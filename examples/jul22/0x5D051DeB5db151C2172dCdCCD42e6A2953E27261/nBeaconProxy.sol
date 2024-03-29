// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "BeaconProxy.sol";

contract nBeaconProxy is BeaconProxy {
    constructor(address beacon, bytes memory data) payable BeaconProxy(beacon, data) { }

    receive() external payable override {
        // Allow ETH transfers to succeed
    }
}