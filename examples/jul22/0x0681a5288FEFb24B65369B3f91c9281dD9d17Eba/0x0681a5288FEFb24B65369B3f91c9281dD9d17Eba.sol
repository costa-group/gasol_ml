// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/proxy/utils/Initializable.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC721/IERC721.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/ERC165Storage.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "contracts/streams/ERC721/base/ERC721MultiTokenStream.sol";
import "contracts/streams/ERC721/extensions/ERC721InstantReleaseExtension.sol";
import "contracts/streams/ERC721/extensions/ERC721ShareSplitExtension.sol";
import "contracts/streams/ERC721/presets/ERC721ShareInstantStream.sol";
