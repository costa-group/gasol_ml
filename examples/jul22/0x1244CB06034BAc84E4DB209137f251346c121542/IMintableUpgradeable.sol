// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMintableUpgradeable {
    function safeMint(address to, uint256 quantity) external returns (uint256);
}
