# ⚒️ Foundry Fuzzing Suite: High-Assurance Testing

![Solidity](https://img.shields.io/badge/Solidity-0.8.30-363636?style=flat-square&logo=solidity)
![Framework](https://img.shields.io/badge/Framework-Foundry-bf4904?style=flat-square&logo=rust)
![Testing](https://img.shields.io/badge/Methodology-Property_Based_Fuzzing-blue?style=flat-square)

A research repository establishing a standardized **Quality Assurance (QA) pipeline** for Solidity smart contracts.

This project moves beyond traditional unit testing by implementing **Property-Based Testing (Fuzzing)** and advanced cheatcodes using **Foundry**. The goal is to mathematically validate contract invariants across thousands of pseudo-random inputs, ensuring edge-case resilience and precise error handling before mainnet deployment.

## 🏗 Testing Architecture & Methodologies

### 1. Property-Based Testing (Fuzzing)
- **Stochastic Validation:**
  - Instead of static assertions (e.g., `assert(add(2,2) == 4)`), the suite utilizes Foundry's fuzzing engine to test logic against a vast spectrum of `uint256` inputs.
  - **Input Bounding:** Implemented `bound()` strategies to programmatically constrain fuzz inputs (e.g., `bound(x, 1, type(uint256).max)`), effectively isolating business logic edge cases like Division by Zero while maintaining broad coverage.

### 2. Advanced State Manipulation (Cheatcodes)
- **Identity Impersonation:**
  - Utilizes `vm.startPrank` and `vm.stopPrank` to simulate granular Access Control scenarios (`onlyAdmin`). This allows for testing privileged functions without the security risks of managing private keys in test environments.
- **Selector-Based Error Assertions:**
  - Strict validation of revert reasons using `vm.expectRevert(CustomError.selector)`. This ensures that transactions fail *exactly* for the intended reasons (e.g., Authorization vs. Logic error), preventing false positives in the test suite.

### 3. Gas Optimization Verification
- **Bytecode Efficiency:**
  - The subject contract demonstrates the usage of `immutable` storage variables and **Custom Errors** (`error NotAuthorized()`) to minimize opcode execution costs. The test suite implicitly validates these optimizations by ensuring correct selector emission during reverts.

## 🛠 Tech Stack

* **Core:** Solidity `0.8.30`
* **Tooling:** Foundry (Forge, Anvil, Cast)
* **Libraries:** `forge-std` (Standard Library)
* **Focus:** Invariant Testing, Fuzzing, Cheatcodes

## 📝 Code Snippet: Fuzzing Pattern

An example of constraining random inputs to validate arithmetic invariants:

```solidity
// Fuzz test with bounded inputs
function testFuzzingDivision(uint256 _firstNumber, uint256 _secondNumber) public {
    vm.startPrank(admin);
    
    // Constrain input to avoid EVM Panic(0x12)
    uint256 secondNumber = bound(_secondNumber, 1, type(uint256).max);
    
    uint256 expected = _firstNumber / secondNumber;
    
    calculator.division(_firstNumber, secondNumber);
    assertEq(calculator.result(), expected);
}
