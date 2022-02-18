// contracts/structures/Stripe.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./Attestation.sol";
import "./Contribution.sol";

struct Stripe {
    ///@dev one stripe may have many contrib types with separate messages
    ///@notice concise github commit-style message. Or could be one string
    string stripeMessage;
    //purpose: store bulk non-uniform pieces of contribution
    //      possibly store on data availability layer
    //example: organizing a party (manual) ++ notion explainer docs related to party
    //both of these contributions should be in the same stripe. Each one has module address.

    // address[] contribModuleAddr; //one loaded contrib module per messsage?

    //intra-DAO credits
    Attestation[] attests;
    /// batch together work into "Stripe" then attest to the whole stripe
    Contribution[] contribs;
    
    //if the stripe had an svg or png
    //long term - render rich svg
    string tokenURI;
}
