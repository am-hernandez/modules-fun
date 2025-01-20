// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract LimitModule {
    address public account;
    uint256 public maxTransactionLimit;

    modifier onlyAccount() {
        require(msg.sender == account, "Unauthorized");
        _;
    }

    constructor(address _account, uint256 _limit) {
        account = _account;
        maxTransactionLimit = _limit;
    }

    function setLimit(uint256 newLimit) external onlyAccount {
        maxTransactionLimit = newLimit;
    }

    function enforceLimit(address target, uint256 value, bytes calldata data) external onlyAccount {
        require(value <= maxTransactionLimit, "Exceeds limit");
        (bool success,) = target.call{value: value}(data);
        require(success, "Execution failed");
    }
}
