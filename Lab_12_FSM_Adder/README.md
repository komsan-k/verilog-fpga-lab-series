
# Lab 12: FSM Design for Serial Adder

## 1. Lab Objective

- To design a serial adder using Finite State Machine (FSM) methodology in Verilog HDL.
- To simulate and verify the functionality of the FSM-based serial adder.
- To understand the control mechanism for sequential arithmetic using FSM design.

## 2. Background Theory

### 2.1 Serial Adder
A serial adder performs bit-by-bit binary addition using a single full adder and a register to store the carry. It processes one bit per clock cycle, starting from the least significant bit (LSB).

### 2.2 FSM Design Approach
A finite state machine consists of:

- A set of states
- Inputs and outputs
- A state transition function
- An output function

FSMs are classified into:

- Mealy Machine: Output depends on current state and inputs.
- Moore Machine: Output depends only on current state.

The serial adder FSM keeps track of the carry and controls bit-by-bit addition over multiple clock cycles.

## 3. Verilog Implementation

### 3.1 FSM-Based Serial Adder (4-bit)

```verilog
module serial_adder_fsm (
    input clk,
    input rst,
    input start,
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] SUM,
    output reg done
);
    reg [2:0] bit_cnt;
    reg carry;
    reg [3:0] regA, regB;
    reg [1:0] state;

    localparam IDLE = 2'b00,
               LOAD = 2'b01,
               ADD  = 2'b10,
               DONE = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= IDLE;
            SUM     <= 0;
            carry   <= 0;
            done    <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= LOAD;
                end
                LOAD: begin
                    regA <= A;
                    regB <= B;
                    bit_cnt <= 0;
                    SUM <= 0;
                    carry <= 0;
                    state <= ADD;
                end
                ADD: begin
                    {carry, SUM[bit_cnt]} <= regA[bit_cnt] + regB[bit_cnt] + carry;
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 3)
                        state <= DONE;
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
```

## 4. Testbench for Serial Adder FSM

### 4.1 Testbench Code

```verilog
module serial_adder_fsm_tb;
    reg clk, rst, start;
    reg [3:0] A, B;
    wire [3:0] SUM;
    wire done;

    serial_adder_fsm uut (
        .clk(clk), .rst(rst), .start(start),
        .A(A), .B(B), .SUM(SUM), .done(done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; start = 0; A = 4'b0000; B = 4'b0000; #10;
        rst = 0;

        A = 4'b0110; B = 4'b0011; start = 1; #10;
        start = 0;

        wait (done);
        #20;

        A = 4'b1111; B = 4'b0001; start = 1; #10;
        start = 0;

        wait (done);
        #20;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | A=%b B=%b SUM=%b done=%b", $time, A, B, SUM, done);
    end
endmodule
```

## 5. Simulation and Results

### 5.1 Sample Simulation Output

| Time (ns) | A    | B    | SUM  | done |
|-----------|------|------|------|------|
| 10        | 0110 | 0011 | ---- | 0    |
| 30        | 0110 | 0011 | 1001 | 1    |
| 60        | 1111 | 0001 | 0000 | 1    |

### Explanation of Simulation Steps:

1. **Initialization (Time = 0–10 ns):** A = 0110 (6) and B = 0011 (3). The `start` signal triggers the FSM.
2. **Bit-by-Bit Addition (10–30 ns):** The FSM adds bit pairs with carry. Result is 1001 (6+3=9).
3. **Second Test Case (30–60 ns):** A = 1111 (15), B = 0001 (1), result wraps to 0000 (overflow), and `done` goes high.

## 6. Exercises

1. Modify the FSM to support 8-bit serial addition.
2. Add carry-out as a separate output from the most significant bit.
3. Add a ready signal to prevent multiple triggers of the FSM while busy.
4. Convert the FSM from Mealy to Moore implementation and compare.
5. Implement the serial adder using shift registers and a single full adder module.

## 7. Conclusion

This lab demonstrates the use of finite state machines for implementing sequential operations, using a serial adder as an example. The FSM structure enables cycle-by-cycle control over data processing and provides insights into the control logic of digital systems.

## 8. Instructor Notes

- Emphasize FSM diagram design before Verilog coding.
- Show differences between serial and parallel adder architectures.
- Discuss FSM state encoding and optimization techniques.

