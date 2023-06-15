// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "Ownable.sol";

contract RNGesus is Ownable{

    uint256 public nextRequestId;

    event RequestId(uint256 requestId, uint256 gweiToUse);
    event RandomNumberGenerated(uint256 requestId, uint256 randomNumber);

    mapping(uint256 => uint256) public randomNumbers;

    constructor() {

        // set nextRequestId to 1
        nextRequestId = 1;
    }

    // function to get a requestId, wait a few minutes and check if your prayer is fulfilled
    function prayToRngesus(uint256 _gweiForFulfillPrayer) public payable returns (uint256) {

        // check if the _fulfillmentPrice is paid
        uint256 _fulfillmentPrice = calculateFulfillmentPrice(_gweiForFulfillPrayer);
        require(msg.value == _fulfillmentPrice);

        // send _fulfillmentPrice to contract owner
        payable(owner()).transfer(msg.value);

        // get the current request id
        uint256 _requestId = nextRequestId;

        // add 1 to nextRequestId
        nextRequestId += 1;

        emit RequestId(_requestId, _gweiForFulfillPrayer);

        return _requestId;

    }

    function fulfillPrayer(uint256 _requestId, uint256 _randomNumber) external onlyOwner {

        randomNumbers[_requestId] = _randomNumber;

        emit RandomNumberGenerated(_requestId, _randomNumber);

    }

    function calculateFulfillmentPrice(uint256 _gweiForFulfillPrayer) public pure returns (uint256) {

        // fixed fee of 0.0001 ETH
        uint256 _fixedFee = 0.0001 * 10 ** 18;

        // fulfillment cost is ~50000 gas
        uint256 _fulfillmentTransactionCosts = 50000 * _gweiForFulfillPrayer * 10 ** 9;

        // calculate _totalFulfillmentPrice
        uint256 _totalFulfillmentPrice = _fixedFee + _fulfillmentTransactionCosts;

        return _totalFulfillmentPrice;

    }

}