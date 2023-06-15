/*



&&#&
&#P!^!PGP55Y55PGB&G!~?PGJ~:. .:!JB
B.                .^?P~   .#P^   ~JYJ~   ^5&
&P^   !GGB#####BPY~   ^B&:   !&7   ~BB7. .G5!!7Y#
~   5~   ~&:   J&~   7&#&^    ?
~   PG:   ?#GPGGB#&BPYYY5G&#.   5?   ~&#BGGB#^    G
~   G&B5!   .?&#J^       :~JB5^       .~    GG    G&GJ!:.     .^?BB555Y.    ?JJYP
!   5BGPYJ7~:   .~Y#5.   !5GG5J~   ~B#~   .?PGPY^     G7   ~J.   .!J55Y7.   J?          .:^J&
B!.          :~7YG#?   .PY   !&^   ^#7    G&^   ?J::~5&B:   J&P55Y.   ~#&
B!.   ~J7:   ^Y&P    ^G&&&&#BY^  :PJ   .#G    B#.   YBG#&#BPY?!~^^:.   ^#.   7
?   J&G?:  .7P!    . ..:..  :75&^   !Y   .B^   ?P~   GBJ~.  .:~!7??^   :&B    ?
J   ?&P!.  ^J#?    Y#P555PG#~   ~#:   .#P   .5BY^   ^PY    7B&!   :&B    ?
J   !#Y^  .!5#&#^   .5&&GY!~5G.   J##Y.    .#G^   ^JY5YJ!:    ~57    ?B&&&#BY~    :&&^   !&BG&
G.   PG!.   .P&J^.  .^~~^:.  .~P#?:   :::  :7    GG?^.      .^75B&Y~.   ...   ^:   .&B^   ~?: .G
#P5P&#57!Y&#PY?777??YPB&&BPY???YG&Y~^!B&BBGGB#&&BP55Y5PB#G~:^JGY?7?YG&



*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './ERC721A.sol';
import './Strings.sol';

contract BlueFragment is ERC721A {

     // library
    using Strings for uint256;

    // constant
    uint constant public maxMint = 3;
    uint constant public maxTotal = 6666;
    uint constant public mintTime = 1655125200;
    
    // attributes
    bool public freeMintOpen = false;
    bool public blindBoxOpen = false;
    address public withdrawAddress;
    string public baseTokenURI;
    string public blindTokenURI;
    mapping(address => uint) public buyRecord;
    
    // modifiers
    modifier onlyOwner {
        require(msg.sender == withdrawAddress, "not owner");
        _;
    }

    constructor(string memory name, string memory symbol, string memory _blindTokenURI) ERC721A(name, symbol)  {
        blindTokenURI = _blindTokenURI;
        withdrawAddress = msg.sender;
    }

    //Free Mint
    function freeMint(uint256 num) public {
        uint256 supply = totalSupply();
        require(freeMintOpen, "not open");
        require(num + buyRecord[msg.sender] <= maxMint, "You can mint a maximum of 3 NFT");
        require(supply + num <= maxTotal, "Exceeds maximum NFT supply");
        require(block.timestamp >= mintTime, "no mint time");

        buyRecord[msg.sender] += num;
        _safeMint(msg.sender, num);
    }

    //Only Owner
    function getAirDrop(address recipient, uint16 _num) public onlyOwner {
        _safeMint(recipient, _num);
    }

    function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
        withdrawAddress = _withdrawAddress;
    }

    function setFreeMintOpened() public onlyOwner {
        freeMintOpen = !freeMintOpen;
    }

    function setBlindBoxOpened() public onlyOwner {
        blindBoxOpen = !blindBoxOpen;
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function setBlindTokenURI(string memory _blindTokenURI) public onlyOwner {
        blindTokenURI = _blindTokenURI;
    }

    function withdrawAll() public onlyOwner {
        (bool success, ) = withdrawAddress.call{value : address(this).balance}("");
        require(success, "withdrawAddress error");
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');

        if (blindBoxOpen) {
            string memory baseURI = _baseURI();
            return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
        } else {
            return blindTokenURI;
        }
    }
}