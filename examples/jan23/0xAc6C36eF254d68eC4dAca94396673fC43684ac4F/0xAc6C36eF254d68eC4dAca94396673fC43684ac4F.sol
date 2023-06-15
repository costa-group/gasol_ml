// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/adapters/UniswapV2Adapter.sol";
import "contracts/dependencies/uniswap/lib/libraries/Babylonian.sol";
import "contracts/dependencies/uniswap/lib/libraries/FullMath.sol";
import "contracts/dependencies/uniswap/v2-core/interfaces/IUniswapV2Factory.sol";
import "contracts/dependencies/uniswap/v2-core/interfaces/IUniswapV2Pair.sol";
import "contracts/dependencies/uniswap/v2-periphery/interfaces/IUniswapV2Router01.sol";
import "contracts/dependencies/uniswap/v2-periphery/interfaces/IUniswapV2Router02.sol";
import "contracts/dependencies/uniswap/v2-periphery/libraries/SafeMath.sol";
import "contracts/dependencies/uniswap/v2-periphery/libraries/UniswapV2Library.sol";
import "contracts/dependencies/uniswap/v2-periphery/libraries/UniswapV2LiquidityMathLibrary.sol";
import "contracts/interfaces/IUniswapV2Adapter.sol";
import "contracts/interfaces/external/IWETH.sol";
