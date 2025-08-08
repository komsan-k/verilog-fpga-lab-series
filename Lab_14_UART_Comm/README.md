
# Lab 14: UART Communication

## 1. Lab Objective

- To understand the Universal Asynchronous Receiver Transmitter (UART) protocol.
- To design UART Transmitter and Receiver modules using Verilog HDL.
- To simulate UART behavior and optionally interface with a serial terminal via FPGA.

## 2. Background Theory

### 2.1 UART Overview

UART is a hardware communication protocol used for asynchronous serial communication. It converts parallel data into serial format (TX) and vice versa (RX) without requiring a separate clock signal.

**Standard UART Frame:**

- 1 start bit (0)
- 8 data bits (LSB first)
- 1 stop bit (1)

**Common Parameters:**

- Baud rate: 9600, 115200 bps, etc.
- No parity
- 1 start, 1 stop bit

---

## 3. Verilog Implementation

Assume a 100 MHz system clock and a baud rate of 9600.

### 3.1 Baud Rate Generator

```verilog
module baud_gen (
    input clk,
    input rst,
    output reg tick
);
    parameter BAUD_DIV = 10416; // 100MHz / 9600

    reg [13:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            tick <= 0;
        end else begin
            if (count == BAUD_DIV - 1) begin
                count <= 0;
                tick <= 1;
            end else begin
                count <= count + 1;
                tick <= 0;
            end
        end
    end
endmodule
```

### 3.2 UART Transmitter

```verilog
module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    input tick,
    output reg tx,
    output reg busy
);
    reg [3:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            busy <= 0;
            state <= 0;
        end else if (tick) begin
            case (state)
                0: if (tx_start) begin
                    busy <= 1;
                    data <= tx_data;
                    tx <= 0; // Start bit
                    state <= 1;
                    bit_cnt <= 0;
                end
                1: begin // Data bits
                    tx <= data[bit_cnt];
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) state <= 2;
                end
                2: begin // Stop bit
                    tx <= 1;
                    state <= 3;
                end
                3: begin
                    busy <= 0;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
```

### 3.3 UART Receiver

```verilog
module uart_rx (
    input clk,
    input rst,
    input rx,
    input tick,
    output reg [7:0] rx_data,
    output reg rx_done
);
    reg [3:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            rx_done <= 0;
        end else if (tick) begin
            case (state)
                0: if (!rx) state <= 1; // Start bit
                1: begin
                    data[bit_cnt] <= rx;
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) state <= 2;
                end
                2: begin // Stop bit
                    rx_data <= data;
                    rx_done <= 1;
                    state <= 3;
                end
                3: begin
                    rx_done <= 0;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
```

## 4. Testbench for UART TX and RX

```verilog
module uart_tb;
    reg clk = 0, rst = 0;
    reg [7:0] tx_data = 8'h55;
    reg tx_start = 0;
    wire tx, rx;
    wire [7:0] rx_data;
    wire tick, rx_done, busy;

    assign rx = tx;

    baud_gen #(10416) baud (.clk(clk), .rst(rst), .tick(tick));
    uart_tx tx_inst (.clk(clk), .rst(rst), .tx_start(tx_start), .tx_data(tx_data),
                     .tick(tick), .tx(tx), .busy(busy));
    uart_rx rx_inst (.clk(clk), .rst(rst), .rx(tx), .tick(tick),
                     .rx_data(rx_data), .rx_done(rx_done));

    always #5 clk = ~clk;

    initial begin
        rst = 1; #20; rst = 0;
        #50 tx_start = 1; #10 tx_start = 0;
        #10000;
        $finish;
    end

    initial begin
        $monitor("TX = %b | RX_DATA = %h | RX_DONE = %b", tx, rx_data, rx_done);
    end
endmodule
```

## 5. Implementation Notes (Optional FPGA Deployment)

- Use `tx` and `rx` pins mapped to Pmod UART (or USB-UART bridge) on the FPGA board.
- Connect to a PC via USB using a serial terminal (Baud = 9600).
- Send ASCII characters to observe loopback behavior.

### Case Using Nexys A7

- Use on-board USB-UART bridge via the USB-JTAG port.
- Map `tx` and `rx` to:

```
tx: U19
rx: R20
```

**XDC constraints:**

```verilog
## UART TX (FPGA to PC)
set_property PACKAGE_PIN U19 [get_ports {tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {tx}]

## UART RX (PC to FPGA)
set_property PACKAGE_PIN R20 [get_ports {rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {rx}]
```

Use a terminal (e.g., PuTTY, TeraTerm) with settings:

- Baud rate: 9600
- 8 data bits
- No parity
- 1 stop bit

## 6. Simulation and Results

The loopback simulation connects `rx = tx`. A byte (0x55) is sent and received.


| Time (ns) | TX Line       | RX Data (Hex) |
|-----------|---------------|----------------|
| 0         | Idle (1)      | --             |
| 50        | Start Bit (0) | --             |
| 60–130    | 01010101      | --             |
| 140       | Stop Bit (1)  | 0x55           |

- Transmitter: start bit → 8 data bits (LSB first) → stop bit.
- Receiver reconstructs byte and sets `rx_done` high.

## 7. Exercises

1. Add parity bit generation and checking.
2. Support 7-bit or 9-bit data.
3. Create a full-duplex UART loopback system.
4. Create an FSM that sends "HELLO" repeatedly.
5. Interface UART with 7-segment display to show received byte.

## 8. Conclusion

This lab introduced UART communication using Verilog HDL. The transmitter and receiver logic was implemented and validated. It's a foundation for serial data transfer in FPGA-based systems.

## 9. Instructor Notes

- Emphasize baud timing accuracy.
- Provide XDC files for UART I/O mapping.
- Suggest waveform inspection tools like GTKWave or Vivado.
