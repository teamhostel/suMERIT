// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;
import "./structures/Attestation.sol";
import "./structures/Contribution.sol";
import "./structures/Stripe.sol";
import "./nft/Badge.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//badge factory allows you to see all the functions and permissions
/// BFM - badge factory manager? contains module addresses. Allows construcing your DAO's custom badge factory. A factory for badge factory.
/// benefit of factory: deploying contract is dead simple
contract BadgeFactory is
    Ownable //ownable allows ownership transfer of contract
{
    /// SECTION: FACTORY STORAGE
    address private daoToken;
    Badge private badge; //NFT contract! address behind the scenes (it's also a contract that looks like badge interface)
    /// @notice return the DAO member Id for an address
    mapping(address => uint256) public addrToMemberId;

    /// SECTION: MODIFIERS
    /// MUST OWN A BADGE
    modifier onlyMember() {
        require(badge.balanceOf(msg.sender) != 0, "you are not in the DAO!");
        _;
    }

    ///MUST HOLD SPECIFIC BADGE ID
    modifier onlyHolder(uint256 id) {
        require(badge.ownerOf(id) == msg.sender, "You do not own this NFT!");
        _;
    }

    /// SECTION: EVENTS
    event NewBadge(address owner, uint256 memberId);

    // event NewFactory(address memory cont); //for BFM
    /// DEPRECATED VARIABLES
    // mapping(address => bool) memberWhitelist; //not needed because
    ///require dao adds members, members can't add themselves. Don't allow members to mint their own badges.
    // mapping(uint256 => address) public memberIdToAddress; //not needed because of func getAddressById
    // address[] public badges; //this should be covered in memberIdToAddress

    /// @param _token address for existing DAO token
    /// @dev todo support more of the DAO stack: creating tokens
    constructor(
        address _token,
        string memory name,
        string memory symbol,
        string memory uri
    ) {
        //create badge contract = each factory has one badge contract w/multiple ideas
        daoToken = _token;
        badge = Badge(name, symbol);
    }

    /// SECTION: Factory config functions
    /// @dev todo include trusted (onlyOwner) modifier (dao must deploy from their main multisig)
    function setDaoTokenAddress(address _token) public onlyOwner {
        daoToken = _token;
    }

    /// SECTION: Badge Minting
    ///@notice Factory mint a DAO badge
    ///@dev free NFT for member fills in addrToMemberId
    function _mintBadge(address _owner) internal {
        // Badge myBadge = Badge(_owner); //this is creating new contract on every mint
        ///look up badge by Id, which returns address of owner

        ///@dev relevant mappings for easy access
        addrToMemberId[_owner] = badge.memberId();
        // memberIdToAddress[myBadge.memberId()] = _owner;

        emit NewBadge(_owner, badge.memberId());
    }

    ///@notice add individual member
    function addDaoMember(address _member) public onlyOwner {
        _mintBadge(_member);
    }

    /// the DAO says these are our members: address[]
    /// modifier no args - no parentheses needed
    function batchAddMembers(address[] memory members) public onlyOwner {
        for (uint256 id = 0; id < members.length; id++) {
            addDaoMember(members[id]);
        }
    }

    /// SECTION: VIEW FUNCTIONS
    function getAddressById(uint256 id) public view returns (address) {
        return badge.ownerOf(id);
    }

    ///SECTION: Contribs and Attests
    /// called by the contributor themselves
    function _createContrib(
        address[] memory contributors,
        string memory message,
        string memory contribType,
        string memory uri
    ) private returns (Contribution memory) {
        return
            Contribution(
                contributors,
                message,
                block.timestamp,
                contribType,
                uri
            );
    }

    function _createAttest(
        string memory message,
        int256 points,
        string memory uri
    ) private returns (Attestation memory) {
        return Attestation(msg.sender, message, block.timestamp, points, uri);
    }

    ///SECTION: Fast utility functions for tracking contribs.
    ///@dev intended to be called my member = msg.sender
    function makeStripeAndContrib(
        address[] memory contribs,
        string memory message,
        string memory contribType,
        string memory uri
    ) public onlyHolder(addrToMemberId[msg.sender]) {
        //include the sender in the contribs array
        uint256 id = addrToMemberId[msg.sender];
        address[] memory contributors = msg.sender;
        contributors.push(contribs);
        badge.contribNewStripe(
            id,
            _createContrib(contributors, message, contribType, uri)
        );
    }
}
