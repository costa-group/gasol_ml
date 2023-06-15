// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IERC721Internal } from '../IERC721Internal.sol';

/**
 * title ERC721Metadata interface
 */
interface IERC721Metadata is IERC721Internal {
    /**
     * notice get token name
     * return token name
     */
    function name() external view returns (string memory);

    /**
     * notice get token symbol
     * return token symbol
     */
    function symbol() external view returns (string memory);

    /**
     * notice get generated URI for given token
     * return token URI
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
