// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "contracts/RewardsDistributionRecipient.sol";
import "contracts/StakingRewards.sol";
import "contracts/StakingRewardsFactory.sol";
import "contracts/interfaces/IStakingRewards.sol";
import "openzeppelin-solidity-3.4.0/contracts/access/Ownable.sol";
import "openzeppelin-solidity-3.4.0/contracts/math/Math.sol";
import "openzeppelin-solidity-3.4.0/contracts/math/SafeMath.sol";
import "openzeppelin-solidity-3.4.0/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity-3.4.0/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity-3.4.0/contracts/utils/Address.sol";
import "openzeppelin-solidity-3.4.0/contracts/utils/Context.sol";
import "openzeppelin-solidity-3.4.0/contracts/utils/ReentrancyGuard.sol";
