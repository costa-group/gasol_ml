// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/eip/interface/IERC165.sol";
import "contracts/eip/interface/IERC20.sol";
import "contracts/eip/interface/IERC2981.sol";
import "contracts/extension/DefaultOperatorFiltererUpgradeable.sol";
import "contracts/extension/OperatorFilterToggle.sol";
import "contracts/extension/OperatorFiltererUpgradeable.sol";
import "contracts/extension/interface/IOperatorFilterRegistry.sol";
import "contracts/extension/interface/IOperatorFilterToggle.sol";
import "contracts/extension/interface/IOwnable.sol";
import "contracts/extension/interface/IPlatformFee.sol";
import "contracts/extension/interface/IPrimarySale.sol";
import "contracts/extension/interface/IRoyalty.sol";
import "contracts/interfaces/IThirdwebContract.sol";
import "contracts/interfaces/IWETH.sol";
import "contracts/interfaces/token/ITokenERC1155.sol";
import "contracts/lib/CurrencyTransferLib.sol";
import "contracts/lib/FeeType.sol";
import "contracts/lib/TWAddress.sol";
import "contracts/openzeppelin-presets/metatx/ERC2771ContextUpgradeable.sol";
import "contracts/openzeppelin-presets/token/ERC20/utils/SafeERC20.sol";
import "contracts/token/TokenERC1155.sol";
import "node_modules/openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/access/IAccessControlEnumerableUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155ReceiverUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/token/ERC1155/extensions/IERC1155MetadataURIUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/utils/MulticallUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "node_modules/openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
