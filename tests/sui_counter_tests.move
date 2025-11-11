#[allow(duplicate_alias, unused_mut_ref)]
#[test_only]
module sui_counter::sui_counter_tests {
    use sui_counter::sui_counter;
    use sui::test_scenario;
    use sui::transfer;

    const EInvalidCounterInit: u64 = 0;
    const EIncrementFailed: u64 = 1;
    const EDecrementFailed: u64 = 2;

    #[test]
    fun test_create_counter() {
        let user = @0x12e4;
        let mut scenario = test_scenario::begin(user);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let c = sui_counter::create_counter_test(ctx);
            assert!(sui_counter::get_value(&c) == 0, EInvalidCounterInit);
            transfer::public_transfer(c, user);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_increment() {
        let user = @0x12e4;
        let mut scenario = test_scenario::begin(user);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let c = sui_counter::create_counter_test(ctx);
            transfer::public_transfer(c, user);
        };

        test_scenario::next_tx(&mut scenario, user);
        {
            let mut c = test_scenario::take_from_sender<sui_counter::Counter>(&mut scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            sui_counter::increment_test(&mut c, ctx);
            assert!(sui_counter::get_value(&c) == 1, EIncrementFailed);
            transfer::public_transfer(c, user);
        };
        test_scenario::end(scenario);
    }

    #[test, expected_failure(abort_code = sui_counter::ENegativeDecrement)]
    fun test_decrement_fail_zero() {
        let user = @0x12e4;
        let mut scenario = test_scenario::begin(user);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let mut c = sui_counter::create_counter_test(ctx);
            sui_counter::decrement_test(&mut c, ctx);
            transfer::public_transfer(c, user);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_decrement_success() {
        let user = @0x12e4;
        let mut scenario = test_scenario::begin(user);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let mut c = sui_counter::create_counter_test(ctx);
            sui_counter::increment_test(&mut c, ctx);
            sui_counter::increment_test(&mut c, ctx);
            assert!(sui_counter::get_value(&c) == 2, EInvalidCounterInit);
            transfer::public_transfer(c, user);
        };

        test_scenario::next_tx(&mut scenario, user);
        {
            let mut c = test_scenario::take_from_sender<sui_counter::Counter>(&mut scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            sui_counter::decrement_test(&mut c, ctx);
            assert!(sui_counter::get_value(&c) == 1, EDecrementFailed);
            transfer::public_transfer(c, user);
        };
        test_scenario::end(scenario);
    }
}
