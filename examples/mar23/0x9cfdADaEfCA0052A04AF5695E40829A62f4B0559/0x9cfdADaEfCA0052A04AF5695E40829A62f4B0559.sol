// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/interfaces/external/curve/ICurvePool.sol";
import "contracts/interfaces/external/curve/IFrxEthStableSwap.sol";
import "contracts/interfaces/external/frax/ISFrxEth.sol";
import "contracts/interfaces/periphery/IOracle.sol";
import "contracts/interfaces/periphery/ITokenOracle.sol";
import "contracts/periphery/tokens/SFraxEthTokenOracle.sol";
