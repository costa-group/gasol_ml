//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/erc721MicDoll/MicDoll.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "operator-filter-registry/src/DefaultOperatorFilterer.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "contracts/erc721MicDoll/ContextMicDoll.sol";
import "operator-filter-registry/src/OperatorFilterer.sol";
import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/IERC721AQueryable.sol";
import "contracts/Registry.sol";
import "contracts/IConfig.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "operator-filter-registry/src/IOperatorFilterRegistry.sol";
import "erc721a/contracts/IERC721A.sol";
