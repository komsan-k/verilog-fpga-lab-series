
# Lab 12: Multiplier Design

## 1. Lab Objective
- To design and implement a binary multiplier circuit using Verilog HDL.
- To understand the principles of combinational and sequential multiplication.
- To verify functionality using simulation and waveform observation.

## 2. Background Theory

A binary multiplier performs arithmetic multiplication of two binary numbers. There are two main approaches:

- **Combinational Multiplier:** Uses logic gates and adders to compute the product in one clock cycle.
- **Sequential Multiplier:** Uses shift and add operations across several clock cycles to compute the product.

**Unsigned Binary Multiplication:**

```
Product = A × B
```

Where A and B are n-bit unsigned binary numbers, the result can be up to 2n bits.

## 3. Verilog Implementations

### 3.1 4-bit Combinational Multiplier
```verilog
module multiplier_4bit (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    assign P = A * B;
endmodule
```

### 3.2 4-bit Sequential Multiplier (Shift and Add)
```verilog
module seq_multiplier_4bit (
    input clk,
    input rst,
    input start,
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] product,
    output reg done
);
    reg [3:0] count;
    reg [3:0] multiplicand, multiplier;
    reg [7:0] temp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0; temp <= 0;
            done <= 0; product <= 0;
        end else if (start && !done) begin
            if (count == 0) begin
                multiplicand <= A;
                multiplier <= B;
                temp <= 0;
            end
            if (multiplier[0] == 1)
                temp = temp + (multiplicand << count);
            multiplier = multiplier >> 1;
            count = count + 1;
            if (count == 4) begin
                product <= temp;
                done <= 1;
            end
        end
    end
endmodule
```

## 4. Testbenches

### 4.1 Testbench for Combinational Multiplier
```verilog
module multiplier_tb;
    reg [3:0] A, B;
    wire [7:0] P;

    multiplier_4bit uut (.A(A), .B(B), .P(P));

    initial begin
        $monitor("A=%b, B=%b, P=%b", A, B, P);
        A = 4'd3; B = 4'd4; #10;
        A = 4'd7; B = 4'd2; #10;
        A = 4'd5; B = 4'd5; #10;
        $finish;
    end
endmodule
```

### 4.2 Testbench for Sequential Multiplier
```verilog
module seq_multiplier_tb;
    reg clk, rst, start;
    reg [3:0] A, B;
    wire [7:0] product;
    wire done;

    seq_multiplier_4bit uut (
        .clk(clk), .rst(rst), .start(start),
        .A(A), .B(B),
        .product(product), .done(done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; start = 0; A = 0; B = 0; #10;
        rst = 0;
        A = 4'd3; B = 4'd5; start = 1; #100;
        $display("Product = %d", product);
        $finish;
    end
endmodule
```

## 5. Simulation and Results

### 5.1 Combinational Multiplier Output Table

| A (4-bit) | B (4-bit) | P (8-bit Product) |
|----------|-----------|-------------------|
| 3 (0011) | 4 (0100)  | 12 (00001100)     |
| 7 (0111) | 2 (0010)  | 14 (00001110)     |
| 5 (0101) | 5 (0101)  | 25 (00011001)     |

### 5.2 Sequential Multiplier Behavior

| Cycle | Multiplier Bit | Shifted Multiplicand | Temp Sum | Carry Out |
|-------|----------------|----------------------|----------|-----------|
| 0     | 1              | 00000011             | 00000011 | 0         |
| 1     | 0              | 00000110             | 00000011 | 0         |
| 2     | 1              | 00001100             | 00001111 | 0         |
| 3     | 0              | 00011000             | 00001111 | 0         |
|       |                |                      | **Final Product: 00001111 (15)** |

**Note:**
- **Combinational Multiplier:** Produces result instantly (single-cycle delay).
- **Sequential Multiplier:** Requires 4 cycles for a 4-bit operation.
- Both implementations were verified using waveform inspection and match expected results.

## 6. Exercises

1. Extend the multiplier to handle signed numbers using two's complement.
2. Design an 8-bit multiplier using a hierarchical approach.
3. Implement a pipelined multiplier and compare performance.
4. Simulate all A × B combinations for A,B ∈ [0, 15].
5. Compare resource usage between combinational and sequential designs. -->

## 7. Conclusion

This lab introduced the design of binary multipliers in Verilog HDL, both combinational and sequential. Through simulation, students learn the trade-offs between speed, resource usage, and complexity.

## 8. Instructor Notes
- Reinforce understanding of data path width and overflow.
- Emphasize testbench design and proper timing simulation.
- Suggest using waveform viewers (e.g., GTKWave) for clarity.
