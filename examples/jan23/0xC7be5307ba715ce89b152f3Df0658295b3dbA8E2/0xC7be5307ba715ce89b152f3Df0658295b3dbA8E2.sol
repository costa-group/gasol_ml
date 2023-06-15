// SPDX-License-Identifier: LGPL-3.0-or-later

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/interfaces/IPool.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import "aave/periphery-v3/contracts/misc/WalletBalanceProvider.sol";
