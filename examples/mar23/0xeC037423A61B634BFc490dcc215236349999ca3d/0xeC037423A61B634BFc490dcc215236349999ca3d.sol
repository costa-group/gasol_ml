// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

import "LpTokenStaker.sol";
import "SafeERC20.sol";
import "IERC20.sol";
import "draft-IERC20Permit.sol";
import "Address.sol";
import "BaseMinter.sol";
import "ERC165Storage.sol";
import "ERC165.sol";
import "IERC165.sol";
import "IMinter.sol";
import "ICNCToken.sol";
import "ILpTokenStaker.sol";
import "IInflationManager.sol";
import "IController.sol";
import "IConicPool.sol";
import "ILpToken.sol";
import "IERC20Metadata.sol";
import "IRewardManager.sol";
import "IOracle.sol";
import "ICurveRegistryCache.sol";
import "IBooster.sol";
import "CurvePoolUtils.sol";
import "ICurvePoolV2.sol";
import "ICurvePoolV1.sol";
import "ScaledMath.sol";
