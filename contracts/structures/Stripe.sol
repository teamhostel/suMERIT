// contracts/structures/Stripe.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./Attestation.sol";
import "./Contribution.sol";

struct Stripe {
    ///@dev one stripe may have many contrib types with separate messages
    ///@notice concise github commit-style message describing the purpose of the stripe.
    string message;
    //purpose: store bulk non-uniform pieces of contribution
    //      possibly store on data availability layer
    //example: organizing a party (manual) ++ notion explainer docs related to party
    //both of these contributions should be in the same stripe. Each one has module address.

    // address[] contribModuleAddr; //one loaded contrib module per messsage?

    Contribution[] contribs;
    /// batch together work into "Stripe" then attest to the whole stripe
    //intra-DAO credits
    Attestation[] attests;
    //if the stripe had an svg or png
    //long term - render rich svg
    string tokenURI;
}
