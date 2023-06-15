// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/utils/Counters.sol";
import "./LibDiamond.sol";

import "hardhat/console.sol";

bytes32 constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

struct MemberShip {
  uint32 memberId;
  uint256 ttl;
}

struct AppStorage {
  // address of offchain signer used to verify messages
  address offchainSigner;
  // price of Token for 1 year period
  uint256 price;
  uint256 pricePerDay;
  uint32 MAX_SUPPLY;
  uint32 MIN_DAYS_TO_EXTEND;
  // toggle switch to pause minting
  bool contractIsPaused;
  bool claimIsPaused;
  // toggle if extension of memberships is enabled
  bool extensionEnabled;
  // TokenMember name
  string name;
  // TokenMember symbol
  string symbol;
  // Token Member Base URI
  string tokenURI;
  // counter of Memberships issued
  Counters.Counter tokenIdCounter;
  // mapping from token ID to member address
  mapping(uint256 => address) members;
  // mapping from member address to token ID
  mapping(address => MemberShip) memberships;
  // maximum term limit that users can purchase / extend.
  // default 2 years set in constructor
  uint256 GLOBAL_TERM_LIMIT;
  uint256 newValue;
}

contract Modifiers {
  modifier onlyOwner() {
    LibDiamond.enforceIsContractOwner();
    _;
  }
}
