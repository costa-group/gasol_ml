// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

/**
 * @notice This library provides stateless, general purpose functions.
 */
library Utils {
    // The code hash of any EOA
    bytes32 constant internal EOA_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

    /**
     * @notice Indicates if the address specified represents a smart contract.
     * @dev Notice that this method returns TRUE if the address is a contract under construction
     * @param addr The address to evaluate
     * @return Returns true if the address represents a smart contract
     */
    function isContract (address addr) internal view returns (bool) {
        bytes32 eoaHash = EOA_HASH;

        bytes32 codeHash;

        // solhint-disable-next-line no-inline-assembly
        assembly { codeHash := extcodehash(addr) }

        return (codeHash != eoaHash && codeHash != 0x0);
    }

    /**
     * @notice Gets the code hash of the address specified
     * @param addr The address to evaluate
     * @return Returns a hash
     */
    function getCodeHash (address addr) internal view returns (bytes32) {
        bytes32 codeHash;

        // solhint-disable-next-line no-inline-assembly
        assembly { codeHash := extcodehash(addr) }

        return codeHash;
    }
}

interface ILenderHook {
    function notifyLoanClosed() external;
    function notifyLoanMatured() external;
}

interface IOpenTermLoan {
    function fundLoan() external;
    function callLoan(uint256 callbackPeriodInHours, uint256 gracePeriodInHours) external;
    function liquidate() external;

    function loanState() external view returns (uint8);
    function getEffectiveLoanAmount() external view returns (uint256);
    function getDebtBoundaries() external view returns (uint256 minPayment, uint256 maxPayment, uint256 netDebtAmount);
    function lender() external view returns (address);
    function interestsRepaid() external view returns (uint256);
    function principalRepaid() external view returns (uint256);
}

/**
 * @title Defines the interface of a basic pricing oracle.
 * @dev All prices are expressed in USD, with 6 decimal positions.
 */
interface IBasicPriceOracle {
    function updateTokenPrice (address tokenAddr, uint256 valueInUSD) external;
    function bulkUpdate (address[] memory tokens, uint256[] memory prices) external;
    function getTokenPrice (address tokenAddr) external view returns (uint256);
}

interface IERC20NonCompliant {
    function transfer(address to, uint256 value) external;
    function transferFrom(address from, address to, uint256 value) external;
    function approve(address spender, uint256 value) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address addr) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external view returns (uint8);
}

/**
 * @title Represents an open-term loan.
 */
contract OpenTermLoan is IOpenTermLoan, ReentrancyGuard {
    // ---------------------------------------------------------------
    // States of a loan
    // ---------------------------------------------------------------
    uint8 constant private PREAPPROVED = 1;        // The loan was pre-approved by the lender
    uint8 constant private FUNDING_REQUIRED = 2;   // The loan was accepted by the borrower. Waiting for the lender to fund the loan.
    uint8 constant private FUNDED = 3;             // The loan was funded.
    uint8 constant private ACTIVE = 4;             // The loan is active.
    uint8 constant private CANCELLED = 5;          // The lender failed to fund the loan and the borrower claimed their collateral.
    uint8 constant private MATURED = 6;            // The loan matured. It was liquidated by the lender.
    uint8 constant private CLOSED = 7;             // The loan was closed normally.

    // ---------------------------------------------------------------
    // Other constants
    // ---------------------------------------------------------------
    // The zero address
    address constant private ZERO_ADDRESS = address(0);

    // The minimum payment interval, expressed in seconds
    uint256 constant private MIN_PAYMENT_INTERVAL = 2 hours;

    // The minimum callback period when calling a loan
    uint256 constant private MIN_CALLBACK_PERIOD = uint256(24);

    // The minimum grace period when calling a loan
    uint256 constant private MIN_GRACE_PERIOD = uint256(12);

    // ---------------------------------------------------------------
    // Tightly packed state
    // ---------------------------------------------------------------
    /**
     * @notice The late interests fee, as a percentage with 2 decimal places.
     */
    uint256 public lateInterestFee = uint256(30000);

    /**
     * @notice The late principal fee, as a percentage with 2 decimal places.
     */
    uint256 public latePrincipalFee = uint256(40000);

    /**
     * @notice The callback deadline of the loan. It is non-zero as soon as the loan gets called.
     * @dev It becomes a non-zero value as soon as the loan gets called.
     */
    uint256 public callbackDeadline;

    /**
     * @notice The date in which the loan was funded by the lender.
     * @dev It becomes a non-zero value as soon as the loan gets funded by the lender. It is zero otherwise.
     */
    uint256 public fundedOn;

    /**
     * @notice The amount of interests repaid so far.
     * @dev It gets updated when the borrower repays interests.
     */
    uint256 public override interestsRepaid;

    /**
     * @notice The amount of principal repaid so far.
     * @dev It gets updated when the borrower repays principal.
     */
    uint256 public override principalRepaid;

    /**
     * @notice The deadline for funding the loan.
     * @dev The lender is required to fund the principal before this exact point in time.
     */
    uint256 public fundingDeadline;

    /**
     * @notice The APR of the loan, with 2 decimal places.
     * @dev If the APR is 6% then the value reads 600, which is 6.00%
     */
    uint256 public immutable apr;

    /**
     * @notice The payment interval, expressed in seconds.
     * @dev For example, 1 day = 86400
     */
    uint256 public immutable paymentIntervalInSeconds;

    /**
     * @notice The funding period, expressed in seconds.
     */
    uint256 public immutable fundingPeriod;

    // The loan amount, expressed in principal tokens.
    uint256 private immutable _loanAmountInPrincipalTokens;

    // The effective loan amount
    uint256 private immutable _effectiveLoanAmount;

    // The initial collateral ratio, with 2 decimal places. It is zero for unsecured debt.
    uint256 private immutable _initialCollateralRatio;

    // The maintenance collateral ratio, with 2 decimal places. It is zero for unsecured debt.
    uint256 private _maintenanceCollateralRatio;

    // The current state of the loan
    uint8 internal _loanState;

    /**
     * @notice The address of the borrower per terms and conditions agreed between parties.
     */
    address public immutable borrower;

    /**
     * @notice The address of the lender per terms and conditions agreed between parties.
     */
    address public immutable override lender;

    /**
     * @notice The address of the principal token.
     */
    address public immutable principalToken;

    /**
     * @notice The address of the collateral token, if any.
     * @dev The collateral token is the zero address for unsecured loans.
     */
    address public immutable collateralToken;

    /**
     * @notice The oracle for calculating token prices.
     */
    address public priceOracle;

    // ---------------------------------------------------------------
    // Events
    // ---------------------------------------------------------------
    /**
     * @notice This event is triggered when the borrower accepts a loan.
     */
    event OnBorrowerCommitment();

    /**
     * @notice This event is triggered when the lender funds the loan.
     * @param amount The funding amount deposited in this loan
     */
    event OnLoanFunded(uint256 amount);

    /**
     * @notice This event is triggered when the borrower claims their collateral.
     * @param collateralClaimed The amount of collateral claimed by the borrower
     */
    event OnCollateralClaimed(uint256 collateralClaimed);

    /**
     * @notice This event is triggered when the price oracle changes.
     * @param prevAddress The address of the previous oracle
     * @param newAddress The address of the new oracle
     */
    event OnPriceOracleChanged(address prevAddress, address newAddress);

    /**
     * @notice This event is triggered when the maintenance collateralization ratio is updated
     * @param prevValue The previous maintenance ratio
     * @param newValue The new maintenance ratio
     */
    event OnCollateralRatioChanged(uint256 prevValue, uint256 newValue);

    /**
     * @notice This event is triggered when the late fees are updated
     * @param prevLateInterestFee The previous late fee for interests
     * @param newLateInterestFee The new late fee for interests
     * @param prevLatePrincipalFee The previous late fee for principal
     * @param newLatePrincipalFee The new late fee for principal
     */
    event OnLateFeesChanged(uint256 prevLateInterestFee, uint256 newLateInterestFee, uint256 prevLatePrincipalFee, uint256 newLatePrincipalFee);

    /**
     * @notice This event is triggered when the borrower withdraws principal tokens from the contract
     * @param numberOfTokens The amount of principal tokens withdrawn by the borrower
     */
    event OnBorrowerWithdrawal (uint256 numberOfTokens);

    /**
     * @notice This event is triggered when the lender calls the loan.
     * @param callbackPeriodInHours The callback period, measured in hours.
     * @param gracePeriodInHours The grace period, measured in hours.
     */
    event OnLoanCalled (uint256 callbackPeriodInHours, uint256 gracePeriodInHours);

    /**
     * @notice This event is triggered when the borrower repays interests
     * @param paymentAmountTokens The amount repaid by the borrower
     */
    event OnInterestsRepayment (uint256 paymentAmountTokens);

    /**
     * @notice This event is triggered when the borrower repays capital (principal)
     * @param paymentAmountTokens The amount repaid by the borrower
     */
    event OnPrincipalRepayment (uint256 paymentAmountTokens);

    /**
     * @notice This event is triggered when the loan gets closed.
     */
    event OnLoanClosed();

    /**
     * @notice This event is triggered when the loan is matured.
     */
    event OnLoanMatured();

    // ---------------------------------------------------------------
    // Constructor
    // ---------------------------------------------------------------
    constructor (
        address lenderAddr, 
        address borrowerAddr,
        IERC20NonCompliant newPrincipalToken,
        IBasicPriceOracle newOracle,
        address newCollateralToken,
        uint256 fundingPeriodInDays,
        uint256 newPaymentIntervalInSeconds,
        uint256 loanAmountInPrincipalTokens, 
        uint256 originationFeePercent2Decimals,
        uint256 newAprWithTwoDecimals,
        uint256 initialCollateralRatioWith2Decimals
    ) {
        // Checks
        require(lenderAddr != ZERO_ADDRESS, "Invalid lender");
        require(borrowerAddr != lenderAddr, "Invalid borrower");
        require(fundingPeriodInDays > 0, "Invalid funding period");
        require(loanAmountInPrincipalTokens > 0, "Invalid loan amount");
        require(newAprWithTwoDecimals > 0, "Invalid APR");

        // The minimum payment interval is 3 hours
        require(newPaymentIntervalInSeconds >= MIN_PAYMENT_INTERVAL, "Payment interval too short");

        // Check the collateralization ratio
        if (newCollateralToken == ZERO_ADDRESS) {
            // Unsecured loan
            require(initialCollateralRatioWith2Decimals == 0, "Invalid initial collateral");
        } else {
            // Secured loan
            require(initialCollateralRatioWith2Decimals > 0 && initialCollateralRatioWith2Decimals <= 12000, "Invalid initial collateral");
        }

        // State changes (immutable)
        lender = lenderAddr;
        borrower = borrowerAddr;
        principalToken = address(newPrincipalToken);
        collateralToken = newCollateralToken;
        fundingPeriod = fundingPeriodInDays * 1 days;
        apr = newAprWithTwoDecimals;
        paymentIntervalInSeconds = newPaymentIntervalInSeconds;
        _loanAmountInPrincipalTokens = loanAmountInPrincipalTokens;
        _initialCollateralRatio = initialCollateralRatioWith2Decimals;
        _effectiveLoanAmount = loanAmountInPrincipalTokens - (loanAmountInPrincipalTokens * originationFeePercent2Decimals / 1e4);

        // State changes (volatile)
        _maintenanceCollateralRatio = initialCollateralRatioWith2Decimals;
        priceOracle = address(newOracle);
        _loanState = PREAPPROVED;
    }

    // ---------------------------------------------------------------
    // Modifiers
    // ---------------------------------------------------------------
    /**
     * @notice Throws if the caller is not the expected borrower.
     */
    modifier onlyBorrower() {
        require(msg.sender == borrower, "Only borrower");
        _;
    }

    /**
     * @notice Throws if the caller is not the expected lender.
     */
    modifier onlyLender() {
        require(msg.sender == lender, "Only lender");
        _;
    }

    /**
     * @notice Throws if the loan is not active.
     */
    modifier onlyIfActive() {
        require(_loanState == ACTIVE, "Loan is not active");
        _;
    }

    /**
     * @notice Throws if the loan is not active or funded.
     */
    modifier onlyIfActiveOrFunded() {
        require(_loanState == ACTIVE || _loanState == FUNDED, "Loan is not active");
        _;
    }

    // ---------------------------------------------------------------
    // Functions
    // ---------------------------------------------------------------
    /**
     * @notice Updates the late fees
     * @dev Only the lender is allowed to call this function. As a lender, you cannot change the fees if the loan was called.
     * @param lateInterestFeeWithTwoDecimals The late interest fee (percentage) with 2 decimal places.
     * @param latePrincipalFeeWithTwoDecimals The late principal fee (percentage) with 2 decimal places.
     */
    function changeLateFees(uint256 lateInterestFeeWithTwoDecimals, uint256 latePrincipalFeeWithTwoDecimals) external onlyLender {
        require(lateInterestFeeWithTwoDecimals > 0 && latePrincipalFeeWithTwoDecimals > 0, "Late fee required");
        require(callbackDeadline == 0, "Loan was called");

        emit OnLateFeesChanged(lateInterestFee, lateInterestFeeWithTwoDecimals, latePrincipalFee, latePrincipalFeeWithTwoDecimals);

        lateInterestFee = lateInterestFeeWithTwoDecimals;
        latePrincipalFee = latePrincipalFeeWithTwoDecimals;
    }

    /**
     * @notice Changes the oracle that calculates token prices.
     * @dev Only the lender is allowed to call this function
     * @param newOracle The new oracle for token prices
     */
    function changeOracle(IBasicPriceOracle newOracle) external onlyLender {
        address prevAddr = priceOracle;
        require(prevAddr != address(newOracle), "Oracle already set");

        if (isSecured()) {
            // The lender cannot change the price oracle if the loan was called.
            // Otherwise the lender could force a liquidation of the loan 
            // by changing the maintenance collateral in order to game the borrower.
            require(callbackDeadline == 0, "Loan was called");
        }

        priceOracle = address(newOracle);
        emit OnPriceOracleChanged(prevAddr, priceOracle);
    }

    /**
     * @notice Updates the maintenance collateral ratio
     * @dev Only the lender is allowed to call this function. As a lender, you cannot change the maintenance collateralization ratio if the loan was called.
     * @param maintenanceCollateralRatioWith2Decimals The maintenance collateral ratio, if applicable.
     */
    function changeMaintenanceCollateralRatio(uint256 maintenanceCollateralRatioWith2Decimals) external onlyLender {
        // The maintenance ratio cannot be altered if the loan is unsecured
        require(isSecured(), "This loan is unsecured");

        // The maintenance ratio cannot be greater than the initial ratio
        require(maintenanceCollateralRatioWith2Decimals > 0, "Maintenance ratio required");
        require(maintenanceCollateralRatioWith2Decimals <= _initialCollateralRatio, "Maintenance ratio too high");
        require(_maintenanceCollateralRatio != maintenanceCollateralRatioWith2Decimals, "Value already set");

        // The lender cannot change the maintenance ratio if the loan was called.
        // Otherwise the lender could force a liquidation of the loan 
        // by changing the maintenance collateral in order to game the borrower.
        require(callbackDeadline == 0, "Loan was called");

        emit OnCollateralRatioChanged(_maintenanceCollateralRatio, maintenanceCollateralRatioWith2Decimals);
        
        _maintenanceCollateralRatio = maintenanceCollateralRatioWith2Decimals;
    }

    /**
     * @notice Allows the borrower to accept the loan offered by the lender.
     * @dev Only the borrower is allowed to call this function. The deposit amount is zero for unsecured loans.
     */
    function borrowerCommitment() external onlyBorrower {
        // Checks
        require(_loanState == PREAPPROVED, "Invalid loan state");

        // Update the state of the loan
        _loanState = FUNDING_REQUIRED;

        // Set the deadline for funding the principal
        fundingDeadline = block.timestamp + fundingPeriod; // solhint-disable-line not-rely-on-time

        if (isSecured()) {
            // This is the amount of collateral the borrower is required to deposit, in tokens.
            uint256 expectedDepositAmount = getInitialCollateralAmount();

            // Deposit the collateral
            _depositToken(IERC20NonCompliant(collateralToken), msg.sender, expectedDepositAmount);
        }

        // Emit the respective event
        emit OnBorrowerCommitment();
    }

    /**
     * @notice Funds this loan with the respective amount of principal, per loan specs.
     * @dev Only the lender is allowed to call this function. The loan must be funded within the time window specified. Otherwise, the borrower is allowed to claim their collateral.
     */
    function fundLoan() external override onlyLender {
        require(_loanState == FUNDING_REQUIRED, "Invalid loan state");

        uint256 ts = block.timestamp; // solhint-disable-line not-rely-on-time
        require(ts <= fundingDeadline, "Funding period elapsed");

        // State changes
        _loanState = FUNDED;
        fundedOn = ts;

        // Fund the loan with the expected amount of principal tokens
        _depositToken(IERC20NonCompliant(principalToken), msg.sender, _effectiveLoanAmount);

        emit OnLoanFunded(_effectiveLoanAmount);
    }

    /**
     * @notice Withdraws the principal tokens of this loan.
     * @dev Only the borrower is allowed to call this function
     */
    function withdraw() external onlyBorrower {
        require(_loanState == FUNDED, "Invalid loan state");

        _loanState = ACTIVE;

        // Send principal tokens to the borrower
        _withdrawPrincipalTokens(_effectiveLoanAmount, borrower);

        // Emit the event
        emit OnBorrowerWithdrawal(_effectiveLoanAmount);
    }

    /**
     * @notice Claims the collateral deposited by the borrower
     * @dev Only the borrower is allowed to call this function
     */
    function claimCollateral() external nonReentrant onlyBorrower {
        require(isSecured(), "This loan is unsecured");
        require(_loanState == FUNDING_REQUIRED, "Invalid loan state");
        require(block.timestamp > fundingDeadline, "Funding period not elapsed"); // solhint-disable-line not-rely-on-time

        IERC20NonCompliant collateralTokenInterface = IERC20NonCompliant(collateralToken);
        uint256 currentBalance = collateralTokenInterface.balanceOf(address(this));

        _loanState = CANCELLED;

        collateralTokenInterface.transfer(borrower, currentBalance);
        require(collateralTokenInterface.balanceOf(address(this)) == 0, "Collateral transfer failed");

        emit OnCollateralClaimed(currentBalance);
    }

    /**
     * @notice Repays the interests portion of the loan.
     */
    function repayInterests() external nonReentrant onlyBorrower onlyIfActive {
        // Make sure the loan hasn't been called
        require(callbackDeadline == 0, "Loan was called");

        // Enforce the maintenance collateral ratio, if applicable
        _enforceMaintenanceRatio();

        // Get the current debt
        (, , , uint256 interestOwed, , , , , uint256 minPaymentAmount, ) = getDebt();
        require(interestOwed > 0, "No interests owed");

        // State changes
        _depositToken(IERC20NonCompliant(principalToken), msg.sender, minPaymentAmount);

        interestsRepaid += interestOwed;
        emit OnInterestsRepayment(minPaymentAmount);

        //_withdrawPrincipalTokens(minPaymentAmount, lender);
        IERC20NonCompliant(principalToken).transfer(lender, minPaymentAmount);
    }

    /**
     * @notice Repays the principal portion of the loan.
     * @param paymentAmountInTokens The payment amount, expressed in principal tokens.
     */
    function repayPrincipal(uint256 paymentAmountInTokens) external nonReentrant onlyBorrower onlyIfActive {
        // Checks
        require(paymentAmountInTokens > 0, "Payment amount required");

        // Enforce the maintenance collateral ratio, if applicable
        _enforceMaintenanceRatio();

        // Get the current debt
        (, , uint256 principalDebtAmount, uint256 interestOwed, , , , , , uint256 maxPaymentAmount) = getDebt();

        if (callbackDeadline > 0) {
            // If the loan was called then the borrower is required to repay the net debt amount
            require(paymentAmountInTokens == maxPaymentAmount, "Full payment expected");
        } else {
            require(interestOwed == 0, "Must repay interests first");
        }

        // If the loan was not called then the borrower can repay any principal amount of their preference 
        // as long as it does not exceed the net debt
        require(paymentAmountInTokens <= maxPaymentAmount, "Amount exceeds net debt");

        // Make sure the deposit succeeds
        _depositToken(IERC20NonCompliant(principalToken), msg.sender, paymentAmountInTokens);

        // Update the amount of principal (capital) that was repaid so far
        uint256 delta = (paymentAmountInTokens <= principalDebtAmount) ? paymentAmountInTokens : principalDebtAmount;
        principalRepaid += delta;

        // Log the event
        emit OnPrincipalRepayment(paymentAmountInTokens);

        // Forward the payment to the lender
        _withdrawPrincipalTokens(paymentAmountInTokens, lender);

        // Close the loan, if applicable
        if (_loanAmountInPrincipalTokens - principalRepaid == 0) _closeLoan();
    }

    /**
     * @notice Calls the loan.
     * @dev Only the lender is allowed to call this function
     * @param callbackPeriodInHours The callback period, measured in hours.
     * @param gracePeriodInHours The grace period, measured in hours.
     */
    function callLoan(uint256 callbackPeriodInHours, uint256 gracePeriodInHours) external virtual override onlyLender onlyIfActiveOrFunded {
        require(callbackPeriodInHours >= MIN_CALLBACK_PERIOD, "Invalid Callback period");
        require(gracePeriodInHours >= MIN_GRACE_PERIOD, "Invalid Grace period");
        require(callbackDeadline == 0, "Loan was called already");

        callbackDeadline = block.timestamp + ((callbackPeriodInHours + gracePeriodInHours) * 1 hours); // solhint-disable-line not-rely-on-time

        emit OnLoanCalled(callbackPeriodInHours, gracePeriodInHours);
    }

    /**
     * @notice Liquidates the loan.
     * @dev Only the lender is allowed to call this function
     */
    function liquidate() external virtual override onlyLender onlyIfActiveOrFunded {
        require(callbackDeadline > 0, "Loan was not called yet");
        require(block.timestamp > callbackDeadline, "Callback period not elapsed"); // solhint-disable-line not-rely-on-time

        // State changes
        _loanState = MATURED;

        // Transfer the collateral to the lender. Transfer any remaining principal to the lender as well.
        _transferPrincipalAndCollateral(lender, lender);

        emit OnLoanMatured();

        if (Utils.isContract(lender)) ILenderHook(lender).notifyLoanMatured();
    }

    // Closes the loan
    function _closeLoan() private {
        // Update the state of the loan
        _loanState = CLOSED;

        // Send the collateral back to the borrower, if applicable.
        if (isSecured()) {
            IERC20NonCompliant collateralTokenInterface = IERC20NonCompliant(collateralToken);
            uint256 collateralBalanceInTokens = collateralTokenInterface.balanceOf(address(this));
            collateralTokenInterface.transfer(borrower, collateralBalanceInTokens);
            require(collateralTokenInterface.balanceOf(address(this)) == 0, "Collateral transfer failed");
        }

        emit OnLoanClosed();

        // If the lender is a smart contract then let the lender know that the loan was just closed.
        if (Utils.isContract(lender)) ILenderHook(lender).notifyLoanClosed();
    }

    // Deposits a specific amount of tokens into this smart contract
    function _depositToken(IERC20NonCompliant tokenInterface, address senderAddr, uint256 depositAmount) private {
        require(depositAmount > 0, "Deposit amount required");

        // Check balance and allowance
        require(tokenInterface.allowance(senderAddr, address(this)) >= depositAmount, "Insufficient allowance");
        require(tokenInterface.balanceOf(senderAddr) >= depositAmount, "Insufficient funds");

        // Calculate the expected outcome, per check-effects-interaction pattern
        uint256 balanceBeforeTransfer = tokenInterface.balanceOf(address(this));
        uint256 expectedBalanceAfterTransfer = balanceBeforeTransfer + depositAmount;

        // Let the borrower deposit the predefined collateral through a partially-compliant ERC20
        tokenInterface.transferFrom(senderAddr, address(this), depositAmount);

        // Check the new balance
        uint256 actualBalanceAfterTransfer = tokenInterface.balanceOf(address(this));
        require(actualBalanceAfterTransfer == expectedBalanceAfterTransfer, "Deposit failed");
    }

    // Transfers principal tokens to the recipient specified
    function _withdrawPrincipalTokens(uint256 amountInPrincipalTokens, address recipientAddr) private {
        // Check the balance of the contract
        IERC20NonCompliant principalTokenInterface = IERC20NonCompliant(principalToken);
        uint256 currentBalanceAtContract = principalTokenInterface.balanceOf(address(this));
        require(currentBalanceAtContract > 0 && currentBalanceAtContract >= amountInPrincipalTokens, "Insufficient balance");

        // Transfer the funds
        uint256 currentBalanceAtRecipient = principalTokenInterface.balanceOf(recipientAddr);
        uint256 newBalanceAtRecipient = currentBalanceAtRecipient + amountInPrincipalTokens;
        uint256 newBalanceAtContract = currentBalanceAtContract - amountInPrincipalTokens;

        principalTokenInterface.transfer(recipientAddr, amountInPrincipalTokens);

        require(principalTokenInterface.balanceOf(address(this)) == newBalanceAtContract, "Balance check failed");
        require(principalTokenInterface.balanceOf(recipientAddr) == newBalanceAtRecipient, "Transfer check failed");
    }

    function _transferPrincipalAndCollateral(address collateralRecipientAddr, address principalRecipientAddr) private {
        // Transfer the collateral, if applicable
        if (isSecured()) {
            IERC20NonCompliant collateralTokenInterface = IERC20NonCompliant(collateralToken);
            uint256 collateralBalanceInTokens = collateralTokenInterface.balanceOf(address(this));
            collateralTokenInterface.transfer(collateralRecipientAddr, collateralBalanceInTokens);
            require(collateralTokenInterface.balanceOf(address(this)) == 0, "Collateral transfer failed");
        }

        IERC20NonCompliant principalTokenInterface = IERC20NonCompliant(principalToken);
        uint256 principalBalanceInTokens = principalTokenInterface.balanceOf(address(this));
        if (principalBalanceInTokens > 0) {
            principalTokenInterface.transfer(principalRecipientAddr, principalBalanceInTokens);
            require(principalTokenInterface.balanceOf(address(this)) == 0, "Principal transfer failed");
        }
    }

    // ---------------------------------------------------------------
    // Views
    // ---------------------------------------------------------------
    /**
     * @notice Gets the number of collateral tokens required to represent the amount of principal specified.
     * @param principalPrice The price of the principal token
     * @param principalQty The number of principal tokens
     * @param collateralPrice The price of the collateral token
     * @param collateralDecimals The decimal positions of the collateral token
     * @return Returns the number of collateral tokens
     */
    function fromTokenToToken(uint256 principalPrice, uint256 principalQty, uint256 collateralPrice, uint256 collateralDecimals) public pure returns (uint256) {
        return ((principalPrice * principalQty) / collateralPrice) * (10 ** (collateralDecimals - 6));
    }

    /**
     * @notice Gets the minimum interest amount.
     * @return The minimum interest amount
     */
    function getMinInterestAmount() public view returns (uint256) {
        return (_loanAmountInPrincipalTokens - principalRepaid) * apr * paymentIntervalInSeconds / 365 days / 1e4;
    }

    /**
     * @notice Gets the date of the next payment.
     * @dev This is provided for informational purposes only. The date is zero if the loan is not active.
     * @return The unix epoch that represents the next payment date.
     */
    function getNextPaymentDate() public view returns (uint256) {
        if (_loanState != ACTIVE) return 0;

        uint256 diffSeconds = block.timestamp - fundedOn; // solhint-disable-line not-rely-on-time
        uint256 currentBillingCycle = (diffSeconds < paymentIntervalInSeconds) ? 1 : ((diffSeconds % paymentIntervalInSeconds == 0) ? diffSeconds / paymentIntervalInSeconds : (diffSeconds / paymentIntervalInSeconds) + 1);

        // The date of the next payment, for informational purposes only (and for the sake of transparency)
        return fundedOn + currentBillingCycle * paymentIntervalInSeconds;
    }

    /**
     * @notice Gets the current debt.
     * @return interestDebtAmount The interest owed by the borrower at this point in time.
     * @return grossDebtAmount The gross debt amount
     * @return principalDebtAmount The amount of principal owed by the borrower at this point in time.
     * @return interestOwed The amount of interest owed by the borrower
     * @return applicableLateFee The late fee(s) applied at the current point in time.
     * @return netDebtAmount The net debt amount, which includes any late fees
     * @return daysSinceFunding The number of days that elapsed since the loan was funded.
     * @return currentBillingCycle The current billing cycle (aka: payment interval).
     * @return minPaymentAmount The minimum payment amount to submit in order to repay your debt, at any point in time, including late fees.
     * @return maxPaymentAmount The maximum amount to repay in order to close the loan.
     */
    function getDebt() public view returns (
        uint256 interestDebtAmount, 
        uint256 grossDebtAmount, 
        uint256 principalDebtAmount, 
        uint256 interestOwed, 
        uint256 applicableLateFee, 
        uint256 netDebtAmount, 
        uint256 daysSinceFunding, 
        uint256 currentBillingCycle,
        uint256 minPaymentAmount,
        uint256 maxPaymentAmount
    ) {
        // If the loan hasn't been funded or it was closed then the current debt is zero
        if (fundedOn == 0 || _loanState == CLOSED) return (0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

        uint256 ts = block.timestamp; // solhint-disable-line not-rely-on-time
        uint256 diffSeconds = ts - fundedOn;
        currentBillingCycle = (diffSeconds < paymentIntervalInSeconds) ? 1 : ((diffSeconds % paymentIntervalInSeconds == 0) ? diffSeconds / paymentIntervalInSeconds : (diffSeconds / paymentIntervalInSeconds) + 1);
        daysSinceFunding = (diffSeconds < 86400) ? 1 : ((diffSeconds % 86400 == 0) ? diffSeconds / 86400 : (diffSeconds / 86400) + 1);
        principalDebtAmount = _loanAmountInPrincipalTokens - principalRepaid;
        interestDebtAmount = _loanAmountInPrincipalTokens * apr * daysSinceFunding / 365 / 1e4;
        require(interestDebtAmount > 0, "Interest debt cannot be zero");

        if (principalDebtAmount > 0) {
            grossDebtAmount = principalDebtAmount + interestDebtAmount;

            // Notice that the minimum interest amount could become zero due to rounding, if the principal debt is too small (say one cent)
            uint256 minInterestAmount = principalDebtAmount * apr * paymentIntervalInSeconds / 365 days / 1e4;

            uint256 x = currentBillingCycle * minInterestAmount;
            interestOwed = (x > interestsRepaid) ? x - interestsRepaid : uint256(0);

            // Calculate the late fee, depending on the current context
            if ((callbackDeadline > 0) && (ts > callbackDeadline)) {
                // The loan was called and the deadline elapsed (callback period + grace period)
                applicableLateFee = grossDebtAmount * latePrincipalFee / 365 / 1e4;
            } else {
                // The loan might have been called. In any case, you are still within the grace period so the principal fee does not apply
                uint256 delta = (interestOwed > minInterestAmount) ? interestOwed - minInterestAmount : uint256(0);
                applicableLateFee = delta * lateInterestFee / 365 / 1e4;
            }

            uint256 n = grossDebtAmount + applicableLateFee;
            netDebtAmount = (n > interestsRepaid) ? n - interestsRepaid : uint256(0);

            // Calculate the min/max payment amount, depending on the context
            if (callbackDeadline == 0) {
                // The loan was not called yet
                maxPaymentAmount = principalDebtAmount + applicableLateFee;
                minPaymentAmount = interestOwed + applicableLateFee;
            } else {
                // The loan was called
                maxPaymentAmount = principalDebtAmount + applicableLateFee + interestOwed;
                minPaymentAmount = maxPaymentAmount;
            }
        }
    }

    /**
     * @notice Gets the boundaries of this loan.
     * @return minPayment The minimum payment amount of the loan, at this point in time.
     * @return maxPayment The payment amount required to repay the full debt and close the loan.
     * @return netDebt The net debt amount of the loan.
     */
    function getDebtBoundaries() public view override returns (uint256 minPayment, uint256 maxPayment, uint256 netDebt) {
        (, , , , , uint256 netDebtAmount, , , uint256 minPaymentAmount, uint256 maxPaymentAmount) = getDebt();
        minPayment = minPaymentAmount;
        maxPayment = maxPaymentAmount;
        netDebt = netDebtAmount;
    }

    /**
     * @notice Indicates whether the loan is secured or not.
     * @return Returns true if the loan represents secured debt.
     */
    function isSecured() public view returns (bool) {
        return collateralToken != ZERO_ADDRESS;
    }

    /**
     * @notice Gets the amount of initial collateral that needs to be deposited in this contract.
     * @return The amount of initial collateral to deposit.
     */
    function getInitialCollateralAmount() public view returns (uint256) {
        return _getCollateralAmount(_initialCollateralRatio);
    }

    /**
     * @notice Gets the amount of maintenance collateral that needs to be deposited in this contract.
     * @return The amount of maintenance collateral to deposit.
     */
    function getMaintenanceCollateralAmount() public view returns (uint256) {
        return _getCollateralAmount(_maintenanceCollateralRatio);
    }

    /**
     * @notice Gets the current state of the loan.
     * @return The state of the loan
     */
    function loanState() external view override returns (uint8) {
        return _loanState;
    }

    /**
     * @notice Gets the effective amount of the loan.
     * @return The effective amount of the loan
     */
    function getEffectiveLoanAmount() external view override returns (uint256) {
        return _effectiveLoanAmount;
    }

    // Enforces the maintenance collateral ratio
    function _enforceMaintenanceRatio() private view {
        if (!isSecured()) return;

        // This is the amount of collateral tokens the borrower is required to maintain.
        uint256 expectedCollatAmount = getMaintenanceCollateralAmount();

        IERC20NonCompliant collateralTokenInterface = IERC20NonCompliant(collateralToken);
        require(collateralTokenInterface.balanceOf(address(this)) >= expectedCollatAmount, "Insufficient maintenance ratio");
    }

    function _getCollateralAmount(uint256 collatRatio) private view returns (uint256) {
        if (!isSecured()) return 0;

        uint256 principalPrice = IBasicPriceOracle(priceOracle).getTokenPrice(principalToken);
        require(principalPrice > 0, "Invalid price for principal");

        uint256 collateralPrice = IBasicPriceOracle(priceOracle).getTokenPrice(collateralToken);
        require(collateralPrice > 0, "Invalid price for collateral");

        IERC20NonCompliant collateralTokenInterface = IERC20NonCompliant(collateralToken);
        uint256 collateralDecimals = uint256(collateralTokenInterface.decimals());
        require(collateralDecimals >= 6, "Invalid collateral token");

        uint256 collateralInPrincipalTokens = _loanAmountInPrincipalTokens * collatRatio / 1e4;
        return fromTokenToToken(principalPrice, collateralInPrincipalTokens, collateralPrice, collateralDecimals);
    }
}