
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

---

## 3. Clock Divider (100 MHz to ~1 Hz)

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

## 4. Top-Level Example Module

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

> Note: If you prefer, you can keep `traffic_light_fsm` clocked by `clk_100mhz` and feed `tick_1hz` into an internal enable/timer instead. For this lab, using `tick_1hz` directly as the FSM clock is simpler and easier to observe on hardware.

---

## 5. Hardware Mapping (Example)

In your XDC/constraints file, map signals to physical FPGA pins, for example (Basys 3-style, **adapt to your board**):

- `clk_100mhz` → 100 MHz clock pin (e.g., `W5`)  
- `rst_btn`    → reset push button (e.g., `U18`)  
- `ped_btn`    → another push button (e.g., `T18`)  
- `leds_traffic[0]` (Green) → `LED0`  
- `leds_traffic[1]` (Yellow) → `LED1`  
- `leds_traffic[2]` (Red) → `LED2`  
- `led_ped` → `LED3` (Pedestrian WALK)

Adjust pin names and locations according to your board’s user manual.

---

## 6. Implementation Steps (Vivado Example)

1. **Create Project**
   - Open Vivado and create a new RTL project.
   - Add source files:
     - `clock_divider.v`
     - `traffic_light_fsm.v`
     - `top_traffic_ped.v`
   - Add or create the XDC constraints file and assign pins.

2. **Set Top Module**
   - Set `top_traffic_ped` as the top module.

3. **Run Synthesis**
   - Run *Synthesis*.
   - Fix any syntax or pin assignment errors if they appear.

4. **Run Implementation & Bitstream**
   - Run *Implementation*.
   - Generate the Bitstream.

5. **Program the FPGA**
   - Open *Hardware Manager*.
   - Connect to the board.
   - Program the FPGA with the generated bitstream.

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

---

## 8. Optional Extensions

If time allows, students can extend the design to:

- Add a **separate pedestrian RED LED**.
- Display the **remaining WALK time** on a 7-segment display.
- Add a **night mode** where GREEN time is longer and pedestrian requests are served differently.

---

Generated as a lab-ready README for FPGA implementation of a traffic light controller with pedestrian crossing.
