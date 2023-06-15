// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solmate/auth/Owned.sol";
import "solmate/tokens/ERC721.sol";
import "solmate/utils/LibString.sol";
import "solmate/utils/MerkleProofLib.sol";

contract RayTaiNFT is ERC721, Owned {
    bytes32 public _root;
    uint256 immutable public _allowlist_price;
    uint256 immutable public _public_price;
    uint32 public _allowlist_sale_time_start;
    uint32 public _public_sale_time_start;
    uint32 public _public_sale_time_stop;
    address immutable public _withdrawer;
    uint16 immutable public _total_limit;
    uint16 _counter;
    uint8 immutable public _allowlist_per_acc_limit;
    uint8 immutable public _public_per_acc_limit;

    string _baseURI;

    struct MintCounters {
        uint8 minted_from_allow_list;
        uint8 minted_from_public_sale;
    }
    mapping(address => MintCounters) _per_acc_counters;

    constructor(string memory name, string memory symbol, bytes32 merkleroot,
                uint256 allowlist_price, uint256 public_price,
                uint8 allowlist_per_acc_limit, uint8 public_per_acc_limit,
                uint16 total_limit,
                uint32 allowlist_sale_time_start, uint32 public_sale_time_start,
                uint32 public_sale_time_stop, address withdrawer,
                string memory baseURI)
    ERC721(name, symbol)
    Owned(msg.sender)
    {
        require(allowlist_sale_time_start < public_sale_time_start && public_sale_time_start < public_sale_time_stop);
        _root = merkleroot;
        _allowlist_price = allowlist_price;
        _public_price = public_price;
        _allowlist_per_acc_limit = allowlist_per_acc_limit;
        _public_per_acc_limit = public_per_acc_limit;
        _total_limit = total_limit;
        _allowlist_sale_time_start = allowlist_sale_time_start;
        _public_sale_time_start = public_sale_time_start;
        _public_sale_time_stop = public_sale_time_stop;
        _withdrawer = withdrawer;
        _baseURI = baseURI;
    }

    function mint(address account, uint8 amount, bytes32[] calldata proof)
    external payable
    {
        require(_verify(_leaf(account), proof), "Invalid merkle proof");
        require(allowlist_sale_is_in_progress(), "Allowlist sale is not now");
        require(msg.value == uint256(amount) * _allowlist_price, "Insufficient ETH provided for AL sale");
        require(255 - amount >= _per_acc_counters[account].minted_from_allow_list, "Overflow on checking the AL limit");
        require(_per_acc_counters[account].minted_from_allow_list + amount <= _allowlist_per_acc_limit, "Over the AL limit");
        unchecked {
            _per_acc_counters[account].minted_from_allow_list += amount;
        }
        _mintImpl(account, amount);
    }

    function mint(address account, uint8 amount)
    public payable
    {
        require(public_sale_is_in_progress(), "Public sale have not started");
        require(msg.value == uint256(amount) * _public_price, "Insufficient ETH provided for public sale");
        require(255 - amount >= _per_acc_counters[account].minted_from_public_sale, "Overflow checking Public Sale Limits");
        require(_per_acc_counters[account].minted_from_public_sale + amount <= _public_per_acc_limit, "Over the Public Sale limit");
        unchecked {
            _per_acc_counters[account].minted_from_public_sale += amount;
        }
        _mintImpl(account, amount);
    }

    function _mintImpl(address account, uint8 amount) internal {
        require(_counter < _total_limit, "No NFTs left");
        uint16 final_index;
        unchecked {
            final_index = _counter + amount;
            if (final_index > _total_limit) {
                final_index = _total_limit;
                (bool returnSent, ) = msg.sender.call{value: msg.value / amount * (_counter + amount - _total_limit)}("");
                require(returnSent);
            }
        }

        for (uint16 index = _counter; index < final_index; ) {
            // Although 721a makes bulk mints cheaper, in a long run, after collection
            // is used for a while, all of it's smartness turns into complications IMO.
            _mint(account, index);
            unchecked { ++index; }
        }

        unchecked {
            _counter = final_index;
        }
    }

    function allowlist_sale_is_in_progress() internal view returns (bool) {
        return block.timestamp >= _allowlist_sale_time_start && block.timestamp <= _public_sale_time_start;
    }

    function public_sale_is_in_progress() internal view returns (bool) {
        return block.timestamp >= _public_sale_time_start && block.timestamp <= _public_sale_time_stop;
    }

    function _leaf(address account)
    internal pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(account));
    }

    function _verify(bytes32 leaf, bytes32[] calldata proof)
    internal view returns (bool)
    {
        return MerkleProofLib.verify(proof, _root, leaf);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return string(abi.encodePacked(_baseURI, LibString.toString(id), ".json"));
    }

    function setBaseURL(string calldata newBaseURI) external onlyOwner {
        _baseURI = newBaseURI;
    }

    function setRoot(bytes32 newRoot) external onlyOwner {
        _root = newRoot;
    }

    function withdraw() external {
        require(msg.sender == _withdrawer, "You are not an owner");
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent);
    }

    function resetTimings(uint32 allowlist_sale_time_start, uint32 public_sale_time_start, uint32 public_sale_time_stop) external onlyOwner {
        require(allowlist_sale_time_start < public_sale_time_start && public_sale_time_start < public_sale_time_stop);
        _allowlist_sale_time_start = allowlist_sale_time_start;
        _public_sale_time_start = public_sale_time_start;
        _public_sale_time_stop = public_sale_time_stop;
    }
}
