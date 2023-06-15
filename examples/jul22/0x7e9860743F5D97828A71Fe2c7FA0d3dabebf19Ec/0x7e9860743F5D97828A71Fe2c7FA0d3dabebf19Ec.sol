// SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.6;

import "contracts/GaugeUniswapClaim.automate.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/utils/DFH/Automate.sol";
import "contracts/utils/Curve/IRegistry.sol";
import "contracts/utils/Curve/IGauge.sol";
import "contracts/utils/Curve/IMinter.sol";
import "contracts/utils/Curve/IPlainPool.sol";
import "contracts/utils/Curve/IMetaPool.sol";
import "contracts/utils/Uniswap/IUniswapV2Router02.sol";
import "contracts/utils/ERC20Tools.sol";
import "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "contracts/utils/DFH/proxy/ERC1167.sol";
import "contracts/utils/DFH/IStorage.sol";
import "contracts/utils/DFH/IBalance.sol";
import "contracts/GaugeUniswapRestake.automate.sol";
