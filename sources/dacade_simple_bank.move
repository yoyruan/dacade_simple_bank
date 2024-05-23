module yoy::dacade_simple_bank {
    use sui::sui::SUI;
    use sui::vec_map::{Self, VecMap};
    use sui::vec_set::{Self, VecSet};
    use sui::coin::{Self, Coin};
    use sui::balance::Balance;
    use sui::event;
    use sui::tx_context::{Self, TxContext};
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
    public struct AdminCap has key {
        id: UID,
    }
    public struct SimpleBank has key {
        id: UID,
        balances: VecMap<address, Balance<SUI>>,
        registeringUserSet: VecSet<address>,
        registeredUserSet: VecSet<address>,
    }
    public fun get_registering_user_set(simpleBank: &SimpleBank): &VecSet<address> {
        &simpleBank.registeringUserSet
    }
    public fun get_registered_user_set(simpleBank: &SimpleBank): &VecSet<address> {
        &simpleBank.registeredUserSet
    }
    public fun get_balances(simpleBank: &SimpleBank): &VecMap<address, Balance<SUI>> {
        &simpleBank.balances
    }
    public fun get_balance(simpleBank: &SimpleBank, user: address): u64 {
        if (vec_map::contains(&simpleBank.balances, &user)) {
            simpleBank.balances.get(&user).value()
        } else {
            0
        }
    }
    // ===> Events <===
    public struct EventRegister has copy, drop {
        sender: address,
    }
    public struct EventApprove has copy, drop {
        sender: address,
    }
    public struct EventDeposit has copy, drop {
        sender: address,
        amount: u64,
        balance: u64,
    }
    public struct EventWithdraw has copy, drop {
        sender: address,
        amount: u64,
        balance: u64,
    }
    public struct EventTransfer has copy, drop {
        recipient: address,
        amount: u64,
        balance: u64,
    }
    // ===> Functions <===
    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            SimpleBank {
                id: object::new(ctx),
                balances: vec_map::empty(),
                registeringUserSet: vec_set::empty(),
                registeredUserSet: vec_set::empty(),
            }
        );
        transfer::transfer(AdminCap {
            id: object::new(ctx),
        }, tx_context::sender(ctx));
    }
    // Register me in the bank
    public entry fun register(simpleBank: &mut SimpleBank, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        // Check if sender is already registered or registering
        assert!(!simpleBank.registeringUserSet.contains(&sender), EAlreadyRegistering);
        assert!(!simpleBank.registeredUserSet.contains(&sender), EAlreadyRegistered);
        // Add sender to registeringUserSet
        simpleBank.registeringUserSet.insert(sender);
        // Emit EventRegister event
        event::emit(EventRegister { sender });
    }
    // Approve a new user by admin
    public entry fun approve(
        _: &AdminCap,
        simpleBank: &mut SimpleBank,
        users: vector<address>
    ) {
        let users_length = users.length();
        assert!(users_length > 0, EEmptyUsers);
        let mut i = 0_u64;
        while (i < users_length) {
            // User should be in registering list
            assert!(simpleBank.registeringUserSet.contains(&users[i]), ENotExistedRegistering);
            if (!simpleBank.registeredUserSet.contains(&users[i])) {
                simpleBank.registeredUserSet.insert(users[i]);
                event::emit(EventApprove { sender: users[i] });
            }
            simpleBank.registeringUserSet.remove(&users[i]);
            i = i + 1;
        }
    }
    // Deposit coin to the bank
    public entry fun deposit(simpleBank: &mut SimpleBank, amount: &mut Coin<SUI>, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        check_auth(simpleBank, sender);
        assert!(coin::value(amount) > 0, EInvalidAmount);
        let value = coin::value(amount);
        let paid = coin::split(amount, value, ctx);
        let totalBalance;
        if (vec_map::contains(&simpleBank.balances, &sender)) {
            let myBalance = simpleBank.balances.get_mut(&sender);
            totalBalance = myBalance.join(coin::into_balance(paid));
        } else {
            simpleBank.balances.insert(sender, coin::into_balance(paid));
            totalBalance = value;
        }
        event::emit(EventDeposit {
            sender,
            amount: value,
            balance: totalBalance,
        });
    }
    // Withdraw coin from the bank
    public entry fun withdraw(simpleBank: &mut SimpleBank, amount: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        check_auth(simpleBank, sender);
        assert!(amount > 0, EInvalidAmount);
        assert!(vec_map::contains(&simpleBank.balances, &sender), ENotExistedToken);
        let myBalance = simpleBank.balances.get(&sender);
        assert!(myBalance.value() >= amount, EInsufficientBalance);
        let myBalance = simpleBank.balances.get_mut(&sender);
        let withdrawBalance = myBalance.split(amount);
        let takeCoin = coin::from_balance(withdrawBalance, ctx);
        transfer::public_transfer(takeCoin, sender);
        event::emit(EventWithdraw {
            sender,
            amount,
            balance: myBalance.value(),
        });
    }
    // Transfer coin from one user to another
    public entry fun transfer(simpleBank: &mut SimpleBank, amount: u64, recipient: address, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        check_auth(simpleBank, sender);
        assert!(amount > 0, EInvalidAmount);
        assert!(vec_map::contains(&simpleBank.balances, &sender), ENotExistedToken);
        let myBalance = simpleBank.balances.get(&sender);
        assert!(myBalance.value() >= amount, EInsufficientBalance);
        let myBalance = simpleBank.balances.get_mut(&sender);
        let withdrawBalance = myBalance.split(amount);
        let takeCoin = coin::from_balance(withdrawBalance, ctx);
        transfer::public_transfer(takeCoin, recipient);
        event::emit(EventTransfer {
            recipient,
            amount,
            balance: myBalance.value(),
        });
    }
    // Check if the user is registered
    fun check_auth(simpleBank: &SimpleBank, user: address) {
        assert!(simpleBank.registeredUserSet.contains(&user), ENotExistedRegistered);
    }
    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(ctx)
    }
}