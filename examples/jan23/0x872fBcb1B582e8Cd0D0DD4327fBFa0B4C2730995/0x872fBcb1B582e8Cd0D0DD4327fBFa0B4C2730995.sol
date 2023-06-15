// SPDX-License-Identifier: LGPL-3.0-or-later

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeMath.sol";
import "aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "aave/core-v3/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol";
import "aave/core-v3/contracts/interfaces/IERC20WithPermit.sol";
import "aave/core-v3/contracts/interfaces/IPool.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/interfaces/IPriceOracleGetter.sol";
import "aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol";
import "aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import "aave/periphery-v3/contracts/adapters/paraswap/BaseParaSwapAdapter.sol";
import "aave/periphery-v3/contracts/adapters/paraswap/BaseParaSwapSellAdapter.sol";
import "aave/periphery-v3/contracts/adapters/paraswap/ParaSwapLiquiditySwapAdapter.sol";
import "aave/periphery-v3/contracts/adapters/paraswap/interfaces/IParaSwapAugustus.sol";
import "aave/periphery-v3/contracts/adapters/paraswap/interfaces/IParaSwapAugustusRegistry.sol";
import "aave/periphery-v3/contracts/dependencies/openzeppelin/ReentrancyGuard.sol";
