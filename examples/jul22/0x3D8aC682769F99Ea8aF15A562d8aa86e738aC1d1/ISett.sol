// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISett {
    function totalSupply() external view returns (uint256);

    function balance() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function getPricePerFullShare() external view returns (uint256);

    function deposit(uint256 _amount) external;
}
