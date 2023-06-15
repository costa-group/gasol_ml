// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "contracts/adapters/SynthAdapter.sol";
import "contracts/interfaces/ISynthAdapter.sol";
import "contracts/interfaces/external/IWETH.sol";
import "contracts/interfaces/external/one-oracle/IMasterOracle.sol";
import "contracts/interfaces/external/synth/IDebtToken.sol";
import "contracts/interfaces/external/synth/IDepositToken.sol";
import "contracts/interfaces/external/synth/IGovernable.sol";
import "contracts/interfaces/external/synth/IPool.sol";
import "contracts/interfaces/external/synth/IPoolRegistry.sol";
import "contracts/interfaces/external/synth/ISyntheticToken.sol";
import "contracts/lib/WadRayMath.sol";
