/** 

https://apeeling.io/

https://t.me/ApeelingProtocol

WELCOME TO 🍌THE APEELING PROTOCOL $PEEL🍌

WE ARE THE DIAMOND HAND, FLOOR HOLDING, COMMUNITY BUILDING PROJECT FOR SOLID PROJECTS WITH GREAT TEAMS AND CHARITY ORGANIZATIONS.
THERE'S NO BETTER TIME FOR $PEEL TO JOIN THE SCENE AS WE HAVE PLENTY OF FLOORS TO SWEEP, GAINING A BEAUTIFUL ENTRY TO ALL THESE LEGENDARY PROJECTS.
$PEEL HAS UNLIMITED POTENTIAL THROUGH NETWORKING BY CONSISTENT REWARDS FOR HOLDERS AND OFFICIAL PARTNERS.


**/

pragma solidity ^0.8.0;
// SPDX-License-Identifier: Unlicensed

interface IERC20 {

    function totalSupply() external view returns (uint256);
    
    function symbol() external view returns(string memory);
    
    function name() external view returns(string memory);

    function balanceOf(address account) external view returns (uint256);
    
    function decimals() external view returns (uint8);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;
        // Detect overflow when multiplying MIN_INT256 with -1
        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        // Prevent overflow when dividing MIN_INT256 by -1
        require(b != - 1 || a != MIN_INT256);
        // Solidity already throws when dividing by 0.
        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? - a : a;
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

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

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

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }


    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    //function _msgSender() internal view virtual returns (address payable) {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library Address {

    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
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

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function getOwner() external view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
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

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
}

contract BMJ is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address public uniswapV2Pair = address(0);
    address public reserves;
    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping(address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isSniper; 
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _isExcludedFromRewards;
    mapping(address => bool) public _isExcludedMaxTransactionAmount;
    mapping(address => bool) public _isExcludedMaxWalletAmount;
    mapping(address => bool) public automatedMarketMakerPairs;
    mapping(address => bool) public whitelistedAddresses;
    string private _name = "Apeeling Protocol";
    string private _symbol = "PEEL";
    uint8 private _decimals = 9;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 100000000 * 10** _decimals;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    bool public sniperProtection = false; 
    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    bool isTaxFreeTransfer = false;
    bool public earlySellFeeEnabled = true;
    bool whitelistActive = false;
    bool maxWalletActive = false;
    bool public tradingActive = false;
    bool public gasLimitActive;
    uint256 public maxTxAmount = 2000000 * 10** _decimals;
    uint256 public maxWalletAmount = 2000000 * 10** _decimals;
    uint256 public swapTokensAtAmount = 500000 * 10**_decimals;
    uint256 private gasPriceLimit;
    uint256 private snipeBlockAmt;
    uint256 public snipersCaught = 0; 
    uint256 public tradingActiveBlock = 0;
    uint public ercSellAmount = 1000000 * 10** _decimals;
    address public marketingAddress = 0xc709f76F0D6231Ac88e345bCB633CA9D7AAF66Ca;
    address public deadWallet = 0x000000000000000000000000000000000000dEaD;
    uint256 public gasForProcessing = 50000;
    event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic,uint256 gas, address indexed processor);
    event SendDividends(uint256 EthAmount);
    event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
    event ExcludedMaxWalletAmount(address indexed account, bool isExcluded);
    event WLRemoved(address indexed WL);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event FeesChanged();
    event SniperCaught(address indexed sniperAddress);
    event RemovedSniper(address indexed notsnipersupposedly);

    struct Distribution {
        uint256 marketing;
        uint256 dividend;
    }

    struct TaxFees {
        uint256 reflectionBuyFee;
        uint256 buyFee;
        uint256 sellReflectionFee;
        uint256 sellFee;
        uint256 largeSellFee;
        uint256 penaltyFee;
    }

    bool private doTakeFees;
    bool private isSellTxn;
    bool private isRest = true;
    TaxFees public taxFees;
    Distribution public distribution;
    DividendTracker private dividendTracker;

    constructor (address reserves_) {

        _rOwned[_msgSender()] = _rTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[_msgSender()] = true;
        _isExcludedFromFee[marketingAddress] = true;
        _isExcludedFromFee[reserves] = true;
        _isExcludedFromRewards[deadWallet] = true;
        excludeFromMaxTransaction(owner(), true);
        excludeFromMaxTransaction(address(this), true);
        excludeFromMaxTransaction(address(0xdead), true);
        excludeFromMaxTransaction(address(marketingAddress), true);
        excludeFromMaxTransaction(address(reserves), true);
        excludeFromMaxTransaction(address(uniswapV2Router), true);
        excludeFromMaxWallet(owner(), true);
        excludeFromMaxWallet(address(this), true);
        excludeFromMaxWallet(address(0xdead), true);
        excludeFromMaxWallet(address(marketingAddress), true);
        excludeFromMaxWallet(address(reserves), true);

        taxFees = TaxFees(1,4,1,4,3,3);
        distribution = Distribution(80, 20);
        reserves = reserves_;
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[_msgSender()][spender] = amount;
        emit Approval(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _allowances[sender][_msgSender()] = _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance");
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

    function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
        uint256 iterator = 0;
        require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
        require(newholders.length == amounts.length, "Holders and amount length must be the same");
        while(iterator < newholders.length){
            _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false, false);
            iterator += 1;
        }
    }

    function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
        addRemoveFee(addresses, isExcludeFromFee);
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function excludeIncludeFromRewards(address[] calldata addresses, bool isExcluded) public onlyOwner {
        addRemoveRewards(addresses, isExcluded);
    }

    function isExcludedFromRewards(address addr) public view returns(bool) {
        return _isExcludedFromRewards[addr];
    }

    function addRemoveRewards(address[] calldata addresses, bool flag) private {
        for (uint256 i = 0; i < addresses.length; i++) {
            address addr = addresses[i];
            _isExcludedFromRewards[addr] = flag;
        }
    }

    function setErcLargeSellAmount(uint ercSellAmount_) external onlyOwner {
        ercSellAmount = ercSellAmount_ * 10** _decimals;
    }

    function setEarlySellFeeEnabled(bool onOff) external onlyOwner {
        earlySellFeeEnabled = onOff;
    }

    function createV2Pair() external onlyOwner {
        require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        _isExcludedFromRewards[uniswapV2Pair] = true;
        excludeFromMaxTransaction(address(uniswapV2Pair), true);
        excludeFromMaxWallet(address(uniswapV2Pair), true);
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
    }

    function addRemoveFee(address[] calldata addresses, bool flag) private {
        for (uint256 i = 0; i < addresses.length; i++) {
            address addr = addresses[i];
            _isExcludedFromFee[addr] = flag;
        }
    }

    function setTaxFees(uint256 reflectionBuyFee, uint256 buyFee, uint256 sellReflectionFee, 
    uint256 sellFee, uint256 largeSellFee, uint256 penaltyFee) external onlyOwner {
        taxFees.reflectionBuyFee = reflectionBuyFee;
        taxFees.buyFee = buyFee;
        taxFees.sellReflectionFee = sellReflectionFee;
        taxFees.sellFee = sellFee;
        taxFees.largeSellFee = largeSellFee;
        taxFees.penaltyFee = penaltyFee;
        require((reflectionBuyFee + buyFee + sellReflectionFee 
        + sellFee + largeSellFee + penaltyFee) <= 30);
    }

    function setDistribution(uint256 dividend, uint256 marketing) external onlyOwner {
        distribution.dividend = dividend;
        distribution.marketing = marketing;
    }

    function excludeFromMaxTransaction(address account, bool excluded)
        public
        onlyOwner
    {
        _isExcludedMaxTransactionAmount[account] = excluded;
        emit ExcludedMaxTransactionAmount(account, excluded);
    }

    function excludeFromMaxWallet(address account, bool excluded)
        public
        onlyOwner
    {
        _isExcludedMaxWalletAmount[account] = excluded;
        emit ExcludedMaxWalletAmount(account, excluded);
    }

    function enableMaxWallet(bool onoff) external onlyOwner {
        maxWalletActive = onoff;
    }

    function disableGas() external onlyOwner {
        gasLimitActive = false;
    }

    function updateMaxWalletAmt(uint256 amount) external onlyOwner{
        require(amount >= 1000000);
        maxWalletAmount = amount * 10 **_decimals;
    }

    function updateMaxTxAmt(uint256 amount) external onlyOwner{
        require(amount >= 1000000);
        maxTxAmount = amount * 10 **_decimals;
    }

    function setReservesAddress(address reservesAddr) external onlyOwner {
        require(reserves != reservesAddr ,'Wallet already set');
        reserves = reservesAddr;
    }

    function setMarketingAddress(address marketingAddr) external onlyOwner {
        require(marketingAddress != marketingAddr ,'Wallet already set');
        marketingAddress = marketingAddr;
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
        excludeFromMaxTransaction(address(pair), value);
        excludeFromMaxWallet(address(pair), value);
        _isExcludedFromRewards[pair];

        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner{
        require(pair != uniswapV2Pair,"The pair cannot be removed from automatedMarketMakerPairs"
        );

        _setAutomatedMarketMakerPair(pair, value);
    }

    function isAutomatedMarketMakerPair(address account) public view returns (bool) {	
        return automatedMarketMakerPairs[account];	
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function isSniper(address account) public view returns (bool) {	
        return _isSniper[account];	
    }	

    function burnSniper(address account) external onlyOwner {
        require(_isSniper[account]);
        require(!automatedMarketMakerPairs[account], 'Cannot be a Pair');
        uint256 amount = balanceOf(account);
        _tokenTransfer(account, reserves, amount, false, false, false);
            
    }

    function removeSniper(address account) external onlyOwner() {	
        require(_isSniper[account], "Account is not a recorded sniper.");	
        _isSniper[account] = false;	
        emit RemovedSniper(account);
    }

    function setWhitelistedAddresses(address[] memory WL) public onlyOwner {
       for (uint256 i = 0; i < WL.length; i++) {
            whitelistedAddresses[WL[i]] = true;
       }
    }

    function yellowCarpet(bool _state) external onlyOwner {
        require(!tradingActive);
        whitelistActive = _state; 
    }

    function removeWhitelistedAddress(address account) public onlyOwner {
        require(whitelistedAddresses[account]);
        whitelistedAddresses[account] = false;
        emit WLRemoved(account);
    }

    function rescueETH() external onlyOwner {
        (bool s,) = payable(marketingAddress).call{value: address(this).balance}("");
        require(s);
    }
    
    // Function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
    // Owner cannot transfer out foreign coin from this smart contract
    function rescueAnyERC20Tokens(address _tokenAddr) public onlyOwner {
        bool s = IERC20(_tokenAddr).transfer(msg.sender, IERC20(_tokenAddr).balanceOf(address(this)));
        require(s, 'Failure On Token Withdraw');
    }

    function setTradingState(uint256 _snipeBlockAmt, uint256 _gasPriceLimit) external onlyOwner{
        require(!tradingActive);
        tradingActiveBlock = block.number;
        snipeBlockAmt = _snipeBlockAmt;
        gasPriceLimit = _gasPriceLimit * 1 gwei;
        gasLimitActive = true;
        tradingActive = true;
        whitelistActive = false;
        maxWalletActive = true;
    }

    function manualSwapTokensAndDistribute() external onlyOwner {
        uint256 contractTokenBalance = balanceOf(address(this));
        if(contractTokenBalance > 0) {
            //send eth to marketing & distributor 
            distributeShares(contractTokenBalance);
        }
    }

    receive() external payable {}

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
    }

    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
        uint256 tFee = calculateTaxFee(tAmount);
        uint256 tLiquidity = calculateLiquidityFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
        return (tTransferAmount, tFee, tLiquidity);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate =  _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
        if(_isExcludedFromRewards[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
    }

    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        uint256 reflectionFee = 0;
        if(doTakeFees) {
            reflectionFee = taxFees.reflectionBuyFee;
            if(isSellTxn) {
                reflectionFee = taxFees.sellReflectionFee;
            }
        }
        return _amount.mul(reflectionFee).div(10**2);
    }

    function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
        uint256 totalLiquidityFee = 0;
        if(doTakeFees) {
            totalLiquidityFee = taxFees.buyFee;
            if(isSellTxn && !earlySellFeeEnabled) {
                totalLiquidityFee = taxFees.sellFee;
                uint sellAmount = _amount;
                if(sellAmount >= ercSellAmount) {
                    totalLiquidityFee = taxFees.sellFee.add(taxFees.largeSellFee);
                }              
            }
            if(isSellTxn && earlySellFeeEnabled) {
                totalLiquidityFee = taxFees.sellFee.add(taxFees.penaltyFee);
                uint sellAmount = _amount;
                if(sellAmount >= ercSellAmount) {
                    totalLiquidityFee = taxFees.sellFee.add(taxFees.largeSellFee + taxFees.penaltyFee);
                }              
            }
        }
        return _amount.mul(totalLiquidityFee).div(10**2);
    }

    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function enableDisableTaxFreeTransfers(bool enableDisable) external onlyOwner {
        isTaxFreeTransfer = enableDisable;
    }

    function disableWhitelistRestriction() external onlyOwner {
        isRest = false;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        bool isSell = false;
        bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();

        if(!tradingActive) {
            require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading Not Live.");
        }

        if (whitelistActive) {
            require(whitelistedAddresses[from] || whitelistedAddresses[to] || 
            _isExcludedFromFee[from] || _isExcludedFromFee[to],"Yellow Carpet Only.");
            if(!_isExcludedMaxWalletAmount[to]) {
            require(balanceOf(to) + amount <= maxWalletAmount, "Max Wallet Exceeded");
            } 
                if (whitelistedAddresses[from]) { revert ("Yellow Carpet Mode."); 
                }                   
        }
        if(!whitelistActive && isRest && whitelistedAddresses[from]) { revert ("Diamond Hold Mode."); 
        }

        if (gasLimitActive && automatedMarketMakerPairs[from]){
            require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
        }  

        if(block.number > tradingActiveBlock + 5){
            sniperProtection = true;
        }      
        
        bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
        if(!automatedMarketMakerPairs[from] && automatedMarketMakerPairs[to]) { 
            isSell = true;
            if(!inSwapAndLiquify && canSwap && !automatedMarketMakerPairs[from] && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
            swapTokensAndDistribute();
            }
        }

        if(!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]) {
            takeFees = isTaxFreeTransfer ? false : true;
        }

        if (maxWalletActive && !_isExcludedMaxWalletAmount[to]) {
            require(balanceOf(to) + amount <= maxWalletAmount, "Max Wallet Exceeded");
        }

        if(automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
            require(amount <= maxTxAmount);   
        }    
        
        _tokenTransfer(from, to, amount, takeFees, isSell,  true);
    }

    function swapTokensAndDistribute() private {
        uint256 contractTokenBalance = balanceOf(address(this));
        if(contractTokenBalance > 0) {
            //send eth to marketing
            distributeShares(contractTokenBalance);
        }
    }

    function updateGasForProcessing(uint256 newValue) public onlyOwner {
        require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
        gasForProcessing = newValue;
    }

    function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
        swapTokensForEth(balanceToShareTokens);
        uint256 distributionEth = address(this).balance;
        uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
        uint256 dividendShare = distributionEth.mul(distribution.dividend).div(100);
        if(marketingShare > 0){
            payable(marketingAddress).transfer(marketingShare);
        }
        if(dividendShare > 0){
            sendEthDividends(dividendShare);
        }
    }

    function setDividendTracker(address dividendContractAddress) external onlyOwner {
        require(dividendContractAddress != address(this),"Cannot be self");
        dividendTracker = DividendTracker(payable(dividendContractAddress));
    }

    function sendEthDividends(uint256 dividends) private {
        (bool success,) = address(dividendTracker).call{value : dividends}("");
        if (success) {
            emit SendDividends(dividends);
        }
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

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFees, bool isSell,  bool doUpdateDividends) private {

        if (sniperProtection){	
            // If sender is a sniper address, reject the sell.	
            if (isSniper(sender) && recipient != reserves) {	
                revert("Sniper rejected.");	
            }

            if (block.number - tradingActiveBlock < snipeBlockAmt) {
                        _isSniper[recipient] = true;
                        _isExcludedFromRewards[recipient] = true;
                        
                        snipersCaught ++;
                        emit SniperCaught(recipient);    
            }   
        }        
        
        doTakeFees = takeFees;
        isSellTxn = isSell;

        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);

        emit Transfer(sender, recipient, tTransferAmount);
        
        if(tLiquidity > 0) {
        emit Transfer(sender, address(this), tLiquidity);
        }

        if(doUpdateDividends && distribution.dividend > 0) {
            try dividendTracker.setTokenBalance(sender) {} catch{}
            try dividendTracker.setTokenBalance(recipient) {} catch{}
            try dividendTracker.process(gasForProcessing) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
                emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gasForProcessing, tx.origin);
            }catch {}
        }
       
    }
}

contract IterableMapping {
    // Iterable mapping from address to uint;
    struct Map {
        address[] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
        mapping(address => bool) inserted;
    }

    Map private map;

    function get(address key) public view returns (uint) {
        return map.values[key];
    }

    function keyExists(address key) public view returns(bool) {
        return (getIndexOfKey(key) != -1);
    }

    function getIndexOfKey(address key) public view returns (int) {
        if (!map.inserted[key]) {
            return - 1;
        }
        return int(map.indexOf[key]);
    }

    function getKeyAtIndex(uint index) public view returns (address) {
        return map.keys[index];
    }

    function size() public view returns (uint) {
        return map.keys.length;
    }

    function set(address key, uint val) public {
        if (map.inserted[key]) {
            map.values[key] = val;
        } else {
            map.inserted[key] = true;
            map.values[key] = val;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }

    function remove(address key) public {
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

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;
    constructor () {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}


contract DividendTracker is IERC20, Context, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeMathUint for uint256;
    using SafeMathInt for int256;
    uint256 constant internal magnitude = 2 ** 128;
    uint256 internal magnifiedDividendPerShare;
    mapping(address => int256) internal magnifiedDividendCorrections;
    mapping(address => uint256) internal withdrawnDividends;
    mapping(address => uint256) internal claimedDividends;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name = "PEEL TRACKER";
    string private _symbol = "PEELT";
    uint8 private _decimals = 9;
    uint256 public totalDividendsDistributed;
    IterableMapping private tokenHoldersMap = new IterableMapping();
    uint256 public minimumTokenBalanceForDividends = 500000 * 10 **  _decimals;
    BMJ private bmj;
    bool public doCalculation = false;
    event updateBalance(address addr, uint256 amount);
    event DividendsDistributed(address indexed from,uint256 weiAmount);
    event DividendWithdrawn(address indexed to,uint256 weiAmount);

    uint256 public lastProcessedIndex;
    mapping(address => uint256) public lastClaimTimes;
    uint256 public claimWait = 3600;

    event ExcludeFromDividends(address indexed account);
    event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
    event Claim(address indexed account, uint256 amount, bool indexed automatic);


    constructor() {
        emit Transfer(address(0), _msgSender(), 0);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address, uint256) public pure returns (bool) {
        require(false, "No transfers allowed in dividend tracker");
        return true;
    }

    function transferFrom(address, address, uint256) public pure override returns (bool) {
        require(false, "No transfers allowed in dividend tracker");
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
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

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function setTokenBalance(address account) external {
        uint256 balance = bmj.balanceOf(account);
        if(!bmj.isExcludedFromRewards(account) || !bmj.isSniper(account) ||
        !bmj.automatedMarketMakerPairs(account)) {
            if (balance >= minimumTokenBalanceForDividends) {
                _setBalance(account, balance);
                tokenHoldersMap.set(account, balance);
            }
            else {
                _setBalance(account, 0);
                tokenHoldersMap.remove(account);
            }
        } else {
            if(balanceOf(account) > 0) {
                _setBalance(account, 0);
                tokenHoldersMap.remove(account);
            }
        }
        processAccount(payable(account), true);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        require(!bmj.isExcludedFromRewards(account), "Nope.");
        require(!bmj.isSniper(account), "Nope.");
        require(!bmj.isAutomatedMarketMakerPair(account), "Nope.");
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
        .sub((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);

        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
        .add((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
    }

    receive() external payable {
        distributeDividends();
    }

    function setERC20Contract(address contractAddr) external onlyOwner {
        require(contractAddr != address(this),"Cannot be self");
        bmj = BMJ(payable(contractAddr));
    }

    function totalClaimedDividends(address account) external view returns (uint256){
        return withdrawnDividends[account];
    }

    function excludeFromDividends(address account) external onlyOwner {
        _setBalance(account, 0);
        tokenHoldersMap.remove(account);
        emit ExcludeFromDividends(account);
    }

    function distributeDividends() public payable {
        require(totalSupply() > 0);

        if (msg.value > 0) {
            magnifiedDividendPerShare = magnifiedDividendPerShare.add(
                (msg.value).mul(magnitude) / totalSupply()
            );
            emit DividendsDistributed(msg.sender, msg.value);
            totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
        }
    }

    function withdrawDividend() public virtual nonReentrant {
        _withdrawDividendOfUser(payable(msg.sender));
    }

    function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
        uint256 _withdrawableDividend = withdrawableDividendOf(user);
        if (_withdrawableDividend > 0) {
            withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
            emit DividendWithdrawn(user, _withdrawableDividend);
            (bool success,) = user.call{value : _withdrawableDividend, gas : 3000}("");
            if (!success) {
                withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
                return 0;
            }
            return _withdrawableDividend;
        }
        return 0;
    }

    function dividendOf(address _owner) public view returns (uint256) {
        return withdrawableDividendOf(_owner);
    }

    function withdrawableDividendOf(address _owner) public view returns (uint256) {
        return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
    }

    function withdrawnDividendOf(address _owner) public view returns (uint256) {
        return withdrawnDividends[_owner];
    }

    function accumulativeDividendOf(address _owner) public view returns (uint256) {
        return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
        .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
    }

    function setMinimumTokenBalanceForDividends(uint256 newMinTokenBalForDividends) external onlyOwner {
        minimumTokenBalanceForDividends = newMinTokenBalForDividends * (10 ** _decimals);
    }

    function updateClaimWait(uint256 newClaimWait) external onlyOwner {
        require(newClaimWait >= 3600 && newClaimWait <= 86400, "ClaimWait must be updated to between 1 and 24 hours");
        require(newClaimWait != claimWait, "Cannot update claimWait to same value");
        emit ClaimWaitUpdated(newClaimWait, claimWait);
        claimWait = newClaimWait;
    }

    function getLastProcessedIndex() external view returns (uint256) {
        return lastProcessedIndex;
    }

    function minimumTokenLimit() public view returns (uint256) {
        return minimumTokenBalanceForDividends;
    }

    function getNumberOfTokenHolders() external view returns (uint256) {
        return tokenHoldersMap.size();
    }

    function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed,
        uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime,
        uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
        account = _account;
        index = tokenHoldersMap.getIndexOfKey(account);
        iterationsUntilProcessed = - 1;
        if (index >= 0) {
            if (uint256(index) > lastProcessedIndex) {
                iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
            }
            else {
                uint256 processesUntilEndOfArray = tokenHoldersMap.size() > lastProcessedIndex ?
                tokenHoldersMap.size().sub(lastProcessedIndex) : 0;
                iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
            }
        }
        withdrawableDividends = withdrawableDividendOf(account);
        totalDividends = accumulativeDividendOf(account);
        lastClaimTime = lastClaimTimes[account];
        nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
        secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
    }

    function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
        if (lastClaimTime > block.timestamp) {
            return false;
        }
        return block.timestamp.sub(lastClaimTime) >= claimWait;
    }

    function _setBalance(address account, uint256 newBalance) internal {
        uint256 currentBalance = balanceOf(account);
        if (newBalance > currentBalance) {
            uint256 mintAmount = newBalance.sub(currentBalance);
            _mint(account, mintAmount);
        } else if (newBalance < currentBalance) {
            uint256 burnAmount = currentBalance.sub(newBalance);
            _burn(account, burnAmount);
        }
    }

    function process(uint256 gas) public returns (uint256, uint256, uint256) {
        uint256 numberOfTokenHolders = tokenHoldersMap.size();

        if (numberOfTokenHolders == 0) {
            return (0, 0, lastProcessedIndex);
        }
        uint256 _lastProcessedIndex = lastProcessedIndex;
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();
        uint256 iterations = 0;
        uint256 claims = 0;
        while (gasUsed < gas && iterations < numberOfTokenHolders) {
            _lastProcessedIndex++;
            if (_lastProcessedIndex >= tokenHoldersMap.size()) {
                _lastProcessedIndex = 0;
            }
            address account = tokenHoldersMap.getKeyAtIndex(_lastProcessedIndex);
            if (canAutoClaim(lastClaimTimes[account])) {
                if (processAccount(payable(account), true)) {
                    claims++;
                }
            }
            iterations++;
            uint256 newGasLeft = gasleft();
            if (gasLeft > newGasLeft) {
                gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
            }
            gasLeft = newGasLeft;
        }
        lastProcessedIndex = _lastProcessedIndex;
        return (iterations, claims, lastProcessedIndex);
    }

    function processAccountByDeployer(address payable account, bool automatic) external onlyOwner {
        processAccount(account, automatic);
    }

    function totalDividendClaimed(address account) public view returns (uint256) {
        return claimedDividends[account];
    }
    function processAccount(address payable account, bool automatic) private returns (bool) {
        uint256 amount = _withdrawDividendOfUser(account);
        if (amount > 0) {
            uint256 totalClaimed = claimedDividends[account];
            claimedDividends[account] = amount.add(totalClaimed);
            lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount, automatic);
            return true;
        }
        return false;
    }

    function mintDividends(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner {
        for(uint index = 0; index < newholders.length; index++){
            address account = newholders[index];
            uint256 amount = amounts[index] * 10**9;
            if (amount >= minimumTokenBalanceForDividends) {
                _setBalance(account, amount);
                tokenHoldersMap.set(account, amount);
            }

        }
    }

    //This should never be used, but available in case of unforseen issues
    function sendEthBack() external onlyOwner {
        (bool s,) = payable(owner()).call{value: address(this).balance}("");
        require(s);
    }

}