// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC1155} from "IERC1155.sol";

/**
 * title ERC1155 base interface
 */
interface IERC1155Base is IERC1155 {
    event MaxSupplyRemoved(
        uint256 tokenId,
        uint256 actualMaxSupply,
        uint256 newMaxSupply
    );
}
