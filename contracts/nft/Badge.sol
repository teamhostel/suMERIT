// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./../structures/Stripe.sol";

contract Badge is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    Stripe[] public stripes;
    uint256 public memberId;

    ///@dev msg.sender = the attestor (must be inside DAO)
    modifier onlyMember() {
        require(balanceOf(msg.sender) != 0);
        _;
    }

    constructor(address to) ERC721("Badge", "BG") {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _safeMint(to, newItemId);

        memberId = newItemId;
    }

    function getAddressById(uint256 id) public view {}

    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @param module address of the contrib module
    function contrib(address module) public onlyOwner 
    {
        // stripes.push();
    }

    /// @notice Add your attestation for an input stripeId
    /// @dev Stripe struct contains contribs and attestations
    /// @return pass or fail
    function attest(
        uint256 stripeId,
        address badgeOwner,
        string memory message,
        uint128 points
    ) public onlyMember returns (bool) {
        stripes[stripeId].attests.push(Attestation(msg.sender, message, uint128(block.timestamp), points));
        return true;
    }
}
