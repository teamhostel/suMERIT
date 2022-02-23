// SPDX-License-Identifier: MIT
pragma solidity <=0.8.9;

///@dev (require some count of attestations to post your first contrib?)
struct Attestation {
    ///@dev block.timestamp
    uint256 time;
    ///@notice Attached Contribution Id that you are voting on
    uint256 contribId;
    ///@notice What DAO member is voting?
    address attestor;
    ///@notice yes/no
    bool vote;
    ///@notice optional included message
    string message;
}
