# Quantum Blue Server Documentation

MkDocs-based documentation site for Quantum Blue server rules and Standard Operating Procedures.

## Setup

Install dependencies:

```bash
pip install -r requirements.txt
```

## Development

Run the development server:

```bash
mkdocs serve
```

The site will be available at http://127.0.0.1:8000/

## Build

Build the static site:

```bash
./deploy-docs.sh
```

or

```bash
mkdocs build
```

The built site will be in the `site/` directory.

## Production Deployment

The site is automatically deployed to https://quantumblue.gay via GitHub webhooks.

### Server Setup (One-time)

On the production server (requires root access):

1. Clone the repository:
```bash
cd /srv
git clone https://github.com/AlinaNova21/quantum-blue-site.git quantum-blue-site
cd quantum-blue-site
```

2. Install dependencies:
```bash
pip3 install -r requirements.txt
```

3. Run the webhook setup script:
```bash
sudo ./server/setup-webhook.sh
```

This will:
- Download and install the webhook binary
- Generate a webhook secret
- Create and enable the systemd service
- Display the webhook URL and secret

4. Add the Caddy configuration from `server/Caddyfile.snippet` to your main Caddyfile

5. Reload Caddy:
```bash
sudo systemctl reload caddy
```

6. Configure the GitHub webhook (URL and secret will be displayed by setup script)

### Manual Deployment

To manually deploy on the server:

```bash
./deploy-docs.sh --deploy
```

Or trigger remotely by pushing to the `main` branch.

## Structure

- `docs/` - Markdown documentation files
- `server/` - Deployment scripts and webhook configuration
- `custom_theme/` - Custom theme files (currently unused, using Material theme)
- `mkdocs.yml` - MkDocs configuration