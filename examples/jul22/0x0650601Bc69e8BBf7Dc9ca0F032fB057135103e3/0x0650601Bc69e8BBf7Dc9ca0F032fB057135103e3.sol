// Sources flattened with hardhat v2.9.3 https://hardhat.org

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0

// SPDX-License-Identifier: UNLICENSED
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File @openzeppelin/contracts/proxy/Clones.sol@v4.5.0
// OpenZeppelin Contracts v4.4.1 (proxy/Clones.sol)

//pragma solidity ^0.8.0;

/**
 * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
 * deploying minimal proxy contracts, also known as "clones".
 *
 * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
 * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
 *
 * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
 * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
 * deterministic method.
 *
 * _Available since v3.4._
 */
library Clones {
    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create opcode, which should never revert.
     */
    function clone(address implementation) internal returns (address instance) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, implementation))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            instance := create(0, ptr, 0x37)
        }
        require(instance != address(0), "ERC1167: create failed");
    }

    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create2 opcode and a `salt` to deterministically deploy
     * the clone. Using the same `implementation` and `salt` multiple time will revert, since
     * the clones cannot be deployed twice at the same address.
     */
    function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, implementation))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            instance := create2(0, ptr, 0x37, salt)
        }
        require(instance != address(0), "ERC1167: create2 failed");
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(
        address implementation,
        bytes32 salt,
        address deployer
    ) internal pure returns (address predicted) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, implementation))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
            mstore(add(ptr, 0x38), shl(0x60, deployer))
            mstore(add(ptr, 0x4c), salt)
            mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
            predicted := keccak256(add(ptr, 0x37), 0x55)
        }
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(address implementation, bytes32 salt)
        internal
        view
        returns (address predicted)
    {
        return predictDeterministicAddress(implementation, salt, address(this));
    }
}


// File contracts/utils/IOtoCoMaster.sol
//pragma solidity ^0.8.0;

interface IOtoCoMaster {

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev See {OtoCoMaster-baseFee}.
     */
    function baseFee() external view returns (uint256 fee);

    receive() external payable;
}


// File contracts/utils/IOtoCoPlugin.sol
//pragma solidity ^0.8.0;

interface IOtoCoPlugin {

    /**
     * Plugin initializer with a fuinction template to be used.
     * @dev To decode initialization data use i.e.: (string memory name) = abi.decode(pluginData, (string));
     *
     * @param pluginData The parameters to create a new instance of plugin.
     */
    function addPlugin(uint256 seriesId, bytes calldata pluginData) external payable;

    /**
     * Allow attach a previously deployed plugin if possible
     * @dev This function should run enumerous amounts of verifications before allow the attachment.
     * @dev To decode initialization data use i.e.: (string memory name) = abi.decode(pluginData, (string));
     *
     * @param pluginData The parameters to remove a instance of the plugin.
     */
    function attachPlugin(uint256 seriesId, bytes calldata pluginData) external payable;

    /**
     * Plugin initializer with a fuinction template to be used.
     * @dev To decode initialization data use i.e.: (string memory name) = abi.decode(pluginData, (string));
     *
     * @param pluginData The parameters to remove a instance of the plugin.
     */
    function removePlugin(uint256 seriesId, bytes calldata pluginData) external payable;
}


// File @openzeppelin/contracts/utils/Context.sol@v4.5.0
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

//pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File contracts/OtoCoPlugin.sol
//pragma solidity ^0.8.0;



abstract contract OtoCoPlugin is IOtoCoPlugin, Ownable {

    // Reference to the OtoCo Master to transfer plugin cost
    IOtoCoMaster public otocoMaster;

    /**
     * Modifier to allow only series owners to change content.
     * @param tokenId The plugin index to update.
     */
    modifier onlySeriesOwner(uint256 tokenId) {
        require(otocoMaster.ownerOf(tokenId) == msg.sender, "OtoCoPlugin: Not the entity owner.");
        _;
    }

    /**
     * Modifier to check if the function set the correct amount of ETH value and transfer it to master.
     * If baseFee are 0 or sender is OtoCoMaster this step is jumped.
     * @dev in the future add/attact/remove could be called from OtoCo Master. In those cases no transfer should be called.
     */
    modifier transferFees() {
        if (otocoMaster.baseFee() > 0 && msg.sender != address(otocoMaster)) payable(otocoMaster).transfer(msg.value);
        _;
    }

    constructor(address payable _otocoMaster) Ownable() {
        otocoMaster = IOtoCoMaster(_otocoMaster);
    }

    /**
     * Plugin initializer with a fuinction template to be used.
     * @dev To decode initialization data use i.e.: (string memory name) = abi.decode(pluginData, (string));
     * @dev Override this function to implement your elements.
     * @param pluginData The parameters to create a new instance of plugin.
     */
    function addPlugin(uint256 seriesId, bytes calldata pluginData) external payable virtual override;

    /**
     * Allow attach a previously deployed plugin if possible
     * @dev This function should run enumerous amounts of verifications before allow the attachment.
     * @dev To decode initialization data use i.e.: (string memory name) = abi.decode(pluginData, (string));
     * @dev Override this function to implement your elements.
     * @param pluginData The parameters to remove a instance of the plugin.
     */
    function attachPlugin(uint256 seriesId, bytes calldata pluginData) external payable virtual override {
        revert("OtoCoPlugin: Attach elements are not possible on this plugin.");
    }

    /**
     * Plugin initializer with a fuinction template to be used.
     * @dev To decode initialization data use i.e.: (string memory name) = abi.decode(pluginData, (string));
     * @dev Override this function to implement your elements.
     * @param pluginData The parameters to remove a instance of the plugin.
     */
    function removePlugin(uint256 seriesId, bytes calldata pluginData) external payable virtual override {
        revert("OtoCoPlugin: Remove elements are not possible on this plugin.");
    }
}


// File contracts/plugins/Token.sol
//pragma solidity ^0.8.0;



interface ISeriesToken {
  function initialize (string memory name, string memory symbol, uint256 supply, address member) external;
}

/**
 * Token factory plugin
 */
contract Token is OtoCoPlugin {

    event TokenAdded(uint256 indexed series, address token);
    event TokenRemoved(uint256 indexed series, address token);

    // Token source contract to be cloned
    address public tokenContract;
    // Mapping from entities to deployed tokens
    mapping(uint256 => uint256) public tokensPerEntity;
    // Mapping from entities to deployed tokens
    mapping(uint256 => address[]) public tokensDeployed;


    /**
    * Constructor for Token Plugin.
    *
    * @param otocoMaster Address from the Master contract.
    * @param token Address from the token source contract to be cloned.
    * @param prevIds Previously deployed token series indexes.
    * @param prevTokens Addresses from the tokens previously deployed.
     */
    constructor(
        address payable otocoMaster,
        address token,
        uint256[] memory prevIds,
        address[] memory prevTokens
    ) OtoCoPlugin(otocoMaster) {
        tokenContract = token;
        for (uint i = 0; i < prevIds.length; i++ ) {
            tokensDeployed[prevIds[i]].push(prevTokens[i]);
            tokensPerEntity[prevIds[i]]++;
            emit TokenAdded(prevIds[i], prevTokens[i]);
        }
    }

    /**
    * Update token contract base source.
    *
    * @param newAddress New token source to be used
     */
    function updateTokenContract(address newAddress) public onlyOwner {
        tokenContract = newAddress;
    }

    /**
    * Create a new token for the entity. May only be called by the owner of the series.
    *
    * @param pluginData Encoded parameters to create a new token.
    * @dev seriesId would be the series that will own the token.
    * @dev supply the total supply of tokens to be issued.
    * @dev name the name of the token as string.
    * @dev symbol the symbol that respresent the token.
     */
    function addPlugin(uint256 seriesId, bytes calldata pluginData) public onlySeriesOwner(seriesId) transferFees() payable override {
        (
            uint256 supply,
            string memory name,
            string memory symbol,
            address holder
        ) = abi.decode(pluginData, (uint256, string, string, address));
        address newToken = Clones.clone(tokenContract);
        ISeriesToken(newToken).initialize(name, symbol, supply, holder);
        tokensDeployed[seriesId].push(newToken);
        tokensPerEntity[seriesId]++;
        emit TokenAdded(seriesId, newToken);
    }

    /**
    * Attaching a pre-existing token to the entity. May only be called by the entity owner.
    *
    * @param pluginData Encoded parameters to create a new token.
    * @dev seriesId Series to remove token from
    * @dev newToken Token address to be attached
     */
    function attachPlugin(uint256 seriesId, bytes calldata pluginData) public onlySeriesOwner(seriesId) transferFees() payable override {
        (
            address newToken
        ) = abi.decode(pluginData, (address));
        tokensDeployed[seriesId].push(newToken);
        tokensPerEntity[seriesId]++;
        emit TokenAdded(seriesId, newToken);
    }

    /**
    * Remove token from entity
    *
    * @param pluginData Encoded parameters to create a new token.
    * @dev seriesId Series to remove token from
    * @dev toRemove Token index to be removed
     */
    function removePlugin(uint256 seriesId, bytes calldata pluginData) public onlySeriesOwner(seriesId) transferFees() payable override {
        (
            uint256 toRemove
        ) = abi.decode(pluginData, (uint256));
        address tokenRemoved = tokensDeployed[seriesId][toRemove];
        // Copy last token to the removed slot
        tokensDeployed[seriesId][toRemove] = tokensDeployed[seriesId][tokensDeployed[seriesId].length - 1];
        // Remove the last token from array
        tokensDeployed[seriesId].pop();
        tokensPerEntity[seriesId]--;
        emit TokenRemoved(seriesId, tokenRemoved);
    }
}