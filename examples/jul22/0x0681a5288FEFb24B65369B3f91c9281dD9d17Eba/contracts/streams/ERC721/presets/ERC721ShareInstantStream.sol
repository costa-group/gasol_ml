// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.9;

import "openzeppelin/contracts/proxy/utils/Initializable.sol";
import "openzeppelin/contracts/access/Ownable.sol";

import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/utils/Counters.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC721/IERC721.sol";

import "../extensions/ERC721InstantReleaseExtension.sol";
import "../extensions/ERC721ShareSplitExtension.sol";

contract ERC721ShareInstantStream is
    Initializable,
    Ownable,
    ERC721InstantReleaseExtension,
    ERC721ShareSplitExtension
{
    string public constant name = "ERC721 Share Instant Stream";

    string public constant version = "0.1";

    struct Config {
        // Base
        address ticketToken;
        uint64 lockedUntilTimestamp;
        // Share split extension
        uint256[] tokenIds;
        uint256[] shares;
    }

    /* INTERNAL */

    constructor(Config memory config) {
        initialize(config, msg.sender);
    }

    function initialize(Config memory config, address deployer)
        public
        initializer
    {
        _transferOwnership(deployer);

        __ERC721MultiTokenStream_init(
            config.ticketToken,
            config.lockedUntilTimestamp
        );
        __ERC721InstantReleaseExtension_init();
        __ERC721ShareSplitExtension_init(config.tokenIds, config.shares);
    }
}
