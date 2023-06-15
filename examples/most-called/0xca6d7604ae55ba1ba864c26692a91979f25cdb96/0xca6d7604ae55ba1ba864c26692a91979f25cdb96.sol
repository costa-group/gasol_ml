// SPDX-License-Identifier: Unliscensed

pragma solidity ^0.8.17;

import "contracts/DailyCargoProxy.sol";
import "openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol";
import "openzeppelin/contracts/proxy/Proxy.sol";
import "openzeppelin/contracts/utils/StorageSlot.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/interfaces/draft-IERC1822.sol";
import "openzeppelin/contracts/proxy/beacon/IBeacon.sol";
