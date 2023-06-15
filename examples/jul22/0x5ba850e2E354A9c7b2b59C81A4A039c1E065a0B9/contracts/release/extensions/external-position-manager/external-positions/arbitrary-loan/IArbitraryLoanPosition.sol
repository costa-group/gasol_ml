// SPDX-License-Identifier: GPL-3.0

/*
    This file is part of the Enzyme Protocol.
    (c) Enzyme Council <councilenzyme.finance>
    For the full license information, please view the LICENSE
    file that was distributed with this source code.
*/

import "../../../../../persistent/external-positions/IExternalPosition.sol";

pragma solidity ^0.6.12;

/// title IArbitraryLoanPosition Interface
/// author Enzyme Council <securityenzyme.finance>
interface IArbitraryLoanPosition is IExternalPosition {
    enum Actions {
        ConfigureLoan,
        UpdateBorrowableAmount,
        CallOnAccountingModule,
        Reconcile,
        CloseLoan
    }

    function getLoanAsset() external view returns (address asset_);
}
