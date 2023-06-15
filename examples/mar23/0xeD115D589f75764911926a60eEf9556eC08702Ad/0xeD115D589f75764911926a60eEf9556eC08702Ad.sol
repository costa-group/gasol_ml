// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "1inch/erc20-pods/contracts/ERC20Pods.sol";
import "1inch/erc20-pods/contracts/interfaces/IERC20Pods.sol";
import "1inch/erc20-pods/contracts/interfaces/IPod.sol";
import "1inch/erc20-pods/contracts/libs/ReentrancyGuard.sol";
import "1inch/erc20-pods/contracts/mocks/ERC20PodsMock.sol";
import "1inch/erc20-pods/contracts/Pod.sol";
import "1inch/farming/contracts/accounting/FarmAccounting.sol";
import "1inch/farming/contracts/accounting/UserAccounting.sol";
import "1inch/farming/contracts/FarmingLib.sol";
import "1inch/farming/contracts/interfaces/IMultiFarmingPod.sol";
import "1inch/farming/contracts/MultiFarmingPod.sol";
import "1inch/solidity-utils/contracts/interfaces/IDaiLikePermit.sol";
import "1inch/solidity-utils/contracts/libraries/AddressArray.sol";
import "1inch/solidity-utils/contracts/libraries/AddressSet.sol";
import "1inch/solidity-utils/contracts/libraries/RevertReasonForwarder.sol";
import "1inch/solidity-utils/contracts/libraries/SafeERC20.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "contracts/DelegatedShare.sol";
import "contracts/DelegationPod.sol";
import "contracts/FarmingDelegationPod.sol";
import "contracts/hardhat-dependency-compiler/1inch/erc20-pods/contracts/mocks/ERC20PodsMock.sol";
import "contracts/interfaces/IDelegatedShare.sol";
import "contracts/interfaces/IDelegationPod.sol";
import "contracts/interfaces/IFarmingDelegationPod.sol";
import "contracts/interfaces/ITokenizedDelegationPod.sol";
import "contracts/TokenizedDelegationPod.sol";
