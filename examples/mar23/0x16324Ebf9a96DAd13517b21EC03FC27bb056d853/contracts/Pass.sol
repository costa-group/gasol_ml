// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// from openzeppelin
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

// local
import "./SalesActivation.sol";
import "./Whitelist.sol";

// TopWhaleClubPass
contract TopWhaleClubPass is
    Ownable,
    ERC721Enumerable,
    SalesActivation,
    Whitelist
{

    // ------------------------------------------- const
    // total sales
    uint256 public constant TOTAL_MAX_QTY = 1000;

    // nft sales price
    uint256 public constant WHITELIST_SALES_PRICE = 0.01 ether;
    uint256 public constant PUBLIC_SALES_PRICE = 0.01 ether;

    // ------------------------------------------- variable
    mapping(address => uint256) public accountToTokenQtyWhitelist;
    mapping(address => uint256) public accountToTokenQtyPublic;

    // max number of NFTs every wallet can buy
    uint256 public max_qty_per_minter_in_public_sales = 5;

    // max number of NFTs every wallet can buy in whitelistsales
    uint256 public max_qty_per_minter_in_whitelist = 5;

    // whitelist sales quantity
    uint256 public whitelistSalesMintedQty = 0;

    // public sales quantity
    uint256 public publicSalesMintedQty = 0;

    // contract URI
    string private _contractURI;

    // URI for NFT meta data
    string private _tokenBaseURI;

    // init for the contract
    constructor() ERC721("Top Whale Club Pass", "TWCPass")   {}

    // whitelist mint
    function whitelistMint(uint256 _mintQty)
        external
        isPreSalesActive
        callerIsUser
        payable
    {
        require(
            isInWhitelist(msg.sender),
            "Not in whitelist yet!"
        );
        require(
            publicSalesMintedQty + whitelistSalesMintedQty + _mintQty <= TOTAL_MAX_QTY,
            "Exceed sales max limit!"
        );
        require(
            accountToTokenQtyWhitelist[msg.sender] + _mintQty <= max_qty_per_minter_in_whitelist,
            "Exceed max mint per minter!"
        );
        require(
            msg.value >= _mintQty * WHITELIST_SALES_PRICE,
            "Insufficient ETH!"
        );

        // update the quantity of the sales
        accountToTokenQtyWhitelist[msg.sender] += _mintQty;
        whitelistSalesMintedQty += _mintQty;

        // safe mint for every NFT
        for (uint256 i = 0; i < _mintQty; i++) {
            _safeMint(msg.sender, totalSupply() + 1);
        }

    }

    // public mint
    function mint(uint256 _mintQty)
        external
        isPublicSalesActive
        callerIsUser
        payable
    {
        require(
            publicSalesMintedQty + whitelistSalesMintedQty + _mintQty <= TOTAL_MAX_QTY,
            "Exceed sales max limit!"
        );
        require(
            accountToTokenQtyPublic[msg.sender] + _mintQty <= max_qty_per_minter_in_public_sales,
            "Exceed max mint per minter!"
        );
        require(
            msg.value >= _mintQty * PUBLIC_SALES_PRICE,
            "Insufficient ETH"
        );

        // update the quantity of the sales
        accountToTokenQtyPublic[msg.sender] += _mintQty;
        publicSalesMintedQty += _mintQty;

        // safe mint for every NFT
        for (uint256 i = 0; i < _mintQty; i++) {
            _safeMint(msg.sender, totalSupply() + 1);
        }

    }

    // set the quantity per minter can mint in public sales
    function setQtyPerMinterPublicSales(uint256 qty) external onlyOwner {
        max_qty_per_minter_in_public_sales = qty;
    }

    // set the quantity per minter can mint in whitelist sales
    function setQtyPerMinterWhitelist(uint256 qty) external onlyOwner {
        max_qty_per_minter_in_whitelist = qty;
    }

    // ------------------------------------------- withdraw
    // withdraw all (if need)
    function withdrawAll() external onlyOwner  {
        require(address(this).balance > 0, "Withdraw: No amount");
        payable(msg.sender).transfer(address(this).balance);
    }

    // set base uri
    function setBaseURI(string calldata URI) external onlyOwner {
        _tokenBaseURI = URI;
    }

    // get the base uri
    function _baseURI()
        internal
        view
        override(ERC721)
        returns (string memory)
    {
        return _tokenBaseURI;
    }


    // not other contract
    modifier callerIsUser() {
        require(tx.origin == msg.sender, "not user!");
        _;
    }


}
