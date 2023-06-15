// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "balancer-labs/v2-solidity-utils/contracts/math/LogExpMath.sol";
import "balancer-labs/v2-interfaces/contracts/solidity-utils/helpers/BalancerErrors.sol";
import "balancer-labs/v2-solidity-utils/contracts/math/FixedPoint.sol";
import "contracts/StableMath.sol";
import "balancer-labs/v2-solidity-utils/contracts/math/Math.sol";
import "balancer-labs/v2-interfaces/contracts/pool-utils/IRateProvider.sol";
import "contracts/StablePool.sol";
import "balancer-labs/v2-solidity-utils/contracts/helpers/WordCodec.sol";
import "balancer-labs/v2-interfaces/contracts/pool-stable/StablePoolUserData.sol";
import "balancer-labs/v2-solidity-utils/contracts/helpers/InputHelpers.sol";
import "balancer-labs/v2-pool-utils/contracts/BaseGeneralPool.sol";
import "balancer-labs/v2-pool-utils/contracts/LegacyBaseMinimalSwapInfoPool.sol";
import "balancer-labs/v2-interfaces/contracts/solidity-utils/openzeppelin/IERC20.sol";
import "balancer-labs/v2-interfaces/contracts/vault/IGeneralPool.sol";
import "balancer-labs/v2-pool-utils/contracts/LegacyBasePool.sol";
import "balancer-labs/v2-interfaces/contracts/vault/IBasePool.sol";
import "balancer-labs/v2-interfaces/contracts/vault/IVault.sol";
import "balancer-labs/v2-interfaces/contracts/vault/IPoolSwapStructs.sol";
import "balancer-labs/v2-interfaces/contracts/solidity-utils/helpers/IAuthentication.sol";
import "balancer-labs/v2-interfaces/contracts/solidity-utils/helpers/ISignaturesValidator.sol";
import "balancer-labs/v2-interfaces/contracts/solidity-utils/helpers/ITemporarilyPausable.sol";
import "balancer-labs/v2-interfaces/contracts/solidity-utils/misc/IWETH.sol";
import "balancer-labs/v2-interfaces/contracts/vault/IAsset.sol";
import "balancer-labs/v2-interfaces/contracts/vault/IAuthorizer.sol";
import "balancer-labs/v2-interfaces/contracts/vault/IFlashLoanRecipient.sol";
import "balancer-labs/v2-interfaces/contracts/vault/IProtocolFeesCollector.sol";
import "balancer-labs/v2-interfaces/contracts/asset-manager-utils/IAssetManager.sol";
import "balancer-labs/v2-solidity-utils/contracts/helpers/TemporarilyPausable.sol";
import "balancer-labs/v2-solidity-utils/contracts/openzeppelin/ERC20.sol";
import "balancer-labs/v2-pool-utils/contracts/BalancerPoolToken.sol";
import "balancer-labs/v2-pool-utils/contracts/RecoveryMode.sol";
import "balancer-labs/v2-solidity-utils/contracts/openzeppelin/SafeMath.sol";
import "balancer-labs/v2-solidity-utils/contracts/openzeppelin/ERC20Permit.sol";
import "balancer-labs/v2-interfaces/contracts/solidity-utils/openzeppelin/IERC20Permit.sol";
import "balancer-labs/v2-solidity-utils/contracts/openzeppelin/EIP712.sol";
import "balancer-labs/v2-interfaces/contracts/solidity-utils/helpers/IRecoveryMode.sol";
import "balancer-labs/v2-interfaces/contracts/pool-utils/BasePoolUserData.sol";
import "balancer-labs/v2-pool-utils/contracts/BasePoolAuthorization.sol";
import "balancer-labs/v2-solidity-utils/contracts/helpers/Authentication.sol";
import "balancer-labs/v2-interfaces/contracts/vault/IMinimalSwapInfoPool.sol";