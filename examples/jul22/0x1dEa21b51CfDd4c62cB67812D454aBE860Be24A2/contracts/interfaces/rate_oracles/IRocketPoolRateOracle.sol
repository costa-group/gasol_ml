// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.9;
import "../rocketPool/IRocketEth.sol";
import "../rate_oracles/IRateOracle.sol";

interface IRocketPoolRateOracle is IRateOracle {

    /// notice Gets the address of the RocketPool RETH token
    /// return Address of the RocketPool RETH token
    function rocketEth() external view returns (IRocketEth);
}