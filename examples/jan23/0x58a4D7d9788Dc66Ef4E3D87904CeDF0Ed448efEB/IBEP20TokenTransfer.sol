// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IBEP20TokenTransfer {
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
}
