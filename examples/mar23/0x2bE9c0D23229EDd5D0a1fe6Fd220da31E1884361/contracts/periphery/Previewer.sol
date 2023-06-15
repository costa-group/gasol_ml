// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

import { FixedPointMathLib } from "solmate/src/utils/FixedPointMathLib.sol";
import { MathUpgradeable as Math } from "openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol";
import { ERC20 } from "solmate/src/tokens/ERC20.sol";
import { InterestRateModel as IRM, AlreadyMatured } from "../InterestRateModel.sol";
import { RewardsController } from "../RewardsController.sol";
import { FixedLib } from "../utils/FixedLib.sol";
import { Auditor, IPriceFeed } from "../Auditor.sol";
import { Market } from "../Market.sol";

/// title Previewer
/// notice Contract to be consumed by Exactly's front-end dApp.
contract Previewer {
  using FixedPointMathLib for uint256;
  using FixedPointMathLib for int256;
  using FixedLib for FixedLib.Position;
  using FixedLib for FixedLib.Pool;
  using FixedLib for uint256;

  /// custom:oz-upgrades-unsafe-allow state-variable-immutable
  Auditor public immutable auditor;
  /// custom:oz-upgrades-unsafe-allow state-variable-immutable
  IPriceFeed public immutable basePriceFeed;

  struct MarketAccount {
    // market
    Market market;
    string symbol;
    uint8 decimals;
    address asset;
    string assetName;
    string assetSymbol;
    InterestRateModel interestRateModel;
    uint256 usdPrice;
    uint256 penaltyRate;
    uint256 adjustFactor;
    uint8 maxFuturePools;
    FixedPool[] fixedPools;
    RewardRate[] rewardRates;
    uint256 floatingBorrowRate;
    uint256 floatingUtilization;
    uint256 floatingBackupBorrowed;
    uint256 floatingAvailableAssets;
    uint256 totalFloatingBorrowAssets;
    uint256 totalFloatingDepositAssets;
    uint256 totalFloatingBorrowShares;
    uint256 totalFloatingDepositShares;
    // account
    bool isCollateral;
    uint256 maxBorrowAssets;
    uint256 floatingBorrowShares;
    uint256 floatingBorrowAssets;
    uint256 floatingDepositShares;
    uint256 floatingDepositAssets;
    FixedPosition[] fixedDepositPositions;
    FixedPosition[] fixedBorrowPositions;
    ClaimableReward[] claimableRewards;
  }

  struct RewardRate {
    address asset;
    string assetName;
    string assetSymbol;
    uint256 usdPrice;
    uint256 borrow;
    uint256 floatingDeposit;
    uint256[] maturities;
  }

  struct ClaimableReward {
    address asset;
    string assetName;
    string assetSymbol;
    uint256 amount;
  }

  struct InterestRateModel {
    address id;
    uint256 fixedCurveA;
    int256 fixedCurveB;
    uint256 fixedMaxUtilization;
    uint256 floatingCurveA;
    int256 floatingCurveB;
    uint256 floatingMaxUtilization;
  }

  struct FixedPosition {
    uint256 maturity;
    uint256 previewValue;
    FixedLib.Position position;
  }

  struct FixedPreview {
    uint256 maturity;
    uint256 assets;
    uint256 utilization;
  }

  struct FixedPool {
    uint256 maturity;
    uint256 borrowed;
    uint256 supplied;
    uint256 available;
    uint256 utilization;
    uint256 depositRate;
    uint256 minBorrowRate;
    uint256 optimalDeposit;
  }

  /// custom:oz-upgrades-unsafe-allow constructor
  constructor(Auditor auditor_, IPriceFeed basePriceFeed_) {
    auditor = auditor_;
    basePriceFeed = basePriceFeed_;
  }

  /// notice Function to get a certain account extended data.
  /// param account address which the extended data will be calculated.
  /// return data extended accountability of all markets for the account.
  function exactly(address account) external view returns (MarketAccount[] memory data) {
    uint256 markets = auditor.accountMarkets(account);
    uint256 maxValue = auditor.allMarkets().length;
    (uint256 adjustedCollateral, uint256 adjustedDebt) = auditor.accountLiquidity(account, Market(address(0)), 0);
    uint256 basePrice = address(basePriceFeed) != address(0)
      ? uint256(basePriceFeed.latestAnswer()) * 10 ** (18 - basePriceFeed.decimals())
      : 1e18;
    data = new MarketAccount[](maxValue);
    for (uint256 i = 0; i < maxValue; ++i) {
      Market market = auditor.marketList(i);
      Market.Account memory a;
      Auditor.MarketData memory m;
      (a.fixedDeposits, a.fixedBorrows, a.floatingBorrowShares) = market.accounts(account);
      (m.adjustFactor, m.decimals, m.index, m.isListed, m.priceFeed) = auditor.markets(market);
      IRM irm = market.interestRateModel();
      data[i] = MarketAccount({
        // market
        market: market,
        symbol: market.symbol(),
        decimals: m.decimals,
        asset: address(market.asset()),
        assetName: market.asset().name(),
        assetSymbol: market.asset().symbol(),
        interestRateModel: InterestRateModel({
          id: address(irm),
          fixedCurveA: irm.fixedCurveA(),
          fixedCurveB: irm.fixedCurveB(),
          fixedMaxUtilization: irm.fixedMaxUtilization(),
          floatingCurveA: irm.floatingCurveA(),
          floatingCurveB: irm.floatingCurveB(),
          floatingMaxUtilization: irm.floatingMaxUtilization()
        }),
        usdPrice: auditor.assetPrice(m.priceFeed).mulWadDown(basePrice),
        penaltyRate: market.penaltyRate(),
        adjustFactor: m.adjustFactor,
        maxFuturePools: market.maxFuturePools(),
        fixedPools: fixedPools(market),
        rewardRates: rewardRates(market, basePrice),
        floatingBorrowRate: irm.floatingRate(
          market.floatingAssets() > 0 ? Math.min(market.floatingDebt().divWadUp(market.floatingAssets()), 1e18) : 0
        ),
        floatingUtilization: market.floatingAssets() > 0
          ? Math.min(market.floatingDebt().divWadUp(market.floatingAssets()), 1e18)
          : 0,
        floatingBackupBorrowed: market.floatingBackupBorrowed(),
        floatingAvailableAssets: floatingAvailableAssets(market),
        totalFloatingBorrowAssets: market.totalFloatingBorrowAssets(),
        totalFloatingDepositAssets: market.totalAssets(),
        totalFloatingBorrowShares: market.totalFloatingBorrowShares(),
        totalFloatingDepositShares: market.totalSupply(),
        // account
        isCollateral: markets & (1 << i) != 0 ? true : false,
        maxBorrowAssets: adjustedCollateral >= adjustedDebt
          ? (adjustedCollateral - adjustedDebt).mulDivUp(10 ** m.decimals, auditor.assetPrice(m.priceFeed)).mulWadUp(
            m.adjustFactor
          )
          : 0,
        floatingBorrowShares: a.floatingBorrowShares,
        floatingBorrowAssets: maxRepay(market, account),
        floatingDepositShares: market.balanceOf(account),
        floatingDepositAssets: market.maxWithdraw(account),
        fixedDepositPositions: fixedPositions(
          market,
          account,
          a.fixedDeposits,
          market.fixedDepositPositions,
          this.previewWithdrawAtMaturity
        ),
        fixedBorrowPositions: fixedPositions(
          market,
          account,
          a.fixedBorrows,
          market.fixedBorrowPositions,
          this.previewRepayAtMaturity
        ),
        claimableRewards: claimableRewards(market, account)
      });
    }
  }

  /// notice Gets the assets plus yield offered by a maturity when depositing a certain amount.
  /// param market address of the market.
  /// param maturity maturity date/pool where the assets will be deposited.
  /// param assets amount of assets that will be deposited.
  /// return amount plus yield that the depositor will receive after maturity.
  function previewDepositAtMaturity(
    Market market,
    uint256 maturity,
    uint256 assets
  ) public view returns (FixedPreview memory) {
    if (block.timestamp > maturity) revert AlreadyMatured();
    (uint256 borrowed, uint256 supplied, , ) = market.fixedPools(maturity);
    uint256 memFloatingAssetsAverage = market.previewFloatingAssetsAverage();

    return
      FixedPreview({
        maturity: maturity,
        assets: assets + fixedDepositYield(market, maturity, assets),
        utilization: memFloatingAssetsAverage > 0 ? borrowed.divWadUp(supplied + assets + memFloatingAssetsAverage) : 0
      });
  }

  /// notice Gets the assets plus yield offered by all VALID maturities when depositing a certain amount.
  /// param market address of the market.
  /// param assets amount of assets that will be deposited.
  /// return previews array containing amount plus yield that account will receive after each maturity.
  function previewDepositAtAllMaturities(
    Market market,
    uint256 assets
  ) public view returns (FixedPreview[] memory previews) {
    uint256 maxFuturePools = market.maxFuturePools();
    uint256 maturity = block.timestamp - (block.timestamp % FixedLib.INTERVAL) + FixedLib.INTERVAL;
    previews = new FixedPreview[](maxFuturePools);
    for (uint256 i = 0; i < maxFuturePools; i++) {
      previews[i] = previewDepositAtMaturity(market, maturity, assets);
      maturity += FixedLib.INTERVAL;
    }
  }

  /// notice Gets the amount plus fees to be repaid at maturity when borrowing certain amount of assets.
  /// param market address of the market.
  /// param maturity maturity date/pool where the assets will be borrowed.
  /// param assets amount of assets that will be borrowed.
  /// return positionAssets amount plus fees that the depositor will repay at maturity.
  function previewBorrowAtMaturity(
    Market market,
    uint256 maturity,
    uint256 assets
  ) public view returns (FixedPreview memory) {
    FixedLib.Pool memory pool;
    (pool.borrowed, pool.supplied, , ) = market.fixedPools(maturity);
    uint256 memFloatingAssetsAverage = market.previewFloatingAssetsAverage();

    uint256 fees = assets.mulWadDown(
      market.interestRateModel().fixedBorrowRate(
        maturity,
        assets,
        pool.borrowed,
        pool.supplied,
        memFloatingAssetsAverage
      )
    );
    return
      FixedPreview({
        maturity: maturity,
        assets: assets + fees,
        utilization: memFloatingAssetsAverage > 0
          ? (pool.borrowed + assets).divWadUp(pool.supplied + memFloatingAssetsAverage)
          : 0
      });
  }

  /// notice Gets the assets plus fees offered by all VALID maturities when borrowing a certain amount.
  /// param market address of the market.
  /// param assets amount of assets that will be borrowed.
  /// return previews array containing amount plus yield that account will receive after each maturity.
  function previewBorrowAtAllMaturities(
    Market market,
    uint256 assets
  ) public view returns (FixedPreview[] memory previews) {
    uint256 maxFuturePools = market.maxFuturePools();
    uint256 maturity = block.timestamp - (block.timestamp % FixedLib.INTERVAL) + FixedLib.INTERVAL;
    previews = new FixedPreview[](maxFuturePools);
    for (uint256 i = 0; i < maxFuturePools; i++) {
      try this.previewBorrowAtMaturity(market, maturity, assets) returns (FixedPreview memory preview) {
        previews[i] = preview;
      } catch {
        previews[i] = FixedPreview({ maturity: maturity, assets: type(uint256).max, utilization: type(uint256).max });
      }
      maturity += FixedLib.INTERVAL;
    }
  }

  /// notice Gets the amount to be withdrawn for a certain positionAmount of assets at maturity.
  /// param market address of the market.
  /// param maturity maturity date/pool where the assets will be withdrawn.
  /// param positionAssets amount of assets that will be tried to withdraw.
  /// return withdrawAssets amount that will be withdrawn.
  function previewWithdrawAtMaturity(
    Market market,
    uint256 maturity,
    uint256 positionAssets,
    address owner
  ) public view returns (FixedPreview memory) {
    FixedLib.Pool memory pool;
    (pool.borrowed, pool.supplied, , ) = market.fixedPools(maturity);
    FixedLib.Position memory position;
    (position.principal, position.fee) = market.fixedDepositPositions(maturity, owner);
    uint256 principal = position.scaleProportionally(positionAssets).principal;
    uint256 memFloatingAssetsAverage = market.previewFloatingAssetsAverage();

    return
      FixedPreview({
        maturity: maturity,
        assets: block.timestamp < maturity
          ? positionAssets.divWadDown(
            1e18 +
              market.interestRateModel().fixedBorrowRate(
                maturity,
                positionAssets,
                pool.borrowed,
                pool.supplied,
                memFloatingAssetsAverage
              )
          )
          : positionAssets,
        utilization: memFloatingAssetsAverage > 0
          ? pool.borrowed.divWadUp(pool.supplied + memFloatingAssetsAverage - principal)
          : 0
      });
  }

  /// notice Gets the assets that will be repaid when repaying a certain amount at the current maturity.
  /// param market address of the market.
  /// param maturity maturity date/pool where the assets will be repaid.
  /// param positionAssets amount of assets that will be subtracted from the position.
  /// param borrower address of the borrower.
  /// return repayAssets amount of assets that will be repaid.
  function previewRepayAtMaturity(
    Market market,
    uint256 maturity,
    uint256 positionAssets,
    address borrower
  ) public view returns (FixedPreview memory) {
    FixedLib.Pool memory pool;
    (pool.borrowed, pool.supplied, , ) = market.fixedPools(maturity);
    FixedLib.Position memory position;
    (position.principal, position.fee) = market.fixedBorrowPositions(maturity, borrower);
    uint256 principal = position.scaleProportionally(positionAssets).principal;
    uint256 memFloatingAssetsAverage = market.previewFloatingAssetsAverage();

    return
      FixedPreview({
        maturity: maturity,
        assets: block.timestamp < maturity
          ? positionAssets - fixedDepositYield(market, maturity, principal)
          : positionAssets + positionAssets.mulWadDown((block.timestamp - maturity) * market.penaltyRate()),
        utilization: memFloatingAssetsAverage > 0
          ? (pool.borrowed - principal).divWadUp(pool.supplied + memFloatingAssetsAverage)
          : 0
      });
  }

  function fixedPools(Market market) internal view returns (FixedPool[] memory pools) {
    uint256 freshFloatingDebt = newFloatingDebt(market);
    pools = new FixedPool[](market.maxFuturePools());
    for (uint256 i = 0; i < market.maxFuturePools(); i++) {
      FixedLib.Pool memory pool;
      (pool.borrowed, pool.supplied, pool.unassignedEarnings, pool.lastAccrual) = market.fixedPools(
        block.timestamp - (block.timestamp % FixedLib.INTERVAL) + FixedLib.INTERVAL * (i + 1)
      );
      (uint256 minBorrowRate, uint256 utilization) = (market.previewFloatingAssetsAverage() + pool.supplied) > 0
        ? market.interestRateModel().minFixedRate(pool.borrowed, pool.supplied, market.previewFloatingAssetsAverage())
        : (0, 0);

      pool.unassignedEarnings -= pool.unassignedEarnings.mulDivDown(
        block.timestamp - pool.lastAccrual,
        (block.timestamp - (block.timestamp % FixedLib.INTERVAL) + FixedLib.INTERVAL * (i + 1)) - pool.lastAccrual
      );
      pools[i] = FixedPool({
        maturity: block.timestamp - (block.timestamp % FixedLib.INTERVAL) + FixedLib.INTERVAL * (i + 1),
        borrowed: pool.borrowed,
        supplied: pool.supplied,
        available: Math.min(
          (market.floatingAssets() + freshFloatingDebt).mulWadDown(1e18 - market.reserveFactor()) -
            Math.min(
              (market.floatingAssets() + freshFloatingDebt).mulWadDown(1e18 - market.reserveFactor()),
              market.floatingBackupBorrowed() + market.floatingDebt() + freshFloatingDebt
            ),
          market.previewFloatingAssetsAverage()
        ) +
          pool.supplied -
          Math.min(pool.supplied, pool.borrowed),
        utilization: utilization,
        optimalDeposit: pool.borrowed - Math.min(pool.borrowed, pool.supplied),
        depositRate: uint256(365 days).mulDivDown(
          pool.borrowed - Math.min(pool.borrowed, pool.supplied) > 0
            ? (pool.unassignedEarnings.mulWadDown(1e18 - market.backupFeeRate())).divWadDown(
              pool.borrowed - Math.min(pool.borrowed, pool.supplied)
            )
            : 0,
          block.timestamp - (block.timestamp % FixedLib.INTERVAL) + FixedLib.INTERVAL * (i + 1) - block.timestamp
        ),
        minBorrowRate: minBorrowRate
      });
    }
  }

  function rewardRates(Market market, uint256 basePrice) internal view returns (RewardRate[] memory rewards) {
    RewardsVars memory r;
    r.controller = market.rewardsController();
    if (address(r.controller) != address(0)) {
      (, r.underlyingDecimals, , , r.underlyingPriceFeed) = auditor.markets(market);
      unchecked {
        r.underlyingBaseUnit = 10 ** r.underlyingDecimals;
      }
      r.deltaTime = 1 hours;
      r.rewardList = r.controller.allRewards();
      rewards = new RewardRate[](r.rewardList.length);
      for (r.i = 0; r.i < r.rewardList.length; ++r.i) {
        r.config = r.controller.rewardConfig(market, r.rewardList[r.i]);
        (r.borrowIndex, r.depositIndex, ) = r.controller.rewardIndexes(market, r.rewardList[r.i]);
        (r.projectedBorrowIndex, r.projectedDepositIndex, ) = r.controller.previewAllocation(
          market,
          r.rewardList[r.i],
          block.timestamp > r.config.start ? r.deltaTime : 0
        );
        (r.start, , ) = r.controller.distributionTime(market, r.rewardList[r.i]);
        r.firstMaturity = r.start - (r.start % FixedLib.INTERVAL) + FixedLib.INTERVAL;
        r.maxMaturity =
          block.timestamp -
          (block.timestamp % FixedLib.INTERVAL) +
          (FixedLib.INTERVAL * market.maxFuturePools());
        r.maturities = new uint256[]((r.maxMaturity - r.firstMaturity) / FixedLib.INTERVAL + 1);
        r.start = 0;
        for (r.maturity = r.firstMaturity; r.maturity <= r.maxMaturity; ) {
          r.maturities[r.start] = r.maturity;
          unchecked {
            r.maturity += FixedLib.INTERVAL;
            ++r.start;
          }
        }
        rewards[r.i] = RewardRate({
          asset: address(r.rewardList[r.i]),
          assetName: r.rewardList[r.i].name(),
          assetSymbol: r.rewardList[r.i].symbol(),
          usdPrice: auditor.assetPrice(r.config.priceFeed).mulWadDown(basePrice),
          borrow: market.totalFloatingBorrowAssets() > 0
            ? (r.projectedBorrowIndex - r.borrowIndex)
              .mulDivDown(market.totalFloatingBorrowShares(), r.underlyingBaseUnit)
              .mulWadDown(auditor.assetPrice(r.config.priceFeed))
              .mulDivDown(
                r.underlyingBaseUnit,
                market.totalFloatingBorrowAssets().mulWadDown(auditor.assetPrice(r.underlyingPriceFeed))
              )
              .mulDivDown(365 days, r.deltaTime)
            : 0,
          floatingDeposit: market.totalAssets() > 0
            ? (r.projectedDepositIndex - r.depositIndex)
              .mulDivDown(market.totalSupply(), r.underlyingBaseUnit)
              .mulWadDown(auditor.assetPrice(r.config.priceFeed))
              .mulDivDown(
                r.underlyingBaseUnit,
                market.totalAssets().mulWadDown(auditor.assetPrice(r.underlyingPriceFeed))
              )
              .mulDivDown(365 days, r.deltaTime)
            : 0,
          maturities: r.maturities
        });
      }
    }
  }

  function claimableRewards(Market market, address account) internal view returns (ClaimableReward[] memory rewards) {
    RewardsController rewardsController = market.rewardsController();
    if (address(rewardsController) != address(0)) {
      ERC20[] memory rewardList = rewardsController.allRewards();

      rewards = new ClaimableReward[](rewardList.length);
      RewardsController.MarketOperation[] memory marketOps = new RewardsController.MarketOperation[](1);
      bool[] memory ops = new bool[](2);
      ops[0] = true;
      ops[1] = false;
      marketOps[0] = RewardsController.MarketOperation({ market: market, operations: ops });

      for (uint256 i = 0; i < rewardList.length; ++i) {
        rewards[i] = ClaimableReward({
          asset: address(rewardList[i]),
          assetName: rewardList[i].name(),
          assetSymbol: rewardList[i].symbol(),
          amount: rewardsController.claimable(marketOps, account, rewardList[i])
        });
      }
    }
  }

  function floatingAvailableAssets(Market market) internal view returns (uint256) {
    uint256 freshFloatingDebt = newFloatingDebt(market);
    uint256 maxAssets = (market.floatingAssets() + freshFloatingDebt).mulWadDown(1e18 - market.reserveFactor());
    return maxAssets - Math.min(maxAssets, market.floatingBackupBorrowed() + market.floatingDebt() + freshFloatingDebt);
  }

  function fixedPositions(
    Market market,
    address account,
    uint256 packedMaturities,
    function(uint256, address) external view returns (uint256, uint256) getPosition,
    function(Market, uint256, uint256, address) external view returns (FixedPreview memory) previewValue
  ) internal view returns (FixedPosition[] memory userMaturityPositions) {
    uint256 userMaturityCount = 0;
    FixedPosition[] memory allMaturityPositions = new FixedPosition[](224);
    uint256 maturity = packedMaturities & ((1 << 32) - 1);
    packedMaturities = packedMaturities >> 32;
    while (packedMaturities != 0) {
      if (packedMaturities & 1 != 0) {
        uint256 positionAssets;
        {
          (uint256 principal, uint256 fee) = getPosition(maturity, account);
          positionAssets = principal + fee;
          allMaturityPositions[userMaturityCount].position = FixedLib.Position(principal, fee);
        }
        try previewValue(market, maturity, positionAssets, account) returns (FixedPreview memory fixedPreview) {
          allMaturityPositions[userMaturityCount].previewValue = fixedPreview.assets;
        } catch {
          allMaturityPositions[userMaturityCount].previewValue = positionAssets;
        }
        allMaturityPositions[userMaturityCount].maturity = maturity;
        ++userMaturityCount;
      }
      packedMaturities >>= 1;
      maturity += FixedLib.INTERVAL;
    }

    userMaturityPositions = new FixedPosition[](userMaturityCount);
    for (uint256 i = 0; i < userMaturityCount; ++i) userMaturityPositions[i] = allMaturityPositions[i];
  }

  function fixedDepositYield(Market market, uint256 maturity, uint256 assets) internal view returns (uint256 yield) {
    FixedLib.Pool memory pool;
    (pool.borrowed, pool.supplied, pool.unassignedEarnings, pool.lastAccrual) = market.fixedPools(maturity);
    pool.unassignedEarnings -= pool.unassignedEarnings.mulDivDown(
      block.timestamp - pool.lastAccrual,
      maturity - pool.lastAccrual
    );
    (yield, ) = pool.calculateDeposit(assets, market.backupFeeRate());
  }

  function maxRepay(Market market, address borrower) internal view returns (uint256) {
    (, , uint256 floatingBorrowShares) = market.accounts(borrower);
    return market.previewRefund(floatingBorrowShares);
  }

  function newFloatingDebt(Market market) internal view returns (uint256) {
    uint256 memFloatingDebt = market.floatingDebt();
    uint256 memFloatingAssets = market.floatingAssets();
    uint256 floatingUtilization = memFloatingAssets > 0
      ? Math.min(memFloatingDebt.divWadUp(memFloatingAssets), 1e18)
      : 0;
    return
      memFloatingDebt.mulWadDown(
        market.interestRateModel().floatingRate(floatingUtilization).mulDivDown(
          block.timestamp - market.lastFloatingDebtUpdate(),
          365 days
        )
      );
  }

  struct RewardsVars {
    RewardsController controller;
    uint256 lastUpdate;
    uint256 depositIndex;
    uint256 borrowIndex;
    uint256 projectedDepositIndex;
    uint256 projectedBorrowIndex;
    uint256 underlyingBaseUnit;
    uint256[] maturities;
    IPriceFeed underlyingPriceFeed;
    RewardsController.Config config;
    ERC20[] rewardList;
    uint256 underlyingDecimals;
    uint256 deltaTime;
    uint256 i;
    uint256 start;
    uint256 maturity;
    uint256 firstMaturity;
    uint256 maxMaturity;
  }
}

error InvalidRewardsLength();
