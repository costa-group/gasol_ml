// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

interface IPOTC {
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
}