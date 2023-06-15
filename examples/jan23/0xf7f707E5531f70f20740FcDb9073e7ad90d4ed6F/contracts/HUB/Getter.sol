// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.17;

import "../interfaces/INFT.sol";
import "../interfaces/IHUB.sol";

contract HubGetter {

    INFT public Genesis = INFT(0x810FeDb4a6927D02A6427f7441F6110d7A1096d5); // Genesis NFT contract
    INFT public Alpha = INFT(0x96Af517c414B3726c1B2Ecc744ebf9d292DCbF60);
    INFT public Wastelands = INFT(0x0b21144dbf11feb286d24cD42A7c3B0f90c32aC8);
    IHUB public HUB = IHUB(0x1FbeA078ad9f0f52FD39Fc8AD7494732D65309Fb);

    function getGenesisOwners() external view returns (uint256 ownerCount, address[] memory owners) {
        owners = new address[](500);
        uint256[] memory stakedGenesis = Genesis.walletOfOwner(address(HUB));
        for(uint i = 0; i < stakedGenesis.length; i++) {
            address ogGenesisOwner;
            uint8 genesisIdentifier = HUB.genesisIdentifier(uint16(stakedGenesis[i]));
            if(genesisIdentifier == 1) {
                ogGenesisOwner = HUB.getRunnerOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 2) {
                ogGenesisOwner = HUB.getBullOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 3) {
                ogGenesisOwner = HUB.getMatadorOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 4) {
                ogGenesisOwner = HUB.getCadetOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 5) {
                ogGenesisOwner = HUB.getAlienOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 6) {
                ogGenesisOwner = HUB.getGeneralOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 7) {
                ogGenesisOwner = HUB.getBakerOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 8) {
                ogGenesisOwner = HUB.getFoodieOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 9) {
                ogGenesisOwner = HUB.getShopOwnerOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 10) {
                ogGenesisOwner = HUB.getCatOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 11) {
                ogGenesisOwner = HUB.getDogOwner(uint16(stakedGenesis[i]));
            } else if(genesisIdentifier == 12) {
                ogGenesisOwner = HUB.getVetOwner(uint16(stakedGenesis[i]));
            }

            bool exists;
            for(uint e = 0; e < owners.length; e++) {
                if(owners[e] == address(0)) {
                    break;
                } else if(owners[e] == ogGenesisOwner) {
                    exists = true;
                    break;
                } else {
                    continue;
                }
            }
            if(!exists) {
                owners[ownerCount] = ogGenesisOwner;
                ownerCount++;
            }
        }
    }

}