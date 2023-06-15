// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "arrakisfi/v2-core/contracts/interfaces/IArrakisV2.sol";
import "arrakisfi/v2-core/contracts/interfaces/IArrakisV2Beacon.sol";
import "arrakisfi/v2-core/contracts/interfaces/IArrakisV2Factory.sol";
import "arrakisfi/v2-core/contracts/interfaces/IArrakisV2Resolver.sol";
import "arrakisfi/v2-core/contracts/structs/SArrakisV2.sol";
import "arrakisfi/v3-lib-0.8/contracts/FullMath.sol";
import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolActions.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolDerivedState.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolEvents.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolImmutables.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolOwnerActions.sol";
import "uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol";
import "contracts/PALMTerms.sol";
import "contracts/abstracts/PALMTermsStorage.sol";
import "contracts/functions/FPALMTerms.sol";
import "contracts/interfaces/IArrakisV2Extended.sol";
import "contracts/interfaces/IPALMManager.sol";
import "contracts/interfaces/IPALMTerms.sol";
import "contracts/structs/SPALMManager.sol";
import "contracts/structs/SPALMTerms.sol";
