//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin/contracts/security/PausableUpgradeable.sol";
import "openzeppelin/contracts/security/ReentrancyGuardUpgradeable.sol";
import "openzeppelin/contracts/token/ERC721/IERC721Upgradeable.sol";
import "openzeppelin/contracts/token/ERC721/ERC721Upgradeable.sol";
import "openzeppelin/contracts/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "openzeppelin/contracts/utils/cryptography/draft-EIP712Upgradeable.sol";
import "openzeppelin/contracts/utils/math/SafeCastUpgradeable.sol";
import "openzeppelin/contracts/utils/AddressUpgradeable.sol";
import "./interfaces/sellerFinancing/ISellerFinancing.sol";
import "./interfaces/sanctions/SanctionsList.sol";
import "./interfaces/royaltyRegistry/IRoyaltyEngineV1.sol";
import "./flashClaim/interfaces/IFlashClaimReceiver.sol";
import "./lib/ECDSABridge.sol";

import "../test/common/Console.sol";

/// title NiftyApes Seller Financing
/// custom:version 1.0
/// author captnseagraves (captnseagraves.eth)

contract NiftyApesSellerFinancing is
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable,
    EIP712Upgradeable,
    ERC721Upgradeable,
    ERC721HolderUpgradeable,
    ISellerFinancing
{
    using AddressUpgradeable for address payable;

    /// dev Internal constant address for the Chainalysis OFAC sanctions oracle
    address private constant SANCTIONS_CONTRACT =
        0x40C57923924B5c5c5455c48D93317139ADDaC8fb;

    /// notice The base value for fees in the protocol.
    uint256 private constant MAX_BPS = 10_000;

    /// dev Constant typeHash for EIP-712 hashing of Offer struct
    ///      If the Offer struct shape changes, this will need to change as well.
    bytes32 private constant _OFFER_TYPEHASH =
        keccak256(
            "Offer(uint128 price,uint128 downPaymentAmount,uint128 minimumPrincipalPerPeriod,uint256 nftId,address nftContractAddress,address creator,uint32 periodInterestRateBps,uint32 periodDuration,uint32 expiration)"
        );

    // increaments by two for each loan, once for buyerNftId, once for sellerNftId
    uint256 private loanNftNonce;

    /// dev The stored address for the royalties engine
    address private royaltiesEngineAddress;

    /// dev The status of sanctions checks
    bool internal _sanctionsPause;

    // instead of address to nftId to struct, could create a loanHash from the address ID and loan ID/Nonce,
    // and use that as the pointer to the loan Struct. - ks

    /// dev A mapping for a NFT to a loan .
    ///      The mapping has to be broken into two parts since an NFT is denominated by its address (first part)
    ///      and its nftId (second part) in our code base.
    mapping(address => mapping(uint256 => Loan)) private _loans;

    /// dev A mapping to mark a signature as used.
    ///      The mapping allows users to withdraw offers that they made by signature.
    mapping(bytes => bool) private _cancelledOrFinalized;

    // could mint an NFT and have these in an inherited contract - ks

    // Mapping owner to nftContractAddress to token count
    mapping(address => mapping(address => uint256)) private _balances;

    // Mapping from owner to nftContractAddress to list of owned token IDs
    mapping(address => mapping(address => mapping(uint256 => uint256)))
        private _ownedTokens;

    // Mapping from nftContractAddress to token ID to index of the owner tokens list
    mapping(address => mapping(uint256 => uint256)) private _ownedTokensIndex;

    /// dev This empty reserved space is put in place to allow future versions to add new
    /// variables without shifting storage.
    uint256[500] private __gap;

    /// notice The initializer for the NiftyApes protocol.
    ///         NiftyApes is intended to be deployed behind a proxy and thus needs to initialize
    ///         its state outside of a constructor.
    function initialize(address newRoyaltiesEngineAddress) public initializer {
        EIP712Upgradeable.__EIP712_init("NiftyApes_SellerFinancing", "0.0.1");
        OwnableUpgradeable.__Ownable_init();
        PausableUpgradeable.__Pausable_init();
        ReentrancyGuardUpgradeable.__ReentrancyGuard_init();
        ERC721HolderUpgradeable.__ERC721Holder_init();
        ERC721Upgradeable.__ERC721_init(
            "NiftyApes Seller Financing Tickets",
            "BANANAS"
        );

        loanNftNonce = 0;
        royaltiesEngineAddress = newRoyaltiesEngineAddress;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function pauseSanctions() external onlyOwner {
        _sanctionsPause = true;
    }

    function unpauseSanctions() external onlyOwner {
        _sanctionsPause = false;
    }

    function getOfferHash(Offer memory offer) public view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        _OFFER_TYPEHASH,
                        offer.price,
                        offer.downPaymentAmount,
                        offer.minimumPrincipalPerPeriod,
                        offer.nftId,
                        offer.nftContractAddress,
                        offer.creator,
                        offer.periodInterestRateBps,
                        offer.periodDuration,
                        offer.expiration
                    )
                )
            );
    }

    function getOfferSigner(
        Offer memory offer,
        bytes memory signature
    ) public view override returns (address) {
        return ECDSABridge.recover(getOfferHash(offer), signature);
    }

    function getOfferSignatureStatus(
        bytes memory signature
    ) external view returns (bool) {
        return _cancelledOrFinalized[signature];
    }

    function withdrawOfferSignature(
        Offer memory offer,
        bytes memory signature
    ) external whenNotPaused {
        _requireAvailableSignature(signature);
        _requireSignature65(signature);
        address signer = getOfferSigner(offer, signature);
        _requireSigner(signer, msg.sender);
        _markSignatureUsed(offer, signature);
    }

    function buyWithFinancing(
        Offer memory offer,
        bytes memory signature
    ) external payable whenNotPaused nonReentrant {
        address seller = getOfferSigner(offer, signature);
        _require721Owner(offer.nftContractAddress, offer.nftId, seller);
        _requireAvailableSignature(signature);
        _requireSignature65(signature);
        _requireIsNotSanctioned(seller);
        _requireIsNotSanctioned(msg.sender);
        // requireOfferisValid
        require(offer.nftContractAddress != address(0), "00004");
        _requireOfferNotExpired(offer);
        Loan storage loan = _getLoan(offer.nftContractAddress, offer.nftId);
        // requireNoOpenLoan
        require(loan.periodBeginTimestamp == 0, "00006");
        // require24HourMinimumDuration
        require(offer.periodDuration >= 1 days, "00006");
        // ensure msg.value is sufficient for downPayment
        require(msg.value >= offer.downPaymentAmount, "00047");
        require(
            offer.price > offer.downPaymentAmount,
            "price must be greater than down payment"
        );
        require(
            (offer.price - offer.downPaymentAmount) >
                offer.minimumPrincipalPerPeriod,
            "Issue: principal per period"
        );

        // mark signature as used
        _markSignatureUsed(offer, signature);

        // if msg.value is too high, return excess value
        if (msg.value > offer.downPaymentAmount) {
            payable(msg.sender).sendValue(msg.value - offer.downPaymentAmount);
        }

        uint256 totalRoyaltiesPaid = _payRoyalties(
            offer.nftContractAddress,
            offer.nftId,
            msg.sender,
            offer.downPaymentAmount
        );

        // payout seller
        payable(seller).sendValue(offer.downPaymentAmount - totalRoyaltiesPaid);

        // mint buyer nft
        uint256 buyerNftId = loanNftNonce;
        loanNftNonce++;
        _safeMint(msg.sender, buyerNftId);

        // mint seller nft
        uint256 sellerNftId = loanNftNonce;
        loanNftNonce++;
        _safeMint(seller, sellerNftId);

        // create loan
        _createLoan(
            loan,
            offer,
            sellerNftId,
            buyerNftId,
            (offer.price - offer.downPaymentAmount)
        );

        // Transfer nft from seller to this contract, revert on failure
        _transferNft(
            offer.nftContractAddress,
            offer.nftId,
            seller,
            address(this)
        );

        _addLoanToOwnerEnumeration(
            msg.sender,
            offer.nftContractAddress,
            offer.nftId
        );

        emit LoanExecuted(
            offer.nftContractAddress,
            offer.nftId,
            seller,
            signature,
            loan
        );
    }

    function makePayment(
        address nftContractAddress,
        uint256 nftId
    ) external payable whenNotPaused nonReentrant {
        Loan storage loan = _getLoan(nftContractAddress, nftId);
        address buyerAddress = ownerOf(loan.buyerNftId);
        address sellerAddress = ownerOf(loan.sellerNftId);

        _requireIsNotSanctioned(buyerAddress);
        _requireIsNotSanctioned(msg.sender);
        _requireOpenLoan(loan);
        require(
            _currentTimestamp32() <
                loan.periodEndTimestamp + loan.periodDuration,
            "cannot make payment, past soft grace period"
        );

        uint256 totalMinimumPayment;
        uint256 periodInterest;

        // if in the current period, else prior to period minimumPayment and interest should remain 0
        if (_currentTimestamp32() >= loan.periodBeginTimestamp) {
            (totalMinimumPayment, periodInterest) = calculateMinimumPayment(
                loan
            );
        }

        // caculate the total possible payment
        uint256 totalPossiblePayment = loan.remainingPrincipal + periodInterest;

        // set msgValue value
        uint256 msgValue = msg.value;
        //require msgValue to be larger than the total minimum payment
        require(msgValue >= totalMinimumPayment, "00047");
        // if msgValue is greater than the totalPossiblePayment send back the difference
        if (msgValue > totalPossiblePayment) {
            //send back value
            payable(buyerAddress).sendValue(msgValue - totalPossiblePayment);
            // adjust msgValue value
            msgValue = totalPossiblePayment;
        }

        uint256 totalRoyaltiesPaid = _payRoyalties(
            nftContractAddress,
            nftId,
            buyerAddress,
            msgValue
        );

        // payout seller
        _conditionalSendValue(
            sellerAddress,
            buyerAddress,
            msgValue - totalRoyaltiesPaid
        );

        // update loan struct
        loan.remainingPrincipal -= uint128(msgValue - periodInterest);

        // check if remianingPrincipal is 0
        if (loan.remainingPrincipal == 0) {
            // if principal == 0 transfer nft and end loan
            _transferNft(
                nftContractAddress,
                nftId,
                address(this),
                buyerAddress
            );
            _removeLoanFromOwnerEnumeration(
                buyerAddress,
                nftContractAddress,
                nftId
            );
            // burn buyer nft
            _burn(loan.buyerNftId);
            // burn seller nft
            _burn(loan.sellerNftId);
            //emit paymentMade event
            emit PaymentMade(
                nftContractAddress,
                nftId,
                msgValue,
                totalRoyaltiesPaid,
                periodInterest,
                loan
            );
            // emit loan repaid event
            emit LoanRepaid(nftContractAddress, nftId, loan);
            // delete loan
            delete _loans[nftContractAddress][nftId];
        }
        //else emit paymentMade event and update loan
        else {
            // if in the current period, else prior to period begin and end should remain the same
            if (_currentTimestamp32() >= loan.periodBeginTimestamp) {
                // increment the currentperiodBegin and End Timestamps equal to the periodDuration
                loan.periodBeginTimestamp += loan.periodDuration;
                loan.periodEndTimestamp += loan.periodDuration;
            }

            //emit paymentMade event
            emit PaymentMade(
                nftContractAddress,
                nftId,
                msgValue,
                totalRoyaltiesPaid,
                periodInterest,
                loan
            );
        }
    }

    // currently callable by anyone, should it only be callable by the seller?
    function seizeAsset(
        address nftContractAddress,
        uint256 nftId
    ) external whenNotPaused nonReentrant {
        Loan storage loan = _getLoan(nftContractAddress, nftId);
        address buyerAddress = ownerOf(loan.buyerNftId);
        address sellerAddress = ownerOf(loan.sellerNftId);

        _requireIsNotSanctioned(sellerAddress);
        // require principal is not 0
        require(loan.remainingPrincipal != 0, "loan repaid");
        // requireLoanInDefault
        require(
            _currentTimestamp32() > loan.periodEndTimestamp,
            "Asset not seizable"
        );

        _transferNft(nftContractAddress, nftId, address(this), sellerAddress);

        _removeLoanFromOwnerEnumeration(
            buyerAddress,
            nftContractAddress,
            nftId
        );

        // burn buyer nft
        _burn(loan.buyerNftId);

        // burn seller nft
        _burn(loan.sellerNftId);

        emit AssetSeized(nftContractAddress, nftId, loan);

        delete _loans[nftContractAddress][nftId];
    }

    function flashClaim(
        address receiverAddress,
        address nftContractAddress,
        uint256 nftId,
        bytes calldata data
    ) external whenNotPaused nonReentrant {
        Loan storage loan = _getLoan(nftContractAddress, nftId);

        _requireNftOwner(loan);
        _requireIsNotSanctioned(msg.sender);
        _requireIsNotSanctioned(ownerOf(loan.buyerNftId));
        // instantiate receiver contract
        IFlashClaimReceiver receiver = IFlashClaimReceiver(receiverAddress);
        // transfer NFT
        _transferNft(nftContractAddress, nftId, address(this), receiverAddress);
        // execute firewalled external arbitrary functionality
        // function must approve this contract to transferFrom NFT in order to return to lending.sol
        require(
            receiver.executeOperation(
                msg.sender,
                nftContractAddress,
                nftId,
                data
            ),
            "00058"
        );
        // transfer nft back to Lending.sol and require return occurs
        _transferNft(nftContractAddress, nftId, receiverAddress, address(this));
        // emit event
        emit FlashClaim(nftContractAddress, nftId, receiverAddress);
    }

    function balanceOf(
        address owner,
        address nftContractAddress
    ) public view returns (uint256) {
        require(owner != address(0), "00035");
        return _balances[owner][nftContractAddress];
    }

    function tokenOfOwnerByIndex(
        address owner,
        address nftContractAddress,
        uint256 index
    ) public view returns (uint256) {
        require(index < balanceOf(owner, nftContractAddress), "00069");
        return _ownedTokens[owner][nftContractAddress][index];
    }

    function calculateMinimumPayment(
        Loan memory loan
    ) public pure returns (uint256 minimumPayment, uint256 periodInterest) {
        uint256 minimumPrincipalPayment = loan.minimumPrincipalPerPeriod;

        // if remainingPrincipal is less than minimumPrincipalPayment make minimum payment the remainder of the principal
        if (loan.remainingPrincipal < minimumPrincipalPayment) {
            minimumPrincipalPayment = loan.remainingPrincipal;
        }
        // calculate % interest to be paid to seller
        if (loan.periodInterestRateBps != 0) {
            periodInterest = ((loan.remainingPrincipal *
                loan.periodInterestRateBps) / MAX_BPS);
        }

        minimumPayment = minimumPrincipalPayment + periodInterest;
    }

    function _payRoyalties(
        address nftContractAddress,
        uint256 nftId,
        address from,
        uint256 amount
    ) private returns (uint256 totalRoyaltiesPaid) {
        // query royalty recipients and amounts
        (
            address payable[] memory recipients,
            uint256[] memory amounts
        ) = IRoyaltyEngineV1(royaltiesEngineAddress).getRoyaltyView(
                nftContractAddress,
                nftId,
                amount
            );

        // payout royalties
        for (uint256 i = 0; i < recipients.length; i++) {
            if (amounts[i] > 0) {
                _conditionalSendValue(recipients[i], from, amounts[i]);
                totalRoyaltiesPaid += amounts[i];
            }
        }
    }

    /// dev If "to" is a contract that doesnt except ETH, send value back to "from" and continue
    /// otherwise "to" could force a default by sending bearer nft to contract that does not accept ETH
    function _conditionalSendValue(
        address to,
        address from,
        uint256 amount
    ) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool toSuccess, ) = to.call{value: amount}("");

        if (!toSuccess) {
            (bool fromSuccess, ) = from.call{value: amount}("");
            // require ETH is sucessfully sent to either to or from
            // we do not want ETH hanging in contract.
            require(
                fromSuccess,
                "Address: unable to send value, recipient may have reverted"
            );
        }
    }

    function getLoan(
        address nftContractAddress,
        uint256 nftId
    ) external view returns (Loan memory) {
        return _getLoan(nftContractAddress, nftId);
    }

    function _getLoan(
        address nftContractAddress,
        uint256 nftId
    ) private view returns (Loan storage) {
        return _loans[nftContractAddress][nftId];
    }

    function _createLoan(
        Loan storage loan,
        Offer memory offer,
        uint256 sellerNftId,
        uint256 buyerNftId,
        uint256 amount
    ) internal {
        loan.sellerNftId = sellerNftId;
        loan.buyerNftId = buyerNftId;
        loan.remainingPrincipal = uint128(amount);
        loan.periodEndTimestamp = _currentTimestamp32() + offer.periodDuration;
        loan.periodBeginTimestamp = _currentTimestamp32();
        loan.minimumPrincipalPerPeriod = offer.minimumPrincipalPerPeriod;
        loan.periodInterestRateBps = offer.periodInterestRateBps;
        loan.periodDuration = offer.periodDuration;
    }

    function _transferNft(
        address nftContractAddress,
        uint256 nftId,
        address from,
        address to
    ) internal {
        IERC721Upgradeable(nftContractAddress).safeTransferFrom(
            from,
            to,
            nftId
        );
    }

    /// dev Private function to add a token to this extension's ownership-tracking data structures.
    /// param owner address representing the new owner of the given token ID
    /// param nftContractAddress address nft collection address
    /// param tokenId uint256 ID of the token to be added to the tokens list of the given address
    function _addLoanToOwnerEnumeration(
        address owner,
        address nftContractAddress,
        uint256 tokenId
    ) private {
        uint256 length = _balances[owner][nftContractAddress];
        _ownedTokens[owner][nftContractAddress][length] = tokenId;
        _ownedTokensIndex[nftContractAddress][tokenId] = length;
        _balances[owner][nftContractAddress] += 1;
    }

    /// dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
    /// while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
    /// gas optimizations e.g. when performing a transfer operation (avoiding double writes).
    /// This has O(1) time complexity, but alters the order of the _ownedTokens array.
    /// param owner address representing the owner of the given token ID to be removed
    /// param nftContractAddress address nft collection address
    /// param tokenId uint256 ID of the token to be removed from the tokens list of the given address
    function _removeLoanFromOwnerEnumeration(
        address owner,
        address nftContractAddress,
        uint256 tokenId
    ) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and then delete the last slot (swap and pop).

        uint256 lastTokenIndex = balanceOf(owner, nftContractAddress) - 1;
        uint256 tokenIndex = _ownedTokensIndex[nftContractAddress][tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[owner][nftContractAddress][
                lastTokenIndex
            ];

            _ownedTokens[owner][nftContractAddress][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[nftContractAddress][lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete _ownedTokensIndex[nftContractAddress][tokenId];
        delete _ownedTokens[owner][nftContractAddress][lastTokenIndex];

        // decrease the owner's collection balance by one
        _balances[owner][nftContractAddress] -= 1;
    }

    function _currentTimestamp32() internal view returns (uint32) {
        return SafeCastUpgradeable.toUint32(block.timestamp);
    }

    function _requireIsNotSanctioned(address addressToCheck) internal view {
        if (!_sanctionsPause) {
            SanctionsList sanctionsList = SanctionsList(SANCTIONS_CONTRACT);
            bool isToSanctioned = sanctionsList.isSanctioned(addressToCheck);
            require(!isToSanctioned, "00017");
        }
    }

    function _requireAvailableSignature(bytes memory signature) public view {
        require(!_cancelledOrFinalized[signature], "00032");
    }

    function _requireSignature65(bytes memory signature) public pure {
        require(signature.length == 65, "00003");
    }

    function _requireOfferNotExpired(Offer memory offer) internal view {
        require(
            offer.expiration > SafeCastUpgradeable.toUint32(block.timestamp),
            "00010"
        );
    }

    function _require721Owner(
        address nftContractAddress,
        uint256 nftId,
        address owner
    ) internal view {
        require(
            IERC721Upgradeable(nftContractAddress).ownerOf(nftId) == owner,
            "00021"
        );
    }

    function _requireSigner(address signer, address expected) internal pure {
        require(signer == expected, "00033");
    }

    function _requireOfferCreator(
        address signer,
        address expected
    ) internal pure {
        require(signer == expected, "00024");
    }

    function _requireOfferDoesntExist(address offerCreator) internal pure {
        require(offerCreator == address(0), "00046");
    }

    function _requireOpenLoan(Loan storage loan) internal view {
        require(loan.remainingPrincipal != 0, "00007");
    }

    function _requireNftOwner(Loan storage loan) internal view {
        require(msg.sender == ownerOf(loan.buyerNftId), "00021");
    }

    function _requireLenderOrNftOwner(Loan memory loan) internal view {
        require(
            msg.sender == ownerOf(loan.buyerNftId) ||
                msg.sender == ownerOf(loan.sellerNftId),
            "00061"
        );
    }

    function _markSignatureUsed(
        Offer memory offer,
        bytes memory signature
    ) internal {
        _cancelledOrFinalized[signature] = true;

        emit OfferSignatureUsed(
            offer.nftContractAddress,
            offer.nftId,
            offer,
            signature
        );
    }

    function renounceOwnership() public override onlyOwner {}
}
