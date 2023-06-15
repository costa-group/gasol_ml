// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/7f6a1666fac8ecff5dd467d0938069bc221ea9e0/contracts/utils/math/SafeMath.sol
 
 
 
pragma solidity ^0.8.0;
 
// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.
 
/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }
 
    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
 
    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }
 
    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
 
    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }
 
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
        return a + b;
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
        return a - b;
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
        return a * b;
    }
 
    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
 
    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        return a % b;
    }
 
    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
 
    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
 
    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}
 
// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
 
 
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
 
//pragma solidity ^0.8.0;
 
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
 
// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
 
 
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
 
// File: poms.sol
 
 
 
//pragma solidity ^0.8.7;
 
 
 
/**
 * @dev Interfaces
 */
 
interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}
 
interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
 
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
 
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
 
interface IUniswapV2Router02 is IUniswapV2Router01{
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);
 
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
 
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
 
    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
 
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
}
 
/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);
 
    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);
}
 
contract PBLToken is Context, IERC20, IERC20Metadata, Ownable {
    receive() external payable {}
 
    event SendNative(bool _wallet);
 
    using SafeMath for uint256;
 
    mapping(address => uint256) private _balances;
 
    mapping(address => mapping(address => uint256)) private _allowances;
 
    uint256 _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
 
    // fees & addresses
    mapping (string => uint) txFees;
 
    mapping (address => bool) public feeExempt;
    mapping (address => bool) public txLimitExempt;
 
    address public farmingAddress = msg.sender;
    address public taxAddress = msg.sender;
    address public nativeTokenAddress = msg.sender;
 
    // taxes for differnet levels
 
    struct TokenFee {
        uint forMarketing;
        uint forDev;
        uint forFarming;
    }
 
    struct TxLimit {
        uint buyLimit;
        uint sellLimit;
        uint cooldown;
        bool inactive;
        mapping(address => uint) buys;
        mapping(address => uint) sells;
        mapping(address => uint) lastTx;
    }
 
    TxLimit txLimits;
 
    struct SwapToken {
        uint swapTokensAt;
        uint lastSwap;
        uint swapDelay;
        uint minToSend;
    }
 
    SwapToken public swapTokens;
 
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
 
    constructor() {
        _name = "POM Blend";
        _symbol = "PBL";
        _decimals = 18;
        _totalSupply = 100_000_000 * (10 ** decimals());
 
        feeExempt[msg.sender] = true;
        txLimitExempt[msg.sender] = true;
        feeExempt[address(this)] = true;
        txLimitExempt[address(this)] = true;
        feeExempt[farmingAddress] = true;
        txLimitExempt[farmingAddress] = true;
        feeExempt[taxAddress] = true;
        txLimitExempt[taxAddress] = true;
        feeExempt[nativeTokenAddress] = true;
        txLimitExempt[nativeTokenAddress] = true;
 
        /**
            Set default buy/sell tx fees (no tax on transfers)
            - marketing, dev, liqudity, farming
        */
        txFees["marketingBuy"] = 100; // 1%
        txFees["liqBuy"] = 250;
        txFees["farmingBuy"] = 100;
 
        txFees["marketingSell"] = 200;
        txFees["liqSell"] = 500;
        txFees["farmingSell"] = 200;
 
        /**
            Set default tx limits
            - Cooldown, buy limit, sell limit
        */
        txLimits.cooldown = 30 seconds;
        txLimits.buyLimit = _totalSupply.div(100);
        txLimits.sellLimit = _totalSupply.div(100);
 
        swapTokens.swapTokensAt = _totalSupply.div(1394); // 0.1%
        swapTokens.minToSend = 10_000 ether;
        swapTokens.swapDelay = 1 minutes;
 
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Router = _uniswapV2Router;
        _approve(address(this), address(uniswapV2Router), _totalSupply);
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
 
        approve(address(uniswapV2Router), _totalSupply);
        feeExempt[address(uniswapV2Router)] = true;
 
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
 
    /**
        Sets buy/sell transaction fees
    */
    event Fees(
        uint _marketingBuy,
        uint _liqBuy,
        uint _farmingBuy,
        uint _marketingSell,
        uint _liqSell,
        uint _farmingSell
    );
 
    function setFees(
        uint _marketingBuy,
        uint _liqBuy,
        uint _farmingBuy,
        uint _marketingSell,
        uint _liqSell,
        uint _farmingSell
    ) external onlyOwner {
        require(_marketingBuy <= 800, "Marketing fee is too high!");
        require(_liqBuy <= 800, "Dev fee is too high!");
        require(_farmingBuy <= 800, "Farming fee is too high!");
        require(_marketingSell <= 800, "Marketing fee is too high!");
        require(_liqSell <= 800, "Dev fee is too high!");
        require(_farmingSell <= 800, "Farming fee is too high!");
 
        txFees["marketingBuy"] = _marketingBuy;
        txFees["liqBuy"] = _liqBuy;
        txFees["farmingBuy"] = _farmingBuy;
 
        txFees["marketingSell"] = _marketingSell;
        txFees["liqSell"] = _liqSell;
        txFees["farmingSell"] = _farmingSell;
 
        emit Fees(
            _marketingBuy,
            _liqBuy,
            _farmingBuy,
            _marketingSell,
            _liqSell,
            _farmingSell
        );
    }
 
    /**
        Returns buy/sell transaction fees
    */
    function getFees() public view returns(
        uint marketingBuy,
        uint liqBuy,
        uint farmingBuy,
        uint marketingSell,
        uint liqSell,
        uint farmingSell
    ) {
        return (
            txFees["marketingBuy"],
            txFees["liqBuy"],
            txFees["farmingBuy"],
            txFees["marketingSell"],
            txFees["liqSell"],
            txFees["farmingSell"]
        );
    }
 
    /**
        Sets the tax collector contracts
    */
    function setTaxAddress(address _farmingAddress, address _taxAddress, address _nativeTokenAddress) external onlyOwner {
        farmingAddress = _farmingAddress;
        taxAddress = _taxAddress;
        nativeTokenAddress = _nativeTokenAddress;
    }
 
    /**
        Sets the tax free trading for the specific address
    */
    function setFeeExempt(address _address, bool _value) external onlyOwner {
        feeExempt[_address] = _value;
    }
 
    /**
        Sets the limit free trading for the specific address
    */
    function setTxLimitExempt(address _address, bool _value) external onlyOwner {
        txLimitExempt[_address] = _value;
    }
 
    /**
        Sets the sell/buy limits & cooldown period
    */
    function setTxLimits(uint _buyLimit, uint _sellLimit, uint _cooldown, bool _inactive) external onlyOwner {
        require(_buyLimit >= _totalSupply.div(200), "Buy transaction limit is too low!"); // 0.5%
        require(_sellLimit >= _totalSupply.div(400), "Sell transaction limit is too low!"); // 0.25%
        require(_cooldown <= 30 minutes, "Cooldown should be 30 minutes or less!");
 
        txLimits.buyLimit = _buyLimit;
        txLimits.sellLimit = _sellLimit;
        txLimits.cooldown = _cooldown;
        txLimits.inactive = _inactive;
    }
 
    /**
        Sell tokens at
    */
    function setSwapTokens(uint _swapTokensAt, uint _lastSwap, uint _delay) external onlyOwner {
        swapTokens.swapTokensAt = _swapTokensAt;
        swapTokens.lastSwap = _lastSwap;
        swapTokens.swapDelay = _delay;
    }
 
    /**
        Returns the sell/buy limits & cooldown period
    */
    function getTxLimits() public view returns(uint buyLimit, uint sellLimit, uint cooldown, bool inactive) {
        return (txLimits.buyLimit, txLimits.sellLimit, txLimits.cooldown, txLimits.inactive);
    }
 
    /**
        Checks the BUY transaction limits for the specific user with the sent amount
    */
    function checkBuyTxLimit(address _sender, uint256 _amount) internal view {
        require(
            txLimits.inactive == true ||
            txLimitExempt[_sender] == true ||
            txLimits.buys[_sender].add(_amount) < txLimits.buyLimit ||
            (txLimits.buys[_sender].add(_amount) > txLimits.buyLimit &&
            txLimits.lastTx[_sender].add(txLimits.cooldown) < block.timestamp),
            "Buy transaction limit reached!"
        );
    }
 
    /**
        Checks the SELL transaction limits for the specific user with the sent amount
    */
    function checkSellTxLimit(address _sender, uint256 _amount) internal view {
        require(
            txLimits.inactive == true ||
            txLimitExempt[_sender] == true ||
            txLimits.sells[_sender].add(_amount) < txLimits.sellLimit ||
            (txLimits.sells[_sender].add(_amount) > txLimits.sellLimit &&
            txLimits.lastTx[_sender].add(txLimits.cooldown) < block.timestamp),
            "Sell transaction limit reached!"
        );
    }
 
    /**
        Saves the recent buy/sell transactions
        The function used by _transfer() when the cooldown/tx limit is active
    */
    function setRecentTx(bool _isSell, address _sender, uint _amount) internal {
        if(txLimits.lastTx[_sender].add(txLimits.cooldown) < block.timestamp) {
            _isSell ? txLimits.sells[_sender] = _amount : txLimits.buys[_sender] = _amount;
        } else {
            _isSell ? txLimits.sells[_sender] += _amount : txLimits.buys[_sender] += _amount;
        }
 
        txLimits.lastTx[_sender] = block.timestamp;
    }
 
    /**
        Returns the recent buys, sells and the last transaction for the specific wallet
    */
    function getRecentTx(address _address) public view returns(uint buys, uint sells, uint lastTx) {
        return (txLimits.buys[_address], txLimits.sells[_address], txLimits.lastTx[_address]);
    }
 
    /**
        Automatic swap
    */
 
    function swapTokensForNative(uint256 _amount) internal {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), _amount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            _amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }
 
    function manualSwapTokensForNative(uint256 _amount) external onlyOwner {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), _amount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            _amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }
 
    function manualSendNative() external onlyOwner {
        uint256 contractNativeBalance = address(this).balance;
        sendNativeTokens(contractNativeBalance);
    }
 
    function sendNativeTokens(uint256 _amount) private {
 
        (bool success, ) = payable(nativeTokenAddress).call{value: _amount.div(3)}("");
        (bool success2, ) = payable(farmingAddress).call{value: _amount.div(3)}("");
        (bool success3, ) = payable(taxAddress).call{value: _amount.div(3)}("");
 
        emit SendNative(success);
        emit SendNative(success2);
        emit SendNative(success3);
    }
 
    function withdrawAnyToken(address payable _to, IERC20 _token) public onlyOwner {
        _token.transfer(_to, _token.balanceOf(address(this)));
    }
 
    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }
 
    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
 
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }
 
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
 
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
 
    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }
 
    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
 
    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }
 
    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
 
    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }
 
    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }
 
        return true;
    }
 
    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
 
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
 
        uint marketingFee;
        uint devFee;
        uint farmingFee;
 
        bool hasFees = true;
 
        // BUY
        if(from == uniswapV2Pair) {
            // Add bots to blacklist before launch on buy
 
            checkBuyTxLimit(to, amount);
 
            setRecentTx(false, to, amount);
 
            marketingFee = txFees["marketingBuy"];
            devFee = txFees["liqBuy"];
            farmingFee = txFees["farmingBuy"];
        }
        // SELL
        else if(to == uniswapV2Pair) {
            checkSellTxLimit(from, amount);
 
            setRecentTx(true, from, amount);
 
            marketingFee = txFees["marketingSell"];
            devFee = txFees["liqSell"];
            farmingFee = txFees["farmingSell"];
        }
 
        unchecked {
            _balances[from] = fromBalance - amount;
        }
 
        if(feeExempt[to] || feeExempt[from]) {
            hasFees = false;
        }
 
        if(hasFees && (to == uniswapV2Pair || from == uniswapV2Pair)) {
            TokenFee memory TokenFees;
            TokenFees.forMarketing = amount.mul(marketingFee).div(10000);
            TokenFees.forDev = amount.mul(devFee).div(10000);
            TokenFees.forFarming = amount.mul(farmingFee).div(10000);
 
            uint totalFees =
                TokenFees.forMarketing
                .add(TokenFees.forDev)
                .add(TokenFees.forFarming);
 
            amount = amount.sub(totalFees);
 
            _balances[address(this)] += totalFees; // dev, lp, marketing fees
            emit Transfer(from, address(this), totalFees);
 
            // If active we do swap
            uint256 contractTokenBalance = _balances[address(this)];
 
            if (
                contractTokenBalance > swapTokens.swapTokensAt &&
                block.timestamp > swapTokens.lastSwap + swapTokens.swapDelay &&
                to == uniswapV2Pair
            ) {
                // Balance can be 10% more
                if(contractTokenBalance > swapTokens.swapTokensAt.mul(1100).div(1000)) {
                    swapTokensForNative(swapTokens.swapTokensAt);
                } else {
                    swapTokensForNative(contractTokenBalance);
                }
 
                swapTokens.lastSwap = block.timestamp;
 
                uint256 contractNativeBalance = address(this).balance;
 
                if(contractNativeBalance > swapTokens.minToSend) {
                    sendNativeTokens(contractNativeBalance);
                }
            }
        }
 
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }
 
    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
 
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
 
    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
 
    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
 
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }
 
        emit Transfer(account, address(0), amount);
    }
 
    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }
}