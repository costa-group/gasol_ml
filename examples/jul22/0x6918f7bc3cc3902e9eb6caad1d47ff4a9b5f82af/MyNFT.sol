// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "./Ownable.sol";


//  sSSs   .S_sSSs    S.       .S       S.     sSSs   .S    S.    .S    sSSs    sSSs  
// d%%SP  .SS~YS%%b   SS.     .SS       SS.   d%%SP  .SS    SS.  .SS   d%%SP   d%%SP  
//d%S'    S%S   `S%b  S%S     S%S       S%S  d%S'    S%S    S%S  S%S  d%S'    d%S'    
//S%|     S%S    S%S  S%S     S%S       S%S  S%|     S%S    S%S  S%S  S%S     S%|     
//S&S     S%S    d*S  S&S     S&S       S&S  S&S     S%S SSSS%S  S&S  S&S     S&S     
//Y&Ss    S&S   .S*S  S&S     S&S       S&S  Y&Ss    S&S  SSS&S  S&S  S&S_Ss  Y&Ss    
//`S&&S   S&S_sdSSS   S&S     S&S       S&S  `S&&S   S&S    S&S  S&S  S&S~SP  `S&&S   
//  `S*S  S&S~YSSY    S&S     S&S       S&S    `S*S  S&S    S&S  S&S  S&S       `S*S  
//   l*S  S*S         S*b     S*b       d*S     l*S  S*S    S*S  S*S  S*b        l*S  
//  .S*P  S*S         S*S.    S*S.     .S*S    .S*P  S*S    S*S  S*S  S*S.      .S*P  
//sSS*S   S*S          SSSbs   SSSbs_sdSSS   sSS*S   S*S    S*S  S*S   SSSbs  sSS*S   
//YSS'    S*S           YSSP    YSSP~YSSY    YSS'    SSS    S*S  S*S    YSSP  YSS'    
//        SP                                                SP   SP                   
//        Y                                                 Y    Y                    
                                                                                    
contract SPLUSHIES is ERC721A, Ownable {
    uint256 public maxSupply = 5555;
    uint256 public maxPerWallet = 6;
    uint256 public maxPerTx = 2;
    uint256 public _price = 0 ether;

    bool public activated;
    string public unrevealedTokenURI =
        "https://gateway.pinata.cloud/ipfs/QmVXcpsWdkfmKH6nV5Lq8is2XZLgMF7X64bPkQDP6bcJsB";
    string public baseURI = "";

    mapping(uint256 => string) private _tokenURIs;

    address private _ownerWallet = 0x7faC9c8e998BB961181a2BB000A547351c9Be4C9;

    constructor( ) ERC721A("splushieswtf", "SPLUSHY") {
    }

    ////  OVERIDES
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return
            bytes(baseURI).length != 0
                ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json"))
                : unrevealedTokenURI;
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    ////  MINT
    function mint(uint256 numberOfTokens) external payable {
        require(activated, "Inactive");
        require(totalSupply() + numberOfTokens <= maxSupply, "All minted");
        require(numberOfTokens <= maxPerTx, "Too many for Tx");
        require(
            _numberMinted(msg.sender) + numberOfTokens <= maxPerWallet,
            "Too many for address"
        );
        _safeMint(msg.sender, numberOfTokens);
    }

    ////  SETTERS
    function setTokenURI(string calldata newURI) external onlyOwner {
        baseURI = newURI;
    }

    function setMaxPerTx(uint256 _maxPerTx) external onlyOwner {
        maxPerTx = _maxPerTx;
    }

    function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
        maxPerWallet = _maxPerWallet;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        maxSupply = _maxSupply;
    }

    function setIsActive(bool _isActive) external onlyOwner {
        activated = _isActive;
    }
}
