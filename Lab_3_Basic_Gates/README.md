# Lab 3: Basic Logic Gates

## 1. Lab Objective

- To understand and implement basic logic gates (AND, OR, NOT, NAND, NOR, XOR, XNOR) using Verilog HDL.
- To write simple Verilog modules for individual logic gates.
- To verify the functionality through testbenches and waveform simulations.

## 2. Background Theory

### 2.1 Logic Gates Overview

Digital circuits operate on binary signals (0 and 1). Basic logic gates form the foundation of these circuits. The following table summarizes common logic gates along with their operations and corresponding Verilog operators:

| Gate  | Symbol | Operation     | Verilog Operator |
|-------|--------|---------------|------------------|
| AND  | ∧      | A * B         | `&`              |
| OR   | ∨      | A + B         | `|`              |
| NOT  | ¬      | ~A            | `~`              |
| NAND | ¬(A∧B) | ~(A & B)      | `~(A & B)`       |
| NOR  | ¬(A∨B) | ~(A | B)      | `~(A | B)`       |
| XOR  | ⊕      | A ⊕ B         | `^`              |
| XNOR | ≡      | ~(A ⊕ B)      | `~(A ^ B)`       |

### 2.2 Verilog Module Structure

```verilog
module <module_name> (input ..., output ...);
    // Declarations
    // Logic
endmodule
```

## 3. Lab Tasks

### 3.1 Task 1: Implement Individual Logic Gates

**(a) AND Gate**

```verilog
module and_gate(input A, input B, output Y);
    assign Y = A & B;
endmodule
```

**(b) OR Gate**

```verilog
module or_gate(input A, input B, output Y);
    assign Y = A | B;
endmodule
```

**(c) NOT Gate**

```verilog
module not_gate(input A, output Y);
    assign Y = ~A;
endmodule
```

### 3.2 Task 2: Testbench for AND Gate

```verilog
module and_gate_tb;
    reg A, B;
    wire Y;

    and_gate uut (.A(A), .B(B), .Y(Y));

    initial begin
        $display("A B | Y");
        $monitor("%b %b | %b", A, B, Y);

        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;

        $finish;
    end
endmodule
```

### 3.3 Task 3: Combined Module (Optional)

```verilog
module all_gates (
    input A, input B,
    output AND_out, OR_out, NAND_out,
    output NOR_out, XOR_out, XNOR_out
);
    assign AND_out  = A & B;
    assign OR_out   = A | B;
    assign NAND_out = ~(A & B);
    assign NOR_out  = ~(A | B);
    assign XOR_out  = A ^ B;
    assign XNOR_out = ~(A ^ B);
endmodule
```

## 4. Simulation and Result Analysis

### 4.1 Expected Truth Table

| A | B | AND | OR | NAND | NOR | XOR | XNOR |
|---|---|-----|----|------|-----|-----|------|
| 0 | 0 |  0  | 0  |  1   |  1  |  0  |  1   |
| 0 | 1 |  0  | 1  |  1   |  0  |  1  |  0   |
| 1 | 0 |  0  | 1  |  1   |  0  |  1  |  0   |
| 1 | 1 |  1  | 1  |  0   |  0  |  0  |  1   |

## 5. Questions and Exercises

1. Modify the testbench to include more delays and corner cases.
2. What is the functional difference between XOR and XNOR?
3. Describe a real-world application where NAND gates are preferred.
4. Write a 2-input multiplexer using only logic gates in Verilog.
5. Explain why the NOT gate is considered a unary operator.

## 6. Conclusion

This lab provided practical experience in writing Verilog HDL code for basic logic gates and using simulation tools to verify their behavior.

## 7. Instructor Notes

- Emphasize the difference between behavioral and structural coding styles.
- Ensure that students simulate and verify outputs with proper waveform timing.
- Encourage debugging by visual inspection and use of `$monitor`.
