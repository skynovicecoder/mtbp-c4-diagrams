```markdown
# MTBP C4 Architecture

This repository contains the **C4 architecture diagrams** for the Movie Ticket Booking Platform (MTBP).

- Actors: End Customers, Theatre Partners, MTBP Admin
- Services: Booking, Inventory, Payment, Customer Service
- Databases: PostgreSQL for all services
- Saga Choreography pattern for distributed transactions

Use `structurizr/workspace.dsl` as the main DSL file.  
Generated diagrams are in `output/`.  
Local generation is available via `scripts/run-local-cli.sh`.  
CI/CD auto-generation via GitHub Actions.