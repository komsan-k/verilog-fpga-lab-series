# Lab 9: Counters and Clock Divider Design

## 1. Lab Objective

- To design and simulate synchronous binary counters using Verilog HDL.
- To implement a clock divider to generate slower clocks from a system clock.
- To verify functionality through simulation and waveform observation.

## 2. Background Theory

### 2.1 Synchronous Counter

A counter is a sequential circuit that goes through a predefined sequence of states. A synchronous counter updates its state on the rising (or falling) edge of a clock signal. Types of counters include:

- Up Counter
- Down Counter
- Up-Down Counter

### 2.2 Clock Divider

A clock divider reduces the frequency of the system clock by a programmable or fixed factor. It is implemented using counters that toggle output after a fixed number of clock cycles.

## 3. Verilog Implementation

### 3.1 4-bit Synchronous Up Counter

```verilog
module counter_4bit (
    input clk,
    input rst,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 4'b0000;
        else
            count <= count + 1;
    end
endmodule
```

### 3.2 Clock Divider (Divide by 2^N)

```verilog
module clock_divider #(parameter N = 25) (
    input clk_in,
    input rst,
    output reg clk_out
);
    reg [N-1:0] count;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else begin
            count <= count + 1;
            clk_out <= count[N-1];
        end
    end
endmodule
```

## 4. Testbenches

### 4.1 Testbench for 4-bit Counter

```verilog
module counter_tb;
    reg clk, rst;
    wire [3:0] count;

    counter_4bit uut (.clk(clk), .rst(rst), .count(count));

    initial begin
        clk = 0; rst = 1; #5;
        rst = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $monitor("Time = %0t | Count = %b", $time, count);
        #100 $finish;
    end
endmodule
```

### 4.2 Testbench for Clock Divider

```verilog
module clock_divider_tb;
    reg clk_in, rst;
    wire clk_out;

    clock_divider #(4) uut (.clk_in(clk_in), .rst(rst), .clk_out(clk_out));

    initial begin
        clk_in = 0; rst = 1; #5;
        rst = 0;
        forever #5 clk_in = ~clk_in;
    end

    initial begin
        $monitor("Time = %0t | clk_out = %b", $time, clk_out);
        #200 $finish;
    end
endmodule
```

## 5. Simulation and Results

### 5.1 4-bit Counter Simulation

| Cycle | Clock | Counter [3:0] |
|-------|-------|----------------|
| 0     | 0     | 0000           |
| 1     | 1     | 0001           |
| 2     | 0     | 0001           |
| 3     | 1     | 0010           |
| 4     | 0     | 0010           |
| 5     | 1     | 0011           |
| 6     | 0     | 0011           |
| 7     | 1     | 0100           |
| 8     | 0     | 0100           |
| 9     | 1     | 0101           |
| 10    | 0     | 0101           |
| 11    | 1     | 0110           |
| 12    | 0     | 0110           |
| 13    | 1     | 0111           |
| 14    | 0     | 0111           |
| 15    | 1     | 1000           |
| 16    | 0     | 1000           |
| 17    | 1     | 1001           |
| 18    | 0     | 1001           |
| 19    | 1     | 1010           |

### 5.2 Clock Divider Simulation

| Cycle | Clock | Divided Clock Output |
|-------|-------|------------------------|
| 0     | 0     | 0                      |
| 1     | 1     | 0                      |
| 2     | 0     | 0                      |
| 3     | 1     | 0                      |
| 4     | 0     | 1                      |
| 5     | 1     | 1                      |
| 6     | 0     | 1                      |
| 7     | 1     | 1                      |
| 8     | 0     | 0                      |
| 9     | 1     | 0                      |
| 10    | 0     | 0                      |
| 11    | 1     | 0                      |
| 12    | 0     | 1                      |
| 13    | 1     | 1                      |
| 14    | 0     | 1                      |
| 15    | 1     | 1                      |
| 16    | 0     | 0                      |
| 17    | 1     | 0                      |
| 18    | 0     | 0                      |
| 19    | 1     | 0                      |

## 6. Exercises

1. Modify the counter to create a down counter and an up-down counter.
2. Implement a counter with a terminal count that resets automatically.
3. Use the clock divider to control the blinking rate of an LED on an FPGA board.
4. Design a clock divider with selectable division factor using inputs.
5. Extend the counter to 8 bits and verify wrap-around behavior.

## 7. Conclusion

This lab demonstrated the design and simulation of a 4-bit counter and a clock divider using Verilog HDL. These components are essential in sequential logic design, digital timing control, and interface timing generation.

## 8. Instructor Notes

- Emphasize difference between asynchronous and synchronous resets.
- Discuss FPGA timing constraints for clock generation and division.
- Highlight overflow behavior and terminal count detection.
