// SPDX-License-Identifier: GPL-3.0
pragma solidity <=0.8.9;
import "./BadgeFactory.sol";

contract BadgeFactoryManager {
    /// @notice The signature nonces for 3rd party module approvals
    mapping(address => uint256) public sigNonces;

    /// @notice The registrar address that can register modules
    address public registrar;

    /// @notice The module fee NFT contract to mint from upon module registration
    ZoraProtocolFeeSettings public moduleFeeToken;

    /// @notice Mapping of each user to module approval in the ZORA registry
    /// @dev User address => Module address => Approved
    mapping(address => mapping(address => bool)) public userApprovals;

    /// @notice A mapping of module addresses to module data
    mapping(address => bool) public moduleRegistered;

    modifier onlyRegistrar() {
        require(msg.sender == registrar, "BFM::onlyRegistrar must be registrar");
        _;
    }


    mapping(address => BadgeFactory) private _addrToBadgeFactory;
    BadgeFactory[] public BadgeFactoryById;

    /// @param _registrar The initial registrar for the manager
    /// @param _feeToken The module fee token contract to mint from upon module registration
    constructor(address _registrar, address _feeToken) {
        require(_registrar != address(0), "BFM::must set registrar to non-zero address");

        registrar = _registrar;
        moduleFeeToken = ZoraProtocolFeeSettings(_feeToken);
    }

    function createBadgeFactoryContract(string memory name, string memory symbol, string memory uri) public
    {
        require(_addrToBadgeFactory[msg.sender] == 0, "Your DAO already owns a Badge Factory!");
        Badge storage b = new Badge(name, symbol, uri);
        _addrToBadgeFactory[msg.sender] = address(b);
        BadgeFactoryById.push(address(b)); 
    }

    function getMyBadgeFactory() public view returns(BadgeFactory)
    {
        require(_addrToBadgeFactory[msg.sender] != 0, "Your DAO does not own a Badge Factory!");
        return _addrToBadgeFactory[msg.sender];
    }

    function getBadgeFactory(address owner) public view returns(BadgeFactory)
    {
        require(_addrToBadgeFactory[owner] != 0, "Your DAO does not own a Badge Factory!");
        return _addrToBadgeFactory[msg.sender];
    }

    ///@dev BFM owner can add and enable/disable modules here
}