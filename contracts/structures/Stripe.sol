// contracts/structures/Stripe.sol
// SPDX-License-Identifier: MIT
pragma solidity <=0.8.9;
import "./Attestation.sol";
import "./Contribution.sol";

///@notice batch together work into "Stripes" which represent epochs of effort.
///        then attest to the whole stripe
///@dev    fascinating tradeoffs between mappings and arrays.
/// using contracts as namespaces
contract cStripe is cContribution, cAttestation {
    struct Stripe {
        ///@dev one stripe may have many contrib types with separate messages
        ///@notice concise github commit-style message describing the purpose of the stripe.
        string message;
        ///@dev if the stripe had an svg or png
        ///@dev long term - render rich svg
        string uri;
        ///@dev comparing arrays versus mappings! Mappings seem better for this.
        // Contribution[] contribs; //array of struct
        mapping(uint256 => Contribution) contribs;
        uint256 contribSize;
        // Attestation[] attests;
        mapping(uint256 => Attestation) attests;
        uint256 attestSize;
    }

    ///SECTION: SETTERS AND GETTERS
}
