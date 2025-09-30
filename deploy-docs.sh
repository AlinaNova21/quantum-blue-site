#!/bin/bash

# Quantum Blue Documentation Deployment Script
# Builds and optionally deploys the MkDocs static site

set -e

DEPLOY_HOST="root@ovh-ss14"
DEPLOY_PATH="/srv/ss14/static/site"

echo "Building Quantum Blue documentation..."

# Build the site
mkdocs build --clean

echo "✓ Documentation built successfully to site/ directory"

# Check if --deploy flag is passed
if [[ "$1" == "--deploy" ]]; then
    echo ""
    echo "Deploying to ${DEPLOY_HOST}:${DEPLOY_PATH}..."

    rsync -avzr --delete site/ "${DEPLOY_HOST}:${DEPLOY_PATH}/"

    echo "✓ Deployed successfully!"
else
    echo ""
    echo "To preview locally, run: mkdocs serve"
    echo "To deploy to server, run: ./deploy-docs.sh --deploy"
fi