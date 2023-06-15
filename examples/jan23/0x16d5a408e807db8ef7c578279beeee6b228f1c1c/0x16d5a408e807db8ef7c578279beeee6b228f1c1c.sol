// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol";
import "uniswap/v3-periphery/contracts/interfaces/IQuoter.sol";
import "uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "contracts/interface/IrETH.sol";
import "contracts/interface/RocketDAOProtocolSettingsDepositInterface.sol";
import "contracts/interface/RocketDepositPool.sol";
import "contracts/interface/RocketStorageInterface.sol";
import "contracts/lib/balancer-labs/v2-interfaces/contracts/solidity-utils/helpers/IAuthentication.sol";
import "contracts/lib/balancer-labs/v2-interfaces/contracts/solidity-utils/helpers/ISignaturesValidator.sol";
import "contracts/lib/balancer-labs/v2-interfaces/contracts/solidity-utils/helpers/ITemporarilyPausable.sol";
import "contracts/lib/balancer-labs/v2-interfaces/contracts/solidity-utils/misc/IWETH.sol";
import "contracts/lib/balancer-labs/v2-interfaces/contracts/vault/IAsset.sol";
import "contracts/lib/balancer-labs/v2-interfaces/contracts/vault/IAuthorizer.sol";
import "contracts/lib/balancer-labs/v2-interfaces/contracts/vault/IFlashLoanRecipient.sol";
import "contracts/lib/balancer-labs/v2-interfaces/contracts/vault/IProtocolFeesCollector.sol";
import "contracts/lib/balancer-labs/v2-interfaces/contracts/vault/IVault.sol";
import "contracts/RocketSwapRouter.sol";
