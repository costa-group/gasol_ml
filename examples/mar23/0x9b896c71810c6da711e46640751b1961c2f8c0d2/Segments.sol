// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Utilities.sol";
import "./Base64.sol";

library segments {

    function getBaseColorName(uint index) internal pure returns (string memory) {
        string[4] memory baseColorNames = ["White", "Red", "Green", "Blue"];
        return baseColorNames[index];
    }

    function getMetadata(uint tokenId, uint256 value, uint baseColor, bool burned, bytes memory _svgPrefix) internal pure returns (string memory) {
        uint[3] memory rgbs = utils.getRgbs(tokenId, baseColor);
        string memory json;

        if (burned) {
            json = string(abi.encodePacked(
            '{"name": "TIME ',
            utils.uint2str(tokenId),
            ' [BURNED]", "description": "Time is the ultimate currency.", "attributes":[{"trait_type": "Burned", "value": "Yes"}], "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(renderSvg(value, rgbs, _svgPrefix))),
            '"}'
        ));
        } else {
            json = string(abi.encodePacked(
            '{"name": "TIME ',
            utils.uint2str(tokenId),
            '", "description": "Time is the ultimate currency.", "attributes":[{"trait_type": "Balance", "max_value": 315359999999, "value": ',
            utils.uint2str(value),
            '},{"display_type": "number", "trait_type": "Mint Phase", "value": ',
            utils.uint2str(utils.getMintPhase(tokenId)),
            '},{"trait_type": "Burned", "value": "No"},{"trait_type": "Base Color", "value": "',
            getBaseColorName(baseColor),
            '"},{"trait_type": "Color", "value": "RGB(',
            utils.uint2str(rgbs[0]),
            ",",
            utils.uint2str(rgbs[1]),
            ",",
            utils.uint2str(rgbs[2]),
            ')"}], "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(renderSvg(value, rgbs, _svgPrefix))),
            '"}'
        ));
        }

        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }

    function getNumberStyle(uint position, uint _value) internal pure returns (string memory) {
        string memory p = utils.uint2str(position);
        if (_value == 0) {
            return string(abi.encodePacked(
                "#p",p,"1,","#p",p,"2,","#p",p,"3,","#p",p,"5,","#p",p,"6,","#p",p,"7 {fill-opacity:1}"
            ));
        } else if (_value == 1) {
            return string(abi.encodePacked(
                "#p",p,"3,","#p",p,"6 {fill-opacity:1}"
            ));
        } else if (_value == 2) {
            return string(abi.encodePacked(
                "#p",p,"1,","#p",p,"3,","#p",p,"4,","#p",p,"5,","#p",p,"7 {fill-opacity:1}"
            ));
        } else if (_value == 3) {
            return string(abi.encodePacked(
                "#p",p,"1,","#p",p,"3,","#p",p,"4,","#p",p,"6,","#p",p,"7 {fill-opacity:1}"
            ));
        } else if (_value == 4) {
            return string(abi.encodePacked(
                "#p",p,"2,","#p",p,"3,","#p",p,"4,","#p",p,"6 {fill-opacity:1}"
            ));
        } else if (_value == 5) {
            return string(abi.encodePacked(
                "#p",p,"1,","#p",p,"2,","#p",p,"4,","#p",p,"6,","#p",p,"7 {fill-opacity:1}"
            ));
        } else if (_value == 6) {
            return string(abi.encodePacked(
                "#p",p,"1,","#p",p,"2,","#p",p,"4,","#p",p,"5,","#p",p,"6,","#p",p,"7 {fill-opacity:1}"
            ));
        } else if (_value == 7) {
            return string(abi.encodePacked(
                "#p",p,"1,","#p",p,"3,","#p",p,"6 {fill-opacity:1}"
            ));
        } else if (_value == 8) {
            return string(abi.encodePacked(
                "#p",p,"1,","#p",p,"2,","#p",p,"3,","#p",p,"4,","#p",p,"5,","#p",p,"6,","#p",p,"7 {fill-opacity:1}"
            ));
        } else if (_value == 9) {
            return string(abi.encodePacked(
                "#p",p,"1,","#p",p,"2,","#p",p,"3,","#p",p,"4,","#p",p,"6,","#p",p,"7 {fill-opacity:1}"
            ));
        } else {
            return "error";
        }
    }

    function renderSvg(uint256 value,uint256[3] memory rgbs, bytes memory _svgPrefix) internal pure returns (string memory svg) {
        svg = string(_svgPrefix);

        string memory styles = string(
            abi.encodePacked(
                "path[id^='p']{fill:rgb(",
                utils.uint2str(rgbs[0]),
                ",",
                utils.uint2str(rgbs[1]),
                ",",
                utils.uint2str(rgbs[2]),
                ")}#bg{fill:#0C0C0C}"
            )
        );

        //bytes memory _number = bytes(utils.seconds2str(value));

        uint[13] memory _number = utils.seconds2strv2(value);
        
        styles = string(
            abi.encodePacked(styles, getNumberStyle(0, _number[0]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(1, _number[1]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(2, _number[2]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(3, _number[3]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(4, _number[4]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(5, _number[5]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(6, _number[6]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(7, _number[7]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(8, _number[8]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(9, _number[9]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(10, _number[10]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(11, _number[11]))
        );
        styles = string(
            abi.encodePacked(styles, getNumberStyle(12, _number[12]))
        );
    
        return string(abi.encodePacked(svg, styles, "</style></svg>"));
    }
}