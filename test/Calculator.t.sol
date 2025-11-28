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

    // --- Unit Testing ---

    function testCheckFirstResult() public view { 
        assertEq(calculator.result(), firstResult);
    } 

    function testAddition() public {
        uint256 firstNumber = 10;
        uint256 secondNumber = 20;
        uint256 expected = firstNumber + secondNumber;

        // When testing external calls that modify state, checking the stored result is crucial
        calculator.addition(firstNumber, secondNumber);
        assertEq(calculator.result(), expected);
    }

    function testSubtraction() public {
        uint256 firstNumber = 30;
        uint256 secondNumber = 20;
        uint256 expected = firstNumber - secondNumber;

        calculator.subtraction(firstNumber, secondNumber);
        assertEq(calculator.result(), expected);
    }

    function testMultiplication() public {
        uint256 firstNumber = 30;
        uint256 secondNumber = 20;
        uint256 expected = firstNumber * secondNumber;

        calculator.multiplication(firstNumber, secondNumber);
        assertEq(calculator.result(), expected);
    }

    function testCannotMultiplyTwoLargeNumbersWithLargerFirstNumber() public {
        uint256 firstNumber = type(uint256).max;
        uint256 secondNumber = 2;
        
        // Expect Arithmetic Over/Underflow (Panic 0x11)
        vm.expectRevert(); 
        calculator.multiplication(firstNumber, secondNumber);
    }

    function testDivision() public {
        vm.startPrank(admin);
        uint256 firstNumber = 30;
        uint256 secondNumber = 2;
        uint256 expected = firstNumber / secondNumber;

        calculator.division(firstNumber, secondNumber);
        assertEq(calculator.result(), expected);
        vm.stopPrank();
    }
    
    function testCannotDivideTwoNumbersWithAdminNotAuthorized() public {
        uint256 firstNumber = 30;
        uint256 secondNumber = 2;
        
        // Best Practice: Expect the specific Custom Error + Parameters
        // Validates that it failed because of auth, not some other reason
        vm.expectRevert(
            abi.encodeWithSelector(Calculator.NotAuthorized.selector, address(this))
        );
        calculator.division(firstNumber, secondNumber);
    }


    function testDivideByZeroExpectsRevert() public {
        vm.startPrank(admin);
        uint256 firstNumber = 30;
        uint256 secondNumber = 0;
        
        // Expect our specific Custom Error
        vm.expectRevert(Calculator.DivisionByZero.selector);
        calculator.division(firstNumber, secondNumber);
        vm.stopPrank();
    }


    // --- Fuzzing Testing ---

    function testFuzzingDivision(uint256 _firstNumber, uint256 _secondNumber) public {
        vm.startPrank(admin);
        // bound() is a Foundry helper to constrain fuzz inputs to a range
        // Here we ensure secondNumber is never 0 to avoid division by zero
        uint256 secondNumber = bound(_secondNumber, 1, type(uint256).max);
        uint256 firstNumber = _firstNumber;

        uint256 expected = firstNumber / secondNumber;

        calculator.division(firstNumber, secondNumber);
        assertEq(calculator.result(), expected);
        vm.stopPrank();
    }
}