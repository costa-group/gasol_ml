// SPDX-License-Identifier: MIT
/*
 .
 .      *77777/'           77777#'    `(777777         `&7777       `(777777*              `(77777/'
 .      777'`            777777          7777&             `77         7777777#               `7%
 .     7#              #77777            7777%               `7        7  %77777&              7,
 .    7              .77777              7777#          ,              7    *777777            &
 .                  77777.               7777%        .7,              7      .777777          &
 .                77777%                 7777&    _.(777,              7         777777        &
 .              777777                   7777%     `,777,              7           777777      &
 .            %77777                     7777#        `7,              7             777777    &
 .          ,77777                7      7777#          ,       ,7     7               777777, &
 .         77777.               %7       7777%                 &,      7                 7777777
 .       77777(              ,777       .77777               /77       7                   #7777
 .    .77777&            ,;77777.     ,;777777.          ,/7777     ,;777:.                  &77
 .
 .
 .   Simple Tokens by Kenny Zen Edition ERC721 Vaulted
 .   Updated Sunday, June 19, 2022
 .
 .   This contract contains a safe.
 .   Scroll down :)
 .
*/

pragma solidity >=0.8.9 <0.9.0;

import "./Vaulted.sol";
import "./Ownable.sol";
import "./Pausable.sol";
import "./ERC721.sol";

/// title This contract conforms to the ERC721 non-fungible token standard. It can be used to mint
///  special distinguishable assets called tokens, each ownable by an Ethereum wallet.
/// author Kenny Zen (https://kennyzen.co)
/// dev This safe contract keeps track of a collection of NFTs and also contains a vault which can
///  secure an account of entrusted funds for any address. Info on how the various of aspects of safe
///  contracts fit together are documented in the safe contract Complex Cipher.
abstract contract SimpleTokensSafe is ERC721, Ownable, Pausable, Vaulted {

  using Strings for uint256;

  /// dev Emitted when the contract's entire subsidized balance has been claimed.
  event SubsidiesCollected(uint256 indexed amountWithdrawn);

  bytes4 public locale; // locale selector for this contract

  string public baseURI; // base URI to get token metadata
  string private _contractURI; // URL to get contract-level metadata

  uint256 public dateDeployed; // timestamp of the block within which this contract was added to Ethereum

  mapping(uint256 => mapping(address => bool)) public tokenHeld; // map of tokenIds to any token holder ever

  /**
  * Function overrides
  */
  /// Called before any token transfer. dev See {ERC721-_beforeTokenTransfer}.
  function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId) internal virtual override {
    super._beforeTokenTransfer(_from, _to, _tokenId);
  }

  /// Called after any token transfer. dev See {ERC721-_afterTokenTransfer}.
  function _afterTokenTransfer(address _from, address _to, uint256 _tokenId) internal virtual override {
    // address of the new holder of _tokenId is recorded once transfer completes
    tokenHeld[_tokenId][_to] = true;
    super._afterTokenTransfer(_from, _to, _tokenId);
  }

  /// dev See {IERC165-supportsInterface}.
  function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
    return super.supportsInterface(_interfaceId);
  }

  /// Override the function called to renounce contract ownership.
  /// dev Overrides {Ownable-renounceOwnership} by throwing instead. Removing this override function
  ///  will make ownership of this contract completely renounceable. Renouncing contract ownership
  ///  will then assign control of this contract to the cipher (0) address to be LOST FOREVER.
  function renounceOwnership() public view virtual override {
    revert("Ownership is not renounceable.");
  }

  /**
   * dev Throws if called by any account other than the token holder.
   * param _tokenId The tokenId of the token to check for ownership
   */
  modifier onlyHolder(uint256 _tokenId) {
    require(ownerOf(_tokenId) == _msgSender(), "You don't hold this token :(");
    _;
  }

  /**
   * dev Determine if a particular wallet address holds a token.
   * param _holder The account to check for ownership
   */
  function isTokenHolder(address _holder) public view returns (bool) {
    if (balanceOf(_holder) > 0) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * dev Determine if a particular token of this contract has been minted.
   * param _tokenId The tokenId of the token to validate existence
   */
  function isTokenMinted(uint256 _tokenId) external view returns (bool) {
    return _exists(_tokenId);
  }

  /**
   * dev Get the storefront-level metadata URL for this contract.
   */
  function contractURI() external view returns (string memory) {
    return _contractURI;
  }

  /**
   * Get the metadata URI for a particular token.
   * dev Throws if the token has never been minted.
   * param _tokenId The tokenId of the token for which to retrieve metadata
   */
  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    require(_exists(_tokenId), "Token does not exist!");
    return string(abi.encodePacked(baseURI, _tokenId.toString()));
  }

  /**
   * Set the base metadata URL for the tokens of this contract.
   * dev Callable by the owner of this contract only.
   * param _uri The URI pointing to the token metadata
   */
  function setBaseURI(string memory _uri) public onlyOwner {
    baseURI = _uri;
  }

  /**
   * Set the storefront-level metadata URL for this contract.
   * dev Callable by the owner of this contract only.
   * param _uri The URL pointing to the contract's metadata
   */
  function setContractURI(string memory _uri) public onlyOwner {
    _contractURI = _uri;
  }

  /**
   * Pause or unpause the contract.
   * dev Callable by the owner of this contract only. Throws if the `paused` status has not changed.
   * param _paused The value to which to update the `paused` status of the contract as a boolean
   */
  function pause(bool _paused) public virtual onlyOwner {
    if (_paused) {
      _pause();
    } else {
      _unpause();
    }
  }

  /**
   * dev Claim the entire subsidized balance for the owner of this contract. Callable by the owner
   *  of this contract only.
   * notice WARNING: If ownership is renounceable, calling this function after renouncing contract
   *  ownership will cause this function to throw, leaving any subsidies thereupon unclaimable.
   */
  function _recover() internal {
    address _owner = owner();
    uint256 _withdrawn = account(_owner);
    _send(_owner, _owner, _withdrawn);
    emit SubsidiesCollected(_withdrawn);
  }

  /**
   * Withdraw all subsidies.
   * dev Callable by the owner of this contract only. Does not throw if the subsidized balance
   *  is a cipher (0).
   * notice WARNING: If ownership is renounceable, renouncing contract ownership will cause this
   *  function to throw, leaving any subsidies thereupon unclaimable.
   */
  function claim() external virtual onlyOwner {
    _recover();
  }

  /**
   * Transfer an NFT that has been sent to this contract directly.
   * dev Callable by the owner of this contract only. Throws if the NFT is not owned by this contract
   *  or the _receiver is a contract which does not implement `onERC721Received`.
   * param _implementation Address of the _tokenId's ERC721 compliant contract
   * param _receiver Address of the account or contract to which to send the token
   * param _tokenId The tokenId of the token of the _implementation contract
   */
  function transferNFT(address _implementation, address _receiver, uint256 _tokenId) public onlyOwner {
    IERC721(_implementation).safeTransferFrom(address(this), _receiver, _tokenId);
  }

  /**
   * dev Implementation of the `onERC721Received` function ensures that calls can be made to this
   *  contract safely to receive non-fungible tokens.
   */
  function onERC721Received(address, address, uint256, bytes calldata) external virtual returns (bytes4) {
    return this.onERC721Received.selector;
  }

  /**
   * dev The `receive` function executes on calls made to this contract to receive ether with no data.
   */
  receive() virtual override external payable {
    /// The ether sent is added to the trust of the contract owner only. dev See {Vaulted-_augment}.
    _augment(owner(), msg.value);
  }

}