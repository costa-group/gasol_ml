// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC20/ERC20BurnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "openzeppelin/contracts/math/SafeMath.sol";
import "openzeppelin/contracts/proxy/Clones.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "contracts/AmplificationUtils.sol";
import "contracts/LPToken.sol";
import "contracts/MathUtils.sol";
import "contracts/OwnerPausableUpgradeable.sol";
import "contracts/Swap.sol";
import "contracts/SwapFlashLoan.sol";
import "contracts/SwapUtils.sol";
import "contracts/interfaces/IAllowlist.sol";
import "contracts/interfaces/IFlashLoanReceiver.sol";
import "contracts/interfaces/ISwap.sol";
