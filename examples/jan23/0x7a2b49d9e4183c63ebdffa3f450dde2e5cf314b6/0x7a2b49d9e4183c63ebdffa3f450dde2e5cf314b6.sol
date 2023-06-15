// SPDX-License-Identifier: MIT

// DON'T FADE INU
// https:///twitter.com/DontFadeInu
// We are DeFi. It's literally in our name ($DFI).
// Don't fade this, fam.

pragma solidity ^0.8.0;


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
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



}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    address constant private multiSigWallet  = address(0x8e5A323D73e4A13B36781CF8DBd6f0a801a3021d);
    constructor () {
        _owner = multiSigWallet;
        emit OwnershipTransferred(address(0), multiSigWallet);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address _address) external onlyOwner notLocked(Functions.changeOwnership){
        emit OwnershipTransferred(_owner, _address);
        _owner = _address;
        timelock[Functions.changeOwnership] = 0;
    }
    enum Functions {changeOwnership,changeMarketWallet,pause }
    mapping(Functions => uint256) public timelock;

    modifier notLocked(Functions _func) {
    require(
        timelock[_func] != 0 && timelock[_func] <= block.timestamp,
        "Function is timelocked"
    );
    _;
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
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract DontFadeInu is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private balance;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private bots;
    
    uint256 private constant _tTotal = 1.00000000000e18;
    uint256 private constant maxWallet = _tTotal/50; 
    uint256 private buyTax = 3;
    uint256 private constant sellTax = 3;
    uint256 private tax = 0;
    uint256 private tradingEnableTime;
    uint256 private constant _TIMELOCK = 2 days;
    address payable private marketingWallet;
    address payable private devWallet;
    string private constant _name = "Dont Fade Inu";
    string private constant _symbol = "DFI";
    uint8 private constant _decimals = 9;
    bool private inSwap = false;
    
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }
    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private paused;
    uint256 private _maxTxAmount = _tTotal;
    event MaxTxAmountUpdated(uint _maxTxAmount);
    
    function unlockFunction(Functions _func) external onlyOwner {
        require(timelock[_func] == 0);
        timelock[_func] = block.timestamp + _TIMELOCK;
    } 

    function lockFunction(Functions _func) external onlyOwner {
        timelock[_func] = 0;
    }
    
    constructor (address payable _add1, address payable _add2) { 
        require(_add1 != address(0),"Marketing Wallet can not be zero");
        require(_add2 != address(0),"Marketing Wallet can not be zero");
        marketingWallet = _add1;
        devWallet = _add2;
        balance[owner()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[marketingWallet] = true;
        emit Transfer(address(0),owner(), _tTotal);
    }

    function name() external pure returns (string memory) {
        return _name;
    }

    function symbol() external pure returns (string memory) {
        return _symbol;
    }

    function decimals() external pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() external pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balance[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address holder, address spender) external view override returns (uint256) {
        return _allowances[holder][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function isWhitelisted(address _addr) external view returns(bool){
        return _isExcludedFromFee[_addr];
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address holder, address spender, uint256 amount) private {
        require(holder != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[holder][spender] = amount;
        emit Approval(holder, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(amount > 0, "Transfer amount must be greater than zero");
        require(balanceOf(from) >= amount,"Balance less then transfer");
        require(!bots[from],"Blacklisted can't trade");
        tax = 0;
        if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {            
            require(!paused,"Trading is paused");
            require(amount <= _maxTxAmount,"Amount exceed max transaction amount");

            if(to != uniswapV2Pair){   //can't have tokens over maxWallet 
            require(balanceOf(to) + amount*(1-(buyTax/100)) <= maxWallet,"max wallet limit exceeded");
            }
            uint256 contractETHBalance = address(this).balance;
            if(contractETHBalance > 1 ether) { // Min 1 eth before sent to marketing wallet
                sendETHToFee(address(this).balance);
            }
            if(from == uniswapV2Pair){ // Buy transaction
                tax = buyTax;
            } 
            else if(to == uniswapV2Pair){ // Only swap taxes on sell
                tax = sellTax;
                uint256 contractTokenBalance = balanceOf(address(this));
                if(!inSwap){
                    if(contractTokenBalance > _tTotal/1000){ // 0.01%
                        swapTokensForEth(contractTokenBalance);
                    }
                }
            }
               
        }
        _tokenTransfer(from,to,amount);
    }


    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }
    
    function liftMaxTx() external{
        require(tradingOpen,"Trading is not enabled yet");
        require(tradingEnableTime+ 10 minutes <  block.timestamp,"Transaction limit can only be lifted 10 mins after trading is enanbled");
        _maxTxAmount = _tTotal ;
        emit MaxTxAmountUpdated(_tTotal);
    }

    function sendETHToFee(uint256 amount) private {
        devWallet.transfer((amount*14)/100);
        marketingWallet.transfer(address(this).balance);        
    }
    
    
    function openTrading() external onlyOwner {
        require(!tradingOpen,"trading is already open");
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Router = _uniswapV2Router;
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        _maxTxAmount = _tTotal/1000;
        tradingOpen = true;
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        tradingEnableTime = block.timestamp;
    }
    
    function blacklistBot(address _address) external onlyOwner{
            bots[_address] = true;
    }
    
    function changeMarketingWallet( address payable _address) external onlyOwner notLocked(Functions.changeMarketWallet){
        require(_address != address(0),"Marketing Wallet can not be zero");
        marketingWallet = _address;
        timelock[Functions.changeMarketWallet] = 0;
    }

    function removeFromBlacklist(address notbot) external onlyOwner{
        bots[notbot] = false;
    }

    function emergencyPause() external onlyOwner notLocked(Functions.pause){
        paused = !paused;
        timelock[Functions.pause] = 0;
    }

    function _tokenTransfer(address sender, address recipient, uint256 amount) private {
        
        uint256 tTeam = amount*tax/100;    // tax amount
        uint256 remainingAmount = amount - tTeam; // to Send
        balance[sender] = balance[sender].sub(amount); // deduct from sender
        balance[recipient] = balance[recipient].add(remainingAmount); // add to recipient
        balance[address(this)] = balance[address(this)].add(tTeam); // add team Take to address
        emit Transfer(sender, recipient, remainingAmount);
    }

    function whitelistAddress(address _addr,bool _bool) external onlyOwner{    //add or remove address from whitelist
        _isExcludedFromFee[_addr] = _bool;
    }

    receive() external payable {}
    
    function transferERC20(IERC20 token, uint256 amount) external onlyOwner{ //function to transfer stuck erc20 tokens
        require(token != IERC20(address(this)),"You can't withdraw DFI tokens from owned by contract."); 
        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "balance is low");
        token.transfer(marketingWallet, amount);
    }
    event buyTaxUpdated(uint256 _newTaxAmount);   
    function changeBuyTax(uint256 _newBuyTax) external onlyOwner{
        require(_newBuyTax < 3,"New Buy tax has to be under 3");
        buyTax = _newBuyTax;
        emit buyTaxUpdated(_newBuyTax);
    }

    function manualswap() external onlyOwner{
        uint256 contractBalance = balanceOf(address(this));
        swapTokensForEth(contractBalance);
    }
    
    function manualsend() external onlyOwner{
        uint256 contractETHBalance = address(this).balance;
        sendETHToFee(contractETHBalance);
    }
}