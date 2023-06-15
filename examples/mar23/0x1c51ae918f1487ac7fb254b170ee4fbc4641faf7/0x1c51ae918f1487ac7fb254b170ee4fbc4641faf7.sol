// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Simple single owner authorization mixin that implements ERC173.
/// @author Modified from Solbase (https://github.com/Sol-DAO/solbase/blob/main/src/auth/Owned.sol)
abstract contract Owned {
    /// -----------------------------------------------------------------------
    /// Events
    /// -----------------------------------------------------------------------

    event OwnershipTransferred(address indexed owner, address indexed newOwner);

    /// -----------------------------------------------------------------------
    /// Custom Errors
    /// -----------------------------------------------------------------------

    error Unauthorized();

    /// -----------------------------------------------------------------------
    /// Ownership Storage
    /// -----------------------------------------------------------------------

    address public owner;

    modifier onlyOwner() virtual {
        if (msg.sender != owner) revert Unauthorized();

        _;
    }

    /// -----------------------------------------------------------------------
    /// Constructor
    /// -----------------------------------------------------------------------

    constructor(address _owner) {
        owner = _owner;

        emit OwnershipTransferred(address(0), _owner);
    }

    /// -----------------------------------------------------------------------
    /// Ownership Logic
    /// -----------------------------------------------------------------------

    function transferOwnership(address newOwner)
        public
        payable
        virtual
        onlyOwner
    {
        owner = newOwner;

        emit OwnershipTransferred(msg.sender, newOwner);
    }

    /// -----------------------------------------------------------------------
    /// ERC165 Logic
    /// -----------------------------------------------------------------------

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        returns (bool)
    {
        // ERC165 Interface ID for ERC173.
        return interfaceId == 0x7f5828d0;
    }
}

/// @notice Remote metadata fetcher for ERC1155.
contract URIRemoteFetcher is Owned(tx.origin) {
    /// -----------------------------------------------------------------------
    /// Events
    /// -----------------------------------------------------------------------

    event AlphaURISet(string alphaURI);

    event BetaURISet(address indexed origin, string betaURI);

    event URISet(address indexed origin, uint256 indexed id, string uri);

    event UserURISet(address indexed origin, address indexed user, string uri);

    event UserIdURISet(
        address indexed origin,
        address indexed user,
        uint256 indexed id,
        string uri
    );

    /// -----------------------------------------------------------------------
    /// URI Storage
    /// -----------------------------------------------------------------------

    string public alphaURI;

    mapping(address => string) public betaURI;

    mapping(address => mapping(uint256 => string)) public uris;

    mapping(address => mapping(address => string)) public userUris;

    mapping(address => mapping(address => mapping(uint256 => string)))
        public userIdUris;

    /// -----------------------------------------------------------------------
    /// Constructor
    /// -----------------------------------------------------------------------

    constructor() payable {}

    /// -----------------------------------------------------------------------
    /// URI Logic
    /// -----------------------------------------------------------------------

    function fetchURI(
        address origin,
        uint256 id
    ) public view virtual returns (string memory) {
        string memory alpha = alphaURI;
        string memory beta = betaURI[origin];
        string memory uri = uris[origin][id];

        if (bytes(uri).length != 0) {
            return uri;
        } else if (bytes(beta).length != 0) {
            return beta;
        } else {
            return bytes(alpha).length != 0 ? alpha : "";
        }
    }

    function setAlphaURI(
        string calldata _alphaURI
    ) public payable virtual onlyOwner {
        alphaURI = _alphaURI;

        emit AlphaURISet(_alphaURI);
    }

    function setBetaURI(
        address origin,
        string calldata beta
    ) public payable virtual onlyOwner {
        betaURI[origin] = beta;

        emit BetaURISet(origin, beta);
    }

    function setURI(
        address origin,
        uint256 id,
        string calldata uri
    ) public payable virtual onlyOwner {
        uris[origin][id] = uri;

        emit URISet(origin, id, uri);
    }

    function setUserURI(
        address origin,
        address user,
        string calldata uri
    ) public payable virtual onlyOwner {
        userUris[origin][user] = uri;

        emit UserURISet(origin, user, uri);
    }

    function setUserIdURI(
        address origin,
        address user,
        uint256 id,
        string calldata uri
    ) public payable virtual onlyOwner {
        userIdUris[origin][user][id] = uri;

        emit UserIdURISet(origin, user, id, uri);
    }
}