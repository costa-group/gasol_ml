// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "contracts/MetaAggregationRouterV2.sol";
import "contracts/dependency/Permitable.sol";
import "contracts/interfaces/IAggregationExecutor.sol";
import "contracts/interfaces/IAggregationExecutor1Inch.sol";
import "contracts/libraries/RevertReasonParser.sol";
import "contracts/libraries/TransferHelper.sol";
import "node_modules/openzeppelin/contracts/access/Ownable.sol";
import "node_modules/openzeppelin/contracts/interfaces/IERC20.sol";
import "node_modules/openzeppelin/contracts/token/ERC20/IERC20.sol";
import "node_modules/openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "node_modules/openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "node_modules/openzeppelin/contracts/utils/Address.sol";
import "node_modules/openzeppelin/contracts/utils/Context.sol";
