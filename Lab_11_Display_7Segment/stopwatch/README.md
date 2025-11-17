
# ⏱️ FPGA Lab: Stopwatch Display Counter (Centi-Second → Second)

## 1. Objective

- Design a **3-digit stopwatch counter** that counts:
  - **Centi-seconds** (00–99)
  - **Seconds** (0–9)
- Display the time on a **multiplexed 7-segment display**.
- Implement and test the design on a **Nexys A7 FPGA** board.

---

## 2. Design Overview

The stopwatch uses:

- A **clock divider** to generate a **100 Hz tick** (every 10 ms) from the 100 MHz system clock.
- A **BCD stopwatch counter**:
  - `cs_ones` : centi-second ones (0–9)
  - `cs_tens` : centi-second tens (0–9)
  - `sec`     : seconds (0–9)
- A **3-digit 7-segment multiplexer**:
  - Digit 0 → cs_ones
  - Digit 1 → cs_tens
  - Digit 2 → sec

Time relationship:

- 1 centi-second = 0.01 s  
- 1 second = 100 centi-seconds → 100 ticks at 100 Hz

---

## 3. Verilog Modules

### 3.1 Clock Divider (100 MHz → 100 Hz)

```verilog
// clock_divider_100hz.v
// 100 MHz -> 100 Hz tick (every 10 ms)

module clock_divider_100hz (
    input  clk,
    input  rst,
    output reg tick_100hz
);
    reg [31:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count      <= 0;
            tick_100hz <= 0;
        end else begin
            if (count == 1_000_000 - 1) begin  // 100,000,000 / 100 = 1,000,000
                count      <= 0;
                tick_100hz <= 1;
            end else begin
                count      <= count + 1;
                tick_100hz <= 0;
            end
        end
    end
endmodule
```

---

### 3.2 Stopwatch Counter (Centi-second → Second)

```verilog
// stopwatch_counter.v
// Counts centi-seconds (00–99) and seconds (0–9).

module stopwatch_counter (
    input  clk100hz,
    input  rst,
    output reg [3:0] cs_ones,   // centi-second ones (0–9)
    output reg [3:0] cs_tens,   // centi-second tens (0–9)
    output reg [3:0] sec        // seconds (0–9)
);
    always @(posedge clk100hz or posedge rst) begin
        if (rst) begin
            cs_ones <= 0;
            cs_tens <= 0;
            sec     <= 0;
        end else begin
            if (cs_ones == 9) begin
                cs_ones <= 0;

                if (cs_tens == 9) begin
                    cs_tens <= 0;

                    if (sec == 9)
                        sec <= 0;
                    else
                        sec <= sec + 1;

                end else begin
                    cs_tens <= cs_tens + 1;
                end

            end else begin
                cs_ones <= cs_ones + 1;
            end
        end
    end
endmodule
```

---

### 3.3 7-Segment Decoder

```verilog
// seg_decoder.v
// Active-low 7-segment decoder: seg[6:0] = {a,b,c,d,e,f,g}

module seg_decoder (
    input  [3:0] digit,
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
            default: seg = 7'b1111111; // all OFF
        endcase
    end
endmodule
```

---

### 3.4 Multiplexed 3-Digit Display

```verilog
// mux3_display.v
// 3-digit multiplexed 7-seg display (active-low anodes).

module mux3_display (
    input clk,
    input rst,
    input [3:0] d0,  // cs_ones
    input [3:0] d1,  // cs_tens
    input [3:0] d2,  // sec
    output reg [6:0] seg,
    output reg [3:0] an
);
    wire [6:0] seg0, seg1, seg2;
    reg [1:0] sel;
    reg [15:0] clkdiv;

    seg_decoder dec0 (.digit(d0), .seg(seg0));
    seg_decoder dec1 (.digit(d1), .seg(seg1));
    seg_decoder dec2 (.digit(d2), .seg(seg2));

    // Clock divider for multiplex speed (~1 kHz region)
    always @(posedge clk or posedge rst) begin
        if (rst)
            clkdiv <= 0;
        else
            clkdiv <= clkdiv + 1;
    end

    // Use a higher bit of clkdiv to generate a slower select clock
    always @(posedge clkdiv[15] or posedge rst) begin
        if (rst)
            sel <= 0;
        else
            sel <= sel + 1;
    end

    always @(*) begin
        case (sel)
            2'd0: begin seg = seg0; an = 4'b1110; end // digit 0 (rightmost)
            2'd1: begin seg = seg1; an = 4'b1101; end // digit 1
            2'd2: begin seg = seg2; an = 4'b1011; end // digit 2
            default: begin seg = 7'b1111111; an = 4'b1111; end
        endcase
    end
endmodule
```

---

### 3.5 Top-Level Module (Nexys A7)

```verilog
// top_stopwatch.v
// Top-level for Nexys A7: Stopwatch with centi-second & second display.

module top_stopwatch (
    input  wire clk,      // 100 MHz system clock (CLK100MHZ)
    input  wire rst,      // active-high reset button
    output wire [6:0] seg,
    output wire [3:0] an
);
    wire tick_100hz;
    wire [3:0] cs_ones;
    wire [3:0] cs_tens;
    wire [3:0] sec;

    // 100 MHz -> 100 Hz
    clock_divider_100hz u_div (
        .clk       (clk),
        .rst       (rst),
        .tick_100hz(tick_100hz)
    );

    // Stopwatch counter
    stopwatch_counter u_cnt (
        .clk100hz (tick_100hz),
        .rst      (rst),
        .cs_ones  (cs_ones),
        .cs_tens  (cs_tens),
        .sec      (sec)
    );

    // 3-digit 7-seg driver
    mux3_display u_mux (
        .clk (clk),
        .rst (rst),
        .d0  (cs_ones),
        .d1  (cs_tens),
        .d2  (sec),
        .seg (seg),
        .an  (an)
    );

endmodule
```

---

## 4. Nexys A7 Pin Mapping (XDC Summary)

We use:

- 100 MHz system clock: `clk` at pin **E3**
- Reset button: center button **BTNC** at pin **N17**
- 7-segment segments: **CA–CG** at pins T10, R10, K16, K13, P15, T11, L18
- 7-segment anodes: **AN[0–3]** at pins J17, J18, T9, J14

Full XDC file is provided as: `NexysA7_Stopwatch.xdc`.

---

## 5. Implementation Steps (Vivado)

1. **Create Project**
   - New RTL project → Add sources:
     - `clock_divider_100hz.v`
     - `stopwatch_counter.v`
     - `seg_decoder.v`
     - `mux3_display.v`
     - `top_stopwatch.v`
   - Add constraint file: `NexysA7_Stopwatch.xdc`.

2. **Set Top Module**
   - Set `top_stopwatch` as the top module.

3. **Run Synthesis & Implementation**
   - Run *Synthesis* and fix any errors.
   - Run *Implementation*.
   - Generate the Bitstream.

4. **Program the Nexys A7**
   - Open Hardware Manager.
   - Connect to target, program device with the generated bitstream.

---

## 6. On-Board Testing

1. After programming:
   - The display should show a rolling value from `000` upward, where:
     - Rightmost digit = centi-second ones
     - Middle digit    = centi-second tens
     - Left digit      = seconds

2. Press and hold **reset (BTNC)**:
   - All digits should reset to `000`.

3. Observe:
   - The counting rate is approximately **0.01 s per increment** of `cs_ones`.
   - After 100 centi-seconds, the **sec** digit increments by 1 and centi-seconds return to 00.

---

## 7. Possible Extensions

- Extend the seconds range to 0–59 (add minute counter).
- Add **start/stop** button.
- Add **lap** capture display.
- Extend to a 4-digit (MM:SS) or 6-digit (HH:MM:SS) format.
