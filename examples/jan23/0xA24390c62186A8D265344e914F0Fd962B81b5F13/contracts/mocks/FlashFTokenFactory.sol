// SPDX-License-Identifier: BSL-1.1

pragma solidity ^0.8.17;

import "openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IFlashFTokenFactory.sol";
import "./FlashFToken.sol";

contract FlashFTokenFactory is Ownable, IFlashFTokenFactory {
    event FTokenCreated(address _tokenAddress);

    constructor() {}

    function createFToken(string calldata _fTokenName, string calldata _fTokenSymbol)
        external
        onlyOwner
        returns (address)
    {
        FlashFToken flashFToken = new FlashFToken(_fTokenName, _fTokenSymbol);
        flashFToken.transferOwnership(msg.sender);

        emit FTokenCreated(address(flashFToken));
        return address(flashFToken);
    }
}
