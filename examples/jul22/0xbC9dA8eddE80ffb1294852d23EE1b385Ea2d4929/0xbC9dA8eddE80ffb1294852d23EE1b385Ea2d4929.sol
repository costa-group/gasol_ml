// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts/math/SafeMath.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "contracts/release/extensions/fee-manager/IFee.sol";
import "contracts/release/extensions/fee-manager/IFeeManager.sol";
import "contracts/release/extensions/fee-manager/fees/MinSharesSupplyFee.sol";
import "contracts/release/extensions/fee-manager/fees/utils/FeeBase.sol";
