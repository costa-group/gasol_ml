// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "contracts/presets/contracts/ERC777MintableToken.sol";
import "contracts/presets/interfaces/ISignedTokenFeeTransfer.sol";
import "contracts/presets/interfaces/IOperatorTransferAnyERC20Token.sol";
import "contracts/presets/interfaces/IOperatorMint.sol";
import "contracts/presets/interfaces/IERC777OperatorBatchFunctions.sol";
import "contracts/presets/interfaces/IERC777BatchBalanceOf.sol";
import "contracts/presets/interfaces/ICirculatingSupply.sol";
import "openzeppelin/contracts/utils/math/SafeMath.sol";
import "openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";
import "openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
import "openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "openzeppelin/contracts/token/ERC777/IERC777.sol";
import "openzeppelin/contracts/token/ERC777/ERC777.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/interfaces/IERC3156FlashLender.sol";
import "openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "openzeppelin/contracts/interfaces/IERC3156.sol";
import "openzeppelin/contracts/access/Ownable.sol";
