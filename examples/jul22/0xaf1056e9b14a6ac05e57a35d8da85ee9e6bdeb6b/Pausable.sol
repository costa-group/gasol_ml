// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

contract Pausable is Ownable {
    bool paused;

    // Приостановить или продолжить трансферы
    function pause(bool _pause) public onlyOwner {
        paused = _pause;
    }
}
