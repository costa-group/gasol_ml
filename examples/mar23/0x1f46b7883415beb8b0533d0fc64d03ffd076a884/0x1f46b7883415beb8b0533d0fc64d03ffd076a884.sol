/* SPDX-License-Identifier: MIT */

// Sources flattened with hardhat v2.12.7 https://hardhat.org

// File @openzeppelin/contracts/utils/Context.sol@v4.8.0

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v4.8.0

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0

// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.8.0

// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}


// File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.0

// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}


// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.0

// OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.0

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


// File contracts/superfine/SuperfineAirdrop.sol
//pragma solidity ^0.8.18;

contract SuperfineAirdrop is Ownable, ReentrancyGuard {
    enum AssetType {
        ERC20,
        ERC721,
        ERC1155
    }

    struct Asset {
        AssetType assetType;
        address assetAddress;
        uint256 assetId; // 0 for ERC20
        uint256 amount; // 1 for ERC721
    }

    struct AirdropCampaign {
        string campaignId;
        address creator;
        Asset[] assets;
        uint256 maxBatchSize;
        uint256 chargedFee;
        bool airdropStarted;
    }

    uint256 private _maxBatchSize;
    uint256 private _feePerBatch;
    mapping(string => AirdropCampaign) private _campaignById;
    mapping(address => bool) private _operators;

    event AirdropCampaignCreated(
        string campaignId,
        address creator,
        Asset[] assets,
        uint256 maxBatchSize
    );

    event AirdropCampaignUpdated(
        string campaignId,
        address creator,
        Asset[] assets,
        uint256 maxBatchSize
    );

    event AssetsAirdropped(
        string campaignId,
        address creator,
        Asset[] assets,
        address[] recipients
    );

    constructor(uint256 maxBatchSize, uint256 feePerBatch) Ownable() {
        require(
            maxBatchSize > 0,
            "SuperfineAirdrop: the size of the batch must be greater than zero"
        );
        _maxBatchSize = maxBatchSize;
        _feePerBatch = feePerBatch;
        _operators[msg.sender] = true;
    }

    modifier onlyOperators() {
        require(
            _operators[msg.sender],
            "SuperfineAirdrop: the caller is not the operator"
        );
        _;
    }

    function getCampaignById(string memory campaignId)
        external
        view
        returns (AirdropCampaign memory)
    {
        return _campaignById[campaignId];
    }

    function estimateAirdropFee(uint256 numAssets)
        public
        view
        returns (uint256)
    {
        uint256 numRequiredBatches = (numAssets + _maxBatchSize - 1) /
            _maxBatchSize; // ceil(numAssets / _maxBatchSize)
        return numRequiredBatches * _feePerBatch;
    }

    function setOperators(
        address[] calldata operators,
        bool[] calldata isOperators
    ) external onlyOwner {
        require(
            operators.length == isOperators.length,
            "SuperfineAirdrop: the number of operators and the number of statuses must be equal"
        );
        for (uint256 i = 0; i < operators.length; i++)
            _operators[operators[i]] = isOperators[i];
    }

    function setMaxBatchSize(uint256 newSize) external onlyOperators {
        require(
            newSize > 0,
            "SuperfineAirdrop: the size of the batch must be greater than zero"
        );
        _maxBatchSize = newSize;
    }

    function setFeePerBatch(uint256 newFee) external onlyOperators {
        _feePerBatch = newFee;
    }

    function createAirdropCampaign(
        string calldata campaignId,
        Asset[] calldata assets
    ) external payable nonReentrant {
        AirdropCampaign storage campaign = _campaignById[campaignId];

        // Check if campaign exists
        require(
            campaign.creator == address(0),
            "SuperfineAirdrop: the campaign has already been created before"
        );

        // Check payment
        uint256 airdropFee = estimateAirdropFee(assets.length);
        require(
            msg.value >= airdropFee,
            "SuperfineAirdrop: the paid fee is insufficient"
        );
        if (msg.value > airdropFee) {
            (bool success, ) = payable(msg.sender).call{
                value: msg.value - airdropFee
            }("");
            require(
                success,
                "SuperfineAirdrop: the excess is failed to be returned"
            );
        }

        // Validate data
        for (uint256 i = 0; i < assets.length; i++) {
            Asset memory asset = assets[i];
            require(
                uint256(asset.assetType) <= 2,
                "SuperfineAirdrop: the asset type is invalid"
            );
            if (asset.assetType == AssetType.ERC20)
                require(
                    asset.assetId == 0,
                    "SuperfineAirdrop: the asset ID of the ERC20 token must be 0"
                );
            else if (asset.assetType == AssetType.ERC721)
                require(
                    asset.amount == 1,
                    "SuperfineAirdrop: the amount of the ERC721 token must be 1"
                );
        }

        // Create new airdrop campaign
        campaign.campaignId = campaignId;
        campaign.creator = msg.sender;
        for (uint256 k = 0; k < assets.length; k++)
            campaign.assets.push(assets[k]);
        campaign.maxBatchSize = _maxBatchSize;
        campaign.chargedFee = airdropFee;

        emit AirdropCampaignCreated(
            campaignId,
            msg.sender,
            assets,
            _maxBatchSize
        );
    }

    function updateCampaign(string calldata campaignId, Asset[] calldata assets)
        external
        payable
        nonReentrant
    {
        AirdropCampaign storage campaign = _campaignById[campaignId];

        // Check campaign ownership
        require(
            campaign.creator == msg.sender,
            "SuperfineAirdrop: the caller is not the owner of the campaign"
        );

        // Make sure that this campaign has not started yet
        require(
            !campaign.airdropStarted,
            "SuperfineAirdrop: the assets of the campaign cannot be updated since the airdrop process has already started"
        );

        // Check payment
        uint256 newAirdropFee = estimateAirdropFee(assets.length);
        if (newAirdropFee > campaign.chargedFee) {
            require(
                msg.value >= newAirdropFee - campaign.chargedFee,
                "SuperfineAirdrop:insufficient airdrop fee"
            );
            if (msg.value > newAirdropFee - campaign.chargedFee) {
                (bool success, ) = payable(msg.sender).call{
                    value: msg.value + campaign.chargedFee - newAirdropFee
                }("");
                require(
                    success,
                    "SuperfineAirdrop: the excess is failed to be returned"
                );
            }
        }

        // Validate data
        for (uint256 i = 0; i < assets.length; i++) {
            Asset memory asset = assets[i];
            require(
                uint256(asset.assetType) <= 2,
                "SuperfineAirdrop: the asset type is invalid"
            );
            if (asset.assetType == AssetType.ERC20)
                require(
                    asset.assetId == 0,
                    "SuperfineAirdrop: the asset ID of the ERC20 token must be 0"
                );
            else if (asset.assetType == AssetType.ERC721)
                require(
                    asset.amount == 1,
                    "SuperfineAirdrop: the amount of the ERC721 token must be 1"
                );
        }

        // Update campaign info
        delete campaign.assets;
        for (uint256 k = 0; k < assets.length; k++)
            campaign.assets.push(assets[k]);
        campaign.maxBatchSize = _maxBatchSize;
        if (newAirdropFee > campaign.chargedFee)
            campaign.chargedFee = newAirdropFee;

        emit AirdropCampaignUpdated(
            campaignId,
            msg.sender,
            assets,
            campaign.maxBatchSize
        );
    }

    function airdrop(
        string calldata campaignId,
        uint256[] calldata assetIndexes,
        address[] calldata recipients
    ) external onlyOperators nonReentrant {
        require(
            _campaignById[campaignId].creator != address(0),
            "SuperfineAirdrop: the campaign does not exist"
        );
        AirdropCampaign storage campaign = _campaignById[campaignId];
        require(
            assetIndexes.length == recipients.length,
            "SuperfineAirdrop: the number of assets and the number of recipients must be equal"
        );
        require(
            assetIndexes.length <= campaign.maxBatchSize,
            "SuperfineAirdrop: the number of assets must not exceed the maximum size of a single batch"
        );
        if (!campaign.airdropStarted) campaign.airdropStarted = true;
        Asset[] memory airdroppedAssets = new Asset[](assetIndexes.length);
        for (uint256 i = 0; i < assetIndexes.length; i++) {
            require(
                assetIndexes[i] < campaign.assets.length,
                "SuperfineAirdrop: the asset index cannot be larger than the total number of assets in this campaign"
            );
            airdroppedAssets[i] = campaign.assets[assetIndexes[i]];
            Asset storage asset = campaign.assets[assetIndexes[i]];
            require(
                asset.amount > 0,
                "SuperfineAirdrop: this reward has already been sent before"
            );
            if (asset.assetType == AssetType.ERC20) {
                bool success = IERC20(asset.assetAddress).transferFrom(
                    campaign.creator,
                    recipients[i],
                    asset.amount
                );
                require(
                    success,
                    "SuperfineAirdrop: the transfer process of the ERC20 assets failed"
                );
                asset.amount = 0;
            } else if (asset.assetType == AssetType.ERC721) {
                IERC721(asset.assetAddress).transferFrom(
                    campaign.creator,
                    recipients[i],
                    asset.assetId
                );
                asset.amount = 0;
            } else if (asset.assetType == AssetType.ERC1155) {
                IERC1155(asset.assetAddress).safeTransferFrom(
                    campaign.creator,
                    recipients[i],
                    asset.assetId,
                    asset.amount,
                    abi.encodePacked("Airdrop ERC1155 assets")
                );
                asset.amount = 0;
            }
        }
        emit AssetsAirdropped(
            campaignId,
            campaign.creator,
            airdroppedAssets,
            recipients
        );
    }

    function withdrawAirdropFee(address recipient) external onlyOwner {
        (bool success, ) = payable(recipient).call{
            value: address(this).balance
        }("");
        require(
            success,
            "SuperfineAirdrop: the process of withdrawing airdrop fee is failed"
        );
    }
}