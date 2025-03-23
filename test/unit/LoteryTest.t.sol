// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import { Test, console } from  "forge-std/Test.sol";
import { Lotery } from "../../src/Lotery.sol";
import { Structs } from "../../src/Structs.sol";

contract LoteryTest is Test {
    Lotery public loteryInstance;
    using Structs for Structs.LoteryStatus;

    address USER = makeAddr("USER");
    uint256 constant INITIAL_BALANCE = 100 ether;

    uint256 constant SUCCESS_VALUE = 10;


    function setUp() public {
        loteryInstance = new Lotery();
        vm.deal(USER, INITIAL_BALANCE);
    }

    function testLoteryCreates() public {

       assertTrue(loteryInstance.createLotery(10, 1000),"Should return true");
    }

    function testCreatingTwoLoterys() public {
        loteryInstance.createLotery(10, 200);

        vm.expectRevert("There is a open lotery");

        loteryInstance.createLotery(2, 100);
    }

    function testRewardBiggerThenEntry() public  {
        vm.expectRevert("the award should be bigger then the entry");
        loteryInstance.createLotery(100, 50);
    }


    function testJoinLotery() public {
        loteryInstance.joinLotery{value: SUCCESS_VALUE }("Eduardo");
    }

    /**
     * SUCCESS_VALUE = 10
     * FAILING_VALUE = 5
     */
    function testCannotJoinLotery() public {
        loteryInstance.joinLotery{value: SUCCESS_VALUE}("Eduardo");

        uint256 FAILING_VALUE = 5;

        vm.expectRevert("the value must be bigger then the winning value");

        loteryInstance.joinLotery{value: FAILING_VALUE}("Ruth");
    }


    function testEndLotery() public {
        loteryInstance.createLotery(5, 50);

        loteryInstance.joinLotery{value: SUCCESS_VALUE}("Eduardo");

        uint256 SUPERIOR_VALUE = 15;

        loteryInstance.joinLotery{value: SUPERIOR_VALUE}("Vemba");

        assertTrue(loteryInstance.endLotery());
    }

}

