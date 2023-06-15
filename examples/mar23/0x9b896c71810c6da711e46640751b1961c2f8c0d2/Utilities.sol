// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

library utils {    
    function uint2str(
        uint256 _i
    ) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function seconds2strv2(uint256 _seconds) internal pure returns (uint[13] memory _numbers) {
        uint _years = _seconds / 31536000;
        _seconds -= _years * 31536000;

        uint _weeks = _seconds / 604800;
        _seconds -= _weeks * 604800;

        uint _days = _seconds / 86400;
        _seconds -= _days * 86400;

        uint _hours = _seconds / 3600;
        _seconds -= _hours * 3600;

        uint _minutes = _seconds / 60;
        _seconds -= _minutes * 60;

        uint _secondsRemaining = _seconds;

        if(_years < 10) {
            _numbers[0] = 0;
            _numbers[1] = 0;
            _numbers[2] = 0;
            _numbers[3] = _years;
        } else if(_years < 100) {
            _numbers[0] = 0;
            _numbers[1] = 0;
            _numbers[2] = (_years / 10);
            _numbers[3] = (_years % 10);
        } else if(_years < 1000) {
            _numbers[0] = 0;
            _numbers[1] = (_years / 100);
            _numbers[2] = ((_years % 100) / 10);
            _numbers[3] = (_years % 10);
        } else if(_years < 10000) {
            _numbers[0] = (_years / 1000);
            _numbers[1] = ((_years % 1000) / 100);
            _numbers[2] = ((_years % 100) / 10);
            _numbers[3] = (_years % 10);
        }

        if(_weeks < 10) {
            _numbers[4] = 0;
            _numbers[5] = _weeks;
        } else {
            _numbers[4] = (_weeks / 10);
            _numbers[5] = (_weeks % 10);
        }

        _numbers[6] = _days;

        if(_hours < 10) {
            _numbers[7] = 0;
            _numbers[8] = _hours;
        } else {
            _numbers[7] = (_hours / 10);
            _numbers[8] = (_hours % 10);
        }

        if(_minutes < 10) {
            _numbers[9] = 0;
            _numbers[10] = _minutes;
        } else {
            _numbers[9] = (_minutes / 10);
            _numbers[10] = (_minutes % 10);
        }


        if(_secondsRemaining < 10) {
            _numbers[11] = 0;
            _numbers[12] = _secondsRemaining;
        } else {
            _numbers[11] = (_secondsRemaining / 10);
            _numbers[12] = (_secondsRemaining % 10);
        }
        
        return _numbers;
    }

    // Get a pseudo random number
    function random(uint256 input, uint256 min, uint256 max) internal pure returns (uint256) {
        uint256 randRange = max - min;
        return max - (uint256(keccak256(abi.encodePacked(input + 2023))) % randRange) - 1;
    }

    function randomNumber(uint256 input, uint256 min, uint256 max) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input))) % (max - min + 1) + min;
    }

    function initValue(uint256 tokenId) internal pure returns (uint256 value) {
        if (tokenId <= 5000) {
            value = randomNumber(tokenId, 24 * 3600, 1000 * 3600);
        }  else if (tokenId <= 8000) {
            value = randomNumber(tokenId, 12 * 3600, 500 * 3600);
        }  else {
            value = randomNumber(tokenId, 6 * 3600, 250 * 3600);
        }
        return value;
    }

    function getRgbs(uint tokenId, uint baseColor) internal pure returns (uint256[3] memory rgbValues) {
        if (baseColor > 0) {
            for (uint i = 0; i < 3; i++) {
                if (baseColor == i + 1) {
                    rgbValues[i] = 255;
                } else {
                    rgbValues[i] = utils.random(tokenId + i, 0, 256);
                }
            }
        } else {
            for (uint i = 0; i < 3; i++) {
                rgbValues[i] = 255;
            }
        }
        return rgbValues;
    }

    function getMintPhase(uint tokenId) internal pure returns (uint mintPhase) {
        if (tokenId <= 5000) {
            mintPhase = 1;
        } else if (tokenId <= 8000) {
            mintPhase = 2;
        } else {
            mintPhase = 3;
        }
    }

    function secondsRemaining(uint end) internal view returns (uint) {
        if (block.timestamp <= end) {
            return end - block.timestamp;
        } else {
            return 0;
        }
    }

    function minutesRemaining(uint end) internal view returns (uint) {
        if (secondsRemaining(end) >= 60) {
            return (end - block.timestamp) / 60;
        } else {
            return 0;
        }
    }
}