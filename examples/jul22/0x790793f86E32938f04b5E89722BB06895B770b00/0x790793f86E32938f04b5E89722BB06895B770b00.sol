// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/AccessControl.sol";
import "openzeppelin/contracts/access/IAccessControl.sol";
import "openzeppelin/contracts/proxy/Clones.sol";
import "openzeppelin/contracts/proxy/utils/Initializable.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "contracts/PaymentSplitterCloneable.sol";
import "contracts/PaymentSplitterManager.sol";
import "contracts/access/AdminControl.sol";
import "contracts/access/IAdminControl.sol";
