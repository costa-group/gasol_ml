// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "contracts/Stronger.sol";
import "lib/openzeppelin/contracts/4.5.0/access/AccessControl.sol";
import "lib/openzeppelin/contracts/4.5.0/token/ERC20/ERC20.sol";
import "lib/openzeppelin/contracts/4.5.0/token/ERC20/extensions/ERC20Burnable.sol";
import "lib/openzeppelin/contracts/4.5.0/token/ERC20/extensions/draft-ERC20Permit.sol";
import "lib/openzeppelin/contracts/4.5.0/access/IAccessControl.sol";
import "lib/openzeppelin/contracts/4.5.0/utils/Context.sol";
import "lib/openzeppelin/contracts/4.5.0/utils/Strings.sol";
import "lib/openzeppelin/contracts/4.5.0/utils/introspection/ERC165.sol";
import "lib/openzeppelin/contracts/4.5.0/utils/introspection/IERC165.sol";
import "lib/openzeppelin/contracts/4.5.0/token/ERC20/IERC20.sol";
import "lib/openzeppelin/contracts/4.5.0/token/ERC20/extensions/IERC20Metadata.sol";
import "lib/openzeppelin/contracts/4.5.0/token/ERC20/extensions/draft-IERC20Permit.sol";
import "lib/openzeppelin/contracts/4.5.0/utils/cryptography/draft-EIP712.sol";
import "lib/openzeppelin/contracts/4.5.0/utils/cryptography/ECDSA.sol";
import "lib/openzeppelin/contracts/4.5.0/utils/Counters.sol";
