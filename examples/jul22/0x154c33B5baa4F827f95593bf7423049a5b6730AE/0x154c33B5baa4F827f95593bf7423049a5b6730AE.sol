// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/math/SafeMath.sol";
import "contracts/bridges/cbridge/RangoCBridgeModels.sol";
import "contracts/bridges/multichain/RangoMultichainModels.sol";
import "contracts/libs/BaseProxyContract.sol";
import "contracts/rango/RangoV1.sol";
import "contracts/rango/bridges/cbridge/IRangoCBridge.sol";
import "contracts/rango/bridges/cbridge/RangoCBridgeProxy.sol";
import "contracts/rango/bridges/multichain/IRangoMultichain.sol";
import "contracts/rango/bridges/multichain/RangoMultichainProxy.sol";
import "contracts/rango/bridges/thorchain/IRangoThorchain.sol";
import "contracts/rango/bridges/thorchain/RangoThorchainProxy.sol";
import "interfaces/IThorchainRouter.sol";
import "interfaces/IWETH.sol";
