// SPDX-License-Identifier: GPL-3.0
pragma solidity <=0.8.9;
import "./structures/Attestation.sol";
import "./structures/Contribution.sol";
import "./structures/Stripe.sol";
import "./nft/Badge.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @notice badge factory allows you to interact with the Badge NFT contract!
/// @dev BadgeFactory is Badge. hierarchical inheritance.
/// @dev    BFM - badge factory manager will contains module addresses.
///         Allows construcing your DAO's custom badge factory. A factory for badge factory.
///         benefit of factory: deploying contract is dead simple
contract BadgeFactory is
    Badge //ownable allows ownership transfer of contract
{
    /// SECTION: FACTORY STORAGE
    address private daoToken;
    Badge private badge; //NFT contract! address behind the scenes (it's also a contract that looks like badge interface)
    /// @notice return the DAO member Id for an address
    mapping(address => uint256) public addrToMemberId;

    /// SECTION: MODIFIERS
    /// MUST OWN A BADGE
    modifier onlyMember() {
        require(balanceOf(msg.sender) > 0, "you are not in the DAO!");
        _;
    }
    ///MUST HOLD SPECIFIC BADGE ID
    modifier onlyHolder(uint256 id) {
        require(balanceOf(msg.sender) > 0, "you are not in the DAO!");
        require(ownerOf(id) == msg.sender, "You do not own this Badge!");
        _;
    }

    /// SECTION: EVENTS
    event NewBadge(address owner, uint256 memberId);
    // event NewFactory(address memory cont); //for BFM

    /// @param _token address for existing DAO token
    /// @dev todo support more of the DAO stack: creating tokens
    constructor(
        address _token,
        string memory name,
        string memory symbol
    ) Badge(name, symbol) {
        /**
         * create Badge contract 
         * factory inherits Badge with IDs for member addresses
        */
        daoToken = _token;
        // _setTokenURI(tokenId, _tokenURI);
        // badge = new Badge(name, symbol);
    }

    /// SECTION: Factory config functions
    /// @dev todo include trusted (onlyOwner) modifier (dao must deploy from their main multisig)
    function setDaoTokenAddress(address _token) public onlyOwner {
        daoToken = _token;
    }

    /// SECTION: Badge Minting
    ///@notice Factory mint a DAO badge
    ///@dev free NFT for member fills in addrToMemberId
    function _mintBadge(address owner) internal {
        // Badge myBadge = Badge(_owner); //this is creating new contract on every mint
        ///look up badge by Id, which returns address of owner
        uint256 id = mint(owner);
        addrToMemberId[owner] = id;
        // memberIdToAddress[mymemberId()] = _owner;

        emit NewBadge(owner, id);
    }

    ///@notice add individual member
    ///@dev only gate the public fns
    function addDaoMember(address member) public onlyOwner {
        _mintBadge(member);
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
        return ownerOf(id);
    }

    ///
    ///SECTION: Contribs and Attests
    /// called by the contributor themselves
    function _createContrib(
        string memory message,
        string memory contribType,
        string memory uri
    ) private view returns (Contribution memory) {
        return
            Contribution(
                msg.sender, //question: when you call inherited functions, does msg.sender == the highest level address? (EOA)
                message,
                block.timestamp,
                contribType,
                uri
            );
    }

    function _createAttest(bool vote, string memory message)
        private
        view
        returns (Attestation memory)
    {
        return Attestation(msg.sender, vote, message, block.timestamp);
    }

    ///SECTION: Fast utility functions for tracking contribs.
    ///@notice requires badge owner. Alt implementation allows DAO address to create stripes for members.
    ///@dev intended to be called my member = msg.sender. NO NEED TO INSTANTIATE CONTRIBS OR ATTESTS
    function makeNewStripe(string memory message, string memory uri)
        external
        onlyHolder(addrToMemberId[msg.sender])
    {
        uint256 id = addrToMemberId[msg.sender];
        newStripeForId(id, message, uri);
    }

    function contribToStripe(
        uint256 stripeId,
        address[] memory contributors,
        string memory message,
        string memory contribType,
        string memory uri
    ) public onlyMember {
        require(contributors.length > 0, "must have contributors");
    }

    function contribToLatestStripe() public {}

    function attestToStripe(uint256 stripeId) public {}

    function attestToLatestStripe() public {}
}
