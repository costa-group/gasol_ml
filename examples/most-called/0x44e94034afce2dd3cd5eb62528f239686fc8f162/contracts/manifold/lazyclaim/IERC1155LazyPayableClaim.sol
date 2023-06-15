// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// author: manifold.xyz

/**
 * Lazy Claim interface
 */
interface IERC1155LazyPayableClaim {
    enum StorageProtocol { INVALID, NONE, ARWEAVE, IPFS }

    struct ClaimParameters {
        uint32 totalMax;
        uint32 walletMax;
        uint48 startDate;
        uint48 endDate;
        StorageProtocol storageProtocol;
        bytes32 merkleRoot;
        string location;
        uint256 cost;
        address payable paymentReceiver;
    }

    struct Claim {
        uint32 total;
        uint32 totalMax;
        uint32 walletMax;
        uint48 startDate;
        uint48 endDate;
        StorageProtocol storageProtocol;
        bytes32 merkleRoot;
        string location;
        uint256 tokenId;
        uint256 cost;
        address payable paymentReceiver;
    }

    event ClaimInitialized(address indexed creatorContract, uint256 indexed claimIndex, address initializer);
    event ClaimMint(address indexed creatorContract, uint256 indexed claimIndex);
    event ClaimMintBatch(address indexed creatorContract, uint256 indexed claimIndex, uint16 mintCount);

    /**
     * notice initialize a new claim, emit initialize event, and return the newly created index
     * param creatorContractAddress    the creator contract the claim will mint tokens for
     * param claimIndex                the index of the claim in the list of creatorContractAddress' _claims
     * param claimParameters           the parameters which will affect the minting behavior of the claim
     */
    function initializeClaim(address creatorContractAddress, uint256 claimIndex, ClaimParameters calldata claimParameters) external;

    /**
     * notice update an existing claim at claimIndex
     * param creatorContractAddress    the creator contract corresponding to the claim
     * param claimIndex                the index of the claim in the list of creatorContractAddress' _claims
     * param claimParameters           the parameters which will affect the minting behavior of the claim
     */
    function updateClaim(address creatorContractAddress, uint256 claimIndex, ClaimParameters calldata claimParameters) external;

    /**
     * notice update tokenURI parameters for an existing claim at claimIndex
     * param creatorContractAddress    the creator contract corresponding to the claim
     * param claimIndex                the index of the claim in the list of creatorContractAddress' _claims
     * param storageProtocol           the new storage protocol
     * param location                  the new location
     */
    function updateTokenURIParams(address creatorContractAddress, uint256 claimIndex, StorageProtocol storageProtocol, string calldata location) external;

    /**
     * notice get a claim corresponding to a creator contract and index
     * param creatorContractAddress    the address of the creator contract
     * param claimIndex                the index of the claim
     * return                          the claim object
     */
    function getClaim(address creatorContractAddress, uint256 claimIndex) external view returns(Claim memory);

    /**
     * notice check if a mint index has been consumed or not (only for merkle claims)
     *
     * param creatorContractAddress    the address of the creator contract for the claim
     * param claimIndex                the index of the claim
     * param mintIndex                 the mint index of the claim
     * return                          whether or not the mint index was consumed
     */
    function checkMintIndex(address creatorContractAddress, uint256 claimIndex, uint32 mintIndex) external view returns(bool);

    /**
     * notice check if multiple mint indices has been consumed or not (only for merkle claims)
     *
     * param creatorContractAddress    the address of the creator contract for the claim
     * param claimIndex                the index of the claim
     * param mintIndices               the mint index of the claim
     * return                          whether or not the mint index was consumed
     */
    function checkMintIndices(address creatorContractAddress, uint256 claimIndex, uint32[] calldata mintIndices) external view returns(bool[] memory);

    /**
     * notice get mints made for a wallet (only for non-merkle claims with walletMax)
     *
     * param minter                    the address of the minting address
     * param creatorContractAddress    the address of the creator contract for the claim
     * param claimIndex                the index of the claim
     * return                          how many mints the minter has made
     */
    function getTotalMints(address minter, address creatorContractAddress, uint256 claimIndex) external view returns(uint32);

    /**
     * notice allow a wallet to lazily claim a token according to parameters
     * param creatorContractAddress    the creator contract address
     * param claimIndex                the index of the claim for which we will mint
     * param mintIndex                 the mint index (only needed for merkle claims)
     * param merkleProof               if the claim has a merkleRoot, verifying merkleProof ensures that address + minterValue was used to construct it  (only needed for merkle claims)
     */
    function mint(address creatorContractAddress, uint256 claimIndex, uint32 mintIndex, bytes32[] calldata merkleProof, address mintFor) external payable;

    /**
     * notice allow a wallet to lazily claim a token according to parameters
     * param creatorContractAddress    the creator contract address
     * param claimIndex                the index of the claim for which we will mint
     * param mintCount                 the number of claims to mint
     * param mintIndices               the mint index (only needed for merkle claims)
     * param merkleProofs              if the claim has a merkleRoot, verifying merkleProof ensures that address + minterValue was used to construct it  (only needed for merkle claims)
     */
    function mintBatch(address creatorContractAddress, uint256 claimIndex, uint16 mintCount, uint32[] calldata mintIndices, bytes32[][] calldata merkleProofs, address mintFor) external payable;

    /**
     * notice allow admin to airdrop arbitrary tokens 
     * param creatorContractAddress    the creator contract the claim will mint tokens for
     * param claimIndex                the index of the claim in the list of creatorContractAddress' _claims
     * param recipients                addresses to airdrop to
     * param amounts                   number of tokens to airdrop to each address in addresses
     */
    function airdrop(address creatorContractAddress, uint256 claimIndex, address[] calldata recipients, uint256[] calldata amounts) external;
}
