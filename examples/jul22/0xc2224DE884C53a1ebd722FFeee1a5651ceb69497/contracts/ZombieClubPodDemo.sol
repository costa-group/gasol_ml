//SPDX-License-Identifier: MIT
/**
▒███████▒ ▒█████   ███▄ ▄███▓ ▄▄▄▄    ██▓▓█████     ▄████▄   ██▓     █    ██  ▄▄▄▄   
▒ ▒ ▒ ▄▀░▒██▒  ██▒▓██▒▀█▀ ██▒▓█████▄ ▓██▒▓█   ▀    ▒██▀ ▀█  ▓██▒     ██  ▓██▒▓█████▄ 
░ ▒ ▄▀▒░ ▒██░  ██▒▓██    ▓██░▒██▒ ▄██▒██▒▒███      ▒▓█    ▄ ▒██░    ▓██  ▒██░▒██▒ ▄██
  ▄▀▒   ░▒██   ██░▒██    ▒██ ▒██░█▀  ░██░▒▓█  ▄    ▒▓▓▄ ▄██▒▒██░    ▓▓█  ░██░▒██░█▀  
▒███████▒░ ████▓▒░▒██▒   ░██▒░▓█  ▀█▓░██░░▒████▒   ▒ ▓███▀ ░░██████▒▒▒█████▓ ░▓█  ▀█▓
░▒▒ ▓░▒░▒░ ▒░▒░▒░ ░ ▒░   ░  ░░▒▓███▀▒░▓  ░░ ▒░ ░   ░ ░▒ ▒  ░░ ▒░▓  ░░▒▓▒ ▒ ▒ ░▒▓███▀▒
░░▒ ▒ ░ ▒  ░ ▒ ▒░ ░  ░      ░▒░▒   ░  ▒ ░ ░ ░  ░     ░  ▒   ░ ░ ▒  ░░░▒░ ░ ░ ▒░▒   ░ 
░ ░ ░ ░ ░░ ░ ░ ▒  ░      ░    ░    ░  ▒ ░   ░      ░          ░ ░    ░░░ ░ ░  ░    ░ 
  ░ ░        ░ ░         ░    ░       ░     ░  ░   ░ ░          ░  ░   ░      ░      
░                                  ░               ░                               ░ 
 
Website: https://zombieclub.io
Twitter: https://twitter.com/get_turned
Discord: https://discord.gg/zombieclub
Github: https://github.com/getTurned

 */

pragma solidity ^0.8.0;

import "openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract ZombieClubPodDemo is Initializable, ERC721Upgradeable, OwnableUpgradeable {
    constructor() initializer {
        __Ownable_init();
    }

    function initialize(address receiver) external initializer {
        __ERC721_init("Virtual", "DEMO");
        __Ownable_init();
        for(uint256 i; i < 4; i++) {
            _mint(receiver, i+1);
        }
    }

    function _baseURI() internal view override returns(string memory){
        return "https://zombieclub.mypinata.cloud/ipfs/QmUG9EhRQAunGnYoMWDiorYBgf3dakkwE3LP79sTg5fNS5/";
    }

    function selfDestruct() public onlyOwner {
        selfdestruct(payable(msg.sender));
    }
}