// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: swifyfee.sol



//pragma solidity ^0.8.0;



interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface IUniswapV2Router02 {
    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
}

contract SwapContract is ReentrancyGuard {

    address public owner;
    address public UniSwapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public feeAddress = 0x58A1817a36787d20FC5Ef11E3e9e68684BfC9127;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint public feePercent = 4;

    IUniswapV2Router02 router = IUniswapV2Router02(UniSwapRouter);

    modifier onlyOwner {
     require (owner == msg.sender, "Only owner may call this function");
     _;
    }

    constructor() payable {
        owner = msg.sender;
    }

    receive () external payable {

    }

    function ethToToken (address tokenFrom, address tokenOut, uint slippage, address receiver) external payable nonReentrant {
        address[] memory path;
        path = new address[](2);
        path[0] = tokenFrom;
        path[1] = tokenOut;
        router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: (msg.value - (msg.value / 100 * feePercent ))}(slippage, path, receiver, 1955751025);

        (bool os,) = payable(feeAddress).call{value:address(this).balance}("");
        require(os);
    }

    function tokenToEth (address tokenFrom, address tokenOut, uint amountToSell, uint slippage, address receiver) external nonReentrant {
        address[] memory path;
        path = new address[](2);
        path[0] = tokenFrom;
        path[1] = tokenOut;

        IERC20(tokenFrom).transferFrom(msg.sender, address(this), amountToSell);

        uint balance = IERC20(tokenFrom).balanceOf(address(this));
        uint feeAmount = (IERC20(tokenFrom).balanceOf(address(this)) / 100 * feePercent);

        uint amountToApe = balance - feeAmount;

        IERC20(tokenFrom).approve(UniSwapRouter, amountToApe * 50);

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(amountToApe, slippage, path, receiver, 1955751025);

        address[] memory feePath;
        feePath = new address[](2);
        feePath[0] = tokenFrom;
        feePath[1] = weth;

        uint balance2 = IERC20(tokenFrom).balanceOf(address(this));

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(balance2, slippage, feePath, feeAddress, 1955751025);
    }

    function tokenToToken (address tokenFrom, address tokenOut, uint amountToSell, uint slippage, address receiver) external nonReentrant {
        address[] memory path;
        path = new address[](2);
        path[0] = tokenFrom;
        path[1] = tokenOut;

        IERC20(tokenFrom).transferFrom(msg.sender, address(this), amountToSell);

        uint balance = IERC20(tokenFrom).balanceOf(address(this));
        uint feeAmount = (IERC20(tokenFrom).balanceOf(address(this)) / 100 * feePercent);

        uint amountToApe = balance - feeAmount;

        IERC20(tokenFrom).approve(UniSwapRouter, amountToApe * 50);

        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amountToApe, slippage, path, receiver, 1955751025);

        address[] memory feePath;
        feePath = new address[](2);
        feePath[0] = tokenFrom;
        feePath[1] = weth;

        uint balance2 = IERC20(tokenFrom).balanceOf(address(this));

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(balance2, slippage, feePath, feeAddress, 1955751025);
    }

    function withdrawEth() external onlyOwner {
          (bool os,) = payable(feeAddress).call{value:address(this).balance}("");
          require(os);
    }

    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function changeFeeAddress(address newFeeAddress) external onlyOwner {
        feeAddress = newFeeAddress;
    }

    function changeFeePercent(uint newFeePercent) external onlyOwner {
        feePercent = newFeePercent;
    }

}