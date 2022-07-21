// SPDX-License-Identifier: AGPL
pragma solidity ^0.7.0;

interface HubI {
    function issuance() external view returns (uint256);
    function issuanceByStep(uint256) external view returns (uint256);
    function inflation() external view returns (uint256);
    function divisor() external view returns (uint256);
    function period() external view returns (uint256);
    function periods() external view returns (uint256);
    function signupBonus() external view returns (uint256);
    function pow(uint256, uint256) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function deployedAt() external view returns (uint256);
    function inflate(uint256, uint256) external view returns (uint256);
    function timeout() external view returns (uint256);
    function userToToken(address) external returns (address);
    function organizations(address) external view returns (bool);
    function tokenToUser(address) external returns (address);
    function limits(address,address) external view returns (uint256);
    function trust(address user, uint limit) external;
}