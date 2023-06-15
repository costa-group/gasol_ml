// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "contracts/messaging/MerkleTreeManager.sol";
import "contracts/messaging/libraries/MerkleLib.sol";
import "contracts/shared/ProposedOwnable.sol";
import "contracts/shared/ProposedOwnableUpgradeable.sol";
import "contracts/shared/interfaces/IProposedOwnable.sol";
