
# Lab 5: MUX and DMUX Designs

## 1. Lab Objective

- To understand and implement multiplexers and demultiplexers using the `case` statement in Verilog HDL.
- To verify the logical correctness through simulation and waveform analysis.

## 2. Background Theory

### 2.1 Multiplexer (MUX)

A multiplexer selects one of several inputs and forwards it to a single output, controlled by select lines. For a 4-to-1 MUX, the output is defined as:

```
Y = I[S]
```

Where `I` is a 4-bit input and `S` is a 2-bit selector.

### 2.2 Demultiplexer (DEMUX)

A demultiplexer routes a single input to one of several outputs depending on select lines. For a 1-to-4 DEMUX:

```
Y[S] = D
```

## 3. Verilog Implementation using `case`

### 3.1 4-to-1 Multiplexer

```verilog
module mux_4to1 (
    input [3:0] I,
    input [1:0] S,
    output reg Y
);
    always @(*) begin
        case (S)
            2'b00: Y = I[0];
            2'b01: Y = I[1];
            2'b10: Y = I[2];
            2'b11: Y = I[3];
            default: Y = 1'b0;
        endcase
    end
endmodule
```

### 3.2 1-to-4 Demultiplexer

```verilog
module demux_1to4 (
    input D,
    input [1:0] S,
    output reg [3:0] Y
);
    always @(*) begin
        Y = 4'b0000;
        case (S)
            2'b00: Y = 4'b0001 & {4{D}};
            2'b01: Y = 4'b0010 & {4{D}};
            2'b10: Y = 4'b0100 & {4{D}};
            2'b11: Y = 4'b1000 & {4{D}};
        endcase
    end
endmodule
```

## 4. Testbenches

### 4.1 Multiplexer Testbench

```verilog
module mux_tb;
    reg [3:0] I;
    reg [1:0] S;
    wire Y;

    mux_4to1 uut (.I(I), .S(S), .Y(Y));

    initial begin
        $display(" I     S | Y");
        I = 4'b1010;

        S = 2'b00; #10;
        S = 2'b01; #10;
        S = 2'b10; #10;
        S = 2'b11; #10;

        $finish;
    end
endmodule
```

### 4.2 Demultiplexer Testbench

```verilog
module demux_tb;
    reg D;
    reg [1:0] S;
    wire [3:0] Y;

    demux_1to4 uut (.D(D), .S(S), .Y(Y));

    initial begin
        $display("D  S | Y");
        D = 1;

        S = 2'b00; #10;
        S = 2'b01; #10;
        S = 2'b10; #10;
        S = 2'b11; #10;

        $finish;
    end
endmodule
```

## 5. Simulation and Result Analysis

### 5.1 Truth Table: MUX

| I[3:0] | S  | Y |
|--------|----|---|
| 1010   | 00 | 0 |
| 1010   | 01 | 1 |
| 1010   | 10 | 0 |
| 1010   | 11 | 1 |

### 5.2 Truth Table: DEMUX

| D | S  | Y[3:0] |
|---|----|--------|
| 1 | 00 | 0001   |
| 1 | 01 | 0010   |
| 1 | 10 | 0100   |
| 1 | 11 | 1000   |

## 6. Exercises

1. Convert the MUX to an 8-to-1 design using nested case statements.
2. Extend the DEMUX to 1-to-8 with an enable input.
3. Modify the MUX to handle a default input when select is out of range.
4. Discuss how `casez` could simplify DEMUX code.
5. Simulate with different I values and validate all paths.

## 7. Conclusion

This lab demonstrated the use of `case` statements in Verilog HDL to implement multiplexers and demultiplexers. The structured approach improves readability and debugging, especially for larger systems.

## 8. Instructor Notes

- Emphasize correct use of blocking vs non-blocking assignments in always blocks.
- Review synthesis implications of combinational `case` blocks.
- Discuss practical examples of MUX/DEMUX in bus architectures and control units.
