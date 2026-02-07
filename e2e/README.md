# Howdy World E2E

Runs production smoke tests against the full docker-compose stack.

## Run
bin/e2e

## What it checks
- HTTP status for each route
- "Howdy, World!" presence
- H1 presence (and optionally contains Howdy)
- optional metadata contract (JSON in a DOM selector)
- optional screenshots into e2e/artifacts/

## Technology
- Playwright (https://playwright.dev/)
