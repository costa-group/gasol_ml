// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "ERC721.sol";
import "ERC721Enumerable.sol";
import "ERC721URIStorage.sol";
import "Ownable.sol";
import "Counters.sol";
import "ReentrancyGuard.sol";


contract GumboLimboClub is ERC721, ERC721Enumerable, ERC721URIStorage, ReentrancyGuard, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    bool public saleIsActive = false;
    string private _baseURIextended;

    uint256 public constant MAX_SUPPLY = 34;
    uint256 public constant MAX_PUBLIC_MINT = 5;
    uint256 public constant PRICE_PER_TOKEN = 0.2 ether;
    bool public revealed = false;
    string public _notRevealedURI;

    constructor() ERC721("GumboLimboClub", "GumLi") {
        _tokenIdCounter.increment();
    }

    function reveal() public onlyOwner(){
        revealed = true;
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;       
    }  

    function baseURI() public view virtual returns (string memory) {
        return _baseURI();
    }

    function setNotRevealedURI(string memory notRevealedURI_) external onlyOwner() {
        _notRevealedURI = notRevealedURI_;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner() {
        _baseURIextended = baseURI_;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {   
        if(revealed == false){
            return _notRevealedURI;

        }
        return super.tokenURI(tokenId);
    }

    function setSaleState(bool newState) public onlyOwner() {
        saleIsActive = newState;
    }

    function PublicMint(uint256 numberOfTokens) public payable nonReentrant{
        require(_tokenIdCounter.current() + numberOfTokens <= MAX_SUPPLY, "Exceeded max token supply");
        require(saleIsActive, "Sale must be active to mint tokens");
        require(numberOfTokens <= MAX_PUBLIC_MINT, "Exceeded max token purchase");
        require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");

        for (uint256 i = 0; i < numberOfTokens; i++){
            _safeMint(msg.sender,_tokenIdCounter.current());
            _tokenIdCounter.increment();
        }
    }
    function reserveGumboLimbos(uint256 numberOfTokens) public onlyOwner() {        
        for (uint256 i = 0; i < numberOfTokens; i++){
            _safeMint(msg.sender,_tokenIdCounter.current());
            _tokenIdCounter.increment();
        }
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    function withdraw() public onlyOwner() {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
    receive() external payable {}
}
