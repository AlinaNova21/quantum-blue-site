#!/bin/bash

# Quantum Blue Webhook Setup Script
# Sets up webhook listener for automatic deployments

set -e

# Auto-detect repo directory
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SERVER_DIR="${REPO_DIR}/server"

echo "=== Quantum Blue Webhook Setup ==="
echo "Repository: ${REPO_DIR}"
echo ""

# Generate or prompt for webhook secret
if [ -z "$WEBHOOK_SECRET" ]; then
    echo "Generating webhook secret..."
    WEBHOOK_SECRET=$(openssl rand -hex 32)
    echo "Generated secret: ${WEBHOOK_SECRET}"
else
    echo "Using provided webhook secret"
fi

# Download webhook binary if not present
if [ ! -f "${SERVER_DIR}/webhook" ]; then
    echo ""
    echo "Downloading webhook binary..."
    WEBHOOK_VERSION="2.8.1"
    wget -q "https://github.com/adnanh/webhook/releases/download/${WEBHOOK_VERSION}/webhook-linux-amd64.tar.gz" -O /tmp/webhook.tar.gz
    tar -xzf /tmp/webhook.tar.gz -C /tmp
    mv /tmp/webhook-linux-amd64/webhook "${SERVER_DIR}/webhook"
    chmod +x "${SERVER_DIR}/webhook"
    rm -rf /tmp/webhook.tar.gz /tmp/webhook-linux-amd64
    echo "✓ Webhook binary installed"
fi

# Generate hooks.json from template
echo ""
echo "Generating hooks.json..."
sed -e "s|{{REPO_DIR}}|${REPO_DIR}|g" \
    -e "s|{{DEPLOY_SCRIPT}}|${SERVER_DIR}/deploy.sh|g" \
    -e "s|{{WEBHOOK_SECRET}}|${WEBHOOK_SECRET}|g" \
    "${SERVER_DIR}/hooks.json.template" > "${SERVER_DIR}/hooks.json"
chmod 600 "${SERVER_DIR}/hooks.json"
echo "✓ hooks.json created"

# Generate systemd service from template
echo ""
echo "Generating systemd service..."
sed -e "s|{{REPO_DIR}}|${REPO_DIR}|g" \
    "${SERVER_DIR}/webhook.service.template" > /tmp/quantum-blue-webhook.service
sudo cp /tmp/quantum-blue-webhook.service /etc/systemd/system/quantum-blue-webhook.service
rm /tmp/quantum-blue-webhook.service
echo "✓ Systemd service created"

# Reload systemd and enable service
echo ""
echo "Enabling and starting webhook service..."
sudo systemctl daemon-reload
sudo systemctl enable quantum-blue-webhook.service
sudo systemctl restart quantum-blue-webhook.service
echo "✓ Service started"

# Check service status
sleep 2
if sudo systemctl is-active --quiet quantum-blue-webhook.service; then
    echo "✓ Webhook service is running"
else
    echo "⚠ Warning: Service may not be running. Check with: systemctl status quantum-blue-webhook.service"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Webhook URL: https://quantumblue.gay/webhook/deploy-docs"
echo "Webhook Secret: ${WEBHOOK_SECRET}"
echo ""
echo "Next steps:"
echo "1. Add the Caddyfile configuration from server/Caddyfile.snippet"
echo "2. Reload Caddy: systemctl reload caddy"
echo "3. Add webhook to GitHub repository with the URL and secret above"
echo ""
echo "To view logs: journalctl -u quantum-blue-webhook.service -f"
echo ""