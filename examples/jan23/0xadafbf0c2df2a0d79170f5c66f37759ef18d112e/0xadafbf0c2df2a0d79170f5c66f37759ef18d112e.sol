// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "capies.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721ABurnable.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721AQueryable.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721ABurnable.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol";
