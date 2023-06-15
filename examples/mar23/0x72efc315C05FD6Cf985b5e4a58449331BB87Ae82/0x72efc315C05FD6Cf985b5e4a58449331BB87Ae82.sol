/*
https://t.me/mewnbound
https://mewnbound.org
*/

// SPDX-License-Identifier: Unlicensed


pragma solidity ^0.7.0;

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
        return c;
    }
}

interface ERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        authorizations[_owner] = true;
        emit OwnershipTransferred(address(0), msgSender);
    }
    mapping (address => bool) internal authorizations;

    function owner() public view returns (address) {
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

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
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

interface InterfaceLP {
    function sync() external;
}



contract mewnbound is Ownable, ERC20 {
    using SafeMath for uint256;

    address WETH;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    

    string constant _name = "mewnbound";
    string constant _symbol = unicode"🌙BOUND";
    uint8 constant _decimals = 9; 
  

    uint256 _totalSupply = 1 * 10**3 * 10**_decimals;

    uint256 public _maxTxAmount = _totalSupply.mul(5).div(100);
    uint256 public _maxWalletToken = _totalSupply.mul(5).div(100);

    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;

    
    mapping (address => bool) isFeeExempt;
    mapping (address => bool) isTxLimitExempt;

    uint256 private liquidityFee    = 0;
    uint256 private marketingFee    = 1;
    uint256 private utilityFee      = 0;
    uint256 private teamFee         = 0; 
    uint256 private burnFee         = 0;
    uint256 public totalFeeInPercentage         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
    uint256 private feeDenominatorBase  = 100;

    uint256 selltaxscalar = 100;
    uint256 buytaxscalar = 100;
    uint256 transfertaxscalar = 1000; 

    address private autoLiquidityReceiver;
    address private marketingFeeReceiver;
    address private utilityFeeReceiver;
    address private teamFeeReceiver;
    address private burnFeeReceiver;


    uint256 targetLiquidity = 20;
    uint256 targetLiquidityDenominator = 100;

    IDEXRouter public router;
    InterfaceLP private pairContract;
    address public pair;
    
    bool public TradingOpen = false;    

    bool public swapEnabled = true;
    uint256 public swapThreshold = _totalSupply * 300 / 10000; 
    bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }
    
    constructor () {
        router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        WETH = router.WETH();
        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
        pairContract = InterfaceLP(pair);
       
        
        _allowances[address(this)][address(router)] = type(uint256).max;

        isFeeExempt[msg.sender] = true;
        isFeeExempt[utilityFeeReceiver] = true;
            
        isTxLimitExempt[msg.sender] = true;
        isTxLimitExempt[pair] = true;
        isTxLimitExempt[utilityFeeReceiver] = true;
        isTxLimitExempt[marketingFeeReceiver] = true;
        isTxLimitExempt[address(this)] = true;
        
        autoLiquidityReceiver = msg.sender;
        marketingFeeReceiver = 0x77F94e86231138Fc1e3f0b1E3843fb9A365dCf5c;
        utilityFeeReceiver = msg.sender;
        teamFeeReceiver = msg.sender;
        burnFeeReceiver = DEAD; 

        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);

    }

    receive() external payable { }

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) {return owner();}
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveAll(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][msg.sender] != type(uint256).max){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

   
  
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if(inSwap){ return _basicTransfer(sender, recipient, amount); }

        if(!authorizations[sender] && !authorizations[recipient]){
            require(TradingOpen,"Trading not open yet");
           }
        
       
        if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
            uint256 heldTokens = balanceOf(recipient);
            require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}

       
        checkTxLimit(sender, amount); 

        if(shouldSwapBack()){ swapBack(); }
        
        uint256 amountReceived = (_owner==sender || _owner==recipient) ? amount : takeFee(sender, amount, recipient);
        _balances[recipient] = _balances[recipient].add(amountReceived);
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        emit Transfer(sender, recipient, amountReceived);
        return true;
    }
    
    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function checkTxLimit(address sender, uint256 amount) internal view {
        require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
    }

    function shouldTakeFee(address sender) internal view returns (bool) {
        return !isFeeExempt[sender];
    }

    function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
        
        uint256 taxscalar = transfertaxscalar;

        if(recipient == pair) {
            taxscalar = selltaxscalar;
        } else if(sender == pair) {
            taxscalar = buytaxscalar;
        }

        uint256 feeTokensAmount = !isFeeExempt[sender] ? amount.mul(totalFeeInPercentage).mul(taxscalar).div(feeDenominatorBase * 100):0;
        uint256 burnTokensFromFeeTaxAmount = feeTokensAmount.mul(burnFee).div(totalFeeInPercentage);
        uint256 contractTaxTokensAmountToTransfer =  amount.mul(totalFeeInPercentage).mul(taxscalar).div(feeDenominatorBase * 100);

        _balances[address(this)] = _balances[address(this)].add(contractTaxTokensAmountToTransfer);
        _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokensFromFeeTaxAmount);
        emit Transfer(sender, address(this), contractTaxTokensAmountToTransfer);
        
        
        if(burnTokensFromFeeTaxAmount > 0){
            _totalSupply = _totalSupply.sub(burnTokensFromFeeTaxAmount);
            emit Transfer(sender, ZERO, burnTokensFromFeeTaxAmount);  
        
        }

        return amount.sub(feeTokensAmount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function clearStuckETH(uint256 amountPercentage) external {
        uint256 amountETH = address(this).balance;
        payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
    }

     function swapback() external onlyOwner {
           swapBack();
    
    }


    function enableTrading() public onlyOwner {
        TradingOpen = true;
        buytaxscalar = 100;
        selltaxscalar = 100;
        transfertaxscalar = 1000;
    }
        
    function swapBack() internal swapping {
        uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
        uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFeeInPercentage).div(2);
        uint256 amountToSwap = _balances[address(this)].sub(amountToLiquify);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH;

        uint256 balanceBefore = address(this).balance;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountETH = address(this).balance.sub(balanceBefore);

        uint256 totalETHFee = totalFeeInPercentage.sub(dynamicLiquidityFee.div(2));
        
        uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
        uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
        uint256 amountETHdeployteam = amountETH.mul(teamFee).div(totalETHFee);
        uint256 amountETHutilitydevelopmentfund = amountETH.mul(utilityFee).div(totalETHFee);

        (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
        (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutilitydevelopmentfund}("");
        (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHdeployteam}("");
        
        tmpSuccess = false;

        if(amountToLiquify > 0){
            router.addLiquidityETH{value: amountETHLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                autoLiquidityReceiver,
                block.timestamp
            );
            emit AutoLiquify(amountETHLiquidity, amountToLiquify);
        }
    }

    function exemptAll(address holder, bool exempt) external onlyOwner {
        isFeeExempt[holder] = exempt;
        isTxLimitExempt[holder] = exempt;
    }

    function setTXExempt(address holder, bool exempt) external onlyOwner {
        isTxLimitExempt[holder] = exempt;
    }

  

    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }

    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
        return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
    }

    function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
        return getLiquidityBacking(accuracy) > target;
    }

  


event AutoLiquify(uint256 amountETH, uint256 amountTokens);

}