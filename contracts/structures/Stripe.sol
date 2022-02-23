// contracts/structures/Stripe.sol
// SPDX-License-Identifier: MIT
pragma solidity <=0.8.9;
import "./Attestation.sol";
import "./Contribution.sol";

///@notice batch together work into "Stripes" which represent epochs of effort.
///@dev Attach your contribs to a stripeId in order to batch your effort into epochs or seasons.
struct Stripe {
    ///@notice concise github commit-style message describing the purpose of the stripe.
    string message;
    ///@notice store URI if the stripe has an svg or png
    ///@dev idea: render rich svg's based on the contrib/attest text inside a badge
    string uri;
}

///SECTION: SETTERS AND GETTERS
