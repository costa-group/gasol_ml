// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.14;

import "openzeppelin/contracts/access/Ownable.sol";
import "../settings/SettingRulesConfigurable.sol";
import "../settings/SettingsV1.sol";

// Oracle settings
//
// Pluggable contract which implements setting changes and can be evolved to new contracts
//
contract AuthoritySettingValidatorV1 is Ownable, SettingRulesConfigurable {
  // Constructor stub

  // -- don't accept raw ether
  receive() external payable {
    revert('unsupported');
  }

  // -- reject any other function
  fallback() external payable {
    revert('unsupported');
  }
}
