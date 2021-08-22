// SPDX-License-Identifier: AGPL
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ERC20.sol";
import "./interfaces/HubI.sol";

contract GroupCurrencyToken is ERC20 {
    using SafeMath for uint256;

    uint8 public immutable override decimals = 18;
    uint8 public immutable mintFeePerThousand = 1;
    
    string public name;
    string public override symbol;

    address public immutable owner; // the safe/EOA/contract that deployed this token
    address public hub; // the address of the hub this token is associated with

    mapping (address => bool) public directMembers;
    mapping (address => bool) public delegatedTrustees;
    
    event Minted(address indexed receiver, uint256 amount, uint256 mintAmount, uint256 mintFee);

    /// @dev modifier allowing function to be only called through the hub
    modifier onlyHub() {
        require(msg.sender == hub);
        _;
    }

    /// @dev modifier allowing function to be only called by the token owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // TODO: How is the owner set, who is deploying the contract? Should it be msg.sender or a parameter?
    constructor(address _hub, string memory _name, string memory _symbol) {
        symbol = _symbol;
        name = _name;
        owner = msg.sender;
        hub = _hub;
    }
    
    function addMember(address _member) public onlyOwner {
        directMembers[_member] = true;
    }

    function removeMember(address _member) public onlyOwner {
        directMembers[_member] = false;
    }
    
    function addDelegatedTrustee(address _account) public onlyOwner {
        delegatedTrustees[_account] = true;
    }

    function removeDelegatedTrustee(address _account) public onlyOwner {
        delegatedTrustees[_account] = false;
    }
    
    // Group currently is created from collateral tokens. Collateral is directly part of the directMembers dictionary.
    function mint(address _collateral, uint256 _amount) public {
        require(directMembers[_collateral], "Collateral address is not marked as direct member.");
        transferCollateralAndMint(_collateral, _amount);
    }
    
    // Group currently is created from collateral tokens. Collateral is trusted by someone in the delegatedTrustees dictionary.
    function mintDelegate(address _trustedBy, address _collateral, uint256 _amount) public {
        require(_trustedBy != address(0), "trustedBy must be valid address.");
        // require(trusted_by in delegated_trustees)
        require(delegatedTrustees[_trustedBy]);
        address collateralOwner = HubI(hub).tokenToUser(_collateral);
        // require(trusted_by.trust(collateral)
        require(HubI(hub).limits(_trustedBy, collateralOwner) > 0);
        transferCollateralAndMint(_collateral, _amount);
    }
    
    function transferCollateralAndMint(address _collateral, uint256 _amount) internal {
        uint256 mintFee = (_amount.div(1000)).mul(mintFeePerThousand); // Set fixed 0.1% fee for now
        ERC20(_collateral).transferFrom(msg.sender, address(this), _amount);
        uint256 mintAmount = _amount.sub(mintFee);
        // mint amount-fee to msg.sender
        _mint(msg.sender, mintAmount);
        emit Minted(msg.sender, _amount, mintAmount, mintFee);    
    }

    function transfer(address dst, uint256 wad) public override returns (bool) {
        // this code shouldn't be necessary, but when it's removed the gas estimation methods
        // in the gnosis safe no longer work, still true as of solidity 7.1
        return super.transfer(dst, wad);
    }
}
