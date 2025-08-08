
# Lab 2: Starting with Xilinx Nexys A7

The Xilinx Nexys A7 is an FPGA development board based on the Xilinx Artix-7 family. It is ideal for learning digital design using Verilog HDL and for prototyping embedded systems. This guide helps you set up your development environment and prepare your first project.

## Lab Objectives

- Set up the Nexys A7 FPGA board and configure Vivado for Artix-7 devices.
- Create a simple Verilog project to control onboard components.
- Use XDC constraints and program the FPGA with the generated bitstream.

## 1. Board Overview

The Nexys A7 provides:

- Xilinx Artix-7 XC7A100T-1CSG324C FPGA
- 100 MHz system clock (pin `W5`)
- 16 user switches, 16 LEDs
- 7-segment display (four digits)
- VGA, USB-UART, and Pmod connectors

## 2. Required Software

Before you begin, install the following tools:

- **Xilinx Vivado Design Suite** (WebPACK edition is free)
- **Digilent Board Files** for Nexys A7 (optional)
- **USB drivers** (FTDI drivers may be required)

## 3. Initial Setup Steps

1. Connect the Nexys A7 to your computer using the micro-USB cable.
2. Open Vivado and create a new RTL project:
   - Select Verilog as the target language.
   - Use part number `xc7a100tcsg324-1`.
3. Create source and constraint files (`.xdc`).

## 4. Pin Mapping (Nexys A7)

Common I/O pin mappings:

- **Clock and Reset:**
  - `clk`: `W5` (100 MHz)
  - `rst`: `T18` (push button)
- **Switches (`sw[7:0]`)**: `V17, V16, W16, W17, W19, V18, U17, U18`
- **LEDs (`led[7:0]`)**: `U16, E19, U19, V19, W18, U15, V15, W15`
- **Push Buttons (`btn[3:0]`)**: `T18, P16, N15, M17`
- **7-Segment Display:**
  - `an[3:0]`: `W22, V22, U21, U22`
  - `seg[6:0]`: `AE26, AC26, AB26, AB25, AA26, Y25, Y26`
  - `dp`: `AA24`
- **UART (USB-to-Serial):**
  - `tx`: `U1`
  - `rx`: `V1`
- **Pmod Headers:**
  - JA[0-3]: `J1, L2, J2, G2`
  - JB[0-3]: `A14, A16, B15, B16`
- **VGA Output:**
  - `vga_red[2:0]`: `N3, N2, P1`
  - `vga_green[2:0]`: `U3, P3, N1`
  - `vga_blue[1:0]`: `R2, T1`
  - `vga_hsync`: `P2`, `vga_vsync`: `R1`

## 5. First Project: LED Blinker

```verilog
module led_blinker (
    input wire clk,
    output reg led
);
    reg [25:0] counter = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
        led <= counter[25];
    end
endmodule
```

Connect `led` to one of the onboard LEDs and `clk` to pin `W5`.

## 6. XDC Constraints File

Create a file named `led_blinker.xdc`:

```tcl
## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## LED output
set_property PACKAGE_PIN U16 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]
```

Add this file via **Flow Navigator > Add Sources > Add or Create Constraints**.

## 7. Programming the FPGA

1. Run synthesis in Vivado.
2. Generate the bitstream.
3. Open Hardware Manager and connect.
4. Program the device using the `.bit` file.

Once programmed, the LED will blink at ~0.75 Hz.

## 8. Summary

You have now configured Vivado, created a Verilog design, applied pin constraints, and programmed the Nexys A7 FPGA. You're ready to build more complex modules like counters, FSMs, and UARTs.
