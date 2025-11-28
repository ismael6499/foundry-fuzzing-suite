// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @title Basic Calculator
/// @author Agustin Acosta
/// @notice A simple calculator with administrative privileges for division
contract Calculator {
  
    // 1. Gas Optimization: Custom Errors are cheaper than string requires
    error NotAuthorized(address caller);
    error InvalidAddress();
    error DivisionByZero();

    uint256 public result;
    
    // 2. Gas Optimization: 'immutable' saves gas as the value is stored in bytecode
    address public immutable admin;

    // 3. UX: 'indexed' parameters allow efficient filtering of events
    event Addition(uint256 indexed _firstNumber, uint256 indexed _secondNumber, uint256 _result);
    event Subtraction(uint256 indexed _firstNumber, uint256 indexed _secondNumber, uint256 _result);
    event Multiplication(uint256 indexed _firstNumber, uint256 indexed _secondNumber, uint256 _result);
    event Division(uint256 indexed _firstNumber, uint256 indexed _secondNumber, uint256 _result);

    modifier onlyAdmin(){
        if (msg.sender != admin) {
            revert NotAuthorized(msg.sender);
        }
        _;
    }
    
    constructor(uint256 _firstResult, address _admin){
        if (_admin == address(0)) revert InvalidAddress();
        
        result = _firstResult;
        admin = _admin;
    }

    function addition(uint256 _firstNumber, uint256 _secondNumber) external returns(uint256 _result){
        _result = _firstNumber + _secondNumber;
        result = _result;
        
        emit Addition(_firstNumber, _secondNumber, _result);
    }

    function subtraction(uint256 _firstNumber, uint256 _secondNumber) external returns(uint256 _result){
        // Note: This will revert with Panic(0x11) on underflow if _firstNumber < _secondNumber
        _result = _firstNumber - _secondNumber;
        result = _result;
        emit Subtraction(_firstNumber, _secondNumber, _result);
    }

    function multiplication(uint256 _firstNumber, uint256 _secondNumber) external returns(uint256 _result){
        _result = _firstNumber * _secondNumber;
        result = _result;
        emit Multiplication(_firstNumber, _secondNumber, _result);
    }
    
    function division(uint256 _firstNumber, uint256 _secondNumber) external onlyAdmin returns(uint256 _result){
        if (_secondNumber == 0) revert DivisionByZero();
        
        _result = _firstNumber / _secondNumber;
        result = _result;
        emit Division(_firstNumber, _secondNumber, _result);
    }
}