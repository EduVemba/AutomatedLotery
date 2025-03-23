// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Lotery } from "../src/Lotery.sol";

contract LoteryDeploy is Script {
    Lotery public lotery;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        lotery = new Lotery();
        vm.stopBroadcast();
    }
}