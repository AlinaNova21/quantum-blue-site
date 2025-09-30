#!/bin/bash

# Quantum Blue Documentation Deployment Script
# Builds the MkDocs static site

set -e

echo "Building Quantum Blue documentation..."

# Build the site
mkdocs build --clean

echo "✓ Documentation built successfully to site/ directory"
echo ""
echo "To preview locally, run: mkdocs serve"
echo "The site will be available at http://127.0.0.1:8000"