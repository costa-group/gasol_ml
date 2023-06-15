// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "contracts/accumulator/BaseAccumulator.sol";
import "contracts/accumulator/CurveAccumulator.sol";
import "contracts/dao/CurveVoterV2.sol";
import "contracts/external/AccessControlUpgradeable.sol";
import "contracts/interfaces/IAccessControl.sol";
import "contracts/interfaces/IGaugeController.sol";
import "contracts/interfaces/ILiquidityGauge.sol";
import "contracts/interfaces/ILocker.sol";
import "contracts/interfaces/IMasterchef.sol";
import "contracts/interfaces/IMultiRewards.sol";
import "contracts/interfaces/ISDTDistributor.sol";
import "contracts/interfaces/ISdtMiddlemanGauge.sol";
import "contracts/interfaces/IStakingRewards.sol";
import "contracts/staking/MasterchefMasterToken.sol";
import "contracts/staking/SdtDistributorEvents.sol";
import "contracts/staking/SdtDistributorV2.sol";
import "contracts/strategy/BaseStrategy.sol";
import "contracts/strategy/CurveStrategy.sol";
