// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;
import "./nft/Badge.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//badge factory allows you to see all the functions and permissions
/// BFM - badge factory manager? contains module addresses. Allows construcing your DAO's custom badge factory. A factory for badge factory.
/// benefit of factory: deploying contract is dead simple
contract BadgeFactory is
    Ownable //ownable allows ownership transfer of contract
{
    address private daoToken;
    Badge private badge; //NFT contract! address behind the scenes (it's also a contract that looks like badge interface)
    
    modifier onlyMember() {
        require(badge.balanceOf(msg.sender) != 0, "you are not in the DAO!");
        _;
    }

    event NewBadge(address owner, uint256 memberId);
    // event NewFactory(address memory cont); //for BFM

    /// @notice return the DAO member Id for an address
    mapping(address => uint256) public addrToMemberId;
    

    /// DEPRECATED VARIABLES
    // mapping(address => bool) memberWhitelist; //not needed because
    ///require dao adds members, members can't add themselves. Don't allow members to mint their own badges.
    // mapping(uint256 => address) public memberIdToAddress; //not needed because of func getAddressById
    // address[] public badges; //this should be covered in memberIdToAddress

    /// @param _token address for existing DAO token
    /// @dev todo support more of the DAO stack: creating tokens
    constructor(
        address _token,
        string memory name,
        string memory symbol,
        string memory uri
    ) {
        //create badge contract = each factory has one badge contract w/multiple ideas
        daoToken = _token;
        badge = Badge(name, symbol);
    }

    /// @dev todo include trusted (onlyOwner) modifier (dao must deploy from their main multisig)
    function setDaoTokenAddress(address _token) public onlyOwner {
        daoToken = _token;
    }

    ///@notice add individual member
    function addDaoMember(address _member) public onlyOwner {
        _mintBadge(_member);
    }

    /// the DAO says these are our members: address[]
    /// modifier no args - no parentheses needed
    function batchMintBadges(address[] memory members) onlyOwner {}

    ///@notice gasless (for member) mint
    function _mintBadge(address _owner) internal {
        // Badge myBadge = Badge(_owner); //this is creating new contract on every mint
        ///look up badge by Id, which returns address of owner

        ///@dev relevant mappings for easy access
        addrToMemberId[_owner] = myBadge.memberId();
        // memberIdToAddress[myBadge.memberId()] = _owner;

        emit NewBadge(_owner, myBadge.memberId());
    }

    function getAddressById(uint256 id) public view returns (address) {
        return badge.ownerOf(id);
    }


    ///SECTION: Contribs and Attests
    //Attestation(msg.sender, message, uint128(block.timestamp), points)
}
