// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {IERC721} from 'openzeppelin/contracts/token/ERC721/IERC721.sol';
import {IUnipeepsSVG} from './IUnipeepsSVG.sol';

interface IUnipeeps is IERC721 {
    /// notice Emitted when a new SVG contract is added for the next future mints
    /// param unipeepsSVG The address of the new contract
    /// param totalSupply The total supply at the time of add. tokenIds after this will be minted with the new SVG.
    event NewSVGContractAdded(IUnipeepsSVG unipeepsSVG, uint96 totalSupply);

    /// notice The queried token does not exist
    error NonexistentPeep(uint256 invalidId);
    /// notice The number of peeps, employeeNumbers, and recipients must match
    error NewPeepsParamLengthMismatch();
    /// notice The number of tokenIds, groups, and roles must match
    error ModifyPeepsParamLengthMismatch();
    /// notice The employee number has already been minted.
    error NewPeepOutOfOrder(uint256 employeeNumber, uint256 totalSupply);

    enum Group {
        Design,
        Engineering,
        Executive,
        Legal,
        Operations,
        Product,
        Strategy
    }

    struct Peep {
        string first;
        string last;
        string role;
        uint248 epochStartDate;
        Group group;
    }

    /// notice Mints a new NFT with the given metadata for the given recipient.
    /// param peeps A list of the metadata for each NFT to mint.
    /// param recipients A list of the recipient addresses that should receive the newly minted NFT. Indices should correspond
    ///        to the _peeps array.
    function newPeeps(Peep[] memory peeps, address[] memory recipients) external;

    /// notice Modifies the role and group of an existing peep.
    /// param tokenIds The tokenIds of the peeps to modify.
    /// param _peeps The updated details for each peep.
    function modifyPeeps(
      uint256[] calldata tokenIds,
      Peep[] calldata _peeps
    ) external;

    /// notice Adds new contract for svg art for the next future mints.
    /// param svgContract The address of the new UnipeepsSVG contract
    function addNewSVGContract(IUnipeepsSVG svgContract) external;

    /// notice Get the SVG contract associated with a tokenId
    /// param tokenId The tokenId
    function getSVGContract(uint256 tokenId) external view returns (IUnipeepsSVG);
}
