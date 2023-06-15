// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9 <0.9.0;

import "./PMCTokens.sol";

/*

        
     
    #//&
    ///////////(
    &/////////////%
    //////
    //////
    (//////////////
    &//////////////////////
    //////////#//////////
    (/////%//////(//////
    ///////////////#//////////////////////
    /////////////////////////////////////////%
    /////#////////%/////////////&
    ////////////////////////////
    /////(///////////%//////
    /////////////////#//////
    //////////////////////////%//////
    /////////&//////////////////&/////
    ////////////////////////%////
    ///////////#//////////%/////
    /////&//////////////////////
    (///////////#////////////////////
    (////%//////////////////////////////////
    (/////&&%/////&////////////////%
    /////&/////
    &////////////
    ///////////////
    ////////////(/////////
    /////////////////////////
    /////&%/////////%
    /////
    %/////
    /////
    /////
    /////(
    /////
    &/////
     /////
        

      ..
     '                                                                                            '
    }                                          PMC TOKENS                                          {
    }                          ERC721 contract by Pecan Milk Cooperative                           {
   {                                    Facebook pecanmilkcoop                                     }
    }                                    Twitter pecanmilkcoop                                    {
    }                                     InstaGram pecanmilk                                     {
     ,                                                                                            ,
      ";"

*/

/// title The non-fungible token contract of Pecan Milk Cooperative
/// author Pecan Milk Cooperative (https://pecanmilk.com)
/// dev This safe contract sets up an unlimited collection of non-fungible tokens with innumberable generations.
///  Info on how the various aspects of safe contracts fit together are documented in the safe contract Complex Cipher.
contract PecanMilkCoop is PMCTokens {

  constructor() PMCTokens(
    "Pecan Milk Coop",
    "PECAN",
    "QmS5Gvpz8o1zKeC1vdpmEqtwtHCbZfzrj35H3MGNGdoRFC",
    100)
  {
    setContractURI("ipfs://QmeprjbfMa8jmn4YomBtycvxd1ro8tzRPDQSsBmmW9fawb");
  }

}
