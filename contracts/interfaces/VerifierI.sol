// SPDX-License-Identifier: AGPL
pragma solidity ^0.7.0;

interface VerifierI {
    function checkSendLimit(address tokenOwner, address src, address dest) public view returns (uint256);
}
