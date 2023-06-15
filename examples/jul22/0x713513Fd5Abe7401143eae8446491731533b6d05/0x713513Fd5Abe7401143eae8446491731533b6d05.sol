// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "contracts/external/AccessControlAngleUpgradeable.sol";
import "contracts/external/ComputePower.sol";
import "contracts/interfaces/IAccessControlAngle.sol";
import "contracts/interfaces/IGenericLender.sol";
import "contracts/interfaces/IPoolManager.sol";
import "contracts/interfaces/IStrategy.sol";
import "contracts/interfaces/external/euler/IEuler.sol";
import "contracts/strategies/OptimizerAPR/genericLender/GenericEuler.sol";
import "contracts/strategies/OptimizerAPR/genericLender/GenericLenderBaseUpgradeable.sol";
