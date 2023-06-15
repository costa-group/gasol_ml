// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "contracts/XENCrypto.sol";
import "contracts/interfaces/IStakingToken.sol";
import "contracts/interfaces/IRankedMintingToken.sol";
import "contracts/interfaces/IBurnableToken.sol";
import "contracts/interfaces/IBurnRedeemable.sol";
import "contracts/Math.sol";
import "abdk-libraries-solidity/ABDKMath64x64.sol";
import "openzeppelin/contracts/utils/introspection/IERC165.sol";
import "openzeppelin/contracts/utils/Context.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/interfaces/IERC165.sol";
