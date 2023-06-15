// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.17;

import "contracts/UniversalRouter.sol";
import "contracts/base/Callbacks.sol";
import "contracts/base/Dispatcher.sol";
import "contracts/base/ReentrancyLock.sol";
import "contracts/base/RewardsCollector.sol";
import "contracts/base/RouterImmutables.sol";
import "contracts/interfaces/IRewardsCollector.sol";
import "contracts/interfaces/IUniversalRouter.sol";
import "contracts/interfaces/external/ICryptoPunksMarket.sol";
import "contracts/interfaces/external/IWETH9.sol";
import "contracts/libraries/Commands.sol";
import "contracts/libraries/Constants.sol";
import "contracts/libraries/Recipient.sol";
import "contracts/modules/Payments.sol";
import "contracts/modules/Permit2Payments.sol";
import "contracts/modules/uniswap/v2/UniswapV2Library.sol";
import "contracts/modules/uniswap/v2/V2SwapRouter.sol";
import "contracts/modules/uniswap/v3/BytesLib.sol";
import "contracts/modules/uniswap/v3/V3Path.sol";
import "contracts/modules/uniswap/v3/V3SwapRouter.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import "lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";
import "lib/permit2/src/interfaces/IAllowanceTransfer.sol";
import "lib/permit2/src/libraries/SafeCast160.sol";
import "lib/solmate/src/tokens/ERC1155.sol";
import "lib/solmate/src/tokens/ERC20.sol";
import "lib/solmate/src/tokens/ERC721.sol";
import "lib/solmate/src/utils/SafeTransferLib.sol";
import "lib/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "lib/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "lib/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol";
import "lib/v3-core/contracts/interfaces/pool/IUniswapV3PoolActions.sol";
import "lib/v3-core/contracts/interfaces/pool/IUniswapV3PoolDerivedState.sol";
import "lib/v3-core/contracts/interfaces/pool/IUniswapV3PoolEvents.sol";
import "lib/v3-core/contracts/interfaces/pool/IUniswapV3PoolImmutables.sol";
import "lib/v3-core/contracts/interfaces/pool/IUniswapV3PoolOwnerActions.sol";
import "lib/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol";
import "lib/v3-core/contracts/libraries/SafeCast.sol";
