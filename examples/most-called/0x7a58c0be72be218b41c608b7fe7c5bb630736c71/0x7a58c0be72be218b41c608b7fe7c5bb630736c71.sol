// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "contracts/v1/Tickets.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "paulrberg/contracts/token/erc20/Erc20Permit.sol";
import "contracts/v1/interfaces/ITickets.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "openzeppelin/contracts/utils/Counters.sol";
import "paulrberg/contracts/token/erc20/Erc20.sol";
import "paulrberg/contracts/token/erc20/IErc20Permit.sol";
import "paulrberg/contracts/token/erc20/IErc20.sol";
