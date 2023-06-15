// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.4;

import "./contracts/oracle/CompositeOracle.sol";
import "./contracts/refs/CoreRef.sol";
import "./contracts/refs/ICoreRef.sol";
import "./contracts/core/ICore.sol";
import "./contracts/core/IPermissions.sol";
import "./contracts/core/IPermissionsRead.sol";
import "./contracts/fei/IFei.sol";
import "./contracts/oracle/IOracle.sol";
import "./contracts/external/Decimal.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/access/AccessControl.sol";
import "openzeppelin/contracts/access/IAccessControl.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/utils/math/SafeMath.sol";
