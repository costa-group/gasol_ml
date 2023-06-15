// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "./ERC20.sol";

// Double your tokens!
// Mint with USDC at the vault, receive equal DDA and DDB tokens!
// Redeem to get USDC back from the vault, using equal amounts of DDA and DDB tokens!
// Find out what happens to the token prices!
// 
// See:
// https://twitter.com/danrobinson/status/1541217413756325890
//
// Blame:
// Daniel Von Fange (DanielVF)

contract DoubleDeeToken is ERC20 {
    address public immutable vault;

    constructor(
        address vault_,
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_, 6) {
        vault = vault_;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == vault, "Not vault");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        require(msg.sender == vault, "Not vault");
        _burn(from, amount);
    }
}
