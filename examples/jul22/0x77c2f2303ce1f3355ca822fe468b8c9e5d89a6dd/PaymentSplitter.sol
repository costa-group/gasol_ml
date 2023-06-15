// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)

pragma solidity ^0.8.15;

import "./SafeERC20.sol";
import "./Address.sol";
import "./Context.sol";

/**
 * title PaymentSplitter
 * dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
 * that the Ether will be split in this way, since it is handled transparently by the contract.
 *
 * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
 * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
 * an amount proportional to the percentage of total shares they were assigned.
 *
 * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
 * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
 * function.
 *
 * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
 * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
 * to run tests before sending real value to this contract.
 * 
 * Changes were made to code as client needs to change shares in the future. Also made it easier to manage withdrawls.
 */

contract PaymentSplitter is Context {
    event PayeeAdded(address account, uint16 shares);
    event PaymentReleased(address to, uint256 amount);
    event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
    event PaymentReceived(address from, uint256 amount);

    uint256 private _totalShares;
    uint256 private _totalReleased;
    address[] private _payees;
    IERC20[] private _tokenList;
    mapping(address => uint256) private _shares;
    mapping(address => uint256) private _released;
    mapping(IERC20 => uint256) private _erc20TotalReleased;
    mapping(IERC20 => mapping(address => uint256)) private _erc20Released;


    /**
     * dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
     * the matching position in the `shares` array.
     *
     * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
     * duplicates in `payees`.
     */
    constructor(address[] memory payees, uint16[] memory shares_) payable {
        require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
        require(payees.length > 0, "PaymentSplitter: no payees");

        for (uint16 i = 0; i < payees.length; i++) {
            _addPayee(payees[i], shares_[i]);
        }
        //Can add tokens eg wrapped ETH
        //_addToken(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);
    }

    /**
     * dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
     * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
     * reliability of the events, and not the actual splitting of Ether.
     *
     * To learn more about this see the Solidity documentation for
     * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
     * functions].
     */
    receive() external payable virtual {
        emit PaymentReceived(_msgSender(), msg.value);
    }

    /**
     * dev Getter for the total shares held by payees.
     */
    function totalShares() public view returns (uint256) {
        return _totalShares;
    }

    /**
     * dev Getter for the total amount of Ether already released.
     */
    function totalReleased() public view returns (uint256) {
        return _totalReleased;
    }

    /**
     * dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
     * contract.
     */
    function totalReleasedToken(IERC20 token) public view returns (uint256) {
        return _erc20TotalReleased[token];
    }

    /**
     * dev Getter for the amount of shares held by an account.
     */
    function shares(address account) public view returns (uint256) {
        return _shares[account];
    }

    /**
     * dev Getter for the amount of Ether already released to a payee.
     */
    function released(address account) public view returns (uint256) {
        return _released[account];
    }

    /**
     * dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
     * IERC20 contract.
     */
    function releasedToken(IERC20 token, address account) public view returns (uint256) {
        return _erc20Released[token][account];
    }

    /**
     * dev Getter for the address of the payee number `index`.
     */
    function payee(uint256 index) public view returns (address) {
        return _payees[index];
    }

    /**
     * dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
     * total shares and their previous withdrawals.
     */
    function _release(address payable account) internal virtual {
        uint256 totalReceived = address(this).balance + totalReleased();
        uint256 payment = _pendingPayment(account, totalReceived, released(account));
 
        //in case calculation is wrong then give remaining balance
        if (payment > address(this).balance) {
            payment = address(this).balance;
        }

        if (payment > 0) {
            _released[account] += payment;
            _totalReleased += payment;

            Address.sendValue(account, payment);
            emit PaymentReleased(account, payment);
        }
    }

    /**
     * dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
     * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
     * contract.
     */
    function _releaseToken(IERC20 token, address payable account) internal virtual {
        uint256 totalReceived = token.balanceOf(address(this)) + totalReleasedToken(token);
        uint256 payment = _pendingPayment(account, totalReceived, releasedToken(token, account));

        //in case calculation is wrong then give remaining balance
        if (payment > token.balanceOf(address(this))) {
            payment = token.balanceOf(address(this));
        }

        if (payment > 0) {
            _erc20Released[token][account] += payment;
            _erc20TotalReleased[token] += payment;

            SafeERC20.safeTransfer(token, account, payment);
            emit ERC20PaymentReleased(token, account, payment);
        }
    }

    /**
     * dev internal logic for computing the pending payment of an `account` given the token historical balances and
     * already released amounts.
     */
    function _pendingPayment(
        address account,
        uint256 totalReceived,
        uint256 alreadyReleased
    ) private view returns (uint256) {
        uint256 _pending;
        if (_totalShares == 0) {
            _pending = 0;
        } else {
            _pending = (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
        }
        return _pending;
    }

    /**
     * dev Add a new payee to the contract.
     * param account The address of the payee to add.
     * param shares_ The number of shares owned by the payee.
     */
    function _addPayee(address account, uint16 shares_) internal virtual {
        uint256 i;
        uint256 j;

        require(Address.isContract(account) == false, "PaymentSplitter: no contracts");

        //prevent duplicates as can be run after contract deployed
        uint payeeExists;
        for (i = 0; i < _payees.length; i++) {
            if (_payees[i] == account) {
                payeeExists = 1;
            }
        }

        //if new payee then add
        if (payeeExists == 0) {
            //make pay outs and reset values so next payout is correct
            if (shares_ > 0) {
                _withdraw();
                _totalReleased = 0;
                for (i = 0; i < _payees.length; i++) {
                    _released[_payees[i]] = 0;
                }

                //for each token
                for (j = 0; j < _tokenList.length; j++) {
                    IERC20 token = _tokenList[j];
                    _erc20TotalReleased[token] = 0;            
                    for (i = 0; i < _payees.length; i++) {
                        _erc20Released[token][_payees[i]] = 0;
                    }
                }
            }

            _payees.push(account);
            _shares[account] = shares_;
            _totalShares = _totalShares + shares_;
            emit PayeeAdded(account, shares_);
        }
    }

    // dev set shares of payout account
    function _setShares(address account, uint256 shares_) internal virtual {
        uint256 i;
        uint256 j;
        uint256 pendingTotal;

        //make sure payee exists
        uint payeeExists = 0;
        for (i = 0; i < _payees.length; i++) {
            if (_payees[i] == account) {
                payeeExists = 1;
            }
        }
        require(payeeExists == 1, "PaymentSplitter: payee does not exist, add payee first");

        pendingTotal = _totalShares - _shares[account] + shares_;
        require(pendingTotal > 0, "PaymentSplitter: total shares must be greater than 0");

        //make pay outs and reset values so next payout is correct
        _withdraw();
        _totalReleased = 0;
        for (i = 0; i < _payees.length; i++) {
            _released[_payees[i]] = 0;
        }

        //for each token
        for (j = 0; j < _tokenList.length; j++) {
            IERC20 token = _tokenList[j];
            _erc20TotalReleased[token] = 0;            
            for (i = 0; i < _payees.length; i++) {
                _erc20Released[token][_payees[i]] = 0;
            }
        }

        _totalShares = pendingTotal;
        _shares[account] = shares_;
    }

    // dev add erc20 token address to the list
    function _addToken(address token) internal virtual {
        require(Address.isContract(token) == true, "PaymentSplitter: must be a contract");

        //test if token exists
        IERC20(token).balanceOf(address(this));

        //prevent duplicates as can be run after contract deployed
        uint tokenExists = 0;
        for (uint256 i = 0; i < _tokenList.length; i++) {
            if (_tokenList[i] == IERC20(token)) {
                tokenExists = 1;
            }
        }
        require(tokenExists == 0, "PaymentSplitter: token already added");

        _tokenList.push(IERC20(token));
    }

    // dev show list of erc20 tokens added in payment splitter
    function showTokens() public view returns (IERC20[] memory) {
        return _tokenList;
    }

    // dev show list of payees added in payment splitter
    function showPayees() public view returns (address[] memory) {
        return _payees;
    }

    // dev releases payments for all payees for ETH and all tokens
    function _withdraw() internal virtual {
        //for each payee
        for (uint256 i = 0; i < _payees.length; i++) {

            //for each token
            for (uint256 j = 0; j < _tokenList.length; j++) {
                IERC20 token = _tokenList[j];
                _releaseToken(token, payable(_payees[i]));
            }

            _release(payable(_payees[i]));
        }
    }
}
