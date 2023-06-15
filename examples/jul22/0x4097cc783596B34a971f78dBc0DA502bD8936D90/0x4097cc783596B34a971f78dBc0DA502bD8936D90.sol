// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "GoatChain.sol";
import "ERC20.sol";
import "IERC20.sol";
import "IERC20Metadata.sol";
import "Context.sol";
import "ERC20Burnable.sol";
import "Ownable.sol";
import "ReentrancyGuard.sol";
import "draft-ERC20Permit.sol";
import "draft-IERC20Permit.sol";
import "draft-EIP712.sol";
import "ECDSA.sol";
import "Counters.sol";
import "IUniswapV2Router02.sol";
import "IUniswapV2Router01.sol";
