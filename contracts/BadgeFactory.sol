// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;
import {ContribModuleManager} from "./ContribModuleManager.sol";
import "./nft/Badge.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";

contract BadgeFactory is ERC721, Ownable {
    event NewBadge(address owner, uint256 memberId);

    /// @notice return the DAO member Id for an address
    mapping(address => uint256) public addrToMemberId;
    mapping(uint256 => address) public memberIdToAddress;

    address private daoToken;

    // address[] public badges; //this should be covered in memberIdToAddress

    /// @param _token address for existing DAO token
    /// @dev todo support more of the DAO stack: creating tokens
    constructor(address _token) ERC721("BadgeFactory", "FACT") {
        daoToken = _token;
    }

    /// @dev todo include trusted (onlyOwner) modifier (dao must deploy from their main multisig)
    function setDaoTokenAddress(address _token) public onlyOwner() {
        daoToken = _token;
    }

    function addDaoMember(address _member) public onlyOwner() {
        _mintBadge(_member);
    }

    function _mintBadge(address _owner) internal {
        Badge myBadge = Badge(_owner);

        ///@dev relevant mappings for easy access
        addrToMemberId[_owner] = myBadge.memberId();
        memberIdToAddress[myBadge.memberId()] = _owner;
        emit NewBadge(_owner, myBadge.memberId());
    }
}
