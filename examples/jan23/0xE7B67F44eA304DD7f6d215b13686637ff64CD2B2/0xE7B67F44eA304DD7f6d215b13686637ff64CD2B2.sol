// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeCast.sol";
import "aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol";
import "aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol";
import "aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol";
import "aave/periphery-v3/contracts/rewards/RewardsController.sol";
import "aave/periphery-v3/contracts/rewards/RewardsDistributor.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/IRewardsDistributor.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/ITransferStrategyBase.sol";
import "aave/periphery-v3/contracts/rewards/libraries/RewardsDataTypes.sol";
