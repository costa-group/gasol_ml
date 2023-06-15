//SPDX-License-Identifier: Unlicense

pragma solidity = 0.8.9;

import "contracts/chainlink/automations/AutomateStablzFeeHandler.sol";
import "uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "contracts/fees/StablzFeeHandler.sol";
import "contracts/chainlink/common/ChainLinkAutomation.sol";
import "contracts/fees/IStablzFeeHandler.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "contracts/token/Stablz.sol";
import "contracts/access/OracleManaged.sol";
import "chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
