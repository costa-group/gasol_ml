// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/AccessControl.sol";
import "openzeppelin/contracts/access/IAccessControl.sol";
import "openzeppelin/contracts/proxy/utils/Initializable.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "contracts/core/Badges.sol";
import "contracts/core/interfaces/IAttestationsRegistry.sol";
import "contracts/core/interfaces/IAttestationsRegistryConfigLogic.sol";
import "contracts/core/interfaces/IBadges.sol";
import "contracts/core/libs/Structs.sol";
import "contracts/core/libs/utils/RangeLib.sol";
