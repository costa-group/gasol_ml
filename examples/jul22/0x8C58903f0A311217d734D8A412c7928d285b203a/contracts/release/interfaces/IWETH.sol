// SPDX-License-Identifier: GPL-3.0

/*
    This file is part of the Enzyme Protocol.

    (c) Enzyme Council <councilenzyme.finance>

    For the full license information, please view the LICENSE
    file that was distributed with this source code.
*/

pragma solidity ^0.6.12;

/// title WETH Interface
/// author Enzyme Council <securityenzyme.finance>
interface IWETH {
    function deposit() external payable;

    function withdraw(uint256) external;
}
