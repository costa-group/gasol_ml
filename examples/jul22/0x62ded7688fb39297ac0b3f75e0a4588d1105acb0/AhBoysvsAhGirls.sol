// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./ERC721A.sol";
import "./Ownable.sol";

contract AhBoysvsAhGirls is ERC721A, Ownable {
  
  uint256 public mintPrice = 0.088 ether;
  uint256 public presalePrice = 0.068 ether;

  string _baseTokenURI;

  bool public isActive = false;
  bool public isPresaleActive = false;

  uint256 public MAX_SUPPLY = 1000;
  uint256 public maximumAllowedTokensPerPurchase = 50;
  uint256 public maximumAllowedTokensPerWallet = 10;
  uint256 public presaleMaximumTokensPerWallet = 200;

  mapping(address => bool) private _allowList;

  constructor(string memory baseURI) ERC721A("Ah Boys vs Ah Girls", "ABAG") {
    setBaseURI(baseURI);
  }

  modifier saleIsOpen {
    require(totalSupply() <= MAX_SUPPLY, "Sale has ended.");
    _;
  }

  modifier onlyAuthorized() {
    require(owner() == msg.sender);
    _;
  }

  function setMaximumAllowedTokens(uint256 _count) public onlyAuthorized {
    maximumAllowedTokensPerPurchase = _count;
  }

  function setMaximumAllowedTokensPerWallet(uint256 _count) public onlyAuthorized {
    maximumAllowedTokensPerWallet = _count;
  }

  function setPresaleMaximumTokensPerWallet(uint256 maxMint) external  onlyAuthorized {
    presaleMaximumTokensPerWallet = maxMint;
  }

  function addToAllowList(address[] calldata addresses) external onlyAuthorized {
    for (uint256 i = 0; i < addresses.length; i++) {
      require(addresses[i] != address(0), "Can't add a null address");
      _allowList[addresses[i]] = true;
    }
  }

  function checkIfOnAllowList(address addr) external view returns (bool) {
    return _allowList[addr];
  }

  function removeFromAllowList(address[] calldata addresses) external onlyAuthorized {
    for (uint256 i = 0; i < addresses.length; i++) {
      require(addresses[i] != address(0), "Can't add a null address");
      _allowList[addresses[i]] = false;
    }
  }

  function setMaxMintSupply(uint256 maxMintSupply) external  onlyAuthorized {
    MAX_SUPPLY = maxMintSupply;
  }

  function setPrice(uint256 _price) public onlyAuthorized {
    mintPrice = _price;
  }

  function setPresalePrice(uint256 _preslaePrice) public onlyAuthorized {
    presalePrice = _preslaePrice;
  }

  function toggleSaleStatus() public onlyAuthorized {
    isActive = !isActive;
  }

  function togglePresaleStatus() external onlyAuthorized {
    isPresaleActive = !isPresaleActive;
  }

  function setBaseURI(string memory baseURI) public onlyAuthorized {
    _baseTokenURI = baseURI;
  }


  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  function airdrop(uint256 _count, address _address) external onlyAuthorized {
    uint256 supply = totalSupply();

    require(supply + _count <= MAX_SUPPLY, "Total supply exceeded.");
    require(supply <= MAX_SUPPLY, "Total supply spent.");

    _safeMint(_address, _count);
  }

  function batchAirdrop(uint256 _count, address[] calldata addresses) external onlyAuthorized {
    uint256 supply = totalSupply();

    require(supply + _count <= MAX_SUPPLY, "Total supply exceeded.");
    require(supply <= MAX_SUPPLY, "Total supply spent.");

    for (uint256 i = 0; i < addresses.length; i++) {
      require(addresses[i] != address(0), "Can't add a null address");
      _safeMint(addresses[i], _count);
    }
  }

  function mint(uint256 _count) public payable saleIsOpen {
    uint256 mintIndex = totalSupply();

    require(isActive, "Sale is not active currently.");
    require(mintIndex + _count <= MAX_SUPPLY, "Total supply exceeded.");
    require(balanceOf(msg.sender) + _count <= maximumAllowedTokensPerWallet, "Max holding cap reached.");
    require( _count <= maximumAllowedTokensPerPurchase, "Exceeds maximum allowed tokens");
    require(msg.value >= mintPrice * _count, "Insufficient ETH amount sent.");

    _safeMint(msg.sender, _count);
    
  }

  function preSaleMint(uint256 _count) public payable saleIsOpen {
    uint256 mintIndex = totalSupply();
    require(isPresaleActive, "Presale is not active");
    require(_allowList[msg.sender], 'You are not on the Allow List');
    require(mintIndex < MAX_SUPPLY, "All tokens have been minted");
    require(balanceOf(msg.sender) + _count <= presaleMaximumTokensPerWallet, "Cannot purchase this many tokens");
    require(msg.value >= presalePrice * _count, "Insuffient ETH amount sent.");

    _safeMint(msg.sender, _count);
  }

  function withdraw() external onlyAuthorized {
    uint balance = address(this).balance;
    payable(owner()).transfer(balance);
  }
}