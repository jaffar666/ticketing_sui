#[test_only]
module ticketing::test_laplace_low_participations {
    use sui::test_scenario::{Self as ts, next_tx};
    use sui::test_utils::{assert_eq};
    use sui::coin::{Coin, mint_for_testing};
    use sui::clock::{Clock, Self};
    use sui::sui::{SUI};

    use std::string::{Self};
    use std::debug::print;

    use ticketing::helpers::init_test_helper;
    use ticketing::ticket::{Self, Customer, EventTicket, TicketOrder};

    const TEST_ADDRESS1: address = @0xee;

    #[test]
    public fun test() {
        let mut scenario_test = init_test_helper();
        let scenario = &mut scenario_test;

        // create customer
        next_tx(scenario, TEST_ADDRESS1);
        {
            let name = b"asd";
            let customer = ticket::register_customer(name, ts::ctx(scenario));
            transfer::public_transfer(customer, TEST_ADDRESS1);
        };
        // add balance 
        next_tx(scenario, TEST_ADDRESS1);
        {
            let coin = mint_for_testing<SUI>(10_000_000_000, ts::ctx(scenario));
            let mut customer = ts::take_from_sender<Customer>(scenario);
            ticket::add_balance(&mut customer, coin);

            ts::return_to_sender(scenario, customer);
        };
        // create event ticket
        next_tx(scenario, TEST_ADDRESS1);
        {
            let event_name = b"event1";
            let price: u64 = 1_000_000_000;

            let ticket = ticket::create_event_ticket(event_name, price, ts::ctx(scenario));
            transfer::public_transfer(ticket, TEST_ADDRESS1);
        };

        // place ticket to ticket order
        next_tx(scenario, TEST_ADDRESS1);
        {
            let mut customer = ts::take_from_sender<Customer>(scenario);
            let ticket = ts::take_from_sender<EventTicket>(scenario);
            let discount: u64 = 1_000;
            let total_price: u64 = 1_000_000_000;

            let ticket_order = ticket::place_ticket_order(&mut customer, ticket, discount, total_price, ts::ctx(scenario));
            transfer::public_transfer(ticket_order, TEST_ADDRESS1);

            ts::return_to_sender(scenario, customer);
        };

        // process payment for a ticket
        next_tx(scenario, TEST_ADDRESS1);
        {
            let mut customer = ts::take_from_sender<Customer>(scenario);
            let mut ticket_order = ts::take_from_sender<TicketOrder>(scenario);
            let recipient = TEST_ADDRESS1;

            ticket::process_payment_with_balance(&mut customer, &mut ticket_order, recipient, ts::ctx(scenario));

            assert_eq(ticket::get_customer_loyalty(&customer), 100_000_000);

            ts::return_to_sender(scenario, customer);
            ts::return_to_sender(scenario, ticket_order);
        };


        ts::end(scenario_test);
    }

}