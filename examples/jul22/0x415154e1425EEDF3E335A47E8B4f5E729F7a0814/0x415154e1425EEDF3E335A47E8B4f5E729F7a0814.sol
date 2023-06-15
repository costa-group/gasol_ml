// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolActions.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolDerivedState.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolEvents.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolImmutables.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolOwnerActions.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol";
import "contracts/ArrakisV1RouterStaking.sol";
import "contracts/interfaces/IArrakisV1RouterBase.sol";
import "contracts/interfaces/IArrakisV1RouterStaking.sol";
import "contracts/interfaces/IArrakisVaultV1.sol";
import "contracts/interfaces/IGauge.sol";
import "contracts/interfaces/IWETH.sol";
