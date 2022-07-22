# Circles v2
Hey everyone,

we recently found ourselves working around some issues we already brought up in https://aboutcircles.com/t/earth-circle-ip-1-circles-2-0-architecture/428/12 .  
Instead of keep working around these issues with dirty tricks in the client software (which hurts compatibility) we decided to take the step and created a v2 Hub- and Token-contract.

We outline the goals and how we intend to achieve them below and kindly ask for feedback.

## Goals
1) Keep all existing trust relations working
2) Remove the necessity to hold on to own tokens to be able to receive other tokens
3) Allow accounts to use a trust list of a trusted entity to automatically accept tokens listed there (follow trust)
4) Remove the possibility to keep tokens alive from "outside"
5) Have a shorter inflation period
6) Have a well specified upgrade path for future versions

__Organizations__:  
Besides not being a hard goal it turned out that no changes are required for organization wallets.

## Upgrade process
### Exchanging v1- for v2-Tokens
Everyone who holds v1 Tokens can exchange them for v2 Tokens as soon as the token owner migrated to the new version.
To do that, each v1 token holder sends their holdings to the hub v2 contract and then mints the same amount of v2 tokens.
This process should be automated by the client software so that whenever a user upgraded to v2 all holders of tokens of this user will exchange their tokens on the next usage of the client.

### Persons
#### New signup
All new users have to signup at the v1 hub just as they would do now. Additionally, they have to call the v2 hub's "migrate" function.

#### Migration from v1
If a user already got a circles safe and receives UBI then this person needs to deactivate their v1 token before the upgrade.
The client software should make sure that the outstanding UBI is minted a last time before the token is de-activated.
When the token was deactivated the user can call the "migrate" method on the v2 hub and then exchange all of their own tokens.

### Organizations
Since the orga accounts didn't suffer from the receive-limitations in the first place, nothing changed.
However, an organization still can decide to register a Verifier which then has the same effect as on user accounts.

## Implementation
We copied the Hub- and Token.sol contracts and modified them as described below. The new files have the "v2" appendix in their name.
Additionally, we added a new "Verifier" interface which can be used to implement the "follow trust" functionality.

### HubV2.sol
This is a copy of Hub.sol where all parts regarding trust have been removed.
It references the v1 Hub which is used to check trust limits and if a user/orga is already signed up.

We made some changes to existing functions and added some new:

#### checkSendLimit()
This method now treats trust as binary (either you're trusted or you're not).
We also removed the restriction which required users to hold own tokens in order to be able to receive other tokens.  
The effect is that as long as you trust someone that person will be able to send (all) their tokens to you.

Also, we added a way to delegate the send-limit calculation to a different contract.
We use this to implement the "follow trust" which is explained below.

#### useVerifier()
Users can set a custom verifier if they like to do so. Verifiers are external contracts with the same interface as the "checkSendLimit" function (see VerifierI.sol).

The verifier is a fallback that's used when no trust relation exists between the sender and receiver (or the trust was set to zero).
The main use case we intended for it is the "follow trust" functionality where a user can decide to automatically accept all tokens that are accepted by another trusted entity.

#### migrate()
Since all users need to signup at the v1 Hub first they always "migrate" to the new version.  
The method checks if the users' v1 Token is stopped (doesn't mint new UBI) and only then deploys and registers the new token.

#### mint()
Users who hold v1 tokens must have a way to exchange them for v2 tokens. This is what this method is for.  
It uses the same principle as the group tokens but always burns the received v1 tokens.

It's used as following:
1) [if token owner] Mint all outstanding v1 UBI
2) Transfer v1 tokens to the v2 Hub
3) Call mint() to get the same amount of v2 tokens back

__!__ Steps two and three have to be completed in the same transaction otherwise someone else could mint instead of the original owner.

### TokenV2.sol
The v1 token and v2 token are identical except for one additional method on the v2 Token.
Also, only the token owner can call the update-method now to prevent other people from keeping tokens "alive".

#### update()
Same as in the v1 token except that it can now be called only by the token owner.

#### migrateMint()
This method can only be called from the v2 hub.
It is used to mint new v2 tokens for v1 token holders via the HubV2's mint() function.

## Source code
You can find the new contracts here: https://github.com/jaensen/circles-contracts/tree/fork-1  
They're forked from Alex's fork which already includes the GroupCurrency contracts.

New files are:
* [Hubv2.sol](https://github.com/jaensen/circles-contracts/blob/fork-1/contracts/HubV2.sol)
* [Tokenv2.sol](https://github.com/jaensen/circles-contracts/blob/fork-1/contracts/TokenV2.sol)
* [FollowTrustVerifier.sol](https://github.com/jaensen/circles-contracts/blob/fork-1/contracts/FollowTrustVerifier.sol)

as well as the corresponding interfaces:
* [HubV2I.sol](https://github.com/jaensen/circles-contracts/blob/fork-1/contracts/interfaces/HubV2I.sol)
* [VerifierI.sol](https://github.com/jaensen/circles-contracts/blob/fork-1/contracts/interfaces/VerifierI.sol)

## Future updates
We think that future updates can be handled in the same way as this proposed update.