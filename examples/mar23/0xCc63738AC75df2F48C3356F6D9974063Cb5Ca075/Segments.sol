// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Utilities.sol";
import "./Base64.sol";

library segments {

    function getBaseColorName(uint index) internal pure returns (string memory) {
        string[4] memory baseColorNames = ["White", "Red", "Green", "Blue"];
        return baseColorNames[index];
    }

    function getMetadata(uint tokenId) internal pure returns (string memory) {
        uint baseColor = utils.random(tokenId, 1, 4);
        uint[3] memory rgbs = utils.getRgbs(tokenId, baseColor);
        string memory json = string(abi.encodePacked(
        '{"name": "Neo Check ',
        utils.uint2str(tokenId),
        '", "description": "This artwork may or may not make you rich.", "attributes":[{"display_type": "number", "trait_type": "Mint Phase", "value": ',
        utils.uint2str(utils.getMintPhase(tokenId)),
        '},{"trait_type": "Base Color", "value": "',
        getBaseColorName(baseColor),
        '"},{"trait_type": "Color", "value": "RGB(',
        utils.uint2str(rgbs[0]),
        ",",
        utils.uint2str(rgbs[1]),
        ",",
        utils.uint2str(rgbs[2]),
        ')"}], "image": "data:image/svg+xml;base64,',
        Base64.encode(bytes(renderSvg(rgbs))),
        '"}'
        ));

        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }

    function renderSvg(uint256[3] memory rgbs) internal pure returns (string memory svg) {
        svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 300"><rect width="300" height="300"/><path d="M172.88,100h3.8l-16,100-25.47-52.43-10.16,4.65-1.73-3.27,15.43-7.76,20.78,42.23,13.34-83.42Z" fill="white"/><path d="M241.99,145.73v8.48c-1.99,.07-3.67,.69-5.05,1.87s-2.35,2.92-2.93,5.23c-.58,2.31-.88,6.67-.92,13.09-.03,6.28-.16,10.44-.36,12.49-.38,3.36-1.25,6.17-2.6,8.43-.97,1.66-2.27,2.86-3.9,3.59s-3.83,1.09-6.61,1.09h-2.39v-8.17h1.35c2.88,0,4.81-.64,5.8-1.93,.99-1.29,1.48-4.22,1.48-8.8,0-9.61,.23-15.74,.68-18.38,.59-3.44,1.57-6.14,2.94-8.12s3.15-3.52,5.33-4.63c-3.26-1.91-5.57-4.42-6.92-7.54-1.35-3.12-2.03-8.41-2.03-15.86s-.1-12.15-.31-13.47c-.35-1.84-.99-3.12-1.93-3.85-.94-.73-2.62-1.09-5.05-1.09h-1.35v-8.17h2.39c2.98,0,5.22,.37,6.71,1.12,1.49,.75,2.71,1.83,3.64,3.25,1.28,1.94,2.12,4.21,2.5,6.82s.59,7.41,.62,14.41c.03,6.42,.35,10.79,.94,13.11,.59,2.32,1.57,4.07,2.93,5.23,1.36,1.16,3.04,1.76,5.02,1.8Z" fill="white"/><path d="M58.01,154.27v-8.48c1.99-.07,3.67-.69,5.05-1.87s2.35-2.92,2.93-5.23c.58-2.31,.88-6.67,.92-13.09,.03-6.28,.16-10.44,.36-12.49,.38-3.36,1.25-6.17,2.6-8.43,.97-1.66,2.27-2.86,3.9-3.59s3.83-1.09,6.61-1.09h2.39v8.17h-1.35c-2.88,0-4.81,.64-5.8,1.93-.99,1.29-1.48,4.22-1.48,8.8,0,9.61-.23,15.74-.68,18.38-.59,3.44-1.57,6.14-2.94,8.12-1.37,1.98-3.15,3.52-5.33,4.63,3.26,1.91,5.57,4.42,6.92,7.54s2.03,8.41,2.03,15.86,.1,12.15,.31,13.47c.35,1.84,.99,3.12,1.93,3.85,.94,.73,2.62,1.09,5.05,1.09h1.35v8.17h-2.39c-2.98,0-5.22-.37-6.71-1.12s-2.71-1.83-3.64-3.25c-1.28-1.94-2.12-4.21-2.5-6.81s-.59-7.41-.62-14.41c-.03-6.42-.35-10.79-.94-13.11-.59-2.32-1.57-4.07-2.93-5.23-1.36-1.16-3.04-1.76-5.02-1.79Z" fill="white"/><style>';

        string memory styles = string(
            abi.encodePacked(
                "path{fill:rgb(",
                utils.uint2str(rgbs[0]),
                ",",
                utils.uint2str(rgbs[1]),
                ",",
                utils.uint2str(rgbs[2]),
                ")}"
            )
        );
    
        return string(abi.encodePacked(svg, styles, "</style></svg>"));
    }
}