// SPDX-License-Identifier: MIT
// Original creator: discord: FrankB#5720
// Send a coffee to: 0x320f1a24565F1781EBc640f2d9539aDC753b518e
pragma solidity ^0.8.9;

import "openzeppelin/contracts/token/ERC721/ERC721.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/utils/Strings.sol";

contract CaptureTheBase is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private _baseURISuffix = ".json";
   
    //The current base level.
    uint public theBase = block.basefee;
    
    constructor() ERC721("CaptureTheBase", "CTB") {
        //Creating the Base NFT with tokenId 0
        safeMint(msg.sender);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmV4WYtC6Uw75QYSXCwH9Hb2xyKoHVHJNd8frsyGt43gux/";
    }

    function conquerTheBase()
        public
    {
        //Check if the Base may be conquered
        require(block.basefee < theBase);
        //Conquer the Base
        theBase = block.basefee;
        _transfer(ownerOf(0),msg.sender,0);
        _transferOwnership(msg.sender);
    }
    
    //Whoever owns the Base may mint as few or many tokens as they'd like.
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId), _baseURISuffix)) : "";
    }

}