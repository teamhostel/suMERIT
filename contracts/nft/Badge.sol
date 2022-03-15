// SPDX-License-Identifier: GPL-3.0
pragma solidity <=0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./../structures/Stripe.sol";

/**
 * single badge contract with multiple token ids
 * non-transfereble NFT
 * Owner = BadgeFactory Contract
 */
contract Badge is
    Ownable,
    ERC721URIStorage
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //dao sets the theme for stripesById
    //every member needs their own list of stripesById
    // mapping(uint256 => mapping(uint256 => Stripe)) public stripesById;
    // mapping(uint256 => uint256) public stripeCount;
    mapping(uint256 => Contribution[]) private _contribs;
    // mapping(uint256 => uint256) private _contribSize;
    mapping(uint256 => Attestation[]) private _attests;
    // mapping(uint256 => uint256) private _attestSize;
    mapping(uint256 => Stripe[]) private _stripes;

    mapping(uint256 => bool) private transferApprovalById; //option to enable transfers for certain members
    mapping(uint256 => string) public discordUsernameById; ///store discord username per badge ID. Then, gelato can automate pushing discord contrib messages to badges! Saving members gas

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

    function mint(address to) internal returns (uint256) {
        //DAO member 1 - indexed
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _safeMint(to, newItemId);
        return newItemId;
        // memberId = newItemId; //this goes into owner field
    }

    /// @notice "mint" a new stripe for a member ID
    /// @dev stripesById is a 2d nested mapping for Stripes for everyone!
    function newStripeForId(
        uint256 memberId,
        string memory message,
        string memory uri
    ) internal {
        // uint256 stripeId = stripesById[memberId].length;
        // stripesById[memberId].push();
        uint256 myStripes = stripeCount[memberId];
        stripesById[memberId][myStripes].message = message;
        stripesById[memberId][myStripes].uri = uri;
        stripesById[memberId][myStripes].message = message;
        stripesById[memberId][myStripes].contribSize = 0;
        stripesById[memberId][myStripes].attestSize = 0;
        stripeCount[memberId]++;
    }

    /// @notice Add a contrib to specific member's stripe
    /// @dev append contrib to the mapping(uint256 => Contribution) contribs;
    /// @param memberId the Badge NFT ID
    /// @param stripeId ref specific stripe
    /// @param contrib obj describing a Contribution
    function appendContribToStripe(
        uint256 memberId,
        uint256 stripeId,
        Contribution memory contrib
    ) internal {
        Stripe storage stripe = stripesById[memberId][stripeId];
        stripe.contribs[stripe.contribSize] = contrib;
        stripe.contribSize++;
        // stripesById[memberId][stripeId].contribs[stripesById[memberId][stripeId].contribSize]
    }

    /// @notice Add a contrib to your most recent stripe
    /// @dev Explain to a developer any extra details
    function appendContribToLatestStripe(
        uint256 memberId,
        Contribution memory contrib
    ) internal {
        uint256 stripeId = getLatestStripeId(memberId);
        Stripe storage stripe = stripesById[memberId][stripeId];
        stripe.contribs[stripe.contribSize] = contrib;
        stripe.contribSize++;
    }

    function appendAttestToStripe(
        uint256 memberId,
        uint256 stripeId,
        Attestation memory attest
    ) internal {
        Stripe storage stripe = stripesById[memberId][stripeId];
        stripe.attests[stripe.contribSize] = attest;
        stripe.attestSize++;
    }

    /// @notice Add your attestation for the latest stripe!
    /// @dev Stripe struct contains contribs and attestations
    function appendAttestToLatestStripe(
        uint256 memberId,
        Attestation memory attest
    ) internal {
        uint256 stripeId = getLatestStripeId(memberId);
        Stripe storage stripe = stripesById[memberId][stripeId];
        stripe.attests[stripe.contribSize] = attest;
        stripe.attestSize++;
    }

    ///SECTION: VIEW FUNCTIONS
    ///@dev //push var to the stack. Reading is cheap, memory is cheap (discarded), storing extremely expensive
    function getLatestStripeId(uint256 memberId) public view returns (uint256) {
        require(stripeCount[memberId] > 0, "Go and add your first Stripe!");
        return stripeCount[memberId] - 1;
    }

    function getStripeCount(uint256 memberId) public view returns (uint256) {
        return stripeCount[memberId];
    }

    function getContribMessagesById(uint256 memberId, uint256 stripeId)
        public
        view
        returns (string[] memory)
    {
        uint256 size = stripesById[memberId][stripeId].contribSize;
        string[] memory messages = new string[](size);
        for (uint256 index = 0; index < size; index++) {
            string memory message = stripesById[memberId][stripeId]
                .contribs[index]
                .message;
            messages[index] = message;
        }
        return messages;
    }
}
