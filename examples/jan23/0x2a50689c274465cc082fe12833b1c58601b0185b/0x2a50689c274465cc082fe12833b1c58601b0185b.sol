// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*

Minty Fresh (MINTY)

An experimental no-fee, time launch contract that collects dev fees from the uniswap pair itself through a novel accounting mechanism.

Fees:
    0%

Special Features:
    fee amount is convertable into temporary tokens that are used by the contract to collect a fee.
    Token has a high tax timed launch feature to slowly reduce the fee % from very high to very low.

    0-10 minutes post launch  - 70% BUY/99% sell fee
    10-20 minutes post launch - 50% BUY/99% sell fee
    20-30 minutes post launch - 40% BUY/75% sell fee
    30-40 minutes post launch - 30% BUY/50% sell fee
    40-50 minutes post launch - 15% BUY/25% sell fee
    50-60 minutes post launch - 10% BUY/10% sell fee
    Final fees                - 2% BUY/2% sell fee

    There will be a 1% wallet limit/txn limit until 50% of the supply has been purchased.
    There will be a 1.5% wallet limit/txn limit between 50% and 25% of the supply purchased.
    Once less than 25% of tokens remain in the liquidty pair the max wallet will be the total supply and will never change.
    NOTE: If the uniswap pair regains a large portion of tokens no change to max wallet will occur. 

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

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

}

interface IERC20 {

    function allowance(address owner, address spender) external view returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
    function approve(address spender, uint256 amount) external returns (bool);

    function transfer(address recipient, uint256 amount) external returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);

}

interface IERC20Metadata is IERC20 {

    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

}

contract ERC20 is IERC20, IERC20Metadata {

    mapping(address => uint256) private _balances;


    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
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

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
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

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
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

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Pair {
    function sync() external;
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

contract MintyFresh is ERC20, Ownable {

    enum FeePhase {
        PRELAUNCH,
        MINUTE_0_10,  // default value
        MINUTE_10_20,
        MINUTE_20_30,
        MINUTE_30_40,
        MINUTE_40_50,
        MINUTE_50_60,
        FINAL
    }

    enum Side {
        TRANSFER,
        BUY,
        SELL
    }

    enum TransactionLimitPhase {
        LOW_LIMIT,  // default value
        HIGH_LIMIT,
        FINAL_LIMIT
    }

    enum WalletLimitPhase {
        LOW_LIMIT,  // default value
        HIGH_LIMIT,
        NO_LIMIT
    }

    mapping(Side => mapping(FeePhase => uint256)) public feeMapping;
    uint256[] public feePhaseStart;
    mapping(TransactionLimitPhase => uint256) public maxTxnMapping;
    mapping(WalletLimitPhase => uint256) public maxWalletMapping;

    FeePhase feePhase;
    TransactionLimitPhase txnLimitPhase;
    WalletLimitPhase walletLimitPhase;

    uint256 feeTokens;    
    address public collectionsWallet;
    IUniswapV2Router02 public immutable router;

    mapping(address => bool) private isFeeExcluded;
    address public immutable uniswapPair;
    mapping(address => bool) public isExcludedMaxTxnAmount;


    uint256 public maxTransactionAmount;
    uint256 public maxWallet;
    uint256 public feeDenominator = 1000;

    bool public limitsInEffect = true;
    bool private collectingFee;


    constructor(address router_, address collectionsWallet_) ERC20("Minty Fresh", "MINTY") {
        router = IUniswapV2Router02(router_);
        uniswapPair = IUniswapV2Factory(
                router.factory()
        ).createPair(
            address(this),
            router.WETH()
        );
        collectionsWallet = collectionsWallet_;
        
        isExcludedMaxTxnAmount[address(uniswapPair)] = true;        
        isExcludedMaxTxnAmount[address(router)] = true;
        isExcludedMaxTxnAmount[address(this)] = true;
        isExcludedMaxTxnAmount[address(0xdead)] = true;

        isFeeExcluded[address(0xdead)] = true;
        isFeeExcluded[address(this)] = true;

        uint256 totalSupply = 100_000_000 * 1e18;

        maxTxnMapping[TransactionLimitPhase.LOW_LIMIT] = totalSupply * 10 / 1000;
        maxTxnMapping[TransactionLimitPhase.HIGH_LIMIT] = totalSupply * 15 / 1000;
        maxTxnMapping[TransactionLimitPhase.FINAL_LIMIT] = totalSupply;

        maxWalletMapping[WalletLimitPhase.LOW_LIMIT] = totalSupply * 10 / 1000;
        maxWalletMapping[WalletLimitPhase.HIGH_LIMIT] = totalSupply * 15 / 1000;
        maxWalletMapping[WalletLimitPhase.NO_LIMIT] = totalSupply;

        feeMapping[Side.BUY][FeePhase.MINUTE_0_10] = 700;
        feeMapping[Side.BUY][FeePhase.MINUTE_10_20] = 500;
        feeMapping[Side.BUY][FeePhase.MINUTE_20_30] = 400;
        feeMapping[Side.BUY][FeePhase.MINUTE_30_40] = 300;
        feeMapping[Side.BUY][FeePhase.MINUTE_40_50] = 150;
        feeMapping[Side.BUY][FeePhase.MINUTE_50_60] = 100;
        feeMapping[Side.BUY][FeePhase.FINAL] = 20;

        feeMapping[Side.SELL][FeePhase.MINUTE_0_10] = 990;
        feeMapping[Side.SELL][FeePhase.MINUTE_10_20] = 990;
        feeMapping[Side.SELL][FeePhase.MINUTE_20_30] = 750;
        feeMapping[Side.SELL][FeePhase.MINUTE_30_40] = 500;
        feeMapping[Side.SELL][FeePhase.MINUTE_40_50] = 250;
        feeMapping[Side.SELL][FeePhase.MINUTE_50_60] = 100;
        feeMapping[Side.SELL][FeePhase.FINAL] = 20;

        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        _mint(address(this), totalSupply);
    }

    function rescueStuckETH() external {
        if (address(this).balance > 0) {
            (bool success, ) = address(collectionsWallet).call{value: address(this).balance}("");
            require(success);
        }
    }

    receive() external payable {}

    function addLiquidityAndLaunch() external payable onlyOwner {
        feePhaseStart = [
            0, // no fee
            block.timestamp,
            block.timestamp + 60 * 10,
            block.timestamp + 60 * 20,
            block.timestamp + 60 * 30,
            block.timestamp + 60 * 40,
            block.timestamp + 60 * 50,
            block.timestamp + 60 * 60
        ];

        _addUniswapLiquidity(balanceOf(address(this)), msg.value, collectionsWallet);
         renounceOwnership();
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

        Side side;

        if (to == uniswapPair) {
            side = Side.SELL;
        } else if (from == uniswapPair) {
            side == Side.BUY;
        }

        if (feePhase != FeePhase.FINAL) {
            FeePhase currentFeePhase;

            for ( uint256 i=uint256(feePhase); i <= uint256(FeePhase.FINAL); i++ ) {
                if (block.timestamp >= feePhaseStart[i]) {
                    currentFeePhase = FeePhase(i);                    
                    continue;
                }

                if (block.timestamp < feePhaseStart[i]) {
                    break;
                }
            }

            if (feePhase != currentFeePhase) {
                feePhase = currentFeePhase;
            }
        }

        if (feePhase != FeePhase.PRELAUNCH) {
            uint256 pairBalance = balanceOf(uniswapPair);

            if (pairBalance > totalSupply() / 2) {
                txnLimitPhase = TransactionLimitPhase.LOW_LIMIT;
                if (walletLimitPhase != WalletLimitPhase.NO_LIMIT) {
                    walletLimitPhase = WalletLimitPhase.LOW_LIMIT;
                }
            } else if (pairBalance > totalSupply() / 4) {
                txnLimitPhase = TransactionLimitPhase.HIGH_LIMIT;
                if (walletLimitPhase != WalletLimitPhase.NO_LIMIT) {
                    walletLimitPhase = WalletLimitPhase.HIGH_LIMIT;
                }
            } else {
                if (walletLimitPhase != WalletLimitPhase.NO_LIMIT) {
                    walletLimitPhase = WalletLimitPhase.NO_LIMIT;
                }

                if (txnLimitPhase != TransactionLimitPhase.FINAL_LIMIT) {
                    txnLimitPhase = TransactionLimitPhase.FINAL_LIMIT;
                }
            }
        }

        if (!isExcludedMaxTxnAmount[from]) {
            require(amount <= maxTxnMapping[txnLimitPhase]);
        }

        if (!isExcludedMaxTxnAmount[to]) {
            require(amount <= maxWalletMapping[walletLimitPhase]);
        }

        if (!collectingFee && side != Side.TRANSFER && !isFeeExcluded[from] && !isFeeExcluded[to]) {
            uint256 fees = amount * feeMapping[side][feePhase] / feeDenominator;
            feeTokens += fees;
            if (feePhase != FeePhase.FINAL) {
                amount -= fees;
            }
        }

        if (
            !collectingFee &&
            side == Side.SELL &&
            !isFeeExcluded[from] &&
            !isFeeExcluded[to]
        ) {
            collectingFee = true;

            collectFee();

            collectingFee = false;
        }

        super._transfer(from, to, amount);
    }

    function collectFee() internal {
        if (feeTokens == 0) {
            return;
        }

        _mint(address(this), feeTokens);
        swapTokensForEth(balanceOf(address(this)));
        _burn(uniswapPair, feeTokens);

        IUniswapV2Pair pair = IUniswapV2Pair(uniswapPair);
        pair.sync();

        feeTokens = 0;
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
}