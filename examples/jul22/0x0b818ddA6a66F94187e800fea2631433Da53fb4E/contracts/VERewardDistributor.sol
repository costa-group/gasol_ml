// SPDX-License-Identifier: WTFPL

pragma solidity ^0.8.13;

import "openzeppelin/contracts/access/Ownable.sol";
import "levxdao/ve/contracts/interfaces/IVotingEscrow.sol";
import "./interfaces/IETHVault.sol";

contract VERewardDistributor is Ownable {
    struct Reward {
        uint256 amount;
        uint256 veSupply;
        uint256 block;
        uint256 deadline;
        uint256 amountClaimed;
        bool withdrawn;
    }

    address public immutable vault;
    address public immutable ve;

    Reward[] public rewards;
    mapping(uint256 => mapping(address => uint256)) public amountClaimed;

    event AddReward(uint256 amount, uint256 veSupply, uint256 block, uint256 deadline);
    event Withdraw(uint256 rewardId, uint256 amount, address to);
    event Claim(uint256 rewardId, uint256 amount, address to);

    constructor(address _vault, address _ve) {
        vault = _vault;
        ve = _ve;
    }

    function rewardsLength() external view returns (uint256) {
        return rewards.length;
    }

    function addReward(
        uint256 amount,
        uint256 blockNumber,
        uint256 deadline
    ) external onlyOwner {
        require(amount > 0, "VERD: INVALID_REWARD_ID");
        require(blockNumber <= block.number, "VERD: INVALID_BLOCK_NUMBER");
        require(deadline > block.number, "VERD: INVALID_DEADLINE");

        IETHVault(vault).withdraw(amount, address(this));

        uint256 veSupply = IVotingEscrow(ve).totalSupplyAt(blockNumber);
        rewards.push(Reward(amount, veSupply, blockNumber, deadline, 0, false));

        emit AddReward(amount, veSupply, blockNumber, deadline);
    }

    function withdraw(uint256 rewardId, address to) external onlyOwner {
        Reward storage reward = rewards[rewardId];
        require(!reward.withdrawn, "VERD: WITHDRAWN");
        require(reward.deadline <= block.timestamp, "VERD: NOT_EXPIRED");

        reward.withdrawn = true;

        uint256 amount = reward.amount - reward.amountClaimed;
        emit Withdraw(rewardId, amount, to);
        payable(to).transfer(amount);
    }

    function claim(uint256 rewardId, address to) external {
        require(amountClaimed[rewardId][msg.sender] == 0, "VERD: CLAIMED");

        Reward storage reward = rewards[rewardId];
        require(block.timestamp < reward.deadline, "VERD: EXPIRED");

        uint256 _block = reward.block;
        uint256 balance = IVotingEscrow(ve).balanceOfAt(msg.sender, _block);
        require(balance > 0, "VERD: INSUFFICIENT_BALANCE");

        uint256 amount = (balance * reward.amount) / reward.veSupply;
        reward.amountClaimed += amount;
        amountClaimed[rewardId][msg.sender] = amount;

        if (to == address(0)) to = msg.sender;
        emit Claim(rewardId, amount, to);
        payable(to).transfer(amount);
    }
}
