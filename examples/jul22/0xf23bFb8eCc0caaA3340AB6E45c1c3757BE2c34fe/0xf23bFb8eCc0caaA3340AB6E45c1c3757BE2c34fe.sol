// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts/math/SafeMath.sol";
import "openzeppelin/contracts/utils/SafeCast.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/modules/ArbitraryLoanFixedInterestModule.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/modules/IArbitraryLoanAccountingModule.sol";
import "contracts/release/utils/MakerDaoMath.sol";
import "contracts/release/utils/MathHelpers.sol";
