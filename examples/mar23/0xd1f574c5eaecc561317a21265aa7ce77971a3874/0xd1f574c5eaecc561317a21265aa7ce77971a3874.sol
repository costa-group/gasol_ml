// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IEggChef {
    function claim(uint256 _pid, address _account) external;
}

contract PartyContract {
    address public eggChef = 0xFc6a933a32AA6A382EA06d699A8b788A0BC49fCb;

    function Party(uint256 _pid) public {
        IEggChef(eggChef).claim(_pid, msg.sender);
    }

    function PartyWthAccount(uint256 _pid, address account) public {
        IEggChef(eggChef).claim(_pid, account);
    }

    function LetThePartyBegin(uint256 _pid, address[] memory accounts) public {
        for (uint256 index = 0; index < accounts.length; index++) {
            IEggChef(eggChef).claim(_pid, accounts[index]);
        }
    }
}