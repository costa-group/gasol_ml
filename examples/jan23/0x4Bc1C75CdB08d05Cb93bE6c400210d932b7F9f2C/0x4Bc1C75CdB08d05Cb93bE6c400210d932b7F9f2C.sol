// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/proxy/utils/Initializable.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "sismo-core/hydra-s1/contracts/HydraS1Verifier.sol";
import "contracts/attesters/hydra-s1/HydraS1AccountboundAttester.sol";
import "contracts/attesters/hydra-s1/HydraS1SimpleAttester.sol";
import "contracts/attesters/hydra-s1/base/HydraS1Base.sol";
import "contracts/attesters/hydra-s1/base/IHydraS1Base.sol";
import "contracts/attesters/hydra-s1/interfaces/IHydraS1AccountboundAttester.sol";
import "contracts/attesters/hydra-s1/interfaces/IHydraS1SimpleAttester.sol";
import "contracts/attesters/hydra-s1/libs/HydraS1Lib.sol";
import "contracts/core/Attester.sol";
import "contracts/core/interfaces/IAttestationsRegistry.sol";
import "contracts/core/interfaces/IAttestationsRegistryConfigLogic.sol";
import "contracts/core/interfaces/IAttester.sol";
import "contracts/core/libs/Structs.sol";
import "contracts/core/libs/utils/RangeLib.sol";
import "contracts/periphery/utils/AvailableRootsRegistry.sol";
import "contracts/periphery/utils/CommitmentMapperRegistry.sol";
import "contracts/periphery/utils/interfaces/IAvailableRootsRegistry.sol";
import "contracts/periphery/utils/interfaces/ICommitmentMapperRegistry.sol";
