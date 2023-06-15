pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

error OnlySuperAdminCanExecuteThisFunction();
error OnlyAdminsCanExecuteThisFunction();
error CanNotSetToTheZeroAddress();
error KillSwitchIsEngaged();


/// notice Interface covering the calls in the "FORWARDING CALLS : NAMED FUNCTIONS"  
/// section below.
interface OwnedContract {
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
    function withdraw(address recipient) external;
}


/// author reggie rumsfeld  ΞTHUNDERGROUND.xyz
/// notice A smart contract owner with role based access control logic
/// dev Introduces simple role based access control to ownable contracts, e.g. 
/// where such logic is absent in the owned contract.

/// The contract distinguishes between 1.) a SUPER admin (e.g. the project owner)
/// and 2.) a regular admin (e.g. the dev on a project).

/// This contract('s address) is to be appointed as owner of the ownable contract. From there on,
/// functions on that contract which are subject to the modifier onlyOwner, can only be called 
/// successfully through this contract, with this contract as msg.sender.

/// The named functions in the section FORWARDING CALLS, CALL the eponymous function 
/// selectors on the owned contracts. Here, these functions are of a financial / 
/// proprietorial nature, and - hence - the prerogative of the SUPER admin (onlySuper modifier). 

/// Data with a function selector which can not be indentified on this contract, will 
/// be forwared (by means of the CALL opcode - NOT DELEGATECALL) to the owned contract via the 
/// fallback() function. This function is subject to the onlyAdmin modfier. This means that any function 
/// on the owned contract, which is not specifically addressed/named on this contract, can be called
/// by BOTHthe admin and the superadmin (via the fallback()).

contract ContractOwner {

    /// notice The address of the contract owned and to which the calls are delegated/forwarded
    address public delegate;

    /// notice The address of the super admin
    address public superadmin;

    /// notice The address of the regular admin
    address public admin;

    uint256 private _killSwitch;

    event KillSwitchDisengaged();
    event BalanceWithdrawn(address indexed recipient);
    event DelegateSet(address indexed delegate);
    event SuperAdminSet(address indexed superAdmin);
    event AdminSet(address indexed admin);
    event ReceivedEth(address indexed from, uint256 indexed amount);

    ///////////////
    // MODIFIERS //
    ///////////////
    
    modifier onlySuper {
        if(msg.sender != superadmin) 
            revert OnlySuperAdminCanExecuteThisFunction();
        _;
    }

    modifier onlyAdmin {
        if(msg.sender != superadmin && msg.sender != admin) 
            revert OnlyAdminsCanExecuteThisFunction();
        _;
    }

    modifier notZeroAddress(address toBeUsed) {
        if(toBeUsed == address(0)) revert CanNotSetToTheZeroAddress();
        _;
    }

    /// notice Checks if the kill switch is off and turns it back "on",
    /// by setting the value of _killSwitch to 0, if passing the check.
    modifier killSwitch() {
        if(!killSwitchOff()) revert KillSwitchIsEngaged();
        _killSwitch = 0;
        _;
    }

    /////////////////
    // CONSTRUCTOR //
    /////////////////

    constructor(address delegate_, address superadmin_) {
        _setDelegate(delegate_);
        _setSuper(superadmin_);
    }

    /////////////
    // RECEIVE //
    /////////////

    receive() external payable {
        emit ReceivedEth(msg.sender, msg.value);
    }

    ///////////////////////
    // ADMIN: KILLSWITCH //
    ///////////////////////

    /// notice Turning off the killswitch
    /// dev Setting the killswitch to the current timestamp, as to pass the 
    /// killSwitchOff modifier requirements. Functions which have the potential to "lock out",
    /// require disengaging the kill switch.
    function turnOffKillSwitch() external onlySuper {
        _killSwitch = block.timestamp;
        emit KillSwitchDisengaged();
    }

    /// notice Indicates wether the killswitch is turned off.
    function killSwitchOff() public view returns (bool) {
        if (_killSwitch == 0 || _killSwitch + 40 < block.timestamp) return false;
        return true;
    }

    //////////////////
    // ADMIN: ROLES //
    //////////////////

    /// notice Renounce the role of super admin
    function renounceSuper() external onlySuper killSwitch {
        _setSuper(address(0));
    }

    /// notice Renounce the role of admin
    function renounceAdmin() external onlyAdmin {
        _setAdmin(address(0));
    }
   
    /// notice Setting the super admin on THIS contract
    function setSuper(address newSuper) public notZeroAddress(newSuper) onlySuper killSwitch {
        _setSuper(newSuper);
    }

    /// notice Setting the lesser admin on THIS contract
    function setAdmin(address newAdmin) public notZeroAddress(newAdmin) onlySuper {
        _setAdmin(newAdmin);
    }

    function _setSuper(address newSuper) internal {
        superadmin = newSuper;
        emit SuperAdminSet(newSuper);
    }

    function _setAdmin(address newAdmin) internal {
        admin = newAdmin;
        emit AdminSet(newAdmin);
    }

    /////////////////
    // ADMIN: MISC //
    /////////////////

    /// notice Withdrawing the full balance of THIS contract
    /// dev Named so, as to not interfere with the withdraw(address) function 
    /// selector below.
    function withdrawal(address payable recipient) external onlySuper notZeroAddress(recipient) {
        (bool sent, ) = recipient.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    /// notice Set a different address to forward the calls to
    function setDelegate(address delegate_) external onlySuper {
        _setDelegate(delegate_);
    }

    function _setDelegate(address delegate_) internal {
        delegate = delegate_;
        emit DelegateSet(delegate_);
    }

    ////////////////////////////////////////
    // FORWARDING CALLS : NAMED FUNCTIONS //
    //////////////////////////////////////// 

    /// dev The functions below constitute CALLS to the delegate contract.
    /// The named functions are reserved to be performed by the superadmin role only.
    /// notice renounce ownerships of THE OWNED CONTRACT
    function renounceOwnership() external onlySuper killSwitch {
        OwnedContract(delegate).renounceOwnership();
    }

    /// notice transfer ownerships of THE OWNED CONTRACT
    /// dev renounce- and transferOwnership are part of OZ's Ownable module, and hence 
    /// in the abi of contracts inheriting said module. Specifically dealing with them 
    /// here, allows me to make them the prerogative of the super admin.
    function transferOwnership(address newOwner) external onlySuper killSwitch {
        OwnedContract(delegate).transferOwnership(newOwner);
    }

    /// notice Withdrawing the full balance of THE OWNED CONTRACT to the msg.sender.
    /// This function is included as a safer withdraw option than withdraw(address), since it 
    /// leaves no room for copy/paste errors: it passes msg.sender as an argument to 
    /// withdraw(address) below.
    function withdrawToSender() external {
        withdraw(msg.sender);
    }

    /// notice Withdrawing the full balance of THE OWNED CONTRACT to the recipient
    /// ********************************
    ///   !!!   HERE BE DRAGONS   !!!  
    /// ********************************
    /// dev tailored to the withdraw function on the contract I designed this one for.
    /// To be adjusted to the comparable function selector on the contract
    /// this contract will own. If such function selector is different then withdraw(address),
    /// - e.g. withdraw(address recipient, uint256 amount) - and not EXPLICITLY dealt with in this 
    /// section, the regular admin will be able to withdraw balance from the owned 
    /// contract (via the fallback() function).
    function withdraw(address recipient) public onlySuper notZeroAddress(recipient) {
        OwnedContract(delegate).withdraw(recipient);
        emit BalanceWithdrawn(recipient);
    }

    /////////////////////////////////
    // FORWARDING CALLS : FALLBACK //
    /////////////////////////////////

    /// notice Calls the owned contract with msg.data for any unidentified function selector,
    /// to the extent the caller is an admin (super or lesser).
    fallback() external payable onlyAdmin {
        assembly {
            let _target := sload(0)
            calldatacopy(0x0, 0x0, calldatasize())
            let result := call(gas(), _target, callvalue(), 0x0, calldatasize(), 0x0, 0)
            returndatacopy(0x0, 0x0, returndatasize())
            switch result case 0 {revert(0, 0)} default {return (0, returndatasize())}
        }
    }
}