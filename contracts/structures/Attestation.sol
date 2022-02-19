// SPDX-License-Identifier: MIT
pragma solidity <=0.8.9;

///@dev (require some count of attestations to post your first contrib?)
contract cAttestation {
    struct Attestation {
        ///@notice who is voting?
        address attestor;
        ///@notice yes/no
        bool vote;
        ///@notice optional included message
        string message;
        uint256 time;
    }
}
