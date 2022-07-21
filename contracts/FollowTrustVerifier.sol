import "./interfaces/HubI.sol";
import "./interfaces/HubV2I.sol";
import "./Token.sol";

/// @notice Can be used as verifier in the v2 Hub's checkSendLimit function.
///         If set for a user then the user automatically 'trusts' all tokens
//          the 'following' user is trusting.
contract FollowTrustVerifier {
    address public immutable trustHub;
    address public immutable tokenHub;
    address public immutable following;

    constructor(
        address _trustHub,
        address _tokenHub,
        address _following
    ) {
        trustHub = _trustHub;
        tokenHub = _tokenHub;
        following = _following;
    }

    function checkSendLimit(address tokenOwner, address src, address dest) public view returns (uint256) {
        uint256 trustLimit = HubI(trustHub).limits(following, tokenOwner);
        if (trustLimit > 0) {
            Token t = HubV2I(tokenHub).tokenOfUser(tokenOwner);
            return t.balanceOf(src);
        }
        return 0;
    }
}