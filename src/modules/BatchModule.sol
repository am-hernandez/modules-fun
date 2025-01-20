// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract BatchModule {
    address public account;

    modifier onlyAccount() {
        require(msg.sender == account, "Unauthorized");
        _;
    }

    constructor(address _account) {
        account = _account;
    }

    function batchExecute(address[] calldata targets, bytes[] calldata data) external onlyAccount {
        require(targets.length == data.length, "Mismatched inputs");
        for (uint256 i = 0; i < targets.length; i++) {
            (bool success,) = targets[i].call(data[i]);
            require(success, "Batch failed");
        }
    }
}
