// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "erc721a/contracts/extensions/ERC4907A.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/security/Pausable.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/token/common/ERC2981.sol";

/**
 * author Created with HeyMint Launchpad https://launchpad.heymint.xyz
 * notice This contract handles minting Skip the Bad Songs tokens.
 */
contract SkipTheBadSongs is
    ERC721A,
    ERC721AQueryable,
    ERC4907A,
    Ownable,
    Pausable,
    ReentrancyGuard,
    ERC2981
{
    event Loan(address from, address to, uint256 tokenId);
    event LoanRetrieved(address from, address to, uint256 tokenId);

    // Address of the smart contract used to check if an operator address is from a blocklisted exchange
    address public blocklistContractAddress;
    address public royaltyAddress = 0x494B3fb8575565f8E605cB2F54737fd94e2B872A;
    address[] public payoutAddresses = [
        0x033c5AE90c6621049af5ed34b109440E266e58e1,
        0x494B3fb8575565f8E605cB2F54737fd94e2B872A
    ];
    // Permanently disable the blocklist so all exchanges are allowed
    bool public blocklistPermanentlyDisabled = false;
    bool public isPublicSaleActive = false;
    // If true, new loans will be disabled but existing loans can be closed
    bool public loansPaused = true;
    // Permanently freezes metadata so it can never be changed
    bool public metadataFrozen = false;
    // If true, payout addresses and basis points are permanently frozen and can never be updated
    bool public payoutAddressesFrozen = false;
    mapping(address => uint256) public totalLoanedPerAddress;
    mapping(uint256 => address) public tokenOwnersOnLoan;
    // If true, the exchange represented by a uint256 integer is blocklisted and cannot be used to transfer tokens
    mapping(uint256 => bool) public isExchangeBlocklisted;
    string public baseTokenURI =
        "ipfs://bafybeif2ravrjynejiq43kgao7e4vlohjpsuhx4hwpdvtguj67pz346o3i/";
    uint256 private currentLoanIndex = 0;
    // Maximum supply of tokens that can be minted
    uint256 public constant MAX_SUPPLY = 333;
    uint256 public publicMintsAllowedPerAddress = 333;
    uint256 public publicMintsAllowedPerTransaction = 333;
    uint256 public publicPrice = 0.039 ether;
    // The respective share of funds to be sent to each address in payoutAddresses in basis points
    uint256[] public payoutBasisPoints = [2000, 8000];
    uint96 public royaltyFee = 500;

    constructor(address _blocklistContractAddress)
        ERC721A("Skip the Bad Songs", "STBS")
    {
        blocklistContractAddress = _blocklistContractAddress;
        _setDefaultRoyalty(royaltyAddress, royaltyFee);
        require(
            payoutAddresses.length == payoutBasisPoints.length,
            "PAYOUT_ADDRESSES_AND_PAYOUT_BASIS_POINTS_MUST_BE_SAME_LENGTH"
        );
        uint256 totalPayoutBasisPoints = 0;
        for (uint256 i = 0; i < payoutBasisPoints.length; i++) {
            totalPayoutBasisPoints += payoutBasisPoints[i];
        }
        require(
            totalPayoutBasisPoints == 10000,
            "TOTAL_PAYOUT_BASIS_POINTS_MUST_BE_10000"
        );
    }

    modifier originalUser() {
        require(tx.origin == msg.sender, "Cannot call from contract address");
        _;
    }

    /**
     * dev Used to directly approve a token for transfers by the current msg.sender,
     * bypassing the typical checks around msg.sender being the owner of a given token
     * from https://github.com/chiru-labs/ERC721A/issues/395#issuecomment-1198737521
     */
    function _directApproveMsgSenderFor(uint256 tokenId) internal {
        assembly {
            mstore(0x00, tokenId)
            mstore(0x20, 6) // '_tokenApprovals' is at slot 6.
            sstore(keccak256(0x00, 0x40), caller())
        }
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    /**
     * dev Overrides the default ERC721A _startTokenId() so tokens begin at 1 instead of 0
     */
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    /**
     * notice Change the royalty fee for the collection
     */
    function setRoyaltyFee(uint96 _feeNumerator) external onlyOwner {
        royaltyFee = _feeNumerator;
        _setDefaultRoyalty(royaltyAddress, royaltyFee);
    }

    /**
     * notice Change the royalty address where royalty payouts are sent
     */
    function setRoyaltyAddress(address _royaltyAddress) external onlyOwner {
        royaltyAddress = _royaltyAddress;
        _setDefaultRoyalty(royaltyAddress, royaltyFee);
    }

    /**
     * notice Wraps and exposes publicly _numberMinted() from ERC721A
     */
    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    /**
     * notice Update the base token URI
     */
    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        require(!metadataFrozen, "METADATA_HAS_BEEN_FROZEN");
        baseTokenURI = _newBaseURI;
    }

    /**
     * notice Freeze metadata so it can never be changed again
     */
    function freezeMetadata() external onlyOwner {
        require(!metadataFrozen, "METADATA_HAS_ALREADY_BEEN_FROZEN");
        metadataFrozen = true;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // https://chiru-labs.github.io/ERC721A/#/migration?id=supportsinterface
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721A, IERC721A, ERC2981, ERC4907A)
        returns (bool)
    {
        // Supports the following interfaceIds:
        // - IERC165: 0x01ffc9a7
        // - IERC721: 0x80ac58cd
        // - IERC721Metadata: 0x5b5e139f
        // - IERC2981: 0x2a55205a
        // - IERC4907: 0xad092b5c
        return
            ERC721A.supportsInterface(interfaceId) ||
            ERC2981.supportsInterface(interfaceId) ||
            ERC4907A.supportsInterface(interfaceId);
    }

    /**
     * notice Allow owner to send 'mintNumber' tokens without cost to multiple addresses
     */
    function gift(address[] calldata receivers, uint256[] calldata mintNumber)
        external
        onlyOwner
    {
        require(
            receivers.length == mintNumber.length,
            "RECEIVERS_AND_MINT_NUMBERS_MUST_BE_SAME_LENGTH"
        );
        uint256 totalMint = 0;
        for (uint256 i = 0; i < mintNumber.length; i++) {
            totalMint += mintNumber[i];
        }
        require(totalSupply() + totalMint <= MAX_SUPPLY, "MINT_TOO_LARGE");
        for (uint256 i = 0; i < receivers.length; i++) {
            _safeMint(receivers[i], mintNumber[i]);
        }
    }

    /**
     * notice To be updated by contract owner to allow public sale minting
     */
    function setPublicSaleState(bool _saleActiveState) external onlyOwner {
        require(
            isPublicSaleActive != _saleActiveState,
            "NEW_STATE_IDENTICAL_TO_OLD_STATE"
        );
        isPublicSaleActive = _saleActiveState;
    }

    /**
     * notice Update the public mint price
     */
    function setPublicPrice(uint256 _publicPrice) external onlyOwner {
        publicPrice = _publicPrice;
    }

    /**
     * notice Set the maximum mints allowed per a given address in the public sale
     */
    function setPublicMintsAllowedPerAddress(uint256 _mintsAllowed)
        external
        onlyOwner
    {
        publicMintsAllowedPerAddress = _mintsAllowed;
    }

    /**
     * notice Set the maximum public mints allowed per a given transaction
     */
    function setPublicMintsAllowedPerTransaction(uint256 _mintsAllowed)
        external
        onlyOwner
    {
        publicMintsAllowedPerTransaction = _mintsAllowed;
    }

    /**
     * notice Allow for public minting of tokens
     */
    function mint(uint256 numTokens)
        external
        payable
        nonReentrant
        originalUser
    {
        require(isPublicSaleActive, "PUBLIC_SALE_IS_NOT_ACTIVE");

        require(
            numTokens <= publicMintsAllowedPerTransaction,
            "MAX_MINTS_PER_TX_EXCEEDED"
        );
        require(
            _numberMinted(msg.sender) + numTokens <=
                publicMintsAllowedPerAddress,
            "MAX_MINTS_EXCEEDED"
        );
        require(totalSupply() + numTokens <= MAX_SUPPLY, "MAX_SUPPLY_EXCEEDED");
        require(msg.value == publicPrice * numTokens, "PAYMENT_INCORRECT");

        _safeMint(msg.sender, numTokens);

        if (totalSupply() >= MAX_SUPPLY) {
            isPublicSaleActive = false;
        }
    }

    /**
     * notice Freeze all payout addresses and percentages so they can never be changed again
     */
    function freezePayoutAddresses() external onlyOwner {
        require(!payoutAddressesFrozen, "PAYOUT_ADDRESSES_ALREADY_FROZEN");
        payoutAddressesFrozen = true;
    }

    /**
     * notice Update payout addresses and basis points for each addresses' respective share of contract funds
     */
    function updatePayoutAddressesAndBasisPoints(
        address[] calldata _payoutAddresses,
        uint256[] calldata _payoutBasisPoints
    ) external onlyOwner {
        require(!payoutAddressesFrozen, "PAYOUT_ADDRESSES_FROZEN");
        require(
            _payoutAddresses.length == _payoutBasisPoints.length,
            "ARRAY_LENGTHS_MUST_MATCH"
        );
        uint256 totalBasisPoints = 0;
        for (uint256 i = 0; i < _payoutBasisPoints.length; i++) {
            totalBasisPoints += _payoutBasisPoints[i];
        }
        require(totalBasisPoints == 10000, "TOTAL_BASIS_POINTS_MUST_BE_10000");
        payoutAddresses = _payoutAddresses;
        payoutBasisPoints = _payoutBasisPoints;
    }

    /**
     * notice Withdraws all funds held within contract
     */
    function withdraw() external nonReentrant onlyOwner {
        require(address(this).balance > 0, "CONTRACT_HAS_NO_BALANCE");
        uint256 balance = address(this).balance;
        for (uint256 i = 0; i < payoutAddresses.length; i++) {
            require(
                payable(payoutAddresses[i]).send(
                    (balance * payoutBasisPoints[i]) / 10000
                )
            );
        }
    }

    // Credit Meta Angels & Gabriel Cebrian

    modifier LoansNotPaused() {
        require(loansPaused == false, "Loans are paused");
        _;
    }

    /**
     * notice To be updated by contract owner to allow for loan functionality to turned on and off
     */
    function setLoansPaused(bool _loansPaused) external onlyOwner {
        require(
            loansPaused != _loansPaused,
            "NEW_STATE_IDENTICAL_TO_OLD_STATE"
        );
        loansPaused = _loansPaused;
    }

    /**
     * notice Allow owner to loan their tokens to other addresses
     */
    function loan(uint256 tokenId, address receiver)
        external
        LoansNotPaused
        nonReentrant
    {
        require(ownerOf(tokenId) == msg.sender, "NOT_OWNER_OF_TOKEN");
        require(receiver != address(0), "CANNOT_TRANSFER_TO_ZERO_ADDRESS");
        require(
            tokenOwnersOnLoan[tokenId] == address(0),
            "CANNOT_LOAN_LOANED_TOKEN"
        );
        // Add it to the mapping of originally loaned tokens
        tokenOwnersOnLoan[tokenId] = msg.sender;
        // Add to the owner's loan balance
        totalLoanedPerAddress[msg.sender] += 1;
        currentLoanIndex += 1;
        // Transfer the token
        safeTransferFrom(msg.sender, receiver, tokenId);
        emit Loan(msg.sender, receiver, tokenId);
    }

    /**
     * notice Allow owner to retrieve a loaned token
     */
    function retrieveLoan(uint256 tokenId) external nonReentrant {
        address borrowerAddress = ownerOf(tokenId);
        require(
            borrowerAddress != msg.sender,
            "BORROWER_CANNOT_RETRIEVE_TOKEN"
        );
        require(
            tokenOwnersOnLoan[tokenId] == msg.sender,
            "TOKEN_NOT_LOANED_BY_CALLER"
        );
        // Remove it from the array of loaned out tokens
        delete tokenOwnersOnLoan[tokenId];
        // Subtract from the owner's loan balance
        totalLoanedPerAddress[msg.sender] -= 1;
        currentLoanIndex -= 1;
        // Transfer the token back
        _directApproveMsgSenderFor(tokenId);
        safeTransferFrom(borrowerAddress, msg.sender, tokenId);
        emit LoanRetrieved(borrowerAddress, msg.sender, tokenId);
    }

    /**
     * notice Allow contract owner to retrieve a loan to prevent malicious floor listings
     */
    function adminRetrieveLoan(uint256 tokenId) external onlyOwner {
        address borrowerAddress = ownerOf(tokenId);
        address loanerAddress = tokenOwnersOnLoan[tokenId];
        require(loanerAddress != address(0), "TOKEN_NOT_LOANED");
        // Remove it from the array of loaned out tokens
        delete tokenOwnersOnLoan[tokenId];
        // Subtract from the owner's loan balance
        totalLoanedPerAddress[loanerAddress] -= 1;
        currentLoanIndex -= 1;
        // Transfer the token back
        _directApproveMsgSenderFor(tokenId);
        safeTransferFrom(borrowerAddress, loanerAddress, tokenId);
        emit LoanRetrieved(borrowerAddress, loanerAddress, tokenId);
    }

    /**
     * Returns the total number of loaned tokens
     */
    function totalLoaned() public view returns (uint256) {
        return currentLoanIndex;
    }

    /**
     * Returns the loaned balance of an address
     */
    function loanedBalanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "CANNOT_QUERY_ZERO_ADDRESS");
        return totalLoanedPerAddress[owner];
    }

    /**
     * Returns all the token ids owned by a given address
     */
    function loanedTokensByAddress(address owner)
        external
        view
        returns (uint256[] memory)
    {
        require(owner != address(0), "CANNOT_QUERY_ZERO_ADDRESS");
        uint256 totalTokensLoaned = loanedBalanceOf(owner);
        uint256 mintedSoFar = totalSupply();
        uint256 tokenIdsIdx = 0;
        uint256[] memory allTokenIds = new uint256[](totalTokensLoaned);
        for (
            uint256 i = 0;
            i < mintedSoFar && tokenIdsIdx != totalTokensLoaned;
            i++
        ) {
            if (tokenOwnersOnLoan[i] == owner) {
                allTokenIds[tokenIdsIdx] = i;
                tokenIdsIdx++;
            }
        }
        return allTokenIds;
    }

    /**
     * dev Require that the address being approved is not from a blocklisted exchange
     */
    modifier onlyAllowedOperatorApproval(address operator) {
        uint256 operatorExchangeId = IExchangeOperatorAddressList(
            blocklistContractAddress
        ).operatorAddressToExchange(operator);
        require(
            blocklistPermanentlyDisabled ||
                !isExchangeBlocklisted[operatorExchangeId],
            "BLOCKLISTED_EXCHANGE"
        );
        _;
    }

    /**
     * notice Override default ERC-721 setApprovalForAll to require that the operator is not from a blocklisted exchange
     * param operator Address to add to the set of authorized operators
     * param approved True if the operator is approved, false to revoke approval
     */
    function setApprovalForAll(address operator, bool approved)
        public
        override(ERC721A, IERC721A)
        onlyAllowedOperatorApproval(operator)
    {
        super.setApprovalForAll(operator, approved);
    }

    /**
     * notice Override default ERC721 approve to require that the operator is not from a blocklisted exchange
     * param to Address to receive the approval
     * param tokenId ID of the token to be approved
     */
    function approve(address to, uint256 tokenId)
        public
        override(ERC721A, IERC721A)
        onlyAllowedOperatorApproval(to)
    {
        super.approve(to, tokenId);
    }

    /**
     * notice Update blocklist contract address to a custom contract address if desired for custom functionality
     */
    function updateBlocklistContractAddress(address _blocklistContractAddress)
        external
        onlyOwner
    {
        blocklistContractAddress = _blocklistContractAddress;
    }

    /**
     * notice Permanently disable the blocklist so all exchanges are allowed forever
     */
    function permanentlyDisableBlocklist() external onlyOwner {
        require(!blocklistPermanentlyDisabled, "BLOCKLIST_ALREADY_DISABLED");
        blocklistPermanentlyDisabled = true;
    }

    /**
     * notice Set or unset an exchange contract address as blocklisted
     */
    function updateBlocklistedExchanges(
        uint256[] calldata exchanges,
        bool[] calldata blocklisted
    ) external onlyOwner {
        require(
            exchanges.length == blocklisted.length,
            "EXCHANGES_AND_BLOCKLISTED_MUST_BE_SAME_LENGTH"
        );
        for (uint256 i = 0; i < exchanges.length; i++) {
            isExchangeBlocklisted[exchanges[i]] = blocklisted[i];
        }
    }

    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 tokenId,
        uint256 quantity
    ) internal override(ERC721A) whenNotPaused {
        require(
            tokenOwnersOnLoan[tokenId] == address(0),
            "CANNOT_TRANSFER_LOANED_TOKEN"
        );
        uint256 operatorExchangeId = IExchangeOperatorAddressList(
            blocklistContractAddress
        ).operatorAddressToExchange(msg.sender);
        require(
            blocklistPermanentlyDisabled ||
                !isExchangeBlocklisted[operatorExchangeId],
            "BLOCKLISTED_EXCHANGE"
        );
        super._beforeTokenTransfers(from, to, tokenId, quantity);
    }
}

interface IExchangeOperatorAddressList {
    function operatorAddressToExchange(address operatorAddress)
        external
        view
        returns (uint256);
}
