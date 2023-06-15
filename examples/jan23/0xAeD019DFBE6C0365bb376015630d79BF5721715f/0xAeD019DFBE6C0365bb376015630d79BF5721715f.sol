// SPDX-License-Identifier: LGPL-3.0-or-later

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeCast.sol";
import "aave/core-v3/contracts/interfaces/IACLManager.sol";
import "aave/core-v3/contracts/interfaces/IAToken.sol";
import "aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol";
import "aave/core-v3/contracts/interfaces/IDelegationToken.sol";
import "aave/core-v3/contracts/interfaces/IInitializableAToken.sol";
import "aave/core-v3/contracts/interfaces/IPool.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol";
import "aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
import "aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import "aave/core-v3/contracts/protocol/tokenization/AToken.sol";
import "aave/core-v3/contracts/protocol/tokenization/DelegationAwareAToken.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/EIP712Base.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/IncentivizedERC20.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/MintableIncentivizedERC20.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/ScaledBalanceTokenBase.sol";
