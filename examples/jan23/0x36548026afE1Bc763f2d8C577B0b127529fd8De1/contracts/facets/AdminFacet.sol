// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/token/ERC721/IERC721.sol";
import {LibStrings} from "../shared/libraries/LibStrings.sol";
import {AppStorage} from "../libraries/LibAppStorage.sol";
// import "hardhat/console.sol";
import {LibMeta} from "../shared/libraries/LibMeta.sol";

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {LibAccessControl} from "../libraries/LibAccessControl.sol";
import {LibRoles} from "../libraries/LibRoles.sol";

contract AdminFacet {
  AppStorage internal s;

  modifier onlyAdmin() {
    LibAccessControl.enforceRole(
      LibAccessControl.getRoleAdmin(LibRoles.ADMIN_ROLE)
    );
    _;
  }

  function setPrice(uint256 _newPrice) external onlyAdmin {
    s.price = _newPrice;
    s.pricePerDay = _newPrice / 365;
  }

  function setBaseURI(string calldata _newBaseURI) external onlyAdmin {
    s.tokenURI = _newBaseURI;
  }

  function setOffchainSigner(address _newOffchainSigner) external onlyAdmin {
    s.offchainSigner = _newOffchainSigner;
  }

  function toggleContractPaused() external onlyAdmin {
    s.contractIsPaused = !s.contractIsPaused;
  }

  function toggleClaimPaused() external onlyAdmin {
    s.claimIsPaused = !s.claimIsPaused;
  }

  function toggleExtensionEnabled() external onlyAdmin {
    s.extensionEnabled = !s.extensionEnabled;
  }

  function setMaxSupply(uint32 _newMaxSupply) external onlyAdmin {
    s.MAX_SUPPLY = _newMaxSupply;
  }

  function setGlobalTermLimit(uint256 newTermLimit) external onlyAdmin {
    s.GLOBAL_TERM_LIMIT = newTermLimit;
  }

  function setMinDaysToExtend(uint32 _newMinDaysToExtend) external onlyAdmin {
    s.MIN_DAYS_TO_EXTEND = _newMinDaysToExtend;
  }

  function isPaused() external view returns (bool) {
    if (s.contractIsPaused) {
      return true;
    } else {
      return false;
    }
  }

  function addSupportedInterface(bytes4 _newInterface) external onlyAdmin {
    LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
    ds.supportedInterfaces[_newInterface] = true;
  }
}
