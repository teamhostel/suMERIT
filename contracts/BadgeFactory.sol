// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;
import {ContribModuleManager} from "./ContribModuleManager.sol";

contract BadgeFactory {
    event NewBadge(address owner, uint memberId);

    /// @notice return the DAO member Id for an address
    mapping(address => uint256) public addrToMemberId;

    struct Badge
    {
        address owner;
        uint memberId;
        uint32 stripeCount;
    }

    address private daoToken;
    Badge[] public badges;
    uint private memberNonce = 0;

    // /// @param _token address for existing DAO token
    // /// @todo support more of the DAO stack: creating tokens
    // constructor (address _token)
    // {
    //     memberNonce = 0;
    // }

    function getBadgeForAddress(address _owner) public view returns(Badge memory)
    {
        return badges[addrToMemberId[_owner]];
    }

    /// todo: include trusted (onlyOwner) modifier (dao must deploy from their main multisig)
    function setDaoTokenAddress(address _token) public
    {
        daoToken = _token;
    }

    function addDaoMember(address _member) public
    {
        _mintBadge(_member);
    }

    function _mintBadge(address _owner) internal
    {
        badges.push(Badge(_owner, memberNonce, 0));
        addrToMemberId[_owner] = memberNonce;
        emit NewBadge(_owner, memberNonce);
        memberNonce++;
    }
}
