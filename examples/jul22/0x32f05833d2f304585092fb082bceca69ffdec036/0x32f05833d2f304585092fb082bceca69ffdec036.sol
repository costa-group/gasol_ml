// File: node_modules\@openzeppelin\contracts-upgradeable\utils\AddressUpgradeable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
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
        return functionCall(target, data, "Address: low-level call failed");
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
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
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
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
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
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin\contracts-upgradeable\proxy\utils\Initializable.sol


// OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/Initializable.sol)

//pragma solidity ^0.8.0;


/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
 * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() initializer {}
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        // If the contract is initializing we ignore whether _initialized is set in order to support multiple
        // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
        // contract may have been reentered.
        require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} modifier, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}

// File: contracts\interface\IERC20.sol



//pragma solidity ^0.8.2;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
    function decimals() external view returns (uint8);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: contracts\library\SafeMath.sol



//pragma solidity ^0.8.2;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a <= b ? a : b;
    }

    function abs(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a < b) {
            return b - a;
        }
        return a - b;
    }
}

// File: contracts\library\Address.sol



//pragma solidity ^0.8.2;

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
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
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
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
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
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
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
        return _functionCallWithValue(target, data, 0, errorMessage);
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
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
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
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: contracts\library\SafeERC20.sol



//pragma solidity ^0.8.2;




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
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
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
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(
            value
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeERC20: decreased allowance below zero"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

// File: contracts\LiquidityMining.sol


//pragma solidity ^0.8.2;





contract LiquidityMining is Initializable{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct PoolInfo{
        address xToken;
        address collection;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accPerShare;
        uint256 amount;
    }

    struct UserInfo{
        uint256 amount;
        mapping(uint256 /* orderId */ => uint256 /* amount */) orders;
        uint256 rewardDebt;
        uint256 rewardToClaim;
    }

    bool internal _notEntered;

    IERC20 public erc20Token;

    address public controller;
    address public admin;
    address public pendingAdmin;

    uint256 public borrowPerBlockReward;
    uint256 public borrowTotalAllocPoint;

    mapping(address /* xToken */ => mapping(address /* collection */ => PoolInfo)) public borrowPoolInfoMap;
    mapping(address /* xToken */ => mapping(address /* collection */ => mapping(address /* user */ => UserInfo))) public borrowUserInfoMap;
    mapping(address /* xToken */ => uint256) public supplyPerBlockRewardMap;
    mapping(address /* xToken */ => PoolInfo) public supplyPoolInfoMap;
    mapping(address /* xToken */ => mapping(address /* user */ => UserInfo)) public supplyUserInfoMap;

    // wAddress => bassAddress
    mapping(address => address) public wAddressToBaseAddressMap;

    event Deposit(address xToken, address collection, bool isBorrow, uint256 amount, address account);
    event Withdraw(address xToken, address collection, bool isBorrow, uint256 amount, address account);
    event Claim(address xToken, address collection, bool isBorrow, uint256 amount, address account);

    function initialize() public initializer {
        admin = msg.sender;
        _notEntered = true;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "require admin auth");
        _;
    }

    modifier onlyController() {
        require(msg.sender == controller || msg.sender == admin, "require controller auth");
        _;
    }

    modifier nonReentrant() {
        require(_notEntered, "re-entered");
        _notEntered = false;
        _;
        _notEntered = true;
    }

    function setPendingAdmin(address payable newPendingAdmin) external onlyAdmin{
        pendingAdmin = newPendingAdmin;
    }

    function acceptAdmin() public{
        require(msg.sender == pendingAdmin, "only pending admin could accept");
        admin = pendingAdmin;
        pendingAdmin = address(0);
    }

    function setController(address _controller) external onlyAdmin{
        controller = _controller;
    }

    function setErc20Token(IERC20 _erc20Token) external onlyAdmin{
        erc20Token = _erc20Token;
    }

    function setBorrowPerBlockReward(uint256 _borrowPerBlockReward) external onlyAdmin{
        borrowPerBlockReward = _borrowPerBlockReward;
    }

    function setSupplyPerBlockRewardMap(address xToken, uint256 perBlockReward) external onlyAdmin{
        supplyPerBlockRewardMap[xToken] = perBlockReward;
    }

    function setWAddressToBaseAddressMap(address wAddress, address baseAddress) external onlyAdmin{
        wAddressToBaseAddressMap[wAddress] = baseAddress;
    }

    function addPool(address xToken, address collection, uint256 allocPoint, bool isBorrow) external onlyAdmin{
        PoolInfo memory poolInfo;
        if(isBorrow){
            poolInfo = borrowPoolInfoMap[xToken][collection];
            require(poolInfo.xToken == address(0), "pool already exists!");
            poolInfo.xToken = xToken;
            poolInfo.collection = collection;
            poolInfo.allocPoint = allocPoint;
            poolInfo.lastRewardBlock = block.number;
            borrowPoolInfoMap[xToken][collection] = poolInfo;

            borrowTotalAllocPoint += allocPoint;
        }else{
            poolInfo = supplyPoolInfoMap[xToken];
            require(poolInfo.xToken == address(0), "pool already exists!");
            poolInfo.xToken = xToken;
            poolInfo.lastRewardBlock = block.number;
            supplyPoolInfoMap[xToken] = poolInfo;
        }
    }

    function setPool(address xToken, address collection, uint256 allocPoint, bool isBorrow) external onlyAdmin{
        if(isBorrow){
            PoolInfo storage poolInfo = borrowPoolInfoMap[xToken][collection];
            require(poolInfo.xToken != address(0), "pool not exists!");

            borrowTotalAllocPoint = borrowTotalAllocPoint.sub(poolInfo.allocPoint).add(allocPoint);

            poolInfo.xToken = xToken;
            poolInfo.collection = collection;
            poolInfo.allocPoint = allocPoint;
        }else{
            PoolInfo storage poolInfo = supplyPoolInfoMap[xToken];
            require(poolInfo.xToken != address(0), "pool not exists!");
            poolInfo.xToken = xToken;
        }
    }

    function updatePool(address xToken, address collection, bool isBorrow) public{
        if(isBorrow){
            updateBorrowPool(xToken, collection);
        }else{
            updateSupplyPool(xToken);
        }
    }

    function updateBorrowPool(address xToken, address collection) internal{
        PoolInfo storage poolInfo = borrowPoolInfoMap[xToken][collection];
        if(poolInfo.xToken != address(0)){
            if (block.number <= poolInfo.lastRewardBlock) {
                return;
            }
            uint256 supply = poolInfo.amount;
            if (supply == 0) {
                poolInfo.lastRewardBlock = block.number;
                return;
            }
            uint256 multiplier = (block.number.sub(poolInfo.lastRewardBlock)).mul(borrowPerBlockReward);
            uint256 reward = multiplier.mul(poolInfo.allocPoint).div(borrowTotalAllocPoint);
            poolInfo.accPerShare = poolInfo.accPerShare.add(reward.mul(1e18).div(supply));
            poolInfo.lastRewardBlock = block.number;
        }
    }

    function updateSupplyPool(address xToken) internal{
        PoolInfo storage poolInfo = supplyPoolInfoMap[xToken];
        if(poolInfo.xToken != address(0)){
            if (block.number <= poolInfo.lastRewardBlock) {
                return;
            }
            uint256 supply = poolInfo.amount;
            if (supply == 0) {
                poolInfo.lastRewardBlock = block.number;
                return;
            }
            uint256 reward = (block.number.sub(poolInfo.lastRewardBlock)).mul(supplyPerBlockRewardMap[xToken]);
            poolInfo.accPerShare = poolInfo.accPerShare.add(reward.mul(1e18).div(supply));
            poolInfo.lastRewardBlock = block.number;
        }
    }

    function massUpdatePools(address[] calldata xToken, address[] calldata collection) external{
        for (uint256 i=0; i<xToken.length; ++i) {
            for(uint256 j=0; j<collection.length; ++j){
                updatePool(xToken[i], collection[j], true);
            }
            updatePool(xToken[i], address(0), false);
        }
    }

    function updateBorrow(address xToken, address collection, uint256 amount, address account, uint256 orderId, bool isDeposit) external onlyController nonReentrant{
        if(wAddressToBaseAddressMap[collection] != address(0x0)){
            collection = wAddressToBaseAddressMap[collection];
        }
        PoolInfo storage poolInfo = borrowPoolInfoMap[xToken][collection];
        if(poolInfo.xToken == address(0)) return;
        UserInfo storage user = borrowUserInfoMap[xToken][collection][account];
        if(!isDeposit && user.amount == 0) return;
        updatePool(xToken, collection, true);
        if((isDeposit && user.amount > 0) || !isDeposit){
            uint256 pending = user.amount.mul(poolInfo.accPerShare).div(1e18).sub(user.rewardDebt);
            user.rewardToClaim = user.rewardToClaim.add(pending);
        }
        poolInfo.amount = poolInfo.amount.sub(user.orders[orderId]).add(amount);
        user.amount = user.amount.sub(user.orders[orderId]).add(amount);
        user.rewardDebt = user.amount.mul(poolInfo.accPerShare).div(1e18);
        user.orders[orderId] = amount;
    }

    function updateSupply(address xToken, uint256 amount, address account, bool isDeposit) external onlyController nonReentrant{
        PoolInfo storage poolInfo = supplyPoolInfoMap[xToken];
        if(poolInfo.xToken == address(0)) return;
        UserInfo storage user = supplyUserInfoMap[xToken][account];
        if(!isDeposit && user.amount == 0) return;
        updatePool(xToken, address(0), false);
        if((isDeposit && user.amount > 0) || !isDeposit){
            uint256 pending = user.amount.mul(poolInfo.accPerShare).div(1e18).sub(user.rewardDebt);
            user.rewardToClaim = user.rewardToClaim.add(pending);
        }
        poolInfo.amount = poolInfo.amount.sub(user.amount).add(amount);
        user.amount = amount;
        user.rewardDebt = user.amount.mul(poolInfo.accPerShare).div(1e18);
    }

    function claim(address xToken, address collection, bool isBorrow, address account) internal{
        if(isBorrow){
            claimBorrowInternal(xToken, collection, account);
        }else{
            claimSupplyInternal(xToken, account);
        }
    }

    function claimBorrowInternal(address xToken, address collection, address account) internal{
        PoolInfo storage poolInfo = borrowPoolInfoMap[xToken][collection];
        if(poolInfo.xToken == address(0)) return;
        UserInfo storage user = borrowUserInfoMap[xToken][collection][account];
        updatePool(xToken, collection, true);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(poolInfo.accPerShare).div(1e18).sub(user.rewardDebt);
            user.rewardToClaim = user.rewardToClaim.add(pending);
        }
        user.rewardDebt = user.amount.mul(poolInfo.accPerShare).div(1e18);
        erc20Token.safeTransfer(account, user.rewardToClaim);
        
        emit Claim(xToken, collection, true, user.rewardToClaim, account);
        user.rewardToClaim = 0;
    }

    function claimBorrow(address xToken, address collection, address account) external nonReentrant{
        claimBorrowInternal(xToken, collection, account);
    }

    function claimSupplyInternal(address xToken, address account) internal{
        PoolInfo storage poolInfo = supplyPoolInfoMap[xToken];
        if(poolInfo.xToken == address(0)) return;
        UserInfo storage user = supplyUserInfoMap[xToken][account];
        updatePool(xToken, address(0), false);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(poolInfo.accPerShare).div(1e18).sub(user.rewardDebt);
            user.rewardToClaim = user.rewardToClaim.add(pending);
        }
        user.rewardDebt = user.amount.mul(poolInfo.accPerShare).div(1e18);
        erc20Token.safeTransfer(account, user.rewardToClaim);
        
        emit Claim(xToken, address(0), false, user.rewardToClaim, account);
        user.rewardToClaim = 0;
    }

    function claimSupply(address xToken, address account) external nonReentrant{
        claimSupplyInternal(xToken, account);
    }

    function claimAll(address[] calldata xToken, address[] calldata collection) external nonReentrant{
        for(uint256 i=0; i<xToken.length; ++i){
            for(uint256 j=0; j<collection.length; ++j){
                if(getPendingAmount(xToken[i], collection[j], msg.sender, true) > 0){
                    claim(xToken[i], collection[j], true, msg.sender);
                }
            }
            if(getPendingAmount(xToken[i], address(0), msg.sender, false) > 0){
                claim(xToken[i], address(0), false, msg.sender);
            }
        }
    }

    function getPendingAmountOfBorrow(address[] memory xToken, address[] memory collection, address account) external view returns(uint256){
        uint256 allAmount = 0;
        for(uint256 i=0; i<xToken.length; i++){
            for(uint256 j=0; j<collection.length; j++){
                allAmount = allAmount.add(getPendingAmount(xToken[i], collection[j], account, true));
            }
        }
        return allAmount;
    }

    function getPendingAmountOfSupply(address[] memory xToken, address account) external view returns(uint256){
        uint256 allAmount = 0;
        for(uint256 i=0; i<xToken.length; i++){
            allAmount = allAmount.add(getPendingAmount(xToken[i], address(0), account, false));
        }
        return allAmount;
    }

    function getPendingAmount(address xToken, address collection, address account, bool isBorrow) internal view returns(uint256){
        PoolInfo memory poolInfo;
        UserInfo storage user;
        if(isBorrow){
            poolInfo = borrowPoolInfoMap[xToken][collection];
            user = borrowUserInfoMap[xToken][collection][account];
        }else{
            poolInfo = supplyPoolInfoMap[xToken];
            user = supplyUserInfoMap[xToken][account];
        }
        if(poolInfo.xToken == address(0)) return 0;
        uint256 accPerShare = poolInfo.accPerShare;
        uint256 supply = poolInfo.amount;
        if(block.number > poolInfo.lastRewardBlock && supply != 0){
            uint256 reward;
            if(isBorrow){
                uint256 multiplier = (block.number.sub(poolInfo.lastRewardBlock)).mul(borrowPerBlockReward);
                reward = multiplier.mul(poolInfo.allocPoint).div(borrowTotalAllocPoint);
            }else{
                reward = (block.number.sub(poolInfo.lastRewardBlock)).mul(supplyPerBlockRewardMap[xToken]);
            }
            accPerShare = accPerShare.add(reward.mul(1e18).div(supply));
        }
        uint256 pending = user.amount.mul(accPerShare).div(1e18).sub(user.rewardDebt);
        uint256 totalPendingAmount = user.rewardToClaim.add(pending);
        return totalPendingAmount;
    }

    function getAllPendingAmount(address[] calldata xToken, address[] calldata collection, address account) external view returns (uint256){
        uint256 allAmount = 0;
        for (uint256 i=0; i<xToken.length; ++i) {
            for(uint256 j=0; j<collection.length; ++j){
                allAmount = allAmount.add(getPendingAmount(xToken[i], collection[j], account, true));
            }
            allAmount = allAmount.add(getPendingAmount(xToken[i], address(0), account, false));
        }
        return allAmount;
    }

    function getOrderIdAmount(address xToken, address collection, address account, uint256 orderId) external view returns(uint256){
        UserInfo storage user = borrowUserInfoMap[xToken][collection][account];
        return user.orders[orderId];
    }
}