// d60d93b59bb4f46e26d76e63866f6016ca45bc9e
// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.17;

import "DEXBase.sol";
interface IAsset {
    // solhint-disable-previous-line no-empty-blocks
}

interface IVault{
    enum SwapKind { GIVEN_IN, GIVEN_OUT }

    struct BatchSwapStep {
        bytes32 poolId;
        uint256 assetInIndex;
        uint256 assetOutIndex;
        uint256 amount;
        bytes userData;
    }

    struct FundManagement {
        address sender;
        bool fromInternalBalance;
        address payable recipient;
        bool toInternalBalance;
    }

    struct JoinPoolRequest {
        IAsset[] assets;
        uint256[] maxAmountsIn;
        bytes userData;
        bool fromInternalBalance;
    }

    struct ExitPoolRequest {
        IAsset[] assets;
        uint256[] minAmountsOut;
        bytes userData;
        bool toInternalBalance;
    }
}

contract BalancerAcl is DEXBase {
    
    string public constant override NAME = "BalancerAcl";
    uint public constant override VERSION = 2;

    address public RELAYER_ADDRESS = 0x2536dfeeCB7A0397CF98eDaDA8486254533b1aFA;

    mapping(bytes32 => mapping (bytes32 => bool)) public poolIdWhitelist;   // joinPool & exitPool

    struct FundManagement {
        address sender;
        bool fromInternalBalance;
        address payable recipient;
        bool toInternalBalance;
    }

    struct JoinPoolRequest {
        IAsset[] assets;
        uint256[] maxAmountsIn;
        bytes userData;
        bool fromInternalBalance;
    }

    struct ExitPoolRequest {
        IAsset[] assets;
        uint256[] minAmountsOut;
        bytes userData;
        bool toInternalBalance;
    }

    struct BatchSwapStep {
        bytes32 poolId;
        uint256 assetInIndex;
        uint256 assetOutIndex;
        uint256 amount;
        bytes userData;
    }

    enum SwapKind {
        GIVEN_IN,
        GIVEN_OUT
    }

    struct SingleSwap {
        bytes32 poolId;
        SwapKind kind;
        IAsset assetIn;
        IAsset assetOut;
        uint256 amount;
        bytes userData;
    }

    struct OutputReference {
        uint256 index;
        uint256 key;
    }

    struct PoolId {
        bytes32 role;
        bytes32 poolId; 
        bool poolStatus;
    }


    // ACL methods
    function setRelayer(address _relayer) external onlySafe {
        require(_relayer != address(0), "_relayer not allowed");
        RELAYER_ADDRESS = _relayer;
    }

    function setPool(bytes32 _role,bytes32 _poolId, bool _poolStatus) external onlySafe {
        poolIdWhitelist[_role][_poolId] = _poolStatus;
    }

    function setPools(PoolId[] calldata _poolIds) external onlySafe {    
        for (uint i=0; i < _poolIds.length; i++) { 
            poolIdWhitelist[_poolIds[i].role][_poolIds[i].poolId] = _poolIds[i].poolStatus;
        }
    }


    function joinPool(
        bytes32 poolId,
        address sender,
        address recipient,
        JoinPoolRequest memory request
    ) external payable onlySelf {
        require(poolIdWhitelist[_checkedRole][poolId], "poolId is not allowed");
        checkRecipient(sender);
        checkRecipient(recipient);
    }

    function exitPool(
        bytes32 poolId,
        address sender,
        address payable recipient,
        ExitPoolRequest memory request
    ) external onlySelf {
        require(poolIdWhitelist[_checkedRole][poolId], "poolId is not allowed");
        checkRecipient(sender);
        checkRecipient(recipient);
    }



    function batchSwap(
        SwapKind kind,
        BatchSwapStep[] memory swaps,
        IAsset[] memory assets,
        FundManagement memory funds,
        int256[] memory limits,
        uint256 deadline
    ) external payable onlySelf {
        batchSwapCheck(funds.sender,funds.recipient,swaps,assets);
    }

    function swap(
        SingleSwap memory singleSwap,
        FundManagement memory funds,
        uint256 limit,
        uint256 deadline
    ) external payable onlySelf {
        checkRecipient(funds.sender);
        checkRecipient(funds.recipient);
        swapInOutTokenCheck(address(singleSwap.assetIn),address(singleSwap.assetOut));
    }

    // multicall
    function multicall(bytes[] calldata data) external payable onlySelf {
        for (uint256 i = 0; i < data.length; i++) {
            (bool success , bytes memory return_data) = address(this).staticcall(data[i]);
            require(success, "Failed in multicall");
        }
    }

    enum PoolKind { WEIGHTED }

    function joinPool(
        bytes32 poolId,
        PoolKind kind,
        address sender,
        address recipient,
        IVault.JoinPoolRequest memory request,
        uint256 value,
        uint256 outputReference
    ) external payable onlySelf {
        require(poolIdWhitelist[_checkedRole][poolId], "poolId is not allowed");
        checkRecipient(sender);
        checkRecipient(recipient);
    }

    function exitPool(
        bytes32 poolId,
        PoolKind kind,
        address sender,
        address payable recipient,
        IVault.ExitPoolRequest memory request,
        OutputReference[] calldata outputReferences
    ) external payable onlySelf {
        require(poolIdWhitelist[_checkedRole][poolId], "poolId is not allowed");
        checkRecipient(sender);
        checkRecipient(recipient);
    }

    function setRelayerApproval(
        address relayer,
        bool approved,
        bytes calldata authorisation
    ) external payable onlySelf {}

    function setRelayerApproval(
        address sender,
        address relayer,
        bool approved
    ) external onlySelf {
        checkRecipient(sender);
        require(relayer == RELAYER_ADDRESS, "Not relayer address");
    }

    function batchSwap(
        SwapKind kind,
        BatchSwapStep[] memory swaps,
        IAsset[] memory assets,
        FundManagement memory funds,
        int256[] memory limits,
        uint256 deadline,
        uint256 value,
        OutputReference[] memory outputReferences
    ) external payable onlySelf {
        batchSwapCheck(funds.sender,funds.recipient,swaps,assets);
    }

    function batchSwapCheck(address _sender, address _recipient, BatchSwapStep[] memory _swaps, IAsset[] memory _assets) internal {
        checkRecipient(_sender);
        require(_recipient == safeAddress || _recipient == RELAYER_ADDRESS, "Not safe address or RELAYER_ADDRESS");
        batchSwapTokensCheck(_swaps,_assets);
    }

    function batchSwapTokensCheck(BatchSwapStep[] memory _swaps, IAsset[] memory _assets) internal {
        BatchSwapStep memory batchSwapStep;

        bool[] memory isInToken = new bool[](_assets.length);
        bool[] memory isOutToken = new bool[](_assets.length);
        

        for (uint256 i = 0; i < _swaps.length; ++i) {
            batchSwapStep = _swaps[i];

            if(isOutToken[batchSwapStep.assetInIndex]){
                // if have A -> B and we got B -> C, clear B's flag.
                isOutToken[batchSwapStep.assetInIndex] = false;
                isInToken[batchSwapStep.assetInIndex] = false;
            }else{
                isInToken[batchSwapStep.assetInIndex] = true;
            }
            
            isOutToken[batchSwapStep.assetOutIndex] = true;
        }

        for (uint256 i = 0; i < _assets.length; ++i) {
            if(isInToken[i]) swapInTokenCheck(address(_assets[i]));
            if(isOutToken[i]) swapOutTokenCheck(address(_assets[i]));
        }
}

    uint256[50] private __gap;
}
