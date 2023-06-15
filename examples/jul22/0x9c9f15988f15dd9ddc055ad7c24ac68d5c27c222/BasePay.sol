// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Initializable.sol";
import "./OwnableUpgradeable.sol";
import "./TransferHelper.sol";
import "./ISwapRouter.sol";
import "./IQuoter.sol";
import "./IMerchant.sol";
import "./Address.sol";
import "./SafeMath.sol";


abstract contract BasePay is Initializable, OwnableUpgradeable{

    uint256 public paymentRate = 50;
    uint256 public withdrawRate = 50;
    IQuoter public immutable iQuoter = IQuoter(0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6);
    uint24 public poolFee = 3000;


    mapping(address => uint256) public tradeFeeOf;
    mapping(address => mapping(address => uint256)) public merchantFunds;
    mapping(address => mapping(string => address)) public merchantOrders;


    event Order(string orderId, uint256 paidAmount,address paidToken,uint256 orderAmount,address settleToken,uint256 totalFee, address merchant, address payer, uint256 rate);
    event Withdraw(address merchant, address settleToken, uint256 settleAmount, address settleAccount, uint256 withdrawFee);
    event WithdrawTradeFee(address token, uint256 amount);


    receive() payable external {}

    function initialize()public initializer{
        __Context_init_unchained();
        __Ownable_init_unchained();
    }


    function getPaymentFee(
        uint256 _merchantRate,
        uint256 _orderAmount,
        uint256 _paidAmount,
        bool isUsdcFee
    ) internal view returns(uint256 totalFee, uint256 platformFee, uint256 proxyFee) {
        if (isUsdcFee) {
            totalFee = SafeMath.div((SafeMath.mul(_orderAmount ,_merchantRate)), 10000);
            platformFee = SafeMath.div((SafeMath.mul(_orderAmount ,paymentRate)), 10000);
            proxyFee = totalFee - platformFee;

            return (totalFee, platformFee, proxyFee);
        } else {
            totalFee = SafeMath.div((SafeMath.mul(_paidAmount ,_merchantRate)), 10000);
            platformFee = SafeMath.div((SafeMath.mul(_paidAmount ,paymentRate)), 10000);
            proxyFee = totalFee - platformFee;

            return (totalFee, platformFee, proxyFee);
        }
    }

    function getWithdrawFee(uint256 _withdrawAmount) internal view returns(uint256 withdrawFee) {
        withdrawFee = SafeMath.div((SafeMath.mul(_withdrawAmount ,withdrawRate)), 10000);
        return withdrawFee;
    }

    function withdrawTradeFee(address _token) external onlyOwner {
        uint256 amount = tradeFeeOf[_token];
        TransferHelper.safeTransfer(_token, msg.sender, amount);
        tradeFeeOf[_token] = 0;
        emit WithdrawTradeFee(_token, amount);
    }

    function getEstimated(address tokenIn, address tokenOut, uint256 amountOut) external payable returns (uint256) {

        return iQuoter.quoteExactOutputSingle(
            tokenIn,
            tokenOut,
            poolFee,
            amountOut,
            0
        );
    }

    function setting(
        uint256 _paymentRate,
        uint256 _withdrawRate,
        uint24 _poolFee
    ) external onlyOwner {
        paymentRate = _paymentRate;
        withdrawRate = _withdrawRate;
        poolFee = _poolFee;
    }

}