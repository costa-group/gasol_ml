// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/interfaces/draft-IERC1822Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/beacon/IBeaconUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/StorageSlotUpgradeable.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "contracts/DistributionCreator.sol";
import "contracts/interfaces/external/uniswap/IUniswapV3Pool.sol";
import "contracts/interfaces/ICore.sol";
import "contracts/struct/DistributionParameters.sol";
import "contracts/struct/ExtensiveDistributionParameters.sol";
import "contracts/struct/RewardTokenAmounts.sol";
import "contracts/utils/Errors.sol";
import "contracts/utils/UUPSHelper.sol";
