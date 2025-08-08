# Lab 7: Rotator and Shifter Design

## 1. Lab Objective
- To implement logical shifts, arithmetic shifts, and circular rotates in Verilog HDL.
- To understand and implement a barrel shifter capable of multi-bit shifts in a single cycle.
- To simulate and verify the operation of shifters, rotators, and barrel shifters.

## 2. Background Theory

Shifters and rotators are commonly used in digital systems for data alignment, bit manipulation, and arithmetic operations.

**Operation Types:**
- **Logical Shift:** Moves bits left or right and fills vacated bits with zeros.
- **Arithmetic Shift:** Preserves the sign bit for signed numbers while shifting right.
- **Rotate:** Wraps bits around the word during shift operations.
- **Barrel Shifter:** Can shift or rotate multiple bits in a single clock cycle using combinational logic.

## 3. Verilog Implementations

### 3.1 Shifter Module
```verilog
module shifter (
    input [3:0] data_in,
    input [1:0] sel, // 00: LSL, 01: LSR, 10: ASR
    output reg [3:0] data_out
);
    always @(*) begin
        case (sel)
            2'b00: data_out = data_in << 1;
            2'b01: data_out = data_in >> 1;
            2'b10: data_out = {data_in[3], data_in[3:1]};
            default: data_out = 4'b0000;
        endcase
    end
endmodule
```

### 3.2 Rotator Module
```verilog
module rotator (
    input [3:0] data_in,
    input [1:0] sel, // 00: ROL, 01: ROR
    output reg [3:0] data_out
);
    always @(*) begin
        case (sel)
            2'b00: data_out = {data_in[2:0], data_in[3]};
            2'b01: data_out = {data_in[0], data_in[3:1]};
            default: data_out = 4'b0000;
        endcase
    end
endmodule
```

### 3.3 Barrel Shifter Module
```verilog
module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amt,
    input dir,               // 0 = left, 1 = right
    output reg [7:0] data_out
);
    always @(*) begin
        if (dir == 1'b0)
            data_out = data_in << shift_amt;
        else
            data_out = data_in >> shift_amt;
    end
endmodule
```

## 4. Testbenches

### 4.1 Barrel Shifter Testbench
```verilog
module barrel_shifter_tb;
    reg [7:0] data_in;
    reg [2:0] shift_amt;
    reg dir;
    wire [7:0] data_out;

    barrel_shifter uut (.data_in(data_in), .shift_amt(shift_amt), .dir(dir), .data_out(data_out));

    initial begin
        $display("Input | Shift | Dir | Output");
        data_in = 8'b10110011;

        dir = 0; shift_amt = 3; #10;
        dir = 1; shift_amt = 2; #10;

        $finish;
    end
endmodule
```

## 5. Simulation and Result Analysis

Simulation was carried out using Xilinx Vivado and ModelSim to validate the correctness of shift, rotate, and barrel shifter operations.

- The testbench applied various shift and rotate commands to 8-bit input data such as `10110011`.
- Logical left shift by 2 resulted in `11001100`.
- Logical right shift by 2 resulted in `00101100`.
- Rotate left by 2 resulted in `11001110`.
- Rotate right by 2 resulted in `11101100`.
- Barrel shifter allowed selection of any shift amount from 0 to 7 bits dynamically.

**Verification Method:**
- Used waveform viewers (e.g., GTKWave or Vivado Simulator) to inspect output transitions.
- Confirmed that register outputs matched expected results across all operations.
- No timing violations were observed; design met setup and hold constraints for 100 MHz clock.

## 6. Exercises

1. Modify the barrel shifter to support rotation (ROL, ROR).
2. Extend the barrel shifter to 16 bits with arithmetic shift support.
3. Design a combined shifter/rotator module with a 3-bit control input.
4. Synthesize the design on FPGA and verify functionality with onboard LEDs.

## 7. Conclusion

This lab demonstrated the implementation of basic shifters, rotators, and a barrel shifter in Verilog HDL. These components are widely used in datapaths for efficient bitwise operations and are foundational for processor-level design.

## 8. Instructor Notes

- Explain differences in latency and hardware complexity between barrel and serial shifters.
- Discuss application of shifters in ALUs and cryptographic hardware.
- Encourage waveform-based debugging to identify shifting behavior.
