// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/AccessControl.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/ERC165.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IAccessControl.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC165.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Strings.sol";
import "aave/core-v3/contracts/interfaces/IACLManager.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/protocol/configuration/ACLManager.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
