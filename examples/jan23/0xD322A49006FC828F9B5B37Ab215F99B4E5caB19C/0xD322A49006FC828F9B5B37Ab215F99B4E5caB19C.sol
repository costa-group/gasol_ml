// SPDX-License-Identifier: LGPL-3.0-or-later

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import "aave/core-v3/contracts/interfaces/IAToken.sol";
import "aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol";
import "aave/core-v3/contracts/interfaces/IInitializableAToken.sol";
import "aave/core-v3/contracts/interfaces/IPool.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol";
import "aave/core-v3/contracts/misc/interfaces/IWETH.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import "aave/periphery-v3/contracts/libraries/DataTypesHelper.sol";
import "aave/periphery-v3/contracts/misc/WrappedTokenGatewayV3.sol";
import "aave/periphery-v3/contracts/misc/interfaces/IWrappedTokenGatewayV3.sol";
