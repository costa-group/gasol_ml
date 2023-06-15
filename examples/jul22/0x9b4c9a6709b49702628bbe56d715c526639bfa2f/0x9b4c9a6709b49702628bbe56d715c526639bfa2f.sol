// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

interface INounsTokenLike {
    function balanceOf(address account) external view returns (uint256);

    function getCurrentVotes(address account) external view returns (uint96);

    function delegates(address delegator) external view returns (address);
}

/// @title Nouns Delegate Votes reporter
contract NounsDelegateVotes {
    INounsTokenLike public immutable nouns = INounsTokenLike(0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03);

    /// @notice Reports the number of votes an account has been externally delegated.
    /// @dev Conforms to the expected ERC-721 function signature `balanceOf(address)` used by token-gate registries
    function balanceOf(address account) public view returns (uint256) {
        address delegate = nouns.delegates(account);
        uint256 balance = nouns.balanceOf(account);
        uint256 votes = uint256(nouns.getCurrentVotes(account));
        if (delegate == account) return votes - balance;
        return votes;
    }
}