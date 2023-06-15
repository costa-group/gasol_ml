//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// title NiftyApes interface for the admin role.
interface ISellerFinancingAdmin {
    /// notice Pauses all interactions with the contract.
    ///         This is intended to be used as an emergency measure to avoid loosing funds.
    function pause() external;

    /// notice Unpauses all interactions with the contract.
    function unpause() external;
}
