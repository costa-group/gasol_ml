// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "manifoldxyz/creator-core-solidity/contracts/core/CreatorCore.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/ICreatorCore.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/IERC1155CreatorCore.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/IERC721CreatorCore.sol";
import "manifoldxyz/creator-core-solidity/contracts/extensions/CreatorExtension.sol";
import "manifoldxyz/creator-core-solidity/contracts/extensions/ICreatorExtensionRoyalties.sol";
import "manifoldxyz/creator-core-solidity/contracts/extensions/ICreatorExtensionTokenURI.sol";
import "manifoldxyz/libraries-solidity/contracts/access/IAdminControl.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "src/MultiTokenSeriesExtension.sol";
