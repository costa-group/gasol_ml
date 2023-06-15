// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/******************************************************************************\
* Author: Nick Mudge <nickperfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
*
* Implementation of a diamond.
/******************************************************************************/

import {IDiamondLoupe} from "../../interfaces/IDiamondLoupe.sol";
import {IDiamondCut} from "../../interfaces/IDiamondCut.sol";
import {IERC165} from "../../interfaces/IERC165.sol";

import {LibDiamond} from "../../libraries/LibDiamond.sol";
import {Constants} from "../../libraries/Constants.sol";

import {BaseConnextFacet} from "../BaseConnextFacet.sol";

import {IProposedOwnable} from "../../../../shared/interfaces/IProposedOwnable.sol";
import {IConnectorManager} from "../../../../messaging/interfaces/IConnectorManager.sol";

// It is expected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

contract DiamondInit is BaseConnextFacet {
  // ========== Custom Errors ===========
  error DiamondInit__init_alreadyInitialized();
  error DiamondInit__init_domainsDontMatch();

  // ============ External ============

  // You can add parameters to this function in order to pass in
  // data to set your own state variables
  // NOTE: not requiring a longer delay related to constant as we want to be able to test
  // with shorter governance delays
  function init(
    uint32 _domain,
    address _xAppConnectionManager,
    uint256 _acceptanceDelay,
    address _lpTokenTargetAddress
  ) external {
    // should not init twice
    if (s.initialized) {
      revert DiamondInit__init_alreadyInitialized();
    }

    // ensure this is the owner
    LibDiamond.enforceIsContractOwner();

    // ensure domains are the same
    IConnectorManager manager = IConnectorManager(_xAppConnectionManager);
    if (manager.localDomain() != _domain) {
      revert DiamondInit__init_domainsDontMatch();
    }

    // update the initialized flag
    s.initialized = true;

    // adding ERC165 data
    LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
    ds.supportedInterfaces[type(IERC165).interfaceId] = true;
    ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
    ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
    ds.supportedInterfaces[type(IProposedOwnable).interfaceId] = true;
    ds.acceptanceDelay = _acceptanceDelay;

    // add your own state variables
    // EIP-2535 specifies that the `diamondCut` function takes two optional
    // arguments: address _init and bytes calldata _calldata
    // These arguments are used to execute an arbitrary function using delegatecall
    // in order to set state variables in the diamond during deployment or an upgrade
    // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface

    // __ReentrancyGuard_init_unchained
    s._status = Constants.NOT_ENTERED;
    s._xcallStatus = Constants.NOT_ENTERED;

    // Connext
    s.domain = _domain;
    s.LIQUIDITY_FEE_NUMERATOR = Constants.INITIAL_LIQUIDITY_FEE_NUMERATOR;
    s.maxRoutersPerTransfer = Constants.INITIAL_MAX_ROUTERS;
    s.xAppConnectionManager = manager;
    s.lpTokenTargetAddress = _lpTokenTargetAddress;
  }
}
