// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "contracts/genericFarmV2.sol";
import "boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
import "boringcrypto/boring-solidity/contracts/BoringBatchable.sol";
import "boringcrypto/boring-solidity/contracts/BoringOwnable.sol";
import "contracts/lib/SignedSafeMath.sol";
import "boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol";
import "boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol";
import "contracts/ichiFarmV2.sol";
