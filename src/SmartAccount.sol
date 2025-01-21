// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SmartAccount {
    address private owner;
    mapping(address => bool) public modules;

    event ModuleAdded(address indexed module);
    event ModuleRemoved(address indexed module);
    event ModuleExecuted(
        address indexed module,
        address indexed user,
        bytes data
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function addModule(address module) external onlyOwner {
        require(!modules[module], "Module already installed");
        modules[module] = true;
        emit ModuleAdded(module);
    }

    function removeModule(address module) external onlyOwner {
        require(modules[module], "Module not installed");
        modules[module] = false;
        emit ModuleRemoved(module);
    }

    function executeModule(address target, bytes calldata data) external {
        require(modules[msg.sender], "Unauthorized module");
        (bool success, ) = target.call(data);
        require(success, "Execution failed");

        emit ModuleExecuted(msg.sender, target, data);
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}
