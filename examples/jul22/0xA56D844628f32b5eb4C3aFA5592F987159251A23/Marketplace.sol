// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma abicoder v2;

import "Ownable.sol";
import "IERC721.sol";
import "ReentrancyGuard.sol";

contract Marketplace is Ownable, ReentrancyGuard {
	address public tokenContractAddress; // ERC721 NFT contract address
	address public communityOwnerAddress; // community owner, provide in constructor
	address public companyAddress; // company address, provide in constructor

	string public name; // contract name
	uint16 public totalSupply; // number of NFTs in circulation
	uint16 public royalty; // royalty percentege (expressed in ten-thousandths 0-10000, this gives two decimal resolution)
	uint16 public companyShare; // percentage of Galaxis' share from the owner's royalty
	IERC721 private tokenContract; // ERC721 NFT token contract

	struct Offer {
		bool isForSale; // cariable to check sale status
		address seller; // seller address
		uint256 value; // in ether
		address onlySellTo; // specify to sell only to a specific person
	}

	struct Bid {
		bool hasBid; // variable to check bid status
		address bidder; // bidder address
		uint256 value; // in ether
	}

	// map offers and bids for each token
	mapping(uint256 => Offer) public cardsForSale; // list of cards of for sale
	mapping(uint256 => Bid) public cardBids; // list of bids on cards
	mapping(address => bool) public permitted; // permitted to modify owner royalty

	event OfferForSale(address _from, address _to, uint16 _tokenId, uint256 _value);
	event OfferExecuted(address _from, address _to, uint16 _tokenId, uint256 _value);
	event OfferRevoked(address _from, address _to, uint16 _tokenId, uint256 _value);

	event ModifyOfferValue(address _from, uint16 _tokenId, uint256 _value);
	event ModifyOfferSellTo(address _from, uint16 _tokenId, address _sellOnlyTo);
	event ModifyOfferBoth(address _from, uint16 _tokenId, uint256 _value, address _sellOnlyTo);

	event BidReceived(address _from, address _to, uint16 _tokenId, uint256 _newValue, uint256 _prevValue);
	event BidAccepted(address _from, address _to, uint16 _tokenId, uint256 _value);
	event BidRevoked(address _from, address _to, uint16 _tokenId, uint256 _value);

	event RoyaltyChanged(address _from, uint16 _royalty);
	event CompanyShareChanged(address _from, uint16 _share);
	event CommunityOwnerAddressChanged(address _address);
	event CompanyOwnerAddressChanged(address _address);

	modifier onlyAllowed() {
		require(permitted[msg.sender], "Unauthorised");
		_;
	}

	constructor(
		string memory _name,
		address _tokenContractAddress,
		address _communityOwnerAddress,
		address _companyAddress,
		uint16 _totalSupply,
		uint16 _royalty
	) {
		require(royalty <= 10000, "Royalty value should be below 10000.");
		name = _name; // set the name for display purposes
		tokenContractAddress = _tokenContractAddress;
		communityOwnerAddress = _communityOwnerAddress;
		companyAddress = _companyAddress;
		totalSupply = _totalSupply;
		royalty = _royalty;
		companyShare = 100;

		tokenContract = IERC721(_tokenContractAddress); // initialize the NFT contract
		permitted[msg.sender] = true; // sender is going to be permitted to change royalty
		permitted[communityOwnerAddress] = true; // community owner address
	}

	function _split(address _seller, uint256 _amount) internal {
		uint256 royaltyAmount = (royalty * _amount) / 10000; // community owner's royalty
		uint256 companyAmount = (royaltyAmount * companyShare) / 10000; // company's royalty from the owner's royalty
		uint256 sellerAmount = _amount - royaltyAmount;
		royaltyAmount -= companyAmount;
		bool sent;

		(sent, ) = _seller.call{ value: sellerAmount }("");
		require(sent, "Failed to send ether");
		(sent, ) = communityOwnerAddress.call{ value: royaltyAmount }("");
		require(sent, "Failed to send ether");
		(sent, ) = companyAddress.call{ value: companyAmount }("");
		require(sent, "Failed to send ether");
	}

	// set the percentage for royalty (expressed in ten-thousandths)
	function setCommunityOwnerRoyalty(uint16 _royalty) external onlyAllowed {
		require(_royalty < 10000, "Royalty over 100%.");
		royalty = _royalty;

		emit RoyaltyChanged(msg.sender, royalty);
	}

	// set the percentage for royalty (expressed in ten-thousandths)
	function setCompanyShare(uint16 _share) external onlyOwner {
		require(_share < 10000, "Share over 100%.");
		companyShare = _share;

		emit CompanyShareChanged(msg.sender, _share);
	}

	// change community owner address
	function setCommunityOwnerAddress(address _communityOwner) external onlyOwner {
		require(_communityOwner != address(0), "Cannot be ZERO address.");
		permitted[communityOwnerAddress] = false;
		permitted[_communityOwner] = true;
		communityOwnerAddress = _communityOwner;

		emit CommunityOwnerAddressChanged(_communityOwner);
	}

	// change company address
	function setCompanyAddress(address _companyAddress) external onlyOwner {
		require(_companyAddress != address(0), "Cannot be ZERO address.");
		companyAddress = _companyAddress;

		emit CommunityOwnerAddressChanged(_companyAddress);
	}

	function offerCardForSale(uint16 _tokenId, uint256 _minPriceInWei) external {
		// check if the contract is approved by token owner
		require(tokenContract.isApprovedForAll(msg.sender, address(this)), "Contract is not approved.");
		// check if the offerer owns the card
		require(msg.sender == tokenContract.ownerOf(_tokenId), "Sender does not own this token.");
		// check if card id is correct
		require(_tokenId < totalSupply, "Token ID should be smaller than total supply.");
		// check if price is set to higher than 0
		require(_minPriceInWei > 0, "Price should be higher than 0.");
		// initialize offer for only 1 buyer - _sellOnlyTo
		cardsForSale[_tokenId] = Offer(true, msg.sender, _minPriceInWei, address(0));

		// emit sale event
		emit OfferForSale(msg.sender, address(0), _tokenId, _minPriceInWei);
	}

	function offerCardForSale(
		uint16 _tokenId,
		uint256 _minPriceInWei,
		address _sellOnlyTo
	) external {
		// check if the contract is approved by token owner
		require(tokenContract.isApprovedForAll(msg.sender, address(this)), "Contract is not approved.");
		// check if the offerer owns the card
		require(msg.sender == tokenContract.ownerOf(_tokenId), "Sender does not own this token.");
		// check if card id is correct
		require(_tokenId < totalSupply, "Token ID should be smaller than total supply.");
		// check if price is set to higher than 0
		require(_minPriceInWei > 0, "Price should be higher than 0.");
		// make sure sell only to is not 0x0
		require(_sellOnlyTo != address(0), "Sell only to address cannot be null.");
		// initialize offer for only 1 buyer - _sellOnlyTo
		cardsForSale[_tokenId] = Offer(true, msg.sender, _minPriceInWei, _sellOnlyTo);

		// emit sale event
		emit OfferForSale(msg.sender, _sellOnlyTo, _tokenId, _minPriceInWei);
	}

	function modifyOffer(uint16 _tokenId, uint256 _value) external {
		Offer memory offer = cardsForSale[_tokenId];
		require(msg.sender == offer.seller, "Sender is not the seller of this token."); // check if the offer is active and the seller is the sender
		require(_value > 0, "Price should be higher than 0."); // change value has to be higher than 0
		// modify offer
		cardsForSale[_tokenId] = Offer(offer.isForSale, offer.seller, _value, offer.onlySellTo);

		// emit modification event
		emit ModifyOfferValue(msg.sender, _tokenId, _value);
	}

	function modifyOffer(uint16 _tokenId, address _sellOnlyTo) external {
		Offer memory offer = cardsForSale[_tokenId];
		require(msg.sender == offer.seller, "Sender is not the seller of this token."); // check if the offer is active and the seller is the sender
		// modify offer
		cardsForSale[_tokenId] = Offer(offer.isForSale, offer.seller, offer.value, _sellOnlyTo);

		// emit modification event
		emit ModifyOfferSellTo(msg.sender, _tokenId, _sellOnlyTo);
	}

	function modifyOffer(
		uint16 _tokenId,
		uint256 _value,
		address _sellOnlyTo
	) external {
		Offer memory offer = cardsForSale[_tokenId];
		// check if the offer is active and the seller is the sender
		require(msg.sender == offer.seller, "Sender is not the seller of this token."); // check if the offer is active and the seller is the sender
		// modify offer
		require(_value > 0, "Price should be higher than 0.");
		cardsForSale[_tokenId] = Offer(offer.isForSale, offer.seller, _value, _sellOnlyTo);
		emit ModifyOfferBoth(msg.sender, _tokenId, _value, _sellOnlyTo);
	}

	function revokeOffer(uint16 _tokenId) external {
		Offer memory offer = cardsForSale[_tokenId];
		// check if the offer is ours
		require(msg.sender == offer.seller, "Sender is not the seller of this token."); // check if the offer is active and the seller is the sender

		cardsForSale[_tokenId] = Offer(false, address(0), 0, address(0));
		emit OfferRevoked(offer.seller, offer.onlySellTo, _tokenId, offer.value);
	}

	function buyItNow(uint16 _tokenId) external payable nonReentrant {
		Offer memory offer = cardsForSale[_tokenId];
		// check if it for sale for someone specific
		if (offer.onlySellTo != address(0)) {
			// only sell to someone specific
			require(offer.onlySellTo == msg.sender, "This coin can be sold only for a specific address.");
		}

		// check approval status, user may have modified transfer approval
		require(tokenContract.isApprovedForAll(offer.seller, address(this)), "Contract is not approved.");

		// check if the offer is valid
		require(offer.seller != address(0), "This token is not for sale.");
		// check if offer value is correct
		require(offer.value > 0, "This token is not for sale.");
		// check if offer value and sent values march
		require(offer.value == msg.value, "Offer ask price and sent ETH mismatch.");
		// make sure buyer is not the owner
		require(msg.sender != tokenContract.ownerOf(_tokenId), "Buyer already owns this token.");
		// make sure the seller is the owner
		require(offer.seller == tokenContract.ownerOf(_tokenId), "Seller no longer owns this token.");

		// save the seller variable
		address seller = offer.seller;
		// reset offer for this card
		cardsForSale[_tokenId] = Offer(false, address(0), 0, address(0));

		// check if there were any bids on this card
		Bid memory bid = cardBids[_tokenId];
		if (bid.hasBid) {
			// save bid values and bidder variables
			address bidder = bid.bidder;
			uint256 amount = bid.value;
			// reset bid
			cardBids[_tokenId] = Bid(false, address(0), 0);
			// send back bid value to bidder
			bool sent;
			(sent, ) = bidder.call{ value: amount }("");
			require(sent, "Failed to send back ether to bidder.");
		}

		// first send the token to the buyer
		tokenContract.safeTransferFrom(seller, msg.sender, _tokenId);
		// transfer ether to acceptor and pay royalty to the community owner
		_split(seller, msg.value);

		// check if the user recieved the item
		require(tokenContract.ownerOf(_tokenId) == msg.sender);

		// emit event
		emit OfferExecuted(offer.seller, msg.sender, _tokenId, offer.value);
	}

	function bidOnCard(uint16 _tokenId) external payable nonReentrant {
		address cardOwner = tokenContract.ownerOf(_tokenId);
		// check if card id is valid
		require(_tokenId < totalSupply, "Token ID should be smaller than total supply.");
		// make sure the bidder is not the owner
		require(msg.sender != cardOwner, "Cannot bid on owned card.");
		// check if bid value is valid
		require(msg.value > 0, "Bid price has to be higher than 0.");

		// check if there were any bids on this card
		Bid memory bid = cardBids[_tokenId];
		if (bid.hasBid) {
			// the current bid has to be higher than the previous
			require(bid.value < msg.value, "Bid price is below current bid.");
			address previousBidder = bid.bidder;
			uint256 amount = bid.value;
			// pay back the previous bidder's ether
			bool sent;
			(sent, ) = previousBidder.call{ value: amount }("");
			require(sent, "Failed to send back ether to previous bidder.");
		}

		// initialize the bid with the new values
		cardBids[_tokenId] = Bid(true, msg.sender, msg.value);

		// emit event
		emit BidReceived(msg.sender, cardOwner, _tokenId, msg.value, bid.value);
	}

	function acceptBid(uint16 _tokenId) external {
		Bid memory bid = cardBids[_tokenId];

		// make sure there is a valid bid on the card
		require(bid.hasBid, "This token has no bid on it.");
		// check if the contract is still approved for transfer
		require(tokenContract.isApprovedForAll(msg.sender, address(this)), "Contract is not approved.");
		// check if the token id is valid
		require(_tokenId < totalSupply, "Token ID should be smaller than total supply.");
		// make sure the acceptor owns the card
		require(msg.sender == tokenContract.ownerOf(_tokenId), "Sender does not own this token.");

		// check if the card is offered for sale
		Offer memory offer = cardsForSale[_tokenId];
		if (offer.seller != address(0)) {
			// reset offer if the offer exits
			cardsForSale[_tokenId] = Offer(false, address(0), 0, address(0));
		}

		address buyer = bid.bidder;
		uint256 amount = bid.value;

		// reset bid
		cardBids[_tokenId] = Bid(false, address(0), 0);
		// transfer ether to acceptor and pay royalty to the community owner
		_split(msg.sender, amount);
		// send token from acceptor to the bidder
		tokenContract.safeTransferFrom(msg.sender, buyer, _tokenId);

		// check if the user receiver the
		require(tokenContract.ownerOf(_tokenId) == buyer);

		// emit event
		emit BidAccepted(msg.sender, bid.bidder, _tokenId, amount);
	}

	function revokeBid(uint16 _tokenId) external {
		Bid memory bid = cardBids[_tokenId];
		// check if the bid exists
		require(bid.hasBid, "This token has no bid on it.");
		// check if the bidder is the sender of the message
		require(bid.bidder == msg.sender, "Sender is not the current highest bidder.");
		// save bid value into a variable
		uint256 amount = bid.value;

		// reset bid
		cardBids[_tokenId] = Bid(false, address(0), 0);

		// transfer back their ether
		bool sent;
		(sent, ) = msg.sender.call{ value: amount }("");
		require(sent, "Failed to retrieve ether.");

		// emit event
		emit BidRevoked(msg.sender, bid.bidder, _tokenId, amount);
	}
}
