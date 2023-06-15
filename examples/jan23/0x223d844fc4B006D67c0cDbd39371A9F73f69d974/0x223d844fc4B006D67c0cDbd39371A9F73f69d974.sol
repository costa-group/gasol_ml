// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import "aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol";
import "aave/periphery-v3/contracts/rewards/EmissionManager.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/IEmissionManager.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/IRewardsDistributor.sol";
import "aave/periphery-v3/contracts/rewards/interfaces/ITransferStrategyBase.sol";
import "aave/periphery-v3/contracts/rewards/libraries/RewardsDataTypes.sol";
