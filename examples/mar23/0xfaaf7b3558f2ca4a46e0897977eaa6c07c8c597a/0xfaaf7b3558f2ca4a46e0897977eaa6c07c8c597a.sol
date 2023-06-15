// SPDX-License-Identifier: Unlicense

pragma solidity = 0.8.9;

import "contracts/chainlink/automations/AutomateStablz3CRVIntegration.sol";
import "contracts/fees/IStablzFeeHandler.sol";
import "contracts/integrations/curve/common/Stablz3CRVMetaPoolIntegration.sol";
import "contracts/integrations/curve/common/ICurveSwap.sol";
import "contracts/integrations/curve/common/ICurve3CRVPool.sol";
import "contracts/integrations/curve/common/ICurve3CRVGauge.sol";
import "contracts/chainlink/common/ChainLinkAutomation.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/integrations/common/StablzLPIntegration.sol";
import "contracts/integrations/curve/common/ICurve3CRVMinter.sol";
import "contracts/integrations/curve/common/ICurve3CRVBasePool.sol";
import "contracts/integrations/curve/common/ICurve3CRVDepositZap.sol";
import "chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/security/ReentrancyGuard.sol";
import "contracts/access/OracleManaged.sol";
import "openzeppelin/contracts/utils/Context.sol";
