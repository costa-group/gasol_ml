// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin/contracts/token/ERC721/ERC721.sol";
import "openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "openzeppelin/contracts/utils/Strings.sol";

/// custom:security-contact securitytenset.io
contract GenesisNFTCEO is ERC721, ERC721Royalty, ERC721Burnable, Ownable {
    using Strings for uint256;

    string public baseURI;

    constructor(string memory baseURI_) ERC721("TGLP Genesis", "TGLP GEN") {
        baseURI = baseURI_;
        _safeMint(0xB9dfC2357FD118E7f538D228AB36F998D1a7586d, 1);
    }

    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function deleteDefaultRoyalty() external onlyOwner {
        _deleteDefaultRoyalty();
    }

    function setTokenRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator
    ) external onlyOwner {
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    function resetTokenRoyalty(uint256 tokenId) external onlyOwner {
        _resetTokenRoyalty(tokenId);
    }

    function setURI(string calldata newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI_ = _baseURI();
        return
            bytes(baseURI_).length > 0
                ? string(abi.encodePacked(baseURI_, tokenId.toString(), ".json"))
                : "";
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721Royalty) {
        super._burn(tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}
