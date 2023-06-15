// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";

contract DrPunksNFT is ERC721A, ERC721AQueryable, Ownable {
    using ECDSA for bytes32;

    uint256 public constant MAX_MINT_PER_TRANSACTION = 10;
    uint256 public constant PRESALE_MAX_MINT = 3;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant SUPPLY_WHITELIST = 5300;

    uint256 public drPunksListPrice = 0.35 ether;
    uint256 public publicSalePrice = 0.45 ether;
    address public signer;
    uint32 public drPunksListStartTime = 1682704800;
    uint32 public drPunksListEndTime = 1682877000;
    uint32 public publicSaleStartTime = 1682877600;

    string private _baseTokenURI =
        "https://drpunks.mypinata.cloud/ipfs/QmZqn6cHJg7JSfyBBM9QkRSsMfpbH5CHKBJE5FP17xTwY8/";

    constructor() ERC721A("Dr.Punks", "DRPUNKS") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function presaleMint(
        uint256 quantity,
        bytes memory signature
    ) external payable {
        require(
            block.timestamp >= drPunksListStartTime &&
                block.timestamp < drPunksListEndTime,
            "Presale not active"
        );
        require(
            recoverSigner(signature) == signer,
            "Address is not in DrPunksList"
        );
        require(
            totalSupply() + quantity <= SUPPLY_WHITELIST,
            "Whitelist DrPunks sold out"
        );
        require(
            numberMinted(msg.sender) + quantity <= PRESALE_MAX_MINT,
            "Cannot mint more than 3 during DrPunksList sale"
        );
        require(
            msg.value == drPunksListPrice * quantity,
            "Insufficient payment"
        );

        _safeMint(msg.sender, quantity);
    }

    function publicSaleMint(uint256 quantity) external payable {
        require(block.timestamp >= publicSaleStartTime, "Sale not active");
        require(totalSupply() + quantity <= MAX_SUPPLY, "DrPunks sold out");
        require(
            quantity <= MAX_MINT_PER_TRANSACTION,
            "Minting too many in one transaction"
        );
        require(
            msg.value == publicSalePrice * quantity,
            "Insufficient payment"
        );
        _safeMint(msg.sender, quantity);
    }

    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    function setSigner(address newSigner) external onlyOwner {
        signer = newSigner;
    }

    function setDrPunksListPrice(uint256 price) external onlyOwner {
        drPunksListPrice = price;
    }

    function setPublicSalePrice(uint256 price) external onlyOwner {
        publicSalePrice = price;
    }

    function setPresale(
        uint32 drPunksListStart,
        uint32 drPunksListEnd
    ) external onlyOwner {
        drPunksListStartTime = drPunksListStart;
        drPunksListEndTime = drPunksListEnd;
    }

    function setPublicSale(uint32 publicSaleStart) external onlyOwner {
        publicSaleStartTime = publicSaleStart;
    }

    function recoverSigner(
        bytes memory signature
    ) private view returns (address) {
        bytes32 messageDigest = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                keccak256(abi.encodePacked(msg.sender))
            )
        );
        return messageDigest.recover(signature);
    }

    bool public teamMinted;
    address payable private pricesWallet;
    address payable private nonProfitOrganization;
    address payable private founderWallet;
    address payable private founderWallet2;
    address payable private founderWallet3;

    function teamMint() external onlyOwner {
        require(!teamMinted, "Already done");

        for (uint256 i = 0; i < 30; i++) {
            _safeMint(msg.sender, 10);
        }
        teamMinted = true;
    }

    function setWithdrawalWallets(
        address payable prices,
        address payable nonProfit,
        address payable founder,
        address payable founder2,
        address payable founder3
    ) external onlyOwner {
        pricesWallet = prices;
        nonProfitOrganization = nonProfit;
        founderWallet = founder;
        founderWallet2 = founder2;
        founderWallet3 = founder3;
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        pricesWallet.transfer((balance * 25) / 100);
        nonProfitOrganization.transfer((balance * 10) / 100);
        founderWallet.transfer((balance * 20) / 100);
        founderWallet2.transfer((balance * 25) / 100);
        founderWallet3.transfer(address(this).balance);
    }
}
