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

    /**
     * create Badge contract
     * factory inherits Badge with IDs for member addresses
     * @dev todo support more of the DAO stack: creating tokens
     */
    constructor(
        string memory name, //badge or dao name
        string memory symbol //TICKER SYM
    ) Badge(name, symbol) {
        // _setTokenURI(tokenId, _tokenURI);
    }

    /// SECTION: Factory config functions
    ///-----------------------------------
    /// @dev todo include trusted (onlyOwner) modifier (dao must deploy from their main multisig)
    function setDaoTokenAddress(address token) public onlyOwner {
        daoToken = token; //address for existing DAO token
        ///@dev future function to mint badge for ALL TOKEN HOLDERS
    }

    /// SECTION: Badge Minting
    ///-----------------------
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

    /// SECTION: VIEW
    ///--------------
    function getAddressById(uint256 id) public view returns (address) {
        return ownerOf(id);
    }

    function getStripeMessageById(uint256 memberId, uint256 stripeId)
        public
        view
        returns (string memory message)
    {
        return stripesById[memberId][stripeId].message;
    }

    function getStripeUriById(uint256 memberId, uint256 stripeId)
        public
        view
        returns (string memory uri)
    {
        return stripesById[memberId][stripeId].uri;
    }

    function getContribAddress(
        uint256 memberId,
        uint256 stripeId,
        uint256 contribId
    ) public view returns (address) {
        return _getContribById(memberId, stripeId, contribId).contributor;
    }

    function getContribTime(
        uint256 memberId,
        uint256 stripeId,
        uint256 contribId
    ) public view returns (uint256) {
        return _getContribById(memberId, stripeId, contribId).time;
    }

    function getContribMessage(
        uint256 memberId,
        uint256 stripeId,
        uint256 contribId
    ) public view returns (string memory) {
        return _getContribById(memberId, stripeId, contribId).message;
    }

    function getContribType(
        uint256 memberId,
        uint256 stripeId,
        uint256 contribId
    ) public view returns (string memory) {
        return _getContribById(memberId, stripeId, contribId).contribType;
    }

    function getContribUri(
        uint256 memberId,
        uint256 stripeId,
        uint256 contribId
    ) public view returns (string memory) {
        return _getContribById(memberId, stripeId, contribId).uri;
    }

    function getAttestAddress(
        uint256 memberId,
        uint256 stripeId,
        uint256 attestId
    ) public view returns (address) {
        return _getAttestById(memberId, stripeId, attestId).attestor;
    }

    function getAttestTime(
        uint256 memberId,
        uint256 stripeId,
        uint256 attestId
    ) public view returns (uint256) {
        return _getAttestById(memberId, stripeId, attestId).time;
    }

    function getAttestVote(
        uint256 memberId,
        uint256 stripeId,
        uint256 attestId
    ) public view returns (bool) {
        return _getAttestById(memberId, stripeId, attestId).vote;
    }

    function getAttestMessage(
        uint256 memberId,
        uint256 stripeId,
        uint256 attestId
    ) public view returns (string memory) {
        return _getAttestById(memberId, stripeId, attestId).message;
    }

    /// SECTION: Fast utility functions for tracking contribs.
    ///@notice requires badge owner. Alt implementation allows DAO address to create stripes for members.
    ///@dev intended to be called my member = msg.sender. NO NEED TO INSTANTIATE CONTRIBS OR ATTESTS
    function addNewStripe(string memory message, string memory uri)
        external
        onlyHolder(addrToMemberId[msg.sender])
    {
        uint256 id = addrToMemberId[msg.sender];
        newStripeForId(id, message, uri);
    }

    /// SECTION: Add Contributions!
    ///----------------------------
    function contribToStripe(
        uint256 stripeId,
        string memory message,
        string memory contribType,
        string memory uri
    ) public onlyHolder(addrToMemberId[msg.sender]) {
        Contribution memory contrib;
        ///@dev long-form more readable syntax
        contrib.contributor = msg.sender;
        contrib.time = block.timestamp;
        contrib.message = message;
        contrib.contribType = contribType;
        contrib.uri = uri;
        uint256 memberId = addrToMemberId[msg.sender];

        appendContribToStripe(memberId, stripeId, contrib);
    }

    function contribToLatestStripe(
        uint256 memberId,
        string memory message,
        string memory contribType,
        string memory uri
    ) public onlyHolder(memberId) {
        Contribution memory contrib = _createContrib(message, contribType, uri);
        appendContribToLatestStripe(memberId, contrib);
    }

    /// SECTION: Add Attestations!
    ///----------------------------
    function attestToStripe(
        uint256 stripeId,
        uint256 memberId,
        bool vote,
        string memory message
    ) public onlyMember {
        Attestation memory attest = _createAttest(vote, message);
        appendAttestToStripe(memberId, stripeId, attest);
    }

    function attestToLatestStripe(
        uint256 memberId,
        bool vote,
        string memory message
    ) public onlyMember {
        Attestation memory attest = _createAttest(vote, message);
        appendAttestToLatestStripe(memberId, attest);
    }

    ///SECTION: PRIVATE FUNCTIONS
    ///--------------------------
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

    /// called by public contrib functions
    function _createContrib(
        string memory message,
        string memory contribType,
        string memory uri
    ) private view returns (Contribution memory) {
        return
            Contribution(
                msg.sender, //question: when you call inherited functions, does msg.sender == the highest level address? (EOA)
                block.timestamp,
                message,
                contribType,
                uri
            );
    }

    function _createAttest(bool vote, string memory message)
        private
        view
        returns (Attestation memory)
    {
        return Attestation(msg.sender, block.timestamp, vote, message);
    }

    function _getContribById(
        uint256 memberId,
        uint256 stripeId,
        uint256 contribId
    ) private view returns (Contribution memory) {
        return stripesById[memberId][stripeId].contribs[contribId];
    }

    function _getAttestById(
        uint256 memberId,
        uint256 stripeId,
        uint256 attestId
    ) private view returns (Attestation memory) {
        return stripesById[memberId][stripeId].attests[attestId];
    }
}
