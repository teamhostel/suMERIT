// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.9;

struct Contribution {
    address[] contributors; //in case multiple stakeholder/peeps involved. First address = badge holder? Function to distribute cred internally?
    // address[] attestors; //vote based attest aggregated via discord and more
    //gradient color could represent the amount of your contrib
    string message; //on-chain contrib message
    uint256 time; //block.timestamp
    string contribType; //DAO defined on-chain metadata
    string uri; //pointer to off-chain props storage. json properties blob //for web links or ipfs/skale storage
}
