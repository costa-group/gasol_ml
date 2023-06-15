// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./lib/Operator.sol";
import "hardhat/console.sol";

//      |||||\          |||||\               |||||\           |||||\
//      ||||| |         ||||| |              ||||| |          ||||| |
//       \__|||||\  |||||\___\|               \__|||||\   |||||\___\|
//          ||||| | ||||| |                      ||||| |  ||||| |
//           \__|||||\___\|       Y u g a         \__|||||\___\|
//              ||||| |             L a b s          ||||| |
//          |||||\___\|                          |||||\___\|
//          ||||| |               J T M          ||||| |
//           \__|||||||||||\        B u f f s     \__|||||||||||\
//              ||||||||||| |                        ||||||||||| |
//               \_________\|                         \_________\|

interface IJimmyTheMonkeyBuffsV1 {
    function getRemainingBuffTimeInSeconds(
        address playerAddress
    ) external view returns (uint256);
}

error BuffPurchasesNotEnabled();
error InvalidInput();

/**
 * title JTM Buff Boosts V2
 */

contract JimmyTheMonkeyBuffsV2 is Operator {
    uint256 public constant BUFF_TIME_INCREASE = 600;
    uint256 public constant BUFF_TIME_INCREASE_PADDING = 60;
    uint256 public constant MAX_BUFFS_PER_TRANSACTIONS = 48;
    uint256 public immutable buffCost;
    address public immutable apeCoinContract;
    IJimmyTheMonkeyBuffsV1 public immutable jimmyTheMonkeyBuffsV1Contract;
    bool public buffPurchasesEnabled;
    mapping(address => uint256) public playerAddressToBuffTimestamp;

    event BuffPurchased(
        address indexed playerAddress,
        uint256 indexed buffTimestamp,
        uint256 quantityPurchased
    );

    constructor(
        address _apeCoinContract,
        uint256 _buffCost,
        address _operator,
        address _jimmyTheMonkeyBuffsV1Contract
    ) Operator(_operator) {
        apeCoinContract = _apeCoinContract;
        buffCost = _buffCost;
        jimmyTheMonkeyBuffsV1Contract = IJimmyTheMonkeyBuffsV1(
            _jimmyTheMonkeyBuffsV1Contract
        );
    }

    /**
     * notice Purchase a buff boost - time starts when the transaction is confirmed
     * param quantity amount of boosts to purchase
     */
    function purchaseBuffs(uint256 quantity) external {
        if (!buffPurchasesEnabled) revert BuffPurchasesNotEnabled();
        if (quantity < 1 || quantity > MAX_BUFFS_PER_TRANSACTIONS)
            revert InvalidInput();

        uint256 newTimestamp;
        uint256 totalBuffIncrease;
        uint256 totalBuffCost;

        uint256 currentBuffTimestamp = playerAddressToBuffTimestamp[
            _msgSender()
        ];

        unchecked {
            totalBuffIncrease = quantity * BUFF_TIME_INCREASE;
            totalBuffCost = quantity * buffCost;
        }

        // player has V2 seconds remaining
        if (currentBuffTimestamp > block.timestamp) {
            unchecked {
                newTimestamp = currentBuffTimestamp + totalBuffIncrease;
            }
        } else {
            // player has no V2 seconds remaining
            unchecked {
                newTimestamp =
                    block.timestamp +
                    totalBuffIncrease +
                    BUFF_TIME_INCREASE_PADDING;
            }
            // first time using v2 contract, add remaining seconds from V1 contract
            if (currentBuffTimestamp == 0) {
                uint256 secondsRemainingBuffsV1 = _getRemainingSecondsFromBuffsV1(
                        _msgSender()
                    );
                unchecked {
                    newTimestamp += secondsRemainingBuffsV1;
                }
            }
        }

        IERC20(apeCoinContract).transferFrom(
            _msgSender(),
            address(this),
            totalBuffCost
        );

        emit BuffPurchased(_msgSender(), newTimestamp, quantity);
        playerAddressToBuffTimestamp[_msgSender()] = newTimestamp;
    }

    /**
     * notice Get the ending boost timestamp for a player address
     * Checks BuffsV1 contract for time
     * param playerAddress the address of the player
     * return uint256 unix timestamp
     */
    function getBuffTimestampForPlayer(
        address playerAddress
    ) external view returns (uint256) {
        uint256 currentBuffTimestamp = playerAddressToBuffTimestamp[
            playerAddress
        ];
        uint256 secondsRemainingBuffsV1;

        // player never purchased on buffsV2 contract
        if (currentBuffTimestamp == 0) {
            // get remaining seconds BuffsV1 contract
            secondsRemainingBuffsV1 = _getRemainingSecondsFromBuffsV1(
                playerAddress
            );
            // same functionality as V1 function
            if (secondsRemainingBuffsV1 == 0) {
                return 0;
            }
            return block.timestamp + secondsRemainingBuffsV1;
        }
        return currentBuffTimestamp;
    }

    /**
     * notice Get the seconds remaining in the boost for a player address
     * Checks BuffsV1 contract for time
     * param playerAddress the address of the player
     * return uint256 seconds of boost remaining
     */
    function getRemainingBuffTimeInSeconds(
        address playerAddress
    ) external view returns (uint256) {
        uint256 currentBuffTimestamp = playerAddressToBuffTimestamp[
            playerAddress
        ];

        // never purchased on buffsV2 contract
        if (currentBuffTimestamp == 0) {
            return _getRemainingSecondsFromBuffsV1(playerAddress);
        } else if (currentBuffTimestamp > block.timestamp) {
            return currentBuffTimestamp - block.timestamp;
        }
        return 0;
    }

    // Internal functions

    function _getRemainingSecondsFromBuffsV1(
        address playerAddress
    ) internal view returns (uint256) {
        return
            jimmyTheMonkeyBuffsV1Contract.getRemainingBuffTimeInSeconds(
                playerAddress
            );
    }

    // Operator functions

    /**
     * notice Toggle the purchase state of buffs
     */
    function flipBuffPurchasesEnabled() external onlyOperator {
        buffPurchasesEnabled = !buffPurchasesEnabled;
    }

    /**
     * notice Withdraw erc-20 tokens
     * param coinContract the erc-20 contract address
     */
    function withdraw(address coinContract) external onlyOperator {
        uint256 balance = IERC20(coinContract).balanceOf(address(this));
        if (balance > 0) {
            IERC20(coinContract).transfer(operator, balance);
        }
    }
}
