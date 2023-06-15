// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/tokenStaking/FeeSharingSystem.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "contracts/tokenStaking/TokenDistributor.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "contracts/interfaces/ILooksRareToken.sol";
