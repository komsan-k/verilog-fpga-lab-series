
# FPGA Lab: Traffic Light Controller with Pedestrian Crossing

## 1. Objective

Implement a **traffic light controller with pedestrian crossing** on an FPGA using:

- A **clock divider** to generate a slow tick (~1 Hz) from the **100 MHz** board clock.
- A **finite state machine (FSM)** with a **latched pedestrian request**.
- External I/O: push buttons for **reset** and **pedestrian request**, LEDs for **traffic lights** and **pedestrian WALK**.

---

## 2. Design Files

Recommended file structure:

- `clock_divider.v` – 100 MHz → 1 Hz tick generator  
- `traffic_light_fsm.v` – FSM for traffic lights and pedestrian crossing  
- `top_traffic_ped.v` – **Top-level design** (connects divider, FSM, and FPGA pins)

You already have `traffic_light_fsm.v`. Below is an example `clock_divider` and `top_traffic_ped.v`.

## 3. Traffic Light FSM
```verilog
module traffic_light_fsm (
    input  clk,
    input  rst,
    input  ped_btn,          // pedestrian request button
    output reg [2:0] lights, // {Red, Yellow, Green} for cars
    output reg       ped_walk // 1 = WALK, 0 = DON'T WALK
);

    // State encoding
    localparam S_GREEN = 2'b00,  // Cars Green
               S_YELL  = 2'b01,  // Cars Yellow
               S_RED   = 2'b10,  // All Red (transition)
               S_PED   = 2'b11;  // Pedestrian Walk (cars red)

    reg [1:0] current_state, next_state;
    reg [3:0] timer;
    reg       ped_req;            // latched pedestrian request

    // Sequential block: state, timer, and ped_req
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S_GREEN;
            timer         <= 0;
            ped_req       <= 1'b0;
        end else begin
            // Latch pedestrian request whenever button is pressed
            if (ped_btn)
                ped_req <= 1'b1;

            if (timer == 0) begin
                current_state <= next_state;

                // Set duration for next_state (in ticks)
                case (next_state)
                    S_GREEN: timer <= 5; // e.g., 5 ticks of green
                    S_YELL : timer <= 2; // 2 ticks of yellow
                    S_RED  : timer <= 2; // 2 ticks all-red clearance
                    S_PED  : timer <= 5; // 5 ticks of pedestrian walk
                    default: timer <= 0;
                endcase

                // When we enter pedestrian state, clear request
                if (next_state == S_PED)
                    ped_req <= 1'b0;

            end else begin
                timer <= timer - 1;
            end
        end
    end

    // Combinational block: next_state + outputs
    always @(*) begin
        // Default outputs
        lights    = 3'b000;
        ped_walk  = 1'b0;
        next_state = S_GREEN; // default to avoid latches

        case (current_state)
            // Cars GREEN, pedestrians DON'T WALK
            S_GREEN: begin
                lights     = 3'b001; // Green
                ped_walk   = 1'b0;   // Don't walk
                next_state = S_YELL;
            end

            // Cars YELLOW, pedestrians DON'T WALK
            S_YELL: begin
                lights     = 3'b010; // Yellow
                ped_walk   = 1'b0;
                next_state = S_RED;
            end

            // All RED: either go to PED (if requested) or GREEN
            S_RED: begin
                lights   = 3'b100; // Red
                ped_walk = 1'b0;

                if (ped_req)
                    next_state = S_PED;   // serve pedestrians
                else
                    next_state = S_GREEN; // back to car green
            end

            // Pedestrian WALK: cars RED, pedestrians WALK
            S_PED: begin
                lights     = 3'b100; // Cars stay red
                ped_walk   = 1'b1;   // WALK signal
                next_state = S_GREEN;
            end

            default: begin
                lights     = 3'b000;
                ped_walk   = 1'b0;
                next_state = S_GREEN;
            end
        endcase
    end

endmodule
```

---

## 4. Clock Divider (100 MHz to ~1 Hz)

```verilog
// clock_divider.v
// Divide a 100 MHz system clock down to a 1 Hz tick.
// tick_1hz goes HIGH for one clk_100 cycle every DIVISOR cycles.

module clock_divider #(
    parameter integer DIVISOR = 100_000_000  // 100 MHz -> 1 Hz
)(
    input  wire clk,
    input  wire rst,
    output reg  tick_1hz
);
    reg [31:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count    <= 32'd0;
            tick_1hz <= 1'b0;
        end else begin
            if (count == DIVISOR - 1) begin
                count    <= 32'd0;
                tick_1hz <= 1'b1;   // one-cycle pulse each second
            end else begin
                count    <= count + 1;
                tick_1hz <= 1'b0;
            end
        end
    end
endmodule
```

---

## 5. Top-Level Example Module

This top-level module:

- Uses the board’s 100 MHz clock and reset button.
- Instantiates `clock_divider` to create `tick_1hz`.
- Uses `tick_1hz` as the **FSM clock**, so the traffic states change once per second.
- Maps:
  - `ped_btn` to a button
  - `lights[2:0]` to 3 LEDs (Red, Yellow, Green)
  - `ped_walk` to a pedestrian LED

```verilog
// top_traffic_ped.v
// Top-level module connecting the 100 MHz clock, clock divider,
// traffic light FSM with pedestrian crossing, and FPGA I/O.

module top_traffic_ped (
    input  wire       clk_100mhz,   // 100 MHz system clock
    input  wire       rst_btn,      // active-high reset button
    input  wire       ped_btn,      // pedestrian request button
    output wire [2:0] leds_traffic, // {Red, Yellow, Green}
    output wire       led_ped       // pedestrian WALK LED
);

    wire tick_1hz;

    // 1 Hz clock divider
    clock_divider #(
        .DIVISOR(100_000_000)
    ) u_div (
        .clk      (clk_100mhz),
        .rst      (rst_btn),
        .tick_1hz (tick_1hz)
    );

    // Traffic light FSM with pedestrian crossing
    // We use tick_1hz as the FSM clock so that states advance once per second.
    traffic_light_fsm u_fsm (
        .clk      (tick_1hz),     // slow clock
        .rst      (rst_btn),
        .ped_btn  (ped_btn),
        .lights   (leds_traffic),
        .ped_walk (led_ped)
    );

endmodule
```

---

## 6. Hardware Mapping (Example)

In your XDC file, map signals to physical FPGA pins:
<!---
- `clk_100mhz` → 100 MHz clock pin (e.g., `W5`)  
- `rst_btn`    → reset push button (e.g., `U18`)  
- `ped_btn`    → another push button (e.g., `T18`)  
- `leds_traffic[0]` (Green) → `LED0`  
- `leds_traffic[1]` (Yellow) → `LED1`  
- `leds_traffic[2]` (Red) → `LED2`  
- `led_ped` → `LED3` (Pedestrian WALK)

Adjust pin names and locations according to your board’s user manual.
--->
---

## 7. On-Board Test Procedure

1. **Initial Power-On**
   - After loading the bitstream, observe that:
     - The traffic LEDs cycle through:
       - GREEN (5 seconds)
       - YELLOW (2 seconds)
       - RED (2 seconds)
       - Back to GREEN
     - The pedestrian LED (`led_ped`) is initially OFF.

2. **Test Pedestrian Request**
   - Press the pedestrian button (`ped_btn`) while the light is GREEN:
     - The controller should finish GREEN → YELLOW → RED,
     - Then enter the **pedestrian WALK phase**:
       - Car Red LED ON
       - `led_ped` ON for the programmed duration (e.g., 5 seconds)
     - After WALK, it returns to GREEN for cars and turns `led_ped` OFF.

3. **Press at Different Times**
   - Press `ped_btn` during YELLOW or RED:
     - The request should be **latched** (`ped_req` inside FSM),
     - The controller still eventually serves a WALK phase after the current cycle.

4. **Reset Behavior**
   - Press and hold `rst_btn`:
     - FSM should reset to `S_GREEN`,
     - Timer should restart,
     - Pedestrian request cleared.


