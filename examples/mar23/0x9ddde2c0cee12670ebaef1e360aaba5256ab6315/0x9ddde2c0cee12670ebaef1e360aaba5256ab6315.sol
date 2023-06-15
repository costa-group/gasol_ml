// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) payable external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) payable external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) payable external;
}

contract BatchAirdroper {
    constructor() {}

    function transferBatch(
        address[] calldata receivers,
        uint256[] calldata ids,
        address contractAddress
    ) external {
        IERC721 erc721Contract = IERC721(contractAddress);

        for (uint256 index = 0; index < receivers.length; index++) {
            erc721Contract.transferFrom(
                msg.sender,
                receivers[index],
                ids[index]
            );
        }
    }

    function transferBatch_2(
        address[] calldata receivers,
        uint256[] calldata ids,
        address contractAddress
    ) external {
        IERC721 erc721Contract = IERC721(contractAddress);

        for (uint256 index = 0; index < receivers.length; index++) {
            erc721Contract.safeTransferFrom(
                msg.sender,
                receivers[index],
                ids[index]
            );
        }
    }

    function transferBatch_3(
        address[] calldata receivers,
        uint256[] calldata ids,
        address contractAddress
    ) external {
        IERC721 erc721Contract = IERC721(contractAddress);

        for (uint256 index = 0; index < receivers.length; index++) {
            erc721Contract.safeTransferFrom(
                msg.sender,
                receivers[index],
                ids[index],
                ""
            );
        }
    }
}