// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SmartAccount} from "../src/SmartAccount.sol";
import {BatchModule} from "../src/modules/BatchModule.sol";
import {GameModule} from "../src/modules/GameModule.sol";

contract SmartAccountTest is Test {
    SmartAccount account;
    BatchModule batch;
    GameModule game;

    address owner = address(0xCAFEBABE);
    address user = address(0x123456);

    function setUp() public {
        vm.startPrank(owner);

        account = new SmartAccount(owner);
        batch = new BatchModule(address(account));
        game = new GameModule(address(account));

        account.addModule(address(batch));
        account.addModule(address(game));

        vm.stopPrank();
    }

    function testDeploymentAndSetup() public view {
        // Verify the modules were installed
        bool batchModuleInstalled = account.modules(address(batch));
        bool gameModuleInstalled = account.modules(address(game));

        console.log("BatchModule installed:", batchModuleInstalled);
        console.log("GameModule installed:", gameModuleInstalled);

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

    function testGameModuleExecution() public {
        vm.startPrank(address(account));

        uint256 numberAtStart = game.number();
        game.incrementNumber();
        game.incrementNumber();
        game.incrementNumber();
        uint256 numberAtEnd = game.number();

        console.log("numberAtStart:", numberAtStart);
        console.log("numberAtEnd:", numberAtEnd);

        assertTrue(numberAtEnd == 3);

        vm.stopPrank();
    }

    function testCanWinGameModule() public {
        vm.startPrank(address(account));

        uint256 numberAtStart = game.number();
        for (uint256 i = 0; i < 10; i++) {
            game.incrementNumber();
        }
        uint256 numberAtEnd = game.number();

        bool isGoalReached = game.getIsGoalReached();

        console.log("numberAtStart:", numberAtStart);
        console.log("numberAtEnd:", numberAtEnd);

        assertTrue(numberAtEnd == 10);
        assertTrue(isGoalReached);

        vm.stopPrank();
    }

    function testIncrementingAfterGoalReachedShouldFail() public {
        vm.startPrank(address(account));

        for (uint256 i = 0; i < 10; i++) {
            game.incrementNumber();
        }

        // Incrementing after reaching goal should fail
        vm.expectRevert("Goal already reached. Game has ended");
        game.incrementNumber();

        vm.stopPrank();
    }
}
