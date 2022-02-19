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
    ERC721URIStorage, //for storing remote ref in NFT
    cStripe
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //dao sets the theme for stripesById
    //every member needs their own list of stripesById
    mapping(uint256 => Stripe[]) public stripesById;
    mapping(uint256 => uint256) public reputationById;
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
        //DAO member 0 - indexed
        uint256 newItemId = _tokenIds.current();
        _tokenIds.increment();

        _safeMint(to, newItemId);
        return newItemId;
        // memberId = newItemId; //this goes into owner field
    }

    function newStripeForId(
        uint256 memberId,
        string memory message,
        string memory uri
    ) internal returns (bool) {
        uint256 stripeId = stripesById[memberId].length;
        // stripesById[memberId][stripesById[memberId].length - 1] = stripe;
        stripesById[memberId].push();
        stripesById[memberId][stripeId].message = message;
        stripesById[memberId][stripeId].uri = uri;
        return true;
    }

    /// @notice Add a contrib to your most recent stripe
    /// @dev Explain to a developer any extra details
    function contribToLatestStripe(
        uint256 memberId,
        Contribution memory contrib
    ) internal returns (bool) {
        uint256 stripeId = getLatestStripeId(memberId);
        Stripe storage stripe = stripesById[memberId][stripeId];
        stripe.contribs[stripe.contribSize] = contrib;
        stripe.contribSize++;
        return true;
    }

    /// @notice Add a contrib to specific stripe
    /// @dev Explain to a developer any extra details
    /// @param stripeId add contribution to specific stripe
    function contribToStripe(
        uint256 memberId,
        uint256 stripeId,
        Contribution memory contrib
    ) internal returns (bool) {
        // Stripe storage stripe = stripesById[memberId][stripeId];
        // stripe.contribs[stripe.contribSize] = contrib;
        // stripe.contribSize++;
    }

    function editStripeMessage(
        uint256 memberId,
        uint256 stripeId,
        string memory _message
    ) internal {
        stripesById[memberId][stripeId].message = _message;
    }

    /// @notice Add your attestation for the last stripe
    /// @dev Stripe struct contains contribs and attestations
    /// @return pass or fail
    /// add attestation to existing stripe?
    /// always have attest add to the latest stripe
    /// inlcude func to add stripe to a user's list
    function attestToLatestStripe(uint256 memberId, Attestation memory attest)
        internal
        returns (bool)
    {
        uint256 stripeId = getLatestStripeId(memberId);
        // stripesById[memberId][stripeId].attests.push(attest);
        return true;
    }

    function attestToStripe(
        uint256 memberId,
        uint256 stripeId,
        Attestation memory attest
    ) internal returns (bool) {
        // stripesById[memberId][stripeId].attests.push(attest);
        return true;
    }

    ///SECTION: UTILITY FUNCTIONS
    ///@dev //push var to the stack. Reading is cheap, memory is cheap (discarded), storing extremely expensive
    function getLatestStripeId(uint256 memberId) public view returns (uint256) {
        return stripesById[memberId].length - 1;
    }
}
