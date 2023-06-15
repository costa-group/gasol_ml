// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

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

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, with an overflow flag.
   *
   * _Available since v3.4._
   */
  function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
  unchecked {
    uint256 c = a + b;
    if (c < a) return (false, 0);
    return (true, c);
  }
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
   *
   * _Available since v3.4._
   */
  function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
  unchecked {
    if (b > a) return (false, 0);
    return (true, a - b);
  }
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
   *
   * _Available since v3.4._
   */
  function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
  unchecked {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) return (true, 0);
    uint256 c = a * b;
    if (c / a != b) return (false, 0);
    return (true, c);
  }
  }

  /**
   * @dev Returns the division of two unsigned integers, with a division by zero flag.
   *
   * _Available since v3.4._
   */
  function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
  unchecked {
    if (b == 0) return (false, 0);
    return (true, a / b);
  }
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
   *
   * _Available since v3.4._
   */
  function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
  unchecked {
    if (b == 0) return (false, 0);
    return (true, a % b);
  }
  }

  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   *
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    return a + b;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   *
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return a - b;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   *
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    return a * b;
  }

  /**
   * @dev Returns the integer division of two unsigned integers, reverting on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator.
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return a / b;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * reverting when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return a % b;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * CAUTION: This function is deprecated because it requires allocating memory for the error
   * message unnecessarily. For custom revert reasons use {trySub}.
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   *
   * - Subtraction cannot overflow.
   */
  function sub(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
  unchecked {
    require(b <= a, errorMessage);
    return a - b;
  }
  }

  /**
   * @dev Returns the integer division of two unsigned integers, reverting with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function div(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
  unchecked {
    require(b > 0, errorMessage);
    return a / b;
  }
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * reverting with custom message when dividing by zero.
   *
   * CAUTION: This function is deprecated because it requires allocating memory for the error
   * message unnecessarily. For custom revert reasons use {tryMod}.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function mod(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
  unchecked {
    require(b > 0, errorMessage);
    return a % b;
  }
  }
}

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

interface INFTContract {
  function mint(address to, uint256 tokenId) external;
}

contract TallyternityAuction is Ownable {
  using SafeMath for uint256;
  event BidEvent(uint256 day, address from, uint256 amount);

  struct Bid {
    address from;
    uint256 amount;
  }

  uint256 public startAt = 1656633600;
  mapping (uint256 => Bid[]) private bids;
  INFTContract NFTContract;

  constructor(address contractAddress) {
    NFTContract = INFTContract(contractAddress);
  }

  function getDay() view public returns (uint256) {
    if (block.timestamp < startAt)
      return 0;

    return getDayForTimestamp(block.timestamp);
  }

  function getDayForTimestamp(uint256 timestamp) view public returns (uint256) {
    if (timestamp < startAt)
      return 0;

    return (timestamp - startAt).div(86400) + 1;
  }

  function bid() payable public {
    uint256 day = getDay();
    require(day > 0, "Auctions not started yet");
    require(msg.value > 0, "Missing amount");

    if (getTotalBidsForDay(day) > 0) {
      Bid memory lastBid = getLastBidForDay(day);
      require(msg.value > lastBid.amount, "Amount must be higher than last bid");

      payable(lastBid.from).transfer(lastBid.amount);
    }

    Bid memory newBid = Bid(msg.sender, msg.value);
    bids[day].push(newBid);

    emit BidEvent(day, msg.sender, msg.value);
  }

  function getTotalBidsForDay(uint256 day) view public returns (uint256) {
    return bids[day].length;
  }

  function getBidsForDay(uint256 day) view public returns (Bid[] memory) {
    return bids[day];
  }

  function getBidForDayAtIndex(uint256 day, uint256 index) view public returns (Bid memory) {
    require(index < getTotalBidsForDay(day), "Index doesn't exist");

    return bids[day][index];
  }

  function getLastBidForDay(uint256 day) view public returns (Bid memory) {
    uint256 totalBidsForDay = getTotalBidsForDay(day);
    require(totalBidsForDay > 0, "No bids for day");

    return getBidForDayAtIndex(day, totalBidsForDay - 1);
  }

  function withdraw() external payable onlyOwner {
    uint256 day = getDay();

    if (getTotalBidsForDay(day) > 0) {
      Bid memory lastBid = getLastBidForDay(day);
      uint256 withdrawableAmount = address(this).balance.sub(lastBid.amount);
      (bool payment, ) = payable(owner()).call{value: withdrawableAmount}("");
      require(payment);
    } else {
      (bool payment, ) = payable(owner()).call{value: address(this).balance}("");
      require(payment);
    }
  }

  function mint(uint256 day) public {
    require(getDay() > day, "Auction not finished yet");

    if (getTotalBidsForDay(day) > 0) {
      Bid memory lastBid = getLastBidForDay(day);
      NFTContract.mint(lastBid.from, day);
    } else {
      NFTContract.mint(owner(), day);
    }
  }
}