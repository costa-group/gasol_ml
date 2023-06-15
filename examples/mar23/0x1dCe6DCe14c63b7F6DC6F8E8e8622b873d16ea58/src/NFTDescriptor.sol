// SPDX-License-Identifier: GPL-3.0

/// Based on Nouns

pragma solidity ^0.8.6;

import {Base64} from "base64-sol/base64.sol";
import {iSVGRenderer} from "./interfaces/iSVGRenderer.sol";

library NFTDescriptor {
    struct TokenURIParams {
        string name;
        string description;
        string background;
        string sky;
        string altitude;
        iSVGRenderer.Part[] parts;
    }

    /**
     * notice Construct an ERC721 token URI.
     */
    function constructTokenURI(
        iSVGRenderer renderer,
        TokenURIParams memory params
    ) public view returns (string memory) {
        string memory image = generateSVGImage(
            renderer,
            iSVGRenderer.SVGParams({
                parts: params.parts,
                background: params.background
            })
        );

        //prettier-ignore
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"', params.name, '", ',
                            '"description":"', params.description, '", ',
                            '"image": "', 'data:image/svg+xml;base64,', image, '", ',
                            '"attributes": [',
                            '{"trait_type": "Altitude", "value": ', params.altitude,'},'
                            '{"trait_type": "Sky", "value": "', params.sky,'"}'
                            ']',
                            '}')
                    )
                )
            )
        );
    }

    /**
     * notice Construct an ERC721 token URI.
     */
    function constructBurnedTokenURI(
        string memory tokenId,
        string memory name,
        string memory description
    ) public view returns (string memory) {
        //prettier-ignore
        string memory burnedPlaceholder = "PHN2ZyB3aWR0aD0iMzIwIiBoZWlnaHQ9IjMyMCIgdmlld0JveD0iMCAwIDMyMCAzMjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgc2hhcGUtcmVuZGVyaW5nPSJjcmlzcEVkZ2VzIj48cG9seWdvbiBwb2ludHM9IjMxMCAwIDMwMCAwIDI5MCAwIDI4MCAwIDI3MCAwIDI2MCAwIDI1MCAwIDI0MCAwIDIzMCAwIDIyMCAwIDIxMCAwIDIwMCAwIDE5MCAwIDE4MCAwIDE3MCAwIDE2MCAwIDE1MCAwIDE0MCAwIDEzMCAwIDEyMCAwIDExMCAwIDEwMCAwIDkwIDAgODAgMCA3MCAwIDYwIDAgNTAgMCA0MCAwIDMwIDAgMjAgMCAxMCAwIDAgMCAwIDEwIDAgMjAgMCAzMCAwIDQwIDAgNTAgMCA2MCAwIDcwIDAgODAgMCA5MCAwIDEwMCAwIDExMCAwIDEyMCAwIDEzMCAwIDE0MCAwIDE1MCAwIDE2MCAwIDE3MCAwIDE4MCAwIDE5MCAwIDIwMCAwIDIxMCAwIDIyMCAwIDIzMCAwIDI0MCAwIDI1MCAwIDI2MCAwIDI3MCAwIDI4MCAwIDI5MCAwIDMwMCAwIDMxMCAwIDMyMCAxMCAzMjAgMjAgMzIwIDMwIDMyMCA0MCAzMjAgNTAgMzIwIDYwIDMyMCA3MCAzMjAgODAgMzIwIDkwIDMyMCAxMDAgMzIwIDExMCAzMjAgMTIwIDMyMCAxMzAgMzIwIDE0MCAzMjAgMTUwIDMyMCAxNjAgMzIwIDE3MCAzMjAgMTgwIDMyMCAxOTAgMzIwIDIwMCAzMjAgMjEwIDMyMCAyMjAgMzIwIDIzMCAzMjAgMjQwIDMyMCAyNTAgMzIwIDI2MCAzMjAgMjcwIDMyMCAyODAgMzIwIDI5MCAzMjAgMzAwIDMyMCAzMTAgMzIwIDMyMCAzMjAgMzIwIDMxMCAzMjAgMzAwIDMyMCAyOTAgMzIwIDI4MCAzMjAgMjcwIDMyMCAyNjAgMzIwIDI1MCAzMjAgMjQwIDMyMCAyMzAgMzIwIDIyMCAzMjAgMjEwIDMyMCAyMDAgMzIwIDE5MCAzMjAgMTgwIDMyMCAxNzAgMzIwIDE2MCAzMjAgMTUwIDMyMCAxNDAgMzIwIDEzMCAzMjAgMTIwIDMyMCAxMTAgMzIwIDEwMCAzMjAgOTAgMzIwIDgwIDMyMCA3MCAzMjAgNjAgMzIwIDUwIDMyMCA0MCAzMjAgMzAgMzIwIDIwIDMyMCAxMCAzMjAgMCAzMTAgMCIvPjxyZWN0IHg9IjIwMCIgeT0iMTEwIiB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIHN0eWxlPSJmaWxsOiAjYmUxZTJkOyIvPjxyZWN0IHg9IjIyMCIgeT0iOTAiIHdpZHRoPSIxMCIgaGVpZ2h0PSIxMCIgc3R5bGU9ImZpbGw6ICNiZTFlMmQ7Ii8+PHJlY3QgeD0iMjIwIiB5PSIxMzAiIHdpZHRoPSIxMCIgaGVpZ2h0PSIxMCIgc3R5bGU9ImZpbGw6ICNiZTFlMmQ7Ii8+PHBvbHlnb24gcG9pbnRzPSIyMjAgMTUwIDIxMCAxNTAgMjEwIDE2MCAyMDAgMTYwIDIwMCAxNTAgMjAwIDE0MCAxOTAgMTQwIDE5MCAxMzAgMTkwIDEyMCAxOTAgMTEwIDE4MCAxMTAgMTgwIDEwMCAxODAgOTAgMTcwIDkwIDE3MCAxMDAgMTYwIDEwMCAxNjAgMTEwIDE2MCAxMjAgMTUwIDEyMCAxNTAgMTMwIDE1MCAxNDAgMTQwIDE0MCAxNDAgMTMwIDE0MCAxMjAgMTMwIDEyMCAxMzAgMTMwIDEyMCAxMzAgMTIwIDE0MCAxMTAgMTQwIDExMCAxNTAgMTEwIDE2MCAxMDAgMTYwIDEwMCAxNzAgMTAwIDE4MCAxMDAgMTkwIDEwMCAyMDAgMTEwIDIwMCAxMTAgMjEwIDEyMCAyMTAgMTIwIDIyMCAxMzAgMjIwIDEzMCAyMzAgMTQwIDIzMCAxNTAgMjMwIDE2MCAyMzAgMTcwIDIzMCAxODAgMjMwIDE5MCAyMzAgMTkwIDIyMCAyMDAgMjIwIDIwMCAyMTAgMjEwIDIxMCAyMTAgMjAwIDIyMCAyMDAgMjIwIDE5MCAyMzAgMTkwIDIzMCAxODAgMjMwIDE3MCAyMzAgMTYwIDIyMCAxNjAgMjIwIDE1MCIgc3R5bGU9ImZpbGw6ICNiZTFlMmQ7Ii8+PHJlY3QgeD0iMTQwIiB5PSIxMDAiIHdpZHRoPSIxMCIgaGVpZ2h0PSIxMCIgc3R5bGU9ImZpbGw6ICNiZTFlMmQ7Ii8+PHJlY3QgeD0iMTAwIiB5PSIxMTAiIHdpZHRoPSIxMCIgaGVpZ2h0PSIxMCIgc3R5bGU9ImZpbGw6ICNiZTFlMmQ7Ii8+PHJlY3QgeD0iOTAiIHk9IjEyMCIgd2lkdGg9IjEwIiBoZWlnaHQ9IjEwIiBzdHlsZT0iZmlsbDogI2JlMWUyZDsiLz48L3N2Zz4=";

        //prettier-ignore
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"', string(abi.encodePacked("Burned Pepe ", tokenId)), '", ',
                            '"description":"', description, '", ',
                            '"image": "', 'data:image/svg+xml;base64,', burnedPlaceholder, '"',
                            '}')
                    )
                )
            )
        );
    }

    /**
     * notice Generate an SVG image for use in the ERC721 token URI.
     */
    function generateSVGImage(
        iSVGRenderer renderer,
        iSVGRenderer.SVGParams memory params
    ) public view returns (string memory svg) {
        return Base64.encode(bytes(renderer.generateSVG(params)));
    }
}
