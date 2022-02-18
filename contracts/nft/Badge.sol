// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./../structures/Stripe.sol";

/// single badge contract with multiple token ids
/// non-transfereble NFT
/// Owner = BadgeFactory Contract
contract Badge is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //dao sets the theme for stripesById
    //every member needs their own list of stripesById
    //memberId = tokenId
    mapping(uint256 => Stripe[]) public stripesById;
    mapping(uint256 => uint256) public reputationById;
    mapping(uint256 => bool) private transferApprovalById; //option to enable transfers for certain members

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

    function mint(address to) public onlyOwner {
        //DAO member 0 - indexed
        uint256 newItemId = _tokenIds.current();
        _tokenIds.increment();

        _safeMint(to, newItemId);
        // memberId = newItemId; //this goes into owner field
    }

    function createNewStripe(
        uint256 memberId,
        Stripe memory stripe
    ) public onlyOwner returns (bool) {
        stripesById[memberId].push(stripe);
        return true;
    }

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
        Stripe storage lastStripe = getLatestStripe(memberId);
        lastStripe.contribs.push(contrib);
    }

    /// @notice Add a contrib to specific stripe
    /// @dev Explain to a developer any extra details
    /// @param stripeId add contribution to specific stripe
    function contribToStripe(
        uint256 memberId,
        uint256 stripeId,
        Contribution memory contrib
    ) public onlyOwner returns (bool) {
        Stripe storage stripe = stripesById[memberId][stripeId];
        stripe.contribs.push(contrib);
    }

    function editStripeMessage(
        uint256 memberId,
        uint256 stripeId,
        string memory _message
    ) private onlyOwner {
        Stripe storage stripe = stripesById[memberId][stripeId];
        stripe.message = _message;
    }

    /// @notice Add your attestation for the last stripe
    /// @dev Stripe struct contains contribs and attestations
    /// @return pass or fail
    /// add attestation to existing stripe?
    /// always have attest add to the latest stripe
    /// inlcude func to add stripe to a user's list
    function attestToLatestStripe(uint256 memberId, Attestation memory attest)
        private
        onlyOwner
        returns (bool)
    {
        Stripe storage lastStripe = getLatestStripe(memberId);
        lastStripe.attests.push(attest);
        return true;
    }

    function attestToStripe(
        uint256 memberId,
        uint256 stripeId,
        Attestation memory attest
    ) private onlyOwner returns (bool) {
        Stripe storage stripe = stripesById[memberId][stripeId];
        stripe.attests.push(attest);
        return true;
    }

    ///SECTION: UTILITY FUNCTIONS
    ///@dev //push var to the stack. Reading is cheap, memory is cheap (discarded), storing extremely expensive
    function getLatestStripe(uint256 memberId)
        public
        view
        returns (Stripe calldata)
    {
        uint256 lastStripeId = stripesById[memberId].length - 1;
        return stripesById[memberId][lastStripeId];
    }
}
