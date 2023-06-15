// SPDX-License-Identifier: CC-BY-ND-4.0

pragma solidity ^0.8.14;

import "./LiquidProtocol.sol";

contract FuidAdvancedNft is protected {

    struct MINTERS {
        uint minted;
        uint last_mint_timestamp;
    }

    mapping(address => MINTERS) minters;

    address public mintable_ooo;
    bool public is_ooo_mintable = false;
    uint public ooo_mint_price = 1;
 
    address public mintable_token;
    bool public is_token_mintable = false;
    uint public token_mint_price;

    bool public is_eth_mintable = true;
    uint public eth_minting_price;

    uint public MAX_PER_WALLET = 100;
    uint public MIN_COOLDOWN = 1 days;
    uint public MAX_MINT_PHASE_1 = 1;

    // Setting limits
    function set_max_per_wallet(uint mpw) public onlyAuth {
        MAX_PER_WALLET = mpw;
    }

    function set_min_cooldown(uint mcd) public onlyAuth {
        MIN_COOLDOWN = mcd;
    }

    function set_max_mint_phase_1(uint mmp1) public onlyAuth {
        MAX_MINT_PHASE_1 = mmp1;
    }


    // Define addresses 

    function set_mintable_token_address(address tkn) public onlyAuth {
        mintable_token = tkn;
    }

    function set_mintable_ooo_address(address ooo) public onlyAuth {
        mintable_ooo = ooo;
    }

    // Define mintables

    function eth_mintable(bool booly) public onlyAuth {
        is_eth_mintable = booly;
    }

    function token_mintable(bool booly) public onlyAuth {
        is_token_mintable = booly;
    }

    function ooo_mintable(bool booly) public onlyAuth {
        is_ooo_mintable = booly;
    }

    // Define prices

    function ooo_price(uint price_wei) public onlyAuth {
        ooo_mint_price = price_wei;
    }

    function eth_price(uint price_wei) public onlyAuth {
        eth_minting_price = price_wei;
    }

    function token_price(uint price_wei) public onlyAuth {
        token_mint_price = price_wei;
    }

    /// PHASES
    bool is_phase_1 = true;
    bool is_phase_2;

    function primitive() public onlyAuth {
        is_phase_1 = true;
        is_phase_2 = false;
    }

    function evolve() public onlyAuth {
        is_phase_1 = false;
        is_phase_2 = true;
    }
}