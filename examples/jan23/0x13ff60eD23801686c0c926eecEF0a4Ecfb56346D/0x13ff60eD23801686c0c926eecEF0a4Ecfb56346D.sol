//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Context {
    constructor() {}

    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this;
        return msg.data;
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, 'SafeMath: addition overflow');

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, 'SafeMath: subtraction overflow');
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, 'SafeMath: multiplication overflow');

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, 'SafeMath: division by zero');
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, 'SafeMath: modulo by zero');
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }

    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address _owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            'SafeBEP20: approve from non-zero to non-zero allowance'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            'SafeBEP20: decreased allowance below zero'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
        }
    }
}

abstract contract Auth {
    address public owner;
    mapping (address => bool) internal authorizations;

    constructor(address _owner) {
        owner = _owner;
        authorizations[_owner] = true; }
    
    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER"); _;
    }

    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    function authorize(address adr) public authorized {
        authorizations[adr] = true;
    }

    function unauthorize(address adr) public authorized {
        authorizations[adr] = false;
    }

    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    function transferOwnership(address payable adr) public authorized {
        owner = adr;
        authorizations[adr] = true;
        emit OwnershipTransferred(adr);
    }

    function renounceOwnership() public authorized {
        address dead = 0x000000000000000000000000000000000000dEaD;
        owner = dead;
        emit OwnershipTransferred(dead);
    }

    event OwnershipTransferred(address owner);
}

library Address {

    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, 'Address: insufficient balance');

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}('');
        require(success, 'Address: unable to send value, recipient may have reverted');
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, 'Address: low-level call failed');
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, 'Address: insufficient balance for call');
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), 'Address: call to non-contract');

        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

contract EthRISEStaking is Auth, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeBEP20 for IERC20;

    struct UserInfo {
        uint256 amount;     // How many staked tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 stakedToken;           // Address of staked token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool. Tokens to distribute per block.
        uint256 lastRewardBlock;  // Last block number that Tokens distribution occurs.
        uint256 accTokensPerShare; // Accumulated Tokens per share, times eNum. See below.
    }

    IERC20 public stakingToken;
    uint256 public rewardPerBlock;
    uint256 public totalStaked;
    uint256 public allocPoint;
    uint256 public eNum = 1e12;
    uint256 public totalBNBDeposited;
    uint256 public totalRewardDebt;

    PoolInfo[] public poolInfo;
    mapping (address => UserInfo) public userInfo;
    uint256 private totalAllocPoint = 0;
    uint256 public startBlock;
    uint256 public bonusEndBlock;

    mapping(address => uint256) totalWalletClaimed;
    uint256 public totalBNBClaimedRewards;

    event RewardsClaimed(address indexed user, uint256 amount);
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 amount);

    constructor() Auth(msg.sender) {
        stakingToken = IERC20(0xB67C86A567E98d97E3E68a1D7dEcA28D8235147E);
        rewardPerBlock = 100000000000;
        startBlock = block.number;
        bonusEndBlock = 99999999;

        // staking pool
        poolInfo.push(PoolInfo({
            stakedToken: stakingToken,
            allocPoint: 100000,
            lastRewardBlock: 99999999,
            accTokensPerShare: 150
        }));

        totalAllocPoint = 100000;

    }

    receive() external payable {totalBNBDeposited = totalBNBDeposited + msg.value;}

    function stopReward() public authorized {
        bonusEndBlock = block.number;
    }

    function startReward() public authorized {
        require(poolInfo[0].lastRewardBlock == 99999999, "Can only start rewards once");
        poolInfo[0].lastRewardBlock = block.number;
    }

    function seteNum(uint256 _enum) external authorized {
        eNum = _enum;
    }

    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        if (_to <= bonusEndBlock) {
            return _to.sub(_from);
        } else if (_from >= bonusEndBlock) {
            return 0;
        } else {
            return bonusEndBlock.sub(_from);
        }
    }

    // View function to see pending Reward on frontend.
    function pendingReward(address _user) external view returns (uint256) {
        PoolInfo storage pool = poolInfo[0];
        UserInfo storage user = userInfo[_user];
        uint256 accTokensPerShare = pool.accTokensPerShare;
        uint256 stakedSupply = totalStaked;
        if (block.number > pool.lastRewardBlock && stakedSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 tokenReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
            accTokensPerShare = accTokensPerShare.add(tokenReward.mul(eNum).div(stakedSupply));
        }
        return user.amount.mul(accTokensPerShare).div(eNum).sub(user.rewardDebt);
    }

    function totalRewardsDue() external view returns (uint256) {
        PoolInfo storage pool = poolInfo[0];
        uint256 accTokensPerShare = pool.accTokensPerShare;
        uint256 stakedSupply = totalStaked;
        if (block.number > pool.lastRewardBlock && stakedSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 tokenReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
            accTokensPerShare = accTokensPerShare.add(tokenReward.mul(eNum).div(stakedSupply));
        }
        return stakedSupply.mul(accTokensPerShare).div(eNum).sub(totalRewardDebt);
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _pid) internal {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 stakedSupply = totalStaked;
        if (stakedSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 tokenReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
        pool.accTokensPerShare = pool.accTokensPerShare.add(tokenReward.mul(eNum).div(stakedSupply));
        pool.lastRewardBlock = block.number;
    }

    // Stake primary tokens
    function deposit(uint256 _amount) public nonReentrant {
        PoolInfo storage pool = poolInfo[0];
        UserInfo storage user = userInfo[msg.sender];

        updatePool(0);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accTokensPerShare).div(eNum).sub(user.rewardDebt);
            if(pending > 0) {
                require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
                payable(msg.sender).transfer(pending);
                totalWalletClaimed[msg.sender] = totalWalletClaimed[msg.sender] + pending;
                totalBNBClaimedRewards = totalBNBClaimedRewards + pending;
            }
        }
        
        uint256 amountTransferred = 0;
        if(_amount > 0) {
            uint256 initialBalance = pool.stakedToken.balanceOf(address(this));
            pool.stakedToken.safeTransferFrom(address(msg.sender), address(this), _amount);
            amountTransferred = pool.stakedToken.balanceOf(address(this)) - initialBalance;
            user.amount = user.amount.add(amountTransferred);
            totalStaked += amountTransferred;
        }
        user.rewardDebt = user.amount.mul(pool.accTokensPerShare).div(eNum);
        totalRewardDebt = totalStaked.mul(pool.accTokensPerShare).div(eNum);

        emit Deposit(msg.sender, amountTransferred);
    }

    function claimRewards() public {
        PoolInfo storage pool = poolInfo[0];
        UserInfo storage user = userInfo[msg.sender];
        updatePool(0);
        uint256 pending = user.amount.mul(pool.accTokensPerShare).div(eNum).sub(user.rewardDebt);
        if(pending > 0) {
            require(pending <= rewardsRemaining(), "Cannot withdraw other people's rewards.  Contact an admin.");
            payable(msg.sender).transfer(pending);}
        user.rewardDebt = user.amount.mul(pool.accTokensPerShare).div(eNum);
        totalRewardDebt = totalStaked.mul(pool.accTokensPerShare).div(eNum);
        totalWalletClaimed[msg.sender] = totalWalletClaimed[msg.sender] + pending;
        totalBNBClaimedRewards = totalBNBClaimedRewards + pending;
        emit RewardsClaimed(msg.sender, pending);
    }

    function withdraw(uint256 _amount) public nonReentrant {
        PoolInfo storage pool = poolInfo[0];
        UserInfo storage user = userInfo[msg.sender];
        require(user.amount >= _amount, "withdraw: attempting to withdraw too many tokens");
        updatePool(0);
        uint256 pending = user.amount.mul(pool.accTokensPerShare).div(eNum).sub(user.rewardDebt);
        if(pending > 0) {
            require(pending <= rewardsRemaining(), "Cannot withdraw other people's staked tokens.  Contact an admin.");
            payable(msg.sender).transfer(pending);
        }
        if(_amount > 0) {
            user.amount = user.amount.sub(_amount);
            pool.stakedToken.safeTransfer(address(msg.sender), _amount);
            totalStaked -= _amount;
        }
        user.rewardDebt = user.amount.mul(pool.accTokensPerShare).div(eNum);
        totalRewardDebt = totalStaked.mul(pool.accTokensPerShare).div(eNum);
        totalWalletClaimed[msg.sender] = totalWalletClaimed[msg.sender] + pending;
        totalBNBClaimedRewards = totalBNBClaimedRewards + pending;

        emit Withdraw(msg.sender, _amount);
    }

    function emergencyWithdraw() external nonReentrant {
        PoolInfo storage pool = poolInfo[0];
        UserInfo storage user = userInfo[msg.sender];
        pool.stakedToken.safeTransfer(address(msg.sender), user.amount);
        totalStaked -= user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        emit EmergencyWithdraw(msg.sender, user.amount);
    }

    function emergencyRescue(address _token, address _rec, uint256 _percent) external authorized {
        uint256 tamt = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(_rec, tamt * (_percent) / (100));
    }

    function emergencyInternalWithdraw(uint256 _amount) external authorized {
        payable(msg.sender).transfer(_amount);
    }

    function emergencyInternalWithdrawAll() external authorized {
        uint256 cbalance = address(this).balance;
        payable(msg.sender).transfer(cbalance);
    }

    function updateRewardPerBlock(uint256 _amount) external authorized {
        updatePool(0);
        rewardPerBlock = _amount;
    }

    function updateAllocPoint(uint256 _amount) external authorized {
        updatePool(0);
        allocPoint = _amount;
    }

    function viewWalletClaimed(address _address) public view returns (uint256) {
        return totalWalletClaimed[_address];
    }

    function rewardsRemaining() public view returns (uint256){
        return(address(this).balance);
    }
}