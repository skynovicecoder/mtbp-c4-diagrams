workspace "Movie Ticket Booking Platform (MTBP)" {

    model {
        user = person "End Customer" "Books movie tickets online"
        admin = person "MTBP Admin" "Manages partner onboarding and operations"
        partner = person "Theatre Partner" "Provides theatre and show details to the MTBP via an API or portal"

        okta = softwareSystem "OKTA / OAuth2" "Identity provider for authentication/authorization"
        paymentGateway = softwareSystem "Third-Party Payment Gateway" "Processes payments securely"

        kafkaMQ = softwareSystem "Kafka Messaging Broker" "Event streaming backbone"

        grafana = softwareSystem "Grafana Dashboard" "Visualizes metrics, logs and traces for observability"

        mtbp = softwareSystem "Movie Ticket Booking Platform (MTBP)" "Online platform to book movie tickets" {

        # Containers
        lb = container "Load Balancer" "Nginx / ALB"
        apigw = container "API Gateway" "Spring Cloud Gateway"
        kafka = container "Service for Kafka Messaging" "Kafka using Cloud Streams "

        theatreSvc = container "Theatre Partner Service" "Spring Boot"
        customerSvc = container "Customer Service" "Spring Boot"
        inventorySvc = container "Inventory Management Service" "Spring Boot"
        bookingSvc = container "Booking Service" "Spring Boot"
        paymentSvc = container "Payment Service" "Spring Boot"

        # Databases
        theatreDb = container "Theatre Partner DB" "PostgreSQL"
        customerDb = container "Customer DB" "PostgreSQL"
        inventoryDb = container "Inventory DB" "PostgreSQL"
        bookingDb = container "Booking DB" "PostgreSQL"
        paymentDb = container "Payment DB" "PostgreSQL"

        # Observability Containers
        prometheus = container "Prometheus" "Collects metrics and provides alerting"
        loki = container "Loki" "Collects and indexes logs (via Promtail)"

        # --- Relationships ---
        # User journeys
        user -> lb "Uses to access the platform's features"
        admin -> lb "Manages the platform through an admin portal"
        partner -> lb "Manages theatre data via a partner portal/API"

        # Platform relationships
        lb -> apigw "Routes requests"

        # Authentication flow
        apigw -> okta "Authenticates user/admin/partner via OAuth2"

        # Service to Service communication (via API Gateway)
        apigw -> theatreSvc "Routes theatre data requests"
        apigw -> customerSvc "Routes customer profile requests"
        apigw -> inventorySvc "Routes seat inventory requests"
        apigw -> bookingSvc "Routes booking creation/management requests"
        apigw -> paymentSvc "Routes payment-related requests"

        # Service to Database communication
        theatreSvc -> theatreDb "Reads/Writes theatre and show data"
        customerSvc -> customerDb "Reads/Writes customer profile data"
        inventorySvc -> inventoryDb "Reads/Writes seat inventory data"
        bookingSvc -> bookingDb "Reads/Writes booking details"
        paymentSvc -> paymentDb "Reads/Writes payment transaction data"

        # Inter-service communication via Kafka
        # This is a common pattern for event-driven systems to ensure loose coupling.
        inventorySvc -> kafka "Publishes Inventory Updated/Reserved Events"
        bookingSvc -> kafka "Publishes Booking Created/Cancelled Events"
        paymentSvc -> kafka "Publishes Payment Success/Failure Events"
        bookingSvc -> inventorySvc "Reserves seats via API call or event handling"

        # Third-Party Integration
        paymentSvc -> paymentGateway "Delegates payment processing"

        bookingSvc -> kafkaMQ "Publishes Booking Events"
        kafkaMQ -> bookingSvc "Consumes Booking Events"
        paymentSvc -> kafkaMQ "Publishes Payment Success/Failure Events"
        kafkaMQ -> paymentSvc "Consumes Payment Success/Failure Events"

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
    }

    views {
        systemContext mtbp {
            include *
            autolayout lr
        }

        container mtbp {
            include *
            autolayout lr
        }

        theme default
    }

}
