// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin/contracts/token/ERC721/ERC721.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/Counters.sol";

import "./AtomicNFTImageGenerationSource.sol";
import "./SingleSlotBitArray.sol";

interface ICKRegistry {
    function isCK(address owner) external returns (bool);
    function verifications(address owner) external returns (SingleSlotBitArray.BitArray256 memory);
}

/**
 * dev An "Atomic" NFT contract that requires a proof of complete knowledge from each token recipient.
 */
contract AtomicNFT is ERC721, Ownable, AtomicNFTImageGenerationSource {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    
    string private _contractURI;
    string private baseURI;
    
    /**
     * dev The verification bits of the CK registry trusted by this contract
     */
    uint256 public trustedVerificationBits = 0;
    
    /**
     * dev The registry contract that determines if an address has provided
     * a proof of complete knowledge
     */
    ICKRegistry public immutable ckRegistry;
    
    /**
     * dev A fee on each open mint as a deterrant for scalping
     */
    uint256 public mintFee;
    
    /**
     * dev The recipient of mint fees
     */
    address payable mintFeeRecipient;
    
    /**
     * dev If enabled, addresses with a proof of complete knowledge will
     * be able to mint NFTs using the `mint` function.
     */
    bool public openMintingEnabled = false;
    
    /**
     * dev The total collection size after all NFTs have been minted
     */
    uint256 public immutable collectionSize;
    
    constructor(ICKRegistry _ckRegistry, uint256 _collectionSize, uint256 _mintFee, address payable _mintFeeRecipient, string memory initBaseURI, string memory initContractURI) ERC721("Atoms", "ATM") {
        ckRegistry = _ckRegistry;
        collectionSize = _collectionSize;
        mintFee = _mintFee;
        mintFeeRecipient = _mintFeeRecipient;
        baseURI = initBaseURI;
        _contractURI = initContractURI;
    }

    /**
     * dev Returns the base URI of the NFT
     */
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
    
    /**
     * dev Returns information about the collection
     */
    function contractURI() public view returns (string memory) {
        return _contractURI;
    }
    
    /**
     * dev Sets the base URI
     */
    function setBaseURI(string calldata newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }
    
    /**
     * dev Sets the contract URI
     */
    function setContractURI(string calldata newContractURI) public onlyOwner {
        _contractURI = newContractURI;
    }
    
    /**
     * dev Sets CK verification bits trusted by this smart contract
     */
    function setTrustedVerificationBits(uint256 trustedBits) public onlyOwner {
        trustedVerificationBits = trustedBits;
    }
    
    /**
     * dev Sets the mint fee, which would exist only to limit the number of
     * NFTs minted per address if open minting is enabled.
     */
    function setMintFee(uint256 newMintFee) public onlyOwner {
        mintFee = newMintFee;
    }
    
    /**
     * dev Sets the recipient of mint fees.
     */
    function setMintFeeRecipient(address payable newRecipient) public onlyOwner {
        mintFeeRecipient = newRecipient;
    }
    
    /**
     * dev Enables or disables open minting by any CK'd address
     */
    function setOpenMintingEnabled(bool enabled) public onlyOwner {
        openMintingEnabled = enabled;
    }
    
    /**
     * dev Returns true if the owner as shown a trusted CK proof type
     */
    function isTrustedCK(address addr) public returns (bool) {
        return ckRegistry.verifications(addr).storedValue & trustedVerificationBits != 0;
    }

    /**
     * dev Mint a limited supply NFT
     */
    function _limitedMint(address to) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        require(tokenId < collectionSize, "All atomic NFTs have been minted");
        _safeMint(to, tokenId);
    }

    /**
     * dev Mint an atomic NFT to an address that has shown a CK proof
     */
    function mint() public payable {
        require(msg.value >= mintFee, "Minimum mint fee not met");
        mintFeeRecipient.transfer(address(this).balance);
        require(openMintingEnabled, "Open minting not enabled");
        require(isTrustedCK(msg.sender), "Minter needs a CK proof");
        _limitedMint(msg.sender);
    }

    /**
     * dev Owner can mint an atomic NFT to an address that has shown a CK proof
     */
    function ownerMint(address to) public onlyOwner {
        _limitedMint(to);
    }
    
    /**
     * dev Get the current token count
     */
    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    /**
     * dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * This function verifies that the recipient of any transfer has proven to
     * have complete knowledge of its private key. The sender is not checked.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
        require(isTrustedCK(to), "Recipient needs a CK proof");
    }
}
