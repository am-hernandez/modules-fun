// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SmartAccount} from "../src/SmartAccount.sol";
import {BatchModule} from "../src/modules/BatchModule.sol";
import {LimitModule} from "../src/modules/LimitModule.sol";

contract SmartAccountTest is Test {
    SmartAccount account;
    BatchModule batch;
    LimitModule limit;

    address owner = address(0xCAFEBABE);
    address user = address(0x123456);

    function setUp() public {
        vm.startPrank(owner);

        account = new SmartAccount(owner);
        batch = new BatchModule(address(account));
        limit = new LimitModule(address(account), 1 ether);

        account.addModule(address(batch));
        account.addModule(address(limit));

        vm.stopPrank();
    }

    function testDeploymentAndSetup() public view {
        // Verify the modules were installed
        bool batchModuleInstalled = account.modules(address(batch));
        bool limitModuleInstalled = account.modules(address(limit));

        console.log("BatchModule installed:", batchModuleInstalled);
        console.log("LimitModule installed:", limitModuleInstalled);

        assertTrue(batchModuleInstalled);
        assertTrue(limitModuleInstalled);
    }

    function testModuleExecution() public {
        vm.startPrank(address(account));

        address[] memory targets = new address[](1);
        targets[0] = user;

        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("testFunction()");

        batch.batchExecute(targets, data);
        vm.stopPrank();
    }
}
