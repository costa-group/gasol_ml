/**
test

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.4.0;//jcf: p.r.a.g.m.a. solidity ^0.8.14;


interface IBEP20 {
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
}
contract TEST is IBEP20 {
    string private constant _name = 'TEST';
    string private constant _symbol = 'TNT';

    constructor() {}

    function name() public pure returns (string memory) {return _name;}
    function symbol() public pure returns (string memory) {return _symbol;}

}