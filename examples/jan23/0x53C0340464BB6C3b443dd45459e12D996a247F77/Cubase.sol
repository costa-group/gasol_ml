
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Ownable.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./Address.sol";
import "./IERC165.sol";
import "./ReentrancyGuard.sol";

interface ICubaseV1{
  function tokens(uint256) external view returns (bool);
}

contract CubaseRewardsV2 is Ownable, ReentrancyGuard {
  using Address for address;

  IERC721 public COLLECTION;
  ICubaseV1 public REWARDS1;

  uint256 public rewardAmount = 0.0085 ether;
  bool public isEnabled;
  mapping(uint256 => bool) public tokens;

  constructor() Ownable() {}

  receive() external payable {}

  event claimedToken(uint256 tokenId);


  function claimRewards (uint256[] memory tokenIds) external payable nonReentrant {
      require(isEnabled, 'Faucet is currently disabled');
      require(COLLECTION.balanceOf(msg.sender) > 0, 'Sorry, you are not eligible for rewards');
      require(address(this).balance > rewardAmount * tokenIds.length, 'Not enough cookies in the Jar');
      require(tokenIds.length > 0, 'No Tokens found');

      uint256 tokenBalance = tokenIds.length;
      
      for (uint256 index = 0; index < tokenIds.length; ++index) {
          uint256 tokenId = tokenIds[index];
          if (tokens[tokenId] == true) {
            tokenBalance -= 1;   
          }
          else if(REWARDS1.tokens(tokenId)) {
            tokenBalance -= 1;
          }
          else {
            require(COLLECTION.ownerOf(tokenId) == msg.sender, 'Not the token owner');
            emit claimedToken(tokenId);
            tokens[tokenId] = true;
          }
      }
      uint256 rewardTotal = tokenBalance * rewardAmount;  

      (bool hs, ) = payable(msg.sender).call{value: rewardTotal}("");
      require(hs, "Failed to Process Rewards");
  }


  // nonpayable - admin

  function setRewardAmount(uint256 _rewardVal) external onlyOwner{
    rewardAmount = _rewardVal;
  }

  function setEnabled(bool newEnabled) external onlyOwner{
    isEnabled = newEnabled;
  }

  function setCollection (IERC721 _collection) external onlyOwner {
    COLLECTION = _collection;
  }

  function setRewards1 (ICubaseV1 _rewards1) external onlyOwner {
    REWARDS1 = _rewards1;
  }


  function withdraw() external onlyOwner {
    uint256 totalBalance = address(this).balance;
    require(totalBalance > 0, "no funds available");
    _sendValue(payable(owner()), totalBalance, gasleft());
  }


  // internal
  function _sendValue(address payable recipient, uint256 amount, uint256 gasLimit) internal {
    require(address(this).balance >= amount, "Address: insufficient balance");

    (bool success, ) = recipient.call{gas: gasLimit, value: amount}("");
    require(success, "Address: unable to send value, recipient may have reverted");
  }
}
