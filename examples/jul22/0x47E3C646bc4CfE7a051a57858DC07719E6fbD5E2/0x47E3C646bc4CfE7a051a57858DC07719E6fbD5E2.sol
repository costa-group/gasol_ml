// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts/access/AccessControl.sol";
import "openzeppelin/contracts/cryptography/ECDSA.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/EnumerableSet.sol";
import "uniswap/lib/contracts/libraries/Babylonian.sol";
import "uniswap/lib/contracts/libraries/BitMath.sol";
import "uniswap/lib/contracts/libraries/FixedPoint.sol";
import "uniswap/lib/contracts/libraries/FullMath.sol";
import "uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import "uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "uniswap/v2-periphery/contracts/interfaces/IWETH.sol";
import "uniswap/v2-periphery/contracts/libraries/SafeMath.sol";
import "uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol";
import "uniswap/v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol";
import "contracts/LPMatch.sol";
