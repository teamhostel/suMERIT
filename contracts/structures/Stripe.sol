// contracts/structures/Stripe.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./Attestation.sol";

struct Stripe
{
    ///@dev one stripe may have many contrib types with separate messages
    string[] contribMsg;
    address[] contribModule;
    Attestation[] attests;

    string tokenURI;
}