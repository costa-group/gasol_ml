// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9 <0.9.0;

import "./Counters.sol";
import "./SimpleTokensSafe.sol";

/**
 *                                                                                                    
 *                                              *((.                                                  
 *                                        (((((((((((/                                                
 *                                       .(((((((((((((,                                              
 *                                                 ((((((                                             
 *                                                   ((((((                                           
 *                              /((((((((              ((((((                                         
 *                       .(((((((((((((((               (((((((                                       
 *                        ((((((((((                  *((((((((((                                     
 *                            /(((((,                (((((( /((((((         _____                     
 *                            ((((((((((            (((((*    (((((((  (((((((((((((),                
 *                            ((((((((((((((       (((((        ((((((((((((((((((((().               
 *                           (((((    *((((((((, ((((((          (((((((.                             
 *                           (((((        ((((((((((((         (((((((((((                            
 *                          (((((/            ((((((          (((((,  ((((((                          
 *                   ((((((((((((                            (((((*     ((((((                        
 *              (((((((((((((((((((((                        (((((       ,((((((                      
 *           ((((((((('    (((((((((((((                     (((((         .(((((             __      
 *         (((((((         (((((   (((((((                   (((((,                         (((('     
 *        ((((((          (((((      *(((((                   (((((,                       (((((      
 *       (((((.           (((((        (((((                   ((((((                    ((((((       
 *      ((((((           ((((((        *(((((                    (((((((              ((((((()        
 *      (((((.           (((((          (((((                      ((((((((((((((((((((((()           
 *      ((((((             ""          ,(((((                         '((((((((((((((()'              
 *       (((((.                        (((((                               """"""""                   
 *       .((((((                     ((((()                                                           
 *        ((((((((                 (((((()                                                            
 *         (((((((((();.      /(((((((()                                                              
 *          (((((((((((((((((((((((()                                                                 
 *          ((((('   '(((((((()'                                                                      
 *           (((((                                                                                    
 *           .(((((                                                                                   
 *            (((((                                                                                   
 *             (((((                                                                                  
 *             ((((((                                                                                 
 *              (((((                                                                                 
 *              .(((((                                                                                
 *                ((((                                                                                
 *                                                                                                    
 *
 *  title Pecan Milk Coop Generational Non-Fungible Tokens
 *  author Pecan Milk Cooperative, LLC <heypecanmilk.com>
 *  notice This contract mints generational NFTs created by various artists of the Pecan Milk Coop.
 *   This abstract in particular, which increments tokenIds for each new mint, is a locale token
 *   tracker or a limited number of mintable PMC tokens per any number of new generations. A record
 *   is kept for each token holder and the tokens minted for each generation become increasingly
 *   historic as each new generation of tokens is borne.
 */
abstract contract PMCTokens is SimpleTokensSafe {

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

  uint256 public premium = 0 ether; // subsidy required to mint one (1) token in wei
  uint256 public maxTokensPerMint = 1; // maximum number of tokens allowed per mint
  uint256 public airdropsPerMinter = 1; // maximum number of airdrops allowed per minter

  uint256 internal _mintableSupply; // total supply of mintable tokens

  mapping(uint256 => address) public minter; // map of tokenIds to original token holder
  mapping(address => uint256) public airdropsAllowed; // map of minter addresses to number of allowed airdrops
  mapping(address => uint256) public airdropsOf; // map of minter addresses to number of minted airdrops
  mapping(uint256 => string) internal _tokenCID; // map of tokenIds to IPFS content identifier

  bool public airdropsOpen = true; // indicates if minter addresses can get airdrops or use their allowed airdrops

  /**
   * dev The constructor instantiates the ERC721 standard contract using _localeName and _localeSymbol,
   *  creates a new locale for these tokens, pauses the contract and gives birth to the genesis generation of tokens.
   * param _localeName The name of this locale ("Pecan Milk Coop")
   * param _localeSymbol The symbol of this locale ("PECAN")
   * param _genesisCID The content identifier for the genesis generation of tokens ("QmWssz")
   * param _initialSupply The initial supply of tokens for the genesis generation (25)
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
      generate(_genesisCID, _initialSupply);
  }

  /**
   * dev Throws if called by a contract or any account other than the sender.
   */
  modifier onlyMinter() {
    require(tx.origin == _msgSender(), "Only minters :(");
    _;
  }

  /**
   * dev Throws if the _mintAmount is noncompliant, or if there are no more mintable tokens.
   * param _mintAmount The number of tokens to check for compliance
   */
  modifier mintCompliance(uint256 _mintAmount) {
    if (premium == 0 && msg.value >= _mintAmount * 0.5 ether) {
      // the premium is naught but the subsidy provided is substantial enough to pass as compliant
      _augment(owner(), msg.value); // the Coop will accept the substantial subsidy
    } else if (_msgSender() != owner()) { // calls by the Coop account pass this compliance check
      require(_mintAmount > 0 && _mintAmount <= maxTokensPerMint, "Invalid mint amount!");
      if (premium == 0) { // the token will be airdropped when the premium is naught
        require(airdropsOf[_msgSender()] + _mintAmount <= airdropsPerMinter, "Maximum airdrops exceeded :(");
        if (msg.value > 0) { // the premium is naught but still a subsidy was provided
          _augment(owner(), msg.value); // the Coop will accept the subsidy as a small donation
        }
      }
    } else if (msg.value > 0) { // the Coop itself has provided a subsidy to the account of the executive
      _augment(executive, msg.value);
    }
    require(_tokenCount.current() + _mintAmount <= _mintableSupply, "No more mintables :(");
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
   * Airdrop a number of tokens to the sender.
   * dev Callable by any address. Throws if airdrops are not open or the sender has an invalid
   *  number of allowed airdrops.
   * param _mintAmount The number of tokens to airdrop
   */
  function airDrop(uint256 _mintAmount) public payable nonReentrant onlyMinter whenNotPaused mintCompliance(_mintAmount) {
    require(airdropsOpen && airdropsAllowed[_msgSender()] >= _mintAmount, "Insufficient airdrops allowed :(");
    airdropsAllowed[_msgSender()] -= _mintAmount;
    airdropsOf[_msgSender()] += _mintAmount;
    _mintLoop(_msgSender(), _mintAmount);
  }

  /**
   * Airdrop a number of tokens to the _receiver, courtesy of the Coop. For giveaways ;)
   * dev Callable by the Coop account only.
   * param _mintAmount The number of tokens to airdrop
   * param _receiver The address of the account to which to gift the minted tokens
   */
  function airDropForAddress(uint256 _mintAmount, address _receiver) public payable nonReentrant onlyOwner mintCompliance(_mintAmount) {
    _mintLoop(_receiver, _mintAmount);
  }

  /**
   * Mint a number of tokens to the sender.
   * dev Callable by any address. Throws if the provided subsidy is noncompliant.
   * param _mintAmount The number of tokens to mint
   */
  function mint(uint256 _mintAmount) public payable nonReentrant onlyMinter whenNotPaused mintCompliance(_mintAmount) {
    if (premium > 0) { // there is a premium to mint _mintAmount of tokens
      // minter must send a subsidy matching or exceeding the premium per token
      require(msg.value >= premium * _mintAmount, "Value sent is incorrect :(");
      _augment(owner(), msg.value);
      if (airdropsOpen) { // airdrops are open
        airdropsAllowed[_msgSender()] += 1; // minter gets one (1) airdrop per mint transaction
      }
    } else { // the _mintAmount of tokens are airdropped
      airdropsOf[_msgSender()] += _mintAmount;
    }
    _mintLoop(_msgSender(), _mintAmount);
  }

  /**
   * Assign an address to act as the executive.
   * dev Callable by the Coop account only.
   * param _newExec The address of the new executive
   */
  function setExecutive(address _newExec) external onlyOwner {
    require(_newExec != address(0) && _newExec != burn, "Cannot assign burn as executive.");
    executive = _newExec;
  }

  /**
   * Update the premium per token.
   * dev Callable by the Coop account only. The minter must send a subsidy matching or
   *  exceeding this premium. Throws if the contract is not paused.
   * param _perTokenPremium The pecuniary amount of the subsidy required to mint a token in wei
   */
  function setPremium(uint256 _perTokenPremium) public onlyOwner whenPaused {
    premium = _perTokenPremium;
  }

  /**
   * Update the maxium number of tokens allowed to be minted per transaction.
   * dev Callable by the Coop account only. Throws if the contract is not paused.
   * param _maxTokens The maximum number of tokens allowed per mint transaction
   */
  function setMaxTokensPerMint(uint256 _maxTokens) public onlyOwner whenPaused {
    maxTokensPerMint = _maxTokens;
  }

  /**
   * Update whether minters can get or use airdrops.
   * dev Callable by the Coop account only. Throws if the contract is not paused.
   * param _open Indicates whether airdrops are open as a boolean value
   */
  function setAirdropsOpen(bool _open) public onlyOwner whenPaused {
    airdropsOpen = _open;
  }

  /**
   * Update the maxium number of airdrops allowed to be minted for every minter address.
   * dev Callable by the Coop account only. Throws if the contract is not paused.
   * param _maxAirdops The maximum number of airdrops allowed for each minter
   */
  function setAirdropsPerMinter(uint256 _maxAirdops) public onlyOwner whenPaused {
    airdropsPerMinter = _maxAirdops;
  }

  /**
   * Update the content identifier for the current generation of tokens.
   * dev Callable by the Coop account only. Theoretically, this would be called only
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
   * dev Callable by the Coop account only. Theoretically, this would be called only in
   *  the event of a mistake or a severe change, whereby the `_generationCID` is also updated.
   *  Throws if the contract is not paused.
   * param _supply The new mintable supply of tokens
   */
  function setSupply(uint256 _supply) public onlyOwner whenPaused {
    require(_supply >= totalSupply(), "Total supply cannot be depleted.");
    _mintableSupply = _supply;
  }

  /**
   * Bear the next generation of mintable tokens by the Coop.
   * dev Callable by the Coop account only. Throws if the contract is not paused, the current
   *  generation of tokens is still being minted, the updated supply of tokens is the cipher (0),
   *  or the _cId is invalid.
   * param _cId The IPFS content identifier of the new generation of tokens
   * param _generationSupply The supply of tokens for the new generation
   */
  function generate(string memory _cId, uint256 _generationSupply) public onlyOwner whenPaused {
    require(availableTokenCount() == 0 && _generationSupply > 0, "Progression not possible.");
    require(bytes(_cId).length == 46, "CID missing or invalid.");
    _mintableSupply += _generationSupply;
    _generationCID = _cId;
    _generation.increment();
  }

  /**
   * Withdraw all subsidies, splitting a percentage with the `executive`.
   * dev Callable by the Coop account only. Throws if the subsidized balance is less than
   *  100 wei, whereupon the payment splitter would malfunction.
   */
  function claim() external override onlyOwner {
    address _owner = owner(); // the Coop account
    uint256 _withdrawn = account(_owner);
    require(_withdrawn > 99, "Insufficient funds :(");
    _send(_owner, executive, _withdrawn / 100); // 1% goes to the executive
    _send(_owner, _owner, account(_owner));
    emit SubsidiesCollected(_withdrawn);
  }

}
