// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
 
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
 
    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
abstract contract Ownable is Context {
    address private _owner;
 
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
 
    function owner() public view virtual returns (address) {
        return _owner;
    }
 
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
 
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
 
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
 
interface IERC20 {
    function totalSupply() external view returns (uint256);
 
    function balanceOf(address account) external view returns (uint256);
 
    function transfer(address recipient, uint256 amount) external returns (bool);
 
    function allowance(address owner, address spender) external view returns (uint256);
 
    function approve(address spender, uint256 amount) external returns (bool);
 
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
 
    event Transfer(address indexed from, address indexed to, uint256 value);
 
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
 
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
 
    mapping (address => uint256) private _balances;
 
    mapping (address => mapping (address => uint256)) private _allowances;
 
    uint256 private _totalSupply;
 
    string private _name;
    string private _symbol;
    uint8 private _decimals;
 
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }
 
    function name() public view virtual returns (string memory) {
        return _name;
    }
 
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }
 
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }
 
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
 
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
 
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
 
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
 
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
 
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
  
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
 
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
 
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
 
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
 
        _beforeTokenTransfer(sender, recipient, amount);
 
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
 
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
 
        _beforeTokenTransfer(address(0), account, amount);
 
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
 
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
 
        _beforeTokenTransfer(account, address(0), amount);
 
        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
 
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
 
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
 
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }
 
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
 
 
interface IDividendPayingToken {
  function dividendOf(address _owner) external view returns(uint256);
 
  function withdrawDividend() external;
 
  event DividendsDistributed(
    address indexed from,
    uint256 weiAmount
  );
 
  event DividendWithdrawn(
    address indexed to,
    uint256 weiAmount
  );
}
 
interface IDividendPayingTokenOptional {
  function withdrawableDividendOf(address _owner) external view returns(uint256);
 
  function withdrawnDividendOf(address _owner) external view returns(uint256);
 
  function accumulativeDividendOf(address _owner) external view returns(uint256);
}
 
contract DividendPayingToken is ERC20, IDividendPayingToken, IDividendPayingTokenOptional, Ownable {
  using SafeMath for uint256;
  using SafeMathUint for uint256;
  using SafeMathInt for int256;
 
  uint256 constant internal magnitude = 2**128;
 
  uint256 internal magnifiedDividendPerShare;
  uint256 internal lastAmount;
 
  address public dividendToken;
 
 
  mapping(address => int256) internal magnifiedDividendCorrections;
  mapping(address => uint256) internal withdrawnDividends;
  mapping(address => bool) _isAuth;
 
  uint256 public totalDividendsDistributed;
 
  modifier onlyAuth() {
    require(_isAuth[msg.sender], "Auth: caller is not the authorized");
    _;
  }
 
  constructor(string memory _name, string memory _symbol, address _token) ERC20(_name, _symbol) {
    dividendToken = _token;
    _isAuth[msg.sender] = true;
  }
 
  function setAuth(address account) external onlyOwner{
      _isAuth[account] = true;
  }
 
 
  function distributeDividends(uint256 amount) public onlyOwner{
    require(totalSupply() > 0);
 
    if (amount > 0) {
      magnifiedDividendPerShare = magnifiedDividendPerShare.add(
        (amount).mul(magnitude) / totalSupply()
      );
      emit DividendsDistributed(msg.sender, amount);
 
      totalDividendsDistributed = totalDividendsDistributed.add(amount);
    }
  }
 
  function withdrawDividend() public virtual override {
    _withdrawDividendOfUser(payable(msg.sender));
  }
 
  function setDividendTokenAddress(address newToken) external virtual onlyOwner{
      dividendToken = newToken;
  }
 
  function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
    uint256 _withdrawableDividend = withdrawableDividendOf(user);
    if (_withdrawableDividend > 0) {
      withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
      emit DividendWithdrawn(user, _withdrawableDividend);
      bool success = IERC20(dividendToken).transfer(user, _withdrawableDividend);
 
      if(!success) {
        withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
        return 0;
      }
 
      return _withdrawableDividend;
    }
 
    return 0;
  }
 
 
  function dividendOf(address _owner) public view override returns(uint256) {
    return withdrawableDividendOf(_owner);
  }
 
  function withdrawableDividendOf(address _owner) public view override returns(uint256) {
    return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
  }
 
  function withdrawnDividendOf(address _owner) public view override returns(uint256) {
    return withdrawnDividends[_owner];
  }
 
 
  function accumulativeDividendOf(address _owner) public view override returns(uint256) {
    return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
      .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
  }
 
  function _transfer(address from, address to, uint256 value) internal virtual override {
    require(false);
 
    int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
    magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
    magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
  }
 
  function _mint(address account, uint256 value) internal override {
    super._mint(account, value);
 
    magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
      .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
  }
 
  function _burn(address account, uint256 value) internal override {
    super._burn(account, value);
 
    magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
      .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
  }
 
  function _setBalance(address account, uint256 newBalance) internal {
    uint256 currentBalance = balanceOf(account);
 
    if(newBalance > currentBalance) {
      uint256 mintAmount = newBalance.sub(currentBalance);
      _mint(account, mintAmount);
    } else if(newBalance < currentBalance) {
      uint256 burnAmount = currentBalance.sub(newBalance);
      _burn(account, burnAmount);
    }
  }
}
 
////////////////////////////////
///////// Interfaces ///////////
////////////////////////////////
 
interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
 
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
 
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
 
    function createPair(address tokenA, address tokenB) external returns (address pair);
 
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}
 
interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
 
    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
 
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
 
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
 
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
 
    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
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
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
 
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
 
    function initialize(address, address) external;
}
 
interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
 
    function addLiquidity( address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline ) external returns (uint amountA, uint amountB, uint liquidity); 
function addLiquidityETH( address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline ) external payable returns (uint amountToken, uint amountETH, uint liquidity); 
function removeLiquidity( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline ) external returns (uint amountA, uint amountB); 
function removeLiquidityETH( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline ) external returns (uint amountToken, uint amountETH); 
function removeLiquidityWithPermit( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s ) external returns (uint amountA, uint amountB); 
function removeLiquidityETHWithPermit( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s ) external returns (uint amountToken, uint amountETH); 
function swapExactTokensForTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external returns (uint[] memory amounts); 
function swapTokensForExactTokens( uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline ) external returns (uint[] memory amounts); 
function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts); 
function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts); 
function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts); 
function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts); 
 
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
 
interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline ) external returns (uint amountETH); 
function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s ) external returns (uint amountETH); 
 
 
function swapExactTokensForTokensSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external; 
function swapExactETHForTokensSupportingFeeOnTransferTokens( uint amountOutMin, address[] calldata path, address to, uint deadline ) external payable; 
function swapExactTokensForETHSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external; 
 
}
 
////////////////////////////////
////////// Libraries ///////////
////////////////////////////////
 
library IterableMapping {
    // Iterable mapping from address to uint;
    struct Map {
        address[] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
        mapping(address => bool) inserted;
    }
 
    function get(Map storage map, address key) public view returns (uint) {
        return map.values[key];
    }
 
    function getIndexOfKey(Map storage map, address key) public view returns (int) {
        if(!map.inserted[key]) {
            return -1;
        }
        return int(map.indexOf[key]);
    }
 
    function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
        return map.keys[index];
    }
 
 
 
    function size(Map storage map) public view returns (uint) {
        return map.keys.length;
    }
 
    function set(Map storage map, address key, uint val) public {
        if (map.inserted[key]) {
            map.values[key] = val;
        } else {
            map.inserted[key] = true;
            map.values[key] = val;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }
 
    function remove(Map storage map, address key) public {
        if (!map.inserted[key]) {
            return;
        }
 
        delete map.inserted[key];
        delete map.values[key];
 
        uint index = map.indexOf[key];
        uint lastIndex = map.keys.length - 1;
        address lastKey = map.keys[lastIndex];
 
        map.indexOf[lastKey] = index;
        delete map.indexOf[key];
 
        map.keys[index] = lastKey;
        map.keys.pop();
    }
}
 
library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }
 
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }
 
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }
 
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }
 
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }
 
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }
 
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
 
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }
 
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }
 
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }
 
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }
 
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}
 
library SafeMathInt {
  function mul(int256 a, int256 b) internal pure returns (int256) {
    // Prevent overflow when multiplying INT256_MIN with -1
    // https://github.com/RequestNetwork/requestNetwork/issues/43
    require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
 
    int256 c = a * b;
    require((b == 0) || (c / b == a));
    return c;
  }
 
  function div(int256 a, int256 b) internal pure returns (int256) {
    // Prevent overflow when dividing INT256_MIN by -1
    // https://github.com/RequestNetwork/requestNetwork/issues/43
    require(!(a == - 2**255 && b == -1) && (b > 0));
 
    return a / b;
  }
 
  function sub(int256 a, int256 b) internal pure returns (int256) {
    require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
 
    return a - b;
  }
 
  function add(int256 a, int256 b) internal pure returns (int256) {
    int256 c = a + b;
    require((b >= 0 && c >= a) || (b < 0 && c < a));
    return c;
  }
 
  function toUint256Safe(int256 a) internal pure returns (uint256) {
    require(a >= 0);
    return uint256(a);
  }
}
 
library SafeMathUint {
  function toInt256Safe(uint256 a) internal pure returns (int256) {
    int256 b = int256(a);
    require(b >= 0);
    return b;
  }
}
 
////////////////////////////////
/////////// Tokens /////////////
////////////////////////////////
 
 
contract USDCDividendTracker is DividendPayingToken  {
    using SafeMath for uint256;
    using SafeMathInt for int256;
    using IterableMapping for IterableMapping.Map;
 
    IterableMapping.Map private tokenHoldersMap;
    uint256 public lastProcessedIndex;
 
    mapping (address => bool) public excludedFromDividends;
 
    mapping (address => uint256) public lastClaimTimes;
 
    uint256 public claimWait;
    uint256 public minimumTokenBalanceForDividends;
 
    event ExcludeFromDividends(address indexed account);
    event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
 
    event Claim(address indexed account, uint256 amount, bool indexed automatic);
 
    constructor(address _dividentToken) DividendPayingToken("Poolgenics_Usdc_Dividend_Tracker", "Poolgenics_Usdc_Dividend_Tracker",_dividentToken) {
    	claimWait = 3600;
        minimumTokenBalanceForDividends = 1000 * (10**18); //must hold 3,000,000,000+ tokens
    }
 
    function _transfer(address, address, uint256) pure internal override {
        require(false, "Poolgenics_Usdc_Dividend_Tracker: No transfers allowed");
    }
 
    function withdrawDividend() pure public override {
        require(false, "Poolgenics_Usdc_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main Poolgenics contract.");
    }
 
    function setDividendTokenAddress(address newToken) external override onlyOwner {
      dividendToken = newToken;
    }
 
    function updateMinimumTokenBalanceForDividends(uint256 _newMinimumBalance) external onlyOwner {
        require(_newMinimumBalance != minimumTokenBalanceForDividends, "New mimimum balance for dividend cannot be same as current minimum balance");
        minimumTokenBalanceForDividends = _newMinimumBalance * (10**18);
    }
 
    function excludeFromDividends(address account) external onlyOwner {
    	require(!excludedFromDividends[account]);
    	excludedFromDividends[account] = true;
 
    	_setBalance(account, 0);
    	tokenHoldersMap.remove(account);
 
    	emit ExcludeFromDividends(account);
    }
 
    function updateClaimWait(uint256 newClaimWait) external onlyOwner {
        require(newClaimWait >= 3600 && newClaimWait <= 86400, "Poolgenics_Usdc_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
        require(newClaimWait != claimWait, "Poolgenics_Usdc_Dividend_Tracker: Cannot update claimWait to same value");
        emit ClaimWaitUpdated(newClaimWait, claimWait);
        claimWait = newClaimWait;
    }
 
    function getLastProcessedIndex() external view returns(uint256) {
    	return lastProcessedIndex;
    }
 
    function getNumberOfTokenHolders() external view returns(uint256) {
        return tokenHoldersMap.keys.length;
    }
 
 
    function getAccount(address _account)
        public view returns (
            address account,
            int256 index,
            int256 iterationsUntilProcessed,
            uint256 withdrawableDividends,
            uint256 totalDividends,
            uint256 lastClaimTime,
            uint256 nextClaimTime,
            uint256 secondsUntilAutoClaimAvailable) {
        account = _account;
 
        index = tokenHoldersMap.getIndexOfKey(account);
 
        iterationsUntilProcessed = -1;
 
        if(index >= 0) {
            if(uint256(index) > lastProcessedIndex) {
                iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
            }
            else {
                uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
                                                        tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
                                                        0;
 
 
                iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
            }
        }
 
 
        withdrawableDividends = withdrawableDividendOf(account);
        totalDividends = accumulativeDividendOf(account);
 
        lastClaimTime = lastClaimTimes[account];
 
        nextClaimTime = lastClaimTime > 0 ?
                                    lastClaimTime.add(claimWait) :
                                    0;
 
        secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
                                                    nextClaimTime.sub(block.timestamp) :
                                                    0;
    }
 
    function getAccountAtIndex(uint256 index)
        public view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
    	if(index >= tokenHoldersMap.size()) {
            return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
        }
 
        address account = tokenHoldersMap.getKeyAtIndex(index);
 
        return getAccount(account);
    }
 
    function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
    	if(lastClaimTime > block.timestamp)  {
    		return false;
    	}
 
    	return block.timestamp.sub(lastClaimTime) >= claimWait;
    }
 
    function setBalance(address payable account, uint256 newBalance) external onlyOwner {
    	if(excludedFromDividends[account]) {
    		return;
    	}
 
    	if(newBalance >= minimumTokenBalanceForDividends) {
            _setBalance(account, newBalance);
    		tokenHoldersMap.set(account, newBalance);
    	}
    	else {
            _setBalance(account, 0);
    		tokenHoldersMap.remove(account);
    	}
 
    	processAccount(account, true);
    }
 
    function process(uint256 gas) public returns (uint256, uint256, uint256) {
    	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
 
    	if(numberOfTokenHolders == 0) {
    		return (0, 0, lastProcessedIndex);
    	}
 
    	uint256 _lastProcessedIndex = lastProcessedIndex;
 
    	uint256 gasUsed = 0;
 
    	uint256 gasLeft = gasleft();
 
    	uint256 iterations = 0;
    	uint256 claims = 0;
 
    	while(gasUsed < gas && iterations < numberOfTokenHolders) {
    		_lastProcessedIndex++;
 
    		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
    			_lastProcessedIndex = 0;
    		}
 
    		address account = tokenHoldersMap.keys[_lastProcessedIndex];
 
    		if(canAutoClaim(lastClaimTimes[account])) {
    			if(processAccount(payable(account), true)) {
    				claims++;
    			}
    		}
 
    		iterations++;
 
    		uint256 newGasLeft = gasleft();
 
    		if(gasLeft > newGasLeft) {
    			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
    		}
 
    		gasLeft = newGasLeft;
    	}
 
    	lastProcessedIndex = _lastProcessedIndex;
 
    	return (iterations, claims, lastProcessedIndex);
    }
 
    function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
        uint256 amount = _withdrawDividendOfUser(account);
 
    	if(amount > 0) {
    		lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount, automatic);
    		return true;
    	}
 
    	return false;
    }
}

contract Poolgenics is ERC20, Ownable {
    using SafeMath for uint256;
 
    IUniswapV2Router02 public uniswapV2Router;
    address public immutable uniswapV2Pair;
 
    address public usdcDividendToken;
    address public deadAddress = 0x000000000000000000000000000000000000dEaD;
 
    bool private swapping;
    bool public tradingIsEnabled = true;
    bool public marketingEnabled = true;
    bool public swapAndLiquifyEnabled = true;
    bool public usdcDividendEnabled = true;

 
    USDCDividendTracker public usdcDividendTracker;
    
    address public marketingWallet;
 
    uint256 public maxBuyTranscationAmount = 10000000 * (10**18);
    uint256 public maxSellTransactionAmount = 2000000 * (10**18);
    uint256 public maxWalletBalance = 1000000000 * (10**18);
    uint256 public swapTokensAtAmount = 100000 * 10**18;
 
    uint256 public liquidityFee;
    uint256 public previousLiquidityFee;

    uint256 public usdcDividendRewardsFee;
    uint256 public previousUsdcDividendRewardsFee;

    uint256 public marketingFee;
    uint256 public previousMarketingFee;

    uint256 public totalFees = usdcDividendRewardsFee.add(marketingFee).add(liquidityFee);
    
    uint256 public _usdcDividendRewardsFeeBuy = 2;
    uint256 public _marketingFeeBuy = 8;
    uint256 public _LpFeeBuy = 0;

    uint256 public _usdcDividendRewardsFeeSell=2;
    uint256 public _LpFeeSell=0;
    uint256 public _marketingFeeSell=8;  
 
    uint256 public usdcDividedRewardsInContract;
    uint256 public tokensForLpInContract;

    uint256 public sellFeeIncreaseFactor = 130;
 
    uint256 public gasForProcessing = 600000;
 
    mapping (address => bool) private isExcludedFromFees;
 
    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
    // could be subject to a maximum transfer amount
    mapping (address => bool) public automatedMarketMakerPairs;
 
    event UpdateusdcDividendTracker(address indexed newAddress, address indexed oldAddress);
    
    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
 
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event MarketingEnabledUpdated(bool enabled);
    event UsdcDividendEnabledUpdated(bool enabled);
    
 
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
 
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
 
    event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
 
    event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
 
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
 
    event SendDividends(
    	uint256 amount
    );
 
    event ProcessedusdcDividendTracker(
    	uint256 iterations,
    	uint256 claims,
        uint256 lastProcessedIndex,
    	bool indexed automatic,
    	uint256 gas,
    	address indexed processor
    );
 
   

    constructor() ERC20("Poolgenics", "PLGN") {
        	
    	marketingWallet = 0xBfCa7e7387f60Eb8cdF48A0692D5A5076B421F2D; 
    	usdcDividendToken = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; 

        usdcDividendTracker = new USDCDividendTracker(usdcDividendToken);

    	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
         // Create a uniswap pair for this new token
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
 
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;
 
        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
 
        excludeFromDividend(address(usdcDividendTracker));
        excludeFromDividend(address(this));
        excludeFromDividend(address(_uniswapV2Router));
        excludeFromDividend(deadAddress);
 
        // exclude from paying fees or having max transaction amount
        excludeFromFees(marketingWallet, true);
        excludeFromFees(address(this), true);
        excludeFromFees(deadAddress, true);
        excludeFromFees(owner(), true);
 
        setAuthOnDividends(owner());
 
        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        _mint(owner(), 1000000000 * (10**18));
    }
 
    receive() external payable {
 
  	}
       mapping (address => bool) private _isBlackListedBot;
    address[] private _blackListedBots;
 
  	function prepareForPartherOrExchangeListing(address _partnerOrExchangeAddress) external onlyOwner {
  	    usdcDividendTracker.excludeFromDividends(_partnerOrExchangeAddress);
        excludeFromFees(_partnerOrExchangeAddress, true);
  	}
 
  	function setWalletBalance(uint256 _maxWalletBalance) external onlyOwner{
  	    maxWalletBalance = _maxWalletBalance;
  	}
 
  	function setMaxBuyTransaction(uint256 _maxTxn) external onlyOwner {
  	    maxBuyTranscationAmount = _maxTxn * (10**18);
  	}

    
  	function setMaxSellTransaction(uint256 _maxTxn) external onlyOwner {
  	    maxSellTransactionAmount = _maxTxn * (10**18);
  	}
 
 
  	function updateUsdcDividendToken(address _newContract) external onlyOwner {
  	    usdcDividendToken = _newContract;
  	    usdcDividendTracker.setDividendTokenAddress(_newContract);
  	}
 
  	function updateMarketingWallet(address _newWallet) external onlyOwner {
  	    require(_newWallet != marketingWallet, "Poolgenics: The marketing wallet is already this address");
        excludeFromFees(_newWallet, true);
        emit MarketingWalletUpdated(marketingWallet, _newWallet);
  	    marketingWallet = _newWallet;
  	}
 
  	function setSwapTokensAtAmount(uint256 _swapAmount) external onlyOwner {
  	    swapTokensAtAmount = _swapAmount * (10**18);
  	}
 
  	function setSellTransactionMultiplier(uint256 _multiplier) external onlyOwner {
  	    sellFeeIncreaseFactor = _multiplier;
  	}
 
 
    function setTradingIsEnabled(bool _enabled) external onlyOwner {
        tradingIsEnabled = _enabled;
    }
 
    function setAuthOnDividends(address account) public onlyOwner {
        usdcDividendTracker.setAuth(account);
    }
 
    function setUsdcDividendEnabled(bool _enabled) external onlyOwner {
        require(usdcDividendEnabled != _enabled, "Can't set flag to same status");
        if (_enabled == false) {
            previousUsdcDividendRewardsFee = usdcDividendRewardsFee;
            usdcDividendRewardsFee = 0;
            usdcDividendEnabled = _enabled;
        }
 
        emit UsdcDividendEnabledUpdated(_enabled);
    }
 
 
    function setMarketingEnabled(bool _enabled) external onlyOwner {
        require(marketingEnabled != _enabled, "Can't set flag to same status");
        if (_enabled == false) {
            previousMarketingFee = marketingFee;
            marketingFee = 0;
            marketingEnabled = _enabled;
        } 
 
        emit MarketingEnabledUpdated(_enabled);
    }
 
    function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
        require(swapAndLiquifyEnabled != _enabled, "Can't set flag to same status");
        if (_enabled == false) {
            previousLiquidityFee = liquidityFee;
            liquidityFee = 0;
            swapAndLiquifyEnabled = _enabled;
        } 
 
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }
 
 
    function updateusdcDividendTracker(address newAddress) external onlyOwner {
        require(newAddress != address(usdcDividendTracker), "Poolgenics: The dividend tracker already has that address");
 
        USDCDividendTracker newusdcDividendTracker = USDCDividendTracker(payable(newAddress));
 
        require(newusdcDividendTracker.owner() == address(this), "Poolgenics: The new dividend tracker must be owned by the Poolgenics token contract");
 
        newusdcDividendTracker.excludeFromDividends(address(newusdcDividendTracker));
        newusdcDividendTracker.excludeFromDividends(address(this));
        newusdcDividendTracker.excludeFromDividends(address(uniswapV2Router));
        newusdcDividendTracker.excludeFromDividends(address(deadAddress));
 
        emit UpdateusdcDividendTracker(newAddress, address(usdcDividendTracker));
 
        usdcDividendTracker = newusdcDividendTracker;
    }
 
    function updateUniswapV2Router(address newAddress) external onlyOwner {
        require(newAddress != address(uniswapV2Router), "Poolgenics: The router already has that address");
        emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
    }
 
    function excludeFromFees(address account, bool excluded) public onlyOwner {
        require(isExcludedFromFees[account] != excluded, "Poolgenics: Account is already exluded from fees");
        isExcludedFromFees[account] = excluded;
 
        emit ExcludeFromFees(account, excluded);
    }
 
    function excludeFromDividend(address account) public onlyOwner {
        usdcDividendTracker.excludeFromDividends(address(account));
       
    }
 
    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
        require(pair != uniswapV2Pair, "Poolgenics: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
 
        _setAutomatedMarketMakerPair(pair, value);
    }
 
    function _setAutomatedMarketMakerPair(address pair, bool value) private onlyOwner {
        require(automatedMarketMakerPairs[pair] != value, "Poolgenics: Automated market maker pair is already set to that value");
        automatedMarketMakerPairs[pair] = value;
 
        if(value) {
            usdcDividendTracker.excludeFromDividends(pair);
          
        }
 
        emit SetAutomatedMarketMakerPair(pair, value);
    }
 
    function updateGasForProcessing(uint256 newValue) external onlyOwner {
        require(newValue != gasForProcessing, "Poolgenics: Cannot update gasForProcessing to same value");
        gasForProcessing = newValue;
        emit GasForProcessingUpdated(newValue, gasForProcessing);
    }
 
    function updateMinimumBalanceForDividends(uint256 newMinimumBalance) external onlyOwner {
        usdcDividendTracker.updateMinimumTokenBalanceForDividends(newMinimumBalance);
    }
 
    function updateClaimWait(uint256 claimWait) external onlyOwner {
        usdcDividendTracker.updateClaimWait(claimWait);

    }
 
    function getUsdcClaimWait() external view returns(uint256) {
        return usdcDividendTracker.claimWait();
    }
 
  
 
    function getTotalUsdcDividendsDistributed() external view returns (uint256) {
        return usdcDividendTracker.totalDividendsDistributed();
    }
 
    
 
    function getIsExcludedFromFees(address account) public view returns(bool) {
        return isExcludedFromFees[account];
    }
 
    function withdrawableUsdcDividendOf(address account) external view returns(uint256) {
    	return usdcDividendTracker.withdrawableDividendOf(account);
  	}
 
  	
 
	function usdcDividendTokenBalanceOf(address account) external view returns (uint256) {
		return usdcDividendTracker.balanceOf(account);
	}
 
	
 
    function getAccountUsdcDividendsInfo(address account)
        external view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
        return usdcDividendTracker.getAccount(account);
    }
 
 
	function getAccountUsdcDividendsInfoAtIndex(uint256 index)
        external view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
    	return usdcDividendTracker.getAccountAtIndex(index);
    }
 
    
	function processDividendTracker(uint256 gas) external onlyOwner {
		(uint256 usdcIterations, uint256 usdcClaims, uint256 usdcLastProcessedIndex) = usdcDividendTracker.process(gas);
		emit ProcessedusdcDividendTracker(usdcIterations, usdcClaims, usdcLastProcessedIndex, false, gas, tx.origin);
 
		
    }
 
    function claim() external {
		usdcDividendTracker.processAccount(payable(msg.sender), false);
		
    }
    function getLastUsdcDividendProcessedIndex() external view returns(uint256) {
    	return usdcDividendTracker.getLastProcessedIndex();
    }
 
    
 
    function getNumberOfUsdcDividendTokenHolders() external view returns(uint256) {
        return usdcDividendTracker.getNumberOfTokenHolders();
    }
 
 
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(!_isBlackListedBot[to], "You have no power here!");
      require(!_isBlackListedBot[tx.origin], "You have no power here!");
   
           

        require(tradingIsEnabled || (isExcludedFromFees[from] || isExcludedFromFees[to]), "Poolgenics: Trading has not started yet");
  
        bool excludedAccount = isExcludedFromFees[from] || isExcludedFromFees[to];
 
        if(!automatedMarketMakerPairs[to] && tradingIsEnabled && !excludedAccount){
            require(balanceOf(to).add(amount) <= maxWalletBalance, 'Wallet balance is exceeding maxWalletBalance');
        }
 
        if (
            tradingIsEnabled &&
            automatedMarketMakerPairs[from] &&
            !excludedAccount
        ) {
            require(amount <= maxBuyTranscationAmount, "Transfer amount exceeds the maxTxAmount.");

            usdcDividendRewardsFee = _usdcDividendRewardsFeeBuy;
            marketingFee = _marketingFeeBuy;
            liquidityFee = _LpFeeBuy;
 	    
        } else if (
        	tradingIsEnabled &&
            automatedMarketMakerPairs[to] &&
            !excludedAccount
        ) {
            require(amount <= maxSellTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");

            usdcDividendRewardsFee = _usdcDividendRewardsFeeSell;
            marketingFee = _marketingFeeSell;
            liquidityFee = _LpFeeSell;

        }
 
 
        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;
 
        if (!swapping && canSwap && from != uniswapV2Pair) {
            swapping = true;
 
            if(swapAndLiquifyEnabled) {
                uint256 liqTokens = tokensForLpInContract;
                swapAndLiquify(liqTokens);
                tokensForLpInContract = 0;
            }
 
            if (usdcDividendEnabled) {
                uint256 usdcTokens = usdcDividedRewardsInContract;
                swapAndSendUsdcDividends(usdcTokens);
                usdcDividedRewardsInContract = 0;
            }
 
 
                swapping = false;
        }
 
        bool takeFee = tradingIsEnabled && !swapping && !excludedAccount;
 
        if(takeFee) {
        	uint256 fees;

            uint256 tmpMarketingRewardPercent;
            uint256 tmpUsdcDividedRewardsInContract;
            uint256 tmpLpRewardInContract;

            tmpMarketingRewardPercent = amount.mul(marketingFee).div(100);
            tmpUsdcDividedRewardsInContract = amount.mul(usdcDividendRewardsFee).div(100);
            tmpLpRewardInContract = amount.mul(liquidityFee).div(100);

            fees = tmpMarketingRewardPercent.add(tmpUsdcDividedRewardsInContract)
                            .add(tmpLpRewardInContract);

            usdcDividedRewardsInContract = usdcDividedRewardsInContract.add(tmpUsdcDividedRewardsInContract);

            tokensForLpInContract = tokensForLpInContract.add(tmpLpRewardInContract);

            // if sell, multiply by 1.2
            if(automatedMarketMakerPairs[to]) {
                fees = fees.div(100).mul(sellFeeIncreaseFactor);
            }

        	amount = amount.sub(fees);
            super._transfer(from, address(this), fees);
            super._transfer(address(this),marketingWallet,tmpMarketingRewardPercent);
        }
 
        super._transfer(from, to, amount);
 
        try usdcDividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
        
        try usdcDividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
        
        if(!swapping) {
	    	uint256 gas = gasForProcessing;
 
	    	try usdcDividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
	    		emit ProcessedusdcDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
	    	}
	    	catch {
 
	    	}
        }
    }
 
 
    function swapAndLiquify(uint256 contractTokenBalance) private {
        // split the contract balance into halves
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);
 
        uint256 initialBalance = address(this).balance;
 
        swapTokensForETH(half);
 
        uint256 newBalance = address(this).balance.sub(initialBalance);
 
        addLiquidity(otherHalf, newBalance);
 
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }
 
    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
 
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            marketingWallet,
            block.timestamp
        );
    }
 
 
    function swapTokensForETH(uint256 tokenAmount) private {
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
 
    function swapTokensForDividendToken(uint256 _tokenAmount, address _recipient, address _dividendAddress) private {
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = _dividendAddress;
 
        _approve(address(this), address(uniswapV2Router), _tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            _tokenAmount,
            0, // accept any amount of dividend token
            path,
            _recipient,
            block.timestamp
        );
    }
 
    function swapAndSendUsdcDividends(uint256 tokens) private {
        swapTokensForDividendToken(tokens, address(this), usdcDividendToken);
        uint256 usdcDividends = IERC20(usdcDividendToken).balanceOf(address(this));
        transferDividends(usdcDividendToken, address(usdcDividendTracker), usdcDividendTracker, usdcDividends);
    }
 
 
    function transferToWallet(address payable recipient, uint256 amount) private {
        recipient.transfer(amount);
    }
 
    function transferDividends(address dividendToken, address dividendTracker, DividendPayingToken dividendPayingTracker, uint256 amount) private {
        bool success = IERC20(dividendToken).transfer(dividendTracker, amount);
 
        if (success) {
            dividendPayingTracker.distributeDividends(amount);
            emit SendDividends(amount);
        }
    }

        function ChangeBuyFee(uint256 marketingBuy,uint256 LpFeeBuy,uint256 usdcDividendRewardsFeeBuy) external onlyOwner() {
        _marketingFeeBuy = marketingBuy;
        _LpFeeBuy=LpFeeBuy;
        _usdcDividendRewardsFeeBuy=usdcDividendRewardsFeeBuy;


    }
function ChangeSellFee(uint256 marketingFeeSell,uint256 LpFeeSell,uint256 usdcDividendRewardsFeeSell) external onlyOwner() {

   _marketingFeeSell=marketingFeeSell;  
   _LpFeeSell=LpFeeSell;
  _usdcDividendRewardsFeeSell=usdcDividendRewardsFeeSell;
    }
      function isBot(address account) public view returns (bool) {
        return  _isBlackListedBot[account];
    }
  function addBotToBlackList(address account) external onlyOwner() {
        require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
        require(!_isBlackListedBot[account], "Account is already blacklisted");
        _isBlackListedBot[account] = true;
        _blackListedBots.push(account);
    }
    
    function removeBotFromBlackList(address account) external onlyOwner() {
        require(_isBlackListedBot[account], "Account is not blacklisted");
        for (uint256 i = 0; i < _blackListedBots.length; i++) {
            if (_blackListedBots[i] == account) {
                _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
                _isBlackListedBot[account] = false;
                _blackListedBots.pop();
                break;
            }
        }
    }  
}