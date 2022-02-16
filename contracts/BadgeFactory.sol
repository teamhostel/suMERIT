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
        uint32 stripeCount;
    }

    address private daoToken;
    Badge[] public badges;

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
        uint id = badges.push(Badge(_owner, 0)) - 1;
        addrToMemberId[_owner] = id;
        NewBadge(_owner, id);
    }
}
