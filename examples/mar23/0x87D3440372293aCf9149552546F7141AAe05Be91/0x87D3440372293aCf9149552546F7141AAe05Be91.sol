// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "chainlink/contracts/src/v0.8/ConfirmedOwnerWithProposal.sol";
import "chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "chainlink/contracts/src/v0.8/interfaces/OwnableInterface.sol";
import "chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "contracts/RandomNumberGenerator.sol";
import "contracts/interfaces/IYDTSwapLottery.sol";
