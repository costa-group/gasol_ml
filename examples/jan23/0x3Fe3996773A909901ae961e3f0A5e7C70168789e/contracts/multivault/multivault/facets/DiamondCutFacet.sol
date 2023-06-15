// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "../../interfaces/IDiamondCut.sol";

import "../storage/DiamondStorage.sol";

/******************************************************************************\
* Author: Nick Mudge <nickperfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamond Standard: https://eips.ethereum.org/EIPS/eip-2535
/******************************************************************************/




contract DiamondCutFacet is IDiamondCut {
    /// notice Add/replace/remove any number of functions and optionally execute
    ///         a function with delegatecall
    /// param _diamondCut Contains the facet addresses and function selectors
    /// param _init The address of the contract or facet to execute _calldata
    /// param _calldata A function call, including function selector and arguments
    ///                  _calldata is executed with delegatecall on _init
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {
        DiamondStorage.enforceIsContractOwner();
        DiamondStorage.diamondCut(_diamondCut, _init, _calldata);
    }
}
