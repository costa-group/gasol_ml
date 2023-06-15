// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts/math/SafeMath.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/SafeCast.sol";
import "contracts/persistent/external-positions/IExternalPosition.sol";
import "contracts/persistent/external-positions/IExternalPositionProxy.sol";
import "contracts/persistent/external-positions/arbitrary-loan/ArbitraryLoanPositionLibBase1.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/ArbitraryLoanPositionDataDecoder.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/ArbitraryLoanPositionLib.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/IArbitraryLoanPosition.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/modules/IArbitraryLoanAccountingModule.sol";
import "contracts/release/interfaces/IWETH.sol";
import "contracts/release/utils/AddressArrayLib.sol";
import "contracts/release/utils/AssetHelpers.sol";
import "contracts/release/utils/MathHelpers.sol";
