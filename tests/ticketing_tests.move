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

        next_tx(scenario, TEST_ADDRESS1);
        {
            let coin = mint_for_testing<SUI>(10_000_000_000, ts::ctx(scenario));
            let mut customer = ts::take_from_sender<Customer>(scenario);
            ticket::add_balance(&mut customer, coin);

            ts::return_to_sender(scenario, customer);

        };


        ts::end(scenario_test);
    }

}