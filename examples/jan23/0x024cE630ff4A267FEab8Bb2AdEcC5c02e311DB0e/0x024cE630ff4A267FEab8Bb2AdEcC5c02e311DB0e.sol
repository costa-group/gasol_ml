// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "contracts/interfaces/external/curve/ICurveAddressProvider.sol";
import "contracts/interfaces/external/curve/ICurveSwaps.sol";
import "contracts/interfaces/swapper/IExchange.sol";
import "contracts/swapper/CurveExchange.sol";
