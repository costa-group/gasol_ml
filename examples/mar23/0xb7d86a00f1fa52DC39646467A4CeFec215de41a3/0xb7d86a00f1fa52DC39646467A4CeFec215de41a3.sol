// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/utils/Base64.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "contracts/OwnableUpgradeable.sol";
import "contracts/RabbitHoleReceipt.sol";
import "contracts/ReceiptRenderer.sol";
import "contracts/interfaces/IQuest.sol";
import "contracts/interfaces/IQuestFactory.sol";
