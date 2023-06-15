// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.3;

import "Users/Elena/Source/argent-contracts/contracts/infrastructure/IAuthoriser.sol";
import "Users/Elena/Source/argent-contracts/contracts/infrastructure/IModuleRegistry.sol";
import "Users/Elena/Source/argent-contracts/contracts/infrastructure/storage/IGuardianStorage.sol";
import "Users/Elena/Source/argent-contracts/contracts/infrastructure/storage/ITransferStorage.sol";
import "Users/Elena/Source/argent-contracts/contracts/modules/ArgentModule.sol";
import "Users/Elena/Source/argent-contracts/contracts/modules/RelayerManager.sol";
import "Users/Elena/Source/argent-contracts/contracts/modules/SecurityManager.sol";
import "Users/Elena/Source/argent-contracts/contracts/modules/TransactionManager.sol";
import "Users/Elena/Source/argent-contracts/contracts/modules/common/BaseModule.sol";
import "Users/Elena/Source/argent-contracts/contracts/modules/common/IModule.sol";
import "Users/Elena/Source/argent-contracts/contracts/modules/common/SimpleOracle.sol";
import "Users/Elena/Source/argent-contracts/contracts/modules/common/Utils.sol";
import "Users/Elena/Source/argent-contracts/contracts/wallet/IWallet.sol";
import "Users/Elena/Source/argent-contracts/lib_0.5/other/ERC20.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "openzeppelin/contracts/utils/math/SafeCast.sol";
import "uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
