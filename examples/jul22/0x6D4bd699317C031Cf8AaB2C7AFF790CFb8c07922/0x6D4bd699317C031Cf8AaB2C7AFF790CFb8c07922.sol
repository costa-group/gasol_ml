// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts/math/SafeMath.sol";
import "openzeppelin/contracts/math/SignedSafeMath.sol";
import "contracts/persistent/arbitrary-value-oracles/IArbitraryValueOracle.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/modules/ArbitraryLoanTotalNominalDeltaOracleModule.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/modules/IArbitraryLoanAccountingModule.sol";
