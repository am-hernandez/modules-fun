// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Game} from "./Game.sol";

contract GameFactoryModule {
    address public owner;
    address[] public games;
    mapping(address => address) public playerToGamesOwned;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function createGame() external returns (Game) {
        Game game = new Game(msg.sender);
        games.push(address(game));
        playerToGamesOwned[msg.sender] = address(game);

        return game;
    }

    function getGames() external view returns (address[] memory) {
        return games;
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}
