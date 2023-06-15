// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "contracts/StakingRewards.sol";
import "contracts/StakingRewardsFactory.sol";
import "contracts/interfaces/ITokenInterface.sol";
import "contracts/interfaces/StakingRewardsFactoryInterface.sol";
import "contracts/interfaces/StakingRewardsInterface.sol";
