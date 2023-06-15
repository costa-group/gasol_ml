// SPDX-License-Identifier: MIT


// ====================================================================================
//     Context      // OpenZeppelin Contracts (utils/Context.sol)
// ====================================================================================

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



// ====================================================================================
//     IERC165      // OpenZeppelin Contracts (utils/introspection/IERC165.sol)
// ====================================================================================

//pragma solidity ^0.8.0;

/** 
 * @dev Interface of the ERC165 standard, as defined in the https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}. 
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas. 
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}



// ====================================================================================
//     ERC165      // OpenZeppelin Contracts (utils/introspection/ERC165.sol)
// ====================================================================================

//pragma solidity ^0.8.0;


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation. 
 */
abstract contract ERC165 is IERC165 {
    /** 
     * @dev See {IERC165-supportsInterface}. 
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}



// ====================================================================================
//     IERC721Receiver      // OpenZeppelin Contracts (token/ERC721/IERC721Receiver.sol)
// ====================================================================================

//pragma solidity ^0.8.0;

/** 
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers from ERC721 asset contracts. 
 */
interface IERC721Receiver {
    /** 
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`. 
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}



// ====================================================================================
//     IERC721      // OpenZeppelin Contracts (token/ERC721/IERC721.sol)
// ====================================================================================

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
     * Requirements: - `tokenId` must exist. 
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /** 
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements: - `from` cannot be the zero address.
     *               - `to` cannot be the zero address.
     *               - `tokenId` token must exist and be owned by `from`.
     *               - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *               - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event. 
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /** 
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements: - `from` cannot be the zero address.
     *               - `to` cannot be the zero address.
     *               - `tokenId` token must exist and be owned by `from`.
     *               - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     *               - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event. 
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /** 
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements: - `from` cannot be the zero address.
     *               - `to` cannot be the zero address.
     *               - `tokenId` token must be owned by `from`.
     *               - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event. 
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /** 
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements: - The caller must own the token or be an approved operator.
     *               - `tokenId` must exist.
     *
     * Emits an {Approval} event. 
     */
    function approve(address to, uint256 tokenId) external;

    /** 
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements: - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event. 
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /** 
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements: - `tokenId` must exist. 
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /** 
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll} 
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}



// ====================================================================================
//     IERC721      // OpenZeppelin Contracts (token/ERC721/extensions/IERC721Metadata.sol)
// ====================================================================================

//pragma solidity ^0.8.0;

/** 
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721 
 */
interface IERC721Metadata is IERC721 {

    /** 
     * @dev Returns the token collection name. 
     */
    function name() external view returns (string memory);

    /** 
     * @dev Returns the token collection symbol. 
     */
    function symbol() external view returns (string memory);

    /** 
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token. 
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}



// ====================================================================================
//     Math      // OpenZeppelin Contracts (utils/math/Math.sol)
// ====================================================================================

//pragma solidity ^0.8.0;

/** 
 * @dev Standard math utilities missing in the Solidity language. 
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /** 
     * @dev Returns the largest of two numbers. 
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /** 
     * @dev Returns the smallest of two numbers. 
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /** 
     * @dev Returns the average of two numbers. The result is rounded towards zero. 
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /** 
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead of rounding down. 
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /** 
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license. 
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1);

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /** 
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction. 
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /** 
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11). 
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /** 
     * @notice Calculates sqrt(a), following the selected rounding direction. 
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /** 
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0. 
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /** 
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0. 
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /** 
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0. 
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10**64) {
                value /= 10**64;
                result += 64;
            }
            if (value >= 10**32) {
                value /= 10**32;
                result += 32;
            }
            if (value >= 10**16) {
                value /= 10**16;
                result += 16;
            }
            if (value >= 10**8) {
                value /= 10**8;
                result += 8;
            }
            if (value >= 10**4) {
                value /= 10**4;
                result += 4;
            }
            if (value >= 10**2) {
                value /= 10**2;
                result += 2;
            }
            if (value >= 10**1) {
                result += 1;
            }
        }
        return result;
    }

    /** 
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0. 
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
        }
    }

    /** 
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string. 
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /** 
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0. 
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
        }
    }
}



// ====================================================================================
//     Strings      // OpenZeppelin Contracts (utils/Strings.sol)
// ====================================================================================

//pragma solidity ^0.8.0;

/** 
 * @dev String operations. 
 */
library Strings {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /** 
     * @dev Converts a `uint256` to its ASCII `string` decimal representation. 
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /** 
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation. 
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /** 
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length. 
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /** 
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation. 
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}



// ====================================================================================
//     Address      // OpenZeppelin Contracts (utils/Address.sol)
// ====================================================================================

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
     * types of addresses: - an externally-owned account
     *                     - a contract in construction
     *                     - an address where a contract will be created
     *                     - an address where a contract lived, but was destroyed
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
     * plain `call` is an unsafe replacement for a function call: use this function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements: - `target` must be a contract.
     *               - calling `target` with `data` must not revert.
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
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /** 
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements: - the calling contract must have an ETH balance of at least `value`.
     *               - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._ 
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /** 
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._ 
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
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
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
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
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /** 
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._ 
     */
    function verifyCallResultFromTarget(address target, bool success, bytes memory returndata, string memory errorMessage) internal view returns (bytes memory) {
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
    function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
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



// ====================================================================================
//  EnumerableSet.sol  //  OpenZeppelin Contracts (utils/structs/EnumerableSet.sol)
// ====================================================================================

// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
//pragma solidity ^0.8.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`) and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
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
     * Returns true if the value was added to the set, that is if it was not already present. 
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
     * Returns true if the value was removed from the set, that is if it was present. 
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
     * Requirements: - `index` must be strictly less than {length}. 
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
     * Returns true if the value was added to the set, that is if it was not already present. 
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /** 
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was present. 
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
     * Requirements: - `index` must be strictly less than {length}. 
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
     * Returns true if the value was added to the set, that is if it was not already present. 
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /** 
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was present. 
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
     * Requirements: - `index` must be strictly less than {length}. 
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
     * Returns true if the value was added to the set, that is if it was not already present. 
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /** 
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was present. 
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
     * Requirements: - `index` must be strictly less than {length}. 
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



// ===================================================================================
//  Ownable.sol                      OpenZeppelin Contracts (access/Ownable.sol)
// ===================================================================================

//pragma solidity ^0.8.0;

/** 
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. 
 * This can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to the owner. 
 */
abstract contract Ownable {
    address private _owner;

    error Ownable_caller_not_the_owner();
    error Ownable_new_owner_is_the_zero_address();

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /** 
     * @dev Initializes the contract setting the deployer as the initial owner. 
     */
    constructor() {
        _transferOwnership(msg.sender);
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
        if (owner() != msg.sender) {
            revert Ownable_caller_not_the_owner();
        }
    }

    /** 
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner. 
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /** 
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner. 
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert Ownable_new_owner_is_the_zero_address();
        }
        
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



// ====================================================================================
//  Ownable2Step.sol          OpenZeppelin Contracts (access/Ownable2Step.sol)
// ====================================================================================

//pragma solidity ^0.8.0;

/** 
 * @dev Contract module which provides access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership} and {acceptOwnership}.
 *
 * This module is used through inheritance. It will make available all functions from parent (Ownable). 
 */
abstract contract Ownable2Step is Ownable {
    address private _pendingOwner;

    error Ownable2Step_caller_is_not_the_new_owner();

    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    /** 
     * @dev Returns the address of the pending owner. 
     */
    function pendingOwner() public view virtual returns (address) {
        return _pendingOwner;
    }

    /** 
     * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
     * Can only be called by the current owner. 
     */
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        _pendingOwner = newOwner;
        emit OwnershipTransferStarted(owner(), newOwner);
    }

    /** 
     * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
     * Internal function without access restriction. 
     */
    function _transferOwnership(address newOwner) internal virtual override {
        delete _pendingOwner;
        super._transferOwnership(newOwner);
    }

    /** 
     * @dev The new owner accepts the ownership transfer. 
     */
    function acceptOwnership() public virtual {
        address sender = msg.sender;

        if (pendingOwner() != sender) {
            revert Ownable2Step_caller_is_not_the_new_owner();
        }

        _transferOwnership(sender);
    }
}



// ====================================================================================
//  OperatorFilterRegistry  >>  Constants.sol       //  @notice OpenSea overrides.
// ====================================================================================

//pragma solidity ^0.8.13;

address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;



// ====================================================================================
//  OperatorFilterRegistryErrorsAndEvents.sol       //  @notice OpenSea overrides.
// ====================================================================================

//pragma solidity ^0.8.13;

contract OperatorFilterRegistryErrorsAndEvents {
    /// @notice Emitted when trying to register an address that has no code.
    error CannotFilterEOAs();

    /// @notice Emitted when trying to add an address that is already filtered.
    error AddressAlreadyFiltered(address operator);

    /// @notice Emitted when trying to remove an address that is not filtered.
    error AddressNotFiltered(address operator);

    /// @notice Emitted when trying to add a codehash that is already filtered.
    error CodeHashAlreadyFiltered(bytes32 codeHash);

    /// @notice Emitted when trying to remove a codehash that is not filtered.
    error CodeHashNotFiltered(bytes32 codeHash);

    /// @notice Emitted when the caller is not the address or EIP-173 "owner()"
    error OnlyAddressOrOwner();

    /// @notice Emitted when the registrant is not registered.
    error NotRegistered(address registrant);

    /// @notice Emitted when the registrant is already registered.
    error AlreadyRegistered();

    /// @notice Emitted when the registrant is already subscribed.
    error AlreadySubscribed(address subscription);

    /// @notice Emitted when the registrant is not subscribed.
    error NotSubscribed();

    /// @notice Emitted when trying to update a registration where the registrant is already subscribed.
    error CannotUpdateWhileSubscribed(address subscription);

    /// @notice Emitted when trying to subscribe to itself.
    error CannotSubscribeToSelf();

    /// @notice Emitted when trying to subscribe to the zero address.
    error CannotSubscribeToZeroAddress();

    /// @notice Emitted when trying to register and the contract is not ownable (EIP-173 "owner()")
    error NotOwnable();

    /// @notice Emitted when an address is filtered.
    error AddressFiltered(address filtered);

    /// @notice Emitted when a codeHash is filtered.
    error CodeHashFiltered(address account, bytes32 codeHash);

    /// @notice Emited when trying to register to a registrant with a subscription.
    error CannotSubscribeToRegistrantWithSubscription(address registrant);

    /// @notice Emitted when trying to copy a registration from itself.
    error CannotCopyFromSelf();

    /// @notice Emitted when a registration is updated.
    event RegistrationUpdated(address indexed registrant, bool indexed registered);

    /// @notice Emitted when an operator is updated.
    event OperatorUpdated(address indexed registrant, address indexed operator, bool indexed filtered);

    /// @notice Emitted when multiple operators are updated.
    event OperatorsUpdated(address indexed registrant, address[] operators, bool indexed filtered);

    /// @notice Emitted when a codeHash is updated.
    event CodeHashUpdated(address indexed registrant, bytes32 indexed codeHash, bool indexed filtered);

    /// @notice Emitted when multiple codeHashes are updated.
    event CodeHashesUpdated(address indexed registrant, bytes32[] codeHashes, bool indexed filtered);

    /// @notice Emitted when a subscription is updated.
    event SubscriptionUpdated(address indexed registrant, address indexed subscription, bool indexed subscribed);
}



// ====================================================================================
//  IOperatorFilterRegistry.sol      //  @notice OpenSea overrides.
// ====================================================================================

//pragma solidity ^0.8.13;

interface IOperatorFilterRegistry {
    /** 
     * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
     *         true if supplied registrant address is not registered. 
     */
    function isOperatorAllowed(address registrant, address operator) external view returns (bool);

    /** 
     * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner. 
     */
    function register(address registrant) external;

    /** 
     * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes. 
     */
    function registerAndSubscribe(address registrant, address subscription) external;

    /** 
     * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
     *         address without subscribing. 
     */
    function registerAndCopyEntries(address registrant, address registrantToCopy) external;

    /** 
     * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
     *         Note that this does not remove any filtered addresses or codeHashes.
     *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes. 
     */
    function unregister(address addr) external;

    /**  
     * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered. 
     */
    function updateOperator(address registrant, address operator, bool filtered) external;

    /** 
     * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates. 
     */
    function updateOperators(address registrant, address[] calldata operators, bool filtered) external;

    /** 
     * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered. 
     */
    function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;

    /** 
     * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates. 
     */
    function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;

    /** 
     * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
     *         subscription if present.
     *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
     *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be used. 
     */
    function subscribe(address registrant, address registrantToSubscribe) external;

    /** 
     * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes. 
     */
    function unsubscribe(address registrant, bool copyExistingEntries) external;

    /** 
     * @notice Get the subscription address of a given registrant, if any. 
     */
    function subscriptionOf(address addr) external returns (address registrant);

    /** 
     * @notice Get the set of addresses subscribed to a given registrant.
     *         Note that order is not guaranteed as updates are made. 
     */
    function subscribers(address registrant) external returns (address[] memory);

    /** 
     * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
     *         Note that order is not guaranteed as updates are made. 
     */
    function subscriberAt(address registrant, uint256 index) external returns (address);

    /** 
     * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr. 
     */
    function copyEntriesOf(address registrant, address registrantToCopy) external;

    /** 
     * @notice Returns true if operator is filtered by a given address or its subscription. 
     */
    function isOperatorFiltered(address registrant, address operator) external returns (bool);

    /** 
     * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription. 
     */
    function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);

    /** 
     * @notice Returns true if a codeHash is filtered by a given address or its subscription. 
     */
    function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);

    /** 
     * @notice Returns a list of filtered operators for a given address or its subscription. 
     */
    function filteredOperators(address addr) external returns (address[] memory);

    /** 
     * @notice Returns the set of filtered codeHashes for a given address or its subscription.
     *         Note that order is not guaranteed as updates are made. 
     */
    function filteredCodeHashes(address addr) external returns (bytes32[] memory);

    /** 
     * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or its subscription.
     *         Note that order is not guaranteed as updates are made. 
     */
    function filteredOperatorAt(address registrant, uint256 index) external returns (address);

    /** 
     * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or its subscription.
     *         Note that order is not guaranteed as updates are made. 
     */
    function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);

    /** 
     * @notice Returns true if an address has registered 
     */
    function isRegistered(address addr) external returns (bool);

    /** 
     * @dev Convenience method to compute the code hash of an arbitrary contract 
     */
    function codeHashOf(address addr) external returns (bytes32);
}



// ====================================================================================
//  OperatorFilterRegistry.sol      //  @notice OpenSea overrides.
// ====================================================================================

//pragma solidity ^0.8.13;

/** 
 * @notice Borrows heavily from the QQL BlacklistOperatorFilter contract:
 *         https://github.com/qql-art/contracts/blob/main/contracts/BlacklistOperatorFilter.sol
 * @notice This contracts allows tokens or token owners to register specific addresses or codeHashes that may be
 *         restricted according to the isOperatorAllowed function. 
 */
contract OperatorFilterRegistry is IOperatorFilterRegistry, OperatorFilterRegistryErrorsAndEvents {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    /** 
     * @dev initialized accounts have a nonzero codehash (see https://eips.ethereum.org/EIPS/eip-1052).
     * Note that this will also be a smart contract's codehash when making calls from its constructor. 
     */
    bytes32 constant EOA_CODEHASH = keccak256("");

    mapping(address => EnumerableSet.AddressSet) private _filteredOperators;
    mapping(address => EnumerableSet.Bytes32Set) private _filteredCodeHashes;
    mapping(address => address) private _registrations;
    mapping(address => EnumerableSet.AddressSet) private _subscribers;

    /** 
     * @notice Restricts method caller to the address or EIP-173 "owner()" 
     */
    modifier onlyAddressOrOwner(address addr) {
        if (msg.sender != addr) {
            try Ownable(addr).owner() returns (address owner) {
                if (msg.sender != owner) {
                    revert OnlyAddressOrOwner();
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert NotOwnable();
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
        _;
    }

    /** 
     * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
     *         true if supplied registrant address is not registered.
     *         Note that this method will *revert* if an operator or its codehash is filtered with an error that is
     *         more informational than a false boolean, so smart contracts that query this method for informational
     *         purposes will need to wrap in a try/catch or perform a low-level staticcall in order to handle the case
     *         that an operator is filtered. 
     */
    function isOperatorAllowed(address registrant, address operator) external view returns (bool) {
        address registration = _registrations[registrant];
        if (registration != address(0)) {
            EnumerableSet.AddressSet storage filteredOperatorsRef;
            EnumerableSet.Bytes32Set storage filteredCodeHashesRef;

            filteredOperatorsRef = _filteredOperators[registration];
            filteredCodeHashesRef = _filteredCodeHashes[registration];

            if (filteredOperatorsRef.contains(operator)) {
                revert AddressFiltered(operator);
            }
            if (operator.code.length > 0) {
                bytes32 codeHash = operator.codehash;
                if (filteredCodeHashesRef.contains(codeHash)) {
                    revert CodeHashFiltered(operator, codeHash);
                }
            }
        }
        return true;
    }

    //////////////////
    // AUTH METHODS //
    //////////////////

    /** 
     * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner. 
     */
    function register(address registrant) external onlyAddressOrOwner(registrant) {
        if (_registrations[registrant] != address(0)) {
            revert AlreadyRegistered();
        }
        _registrations[registrant] = registrant;
        emit RegistrationUpdated(registrant, true);
    }

    /** 
     * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
     *         Note that this does not remove any filtered addresses or codeHashes.
     *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes. 
     */
    function unregister(address registrant) external onlyAddressOrOwner(registrant) {
        address registration = _registrations[registrant];
        if (registration == address(0)) {
            revert NotRegistered(registrant);
        }
        if (registration != registrant) {
            _subscribers[registration].remove(registrant);
            emit SubscriptionUpdated(registrant, registration, false);
        }
        _registrations[registrant] = address(0);
        emit RegistrationUpdated(registrant, false);
    }

    /** 
     * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes. 
     */
    function registerAndSubscribe(address registrant, address subscription) external onlyAddressOrOwner(registrant) {
        address registration = _registrations[registrant];
        if (registration != address(0)) {
            revert AlreadyRegistered();
        }
        if (registrant == subscription) {
            revert CannotSubscribeToSelf();
        }
        address subscriptionRegistration = _registrations[subscription];
        if (subscriptionRegistration == address(0)) {
            revert NotRegistered(subscription);
        }
        if (subscriptionRegistration != subscription) {
            revert CannotSubscribeToRegistrantWithSubscription(subscription);
        }

        _registrations[registrant] = subscription;
        _subscribers[subscription].add(registrant);
        emit RegistrationUpdated(registrant, true);
        emit SubscriptionUpdated(registrant, subscription, true);
    }

    /**
     * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
     *         address without subscribing. 
     */
    function registerAndCopyEntries(address registrant, address registrantToCopy) external onlyAddressOrOwner(registrant) {
        if (registrantToCopy == registrant) {
            revert CannotCopyFromSelf();
        }
        address registration = _registrations[registrant];
        if (registration != address(0)) {
            revert AlreadyRegistered();
        }
        address registrantRegistration = _registrations[registrantToCopy];
        if (registrantRegistration == address(0)) {
            revert NotRegistered(registrantToCopy);
        }
        _registrations[registrant] = registrant;
        emit RegistrationUpdated(registrant, true);
        _copyEntries(registrant, registrantToCopy);
    }

    /** 
     * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered. 
     */
    function updateOperator(address registrant, address operator, bool filtered) external onlyAddressOrOwner(registrant) {
        address registration = _registrations[registrant];
        if (registration == address(0)) {
            revert NotRegistered(registrant);
        }
        if (registration != registrant) {
            revert CannotUpdateWhileSubscribed(registration);
        }
        EnumerableSet.AddressSet storage filteredOperatorsRef = _filteredOperators[registrant];

        if (!filtered) {
            bool removed = filteredOperatorsRef.remove(operator);
            if (!removed) {
                revert AddressNotFiltered(operator);
            }
        } else {
            bool added = filteredOperatorsRef.add(operator);
            if (!added) {
                revert AddressAlreadyFiltered(operator);
            }
        }
        emit OperatorUpdated(registrant, operator, filtered);
    }

    /** 
     * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
     *         Note that this will allow adding the bytes32(0) codehash, which could result in unexpected behavior,
     *         since calling `isCodeHashFiltered` will return true for bytes32(0), which is the codeHash of any
     *         un-initialized account. Since un-initialized accounts have no code, the registry will not validate
     *         that an un-initalized account's codeHash is not filtered. By the time an account is able to
     *         act as an operator (an account is initialized or a smart contract exclusively in the context of its
     *         constructor),  it will have a codeHash of EOA_CODEHASH, which cannot be filtered. 
     */
    function updateCodeHash(address registrant, bytes32 codeHash, bool filtered) external onlyAddressOrOwner(registrant) {
        if (codeHash == EOA_CODEHASH) {
            revert CannotFilterEOAs();
        }
        address registration = _registrations[registrant];
        if (registration == address(0)) {
            revert NotRegistered(registrant);
        }
        if (registration != registrant) {
            revert CannotUpdateWhileSubscribed(registration);
        }
        EnumerableSet.Bytes32Set storage filteredCodeHashesRef = _filteredCodeHashes[registrant];

        if (!filtered) {
            bool removed = filteredCodeHashesRef.remove(codeHash);
            if (!removed) {
                revert CodeHashNotFiltered(codeHash);
            }
        } else {
            bool added = filteredCodeHashesRef.add(codeHash);
            if (!added) {
                revert CodeHashAlreadyFiltered(codeHash);
            }
        }
        emit CodeHashUpdated(registrant, codeHash, filtered);
    }

    /** 
     * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates. 
     */
    function updateOperators(address registrant, address[] calldata operators, bool filtered) external onlyAddressOrOwner(registrant) {
        address registration = _registrations[registrant];
        if (registration == address(0)) {
            revert NotRegistered(registrant);
        }
        if (registration != registrant) {
            revert CannotUpdateWhileSubscribed(registration);
        }
        EnumerableSet.AddressSet storage filteredOperatorsRef = _filteredOperators[registrant];
        uint256 operatorsLength = operators.length;
        if (!filtered) {
            for (uint256 i = 0; i < operatorsLength;) {
                address operator = operators[i];
                bool removed = filteredOperatorsRef.remove(operator);
                if (!removed) {
                    revert AddressNotFiltered(operator);
                }
                unchecked {
                    ++i;
                }
            }
        } else {
            for (uint256 i = 0; i < operatorsLength;) {
                address operator = operators[i];
                bool added = filteredOperatorsRef.add(operator);
                if (!added) {
                    revert AddressAlreadyFiltered(operator);
                }
                unchecked {
                    ++i;
                }
            }
        }
        emit OperatorsUpdated(registrant, operators, filtered);
    }

    /** 
     * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
     *         Note that this will allow adding the bytes32(0) codehash, which could result in unexpected behavior,
     *         since calling `isCodeHashFiltered` will return true for bytes32(0), which is the codeHash of any
     *         un-initialized account. Since un-initialized accounts have no code, the registry will not validate
     *         that an un-initalized account's codeHash is not filtered. By the time an account is able to
     *         act as an operator (an account is initialized or a smart contract exclusively in the context of its
     *         constructor),  it will have a codeHash of EOA_CODEHASH, which cannot be filtered. 
     */
    function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external onlyAddressOrOwner(registrant) {
        address registration = _registrations[registrant];
        if (registration == address(0)) {
            revert NotRegistered(registrant);
        }
        if (registration != registrant) {
            revert CannotUpdateWhileSubscribed(registration);
        }
        EnumerableSet.Bytes32Set storage filteredCodeHashesRef = _filteredCodeHashes[registrant];
        uint256 codeHashesLength = codeHashes.length;
        if (!filtered) {
            for (uint256 i = 0; i < codeHashesLength;) {
                bytes32 codeHash = codeHashes[i];
                bool removed = filteredCodeHashesRef.remove(codeHash);
                if (!removed) {
                    revert CodeHashNotFiltered(codeHash);
                }
                unchecked {
                    ++i;
                }
            }
        } else {
            for (uint256 i = 0; i < codeHashesLength;) {
                bytes32 codeHash = codeHashes[i];
                if (codeHash == EOA_CODEHASH) {
                    revert CannotFilterEOAs();
                }
                bool added = filteredCodeHashesRef.add(codeHash);
                if (!added) {
                    revert CodeHashAlreadyFiltered(codeHash);
                }
                unchecked {
                    ++i;
                }
            }
        }
        emit CodeHashesUpdated(registrant, codeHashes, filtered);
    }

    /** 
     * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
     *         subscription if present.
     *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
     *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be used. 
     */
    function subscribe(address registrant, address newSubscription) external onlyAddressOrOwner(registrant) {
        if (registrant == newSubscription) {
            revert CannotSubscribeToSelf();
        }
        if (newSubscription == address(0)) {
            revert CannotSubscribeToZeroAddress();
        }
        address registration = _registrations[registrant];
        if (registration == address(0)) {
            revert NotRegistered(registrant);
        }
        if (registration == newSubscription) {
            revert AlreadySubscribed(newSubscription);
        }
        address newSubscriptionRegistration = _registrations[newSubscription];
        if (newSubscriptionRegistration == address(0)) {
            revert NotRegistered(newSubscription);
        }
        if (newSubscriptionRegistration != newSubscription) {
            revert CannotSubscribeToRegistrantWithSubscription(newSubscription);
        }

        if (registration != registrant) {
            _subscribers[registration].remove(registrant);
            emit SubscriptionUpdated(registrant, registration, false);
        }
        _registrations[registrant] = newSubscription;
        _subscribers[newSubscription].add(registrant);
        emit SubscriptionUpdated(registrant, newSubscription, true);
    }

    /** 
     * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes. 
     */
    function unsubscribe(address registrant, bool copyExistingEntries) external onlyAddressOrOwner(registrant) {
        address registration = _registrations[registrant];
        if (registration == address(0)) {
            revert NotRegistered(registrant);
        }
        if (registration == registrant) {
            revert NotSubscribed();
        }
        _subscribers[registration].remove(registrant);
        _registrations[registrant] = registrant;
        emit SubscriptionUpdated(registrant, registration, false);
        if (copyExistingEntries) {
            _copyEntries(registrant, registration);
        }
    }

    /** 
     * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr. 
     */
    function copyEntriesOf(address registrant, address registrantToCopy) external onlyAddressOrOwner(registrant) {
        if (registrant == registrantToCopy) {
            revert CannotCopyFromSelf();
        }
        address registration = _registrations[registrant];
        if (registration == address(0)) {
            revert NotRegistered(registrant);
        }
        if (registration != registrant) {
            revert CannotUpdateWhileSubscribed(registration);
        }
        address registrantRegistration = _registrations[registrantToCopy];
        if (registrantRegistration == address(0)) {
            revert NotRegistered(registrantToCopy);
        }
        _copyEntries(registrant, registrantToCopy);
    }

    /** 
     * @dev helper to copy entries from registrantToCopy to registrant and emit events. 
     */
    function _copyEntries(address registrant, address registrantToCopy) private {
        EnumerableSet.AddressSet storage filteredOperatorsRef = _filteredOperators[registrantToCopy];
        EnumerableSet.Bytes32Set storage filteredCodeHashesRef = _filteredCodeHashes[registrantToCopy];
        uint256 filteredOperatorsLength = filteredOperatorsRef.length();
        uint256 filteredCodeHashesLength = filteredCodeHashesRef.length();
        for (uint256 i = 0; i < filteredOperatorsLength;) {
            address operator = filteredOperatorsRef.at(i);
            bool added = _filteredOperators[registrant].add(operator);
            if (added) {
                emit OperatorUpdated(registrant, operator, true);
            }
            unchecked {
                ++i;
            }
        }
        for (uint256 i = 0; i < filteredCodeHashesLength;) {
            bytes32 codehash = filteredCodeHashesRef.at(i);
            bool added = _filteredCodeHashes[registrant].add(codehash);
            if (added) {
                emit CodeHashUpdated(registrant, codehash, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    //////////////////
    // VIEW METHODS //
    //////////////////

    /** 
     * @notice Get the subscription address of a given registrant, if any. 
     */
    function subscriptionOf(address registrant) external view returns (address subscription) {
        subscription = _registrations[registrant];
        if (subscription == address(0)) {
            revert NotRegistered(registrant);
        } else if (subscription == registrant) {
            subscription = address(0);
        }
    }

    /** 
     * @notice Get the set of addresses subscribed to a given registrant.
     *         Note that order is not guaranteed as updates are made. 
     */
    function subscribers(address registrant) external view returns (address[] memory) {
        return _subscribers[registrant].values();
    }

    /** 
     * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
     *         Note that order is not guaranteed as updates are made. 
     */
    function subscriberAt(address registrant, uint256 index) external view returns (address) {
        return _subscribers[registrant].at(index);
    }

    /** 
     * @notice Returns true if operator is filtered by a given address or its subscription. 
     */
    function isOperatorFiltered(address registrant, address operator) external view returns (bool) {
        address registration = _registrations[registrant];
        if (registration != registrant) {
            return _filteredOperators[registration].contains(operator);
        }
        return _filteredOperators[registrant].contains(operator);
    }

    /** 
     * @notice Returns true if a codeHash is filtered by a given address or its subscription. 
     */
    function isCodeHashFiltered(address registrant, bytes32 codeHash) external view returns (bool) {
        address registration = _registrations[registrant];
        if (registration != registrant) {
            return _filteredCodeHashes[registration].contains(codeHash);
        }
        return _filteredCodeHashes[registrant].contains(codeHash);
    }

    /** 
     * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription. 
     */
    function isCodeHashOfFiltered(address registrant, address operatorWithCode) external view returns (bool) {
        bytes32 codeHash = operatorWithCode.codehash;
        address registration = _registrations[registrant];
        if (registration != registrant) {
            return _filteredCodeHashes[registration].contains(codeHash);
        }
        return _filteredCodeHashes[registrant].contains(codeHash);
    }

    /** 
     * @notice Returns true if an address has registered 
     */
    function isRegistered(address registrant) external view returns (bool) {
        return _registrations[registrant] != address(0);
    }

    /** 
     * @notice Returns a list of filtered operators for a given address or its subscription. 
     */
    function filteredOperators(address registrant) external view returns (address[] memory) {
        address registration = _registrations[registrant];
        if (registration != registrant) {
            return _filteredOperators[registration].values();
        }
        return _filteredOperators[registrant].values();
    }

    /** 
     * @notice Returns the set of filtered codeHashes for a given address or its subscription.
     *         Note that order is not guaranteed as updates are made. 
     */
    function filteredCodeHashes(address registrant) external view returns (bytes32[] memory) {
        address registration = _registrations[registrant];
        if (registration != registrant) {
            return _filteredCodeHashes[registration].values();
        }
        return _filteredCodeHashes[registrant].values();
    }

    /** 
     * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or its subscription.
     *         Note that order is not guaranteed as updates are made. 
     */
    function filteredOperatorAt(address registrant, uint256 index) external view returns (address) {
        address registration = _registrations[registrant];
        if (registration != registrant) {
            return _filteredOperators[registration].at(index);
        }
        return _filteredOperators[registrant].at(index);
    }

    /** 
     * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or its subscription.
     *         Note that order is not guaranteed as updates are made. 
     */
    function filteredCodeHashAt(address registrant, uint256 index) external view returns (bytes32) {
        address registration = _registrations[registrant];
        if (registration != registrant) {
            return _filteredCodeHashes[registration].at(index);
        }
        return _filteredCodeHashes[registrant].at(index);
    }

    /** 
     * @dev Convenience method to compute the code hash of an arbitrary contract 
     */
    function codeHashOf(address a) external view returns (bytes32) {
        return a.codehash;
    }
}



// ====================================================================================
//  OwnedRegistrant.sol       //  @notice OpenSea overrides.
// ====================================================================================

//pragma solidity ^0.8.13;

/** 
 * @notice Ownable contract that registers itself with the OperatorFilterRegistry and administers its own entries,
 *         to facilitate a subscription whose ownership can be transferred. 
 */
contract OwnedRegistrant is Ownable2Step {
    /** 
     * @dev The constructor that is called when the contract is being deployed. 
     */
    constructor(address _owner) {
        IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS).register(address(this));
        transferOwnership(_owner);
    }
}



// ====================================================================================
//  OperatorFilterer.sol        //  @notice OpenSea overrides.
// ====================================================================================

//pragma solidity ^0.8.13;

/** 
 * @title  OperatorFilterer
 * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
 *         registrant's entries in the OperatorFilterRegistry.
 * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
 *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
 *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
 *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
 *         administration methods on the contract itself to interact with the registry otherwise the subscription
 *         will be locked to the options set during construction. 
 */
abstract contract OperatorFilterer {
    /** 
     * @dev Emitted when an operator is not allowed. 
     */
    error OperatorNotAllowed(address operator);

    IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
        IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);

    /** 
     * @dev The constructor that is called when the contract is being deployed. 
     */
    constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
        // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
        // will not revert, but the contract will need to be registered with the registry once it is deployed in
        // order for the modifier to filter addresses.
        if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
            if (subscribe) {
                OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
            } else {
                if (subscriptionOrRegistrantToCopy != address(0)) {
                    OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
                } else {
                    OPERATOR_FILTER_REGISTRY.register(address(this));
                }
            }
        }
    }

    /** 
     * @dev A helper function to check if an operator is allowed. 
     */
    modifier onlyAllowedOperator(address from) virtual {
        // Allow spending tokens from addresses with balance
        // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
        // from an EOA.
        if (from != msg.sender) {
            _checkFilterOperator(msg.sender);
        }
        _;
    }

    /** 
     * @dev A helper function to check if an operator approval is allowed. 
     */
    modifier onlyAllowedOperatorApproval(address operator) virtual {
        _checkFilterOperator(operator);
        _;
    }

    /** 
     * @dev A helper function to check if an operator is allowed. 
     */
    function _checkFilterOperator(address operator) internal view virtual {
        // Check registry code length to facilitate testing in environments without a deployed registry.
        if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
            // under normal circumstances, this function will revert rather than return false, but inheriting contracts
            // may specify their own OperatorFilterRegistry implementations, which may behave differently
            if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
                revert OperatorNotAllowed(operator);
            }
        }
    }
}



// ====================================================================================
//  DefaultOperatorFilterer.sol       //  @notice OpenSea overrides.
// ====================================================================================

//pragma solidity ^0.8.13;

/** 
 * @title  DefaultOperatorFilterer
 * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
 * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
 *         administration methods on the contract itself to interact with the registry otherwise the subscription
 *         will be locked to the options set during construction. 
 */
abstract contract DefaultOperatorFilterer is OperatorFilterer {
    // @dev The constructor that is called when the contract is being deployed.
    constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {
    }
}



// ====================================================================================
//   ERC721.sol
// ====================================================================================

//pragma solidity ^0.8.14;

contract ERC721 is IERC721, ERC165, Ownable, IERC721Metadata, DefaultOperatorFilterer {
    
    using Address for address;
    using Strings for uint256;

    // Collection size
    uint256 constant COLECTION_SIZE = 500;

    // Count token id
    uint256 private _counterId;

    // The number of tokens burned.
    uint256 private _burnCounter;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Base URI
    string private BASE_URI;

    // Contract creator address
    address immutable _creator = msg.sender;

    // Array of all tokens storing the owner's address
    address[COLECTION_SIZE + 1] private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;


    error Token_id_is_invalid();
    error Zero_address_is_not_valid();
    error Amount_exceeds_the_size_of_the_collection();
    error Incorrect_owner_of_the_token();
    error Approval_To_Current_Owner();
    error Approve_Caller_Is_Not_Owner_or_ApprovedForAll();
    error Approve_To_Caller();
    error Transfer_Caller_Is_Not_Owner_or_Approved();
    error Transfer_To_Non_ERC721_Receiver_Implementer();
    

	/** 
     * @dev Initializes the contract by setting a `name` a `symbol` and a `baseUri` to the token collection. 
     */  
    constructor(string memory name_, string memory symbol_, string memory baseUri_) {
        _name = name_;
        _symbol = symbol_;
        BASE_URI = baseUri_;
    }

    // =====================================================================
    //                             IERC165
    // =====================================================================

    /** 
     * @dev See {IERC165-supportsInterface}. 
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override (ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
    }

    // =====================================================================
    //                        IERC721 METADATA
    // =====================================================================

    /**  
     * @dev See {IERC721Metadata-name}. 
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /** 
     * @dev See {IERC721Metadata-symbol}. 
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /** 
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts. 
     */
    function _baseURI() internal view virtual returns (string memory) {
        return BASE_URI;
    }

    /** 
     * @dev See {IERC721Metadata-tokenURI}. 
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _exists(tokenId); // Checks if the `tokenId` exists.

        string memory baseURI = _baseURI();
        
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")) : "";
    }

    // =====================================================================
    //                        INTERNAL FUNCTIONS
    // =====================================================================

    /** 
     * @dev Increases the owner's balance. 
     */
    function _incrementBalances(address to, uint256 amount) internal {
        unchecked {
            _balances[to] += amount;
        }
    }

    /** 
     * @dev Decreases the owner's balance. 
     */
    function _decrementBalances(address to, uint256 amount) internal {
        unchecked {
            _balances[to] -= amount;
        }
    }

    /** 
     * @dev For more efficient reverts. 
     */
    function _revert(bytes4 errorSelector) internal pure {
        assembly {
            mstore(0x00, errorSelector)
            revert(0x00, 0x04)
        }
    }

    /** 
     * @dev Address passed in is not the zero address. 
     */
    function _validAddress(address toCheck) internal pure {
        if (toCheck == address(0)) {
            _revert(Zero_address_is_not_valid.selector);
        }
    }

    /** 
     * @dev Returns the address of the owner of the token. 
     */
    function _ownerToken(uint256 tokenId) internal view returns (address) {
        return _owners[tokenId];
    }

    // =====================================================================
    //                      TOKEN COUNTING OPERATIONS
    // =====================================================================

    /** 
     * @dev Total amount of tokens minted. 
     */
    function totalMinted() public view returns (uint256) {
        return _counterId;
    }

    /** 
     * @dev Total amount of tokens burned. 
     */
    function totalBurned() public view returns (uint256) {
        return _burnCounter;
    }

    /** 
     * @dev Total amount of tokens in with a given id. 
     */
    function totalSupply() public view returns (uint256) {
        unchecked {
            return _counterId - _burnCounter;
        }
    }

    // =====================================================================
    //                      ADDRESS DATA OPERATIONS
    // =====================================================================

    /** 
     * @dev See {IERC721-balanceOf}. 
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        _validAddress(owner); // Address passed in is not the zero address.
        
        return _balances[owner];
    }

    // =====================================================================
    //                      OWNERSHIPS OPERATIONS
    // =====================================================================

    /** 
     * @dev See {IERC721-ownerOf}. 
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner_ = _ownerToken(tokenId);

        _exists(tokenId); // Checks if the `tokenId` exists.

        if (owner_ == _ownerToken(0)) {
            owner_ = _creator;
        }

        return owner_;
    }

    // =====================================================================
    //                        TOKEN OPERATIONS
    // =====================================================================

    /** 
     * @dev Returns whether `tokenId` exists.
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`). 
     */
    function _exists(uint256 tokenId) internal view virtual {
        if (tokenId == 0 || tokenId > _counterId || _ownerToken(tokenId) == address(0xdEaD)) {
            _revert(Token_id_is_invalid.selector);
        }
    }

    // =====================================================================
    //                         MINT OPERATIONS
    // =====================================================================

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements: - `tokenId` must not exist.
     *               - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event. 
     */
    function _safeMint(address to, uint256 amount) internal virtual {
        _safeMint(to, amount, "");
    }

    /** 
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients. 
     */
    function _safeMint(address to, uint256 amount, bytes memory _data) internal virtual {
        _mint(to , amount);

        if (!_checkOnERC721Received(address(0), to, _counterId - 1, _data)) {
            _revert(Transfer_To_Non_ERC721_Receiver_Implementer.selector);
        }
    }

    /** 
     * @dev Mints `tokenId` and transfers it to `to`.
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements: - `tokenId` must not exist.
     *               - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event. 
     */
    function _mint(address to, uint256 amount) internal {
        address creator_ = _creator;
        uint256 j = _counterId;
        
        _validAddress(to); // Address passed in is not the zero address.

        unchecked {
            if (j + amount > COLECTION_SIZE) {
                _revert(Amount_exceeds_the_size_of_the_collection.selector);
            }

            for (uint256 i; i < amount; i += 1) {
                j += 1;
                
                if (to != creator_) {
                    _owners[j] = to;
                }

                emit Transfer(address(0), to, j);
            }

            _incrementBalances(to, amount); // Increase the owner's balance
        }

        _counterId = j;
    }

    // =====================================================================
    //                          BURN OPERATIONS
    // =====================================================================

    /** 
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements: - `tokenId` must exist.
     *
     * Emits a {Transfer} event. 
     */
    function _burn(uint256 tokenId) internal {
        address owner_ = msg.sender;
        
        _exists(tokenId); // Checks if the `tokenId` exists.

        if (owner_ != ownerOf(tokenId)) {
            _revert(Incorrect_owner_of_the_token.selector);
        }
        
        _approve(address(0), tokenId);
        _owners[tokenId] = address(0xdEaD);

        _decrementBalances(owner_, 1); // Decreases the owner's balance
        _burnCounter += 1; // Increases `_burnCounter`;
       
        emit Transfer(owner_, address(0), tokenId);
    }

    // =====================================================================
    //                         APPROVAL OPERATIONS
    // =====================================================================

    /** 
     * @dev See {IERC721-approve}.
     * @notice DefaultOperatorFilterer OpenSea overrides. 
     */
    function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
        address owner_ = ownerOf(tokenId);

        if (operator == owner_) {
            _revert(Approval_To_Current_Owner.selector);
        }

        if (msg.sender != owner_ && !isApprovedForAll(owner_, msg.sender)) {
            _revert(Approve_Caller_Is_Not_Owner_or_ApprovedForAll.selector);
        }

        _approve(operator, tokenId);
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     * @notice DefaultOperatorFilterer OpenSea overrides. 
     */
    function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
        if (operator == msg.sender) {
            _revert(Approve_To_Caller.selector);
        }

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /** 
     * @dev See {IERC721-getApproved}. 
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        _exists(tokenId); // Checks if the `tokenId` exists.

        return _tokenApprovals[tokenId];
    }

    /** 
     * @dev See {IERC721-isApprovedForAll}. 
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /** 
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements: - `tokenId` must exist. 
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool){
        _exists(tokenId); // Checks if the `tokenId` exists.

        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /** 
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event. 
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    // =====================================================================
    //                         TRANSFER OPERATIONS
    // =====================================================================

    /** 
     * @dev See {IERC721-transferFrom}.
     * @notice DefaultOperatorFilterer OpenSea overrides.
     */ 
    function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {      
        _tranfer(from, to, tokenId);
    }

    /** 
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /** 
     * @dev See {IERC721-safeTransferFrom}.
     * @notice DefaultOperatorFilterer OpenSea overrides.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            _revert(Transfer_Caller_Is_Not_Owner_or_Approved.selector);
        }

        _tranfer(from, to, tokenId);

        if (!_checkOnERC721Received(from, to, tokenId, data)) {
            _revert(Transfer_To_Non_ERC721_Receiver_Implementer.selector);
        }
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *
     * Requirements: - `to` cannot be the zero address.
     *               - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _tranfer(address from, address to, uint256 tokenId) internal {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            _revert(Transfer_Caller_Is_Not_Owner_or_Approved.selector);
        }

        _validAddress(to); // Address passed in is not the zero address.
        
        if (from != ownerOf(tokenId)) {
            _revert(Incorrect_owner_of_the_token.selector);
        }

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);
        _owners[tokenId] = to;

        _decrementBalances(from, 1); // Decreases the owner's balance
        _incrementBalances(to, 1); // Increase the owner's balance

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value 
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } 
            catch (bytes memory reason) {
                if (reason.length == 0) {
                    _revert(Transfer_To_Non_ERC721_Receiver_Implementer.selector);
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }


    /**
     * @dev Hook that is called before a set of serially-ordered token IDs are about to be transferred. This includes minting.
     * And also called before burning one token.
     *
     * `startTokenId` - the first token ID to be transferred.
     * `quantity` - the amount to be transferred.
     *
     * Calling conditions: - When `from` and `to` are both non-zero, `from`'s `tokenId` will be transferred to `to`.
     *                     - When `from` is zero, `tokenId` will be minted for `to`.
     *                     - When `to` is zero, `tokenId` will be burned by `from`.
     *                     - `from` and `to` are never both zero. 
     */
    function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {
    }

    /** 
     * @dev Hook that is called after a set of serially-ordered token IDs have been transferred. This includes minting.
     * And also called after one token has been burned.
     *
     * `startTokenId` - the first token ID to be transferred.
     * `quantity` - the amount to be transferred.
     *
     * Calling conditions: - When `from` and `to` are both non-zero, `from`'s `tokenId` has been transferred to `to`.
     *                     - When `from` is zero, `tokenId` has been minted for `to`.
     *                     - When `to` is zero, `tokenId` has been burned by `from`.
     *                     - `from` and `to` are never both zero. 
     */
    function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {
    }
}


//pragma solidity ^0.8.14;

contract LuxeDots is ERC721 {

    /** 
     * @dev Initializes the contract by setting a `name` a `symbol` and a `baseUri` to the token collection. 
     */ 
    constructor(string memory name_, string memory symbol_, string memory baseUri_) ERC721(name_, symbol_, baseUri_) {
    }

    /**
     * @notice Mint tokens for the owner.
     */
    function mint(uint256 amount) external onlyOwner {
        _safeMint(msg.sender, amount);
    }
}