// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SmartAccount} from "../src/SmartAccount.sol";
import {BatchModule} from "../src/modules/BatchModule.sol";
import {LimitModule} from "../src/modules/LimitModule.sol";

contract SmartAccountScript is Script {
    SmartAccount public smartAccount;
    BatchModule public batch;
    LimitModule public limit;

    address owner = address(0xCAFEBABE);

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy SmartAccount
        smartAccount = new SmartAccount(owner);

        // Deploy BatchModule and LimitModule
        batch = new BatchModule(address(smartAccount));
        limit = new LimitModule(address(smartAccount), 1 ether);

        // Install modules in SmartAccount
        smartAccount.addModule(address(batch));
        smartAccount.addModule(address(limit));

        vm.stopBroadcast();
    }
}
