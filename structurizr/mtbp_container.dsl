workspace "MTBP" {

    model {
        # People
        user = person "End Customer" "Books movie tickets online"
        admin = person "MTBP Admin" "Manages theatre partner onboarding and operations"
        partner = person "Theatre Partner" "Provides theatre and show details"

        # External systems
        okta = softwareSystem   "OKTA / OAuth2" "Identity provider for authentication and authorization"
        kafka = softwareSystem "Kafka Messaging Broker" "Event streaming backbone"
        grafana = softwareSystem "Grafana Dashboard" "Visualizes metrics, logs and traces for observability"

        # Main system
        mtbp = softwareSystem "Movie Ticket Booking Platform" "Platform for movie ticket booking" {

            lb = container "Load Balancer" "Distributes incoming traffic (https://www.mtbp.com)" "Nginx/ALB"
            apigw = container "API Gateway" "Handles routing, authentication, and API traffic" "Spring Cloud Gateway"
            theatreSvc = container "Theatre Partner Service" "Handles theatre partner integration" "Spring Boot"
            customerSvc = container "Customer Service" "Manages customers" "Spring Boot"
            inventorySvc = container "Inventory Management Service" "Handles movie inventory and seat availability" "Spring Boot"
            bookingSvc = container "Booking Service" "Handles booking workflow" "Spring Boot"
            paymentSvc = container "Payment Service" "Handles payments" "Spring Boot"

            # Databases
            theatreDb = container "Theatre Partner DB" "Stores theatre info" "PostgreSQL"
            customerDb = container "Customer DB" "Stores customer info" "PostgreSQL"
            inventoryDb = container "Inventory DB" "Stores inventory info" "PostgreSQL"
            bookingDb = container "Booking DB" "Stores booking info" "PostgreSQL"
            paymentDb = container "Payment DB" "Stores payment info" "PostgreSQL"

            # Observability Containers
            prometheus = container "Prometheus" "Collects metrics and provides alerting" "TimeSeriesDB"
            loki = container "Loki" "Collects and indexes logs (via Promtail)" "Loki Logs Collector & Promatail"

            # Relationships inside MTBP
            lb -> apigw "Routes requests"
            apigw -> okta "Authenticates using"
            apigw -> theatreSvc "Routes traffic"
            apigw -> customerSvc "Routes traffic"
            apigw -> inventorySvc "Routes traffic"
            apigw -> bookingSvc "Routes traffic"
            apigw -> paymentSvc "Routes traffic"

            theatreSvc -> theatreDb "Reads/Writes"
            customerSvc -> customerDb "Reads/Writes"
            inventorySvc -> inventoryDb "Reads/Writes"
            bookingSvc -> bookingDb "Reads/Writes"
            paymentSvc -> paymentDb "Reads/Writes"

            inventorySvc -> kafka "Publishes Inventory Events"
            bookingSvc -> kafka "Publishes Booking Events"
            paymentSvc -> kafka "Publishes Payment Events"
            kafka -> bookingSvc "Consumes Booking Events"
            kafka -> paymentSvc "Consumes Payment Events"

            # Observability relationships
            bookingSvc -> prometheus "Exposes metrics"
            paymentSvc -> prometheus "Exposes metrics"
            inventorySvc -> prometheus "Exposes metrics"
            customerSvc -> prometheus "Exposes metrics"
            theatreSvc -> prometheus "Exposes metrics"

            bookingSvc -> loki "Pushes logs via Promtail"
            paymentSvc -> loki "Pushes logs via Promtail"
            inventorySvc -> loki "Pushes logs via Promtail"
            customerSvc -> loki "Pushes logs via Promtail"
            theatreSvc -> loki "Pushes logs via Promtail"

            prometheus -> grafana "Provides metrics"
            loki -> grafana "Provides logs"
        }

        # External relationships
        user -> mtbp "Uses to book movies"
        admin -> mtbp "Manages platform"
        partner -> mtbp "Provides theatre data"
    }

    views {
  
        container mtbp {
            include *
            autolayout lr
        }

        theme default
    }
}
