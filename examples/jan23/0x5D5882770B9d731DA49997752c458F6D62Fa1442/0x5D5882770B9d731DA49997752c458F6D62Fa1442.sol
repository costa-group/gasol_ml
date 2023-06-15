// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/LilPudgysProxyONFT.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "layerzerolabs/solidity-examples/contracts/interfaces/ILayerZeroReceiver.sol";
import "layerzerolabs/solidity-examples/contracts/interfaces/ILayerZeroUserApplicationConfig.sol";
import "layerzerolabs/solidity-examples/contracts/interfaces/ILayerZeroEndpoint.sol";
import "layerzerolabs/solidity-examples/contracts/util/BytesLib.sol";
import "layerzerolabs/solidity-examples/contracts/lzApp/LzApp.sol";
import "layerzerolabs/solidity-examples/contracts/util/ExcessivelySafeCall.sol";
import "layerzerolabs/solidity-examples/contracts/token/onft/IONFT721Core.sol";
import "layerzerolabs/solidity-examples/contracts/lzApp/NonblockingLzApp.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/token/ERC721/IERC721.sol";
import "openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "layerzerolabs/solidity-examples/contracts/token/onft/ONFT721Core.sol";
import "layerzerolabs/solidity-examples/contracts/token/onft/extension/ProxyONFT721.sol";
