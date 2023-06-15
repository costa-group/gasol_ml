// hevm: flattened sources of src/DssSpell.sol
// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.6.12 >=0.6.12 <0.7.0;
// pragma experimental ABIEncoderV2;

////// lib/dss-exec-lib/src/CollateralOpts.sol
/* //pragma solidity ^0.6.12; */

struct CollateralOpts {
    bytes32 ilk;
    address gem;
    address join;
    address clip;
    address calc;
    address pip;
    bool    isLiquidatable;
    bool    isOSM;
    bool    whitelistOSM;
    uint256 ilkDebtCeiling;
    uint256 minVaultAmount;
    uint256 maxLiquidationAmount;
    uint256 liquidationPenalty;
    uint256 ilkStabilityFee;
    uint256 startingPriceFactor;
    uint256 breakerTolerance;
    uint256 auctionDuration;
    uint256 permittedDrop;
    uint256 liquidationRatio;
    uint256 kprFlatReward;
    uint256 kprPctReward;
}

////// lib/dss-exec-lib/src/DssExecLib.sol
//
// DssExecLib.sol -- MakerDAO Executive Spellcrafting Library
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
/* //pragma solidity ^0.6.12; */
/* // pragma experimental ABIEncoderV2; */

/* //import { CollateralOpts } from "./CollateralOpts.sol"; */

interface Initializable {
    function init(bytes32) external;
}

interface Authorizable {
    function rely(address) external;
    function deny(address) external;
    function setAuthority(address) external;
}

interface Fileable {
    function file(bytes32, address) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, bytes32, address) external;
}

interface Drippable {
    function drip() external returns (uint256);
    function drip(bytes32) external returns (uint256);
}

interface Pricing {
    function poke(bytes32) external;
}

interface ERC20 {
    function decimals() external returns (uint8);
}

interface DssVat {
    function hope(address) external;
    function nope(address) external;
    function ilks(bytes32) external returns (uint256 Art, uint256 rate, uint256 spot, uint256 line, uint256 dust);
    function Line() external view returns (uint256);
    function suck(address, address, uint) external;
}

interface ClipLike {
    function vat() external returns (address);
    function dog() external returns (address);
    function spotter() external view returns (address);
    function calc() external view returns (address);
    function ilk() external returns (bytes32);
}

interface DogLike {
    function ilks(bytes32) external returns (address clip, uint256 chop, uint256 hole, uint256 dirt);
}

interface JoinLike {
    function vat() external returns (address);
    function ilk() external returns (bytes32);
    function gem() external returns (address);
    function dec() external returns (uint256);
    function join(address, uint) external;
    function exit(address, uint) external;
}

// Includes Median and OSM functions
interface OracleLike_2 {
    function src() external view returns (address);
    function lift(address[] calldata) external;
    function drop(address[] calldata) external;
    function setBar(uint256) external;
    function kiss(address) external;
    function diss(address) external;
    function kiss(address[] calldata) external;
    function diss(address[] calldata) external;
    function orb0() external view returns (address);
    function orb1() external view returns (address);
}

interface MomLike {
    function setOsm(bytes32, address) external;
    function setPriceTolerance(address, uint256) external;
}

interface RegistryLike {
    function add(address) external;
    function xlip(bytes32) external view returns (address);
}

// https://github.com/makerdao/dss-chain-log
interface ChainlogLike {
    function setVersion(string calldata) external;
    function setIPFS(string calldata) external;
    function setSha256sum(string calldata) external;
    function getAddress(bytes32) external view returns (address);
    function setAddress(bytes32, address) external;
    function removeAddress(bytes32) external;
}

interface IAMLike {
    function ilks(bytes32) external view returns (uint256,uint256,uint48,uint48,uint48);
    function setIlk(bytes32,uint256,uint256,uint256) external;
    function remIlk(bytes32) external;
    function exec(bytes32) external returns (uint256);
}

interface LerpFactoryLike {
    function newLerp(bytes32 name_, address target_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) external returns (address);
    function newIlkLerp(bytes32 name_, address target_, bytes32 ilk_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) external returns (address);
}

interface LerpLike {
    function tick() external returns (uint256);
}


library DssExecLib {

    /* WARNING

The following library code acts as an interface to the actual DssExecLib
library, which can be found in its own deployed contract. Only trust the actual
library's implementation.

    */

    address constant public LOG = 0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F;
    uint256 constant internal WAD      = 10 ** 18;
    uint256 constant internal RAY      = 10 ** 27;
    uint256 constant internal RAD      = 10 ** 45;
    uint256 constant internal THOUSAND = 10 ** 3;
    uint256 constant internal MILLION  = 10 ** 6;
    uint256 constant internal BPS_ONE_PCT             = 100;
    uint256 constant internal BPS_ONE_HUNDRED_PCT     = 100 * BPS_ONE_PCT;
    uint256 constant internal RATES_ONE_HUNDRED_PCT   = 1000000021979553151239153027;
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {}
    function mkr()        public view returns (address) { return getChangelogAddress("MCD_GOV"); }
    function dog()        public view returns (address) { return getChangelogAddress("MCD_DOG"); }
    function pot()        public view returns (address) { return getChangelogAddress("MCD_POT"); }
    function end()        public view returns (address) { return getChangelogAddress("MCD_END"); }
    function reg()        public view returns (address) { return getChangelogAddress("ILK_REGISTRY"); }
    function spotter()    public view returns (address) { return getChangelogAddress("MCD_SPOT"); }
    function lerpFab()    public view returns (address) { return getChangelogAddress("LERP_FAB"); }
    function clip(bytes32 _ilk) public view returns (address _clip) {}
    function flip(bytes32 _ilk) public view returns (address _flip) {}
    function calc(bytes32 _ilk) public view returns (address _calc) {}
    function getChangelogAddress(bytes32 _key) public view returns (address) {}
    function setChangelogAddress(bytes32 _key, address _val) public {}
    function setChangelogVersion(string memory _version) public {}
    function setAuthority(address _base, address _authority) public {}
    function canCast(uint40 _ts, bool _officeHours) public pure returns (bool) {}
    function nextCastTime(uint40 _eta, uint40 _ts, bool _officeHours) public pure returns (uint256 castTime) {}
    function setValue(address _base, bytes32 _what, uint256 _amt) public {}
    function setValue(address _base, bytes32 _ilk, bytes32 _what, uint256 _amt) public {}
    function setIlkLiquidationPenalty(bytes32 _ilk, uint256 _pct_bps) public {}
    function setKeeperIncentiveFlatRate(bytes32 _ilk, uint256 _amount) public {}
    function linearInterpolation(bytes32 _name, address _target, bytes32 _what, uint256 _startTime, uint256 _start, uint256 _end, uint256 _duration) public returns (address) {}
    function linearInterpolation(bytes32 _name, address _target, bytes32 _ilk, bytes32 _what, uint256 _startTime, uint256 _start, uint256 _end, uint256 _duration) public returns (address) {}
}

////// lib/dss-exec-lib/src/DssAction.sol
//
// DssAction.sol -- DSS Executive Spell Actions
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* //pragma solidity ^0.6.12; */

/* //import { DssExecLib } from "./DssExecLib.sol"; */
/* //import { CollateralOpts } from "./CollateralOpts.sol"; */

interface OracleLike_1 {
    function src() external view returns (address);
}

abstract contract DssAction {

    using DssExecLib for *;

    // Modifier used to limit execution time when office hours is enabled
    modifier limited {
        require(DssExecLib.canCast(uint40(block.timestamp), officeHours()), "Outside office hours");
        _;
    }

    // Office Hours defaults to true by default.
    //   To disable office hours, override this function and
    //    return false in the inherited action.
    function officeHours() public virtual returns (bool) {
        return true;
    }

    // DssExec calls execute. We limit this function subject to officeHours modifier.
    function execute() external limited {
        actions();
    }

    // DssAction developer must override `actions()` and place all actions to be called inside.
    //   The DssExec function will call this subject to the officeHours limiter
    //   By keeping this function public we allow simulations of `execute()` on the actions outside of the cast time.
    function actions() public virtual;

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://<executive-vote-canonical-post> -q -O - 2>/dev/null)"
    function description() external virtual view returns (string memory);

    // Returns the next available cast time
    function nextCastTime(uint256 eta) external returns (uint256 castTime) {
        require(eta <= uint40(-1));
        castTime = DssExecLib.nextCastTime(uint40(eta), uint40(block.timestamp), officeHours());
    }
}

////// lib/dss-exec-lib/src/DssExec.sol
//
// DssExec.sol -- MakerDAO Executive Spell Template
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* //pragma solidity ^0.6.12; */

interface PauseAbstract {
    function delay() external view returns (uint256);
    function plot(address, bytes32, bytes calldata, uint256) external;
    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);
}

interface Changelog {
    function getAddress(bytes32) external view returns (address);
}

interface SpellAction {
    function officeHours() external view returns (bool);
    function description() external view returns (string memory);
    function nextCastTime(uint256) external view returns (uint256);
}

contract DssExec {

    Changelog      constant public log   = Changelog(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
    uint256                 public eta;
    bytes                   public sig;
    bool                    public done;
    bytes32       immutable public tag;
    address       immutable public action;
    uint256       immutable public expiration;
    PauseAbstract immutable public pause;

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://<executive-vote-canonical-post> -q -O - 2>/dev/null)"
    function description() external view returns (string memory) {
        return SpellAction(action).description();
    }

    function officeHours() external view returns (bool) {
        return SpellAction(action).officeHours();
    }

    function nextCastTime() external view returns (uint256 castTime) {
        return SpellAction(action).nextCastTime(eta);
    }

    // @param _description  A string description of the spell
    // @param _expiration   The timestamp this spell will expire. (Ex. now + 30 days)
    // @param _spellAction  The address of the spell action
    constructor(uint256 _expiration, address _spellAction) public {
        pause       = PauseAbstract(log.getAddress("MCD_PAUSE"));
        expiration  = _expiration;
        action      = _spellAction;

        sig = abi.encodeWithSignature("execute()");
        bytes32 _tag;                    // Required for assembly access
        address _action = _spellAction;  // Required for assembly access
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
    }

    function schedule() public {
        require(now <= expiration, "This contract has expired");
        require(eta == 0, "This spell has already been scheduled");
        eta = now + PauseAbstract(pause).delay();
        pause.plot(action, tag, sig, eta);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}

////// src/DssSpellCollateral.sol
// S.P.D.X.-FileCopyrightText: © 2021 Dai Foundation <www.daifoundation.org>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* //pragma solidity ^0.6.12; */

/* //import "dss-exec-lib/DssExecLib.sol"; */

contract DssSpellCollateralAction {
    // --- Math ---
    uint256 constant RAY  = 10 ** 27;

    // --- Offboarding: Current Liquidation Ratio ---
    uint256 constant CURRENT_UNI_A_MAT              =  165 * RAY / 100;
    uint256 constant CURRENT_UNIV2DAIETH_A_MAT      =  120 * RAY / 100;
    uint256 constant CURRENT_UNIV2WBTCETH_A_MAT     =  145 * RAY / 100;
    uint256 constant CURRENT_UNIV2WBTCDAI_A_MAT     =  120 * RAY / 100;

    // --- Offboarding: Target Liquidation Ratio ---
    uint256 constant TARGET_UNI_A_MAT               = 1_300 * RAY / 100;
    uint256 constant TARGET_UNIV2DAIETH_A_MAT       = 2_000 * RAY / 100;
    uint256 constant TARGET_UNIV2WBTCETH_A_MAT      = 2_400 * RAY / 100;
    uint256 constant TARGET_UNIV2WBTCDAI_A_MAT      = 800 * RAY / 100;

    // --- Rates ---
    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    // A table of rates can be found at
    //    https://ipfs.io/ipfs/QmTRiQ3GqjCiRhh1ojzKzgScmSsiwQPLyjhgYSxZASQekj
    //

    function onboardNewCollaterals() internal {
        // ----------------------------- Collateral onboarding -----------------------------
        //  Add ______________ as a new Vault Type
        //  Poll Link:

        // DssExecLib.addNewCollateral(
        //     CollateralOpts({
        //         ilk:                   ,
        //         gem:                   ,
        //         join:                  ,
        //         clip:                  ,
        //         calc:                  ,
        //         pip:                   ,
        //         isLiquidatable:        ,
        //         isOSM:                 ,
        //         whitelistOSM:          ,
        //         ilkDebtCeiling:        ,
        //         minVaultAmount:        ,
        //         maxLiquidationAmount:  ,
        //         liquidationPenalty:    ,
        //         ilkStabilityFee:       ,
        //         startingPriceFactor:   ,
        //         breakerTolerance:      ,
        //         auctionDuration:       ,
        //         permittedDrop:         ,
        //         liquidationRatio:      ,
        //         kprFlatReward:         ,
        //         kprPctReward:
        //     })
        // );

        // DssExecLib.setStairstepExponentialDecrease(
        //     CALC_ADDR,
        //     DURATION,
        //     PCT_BPS
        // );

        // DssExecLib.setIlkAutoLineParameters(
        //     ILK,
        //     AMOUNT,
        //     GAP,
        //     TTL
        // );

        // ChainLog Updates
        // Add the new flip and join to the Chainlog
        // address constant CHAINLOG        = DssExecLib.LOG();
        // ChainlogAbstract(CHAINLOG).setAddress("<join-name>", <join-address>);
        // ChainlogAbstract(CHAINLOG).setAddress("<clip-name>", <clip-address>);
        // ChainlogAbstract(CHAINLOG).setVersion("<new-version>");
    }

    function offboardCollaterals() internal {

        address spotter = DssExecLib.spotter();

        // Offboard UNI-A
        // https://vote.makerdao.com/polling/QmSfLS6V#poll-detail
        // https://forum.makerdao.com/t/signal-request-offboard-uni-univ2daieth-univ2wbtceth-univ2unieth-and-univ2wbtcdai/15160

        DssExecLib.setIlkLiquidationPenalty("UNI-A", 0);
        DssExecLib.setKeeperIncentiveFlatRate("UNI-A", 0);
        DssExecLib.linearInterpolation({
            _name:      "UNI-A Offboarding",
            _target:    spotter,
            _ilk:       "UNI-A",
            _what:      "mat",
            _startTime: block.timestamp,
            _start:     CURRENT_UNI_A_MAT,
            _end:       TARGET_UNI_A_MAT,
            _duration:  30 days
        });

        // Offboard UNIV2DAIETH-A
        // https://vote.makerdao.com/polling/QmQUozNn#poll-detail
        // https://forum.makerdao.com/t/signal-request-offboard-uni-univ2daieth-univ2wbtceth-univ2unieth-and-univ2wbtcdai/15160

        DssExecLib.setIlkLiquidationPenalty("UNIV2DAIETH-A", 0);
        DssExecLib.setKeeperIncentiveFlatRate("UNIV2DAIETH-A", 0);
        DssExecLib.linearInterpolation({
            _name:      "UNIV2DAIETH-A Offboarding",
            _target:    spotter,
            _ilk:       "UNIV2DAIETH-A",
            _what:      "mat",
            _startTime: block.timestamp,
            _start:     CURRENT_UNIV2DAIETH_A_MAT,
            _end:       TARGET_UNIV2DAIETH_A_MAT,
            _duration:  30 days
        });

        // Offboard UNIV2WBTCETH-A
        // https://vote.makerdao.com/polling/QmY3YsDB#poll-detail
        // https://forum.makerdao.com/t/signal-request-offboard-uni-univ2daieth-univ2wbtceth-univ2unieth-and-univ2wbtcdai/15160

        DssExecLib.setIlkLiquidationPenalty("UNIV2WBTCETH-A", 0);
        DssExecLib.setKeeperIncentiveFlatRate("UNIV2WBTCETH-A", 0);
        DssExecLib.linearInterpolation({
            _name:      "UNIV2WBTCETH-A Offboarding",
            _target:    spotter,
            _ilk:       "UNIV2WBTCETH-A",
            _what:      "mat",
            _startTime: block.timestamp,
            _start:     CURRENT_UNIV2WBTCETH_A_MAT,
            _end:       TARGET_UNIV2WBTCETH_A_MAT,
            _duration:  30 days
        });

        // Offboard UNIV2UNIETH-A
        // https://vote.makerdao.com/polling/QmUeYVa2#poll-detail
        // https://forum.makerdao.com/t/signal-request-offboard-uni-univ2daieth-univ2wbtceth-univ2unieth-and-univ2wbtcdai/15160

        DssExecLib.setIlkLiquidationPenalty("UNIV2UNIETH-A", 0);
        DssExecLib.setKeeperIncentiveFlatRate("UNIV2UNIETH-A", 0);

        // Offboard UNIV2WBTCDAI-A
        // https://vote.makerdao.com/polling/QmZHNkip#poll-detail
        // https://forum.makerdao.com/t/signal-request-offboard-uni-univ2daieth-univ2wbtceth-univ2unieth-and-univ2wbtcdai/15160

        DssExecLib.setIlkLiquidationPenalty("UNIV2WBTCDAI-A", 0);
        DssExecLib.setKeeperIncentiveFlatRate("UNIV2WBTCDAI-A", 0);
        DssExecLib.linearInterpolation({
            _name:      "UNIV2WBTCDAI-A Offboarding",
            _target:    spotter,
            _ilk:       "UNIV2WBTCDAI-A",
            _what:      "mat",
            _startTime: block.timestamp,
            _start:     CURRENT_UNIV2WBTCDAI_A_MAT,
            _end:       TARGET_UNIV2WBTCDAI_A_MAT,
            _duration:  30 days
        });
    }
}

////// src/DssSpell.sol
// S.P.D.X.-FileCopyrightText: © 2021 Dai Foundation <www.daifoundation.org>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* //pragma solidity 0.6.12; */

// Enable ABIEncoderV2 when onboarding collateral
// // pragma experimental ABIEncoderV2;
/* //import "dss-exec-lib/DssExec.sol"; */
/* //import "dss-exec-lib/DssAction.sol"; */

/* //import { DssSpellCollateralAction } from "./DssSpellCollateral.sol"; */

interface GemLike {
    function transfer(address, uint256) external returns (bool);
}

contract DssSpellAction is DssAction, DssSpellCollateralAction {

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: cast keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/9e4a28dd9961cc802f37493fb9176674fd746dff/governance/votes/Executive%20vote%20-%20June%2029%2C%202022.md -q -O - 2>/dev/null)"
    string public constant override description =
        "2022-06-29 MakerDAO Executive Spell | Hash: 0xb2521ac39ef97ccbb20120431edefa51eb424149ed4a9f7d2840a92920a23420";

    address constant RISK_WALLET_VEST = 0x5d67d5B1fC7EF4bfF31967bE2D2d7b9323c1521c;

    // Math
    uint256 constant WAD = 10**18;

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    // A table of rates can be found at
    //    https://ipfs.io/ipfs/QmPgPVrVxDCGyNR5rGp9JC5AUxppLzUAqvncRJDcxQnX1u
    //

    function officeHours() public override returns (bool) {
        return true;
    }

    function actions() public override {
        // Risk Core Unit MKR Vesting Transfer
        // https://github.com/makerdao/community/blob/9e4a28dd9961cc802f37493fb9176674fd746dff/governance/votes/Executive%20vote%20-%20June%2029%2C%202022.md#rick-core-unit-mkr-vesting-transfer
        GemLike(DssExecLib.mkr()).transfer(RISK_WALLET_VEST, 175 * WAD);

        // ---------------------------------------------------------------------
        // Includes changes from the DssSpellCollateralAction
        // onboardNewCollaterals();
        offboardCollaterals();

        // Housekeeping - add Starknet core contract to Chainlog
        // Contract address taken from https://github.com/starknet-community-libs/starknet-addresses
        DssExecLib.setChangelogAddress("STARKNET_CORE", 0xc662c410C0ECf747543f5bA90660f6ABeBD9C8c4);
        DssExecLib.setChangelogVersion("1.13.2");

    }
}

contract DssSpell is DssExec {
    constructor() DssExec(block.timestamp + 30 days, address(new DssSpellAction())) public {}
}

