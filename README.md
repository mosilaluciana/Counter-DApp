# Counter-DApp

## Build & Test Instructions

### Build the contract
`sui move build`

### Run tests
`sui move test`

All tests should pass successfully:
[ PASS ] sui_counter::sui_counter_tests::test_create_counter
[ PASS ] sui_counter::sui_counter_tests::test_increment
[ PASS ] sui_counter::sui_counter_tests::test_decrement_success
[ PASS ] sui_counter::sui_counter_tests::test_decrement_fail_zero

### Deploy to Testnet
`sui client publish --gas-budget 100000000`
After publishing, you will receive your Package ID and Transaction Hash.


## Brief Explanation of Implementation

The sui_counter module defines a simple on-chain counter that each user can create and control individually.
Every counter is stored as a Sui object with the key ability, so it can be owned, stored, and updated directly on the blockchain.

The main structure, Counter, includes:
  - a unique UID
  - the owner’s address
  - the current counter value
  - and the creation timestamp

The module contains a few main functions that cover all core operations:
  - create_counter – creates a new counter with an initial value of 0 and records who created it. It also emits an event when the counter is created.
  - increment – adds 1 to the counter value, only if the caller is the owner and the maximum limit hasn’t been reached.
  - decrement – subtracts 1 from the counter, with checks that prevent negative values or actions from non-owners.
  - get_value – returns the current stored value.

The module also defines events for creation, increment, and decrement actions, so all updates can be tracked on-chain.
Basic error codes are used to handle invalid cases like unauthorized access or overflow.
Overall, the implementation is straightforward — it uses Move’s ownership rules and event system to keep everything transparent and secure.
