// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import 'openzeppelin/contracts/access/Ownable.sol';
import 'erc721a/contracts/ERC721A.sol';
import 'openzeppelin/contracts/utils/Strings.sol';
import 'openzeppelin/contracts/utils/math/SafeMath.sol';
import 'openzeppelin/contracts/utils/Address.sol';

contract TrashPlanet is ERC721A, Ownable {
  using Strings for uint256;

  uint256 public maxSupply = 2022;

  uint256 public maxFreeAmount = 1000;
  uint256 public currentFreeAmount = 0;
  uint256 public maxFreePerWallet = 1;
  uint256 public maxPerTx = 5;
  uint256 public price = 0.006 ether;

  mapping(address => bool) public isNew;
  bool public mintEnabled = false;
  bool public isRevealed = true;
  mapping(address => uint256) private _mintedFreeAmount;
  string public baseURI = '';
  string public hiddenURI = '';

  constructor() ERC721A('Trash', 'TRA') {
    _safeMint(msg.sender, 5);
  }

  function mint(uint256 amount) external payable {
    uint256 allCost;
    if (isNew[msg.sender] == false && currentFreeAmount + 1 <= maxFreeAmount) {
      allCost = (amount - maxFreePerWallet) * price;
      currentFreeAmount++;
      isNew[msg.sender] = true;
    } else {
      allCost = amount * price;
    }

    require(amount > 0, 'Amount error');
    require(amount <= maxPerTx, 'Max per TX reached.');
    require(tx.origin == msg.sender, 'Yo!!!');
    require(mintEnabled, 'Minting is not live yet.');
    require(msg.value >= allCost, 'Please send the exact amount.');
    require(totalSupply() + amount <= maxSupply, 'No more');

    _safeMint(msg.sender, amount);
  }

  function setBaseURI(string memory _baseURI) external onlyOwner {
    baseURI = _baseURI;
  }

  function setHiddenURI(string memory _hiddenURI) external onlyOwner {
    hiddenURI = _hiddenURI;
  }

  function setRevealed(bool _state) external onlyOwner {
    isRevealed = _state;
  }

  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');

    if (isRevealed == false) return hiddenURI;

    return string(abi.encodePacked(baseURI, _tokenId.toString(), '.json'));
  }

  function setPrice(uint256 _newPrice) external onlyOwner {
    price = _newPrice;
  }

  function setMaxPerTx(uint256 _amount) external onlyOwner {
    maxPerTx = _amount;
  }

  function setMaxFreeAmount(uint256 _amount) external onlyOwner {
    maxFreeAmount = _amount;
  }

  function setMaxFreePerWallet(uint256 _amount) external onlyOwner {
    maxFreePerWallet = _amount;
  }

  function flipSale() external onlyOwner {
    mintEnabled = !mintEnabled;
  }

  function withdraw() external onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}('');
    require(success, 'Transfer failed.');
  }
}
