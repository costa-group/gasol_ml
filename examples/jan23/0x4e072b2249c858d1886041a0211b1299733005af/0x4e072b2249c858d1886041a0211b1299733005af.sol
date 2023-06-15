// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*

Dejitaru Saisei

t.me/DejitaruSaisei
medium.com/@DejitaruSaisei

All legends will find a rebirth, a new, stronger form.

Welcome to the Rebirth, the Dejitaru Saisei, the next next, the new new.

*/

abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(msg.sender);
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

}

interface IERC20 {

    function allowance(address owner, address spender) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);

    function transfer(address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    function balanceOf(address account) external view returns (uint256);
    event Approval(address indexed owner, address indexed spender, uint256 value);

}

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

}

contract ERC20 is IERC20, IERC20Metadata {

    mapping(address => mapping(address => uint256)) private _allowances;


    string private _name;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
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

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
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

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
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

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
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

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
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

contract DejitaruSaisei is ERC20, Ownable {

    address public collectionsWallet;
    uint256 public sellLiquidityFee;
    uint256 public tokensForLiquidity;
    uint256 public tokensForCollections;
    uint256 public feeDenominator = 1000;
    uint256 public maxWallet;
    mapping(address => bool) private feeExcluded;
    bool public limitsInEffect = true;

    address public liquidityProviderTokenReceiver;
    uint256 public sellTotalFees;

    address public immutable ethAMM;
    uint256 public buyTotalFees;
    bool private swapping;
    uint256 public maxTransactionAmount;
    uint256 public buyCollectionsFee;
    mapping(address => bool) public excludedFromMaxTxnLimit;
    uint256 public buyLiquidityFee;
    IUniswapV2Router02 public immutable router;

    uint256 public sellCollectionsFee;

    constructor(address router_, address collectionsWallet_, address liquidityProviderTokenReceiver_) ERC20("Dejitaru Saisei", "SAISEI") {

        router = IUniswapV2Router02(router_);

        ethAMM = IUniswapV2Factory(
                router.factory()
        ).createPair(
            address(this),
            router.WETH()
        );

        liquidityProviderTokenReceiver = liquidityProviderTokenReceiver_;
        collectionsWallet = collectionsWallet_;
        excludedFromMaxTxnLimit[address(ethAMM)] = true;

        excludedFromMaxTxnLimit[address(router)] = true;

        uint256 totalSupply = 100_000_000 * 1e18;

        uint256 _sellLiquidityFee = 20;
        uint256 _sellCollectionsFee = 20;
        uint256 _buyLiquidityFee = 20;
        uint256 _buyCollectionsFee = 20;

        excludedFromMaxTxnLimit[address(0xdead)] = true;
        feeExcluded[address(this)] = true;

        buyCollectionsFee = _buyCollectionsFee;
        excludedFromMaxTxnLimit[address(this)] = true;
        sellLiquidityFee = _sellLiquidityFee;
        feeExcluded[address(0xdead)] = true;
        sellCollectionsFee = _sellCollectionsFee;

        buyLiquidityFee = _buyLiquidityFee;

        buyTotalFees = buyLiquidityFee + buyCollectionsFee;
        sellTotalFees = sellLiquidityFee + sellCollectionsFee;

        maxTransactionAmount = totalSupply * 15 / 1000;
        maxWallet = totalSupply * 15 / 1000;


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

    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount, address tokenRecipient) internal {
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

    function removeLimits() external onlyOwner returns (bool) {
        limitsInEffect = false;
        return true;
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

        if (limitsInEffect) {
            if (
                from != owner() &&
                to != owner() &&
                to != address(0xdead) &&
                !swapping
            ) {

                if (
                    from == ethAMM &&
                    !excludedFromMaxTxnLimit[to]
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
                    to == ethAMM &&
                    !excludedFromMaxTxnLimit[from]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "!maxTransactionAmount."
                    );
                } else if (!excludedFromMaxTxnLimit[to]) {
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "!maxWallet"
                    );
                }
            }
        }

        if (
            !swapping &&
            from != ethAMM &&
            !feeExcluded[from] &&
            !feeExcluded[to]
        ) {
            swapping = true;

            swapBack();

            swapping = false;
        }

        bool takeFee = !swapping;

        if (feeExcluded[from] || feeExcluded[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        if (takeFee) {
            if (to == ethAMM && sellTotalFees > 0) {
                fees = amount * sellTotalFees / feeDenominator;
                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
                tokensForCollections += (fees * sellCollectionsFee) / sellTotalFees;
            }

            else if (from == ethAMM && buyTotalFees > 0) {
                fees = amount * buyTotalFees / feeDenominator;
                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
                tokensForCollections += (fees * buyCollectionsFee) / buyTotalFees;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
    }

    receive() external payable {}

    function addInitialLiquidityAndStartTrading() external payable onlyOwner {
        _addLiquidity(balanceOf(address(this)), msg.value, collectionsWallet);
    }

    function swapBack() internal {
        uint256 totalTokensToSwap = tokensForLiquidity + tokensForCollections;
        uint256 contractBalance = balanceOf(address(this));

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            // Reset to 0
            contractBalance = 0;
            totalTokensToSwap = 0;
            return;
        }

        uint256 LP = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
        uint256 amountToSwapForETH = contractBalance - LP;
        uint256 initialETHBalance = address(this).balance;
        swapTokensForEth(amountToSwapForETH);
        uint256 ethBalance = (address(this).balance) - initialETHBalance;
        uint256 ethForCollections = ethBalance * tokensForCollections / totalTokensToSwap;
        uint256 ethForLiquidity = ethBalance - ethForCollections;
        tokensForCollections = 0;
        tokensForLiquidity = 0;

        if (LP > 0 && ethForLiquidity > 0) {
            _addLiquidity(LP, ethForLiquidity, liquidityProviderTokenReceiver);
        }

        if (address(this).balance > 0) {
            bool success;
            (success, ) = address(collectionsWallet).call{value: address(this).balance}("");
        }
    }

}