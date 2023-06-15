// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
/**
 * ███████████     ███████      █████████  █████   █████████   ███   ███████████████ █████      █████
 * ░███░░░░░███  ███░░░░░███   ███░░░░░███░░███   ███░░░███   ░███  ░░███░░███░░░░░█░░███      ░░███
 * ░███    ░███ ███     ░░███ ███     ░░░  ░███  ███   ░███   ░███   ░███ ░███  █ ░  ░███       ░███
 * ░██████████ ░███      ░███░███          ░███████    ░███   ░███   ░███ ░██████    ░███       ░███
 * ░███░░░░░███░███      ░███░███          ░███░░███   ░░███  █████  ███  ░███░░█    ░███       ░███
 * ░███    ░███░░███     ███ ░░███     ███ ░███ ░░███   ░░░█████░█████░   ░███ ░   █ ░███      █░███      █
 * █████   █████░░░███████░   ░░█████████  █████ ░░████   ░░███ ░░███     ██████████ ██████████████████████
 * ░░░░░   ░░░░░   ░░░░░░░      ░░░░░░░░░  ░░░░░   ░░░░     ░░░   ░░░     ░░░░░░░░░░ ░░░░░░░░░░░░░░░░░░░░░░
 *
 * -----------------------------=============== rockwell.money ===============-----------------------------
 *
 * title   seedRockwell ERC20 Token (Seed Round Phase)
 * author  Zack W. Bishop
 * notice  "In profits we trust" is the motto of Rockwell, a cross-chain decentralized finance (DeFi)
 *          protocol with a purpose: building wealth. Rockwell's strategy is based on three pillars:
 *            (1) investing in large-cap crypto tokens and frequently rebalancing based on market
 *                capitalization (similar to a crypto mutual fund);
 *            (2) investing in promising mid-cap and small-cap DeFi projects after a thorough
 *                due diligence process (similar to a crypto hedge fund);
 *            (3) acting as a venture capital for early-stage DeFi startups (like a launchpad).
 *          This multi-asset treasury would support the value of Rockwell's ERC-20 token, the RCW.
 *          Read the full Whitepaper here: https://rockwell.money/whitepaper.pdf
 */

import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract seedRockwell is ERC20, Ownable {

  using SafeERC20 for IERC20;

  /* ============ Events ============ */

  event Buy(address _buyer, address _asset, uint256 _amount, uint256 _tokens);

  /* ============ State Variables ============ */

  bool active = true; // Presale starts at deployment of the smart contract
  uint256 public constant price = 800000000000000000; // 1 seedRCW = 0.8 USD fixed price

  struct Asset {
      string ticker;
      address tokenAddress;
      address dataFeed;
  }

  mapping(address => Asset) assets;
  address[] public supportedAssets;

  constructor() ERC20("Rockwell seedToken", "seedRCW") {}

  /* ============ External Functions ============ */

  /**
   * notice You can send ETH directly to the smart contract and you will get the corresponding amount of seedRCW tokens in return.
   */
  receive() external payable virtual {
      buy(address(0), msg.value);
  }

  function decimals() public pure override returns (uint8) {
      return 6;
  }

  /**
   * notice Burn function. This will be used in the future by the RockwellBroker, when you will exchange the seedRCW tokens for RCW.
   */
  function burn(uint256 amount) external {
      _burn(msg.sender, amount);
  }

  /* ============ Public Functions ============ */

  /**
   * notice You can buy seedRCW in exchange of ETH or other supportes assets (eg. USDT, DAI, FRAX etc.)
   * param _asset The address of the asset to used for exchange (use Zero address for ETH)
   * param _amount The amount of the asset token to be used for exchange
   * return Number of seedRCW tokens minted
   */
  function buy(address _asset, uint256 _amount) public payable returns (uint256) {
      require(active, "Presale has already finished");

      if ( _asset == address(0) ) {
          // ETH
          require(msg.value > 0, "Value cannot be Zero");
          _amount = msg.value;
      } else {
          // other supported asset (token)
          require(isSupportedAsset(_asset), "Asset not supported");
          require( IERC20(_asset).allowance(msg.sender, address(this)) >= _amount, "Amount exceededs allowance");
          IERC20(_asset).safeTransferFrom(msg.sender, address(this), _amount);
      }

      uint256 tokenAmount = payoutFor(_asset, _amount);
      require(tokenAmount > 0);
      _mint(msg.sender, tokenAmount);

      emit Buy(msg.sender, _asset, _amount, tokenAmount);

      return tokenAmount;
  }

  /**
   * notice Admin function: add supported asset
   * param _ticker Ticker of the asset (to be used for front-end)
   * param _asset The address of the asset
   * param _dataFeed The Token/USD ChainLink data feed address to calculate the price in USD. Used for NOT stable USD tokens only (eg. WETH).
   */
  function addAsset(string calldata _ticker, address _asset, address _dataFeed) public onlyOwner {
      require(active, "Presale has already finished");
      assets[_asset] = Asset({
          ticker: _ticker,
          tokenAddress: _asset,
          dataFeed: _dataFeed
      });
      supportedAssets.push(_asset);
  }

  /**
   * notice Admin function: remove supported asset
   * param _asset The address of the asset
   */
  function removeAsset(address _asset) public onlyOwner {
      require(isSupportedAsset(_asset), "Asset not supported");
      delete assets[_asset];
      for (uint i = 0; i < supportedAssets.length-1; i++){
          if ( supportedAssets[i] == _asset ) {
            supportedAssets[i] = supportedAssets[i+1];
          }
      }
      supportedAssets.pop();
  }

  /**
   * notice Admin function: withdraw asset tokens to be used for funding ICO activities
   * param asset The address of the asset
   * param amount The amount to be withdraw (use 0 to withdraw the total balance)
   */
  function withdrawToken(address asset, uint256 amount) public onlyOwner {
      if ( amount == 0 ) {
          uint256 thisBalance = IERC20(asset).balanceOf( address(this) );
          IERC20(asset).safeTransfer(msg.sender, thisBalance);
      } else {
          IERC20(asset).safeTransfer(msg.sender, amount);
      }
  }

  /**
   * notice Admin function: withdraw ETH to be used for funding ICO activities
   */
  function withdrawEth() public onlyOwner {
      uint256 amount = address(this).balance;
      require(amount > 0, "Nothing to withdraw; contract balance empty");
      address _owner = owner();
      (bool sent, ) = _owner.call{value: amount}("");
      require(sent, "Failed to send Ether");
  }

  /**
   * notice Stops the Presale. Minting seedRCW after this event is not anymore possible.
   */
  function stopPresale() public onlyOwner {
      active = false;
  }

  /**
   * notice Calculates how much seedRCW you can mint in exchange of ETH or other supportes assets (eg. USDT, DAI, FRAX etc.)
   * param _asset The address of the asset to used for exchange (use Zero address for ETH)
   * param _amount The amount of the asset token to be used for exchange
   * return Number of seedRCW tokens can be minted
   */
  function payoutFor(address _asset, uint256 _amount) public view returns ( uint256 ) {
      require(isSupportedAsset(_asset), "Asset not supported");
      if ( _asset == address(0) || assets[_asset].dataFeed != address(0) ) {
          // ETH or wETH
          // With the help of the data feed we calculate the current USD price of the asset token
          // and then we calculate how much seedRCW token we can mint for that amount
          AggregatorV3Interface priceFeed = AggregatorV3Interface(assets[_asset].dataFeed);
          (, int256 latestAnswer, , , ) = priceFeed.latestRoundData();
          return (_amount * uint256(latestAnswer) * 10**6) / price / 10**priceFeed.decimals();
      } else if ( assets[_asset].tokenAddress == address(0) ) {
          // token not supported
          return 0;
      } else {
          // stable USD token
          uint256 tokenDecimals = IERC20Metadata(_asset).decimals();
          return (_amount * 10**18) / price / 10**(tokenDecimals - 6);
      }
  }

  /**
   * notice Supporting function for front-end
   * return The number of supported assets, to be used as input for supportedAssets()
   */
  function supportedAssetsNum() public view returns (uint256) {
      return supportedAssets.length;
  }

  /* ============ Internal Functions ============ */

  /**
   * notice Supporting function for buy()
   * return Returns TRUE if the asset is supported
   */
  function isSupportedAsset(address _asset) internal view returns (bool) {
      if (supportedAssets.length == 0) { return false; }
      for (uint i = 0; i < supportedAssets.length; i++) {
          if (supportedAssets[i] == _asset) {
              return true;
          }
      }
      return false;
  }

}
