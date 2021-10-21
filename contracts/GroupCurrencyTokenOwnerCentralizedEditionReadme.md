# Group Currency Token Centralized Edition Smart Contract

To avoid having to deploy a new version of the `Hub`: `OrgaHub`, there is a version of the GCT and GCTO which can reuse the existing `Hub`. However, these editions are centralized, ie. they require a trusted service which monitors events on the GCTO and trigger events on the GCT and GCTO when these events happen.

## Call Flows for mintTransitive in Centralized Edition

_Note: As there are too many steps necessary for setup & config, `mintTransitive` can only be tested with the Integration Test written in Spring Boot._

### mintTransitive

![flow](https://drive.google.com/uc?export=view&id=1xQVg7NFElpdar_5-lgIcjWzvqSWgFVmJ)

## Tech Walk-Through

### Prerequisites

* Java 11+
* Maven 3+

### Integration Test Execution

* Clone circles-contract-group-currency fork: `git clone git@github.com:ice09/token-paid-services.git`
* Start Hardhat with default mnemonic `test test ... junk`
* Start Spring Boot Integration Test `TokenPaidServicesCentralizedEditionApplicationTests` with `mvn package` or in an IDE with Spring Boot support

