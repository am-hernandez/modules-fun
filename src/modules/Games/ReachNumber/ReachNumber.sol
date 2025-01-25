// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ReachNumber {
    address public owner;
    uint256 public number;
    uint256 private constant _numberGoal = 10;
    bool public isGoalReached = false;

    event NumberIncremented(uint256 number);
    event GoalReached(address owner, uint256 number, uint256 _numberGoal);

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
            emit GoalReached(owner, number, _numberGoal);
        }
    }

    function getIsGoalReached() public view returns (bool) {
        return isGoalReached;
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}
