// SPDX-License-Identifier: AGPL
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./GroupCurrencyToken.sol";
import "./Hub.sol";

contract GroupCurrencyTokenOwner {
    using SafeMath for uint256;

    address public token; // the safe/EOA/contract that deployed this token, can be changed by owner
    address public hub; // the address of the hub this token is associated with
    address public owner; 
    
    event Minted(address indexed receiver, address indexed collateral, uint256 amount);

    /// @dev modifier allowing function to be only called by the token owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _hub, address _token, address _owner) {
        owner = _owner;
        hub = _hub;
        token = _token;
    }
    
    function setup() public onlyOwner {
       Hub(hub).organizationSignup();
       GroupCurrencyToken(token).addDelegatedTrustee(address(this));
    }
    
    function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
    }
    
    // Group currently is created from collateral tokens. Collateral is directly part of the directMembers dictionary.
    function mintTransitive(address[] memory tokenOwners, address[] memory srcs, address[] memory dests, uint[] memory wads) public {
        Hub(hub).transferThrough(tokenOwners, srcs, dests, wads);
        uint lastElementIndex = tokenOwners.length-1;
        GroupCurrencyToken(token).mintDelegate(address(this), HubI(hub).userToToken(tokenOwners[lastElementIndex]), wads[lastElementIndex]);
    }
        
    // Trust must be called by this contract (as a delegate) on Hub
    function trust(address _trustee) public onlyOwner {
        Hub(hub).trust(_trustee, 100);
    }
    
}
