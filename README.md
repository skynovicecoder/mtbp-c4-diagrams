# MTBP C4 Architecture

This repository contains the **C4 architecture diagrams** for the Movie Ticket Booking Platform (MTBP).

## Overview

- **Actors:** End Customers, Theatre Partners, MTBP Admin  
- **Services:** Booking, Inventory, Payment, Customer Service  
- **Databases:** PostgreSQL for all services  
- **Patterns:** Saga Choreography for distributed transactions  

## DSL and Diagram Generation

- Use `structurizr/workspace.dsl` as the main DSL file.  
- Generated diagrams are placed in the `output/` directory.  

### Local Generation

Run the CLI locally using:

```bash
scripts/run-local-cli.sh


## Viewing Structurizr Diagrams

The workflow automatically generates architecture diagrams for each DSL file in this repository.  

**How to view the diagrams:**

1. Open the **Pull Request** associated with your changes.  
2. Click on the **Actions** tab or go to the workflow run for this PR.  
3. Find the **"Generate Structurizr Diagrams"** workflow run.  
4. Download the generated diagrams from the **Artifacts** section.  

> Note: The diagrams are not directly embedded in the PR comment. They are available as downloadable artifacts for review.