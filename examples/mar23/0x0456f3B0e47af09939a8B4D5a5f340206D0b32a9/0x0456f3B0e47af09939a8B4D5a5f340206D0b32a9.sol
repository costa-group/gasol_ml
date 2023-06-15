// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;


////import "../utils/Context.sol";
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


////import "@openzeppelin/contracts/access/Ownable.sol";
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
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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


////import "../../utils/introspection/IERC165.sol";
/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


////import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}


////import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
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
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}


////import "./common/IERC721Monitor.sol";
interface IERC721Monitor{
    function onTransfered( address from, address to, uint256 tokenId, uint256 batchSize ) external;
}


//-----------------------------------
// BallotBox(1st)
//-----------------------------------
contract BallotBox is Ownable, IERC721Monitor, ReentrancyGuard {
    //--------------------------------------
    // event
    //--------------------------------------
    event Voted( address indexed user, uint256 indexed character, uint256 indexed candidate );
    event Unvoted( address indexed user, uint256 indexed character, uint256 indexed candidate );

    //--------------------------------------
    // constant
    //--------------------------------------
    uint256 constant private BLOCK_SEC_MARGIN = 30;
    uint256 constant private NUM_CHARACTER = 3;         // 0 〜 2
    uint256 constant private NUM_CANDIDATE = 160;       // 0 〜 159

    //-----------
    // mainnet
    //-----------
    address constant private NFT_ADDRESS = 0x47Ec63b17bA222d7Cc17bF7A17b05049E5975C16;

/*
    //-----------
    // testnet
    //-----------
    address constant private NFT_ADDRESS = 0x1C0E344A778B1035cf82e5c00b786219Ce42B08D;
*/

    //--------------------------------------
    // enum
    //--------------------------------------
    uint256 constant private INFO_VOTE_FINISHED = 0;
    uint256 constant private INFO_VOTE_SUSPENDED = 1;
    uint256 constant private INFO_VOTE_START = 2;
    uint256 constant private INFO_VOTE_END = 3;
    uint256 constant private INFO_USER_VOTABLE = 4;
    uint256 constant private INFO_USER_VOTED = 5;
    uint256 constant private INFO_USER_MAX = 6;

    //--------------------------------------
    // storage
    //--------------------------------------
    IERC721 private _nft;

    bool private _is_finished;
    bool private _is_suspended;
    uint256 private _start;
    uint256 private _end;

    uint256[NUM_CHARACTER*NUM_CANDIDATE] private _arr_count;
    mapping( address => uint256[] ) private _map_history_of_voter;
    mapping( address => uint256 ) private _map_no_of_voter;
    address[] private _arr_voter;

    //--------------------------------------------------------
    // [modifier] onlyOwnerOrVoter
    //--------------------------------------------------------
    modifier onlyOwnerOrVoter( address target ) {
        if( msg.sender != target ){
            _checkOwner();
        }
        _;
    }

    //--------------------------------------------------------
    // [modifier] onlyOwnerIfNotFinished
    //--------------------------------------------------------
    modifier onlyOwnerIfNotFinished() {
        if( ! _is_finished ){
            _checkOwner();
        }
        _;
    }

    //--------------------------------------------------------
    // [modifier] onlyNft
    //--------------------------------------------------------
    modifier onlyNft() {
        require( msg.sender == nft(), "caller is not the NFT" );
        _;
    }

    //--------------------------------------------------------
    // constructor
    //--------------------------------------------------------
    constructor(){
        _nft = IERC721(NFT_ADDRESS);

        //-----------------------
        // mainnet 1st
        //-----------------------
        _start = 1678458600;                // 2023-03-10 23:30:00(JST)
        _end   = 1678528800;                // 2023-03-11 19:00:00(JST)

/*
        //-----------------------
        // mainnet 2nd
        //-----------------------
        _start = 1679014800;                // 2023-03-17 10:00:00(JST)
        _end   = 1679133600;                // 2023-03-18 19:00:00(JST)
*/

/*
        //-----------------------
        // testnet
        //-----------------------
        _start = 1677978000;                // test 2023-03-05 10:00:00(JST)
        _end   = 1678446000;                // test 2023-03-10 20:00:00(JST)
*/
    }

    //--------------------------------------------------------
    // [public] nft
    //--------------------------------------------------------
    function nft() public view returns (address) {
        return( address(_nft) );
    }

    //--------------------------------------------------------
    // [external/onlyOwner] setNft
    //--------------------------------------------------------
    function setNft( address target ) external onlyOwner {
        _nft = IERC721(target);
    }

    //--------------------------------------------------------
    // [external/onlyOwner] write
    //--------------------------------------------------------
    function finish( bool flag ) external onlyOwner { _is_finished = flag; }
    function suspend( bool flag ) external onlyOwner { _is_suspended = flag; }
    function setStartEnd( uint256 start, uint256 end ) external onlyOwner { _start = start; _end = end; }

    //--------------------------------------------------------
    // [external/nonReentrant] vote
    //--------------------------------------------------------
    function vote( uint256[] calldata characters, uint256[] calldata candidates ) external nonReentrant {
        require( ! _is_finished, "vote: finished" );
        require( ! _is_suspended, "vote: suspended" );
        require( _start <= (block.timestamp+BLOCK_SEC_MARGIN), "vote: not opend" );
        require( (_end+BLOCK_SEC_MARGIN) > block.timestamp, "vote: finished" );

        require( characters.length == candidates.length, "vote: array size mismatch" );
        for( uint256 i=0; i<characters.length; i++ ){
            require( characters[i] < NUM_CHARACTER, "vote: invalid character" );
            require( candidates[i] < NUM_CANDIDATE, "vote: invalid candidate" );
        }

        address from = msg.sender;
        uint256 votable = _nft.balanceOf( from );
        require( (_map_history_of_voter[from].length+characters.length) <= votable, "vote: lack of nfts" );

        //---------------
        // check ok
        //---------------

        if( _map_no_of_voter[from] == 0 ){
            _arr_voter.push( from );
            _map_no_of_voter[from] = _arr_voter.length;
        }

        for( uint256 i=0; i<characters.length; i++ ){
            uint256 packedId = characters[i]*NUM_CANDIDATE + candidates[i];

            // vote
            _arr_count[packedId]++;
            _map_history_of_voter[from].push( packedId );
            emit Voted( from, characters[i], candidates[i] );
        }
    }

    //--------------------------------------------------------
    // [external/override/onlyNft] onTransfered(unvote)
    //--------------------------------------------------------
    function onTransfered( address from, address /*to*/, uint256 /*tokenId*/, uint256 /*batchSize*/ ) external override onlyNft {
        if( from == address(0x0) ){ return; }

        // Ensure consistency unless fininshed
        if( _is_finished ){ return; }
        //if( _is_suspended ){ return; }
        //if( _start > block.timestamp ){ return; }
        //if( _end <= block.timestamp ){ return; }

        uint256 votable = _nft.balanceOf( from );
        uint256 cur = _map_history_of_voter[from].length;
        while( votable < cur ){
            cur--;
            uint256 packedId = _map_history_of_voter[from][cur];

            // unvote
            _arr_count[packedId]--;
            _map_history_of_voter[from].pop();
            emit Unvoted( from, packedId/NUM_CANDIDATE, packedId%NUM_CANDIDATE );
        }
    }

    //--------------------------------------------------------
    // [external/onlyOwnerOrVoter] getUserInfo
    //--------------------------------------------------------
    function getUserInfo( address target ) external view onlyOwnerOrVoter(target) returns (uint256[INFO_USER_MAX] memory) {
        uint256[INFO_USER_MAX] memory arrRet;

        if( _is_finished ){ arrRet[INFO_VOTE_FINISHED] = 1; }
        if( _is_suspended ){ arrRet[INFO_VOTE_SUSPENDED] = 1; }
        arrRet[INFO_VOTE_START] = _start;
        arrRet[INFO_VOTE_END] = _end;
        arrRet[INFO_USER_VOTABLE] = _nft.balanceOf( target );
        arrRet[INFO_USER_VOTED] =  _map_history_of_voter[target].length;

        return( arrRet );
    }

    //--------------------------------------------------------
    // [external/onlyOwnerOrVoter] getVoterNo
    //--------------------------------------------------------
    function getVoterNo( address target ) onlyOwnerOrVoter(target) external view returns (uint256) {
        return( _map_no_of_voter[target] );
    }

    //--------------------------------------------------------
    // [external/onlyOwnerOrVoter] getUserHistory
    //--------------------------------------------------------
    function getUserHistory( address target ) external view onlyOwnerOrVoter(target) returns (uint256[] memory) {
        return( _map_history_of_voter[target] );
    }

    //--------------------------------------------------------
    // [external/onlyOwnerIfNotFinished] getCountOf
    //--------------------------------------------------------
    function getCountOf( uint256 character ) external view onlyOwnerIfNotFinished returns (uint256[NUM_CANDIDATE] memory) {
        require( character < NUM_CHARACTER, "invalid character" );

        uint256[NUM_CANDIDATE] memory arrCount;

        uint256 ofs = character * NUM_CANDIDATE;
        for( uint256 i=0; i<NUM_CANDIDATE; i++ ){
            arrCount[i] = _arr_count[ofs+i];
        }

        return( arrCount );
    }

    //--------------------------------------------------------
    // [external/onlyOwnerIfNotFinished] getVoterInfo
    //--------------------------------------------------------
    function getVoterInfo( uint256 pageSize, uint256 pageOfs ) onlyOwnerIfNotFinished external view returns (address[] memory, uint256[] memory) {
        uint max = _arr_voter.length;
        uint ofs = pageSize * pageOfs;
        uint num;
        if( ofs < max ){
            num = max - ofs;
            if( num > pageSize ){
                num = pageSize;
            }
        }

        address[] memory infoAddress = new address[](num);
        uint256[] memory infoCount = new uint256[](num);
        for( uint256 i=0; i<num; i++ ){
            address target = _arr_voter[ofs+i];
            infoAddress[i] = target;
            infoCount[i] = _map_history_of_voter[target].length;
        }

        return( infoAddress, infoCount );
    }

}