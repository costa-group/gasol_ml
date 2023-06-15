// SPDX-License-Identifier: MIT
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


// File @openzeppelin/contracts/utils/Address.sol@v4.8.0

// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

//pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}


// File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.8.0

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}


// File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.8.0

// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)

//pragma solidity ^0.8.0;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


// File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.8.0

// OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

//pragma solidity ^0.8.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}


// File contracts/NFTVariable.sol

//pragma solidity ^0.8.18;






contract NFTStaking is Ownable, ReentrancyGuard {

    using EnumerableSet for EnumerableSet.AddressSet;

    using EnumerableSet for EnumerableSet.UintSet;
    

    IERC721 public immutable mriNFT;
    IERC20 public rewardToken;
    
       
    struct Stake {

        uint256 amountStaked;
        uint256 timestampLastUpdate;
        uint256 claimedRewards;
        uint256 rewardDebt;
        EnumerableSet.UintSet nftIds;
       
    }

    struct RarityMultiplier {
        uint8 other;
        uint8 rare;
        uint8 epic;
        uint8 legendary;
    }

    struct PoolInfo {
        uint64 startStakingTime;
        uint64 endStakingTime;
        uint64 totalNFTStaked;
        // Rewards are cumulated once every hour.
        uint256 rewardsPerHour;
        uint256 rewardsForWithdraw;
        uint256 accTokenPerShare; // Accumulated Tokens per share of rarity
    }

    // map staker address to stake details
    mapping(address => Stake) private stakes;
    //mapping(address => EnumerableSet.UintSet) private nftIdsOfUser;
    mapping(uint256 => uint8) public IDsRarity;
    // mapping each rarity to its number of NFTs staked
    mapping(uint8 => uint16) public totalNFTByRarity;
   
    uint256 lastRewardTime;
    // map staker to total staking time 

    // Rewards per hour per token in wei.

    // Based on the amount of NFT staked and their rarity a multiplier is applied
    RarityMultiplier rarityMultiplier = RarityMultiplier(1, 2, 3, 4);
    // list of stakers
   // EnumerableSet.AddressSet private stakersArray;
    
    // All the staking pool details
    PoolInfo public poolInfo;


    // Mapping of Token Id to staker. Made for the Staking contract to remeber
    // who to send back the ERC721 Token to.
    mapping(uint256 => address) public stakerAddress;


    error Unstake_NoTokensStaked();
    error Stake_NotOwnedNFT();
    error InvalidEndBlock();
    error InvalidStakingPeriod();

    event RewardsPerHourChanged(uint256 newRewardsPerHour);
    event StakeNFT(address indexed staker, uint256[] tokenIds);
    event UnstakeNFT(address indexed staker, uint256[] tokenIds);
    event EmergencyWithdraw(uint256 percentage);
    event SetStakingPeriod(uint256 startStakingTime, uint256 endStakingTime);
    event SetRewardToken(address rewardToken);
    event RarityMultiplierChanged(uint8 other, uint8 rare, uint8 epic, uint8 legendary);

    constructor(address _nftContractAddress, address _rewardToken) {
        
        rewardToken = IERC20(_rewardToken);
        mriNFT = IERC721(_nftContractAddress); 
        
    }

   
    /**
     * @dev Stake one or more ERC721 Tokens: For every new Token Id in param transferFrom user to this Smart Contract,
     * increment the amountStaked and map msg.sender to the Token Id of the staked token
     * to later send back on withdrawal.
     * Finally give timeOfLastUpdate the value of now.
     * If address already has ERC721 Token/s staked, calculate the rewards.
     * @param _tokenIds Array of ERC721 Token Ids to stake
     */
    function stake(uint256[] calldata _tokenIds) external nonReentrant {
       

        _claimRewards();
        uint256 len = _tokenIds.length;
        for (uint256 i; i < len; ++i) {
            if(
                mriNFT.ownerOf(_tokenIds[i]) != msg.sender

            ){
                revert Stake_NotOwnedNFT();
            }

            mriNFT.transferFrom(msg.sender, address(this), _tokenIds[i]);
            stakerAddress[_tokenIds[i]] = msg.sender;
            totalNFTByRarity[IDsRarity[_tokenIds[i]]] += 1;
            stakes[msg.sender].nftIds.add(_tokenIds[i]);

        }

        stakes[msg.sender].amountStaked += uint64(len);
        stakes[msg.sender].timestampLastUpdate = block.timestamp;
        stakes[msg.sender].rewardDebt = calculateRarity(msg.sender) * poolInfo.accTokenPerShare;

        poolInfo.totalNFTStaked += uint64(len);

        emit StakeNFT(msg.sender, _tokenIds);
    }

    
    /**
     * @dev Withdraw one or more ERC721 Tokens : Check if user has any ERC721 Tokens Staked and if he tried to withdraw,
     * calculate the rewards and store them in the unclaimedRewards and for each
     * ERC721 Token in param: check if msg.sender is the original staker, decrement
     * the amountStaked of the user and transfer the ERC721 token back to them
     * @param _tokenIds Array of ERC721 Token Ids to unstake
     */
    function unstake(uint256[] calldata _tokenIds) external nonReentrant {
        if(
            stakes[msg.sender].amountStaked == 0
        ) { 
            revert Unstake_NoTokensStaked();
        }
        _claimRewards();
        uint256 len = _tokenIds.length;
        for (uint256 i; i < len; ++i) {

            require(stakerAddress[_tokenIds[i]] == msg.sender);
            mriNFT.transferFrom(address(this), msg.sender, _tokenIds[i]);
            stakerAddress[_tokenIds[i]] = address(0);
            totalNFTByRarity[IDsRarity[_tokenIds[i]]] -= 1;
            stakes[msg.sender].nftIds.remove(_tokenIds[i]);
        }

        stakes[msg.sender].amountStaked -= len;
        stakes[msg.sender].timestampLastUpdate = block.timestamp;
        //stakes[msg.sender].unclaimedRewards = 0;
        stakes[msg.sender].rewardDebt = calculateRarity(msg.sender) * poolInfo.accTokenPerShare;

        poolInfo.totalNFTStaked -= uint64(len);
        emit UnstakeNFT(msg.sender, _tokenIds);
        
    }



    /** 
     * @dev Emergency unstake: unstake NFT without caring about calcultating rewards
     * For regular unstake use the unstake function, this must be called only in case of emergency
     * param: _tokenIds Array of ERC721 Token Ids to unstake
     */
    function emergencyUnstake(uint256[] calldata _tokenIds) external nonReentrant {
        if(
            stakes[msg.sender].amountStaked == 0
        ) { 
            revert Unstake_NoTokensStaked();
        }
        
        uint256 len = _tokenIds.length;
        for (uint256 i; i < len; ++i) {

            require(stakerAddress[_tokenIds[i]] == msg.sender);
            stakerAddress[_tokenIds[i]] = address(0);
            mriNFT.transferFrom(address(this), msg.sender, _tokenIds[i]);
            totalNFTByRarity[IDsRarity[_tokenIds[i]]] -= 1;
            stakes[msg.sender].nftIds.remove(i);
        }
        stakes[msg.sender].amountStaked -= len;
        stakes[msg.sender].timestampLastUpdate = block.timestamp;

        poolInfo.totalNFTStaked -= uint64(len);

        emit UnstakeNFT(msg.sender, _tokenIds);
    }

    /**
     * @dev Update the rewards emitted by the pool: If the pool is active,
     */
    function updatePoolRewards() public {

        uint256 updateRewardInterval = 0;
        if( block.timestamp <= poolInfo.endStakingTime && 
            block.timestamp >= poolInfo.startStakingTime &&
            lastRewardTime < block.timestamp
        ){
            updateRewardInterval = block.timestamp - lastRewardTime;
        } 
        lastRewardTime = block.timestamp;

        uint256 rewards;
        if (updateRewardInterval > 0 ) {
            uint256 totalStaked = poolInfo.totalNFTStaked;
            if (totalStaked > 0) {
                rewards = (updateRewardInterval * poolInfo.rewardsPerHour) / 3600;           
            }
        }
        else{
            return;
        }
        uint16 _totalRarityStaked = getTotalRarityStaked();
        if( poolInfo.startStakingTime < block.timestamp && _totalRarityStaked > 0){
            if( poolInfo.rewardsForWithdraw + rewards <= rewardToken.balanceOf(address(this)) ){
                poolInfo.rewardsForWithdraw += rewards;
                poolInfo.accTokenPerShare += (rewards / _totalRarityStaked );
            }
            else if( poolInfo.rewardsForWithdraw < rewardToken.balanceOf(address(this)) ) {
                poolInfo.accTokenPerShare +=  (rewardToken.balanceOf(address(this)) - poolInfo.rewardsForWithdraw) / _totalRarityStaked ;
                poolInfo.rewardsForWithdraw = rewardToken.balanceOf(address(this));
            }

        }

    }


    /**
     * @dev Claim rewards for the msg.sender
     * Calculate rewards for the msg.sender, check if there are any rewards
     * claim, set unclaimedRewards to 0 and transfer the ERC20 Reward token
     * to the user.
     */
    function _claimRewards() internal {
        updatePoolRewards();
        uint256 rewards = calculateRewards(msg.sender);
        uint16 stakerRarity =  calculateRarity(msg.sender);


        stakes[msg.sender].timestampLastUpdate = block.timestamp;
        
        if( rewards == 0){
            return;
        }

        if( poolInfo.rewardsForWithdraw >= rewards && rewardToken.balanceOf(address(this)) >= rewards)
            poolInfo.rewardsForWithdraw -= rewards;
        else
            return;

        stakes[msg.sender].rewardDebt =  stakerRarity * poolInfo.accTokenPerShare;

       // stakes[msg.sender].unclaimedRewards = 0;
        stakes[msg.sender].claimedRewards += rewards;
        rewardToken.transfer(msg.sender, rewards);
    }
    

    /**
     * @dev Claim rewards for the msg.sender
     */
    function claimRewards() external nonReentrant {
        _claimRewards();

    }
    /**
     * @dev Set the rewards per hour
     * as the rewards are calculated passively, the rewards must be calculated for each staker first
     * then the rewards variable can be changed: there is the risk of reaching the gas limit per block
     * @param _rewardsPerHour New value for rewards per hour
     */
    function setRewardsPerHour(
        uint256 _rewardsPerHour 
    ) public onlyOwner {

        updatePoolRewards();

        poolInfo.rewardsPerHour = _rewardsPerHour;

        emit RewardsPerHourChanged(_rewardsPerHour);
    
    }

    ////////////////////////// view //////////////////////////

    /**
     * @dev Get all the info of a user stake status
     * @param _user Address of the user
     * @return _amountStaked Amount of staked ERC721 Tokens 
     * @return _timestampLastUpdate Available rewards 
     * @return nftIds Array of ERC721 Token Ids staked by the user
     * @return _availableRewards Available rewards for the user
     */
    function userStakeInfo(address _user)
        public
        view
        returns (uint256 _amountStaked, 
                 uint256 _timestampLastUpdate, 
                 uint256[] memory nftIds,
                 uint256 _availableRewards,
                 uint256 totalRewards
                )
    {
        _availableRewards = availableRewards(_user);
        return (
                stakes[_user].amountStaked, 
                stakes[_user].timestampLastUpdate,
                stakes[_user].nftIds.values(),
                _availableRewards,
                stakes[_user].claimedRewards
                );
    }
    /**
     * @dev Get the available rewards for the given _user. 
     * Dinamically updates the ui for the current available rewards
     * @param _user Address of the user
     * @return _rewards Available rewards for the param _user
     */
    function availableRewards(address _user) public view returns (uint256) {
        if (stakes[_user].amountStaked == 0 || rewardToken.balanceOf(address(this)) == 0 || rewardToken.balanceOf(address(this)) < poolInfo.rewardsForWithdraw) {
            return 0;
        }
        Stake storage _stake = stakes[_user];

        uint16 stakerRarity =  calculateRarity(_user);

        uint256 deltaStakeTime;
        uint256 _accTokenPerShare;
        
        if( poolInfo.startStakingTime <= _stake.timestampLastUpdate){
            
            if( block.timestamp < poolInfo.endStakingTime  ){
            // staking started and still ongoing
                deltaStakeTime =  block.timestamp - _stake.timestampLastUpdate;
            }
            else if(  block.timestamp  > poolInfo.endStakingTime && poolInfo.endStakingTime > _stake.timestampLastUpdate)
                deltaStakeTime =  poolInfo.endStakingTime - _stake.timestampLastUpdate;
        }
        _accTokenPerShare = poolInfo.accTokenPerShare +  (deltaStakeTime * poolInfo.rewardsPerHour  / getTotalRarityStaked()) / 3600; //= accTokenPerShare

        uint256 _rewards = (stakerRarity * _accTokenPerShare ) - _stake.rewardDebt;

        return _rewards;
    }


    ////////////////////////// internal  //////////////////////////
    
    /**
     * @dev Calculate rewards for a given user
     * Calculate rewards for param _staker by calculating the time passed
     * since last update in hours and mulitplying it to ERC721 Tokens Staked
     * and rewardsPerHour.
     * @param _user Address of the user
     * @return _rewards Rewards for the given user
     */
    function calculateRewards(address _user)
        internal
        view
        returns (uint256 _rewards)
    {
        Stake storage _stake = stakes[_user];
        uint16 stakerRarity =  calculateRarity(_user);

        uint256 pendingRewards = stakerRarity * poolInfo.accTokenPerShare - _stake.rewardDebt;

        return  pendingRewards; 
    }

    /**
     * @dev Change the staking period 
     * @param _startStakingTime : new start time for the next staking period
     * @param _endStakingTime: new end time for the next staking period 
     */
    function changeStakingPeriod(uint64 _startStakingTime, uint64 _endStakingTime ) public onlyOwner {
        if(_endStakingTime < block.timestamp || _startStakingTime > _endStakingTime)
            revert InvalidStakingPeriod();
        
        poolInfo.startStakingTime = _startStakingTime;
        poolInfo.endStakingTime = _endStakingTime;

        emit SetStakingPeriod( _startStakingTime , _endStakingTime);
    }

    /** 
      * @dev Load rarity values for each NFT: the rarity is a number between 1 and 5, 
      * the the ids array must have the same length of the rarity array
      * different portion of ids can be loaded in different calls (to not incur in gas limits)
      * @param rarity: array of rarities
      * @param ids: array of ids
      * @notice this function can only be called by the owner
     */
    function loadRarityRank(uint8[] memory rarity, uint256[] memory ids) external onlyOwner {
        for (uint256 i = 0; i < rarity.length; i++) {
            IDsRarity[ids[i]] = rarity[i];
        }
    } 

    /**
     * @dev Emergency withdraw of the reward token 
     * @param percentage: percentage of the reward token to withdraw
     * @notice this function can only be called by the owner
     * emits EmergencyWithdraw event
     */
    function emergencyWithdraw(uint256 percentage) external onlyOwner {

        bool success = rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)) * percentage / 100);
        if(!success)
            revert();
        emit EmergencyWithdraw(rewardToken.balanceOf(address(this)) * percentage / 100);
    }

    /**
     * @dev SetRarityMultiplier: set the multiplier for each rarity
     * @param other: array of multipliers for each rarity
     * @param rare: array of multipliers for each rarity
     * @param epic: array of multipliers for each rarity
     * @param legendary: array of multipliers for each rarity
     * emits RarityMultiplierChanged event
     */
    function setRarityMultiplier(uint8 other, uint8 rare, uint8 epic, uint8 legendary) public onlyOwner {
        rarityMultiplier.other = other;
        rarityMultiplier.rare = rare;
        rarityMultiplier.epic = epic;
        rarityMultiplier.legendary = legendary;
        emit RarityMultiplierChanged(other, rare, epic, legendary);
    }
    
    /**
     * @dev SetRewardsPerHour: set the rewards per hour
     *
     */
    function getTotalRarityStaked() public view returns (uint16 _totalRarityStaked) {
        
  
        _totalRarityStaked = totalNFTByRarity[uint8(0)] * rarityMultiplier.other + 
                             totalNFTByRarity[uint8(3)] * rarityMultiplier.rare + 
                             totalNFTByRarity[uint8(4)] * rarityMultiplier.epic + 
                             totalNFTByRarity[uint8(5)] * rarityMultiplier.legendary;
        
    }

    /**
     * @dev Calculate the total rarity of the NFTs staked by the user
     * @param user: address of the user
     * @return _totalRarity total rarity of the NFTs staked by the user
     */
     function calculateRarity(address user) internal view returns (uint16 _totalRarity) {
        uint256[] memory nftIds = stakes[user].nftIds.values();
        for (uint256 i = 0; i < nftIds.length; i++) {
            if( IDsRarity[nftIds[i]] == 0 )  // Common/Uncommon
                _totalRarity += rarityMultiplier.other;

            else if( IDsRarity[nftIds[i]] == 3 )  // Rare
                _totalRarity += rarityMultiplier.rare;

            else if( IDsRarity[nftIds[i]] == 4 )  // Epic
                _totalRarity += rarityMultiplier.epic;

            else if (IDsRarity[nftIds[i]] == 5 )  // Legendary
                _totalRarity += rarityMultiplier.legendary;

        }

        return _totalRarity;
     }
    /**
     * @dev Set the address of the reward token
     * @param _rewardToken: the reward token address
     * @notice this function can only be called by the owner
     */
     function setRewardToken(address _rewardToken) external onlyOwner {
        rewardToken = IERC20(_rewardToken);
        emit SetRewardToken(_rewardToken);
     }    



    
}