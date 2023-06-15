// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "StrategyConvex3CrvRewardsClonable.sol";
import "IERC20.sol";
import "SafeERC20.sol";
import "draft-IERC20Permit.sol";
import "Address.sol";
import "Math.sol";
import "SafeMath.sol";
import "ICurve.sol";
import "IUniV2.sol";
import "BaseStrategy.sol";
import "ERC20.sol";
import "IERC20Metadata.sol";
import "Context.sol";
import "IOracle.sol";
import "IUniV3.sol";
import "IConvexRewards.sol";
import "IConvexDeposit.sol";
