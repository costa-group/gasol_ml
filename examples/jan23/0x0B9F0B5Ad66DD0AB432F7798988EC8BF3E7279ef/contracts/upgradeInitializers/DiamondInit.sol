// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/******************************************************************************\
// implemented by zeroknots.eth & kineut.eth
* Implementation of a diamond.
/******************************************************************************/
import "openzeppelin/contracts/utils/Counters.sol";

import {AppStorage} from "../libraries/LibAppStorage.sol";
import {LibAccessControl} from "../libraries/LibAccessControl.sol";
import {LibRoles} from "../libraries/LibRoles.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";
import {IDiamondLoupe} from "../interfaces/IDiamondLoupe.sol";
import {IDiamondCut} from "../interfaces/IDiamondCut.sol";
import {IERC173} from "../interfaces/IERC173.sol";
import {IERC165} from "../interfaces/IERC165.sol";

import {IERC721} from "../interfaces/IERC721.sol";
import {IERC721Enumerable} from "../interfaces/IERC721Enumerable.sol";

import {console} from "hardhat/console.sol";

// It is expected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

contract DiamondInit {
  using Counters for Counters.Counter;

  // You can add parameters to this function in order to pass in
  // data to set your own state variables
  AppStorage internal s;

  function init(address _contractOwner, address _offchainSigner) external {
    address currentOwner = LibDiamond.contractOwner();
    if(currentOwner != address(0)) {
      if(currentOwner != msg.sender) {
        revert("DiamondInit: Only the contract owner can reinitialize");
      }
    }

    LibDiamond.setContractOwner(_contractOwner);


    // Only first init() should increment the memberId counter to 1
    if(s.tokenIdCounter.current() == 0) {
      s.tokenIdCounter.increment();
    }

    s.MAX_SUPPLY = 9999;
    s.MIN_DAYS_TO_EXTEND = 30;
    s.GLOBAL_TERM_LIMIT = block.timestamp + (365 days * 2);
    s.price = 1 ether;
    s.pricePerDay = 2739726027397300;
    s.contractIsPaused = false;
    s.offchainSigner = _offchainSigner;
    s.name = "Provenance";
    s.symbol = "$PROV";
    s.extensionEnabled = false;
    s.claimIsPaused = false;
    s
      .tokenURI = "https://s3.us-west-1.wasabisys.com/provenance/metadata/";

    // adding ERC165 data
    LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
    ds.supportedInterfaces[type(IERC165).interfaceId] = true;
    ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
    ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
    ds.supportedInterfaces[type(IERC173).interfaceId] = true;
    ds.supportedInterfaces[type(IERC721).interfaceId] = true; // ERC721
    ds.supportedInterfaces[0x80ac58cd] = true; // ERC721

    ds.supportedInterfaces[type(IERC721Enumerable).interfaceId] = true; // ERC721

    LibAccessControl.grantRole(LibRoles.DEFAULT_ADMIN_ROLE, msg.sender);
    LibAccessControl.grantRole(LibRoles.DEFAULT_ADMIN_ROLE, _contractOwner);
    LibAccessControl.grantRole(LibRoles.ADMIN_ROLE, msg.sender);
    LibAccessControl.grantRole(LibRoles.ADMIN_ROLE, _contractOwner);

    // add your own state variables
    // EIP-2535 specifies that the `diamondCut` function takes two optional
    // arguments: address _init and bytes calldata _calldata
    // These arguments are used to execute an arbitrary function using delegatecall
    // in order to set state variables in the diamond during deployment or an upgrade
    // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface
  }
}
