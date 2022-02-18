// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./../structures/Stripe.sol";

/// single badge contract with multiple token ids
/// non-transfereble NFT
contract Badge is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //dao sets the theme for stripesById
    //every member needs their own list of stripesById
    //memberId = tokenId
    mapping(uint256 => Stripe[]) public stripesById;
    mapping(uint256 => uint256) public reputationById;
    mapping(uint256 => bool) private transferApprovalById; //option to enable transfers for certain members

    ///@dev msg.sender = the attestor (must be inside DAO)
    modifier onlyMember() {
        require(balanceOf(msg.sender) != 0, "you are not in the DAO!");
        _;
    }

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        //empty. sets up ERC721
    }

    /// @notice SECURITY RISK: This NFT is non-transferrable
    /// @dev non-transferrable badge: override _transfer
    function _transfer(
        address from,
        address to,
        uint256 tokenId //can choose to specify override contract
    ) internal virtual override {
        require(false, "Non-transferrable!");
    }

    function mint(address to) {
        //DAO member 0 - indexed
        uint256 newItemId = _tokenIds.current();
        _tokenIds.increment();

        _safeMint(to, newItemId);
        // memberId = newItemId; //this goes into owner field
    }

    function contribNewStripe(uint256 memberId, Contribution memory contrib)
        public
        onlyOwner
        returns (bool)
    {}

    /// @notice Add a contrib to your most recent stripe
    /// @dev Explain to a developer any extra details
    function contribToLatestStripe(
        uint256 memberId,
        Contribution memory contrib
    )
        public
        onlyOwner //BadgeFactory is the owner
        returns (bool)
    {
        // stripesById.push();
    }

    /// @notice Add a contrib to specific stripe
    /// @dev Explain to a developer any extra details
    /// @param stripeId add contribution to specific stripe
    function contribToStripe(
        uint256 memberId,
        uint256 stripeId,
        Contribution memory contrib
    ) public onlyOwner returns (bool) {
        // stripesById.push();
    }

    /// @notice Add your attestation for the last stripe
    /// @dev Stripe struct contains contribs and attestations
    /// @return pass or fail
    /// add attestation to existing stripe?
    /// always have attest add to the latest stripe
    /// inlcude func to add stripe to a user's list
    function attestToLatest(uint256 memberId, Attestation memory attest)
        public
        onlyMember
        returns (bool)
    {
        uint256 lastStripeId = stripesById[memberId].length - 1; //push var to the stack. Reading is cheap, memory is cheap (discarded), storing extremely expensive
        Stripe lastStripe = stripesById[memberId][lastStripeId];

        lastStripe.attests.push(attest);
        return true;
    }

    function attestTo(
        uint256 memberId,
        uint256 stripeId,
        Attestation memory attest
    ) public onlyMember returns (bool) {
        Stripe stripe = stripesById[memberId][stripeId];

        stripe.attests.push(attest);
        return true;
    }
}