# Group Currency Token Smart Contract

A group currency would define a number of individual Circles tokens directly or transitively (all accounts trusted by account X) as members. All of those members Circles could be used to mint the group currency.

_Note: The GroupCurrencyToken and GroupCurrencyTokenOwner contracts are WIP, non-tested, non-audited and not ready for Mainnet/production usage!_

See https://aboutcircles.com/t/suggestion-for-group-currencies/410 for further details.

## Call Flows for mintTransitive

_Note: As there are too many steps necessary for setup & config, `mintTransitive` can only be tested with the Integration Test written in Spring Boot._

### mintTransitive

![flow](https://drive.google.com/uc?export=view&id=15Mas10wGK6JsEMpPxWS0RxOPZypWvqPO)

## Tech Walk-Through

### Prerequisites

* Java 11+
* Maven 3+

### Integration Test Execution

* Clone circles-contract-group-currency fork: `git clone git@github.com:ice09/token-paid-services.git`
* Start Hardhat with default mnemonic `test test ... junk`
* Start Spring Boot Integration Test `TokenPaidServicesApplicationTests` with `mvn package` or in an IDE with Spring Boot support

