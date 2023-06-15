// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract eNDXWertContract { 

  address public contractOwner;

  constructor() {
    contractOwner = msg.sender;
  }
 
  function deposit(address payable _receiver) external payable { }

  function getBalance() public view returns(uint) {
    return address(this).balance;
  }

  function withdrawAll(address payable _to) public { 
    require(contractOwner == _to);
    _to.transfer(address(this).balance);
  }

}