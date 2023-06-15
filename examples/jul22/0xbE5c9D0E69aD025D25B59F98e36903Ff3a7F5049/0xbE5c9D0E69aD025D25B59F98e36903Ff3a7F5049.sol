// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "solidstate/contracts/token/ERC1155/metadata/ERC1155Metadata.sol";
import "solidstate/contracts/token/ERC1155/metadata/ERC1155MetadataInternal.sol";
import "solidstate/contracts/token/ERC1155/metadata/ERC1155MetadataStorage.sol";
import "solidstate/contracts/token/ERC1155/metadata/IERC1155Metadata.sol";
import "solidstate/contracts/token/ERC1155/metadata/IERC1155MetadataInternal.sol";
import "solidstate/contracts/token/ERC721/IERC721Internal.sol";
import "solidstate/contracts/token/ERC721/metadata/IERC721Metadata.sol";
import "solidstate/contracts/utils/UintUtils.sol";
import "contracts/land/LandMetadata.sol";
import "contracts/land/LandStorage.sol";
import "contracts/land/LandTypes.sol";
import "contracts/libraries/Base64.sol";
import "contracts/vendor/ERC2981/ERC2981Base.sol";
import "contracts/vendor/ERC2981/ERC2981Storage.sol";
import "contracts/vendor/ERC2981/IERC2981Royalties.sol";
import "contracts/vendor/OpenSea/IOpenSeaCompatible.sol";
import "contracts/vendor/OpenSea/OpenSeaCompatible.sol";
