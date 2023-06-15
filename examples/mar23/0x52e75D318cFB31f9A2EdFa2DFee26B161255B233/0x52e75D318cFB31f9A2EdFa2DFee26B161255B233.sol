// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/OriginalTokenBridge.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "layerzerolabs/solidity-examples/contracts/interfaces/ILayerZeroReceiver.sol";
import "layerzerolabs/solidity-examples/contracts/interfaces/ILayerZeroUserApplicationConfig.sol";
import "layerzerolabs/solidity-examples/contracts/interfaces/ILayerZeroEndpoint.sol";
import "layerzerolabs/solidity-examples/contracts/util/BytesLib.sol";
import "layerzerolabs/solidity-examples/contracts/lzApp/LzApp.sol";
import "layerzerolabs/solidity-examples/contracts/util/ExcessivelySafeCall.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "layerzerolabs/solidity-examples/contracts/lzApp/NonblockingLzApp.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "layerzerolabs/solidity-examples/contracts/libraries/LzLib.sol";
import "contracts/TokenBridgeBase.sol";
import "contracts/interfaces/IWETH.sol";
