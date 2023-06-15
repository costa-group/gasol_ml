// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;//jcf: p.r.a.g.m.a. solidity ^0.8.13;

contract PayForMinting {
    address payable private owner = payable(0xd711Dd225F2c075b6fE8260175B2e075890F52Cc);
    uint256 public constant costToCustomize = 40000000000000000;
    uint256 public constant costToMint = 20000000000000000;

    event PaidForMinting(string indexed dragonWalletIndexed, string dragonWallet, uint8 paymentLevel);
    event CollectedFunds(uint256 amount);

    /// @param dragonWallet The Dragon Wallet string that is receiving payment.
    function payForMinting(string calldata dragonWallet) external payable {
        require(msg.value == costToCustomize || msg.value == costToMint);

        emit PaidForMinting(dragonWallet, dragonWallet, msg.value == costToCustomize ? 2 : 1);
    }

    function claimFunds() external {
        uint256 balance = address(this).balance;
        owner.transfer(balance);
        emit CollectedFunds(balance);
    }
}