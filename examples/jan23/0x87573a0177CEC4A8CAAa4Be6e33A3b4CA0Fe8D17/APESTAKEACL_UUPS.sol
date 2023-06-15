// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.17;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

import "UUPSUpgradeable.sol";
import "OwnableUpgradeable.sol";

contract APESTAKEACLForUUPS is OwnableUpgradeable, UUPSUpgradeable {

    address public safeAddress;
    address public safeModule;

    bytes32 private _checkedRole = hex"01";
    uint256 private _checkedValue = 1;
    string public constant NAME = "APESTAKEACL";
    uint public constant VERSION = 1;

    // using Subsafe address(0) for Gnosis Safe
    mapping(address => mapping(address => bool)) safeLiquidityPair;
    mapping(address => mapping(address => uint256)) safeSwapPath;

    uint256 constant APECOIN_POOL_ID = 0;
    uint256 constant BAYC_POOL_ID = 1;
    uint256 constant MAYC_POOL_ID = 2;
    uint256 constant BAKC_POOL_ID = 3;


    struct SingleNft {
        uint32 tokenId;
        uint224 amount;
    }

    struct PairNftDepositWithAmount {
        uint32 mainTokenId;
        uint32 bakcTokenId;
        uint184 amount;
    }

    struct PairNft {
        uint128 mainTokenId;
        uint128 bakcTokenId;
    }

    struct PairNftWithdrawWithAmount {
        uint32 mainTokenId;
        uint32 bakcTokenId;
        uint184 amount;
        bool isUncommit;
    }

    address public constant BAYC = address(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
    address public constant MAYC = address(0x60E4d786628Fea6478F785A6d7e704777c86a7c6);
    address public constant BAKC = address(0xba30E5F9Bb24caa003E9f2f0497Ad287FDF95623);

    /// notice Constructor function for Acl
    /// param _safeAddress the Gnosis Safe (GnosisSafeProxy) instance's address
    /// param _safeModule the CoboSafe module instance's address
    function initialize(address _safeAddress, address _safeModule) initializer public {
        __APESTAKEACL_init(_safeAddress, _safeModule);
    }

    function __APESTAKEACL_init(address _safeAddress, address _safeModule) internal onlyInitializing {
        __Ownable_init();
        __UUPSUpgradeable_init();
        __APESTAKEACL_init_unchained(_safeAddress, _safeModule);
    }

    function __APESTAKEACL_init_unchained(address _safeAddress, address _safeModule) internal onlyInitializing {
        require(_safeAddress != address(0), "Invalid safe address");
        require(_safeModule!= address(0), "Invalid module address");
        safeAddress = _safeAddress;
        safeModule = _safeModule;

        // make the given safe the owner of the current acl.
        _transferOwnership(_safeAddress);
    }

    modifier onlySelf() {
        require(address(this) == msg.sender, "Caller is not inner");
        _;
    }

    modifier onlyModule() {
        require(safeModule == msg.sender, "Caller is not the module");
        _;
    }

    function check(bytes32 _role, uint256 _value, bytes calldata data) external onlyModule returns (bool) {
        _checkedRole = _role;
        _checkedValue = _value;
        (bool success,) = address(this).staticcall(data);
        return success;
    }


    fallback() external {
        revert("Unauthorized access");
    }

    // ACL methods

    // ApeCoin staking
    function depositSelfApeCoin(uint256 _amount) external view onlySelf {}
    function claimSelfApeCoin() external view onlySelf {}
    function withdrawSelfApeCoin(uint256 _amount) external view onlySelf {}

    // BAYC staking
    function depositBAYC(SingleNft[] calldata _nfts) external view onlySelf {
        uint256 tokenId;
        uint256 length = _nfts.length;
        for(uint256 i; i < length;) {
            tokenId = _nfts[i].tokenId;
            require(IERC721(BAYC).ownerOf(tokenId) == safeAddress,'depositBAYC NFT tokenId not allowed');
            unchecked {
                ++i;
            }
        }
    }
    function claimSelfBAYC(uint256[] calldata _nfts) external view onlySelf {}
    function withdrawSelfBAYC(SingleNft[] calldata _nfts) external view onlySelf {}

    // MAYC staking
    function depositMAYC(SingleNft[] calldata _nfts) external view onlySelf {
        uint256 tokenId;
        uint256 length = _nfts.length;
        for(uint256 i; i < length;) {
            tokenId = _nfts[i].tokenId;
            require(IERC721(MAYC).ownerOf(tokenId) == safeAddress,'depositMAYC NFT tokenId not allowed');
            unchecked {
                ++i;
            }
        }
    }
    function claimSelfMAYC(uint256[] calldata _nfts) external view onlySelf {}
    function withdrawSelfMAYC(SingleNft[] calldata _nfts) external view onlySelf {}

    // BAKC staking
    function depositBAKC(PairNftDepositWithAmount[] calldata _baycPairs, PairNftDepositWithAmount[] calldata _maycPairs) external view onlySelf {
        PairNftDepositWithAmount memory _baycPair;
        PairNftDepositWithAmount memory _maycPair;
        uint256 _baycLength = _baycPairs.length;
        uint256 _maycLength = _maycPairs.length;

        for(uint256 i; i < _baycLength;) {
            _baycPair = _baycPairs[i];
            require(IERC721(BAYC).ownerOf(_baycPair.mainTokenId) == safeAddress,'depositBAKC NFT tokenId not allowed');
            require(IERC721(BAKC).ownerOf(_baycPair.bakcTokenId) == safeAddress,'depositBAKC NFT tokenId not allowed');
            unchecked {
                ++i;
            }
        }

        for(uint256 i; i < _maycLength;) {
            _maycPair = _maycPairs[i];
            require(IERC721(MAYC).ownerOf(_maycPair.mainTokenId) == safeAddress,'depositBAKC NFT tokenId not allowed');
            require(IERC721(BAKC).ownerOf(_maycPair.bakcTokenId) == safeAddress,'depositBAKC NFT tokenId not allowed');
            unchecked {
                ++i;
            }
        }
    }
    function claimSelfBAKC(PairNft[] calldata _baycPairs, PairNft[] calldata _maycPairs) external view onlySelf {}
    function withdrawBAKC(PairNftWithdrawWithAmount[] calldata _baycPairs, PairNftWithdrawWithAmount[] calldata _maycPairs) external view onlySelf {}

    /// dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
    /// {upgradeTo} and {upgradeToAndCall}.
    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}