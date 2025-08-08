
# Lab 6: Encoder and Decoder Design

## 1. Lab Objective
- To design and simulate binary encoders and decoders using behavioral and hierarchical modeling styles in Verilog HDL.
- To compare modular design techniques and understand abstraction in combinational logic design.

## 2. Background Theory

### 2.1 Binary Encoder
A binary encoder converts one active input line into a binary code on the output. A 4-to-2 encoder maps four input lines to two output bits.

**Priority Behavior:**
- If multiple inputs are active, the encoder outputs the code of the highest-priority input (e.g., I[3] has highest priority).

### 2.2 Binary Decoder
A decoder performs the reverse operation: it takes a binary input code and activates one output line.

**2-to-4 Decoder:**
- For every binary input combination, only one output line is activated.
- Useful in memory address decoding, instruction decoding, etc.

## 3. Verilog Implementation

### 3.1 Behavioral 4-to-2 Encoder
```verilog
module encoder_4to2_behavioral (
    input [3:0] I,
    output reg [1:0] Y
);
    always @(*) begin
        Y = 2'b00;
        if (I[3]) Y = 2'b11;
        else if (I[2]) Y = 2'b10;
        else if (I[1]) Y = 2'b01;
        else if (I[0]) Y = 2'b00;
    end
endmodule
```

### 3.2 Behavioral 2-to-4 Decoder
```verilog
module decoder_2to4_behavioral (
    input [1:0] A,
    output reg [3:0] Y
);
    always @(*) begin
        Y = 4'b0000;
        Y[A] = 1'b1;
    end
endmodule
```

### 3.3 Hierarchical 2-to-4 Decoder

**Bit Cell Module:**
```verilog
module decoder_bit (
    input enable,
    output Y
);
    assign Y = enable;
endmodule
```

**2-to-4 Decoder Using Bit Cells:**
```verilog
module decoder_2to4_hierarchical (
    input [1:0] A,
    output [3:0] Y
);
    wire [3:0] enable;
    assign enable = 4'b0001 << A;

    decoder_bit d0 (enable[0], Y[0]);
    decoder_bit d1 (enable[1], Y[1]);
    decoder_bit d2 (enable[2], Y[2]);
    decoder_bit d3 (enable[3], Y[3]);
endmodule
```

### 3.4 Hierarchical 4-to-2 Encoder
```verilog
module encoder_4to2_hierarchical (
    input [3:0] I,
    output reg [1:0] Y
);
    always @(*) begin
        casez (I)
            4'b???1: Y = 2'b00;
            4'b??10: Y = 2'b01;
            4'b?100: Y = 2'b10;
            4'b1000: Y = 2'b11;
            default: Y = 2'b00;
        endcase
    end
endmodule
```

## 4. Testbenches

### 4.1 Encoder Testbench (Generic)
```verilog
module encoder_tb;
    reg [3:0] I;
    wire [1:0] Y;

    encoder_4to2_behavioral uut (.I(I), .Y(Y)); // or encoder_4to2_hierarchical

    initial begin
        $display("Input  | Output");
        $monitor("%b  |  %b", I, Y);
        I = 4'b0001; #10;
        I = 4'b0010; #10;
        I = 4'b0100; #10;
        I = 4'b1000; #10;
        $finish;
    end
endmodule
```

### 4.2 Decoder Testbench (Generic)
```verilog
module decoder_tb;
    reg [1:0] A;
    wire [3:0] Y;

    decoder_2to4_behavioral uut (.A(A), .Y(Y)); // or decoder_2to4_hierarchical

    initial begin
        $display("Input | Output");
        $monitor("%b   | %b", A, Y);
        A = 2'b00; #10;
        A = 2'b01; #10;
        A = 2'b10; #10;
        A = 2'b11; #10;
        $finish;
    end
endmodule
```

## 5. Simulation and Results

### 5.1 Encoder Truth Table
| Input (I[3:0]) | Output (Y[1:0]) |
|----------------|------------------|
| 0001           | 00               |
| 0010           | 01               |
| 0100           | 10               |
| 1000           | 11               |

### 5.2 Decoder Truth Table
| Input (A[1:0]) | Output (Y[3:0]) |
|----------------|------------------|
| 00             | 0001             |
| 01             | 0010             |
| 10             | 0100             |
| 11             | 1000             |

## 6. Exercises
1. Add an enable input to both encoder and decoder modules.
2. Modify the encoder to output a valid flag when at least one input is active.
3. Create a hierarchical 3-to-8 decoder using 2-to-4 decoders.
4. Compare structural, behavioral, and hierarchical models in terms of readability and reusability.
5. Use conditional operators (?:) to implement a 4-to-2 encoder.

## 7. Conclusion
This lab explored both behavioral and hierarchical modeling techniques for encoder and decoder circuits using Verilog HDL. Through modular design and abstraction, students gained insight into structured circuit development and simulation practices.

## 8. Instructor Notes
- Discuss where behavioral models are more suitable than hierarchical (e.g., test environments).
- Emphasize code reuse and top-down design in hierarchical modeling.
- Encourage waveform analysis to confirm signal timing and correctness.
