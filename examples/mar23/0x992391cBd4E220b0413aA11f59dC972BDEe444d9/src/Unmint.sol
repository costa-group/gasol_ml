// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "solmate/auth/Owned.sol";
import "solmate/utils/MerkleProofLib.sol";

import {RayTaiNFT} from "./RayTaiNFT.sol";

contract RaytaiUnmint is Owned {
    RayTaiNFT immutable _collection;
    uint256 immutable _first_public_sale_token_id;
    bytes32 public _root;
    address immutable public _withdrawer;

    constructor(bytes32 merkleroot, address withdrawer, RayTaiNFT collection, uint256 first_public_sale_token_id) 
    Owned(msg.sender) {
        _collection = collection;
        _first_public_sale_token_id = first_public_sale_token_id;
        _root = merkleroot;
	    _withdrawer = withdrawer;
    }

    //function unmint(uint256 tokenId, bool isAL, bytes32[] calldata proof) external {
        // require(_verify(_leaf(msg.sender, tokenId, isAL), proof), "Invalid merkle proof");
        // _collection.safeTransferFrom(msg.sender, address(this), tokenId);
        // if (tokenId >= _first_public_sale_token_id) {
        //     (bool result, ) = msg.sender.call{value: 33000000 gwei}("");
        //     require(result, "Transfer failed.");
        // } else {
        //     (bool result, ) = msg.sender.call{value: 25000000 gwei}("");
        //     require(result, "Transfer failed.");
        // }
    //}

    // function setRoot(bytes32 newRoot) external onlyOwner {
    //     _root = newRoot;
    // }

    function withdraw() external {
        require(msg.sender == _withdrawer, "You are not an owner");
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent);
    }

    // function _leaf(address account, uint256 tokenId, bool isAL)
    // internal pure returns (bytes32)
    // {
    //     return keccak256(abi.encodePacked(account, tokenId, isAL));
    // }

    // function _verify(bytes32 leaf, bytes32[] calldata proof)
    // internal view returns (bool)
    // {
    //     return MerkleProofLib.verify(proof, _root, leaf);
    // }

    function onERC721Received(
        address,
        address from,
        uint256 tokenId,
        bytes calldata
    ) external virtual returns (bytes4) {
        require(msg.sender == address(_collection), "Not from collection");
        if (tokenId >= _first_public_sale_token_id) {
            (bool result, ) = from.call{value: 33000000 gwei}("");
            require(result, "Transfer failed.");
        } else {
            (bool result, ) = from.call{value: 25000000 gwei}("");
            require(result, "Transfer failed.");
        }
        return RaytaiUnmint.onERC721Received.selector;
    }

    receive() external payable {}
}
