// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9 <0.9.0;

import "./Counters.sol";
import "./SimpleTokensSafe.sol";

/// title This abstract sets up a locale token tracker for an unlimited number of mintable tokens
///  with innumerable generations, incrementing tokenIds on each new mint.
/// author Kenny Zen (https://kennyzen.co)
/// dev This safe contract mints generational NFTs. Info on how the various aspects of safe contracts
///  fit together are documented in the safe contract Complex Cipher.
abstract contract GenerationTokens is SimpleTokensSafe {

  using Strings for uint256;
  using Counters for Counters.Counter;

  address public executive = 0x736E8502bFf0af7189ed82fF58D1501e860A88a7; // the official Ethereum account of Kenny Zen

  /// dev Emitted when a new token is minted.
  event TokenMinted(uint256 indexed tokenId, address indexed minter);

  /// dev Emitted when the supply of tokens for this locale changes.
  event TokenCountUpdated(uint256 indexed supply);

  string private _generationCID; // the IPFS content identifier of the current generation of tokens

  Counters.Counter private _generation; // keeps track of the current generation of tokens
  Counters.Counter private _tokenCount; // keeps track of the number of minted tokens

  uint256 public premium = 0.07 ether; // subsidy required to mint one (1) token
  uint256 public maxTokensPerMint = 1; // maximum number of tokens allowed per mint

  uint256 internal _mintableSupply; // total supply of mintable tokens

  mapping(uint256 => address) public minter; // map of tokenIds to original token holder
  mapping(uint256 => string) internal _tokenCID; // map of tokenIds to IPFS content identifier

  /**
   * dev The constructor instantiates the ERC721 standard contract using _localeName and _localeSymbol,
   *  creates a new locale for these tokens, pauses the contract and gives birth to the genesis generation of tokens.
   * param _localeName The name of this locale ("Kenny Zen Genesis")
   * param _localeSymbol The symbol of this locale ("ZEN")
   * param _genesisCID The content identifier for the genesis generation of tokens ("QmWsszxdYUh2rdUD7jKBdTnnmJrWbBf3YPZNAR5zNnf8TD")
   * param _initialSupply The initial supply of tokens for the genesis generation (7)
   */
  constructor(
    string memory _localeName,
    string memory _localeSymbol,
    string memory _genesisCID,
    uint256 _initialSupply)
    ERC721(_localeName, _localeSymbol) {
      baseURI = "ipfs://";
      dateDeployed = block.timestamp;
      locale = bytes4(keccak256(abi.encodePacked(_localeName, _localeSymbol, dateDeployed)));
      pause(true);
      bearTokens(_genesisCID, _initialSupply);
  }

  /**
   * dev Throws if the sender is a contract.
   */
  modifier addressOnly() {
    require(tx.origin == _msgSender(), "No contracts :(");
    _;
  }

  /**
   * dev Throws if the _mintAmount is noncompliant, or if there are no more mintable tokens.
   * param _mintAmount The number of tokens to check for compliance.
   */
  modifier mintCompliance(uint256 _mintAmount) {
    if (_msgSender() != owner()) {
      require(_mintAmount > 0 && _mintAmount <= maxTokensPerMint, "Invalid mint amount!");
    }
    require(_tokenCount.current() + _mintAmount <= _mintableSupply, "No more mintables :(");
    _;
  }

  /**
   * dev Throws if called by any account other than the original token holder.
   * param _tokenId The tokenId of the token for which to check for ownership
   */
  modifier onlyMinter(uint256 _tokenId) {
    require(minter[_tokenId] == _msgSender(), "You ain't OG :(");
    _;
  }

  /**
   * dev Throws if called by any account other than the current or orignial token holder.
   * param _tokenId The tokenId of the token for which to check for ownership
   */
  modifier onlyOwned(uint256 _tokenId) {
    require(ownerOf(_tokenId) == _msgSender() || minter[_tokenId] == _msgSender()
    , "Not the owner :(");
    _;
  }

  /**
   * dev Set up the minted token. This assigns the address of the orignal holder and asssigns the
   *  content identifier of the location where the token's metadata lives on IPFS.
   * param _tokenId The tokenId of the token to set up
   * param _minter The address of the original minter
   */
  function _structureToken(uint256 _tokenId, address _minter) private {
    _tokenCID[_tokenId] = _generationCID;
    minter[_tokenId] = _minter;
    emit TokenMinted(_tokenId, _minter);
  }

  /**
   * dev Set up the minted token. Be sure to include this within the mint function of any
   *  derivative safe contract to give the tokens their structure and generational context.
   *  Overrides should call `super.structureToken(_tokenId,_minter)`.
   * param _tokenId The tokenId of the token to set up
   * param _minter The address of the original minter
   */
  function structureToken(uint256 _tokenId, address _minter) internal virtual {
    _structureToken(_tokenId, _minter);
  }

  /**
   * dev Get the number of generations that have been borne.
   * return The current number of generations
   */
  function generations() public view returns (uint256) {
    return _generation.current();
  }

  /**
   * dev Get the number of tokens that have been minted.
   * return The current token count
   */
  function totalSupply() public view returns (uint256) {
    return _tokenCount.current();
  }

  /**
   * dev Increment the token count and fetch the latest mintable token.
   * return The next tokenId to mint
   * notice The initial tokenId is 1.
   */
  function nextToken() internal virtual returns (uint256) {
    _tokenCount.increment();
    return _tokenCount.current();
  }

  /**
   * dev Get the number of tokens still available to be minted.
   * return The available token count
   */
  function availableTokenCount() public view returns (uint256) {
    return _mintableSupply - totalSupply();
  }

  /**
   * dev Get the metadata URI for a particular token. Throws if the token has never been minted.
   * param _tokenId The tokenId of the token for which to retrieve metadata
   */
  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    require(_exists(_tokenId), "Token does not exist!");
    return string(abi.encodePacked(baseURI, _tokenCID[_tokenId], "/", _tokenId.toString()));
  }

  /**
   * dev Get the tokens owned by a particular wallet address by tokenId.
   * param _owner The account to check for ownership
   */
  function tokensByOwner(address _owner) public view returns (uint256[] memory) {
    uint256 balance = balanceOf(_owner);
    uint256[] memory owned = new uint256[](balance);
    uint256 i = 0;
    uint256 currentId = 1;
    while (i < balance && currentId <= _tokenCount.current()) {
      address currentTokenOwner = ownerOf(currentId);
      if (currentTokenOwner == _owner) {
        owned[i] = currentId;
        i++;
      }
      currentId++;
    }
    return owned;
  }

  /**
   * Mint a number of tokens to the _receiver.
   * dev Callable internally only.
   * param _mintAmount The number of tokens to mint
   * param _receiver The address of the account to which to mint _mintAmount of tokens
   */
  function _mintLoop(address _receiver, uint256 _mintAmount) internal {
    for (uint256 i = 0; i < _mintAmount; i++) {
      uint256 _id = nextToken();
      _safeMint(_receiver, _id);
      _structureToken(_id, _receiver);
    }
    emit TokenCountUpdated(totalSupply());
  }

  /**
   * Mint a number of tokens to the sender.
   * dev Callable by any address (no contracts). Throws if the provided subsidy is noncompliant.
   * param _mintAmount The number of tokens to mint
   */
  function mint(uint256 _mintAmount) public payable addressOnly nonReentrant whenNotPaused mintCompliance(_mintAmount) {
    // minter must send a subsidy matching or exceeding the premium per token
    require(msg.value >= premium * _mintAmount, "Value sent is incorrect :(");
    _augment(owner(), msg.value);
    _mintLoop(_msgSender(), _mintAmount);
  }

  /**
   * Mint a number of tokens to the _receiver, courtesy of the contract owner. For giveaways ;)
   * dev Callable by the owner of this contract only.
   * param _mintAmount The number of minted tokens to airdrop
   * param _receiver The address of the account to which to gift the minted tokens
   */
  function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
    _mintLoop(_receiver, _mintAmount);
  }

  /**
   * Assign an address to act as the executive.
   * dev Callable by the owner of this contract only.
   * param _newExec The address of the new executive
   */
  function setExecutive(address _newExec) external onlyOwner {
    require(_newExec != address(0) && _newExec != burn, "Cannot assign burn as executive.");
    executive = _newExec;
  }

  /**
   * Update the premium per token.
   * dev Callable by the owner of this contract only. The minter must send a subsidy matching or
   *  exceeding this premium. Throws if the contract is not paused.
   * param _perTokenPremium The pecuniary amount of the subsidy required to mint a token in wei
   */
  function setPremium(uint256 _perTokenPremium) public onlyOwner whenPaused {
    premium = _perTokenPremium;
  }

  /**
   * Update the maxium number of tokens allowed to be minted per transaction.
   * dev Callable by the owner of this contract only. Throws if the contract is not paused.
   * param _maxTokens The address of the new executive
   */
  function setMaxTokensPerMint(uint256 _maxTokens) public onlyOwner whenPaused {
    maxTokensPerMint = _maxTokens;
  }

  /**
   * Update the content identifier for the current generation of tokens.
   * dev Callable by the owner of this contract only. Theoretically, this would be called only
   *  in the event of a mistake or a severe change. Throws if the contract is not paused, or the
   *  _cId is invalid.
   * param _cId The updated IPFS content identifier
   */
  function setCID(string memory _cId) public onlyOwner whenPaused {
    require(bytes(_cId).length == 46, "CID missing or invalid.");
    _generationCID = _cId;
  }

  /**
   * Update the supply of mintable tokens for the current generation.
   * dev Callable by the owner of this contract only. Theoretically, this would be called only in
   *  the event of a mistake or a severe change, whereby the `_generationCID` is also updated.
   *  Throws if the contract is not paused.
   * param _supply The new mintable supply of tokens
   */
  function setSupply(uint256 _supply) public onlyOwner whenPaused {
    require(_supply >= totalSupply(), "Total supply cannot be depleted.");
    _mintableSupply = _supply;
  }

  /**
   * Bear the next generation of mintable tokens for this contract.
   * dev Callable by the owner of this contract only. Throws if the contract is not paused, the current
   *  generation of tokens is still being minted, the updated supply of tokens is the cipher (0), or the
   *  _cId is invalid.
   * param _cId The IPFS content identifier of the new generation of tokens
   * param _generationSupply The supply of tokens for the new generation
   */
  function bearTokens(string memory _cId, uint256 _generationSupply) public onlyOwner whenPaused {
    require(availableTokenCount() == 0 && _generationSupply > 0, "Progression not possible.");
    require(bytes(_cId).length == 46, "CID missing or invalid.");
    _mintableSupply += _generationSupply;
    _generationCID = _cId;
    _generation.increment();
  }

  /**
   * Withdraw all subsidies, splitting a percentage with the `executive`.
   * dev Callable by the owner of this contract only. Throws if the subsidized balance is less than
   *  100 wei, whereupon the payment splitter would malfunction.
   * notice WARNING: If ownership is renounceable, renouncing contract ownership will cause this
   *  function to throw, leaving any subsidies thereupon unclaimable.
   */
  function claim() external override onlyOwner {
    address _owner = owner();
    uint256 _withdrawn = account(_owner);
    require(_withdrawn > 99, "Insufficient funds :(");
    _send(_owner, executive, _withdrawn * 15 / 100); // 15% goes to the executive.
    _send(_owner, _owner, account(_owner));
    emit SubsidiesCollected(_withdrawn);
  }

}
