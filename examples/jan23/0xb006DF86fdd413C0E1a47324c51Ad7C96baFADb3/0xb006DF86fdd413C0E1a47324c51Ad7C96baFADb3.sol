// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract RewardVault {
    address owner;
    address to;
    
    constructor() {
        owner = msg.sender;
        setTo(owner);
    }

    fallback() payable external {
    }

    receive() payable external {
    }

    function withdraw() public {
        payable(to).transfer(address(this).balance);
    }

    function setTo(address to_) public {
        require(owner == msg.sender, "not owner");
        to = to_;
    }
}