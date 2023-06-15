// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/introspection/IERC165.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "contracts/royalties/RoyaltyFeeSetter.sol";
import "contracts/royalties/interfaces/IOwnable.sol";
import "contracts/royalties/interfaces/IRoyaltyFeeRegistry.sol";
