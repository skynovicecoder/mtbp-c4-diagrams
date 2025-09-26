workspace "Movie Ticket Booking Platform" "C4 Architecture with Postgres + Saga Choreography" {

  model {
    // Actors
    tp = person "Theatre Partner" "Manages theatre inventory and screens"
    ec = person "End Customer" "Books tickets online"
    admin = person "MTBP Admin" "Manages platform operations"

    // System & Containers
    mtbp = softwareSystem "Movie Ticket Booking Platform" "Handles bookings, payments, and theatre management" {

      bookingService = container "Booking Service" "Spring Boot" "Manages ticket bookings and initiates saga"
      inventoryService = container "Inventory Management Service" "Spring Boot" "Manages theatre inventory & seat reservations"
      paymentService = container "Payment Service" "Spring Boot" "Processes payments for bookings"
      customerService = container "Customer Service" "Spring Boot" "Handles customer profiles and booking history"

      dbBooking = container "Booking DB" "PostgreSQL" "Stores booking records"
      dbInventory = container "Inventory DB" "PostgreSQL" "Stores theatre screens, seats, and movie info"
      dbPayment = container "Payment DB" "PostgreSQL" "Stores payment transactions"
      dbCustomer = container "Customer DB" "PostgreSQL" "Stores customer profiles and history"
    }

    // Relationships
    ec -> bookingService "Books tickets"
    tp -> inventoryService "Updates movie & screen availability"
    admin -> mtbp "Manages platform operations"

    bookingService -> dbBooking "Reads/Writes booking info"
    inventoryService -> dbInventory "Reads/Writes inventory info"
    paymentService -> dbPayment "Records payment transactions"
    customerService -> dbCustomer "Reads/Writes customer data"

    // Saga Choreography Events
    bookingService -> inventoryService "BookingCreated event"
    inventoryService -> bookingService "SeatsReserved / BookingFailed event"
    inventoryService -> paymentService "SeatsReserved event"
    paymentService -> bookingService "PaymentCompleted / PaymentFailed event"
    bookingService -> inventoryService "Compensation: release seats on failure"
    bookingService -> paymentService "Compensation: refund payment on failure"
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
