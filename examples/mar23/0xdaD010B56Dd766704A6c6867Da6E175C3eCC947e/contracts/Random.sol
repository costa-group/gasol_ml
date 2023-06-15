// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

import "chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

abstract contract Random is OwnableUpgradeable, VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface private coordinator;
    LinkTokenInterface private linkToken;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    bytes32 private keyHash;

    // A reasonable default is 100000, but this value could be different
    // on other networks.
    uint32 private callbackGasLimit = 100000;

    // The default is 3, but you can set this higher.
    uint16 private requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 private numWords = 1;

    // pool id => subscription id
    mapping(uint256 => uint64) public subscriptionIds;

    constructor(address _vrfCoordinator, address _linkTokenContract) VRFConsumerBaseV2(_vrfCoordinator) {
        coordinator = VRFCoordinatorV2Interface(_vrfCoordinator);
        linkToken = LinkTokenInterface(_linkTokenContract);
    }

    // solhint-disable-next-line func-name-mixedcase
    function __Random_init(bytes32 _keyHash) internal onlyInitializing {
        __Ownable_init();
        keyHash = _keyHash;
    }

    // Assumes the subscription is funded sufficiently.
    function requestRandomWords(uint64 subscriptionId) internal returns (uint256 requestId) {
        // Will revert if subscription is not set and funded.
        requestId = coordinator.requestRandomWords(
            keyHash,
            subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    // Create a new subscription when the contract is initially deployed.
    function createNewSubscription() internal returns (uint64 subscriptionId) {
        subscriptionId = coordinator.createSubscription();
        // Add this contract as a consumer of its own subscription.
        coordinator.addConsumer(subscriptionId, address(this));
    }

    function cancelSubscription(uint64 subscriptionId, address receivingWallet) internal {
        // Cancel the subscription and send the remaining LINK to a wallet address.
        coordinator.cancelSubscription(subscriptionId, receivingWallet);
    }

    // Assumes this contract owns link.
    // 1000000000000000000 = 1 LINK
    function topUpSubscription(uint64 subscriptionId, uint256 amount) external onlyOwner {
        linkToken.transferAndCall(address(coordinator), amount, abi.encode(subscriptionId));
    }

    // Transfer this contract's funds to an address.
    // 1000000000000000000 = 1 LINK
    function withdraw(uint256 amount, address to) external onlyOwner {
        linkToken.transfer(to, amount);
    }
}
