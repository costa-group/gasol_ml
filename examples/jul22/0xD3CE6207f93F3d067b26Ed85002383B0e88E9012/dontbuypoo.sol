// SPDX-License-Identifier: MIT

//╭━━━╮╱╱╱╱╱╱╭╮╭━━╮╱╱╱╱╱╱╱╭━━━╮
//╰╮╭╮┃╱╱╱╱╭┳╯╰┫╭╮┃╱╱╱╱╱╱╱┃╭━╮┃
//╱┃┃┃┣━━┳━┫┣╮╭┫╰╯╰┳╮╭┳╮╱╭┫╰━╯┣━━┳━━╮
//╱┃┃┃┃╭╮┃╭╋┫┃┃┃╭━╮┃┃┃┃┃╱┃┃╭━━┫╭╮┃╭╮┃
//╭╯╰╯┃╰╯┃┃┃┃┃╰┫╰━╯┃╰╯┃╰━╯┃┃╱╱┃╰╯┃╰╯┃
//╰━━━┻━━┻╯╰╯╰━┻━━━┻━━┻━╮╭┻╯╱╱╰━━┻━━╯
//╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭━╯┃
//╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯


//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡾⠟⠋⢩⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠸⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠁⠀⠀⠀⠀⠀⠀⠙⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠃⠀⠀⠀⠀⠀⠐⠷⠤⠤⠤⠤⣿⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡾⠟⠛⢦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⢰⡿⠉⠀⠀⠀⠀⠈⠓⠦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⣀⡤⠤⠤⢄⡀⠀⠈⠙⠒⠦⣤⣀⣠⠖⠋⠉⠓⠦⣀⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⠀⠀⣀⣿⣧⡞⠁⢀⣀⡀⠀⠙⣆⠀⠀⠀⠀⠀⡼⠁⠀⣠⣤⡀⠀⠙⡟⠿⢶⣤⡀⠀⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⠀⣠⡾⠟⠁⡼⠀⢠⣿⣿⣿⣦⠀⠘⡆⠀⠀⠀⢰⠇⠀⣼⣿⣿⣿⡄⠀⢹⠀⠀⠙⢿⣄⠀⠀⠀⠀⠀⠀
//⠀⠀⠀⣼⡟⠀⠀⠀⡇⠀⢸⣿⣿⣿⣿⠆⠀⡧⠀⠀⠀⠸⡆⠀⣿⣿⣿⣿⡇⠀⢸⠇⠀⠀⠈⣿⡀⠀⠀⠀⠀⠀
//⠀⠀⠀⣿⠀⠀⠀⠀⢻⡀⠘⣿⣿⣿⡿⠀⢀⠟⠦⢤⣀⡀⢳⠀⠘⢿⣿⠟⠀⠀⡼⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀
//⠀⠀⠀⢿⡆⠀⠀⠀⠀⢳⡀⠈⠉⠉⠀⢀⡞⠀⠀⠀⠈⠉⠙⠳⣄⠀⠀⠀⣠⣾⣁⣀⣀⣀⣠⣿⣤⣀⠀⠀⠀⠀
//⠀⠀⣀⣼⣿⡄⠀⠀⠀⠀⠙⠲⠤⠤⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⡉⡉⠁⠀⠀⠀⠀⠀⠀⠀⠉⠛⢷⣦⠀⠀
//⣠⣾⠟⠉⠀⠙⢦⡀⠀⠀⠀⠀⣴⠒⠒⠲⠤⠤⠤⠴⠖⠒⠒⠒⠊⠉⢉⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⠀
//⢰⡟⠁⠀⠀⠀⠀⠀⠉⠳⢤⣀⠀⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿
//⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠲⢤⣀⡙⠲⠤⠤⣤⣤⠤⠴⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡇
//⢻⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠓⠲⠤⢤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠀
//⠀⠙⢷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣠⣭⣽⣿⠶⠶⠶⣶⣤⣤⣤⣤⣤⣤⣤⣶⠿⠛⠀⠀
//⠀⠀⠀⢉⣙⡛⠿⠷⠶⢶⣶⣶⣶⡶⠶⠶⠾⠿⠟⠛⠛⠋⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠁⠀⠀⠀⠀⠀


// Don’t Buy Poo is a Free Mint NFT Project

// 10,000 Poos have been Programmatically Plopped from a variety of Shitty Traits. From Devil Wings, to Sweet Corn Pieces, as in life, no two Poos are the same.

// Website - DontBuyPoo.wtf
// Opensea - opensea.io/collection/dont-buy-poo
// Twitter - twitter.com/DontBuyPoo

// This Token is crap - don’t buy it!   #dontbuypoo
// 0 Tax - Renounced - Initial 1 Month Lock 

// You want a Telegram… then make your own Shit Heads

pragma solidity ^0.8.10;

import "Ownable.sol";
import "ERC20.sol";

contract SimpleToken is ERC20, Ownable {
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply_
    ) ERC20(name, symbol) {
        _mint(msg.sender, totalSupply_);
    }

}