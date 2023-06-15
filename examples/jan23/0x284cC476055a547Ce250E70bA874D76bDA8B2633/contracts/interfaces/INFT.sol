// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

interface INFT is IERC721Enumerable {
    function walletOfOwner(address) external view returns (uint256[] memory);
}