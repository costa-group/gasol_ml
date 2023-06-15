// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/core/AttestationsRegistry.sol";
import "contracts/core/interfaces/IAttestationsRegistry.sol";
import "contracts/core/interfaces/IAttestationsRegistryConfigLogic.sol";
import "contracts/core/interfaces/IBadges.sol";
import "contracts/core/libs/Structs.sol";
import "contracts/core/libs/attestations-registry/AttestationsRegistryConfigLogic.sol";
import "contracts/core/libs/attestations-registry/AttestationsRegistryState.sol";
import "contracts/core/libs/attestations-registry/InitializableLogic.sol";
import "contracts/core/libs/attestations-registry/OwnableLogic.sol";
import "contracts/core/libs/attestations-registry/PausableLogic.sol";
import "contracts/core/libs/utils/Address.sol";
import "contracts/core/libs/utils/Bitmap256Bit.sol";
import "contracts/core/libs/utils/Context.sol";
import "contracts/core/libs/utils/RangeLib.sol";
