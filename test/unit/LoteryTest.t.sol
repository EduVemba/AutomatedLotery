// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import { Test, console } from  "forge-std/Test.sol";
import { Lotery } from "../../src/Lotery.sol";
import { Structs } from "../../src/Structs.sol";

contract LoteryTest is Test {
    Lotery public loteryInstance;
    using Structs for Structs.LoteryStatus;

    address USER = makeAddr("USER");
    uint256 constant INITIAL_BALANCE = 1000 ether;

    uint256 constant SUCCESS_VALUE = 10;


    function setUp() public {
        loteryInstance = new Lotery();
        vm.deal(USER, INITIAL_BALANCE);
    }

    function testLoteryCreates() public {
        loteryInstance.createLotery{value: 100}(10, 100);
       assertTrue(address(loteryInstance).balance >= 100,"Contrato deve ter saldo suficiente");
    }

    function testCreatingTwoLoterys() public {
    
        loteryInstance.createLotery{value: 200}(10, 200);

        vm.expectRevert("There is a open lotery");

        loteryInstance.createLotery{value: 100}(2, 100);
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
        loteryInstance.createLotery{value: 100}(5, 100);

        vm.prank(USER);
        loteryInstance.joinLotery{value: SUCCESS_VALUE}("Eduardo");

        uint256 SUPERIOR_VALUE = 15;

         address USER2 = makeAddr("USER2");
         vm.deal(USER2, INITIAL_BALANCE);
         vm.prank(USER2);
        loteryInstance.joinLotery{value: SUPERIOR_VALUE}("Vemba");
        

        assertEq(loteryInstance.CurrentWinner(), USER2);

        assertTrue(loteryInstance.endLotery(),"A loteria deve terminar com sucesso");

        assertEq(USER2.balance, INITIAL_BALANCE + 100 - SUPERIOR_VALUE,"O vencedor deve receber o premio");

    }

    

}

