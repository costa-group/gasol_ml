// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "contracts/interfaces/IAgToken.sol";
import "contracts/interfaces/ICoreBorrow.sol";
import "contracts/interfaces/IFlashAngle.sol";
import "contracts/interfaces/IOracle.sol";
import "contracts/interfaces/ITreasury.sol";
import "contracts/oracle/BaseOracleChainlinkMulti.sol";
import "contracts/oracle/BaseOracleChainlinkMultiTwoFeeds.sol";
import "contracts/oracle/implementations/mainnet/XAU/OracleUSDCXAUChainlink.sol";
