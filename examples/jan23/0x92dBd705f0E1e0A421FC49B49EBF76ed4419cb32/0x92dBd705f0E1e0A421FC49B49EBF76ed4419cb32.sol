// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "src/USDCBank/USDCBankV1.sol";
