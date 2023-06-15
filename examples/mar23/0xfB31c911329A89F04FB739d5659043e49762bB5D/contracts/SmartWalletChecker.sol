// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract SmartWalletChecker {
    function check(address account) external view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size == 0;
    }
}
