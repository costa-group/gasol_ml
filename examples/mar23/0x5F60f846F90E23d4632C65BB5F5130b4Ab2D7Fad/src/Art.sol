// SPDX-License-Identifier: GPL-3.0

/// Based on Nouns

pragma solidity ^0.8.6;

import {iArt} from "./interfaces/iArt.sol";
import {SSTORE2} from "./libs/SSTORE2.sol";
import {iInflator} from "./interfaces/iInflator.sol";

contract Art is iArt {
    /// notice Current Descriptor address
    address public override descriptor;

    /// notice Current Inflator address
    iInflator public override inflator;

    /// notice Backgrounds (Hex Colors)
    string[] public override backgrounds;

    /// notice Color Palettes (Index => Hex Colors, stored as a contract using SSTORE2)
    mapping(uint8 => address) public palettesPointers;

    /// notice Skies Trait
    Trait public skiesTrait;

    /// notice Pepe Trait
    Trait public pepeTrait;

    /// notice Altitudes Trait
    Trait public altitudesTrait;

    /**
     * notice Require that the sender is the descriptor.
     */
    modifier onlyDescriptor() {
        if (msg.sender != descriptor) {
            revert SenderIsNotDescriptor();
        }
        _;
    }

    constructor(address _descriptor, iInflator _inflator) {
        descriptor = _descriptor;
        inflator = _inflator;
    }

    /**
     * notice Set the descriptor.
     * dev This function can only be called by the current descriptor.
     */
    function setDescriptor(
        address _descriptor
    ) external override onlyDescriptor {
        address oldDescriptor = descriptor;
        descriptor = _descriptor;

        emit DescriptorUpdated(oldDescriptor, descriptor);
    }

    /**
     * notice Set the inflator.
     * dev This function can only be called by the descriptor.
     */
    function setInflator(iInflator _inflator) external override onlyDescriptor {
        address oldInflator = address(inflator);
        inflator = _inflator;

        emit InflatorUpdated(oldInflator, address(_inflator));
    }

    /**
     * notice Get the Trait struct for skies.
     * dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getSkiesTrait() external view override returns (Trait memory) {
        return skiesTrait;
    }

    /**
     * notice Get the Trait struct for pepe.
     * dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getPepeTrait() external view override returns (Trait memory) {
        return pepeTrait;
    }

    /**
     * notice Get the Trait struct for altitudes.
     * dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getAltitudesTrait() external view override returns (Trait memory) {
        return altitudesTrait;
    }

    /**
     * notice Batch add backgrounds.
     * dev This function can only be called by the descriptor.
     */
    function addManyBackgrounds(
        string[] calldata _backgrounds
    ) external override onlyDescriptor {
        for (uint256 i = 0; i < _backgrounds.length; i++) {
            _addBackground(_backgrounds[i]);
        }

        emit BackgroundsAdded(_backgrounds.length);
    }

    /**
     * notice Add a background.
     * dev This function can only be called by the descriptor.
     */
    function addBackground(
        string calldata _background
    ) external override onlyDescriptor {
        _addBackground(_background);

        emit BackgroundsAdded(1);
    }

    /**
     * notice Update a single color palette. This function can be used to
     * add a new color palette or update an existing palette.
     * param paletteIndex the identifier of this palette
     * param palette byte array of colors. every 3 bytes represent an RGB color. max length: 256 * 3 = 768
     * dev This function can only be called by the descriptor.
     */
    function setPalette(
        uint8 paletteIndex,
        bytes calldata palette
    ) external override onlyDescriptor {
        if (palette.length == 0) {
            revert EmptyPalette();
        }
        if (palette.length % 3 != 0 || palette.length > 768) {
            revert BadPaletteLength();
        }
        palettesPointers[paletteIndex] = SSTORE2.write(palette);

        emit PaletteSet(paletteIndex);
    }

    /**
     * notice Add a batch of sky images.
     * param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * param imageCount the number of images in this batch; used when searching for images among batches.
     * dev This function can only be called by the descriptor.
     */
    function addSkies(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(skiesTrait, encodedCompressed, decompressedLength, imageCount);

        emit SkiesAdded(imageCount);
    }

    /**
     * notice Add a batch of pepe images.
     * param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * param imageCount the number of images in this batch; used when searching for images among batches.
     * dev This function can only be called by the descriptor.
     */
    function addPepe(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(pepeTrait, encodedCompressed, decompressedLength, imageCount);

        emit PepeAdded(imageCount);
    }

    /**
     * notice Add a batch of altitudes images.
     * param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * param imageCount the number of images in this batch; used when searching for images among batches.
     * dev This function can only be called by the descriptor.
     */
    function addAltitudes(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(
            altitudesTrait,
            encodedCompressed,
            decompressedLength,
            imageCount
        );

        emit AltitudesAdded(imageCount);
    }

    /**
     * notice Update a single color palette. This function can be used to
     * add a new color palette or update an existing palette. This function does not check for data length validity
     * (len <= 768, len % 3 == 0).
     * param paletteIndex the identifier of this palette
     * param pointer the address of the contract holding the palette bytes. every 3 bytes represent an RGB color.
     * max length: 256 * 3 = 768.
     * dev This function can only be called by the descriptor.
     */
    function setPalettePointer(
        uint8 paletteIndex,
        address pointer
    ) external override onlyDescriptor {
        palettesPointers[paletteIndex] = pointer;

        emit PaletteSet(paletteIndex);
    }

    /**
     * notice Add a batch of sky images from an existing storage contract.
     * param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * param imageCount the number of images in this batch; used when searching for images among batches.
     * dev This function can only be called by the descriptor.
     */
    function addSkiesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(skiesTrait, pointer, decompressedLength, imageCount);

        emit SkiesAdded(imageCount);
    }

    /**
     * notice Add a batch of pepe images from an existing storage contract.
     * param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * param imageCount the number of images in this batch; used when searching for images among batches
     * dev This function can only be called by the descriptor..
     */
    function addPepeFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(pepeTrait, pointer, decompressedLength, imageCount);

        emit PepeAdded(imageCount);
    }

    /**
     * notice Add a batch of altitudes images from an existing storage contract.
     * param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * param imageCount the number of images in this batch; used when searching for images among batches.
     * dev This function can only be called by the descriptor.
     */
    function addAltitudesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(altitudesTrait, pointer, decompressedLength, imageCount);

        emit AltitudesAdded(imageCount);
    }

    /**
     * notice Get the number of available `backgrounds`.
     */
    function backgroundsCount() public view override returns (uint256) {
        return backgrounds.length;
    }

    /**
     * notice Get a pepe image bytes (RLE-encoded).
     */
    function pepe(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(pepeTrait, index);
    }

    /**
     * notice Get a sky image bytes (RLE-encoded).
     */
    function skies(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(skiesTrait, index);
    }

    /**
     * notice Get a altitudes image bytes (RLE-encoded).
     */
    function altitudes(
        uint256 index
    ) public view override returns (bytes memory) {
        return imageByIndex(altitudesTrait, index);
    }

    /**
     * notice Get a color palette bytes.
     */
    function palettes(
        uint8 paletteIndex
    ) public view override returns (bytes memory) {
        address pointer = palettesPointers[paletteIndex];
        if (pointer == address(0)) {
            revert PaletteNotFound();
        }
        return SSTORE2.read(palettesPointers[paletteIndex]);
    }

    function _addBackground(string calldata _background) internal {
        backgrounds.push(_background);
    }

    function addPage(
        Trait storage trait,
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) internal {
        if (encodedCompressed.length == 0) {
            revert EmptyBytes();
        }
        address pointer = SSTORE2.write(encodedCompressed);
        addPage(trait, pointer, decompressedLength, imageCount);
    }

    function addPage(
        Trait storage trait,
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) internal {
        if (decompressedLength == 0) {
            revert BadDecompressedLength();
        }
        if (imageCount == 0) {
            revert BadImageCount();
        }
        trait.storagePages.push(
            ArtStoragePage({
                pointer: pointer,
                decompressedLength: decompressedLength,
                imageCount: imageCount
            })
        );
        trait.storedImagesCount += imageCount;
    }

    function imageByIndex(
        iArt.Trait storage trait,
        uint256 index
    ) internal view returns (bytes memory) {
        (iArt.ArtStoragePage storage page, uint256 indexInPage) = getPage(
            trait.storagePages,
            index
        );
        bytes[] memory decompressedImages = decompressAndDecode(page);
        return decompressedImages[indexInPage];
    }

    /**
     * dev Given an image index, this function finds the storage page the image is in, and the relative index
     * inside the page, so the image can be read from storage.
     * Example: if you have 2 pages with 100 images each, and you want to get image 150, this function would return
     * the 2nd page, and the 50th index.
     * return iArt.ArtStoragePage the page containing the image at index
     * return uint256 the index of the image in the page
     */
    function getPage(
        iArt.ArtStoragePage[] storage pages,
        uint256 index
    ) internal view returns (iArt.ArtStoragePage storage, uint256) {
        uint256 len = pages.length;
        uint256 pageFirstImageIndex = 0;
        for (uint256 i = 0; i < len; i++) {
            iArt.ArtStoragePage storage page = pages[i];

            if (index < pageFirstImageIndex + page.imageCount) {
                return (page, index - pageFirstImageIndex);
            }

            pageFirstImageIndex += page.imageCount;
        }

        revert ImageNotFound();
    }

    function decompressAndDecode(
        iArt.ArtStoragePage storage page
    ) internal view returns (bytes[] memory) {
        bytes memory compressedData = SSTORE2.read(page.pointer);
        (, bytes memory decompressedData) = inflator.puff(
            compressedData,
            page.decompressedLength
        );
        return abi.decode(decompressedData, (bytes[]));
    }
}
