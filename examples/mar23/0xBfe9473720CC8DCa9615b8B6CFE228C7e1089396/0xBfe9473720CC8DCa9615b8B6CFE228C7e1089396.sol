// File: @openzeppelin\contracts\utils\introspection\IERC165.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin\contracts\utils\introspection\ERC165Checker.sol

// OpenZeppelin Contracts (last updated v4.8.0) (utils/introspection/ERC165Checker.sol)

/**
 * @dev Library used to query support of an interface declared via {IERC165}.
 *
 * Note that these functions return the actual result of the query: they do not
 * `revert` if an interface is not supported. It is up to the caller to decide
 * what to do in these cases.
 */
library ERC165Checker {
    // As per the EIP-165 spec, no interface should ever match 0xffffffff
    bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;

    /**
     * @dev Returns true if `account` supports the {IERC165} interface.
     */
    function supportsERC165(address account) internal view returns (bool) {
        // Any contract that implements ERC165 must explicitly indicate support of
        // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
        return
            supportsERC165InterfaceUnchecked(account, type(IERC165).interfaceId) &&
            !supportsERC165InterfaceUnchecked(account, _INTERFACE_ID_INVALID);
    }

    /**
     * @dev Returns true if `account` supports the interface defined by
     * `interfaceId`. Support for {IERC165} itself is queried automatically.
     *
     * See {IERC165-supportsInterface}.
     */
    function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
        // query support of both ERC165 as per the spec and support of _interfaceId
        return supportsERC165(account) && supportsERC165InterfaceUnchecked(account, interfaceId);
    }

    /**
     * @dev Returns a boolean array where each value corresponds to the
     * interfaces passed in and whether they're supported or not. This allows
     * you to batch check interfaces for a contract where your expectation
     * is that some interfaces may not be supported.
     *
     * See {IERC165-supportsInterface}.
     *
     * _Available since v3.4._
     */
    function getSupportedInterfaces(address account, bytes4[] memory interfaceIds)
        internal
        view
        returns (bool[] memory)
    {
        // an array of booleans corresponding to interfaceIds and whether they're supported or not
        bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);

        // query support of ERC165 itself
        if (supportsERC165(account)) {
            // query support of each interface in interfaceIds
            for (uint256 i = 0; i < interfaceIds.length; i++) {
                interfaceIdsSupported[i] = supportsERC165InterfaceUnchecked(account, interfaceIds[i]);
            }
        }

        return interfaceIdsSupported;
    }

    /**
     * @dev Returns true if `account` supports all the interfaces defined in
     * `interfaceIds`. Support for {IERC165} itself is queried automatically.
     *
     * Batch-querying can lead to gas savings by skipping repeated checks for
     * {IERC165} support.
     *
     * See {IERC165-supportsInterface}.
     */
    function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
        // query support of ERC165 itself
        if (!supportsERC165(account)) {
            return false;
        }

        // query support of each interface in interfaceIds
        for (uint256 i = 0; i < interfaceIds.length; i++) {
            if (!supportsERC165InterfaceUnchecked(account, interfaceIds[i])) {
                return false;
            }
        }

        // all interfaces supported
        return true;
    }

    /**
     * @notice Query if a contract implements an interface, does not check ERC165 support
     * @param account The address of the contract to query for support of an interface
     * @param interfaceId The interface identifier, as specified in ERC-165
     * @return true if the contract at account indicates support of the interface with
     * identifier interfaceId, false otherwise
     * @dev Assumes that account contains a contract that supports ERC165, otherwise
     * the behavior of this method is undefined. This precondition can be checked
     * with {supportsERC165}.
     * Interface identification is specified in ERC-165.
     */
    function supportsERC165InterfaceUnchecked(address account, bytes4 interfaceId) internal view returns (bool) {
        // prepare call
        bytes memory encodedParams = abi.encodeWithSelector(IERC165.supportsInterface.selector, interfaceId);

        // perform static call
        bool success;
        uint256 returnSize;
        uint256 returnValue;
        assembly {
            success := staticcall(30000, account, add(encodedParams, 0x20), mload(encodedParams), 0x00, 0x20)
            returnSize := returndatasize()
            returnValue := mload(0x00)
        }

        return success && returnSize >= 0x20 && returnValue > 0;
    }
}

// File: contracts\libs\WitnetBuffer.sol

/// @title A convenient wrapper around the `bytes memory` type that exposes a buffer-like interface
/// @notice The buffer has an inner cursor that tracks the final offset of every read, i.e. any subsequent read will
/// start with the byte that goes right after the last one in the previous read.
/// @dev `uint32` is used here for `cursor` because `uint16` would only enable seeking up to 8KB, which could in some
/// theoretical use cases be exceeded. Conversely, `uint32` supports up to 512MB, which cannot credibly be exceeded.
/// @author The Witnet Foundation.
library WitnetBuffer {

  error EmptyBuffer();
  error IndexOutOfBounds(uint index, uint range);
  error MissingArgs(uint expected, uint given);

  /// Iterable bytes buffer.
  struct Buffer {
      bytes data;
      uint cursor;
  }

  // Ensures we access an existing index in an array
  modifier withinRange(uint index, uint _range) {
    if (index >= _range) {
      revert IndexOutOfBounds(index, _range);
    }
    _;
  }

  /// @notice Concatenate undefinite number of bytes chunks.
  /// @dev Faster than looping on `abi.encodePacked(output, _buffs[ix])`.
  function concat(bytes[] memory _buffs)
    internal pure
    returns (bytes memory output)
  {
    unchecked {
      uint destinationPointer;
      uint destinationLength;
      assembly {
        // get safe scratch location
        output := mload(0x40)
        // set starting destination pointer
        destinationPointer := add(output, 32)
      }      
      for (uint ix = 1; ix <= _buffs.length; ix ++) {  
        uint source;
        uint sourceLength;
        uint sourcePointer;        
        assembly {
          // load source length pointer
          source := mload(add(_buffs, mul(ix, 32)))
          // load source length
          sourceLength := mload(source)
          // sets source memory pointer
          sourcePointer := add(source, 32)
        }
        _memcpy(
          destinationPointer,
          sourcePointer,
          sourceLength
        );
        assembly {          
          // increase total destination length
          destinationLength := add(destinationLength, sourceLength)
          // sets destination memory pointer
          destinationPointer := add(destinationPointer, sourceLength)
        }
      }
      assembly {
        // protect output bytes
        mstore(output, destinationLength)
        // set final output length
        mstore(0x40, add(mload(0x40), add(destinationLength, 32)))
      }
    }
  }

  function fork(WitnetBuffer.Buffer memory buffer)
    internal pure
    returns (WitnetBuffer.Buffer memory)
  {
    return Buffer(
      buffer.data,
      buffer.cursor
    );
  }

  function mutate(
      WitnetBuffer.Buffer memory buffer,
      uint length,
      bytes memory pokes
    )
    internal pure
    withinRange(length, buffer.data.length - buffer.cursor)
  {
    bytes[] memory parts = new bytes[](3);
    parts[0] = peek(
      buffer,
      0,
      buffer.cursor
    );
    parts[1] = pokes;
    parts[2] = peek(
      buffer,
      buffer.cursor + length,
      buffer.data.length - buffer.cursor - length
    );
    buffer.data = concat(parts);
  }

  /// @notice Read and consume the next byte from the buffer.
  /// @param buffer An instance of `Buffer`.
  /// @return The next byte in the buffer counting from the cursor position.
  function next(Buffer memory buffer)
    internal pure
    withinRange(buffer.cursor, buffer.data.length)
    returns (bytes1)
  {
    // Return the byte at the position marked by the cursor and advance the cursor all at once
    return buffer.data[buffer.cursor ++];
  }

  function peek(
      WitnetBuffer.Buffer memory buffer,
      uint offset,
      uint length
    )
    internal pure
    withinRange(offset + length, buffer.data.length + 1)
    returns (bytes memory)
  {
    bytes memory data = buffer.data;
    bytes memory peeks = new bytes(length);
    uint destinationPointer;
    uint sourcePointer;
    assembly {
      destinationPointer := add(peeks, 32)
      sourcePointer := add(add(data, 32), offset)
    }
    _memcpy(
      destinationPointer,
      sourcePointer,
      length
    );
    return peeks;
  }

  // @notice Extract bytes array from buffer starting from current cursor.
  /// @param buffer An instance of `Buffer`.
  /// @param length How many bytes to peek from the Buffer.
  // solium-disable-next-line security/no-assign-params
  function peek(
      WitnetBuffer.Buffer memory buffer,
      uint length
    )
    internal pure
    withinRange(length, buffer.data.length - buffer.cursor)
    returns (bytes memory)
  {
    return peek(
      buffer,
      buffer.cursor,
      length
    );
  }

  /// @notice Read and consume a certain amount of bytes from the buffer.
  /// @param buffer An instance of `Buffer`.
  /// @param length How many bytes to read and consume from the buffer.
  /// @return output A `bytes memory` containing the first `length` bytes from the buffer, counting from the cursor position.
  function read(Buffer memory buffer, uint length)
    internal pure
    withinRange(buffer.cursor + length, buffer.data.length + 1)
    returns (bytes memory output)
  {
    // Create a new `bytes memory destination` value
    output = new bytes(length);
    // Early return in case that bytes length is 0
    if (length > 0) {
      bytes memory input = buffer.data;
      uint offset = buffer.cursor;
      // Get raw pointers for source and destination
      uint sourcePointer;
      uint destinationPointer;
      assembly {
        sourcePointer := add(add(input, 32), offset)
        destinationPointer := add(output, 32)
      }
      // Copy `length` bytes from source to destination
      _memcpy(
        destinationPointer,
        sourcePointer,
        length
      );
      // Move the cursor forward by `length` bytes
      seek(
        buffer,
        length,
        true
      );
    }
  }
  
  /// @notice Read and consume the next 2 bytes from the buffer as an IEEE 754-2008 floating point number enclosed in an
  /// `int32`.
  /// @dev Due to the lack of support for floating or fixed point arithmetic in the EVM, this method offsets all values
  /// by 5 decimal orders so as to get a fixed precision of 5 decimal positions, which should be OK for most `float16`
  /// use cases. In other words, the integer output of this method is 10,000 times the actual value. The input bytes are
  /// expected to follow the 16-bit base-2 format (a.k.a. `binary16`) in the IEEE 754-2008 standard.
  /// @param buffer An instance of `Buffer`.
  /// @return result The `int32` value of the next 4 bytes in the buffer counting from the cursor position.
  function readFloat16(Buffer memory buffer)
    internal pure
    returns (int32 result)
  {
    uint32 value = readUint16(buffer);
    // Get bit at position 0
    uint32 sign = value & 0x8000;
    // Get bits 1 to 5, then normalize to the [-14, 15] range so as to counterweight the IEEE 754 exponent bias
    int32 exponent = (int32(value & 0x7c00) >> 10) - 15;
    // Get bits 6 to 15
    int32 significand = int32(value & 0x03ff);
    // Add 1024 to the fraction if the exponent is 0
    if (exponent == 15) {
      significand |= 0x400;
    }
    // Compute `2 ^ exponent · (1 + fraction / 1024)`
    if (exponent >= 0) {
      result = (
        int32((int256(1 << uint256(int256(exponent)))
          * 10000
          * int256(uint256(int256(significand)) | 0x400)) >> 10)
      );
    } else {
      result = (int32(
        ((int256(uint256(int256(significand)) | 0x400) * 10000)
          / int256(1 << uint256(int256(- exponent))))
          >> 10
      ));
    }
    // Make the result negative if the sign bit is not 0
    if (sign != 0) {
      result *= -1;
    }
  }

  // Read a text string of a given length from a buffer. Returns a `bytes memory` value for the sake of genericness,
  /// but it can be easily casted into a string with `string(result)`.
  // solium-disable-next-line security/no-assign-params
  function readText(
      WitnetBuffer.Buffer memory buffer,
      uint64 length
    )
    internal pure
    returns (bytes memory text)
  {
    text = new bytes(length);
    unchecked {
      for (uint64 index = 0; index < length; index ++) {
        uint8 char = readUint8(buffer);
        if (char & 0x80 != 0) {
          if (char < 0xe0) {
            char = (char & 0x1f) << 6
              | (readUint8(buffer) & 0x3f);
            length -= 1;
          } else if (char < 0xf0) {
            char  = (char & 0x0f) << 12
              | (readUint8(buffer) & 0x3f) << 6
              | (readUint8(buffer) & 0x3f);
            length -= 2;
          } else {
            char = (char & 0x0f) << 18
              | (readUint8(buffer) & 0x3f) << 12
              | (readUint8(buffer) & 0x3f) << 6  
              | (readUint8(buffer) & 0x3f);
            length -= 3;
          }
        }
        text[index] = bytes1(char);
      }
      // Adjust text to actual length:
      assembly {
        mstore(text, length)
      }
    }
  }

  /// @notice Read and consume the next byte from the buffer as an `uint8`.
  /// @param buffer An instance of `Buffer`.
  /// @return value The `uint8` value of the next byte in the buffer counting from the cursor position.
  function readUint8(Buffer memory buffer)
    internal pure
    withinRange(buffer.cursor, buffer.data.length)
    returns (uint8 value)
  {
    bytes memory data = buffer.data;
    uint offset = buffer.cursor;
    assembly {
      value := mload(add(add(data, 1), offset))
    }
    buffer.cursor ++;
  }

  /// @notice Read and consume the next 2 bytes from the buffer as an `uint16`.
  /// @param buffer An instance of `Buffer`.
  /// @return value The `uint16` value of the next 2 bytes in the buffer counting from the cursor position.
  function readUint16(Buffer memory buffer)
    internal pure
    withinRange(buffer.cursor + 1, buffer.data.length)
    returns (uint16 value)
  {
    bytes memory data = buffer.data;
    uint offset = buffer.cursor;
    assembly {
      value := mload(add(add(data, 2), offset))
    }
    buffer.cursor += 2;
  }

  /// @notice Read and consume the next 4 bytes from the buffer as an `uint32`.
  /// @param buffer An instance of `Buffer`.
  /// @return value The `uint32` value of the next 4 bytes in the buffer counting from the cursor position.
  function readUint32(Buffer memory buffer)
    internal pure
    withinRange(buffer.cursor + 3, buffer.data.length)
    returns (uint32 value)
  {
    bytes memory data = buffer.data;
    uint offset = buffer.cursor;
    assembly {
      value := mload(add(add(data, 4), offset))
    }
    buffer.cursor += 4;
  }

  /// @notice Read and consume the next 8 bytes from the buffer as an `uint64`.
  /// @param buffer An instance of `Buffer`.
  /// @return value The `uint64` value of the next 8 bytes in the buffer counting from the cursor position.
  function readUint64(Buffer memory buffer)
    internal pure
    withinRange(buffer.cursor + 7, buffer.data.length)
    returns (uint64 value)
  {
    bytes memory data = buffer.data;
    uint offset = buffer.cursor;
    assembly {
      value := mload(add(add(data, 8), offset))
    }
    buffer.cursor += 8;
  }

  /// @notice Read and consume the next 16 bytes from the buffer as an `uint128`.
  /// @param buffer An instance of `Buffer`.
  /// @return value The `uint128` value of the next 16 bytes in the buffer counting from the cursor position.
  function readUint128(Buffer memory buffer)
    internal pure
    withinRange(buffer.cursor + 15, buffer.data.length)
    returns (uint128 value)
  {
    bytes memory data = buffer.data;
    uint offset = buffer.cursor;
    assembly {
      value := mload(add(add(data, 16), offset))
    }
    buffer.cursor += 16;
  }

  /// @notice Read and consume the next 32 bytes from the buffer as an `uint256`.
  /// @param buffer An instance of `Buffer`.
  /// @return value The `uint256` value of the next 32 bytes in the buffer counting from the cursor position.
  function readUint256(Buffer memory buffer)
    internal pure
    withinRange(buffer.cursor + 31, buffer.data.length)
    returns (uint256 value)
  {
    bytes memory data = buffer.data;
    uint offset = buffer.cursor;
    assembly {
      value := mload(add(add(data, 32), offset))
    }
    buffer.cursor += 32;
  }

  /// @notice Count number of required parameters for given bytes arrays
  /// @dev Wildcard format: "\#\", with # in ["0".."9"].
  /// @param input Bytes array containing strings.
  /// @param count Highest wildcard index found, plus 1.
  function argsCountOf(bytes memory input)
    internal pure
    returns (uint8 count)
  {
    if (input.length < 3) {
      return 0;
    }
    unchecked {
      uint ix = 0; 
      uint length = input.length - 2;
      for (; ix < length; ) {
        if (
          input[ix] == bytes1("\\")
            && input[ix + 2] == bytes1("\\")
            && input[ix + 1] >= bytes1("0")
            && input[ix + 1] <= bytes1("9")
        ) {
          uint8 ax = uint8(uint8(input[ix + 1]) - uint8(bytes1("0")) + 1);
          if (ax > count) {
            count = ax;
          }
          ix += 3;
        } else {
          ix ++;
        }
      }
    }
  }

  /// @notice Replace bytecode indexed wildcards by correspondent string.
  /// @dev Wildcard format: "\#\", with # in ["0".."9"].
  /// @param input Bytes array containing strings.
  /// @param args String values for replacing existing indexed wildcards in input.
  function replace(bytes memory input, string[] memory args)
    internal pure
    returns (bytes memory output)
  {
    uint ix = 0; uint lix = 0;
    uint inputLength;
    uint inputPointer;
    uint outputLength;
    uint outputPointer;    
    uint source;
    uint sourceLength;
    uint sourcePointer;

    if (input.length < 3) {
      return input;
    }
    
    assembly {
      // set starting input pointer
      inputPointer := add(input, 32)
      // get safe output location
      output := mload(0x40)
      // set starting output pointer
      outputPointer := add(output, 32)
    }         

    unchecked {
      uint length = input.length - 2;
      for (; ix < length; ) {
        if (
          input[ix] == bytes1("\\")
            && input[ix + 2] == bytes1("\\")
            && input[ix + 1] >= bytes1("0")
            && input[ix + 1] <= bytes1("9")
        ) {
          inputLength = (ix - lix);
          if (ix > lix) {
            _memcpy(
              outputPointer,
              inputPointer,
              inputLength
            );
            inputPointer += inputLength + 3;
            outputPointer += inputLength;
          } else {
            inputPointer += 3;
          }
          uint ax = uint(uint8(input[ix + 1]) - uint8(bytes1("0")));
          if (ax >= args.length) {
            revert MissingArgs(ax + 1, args.length);
          }
          assembly {
            source := mload(add(args, mul(32, add(ax, 1))))
            sourceLength := mload(source)
            sourcePointer := add(source, 32)      
          }        
          _memcpy(
            outputPointer,
            sourcePointer,
            sourceLength
          );
          outputLength += inputLength + sourceLength;
          outputPointer += sourceLength;
          ix += 3;
          lix = ix;
        } else {
          ix ++;
        }
      }
      ix = input.length;    
    }
    if (outputLength > 0) {
      if (ix > lix ) {
        _memcpy(
          outputPointer,
          inputPointer,
          ix - lix
        );
        outputLength += (ix - lix);
      }
      assembly {
        // set final output length
        mstore(output, outputLength)
        // protect output bytes
        mstore(0x40, add(mload(0x40), add(outputLength, 32)))
      }
    }
    else {
      return input;
    }
  }

  /// @notice Move the inner cursor of the buffer to a relative or absolute position.
  /// @param buffer An instance of `Buffer`.
  /// @param offset How many bytes to move the cursor forward.
  /// @param relative Whether to count `offset` from the last position of the cursor (`true`) or the beginning of the
  /// buffer (`true`).
  /// @return The final position of the cursor (will equal `offset` if `relative` is `false`).
  // solium-disable-next-line security/no-assign-params
  function seek(
      Buffer memory buffer,
      uint offset,
      bool relative
    )
    internal pure
    withinRange(offset, buffer.data.length + 1)
    returns (uint)
  {
    // Deal with relative offsets
    if (relative) {
      offset += buffer.cursor;
    }
    buffer.cursor = offset;
    return offset;
  }

  /// @notice Move the inner cursor a number of bytes forward.
  /// @dev This is a simple wrapper around the relative offset case of `seek()`.
  /// @param buffer An instance of `Buffer`.
  /// @param relativeOffset How many bytes to move the cursor forward.
  /// @return The final position of the cursor.
  function seek(
      Buffer memory buffer,
      uint relativeOffset
    )
    internal pure
    returns (uint)
  {
    return seek(
      buffer,
      relativeOffset,
      true
    );
  }

  /// @notice Copy bytes from one memory address into another.
  /// @dev This function was borrowed from Nick Johnson's `solidity-stringutils` lib, and reproduced here under the terms
  /// of [Apache License 2.0](https://github.com/Arachnid/solidity-stringutils/blob/master/LICENSE).
  /// @param dest Address of the destination memory.
  /// @param src Address to the source memory.
  /// @param len How many bytes to copy.
  // solium-disable-next-line security/no-assign-params
  function _memcpy(
      uint dest,
      uint src,
      uint len
    )
    private pure
  {
    unchecked {
      // Copy word-length chunks while possible
      for (; len >= 32; len -= 32) {
        assembly {
          mstore(dest, mload(src))
        }
        dest += 32;
        src += 32;
      }
      if (len > 0) {
        // Copy remaining bytes
        uint _mask = 256 ** (32 - len) - 1;
        assembly {
          let srcpart := and(mload(src), not(_mask))
          let destpart := and(mload(dest), _mask)
          mstore(dest, or(destpart, srcpart))
        }
      }
    }
  }

}

// File: contracts\libs\WitnetCBOR.sol

/// @title A minimalistic implementation of “RFC 7049 Concise Binary Object Representation”
/// @notice This library leverages a buffer-like structure for step-by-step decoding of bytes so as to minimize
/// the gas cost of decoding them into a useful native type.
/// @dev Most of the logic has been borrowed from Patrick Gansterer’s cbor.js library: https://github.com/paroga/cbor-js
/// @author The Witnet Foundation.
/// 
/// TODO: add support for Map (majorType = 5)
/// TODO: add support for Float32 (majorType = 7, additionalInformation = 26)
/// TODO: add support for Float64 (majorType = 7, additionalInformation = 27) 

library WitnetCBOR {

  using WitnetBuffer for WitnetBuffer.Buffer;
  using WitnetCBOR for WitnetCBOR.CBOR;

  /// Data struct following the RFC-7049 standard: Concise Binary Object Representation.
  struct CBOR {
      WitnetBuffer.Buffer buffer;
      uint8 initialByte;
      uint8 majorType;
      uint8 additionalInformation;
      uint64 len;
      uint64 tag;
  }

  uint8 internal constant MAJOR_TYPE_INT = 0;
  uint8 internal constant MAJOR_TYPE_NEGATIVE_INT = 1;
  uint8 internal constant MAJOR_TYPE_BYTES = 2;
  uint8 internal constant MAJOR_TYPE_STRING = 3;
  uint8 internal constant MAJOR_TYPE_ARRAY = 4;
  uint8 internal constant MAJOR_TYPE_MAP = 5;
  uint8 internal constant MAJOR_TYPE_TAG = 6;
  uint8 internal constant MAJOR_TYPE_CONTENT_FREE = 7;

  uint32 internal constant UINT32_MAX = type(uint32).max;
  uint64 internal constant UINT64_MAX = type(uint64).max;
  
  error EmptyArray();
  error InvalidLengthEncoding(uint length);
  error UnexpectedMajorType(uint read, uint expected);
  error UnsupportedPrimitive(uint primitive);
  error UnsupportedMajorType(uint unexpected);  

  modifier isMajorType(
      WitnetCBOR.CBOR memory cbor,
      uint8 expected
  ) {
    if (cbor.majorType != expected) {
      revert UnexpectedMajorType(cbor.majorType, expected);
    }
    _;
  }

  modifier notEmpty(WitnetBuffer.Buffer memory buffer) {
    if (buffer.data.length == 0) {
      revert WitnetBuffer.EmptyBuffer();
    }
    _;
  }

  function eof(CBOR memory cbor)
    internal pure
    returns (bool)
  {
    return cbor.buffer.cursor >= cbor.buffer.data.length;
  }

  /// @notice Decode a CBOR structure from raw bytes.
  /// @dev This is the main factory for CBOR instances, which can be later decoded into native EVM types.
  /// @param bytecode Raw bytes representing a CBOR-encoded value.
  /// @return A `CBOR` instance containing a partially decoded value.
  function fromBytes(bytes memory bytecode)
    internal pure
    returns (CBOR memory)
  {
    WitnetBuffer.Buffer memory buffer = WitnetBuffer.Buffer(bytecode, 0);
    return fromBuffer(buffer);
  }

  /// @notice Decode a CBOR structure from raw bytes.
  /// @dev This is an alternate factory for CBOR instances, which can be later decoded into native EVM types.
  /// @param buffer A Buffer structure representing a CBOR-encoded value.
  /// @return A `CBOR` instance containing a partially decoded value.
  function fromBuffer(WitnetBuffer.Buffer memory buffer)
    internal pure
    notEmpty(buffer)
    returns (CBOR memory)
  {
    uint8 initialByte;
    uint8 majorType = 255;
    uint8 additionalInformation;
    uint64 tag = UINT64_MAX;
    uint256 len;
    bool isTagged = true;
    while (isTagged) {
      // Extract basic CBOR properties from input bytes
      initialByte = buffer.readUint8();
      len ++;
      majorType = initialByte >> 5;
      additionalInformation = initialByte & 0x1f;
      // Early CBOR tag parsing.
      if (majorType == MAJOR_TYPE_TAG) {
        uint _cursor = buffer.cursor;
        tag = readLength(buffer, additionalInformation);
        len += buffer.cursor - _cursor;
      } else {
        isTagged = false;
      }
    }
    if (majorType > MAJOR_TYPE_CONTENT_FREE) {
      revert UnsupportedMajorType(majorType);
    }
    return CBOR(
      buffer,
      initialByte,
      majorType,
      additionalInformation,
      uint64(len),
      tag
    );
  }

  function fork(WitnetCBOR.CBOR memory self)
    internal pure
    returns (WitnetCBOR.CBOR memory)
  {
    return CBOR({
      buffer: self.buffer.fork(),
      initialByte: self.initialByte,
      majorType: self.majorType,
      additionalInformation: self.additionalInformation,
      len: self.len,
      tag: self.tag
    });
  }

  function settle(CBOR memory self)
      internal pure
      returns (WitnetCBOR.CBOR memory)
  {
    if (!self.eof()) {
      return fromBuffer(self.buffer);
    } else {
      return self;
    }
  }

  function skip(CBOR memory self)
      internal pure
      returns (WitnetCBOR.CBOR memory)
  {
    if (
      self.majorType == MAJOR_TYPE_INT
        || self.majorType == MAJOR_TYPE_NEGATIVE_INT
    ) {
      self.buffer.cursor += self.peekLength();
    } else if (
        self.majorType == MAJOR_TYPE_STRING
          || self.majorType == MAJOR_TYPE_BYTES
    ) {
      uint64 len = readLength(self.buffer, self.additionalInformation);
      self.buffer.cursor += len;
    } else if (
      self.majorType == MAJOR_TYPE_ARRAY
    ) { 
      self.len = readLength(self.buffer, self.additionalInformation);      
    // } else if (
    //   self.majorType == MAJOR_TYPE_CONTENT_FREE
    // ) {
      // TODO
    } else {
      revert UnsupportedMajorType(self.majorType);
    }
    return self;
  }

  function peekLength(CBOR memory self)
    internal pure
    returns (uint64)
  {
    assert(1 << 0 == 1);
    if (self.additionalInformation < 24) {
      return self.additionalInformation;
    } else if (self.additionalInformation > 27) {
      revert InvalidLengthEncoding(self.additionalInformation);
    } else {
      return uint64(1 << (self.additionalInformation - 24));
    }
  }

  // event Array(uint cursor, uint items);
  // event Log2(uint index, bytes data, uint cursor, uint major, uint addinfo, uint len);
  function readArray(CBOR memory self)
    internal pure
    isMajorType(self, MAJOR_TYPE_ARRAY)
    returns (CBOR[] memory items)
  {
    uint64 len = readLength(self.buffer, self.additionalInformation);
    // emit Array(self.buffer.cursor, len);
    items = new CBOR[](len + 1);
    for (uint ix = 0; ix < len; ix ++) {
      items[ix] = self.fork().settle();
      // emit Log2(
      //   ix,
      //   items[ix].buffer.data,
      //   items[ix].buffer.cursor,
      //   items[ix].majorType,
      //   items[ix].additionalInformation,
      //   items[ix].len
      // );
      self.buffer.cursor = items[ix].buffer.cursor;
      self.majorType = items[ix].majorType;
      self.additionalInformation = items[ix].additionalInformation;
      self.len = items[ix].len;
      if (self.majorType == MAJOR_TYPE_ARRAY) {
        CBOR[] memory subitems = self.readArray();
        self = subitems[subitems.length - 1];
      } else {
        self.skip();
      }
    }
    items[len] = self;
  }

  /// Reads the length of the settle CBOR item from a buffer, consuming a different number of bytes depending on the
  /// value of the `additionalInformation` argument.
  function readLength(
      WitnetBuffer.Buffer memory buffer,
      uint8 additionalInformation
    ) 
    internal pure
    returns (uint64)
  {
    if (additionalInformation < 24) {
      return additionalInformation;
    }
    if (additionalInformation == 24) {
      return buffer.readUint8();
    }
    if (additionalInformation == 25) {
      return buffer.readUint16();
    }
    if (additionalInformation == 26) {
      return buffer.readUint32();
    }
    if (additionalInformation == 27) {
      return buffer.readUint64();
    }
    if (additionalInformation == 31) {
      return UINT64_MAX;
    }
    revert InvalidLengthEncoding(additionalInformation);
  }

  /// @notice Read a `CBOR` structure into a native `bool` value.
  /// @param cbor An instance of `CBOR`.
  /// @return The value represented by the input, as a `bool` value.
  function readBool(CBOR memory cbor)
    internal pure
    isMajorType(cbor, MAJOR_TYPE_CONTENT_FREE)
    returns (bool)
  {
    if (cbor.additionalInformation == 20) {
      return false;
    } else if (cbor.additionalInformation == 21) {
      return true;
    } else {
      revert UnsupportedPrimitive(cbor.additionalInformation);
    }
  }

  /// @notice Decode a `CBOR` structure into a native `bytes` value.
  /// @param cbor An instance of `CBOR`.
  /// @return output The value represented by the input, as a `bytes` value.   
  function readBytes(CBOR memory cbor)
    internal pure
    isMajorType(cbor, MAJOR_TYPE_BYTES)
    returns (bytes memory output)
  {
    cbor.len = readLength(
      cbor.buffer,
      cbor.additionalInformation
    );
    if (cbor.len == UINT32_MAX) {
      // These checks look repetitive but the equivalent loop would be more expensive.
      uint32 length = uint32(_readIndefiniteStringLength(
        cbor.buffer,
        cbor.majorType
      ));
      if (length < UINT32_MAX) {
        output = abi.encodePacked(cbor.buffer.read(length));
        length = uint32(_readIndefiniteStringLength(
          cbor.buffer,
          cbor.majorType
        ));
        if (length < UINT32_MAX) {
          output = abi.encodePacked(
            output,
            cbor.buffer.read(length)
          );
        }
      }
    } else {
      return cbor.buffer.read(uint32(cbor.len));
    }
  }

  /// @notice Decode a `CBOR` structure into a `fixed16` value.
  /// @dev Due to the lack of support for floating or fixed point arithmetic in the EVM, this method offsets all values
  /// by 5 decimal orders so as to get a fixed precision of 5 decimal positions, which should be OK for most `fixed16`
  /// use cases. In other words, the output of this method is 10,000 times the actual value, encoded into an `int32`.
  /// @param cbor An instance of `CBOR`.
  /// @return The value represented by the input, as an `int128` value.
  function readFloat16(CBOR memory cbor)
    internal pure
    isMajorType(cbor, MAJOR_TYPE_CONTENT_FREE)
    returns (int32)
  {
    if (cbor.additionalInformation == 25) {
      return cbor.buffer.readFloat16();
    } else {
      revert UnsupportedPrimitive(cbor.additionalInformation);
    }
  }

  /// @notice Decode a `CBOR` structure into a native `int128[]` value whose inner values follow the same convention 
  /// @notice as explained in `decodeFixed16`.
  /// @param cbor An instance of `CBOR`.
  function readFloat16Array(CBOR memory cbor)
    internal pure
    isMajorType(cbor, MAJOR_TYPE_ARRAY)
    returns (int32[] memory values)
  {
    uint64 length = readLength(cbor.buffer, cbor.additionalInformation);
    if (length < UINT64_MAX) {
      values = new int32[](length);
      for (uint64 i = 0; i < length; ) {
        CBOR memory item = fromBuffer(cbor.buffer);
        values[i] = readFloat16(item);
        unchecked {
          i ++;
        }
      }
    } else {
      revert InvalidLengthEncoding(length);
    }
  }

  /// @notice Decode a `CBOR` structure into a native `int128` value.
  /// @param cbor An instance of `CBOR`.
  /// @return The value represented by the input, as an `int128` value.
  function readInt(CBOR memory cbor)
    internal pure
    returns (int)
  {
    if (cbor.majorType == 1) {
      uint64 _value = readLength(
        cbor.buffer,
        cbor.additionalInformation
      );
      return int(-1) - int(uint(_value));
    } else if (cbor.majorType == 0) {
      // Any `uint64` can be safely casted to `int128`, so this method supports majorType 1 as well so as to have offer
      // a uniform API for positive and negative numbers
      return int(readUint(cbor));
    }
    else {
      revert UnexpectedMajorType(cbor.majorType, 1);
    }
  }

  /// @notice Decode a `CBOR` structure into a native `int[]` value.
  /// @param cbor instance of `CBOR`.
  /// @return array The value represented by the input, as an `int[]` value.
  function readIntArray(CBOR memory cbor)
    internal pure
    isMajorType(cbor, MAJOR_TYPE_ARRAY)
    returns (int[] memory array)
  {
    uint64 length = readLength(cbor.buffer, cbor.additionalInformation);
    if (length < UINT64_MAX) {
      array = new int[](length);
      for (uint i = 0; i < length; ) {
        CBOR memory item = fromBuffer(cbor.buffer);
        array[i] = readInt(item);
        unchecked {
          i ++;
        }
      }
    } else {
      revert InvalidLengthEncoding(length);
    }
  }

  /// @notice Decode a `CBOR` structure into a native `string` value.
  /// @param cbor An instance of `CBOR`.
  /// @return text The value represented by the input, as a `string` value.
  function readString(CBOR memory cbor)
    internal pure
    isMajorType(cbor, MAJOR_TYPE_STRING)
    returns (string memory text)
  {
    cbor.len = readLength(cbor.buffer, cbor.additionalInformation);
    if (cbor.len == UINT64_MAX) {
      bool _done;
      while (!_done) {
        uint64 length = _readIndefiniteStringLength(
          cbor.buffer,
          cbor.majorType
        );
        if (length < UINT64_MAX) {
          text = string(abi.encodePacked(
            text,
            cbor.buffer.readText(length / 4)
          ));
        } else {
          _done = true;
        }
      }
    } else {
      return string(cbor.buffer.readText(cbor.len));
    }
  }

  /// @notice Decode a `CBOR` structure into a native `string[]` value.
  /// @param cbor An instance of `CBOR`.
  /// @return strings The value represented by the input, as an `string[]` value.
  function readStringArray(CBOR memory cbor)
    internal pure
    isMajorType(cbor, MAJOR_TYPE_ARRAY)
    returns (string[] memory strings)
  {
    uint length = readLength(cbor.buffer, cbor.additionalInformation);
    if (length < UINT64_MAX) {
      strings = new string[](length);
      for (uint i = 0; i < length; ) {
        CBOR memory item = fromBuffer(cbor.buffer);
        strings[i] = readString(item);
        unchecked {
          i ++;
        }
      }
    } else {
      revert InvalidLengthEncoding(length);
    }
  }

  /// @notice Decode a `CBOR` structure into a native `uint64` value.
  /// @param cbor An instance of `CBOR`.
  /// @return The value represented by the input, as an `uint64` value.
  function readUint(CBOR memory cbor)
    internal pure
    isMajorType(cbor, MAJOR_TYPE_INT)
    returns (uint)
  {
    return readLength(
      cbor.buffer,
      cbor.additionalInformation
    );
  }

  /// @notice Decode a `CBOR` structure into a native `uint64[]` value.
  /// @param cbor An instance of `CBOR`.
  /// @return values The value represented by the input, as an `uint64[]` value.
  function readUintArray(CBOR memory cbor)
    internal pure
    isMajorType(cbor, MAJOR_TYPE_ARRAY)
    returns (uint[] memory values)
  {
    uint64 length = readLength(cbor.buffer, cbor.additionalInformation);
    if (length < UINT64_MAX) {
      values = new uint[](length);
      for (uint ix = 0; ix < length; ) {
        CBOR memory item = fromBuffer(cbor.buffer);
        values[ix] = readUint(item);
        unchecked {
          ix ++;
        }
      }
    } else {
      revert InvalidLengthEncoding(length);
    }
  }  

  /// Read the length of a CBOR indifinite-length item (arrays, maps, byte strings and text) from a buffer, consuming
  /// as many bytes as specified by the first byte.
  function _readIndefiniteStringLength(
      WitnetBuffer.Buffer memory buffer,
      uint8 majorType
    )
    private pure
    returns (uint64 len)
  {
    uint8 initialByte = buffer.readUint8();
    if (initialByte == 0xff) {
      return UINT64_MAX;
    }
    len = readLength(
      buffer,
      initialByte & 0x1f
    );
    if (len >= UINT64_MAX) {
      revert InvalidLengthEncoding(len);
    } else if (majorType != (initialByte >> 5)) {
      revert UnexpectedMajorType((initialByte >> 5), majorType);
    }
  }
 
}

// File: contracts\interfaces\IWitnetRequest.sol

/// @title The Witnet Data Request basic interface.
/// @author The Witnet Foundation.
interface IWitnetRequest {
    /// A `IWitnetRequest` is constructed around a `bytes` value containing 
    /// a well-formed Witnet Data Request using Protocol Buffers.
    function bytecode() external view returns (bytes memory);

    /// Returns SHA256 hash of Witnet Data Request as CBOR-encoded bytes.
    function hash() external view returns (bytes32);
}

// File: contracts\libs\Witnet.sol

library Witnet {

    /// ===============================================================================================================
    /// --- Witnet internal methods -----------------------------------------------------------------------------------

    /// @notice Witnet function that computes the hash of a CBOR-encoded Data Request.
    /// @param _bytecode CBOR-encoded RADON.
    function hash(bytes memory _bytecode) internal pure returns (bytes32) {
        return sha256(_bytecode);
    }

    /// Struct containing both request and response data related to every query posted to the Witnet Request Board
    struct Query {
        Request request;
        Response response;
        address from;      // Address from which the request was posted.
    }

    /// Possible status of a Witnet query.
    enum QueryStatus {
        Unknown,
        Posted,
        Reported,
        Deleted
    }

    /// Data kept in EVM-storage for every Request posted to the Witnet Request Board.
    struct Request {
        IWitnetRequest addr;    // The contract containing the Data Request which execution has been requested.
        address requester;      // Address from which the request was posted.
        bytes32 hash;           // Hash of the Data Request whose execution has been requested.
        uint256 gasprice;       // Minimum gas price the DR resolver should pay on the solving tx.
        uint256 reward;         // Escrowed reward to be paid to the DR resolver.
    }

    /// Data kept in EVM-storage containing Witnet-provided response metadata and result.
    struct Response {
        address reporter;       // Address from which the result was reported.
        uint256 timestamp;      // Timestamp of the Witnet-provided result.
        bytes32 drTxHash;       // Hash of the Witnet transaction that solved the queried Data Request.
        bytes   cborBytes;      // Witnet-provided result CBOR-bytes to the queried Data Request.
    }

    /// Data struct containing the Witnet-provided result to a Data Request.
    struct Result {
        bool success;           // Flag stating whether the request could get solved successfully, or not.
        WitnetCBOR.CBOR value;             // Resulting value, in CBOR-serialized bytes.
    }

    /// ===============================================================================================================
    /// --- Witnet error codes table ----------------------------------------------------------------------------------

    enum ErrorCodes {
        // 0x00: Unknown error. Something went really bad!
        Unknown,
        // Script format errors
        /// 0x01: At least one of the source scripts is not a valid CBOR-encoded value.
        SourceScriptNotCBOR,
        /// 0x02: The CBOR value decoded from a source script is not an Array.
        SourceScriptNotArray,
        /// 0x03: The Array value decoded form a source script is not a valid Data Request.
        SourceScriptNotRADON,
        /// Unallocated
        ScriptFormat0x04,
        ScriptFormat0x05,
        ScriptFormat0x06,
        ScriptFormat0x07,
        ScriptFormat0x08,
        ScriptFormat0x09,
        ScriptFormat0x0A,
        ScriptFormat0x0B,
        ScriptFormat0x0C,
        ScriptFormat0x0D,
        ScriptFormat0x0E,
        ScriptFormat0x0F,
        // Complexity errors
        /// 0x10: The request contains too many sources.
        RequestTooManySources,
        /// 0x11: The script contains too many calls.
        ScriptTooManyCalls,
        /// Unallocated
        Complexity0x12,
        Complexity0x13,
        Complexity0x14,
        Complexity0x15,
        Complexity0x16,
        Complexity0x17,
        Complexity0x18,
        Complexity0x19,
        Complexity0x1A,
        Complexity0x1B,
        Complexity0x1C,
        Complexity0x1D,
        Complexity0x1E,
        Complexity0x1F,
        // Operator errors
        /// 0x20: The operator does not exist.
        UnsupportedOperator,
        /// Unallocated
        Operator0x21,
        Operator0x22,
        Operator0x23,
        Operator0x24,
        Operator0x25,
        Operator0x26,
        Operator0x27,
        Operator0x28,
        Operator0x29,
        Operator0x2A,
        Operator0x2B,
        Operator0x2C,
        Operator0x2D,
        Operator0x2E,
        Operator0x2F,
        // Retrieval-specific errors
        /// 0x30: At least one of the sources could not be retrieved, but returned HTTP error.
        HTTP,
        /// 0x31: Retrieval of at least one of the sources timed out.
        RetrievalTimeout,
        /// Unallocated
        Retrieval0x32,
        Retrieval0x33,
        Retrieval0x34,
        Retrieval0x35,
        Retrieval0x36,
        Retrieval0x37,
        Retrieval0x38,
        Retrieval0x39,
        Retrieval0x3A,
        Retrieval0x3B,
        Retrieval0x3C,
        Retrieval0x3D,
        Retrieval0x3E,
        Retrieval0x3F,
        // Math errors
        /// 0x40: Math operator caused an underflow.
        Underflow,
        /// 0x41: Math operator caused an overflow.
        Overflow,
        /// 0x42: Tried to divide by zero.
        DivisionByZero,
        /// Unallocated
        Math0x43,
        Math0x44,
        Math0x45,
        Math0x46,
        Math0x47,
        Math0x48,
        Math0x49,
        Math0x4A,
        Math0x4B,
        Math0x4C,
        Math0x4D,
        Math0x4E,
        Math0x4F,
        // Other errors
        /// 0x50: Received zero reveals
        NoReveals,
        /// 0x51: Insufficient consensus in tally precondition clause
        InsufficientConsensus,
        /// 0x52: Received zero commits
        InsufficientCommits,
        /// 0x53: Generic error during tally execution
        TallyExecution,
        /// Unallocated
        OtherError0x54,
        OtherError0x55,
        OtherError0x56,
        OtherError0x57,
        OtherError0x58,
        OtherError0x59,
        OtherError0x5A,
        OtherError0x5B,
        OtherError0x5C,
        OtherError0x5D,
        OtherError0x5E,
        OtherError0x5F,
        /// 0x60: Invalid reveal serialization (malformed reveals are converted to this value)
        MalformedReveal,
        /// Unallocated
        OtherError0x61,
        OtherError0x62,
        OtherError0x63,
        OtherError0x64,
        OtherError0x65,
        OtherError0x66,
        OtherError0x67,
        OtherError0x68,
        OtherError0x69,
        OtherError0x6A,
        OtherError0x6B,
        OtherError0x6C,
        OtherError0x6D,
        OtherError0x6E,
        OtherError0x6F,
        // Access errors
        /// 0x70: Tried to access a value from an index using an index that is out of bounds
        ArrayIndexOutOfBounds,
        /// 0x71: Tried to access a value from a map using a key that does not exist
        MapKeyNotFound,
        /// Unallocated
        OtherError0x72,
        OtherError0x73,
        OtherError0x74,
        OtherError0x75,
        OtherError0x76,
        OtherError0x77,
        OtherError0x78,
        OtherError0x79,
        OtherError0x7A,
        OtherError0x7B,
        OtherError0x7C,
        OtherError0x7D,
        OtherError0x7E,
        OtherError0x7F,
        OtherError0x80,
        OtherError0x81,
        OtherError0x82,
        OtherError0x83,
        OtherError0x84,
        OtherError0x85,
        OtherError0x86,
        OtherError0x87,
        OtherError0x88,
        OtherError0x89,
        OtherError0x8A,
        OtherError0x8B,
        OtherError0x8C,
        OtherError0x8D,
        OtherError0x8E,
        OtherError0x8F,
        OtherError0x90,
        OtherError0x91,
        OtherError0x92,
        OtherError0x93,
        OtherError0x94,
        OtherError0x95,
        OtherError0x96,
        OtherError0x97,
        OtherError0x98,
        OtherError0x99,
        OtherError0x9A,
        OtherError0x9B,
        OtherError0x9C,
        OtherError0x9D,
        OtherError0x9E,
        OtherError0x9F,
        OtherError0xA0,
        OtherError0xA1,
        OtherError0xA2,
        OtherError0xA3,
        OtherError0xA4,
        OtherError0xA5,
        OtherError0xA6,
        OtherError0xA7,
        OtherError0xA8,
        OtherError0xA9,
        OtherError0xAA,
        OtherError0xAB,
        OtherError0xAC,
        OtherError0xAD,
        OtherError0xAE,
        OtherError0xAF,
        OtherError0xB0,
        OtherError0xB1,
        OtherError0xB2,
        OtherError0xB3,
        OtherError0xB4,
        OtherError0xB5,
        OtherError0xB6,
        OtherError0xB7,
        OtherError0xB8,
        OtherError0xB9,
        OtherError0xBA,
        OtherError0xBB,
        OtherError0xBC,
        OtherError0xBD,
        OtherError0xBE,
        OtherError0xBF,
        OtherError0xC0,
        OtherError0xC1,
        OtherError0xC2,
        OtherError0xC3,
        OtherError0xC4,
        OtherError0xC5,
        OtherError0xC6,
        OtherError0xC7,
        OtherError0xC8,
        OtherError0xC9,
        OtherError0xCA,
        OtherError0xCB,
        OtherError0xCC,
        OtherError0xCD,
        OtherError0xCE,
        OtherError0xCF,
        OtherError0xD0,
        OtherError0xD1,
        OtherError0xD2,
        OtherError0xD3,
        OtherError0xD4,
        OtherError0xD5,
        OtherError0xD6,
        OtherError0xD7,
        OtherError0xD8,
        OtherError0xD9,
        OtherError0xDA,
        OtherError0xDB,
        OtherError0xDC,
        OtherError0xDD,
        OtherError0xDE,
        OtherError0xDF,
        // Bridge errors: errors that only belong in inter-client communication
        /// 0xE0: Requests that cannot be parsed must always get this error as their result.
        /// However, this is not a valid result in a Tally transaction, because invalid requests
        /// are never included into blocks and therefore never get a Tally in response.
        BridgeMalformedRequest,
        /// 0xE1: Witnesses exceeds 100
        BridgePoorIncentives,
        /// 0xE2: The request is rejected on the grounds that it may cause the submitter to spend or stake an
        /// amount of value that is unjustifiably high when compared with the reward they will be getting
        BridgeOversizedResult,
        /// Unallocated
        OtherError0xE3,
        OtherError0xE4,
        OtherError0xE5,
        OtherError0xE6,
        OtherError0xE7,
        OtherError0xE8,
        OtherError0xE9,
        OtherError0xEA,
        OtherError0xEB,
        OtherError0xEC,
        OtherError0xED,
        OtherError0xEE,
        OtherError0xEF,
        OtherError0xF0,
        OtherError0xF1,
        OtherError0xF2,
        OtherError0xF3,
        OtherError0xF4,
        OtherError0xF5,
        OtherError0xF6,
        OtherError0xF7,
        OtherError0xF8,
        OtherError0xF9,
        OtherError0xFA,
        OtherError0xFB,
        OtherError0xFC,
        OtherError0xFD,
        OtherError0xFE,
        // This should not exist:
        /// 0xFF: Some tally error is not intercepted but should
        UnhandledIntercept
    }

}

// File: contracts\libs\WitnetV2.sol

library WitnetV2 {

    error IndexOutOfBounds(uint256 index, uint256 range);
    error InsufficientBalance(uint256 weiBalance, uint256 weiExpected);
    error InsufficientFee(uint256 weiProvided, uint256 weiExpected);
    error Unauthorized(address violator);

    error RadonFilterMissingArgs(uint8 opcode);

    error RadonRequestNoSources();
    error RadonRequestSourcesArgsMismatch(uint expected, uint actual);
    error RadonRequestMissingArgs(uint index, uint expected, uint actual);
    error RadonRequestResultsMismatch(uint index, uint8 read, uint8 expected);
    error RadonRequestTooHeavy(bytes bytecode, uint weight);

    error RadonSlaNoReward();
    error RadonSlaNoWitnesses();
    error RadonSlaTooManyWitnesses(uint256 numWitnesses);
    error RadonSlaConsensusOutOfRange(uint256 percentage);
    error RadonSlaLowCollateral(uint256 witnessCollateral);

    error UnsupportedDataRequestMethod(uint8 method, string schema, string body, string[2][] headers);
    error UnsupportedRadonDataType(uint8 datatype, uint256 maxlength);
    error UnsupportedRadonFilterOpcode(uint8 opcode);
    error UnsupportedRadonFilterArgs(uint8 opcode, bytes args);
    error UnsupportedRadonReducerOpcode(uint8 opcode);
    error UnsupportedRadonReducerScript(uint8 opcode, bytes script, uint256 offset);
    error UnsupportedRadonScript(bytes script, uint256 offset);
    error UnsupportedRadonScriptOpcode(bytes script, uint256 cursor, uint8 opcode);
    error UnsupportedRadonTallyScript(bytes32 hash);

    function toEpoch(uint _timestamp) internal pure returns (uint) {
        return 1 + (_timestamp - 11111) / 15;
    }

    function toTimestamp(uint _epoch) internal pure returns (uint) {
        return 111111+ _epoch * 15;
    }

    struct Beacon {
        uint256 escrow;
        uint256 evmBlock;
        uint256 gasprice;
        address relayer;
        address slasher;
        uint256 superblockIndex;
        uint256 superblockRoot;        
    }

    enum BeaconStatus {
        Idle
    }

    struct Block {
        bytes32 blockHash;
        bytes32 drTxsRoot;
        bytes32 drTallyTxsRoot;
    }
    
    enum BlockStatus {
        Idle
    }

    struct DrPost {
        uint256 block;
        DrPostStatus status;
        DrPostRequest request;
        DrPostResponse response;
    }
    
    /// Data kept in EVM-storage for every Request posted to the Witnet Request Board.
    struct DrPostRequest {
        uint256 epoch;
        address requester;
        address reporter;
        bytes32 radHash;
        bytes32 slaHash;
        uint256 weiReward;
    }

    /// Data kept in EVM-storage containing Witnet-provided response metadata and result.
    struct DrPostResponse {
        address disputer;
        address reporter;
        uint256 escrowed;
        uint256 drCommitTxEpoch;
        uint256 drTallyTxEpoch;
        bytes32 drTallyTxHash;
        bytes   drTallyResultCborBytes;
    }

    enum DrPostStatus {
        Void,
        Deleted,
        Expired,
        Posted,
        Disputed,
        Reported,
        Finalized,
        Accepted,
        Rejected
    }

    struct DataProvider {
        string  authority;
        uint256 totalSources;
        mapping (uint256 => bytes32) sources;
    }

    enum DataRequestMethods {
        /* 0 */ Unknown,
        /* 1 */ HttpGet,
        /* 2 */ Rng,
        /* 3 */ HttpPost
    }

    struct DataSource {
        uint8 argsCount;
        DataRequestMethods method;
        RadonDataTypes resultDataType;
        string url;
        string body;
        string[2][] headers;
        bytes script;
    }

    enum RadonDataTypes {
        /* 0x00 */ Any, 
        /* 0x01 */ Array,
        /* 0x02 */ Bool,
        /* 0x03 */ Bytes,
        /* 0x04 */ Integer,
        /* 0x05 */ Float,
        /* 0x06 */ Map,
        /* 0x07 */ String,
        Unused0x08, Unused0x09, Unused0x0A, Unused0x0B,
        Unused0x0C, Unused0x0D, Unused0x0E, Unused0x0F,
        /* 0x10 */ Same,
        /* 0x11 */ Inner,
        /* 0x12 */ Match,
        /* 0x13 */ Subscript
    }

    struct RadonFilter {
        RadonFilterOpcodes opcode;
        bytes args;
    }

    enum RadonFilterOpcodes {
        /* 0x00 */ GreaterThan,
        /* 0x01 */ LessThan,
        /* 0x02 */ Equals,
        /* 0x03 */ AbsoluteDeviation,
        /* 0x04 */ RelativeDeviation,
        /* 0x05 */ StandardDeviation,
        /* 0x06 */ Top,
        /* 0x07 */ Bottom,
        /* 0x08 */ Mode,
        /* 0x09 */ LessOrEqualThan
    }

    struct RadonReducer {
        RadonReducerOpcodes opcode;
        RadonFilter[] filters;
        bytes script;
    }

    enum RadonReducerOpcodes {
        /* 0x00 */ Minimum,
        /* 0x01 */ Maximum,
        /* 0x02 */ Mode,
        /* 0x03 */ AverageMean,
        /* 0x04 */ AverageMeanWeighted,
        /* 0x05 */ AverageMedian,
        /* 0x06 */ AverageMedianWeighted,
        /* 0x07 */ StandardDeviation,
        /* 0x08 */ AverageDeviation,
        /* 0x09 */ MedianDeviation,
        /* 0x0A */ MaximumDeviation,
        /* 0x0B */ ConcatenateAndHash
    }

    struct RadonSLA {
        uint numWitnesses;
        uint minConsensusPercentage;
        uint witnessReward;
        uint witnessCollateral;
        uint minerCommitFee;
    }

}

// File: contracts\requests\WitnetRequestTemplate.sol

abstract contract WitnetRequestTemplate
{
    event WitnetRequestTemplateSettled(WitnetRequest indexed request, bytes32 indexed radHash, string[][] args);

    function class() virtual external view returns (bytes4);
    function getDataSources() virtual external view returns (bytes32[] memory);
    function getDataSourcesCount() virtual external view returns (uint256);    
    function getRadonAggregatorHash() virtual external view returns (bytes32);
    function getRadonTallyHash() virtual external view returns (bytes32);
    function getResultDataMaxSize() virtual external view returns (uint16);
    function getResultDataType() virtual external view returns (WitnetV2.RadonDataTypes);
    function lookupDataSourceByIndex(uint256) virtual external view returns (WitnetV2.DataSource memory);
    function lookupRadonAggregator() virtual external view returns (WitnetV2.RadonReducer memory);
    function lookupRadonTally() virtual external view returns (WitnetV2.RadonReducer memory);
    function parameterized() virtual external view returns (bool);
    function settleArgs(string[][] calldata args) virtual external returns (WitnetRequest);
    function version() virtual external view returns (string memory);
}

// File: contracts\data\WitnetRequestFactoryData.sol

contract WitnetRequestFactoryData {

    bytes32 internal constant _WITNET_REQUEST_SLOTHASH =
        /* keccak256("io.witnet.data.request") */
        0xbf9e297db5f64cdb81cd821e7ad085f56008e0c6100f4ebf5e41ef6649322034;

    bytes32 internal constant _WITNET_REQUEST_FACTORY_SLOTHASH =
        /* keccak256("io.witnet.data.request.factory") */
        0xfaf45a8ecd300851b566566df52ca7611b7a56d24a3449b86f4e21c71638e642;

    bytes32 internal constant _WITNET_REQUEST_TEMPLATE_SLOTHASH =
        /* keccak256("io.witnet.data.request.template") */
        0x50402db987be01ecf619cd3fb022cf52f861d188e7b779dd032a62d082276afb;

    struct Slot {
        address owner;
        address pendingOwner;
    }

    struct WitnetRequestSlot {
        /// Array of string arguments passed upon initialization.
        string[][] args;  
        /// Witnet Data Request bytecode after inserting string arguments.
        bytes bytecode;    
        /// Address from which the request's SLA can be modifies.
        address curator;
        /// SHA-256 hash of the Witnet Data Request bytecode.
        bytes32 hash;
        /// Radon RAD hash. 
        bytes32 radHash;
        /// Radon SLA hash.
        bytes32 slaHash;
        /// Parent WitnetRequestTemplate contract.
        WitnetRequestTemplate template;
    }

    struct WitnetRequestTemplateSlot {
        /// Whether any of the sources is parameterized.
        bool parameterized;
        /// @notice Result data type.
        WitnetV2.RadonDataTypes resultDataType;
        /// @notice Result max size or rank (if variable type).
        uint16 resultDataMaxSize;        
        /// @notice Aggregator reducer hash.
        bytes32 aggregatorHash;
        /// @notice Tally reducer hash.
        bytes32 tallyHash;
        /// @notice Array of sources hashes passed upon construction.
        bytes32[] sources;
    }

    function __witnetRequestFactory()
        internal pure
        returns (Slot storage ptr)
    {
        assembly {
            ptr.slot := _WITNET_REQUEST_FACTORY_SLOTHASH
        }
    }

    function __witnetRequest()
        internal pure
        returns (WitnetRequestSlot storage ptr)
    {
        assembly {
            ptr.slot := _WITNET_REQUEST_SLOTHASH
        }
    }

    function __witnetRequestTemplate()
        internal pure
        returns (WitnetRequestTemplateSlot storage ptr)
    {
        assembly {
            ptr.slot := _WITNET_REQUEST_TEMPLATE_SLOTHASH
        }
    }
}

// File: @openzeppelin\contracts\utils\introspection\ERC165.sol

// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File: @openzeppelin\contracts\utils\Context.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin\contracts\access\Ownable.sol

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin\contracts\access\Ownable2Step.sol

// OpenZeppelin Contracts (last updated v4.8.0) (access/Ownable2Step.sol)

/**
 * @dev Contract module which provides access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership} and {acceptOwnership}.
 *
 * This module is used through inheritance. It will make available all functions
 * from parent (Ownable).
 */
abstract contract Ownable2Step is Ownable {
    address private _pendingOwner;

    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Returns the address of the pending owner.
     */
    function pendingOwner() public view virtual returns (address) {
        return _pendingOwner;
    }

    /**
     * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        _pendingOwner = newOwner;
        emit OwnershipTransferStarted(owner(), newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual override {
        delete _pendingOwner;
        super._transferOwnership(newOwner);
    }

    /**
     * @dev The new owner accepts the ownership transfer.
     */
    function acceptOwnership() external {
        address sender = _msgSender();
        require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
        _transferOwnership(sender);
    }
}

// File: @openzeppelin\contracts\security\ReentrancyGuard.sol

// OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: @openzeppelin\contracts-upgradeable\utils\AddressUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// File: @openzeppelin\contracts-upgradeable\proxy\utils\Initializable.sol

// OpenZeppelin Contracts (last updated v4.8.0) (proxy/utils/Initializable.sol)

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
     * constructor.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require(
            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
            "Initializable: contract is already initialized"
        );
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: setting the version to 255 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint8 version) {
        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized < type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    /**
     * @dev Internal function that returns the initialized version. Returns `_initialized`
     */
    function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }

    /**
     * @dev Internal function that returns the initialized version. Returns `_initializing`
     */
    function _isInitializing() internal view returns (bool) {
        return _initializing;
    }
}

// File: contracts\patterns\Proxiable.sol

abstract contract Proxiable {
    /// @dev Complying with EIP-1822: Universal Upgradeable Proxy Standard (UUPS)
    /// @dev See https://eips.ethereum.org/EIPS/eip-1822.
    function proxiableUUID() virtual external view returns (bytes32);

    struct ProxiableSlot {
        address implementation;
        address proxy;
    }

    function __implementation() internal view returns (address) {
        return __proxiable().implementation;
    }

    function __proxy() internal view returns (address) {
        return __proxiable().proxy;
    }

    function __proxiable() internal pure returns (ProxiableSlot storage proxiable) {
        assembly {
            // bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)
            proxiable.slot := 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
        }
    }
}

// File: contracts\patterns\Upgradeable.sol

/* solhint-disable var-name-mixedcase */

abstract contract Upgradeable is Initializable, Proxiable {

    address internal immutable _BASE;
    bytes32 internal immutable _CODEHASH;
    bool internal immutable _UPGRADABLE;

    modifier onlyDelegateCalls virtual {
        require(
            address(this) != _BASE,
            "Upgradeable: not a delegate call"
        );
        _;
    }

    /// Emitted every time the contract gets upgraded.
    /// @param from The address who ordered the upgrading. Namely, the WRB operator in "trustable" implementations.
    /// @param baseAddr The address of the new implementation contract.
    /// @param baseCodehash The EVM-codehash of the new implementation contract.
    /// @param versionTag Ascii-encoded version literal with which the implementation deployer decided to tag it.
    event Upgraded(
        address indexed from,
        address indexed baseAddr,
        bytes32 indexed baseCodehash,
        string  versionTag
    );

    constructor (bool _isUpgradable) {
        address _base = address(this);
        bytes32 _codehash;        
        assembly {
            _codehash := extcodehash(_base)
        }
        _BASE = _base;
        _CODEHASH = _codehash;
        _UPGRADABLE = _isUpgradable;
    }

    /// @dev Retrieves base contract. Differs from address(this) when called via delegate-proxy pattern.
    function base() public view returns (address) {
        return _BASE;
    }

    /// @dev Retrieves the immutable codehash of this contract, even if invoked as delegatecall.
    function codehash() public view returns (bytes32) {
        return _CODEHASH;
    }

    /// @dev Determines whether the logic of this contract is potentially upgradable.
    function isUpgradable() public view returns (bool) {
        return _UPGRADABLE;
    }

    /// @dev Tells whether provided address could eventually upgrade the contract.
    function isUpgradableFrom(address from) virtual external view returns (bool);

    /// @notice Re-initialize contract's storage context upon a new upgrade from a proxy.    
    /// @dev Must fail when trying to upgrade to same logic contract more than once.
    function initialize(bytes memory) virtual external;

    /// @dev Retrieves human-redable named version of current implementation.
    function version() virtual public view returns (string memory); 
}

// File: contracts\impls\WitnetProxy.sol

/// @title WitnetProxy: upgradable delegate-proxy contract. 
/// @author The Witnet Foundation.
contract WitnetProxy {

    /// Event emitted every time the implementation gets updated.
    event Upgraded(address indexed implementation);  

    /// Constructor with no params as to ease eventual support of Singleton pattern (i.e. ERC-2470).
    constructor () {}

    receive() virtual external payable {}

    /// Payable fallback accepts delegating calls to payable functions.  
    fallback() external payable { /* solhint-disable no-complex-fallback */
        address _implementation = implementation();
        assembly { /* solhint-disable avoid-low-level-calls */
            // Gas optimized delegate call to 'implementation' contract.
            // Note: `msg.data`, `msg.sender` and `msg.value` will be passed over 
            //       to actual implementation of `msg.sig` within `implementation` contract.
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _implementation, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            switch result
                case 0  { 
                    // pass back revert message:
                    revert(ptr, size) 
                }
                default {
                  // pass back same data as returned by 'implementation' contract:
                  return(ptr, size) 
                }
        }
    }

    /// Returns proxy's current implementation address.
    function implementation() public view returns (address) {
        return __proxySlot().implementation;
    }

    /// Upgrades the `implementation` address.
    /// @param _newImplementation New implementation address.
    /// @param _initData Raw data with which new implementation will be initialized.
    /// @return Returns whether new implementation would be further upgradable, or not.
    function upgradeTo(address _newImplementation, bytes memory _initData)
        public returns (bool)
    {
        // New implementation cannot be null:
        require(_newImplementation != address(0), "WitnetProxy: null implementation");

        address _oldImplementation = implementation();
        if (_oldImplementation != address(0)) {
            // New implementation address must differ from current one:
            require(_newImplementation != _oldImplementation, "WitnetProxy: nothing to upgrade");

            // Assert whether current implementation is intrinsically upgradable:
            try Upgradeable(_oldImplementation).isUpgradable() returns (bool _isUpgradable) {
                require(_isUpgradable, "WitnetProxy: not upgradable");
            } catch {
                revert("WitnetProxy: unable to check upgradability");
            }

            // Assert whether current implementation allows `msg.sender` to upgrade the proxy:
            (bool _wasCalled, bytes memory _result) = _oldImplementation.delegatecall(
                abi.encodeWithSignature(
                    "isUpgradableFrom(address)",
                    msg.sender
                )
            );
            require(_wasCalled, "WitnetProxy: not compliant");
            require(abi.decode(_result, (bool)), "WitnetProxy: not authorized");
            require(
                Upgradeable(_oldImplementation).proxiableUUID() == Upgradeable(_newImplementation).proxiableUUID(),
                "WitnetProxy: proxiableUUIDs mismatch"
            );
        }

        // Initialize new implementation within proxy-context storage:
        (bool _wasInitialized,) = _newImplementation.delegatecall(
            abi.encodeWithSignature(
                "initialize(bytes)",
                _initData
            )
        );
        require(_wasInitialized, "WitnetProxy: unable to initialize");

        // If all checks and initialization pass, update implementation address:
        __proxySlot().implementation = _newImplementation;
        emit Upgraded(_newImplementation);

        // Asserts new implementation complies w/ minimal implementation of Upgradeable interface:
        try Upgradeable(_newImplementation).isUpgradable() returns (bool _isUpgradable) {
            return _isUpgradable;
        }
        catch {
            revert ("WitnetProxy: not compliant");
        }
    }

    /// @dev Complying with EIP-1967, retrieves storage struct containing proxy's current implementation address.
    function __proxySlot() private pure returns (Proxiable.ProxiableSlot storage _slot) {
        assembly {
            // bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)
            _slot.slot := 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
        }
    }

}

// File: contracts\impls\WitnetUpgradableBase.sol

// solhint-disable var-name-mixedcase
// solhint-disable payable-fallback

/// @title Witnet Request Board base contract, with an Upgradeable (and Destructible) touch.
/// @author The Witnet Foundation.
abstract contract WitnetUpgradableBase
    is
        ERC165,
        Ownable2Step,
        Upgradeable, 
        ReentrancyGuard
{
    bytes32 internal immutable _WITNET_UPGRADABLE_VERSION;

    error AlreadyUpgraded(address implementation);
    error NotCompliant(bytes4 interfaceId);
    error NotUpgradable(address self);
    error OnlyOwner(address owner);

    constructor(
            bool _upgradable,
            bytes32 _versionTag,
            string memory _proxiableUUID
        )
        Upgradeable(_upgradable)
    {
        _WITNET_UPGRADABLE_VERSION = _versionTag;
        proxiableUUID = keccak256(bytes(_proxiableUUID));
    }
    
    /// @dev Reverts if proxy delegatecalls to unexistent method.
    fallback() external {
        revert("WitnetUpgradableBase: not implemented");
    }


    // ================================================================================================================
    // --- Overrides IERC165 interface --------------------------------------------------------------------------------

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 _interfaceId)
      public view
      virtual override
      returns (bool)
    {
        return _interfaceId == type(Ownable2Step).interfaceId
            || _interfaceId == type(Upgradeable).interfaceId
            || super.supportsInterface(_interfaceId);
    }

    // ================================================================================================================
    // --- Overrides 'Proxiable' --------------------------------------------------------------------------------------

    /// @dev Gets immutable "heritage blood line" (ie. genotype) as a Proxiable, and eventually Upgradeable, contract.
    ///      If implemented as an Upgradeable touch, upgrading this contract to another one with a different 
    ///      `proxiableUUID()` value should fail.
    bytes32 public immutable override proxiableUUID;


    // ================================================================================================================
    // --- Overrides 'Upgradeable' --------------------------------------------------------------------------------------

    /// Retrieves human-readable version tag of current implementation.
    function version() public view virtual override returns (string memory) {
        return _toString(_WITNET_UPGRADABLE_VERSION);
    }


    // ================================================================================================================
    // --- Internal methods -------------------------------------------------------------------------------------------

    /// Converts bytes32 into string.
    function _toString(bytes32 _bytes32)
        internal pure
        returns (string memory)
    {
        bytes memory _bytes = new bytes(_toStringLength(_bytes32));
        for (uint _i = 0; _i < _bytes.length;) {
            _bytes[_i] = _bytes32[_i];
            unchecked {
                _i ++;
            }
        }
        return string(_bytes);
    }

    // Calculate length of string-equivalent to given bytes32.
    function _toStringLength(bytes32 _bytes32)
        internal pure
        returns (uint _length)
    {
        for (; _length < 32; ) {
            if (_bytes32[_length] == 0) {
                break;
            }
            unchecked {
                _length ++;
            }
        }
    }

}

// File: contracts\patterns\Clonable.sol

abstract contract Clonable
    is
        Initializable
{
    address immutable internal _SELF = address(this);

    event Cloned(address indexed by, address indexed self, address indexed clone);

    modifier onlyDelegateCalls virtual {
        require(address(this) != _SELF, "Clonable: not a delegate call");
        _;
    }

    modifier wasInitialized {
        require(initialized(), "Clonable: not initialized");
        _;
    }

    /// @notice Tells whether this contract is a clone of `self()`
    function cloned()
        public view
        returns (bool)
    {
        return (
            address(this) != self()
        );
    }

    /// @notice Tells whether this instance has been initialized.
    function initialized() virtual public view returns (bool);

    /// @notice Contract address to which clones will be re-directed.
    function self() virtual public view returns (address) {
        return _SELF;
    }

    /// Deploys and returns the address of a minimal proxy clone that replicates contract
    /// behaviour while using its own EVM storage.
    /// @dev This function should always provide a new address, no matter how many times 
    /// @dev is actually called from the same `msg.sender`.
    /// @dev See https://eips.ethereum.org/EIPS/eip-1167.
    /// @dev See https://blog.openzeppelin.com/deep-dive-into-the-minimal-proxy-contract/.
    function _clone()
        internal
        returns (address _instance)
    {
        bytes memory ptr = _cloneBytecodePtr();
        assembly {
            // CREATE new instance:
            _instance := create(0, ptr, 0x37)
        }        
        require(_instance != address(0), "Clonable: CREATE failed");
        emit Cloned(msg.sender, self(), _instance);
    }

    /// @notice Returns minimal proxy's deploy bytecode.
    function _cloneBytecode()
        virtual internal view
        returns (bytes memory)
    {
        return abi.encodePacked(
            hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
            bytes20(self()),
            hex"5af43d82803e903d91602b57fd5bf3"
        );
    }

    /// @notice Returns mem pointer to minimal proxy's deploy bytecode.
    function _cloneBytecodePtr()
        virtual internal view
        returns (bytes memory ptr)
    {
        address _base = self();
        assembly {
            // ptr to free mem:
            ptr := mload(0x40)
            // begin minimal proxy construction bytecode:
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            // make minimal proxy delegate all calls to `self()`:
            mstore(add(ptr, 0x14), shl(0x60, _base))
            // end minimal proxy construction bytecode:
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
        }
    }

    /// Deploys and returns the address of a minimal proxy clone that replicates contract 
    /// behaviour while using its own EVM storage.
    /// @dev This function uses the CREATE2 opcode and a `_salt` to deterministically deploy
    /// @dev the clone. Using the same `_salt` multiple times will revert, since
    /// @dev no contract can be deployed more than once at the same address.
    /// @dev See https://eips.ethereum.org/EIPS/eip-1167.
    /// @dev See https://blog.openzeppelin.com/deep-dive-into-the-minimal-proxy-contract/.
    function _cloneDeterministic(bytes32 _salt)
        internal
        returns (address _instance)
    {
        bytes memory ptr = _cloneBytecodePtr();
        assembly {
            // CREATE2 new instance:
            _instance := create2(0, ptr, 0x37, _salt)
        }
        require(_instance != address(0), "Clonable: CREATE2 failed");
        emit Cloned(msg.sender, self(), _instance);
    }
}

// File: contracts\interfaces\V2\IWitnetBytecodes.sol

interface IWitnetBytecodes {

    error UnknownDataSource(bytes32 hash);
    error UnknownRadonReducer(bytes32 hash);
    error UnknownRadonRequest(bytes32 hash);
    error UnknownRadonSLA(bytes32 hash);
    
    event NewDataProvider(uint256 index);
    event NewDataSourceHash(bytes32 hash);
    event NewRadonReducerHash(bytes32 hash);
    event NewRadHash(bytes32 hash);
    event NewSlaHash(bytes32 hash);

    function bytecodeOf(bytes32 radHash) external view returns (bytes memory);
    function bytecodeOf(bytes32 radHash, bytes32 slahHash) external view returns (bytes memory);

    function hashOf(bytes32 radHash, bytes32 slaHash) external pure returns (bytes32 drQueryHash);
    function hashWeightWitsOf(bytes32 radHash, bytes32 slaHash) external view returns (
            bytes32 drQueryHash,
            uint32  drQueryWeight,
            uint256 drQueryWits
        );

    function lookupDataProvider(uint256 index) external view returns (string memory, uint);
    function lookupDataProviderIndex(string calldata authority) external view returns (uint);
    function lookupDataProviderSources(uint256 index, uint256 offset, uint256 length) external view returns (bytes32[] memory);
    function lookupDataSource(bytes32 hash) external view returns (WitnetV2.DataSource memory);
    function lookupDataSourceArgsCount(bytes32 hash) external view returns (uint8);
    function lookupDataSourceResultDataType(bytes32 hash) external view returns (WitnetV2.RadonDataTypes);
    function lookupRadonReducer(bytes32 hash) external view returns (WitnetV2.RadonReducer memory);
    function lookupRadonRequestAggregator(bytes32 hash) external view returns (WitnetV2.RadonReducer memory);
    function lookupRadonRequestResultMaxSize(bytes32 hash) external view returns (uint256);
    function lookupRadonRequestResultDataType(bytes32 hash) external view returns (WitnetV2.RadonDataTypes);
    function lookupRadonRequestSources(bytes32 hash) external view returns (bytes32[] memory);
    function lookupRadonRequestSourcesCount(bytes32 hash) external view returns (uint);
    function lookupRadonRequestTally(bytes32 hash) external view returns (WitnetV2.RadonReducer memory);
    function lookupRadonSLA(bytes32 hash) external view returns (WitnetV2.RadonSLA memory);
    function lookupRadonSLAReward(bytes32 hash) external view returns (uint);
    
    function verifyDataSource(
            WitnetV2.DataRequestMethods requestMethod,
            string calldata requestSchema,
            string calldata requestAuthority,
            string calldata requestPath,
            string calldata requestQuery,
            string calldata requestBody,
            string[2][] calldata requestHeaders,
            bytes calldata requestRadonScript
        ) external returns (bytes32 hash);
    
    function verifyRadonReducer(WitnetV2.RadonReducer calldata reducer)
        external returns (bytes32 hash);
    
    function verifyRadonRequest(
            bytes32[] calldata sources,
            bytes32 aggregator,
            bytes32 tally,
            uint16 resultMaxSize,
            string[][] calldata args
        ) external returns (bytes32 hash);    
    
    function verifyRadonSLA(WitnetV2.RadonSLA calldata sla)
        external returns (bytes32 hash);

    function totalDataProviders() external view returns (uint);
   
}

// File: contracts\requests\WitnetRequest.sol

abstract contract WitnetRequest
    is
        IWitnetRequest
{
    event WitnetRequestSettled(WitnetV2.RadonSLA sla);

    function args() virtual external view returns (string[][] memory);
    function class() virtual external view returns (bytes4);
    function curator() virtual external view returns (address);
    function getRadonSLA() virtual external view returns (WitnetV2.RadonSLA memory);
    function initialized() virtual external view returns (bool);
    function modifySLA(WitnetV2.RadonSLA calldata sla) virtual external returns (IWitnetRequest);
    function radHash() virtual external view returns (bytes32);
    function slaHash() virtual external view returns (bytes32);
    function template() virtual external view returns (WitnetRequestTemplate);
    function version() virtual external view returns (string memory);
}

// File: contracts\interfaces\V2\IWitnetRequestFactory.sol

interface IWitnetRequestFactory {
    
    event WitnetRequestBuilt(WitnetRequest request);
    event WitnetRequestTemplateBuilt(WitnetRequestTemplate template, bool parameterized);
    
    function buildRequest(
            bytes32[] memory sourcesIds,
            bytes32 aggregatorId,
            bytes32 tallyId,
            uint16  resultDataMaxSize
        ) external returns (WitnetRequest request);
    
    function buildRequestTemplate(
            bytes32[] memory sourcesIds,
            bytes32 aggregatorId,
            bytes32 tallyId,
            uint16  resultDataMaxSize
        ) external returns (WitnetRequestTemplate template);
    
    function class() external view returns (bytes4);    
    function registry() external view returns (IWitnetBytecodes);

}

// File: contracts\apps\WitnetRequestFactory.sol

contract WitnetRequestFactory
    is
        Clonable,
        IWitnetRequestFactory,
        WitnetRequest,
        WitnetRequestTemplate,
        WitnetRequestFactoryData,
        WitnetUpgradableBase        
{
    using ERC165Checker for address;

    /// @notice Reference to Witnet Data Requests Bytecode Registry
    IWitnetBytecodes immutable public override registry;

    modifier onlyDelegateCalls override(Clonable, Upgradeable) {
        require(
            address(this) != _BASE,
            "WitnetRequestFactory: not a delegate call"
        );
        _;
    }

    modifier onlyOnFactory {
        require(
            address(this) == __proxy(),
            "WitnetRequestFactory: not a factory"
        );
        _;
    }

    modifier onlyOnTemplates {
        require(
            __witnetRequestTemplate().tallyHash != bytes32(0),
            "WitnetRequestFactory: not a template"
        );
        _;
    }

    constructor(
            IWitnetBytecodes _registry,
            bool _upgradable,
            bytes32 _versionTag
        )
        WitnetUpgradableBase(
            _upgradable,
            _versionTag,
            "io.witnet.requests.factory"
        )
    {
        require(
            address(_registry).supportsInterface(type(IWitnetBytecodes).interfaceId),
            "WitnetRequestFactory: uncompliant registry"
        );
        registry = _registry;
        // let logic contract be used as a factory, while avoiding further initializations:
        __proxiable().proxy = address(this);
        __proxiable().implementation = address(this);
        __witnetRequestFactory().owner = address(0);
    }


    /// ===============================================================================================================
    /// --- IWitnetRequestFactory implementation ----------------------------------------------------------------------

    function buildRequest(
            bytes32[] memory _sources,
            bytes32 _aggregator,
            bytes32 _tally,
            uint16  _resultDataMaxSize
        )
        virtual override
        external
        onlyOnFactory
        returns (WitnetRequest _request)
    {
        WitnetRequestTemplate _template = buildRequestTemplate(
            _sources,
            _aggregator,
            _tally,
            _resultDataMaxSize
        );
        require(
            !_template.parameterized(),
            "WitnetRequestFactory: parameterized sources"
        );
        _request = _template.settleArgs(abi.decode(hex"",(string[][])));
        emit WitnetRequestBuilt(_request);
    }

    function buildRequestTemplate(
            bytes32[] memory _sources,
            bytes32 _aggregator,
            bytes32 _tally,
            uint16  _resultDataMaxSize
        )
        virtual override
        public
        onlyOnFactory
        returns (WitnetRequestTemplate _template)
    {
        bytes32 _salt = keccak256(
            // As to avoid template address collisions from:
            abi.encodePacked( 
                // - different factory versions
                _WITNET_UPGRADABLE_VERSION,
                // - different templates
                _sources, 
                _aggregator,
                _tally,
                _resultDataMaxSize
            )
        );
        address _address = address(uint160(uint256(keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(_cloneBytecode())
            )
        ))));
        if (_address.code.length > 0) {
            _template = WitnetRequestTemplate(_address);
        } else {
            _template = WitnetRequestFactory(
                _cloneDeterministic(_salt)
            ).initializeWitnetRequestTemplate(
                _sources,
                _aggregator,
                _tally,
                _resultDataMaxSize
            );
            emit WitnetRequestTemplateBuilt(
                _template,
                _template.parameterized()
            );
        }
    }

    function class() 
        virtual override(IWitnetRequestFactory, WitnetRequest, WitnetRequestTemplate)
        external view
        returns (bytes4)
    {
        if (address(this) == _SELF) {
            return type(Upgradeable).interfaceId;
        } else {
            if (address(this) == __proxy()) {
                return type(IWitnetRequestFactory).interfaceId;
            } else if (__witnetRequest().radHash != bytes32(0)) {
                return type(WitnetRequest).interfaceId;
            } else {
                return type(WitnetRequestTemplate).interfaceId;
            }
        }
    }

    function initializeWitnetRequestTemplate(
            bytes32[] calldata _sources,
            bytes32 _aggregatorId,
            bytes32 _tallyId,
            uint16  _resultDataMaxSize
        )
        virtual public
        initializer
        returns (WitnetRequestTemplate)
    {
        WitnetV2.RadonDataTypes _resultDataType;
        require(
            _sources.length > 0,
            "WitnetRequestTemplate: no sources"
        );
        // check all sources return the same data types, 
        // and whether any of them is parameterized
        bool _parameterized;
        for (uint _ix = 0; _ix < _sources.length; _ix ++) {
            if (_ix == 0) {
                _resultDataType = registry.lookupDataSourceResultDataType(_sources[_ix]);
            } else {
                require(
                    _resultDataType == registry.lookupDataSourceResultDataType(_sources[_ix]),
                    "WitnetRequestTemplate: mismatching sources"
                );
            }
            if (!_parameterized) {
                _parameterized = registry.lookupDataSourceArgsCount(_sources[_ix]) > 0;
            }
        }
        // revert if the aggregator reducer is unknown
        registry.lookupRadonReducer(_aggregatorId);
        // revert if the tally reducer is unknown
        registry.lookupRadonReducer(_tallyId);
        {
            WitnetRequestTemplateSlot storage __data = __witnetRequestTemplate();
            __data.parameterized = _parameterized;
            __data.aggregatorHash = _aggregatorId;
            __data.tallyHash = _tallyId;
            __data.resultDataType = _resultDataType;
            __data.resultDataMaxSize = _resultDataMaxSize;
            __data.sources = _sources;
        }
        return WitnetRequestTemplate(address(this));
    }
    
    function initializeWitnetRequest(
            address _from,
            bytes32 _radHash,
            string[][] memory _args
        )
        virtual public
        initializer
        returns (WitnetRequest)
    {
        WitnetRequestSlot storage __data = __witnetRequest();
        __data.args = _args;
        __data.curator = _from;
        __data.radHash = _radHash;
        __data.template = WitnetRequestTemplate(msg.sender);
        return WitnetRequest(address(this));
    }


    // ================================================================================================================
    // ---Overrides 'IERC165' -----------------------------------------------------------------------------------------

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 _interfaceId)
      public view
      virtual override
      returns (bool)
    {
        if (__witnetRequest().radHash != bytes32(0)) {
            return (
                _interfaceId == type(IWitnetRequest).interfaceId
                    || _interfaceId == type(WitnetRequest).interfaceId
                    || _interfaceId  == type(WitnetRequestTemplate).interfaceId
            );
        }
        else if (__witnetRequestTemplate().sources.length > 0) {
            return (_interfaceId == type(WitnetRequestTemplate).interfaceId);
        }
        else if (address(this) == __proxy()) {
            return (
                _interfaceId == type(IWitnetRequestFactory).interfaceId
                    || super.supportsInterface(_interfaceId)
            );
        }
        else {
            return (_interfaceId == type(Upgradeable).interfaceId);
        }
    }


    // ================================================================================================================
    // --- Overrides 'Ownable2Step' -----------------------------------------------------------------------------------

    /// @notice Returns the address of the pending owner.
    function pendingOwner()
        public view
        virtual override
        returns (address)
    {
        return __witnetRequestFactory().pendingOwner;
    }

    /// @notice Returns the address of the current owner.
    function owner()
        public view
        virtual override
        returns (address)
    {
        return __witnetRequestFactory().owner;
    }

    /// @notice Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
    /// @dev Can only be called by the current owner.
    function transferOwnership(address _newOwner)
        public
        virtual override
        onlyOwner
    {
        __witnetRequestFactory().pendingOwner = _newOwner;
        emit OwnershipTransferStarted(owner(), _newOwner);
    }

    /// @dev Transfers ownership of the contract to a new account (`_newOwner`) and deletes any pending owner.
    /// @dev Internal function without access restriction.
    function _transferOwnership(address _newOwner)
        internal
        virtual override
    {
        delete __witnetRequestFactory().pendingOwner;
        address _oldOwner = owner();
        if (_newOwner != _oldOwner) {
            __witnetRequestFactory().owner = _newOwner;
            emit OwnershipTransferred(_oldOwner, _newOwner);
        }
    }


    // ================================================================================================================
    // --- Overrides 'Upgradeable' -------------------------------------------------------------------------------------

    /// @notice Re-initialize contract's storage context upon a new upgrade from a proxy.
    /// @dev Must fail when trying to upgrade to same logic contract more than once.
    function initialize(bytes memory) 
        virtual override
        public
        onlyDelegateCalls
    {
        // WitnetRequest or WitnetRequestTemplate instances would already be initialized,
        // so only callable from proxies, in practice.

        address _owner = __witnetRequestFactory().owner;
        if (_owner == address(0)) {
            // set owner if none set yet
            _owner = msg.sender;
            __witnetRequestFactory().owner = _owner;
        } else {
            // only owner can initialize the proxy
            if (msg.sender != _owner) {
                revert WitnetUpgradableBase.OnlyOwner(_owner);
            }
        }

        if (__proxiable().proxy == address(0)) {
            // first initialization of the proxy
            __proxiable().proxy = address(this);
        }

        if (__proxiable().implementation != address(0)) {
            // same implementation cannot be initialized more than once:
            if(__proxiable().implementation == base()) {
                revert WitnetUpgradableBase.AlreadyUpgraded(base());
            }
        }        
        __proxiable().implementation = base();

        emit Upgraded(msg.sender, base(), codehash(), version());
    }

    /// Tells whether provided address could eventually upgrade the contract.
    function isUpgradableFrom(address _from) external view override returns (bool) {
        address _owner = __witnetRequestFactory().owner;
        return (
            // false if the WRB is intrinsically not upgradable, or `_from` is no owner
            isUpgradable()
                && _owner == _from
        );
    }


    // ================================================================================================================
    /// --- Clonable implementation and override ----------------------------------------------------------------------

    /// @notice Tells whether a WitnetRequest instance has been fully initialized.
    /// @dev True only on WitnetRequest instances with some Radon SLA set.
    function initialized()
        virtual override(Clonable, WitnetRequest)
        public view
        returns (bool)
    {
        return __witnetRequest().slaHash != bytes32(0);
    }

    /// @notice Contract address to which clones will be re-directed.
    function self()
        virtual override
        public view
        returns (address)
    {
        return (__proxy() != address(0)
            ? __implementation()
            : base()
        );
    }


    /// ===============================================================================================================
    /// --- IWitnetRequest implementation -----------------------------------------------------------------------------

    function bytecode() override external view returns (bytes memory) {
        return __witnetRequest().bytecode;
    }

    function hash() override external view returns (bytes32) {
        return __witnetRequest().hash;
    }


    /// ===============================================================================================================
    /// --- WitnetRequest implementation ------------------------------------------------------------------------------

    function args()
        override
        external view
        onlyDelegateCalls
        returns (string[][] memory)
    {
        return __witnetRequest().args;
    }

    function curator()
        override
        external view
        onlyDelegateCalls
        returns (address)
    {
        return __witnetRequest().curator;
    }

    function getRadonSLA()
        override
        external view
        onlyDelegateCalls
        returns (WitnetV2.RadonSLA memory)
    {
        return registry.lookupRadonSLA(
            __witnetRequest().slaHash
        );
    }

    function radHash()
        override
        external view
        onlyDelegateCalls
        returns (bytes32)
    {
        return __witnetRequest().radHash;
    }

    function slaHash() 
        override
        external view
        onlyDelegateCalls
        returns (bytes32)
    {
        return __witnetRequest().slaHash;
    }

    function template()
        override
        external view
        onlyDelegateCalls
        returns (WitnetRequestTemplate)
    {
        return __witnetRequest().template;
    }

    function modifySLA(WitnetV2.RadonSLA memory _sla)
        virtual override
        external
        onlyDelegateCalls
        returns (IWitnetRequest)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        require(
            address(_template) != address(0),
            "WitnetRequestFactory: not a request"
        );
        require(
            msg.sender == __witnetRequest().curator,
            "WitnetRequest: not the curator"
        );
        bytes32 _slaHash = registry.verifyRadonSLA(_sla);
        WitnetRequestSlot storage __data = __witnetRequest();
        if (_slaHash != __data.slaHash) {
            bytes memory _bytecode = registry.bytecodeOf(__data.radHash, _slaHash);
            __data.bytecode = _bytecode;
            __data.hash = Witnet.hash(_bytecode);
            __data.slaHash = _slaHash;        
            emit WitnetRequestSettled(_sla);
        }
        return IWitnetRequest(address(this));
    }

    function version() 
        virtual override(WitnetRequest, WitnetRequestTemplate, WitnetUpgradableBase)
        public view
        returns (string memory)
    {
        return WitnetUpgradableBase.version();
    }


    /// ===============================================================================================================
    /// --- WitnetRequestTemplate implementation ----------------------------------------------------------------------

    function getDataSources()
        override
        external view
        onlyDelegateCalls
        returns (bytes32[] memory)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.getDataSources();
        } else {
            return __witnetRequestTemplate().sources;
        }

    }

    function getDataSourcesCount() 
        override
        external view
        onlyDelegateCalls
        returns (uint256)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.getDataSourcesCount();
        } else {
            return __witnetRequestTemplate().sources.length;
        }
    }

    function getRadonAggregatorHash()
        override
        external view
        onlyDelegateCalls
        returns (bytes32)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.getRadonAggregatorHash();
        } else {
            return __witnetRequestTemplate().aggregatorHash;
        }
    }
    
    function getRadonTallyHash()
        override
        external view
        onlyDelegateCalls
        returns (bytes32)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.getRadonTallyHash();
        } else {
            return __witnetRequestTemplate().tallyHash;
        }
    }
    
    function getResultDataMaxSize()
        override
        external view
        onlyDelegateCalls
        returns (uint16)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.getResultDataMaxSize();
        } else {
            return __witnetRequestTemplate().resultDataMaxSize;
        }
    }

    function getResultDataType() 
        override
        external view
        onlyDelegateCalls
        returns (WitnetV2.RadonDataTypes)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.getResultDataType();
        } else {
            return __witnetRequestTemplate().resultDataType;
        }
    }

    function lookupDataSourceByIndex(uint256 _index) 
        override
        external view
        onlyDelegateCalls
        returns (WitnetV2.DataSource memory)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.lookupDataSourceByIndex(_index);
        } else {
            require(
                _index < __witnetRequestTemplate().sources.length,
                "WitnetRequestTemplate: out of range"
            );
            return registry.lookupDataSource(
                __witnetRequestTemplate().sources[_index]
            );
        }
    }

    function lookupRadonAggregator()
        override
        external view
        onlyDelegateCalls
        returns (WitnetV2.RadonReducer memory)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.lookupRadonAggregator();
        } else {
            return registry.lookupRadonReducer(
                __witnetRequestTemplate().aggregatorHash
            );
        }
    }

    function lookupRadonTally()
        override
        external view
        onlyDelegateCalls
        returns (WitnetV2.RadonReducer memory)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.lookupRadonTally();
        } else {
            return registry.lookupRadonReducer(
                __witnetRequestTemplate().tallyHash
            );
        }
    }

    function parameterized()
        override
        external view
        onlyDelegateCalls
        returns (bool)
    {
        WitnetRequestTemplate _template = __witnetRequest().template;
        if (address(_template) != address(0)) {
            return _template.parameterized();
        } else {
            return __witnetRequestTemplate().parameterized;
        }
    }

    function settleArgs(string[][] memory _args)
        virtual override
        external
        onlyOnTemplates
        returns (WitnetRequest _request)
    {
        WitnetRequestTemplateSlot storage __data = __witnetRequestTemplate();
        bytes32 _radHash = registry.verifyRadonRequest(
            __data.sources,
            __data.aggregatorHash,
            __data.tallyHash,
            __data.resultDataMaxSize,
            _args
        );
        bytes32 _salt = keccak256( 
            // As to avoid request address collisions from:
            abi.encodePacked( 
                // - different factory versions
                _WITNET_UPGRADABLE_VERSION,
                // - different curators
                msg.sender,
                // - different templates or args values
                _radHash
            )
        );
        address _address = address(uint160(uint256(keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(_cloneBytecode())
            )
        ))));
        if (_address.code.length > 0) {
            _request = WitnetRequest(_address);
        } else {
            _request = WitnetRequestFactory(_cloneDeterministic(_salt))
                .initializeWitnetRequest(
                    msg.sender,
                    _radHash,
                    _args
                );
        }
        emit WitnetRequestTemplateSettled(_request, _radHash, _args);
    }
}