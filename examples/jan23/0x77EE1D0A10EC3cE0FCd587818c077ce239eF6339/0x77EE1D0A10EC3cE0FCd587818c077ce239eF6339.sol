// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Interface of the global ERC1820 Registry, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
 * implementers for interfaces in this registry, as well as query support.
 *
 * Implementers may be shared by multiple accounts, and can also implement more
 * than a single interface for each account. Contracts can implement interfaces
 * for themselves, but externally-owned accounts (EOA) must delegate this to a
 * contract.
 *
 * {IERC165} interfaces can also be queried via the registry.
 *
 * For an in-depth explanation and source code analysis, see the EIP text.
 */
interface IERC1820Registry {
  /**
   * @dev Sets `newManager` as the manager for `account`. A manager of an
   * account is able to set interface implementers for it.
   *
   * By default, each account is its own manager. Passing a value of `0x0` in
   * `newManager` will reset the manager to this initial state.
   *
   * Emits a {ManagerChanged} event.
   *
   * Requirements:
   *
   * - the caller must be the current manager for `account`.
   */
  function setManager(address account, address newManager) external;

  /**
   * @dev Returns the manager for `account`.
   *
   * See {setManager}.
   */
  function getManager(address account) external view returns (address);

  /**
   * @dev Sets the `implementer` contract as ``account``'s implementer for
   * `interfaceHash`.
   *
   * `account` being the zero address is an alias for the caller's address.
   * The zero address can also be used in `implementer` to remove an old one.
   *
   * See {interfaceHash} to learn how these are created.
   *
   * Emits an {InterfaceImplementerSet} event.
   *
   * Requirements:
   *
   * - the caller must be the current manager for `account`.
   * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
   * end in 28 zeroes).
   * - `implementer` must implement {IERC1820Implementer} and return true when
   * queried for support, unless `implementer` is the caller. See
   * {IERC1820Implementer-canImplementInterfaceForAddress}.
   */
  function setInterfaceImplementer(
    address account,
    bytes32 _interfaceHash,
    address implementer
  ) external;

  /**
   * @dev Returns the implementer of `interfaceHash` for `account`. If no such
   * implementer is registered, returns the zero address.
   *
   * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
   * zeroes), `account` will be queried for support of it.
   *
   * `account` being the zero address is an alias for the caller's address.
   */
  function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);

  /**
   * @dev Returns the interface hash for an `interfaceName`, as defined in the
   * corresponding
   * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
   */
  function interfaceHash(string calldata interfaceName) external pure returns (bytes32);

  /**
   * @notice Updates the cache with whether the contract implements an ERC165 interface or not.
   * @param account Address of the contract for which to update the cache.
   * @param interfaceId ERC165 interface for which to update the cache.
   */
  function updateERC165Cache(address account, bytes4 interfaceId) external;

  /**
   * @notice Checks whether a contract implements an ERC165 interface or not.
   * If the result is not cached a direct lookup on the contract address is performed.
   * If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
   * {updateERC165Cache} with the contract address.
   * @param account Address of the contract to check.
   * @param interfaceId ERC165 interface to check.
   * @return True if `account` implements `interfaceId`, false otherwise.
   */
  function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);

  /**
   * @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
   * @param account Address of the contract to check.
   * @param interfaceId ERC165 interface to check.
   * @return True if `account` implements `interfaceId`, false otherwise.
   */
  function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);

  event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);

  event ManagerChanged(address indexed account, address indexed newManager);
}

/**
 * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
 *
 * Accounts can be notified of {IERC777} tokens being sent to them by having a
 * contract implement this interface (contract holders can be their own
 * implementer) and registering it on the
 * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
 *
 * See {IERC1820Registry} and {ERC1820Implementer}.
 */
interface IERC777Recipient {
  /**
   * @dev Called by an {IERC777} token contract whenever tokens are being
   * moved or created into a registered account (`to`). The type of operation
   * is conveyed by `from` being the zero address or not.
   *
   * This call occurs _after_ the token contract's state is updated, so
   * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
   *
   * This function may revert to prevent the operation from being executed.
   */
  function tokensReceived(
    address operator,
    address from,
    address to,
    uint256 amount,
    bytes calldata userData,
    bytes calldata operatorData
  ) external;
}

/**
 * @dev Interface for an ERC1820 implementer, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1820#interface-implementation-erc1820implementerinterface[EIP].
 * Used by contracts that will be registered as implementers in the
 * {IERC1820Registry}.
 */
interface IERC1820Implementer {
  /**
   * @dev Returns a special value (`ERC1820_ACCEPT_MAGIC`) if this contract
   * implements `interfaceHash` for `account`.
   *
   * See {IERC1820Registry-setInterfaceImplementer}.
   */
  function canImplementInterfaceForAddress(bytes32 interfaceHash, address account) external view returns (bytes32);
}

contract SimpleERC777Recipient is IERC777Recipient, IERC1820Implementer {
  bytes32 private constant TOKENS_RECIPIENT_INTERFACE_HASH = keccak256('ERC777TokensRecipient');
  bytes32 private constant ERC1820_ACCEPT_MAGIC = keccak256('ERC1820_ACCEPT_MAGIC');

  IERC1820Registry public constant ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

  function tokensReceived(
    address operator,
    address from,
    address to,
    uint256 amount,
    bytes calldata userData,
    bytes calldata operatorData
  ) external override(IERC777Recipient) {
    // accept all the ERC777 tokens
  }

  /**
   * override implementation check
   */
  function canImplementInterfaceForAddress(bytes32 interfaceHash, address account)
    public
    view
    virtual
    override
    returns (bytes32)
  {
    return interfaceHash == TOKENS_RECIPIENT_INTERFACE_HASH ? ERC1820_ACCEPT_MAGIC : bytes32(0x00);
  }
}