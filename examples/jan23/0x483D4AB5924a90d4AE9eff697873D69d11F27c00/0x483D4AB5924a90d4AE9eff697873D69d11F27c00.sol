// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/AccessControl.sol";
import "openzeppelin/contracts/access/IAccessControl.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/proxy/utils/Initializable.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "openzeppelin/contracts/utils/introspection/ERC165.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/utils/math/Math.sol";
import "sismo-core/hydra-s1/contracts/HydraS1Verifier.sol";
import "contracts/attesters/hydra-s1/HydraS1AccountboundAttester.sol";
import "contracts/attesters/hydra-s1/HydraS1SimpleAttester.sol";
import "contracts/attesters/hydra-s1/base/HydraS1Base.sol";
import "contracts/attesters/hydra-s1/base/IHydraS1Base.sol";
import "contracts/attesters/hydra-s1/interfaces/IHydraS1AccountboundAttester.sol";
import "contracts/attesters/hydra-s1/interfaces/IHydraS1SimpleAttester.sol";
import "contracts/attesters/hydra-s1/libs/HydraS1Lib.sol";
import "contracts/core/AttestationsRegistry.sol";
import "contracts/core/Attester.sol";
import "contracts/core/Badges.sol";
import "contracts/core/Front.sol";
import "contracts/core/interfaces/IAttestationsRegistry.sol";
import "contracts/core/interfaces/IAttestationsRegistryConfigLogic.sol";
import "contracts/core/interfaces/IAttester.sol";
import "contracts/core/interfaces/IBadges.sol";
import "contracts/core/interfaces/IFront.sol";
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
import "contracts/core/utils/AddressesProvider.sol";
import "contracts/core/utils/interfaces/IAddressesProvider.sol";
import "contracts/periphery/utils/AvailableRootsRegistry.sol";
import "contracts/periphery/utils/CommitmentMapperRegistry.sol";
import "contracts/periphery/utils/interfaces/IAvailableRootsRegistry.sol";
import "contracts/periphery/utils/interfaces/ICommitmentMapperRegistry.sol";
