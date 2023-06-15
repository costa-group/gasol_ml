// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/dependencies/openzeppelin/access/Ownable.sol";
import "contracts/dependencies/openzeppelin/proxy/ERC1967/ERC1967Proxy.sol";
import "contracts/dependencies/openzeppelin/proxy/ERC1967/ERC1967Upgrade.sol";
import "contracts/dependencies/openzeppelin/proxy/Proxy.sol";
import "contracts/dependencies/openzeppelin/proxy/beacon/IBeacon.sol";
import "contracts/dependencies/openzeppelin/proxy/transparent/ProxyAdmin.sol";
import "contracts/dependencies/openzeppelin/proxy/transparent/TransparentUpgradeableProxy.sol";
import "contracts/dependencies/openzeppelin/utils/Address.sol";
import "contracts/dependencies/openzeppelin/utils/Context.sol";
import "contracts/dependencies/openzeppelin/utils/StorageSlot.sol";
import "contracts/interface/external/IMulticall.sol";
import "contracts/upgraders/RewardsUpgrader.sol";
import "contracts/upgraders/UpgraderBase.sol";
