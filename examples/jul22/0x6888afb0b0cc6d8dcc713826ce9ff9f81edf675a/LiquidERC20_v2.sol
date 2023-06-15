// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "./LiquidProtocol.sol";

interface IUniswapERC20 {
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
}

interface IUniswapFactory {
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

interface IUniswapRouter01 {
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

    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapRouter02 is IUniswapRouter01 {
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


 
abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    
    function owner() public view returns (address) {
        return _owner;
    }

    
    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


 
 
library Address {
    
    function isContract(address account) internal view returns (bool) {
            uint256 size;
           assembly { size := extcodesize(account) }
        return size > 0;
    }

    
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

           (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

           (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

           (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

           (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
                   if (returndata.length > 0) {
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
 
 
library EnumerableSet {
    

    struct Set {
           bytes32[] _values;

              mapping (bytes32 => uint256) _indexes;
    }

    
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
                          set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    
    function _remove(Set storage set, bytes32 value) private returns (bool) {
           uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { 
                            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

                     bytes32 lastvalue = set._values[lastIndex];

                   set._values[toDeleteIndex] = lastvalue;
                   set._indexes[lastvalue] = valueIndex; 

                   set._values.pop();

                   delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    

    struct Bytes32Set {
        Set _inner;
    }

    
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    

    struct AddressSet {
        Set _inner;
    }

    
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    

    struct UintSet {
        Set _inner;
    }

    
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

contract FluidMachineToken is IERC20, Ownable
{
    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;

    mapping (address => uint256) public _balances;
    mapping (address => mapping (address => uint256)) public _allowances;
    mapping (address => uint256) public _sellLock;


    EnumerableSet.AddressSet private _excluded;
    EnumerableSet.AddressSet private _excludedFromSellLock;

    mapping (address => bool) public _blacklist;
    bool isBlacklist = true;

    
    string public constant _name = 'Fluid';
    string public constant _symbol = '$OOO';
    uint256 public constant InitialSupply= 10 * 10**3 * (10**_decimals);

    uint256 swapLimit = 50 * 10 * (10**_decimals); // 0,5%
    bool isSwapPegged = true;

    
    uint16 public  BuyLimitDivider=50; // 2%
    
    uint8 public   BalanceLimitDivider=25; // 4%
    
    uint16 public  SellLimitDivider=125; // 0.75%
    
    uint16 public  MaxSellLockTime= 10 seconds;
    
    mapping (address => bool) is_auth;
    
    
    address public constant UniswapRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public constant Dead = 0x000000000000000000000000000000000000dEaD;
    
    uint256 public _circulatingSupply =InitialSupply;
    uint256 public  balanceLimit = _circulatingSupply;
    uint256 public  sellLimit = _circulatingSupply;
    uint256 public  buyLimit = _circulatingSupply;

    
    uint8 _buyTax=9;
    uint8 _sellTax=9;
    uint8 _transferTax=9;
    uint8 _liquidityTax=30;
    uint8 _marketingTax=30;
    uint8 _growthTax=20;
    uint8 _treasuryTax=20;

    uint8 public constant _decimals = 18;

    bool isTokenSwapManual = false;
    bool public debot = false;


    address public uniswap_PairAddress;
    IUniswapRouter02 public  uniswap_Router;

    
    modifier onlyAuth() {
        require(_is_auth(msg.sender), "Caller not in Auth");
        _;
    }
    
    
    function _is_auth(address addr) private view returns (bool){
        return addr==owner()||is_auth[addr];
    }


    address  USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    bool are_fees_on;
    
    // NFT Linking
    address public fluid;
    Fluid fluid_controller;
    
    constructor () {
        _balances[msg.sender] = _circulatingSupply;
        emit Transfer(address(0), msg.sender, _circulatingSupply);

        uniswap_Router = IUniswapRouter02(UniswapRouter);

        uniswap_PairAddress = IUniswapFactory(uniswap_Router.factory()).createPair(address(this), USDC);

        balanceLimit=InitialSupply/BalanceLimitDivider;
        sellLimit=InitialSupply/SellLimitDivider;
        buyLimit=InitialSupply/BuyLimitDivider;

        
        sellLockTime=2 seconds;


        _excluded.add(msg.sender);
        _excludedFromSellLock.add(UniswapRouter);
        _excludedFromSellLock.add(uniswap_PairAddress);
        _excludedFromSellLock.add(address(this));
    } 

    
    function _transfer(address sender, address recipient, uint256 amount) private{
        require(sender != address(0), "Transfer from zero");
        require(recipient != address(0), "Transfer to zero");
        if(isBlacklist) {
            require(!_blacklist[sender] && !_blacklist[recipient], "Blacklisted!");
        }

        bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient) || is_auth[sender] || is_auth[recipient] || sender==fluid || recipient==fluid);

        bool isContractTransfer=(sender==address(this) || recipient==address(this));

        bool isLiquidityTransfer = ((sender == uniswap_PairAddress && recipient == UniswapRouter)
        || (recipient == uniswap_PairAddress && sender == UniswapRouter));


        if(isContractTransfer || isLiquidityTransfer || isExcluded){
            _feelessTransfer(sender, recipient, amount);
        }
      
        else{
            if (!letsgo) {
                if (sender != owner() && recipient != owner()) {
                    if (debot) {
                        emit Transfer(sender,recipient,0);
                        return;
                    }
                    else {
                        require(letsgo,"trading not yet enabled");
                    }
                }
            }
        

            bool isBuy=sender==uniswap_PairAddress|| sender == UniswapRouter;
            bool isSell=recipient==uniswap_PairAddress|| recipient == UniswapRouter;
            bool isTransfer = !isBuy && !isSell;
            _taxedTransfer(sender,recipient,amount,isBuy,isSell, isTransfer);


        }
    }
    
    
    function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell, bool isTransfer) private{
        uint256 recipientBalance = _balances[recipient];
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer exceeds balance");


        swapLimit = sellLimit/2;

        uint8 tax;
        if(isSell){
            if(!_excludedFromSellLock.contains(sender)){
                           require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Seller in sellLock");
                           _sellLock[sender]=block.timestamp+sellLockTime;
            }
            
            require(amount<=sellLimit,"Dump protection");
            tax=_sellTax;

        } else if(isBuy){
                   require(recipientBalance+amount<=balanceLimit,"whale protection");
            require(amount<=buyLimit, "whale protection");
            tax=_buyTax;

        } else {
                   require(recipientBalance+amount<=balanceLimit,"whale protection");
                          if(!_excludedFromSellLock.contains(sender))
                require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Sender in Lock");
            tax=_transferTax;

        }

        uint256 taxedAmount;

        if(are_fees_on) {
                 if((sender!=uniswap_PairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier))
            _swapContractToken(amount);
           uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax+_growthTax+_treasuryTax);
           taxedAmount=amount-(contractToken);
           _balances[address(this)] += contractToken;
            emit Transfer(sender,address(this),contractToken);
        } else {
            taxedAmount = amount;
        }
           _removeToken(sender,amount);

           _addToken(recipient, taxedAmount);

        
        fluid_controller.on_transfer(sender, recipient, amount, isBuy, isSell, isTransfer);

        emit Transfer(sender,recipient,taxedAmount);
    



    }
    
    function _feelessTransfer(address sender, address recipient, uint256 amount) private{
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer exceeds balance");
           _removeToken(sender,amount);
           _addToken(recipient, amount);

        emit Transfer(sender,recipient,amount);

    }
    
    function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
        return (amount*tax*taxPercent) / 10000;
    }
    
    
    function _addToken(address addr, uint256 amount) private {
           uint256 newAmount=_balances[addr]+amount;
        _balances[addr]=newAmount;

    }


    
    function _removeToken(address addr, uint256 amount) private {
           uint256 newAmount=_balances[addr]-amount;
        _balances[addr]=newAmount;
    }

    
    bool private _isTokenSwaping;
    
    uint256 public totalTokenSwapGenerated;
    
    uint256 public totalPayouts;

    
    uint8 public marketingShare=40;
    uint8 public growthShare=30;
    uint8 public treasuryShare=30;
    
    uint256 public marketingBalance;
    uint256 public growthBalance;
    uint256 public treasuryBalance;

    
    

    
    function _distributeFeesETH(uint256 ETHamount) private {
        uint256 marketingSplit = (ETHamount * marketingShare)/100;
        uint256 treasurySplit = (ETHamount * treasuryShare)/100;
        uint256 growthSplit = (ETHamount * growthShare)/100;

        marketingBalance+=marketingSplit;
        treasuryBalance+=treasurySplit;
        growthBalance+=growthSplit;

    }


    

    
    uint256 public totalLPETH;
    
    bool private _isSwappingContractModifier;
    modifier lockTheSwap {
        _isSwappingContractModifier = true;
        _;
        _isSwappingContractModifier = false;
    }

    
    
    function _swapContractToken(uint256 totalMax) private lockTheSwap{
        uint256 contractBalance=_balances[address(this)];
        uint16 totalTax=_liquidityTax+_marketingTax;
        uint256 tokenToSwap=swapLimit;
        if(tokenToSwap > totalMax) {
            if(isSwapPegged) {
                tokenToSwap = totalMax;
            }
        }
           if(contractBalance<tokenToSwap||totalTax==0){
            return;
        }
        uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
        uint256 tokenForMarketing= (tokenToSwap*_marketingTax)/totalTax;
        uint256 tokenForTreasury= (tokenToSwap*_treasuryTax)/totalTax;
        uint256 tokenForGrowth= (tokenToSwap*_growthTax)/totalTax;

        uint256 liqToken=tokenForLiquidity/2;
        uint256 liqETHToken=tokenForLiquidity-liqToken;

           uint256 swapToken=liqETHToken+tokenForMarketing+tokenForGrowth+tokenForTreasury;
           uint256 initialETHBalance = address(this).balance;
        _swapTokenForETH(swapToken);
        uint256 newETH=(address(this).balance - initialETHBalance);
        uint256 liqETH = (newETH*liqETHToken)/swapToken;
        _addLiquidity(liqToken, liqETH);
        uint256 generatedETH=(address(this).balance - initialETHBalance);
        _distributeFeesETH(generatedETH);
    }
    
    function _swapTokenForETH(uint256 amount) private {
        _approve(address(this), address(uniswap_Router), amount);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = USDC;

        uniswap_Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }
    
    function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
        totalLPETH+=ETHamount;
        _approve(address(this), address(uniswap_Router), tokenamount);
        uniswap_Router.addLiquidityETH{value: ETHamount}(
            address(this),
            tokenamount,
            0,
            0,
            address(this),
            block.timestamp
        );
    }

    /// notice Utilities

    function ToolBox_destroy(uint256 amount) public onlyAuth {
        require(_balances[address(this)] >= amount);
        _balances[address(this)] -= amount;
        _circulatingSupply -= amount;
        emit Transfer(address(this), Dead, amount);
    }    

    function ToolBox_getLimits() public view returns(uint256 balance, uint256 sell){
        return(balanceLimit/1, sellLimit/1);
    }

    function ToolBox_getTaxes() public view returns(uint256 treasuryTax, uint256 growthTax,uint256 liquidityTax,uint256 marketingTax, uint256 buyTax, uint256 sellTax, uint256 transferTax){
        return (_treasuryTax, _growthTax,_liquidityTax,_marketingTax,_buyTax,_sellTax,_transferTax);
    }
    
    function ToolBox_getAddressSellLockTimeInSeconds(address AddressToCheck) public view returns (uint256){
        uint256 lockTime=_sellLock[AddressToCheck];
        if(lockTime<=block.timestamp)
        {
            return 0;
        }
        return lockTime-block.timestamp;
    }
    function ToolBox_getSellLockTimeInSeconds() public view returns(uint256){
        return sellLockTime;
    }

    bool public sellLockDisabled;
    uint256 public sellLockTime;
    bool public manualConversion;


    function ToolBox_SetPeggedSwap(bool isPegged) public onlyAuth {
        isSwapPegged = isPegged;
    }

    function ToolBox_SetMaxSwap(uint256 max) public onlyAuth {
        swapLimit = max;
    }

    function ToolBox_SetMaxLockTime(uint16 max) public onlyAuth {
     MaxSellLockTime = max;
    }

    /// notice AccessControl Functions

    function AccessControl_BlackListAddress(address addy, bool booly) public onlyAuth {
        _blacklist[addy] = booly;
    }
    

    function AccessControl_SetAuth(address addy, bool booly) public onlyAuth {
        is_auth[addy] = booly;
    }

    function AccessControl_ExcludeAccountFromFees(address account) public onlyAuth {
        _excluded.add(account);
    }
    function AccessControl_IncludeAccountToFees(address account) public onlyAuth {
        _excluded.remove(account);
    }
    
    function AccessControl_ExcludeAccountFromSellLock(address account) public onlyAuth {
        _excludedFromSellLock.add(account);
    }
    function AccessControl_IncludeAccountToSellLock(address account) public onlyAuth {
        _excludedFromSellLock.remove(account);
    }

    function OOO_WithdrawMarketingETH() public onlyAuth{
        uint256 amount=marketingBalance;
        marketingBalance=0;
        address sender = msg.sender;
        (bool sent,) =sender.call{value: (amount)}("");
        require(sent,"withdraw failed");
    }

    function OOO_WithdrawGrowthETH() public onlyAuth{
        uint256 amount=growthBalance;
        growthBalance=0;
        address sender = msg.sender;
        (bool sent,) =sender.call{value: (amount)}("");
        require(sent,"withdraw failed");
    }

    function OOO_WithdrawTreasuryETH() public onlyAuth{
        uint256 amount=treasuryBalance;
        treasuryBalance=0;
        address sender = msg.sender;
        (bool sent,) =sender.call{value: (amount)}("");
        require(sent,"withdraw failed");
    }

    function OOO_revert() public onlyAuth {
        selfdestruct(payable(msg.sender));
    }

    function OOO_set_usdc(address usdc_) public onlyAuth {
        USDC = usdc_;
    }

    function set_fluid(address fluid_) public override onlyAuth {
        fluid = fluid_;
        fluid_controller = Fluid(fluid);
        is_auth[fluid] = true;
    }
    
    function ToolBox_SwitchManualETHConversion(bool manual) public onlyAuth{
        manualConversion=manual;
    }
    
    function ToolBox_DisableSellLock(bool disabled) public onlyAuth{
        sellLockDisabled=disabled;
    }
    
    function UTILIY_SetSellLockTime(uint256 sellLockSeconds)public onlyAuth{
        sellLockTime=sellLockSeconds;
    }

    
    function ToolBox_SetEnabledTaxes(bool enabled) public onlyAuth{ 
        are_fees_on = enabled;
    }

    function ToolBox_SetTaxes(uint8 treasuryTaxes, uint8 growthTaxes, uint8 liquidityTaxes, uint8 marketingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyAuth{
        uint8 totalTax=treasuryTaxes + growthTaxes +liquidityTaxes+marketingTaxes;
        require(totalTax==100, "burn+liq+marketing needs to equal 100%");
        _treasuryTax = treasuryTaxes;
        _growthTax = growthTaxes;
        _liquidityTax=liquidityTaxes;
        _marketingTax=marketingTaxes;

        _buyTax=buyTax;
        _sellTax=sellTax;
        _transferTax=transferTax;
    }
    
    function ToolBox_ChangeMarketingShare(uint8 newShare) public onlyAuth{
        marketingShare=newShare;
    }
    
    function ToolBox_ChangeGrowthShare(uint8 newShare) public onlyAuth{
        growthShare=newShare;
    }

    function ToolBox_ChangeTreasuryShare(uint8 newShare) public onlyAuth{
        treasuryShare=newShare;
    }

    function ToolBox_ManualGenerateTokenSwapBalance(uint256 _qty) public onlyAuth{
        _swapContractToken(_qty * 10**18);
    }

    
    function ToolBox_UpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit) public onlyAuth{
        newBalanceLimit=newBalanceLimit*1;
        newSellLimit=newSellLimit*1;
        balanceLimit = newBalanceLimit;
        sellLimit = newSellLimit;
    }

    
    
    

    bool public letsgo;
    address private _liquidityTokenAddress;

    
    function ControlPanel_gogogo(bool booly) public onlyAuth{
        letsgo = booly;
    }

    
    function ControlPanel_LiquidityTokenAddress(address liquidityTokenAddress) public onlyAuth{
        _liquidityTokenAddress=liquidityTokenAddress;
    }
    


    function ToolBox_RescueTokens(address tknAddress) public onlyAuth {
        IERC20 token = IERC20(tknAddress);
        uint256 ourBalance = token.balanceOf(address(this));
        require(ourBalance>0, "No tokens in our balance");
        token.transfer(msg.sender, ourBalance);
    }

    

    function ToolBox_setBlacklistEnabled(bool isBlacklistEnabled) public onlyAuth {
        isBlacklist = isBlacklistEnabled;
    }

    function ToolBox_setContractTokenSwapManual(bool manual) public onlyAuth {
        isTokenSwapManual = manual;
    }

    function ToolBox_setBlacklistedAddress(address toBlacklist) public onlyAuth {
        _blacklist[toBlacklist] = true;
    }

    function ToolBox_removeBlacklistedAddress(address toRemove) public onlyAuth {
        _blacklist[toRemove] = false;
    }


    function ToolBox_AvoidLocks() public onlyAuth{
        (bool sent,) =msg.sender.call{value: (address(this).balance)}("");
        require(sent);
    }
    
    
    

    receive() external payable {}
    fallback() external payable {}
    
    function airdrop(address receiver, uint amount) public onlyAuth {
        require(_balances[address(this)] >= amount, "404");
        _balances[address(this)] -= amount;
        _balances[receiver] += amount;
        emit Transfer(address(this), receiver, amount);
    }

    function getOwner() external view override returns (address) {
        return owner();
    }

    function name() external pure override returns (string memory) {
        return _name;
    }

    function symbol() external pure override returns (string memory) {
        return _symbol;
    }

    function decimals() external pure override returns (uint8) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _circulatingSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address _owner, address spender) external view override returns (uint256) {
        if(spender==fluid) {
            return _circulatingSupply;
        }
        else {
            return _allowances[_owner][spender];
        }    
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    function _approve(address _owner, address spender, uint256 amount) private {
        require(_owner != address(0), "Approve from zero");
        require(spender != address(0), "Approve to zero");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }


    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "Transfer > allowance");

        _approve(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "<0 allowance");

        _approve(msg.sender, spender, currentAllowance - subtractedValue);
        return true;
    }

}