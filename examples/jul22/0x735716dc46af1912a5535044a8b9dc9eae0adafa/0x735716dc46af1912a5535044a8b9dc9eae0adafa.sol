pragma solidity ^0.7.6;

import "Deployer02.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/utils/Address.sol";
import "openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/math/SafeMath.sol";
import "libraries/StrConcat.sol";
import "libraries/BasicMaths.sol";
import "interfaces/ISystemSettings.sol";
import "interfaces/IRates.sol";
import "interfaces/IPoolCallback.sol";
import "interfaces/IDeployer02.sol";
import "interfaces/IDebt.sol";
import "Debt.sol";
