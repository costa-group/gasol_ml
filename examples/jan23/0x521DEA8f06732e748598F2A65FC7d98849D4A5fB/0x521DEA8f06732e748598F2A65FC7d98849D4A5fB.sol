// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "contracts/MultiSend.sol";
import "contracts/dependencies/uniswap/lib/libraries/Babylonian.sol";
import "contracts/dependencies/uniswap/lib/libraries/FullMath.sol";
import "contracts/dependencies/uniswap/v2-core/interfaces/IUniswapV2Factory.sol";
import "contracts/dependencies/uniswap/v2-core/interfaces/IUniswapV2Pair.sol";
import "contracts/dependencies/uniswap/v2-periphery/libraries/SafeMath.sol";
import "contracts/dependencies/uniswap/v2-periphery/libraries/UniswapV2Library.sol";
import "contracts/dependencies/uniswap/v2-periphery/libraries/UniswapV2LiquidityMathLibrary.sol";
import "contracts/interfaces/external/aave/IAave.sol";
import "contracts/interfaces/external/uniswap-v2/IUniswapV2Callee.sol";
import "contracts/utils/TokenHolder.sol";
