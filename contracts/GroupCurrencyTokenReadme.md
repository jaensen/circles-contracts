# Group Currency Token Smart Contract

A group currency would define a number of individual Circles tokens directly or transitively (all accounts trusted by account X) as members. All of those members Circles could be used to mint the group currency.

_Note: The GroupCurrencyToken contract is WIP, non-tested, non-audited and not ready for Mainnet/production usage!_

See https://aboutcircles.com/t/suggestion-for-group-currencies/410 for further details.

## Call Flows for mint and mintDelegate

### mint

![flow](https://drive.google.com/uc?export=view&id=1QIYX3UM2HqW8UJGaUIH13SnADnZadb73)

### mintDelegate

![flow](https://drive.google.com/uc?export=view&id=1t2mFhNWxrtlSSyn5TbGAh6-Nz4ds1AkA)

## Tech Walk-Through

The initial drafts uses manual steps to setup, deploy and test the `GroupCurrencyToken` smart contract.

* Clone circles-contract-group-currency fork: `git clone git@github.com:ice09/circles-contracts.git`
* Open Remix-IDE: https://remix.ethereum.org/ 
* Switch to *JavaScript VM (Berlin)* Environment (until London has a working debug mode in Remix-IDE)
* Deploy `Hub.sol` with params `"1","1","CRC","Circles","50000000000000000000","1","1"`
* Call `signup` on Hub contract
	* This will deploy an individual Circles-Token from the Hub contract
* From Event-Logs in Remix, copy "Token" address from "Signup" event 
* Load `Token.sol` at the copied address
	* This is the Circles-Token which will be used as Collateral Token
* Deploy `GroupCurrencyToken.sol` with Hub smart contract address and some name and symbol
* [CollateralToken] `approve` GroupCurrencyToken address (eg. amount 10000000000000000000)

### mint

* [GroupCurrencyToken] `addMember` for Collateral Token address
* [GroupCurrencyToken] `mint` 10000000000000000000 for Collateral token

### mintDelegate 

* [Hub] `signup` with second account
* [Hub] `trust` with second account: firstAccountAddress, 100
* [GroupCurrencyToken] `addDelegateTrustee` with first account: secondAccountAddress
* [GroupCurrencyToken] `mintDelegate` with first account: secondAccountAddress, CollateralToken, 10000