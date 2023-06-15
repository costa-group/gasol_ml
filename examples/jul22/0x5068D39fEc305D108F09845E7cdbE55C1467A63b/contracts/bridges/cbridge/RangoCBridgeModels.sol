// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library RangoCBridgeModels {
    struct RangoCBridgeInterChainMessage {
        uint64 dstChainId;
        bool bridgeNativeOut;
        address dexAddress;
        address fromToken;
        address toToken;
        uint amountOutMin;
        address[] path;
        uint deadline;
        bool nativeOut;
        address originalSender;
        address recipient;

        // Extra message
        bytes dAppMessage;
        address dAppSourceContract;
        address dAppDestContract;
    }
}