// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.11;

import "Scientists.sol";
import "interfaces/IRWaste.sol";
import "interfaces/ISpendable.sol";
import "interfaces/IScientists.sol";
import "interfaces/IScales.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/access/AccessControl.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC721/IERC721.sol";
import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/IERC721AQueryable.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/access/IAccessControl.sol";
import "erc721a/contracts/IERC721A.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
