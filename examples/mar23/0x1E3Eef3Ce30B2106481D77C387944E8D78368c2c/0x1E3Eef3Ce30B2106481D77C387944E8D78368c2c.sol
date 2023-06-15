// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity ^0.8.0;

import "gnosis.pm/safe-contracts/contracts/GnosisSafe.sol";
import "gnosis.pm/safe-contracts/contracts/base/Executor.sol";
import "gnosis.pm/safe-contracts/contracts/base/FallbackManager.sol";
import "gnosis.pm/safe-contracts/contracts/base/GuardManager.sol";
import "gnosis.pm/safe-contracts/contracts/base/ModuleManager.sol";
import "gnosis.pm/safe-contracts/contracts/base/OwnerManager.sol";
import "gnosis.pm/safe-contracts/contracts/common/Enum.sol";
import "gnosis.pm/safe-contracts/contracts/common/EtherPaymentFallback.sol";
import "gnosis.pm/safe-contracts/contracts/common/SecuredTokenTransfer.sol";
import "gnosis.pm/safe-contracts/contracts/common/SelfAuthorized.sol";
import "gnosis.pm/safe-contracts/contracts/common/SignatureDecoder.sol";
import "gnosis.pm/safe-contracts/contracts/common/Singleton.sol";
import "gnosis.pm/safe-contracts/contracts/common/StorageAccessible.sol";
import "gnosis.pm/safe-contracts/contracts/external/GnosisSafeMath.sol";
import "gnosis.pm/safe-contracts/contracts/interfaces/ISignatureValidator.sol";
import "openzeppelin/contracts/utils/Create2.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "contracts/core/Helpers.sol";
import "contracts/interfaces/IAccount.sol";
import "contracts/interfaces/UserOperation.sol";
import "contracts/utils/Exec.sol";
import "contracts/zerodev/ZeroDevPluginSafe.sol";
import "contracts/zerodev/plugin/IPlugin.sol";
import "contracts/zerodev/plugin/policy/FunctionSignaturePolicy.sol";
import "contracts/zerodev/plugin/policy/FunctionSignaturePolicyFactory.sol";
import "contracts/zerodev/plugin/policy/IPolicy.sol";
