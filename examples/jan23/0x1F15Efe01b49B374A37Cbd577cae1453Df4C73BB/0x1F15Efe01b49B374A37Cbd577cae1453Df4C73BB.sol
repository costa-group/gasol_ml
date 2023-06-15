// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/proxy/utils/Initializable.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "sismo-core/pythia-1/contracts/Pythia1Verifier.sol";
import "contracts/attesters/pythia-1/Pythia1SimpleAttester.sol";
import "contracts/attesters/pythia-1/base/IPythia1Base.sol";
import "contracts/attesters/pythia-1/base/Pythia1Base.sol";
import "contracts/attesters/pythia-1/interfaces/IPythia1SimpleAttester.sol";
import "contracts/attesters/pythia-1/libs/Pythia1Lib.sol";
import "contracts/core/Attester.sol";
import "contracts/core/interfaces/IAttestationsRegistry.sol";
import "contracts/core/interfaces/IAttestationsRegistryConfigLogic.sol";
import "contracts/core/interfaces/IAttester.sol";
import "contracts/core/libs/Structs.sol";
import "contracts/core/libs/utils/RangeLib.sol";
