// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol";
import "aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol";
import "aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol";
import "aave/core-v3/contracts/interfaces/IPool.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/interfaces/IPoolDataProvider.sol";
import "aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol";
import "aave/core-v3/contracts/interfaces/IStableDebtToken.sol";
import "aave/core-v3/contracts/interfaces/IVariableDebtToken.sol";
import "aave/core-v3/contracts/misc/AaveProtocolDataProvider.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
import "aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
