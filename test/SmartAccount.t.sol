// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SmartAccount} from "../src/SmartAccount.sol";
import {BatchModule} from "../src/modules/BatchModule.sol";
import {GameFactoryModule} from "../src/modules/Games/GameFactoryModule.sol";
import {Game} from "../src/modules/Games/Game.sol";

contract SmartAccountTest is Test {
    SmartAccount account;
    BatchModule batch;
    GameFactoryModule game;

    address owner = address(0xCAFEBABE);
    address user = address(0x123456);

    function setUp() public {
        vm.startPrank(owner);

        account = new SmartAccount(owner);
        batch = new BatchModule(address(account));
        game = new GameFactoryModule(address(account));

        account.addModule(address(batch));
        account.addModule(address(game));

        vm.stopPrank();
    }

    function testDeploymentAndSetup() public view {
        // Verify the modules were installed
        bool batchModuleInstalled = account.modules(address(batch));
        bool gameModuleInstalled = account.modules(address(game));

        console.log("BatchModule installed:", batchModuleInstalled);
        console.log("GameFactoryModule installed:", gameModuleInstalled);

        assertTrue(batchModuleInstalled);
        assertTrue(gameModuleInstalled);
    }

    function testBatchModuleExecution() public {
        vm.startPrank(address(account));

        address[] memory targets = new address[](1);
        targets[0] = user;

        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("testFunction()");

        batch.batchExecute(targets, data);
        vm.stopPrank();
    }

    function testGameFactoryModuleShouldDeployGame() public {
        vm.startPrank(address(user));

        Game deployedGame = game.createGame();
        console.log("Game:", address(deployedGame));

        vm.stopPrank();
    }

    function testCanWinGame() public {
        vm.startPrank(address(user));

        Game deployedGame = game.createGame();
        console.log("Game:", address(deployedGame));

        uint256 numberAtStart = deployedGame.number();
        for (uint256 i = 0; i < 10; i++) {
            deployedGame.incrementNumber();
        }
        uint256 numberAtEnd = deployedGame.number();

        bool isGoalReached = deployedGame.getIsGoalReached();

        console.log("numberAtStart:", numberAtStart);
        console.log("numberAtEnd:", numberAtEnd);

        assertTrue(numberAtEnd == 10);
        assertTrue(isGoalReached);

        vm.stopPrank();
    }

    function testIncrementingAfterGoalReachedShouldFail() public {
        vm.startPrank(address(user));

        Game deployedGame = game.createGame();
        console.log("Game:", address(deployedGame));

        for (uint256 i = 0; i < 10; i++) {
            deployedGame.incrementNumber();
        }

        // Incrementing after reaching goal should fail
        vm.expectRevert("Goal already reached. Game has ended");
        deployedGame.incrementNumber();

        vm.stopPrank();
    }
}
