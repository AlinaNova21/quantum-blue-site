#!/bin/bash

# Quantum Blue Documentation Deployment Script
# Triggered by GitHub webhook

set -e

# Auto-detect repo directory (script is in server/ subdirectory)
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="${REPO_DIR}/server/deploy.log"

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== Starting deployment ==="
log "Repository: ${REPO_DIR}"

# Navigate to repo directory
cd "${REPO_DIR}"

# Pull latest changes
log "Pulling latest changes from git..."
git pull origin main 2>&1 | tee -a "$LOG_FILE"

# Build documentation (output goes to site/ directory)
log "Building documentation with mkdocs..."
mkdocs build --clean 2>&1 | tee -a "$LOG_FILE"

log "=== Deployment completed successfully ==="
log "Site built at: ${REPO_DIR}/site/"
log ""