// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

/**
 * @title Represents an ownable resource.
 */
contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address previousOwner, address newOwner);

    /**
     * Constructor
     * @param addr The owner of the smart contract
     */
    constructor (address addr) {
        require(addr != address(0), "non-zero address required");
        require(addr != address(1), "ecrecover address not allowed");
        _owner = addr;
        emit OwnershipTransferred(address(0), addr);
    }

    /**
     * @notice This modifier indicates that the function can only be called by the owner.
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(msg.sender), "Only owner requirement");
        _;
    }

    /**
     * @notice Transfers ownership to the address specified.
     * @param addr Specifies the address of the new owner.
     * @dev Throws if called by any account other than the owner.
     */
    function transferOwnership (address addr) public onlyOwner {
        require(addr != address(0), "non-zero address required");
        emit OwnershipTransferred(_owner, addr);
        _owner = addr;
    }

    /**
     * @notice Destroys the smart contract.
     * @param addr The payable address of the recipient.
     */
    function destroy(address payable addr) public virtual onlyOwner {
        require(addr != address(0), "non-zero address required");
        require(addr != address(1), "ecrecover address not allowed");
        selfdestruct(addr);
    }

    /**
     * @notice Gets the address of the owner.
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @notice Indicates if the address specified is the owner of the resource.
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner(address addr) public view returns (bool) {
        return addr == _owner;
    }
}

/**
 * @notice This library provides stateless, general purpose functions.
 */
library Utils {
    // The code hash of any EOA
    bytes32 constant internal EOA_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

    /**
     * @notice Indicates if the address specified represents a smart contract.
     * @dev Notice that this method returns TRUE if the address is a contract under construction
     * @param addr The address to evaluate
     * @return Returns true if the address represents a smart contract
     */
    function isContract (address addr) internal view returns (bool) {
        bytes32 eoaHash = EOA_HASH;

        bytes32 codeHash;

        // solhint-disable-next-line no-inline-assembly
        assembly { codeHash := extcodehash(addr) }

        return (codeHash != eoaHash && codeHash != 0x0);
    }

    /**
     * @notice Gets the code hash of the address specified
     * @param addr The address to evaluate
     * @return Returns a hash
     */
    function getCodeHash (address addr) internal view returns (bytes32) {
        bytes32 codeHash;

        // solhint-disable-next-line no-inline-assembly
        assembly { codeHash := extcodehash(addr) }

        return codeHash;
    }
}

interface ICurveConvexRegistry {
    function getCurveDepositInfo (bytes32 recordId) external view returns (
        address curveDepositAddress, 
        address inputTokenAddress, 
        address curveLpTokenAddress
    );

    function getConvexDepositInfo (bytes32 recordId) external view returns (
        uint256 convexPoolId,
        address curveLpTokenAddress, 
        address convexRewardsAddress,
        address convexPoolAddress
    );

    function getCurveAddLiquidityInfo (bytes32 recordId) external view returns (
        uint8 totalParams,
        uint8 tokenPosition,
        bool useZap,
        address curveDepositAddress,
        bytes4 addLiquidityFnSig
    );

    function buildAddLiquidityCallData (bytes32 recordId, uint256 depositAmount, uint256 expectedLpTokensAmountAfterFees, address senderAddr) external view returns (bytes memory);
}

interface IERC20NonCompliant {
    function transfer(address to, uint256 value) external;
    function transferFrom(address from, address to, uint256 value) external;
    function approve(address spender, uint256 value) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address addr) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

interface IMinLpToken {
    function transfer(address to, uint256 value) external;
    function transferFrom(address from, address to, uint256 value) external;
    function approve(address spender, uint256 value) external;
    function balanceOf(address addr) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract CurveConvexRegistry is ICurveConvexRegistry, Ownable {
    address constant internal ZERO_ADDRESS = address(0);
    bytes4 constant internal ADD_LIQUIDITY_2_POOL = 0x0b4c7e4d; // bytes4(keccak256("add_liquidity(uint256[2],uint256)"));
    bytes4 constant internal ADD_LIQUIDITY_2_ZAP  = 0x4fb92465; // bytes4(keccak256("add_liquidity(address,uint256[2],uint256,address)"));
    bytes4 constant internal ADD_LIQUIDITY_4_POOL = 0x029b2f34; // bytes4(keccak256("add_liquidity(uint256[4],uint256)"));
    bytes4 constant internal ADD_LIQUIDITY_4_ZAP  = 0xd0b951e8; // bytes4(keccak256("add_liquidity(address,uint256[4],uint256,address)"));

    struct Record {
        address curvePoolAddress;
        address curveLpTokenAddress;
        address curveDepositAddress;
        address inputTokenAddress;
        address convexPoolAddress; 
        address convexRewardsAddress;
        uint256 convexPoolId; 
        uint8 totalParams;
        uint8 tokenPosition;
        bool useZap;
        bytes4 addLiquidityFnSig;
    }

    mapping (bytes32 => Record) internal _records;

    constructor (address newOwner) Ownable(newOwner) { // solhint-disable-line no-empty-blocks
    }

    /**
     * @notice Sets the deposit data of the pool specified
     * @param poolName The human readable name of the pool
     * @param curvePoolAddr The address of the pool, per Curve
     * @param curveLpTokenAddr The address of the LP token, per Curve
     * @param curveDepositAddr The deposit address in Curve
     * @param useZap Indicates if the deposit address is a Zap address or not
     * @param totalParams The number of parameters expected when adding liquidity to the pool
     * @param inputToken The token to deposit in Curve
     * @param tokenPosition The token position in Curve
     */
    function setDepositData (
        string memory poolName, 
        address curvePoolAddr, 
        IMinLpToken curveLpTokenAddr, 
        address curveDepositAddr,
        bool useZap, 
        uint8 totalParams,
        IERC20NonCompliant inputToken,
        uint8 tokenPosition
    ) public onlyOwner {
        // Checks
        require(curvePoolAddr != ZERO_ADDRESS, "non-zero address required");
        require(curveDepositAddr != ZERO_ADDRESS, "non-zero address required");
        require(address(curveLpTokenAddr) != ZERO_ADDRESS, "non-zero address required");
        require(address(inputToken) != ZERO_ADDRESS, "non-zero address required");
        require((totalParams == 2) || (totalParams == 4), "Invalid number of parameters");
        require(tokenPosition < totalParams, "Invalid target index");

        // Make sure the deposit address is a smart contract.
        // Query the exact code hash of the deposit contract. We don't want to deposit funds in an unknown contract implementation.
        bytes32 depositContractCodeHash = Utils.getCodeHash(curveDepositAddr);
        bool depositAddrIsContract = (depositContractCodeHash != Utils.EOA_HASH && depositContractCodeHash != 0x0);
        require(depositAddrIsContract, "Invalid Deposit address");

        bytes32 h = keccak256(abi.encode(poolName));

        _records[h].curvePoolAddress = curvePoolAddr;
        _records[h].curveLpTokenAddress = address(curveLpTokenAddr);
        _records[h].curveDepositAddress = curveDepositAddr;
        _records[h].inputTokenAddress = address(inputToken);
        _records[h].totalParams = totalParams;
        _records[h].tokenPosition = tokenPosition;
        _records[h].useZap = useZap;
        _records[h].addLiquidityFnSig = _getAddLiquiditySignature(useZap, totalParams);
    }

    /**
     * @notice Sets the staking data
     * @param poolName The human readable name of the pool
     * @param convexPoolAddr The address of the Convex pool
     * @param convexRewardsAddr The address of the Convex rewards
     * @param convexPoolId The ID of the Convex pool
     */
    function setStakingData (
        string memory poolName, 
        address convexPoolAddr, 
        address convexRewardsAddr,
        uint256 convexPoolId
    ) public onlyOwner {
        // Checks
        require(convexPoolAddr != ZERO_ADDRESS, "non-zero address required");
        require(convexRewardsAddr != ZERO_ADDRESS, "non-zero address required");

        bytes32 h = keccak256(abi.encode(poolName));

        _records[h].convexPoolAddress = convexPoolAddr;
        _records[h].convexRewardsAddress = convexRewardsAddr;
        _records[h].convexPoolId = convexPoolId;
    }

    function getCurveDepositInfo (bytes32 recordId) public override view returns (
        address curveDepositAddress, 
        address inputTokenAddress, 
        address curveLpTokenAddress
    ) {
        curveLpTokenAddress = _records[recordId].curveLpTokenAddress;
        curveDepositAddress = _records[recordId].curveDepositAddress;
        inputTokenAddress = _records[recordId].inputTokenAddress;
    }

    function getConvexDepositInfo (bytes32 recordId) public override view returns (
        uint256 convexPoolId,
        address curveLpTokenAddress, 
        address convexRewardsAddress,
        address convexPoolAddress
    ) {
        convexPoolId = _records[recordId].convexPoolId;
        curveLpTokenAddress = _records[recordId].curveLpTokenAddress;
        convexRewardsAddress = _records[recordId].convexRewardsAddress;
        convexPoolAddress = _records[recordId].convexPoolAddress;
    }

    function getCurveAddLiquidityInfo (bytes32 recordId) public override view returns (
        uint8 totalParams,
        uint8 tokenPosition,
        bool useZap,
        address curveDepositAddress,
        bytes4 addLiquidityFnSig
    ) {
        totalParams = _records[recordId].totalParams;
        tokenPosition = _records[recordId].tokenPosition;
        useZap = _records[recordId].useZap;
        curveDepositAddress = _records[recordId].curveDepositAddress;
        addLiquidityFnSig = _records[recordId].addLiquidityFnSig;
    }

    function getRecord (bytes32 recordId) public view returns (
        address curvePoolAddress,
        address curveLpTokenAddress,
        address curveDepositAddress,
        address inputTokenAddress,
        address convexPoolAddress, 
        address convexRewardsAddress,
        uint8 totalParams,
        uint8 tokenPosition,
        bool useZap,
        bytes4 addLiquidityFnSig
    ) {
        curvePoolAddress = _records[recordId].curvePoolAddress;
        curveLpTokenAddress = _records[recordId].curveLpTokenAddress;
        curveDepositAddress = _records[recordId].curveDepositAddress;
        inputTokenAddress = _records[recordId].inputTokenAddress;
        convexPoolAddress = _records[recordId].convexPoolAddress;
        convexRewardsAddress = _records[recordId].convexRewardsAddress;
        totalParams = _records[recordId].totalParams;
        tokenPosition = _records[recordId].tokenPosition;
        useZap = _records[recordId].useZap;
        addLiquidityFnSig = _records[recordId].addLiquidityFnSig;
    }

    function buildAddLiquidityCallData (bytes32 recordId, uint256 depositAmount, uint256 expectedLpTokensAmountAfterFees, address senderAddr) public override view returns (bytes memory) {
        // Get the parameters
        (
            uint8 totalParams,
            uint8 tokenPosition,
            bool useZap,
            address curveDepositAddress,
            bytes4 addLiquidityFnSig
        ) = getCurveAddLiquidityInfo(recordId);

        require((totalParams == 2) || (totalParams == 4), "Invalid number of parameters");

        // Get the resulting payload
        if (totalParams == 4) {
            return useZap 
                    ? abi.encodeWithSelector(addLiquidityFnSig, curveDepositAddress, _buildFixedArrayOf4(tokenPosition, depositAmount), expectedLpTokensAmountAfterFees, senderAddr)
                    : abi.encodeWithSelector(addLiquidityFnSig, _buildFixedArrayOf4(tokenPosition, depositAmount), expectedLpTokensAmountAfterFees);
        }
        else if (totalParams == 2) {
            return useZap 
                    ? abi.encodeWithSelector(addLiquidityFnSig, curveDepositAddress, _buildFixedArrayOf2(tokenPosition, depositAmount), expectedLpTokensAmountAfterFees, senderAddr)
                    : abi.encodeWithSelector(addLiquidityFnSig, _buildFixedArrayOf2(tokenPosition, depositAmount), expectedLpTokensAmountAfterFees);
        }
        else revert("Invalid parameters");
    }

    function _getAddLiquiditySignature (bool useZap, uint8 totalParams) private pure returns (bytes4) {
        if (totalParams == 4) {
            return (useZap) ? ADD_LIQUIDITY_4_ZAP : ADD_LIQUIDITY_4_POOL;
        }
        else if (totalParams == 2) {
            return (useZap) ? ADD_LIQUIDITY_2_ZAP : ADD_LIQUIDITY_2_POOL;
        }
        else revert("Invalid parameters");
    }

    function _buildFixedArrayOf2 (uint8 targetIndex, uint256 targetValue) private pure returns (uint256[2] memory) {
        require(targetIndex < 2, "Invalid target index");
        return (targetIndex == 0) ? [targetValue, 0] : [0, targetValue];
    }

    function _buildFixedArrayOf4 (uint8 targetIndex, uint256 targetValue) private pure returns (uint256[4] memory) {
        require(targetIndex < 4, "Invalid target index");
        if (targetIndex == 0) return uint256[4]([targetValue, 0, 0, 0]);
        else if (targetIndex == 1) return uint256[4]([0, targetValue, 0, 0]);
        else if (targetIndex == 2) return uint256[4]([0, 0, targetValue, 0]);
        else return uint256[4]([0, 0, 0, targetValue]);
    }
}