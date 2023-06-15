// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * dev Contract for veTOM token
 */
contract VeTOM is ERC20 {
    uint256 private constant _initialSupply = 100_000e18;

    constructor() ERC20("Vote-escrowed TOM", "veTOM") {
        _mint(_msgSender(), _initialSupply);
    }
}
