// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;  
contract Refund {
    // constructor(){}

    function refund(address[] memory addresses, uint[] memory amounts) public payable{
        for(uint i=0; i<addresses.length; i++) {
            (bool success, ) = addresses[i].call{value: amounts[i]}("");
            require(success, "Transfer failed.");
        }
    }
}