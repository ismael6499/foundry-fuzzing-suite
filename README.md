# ⚒️ Advanced Smart Contract Testing with Foundry

A research repository focused on implementing advanced testing methodologies—including Fuzzing and Cheatcodes—using **Foundry**, the Rust-based toolkit for Ethereum application development.

## 🚀 Engineering Context

As a **Java Software Engineer**, relying on JavaScript frameworks (like Hardhat) for testing Solidity creates a disconnect in type safety and environment consistency.

In this project, I migrated the development workflow to **Foundry** to bridge this gap. By writing tests directly in Solidity (`.t.sol`), I achieved a developer experience comparable to **JUnit/Mockito**, enabling native type checking, faster execution traces, and a unified language for both logic and validation.

## 💡 Project Overview

This project implements a `Calculator` smart contract as a baseline to explore Foundry's capabilities. The focus is not on arithmetic logic, but on establishing a robust Quality Assurance (QA) pipeline using **Property-Based Testing**.

### 🔍 Key Technical Features:

* **Fuzz Testing (Property-Based Testing):**
    * Instead of static unit tests (e.g., `10 / 2 = 5`), I implemented **Fuzzing** to test invariants across thousands of generated inputs.
    * **Input Bounding:** Leveraged `bound()` to programmatically handle edge cases (such as preventing division by zero during random input generation) while ensuring the logic holds for the rest of the `uint256` spectrum.

* **Advanced Cheatcodes & State Manipulation:**
    * **Identity Impersonation (`prank`):** Used `vm.startPrank` and `vm.stopPrank` to simulate administrative actions and validate Access Control modifiers (`onlyAdmin`) without managing private keys.
    * **Error Selector Assertion:** Implemented `vm.expectRevert` with specific custom error selectors (`Calculator.DivisionByZero.selector`) to strictly validate *why* a transaction fails, ensuring precise error handling.

* **Gas Optimization:**
    * Implementation of `immutable` variables for admin storage to reduce runtime gas costs.
    * Usage of Custom Errors (`error NotAuthorized`) over string-based `require` statements to optimize deployment and execution size.

## 🛠️ Stack & Tools

* **Framework:** Foundry (Forge, Anvil).
    * *Selected for its Fuzzing engine and Solidity-native scripting.*
* **Language:** Solidity 0.8.30.
* **Testing:** `forge-std`.
* **Concepts:** Invariant Testing, Cheatcodes, CI/CD pipelines.

---

*This project establishes a standardized testing framework for secure smart contract development.*