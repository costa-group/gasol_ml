// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "./IERC20.sol";
import "./Ownable.sol";

contract SafeToken is Ownable {
    address _safeManager;

    constructor() {
        _safeManager = _msgSender();
    }

    function setSafeManager(address account) external onlyOwner {
        _safeManager = account;
    }

    function withdraw(address token, uint256 amount) external {
        require(_msgSender() == _safeManager, "SafeToken: caller is not the manager");
        
        if(token == address(0)) {
            (bool success, ) = payable(_safeManager).call{value: amount}("");
            require(success, "SafeToken: failed to withdraw ETH for emergency");
        } else {
            require(IERC20(token).transfer(_safeManager, amount), "SafeToken: failed to withdraw token for emergency");
        }
    }
}
