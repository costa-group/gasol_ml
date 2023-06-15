// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/cryptography/MerkleProofUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "BaseRegistrar.sol";
import "BaseRegistrarImplementation.sol";
import "NNSRegistrarController";
import "PriceOracle.sol";
import "SafeMath.sol";
import "StablePriceOracle.sol";
import "StringUtils.sol";
import "registry/NNS.sol";
import "resolvers/Resolver.sol";
