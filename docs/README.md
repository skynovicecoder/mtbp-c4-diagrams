# MTBP C4 Diagrams Repo

This repository contains **C4 architecture diagrams** for the Movie Ticket Booking Platform (MTBP) using **Structurizr DSL**.

## Folder Structure

- `structurizr/` → Source `.dsl` files for all services and containers.
- `output/` → Generated diagrams (PNG/SVG) from CLI or CI.
- `.github/workflows/` → GitHub Actions workflow to auto-generate diagrams.
- `scripts/` → Helper scripts (e.g., `run-local-cli.sh` to run CLI locally). Note: First run: chmod +x scripts/run-local-cli.sh
Note: To run local Alternative: Install Plugins in Visula Studio: C4 DSL Extension, PlantUML, Mermaid
In settings of C4 DSL Extension, select one of the above and enable it and choose render options too.
- `docs/` → Documentation.

## How to Generate Diagrams Locally

```bash
./scripts/run-local-cli.sh
