// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

interface IStrategyV4 {
    function rebalance() external;

    function sweepERC20(address _fromToken) external;

    function withdraw(uint256 _amount) external;

    function feeCollector() external view returns (address);

    function isReservedToken(address _token) external view returns (bool);

    function keepers() external view returns (address);

    function migrate(address _newStrategy) external;

    function pool() external view returns (address);

    function token() external view returns (address);

    function totalValue() external view returns (uint256);

    function totalValueCurrent() external returns (uint256);
}
