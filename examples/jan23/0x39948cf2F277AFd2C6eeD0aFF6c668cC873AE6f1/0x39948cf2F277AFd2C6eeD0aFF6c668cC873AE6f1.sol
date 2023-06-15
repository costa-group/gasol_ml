// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "contracts/adapters/AaveAdapter.sol";
import "contracts/interfaces/IAaveAdapter.sol";
import "contracts/interfaces/external/IWETH.sol";
import "contracts/interfaces/external/aave/IAave.sol";
