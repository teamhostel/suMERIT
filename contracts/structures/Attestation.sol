// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

struct Attestation {
    address attestor;
    string message;
    uint128 time;
    uint128 points;    
}
