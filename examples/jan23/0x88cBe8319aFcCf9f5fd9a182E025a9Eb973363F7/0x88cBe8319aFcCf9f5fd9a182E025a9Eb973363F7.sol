// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/adapters/CurveAdapter.sol";
import "contracts/interfaces/ICurveAdapter.sol";
import "contracts/interfaces/external/IWETH.sol";
import "contracts/interfaces/external/curve/ICurveAddressProvider.sol";
import "contracts/interfaces/external/curve/ICurveFactoryRegistry.sol";
import "contracts/interfaces/external/curve/ICurveSwaps.sol";
