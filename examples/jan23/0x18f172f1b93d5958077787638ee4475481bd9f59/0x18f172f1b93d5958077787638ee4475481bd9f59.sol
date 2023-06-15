// tuta @thecryptogus
pragma solidity ^0.8.0;

contract SendEther {
    uint256 public addresses;
    uint256 public amount;
    address payable[] public recipients;

    function sendViaTransfer(address payable[] memory _recipients) public payable {
        // This function is no longer recommended for sending Ether.
        addresses = _recipients.length;
        amount = msg.value / addresses;
        for (uint256 i = 0; i < _recipients.length; i++) {
            _recipients[i].transfer(amount);
        }
    }
}