// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";
import "chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "chainlink/contracts/src/v0.8/interfaces/VRFV2WrapperInterface.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/interfaces/IERC2981.sol";
import "openzeppelin/contracts/token/common/ERC2981.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/IERC721A.sol";
import "operator-filter-registry/src/DefaultOperatorFilterer.sol";
import "operator-filter-registry/src/IOperatorFilterRegistry.sol";
import "operator-filter-registry/src/OperatorFilterer.sol";
import "src/OMNIS.sol";
