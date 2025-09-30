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

## Structure

- `docs/` - Markdown documentation files
- `custom_theme/` - Custom theme files (currently unused, using Material theme)
- `mkdocs.yml` - MkDocs configuration