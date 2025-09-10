
# Lab 10: Display Counter on FPGA

## 1. Lab Objective

- To design a 2-digit decimal counter and interface it with a 7-segment display.
- To apply multiplexing to control multiple digits with limited FPGA I/O.
- To simulate and implement the design on a real FPGA board.

## 2. Background Theory

A 7-segment display consists of seven LEDs labeled 'a' through 'g', arranged to display numeric digits. For multiple digits, multiplexing is used: only one digit is enabled at a time, but they are toggled fast enough for persistence of vision.

**Key Concepts:**

- Binary counter increments every clock cycle.
- BCD conversion is required to display decimal numbers.
- Multiplexing alternates the active digit rapidly.

## 3. Verilog Design Overview

### 3.1 BCD Counter (0–99)

```verilog
module bcd_counter (
    input clk,
    input rst,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ones <= 0;
            tens <= 0;
        end else begin
            if (ones == 9) begin
                ones <= 0;
                if (tens == 9)
                    tens <= 0;
                else
                    tens <= tens + 1;
            end else begin
                ones <= ones + 1;
            end
        end
    end
endmodule
```

### 3.2 7-Segment Decoder

```verilog
module seg_decoder (
    input [3:0] digit,
    output reg [6:0] seg
);
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end
endmodule
```

### 3.3 Multiplexed Display Control

```verilog
module mux_display (
    input clk,
    input rst,
    input [3:0] digit1,
    input [3:0] digit2,
    output reg [6:0] seg,
    output reg [3:0] an
);
    reg toggle;
    wire [6:0] seg1, seg2;

    seg_decoder dec1 (.digit(digit1), .seg(seg1));
    seg_decoder dec2 (.digit(digit2), .seg(seg2));

    reg [15:0] clkdiv;

    always @(posedge clk or posedge rst) begin
        if (rst)
            clkdiv <= 0;
        else
            clkdiv <= clkdiv + 1;
    end

    always @(posedge clkdiv[15]) begin
        toggle <= ~toggle;
    end

    always @(*) begin
        if (toggle) begin
            seg = seg1;
            an = 4'b1110;
        end else begin
            seg = seg2;
            an = 4'b1101;
        end
    end
endmodule
```

### 3.4 Top-Level Integration

```verilog
module top_display_counter (
    input clk,
    input rst,
    output [6:0] seg,
    output [3:0] an
);
    wire [3:0] ones, tens;

    bcd_counter bcd (.clk(clk), .rst(rst), .tens(tens), .ones(ones));
    mux_display mux (.clk(clk), .rst(rst), .digit1(ones), .digit2(tens), .seg(seg), .an(an));
endmodule
```

## 4. FPGA Pin Mapping (Nexys A7)

- `clk`: W5 (100 MHz system clock)
- `rst`: Connect to push button (e.g., T18)
- `seg[6:0]`: AE26, AC26, AB26, AB25, AA26, Y25, Y26
- `an[3:0]`: W22, V22, U21, U22

## 5. Simulation and Results

### 5.1 BCD Counter Simulation Table

| Clock Cycle | Tens (BCD) | Ones (BCD) |
|-------------|------------|------------|
| 0           | 0          | 0          |
| 1           | 0          | 1          |
| ...         | ...        | ...        |
| 9           | 0          | 9          |
| 10          | 1          | 0          |
| 11          | 1          | 1          |
| ...         | ...        | ...        |
| 15          | 1          | 5          |

### 5.2 7-Segment Multiplexing Results

| Time (ns) | Toggle | Active Digit | Segment Code (seg)     |
|-----------|--------|---------------|-------------------------|
| 1000      | 0      | Tens          | 7'b1000000 (shows '0')  |
| 2000      | 1      | Ones          | 7'b1111001 (shows '1')  |
| 3000      | 0      | Tens          | 7'b1000000 (shows '0')  |
| 4000      | 1      | Ones          | 7'b0100100 (shows '2')  |

> Note: The display counts from `00` to `99` and rolls over. Multiplexing gives the illusion of simultaneous display.

## 6. Implementation and Testing

1. Use Vivado to create the project and add the top module and submodules.
2. Assign pins using the XDC constraints file.
3. Program the FPGA and observe the counter on the 2-digit display.

## 7. Exercises

1. Modify the design to count down from 99 to 00.
2. Add a pause/resume button for the counter.
3. Add a clock divider for slower counting (1 Hz).
4. Expand the design to 4 digits (0000–9999).
5. Display hexadecimal values instead of decimal (0–FF).

## 8. Conclusion

This lab demonstrated the control of a 2-digit 7-segment display using a binary-to-BCD counter and digit multiplexing. It introduced a complete display subsystem for real-time counting, applicable in timers, counters, and embedded interfaces.

## 9. Instructor Notes

- Emphasize the concept of human visual persistence in multiplexing.
- Encourage modular design and simulation of each unit separately.
- Provide XDC templates for faster pin assignment.

