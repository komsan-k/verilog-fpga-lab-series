# Lab 13: Traffic Light Controller

## 1. Lab Objective

- To design and simulate a traffic light controller using Verilog HDL.
- To apply FSM-based sequential logic design.
- To implement the design on an FPGA development board.

## 2. Background Theory

A traffic light controller operates based on a fixed or adaptive sequence to regulate traffic at intersections. It typically follows a deterministic state machine pattern:

- Green → Yellow → Red
- Time delays determine how long each light remains active.

This lab uses a **Moore FSM model**, where the output depends only on the current state.

## 3. Traffic Light State Diagram

- **S0**: Green (main road) – 5 seconds
- **S1**: Yellow (main road) – 2 seconds
- **S2**: Red (main road) – 5 seconds

Cycle repeats every 12 seconds. Clock frequency is assumed to be 1 Hz (1 second tick).

## 4. Verilog Implementation

### 4.1 FSM Code

```verilog
module traffic_light_fsm (
    input clk,
    input rst,
    output reg [2:0] lights  // {Red, Yellow, Green}
);
    typedef enum reg [1:0] {S0, S1, S2} state_t;
    state_t current_state, next_state;
    reg [3:0] timer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S0;
            timer <= 0;
        end else begin
            if (timer == 0) begin
                current_state <= next_state;
                case (next_state)
                    S0: timer <= 5;
                    S1: timer <= 2;
                    S2: timer <= 5;
                endcase
            end else begin
                timer <= timer - 1;
            end
        end
    end

    always @(*) begin
        case (current_state)
            S0: begin lights = 3'b001; next_state = S1; end // Green
            S1: begin lights = 3'b010; next_state = S2; end // Yellow
            S2: begin lights = 3'b100; next_state = S0; end // Red
            default: begin lights = 3'b000; next_state = S0; end
        endcase
    end
endmodule
```

## 5. Testbench Example

```verilog
module tb_traffic_light;
    reg clk = 0, rst = 1;
    wire [2:0] lights;

    traffic_light_fsm uut (.clk(clk), .rst(rst), .lights(lights));

    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%t, State={{R,Y,G}}=%b", $time, lights);
        #15 rst = 0;
        #200 $finish;
    end
endmodule
```

## 6. FPGA Mapping (e.g., Nexys A7)

```tcl
## Green LED
set_property PACKAGE_PIN U16 [get_ports {lights[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lights[0]}]

## Yellow LED
set_property PACKAGE_PIN V16 [get_ports {lights[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lights[1]}]

## Red LED
set_property PACKAGE_PIN W16 [get_ports {lights[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lights[2]}]

## Clock and Reset
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN T18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
```

## 7. Simulation and Results

| Time (ns) | lights [R,Y,G] |
|-----------|----------------|
| 0         | 001 (Green)    |
| 50        | 010 (Yellow)   |
| 70        | 100 (Red)      |
| 120       | 001 (Green)    |

## 8. Exercises

1. Modify FSM for two-way intersection (Main and Side road).
2. Add pedestrian walk signal with button interrupt.
3. Use 1 kHz input clock with a counter-based divider for 1 Hz tick.
4. Add buzzer output for pedestrian crossing alert.
5. Display countdown on 7-segment display for each light.

## 9. Conclusion

This lab demonstrated the implementation of a finite state machine for traffic light control using Verilog. Students practiced state encoding, timing control, and FPGA pin mapping for real-world interfacing.

## 10. Instructor Notes

- Discuss synchronous vs asynchronous reset behavior.
- Encourage waveform validation using simulation tools.
- Let students experiment with different timing intervals.
