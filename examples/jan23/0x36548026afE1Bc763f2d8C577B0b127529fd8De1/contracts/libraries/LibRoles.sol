pragma solidity ^0.8.9;

/**
 * dev Library with a set of default roles to use across different other contracts.
 */
library LibRoles {
  bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

  //0xb19546dff01e856fb3f010c267a7b1c60363cf8a4664e21cc89c26224620214e
  bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

  //0xa49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775
  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
  bytes32 public constant MAINTENANCE_ROLE = keccak256("MAINTENANCE_ROLE");
  bytes32 public constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
}
