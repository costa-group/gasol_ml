// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

import "./contracts/metagov/VlAuraDelegatorPCVDeposit.sol";
import "./contracts/core/TribeRoles.sol";
import "./contracts/metagov/DelegatorPCVDeposit.sol";
import "./contracts/pcv/PCVDeposit.sol";
import "./contracts/refs/CoreRef.sol";
import "./contracts/refs/ICoreRef.sol";
import "./contracts/core/ICore.sol";
import "./contracts/core/IPermissions.sol";
import "./contracts/core/IPermissionsRead.sol";
import "./contracts/fei/IFei.sol";
import "./contracts/pcv/IPCVDeposit.sol";
import "./contracts/pcv/IPCVDepositBalances.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "openzeppelin/contracts/governance/utils/IVotes.sol";
import "openzeppelin/contracts/utils/math/SafeCast.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/access/AccessControl.sol";
import "openzeppelin/contracts/access/IAccessControl.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
