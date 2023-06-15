// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

import "./BounceBase.sol";
import "./Random.sol";

contract BounceLottery is BounceBase, Random {
    using SafeMathUpgradeable for uint256;
    using SafeERC20Upgradeable for IERC20Upgradeable;

    struct CreateReq {
        string name;
        address token0;
        address token1;
        uint256 amountTotal0;
        uint256 amount1PerWallet;
        uint48 openAt;
        uint48 closeAt;
        uint48 claimAt;
        uint16 maxPlayer;
        uint16 nShare;
        bytes32 whitelistRoot;
    }

    struct Pool {
        address creator;
        address token0;
        address token1;
        uint256 amountTotal0;
        uint256 amount1PerWallet;
        uint48 openAt;
        uint48 closeAt;
        uint48 claimAt;
        uint16 maxPlayer;
        uint16 curPlayer;
        uint16 nShare;
    }

    Pool[] public pools;

    mapping(uint256 => uint256) public requestIdToIndexes;
    mapping(uint256 => uint256) public winnerSeed;
    // pool id => claimed
    mapping(uint256 => bool) public creatorClaimed;
    // player => pool id => claimed
    mapping(address => mapping(uint256 => bool)) public myClaimed;
    // player => pool id => Serial number-start from 1
    mapping(address => mapping(uint256 => uint256)) public betNo;

    event Created(uint256 indexed index, address indexed sender, Pool pool, string name, bytes32 whitelistRoot);
    event Bet(uint256 indexed index, address indexed sender);
    event CreatorClaimed(
        uint256 indexed index,
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        uint256 txFee
    );
    event UserClaimed(uint256 indexed index, address indexed sender, uint256 amount0, uint256 amount1);
    event Reversed(uint256 indexed index, address indexed sender, uint256 amount1);
    event RandomRequested(uint256 indexed index, address indexed sender, uint256 requestId);

    // solhint-disable-next-line no-empty-blocks
    constructor(address _vrfCoordinator, address _linkTokenContract) Random(_vrfCoordinator, _linkTokenContract) {}

    function initialize(
        uint256 _txFeeRatio,
        address _stakeContract,
        address _signer,
        bytes32 _keyHash
    ) public initializer {
        super.__BounceBase_init(_txFeeRatio, _stakeContract, _signer);
        super.__Random_init(_keyHash);
    }

    function create(CreateReq memory poolReq, uint256 expireAt, bytes memory signature) external nonReentrant {
        require(poolReq.amountTotal0 >= poolReq.nShare, "amountTotal0 less than nShare");
        require(poolReq.amount1PerWallet != 0, "amount1PerWallet is zero");
        require(poolReq.nShare != 0, "nShare is zero");
        require(poolReq.nShare <= poolReq.maxPlayer, "max player less than nShare");
        require(poolReq.maxPlayer > 0, "maxPlayer is zero");
        require(poolReq.openAt >= block.timestamp, "invalid openAt");
        require(poolReq.closeAt > poolReq.openAt, "invalid closeAt");
        require(poolReq.claimAt >= poolReq.closeAt, "invalid claimAt");
        require(bytes(poolReq.name).length <= 60, "name is too long");

        checkCreator(keccak256(abi.encode(poolReq, PoolType.Lottery)), expireAt, signature);

        uint256 index = pools.length;

        if (poolReq.whitelistRoot != bytes32(0)) {
            whitelistRootP[index] = poolReq.whitelistRoot;
        }

        // transfer amount of token0 to this contract
        transferAndCheck(poolReq.token0, msg.sender, poolReq.amountTotal0);

        Pool memory pool;
        pool.creator = msg.sender;
        pool.token0 = poolReq.token0;
        pool.token1 = poolReq.token1;
        pool.amountTotal0 = poolReq.amountTotal0;
        pool.amount1PerWallet = poolReq.amount1PerWallet;
        pool.openAt = poolReq.openAt;
        pool.closeAt = poolReq.closeAt;
        pool.claimAt = poolReq.claimAt;
        pool.maxPlayer = poolReq.maxPlayer;
        pool.nShare = poolReq.nShare;
        pools.push(pool);

        subscriptionIds[index] = super.createNewSubscription();

        emit Created(index, msg.sender, pool, poolReq.name, whitelistRootP[index]);
    }

    function bet(
        uint256 index,
        bytes32[] memory proof
    ) external payable nonReentrant isPoolExist(index) isPoolNotClosed(index) {
        checkWhitelist(index, proof);
        Pool memory pool = pools[index];
        require(betNo[msg.sender][index] == 0, "already bet");
        require(pool.openAt <= block.timestamp, "pool not open");
        require(pool.curPlayer <= pool.maxPlayer, "reached upper limit");

        pools[index].curPlayer += 1;
        betNo[msg.sender][index] = pools[index].curPlayer;

        if (pool.token1 == address(0)) {
            require(msg.value == pool.amount1PerWallet, "invalid amount of ETH");
        } else {
            IERC20Upgradeable(pool.token1).safeTransferFrom(msg.sender, address(this), pool.amount1PerWallet);
        }

        emit Bet(index, msg.sender);
    }

    function creatorClaim(uint256 index) external nonReentrant isPoolExist(index) isPoolClosed(index) {
        Pool memory pool = pools[index];
        require(pool.creator == msg.sender, "invalid pool creator");
        require(!creatorClaimed[index], "creator claimed");
        creatorClaimed[index] = true;

        super.cancelSubscription(subscriptionIds[index], address(this));

        if (pool.curPlayer == 0) {
            IERC20Upgradeable(pool.token0).safeTransfer(msg.sender, pool.amountTotal0);
            emit CreatorClaimed(index, msg.sender, pool.amountTotal0, 0, 0);
            return;
        }

        uint256 nShare = pools[index].nShare;
        uint256 hitShare = (pool.curPlayer > nShare ? nShare : pool.curPlayer);
        uint256 amount0 = 0;
        if (nShare > pool.curPlayer) {
            amount0 = pool.amountTotal0.div(nShare).mul(nShare.sub(pool.curPlayer));
            IERC20Upgradeable(pool.token0).safeTransfer(msg.sender, amount0);
        }

        uint256 amount1 = pool.amount1PerWallet.mul(hitShare);
        uint256 txFee = amount1.mul(txFeeRatio).div(TX_FEE_DENOMINATOR);
        uint256 _amount1 = amount1.sub(txFee);
        if (_amount1 > 0) {
            if (pool.token1 == address(0)) {
                payable(pool.creator).transfer(_amount1);
            } else {
                IERC20Upgradeable(pool.token1).safeTransfer(pool.creator, _amount1);
            }
        }

        if (txFee > 0) {
            if (pool.token1 == address(0)) {
                // deposit transaction fee to staking contract
                // solhint-disable-next-line avoid-low-level-calls
                (bool success, ) = stakeContract.call{value: txFee}(abi.encodeWithSignature("depositReward()"));
                if (!success) {
                    revert("Revert: depositReward()");
                }
            } else {
                IERC20Upgradeable(pool.token1).safeTransfer(stakeContract, txFee);
            }
        }

        emit CreatorClaimed(index, msg.sender, amount0, _amount1, txFee);
    }

    function userClaim(uint256 index) external nonReentrant isPoolExist(index) isClaimReady(index) {
        require(!myClaimed[msg.sender][index], "claimed");
        myClaimed[msg.sender][index] = true;
        require(winnerSeed[index] > 0, "waiting seed");
        require(betNo[msg.sender][index] > 0, "no bet");

        Pool memory pool = pools[index];
        uint256 amount0 = 0;
        uint256 amount1 = 0;
        if (isWinner(index, msg.sender)) {
            amount0 = pool.amountTotal0.div(pools[index].nShare);
            IERC20Upgradeable(pool.token0).safeTransfer(msg.sender, amount0);
        } else {
            amount1 = pool.amount1PerWallet;
            if (pool.token1 == address(0)) {
                payable(msg.sender).transfer(amount1);
            } else {
                IERC20Upgradeable(pool.token1).safeTransfer(msg.sender, amount1);
            }
        }

        emit UserClaimed(index, msg.sender, amount0, amount1);
    }

    function reverse(uint256 index) external nonReentrant isPoolExist(index) isPoolNotClosed(index) {
        require(betNo[msg.sender][index] > 0, "no bet");
        delete betNo[msg.sender][index];
        pools[index].curPlayer -= 1;

        Pool memory pool = pools[index];
        if (pool.token1 == address(0)) {
            payable(msg.sender).transfer(pool.amount1PerWallet);
        } else {
            IERC20Upgradeable(pool.token1).safeTransfer(msg.sender, pool.amount1PerWallet);
        }

        emit Reversed(index, msg.sender, pool.amount1PerWallet);
    }

    function requestRandom(uint256 index) external nonReentrant isPoolExist(index) isPoolClosed(index) {
        require(pools[index].curPlayer > 0, "no bet");
        uint256 requestId = requestRandomWords(subscriptionIds[index]);
        requestIdToIndexes[requestId] = index;

        emit RandomRequested(index, msg.sender, requestId);
    }

    function lo2(uint256 value) private pure returns (uint256) {
        require(value < 65536, "too large");
        if (value <= 2) {
            return uint256(0);
        } else if (value == 3) {
            return uint256(2);
        }
        uint256 x = 0;
        uint256 s = value;
        while (value > 1) {
            value >>= 1;
            x++;
        }
        if (s > ((2 << (x.sub(1))) + (2 << (x.sub(2))))) return (x.mul(2).add(1));
        return (x.mul(2));
    }

    function calcRet(uint256 index, uint256 m) private pure returns (uint256) {
        uint256[32] memory p = [
            uint256(3),
            3,
            5,
            7,
            17,
            11,
            7,
            11,
            13,
            23,
            31,
            47,
            61,
            89,
            127,
            191,
            251,
            383,
            509,
            761,
            1021,
            1531,
            2039,
            3067,
            4093,
            6143,
            8191,
            12281,
            16381,
            24571,
            32749,
            49139
        ];
        uint256 nSel = lo2(m);
        return (index.mul(p[nSel])) % m;
    }

    function isWinner(uint256 index, address sender) public view returns (bool) {
        require(pools[index].closeAt < block.timestamp, "It's not time to start the prize");
        if (betNo[sender][index] == 0) {
            return false;
        }
        uint256 nShare = pools[index].nShare;
        uint256 curPlayer = pools[index].curPlayer;

        if (curPlayer <= nShare) {
            return true;
        }

        uint256 n = winnerSeed[index] - 1;

        uint256 pos = calcRet(betNo[sender][index] - 1, curPlayer);

        if ((n.add(nShare)) % curPlayer > n) {
            if ((pos >= n) && (pos < (n + nShare))) {
                return true;
            }
        } else {
            if ((pos >= n) && (pos < curPlayer)) {
                return true;
            }
            if (pos < (n.add(nShare)) % curPlayer) {
                return true;
            }
        }
        return false;
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        uint256 index = requestIdToIndexes[requestId];
        if (winnerSeed[index] == 0) {
            winnerSeed[index] = (randomWords[0] % pools[index].curPlayer) + 1;
        }
    }

    function getPoolCount() external view returns (uint256) {
        return pools.length;
    }

    modifier isPoolClosed(uint256 index) {
        require(pools[index].closeAt <= block.timestamp, "this pool is not closed");
        _;
    }

    modifier isPoolNotClosed(uint256 index) {
        require(pools[index].closeAt > block.timestamp, "this pool is closed");
        _;
    }

    modifier isClaimReady(uint256 index) {
        require(pools[index].claimAt <= block.timestamp, "claim not ready");
        _;
    }

    modifier isPoolExist(uint256 index) {
        require(index < pools.length, "this pool does not exist");
        _;
    }
}
