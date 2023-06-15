// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "contracts/WarriorERC721.sol";
import "contracts/interfaces/IERC165.sol";
import "contracts/interfaces/IERC721.sol";
import "contracts/interfaces/IERC721Metadata.sol";
import "contracts/interfaces/IERC721Receiver.sol";
import "contracts/interfaces/IWeedERC20.sol";
import "contracts/libraries/Address.sol";
import "contracts/libraries/Counters.sol";
import "contracts/libraries/Strings.sol";
import "contracts/types/Context.sol";
import "contracts/types/ERC165.sol";
import "contracts/types/ERC721.sol";
import "contracts/types/ERC721Burnable.sol";
import "contracts/types/Ownable.sol";
import "contracts/types/OwnerOrAdmin.sol";
import "contracts/types/WeedWarsERC721.sol";
