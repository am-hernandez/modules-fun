// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SmartAccount} from "../src/SmartAccount.sol";
import {BatchModule} from "../src/modules/BatchModule.sol";
import {GameFactoryModule} from "../src/modules/Games/GameFactoryModule.sol";

contract SmartAccountScript is Script {
    SmartAccount public smartAccount;
    BatchModule public batch;
    GameFactoryModule public gameFactory;

    address owner = address(0xCAFEBABE);

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy SmartAccount
        smartAccount = new SmartAccount(owner);

        // Deploy BatchModule and LimitModule
        batch = new BatchModule(address(smartAccount));
        gameFactory = new GameFactoryModule(address(smartAccount));

        // Install modules in SmartAccount
        smartAccount.addModule(address(batch));
        smartAccount.addModule(address(gameFactory));

        vm.stopBroadcast();
    }
}
