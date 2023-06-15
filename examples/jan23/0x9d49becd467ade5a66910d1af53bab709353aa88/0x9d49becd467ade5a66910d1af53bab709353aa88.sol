// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*

Who doesn't love a New Years Delight.

What could it be ... and when?

*/ 

abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(msg.sender);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

}

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function transfer(address recipient, uint256 amount) external returns (bool);

    function totalSupply() external view returns (uint256);


    function allowance(address owner, address spender) external view returns (uint256);

}

interface IERC20Metadata is IERC20 {

    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function decimals() external view returns (uint8);

}

contract ERC20 is IERC20, IERC20Metadata {

    string private _symbol;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    string private _name;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

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

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from zero address");
        require(recipient != address(0), "ERC20: transfer to zero address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount greater than balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount greater than allowance");
        unchecked {
            _approve(sender, msg.sender, currentAllowance - amount);
        }

        return true;
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

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

contract NewYearsDelight is ERC20, Ownable {

    address public immutable amm;

    uint256 public maxWallet;

    uint256 public sellTreasuryFee;
    mapping(address => bool) public isExcludedMaxTxnAmount;
    uint256 public tokensForTreasury;
    address public treasuryWallet;

    address public LPRecipient;
    mapping(address => bool) private feeExclusion;
    uint256 public sellTotalFees;


    uint256 public maxTransactionAmount;
    uint256 public tokensForLiquidity;
    IUniswapV2Router02 public immutable router;
    bool private swapping;
    uint256 public buyTreasuryFee;
    uint256 public sellLiquidityFee;
    uint256 public buyLiquidityFee;
    uint256 public feeDenominator = 1000;
    uint256 public buyTotalFees;
    bool public limitsInEffect = true;

    constructor(address router_, address treasuryWallet_, address LPRecipient_) ERC20("New Years Delight", "NYD") {

        router = IUniswapV2Router02(router_);

        LPRecipient = LPRecipient_;
        isExcludedMaxTxnAmount[address(router)] = true;
        amm = IUniswapV2Factory(
                router.factory()
        ).createPair(
            address(this),
            router.WETH()
        );
        isExcludedMaxTxnAmount[address(amm)] = true;
        treasuryWallet = treasuryWallet_;

        uint256 totalSupply = 100_000_000 * 1e18;

        uint256 _sellLiquidityFee = 20;
        uint256 _sellTreasuryFee = 20;
        uint256 _buyLiquidityFee = 20;
        uint256 _buyTreasuryFee = 20;

        sellLiquidityFee = _sellLiquidityFee;


        sellTreasuryFee = _sellTreasuryFee;
        isExcludedMaxTxnAmount[address(this)] = true;
        buyLiquidityFee = _buyLiquidityFee;
        isExcludedMaxTxnAmount[address(0xdead)] = true;
        feeExclusion[address(0xdead)] = true;
        buyTreasuryFee = _buyTreasuryFee;
        feeExclusion[address(this)] = true;

        buyTotalFees = buyLiquidityFee + buyTreasuryFee;
        sellTotalFees = sellLiquidityFee + sellTreasuryFee;

        maxTransactionAmount = totalSupply * 2 / 100;
        maxWallet = totalSupply * 2 / 100;


        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        _mint(address(this), totalSupply);
    }

    function swapTokensForEth(uint256 tokenAmount) internal {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        _approve(address(this), address(router), tokenAmount);
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function _addUniswapLiquidity(uint256 tokenAmount, uint256 ethAmount, address tokenRecipient) internal {
        _approve(address(this), address(router), tokenAmount);
        router.addLiquidityETH{value: ethAmount} (
            address(this),
            tokenAmount,
            0,
            0,
            tokenRecipient,
            block.timestamp
        );
    }

    receive() external payable {}

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

        if (limitsInEffect) {
            if (
                from != owner() &&
                to != owner() &&
                to != address(0xdead) &&
                !swapping
            ) {

                if (
                    from == amm &&
                    !isExcludedMaxTxnAmount[to]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "!maxTransactionAmount."
                    );
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "!maxWallet"
                    );
                }

                else if (
                    to == amm &&
                    !isExcludedMaxTxnAmount[from]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "!maxTransactionAmount."
                    );
                } else if (!isExcludedMaxTxnAmount[to]) {
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "!maxWallet"
                    );
                }
            }
        }

        if (
            !swapping &&
            from != amm &&
            !feeExclusion[from] &&
            !feeExclusion[to]
        ) {
            swapping = true;

            swapBack();

            swapping = false;
        }

        bool takeFee = !swapping;

        if (feeExclusion[from] || feeExclusion[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        if (takeFee) {
            if (to == amm && sellTotalFees > 0) {
                fees = amount * sellTotalFees / feeDenominator;
                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
                tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
            }

            else if (from == amm && buyTotalFees > 0) {
                fees = amount * buyTotalFees / feeDenominator;
                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
                tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
    }

    function swapBack() internal {
        uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
        uint256 contractBalance = balanceOf(address(this));

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            // Reset to 0
            contractBalance = 0;
            totalTokensToSwap = 0;
            return;
        }

        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
        uint256 amountToSwapForETH = contractBalance - liquidityTokens;
        uint256 initialETHBalance = address(this).balance;
        swapTokensForEth(amountToSwapForETH);
        uint256 ethBalance = (address(this).balance) - initialETHBalance;
        uint256 ethForTreasury = ethBalance * tokensForTreasury / totalTokensToSwap;
        uint256 ethForLiquidity = ethBalance - ethForTreasury;
        tokensForTreasury = 0;
        tokensForLiquidity = 0;

        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            _addUniswapLiquidity(liquidityTokens, ethForLiquidity, LPRecipient);
        }

        if (address(this).balance > 0) {
            bool success;
            (success, ) = address(treasuryWallet).call{value: address(this).balance}("");
        }
    }

    function addInitialLiquidity() external payable onlyOwner {
        _addUniswapLiquidity(balanceOf(address(this)), msg.value, treasuryWallet);
    }

    function removeLimits() external onlyOwner returns (bool) {
        limitsInEffect = false;
        return true;
    }

}