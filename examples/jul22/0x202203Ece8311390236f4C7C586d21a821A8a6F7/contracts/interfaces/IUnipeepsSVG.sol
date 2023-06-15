// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {IUnipeeps} from './IUnipeeps.sol';

interface IUnipeepsSVG {
    function generateSVG(
        uint256 number,
        IUnipeeps.Peep memory peep,
        uint256 totalPeeps
    ) external view returns (bytes memory SVG);
}
