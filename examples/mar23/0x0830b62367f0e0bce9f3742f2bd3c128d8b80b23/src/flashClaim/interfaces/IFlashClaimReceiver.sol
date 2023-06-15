// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// title IFlashClaimReceiver
/// author captnseagraves
/// notice Defines the basic interface of a flashClaimReceiver contract.
/// dev Implement this interface to develop a flashClaim-compatible flashClaimReceiver contract

interface IFlashClaimReceiver {
    /// notice Executes an operation after receiving the flash claimed nft
    /// dev Ensure that the contract approves the FlashClaim contract to transferFrom
    ///      the NFT back to the Lending contract before the end of the transaction
    /// param initiator The initiator of the flashClaim
    /// param nftContractAddress The address of the nft collection
    /// param nftId The id of the specified nft
    /// param data Arbitrary data structure, intended to contain user-defined parameters
    /// return True if the execution of the operation succeeds, false otherwise
    function executeOperation(
        address initiator,
        address nftContractAddress,
        uint256 nftId,
        bytes calldata data
    ) external returns (bool);
}
