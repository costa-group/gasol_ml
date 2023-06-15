/**
 * DRACO - A Dragon Medieval Game
 *
 * WEBSITE: https://draco.guru
 * TELEGRAM: https://t.me/draco_erc
*/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable returns (
        uint256 amountToken,
        uint256 amountETH,
        uint256 liquidity
    );

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract DRACO is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    address private constant DEAD = address(0xdead);
    address private constant ZERO = address(0);

    bool private swapping;

    uint256 public maxTransactionAmount;
    uint256 public swapTokensAtAmount;
    uint256 public maxWallet;

    bool public limitsInEffect = true;
    bool public tradingActive = false;
    bool public swapEnabled = false;

    bool private gasLimitActive = false;
    uint256 private constant gasPriceLimit = 100 * 1 gwei; //Max Gwei to trade

    // Anti-bot and anti-whale mappings and variables
    mapping(address => uint256) private _holderLastTransferTimestamp; //Keep last transfer timestamp temporarily during launch
    bool private transferDelayEnabled = false; //Protect launch from bots

    struct Fees {
        uint256 marketing;
        uint256 liquidity;
        uint256 total;
    }
    Fees public buyFee;
    Fees public sellFee;

    address private marketingWallet;
    uint256 private tokensForMarketing;
    uint256 private tokensForLiquidity;

    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) private _isExcludedMaxTransactionAmount;
    mapping(address => bool) private automatedMarketMakerPairs;

    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event SwapAndLiquidity(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);

    constructor(address _marketingWallet, uint256[] memory _fees) ERC20("Draco", "DRA") {
        _createPair();

        uint256 totalSupply = 100000000 * 10**decimals();

        maxTransactionAmount = totalSupply.mul(2).div(100);
        maxWallet = totalSupply.mul(3).div(100);
        swapTokensAtAmount = totalSupply.mul(5).div(10000);

        marketingWallet = _marketingWallet;

        buyFee = Fees(_fees[0], _fees[1], _fees[0] + _fees[1]);
        sellFee = Fees(_fees[2], _fees[3], _fees[2] + _fees[3]);

        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(DEAD, true);

        excludeFromMaxTransaction(owner(), true);
        excludeFromMaxTransaction(address(this), true);
        excludeFromMaxTransaction(DEAD, true);

        _mint(msg.sender, totalSupply);
    }

    receive() external payable {}

    function _createPair() private {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        excludeFromMaxTransaction(address(_uniswapV2Router), true);
        uniswapV2Router = _uniswapV2Router;

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        excludeFromMaxTransaction(address(uniswapV2Pair), true);
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function isExcludedFromFees(address _address) public view returns (bool) {
        return _isExcludedFromFees[_address];
    }

    function startTrading() external onlyOwner {
        require(!tradingActive, "Owner cannot disable trade.");
        tradingActive = swapEnabled = !tradingActive;
    }

    function removeLimits() external onlyOwner {
        require(limitsInEffect, "The limits in effect has been removed.");
        limitsInEffect = !limitsInEffect;
    }

    function toggleSwapEnabled() external onlyOwner {
        swapEnabled = !swapEnabled;
    }

    function toggleGasLimitActive() external onlyOwner {
        gasLimitActive = !gasLimitActive;
    }

    function toggleTransferDelayEnabled() external onlyOwner {
        transferDelayEnabled = !transferDelayEnabled;
    }

    function updateSwapTokensAtAmount(uint256 _amount) external onlyOwner {
        _amount = _amount.mul(10**decimals());
        require(_amount >= totalSupply().mul(1).div(100000), "Swap amount cannot be lower than 0.001% total supply.");
        require(_amount <= totalSupply().mul(5).div(1000), "Swap amount cannot be higher than 0.5% total supply.");
        swapTokensAtAmount = _amount;
    }

    function updateMaxWalletAndTxnAmount(uint256 _maxTransactionAmount, uint256 _maxWallet) external onlyOwner {
        _maxTransactionAmount = _maxTransactionAmount.mul(10**decimals());
        _maxWallet = _maxWallet.mul(10**decimals());
        uint256 limit = totalSupply().mul(5).div(1000);
        require(_maxTransactionAmount >= limit, "Cannot set maxTxn lower than 0.5%");
        require(_maxWallet >= limit, "Cannot set maxWallet lower than 0.5%");
        maxTransactionAmount = _maxTransactionAmount;
        maxWallet = _maxWallet;
    }

    function updateBuyFees(uint256 _marketing, uint256 _liquidity) external onlyOwner {
        buyFee = Fees(_marketing, _liquidity, _marketing + _liquidity);
        require(buyFee.total <= 5, "Must keep fees at 5% or less");
    }

    function updateSellFees(uint256 _marketing, uint256 _liquidity) external onlyOwner {
        sellFee = Fees(_marketing, _liquidity, _marketing + _liquidity);
        require(sellFee.total <= 5, "Must keep fees at 5% or less");
    }

    function updateMarketingWallet(address _marketingWallet) external onlyOwner {
        require(_marketingWallet != ZERO, "Marketing wallet cannot be zero address");
        require(_marketingWallet != DEAD, "Marketing wallet cannot be dead address");
        marketingWallet = _marketingWallet;
    }

    function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
        require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
        _setAutomatedMarketMakerPair(pair, value);
    }

    function excludeFromMaxTransaction(address _address, bool isExclude) public onlyOwner {
        _isExcludedMaxTransactionAmount[_address] = isExclude;
    }

    function excludeFromFees(address _address, bool isExclude) public onlyOwner {
        _isExcludedFromFees[_address] = isExclude;
        emit ExcludeFromFees(_address, isExclude);
    }

    function withdrawStuckedBalance(uint256 _mount) external onlyOwner {
        require(address(this).balance >= _mount, "Insufficient balance");
        payable(msg.sender).transfer(_mount);
    }

    function withdrawStuckedTokens(address _tokenAddress, address _to, uint256 _amount) external onlyOwner returns (bool) {
        require(_tokenAddress != address(this), "Owner can't claim contract's balance of its own tokens");
        return ERC20(_tokenAddress).transfer(_to, _amount);
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(from != ZERO, "ERC20: transfer from the zero address");
        require(to != DEAD, "ERC20: transfer to the zero address");

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (from != owner() && to != owner() && to != ZERO && to != DEAD && !swapping) {
            if (!tradingActive) {
                require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
            }

            if (limitsInEffect) {
                //Only use to prevent sniper buys at launch.
                if (gasLimitActive && automatedMarketMakerPairs[from]) {
                    require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
                }

                //if the transfer delay is enabled at launch
                if (transferDelayEnabled) {
                    if (
                        to != owner() &&
                        to != address(uniswapV2Router) &&
                        to != address(uniswapV2Pair)
                    ) {
                        require(
                            _holderLastTransferTimestamp[tx.origin] < block.number,
                            "Only one purchase per block allowed."
                        );
                        _holderLastTransferTimestamp[tx.origin] = block.number;
                    }
                }

                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
                    require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
                    require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
                }
                else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
                    require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
                }
                else if (!_isExcludedMaxTransactionAmount[to]) {
                    require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
                }
            }
        }

        bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
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

        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        if (takeFee) {
            if (automatedMarketMakerPairs[to] && sellFee.total > 0) {
                fees = amount.mul(sellFee.total).div(100);
                tokensForLiquidity += (fees * sellFee.liquidity) / sellFee.total;
                tokensForMarketing += (fees * sellFee.marketing) / sellFee.total;
            }
            else if (automatedMarketMakerPairs[from] && buyFee.total > 0) {
                fees = amount.mul(buyFee.total).div(100);
                tokensForLiquidity += (fees * buyFee.liquidity) / buyFee.total;
                tokensForMarketing += (fees * buyFee.marketing) / buyFee.total;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }
            amount -= fees;
        }
        super._transfer(from, to, amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
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

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            DEAD,
            block.timestamp
        );
    }

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
        bool success;

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            return;
        }

        if (contractBalance > swapTokensAtAmount * 20) {
            contractBalance = swapTokensAtAmount * 20;
        }

        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);

        uint256 initialETHBalance = address(this).balance;

        swapTokensForEth(amountToSwapForETH);

        uint256 ethBalance = address(this).balance.sub(initialETHBalance);
        uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
        uint256 ethForLiquidity = ethBalance - ethForMarketing;

        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            addLiquidity(liquidityTokens, ethForLiquidity);
            emit SwapAndLiquidity(
                amountToSwapForETH,
                ethForLiquidity,
                tokensForLiquidity
            );
        }

        tokensForLiquidity = 0;
        tokensForMarketing = 0;

        (success, ) = address(marketingWallet).call{value: address(this).balance}("");
    }
}