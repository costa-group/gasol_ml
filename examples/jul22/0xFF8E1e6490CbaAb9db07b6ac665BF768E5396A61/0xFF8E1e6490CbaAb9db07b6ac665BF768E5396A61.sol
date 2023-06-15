// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity >=0.7.0 <0.9.0;

import "gnosis.pm/safe-contracts/contracts/common/Enum.sol";
import "gnosis.pm/zodiac/contracts/core/Module.sol";
import "gnosis.pm/zodiac/contracts/factory/FactoryFriendly.sol";
import "gnosis.pm/zodiac/contracts/guard/BaseGuard.sol";
import "gnosis.pm/zodiac/contracts/guard/Guardable.sol";
import "gnosis.pm/zodiac/contracts/interfaces/IAvatar.sol";
import "gnosis.pm/zodiac/contracts/interfaces/IGuard.sol";
import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "contracts/NomadModule.sol";
