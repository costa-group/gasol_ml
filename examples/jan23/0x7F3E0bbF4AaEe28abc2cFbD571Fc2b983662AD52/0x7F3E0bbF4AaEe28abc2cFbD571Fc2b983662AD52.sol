// SPDX-License-Identifier: LGPL-3.0-or-later

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeCast.sol";
import "aave/core-v3/contracts/interfaces/IAToken.sol";
import "aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol";
import "aave/core-v3/contracts/interfaces/IInitializableAToken.sol";
import "aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol";
import "aave/core-v3/contracts/interfaces/IPool.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/interfaces/IPriceOracleGetter.sol";
import "aave/core-v3/contracts/interfaces/IPriceOracleSentinel.sol";
import "aave/core-v3/contracts/interfaces/IReserveInterestRateStrategy.sol";
import "aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol";
import "aave/core-v3/contracts/interfaces/IStableDebtToken.sol";
import "aave/core-v3/contracts/interfaces/IVariableDebtToken.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
import "aave/core-v3/contracts/protocol/libraries/logic/BridgeLogic.sol";
import "aave/core-v3/contracts/protocol/libraries/logic/EModeLogic.sol";
import "aave/core-v3/contracts/protocol/libraries/logic/GenericLogic.sol";
import "aave/core-v3/contracts/protocol/libraries/logic/ReserveLogic.sol";
import "aave/core-v3/contracts/protocol/libraries/logic/ValidationLogic.sol";
import "aave/core-v3/contracts/protocol/libraries/math/MathUtils.sol";
import "aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol";
import "aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
