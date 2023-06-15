// ░██████╗████████╗░█████╗░██████╗░██████╗░██╗░░░░░░█████╗░░█████╗░██╗░░██╗
// ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██║░░░░░██╔══██╗██╔══██╗██║░██╔╝
// ╚█████╗░░░░██║░░░███████║██████╔╝██████╦╝██║░░░░░██║░░██║██║░░╚═╝█████═╝░
// ░╚═══██╗░░░██║░░░██╔══██║██╔══██╗██╔══██╗██║░░░░░██║░░██║██║░░██╗██╔═██╗░
// ██████╔╝░░░██║░░░██║░░██║██║░░██║██████╦╝███████╗╚█████╔╝╚█████╔╝██║░╚██╗
// ╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝░╚════╝░░╚════╝░╚═╝░░╚═╝

// SPDX-License-Identifier: MIT
// StarBlock DAO Contracts, https://www.starblockdao.io/

pragma solidity ^0.8.0;

import "./IERC2981.sol";
import "./IERC721Receiver.sol";
import "./IERC721Metadata.sol";
import "./IERC721Enumerable.sol";

interface IERC2981Mutable is IERC165, IERC2981 {
    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external;
    function deleteDefaultRoyalty() external;
}

interface IBaseWrappedNFT is IERC165, IERC2981Mutable, IERC721Receiver, IERC721, IERC721Metadata {
    event DelegatorChanged(address _delegator);
    event Deposit(address _forUser, uint256[] _tokenIds);
    event Withdraw(address _forUser, uint256[] _wnftTokenIds);

    function nft() external view returns (IERC721Metadata);
    function factory() external view returns (IWrappedNFTFactory);

    function deposit(address _forUser, uint256[] memory _tokenIds) external;
    function withdraw(address _forUser, uint256[] memory _wnftTokenIds) external;

    function exists(uint256 _tokenId) external view returns (bool);
    
    function delegator() external view returns (address);
    function setDelegator(address _delegator) external;
    
    function isEnumerable() external view returns (bool);
}

interface IWrappedNFT is IBaseWrappedNFT {
    function totalSupply() external view returns (uint256);
}

interface IWrappedNFTEnumerable is IWrappedNFT, IERC721Enumerable {
    function totalSupply() external view override(IWrappedNFT, IERC721Enumerable) returns (uint256);
}

interface IWrappedNFTFactory {
    event WrappedNFTDeployed(IERC721Metadata _nft, IWrappedNFT _wnft, bool _isEnumerable);
    event WNFTDelegatorChanged(address _wnftDelegator);

    function wnftDelegator() external view returns (address);

    function deployWrappedNFT(IERC721Metadata _nft, bool _isEnumerable) external returns (IWrappedNFT);
    function wnfts(IERC721Metadata _nft) external view returns (IWrappedNFT);
    function wnftsNumber() external view returns (uint);
}