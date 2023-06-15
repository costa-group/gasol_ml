// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol";
import "aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol";
import "aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave/core-v3/contracts/protocol/configuration/PoolAddressesProvider.sol";
import "aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol";
import "aave/core-v3/contracts/protocol/libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol";
