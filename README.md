# FIFO_Project

This project implements a **parameterized FIFO system** with asymmetric data widths (write: 16-bit, read: 8-bit) on a **DE1-SoC FPGA** board. The design includes a FIFO controller and register file enabling half-word access, with precise flag handling for `empty` and `full` conditions.

---

## Project Overview

- **Objective:** Buffer and process 16-bit data entries using a dual-port FIFO, reading one 8-bit half at a time.
- **Design Highlights:**
  - Supports **half-word reads**, outputting upper half before lower half.
  - Designed using **SystemVerilog modules** for modularity and clarity.
  - Implements circular buffer logic with **full/empty status flags**.
  - Simulated and verified via custom **testbench**.

---

## Features

- **Half-word read FIFO**: Supports 16-bit writes and sequential 8-bit reads.
- **Circular Queue Logic**: Pointers managed in a looped memory space.
- **Stateful Flag Handling**: Ensures correct `empty` and `full` signaling.
- **Synchronous Write, Asynchronous Read**
- Modular SystemVerilog Design

---

## File Descriptions

| File              | Description |
|-------------------|-------------|
| `DE1_SoC.sv`       | Top-level integration module for the FPGA board |
| `FIFO.sv`          | Wrapper module connecting FIFO controller and memory |
| `FIFO_Control.sv`  | Controls pointer logic and half-word tracking |
| `reg_file.sv`      | Register file with 2×DATA_WIDTH memory cells |
| `buttonPress.sv`   | Debounces and handles push-button inputs |
| `seg7_hex.sv`      | Converts hex values for display on 7-segment displays |
| `ram16x8.v`        | 16×8 RAM module for reference or comparison |
| `ram16x8.mif`      | Memory initialization file |
| `EE371 Lab 2 Report.pdf` | Documentation and explanation of implementation |
| `README.md`        | This documentation file |

---

## How to Run

1. Open the project in **Quartus Prime**.
2. Compile the design files.
3. Load the `.sof` file to the **DE1-SoC** using USB Blaster.
4. Provide 16-bit input using switches or inputs.
5. Observe the sequential 8-bit read outputs and control flag behavior on LEDs.

---

## Hardware Requirements

- **DE1-SoC FPGA** development board
- **Quartus Prime Software**
- **USB Blaster** programming cable

---

## Skills Demonstrated

- Parameterized FIFO design and buffer control
- Synchronous state machine logic in SystemVerilog
- Multi-width data handling and pointer arithmetic
- Hardware debugging and waveform simulation
- Modular design and testbench-driven verification

---
