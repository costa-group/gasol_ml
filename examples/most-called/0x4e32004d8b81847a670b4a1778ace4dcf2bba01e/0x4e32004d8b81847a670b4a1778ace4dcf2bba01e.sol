// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/manifold/lazyclaim/ERC1155LazyPayableClaim.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/IERC1155CreatorCore.sol";
import "manifoldxyz/libraries-solidity/contracts/access/AdminControl.sol";
import "manifoldxyz/creator-core-solidity/contracts/extensions/ICreatorExtensionTokenURI.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "openzeppelin/contracts/interfaces/IERC165.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "contracts/manifold/lazyclaim/IERC1155LazyPayableClaim.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/CreatorCore.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "manifoldxyz/creator-core-solidity/contracts/core/ICreatorCore.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "manifoldxyz/libraries-solidity/contracts/access/IAdminControl.sol";
import "openzeppelin/contracts/utils/Context.sol";
