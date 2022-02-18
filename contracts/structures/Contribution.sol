// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

struct Contribution {
    address[] contributors;
    string message; //on-chain contrib message
    uint128 time; //block.timestamp
    string contribType; //DAO defined on-chain metadata
    string uri; //pointer to off-chain props storage. json properties blob //for web links or ipfs/skale storage
}
