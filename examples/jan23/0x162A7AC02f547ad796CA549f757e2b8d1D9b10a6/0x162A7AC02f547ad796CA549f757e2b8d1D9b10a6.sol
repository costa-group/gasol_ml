// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeCast.sol";
import "aave/core-v3/contracts/interfaces/IACLManager.sol";
import "aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol";
import "aave/core-v3/contracts/interfaces/IPool.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
import "aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/IncentivizedERC20.sol";
import "aave/periphery-v3/contracts/misc/UiIncentiveDataProviderV3.sol";
import "aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol";
import "aave/periphery-v3/contracts/misc/interfaces/IUiIncentiveDataProviderV3.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/IRewardsDistributor.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/ITransferStrategyBase.sol";
import "aave/periphery-v3/contracts/rewards/libraries/RewardsDataTypes.sol";
