pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

contract safebox{
    address public owner;
    uint256 public balance;

    constructor(){
        owner = msg.sender; //0x1647942404c4a6C6112Fc7e227764f53e0a05549
    }
    receive() payable external{
        balance += msg.value;
    }

    function withdraw (uint amount, address payable destAddr) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount <= balance, "Insufficient funds");
        destAddr.transfer(amount);
        balance -= amount;

    }

}