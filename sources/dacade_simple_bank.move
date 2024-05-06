module yoy::dacade_simple_bank {
    use std::option::Option;
    use sui::sui::SUI;
    use sui::vec_map::{Self, VecMap};
    use sui::vec_set::{Self, VecSet};
    use sui::coin::{Self, Coin};
    use sui::balance::Balance;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::event;

    // ===> ErrorCodes <===
    const EInvalidAmount: u64 = 1;
    const ENotExistedToken: u64 = 2;
    const EInsufficientBalance: u64 = 3;
    const EAlreadyRegistering: u64 = 4;
    const EAlreadyRegistered: u64 = 5;
    const EEmptyUsers: u64 = 6;
    const ENotExistedRegistering: u64 = 7;
    const ENotExistedRegistered: u64 = 8;

    // ===> Structures <===
    struct AdminCap has key {
        id: UID,
    }

    struct SimpleBank has key {
        id: UID,
        balances: VecMap<address, Balance<SUI>>,
        registeringUserSet: VecSet<address>,
        registeredUserSet: VecSet<address>,
    }

    // ===> Events <===
    struct EventRegister has copy, drop {
        sender: address,
    }

    struct EventApprove has copy, drop {
        sender: address,
    }

    struct EventDeposit has copy, drop {
        sender: address,
        amount: u64,
        balance: u64
    }

    struct EventWithdraw has copy, drop {
        sender: address,
        amount: u64,
        balance: u64
    }

    struct EventTransfer has copy, drop {
        recipient: address,
        amount: u64,
        balance: u64
    }

    // ===> Public Functions <===

    /// Get the registering user set from the SimpleBank
    public fun get_registering_user_set(simpleBank: &SimpleBank): &VecSet<address> {
        &simpleBank.registeringUserSet
    }

    /// Get the registered user set from the SimpleBank
    public fun get_registered_user_set(simpleBank: &SimpleBank): &VecSet<address> {
        &simpleBank.registeredUserSet
    }

    /// Get the balances map from the SimpleBank
    public fun get_balances(simpleBank: &SimpleBank): &VecMap<address, Balance<SUI>> {
        &simpleBank.balances
    }

    /// Initialize the SimpleBank and create an AdminCap
    public entry fun init(ctx: &mut TxContext) {
        transfer::share_object(
            SimpleBank {
                id: object::new(ctx),
                balances: vec_map::empty(),
                registeringUserSet: vec_set::empty(),
                registeredUserSet: vec_set::empty(),
            }
        );

        transfer::transfer(AdminCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx));
    }

    /// Register a new user in the SimpleBank
    public entry fun register(simpleBank: &mut SimpleBank, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        // Check if sender is already registered or registering
        assert!(!simpleBank.registeringUserSet.contains(&sender), EAlreadyRegistering);
        assert!(!simpleBank.registeredUserSet.contains(&sender), EAlreadyRegistered);

        // Add sender to registeringUserSet
        vec_set::insert(&mut simpleBank.registeringUserSet, sender);

        // Emit EventRegister event
        event::emit(EventRegister { sender });
    }

    /// Approve a list of users by the admin
    public entry fun approve(_: &AdminCap, simpleBank: &mut SimpleBank, users: vector<address>) {
        let users_length = vector::length(&users);
        assert!(users_length > 0, EEmptyUsers);

        let i = 0;
        while (i < users_length) {
            let user = vector::borrow(&users, i);

            // User should be in the registering list
            assert!(vec_set::contains(&simpleBank.registeringUserSet, user), ENotExistedRegistering);

            if (!vec_set::contains(&simpleBank.registeredUserSet, user)) {
                vec_set::insert(&mut simpleBank.registeredUserSet, *user);
                event::emit(EventApprove { sender: *user });
            };

            vec_set::remove(&mut simpleBank.registeringUserSet, user);

            i = i + 1;
        };
    }

    /// Deposit coins to the SimpleBank
    public entry fun deposit(simpleBank: &mut SimpleBank, amount: &mut Coin<SUI>, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        check_auth(simpleBank, sender);

        assert!(coin::value(amount) > 0, EInvalidAmount);

        let value = coin::value(amount);
        let paid = coin::split(amount, value, ctx);

        let totalBalance;

        if (vec_map::contains(&simpleBank.balances, &sender)) {
            let myBalance = vec_map::get_mut(&mut simpleBank.balances, &sender);
            totalBalance = balance::join(myBalance, coin::into_balance(paid));
        } else {
            vec_map::insert(&mut simpleBank.balances, sender, coin::into_balance(paid));
            totalBalance = value;
        };

        event::emit(EventDeposit {
            sender,
            amount: value,
            balance: totalBalance
        });
    }

    /// Withdraw coins from the SimpleBank
    public entry fun withdraw(simpleBank: &mut SimpleBank, amount: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        check_auth(simpleBank, sender);

        assert!(amount > 0, EInvalidAmount);

        assert!(vec_map::contains(&simpleBank.balances, &sender), ENotExistedToken);

        let myBalance = vec_map::get(&simpleBank.balances, &sender);
        assert!(balance::value(myBalance) >= amount, EInsufficientBalance);

        let myBalance = vec_map::get_mut(&mut simpleBank.balances, &sender);
        let withdrawBalance = balance::split(myBalance, amount);

        let takeCoin = coin::from_balance(withdrawBalance, ctx);
        transfer::public_transfer(takeCoin, sender);

        event::emit(EventWithdraw {
            sender,
            amount,
            balance: balance::value(myBalance)
        });
    }

    /// Transfer coins from the sender's account to a recipient
    public entry fun transfer(simpleBank: &mut SimpleBank, amount: u64, recipient: address, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        check_auth(simpleBank, sender);

        assert!(amount > 0, EInvalidAmount);

        assert!(vec_map::contains(&simpleBank.balances, &sender), ENotExistedToken);

        let myBalance = vec_map::get(&simpleBank.balances, &sender);
        assert!(balance::value(myBalance) >= amount, EInsufficientBalance);

        let myBalance = vec_map::get_mut(&mut simpleBank.balances, &sender);
        let withdrawBalance = balance::split(myBalance, amount);

        let takeCoin = coin::from_balance(withdrawBalance, ctx);
        transfer::public_transfer(takeCoin, recipient);

        event::emit(EventTransfer {
            recipient,
            amount,
            balance: balance::value(myBalance)
        });
    }

    /// Check if a user is authorized (registered)
   fun check_auth(simpleBank: &SimpleBank, user: address) {
    assert!(vec_set::contains(&simpleBank.registeredUserSet, &user), ENotExistedRegistered);
    }

    // ===> Admin Functions <===

    /// Get the balance of a registered user
    public fun get_user_balance(simpleBank: &SimpleBank, user: address): Option<u64> {
        if (vec_set::contains(&simpleBank.registeredUserSet, &user) &&
            vec_map::contains(&simpleBank.balances, &user)) {
            let balance = vec_map::get(&simpleBank.balances, &user);
            some(balance::value(balance))
        } else {
            none()
        }
    }

    /// Get the total balance of the SimpleBank
    public fun get_total_balance(simpleBank: &SimpleBank): u64 {
        let total = 0;
        let iter = vec_map::iter(&simpleBank.balances);
        loop {
            let (_, balance) = vec_map::next(&mut iter);
            if (balance == vec_map::end(&simpleBank.balances)) break;
            total = total + balance::value(balance);
        }
        total
    }
}
    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(ctx)
    }