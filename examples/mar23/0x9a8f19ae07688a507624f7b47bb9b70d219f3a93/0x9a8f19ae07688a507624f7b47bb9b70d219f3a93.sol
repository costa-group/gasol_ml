// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract MultiSend{
    function oneToAll(address[] memory addresses , uint amount) external payable {
        for (uint i = 0; i < addresses.length; i++) {
             (bool sent, ) = payable(addresses[i]).call{value: amount}("");
             require(sent, "Failed to send Ether");
        }
    }
}