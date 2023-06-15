// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "contracts/MetaAggregationRouter.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "contracts/dependency/Permitable.sol";
import "contracts/interfaces/IAggregationExecutor.sol";
import "contracts/interfaces/IAggregationExecutor1Inch.sol";
import "contracts/libraries/TransferHelper.sol";
import "contracts/libraries/RevertReasonParser.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/interfaces/IERC20.sol";
