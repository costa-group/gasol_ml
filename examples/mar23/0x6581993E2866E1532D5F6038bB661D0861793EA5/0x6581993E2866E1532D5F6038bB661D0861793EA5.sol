// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155ReceiverUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC1155/extensions/IERC1155MetadataURIUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "openzeppelin/contracts/utils/Base64.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "contracts/OwnableUpgradeable.sol";
import "contracts/RabbitHoleTickets.sol";
import "contracts/TicketRenderer.sol";
