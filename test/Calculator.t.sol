// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "forge-std/Test.sol";
import "../src/Calculator.sol";

contract TestCalculator is Test {
    Calculator calculator;
    uint256 public firstResult = 100;
    address public admin = vm.addr(1);

    function setUp() public {
        calculator = new Calculator(firstResult, admin);
    }

    //Unit testing
    function testCheckFirstResult() public view { 
        assertEq(calculator.result(), firstResult);
    } 

    function testAddition() public {
        uint256 firstNumber = 10;
        uint256 secondNumber = 20;
        uint256 expected = firstNumber + secondNumber;

        assertEq(calculator.addition(firstNumber, secondNumber), expected);
    }

    function testSubtraction() public {
        uint256 firstNumber = 30;
        uint256 secondNumber = 20;
        uint256 expected = firstNumber - secondNumber;

        assertEq(calculator.subtraction(firstNumber, secondNumber), expected);
    }

    function testMultiplication() public {
        uint256 firstNumber = 30;
        uint256 secondNumber = 20;
        uint256 expected = firstNumber * secondNumber;

        assertEq(calculator.multiplication(firstNumber, secondNumber), expected);
    }

    function testCannotMultiplyTwoLargeNumbersWithLargerFirstNumber() public {
        uint256 firstNumber = type(uint256).max - 1;
        uint256 secondNumber = 2;
        
        vm.expectRevert();
        calculator.multiplication(firstNumber, secondNumber);
    }

    function testCannotMultiplyTwoLargeNumbersWithLargerSecondNumber() public {
        uint256 firstNumber = 3;
        uint256 secondNumber = type(uint256).max - 1;
        
        vm.expectRevert();
        calculator.multiplication(firstNumber, secondNumber);
    }


    function testDivision() public {
        vm.startPrank(admin);
        uint256 firstNumber = 30;
        uint256 secondNumber = 2;
        uint256 expected = firstNumber / secondNumber;

        assertEq(calculator.division(firstNumber, secondNumber), expected);
        vm.stopPrank();
    }
    
    function testCannotDivideTwoNumbersWithAdminNotAuthorized() public {
        uint256 firstNumber = 30;
        uint256 secondNumber = 2;
        
        vm.expectRevert();
        calculator.division(firstNumber, secondNumber);
    }


    function testDivideByZeroExpectsRevert() public {
        vm.startPrank(admin);
        uint256 firstNumber = 30;
        uint256 secondNumber = 0;
        
        vm.expectRevert();
        calculator.division(firstNumber, secondNumber);
        vm.stopPrank();
    }


    //Fuzzing testing
    function testFuzzingDivision(uint256 _firstNumber, uint256 _secondNumber) public {
        vm.startPrank(admin);
        uint256 firstNumber = _firstNumber;
        uint256 secondNumber = _secondNumber % 256;
        if (secondNumber == 0) secondNumber = 1; 

        vm.assume(secondNumber != 0);
        uint256 expected = firstNumber / secondNumber;

        assertEq(calculator.division(firstNumber, secondNumber), expected);
        vm.stopPrank();
    }

    
    function testFuzzingDivisionZeroSecondNumber(uint256 _firstNumber) public {
        vm.startPrank(admin);
        uint256 firstNumber = _firstNumber;
        uint256 secondNumber = 0;

        vm.expectRevert();
        calculator.division(firstNumber, secondNumber);
        vm.stopPrank();
    }

    
    


}