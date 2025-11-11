module sui_counter::sui_counter {

    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::event;
    use sui::clock::{Self, Clock};

    const ENotOwner: u64 = 0;
    const ECounterOverflow: u64 = 1;
    const ENegativeDecrement: u64 = 2;

    const MAX_COUNTER_VALUE: u64 = 1_000_000;

    public struct CounterCreatedEvent has copy, drop {
        owner: address,
        timestamp: u64,
    }

    public struct CounterIncrementedEvent has copy, drop {
        owner: address,
        new_value: u64,
        timestamp: u64,
    }

    public struct CounterDecrementedEvent has copy, drop {
        owner: address,
        new_value: u64,
        timestamp: u64,
    }

    public struct Counter has key, store {
        id: UID,
        owner: address,
        value: u64,
        created_at: u64
    }

    public fun create_counter(clock_ref: &Clock, ctx: &mut TxContext): Counter {
        let owner = tx_context::sender(ctx);
        let timestamp = clock::timestamp_ms(clock_ref);

        event::emit(CounterCreatedEvent { owner, timestamp });

        Counter {
            id: object::new(ctx),
            owner,
            value: 0,
            created_at: timestamp
        }
    }

    public fun increment(c: &mut Counter, clock_ref: &Clock, ctx: &TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(sender == c.owner, ENotOwner);
        assert!(c.value < MAX_COUNTER_VALUE, ECounterOverflow);

        c.value = c.value + 1;

        let timestamp = clock::timestamp_ms(clock_ref);
        event::emit(CounterIncrementedEvent { owner: sender, new_value: c.value, timestamp });
    }

    public fun decrement(c: &mut Counter, clock_ref: &Clock, ctx: &TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(sender == c.owner, ENotOwner);
        assert!(c.value > 0, ENegativeDecrement);

        c.value = c.value - 1;

        let timestamp = clock::timestamp_ms(clock_ref);
        event::emit(CounterDecrementedEvent { owner: sender, new_value: c.value, timestamp });
    }

    public fun get_value(c: &Counter): u64 {
        c.value
    }

}
