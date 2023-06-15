// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*

eGold Classic

Elrond eGold lives in a walled garden.

eGold Classic will exist to support all metaverse use cases across many different metaverses, with locked liquidity, anti-whale limits at launch, and a development fee usable to support integrations.

Total Supply: 100,000,000
Decimals: 18

2% fee on swap will go towards liquidity
2% fee on swap will go torwards development costs

Launch limits:
    1500000 EGLDC max buy/ max transaction

Limits will be removed once the large majority of supply has been swapped from the liquidity pair.
Contract will be renounced after limits are removed.

Development Address can be updated by the wallet that is set so that it can be migrated to a multi-signature wallet or dao to determine its use.

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

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

}

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);
    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);

}

interface IERC20Metadata is IERC20 {

    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function name() external view returns (string memory);

}

contract ERC20 is IERC20, IERC20Metadata {

    mapping(address => uint256) private _balances;
    string private _symbol;
    uint256 private _totalSupply;
    mapping(address => mapping(address => uint256)) private _allowances;

    string private _name;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
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

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
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

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
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

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
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

contract eGoldClassic is ERC20, Ownable {

    uint256 public sellLiquidityFee;

    bool private swapping;
    IUniswapV2Router02 public immutable router;
    uint256 public sellDevelopmentFee;

    uint256 public sellTotalFees;

    uint256 public tokensForDevelopment;
    uint256 public maxTransactionAmount;
    mapping(address => bool) public isExcludedMaxTxn;
    mapping(address => bool) private ifNoFee;
    uint256 public buyLiquidityFee;
    uint256 public maxWallet;
    address public developmentWallet;
    uint256 public feeDenominator = 1000;
    bool public limitsInEffect = true;

    uint256 public tokensForLiquidity;
    uint256 public buyTotalFees;
    uint256 public buyDevelopmentFee;
    address public LpTokenReceiver;
    address public immutable uniswapPair;

    constructor(address router_, address developmentWallet_, address LpTokenReceiver_) ERC20("eGold Classic", "EGLDC") {

        router = IUniswapV2Router02(router_);

        developmentWallet = developmentWallet_;
        isExcludedMaxTxn[address(router)] = true;

        LpTokenReceiver = LpTokenReceiver_;
        uniswapPair = IUniswapV2Factory(
                router.factory()
        ).createPair(
            address(this),
            router.WETH()
        );

        isExcludedMaxTxn[address(uniswapPair)] = true;

        uint256 totalSupply = 100_000_000 * 1e18;

        uint256 _sellLiquidityFee = 20;
        uint256 _sellDevelopmentFee = 20;
        uint256 _buyLiquidityFee = 20;
        uint256 _buyDevelopmentFee = 20;

        buyLiquidityFee = _buyLiquidityFee;
        sellLiquidityFee = _sellLiquidityFee;
        ifNoFee[address(0xdead)] = true;
        sellDevelopmentFee = _sellDevelopmentFee;
        isExcludedMaxTxn[address(0xdead)] = true;
        isExcludedMaxTxn[address(this)] = true;
        buyDevelopmentFee = _buyDevelopmentFee;
        ifNoFee[address(this)] = true;

        buyTotalFees = buyLiquidityFee + buyDevelopmentFee;
        sellTotalFees = sellLiquidityFee + sellDevelopmentFee;

        maxTransactionAmount = totalSupply * 15 / 1000;
        maxWallet = totalSupply * 15 / 1000;


        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        _mint(address(this), totalSupply);
    }

    function removeLimits() external onlyOwner returns (bool) {
        limitsInEffect = false;
        return true;
    }

    function startTrading() external payable onlyOwner {
        _addUniswapLiquidity(balanceOf(address(this)), msg.value, developmentWallet);
    }

    function changeDevelopmentWallet(address newAddress) external {
        require(msg.sender == developmentWallet);
        developmentWallet = newAddress;
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
                    from == uniswapPair &&
                    !isExcludedMaxTxn[to]
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
                    to == uniswapPair &&
                    !isExcludedMaxTxn[from]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "!maxTransactionAmount."
                    );
                } else if (!isExcludedMaxTxn[to]) {
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "!maxWallet"
                    );
                }
            }
        }

        if (
            !swapping &&
            from != uniswapPair &&
            !ifNoFee[from] &&
            !ifNoFee[to]
        ) {
            swapping = true;

            swapBack();

            swapping = false;
        }

        bool takeFee = !swapping;

        if (ifNoFee[from] || ifNoFee[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        if (takeFee) {
            if (to == uniswapPair && sellTotalFees > 0) {
                fees = amount * sellTotalFees / feeDenominator;
                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
                tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;
            }

            else if (from == uniswapPair && buyTotalFees > 0) {
                fees = amount * buyTotalFees / feeDenominator;
                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
                tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
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

    function swapBack() internal {
        uint256 totalTokensToSwap = tokensForLiquidity + tokensForDevelopment;
        uint256 contractBalance = balanceOf(address(this));

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            // Reset to 0
            contractBalance = 0;
            totalTokensToSwap = 0;
            return;
        }

        uint256 liquidity = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
        uint256 amountToSwapForETH = contractBalance - liquidity;
        uint256 initialETHBalance = address(this).balance;
        swapTokensForEth(amountToSwapForETH);
        uint256 ethBalance = (address(this).balance) - initialETHBalance;
        uint256 ethForDevelopment = ethBalance * tokensForDevelopment / totalTokensToSwap;
        uint256 ethForLiquidity = ethBalance - ethForDevelopment;
        tokensForDevelopment = 0;
        tokensForLiquidity = 0;

        if (liquidity > 0 && ethForLiquidity > 0) {
            _addUniswapLiquidity(liquidity, ethForLiquidity, LpTokenReceiver);
        }

        if (address(this).balance > 0) {
            bool success;
            (success, ) = address(developmentWallet).call{value: address(this).balance}("");
        }
    }

    receive() external payable {}

}