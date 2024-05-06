// #[test_only]
// module yoy::dacade_simple_bank_tests {
//     use sui::sui::SUI;
//     use sui::coin::{Self, Coin};

//     use yoy::dacade_simple_bank::{Self, SimpleBank, AdminCap};

//     #[test_only]
//     use sui::test_scenario;
//     #[test_only]
//     use sui::test_utils::assert_eq;

//     #[test]
//     fun test_simple_bank() {
//         let admin = @0x1;
//         let alice = @0xa;
//         let bob = @0xb;

//         let mut scenario_val = test_scenario::begin(admin);
//         let mut scenario = &mut scenario_val;

//         // ====================
//         //  init
//         // ====================
//         {
//             dacade_simple_bank::test_init(test_scenario::ctx(scenario));
//         };


//         // ====================
//         //  register alice
//         // ====================
//         test_scenario::next_tx(scenario, alice);
//         {
//             let mut simpleBank = test_scenario::take_shared<SimpleBank>(scenario);

//             dacade_simple_bank::register(
//                 &mut simpleBank, 
//                 test_scenario::ctx(scenario)
//             );

//             assert_eq(dacade_simple_bank::get_registering_user_set(&simpleBank).size(), 1);

//             test_scenario::return_shared(simpleBank);
//         };

//         // ====================
//         //  register bob
//         // ====================
//         test_scenario::next_tx(scenario, bob);
//         {
//             let mut simpleBank = test_scenario::take_shared<SimpleBank>(scenario);

//             dacade_simple_bank::register(
//                 &mut simpleBank, 
//                 test_scenario::ctx(scenario)
//             );

//             assert_eq(dacade_simple_bank::get_registering_user_set(&simpleBank).size(), 2);

//             test_scenario::return_shared(simpleBank);
//         };

//         // ====================
//         //  admin approve alice
//         // ====================
//         test_scenario::next_tx(scenario, admin);
//         {
//             let mut simpleBank = test_scenario::take_shared<SimpleBank>(scenario);
//             let admin_cap = test_scenario:: take_from_sender<AdminCap>(scenario);

//             let mut users = vector::empty();
//             users.push_back(alice);

//             dacade_simple_bank::approve(
//                 &admin_cap, 
//                 &mut simpleBank, 
//                 users, 
//             );

//             assert_eq(dacade_simple_bank::get_registering_user_set(&simpleBank).size(), 1);
//             assert_eq(dacade_simple_bank::get_registered_user_set(&simpleBank).size(), 1);

//             test_scenario::return_shared(simpleBank);
//             test_scenario::return_to_sender(scenario, admin_cap);
//         };

//         // ====================
//         //  alice deposit
//         // ====================
//         test_scenario::next_tx(scenario, alice);
//         {
//             let mut simpleBank = test_scenario::take_shared<SimpleBank>(scenario);

//             let mut payment_coin = coin::mint_for_testing<SUI>(1000, test_scenario::ctx(scenario));

//             dacade_simple_bank::deposit(
//                 &mut simpleBank, 
//                 &mut payment_coin,
//                 test_scenario::ctx(scenario)
//             );

//             let balances = dacade_simple_bank::get_balances(&simpleBank);

//             assert_eq(balances.contains(&alice), true);
//             assert_eq(balances.get(&alice).value(), 1000);

//             coin::burn_for_testing(payment_coin);
//             test_scenario::return_shared(simpleBank);
//         };

//         // ====================
//         //  alice withdraw
//         // ====================
//         test_scenario::next_tx(scenario, alice);
//         {
//             let mut simpleBank = test_scenario::take_shared<SimpleBank>(scenario);

//             dacade_simple_bank::withdraw(
//                 &mut simpleBank, 
//                 800,
//                 test_scenario::ctx(scenario)
//             );

//             let balances = dacade_simple_bank::get_balances(&simpleBank);

//             assert_eq(balances.contains(&alice), true);
//             assert_eq(balances.get(&alice).value(), 200);

//             test_scenario::return_shared(simpleBank);
//         };

//         test_scenario::end(scenario_val);
//     }
// }