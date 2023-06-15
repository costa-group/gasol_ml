// SPDX-License-Identifier: MIT
// 
// 
// **,,,
// ,,,,,,,
// *,,,*,,,,
// ,,,*,,,,,,,*
// ,,,,,****,,,*
// ,,,,#(**%,,
// *,,,*,****
// ,,**(,,,,,**,,,
// ,,,****,,,,,,,,,*,,*(
// ,,,,#,,,,,,*,*,,,,,,,,,,,,,,,,,
// **,**,,,,,,,*****,,***,,,,,,,*,,*
// (,******#(**,,,,**,,,,,,*
// ,,,,*****(,,,,,,**(,,,,,,,,
// *,,,,,,,/(,,,*,,,,,,,,,,(***,,*/*
// ,,,,,**#,,,,,,,,,,,,,,,,,###
// ****#(,,,,,,,,,,,,,,,,,,,,,,,,*,,#
// (***,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,##
// #,,,,,,,,,,,*,****,,,,,,,,,***,,,,,,
// #,,,,,,**,,,,,,,,,,,,,,******,,*****(
// #***,,,,*,***,*******,,*****,****(***
// #***,,,**,********(*(((
// #*************,*#
// #((*(#
// &&##&&
// &&
// &&&
// &&&
// 
// 
// 
pragma solidity ^0.8.18;

import { JailBreakCommitment } from "../shared/Types.sol";

library JailBreakStorage {
    struct Layout {
        mapping(address => JailBreakCommitment) commitments;
        // IMPORTANT: For update append only, do not re-order fields!
    }

    bytes32 internal constant STORAGE_SLOT = keccak256("copium.wars.storage.jailbreak");

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
