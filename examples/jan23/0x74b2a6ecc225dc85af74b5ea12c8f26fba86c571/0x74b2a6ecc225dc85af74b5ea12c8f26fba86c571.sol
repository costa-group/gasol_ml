// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.0;

import "contracts/libraries/BytesLibrary.sol";
import "contracts/overrides/IRoyaltySplitter.sol";
import "contracts/overrides/RoyaltySplitter.sol";
import "lib/openzeppelin-contracts/contracts/proxy/Clones.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";
import "lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/utils/AddressUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/utils/ContextUpgradeable.sol";
