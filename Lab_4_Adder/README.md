# Lab 4: Adder Design

## 1. Lab Objective

- To understand and implement the design of Half Adder and Full Adder circuits using Verilog HDL.
- To design a 4-bit binary adder using Full Adders.
- To verify all designs through simulation and waveform analysis.

## 2. Background Theory

### 2.1 Half Adder

A Half Adder adds two single-bit binary numbers (A and B). It produces:

- **Sum** = A XOR B
- **Carry** = A AND B

### 2.2 Full Adder

A Full Adder adds three 1-bit binary numbers: A, B, and Carry-in (Cin). It outputs:

- **Sum** = A ⊕ B ⊕ Cin
- **Carry-out** = (A & B) | (B & Cin) | (A & Cin)

### 2.3 4-bit Ripple Carry Adder

A 4-bit adder is formed by connecting four Full Adders in series. Each carry-out from the previous stage becomes the carry-in of the next.

## 3. Lab Tasks

### 3.1 Task 1: Verilog Code for Half Adder

```verilog
module half_adder(input A, input B, output Sum, output Carry);
    assign Sum = A ^ B;
    assign Carry = A & B;
endmodule
```

### 3.2 Task 2: Verilog Code for Full Adder

```verilog
module full_adder(input A, input B, input Cin, output Sum, output Cout);
    assign Sum  = A ^ B ^ Cin;
    assign Cout = (A & B) | (B & Cin) | (A & Cin);
endmodule
```

### 3.3 Task 3: 4-bit Ripple Carry Adder

```verilog
module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire c1, c2, c3;

    full_adder FA0(A[0], B[0], Cin,     Sum[0], c1);
    full_adder FA1(A[1], B[1], c1,      Sum[1], c2);
    full_adder FA2(A[2], B[2], c2,      Sum[2], c3);
    full_adder FA3(A[3], B[3], c3,      Sum[3], Cout);
endmodule
```

## 4. Testbenches

### 4.1 Half Adder Testbench

```verilog
module half_adder_tb;
    reg A, B;
    wire Sum, Carry;

    half_adder uut(.A(A), .B(B), .Sum(Sum), .Carry(Carry));

    initial begin
        $display("A B | Sum Carry");
        $monitor("%b %b |  %b     %b", A, B, Sum, Carry);

        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;

        $finish;
    end
endmodule
```

### 4.2 Full Adder Testbench

```verilog
module full_adder_tb;
    reg A, B, Cin;
    wire Sum, Cout;

    full_adder uut(.A(A), .B(B), .Cin(Cin), .Sum(Sum), .Cout(Cout));

    initial begin
        $display("A B Cin | Sum Cout");
        $monitor("%b %b  %b  |  %b   %b", A, B, Cin, Sum, Cout);

        A = 0; B = 0; Cin = 0; #10;
        A = 0; B = 1; Cin = 0; #10;
        A = 1; B = 0; Cin = 0; #10;
        A = 1; B = 1; Cin = 0; #10;
        A = 0; B = 0; Cin = 1; #10;
        A = 1; B = 1; Cin = 1; #10;

        $finish;
    end
endmodule
```

### 4.3 4-bit Adder Testbench

```verilog
module four_bit_adder_tb;
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] Sum;
    wire Cout;

    four_bit_adder uut(.A(A), .B(B), .Cin(Cin), .Sum(Sum), .Cout(Cout));

    initial begin
        $display("   A    B  Cin |  Sum Cout");
        $monitor("%b %b   %b   |  %b   %b", A, B, Cin, Sum, Cout);

        A = 4'b0001; B = 4'b0010; Cin = 0; #10;
        A = 4'b1111; B = 4'b0001; Cin = 0; #10;
        A = 4'b1010; B = 4'b0101; Cin = 1; #10;

        $finish;
    end
endmodule
```

## 5. Simulation Results

### 5.1 Expected Half Adder Truth Table

| A | B | Sum | Carry |
|---|---|-----|-------|
| 0 | 0 |  0  |   0   |
| 0 | 1 |  1  |   0   |
| 1 | 0 |  1  |   0   |
| 1 | 1 |  0  |   1   |

### 5.2 Full Adder Truth Table

| A | B | Cin | Sum | Cout |
|---|---|-----|-----|------|
| 0 | 0 |  0  |  0  |  0   |
| 0 | 0 |  1  |  1  |  0   |
| 0 | 1 |  0  |  1  |  0   |
| 0 | 1 |  1  |  0  |  1   |
| 1 | 0 |  0  |  1  |  0   |
| 1 | 0 |  1  |  0  |  1   |
| 1 | 1 |  0  |  0  |  1   |
| 1 | 1 |  1  |  1  |  1   |

## 6. Exercises

1. Modify the full adder to display overflow condition in 4-bit addition.
2. Implement a 4-bit subtractor using full adders and 2's complement logic.
3. Extend the design to an 8-bit adder.
4. Write behavioral Verilog code for the full adder and compare with structural style.
5. Analyze propagation delay in a ripple carry adder.

## 7. Conclusion

This lab provided practical experience in designing and simulating Half Adders, Full Adders, and multi-bit binary adders. These are essential components for building Arithmetic Logic Units (ALUs) and understanding fundamental arithmetic operations in digital systems.

## 8. Instructor Notes

- Emphasize the design hierarchy (e.g., 4-bit adder using full adders).
- Discuss testbench writing and timing simulation.
- Encourage students to debug using waveform outputs.
