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
import "gnosis.pm/safe-contracts/contracts/handler/DefaultCallbackHandler.sol";
import "gnosis.pm/safe-contracts/contracts/interfaces/ERC1155TokenReceiver.sol";
import "gnosis.pm/safe-contracts/contracts/interfaces/ERC721TokenReceiver.sol";
import "gnosis.pm/safe-contracts/contracts/interfaces/ERC777TokensRecipient.sol";
import "gnosis.pm/safe-contracts/contracts/interfaces/IERC165.sol";
import "gnosis.pm/safe-contracts/contracts/interfaces/ISignatureValidator.sol";
import "gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxy.sol";
import "gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol";
import "gnosis.pm/safe-contracts/contracts/proxies/IProxyCreationCallback.sol";
import "openzeppelin/contracts/utils/Create2.sol";
import "contracts/zerodev/ZeroDevGnosisAccountFactory.sol";
