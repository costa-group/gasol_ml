// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "contracts/vaultManager/VaultManager.sol";
import "contracts/vaultManager/VaultManagerPermit.sol";
import "contracts/vaultManager/VaultManagerERC721.sol";
import "contracts/interfaces/external/IERC1271.sol";
import "contracts/vaultManager/VaultManagerStorage.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-IERC20PermitUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/interfaces/IERC721MetadataUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "contracts/interfaces/IAgToken.sol";
import "contracts/interfaces/IOracle.sol";
import "contracts/interfaces/ISwapper.sol";
import "contracts/interfaces/ITreasury.sol";
import "contracts/interfaces/IVaultManager.sol";
import "contracts/interfaces/governance/IVeBoostProxy.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "contracts/interfaces/ICoreBorrow.sol";
import "contracts/interfaces/IFlashAngle.sol";
import "openzeppelin/contracts/interfaces/IERC721Metadata.sol";
import "openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "openzeppelin/contracts/token/ERC721/IERC721.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
