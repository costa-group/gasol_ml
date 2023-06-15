// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract ERC721TokenReceiver {
    function onERC721Received(address, address, uint256, bytes calldata) 
    external virtual returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }
}

abstract contract ERC721 {
    
    ///// Events /////
    event Transfer(address indexed from_, address indexed to_, uint256 indexed tokenId_);
    event Approval(address indexed owner_, address indexed spender_, uint256 indexed id_);
    event ApprovalForAll(address indexed owner_, address indexed operator_, bool approved_);
    
    ///// Token Data /////
    string public name; 
    string public symbol;

    ///// Token Storage /////
    struct TokenData {
        address owner;
        /** @dev 12 free bytes */
    }
    struct BalanceData {
        uint32 balance;
        /** @dev 28 free bytes */
    }

    /** @dev these mappings replace ownerOf and balanceOf with structs */
    mapping(uint256 => TokenData) public _tokenData;
    mapping(address => BalanceData) public _balanceData;

    function balanceOf(address owner_) public virtual view returns (uint256) {
        require(owner_ != address(0), "balanceOf to 0x0");
        return _balanceData[owner_].balance;
    }
    function ownerOf(uint256 tokenId_) public virtual view returns (address) {
        address _owner = _tokenData[tokenId_].owner;
        require(_owner != address(0), "ownerOf token does not exist!");
        return _owner;
    }

    ///// Token Approvals /////
    mapping(uint256 => address) public getApproved;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    ///// Constructor /////
    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    ///// ERC721 Functions /////
    /** @dev _mint and _burn does not have totalSupply manipulations */
    function _mint(address to_, uint256 tokenId_) internal virtual { unchecked {
        require(to_ != address(0), "_mint to 0x0");
        require(_tokenData[tokenId_].owner == address(0), "_mint token exists");
        _tokenData[tokenId_].owner = to_;
        _balanceData[to_].balance++;
        emit Transfer(address(0), to_, tokenId_);
    }}
    function _burn(uint256 tokenId_) internal virtual { unchecked {
        address _owner = ownerOf(tokenId_); // will revert on 0x0
        _balanceData[_owner].balance--;
        delete _tokenData[tokenId_];
        delete getApproved[tokenId_];
        emit Transfer(_owner, address(0), tokenId_);
    }}

    /** @dev _transfer has a special checkApproved_ argument for gas-efficiency */
    function _transfer(address from_, address to_, uint256 tokenId_, 
    bool checkApproved_) internal virtual { unchecked {
        require(to_ != address(0), "_transfer to 0x0");
        address _owner = ownerOf(tokenId_);
        require(from_ == _owner, "_transfer not from owner");
        if (checkApproved_) require(_isApprovedOrOwner(_owner, msg.sender, tokenId_),
                               "_transfer not approved");
        delete getApproved[tokenId_];
        _tokenData[tokenId_].owner = to_;
        _balanceData[from_].balance--;
        _balanceData[to_].balance++;
        emit Transfer(from_, to_, tokenId_);
    }}

    /** @dev transferFrom uses special _transfer with approval check flow */
    function transferFrom(address from_, address to_, uint256 tokenId_) public virtual {
        _transfer(from_, to_, tokenId_, true);
    }
    function safeTransferFrom(address from_, address to_, uint256 tokenId_,
    bytes memory data_) public virtual {
        transferFrom(from_, to_, tokenId_);
        require(to_.code.length == 0 ||
            ERC721TokenReceiver(to_)
            .onERC721Received(msg.sender, from_, tokenId_, data_) ==
            ERC721TokenReceiver.onERC721Received.selector, 
            "safeTransferFrom to unsafe address");
    }
    function safeTransferFrom(address from_, address to_, uint256 tokenId_) 
    public virtual {
        safeTransferFrom(from_, to_, tokenId_, "");
    }

    ///// ERC721 Approvals /////
    function approve(address spender_, uint256 tokenId_) public virtual {
        address _owner = ownerOf(tokenId_);
        require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender],
                "approve not authorized!");
        getApproved[tokenId_] = spender_;
        emit Approval(_owner, spender_, tokenId_);
    }
    function setApprovalForAll(address operator_, bool approved_) public virtual {
        isApprovedForAll[msg.sender][operator_] = approved_;
        emit ApprovalForAll(msg.sender, operator_, approved_);
    }
    /** @dev _isApprovedOrOwner has a special owner_ argument for gas-efficiency */
    function _isApprovedOrOwner(address owner_, address spender_, uint256 tokenId_) 
    internal virtual view returns (bool) {
        return (owner_ == spender_ ||
                getApproved[tokenId_] == spender_ ||
                isApprovedForAll[owner_][spender_]);
    }

    ///// ERC165 Interface /////
    function supportsInterface(bytes4 iid_) public virtual view returns (bool) {
        return  iid_ == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
                iid_ == 0x80ac58cd || // ERC165 Interface ID for ERC721
                iid_ == 0x5b5e139f;   // ERC165 Interface ID for ERC721Metadata
    }

    /** @dev tokenURI is not implemented */
    function tokenURI(uint256 tokenId_) public virtual view returns (string memory) {}
}

abstract contract ERC721TokenURI {

    string public baseTokenURI;

    function _setBaseTokenURI(string memory uri_) internal virtual {
        baseTokenURI = uri_;
    }

    function _toString(uint256 value_) internal pure virtual 
    returns (string memory _str) {
        assembly {
            let m := add(mload(0x40), 0xa0)
            mstore(0x40, m)
            _str := sub(m, 0x20)
            mstore(_str, 0)

            let end := _str

            for { let temp := value_ } 1 {} {
                _str := sub(_str, 1)
                mstore8(_str, add(48, mod(temp, 10)))
                temp := div(temp, 10)
                if iszero(temp) { break }
            }

            let length := sub(end, _str)
            _str := sub(_str, 0x20)
            mstore(_str, length)
        }
    }

    function _getERC721TokenURI(uint256 tokenId_) internal virtual view 
    returns (string memory) {
        return string(abi.encodePacked(baseTokenURI, _toString(tokenId_)));
    }
}

abstract contract Ownable {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    address public owner;
    constructor() { 
        owner = msg.sender; 
    }
    modifier onlyOwner { 
        require(owner == msg.sender, "onlyOwner not owner!");
        _; 
    }
    function transferOwnership(address new_) external onlyOwner {
        address _old = owner;
        owner = new_;
        emit OwnershipTransferred(_old, new_);
    }
}

abstract contract Controllerable is Ownable {

    event ControllerSet(string indexed controllerType, bytes32 indexed controllerSlot, 
        address indexed controller, bool status);

    mapping(bytes32 => mapping(address => bool)) internal __controllers;

    function isController(string memory type_, address controller_) public 
    view returns (bool) {
        bytes32 _slot = keccak256(abi.encodePacked(type_));
        return __controllers[_slot][controller_];
    }

    modifier onlyController(string memory type_) {
        require(isController(type_, msg.sender), "Controllerable: Not Controller!");
        _;
    }

    function setController(string memory type_, address controller_, bool bool_) 
    public onlyOwner {
        bytes32 _slot = keccak256(abi.encodePacked(type_));
        __controllers[_slot][controller_] = bool_;
        emit ControllerSet(type_, _slot, controller_, bool_);
    }
}

interface IMetadata {
    function tokenURI(uint256 tokenId_) external view returns (string memory);
}

contract ERC721Contract is ERC721, ERC721TokenURI, Controllerable {

    address public metadata;
    bool public useMetadata;

    constructor(address owner_) ERC721("CensorlessERC721", "CERC721") {
        proxyInitialize("CensorlessERC721", "CERC721", owner_);
    }

    function proxyInitialize(string memory name_, string memory symbol_, address owner_) public onlyOwner {

        name = name_;
        symbol = symbol_;

        owner = msg.sender;

        _mint(owner_, 0);

        setController("MINTER", owner_, true);

        setController("TOKENURISETTER", owner_, true);

        setController("TOKENDATASETTER", owner_, true);

        setController("BURNER", owner_, true);

        owner = owner_;
    }

    function setNameAndSymbol(string calldata name_, string calldata symbol_) external onlyController("TOKENDATASETTER") {
        name = name_;
        symbol = symbol_;
    }

    function controllerMint(address to_, uint256 amount_) external onlyController("MINTER") {
        _mint(to_, amount_);
    }

    function controllerBurn(uint256 tokenId_) external  onlyController("BURNER") {
        _burn(tokenId_);
    }

    function setBaseTokenURI(string calldata uri_) external onlyController("MINTER") {
        _setBaseTokenURI(uri_);
    }

    function setMetadata(address address_) external onlyController("MINTER") { 
        metadata = address_; 
    }

    function setUseMetadata(bool bool_) external onlyController("MINTER") { 
        useMetadata = bool_; 
    }

    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        if (!useMetadata) {
            return _getERC721TokenURI(tokenId_);
        } else {
            return IMetadata(metadata).tokenURI(tokenId_);
        }
    }
}