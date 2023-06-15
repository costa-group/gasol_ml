// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol";
import "aave/core-v3/contracts/interfaces/IAToken.sol";
import "aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol";
import "aave/core-v3/contracts/interfaces/IAaveOracle.sol";
import "aave/core-v3/contracts/interfaces/IDefaultInterestRateStrategy.sol";
import "aave/core-v3/contracts/interfaces/IInitializableAToken.sol";
import "aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol";
import "aave/core-v3/contracts/interfaces/IPool.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/interfaces/IPoolDataProvider.sol";
import "aave/core-v3/contracts/interfaces/IPriceOracleGetter.sol";
import "aave/core-v3/contracts/interfaces/IReserveInterestRateStrategy.sol";
import "aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol";
import "aave/core-v3/contracts/interfaces/IStableDebtToken.sol";
import "aave/core-v3/contracts/interfaces/IVariableDebtToken.sol";
import "aave/core-v3/contracts/misc/AaveProtocolDataProvider.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
import "aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol";
import "aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import "aave/core-v3/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol";
import "aave/periphery-v3/contracts/misc/UiPoolDataProviderV3.sol";
import "aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol";
import "aave/periphery-v3/contracts/misc/interfaces/IERC20DetailedBytes.sol";
import "aave/periphery-v3/contracts/misc/interfaces/IUiPoolDataProviderV3.sol";
