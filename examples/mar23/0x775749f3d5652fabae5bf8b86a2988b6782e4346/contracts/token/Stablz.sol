//SPDX-License-Identifier: Unlicense
pragma solidity = 0.8.9;

/*
                    .!5B&&5.                                 :G#7                &5
               .~Y#&GYY5                                 &Y               ?&
           :7G&&G?:   ^G&.    ^&P                        J&               .~             .
       ^Y##Y~.     ~B!     .&Y.:^~7?YPGB#&&^  .~               PB   !?Y5GBB#&&5
     5&G7:          .!!???5GB##&&&#BG5J?!~^.   GB     ^JGBG!    ^.  Y&&G:
    &~                ^&#&Y7!~^:.                 ~.  ^G.   #J    ..  !&P:
    &!                        #Y      .?G#&Y   &J.Y&G~ GB   ?&       7&5.
    .PBY~:                  J&      P#BPY?7P&   ?B&7   .:  .~     ?&J
      .~5#&GJ~.           :^     #P     :G!  .#^     GP   GG   .JJ.  .:^~!?J5PG#&&
           .~JG&&P?^.     #G     Y&    :BB   G&^      5:  ?B!?G&&&#BP5J
                 :!YB&#P7J.    .^  :BGY.  ~G..:^~7Y&&&B&#BGPYJ7!^::..
  ~B~               .:!5B&J     GG ^BB: GBG#&G!YBBBG57::^:..
 GG                      G#!!?Y#B^   ^#&&&&#GPYJ7!~^:.
GP         ..:^~!?J5GB#&&GPBB57.
PBPPGB&&&&#BGY7:..:...
 !G&&&#GPY?!~^:..
*/

import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/// title Stablz token
contract Stablz is ERC20Burnable {

    constructor () ERC20("Stablz", "STABLZ") {
        _mint(msg.sender, 100_000_000 * (10 ** decimals()));
    }
}
