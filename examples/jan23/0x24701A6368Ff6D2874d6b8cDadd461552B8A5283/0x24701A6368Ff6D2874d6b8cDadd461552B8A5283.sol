// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/interfaces/IDefaultInterestRateStrategy.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/interfaces/IReserveInterestRateStrategy.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
import "aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol";
import "aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import "aave/core-v3/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol";
