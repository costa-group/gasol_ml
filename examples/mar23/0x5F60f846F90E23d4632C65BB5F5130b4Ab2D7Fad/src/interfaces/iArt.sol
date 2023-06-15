// SPDX-License-Identifier: GPL-3.0

/// Based on Nouns

pragma solidity ^0.8.6;

import {Inflate} from "../libs/Inflate.sol";
import {iInflator} from "./iInflator.sol";

interface iArt {
    error SenderIsNotDescriptor();

    error EmptyPalette();

    error BadPaletteLength();

    error EmptyBytes();

    error BadDecompressedLength();

    error BadImageCount();

    error ImageNotFound();

    error PaletteNotFound();

    event DescriptorUpdated(address oldDescriptor, address newDescriptor);

    event InflatorUpdated(address oldInflator, address newInflator);

    event BackgroundsAdded(uint256 count);

    event PaletteSet(uint8 paletteIndex);

    event SkiesAdded(uint16 count);

    event PepeAdded(uint16 count);

    event AltitudesAdded(uint16 count);

    struct ArtStoragePage {
        uint16 imageCount;
        uint80 decompressedLength;
        address pointer;
    }

    struct Trait {
        ArtStoragePage[] storagePages;
        uint256 storedImagesCount;
    }

    function descriptor() external view returns (address);

    function inflator() external view returns (iInflator);

    function setDescriptor(address descriptor) external;

    function setInflator(iInflator inflator) external;

    function addManyBackgrounds(string[] calldata _backgrounds) external;

    function addBackground(string calldata _background) external;

    function palettes(uint8 paletteIndex) external view returns (bytes memory);

    function setPalette(uint8 paletteIndex, bytes calldata palette) external;

    function addSkies(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addPepe(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addAltitudes(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addSkiesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function setPalettePointer(uint8 paletteIndex, address pointer) external;

    function addPepeFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addAltitudesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function backgroundsCount() external view returns (uint256);

    function backgrounds(uint256 index) external view returns (string memory);

    function pepe(uint256 index) external view returns (bytes memory);

    function skies(uint256 index) external view returns (bytes memory);

    function altitudes(uint256 index) external view returns (bytes memory);

    function getSkiesTrait() external view returns (Trait memory);

    function getPepeTrait() external view returns (Trait memory);

    function getAltitudesTrait() external view returns (Trait memory);
}
