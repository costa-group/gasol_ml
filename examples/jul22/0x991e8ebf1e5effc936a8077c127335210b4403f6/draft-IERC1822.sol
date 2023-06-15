// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC1822Proxiable {
    function proxiableUUID() external view returns (bytes32);
}
