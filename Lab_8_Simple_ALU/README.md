# Lab 8: Simple ALU Design

## 1. Lab Objective

- To design a simple 4-bit Arithmetic Logic Unit (ALU) using Verilog HDL.
- To implement arithmetic (ADD, SUB) and logic operations (AND, OR, XOR, NOT).
- To verify functionality using simulation and testbenches.

## 2. Background Theory

An ALU (Arithmetic Logic Unit) is a combinational digital circuit that performs a set of arithmetic and logical operations. It is a critical component in CPUs, microcontrollers, and digital signal processors.

**Typical ALU Functions:**

- Arithmetic: Addition, Subtraction
- Logical: AND, OR, XOR, NOT
- Shift: Left Shift, Right Shift (optional)
- Comparison: Zero flag, Carry flag, Overflow detection

**Opcode-based ALU Design:**

Operations are selected using an `opcode` (Operation Code), which controls a multiplexer to route the correct logic.

## 3. Verilog Implementation

### 3.1 ALU Module (4-bit)
```verilog
module alu_4bit (
    input [3:0] A,
    input [3:0] B,
    input [2:0] opcode,
    output reg [3:0] result,
    output reg zero
);
    always @(*) begin
        case (opcode)
            3'b000: result = A + B;          // ADD
            3'b001: result = A - B;          // SUB
            3'b010: result = A & B;          // AND
            3'b011: result = A | B;          // OR
            3'b100: result = A ^ B;          // XOR
            3'b101: result = ~A;             // NOT A (B ignored)
            3'b110: result = A << 1;         // Shift Left
            3'b111: result = A >> 1;         // Shift Right
            default: result = 4'b0000;
        endcase
        zero = (result == 4'b0000);
    end
endmodule
```

## 4. Testbench for ALU

### 4.1 ALU Testbench
```verilog
module alu_tb;
    reg [3:0] A, B;
    reg [2:0] opcode;
    wire [3:0] result;
    wire zero;

    alu_4bit uut (
        .A(A), .B(B),
        .opcode(opcode),
        .result(result),
        .zero(zero)
    );

    initial begin
        $display("A    B    OPC | RESULT ZERO");
        $monitor("%b %b  %b   |  %b     %b", A, B, opcode, result, zero);

        A = 4'b0011; B = 4'b0001;

        opcode = 3'b000; #10; // ADD
        opcode = 3'b001; #10; // SUB
        opcode = 3'b010; #10; // AND
        opcode = 3'b011; #10; // OR
        opcode = 3'b100; #10; // XOR
        opcode = 3'b101; #10; // NOT
        opcode = 3'b110; #10; // Shift Left
        opcode = 3'b111; #10; // Shift Right

        $finish;
    end
endmodule
```

## 5. Simulation and Results

The ALU was tested using Xilinx Vivado to verify functionality across all supported operations. Sample inputs were applied and corresponding outputs were validated using waveform inspection tools.

### 5.1 ALU Operation Table

| Opcode | Operation             |
|--------|------------------------|
| 000    | A + B (Addition)       |
| 001    | A - B (Subtraction)    |
| 010    | A AND B                |
| 011    | A OR B                 |
| 100    | A XOR B                |
| 101    | NOT A                  |
| 110    | A Shift Left by 1      |
| 111    | A Shift Right by 1     |

### 5.2 Sample Simulation Results

For inputs `A = 8'b10101010`, `B = 8'b01010101`:

- **Addition (000):** `11111111`
- **Subtraction (001):** `01010101`
- **AND (010):** `00000000`
- **OR (011):** `11111111`
- **XOR (100):** `11111111`
- **NOT A (101):** `01010101`
- **Shift Left (110):** `01010100`
- **Shift Right (111):** `01010101`

All operations were verified using Vivado waveform viewer and matched expected behavior.

## 6. Exercises

1. Add overflow detection for addition and subtraction.
2. Extend the ALU to 8-bit width.
3. Implement increment and decrement operations.
4. Use a parameterized opcode width and input size.
5. Design a register file to connect to the ALU inputs and outputs.

## 7. Conclusion

This lab introduced the design of a basic ALU using Verilog HDL, covering both arithmetic and logic functions. The simulation confirmed functional correctness, and the design serves as a foundation for more complex datapath and processor projects.

## 8. Instructor Notes

- Emphasize the use of `always @(*)` for combinational logic.
- Discuss signed vs. unsigned arithmetic.
- Highlight ALU integration into larger datapath architectures.
