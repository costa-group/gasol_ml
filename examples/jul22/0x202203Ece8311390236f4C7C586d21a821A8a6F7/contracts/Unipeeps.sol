// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {IUnipeeps} from './interfaces/IUnipeeps.sol';
import {ERC721} from 'openzeppelin/contracts/token/ERC721/ERC721.sol';
import {Ownable} from 'openzeppelin/contracts/access/Ownable.sol';
import {Strings} from 'openzeppelin/contracts/utils/Strings.sol';
import {IUnipeepsSVG} from './interfaces/IUnipeepsSVG.sol';
import {Base64} from 'base64-sol/base64.sol';

contract Unipeeps is IUnipeeps, ERC721, Ownable {
    using Strings for *;

    uint96 private constant MAX_THRESHOLD = 0;

    /// notice Metadata about each peeps
    mapping(uint256 => Peep) public peeps;

    struct SVGContract {
        IUnipeepsSVG svgContract;
        uint96 tokenIdThreshold;
    }
    SVGContract[] private svgContracts;

    /// notice The total number of peeps
    uint96 public totalSupply;

    constructor(
        string memory name,
        string memory symbol,
        address owner,
        IUnipeepsSVG svgContract
    ) ERC721(name, symbol) Ownable() {
        svgContracts.push(SVGContract(svgContract, MAX_THRESHOLD));
        transferOwnership(owner);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_exists(tokenId)) revert NonexistentPeep(tokenId);
        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                'UL ',
                                tokenId.toString(),
                                '/',
                                totalSupply.toString(),
                                '", "description":"',
                                'Commemorative NFTs for Uniswap Labs employees',
                                '", "image": "',
                                _generateSVGURL(tokenId),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    /// inheritdoc IUnipeeps
    function newPeeps(Peep[] memory _peeps, address[] memory recipients) external onlyOwner {
        if (_peeps.length != recipients.length) revert NewPeepsParamLengthMismatch();
        unchecked {
            for (uint256 i = 0; i < _peeps.length; i++) {
                peeps[++totalSupply] = _peeps[i];
                _mint(recipients[i], totalSupply);
            }
        }
    }

    /// inheritdoc IUnipeeps
    function modifyPeeps(
        uint256[] calldata tokenIds,
        Peep[] calldata _peeps
    ) external onlyOwner {
        if (tokenIds.length != _peeps.length) revert ModifyPeepsParamLengthMismatch();
        unchecked {
            for (uint256 i = 0; i < tokenIds.length; i++) {
                if (!_exists(tokenIds[i])) revert NonexistentPeep(tokenIds[i]);
                peeps[tokenIds[i]] = _peeps[i];
            }
        }
    }

    /// inheritdoc IUnipeeps
    function addNewSVGContract(IUnipeepsSVG svgContract) external onlyOwner {
        uint256 numSVGContracts = svgContracts.length;
        // if no new mints have happened since adding last svgContract, replace or else this one is unused.
        if (numSVGContracts > 1 && svgContracts[numSVGContracts - 2].tokenIdThreshold == totalSupply) {
            svgContracts[numSVGContracts - 1].svgContract = svgContract;
        } else {
            svgContracts[numSVGContracts - 1].tokenIdThreshold = totalSupply;
            svgContracts.push(SVGContract(svgContract, MAX_THRESHOLD));
        }
        emit NewSVGContractAdded(svgContract, totalSupply);
    }

    /// inheritdoc IUnipeeps
    function getSVGContract(uint256 tokenId) public view returns (IUnipeepsSVG) {
        if (!_exists(tokenId)) revert NonexistentPeep(tokenId);
        return _getSVGContract(tokenId);
    }

    function _getSVGContract(uint256 tokenId) public view returns (IUnipeepsSVG) {
        unchecked {
            for (uint256 i = 0; i <= svgContracts.length; i++) {
                SVGContract memory svgContract = svgContracts[i];
                if (tokenId <= svgContract.tokenIdThreshold || svgContract.tokenIdThreshold == MAX_THRESHOLD)
                    return svgContract.svgContract;
            }
        }
    }

    /// dev Generates the SVG URL for the image in the NFT metadata JSON
    function _generateSVGURL(uint256 tokenId) internal view returns (bytes memory) {
        return abi.encodePacked('data:image/svg+xml;base64,', Base64.encode(bytes(_getSVG(tokenId))));
    }

    /// dev Helper method for testing that returns the raw SVG content for the given token ID
    function _getSVG(uint256 tokenId) internal view returns (string memory) {
        return string(_getSVGContract(tokenId).generateSVG(tokenId, peeps[tokenId], totalSupply));
    }
}
