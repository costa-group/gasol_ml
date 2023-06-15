// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "manifoldxyz/creator-core-solidity/contracts/ERC1155Creator.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/CreatorCore.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/ERC1155CreatorCore.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/ICreatorCore.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/IERC1155CreatorCore.sol";
import "manifoldxyz/creator-core-solidity/contracts/extensions/ERC1155/IERC1155CreatorExtensionApproveTransfer.sol";
import "manifoldxyz/creator-core-solidity/contracts/extensions/ERC1155/IERC1155CreatorExtensionBurnable.sol";
import "manifoldxyz/creator-core-solidity/contracts/extensions/ICreatorExtensionTokenURI.sol";
import "manifoldxyz/creator-core-solidity/contracts/permissions/ERC1155/IERC1155CreatorMintPermissions.sol";
import "manifoldxyz/libraries-solidity/contracts/access/AdminControl.sol";
import "manifoldxyz/libraries-solidity/contracts/access/IAdminControl.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "contracts/MFW.sol";
