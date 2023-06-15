// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts/GSN/Context.sol";
import "openzeppelin/contracts/math/SafeMath.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "contracts/Pausable.sol";
import "contracts/interfaces/bloq/ISwapManager.sol";
import "contracts/interfaces/uniswap/IUniswapV2Router01.sol";
import "contracts/interfaces/uniswap/IUniswapV2Router02.sol";
import "contracts/interfaces/vesper/IController.sol";
import "contracts/interfaces/vesper/IPoolRewardsV4.sol";
import "contracts/interfaces/vesper/IStrategy.sol";
import "contracts/interfaces/vesper/IStrategyV4.sol";
import "contracts/interfaces/vesper/IVesperPool.sol";
import "contracts/interfaces/vesper/IVesperPoolV5.sol";
import "contracts/strategies/Strategy.sol";
import "contracts/strategies/VesperBridgeStrategy.sol";
