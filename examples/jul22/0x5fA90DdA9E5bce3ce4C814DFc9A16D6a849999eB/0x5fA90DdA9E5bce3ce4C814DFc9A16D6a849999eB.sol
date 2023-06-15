// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import "contracts/FastWithdraw.sol";
import "contracts/external/openzeppelin/security/ReentrancyGuard.sol";
import "contracts/external/openzeppelin/token/ERC20/IERC20.sol";
import "contracts/external/openzeppelin/token/ERC20/utils/SafeERC20.sol";
import "contracts/external/openzeppelin/utils/Address.sol";
import "contracts/interfaces/IController.sol";
import "contracts/interfaces/IFastWithdraw.sol";
import "contracts/interfaces/ISpool.sol";
import "contracts/interfaces/ISwapData.sol";
import "contracts/interfaces/IVault.sol";
import "contracts/interfaces/spool/ISpoolBase.sol";
import "contracts/interfaces/spool/ISpoolDoHardWork.sol";
import "contracts/interfaces/spool/ISpoolExternal.sol";
import "contracts/interfaces/spool/ISpoolReallocation.sol";
import "contracts/interfaces/spool/ISpoolStrategy.sol";
import "contracts/interfaces/vault/IRewardDrip.sol";
import "contracts/interfaces/vault/IVaultBase.sol";
import "contracts/interfaces/vault/IVaultDetails.sol";
import "contracts/interfaces/vault/IVaultImmutable.sol";
import "contracts/interfaces/vault/IVaultIndexActions.sol";
import "contracts/interfaces/vault/IVaultRestricted.sol";
import "contracts/shared/SpoolPausable.sol";
import "hardhat/console.sol";
