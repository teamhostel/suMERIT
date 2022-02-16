// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;

// import {ZoraProtocolFeeSettings} from "./auxiliary/ZoraProtocolFeeSettings/ZoraProtocolFeeSettings.sol";

/// @title ContribModuleManager
/// @author 
/// @notice This contract allows users to add & access modules on CONTRIB
contract ContribModuleManager {
    /// @notice The signature nonces for 3rd party module approvals
    mapping(address => uint256) public sigNonces;

    /// @notice The registrar address that can register modules
    address public registrar;

    /// @dev no plans for module fees within contrib, except on-mint
    /// @notice The module fee NFT contract to mint from upon module registration
    // ZoraProtocolFeeSettings public moduleFeeToken;

    /// @notice Mapping of each user to module approval by module contract address
    /// @dev User address => Module address => Approved
    mapping(address => mapping(address => bool)) public userApprovals;

    /// @notice A mapping of module addresses to module data
    mapping(address => bool) public moduleRegistered;

    modifier onlyRegistrar() {
        require(msg.sender == registrar, "ZMM::onlyRegistrar must be registrar");
        _;
    }

    event ModuleRegistered(address indexed module);

    event ModuleApprovalSet(address indexed user, address indexed module, bool approved);

    event RegistrarChanged(address indexed newRegistrar);

    /// @param _registrar The initial registrar for the manager
    constructor(address _registrar) {
        require(_registrar != address(0), "ZMM::must set registrar to non-zero address");

        registrar = _registrar;
        // moduleFeeToken = ZoraProtocolFeeSettings(_feeToken);
    }

    /// @notice Returns true if the user has approved a given module, false otherwise
    /// @param _user The user to check approvals for
    /// @param _module The module to check approvals for
    /// @return True if the module has been approved by the user, false otherwise
    function isModuleApproved(address _user, address _module) external view returns (bool) {
        return userApprovals[_user][_module];
    }

    //        ,-.
    //        `-'
    //        /|\
    //         |             ,-----------------.
    //        / \            |ContribModuleManager|
    //      Caller           `--------+--------'
    //        | setApprovalForModule()|
    //        | ---------------------->
    //        |                       |
    //        |                       |----.
    //        |                       |    | set approval for module
    //        |                       |<---'
    //        |                       |
    //        |                       |----.
    //        |                       |    | emit ModuleApprovalSet()
    //        |                       |<---'
    //      Caller           ,--------+--------.
    //        ,-.            |ContribModuleManager|
    //        `-'            `-----------------'
    //        /|\
    //         |
    //        / \
    /// @notice Allows a user to set the approval for a given module
    /// @param _module The module to approve
    /// @param _approved A boolean, whether or not to approve a module
    function setApprovalForModule(address _module, bool _approved) public {
        _setApprovalForModule(_module, msg.sender, _approved);
    }

    //        ,-.
    //        `-'
    //        /|\
    //         |                  ,-----------------.
    //        / \                 |ContribModuleManager|
    //      Caller                `--------+--------'
    //        | setBatchApprovalForModule()|
    //        | --------------------------->
    //        |                            |
    //        |                            |
    //        |         _____________________________________________________
    //        |         ! LOOP  /  for each module                           !
    //        |         !______/           |                                 !
    //        |         !                  |----.                            !
    //        |         !                  |    | set approval for module    !
    //        |         !                  |<---'                            !
    //        |         !                  |                                 !
    //        |         !                  |----.                            !
    //        |         !                  |    | emit ModuleApprovalSet()   !
    //        |         !                  |<---'                            !
    //        |         !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //      Caller                ,--------+--------.
    //        ,-.                 |ContribModuleManager|
    //        `-'                 `-----------------'
    //        /|\
    //         |
    //        / \
    /// @notice Sets approvals for multiple modules at once
    /// @param _modules The list of module addresses to set approvals for
    /// @param _approved A boolean, whether or not to approve the modules
    function setBatchApprovalForModules(address[] memory _modules, bool _approved) public {
        for (uint256 i = 0; i < _modules.length; i++) {
            _setApprovalForModule(_modules[i], msg.sender, _approved);
        }
    }


    //         ,-.
    //         `-'
    //         /|\
    //          |               ,-----------------.          ,-----------------------.
    //         / \              |ContribModuleManager|          |ZoraProtocolFeeSettings|
    //      Registrar           `--------+--------'          `-----------+-----------'
    //          |   registerModule()     |                               |
    //          |----------------------->|                               |
    //          |                        |                               |
    //          |                        ----.                           |
    //          |                            | register module           |
    //          |                        <---'                           |
    //          |                        |                               |
    //          |                        |            mint()             |
    //          |                        |------------------------------>|
    //          |                        |                               |
    //          |                        |                               ----.
    //          |                        |                                   | mint token to registrar
    //          |                        |                               <---'
    //          |                        |                               |
    //          |                        ----.                           |
    //          |                            | emit ModuleRegistered()   |
    //          |                        <---'                           |
    //      Registrar           ,--------+--------.          ,-----------+-----------.
    //         ,-.              |ContribModuleManager|          |ZoraProtocolFeeSettings|
    //         `-'              `-----------------'          `-----------------------'
    //         /|\
    //          |
    //         / \
    /// @notice Registers a module
    /// @param _module The address of the module
    function registerModule(address _module) public onlyRegistrar {
        require(!moduleRegistered[_module], "ZMM::registerModule module already registered");

        moduleRegistered[_module] = true;
        // moduleFeeToken.mint(registrar, _module);

        emit ModuleRegistered(_module);
    }

    //         ,-.
    //         `-'
    //         /|\
    //          |               ,-----------------.
    //         / \              |ContribModuleManager|
    //      Registrar           `--------+--------'
    //          |    setRegistrar()      |
    //          |----------------------->|
    //          |                        |
    //          |                        ----.
    //          |                            | set registrar
    //          |                        <---'
    //          |                        |
    //          |                        ----.
    //          |                            | emit RegistrarChanged()
    //          |                        <---'
    //      Registrar           ,--------+--------.
    //         ,-.              |ContribModuleManager|
    //         `-'              `-----------------'
    //         /|\
    //          |
    //         / \
    /// @notice Sets the registrar for the ZORA Module Manager
    /// @param _registrar the address of the new registrar
    function setRegistrar(address _registrar) public onlyRegistrar {
        require(_registrar != address(0), "ZMM::setRegistrar must set registrar to non-zero address");
        registrar = _registrar;

        emit RegistrarChanged(_registrar);
    }

    function _chainID() private view returns (uint256 id) {
        assembly {
            id := chainid()
        }
    }

    function _setApprovalForModule(
        address _module,
        address _user,
        bool _approved
    ) private {
        require(moduleRegistered[_module], "ZMM::must be registered module");

        userApprovals[_user][_module] = _approved;

        emit ModuleApprovalSet(msg.sender, _module, _approved);
    }
}
