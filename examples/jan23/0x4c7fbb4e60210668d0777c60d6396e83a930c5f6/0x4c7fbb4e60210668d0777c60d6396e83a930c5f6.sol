// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "DinoPlanet.sol";
import "openzeppelin/contracts4.8.0/utils/Counters.sol";
import "openzeppelin/contracts4.8.0/access/Ownable.sol";
import "openzeppelin/contracts4.8.0/security/Pausable.sol";
import "openzeppelin/contracts4.8.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin/contracts4.8.0/token/ERC721/ERC721.sol";
import "openzeppelin/contracts4.8.0/token/ERC721/extensions/IERC721Enumerable.sol";
import "openzeppelin/contracts4.8.0/utils/introspection/ERC165.sol";
import "openzeppelin/contracts4.8.0/utils/Strings.sol";
import "openzeppelin/contracts4.8.0/utils/Context.sol";
import "openzeppelin/contracts4.8.0/utils/Address.sol";
import "openzeppelin/contracts4.8.0/token/ERC721/extensions/IERC721Metadata.sol";
import "openzeppelin/contracts4.8.0/token/ERC721/IERC721Receiver.sol";
import "openzeppelin/contracts4.8.0/token/ERC721/IERC721.sol";
import "openzeppelin/contracts4.8.0/utils/introspection/IERC165.sol";
import "openzeppelin/contracts4.8.0/utils/math/Math.sol";
