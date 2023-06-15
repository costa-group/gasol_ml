// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/utils/math/SafeMath.sol";

import {LibStrings} from "../shared/libraries/LibStrings.sol";
import {AppStorage, MemberShip} from "../libraries/LibAppStorage.sol";
// import "hardhat/console.sol";
import {LibMeta} from "../shared/libraries/LibMeta.sol";

import {LibDiamond} from "../libraries/LibDiamond.sol";

import {LibOffchainSig} from "../libraries/LibOffchainSig.sol";
import {LibAccessControl} from "../libraries/LibAccessControl.sol";
import {LibRoles} from "../libraries/LibRoles.sol";

import "hardhat/console.sol";

import {IERC721} from "../interfaces/IERC721.sol";
import {IERC721Enumerable} from "../interfaces/IERC721Enumerable.sol";

contract TokenMemberFacet is IERC721, IERC721Enumerable {
  using Counters for Counters.Counter;
  AppStorage internal s;
  using SafeMath for uint256;

  event RenewMembership(
    address indexed member,
    uint256 tokenId,
    uint32 daysExtended
  );

  /// notice returns membership expiration day of membership
  // param tokenId - token id of membership
  function getExpirationDate(uint256 _tokenId)
    public
    view
    returns (uint256 ttl_)
  {
    require(_exists(_tokenId), "Provenance: Token does not exist");
    address member_ = s.members[_tokenId];
    return s.memberships[member_].ttl;
  }

  /// notice returns price of membership for 1 year period in wei
  function getPrice() external view returns (uint256) {
    return s.price;
  }

  /// notice returns price of membership for 1 dat period in wei

  function getPricePerDay(uint256 daysMultiplier)
    public
    view
    returns (uint256)
  {
    return s.pricePerDay * daysMultiplier;
  }

  /// notice extends membership TTL to current TTL + _daysToExtend
  /// param _tokenId token id of membership to extend
  /// param _daysToExtend number of days to extend membership
  function extendMembership(uint256 _tokenId, uint32 _daysToExtend)
    external
    payable
  {
    _enforceContractNotPaused();
    require(
      s.extensionEnabled,
      "Provenance: Extension is currently disabled"
    );
    require(
      _daysToExtend >= s.MIN_DAYS_TO_EXTEND,
      "Provenance: Can not extend membership for this amount of days"
    );
    require(
      msg.value >= getPricePerDay(_daysToExtend),
      "Provenance: Incorrect amount sent"
    );
    require(_exists(_tokenId), "Provenance: Token does not exist");

    address member_ = s.members[_tokenId];
    uint256 newTTL;

    if (_isExpired(_tokenId)) {
      newTTL = block.timestamp + (_daysToExtend * 1 days);
      require(
        newTTL <= s.GLOBAL_TERM_LIMIT,
        "Provenance: Exceeds term limit"
      );
      s.memberships[member_].ttl = newTTL;
    } else {
      newTTL = s.memberships[member_].ttl + (_daysToExtend * 1 days);
      require(
        newTTL <= s.GLOBAL_TERM_LIMIT,
        "Provenance: Exceeds term limit"
      );
      s.memberships[member_].ttl = newTTL;
    }

    emit RenewMembership(member_, _tokenId, _daysToExtend);
  }

  //----------------------------------------------------------------
  /// notice claim is the mint functionality for this SBT contract.
  /// dev use in conjunction with the offchain signature library to create verifyable signatures
  /// param  msgHash_ created by offchain signer
  /// param  signature_ signature created by offchain signer
  function claim(bytes32 msgHash_, bytes calldata signature_) external payable {
    _enforceContractNotPaused();
    _enforceClaimNotPaused();
    address to = LibMeta.msgSender();
    require(msg.value >= s.price, "Insufficient funds");
    require(
      LibOffchainSig._verifyMsg(to, 1, msgHash_, signature_, s.offchainSigner),
      "INVALID_SIG"
    );
    require(s.tokenIdCounter.current() + 1 <= s.MAX_SUPPLY, "SOLD_OUT");
    _safeMint(to);
  }

    //--------------------------------------------------------------
  /// notice claimDelegate is the mint functionality for this SBT contract.
  /// dev use in conjunction with the offchain signature library to create verifyable signatures
  /// param  msgHash_ created by offchain signer
  /// param  signature_ signature created by offchain signer
  function claimDelegate(address to_, bytes32 msgHash_, bytes calldata signature_) external payable {
    _enforceContractNotPaused();
    _enforceClaimNotPaused();
    require(msg.value >= s.price, "Insufficient funds");
    require(
      LibOffchainSig._verifyMsg(LibMeta.msgSender(), 1, msgHash_, signature_, s.offchainSigner),
      "INVALID_SIG"
    );
    require(s.tokenIdCounter.current() + 1 <= s.MAX_SUPPLY, "SOLD_OUT");
    _safeMint(to_);
  }



  function devMint(address to_) external {
    LibAccessControl.enforceRole(
      LibAccessControl.getRoleAdmin(LibRoles.ADMIN_ROLE)
    );
    _safeMint(to_);
  }

  //----------------------------------------------------------------
  /// notice safeMint wrapper for minting SBT.
  /// dev function is used to implement Counter.counter to iterate tokenIds
  /// param to_ shall be msg.sender. caller claim() enforces that.
  function _safeMint(address to_) internal {
    uint256 tokenId = s.tokenIdCounter.current();
    s.tokenIdCounter.increment();
    _mint(to_, tokenId);
    emit Transfer(address(0), to_, tokenId);
  }

  //----------------------------------------------------------------
  /// notice internal mint function
  /// dev function is used to implement the actual mint and sets TTL of membership
  /// param to shall be msg.sender.
  function _mint(address to, uint256 tokenId) internal virtual {
    require(to != address(0), "ERC721: mint to the zero address");
    require(!_exists(tokenId), "ERC721: token already minted");

    _beforeTokenTransfer(address(0), to, tokenId);

    uint256 ttl = block.timestamp + 365 days;
    require(ttl <= s.GLOBAL_TERM_LIMIT, "Provenance: TTL exceeds limit");

    s.members[tokenId] = to;
    s.memberships[to] = MemberShip({memberId: uint32(tokenId), ttl: ttl});
  }

  //----------------------------------------------------------------
  /// notice checks if supplied tokenId exists
  /// param tokenId to check
  function _exists(uint256 tokenId) internal view virtual returns (bool) {
    return s.members[tokenId] != address(0);
  }

  //----------------------------------------------------------------
  /// notice override of ERC721 token transfers.
  /// dev address(0) needs to be implemented to allow transfer during minting
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal pure {
    require(
      from == address(0) || to == address(0),
      "Provenance: Not allowed to transfer Soulbond Token"
    );
  }

  ///notice Query the universal totalSupply of all NFTs ever minted
  ///return totalSupply_ the number of all NFTs that have been minted
  function totalSupply() external view returns (uint256 totalSupply_) {
    totalSupply_ = s.tokenIdCounter.current();
  }

  /// notice Count all NFTs assigned to an owner
  /// dev NFTs assigned to the zero address are considered invalid, and this.
  ///  function throws for queries about the zero address.
  /// param _member An address for whom to query the balance
  /// return balance_ The number of NFTs owned by `_owner`, possibly zero
  function balanceOf(address _member) external view returns (uint256 balance_) {
    require(
      _member != address(0),
      "Provenance: _member can't be address(0)"
    );
    uint256 memberTokenId = s.memberships[_member].memberId;
    if (memberTokenId > 0 && !_isExpired(_member)) {
      return 1;
    } else {
      return 0;
    }
  }

  /// notice Get all the Ids of NFTs owned by an address
  /// param  _member The address to check for the NFTs
  /// return tokenId_ an array of unsigned integers,each representing the tokenId of each NFT
  function tokensOfOwner(address _member)
    external
    view
    returns (uint32 tokenId_)
  {
    _enforceActiveMembership(_member);

    return s.memberships[_member].memberId;
  }

  /// notice Find the owner of an NFT
  /// dev NFTs assigned to zero address are considered invalid, and queries
  ///  about them do throw.
  /// param _tokenId The identifier for an NFT
  /// return owner_ The address of the owner of the NFT
  function ownerOf(uint256 _tokenId) external view returns (address) {
    address owner_ = s.members[_tokenId];
    _enforceActiveMembership(owner_);
    require(owner_ != address(0), "Provenance: invalid _tokenId");
    return owner_;
  }

  /// notice Query if an address is an authorized operator for another address
  /// param _owner The address that owns the NFTs
  /// param _operator The address that acts on behalf of the owner
  /// return approved_ True if `_operator` is an approved operator for `_owner`, false otherwise
  function isApprovedForAll(address _owner, address _operator)
    external
    view
    returns (bool approved_)
  {
    revert("ERC721: Approve disabled for this Soul Bond Token");
  }

  /// notice Transfers the ownership of an NFT from one address to another address
  /// dev Throws unless `LibMeta.msgSender()` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
  ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
  ///  `onERC721Received` on `_to` and throws if the return value is not
  ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
  /// param _from The current owner of the NFT
  /// param _to The new owner
  /// param _tokenId The NFT to transfer
  /// param _data Additional data with no specified format, sent in call to `_to`
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes calldata _data
  ) external {
    address sender = LibMeta.msgSender();
    internalTransferFrom(sender, _from, _to, _tokenId);
  }

  /// notice Transfers the ownership of an NFT from one address to another address
  /// dev This works identically to the other function with an extra data parameter,
  ///  except this function just sets data to "".
  /// param _from The current owner of the NFT
  /// param _to The new owner
  /// param _tokenId The NFT to transfer
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external {
    address sender = LibMeta.msgSender();
    internalTransferFrom(sender, _from, _to, _tokenId);
  }

  /// notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
  ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
  ///  THEY MAY BE PERMANENTLY LOST
  /// dev Throws unless `LibMeta.msgSender()` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT.
  /// param _from The current owner of the NFT
  /// param _to The new owner
  /// param _tokenId The NFT to transfer
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external {
    internalTransferFrom(LibMeta.msgSender(), _from, _to, _tokenId);
  }

  // This function is used by transfer functions
  function internalTransferFrom(
    address _sender,
    address _from,
    address _to,
    uint256 _tokenId
  ) internal pure {
    require(_to != address(0), "Provenance: Can't transfer to 0 address");
    require(_from != address(0), "Provenance: _from can't be 0 address");

  }

  /// notice Change or reaffirm the approved address for an NFT
  /// dev The zero address indicates there is no approved address.
  /// param _approved The new approved NFT controller
  /// param _tokenId The NFT to approve
  function approve(address _approved, uint256 _tokenId) external {
    revert("Provenance: Listing this SBT is disabled");
  }

  /// notice Enable or disable approval for a third party ("operator") to manage
  ///  all of `LibMeta.msgSender()`'s assets
  /// dev Emits the ApprovalForAll event. The contract MUST allow
  ///  multiple operators per owner.
  /// param _operator Address to add to the set of authorized operators
  /// param _approved True if the operator is approved, false to revoke approval
  function setApprovalForAll(address _operator, bool _approved) external {
    revert("Provenance: Listing this SBT is disabled");
  }

  ///notice Return the universal name of the NFT
  function name() external view returns (string memory) {
    // return "SBT Name";
    return s.name;
  }

  /// notice An abbreviated name for NFTs in this contract
  function symbol() external view returns (string memory) {
    //return "SBT Symbol";
    return s.symbol;
  }

  /// notice the base URI that points to the metadata link for each token
  function baseURI() external view returns (string memory) {
    return s.tokenURI;
  }

  /// notice A distinct Uniform Resource Identifier (URI) for a given asset.
  /// dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
  ///  3986. The URI may point to a JSON file that conforms to the "ERC721
  ///  Metadata JSON Schema".
  function tokenURI(uint256 _tokenId) external view returns (string memory) {
    return LibStrings.strWithUint(s.tokenURI, _tokenId); //Here is your URL!
  }

  /// notice internal burn function that deletes token
  function _burn(uint256 _tokenId) internal {
    _enforceContractNotPaused();
    delete s.members[_tokenId];

    //note s.totalSupply shall not be decremented.
    // otherwise the membership can be overwritten and reclaimed.
  }

  /// notice allows users to burn their token
  function burn(uint256 _tokenId) external {
    address owner = s.members[_tokenId];
    require(owner == LibMeta.msgSender(), "TokenMember: Only owner can burn");
    _burn(_tokenId);
  }

  /// notice allows admin to revoke memberships
  function revoke(uint256 _tokenId) external {
    LibAccessControl.enforceRole(
      LibAccessControl.getRoleAdmin(LibRoles.ADMIN_ROLE)
    );
    _burn(_tokenId);
  }

  /// notice implement function to be ERC721 compliant.
  /// Function should not do anything
  function getApproved(uint256 tokenId)
    external
    view
    returns (address operator)
  {}

  function _isExpired(uint256 _tokenId)
    internal
    view
    returns (bool expiration)
  {
    uint256 expirationDate = getExpirationDate(_tokenId);
    if (expirationDate > block.timestamp) {
      return false;
    } else {
      return true;
    }
  }

  function _isExpired(address _member) internal view returns (bool expiration) {
    uint256 membershipTTL = getExpirationDate(s.memberships[_member].memberId);
    if (membershipTTL > block.timestamp) {
      return false;
    } else {
      return true;
    }
  }

  function _enforceContractNotPaused() internal view {
    require(!s.contractIsPaused, "Contract is paused");
  }

  function _enforceClaimNotPaused() internal view {
    require(!s.claimIsPaused, "Contract is paused");
  }

  function _enforceActiveMembership(address _member) internal view {
    require(!_isExpired(_member), "Provenance: Membership expired");
  }

  /// notice implement function to be ERC721 compliant.
  /// Function should not do anything
  function tokenOfOwnerByIndex(address owner, uint256 index)
    external
    view
    override
    returns (uint256)
  {}

  /// notice implement function to be ERC721 compliant.
  /// Function should not do anything
  function tokenByIndex(uint256 index)
    external
    view
    override
    returns (uint256)
  {}
}
