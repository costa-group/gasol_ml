// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

contract H4CChristmasEdition is ERC721A, ERC721ABurnable, ERC721AQueryable, Ownable {
    IERC721Enumerable public constant originalCollection = IERC721Enumerable(0xde76E34DB5cc2E1e1A3e80e2dDC19EfBc91Ab012);
    uint32 public constant christmasStartTime = 1671926400;
    uint32 public constant christmasEndTime = 1672012800;

    mapping(uint256 => bool) public h4cTokenUsed;
    
    string private _baseTokenURI = "https://h4c.mypinata.cloud/ipfs/QmWhEujozDqNj6w52eUzC7E9jGMKAMAEMoQbjgmUofhY2M/";

    constructor() ERC721A("H4C Christmas edition", "H4C") {}

    function claimGift() external {
        require(block.timestamp >= christmasStartTime && block.timestamp <= christmasEndTime, "Christmas is over");
        uint256 balance = originalCollection.balanceOf(msg.sender);
        require(balance > 1, "Not enough tokens to claim reward");
        uint256 count;
        unchecked{
            for(uint256 i = 0; i < balance; i++){
                uint256 token = originalCollection.tokenOfOwnerByIndex(msg.sender, i);
                if(!h4cTokenUsed[token]){
                    count++;
                    h4cTokenUsed[token] = true;
                    if(count == 20){
                        break;
                    }
                }
            }
        }

        require(count > 1, "Not enough tokens to claim reward");
        if(count % 2 == 1) {
            h4cTokenUsed[originalCollection.tokenOfOwnerByIndex(msg.sender, balance - 1)] = false;
        }

        _safeMint(msg.sender, count / 2);
    }

    function getAvailableTokens(address owner) external view returns(uint256){
        uint256 balance = originalCollection.balanceOf(owner);
        if(balance < 2){
            return 0;
        }
        uint256 count;
        unchecked{
            for(uint256 i = 0; i < balance; i++){
                uint256 token = originalCollection.tokenOfOwnerByIndex(owner, i);
                if(!h4cTokenUsed[token]){
                    count++;
                }
            }
        }
        return count / 2;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }
}
