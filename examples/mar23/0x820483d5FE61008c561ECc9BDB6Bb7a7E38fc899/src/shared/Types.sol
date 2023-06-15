//SPDX-License-Identifier: MIT
// 
// 
// **,,,
// ,,,,,,,
// *,,,*,,,,
// ,,,*,,,,,,,*
// ,,,,,****,,,*
// ,,,,#(**%,,
// *,,,*,****
// ,,**(,,,,,**,,,
// ,,,****,,,,,,,,,*,,*(
// ,,,,#,,,,,,*,*,,,,,,,,,,,,,,,,,
// **,**,,,,,,,*****,,***,,,,,,,*,,*
// (,******#(**,,,,**,,,,,,*
// ,,,,*****(,,,,,,**(,,,,,,,,
// *,,,,,,,/(,,,*,,,,,,,,,,(***,,*/*
// ,,,,,**#,,,,,,,,,,,,,,,,,###
// ****#(,,,,,,,,,,,,,,,,,,,,,,,,*,,#
// (***,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,##
// #,,,,,,,,,,,*,****,,,,,,,,,***,,,,,,
// #,,,,,,**,,,,,,,,,,,,,,******,,*****(
// #***,,,,*,***,*******,,*****,****(***
// #***,,,**,********(*(((
// #*************,*#
// #((*(#
// &&##&&
// &&
// &&&
// &&&
// 
// 
// 
pragma solidity ^0.8.18;

enum Weapon {
    Hammer,
    Sword,
    Spear,
    Bow,
    Fart
}

struct Duel {
    bytes32 commitmentPlayerA;
    bytes32 commitmentPlayerB;
}

struct JailBreakCommitment {
    uint8 door;
    uint248 blockNumber;
}
