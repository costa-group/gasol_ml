// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/beacon/IBeaconUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/StorageSlotUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "contracts/interfaces/EIP2981Spec.sol";
import "contracts/interfaces/ERC20Spec.sol";
import "contracts/interfaces/ERC721SpecExt.sol";
import "contracts/interfaces/IdentifiableSpec.sol";
import "contracts/interfaces/ImmutableSpec.sol";
import "contracts/interfaces/LandERC721Spec.sol";
import "contracts/lib/LandBlobLib.sol";
import "contracts/lib/LandLib.sol";
import "contracts/lib/SafeERC20.sol";
import "contracts/token/LandERC721.sol";
import "contracts/token/RoyalERC721.sol";
import "contracts/token/UpgradeableERC721.sol";
import "contracts/utils/UpgradeableAccessControl.sol";
