// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "manifoldxyz/royalty-registry-solidity/contracts/overrides/IRoyaltyOverride.sol";
import "manifoldxyz/royalty-registry-solidity/contracts/overrides/RoyaltyOverrideCore.sol";
import "manifoldxyz/royalty-registry-solidity/contracts/specs/IEIP2981.sol";
import "openzeppelin/contracts/access/AccessControl.sol";
import "openzeppelin/contracts/access/IAccessControl.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/proxy/utils/Initializable.sol";
import "openzeppelin/contracts/token/ERC721/ERC721.sol";
import "openzeppelin/contracts/token/ERC721/IERC721.sol";
import "openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/ERC165Storage.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/utils/math/SafeMath.sol";
import "openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "contracts/collections/ERC721/extensions/ERC721AutoIdMinterExtension.sol";
import "contracts/collections/ERC721/extensions/ERC721CollectionMetadataExtension.sol";
import "contracts/collections/ERC721/extensions/ERC721OneOfOneMintExtension.sol";
import "contracts/collections/ERC721/extensions/ERC721OpenSeaNoGasExtension.sol";
import "contracts/collections/ERC721/extensions/ERC721OwnerMintExtension.sol";
import "contracts/collections/ERC721/extensions/ERC721PerTokenMetadataExtension.sol";
import "contracts/collections/ERC721/extensions/ERC721RoyaltyExtension.sol";
import "contracts/collections/ERC721/presets/ERC721OneOfOneCollection.sol";
import "contracts/common/meta-transactions/ERC2771ContextOwnable.sol";
import "contracts/misc/opensea/ProxyRegistry.sol";
import "contracts/misc/rarible/IRoyalties.sol";
import "contracts/misc/rarible/LibPart.sol";
import "contracts/misc/rarible/LibRoyaltiesV2.sol";
