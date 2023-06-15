// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "OgvStaking.sol";
import "ERC20Votes.sol";
import "draft-ERC20Permit.sol";
import "draft-IERC20Permit.sol";
import "ERC20.sol";
import "IERC20.sol";
import "IERC20Metadata.sol";
import "Context.sol";
import "draft-EIP712.sol";
import "ECDSA.sol";
import "Strings.sol";
import "Counters.sol";
import "Math.sol";
import "IVotes.sol";
import "SafeCast.sol";
import "PRBMathUD60x18.sol";
import "PRBMath.sol";
import "RewardsSource.sol";
import "Governable.sol";
