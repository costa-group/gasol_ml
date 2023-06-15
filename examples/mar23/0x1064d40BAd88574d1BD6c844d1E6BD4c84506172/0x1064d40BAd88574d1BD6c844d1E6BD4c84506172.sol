// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "contracts/Automate.sol";
import "contracts/AutomateStorage.sol";
import "contracts/functions/FExec.sol";
import "contracts/functions/FUtils.sol";
import "contracts/interfaces/IAutomate.sol";
import "contracts/interfaces/ILegacyAutomate.sol";
import "contracts/interfaces/ITaskModule.sol";
import "contracts/interfaces/ITaskTreasuryUpgradable.sol";
import "contracts/libraries/LibDataTypes.sol";
import "contracts/libraries/LibEvents.sol";
import "contracts/libraries/LibLegacyTask.sol";
import "contracts/libraries/LibTaskId.sol";
import "contracts/libraries/LibTaskModule.sol";
import "contracts/libraries/LibTaskModuleConfig.sol";
import "contracts/vendor/gelato/GelatoBytes.sol";
import "contracts/vendor/gelato/Gelatofied.sol";
import "contracts/vendor/proxy/EIP173/Proxied.sol";
