// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Context.sol";
import "./ReentrancyGuard.sol";

/// title This is an abstract to construct a safe contract, i.e. a smart contract containing a vault
///  which secures a safe of entrusted funds.
/// author Kenny Zen (https://kennyzen.co)
/// dev Info on how the various aspects of safe contracts fit together are documented in the safe contract Complex Cipher.
abstract contract Vaulted is Context, ReentrancyGuard {

  // The official Ethereum burn address
  address public burn = 0x000000000000000000000000000000000000dEaD;

  struct Vault {
    uint256 safe; // a trusted balance of pecuniary funds
    mapping(address => uint256) trust; // a map of an address to its trusted balance
  }

  /// dev The total trusted balance for this contract is kept in the safe of the Vault struct _vault.
  /// notice The amount of funds kept in the vault's safe is only accessible to the address of the
  ///  account which has deposited or been entrusted funds.
  Vault private _vault;

  /**
   * Get the trusted balance of a particular account (the account's trust).
   * dev Only the account with a trusted balance greater than cipher (0) can claim from its trust.
   * param _account The address of the account for which to retrieve the trust
   */
  function account(address _account) public view returns (uint256) {
    return _vault.trust[_account];
  }

  /**
   * Get the sum of funds entrusted to the vault's safe, i.e. the total trusted balance for this contract.
   * dev Any account can add a trusted amount to the vault's safe. Any account with a trust greater
   *  than cipher (0) can claim from the vault's safe an amount no greater than the account's trust.
   */
  function safe() public view returns (uint256) {
    return _vault.safe;
  }

  /**
   * Add to the trusted balance of a particular account (the account's trust).
   * dev Callable internally only. Use this function when receiving value to augment the balance
   *  of the vault's safe.
   * param _account The address of the account for which to increase the trust
   * param _amount The pecuniary amount by which to increase the trust and the vault's safe in wei
   */
  function _augment(address _account, uint256 _amount) internal {
    _vault.trust[_account] += _amount;
    _vault.safe += _amount;
  }

  /**
   * Take away from the trusted balance of a particular account (the account's trust).
   * dev Callable internally only. For use when sending value from the safe contract to deplete
   *  the balance of the vault's safe.
   * param _account The address of the account for which to decrease the trust
   * param _amount The pecuniary amount by which to decrease the trust and the vault's safe in wei
   * notice USE WITH CARE: Derivative logic MUST NOT allow for the depletion of entrusted funds in the
   *  vault's safe. Special attention MUST be paid to ensure the security of the vault's safe FOREVER.
   */
  function _deplete(address _account, uint256 _amount) internal {
    require(_vault.safe >= _amount && _vault.trust[_account] >= _amount, "Insufficient funds in vault.");
    _vault.trust[_account] -= _amount;
    _vault.safe -= _amount;
  }

  /**
   * Deposit an amount to the trust of a particular account.
   * dev Callable by any address. The _account cannot be the cipher (0) or the burn address.
   * param _account The address of the account to which to entrust deposited funds
   */
  function deposit(address _account) external payable nonReentrant {
    require(_account != address(0) && _account != burn, "Cannot deposit funds to burn.");
    _augment(_account, msg.value);
  }

  /**
   * Withdraw an amount from the trust of a particular account.
   * dev Callable by the _account only. Throws on insufficient funds. See {_send}. Can be overridden
   *  to extend or restrict behaviour.
   * param _account The address of the account from which to withdraw entrusted funds
   * param _amount The pecuniary amount to withdraw in wei
   * notice USE WITH CARE: Overwrites of this or the `dispatch` function without a call to the
   *  `_send` function may leave the balance of this safe contract untouchable.
   */
  function withdraw(address _account, uint256 _amount) external virtual {
    _send(_account, _account, _amount);
  }

  /**
   * dev See {_send}. Can be overridden to extend or restrict behaviour.
   * notice USE WITH CARE: Overwrites of this or the `withdraw` function without a call to the
   *  `_send` function may leave the balance of this safe contract untouchable.
   */
  function dispatch(address _from, address _to, uint256 _amount) external virtual {
    _send(_from, _to, _amount);
  }

  /**
   * Send an amount from the trust of the _from account to the _to address.
   * dev Callable by _from only. Throws on insufficient funds or if _to is the cipher (0)
   *  or the burn address.
   * param _from The account from which to dispatch the _amount of trust funds
   * param _to The account to which to send the _amount of funds
   * param _amount The pecuniary amount to send in wei
   */
  function _send(address _from, address _to, uint256 _amount) internal nonReentrant {
    require(_from == _msgSender(), "Unauthorized account.");
    require(_to != address(0) && _to != burn, "Cannot dispatch safe funds to burn.");
    require(_amount <= account(_from), "Insufficient funds in trust :(");
    _deplete(_from, _amount);
    (bool paid, ) = payable(_to).call{value: _amount}("");
    require(paid, "Payment failed :(");
  }

  /**
   * dev The `receive` function executes on calls made to the safe contract to receive ether with
   *  no data. Can be overridden to extend behaviour.
   */
  receive() virtual external payable {
    // For now, we reject any ether not sent to the vault's safe.
    // Potentially, logic could be implemented to use the `_augment` function to augment the trust
    // of the contract owner, whereupon the owner can withdraw the funds from the vault's safe, e.g.
    // _augment(owner(), msg.value);
    revert("Nonpayable");
  }

}