// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "../core/TribeRoles.sol";
import "./DelegatorPCVDeposit.sol";

interface IAuraLocker {
    struct LockedBalance {
        uint112 amount;
        uint32 unlockTime;
    }
    struct EarnedData {
        address token;
        uint256 amount;
    }

    function balanceOf(address _user) external view returns (uint256);

    function lock(address _account, uint256 _amount) external;

    function getReward(address _account, bool _stake) external;

    function processExpiredLocks(bool _relock) external;

    function emergencyWithdraw() external;

    function delegates(address account) external view returns (address);

    function getVotes(address account) external view returns (uint256);

    function lockedBalances(address _user)
        external
        view
        returns (
            uint256 total,
            uint256 unlockable,
            uint256 locked,
            LockedBalance[] memory lockData
        );

    function claimableRewards(address _account) external view returns (EarnedData[] memory userRewards);

    function notifyRewardAmount(address _rewardsToken, uint256 _reward) external;
}

interface IAuraMerkleDrop {
    function claim(
        bytes32[] calldata _proof,
        uint256 _amount,
        bool _lock
    ) external returns (bool);
}

/// title Vote-locked AURA PCVDeposit
/// author eswak
contract VlAuraDelegatorPCVDeposit is DelegatorPCVDeposit {
    using SafeERC20 for IERC20;

    address public aura;
    address public auraLocker;
    address public auraMerkleDrop;

    /// notice constructor
    /// param _core Fei Core for reference
    constructor(address _core)
        DelegatorPCVDeposit(
            _core,
            address(0), // token
            address(0) // initialDelegate
        )
    {}

    function initialize(
        address _aura,
        address _auraLocker,
        address _auraMerkleDrop
    ) external {
        require(
            aura == address(0) ||
                auraLocker == address(0) ||
                auraMerkleDrop == address(0) ||
                address(token) == address(0),
            "initialized"
        );

        aura = _aura;
        auraLocker = _auraLocker;
        auraMerkleDrop = _auraMerkleDrop;
        token = ERC20Votes(_auraLocker);
    }

    /// notice noop, vlAURA can't be transferred.
    /// wait for lock expiry, and call withdrawERC20 on AURA.
    function withdraw(address, uint256) external override {}

    /// notice returns the balance of locked + unlocked
    function balance() public view virtual override returns (uint256) {
        return IERC20(aura).balanceOf(address(this)) + IERC20(auraLocker).balanceOf(address(this));
    }

    /// notice claim AURA airdrop and vote-lock it for 16 weeks
    /// this function is not access controlled & can be called by anyone.
    function claimAirdropAndLock(bytes32[] calldata _proof, uint256 _amount) external returns (bool) {
        return IAuraMerkleDrop(auraMerkleDrop).claim(_proof, _amount, true);
    }

    /// notice lock AURA held on this contract to vlAURA
    function lock() external whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
        uint256 amount = IERC20(aura).balanceOf(address(this));
        IERC20(aura).safeApprove(auraLocker, amount);
        IAuraLocker(auraLocker).lock(address(this), amount);
    }

    /// notice refresh lock after it has expired
    function relock() external whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
        IAuraLocker(auraLocker).processExpiredLocks(true);
    }

    /// notice exit lock after it has expired
    function unlock() external whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
        IAuraLocker(auraLocker).processExpiredLocks(false);
    }

    /// notice emergency withdraw if system is shut down
    function emergencyWithdraw() external whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
        IAuraLocker(auraLocker).emergencyWithdraw();
    }

    /// notice get rewards & stake them (rewards claiming is permissionless)
    function getReward() external {
        IAuraLocker(auraLocker).getReward(address(this), true);
    }
}
