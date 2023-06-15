pragma solidity ^0.8.0;

library ExternalLib{
    uint private constant  CONST = 1000;

    function getConst() external pure returns (uint){
        return CONST;
    }
}

contract MyContract {
    function getConst() public pure returns (uint){
        return ExternalLib.getConst();
    }
}