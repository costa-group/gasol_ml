import {LibAccessControl} from "../libraries/LibAccessControl.sol";
import {LibRoles} from "../libraries/LibRoles.sol";

contract WithdrawFacet {
  //----------------------------------------------------------------
  /// notice externally exposed fucntions withdraw funds
  /// dev using best practices from consensys
  // https://consensys.github.io/smart-contract-best-practices/development-recommendations/general/external-calls/#dont-use-transfer-or-send
  // ReentrancyGuard is used in this contract
  /// param withdrawTo address to send funds to
  function withdraw(address withdrawTo) external {
    LibAccessControl.enforceRole(
      LibAccessControl.getRoleAdmin(LibRoles.ADMIN_ROLE)
    );
    uint256 amount = address(this).balance;
    bool success = false;
    (success, ) = payable(withdrawTo).call{value: amount}("");
    require(success, "Transfer failed.");
  }
}
