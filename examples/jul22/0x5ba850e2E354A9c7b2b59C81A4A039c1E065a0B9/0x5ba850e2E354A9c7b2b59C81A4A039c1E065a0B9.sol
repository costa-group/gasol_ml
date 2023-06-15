// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "openzeppelin/contracts/math/SafeMath.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "contracts/persistent/address-list-registry/AddressListRegistry.sol";
import "contracts/persistent/dispatcher/IDispatcher.sol";
import "contracts/persistent/external-positions/IExternalPosition.sol";
import "contracts/release/extensions/external-position-manager/external-positions/IExternalPositionParser.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/ArbitraryLoanPositionDataDecoder.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/ArbitraryLoanPositionParser.sol";
import "contracts/release/extensions/external-position-manager/external-positions/arbitrary-loan/IArbitraryLoanPosition.sol";
import "contracts/release/utils/AddressArrayLib.sol";
