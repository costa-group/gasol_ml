// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts/interfaces/draft-IERC1822.sol";
import "openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol";
import "openzeppelin/contracts/proxy/Proxy.sol";
import "openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "openzeppelin/contracts/proxy/beacon/IBeacon.sol";
import "openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/StorageSlot.sol";
import "openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolActions.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolDerivedState.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolEvents.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolImmutables.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolOwnerActions.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol";
import "contracts/ArrakisV2Factory.sol";
import "contracts/abstract/ArrakisV2FactoryStorage.sol";
import "contracts/functions/FArrakisV2Factory.sol";
import "contracts/interfaces/IArrakisV2.sol";
import "contracts/interfaces/IArrakisV2Beacon.sol";
import "contracts/interfaces/IArrakisV2Factory.sol";
import "contracts/interfaces/ITransparentUpgradeableProxy.sol";
import "contracts/structs/SArrakisV2.sol";
