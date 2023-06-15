// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/chainlink/AggregatorInterface.sol";
import "aave/core-v3/contracts/interfaces/IACLManager.sol";
import "aave/core-v3/contracts/interfaces/IAaveOracle.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/interfaces/IPriceOracleGetter.sol";
import "aave/core-v3/contracts/misc/AaveOracle.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
