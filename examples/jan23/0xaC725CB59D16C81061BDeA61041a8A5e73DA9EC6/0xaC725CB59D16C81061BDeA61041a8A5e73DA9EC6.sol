// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeCast.sol";
import "aave/core-v3/contracts/interfaces/IACLManager.sol";
import "aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol";
import "aave/core-v3/contracts/interfaces/ICreditDelegationToken.sol";
import "aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol";
import "aave/core-v3/contracts/interfaces/IPool.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol";
import "aave/core-v3/contracts/interfaces/IVariableDebtToken.sol";
import "aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol";
import "aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";
import "aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import "aave/core-v3/contracts/protocol/tokenization/VariableDebtToken.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/DebtTokenBase.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/EIP712Base.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/IncentivizedERC20.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/MintableIncentivizedERC20.sol";
import "aave/core-v3/contracts/protocol/tokenization/base/ScaledBalanceTokenBase.sol";
