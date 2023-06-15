//SPDX-License-Identifier: Unlicense

pragma solidity = 0.8.9;

import "contracts/staking/OperatingSystemStaking (3).sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/access/OracleManaged.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/utils/Context.sol";
