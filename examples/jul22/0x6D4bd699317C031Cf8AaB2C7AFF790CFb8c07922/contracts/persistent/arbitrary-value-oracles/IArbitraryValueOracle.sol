// SPDX-License-Identifier: GPL-3.0

/*
    This file is part of the Enzyme Protocol.
    (c) Enzyme Council <councilenzyme.finance>
    For the full license information, please view the LICENSE
    file that was distributed with this source code.
*/

pragma solidity ^0.6.12;

/// title IArbitraryValueOracle Interface
/// author Enzyme Council <securityenzyme.finance>
interface IArbitraryValueOracle {
    function getLastUpdated() external view returns (uint256 lastUpdated_);

    function getValue() external view returns (int256 value_);

    function getValueWithTimestamp() external view returns (int256 value_, uint256 lastUpdated_);
}
