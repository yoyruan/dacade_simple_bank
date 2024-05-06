# Dacade Simple Bank by YOY

## Description

A simple banking system with features including:

- user registration
- admin approval
- user deposit
- user withdrawal
- uer transfer.

## Functions

### 1 register

```rust
    public entry fun register (
        simpleBank: &mut SimpleBank,
        ctx: &mut TxContext)
```

### 2 approve

```rust
    public entry fun approve (
        _: &AdminCap,
        simpleBank: &mut SimpleBank,
        users: vector<address>)
```

### 3 deposit

```rust
    public entry fun deposit (
        simpleBank: &mut SimpleBank,
        amount: &mut Coin<SUI>,
        ctx: &mut TxContext)
```

### 4 withdraw

```rust
    public entry fun withdraw (
        simpleBank: &mut SimpleBank,
        amount: u64,
        ctx: &mut TxContext)
```

### 5 transfer

```rust
    public entry fun transfer (
        simpleBank: &mut SimpleBank,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext)
```

## UNITTEST

```bash
$ sui --version
sui 1.25.0-c1dfdcdb3d8a

$ sui move test
Running Move unit tests
[ PASS    ] 0x0::dacade_simple_bank_tests::test_simple_bank
Test result: OK. Total tests: 1; passed: 1; failed: 0
```

## Deployment

### 1 publish

```bash
sui client publish --gas-budget 100000000
```

- **Created Objects**

```bash
│  ┌──                                                                                                               │
│  │ ObjectID: 0x16f82f6d3b8e032e0d746e5473870205f8ce3dec30a7a859535596e2d05f2863                                    │
│  │ Sender: 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b                                      │
│  │ Owner: Shared                                                                                                   │
│  │ ObjectType: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb::dacade_simple_bank::SimpleBank  │
│  │ Version: 863475                                                                                                 │
│  │ Digest: vdLkF8EcygFoPA5EzxiTwud1F5LxR16q3xC8NASCjga                                                             │
│  └──                                                                                                               │
│  ┌──                                                                                                               │
│  │ ObjectID: 0xaaf46ea03a9db22831cc062c10012e8f36680f56ce2e69340eb681e6340262bc                                    │
│  │ Sender: 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b                                      │
│  │ Owner: Account Address ( 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b )                   │
│  │ ObjectType: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb::dacade_simple_bank::AdminCap    │
│  │ Version: 863475                                                                                                 │
│  │ Digest: CDjV1GX3uxcszAbFnHDuj3JtYgCXB4DJ7unK9HeJuHtk                                                            │
│  └──                                                                                                               │

export SIMPLE_BANK=0x16f82f6d3b8e032e0d746e5473870205f8ce3dec30a7a859535596e2d05f2863
export ADMIN_CAP=0xaaf46ea03a9db22831cc062c10012e8f36680f56ce2e69340eb681e6340262bc
```

- **Published Objects**

```bash
│  ┌──                                                                             │
│  │ PackageID: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb │
│  │ Version: 1                                                                    │
│  │ Digest: 5ea286Tak4wnXSA5XhVDJ8LAs8ZkxKmJerNdoNoZHoei                          │
│  │ Modules: dacade_simple_bank                                                   │
│  └──                                                                             │

export PACKAGE_ID=0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb
```

### 2 register

```bash
sui client call --package $PACKAGE_ID --module dacade_simple_bank --function register --args $SIMPLE_BANK --gas-budget 100000000

╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                            │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                                │
│  │ EventID: 4ECEfnopZPF4SADyxQmTHDpxhR373Gj7DuLd3YmxEDBU:0                                                          │
│  │ PackageID: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb                                    │
│  │ Transaction Module: dacade_simple_bank                                                                           │
│  │ Sender: 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b                                       │
│  │ EventType: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb::dacade_simple_bank::EventRegister │
│  │ ParsedJSON:                                                                                                      │
│  │   ┌────────┬────────────────────────────────────────────────────────────────────┐                                │
│  │   │ sender │ 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b │                                │
│  │   └────────┴────────────────────────────────────────────────────────────────────┘                                │
│  └──                                                                                                                │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

### 3 approve

```bash
sui client call --package $PACKAGE_ID --module dacade_simple_bank --function approve --args $ADMIN_CAP $SIMPLE_BANK "[\"0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b\"]" --gas-budget 100000000

╭────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                           │
├────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                               │
│  │ EventID: Au8hKbCEsXxzn7HRYs9c2J7j48jdRy9jPxrq7ALoSuUa:0                                                         │
│  │ PackageID: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb                                   │
│  │ Transaction Module: dacade_simple_bank                                                                          │
│  │ Sender: 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b                                      │
│  │ EventType: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb::dacade_simple_bank::EventApprove │
│  │ ParsedJSON:                                                                                                     │
│  │   ┌────────┬────────────────────────────────────────────────────────────────────┐                               │
│  │   │ sender │ 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b │                               │
│  │   └────────┴────────────────────────────────────────────────────────────────────┘                               │
│  └──                                                                                                               │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

### 4 deposit

```bash
export COIN=0x56f40e41fb886e4f95968f8c3e0a6ab503c0e2ccd7e73cce82cfe82c808d3dd7
sui client call --package $PACKAGE_ID --module dacade_simple_bank --function deposit --args $SIMPLE_BANK $COIN --gas-budget 100000000

╭────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                           │
├────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                               │
│  │ EventID: CbyoW5MsHeLuv4L6Go3uSnRPNrih2smcxbqDoRpnK5CE:0                                                         │
│  │ PackageID: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb                                   │
│  │ Transaction Module: dacade_simple_bank                                                                          │
│  │ Sender: 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b                                      │
│  │ EventType: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb::dacade_simple_bank::EventDeposit │
│  │ ParsedJSON:                                                                                                     │
│  │   ┌─────────┬────────────────────────────────────────────────────────────────────┐                              │
│  │   │ amount  │ 1000000000                                                         │                              │
│  │   ├─────────┼────────────────────────────────────────────────────────────────────┤                              │
│  │   │ balance │ 1000000000                                                         │                              │
│  │   ├─────────┼────────────────────────────────────────────────────────────────────┤                              │
│  │   │ sender  │ 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b │                              │
│  │   └─────────┴────────────────────────────────────────────────────────────────────┘                              │
│  └──                                                                                                               │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

### 5 withdraw

```bash
sui client call --package $PACKAGE_ID --module dacade_simple_bank --function withdraw --args $SIMPLE_BANK 200000000 --gas-budget 100000000

╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                            │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                                │
│  │ EventID: CWUrV2zSgkZWJW2KtF24XnVxbhj19PH6BdchRMYFbQ2Y:0                                                          │
│  │ PackageID: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb                                    │
│  │ Transaction Module: dacade_simple_bank                                                                           │
│  │ Sender: 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b                                       │
│  │ EventType: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb::dacade_simple_bank::EventWithdraw │
│  │ ParsedJSON:                                                                                                      │
│  │   ┌─────────┬────────────────────────────────────────────────────────────────────┐                               │
│  │   │ amount  │ 200000000                                                          │                               │
│  │   ├─────────┼────────────────────────────────────────────────────────────────────┤                               │
│  │   │ balance │ 800000000                                                          │                               │
│  │   ├─────────┼────────────────────────────────────────────────────────────────────┤                               │
│  │   │ sender  │ 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b │                               │
│  │   └─────────┴────────────────────────────────────────────────────────────────────┘                               │
│  └──                                                                                                                │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

### 6 transfer

```bash
export BOB=0x2aa7b7d582a873c71d661392401792ff9354ad0b484d35863b5eb0f96c211bab
sui client call --package $PACKAGE_ID --module dacade_simple_bank --function transfer --args $SIMPLE_BANK 500000000 $BOB --gas-budget 100000000

╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                            │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                                │
│  │ EventID: 5BJBWEwK1xugKck7Zo4LD33ogELKa7narnRkV9Y2jUut:0                                                          │
│  │ PackageID: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb                                    │
│  │ Transaction Module: dacade_simple_bank                                                                           │
│  │ Sender: 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b                                       │
│  │ EventType: 0xb4e8d5efec64ce16119d48bcea42a33cf8e63e9e5023a161be1959ebc27e9bfb::dacade_simple_bank::EventTransfer │
│  │ ParsedJSON:                                                                                                      │
│  │   ┌───────────┬────────────────────────────────────────────────────────────────────┐                             │
│  │   │ amount    │ 500000000                                                          │                             │
│  │   ├───────────┼────────────────────────────────────────────────────────────────────┤                             │
│  │   │ balance   │ 300000000                                                          │                             │
│  │   ├───────────┼────────────────────────────────────────────────────────────────────┤                             │
│  │   │ recipient │ 0x2aa7b7d582a873c71d661392401792ff9354ad0b484d35863b5eb0f96c211bab │                             │
│  │   └───────────┴────────────────────────────────────────────────────────────────────┘                             │
│  └──                                                                                                                │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

│ Created Objects:                                                                                                   │
│  ┌──                                                                                                               │
│  │ ObjectID: 0x38c2493041baa744d99879f1d0cd4050aabd24ef552fba2fd1443d1e297b5c76                                    │
│  │ Sender: 0xebc0937a2afdffcd80c0f0f3a61854b8669bbb8356b602fa29e5c688818b336b                                      │
│  │ Owner: Account Address ( 0x2aa7b7d582a873c71d661392401792ff9354ad0b484d35863b5eb0f96c211bab )                   │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                                      │
│  │ Version: 863481                                                                                                 │
│  │ Digest: G63q26dy3wX7vYLZjVmVfQRLFQ6KNth194BZQzBr2MQ5                                                            │
│  └──                                                                                                               │
```
