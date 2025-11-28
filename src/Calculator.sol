// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Calculator {
  
    uint256 public result;
    address public admin;

    event Addition(uint256 _firstNumber, uint256 _secondNumber, uint256 _result);
    event Subtraction(uint256 _firstNumber, uint256 _secondNumber, uint256 _result);
    event Multiplication(uint256 _firstNumber, uint256 _secondNumber, uint256 _result);
    event Division(uint256 _firstNumber, uint256 _secondNumber, uint256 _result);

    modifier onlyAdmin(){
        require(msg.sender == admin, "Not authorized");
        _;
    }
    
    constructor(uint256 _firstResult, address _admin){
        result = _firstResult;
        admin = _admin;
    }

    function addition(uint256 _firstNumber, uint256 _secondNumber) external returns(uint256 _result){
        _result = _firstNumber + _secondNumber;
        result = _result;
        
        emit Addition(_firstNumber, _secondNumber, _result);
    }

    function subtraction(uint256 _firstNumber, uint256 _secondNumber) external returns(uint256 _result){
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
        _result = _firstNumber / _secondNumber;
        result = _result;
        emit Division(_firstNumber, _secondNumber, _result);
    }

}