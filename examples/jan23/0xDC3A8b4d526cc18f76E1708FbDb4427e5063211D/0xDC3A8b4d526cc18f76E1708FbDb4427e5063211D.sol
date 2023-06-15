// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import "uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "contracts/DividendTracker.sol";
import "contracts/interfaces/IDividendTracker.sol";
