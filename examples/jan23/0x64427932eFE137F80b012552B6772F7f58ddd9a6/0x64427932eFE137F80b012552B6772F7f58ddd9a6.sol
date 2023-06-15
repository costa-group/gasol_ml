// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/IRoyaltyRegistry.sol";
import "contracts/RoyaltyRegistry.sol";
import "contracts/specs/IArtBlocks.sol";
import "contracts/specs/IDigitalax.sol";
import "contracts/specs/IFoundation.sol";
import "contracts/specs/INiftyGateway.sol";
import "lib/libraries-solidity/contracts/access/IAdminControl.sol";
import "lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";
import "lib/openzeppelin-contracts/contracts/utils/introspection/ERC165Checker.sol";
import "lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/IAccessControlUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/utils/AddressUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/utils/ContextUpgradeable.sol";
