// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

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

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

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

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

//pragma solidity ^0.8.0;

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

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)

//pragma solidity ^0.8.0;


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
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
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

// File: @openzeppelin/contracts/interfaces/IERC721.sol


// OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)

//pragma solidity ^0.8.0;


// File: contracts/chupadeal.sol



/*                                                                                                                        
      # ###      /                                                             /                                       
    /  /###  / #/                                                            #/                                        
   /  /  ###/  ##                                                            ##                                        
  /  ##   ##   ##                                                            ##                                        
 /  ###        ##                                                            ##                                        
##   ##        ##  /##  ##   ####        /###     /###     /###      /###    ## /###   ###  /###     /###      /###    
##   ##        ## / ###  ##    ###  /   / ###  / / ###  / / ###  /  / ###  / ##/ ###  / ###/ #### / / ###  /  / #### / 
##   ##        ##/   ### ##     ###/   /   ###/ /   ###/ /   ###/  /   ###/  ##   ###/   ##   ###/ /   ###/  ##  ###/  
##   ##        ##     ## ##      ##   ##    ## ##    ## ##        ##    ##   ##    ##    ##       ##    ##  ####       
##   ##        ##     ## ##      ##   ##    ## ##    ## ##        ##    ##   ##    ##    ##       ##    ##    ###      
 ##  ##        ##     ## ##      ##   ##    ## ##    ## ##        ##    ##   ##    ##    ##       ##    ##      ###    
  ## #      /  ##     ## ##      ##   ##    ## ##    ## ##        ##    ##   ##    ##    ##       ##    ##        ###  
   ###     /   ##     ## ##      /#   ##    ## ##    /# ###     / ##    /#   ##    /#    ##       ##    /#   /###  ##  
    ######/    ##     ##  ######/ ##  #######   ####/ ## ######/   ####/ ##   ####/      ###       ####/ ## / #### /   
      ###       ##    ##   #####   ## ######     ###   ## #####     ###   ##   ###        ###       ###   ##   ###/    
                      /               ##                                                                               
                     /                ##                                                                               
                    /                 ##                                                                               
                   /                   ##       
Owner: Osos Muertos
Developer: crankydev.eth
*/

//pragma solidity >=0.7.0 <0.9.0;



interface IChupacabras is IERC721 {
    function transferOwnership(address newOwner) external;

    function mintForAddress(uint256 quantity, address _receiver) external;

    function setPublicSaleActive(bool _state) external;
}

/**
 * @title ChupacabrasDeal
 */
contract ChupacabrasDeal is Ownable {
    IChupacabras Chupacabras;

    bool public dealActive = false;
    uint256 public dealQuantity = 20;
    uint256 public dealPrice = 0.1 ether;

    address DEV_ADDRESS = 0xB4C55107c5a4650500269D6DD1b2aE0F028Cf15f;

    constructor() {
        Chupacabras = IChupacabras(0x1795f46966e2F2D98639F25aEc0bEcFc9F8ef8bb);
    }

    function mintDeal() public payable {
        require(dealActive, "Deal Not Active");
        require(msg.value >= dealPrice, "Not enough ether sent!");
        
        Chupacabras.mintForAddress(dealQuantity, msg.sender);
    }

    function setDealActive(bool active) public onlyOwner {
        dealActive = active;
    }

    function setDealPrice(uint256 price) public onlyOwner {
        dealPrice = price;
    }

    function setDealQuantity(uint256 quantity) public onlyOwner {
        dealQuantity = quantity;
    }

    function setChupacabrasPublicSaleActive(bool _state) public onlyOwner {
        Chupacabras.setPublicSaleActive(_state);
    }

    function transferChupacabrasOwnership(address newOwner) public onlyOwner {
        Chupacabras.transferOwnership(newOwner);
    }

    function setDevAddress(address developer) public {
      require(msg.sender == DEV_ADDRESS, "Not the developer!");
      DEV_ADDRESS = developer;
    }

    function withdraw() public onlyOwner {
        //
        // =============================================================================
        (bool hs, ) = payable(DEV_ADDRESS).call{
            value: (address(this).balance * 20) / 100
        }("");
        require(hs);
        // =============================================================================

        // =============================================================================
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
        // =============================================================================
    }
}