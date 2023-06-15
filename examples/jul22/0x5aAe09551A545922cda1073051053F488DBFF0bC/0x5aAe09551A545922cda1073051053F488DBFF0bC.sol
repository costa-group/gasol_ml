// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "contracts/libraries/TransferHelper.sol";
import "contracts/modules/ERC20.sol";
import "contracts/modules/ERC20Basic.sol";
import "contracts/modules/MadworldTransferProxy.sol";
import "contracts/registry/OwnableDelegateProxy.sol";
import "contracts/registry/ProxyRegistry.sol";
import "contracts/registry/ProxyRegistryInterface.sol";
import "contracts/registry/proxy/OwnedUpgradeabilityProxy.sol";
import "contracts/registry/proxy/OwnedUpgradeabilityStorage.sol";
import "contracts/registry/proxy/Proxy.sol";
