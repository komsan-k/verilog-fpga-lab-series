
# Lab 1: Beginning with Xilinx Vivado

## Lab Objectives
- Learn how to install and configure the Xilinx Vivado Design Suite.
- Create, simulate, and verify a basic Verilog project.

## 1. Introduction
Xilinx Vivado Design Suite is a powerful development environment for implementing digital systems on Xilinx FPGAs. It supports RTL design entry, simulation, synthesis, implementation, and bitstream generation for a wide range of Xilinx devices including Artix-7, Zynq-7000, and others.

## 2. Installation

**System Requirements:**
- OS: Windows 10/11 (64-bit) or Ubuntu 20.04+
- RAM: 8 GB minimum (16  GB recommended)
- Disk Space: At least 50 GB

**Steps:**
1. Visit: https://www.xilinx.com/support/download.html
2. Navigate to Products > Design Tools > Vivado Design Suite
3. Register and download the Vivado WebPACK edition
4. Run the installer and select:
   - Vivado HL WebPACK
   - Device family support (e.g., Artix-7 for Nexys A7)
5. Complete installation and license activation

## 3. Creating a New Vivado Project

1. Launch Vivado > Create Project
2. Set project name and location
3. Select RTL Project, enable 'Do not specify sources at this time'
4. Choose FPGA device (e.g., xc7a100tcsg324-1)
5. Click Finish

## 4. Adding Design Sources

- Go to Project Manager > Add Sources
- Choose "Add or Create Design Sources"
- Add files such as `and_gate.v`, `and_gate_tb.v`

**Example Verilog Module:**
```verilog
module and_gate(input A, input B, output Y);
    assign Y = A & B;
endmodule
```

## 5. Running Simulation

**Testbench:**
```verilog
module and_gate_tb;
    reg A, B;
    wire Y;

    and_gate uut (.A(A), .B(B), .Y(Y));

    initial begin
        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;
    end
endmodule
```

**Steps:**
- Select Run Simulation > Run Behavioral Simulation
- View waveforms to inspect outputs

## 6. Tips and Troubleshooting

- Use `$display` and `$monitor` in testbenches
- Use correct XDC constraint file for I/O pin mapping
- Check the Messages panel for warnings and errors

## 7. Conclusion

This lab introduced the Vivado environment and showed how to create a project, write Verilog code, simulate, and begin synthesis for FPGA development.
