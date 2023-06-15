// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "FairXYZDeployer.sol";
import "ERC721xyzUpgradeable.sol";
import "IERC721Upgradeable.sol";
import "IERC165Upgradeable.sol";
import "IERC721ReceiverUpgradeable.sol";
import "IERC721MetadataUpgradeable.sol";
import "AddressUpgradeable.sol";
import "ContextUpgradeable.sol";
import "Initializable.sol";
import "StringsUpgradeable.sol";
import "MathUpgradeable.sol";
import "ERC165Upgradeable.sol";
import "ERC2981Upgradeable.sol";
import "IERC2981Upgradeable.sol";
import "UpdatableOperatorFiltererUpgradeable.sol";
import "IOperatorFilterRegistry.sol";
import "IFairXYZWallets.sol";
import "ECDSAUpgradeable.sol";
import "AccessControlUpgradeable.sol";
import "IAccessControlUpgradeable.sol";
import "MerkleProofUpgradeable.sol";
import "MulticallUpgradeable.sol";
import "ReentrancyGuardUpgradeable.sol";
import "OwnableUpgradeable.sol";
