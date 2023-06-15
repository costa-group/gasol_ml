//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ISellerFinancingStructs {
    struct Offer {
        // SLOT 0
        // Full price of NFT
        uint128 price;
        // Down payment for NFT financing
        uint128 downPaymentAmount;
        // SLOT 1 - 128 remaining
        // Minimum percentage of total principal to be paid each period
        uint128 minimumPrincipalPerPeriod;
        // SLOT 2
        // Offer NFT ID
        uint256 nftId;
        // SLOT 3 - 96 remaining
        // Offer NFT contract address
        address nftContractAddress;
        // Offer creator
        address creator;
        // Interest rate basis points to be paid against remainingPrincipal per period
        uint32 periodInterestRateBps;
        // Number of seconds per period
        uint32 periodDuration;
        // Timestamp of offer expiration
        uint32 expiration;
    }

    struct Loan {
        // SLOT 0
        // Buyer loan receipt nftId
        uint256 buyerNftId;
        // SLOT 1
        // Seller loan receipt nftId
        uint256 sellerNftId;
        // SLOT 2
        // Remaining principal on loan
        uint128 remainingPrincipal;
        // Minimum percentage of total principal to be paid each period
        uint128 minimumPrincipalPerPeriod;
        // SLOT 3 - 128 remaining
        // Interest rate basis points to be paid against remainingPrincipal per period
        uint32 periodInterestRateBps;
        // Number of seconds per period
        uint32 periodDuration;
        // Timestamp of period end
        uint32 periodEndTimestamp;
        // Timestamp of period beginning
        uint32 periodBeginTimestamp;
    }
}
