// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/solidity/NFTXVaultFactoryUpgradeable.sol";
import "contracts/solidity/NFTXVaultUpgradeable.sol";
import "contracts/solidity/interface/IERC165Upgradeable.sol";
import "contracts/solidity/interface/IERC3156Upgradeable.sol";
import "contracts/solidity/interface/INFTXEligibility.sol";
import "contracts/solidity/interface/INFTXEligibilityManager.sol";
import "contracts/solidity/interface/INFTXFeeDistributor.sol";
import "contracts/solidity/interface/INFTXVault.sol";
import "contracts/solidity/interface/INFTXVaultFactory.sol";
import "contracts/solidity/proxy/BeaconProxy.sol";
import "contracts/solidity/proxy/IBeacon.sol";
import "contracts/solidity/proxy/Initializable.sol";
import "contracts/solidity/proxy/Proxy.sol";
import "contracts/solidity/proxy/UpgradeableBeacon.sol";
import "contracts/solidity/token/ERC1155ReceiverUpgradeable.sol";
import "contracts/solidity/token/ERC1155SafeHolderUpgradeable.sol";
import "contracts/solidity/token/ERC20FlashMintUpgradeable.sol";
import "contracts/solidity/token/ERC20Upgradeable.sol";
import "contracts/solidity/token/ERC721SafeHolderUpgradeable.sol";
import "contracts/solidity/token/IERC1155ReceiverUpgradeable.sol";
import "contracts/solidity/token/IERC1155Upgradeable.sol";
import "contracts/solidity/token/IERC20Metadata.sol";
import "contracts/solidity/token/IERC20Upgradeable.sol";
import "contracts/solidity/token/IERC721ReceiverUpgradeable.sol";
import "contracts/solidity/token/IERC721Upgradeable.sol";
import "contracts/solidity/util/Address.sol";
import "contracts/solidity/util/ContextUpgradeable.sol";
import "contracts/solidity/util/ERC165Upgradeable.sol";
import "contracts/solidity/util/EnumerableSetUpgradeable.sol";
import "contracts/solidity/util/OwnableUpgradeable.sol";
import "contracts/solidity/util/PausableUpgradeable.sol";
import "contracts/solidity/util/ReentrancyGuardUpgradeable.sol";
