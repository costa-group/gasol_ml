pragma solidity ^0.7.6;

import "./libraries/StrConcat.sol";
import "./interfaces/IDeployer02.sol";
import "./Debt.sol";

contract Deployer02 is IDeployer02 {
    function deploy(address owner, address poolToken, address setting, string memory tradePair) external override returns (address) {
        string memory tradePair = StrConcat.strConcat2("d", tradePair);
        return address(new Debt(owner, poolToken, setting, tradePair));
    }
}
