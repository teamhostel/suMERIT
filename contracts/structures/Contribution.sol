// contracts/structures/Contribution.sol
// SPDX-License-Identifier: MIT
pragma solidity <=0.8.9;

struct Contribution {
    ///@dev block.timestamp
    uint256 time;
    ///@param stripeId shows which stripe or 'epoch' this contrib is attached to
    ///@notice The Stripe represents an epoch, or theme, of contribution. Open ended to DAO's uses
    ///@dev idea: Stripes could be a toggle-able module in BadgeFactoryManager.sol
    uint256 stripeId;
    ///@notice DAO defined on-chain metadata
    string contribType;
    ///@notice json properties blob
    ///@dev pointer to off-chain props storage. for web links or ipfs storage
    string uri;
    ///@notice on-chain contrib message
    string message;

    ///@dev idea: gradient color could represent the amount of your contrib
    ///@dev idea: for team effort contribs, map contrib to multiple
    ///@dev for now, one contribution = one address. Add contrib to each person's stripe
    ///@notice raid squads = address[] = a group of people who coordinate together often. Accountability partners.
    // address[] contributor; //in case multiple stakeholder/peeps involved. First address = badge holder? Function to distribute cred internally?
}
