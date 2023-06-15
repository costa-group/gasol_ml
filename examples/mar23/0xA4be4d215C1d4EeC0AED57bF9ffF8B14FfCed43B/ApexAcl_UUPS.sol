// 8c4687b4b5b29597f67d5dff88e9b389908fbde1
// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.17;

import "ACLBase.sol";

interface IERC20 {
    function decimals() external view returns (uint8);
}

interface ISTARKEX {
    function getEthKey(uint256 ownerKey) external view returns (address);
}

contract ApexAcl is ACLBase {

    string public constant override NAME = "ApexAcl";
    uint public constant override VERSION = 2;
    address public STARKEX_ADDRESS = 0xA1D5443F2FB80A5A55ac804C948B45ce4C52DCbb;

    mapping(uint256 => mapping (uint256 => bool)) public starkKeyPositionIdPairs;  // role => token => bool

    struct StarkKeyPositionIdPair {
        uint256 starkKey;
        uint256 positionId; 
        bool status;
    }

    // ACL set methods

    function setStarkex(address _starkex) external onlySafe {
        require(_starkex != address(0), "_starkex not allowed");
        STARKEX_ADDRESS = _starkex;
    }

    function setstarkKeyPositionIdPair(uint256 _starkKey, uint256 _positionId, bool _status) external onlySafe{    
        starkKeyPositionIdPairs[_starkKey][_positionId] = _status;
    }

    function setstarkKeyPositionIdPairs(StarkKeyPositionIdPair[] calldata _starkKeyPositionIdPair) external onlySafe{    
        for (uint i=0; i < _starkKeyPositionIdPair.length; i++) { 
            starkKeyPositionIdPairs[_starkKeyPositionIdPair[i].starkKey][_starkKeyPositionIdPair[i].positionId] = _starkKeyPositionIdPair[i].status;
        }
    }

    // ACL check methods

    function deposit(
        IERC20 token,
        uint256 amount,
        uint256 starkKey,
        uint256 positionId,
        bytes calldata exchangeData
    ) public payable onlySelf {
        require(ISTARKEX(STARKEX_ADDRESS).getEthKey(starkKey) == safeAddress,'starkKey not registered with safe!');
        require(starkKeyPositionIdPairs[starkKey][positionId],'starkKey or positionId not allowed!');
    }

    function withdraw(uint256 ownerKey, uint256 assetType) public onlySelf {}

    fallback() external {
        revert("Unauthorized access");
    }
}