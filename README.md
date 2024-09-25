# Ticketing Module README

## Overview

The Ticketing Module is designed to facilitate the management of event ticket sales, customer accounts, and payment processing. It enables users to register as customers, manage their balances and loyalty points, create event tickets, place orders, and process payments through various methods.

## Features

- **Customer Management**: Register customers and manage their balances and loyalty points.
- **Event Ticket Creation**: Create event tickets with specific details like name and price.
- **Ticket Orders**: Place orders for multiple tickets, track order details, and manage payment statuses.
- **Payment Processing**: Support for payments using balance, loyalty points, and partial payments.
- **Discounts**: Apply discounts to ticket orders.

## Structures

### Customer

```rust
struct Customer {
    id: UID,
    name: vector<u8>,
    balance: Balance<SUI>,
    loyalty_points: u64,
}
```

### EventTicket

```rust
struct EventTicket {
    id: UID,
    event_name: vector<u8>,
    price: u64,
}
```

### TicketOrder

```rust
struct TicketOrder {
    id: UID,
    customer: ID,
    tickets: vector<EventTicket>,
    total_price: u64,
    is_paid: bool,
    discount: u64,
}
```

## Functions

### 1. Customer Management

- **`register_customer(name: vector<u8>, ctx: &mut TxContext) -> Customer`**: Registers a new customer and returns their details.
  
- **`get_customer_details(customer: &Customer) -> (vector<u8>, &Balance<SUI>, u64)`**: Retrieves customer details.

- **`add_balance(customer: &mut Customer, amount: Coin<SUI>)`**: Adds balance to the customer's account.

- **`add_loyalty_points(customer: &mut Customer, points: u64)`**: Adds loyalty points to the customer's account.

### 2. Event Ticket Management

- **`create_event_ticket(event_name: vector<u8>, price: u64, ctx: &mut TxContext) -> EventTicket`**: Creates a new event ticket.

### 3. Ticket Order Management

- **`place_ticket_order(customer: &mut Customer, tickets: vector<EventTicket>, discount: u64, total_price: u64, ctx: &mut TxContext) -> TicketOrder`**: Places a new ticket order.

- **`get_ticket_order_details(order: &TicketOrder) -> (&ID, &vector<EventTicket>, u64, bool, u64)`**: Retrieves ticket order details.

### 4. Payment Processing

- **`process_payment_with_balance(customer: &mut Customer, order: &mut TicketOrder, recipient: address, ctx: &mut TxContext)`**: Processes payment for a ticket order using the customer’s balance.

- **`process_payment_with_loyalty_points(customer: &mut Customer, order: &mut TicketOrder, recipient: address, ctx: &mut TxContext)`**: Processes payment using the customer's loyalty points.

- **`apply_discount(order: &mut TicketOrder, discount: u64)`**: Applies a discount to the ticket order.

- **`process_partial_payment(customer: &mut Customer, order: &mut TicketOrder, recipient: address, ctx: &mut TxContext, amount: u64)`**: Handles partial payments for ticket orders.

## Error Codes

- **`ERR_INSUFFICIENT_BALANCE`**: Error code for insufficient balance during payment.
- **`ERR_TICKET_ALREADY_PAID`**: Error code for attempting to pay for an already paid ticket order.

## Usage Example

1. **Register a Customer**:
   ```rust
   let new_customer = register_customer(b"John Doe", ctx);
   ```

2. **Create an Event Ticket**:
   ```rust
   let ticket = create_event_ticket(b"Concert", 100, ctx);
   ```

3. **Place a Ticket Order**:
   ```rust
   let order = place_ticket_order(&mut new_customer, vec![ticket], 10, 90, ctx);
   ```

4. **Process Payment**:
   ```rust
   process_payment_with_balance(&mut new_customer, &mut order, recipient_address, ctx);
   ```

## Conclusion

This Ticketing Module provides a comprehensive solution for managing event tickets, customer accounts, and payment processes. By leveraging its features, developers can create robust ticketing systems suitable for various events.
# ticketing_sui
