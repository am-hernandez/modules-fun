// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract GameModule {
    address public owner;
    uint256 public number;
    uint256 private constant _numberGoal = 10;
    bool public isGoalReached = false;

    modifier goalNotReached() {
        require(isGoalReached == false, "Goal already reached. Game has ended");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function incrementNumber() external onlyOwner goalNotReached {
        number++;

        if (number == _numberGoal) {
            isGoalReached = true;
        }
    }

    function getIsGoalReached() public view returns (bool) {
        return isGoalReached;
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}
