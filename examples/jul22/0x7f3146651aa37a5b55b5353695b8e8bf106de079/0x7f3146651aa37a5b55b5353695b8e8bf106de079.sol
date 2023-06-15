// Sources flattened with hardhat v2.9.1 https://hardhat.org

// File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.6.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


// File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.6.0

// OpenZeppelin Contracts (last updated v4.6.0) (proxy/utils/Initializable.sol)

//pragma solidity ^0.8.2;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
     */
    modifier initializer() {
        bool isTopLevelCall = _setInitializedVersion(1);
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
     * initialization step. This is essential to configure modules that are added through upgrades and that require
     * initialization.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     */
    modifier reinitializer(uint8 version) {
        bool isTopLevelCall = _setInitializedVersion(version);
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(version);
        }
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     */
    function _disableInitializers() internal virtual {
        _setInitializedVersion(type(uint8).max);
    }

    function _setInitializedVersion(uint8 version) private returns (bool) {
        // If the contract is initializing we ignore whether _initialized is set in order to support multiple
        // inheritance patterns, but we only do this in the context of a constructor, and for the lowest level
        // of initializers, because in other contexts the contract may have been reentered.
        if (_initializing) {
            require(
                version == 1 && !AddressUpgradeable.isContract(address(this)),
                "Initializable: contract is already initialized"
            );
            return false;
        } else {
            require(_initialized < version, "Initializable: contract is already initialized");
            _initialized = version;
            return true;
        }
    }
}


// File contracts/CreatorDAOCommission.sol

//pragma solidity ^0.8.2;


contract CreatorDAOCommission is Initializable {
    enum CommissionStatus {
        queued,
        accepted,
        removed
    }

    struct Shop {
        uint256 minBid;
        uint256 tax; // e.g 50 represent for 5%
        address payable owner;
    }

    struct Commission {
        address payable recipient;
        uint256 shopId;
        uint256 bid;
        CommissionStatus status;
    }

    address payable public admin;
    address payable public recipientDao;

    mapping(uint256 => Commission) public commissions;
    mapping(uint256 => Shop) public shops;

    //uint256public minBid; // the number of wei required to create a commission
    uint256 public newCommissionIndex; // the index of the next commission which should be created in the mapping
    uint256 public newShopIndex;
    bool private callStarted; // ensures no re-entrancy can occur

    modifier callNotStarted() {
        require(!callStarted, "callNotStarted");
        callStarted = true;
        _;
        callStarted = false;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "not an admin");
        _;
    }

    function initialize(address payable _admin, address payable _recipientDao)
        public
        initializer
    {
        admin = _admin;
        recipientDao = _recipientDao;
        newCommissionIndex = 1;
        newShopIndex = 1;
    }

    function updateAdmin(address payable _newAdmin)
        public
        callNotStarted
        onlyAdmin
    {
        admin = _newAdmin;
        emit AdminUpdated(_newAdmin);
    }

    function updateTaxRecipient(address payable _newRecipientDao)
        public
        callNotStarted
        onlyAdmin
    {
        recipientDao = _newRecipientDao;
    }

    function updateMinBid(uint256 _shopId, uint256 _newMinBid)
        public
        callNotStarted
        onlyAdmin
    {
        Shop storage shop = shops[_shopId];
        shop.minBid = _newMinBid;
        emit MinBidUpdated(_shopId, _newMinBid);
    }

    function commission(string memory _id, uint256 _shopId)
        public
        payable
        callNotStarted
    {
        Shop memory shop = shops[_shopId];
        require(shop.minBid != 0, "undefined shopId");
        require(msg.value >= shop.minBid, "bid below minimum"); // must send the proper amount of into the bid

        // Next, initialize the new commission
        Commission storage newCommission = commissions[newCommissionIndex];
        newCommission.shopId = _shopId;
        newCommission.bid = msg.value;
        newCommission.status = CommissionStatus.queued;
        newCommission.recipient = payable(msg.sender);

        emit NewCommission(
            newCommissionIndex,
            _id,
            _shopId,
            msg.value,
            msg.sender
        );

        newCommissionIndex++; // for the subsequent commission to be added into the next slot
    }

    function rescindCommission(uint256 _commissionIndex) public callNotStarted {
        Commission storage selectedCommission = commissions[_commissionIndex];
        require(
            msg.sender == selectedCommission.recipient,
            "commission not yours"
        ); // may only be performed by the person who commissioned it
        require(
            selectedCommission.status == CommissionStatus.queued,
            "commission not in queue"
        ); // the commission must still be queued

        // we mark it as removed and return the individual their bid
        selectedCommission.status = CommissionStatus.removed;
        (bool success, ) = selectedCommission.recipient.call{
            value: selectedCommission.bid
        }("");
        require(success, "Transfer failed.");

        emit CommissionRescinded(_commissionIndex, selectedCommission.bid);
    }

    function increaseCommissionBid(uint256 _commissionIndex)
        public
        payable
        callNotStarted
    {
        Commission storage selectedCommission = commissions[_commissionIndex];
        require(
            msg.sender == selectedCommission.recipient,
            "commission not yours"
        ); // may only be performed by the person who commissioned it
        require(
            selectedCommission.status == CommissionStatus.queued,
            "commission not in queue"
        ); // the commission must still be queued

        // then we update the commission's bid
        selectedCommission.bid = selectedCommission.bid + msg.value;

        emit CommissionBidUpdated(
            _commissionIndex,
            msg.value,
            selectedCommission.bid
        );
    }

    function processCommissions(uint256[] memory _commissionIndexes)
        public
        onlyAdmin
        callNotStarted
    {
        uint256 totalTaxAmount = 0;
        for (uint256 i = 0; i < _commissionIndexes.length; i++) {
            Commission storage selectedCommission = commissions[
                _commissionIndexes[i]
            ];

            //the queue my not be empty when processing more commissions
            require(
                selectedCommission.status == CommissionStatus.queued,
                "commission not in the queue"
            );

            selectedCommission.status = CommissionStatus.accepted; // first, we change the status of the commission to accepted

            uint256 taxAmount = (selectedCommission.bid *
                shops[selectedCommission.shopId].tax) / 1000;

            uint256 payAmount = selectedCommission.bid - taxAmount;

            totalTaxAmount = totalTaxAmount + taxAmount;

            (bool success, ) = shops[selectedCommission.shopId].owner.call{
                value: payAmount
            }(""); // next we accept the payment for the commission
            require(success, "Transfer failed.");

            emit CommissionProcessed(
                _commissionIndexes[i],
                selectedCommission.status,
                taxAmount,
                payAmount
            );
        }

        (bool success, ) = recipientDao.call{value: totalTaxAmount}("");

        require(success, "Transfer failed.");
    }

    function addShop(
        uint256 _minBid,
        uint256 _tax,
        address _owner
    ) public onlyAdmin {
        require(_minBid != 0, "minBid must not zero");
        require(_tax < 1000, "tax too high");
        Shop storage shop = shops[newShopIndex];
        shop.minBid = _minBid;
        shop.tax = _tax;
        shop.owner = payable(_owner);

        emit NewShop(newShopIndex, _minBid, _tax, _owner);
        newShopIndex++;
    }

    event AdminUpdated(address _newAdmin);
    event MinBidUpdated(uint256 _shopId, uint256 _newMinBid);
    event NewCommission(
        uint256 _commissionIndex,
        string _id,
        uint256 _shopId,
        uint256 _bid,
        address _recipient
    );
    event CommissionBidUpdated(
        uint256 _commissionIndex,
        uint256 _addedBid,
        uint256 _newBid
    );
    event CommissionRescinded(uint256 _commissionIndex, uint256 _bid);
    event CommissionProcessed(
        uint256 _commissionIndex,
        CommissionStatus _status,
        uint256 taxAmount,
        uint256 payAmount
    );
    event NewShop(
        uint256 _newShopIndex,
        uint256 _minBid,
        uint256 _tax,
        address owner
    );
}


// File contracts/CreatorDAOCommissionV1_1.sol

//pragma solidity ^0.8.2;


contract CreatorDAOCommissionV1_1 is Initializable {
    enum CommissionStatus {
        queued,
        accepted,
        removed,
        finished
    }

    struct Shop {
        uint256 minBid;
        uint256 tax; // e.g 50 represent for 5%
        address payable owner;
    }

    struct Commission {
        address payable recipient;
        uint256 shopId;
        uint256 bid;
        CommissionStatus status;
    }

    address payable public admin;
    address payable public recipientDao;

    mapping(uint256 => Commission) public commissions;
    mapping(uint256 => Shop) public shops;

    //uint256public minBid; // the number of wei required to create a commission
    uint256 public newCommissionIndex; // the index of the next commission which should be created in the mapping
    uint256 public newShopIndex;
    bool private callStarted; // ensures no re-entrancy can occur

    modifier callNotStarted() {
        require(!callStarted, "callNotStarted");
        callStarted = true;
        _;
        callStarted = false;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "not an admin");
        _;
    }

    function initialize(address payable _admin, address payable _recipientDao)
        public
        initializer
    {
        admin = _admin;
        recipientDao = _recipientDao;
        newCommissionIndex = 1;
        newShopIndex = 1;
    }

    function updateAdmin(address payable _newAdmin)
        public
        callNotStarted
        onlyAdmin
    {
        admin = _newAdmin;
        emit AdminUpdated(_newAdmin);
    }

    function updateTaxRecipient(address payable _newRecipientDao)
        public
        callNotStarted
        onlyAdmin
    {
        recipientDao = _newRecipientDao;
    }

    function updateMinBid(uint256 _shopId, uint256 _newMinBid)
        public
        callNotStarted
        onlyAdmin
    {
        Shop storage shop = shops[_shopId];
        shop.minBid = _newMinBid;
        emit MinBidUpdated(_shopId, _newMinBid);
    }

    function updateShopOwner(uint256 _shopId, address payable _newOwner)
        public
    {
        Shop storage shop = shops[_shopId];
        require(shop.owner == msg.sender, "only old owner could set new owner");
        shop.owner = _newOwner;
        emit OwnerUpdated(_shopId, _newOwner);
    }

    function commission(string memory _id, uint256 _shopId)
        public
        payable
        callNotStarted
    {
        Shop memory shop = shops[_shopId];
        require(shop.minBid != 0, "undefined shopId");
        require(msg.value >= shop.minBid, "bid below minimum"); // must send the proper amount of into the bid

        // Next, initialize the new commission
        Commission storage newCommission = commissions[newCommissionIndex];
        newCommission.shopId = _shopId;
        newCommission.bid = msg.value;
        newCommission.status = CommissionStatus.queued;
        newCommission.recipient = payable(msg.sender);

        emit NewCommission(
            newCommissionIndex,
            _id,
            _shopId,
            msg.value,
            msg.sender
        );

        newCommissionIndex++; // for the subsequent commission to be added into the next slot
    }

    function rescindCommission(uint256 _commissionIndex) public callNotStarted {
        Commission storage selectedCommission = commissions[_commissionIndex];
        require(
            msg.sender == selectedCommission.recipient,
            "Only recipient could rescind"
        ); // may only be performed by the person who commissioned it
        require(
            selectedCommission.status == CommissionStatus.queued,
            "commission not in queue"
        ); // the commission must still be queued

        // we mark it as removed and return the individual their bid
        selectedCommission.status = CommissionStatus.removed;
        (bool success, ) = selectedCommission.recipient.call{
            value: selectedCommission.bid
        }("");
        require(success, "Transfer failed.");

        emit CommissionRescinded(_commissionIndex, selectedCommission.bid);
    }

    function increaseCommissionBid(uint256 _commissionIndex)
        public
        payable
        callNotStarted
    {
        Commission storage selectedCommission = commissions[_commissionIndex];
        require(
            msg.sender == selectedCommission.recipient,
            "commission not yours"
        ); // may only be performed by the person who commissioned it
        require(
            selectedCommission.status == CommissionStatus.queued,
            "commission not in queue"
        ); // the commission must still be queued

        // then we update the commission's bid
        selectedCommission.bid = selectedCommission.bid + msg.value;

        emit CommissionBidUpdated(
            _commissionIndex,
            msg.value,
            selectedCommission.bid
        );
    }

    function processCommissions(uint256[] memory _commissionIndexes)
        public
        callNotStarted
    {
        for (uint256 i = 0; i < _commissionIndexes.length; i++) {
            Commission storage selectedCommission = commissions[
                _commissionIndexes[i]
            ];

            //the queue my not be empty when processing more commissions
            require(
                selectedCommission.status == CommissionStatus.queued,
                "commission not in the queue"
            );

            require(
                msg.sender == shops[selectedCommission.shopId].owner,
                "Only shop owner could accept commission"
            );

            selectedCommission.status = CommissionStatus.accepted; // first, we change the status of the commission to accepted

            emit CommissionProcessed(
                _commissionIndexes[i],
                selectedCommission.status
            );
        }
    }

    function settleCommissions(uint256[] memory _commissionIndexes)
        public
        onlyAdmin
        callNotStarted
    {
        uint256 totalTaxAmount = 0;
        for (uint256 i = 0; i < _commissionIndexes.length; i++) {
            Commission storage selectedCommission = commissions[
                _commissionIndexes[i]
            ];

            //the queue my not be empty when processing more commissions
            require(
                selectedCommission.status == CommissionStatus.accepted,
                "commission not in the queue"
            );

            selectedCommission.status = CommissionStatus.finished; // first, we change the status of the commission to accepted

            uint256 taxAmount = (selectedCommission.bid *
                shops[selectedCommission.shopId].tax) / 1000;

            uint256 payAmount = selectedCommission.bid - taxAmount;

            totalTaxAmount = totalTaxAmount + taxAmount;

            (bool success, ) = shops[selectedCommission.shopId].owner.call{
                value: payAmount
            }(""); // next we accept the payment for the commission
            require(success, "Transfer failed.");

            emit CommissionSettled(
                _commissionIndexes[i],
                selectedCommission.status,
                taxAmount,
                payAmount
            );
        }

        (bool success, ) = recipientDao.call{value: totalTaxAmount}("");

        require(success, "Transfer failed.");
    }

    function rescindCommissionByAdmin(uint256 _commissionIndex)
        public
        onlyAdmin
        callNotStarted
    {
        Commission storage selectedCommission = commissions[_commissionIndex];
        require(
            selectedCommission.status == CommissionStatus.accepted,
            "commission not in queue"
        ); // the commission must still be accepted

        // we mark it as removed and return the individual their bid
        selectedCommission.status = CommissionStatus.removed;
        (bool success, ) = selectedCommission.recipient.call{
            value: selectedCommission.bid
        }("");
        require(success, "Transfer failed.");

        emit CommissionRescinded(_commissionIndex, selectedCommission.bid);
    }

    function addShop(
        uint256 _minBid,
        uint256 _tax,
        address _owner
    ) public onlyAdmin {
        require(_minBid != 0, "minBid must not zero");
        require(_tax < 1000, "tax too high");
        Shop storage shop = shops[newShopIndex];
        shop.minBid = _minBid;
        shop.tax = _tax;
        shop.owner = payable(_owner);

        emit NewShop(newShopIndex, _minBid, _tax, _owner);
        newShopIndex++;
    }

    event AdminUpdated(address _newAdmin);
    event MinBidUpdated(uint256 _shopId, uint256 _newMinBid);
    event NewCommission(
        uint256 _commissionIndex,
        string _id,
        uint256 _shopId,
        uint256 _bid,
        address _recipient
    );
    event CommissionBidUpdated(
        uint256 _commissionIndex,
        uint256 _addedBid,
        uint256 _newBid
    );
    event CommissionRescinded(uint256 _commissionIndex, uint256 _bid);
    event CommissionProcessed(
        uint256 _commissionIndex,
        CommissionStatus _status
    );
    event CommissionSettled(
        uint256 _commissionIndex,
        CommissionStatus _status,
        uint256 taxAmount,
        uint256 payAmount
    );
    event NewShop(
        uint256 _newShopIndex,
        uint256 _minBid,
        uint256 _tax,
        address owner
    );
    event OwnerUpdated(uint256 _shopId, address _newOwner);
}