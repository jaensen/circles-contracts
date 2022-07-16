import "./interfaces/HubI.sol";

contract FollowTrustVerifier {
    uint256 public immutable trustHub;
    uint256 public immutable tokenHub;
    uint256 public immutable following;

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
            return HubV2I(tokenHub).userToToken[tokenOwner].balanceOf(src);
        }
        return 0;
    }
}