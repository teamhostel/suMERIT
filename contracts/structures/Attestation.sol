// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

struct Attestation {
    address attestor;
    string message;
    uint128 time;
    int256 points; //for erc20 and reputation score later
    string uri; //pointer to off-chain props storage. json properties blob //for web links or ipfs/skale storage
}