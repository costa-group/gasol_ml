// SPDX-License-Identifier: BlueOak-1.0.0

pragma solidity ^0.8.4;

import "contracts/RSR.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "contracts/Enchantable.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "contracts/Spell.sol";
