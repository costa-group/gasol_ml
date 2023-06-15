// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ECDSAUpgradeable.sol";
import "StringsUpgradeable.sol";
import "ERC721EnumerableUpgradeable.sol";
import "OwnableUpgradeable.sol";
import "Initializable.sol";

contract Mint_ is
    Initializable,
    ERC721EnumerableUpgradeable,
    OwnableUpgradeable
{
    using ECDSAUpgradeable for bytes32;
    using ECDSAUpgradeable for bytes;
    using StringsUpgradeable for uint256;

    mapping(uint256 => string) private _tokenURIs;
    uint256 private counter;
    address private server_address;

    function initialize(
        uint256 _counter,
        address _server_address,
        string memory token_name_symbol
    ) public initializer {
        counter = _counter;
        server_address = _server_address;
        __ERC721_init(token_name_symbol, token_name_symbol);
        __Ownable_init();
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        virtual
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = string(
            abi.encodePacked(
                _tokenURI,
                "/",
                StringsUpgradeable.toString(tokenId)
            )
        );
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory _tokenURI = _tokenURIs[tokenId];

        // If there is no base URI, return the token URI.
        return _tokenURI;
    }

    function mint(address addr, string memory url) public {
        require(msg.sender == server_address, "Address mismatch");
        _safeMint(addr, counter + 1);
        _setTokenURI(counter + 1, url);
        counter += 1;
    }

    function burn(
        uint256 token_id,
        bytes memory holder_sig // Sig data is formatted {contract_address}_{token_id}
    ) public {
        require(msg.sender == server_address, "Address mismatch");

        // Require sig works
        address holder_addr = ownerOf(token_id);
        bytes memory data = bytes(
            string(
                abi.encodePacked(
                    uint256(uint160(address(this))).toHexString(),
                    "_",
                    StringsUpgradeable.toString(token_id)
                )
            )
        );
        bool correct_sig = data.toEthSignedMessageHash().recover(holder_sig) ==
            holder_addr;
        require(correct_sig, "Bad sig.");

        _burn(token_id);
    }
}
