// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "solc_0.8/openzeppelin/interfaces/draft-IERC1822.sol";
import "solc_0.8/openzeppelin/proxy/ERC1967/ERC1967Proxy.sol";
import "solc_0.8/openzeppelin/proxy/ERC1967/ERC1967Upgrade.sol";
import "solc_0.8/openzeppelin/proxy/Proxy.sol";
import "solc_0.8/openzeppelin/proxy/beacon/IBeacon.sol";
import "solc_0.8/openzeppelin/utils/Address.sol";
import "solc_0.8/openzeppelin/utils/StorageSlot.sol";
import "solc_0.8/proxy/OptimizedTransparentUpgradeableProxy.sol";
