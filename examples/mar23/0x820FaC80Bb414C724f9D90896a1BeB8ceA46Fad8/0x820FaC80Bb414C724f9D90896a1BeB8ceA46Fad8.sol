// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CometYieldState {
    mapping(address => uint256) public lastTime;

    function getLastTime(address vault) external view returns (uint256) {
        return lastTime[vault];
    }

    function setLastTime(uint256 time) external {
        lastTime[msg.sender] = time;
    }
}