// SPDX-License-Identifier: MIT
pragma solidity <=0.8.9;

contract cContribution {
    struct Contribution {
        ///@dev idea: for team effort contribs, map contrib to multiple
        ///@dev for now, one contribution = one address. Add contrib to each person's stripe
        ///@notice raid squads = address[] = a group of people who coordinate together often. Accountability partners.
        address contributor; //in case multiple stakeholder/peeps involved. First address = badge holder? Function to distribute cred internally?
        ///@notice on-chain contrib message
        ///@dev block.timestamp
        uint256 time;
        string message;
        ///@notice DAO defined on-chain metadata
        string contribType;
        ///@dev pointer to off-chain props storage.
        ///@notice json properties blob
        ///@dev for web links or ipfs/skale storage
        string uri;
        ///@dev idea: gradient color could represent the amount of your contrib
    }

    function messageOf(Contribution memory c) public pure returns (string memory)
    {
        return c.message;
    }
}
