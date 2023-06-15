// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/OFTWrapper.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "layerzerolabs/solidity-examples/contracts/token/oft/IOFTCore.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "layerzerolabs/solidity-examples/contracts/token/oft/v2/ICommonOFT.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "layerzerolabs/solidity-examples/contracts/token/oft/v2/IOFTV2.sol";
import "layerzerolabs/solidity-examples/contracts/token/oft/v2/fee/IOFTWithFee.sol";
import "layerzerolabs/solidity-examples/contracts/token/oft/IOFT.sol";
import "contracts/interfaces/IOFTWrapper.sol";
