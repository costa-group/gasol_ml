// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMerchant {

    struct MerchantInfo {
        address account;
        address payable settleAccount;
        address settleCurrency;
        bool autoSettle;
        address proxy;
        uint256 rate;
        address [] tokens;
    }

    function addMerchant(
        address payable settleAccount,
        address settleCurrency,
        bool autoSettle,
        address proxy,
        uint256 rate,
        address[] memory tokens
    ) external;

    function setMerchantRate(address _merchant, uint256 _rate) external;

    function getMerchantInfo(address _merchant) external view returns(MerchantInfo memory);

    function isMerchant(address _merchant) external view returns(bool);

    function getMerchantTokens(address _merchant) external view returns(address[] memory);

    function getAutoSettle(address _merchant) external view returns(bool);

    function getSettleCurrency(address _merchant) external view returns(address);

    function getSettleAccount(address _merchant) external view returns(address);

    function getGlobalTokens() external view returns(address[] memory);

    function validatorCurrency(address _merchant, address _currency) external view returns (bool);

    function validatorGlobalToken(address _token) external view returns (bool);

}