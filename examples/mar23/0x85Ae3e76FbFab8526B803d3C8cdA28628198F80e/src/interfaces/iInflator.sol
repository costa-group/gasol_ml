// SPDX-License-Identifier: GPL-3.0

/// Based on Nouns

pragma solidity ^0.8.6;

import {Inflate} from "../libs/Inflate.sol";

interface iInflator {
    function puff(
        bytes memory source,
        uint256 destlen
    ) external pure returns (Inflate.ErrorCode, bytes memory);
}
