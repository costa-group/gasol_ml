// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/AccessControl.sol";
import "openzeppelin/contracts/access/IAccessControl.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/interfaces/IERC165.sol";
import "openzeppelin/contracts/interfaces/IERC2981.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/token/ERC721/IERC721.sol";
import "openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "openzeppelin/contracts/token/common/ERC2981.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "contracts/VVNeonIdol.sol";
import "contracts/access/AdminControl.sol";
import "contracts/access/IAdminControl.sol";
import "contracts/token/ERC721Optimized/ERC721.sol";
import "contracts/token/ERC721Optimized/ERC721Enumerable.sol";
