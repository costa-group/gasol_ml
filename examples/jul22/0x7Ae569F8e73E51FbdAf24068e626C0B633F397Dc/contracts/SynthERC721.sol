// SPDX-License-Identifier: AGPL-3.0

pragma solidity ^0.8.0;

import "./types/WeedWarsERC721.sol";

contract SynthERC721 is WeedWarsERC721 {

    constructor() WeedWarsERC721("Synthicants", "SYNTH") {}
}
