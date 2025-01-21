// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Game} from "./Game.sol";

/// @title GameFactoryModule
/// @notice This contract allows users to create and manage games.
contract GameFactoryModule {
    address public owner;
    address[] public games;
    mapping(address => address) public playerToGamesOwned;

    event GameCreated(address game, address owner);

    /// @dev Modifier to restrict access to the owner.
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    /// @notice Constructor to initialize the contract with the owner and version.
    /// @param _owner The address of the contract owner.
    constructor(address _owner) {
        owner = _owner;
    }

    /// @notice Creates a new game and assigns it to the caller.
    /// @dev Emits a GameCreated event with the game address and owner address.
    /// @return game The address of the newly created game.
    function createGame() external returns (Game) {
        Game game = new Game(msg.sender);
        games.push(address(game));
        playerToGamesOwned[msg.sender] = address(game);

        emit GameCreated(address(game), msg.sender);

        return game;
    }

    /// @notice Returns the list of all games created.
    /// @return An array of addresses of all games.
    function getGames() external view returns (address[] memory) {
        return games;
    }

    /// @notice Returns the game owned by a specific player.
    /// @param gameOwner The address of the game owner.
    /// @return The address of the game owned by the specified player.
    function getGamesOwned(address gameOwner) external view returns (address) {
        return playerToGamesOwned[gameOwner];
    }

    /// @notice Returns the owner of the contract.
    /// @return The address of the contract owner.
    function getOwner() external view returns (address) {
        return owner;
    }
}
