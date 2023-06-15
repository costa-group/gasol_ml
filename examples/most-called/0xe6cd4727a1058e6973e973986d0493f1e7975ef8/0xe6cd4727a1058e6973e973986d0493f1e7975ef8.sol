// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "contracts/UpgradableProxy.sol";
import "openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "openzeppelin/contracts/proxy/Proxy.sol";
import "openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol";
import "openzeppelin/contracts/proxy/beacon/IBeacon.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/StorageSlot.sol";
