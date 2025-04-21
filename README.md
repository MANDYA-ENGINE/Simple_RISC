# Simple RISC Processor 

![Verilog](https://img.shields.io/badge/Verilog-5C2D91?style=for-the-badge&logo=verilog&logoColor=white)
![RISC](https://img.shields.io/badge/RISC-Architecture-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge) 

A Verilog implementation of a Simple RISC (Reduced Instruction Set Computer) Processor. This project demonstrates a basic RISC processor architecture with various components including ALU and Control Unit.

---

## 📁 Project Structure

### Core Components
| Component | Description |
|-----------|-------------|
| `Simple_RISC_Processor.v` | Main processor module |
| `ALU.v` | Arithmetic Logic Unit |
| `CU.v` | Control Unit |
| `IF.v` | Instruction Fetch stage |
| `EX.v` | Execute stage |
| `MA.v` | Memory Access stage |
| `RW.v` | Register Write stage |
| `OF.v` | Operand Fetch stage |

### Testbenches
| Testbench | Description |
|-----------|-------------|
| `Simple_RISC_Processor_tb.v` | Main testbench |
| `ALU_tb.v` | ALU testbench |
| `CU_tb.v` | Control Unit testbench |
| `IF_tb.v` | Instruction Fetch testbench |
| `EX_tb.v` | Execute stage testbench |
| `MA_tb.v` | Memory Access testbench |
| `RW_tb.v` | Register Write testbench |
| `OF_tb.v` | Operand Fetch testbench |

### Input Files
| File | Description |
|------|-------------|
| `instructions.hex` | Instruction memory contents |
| `input.hex` | Input data for the processor |

---

## ✨ Features

- 🏗️ 5-stage architecture
- 🔧 Simple RISC 21 instruction set Architecture
- 🧪 Separate testbenches for each component
- 💾 Memory-mapped I/O
- 📝 Register file implementation

---

## 🚀 Getting Started

### Prerequisites

- Verilog simulator (e.g., ModelSim, Icarus Verilog)
- Basic understanding of RISC architecture

### Simulation

To simulate the processor:

1. Compile the Verilog files using your preferred simulator
2. Load the testbench
3. Run the simulation
4. Analyze the waveforms and outputs

---

## 📦 Project Organization

The project follows a modular design with separate components for each stage of the processor pipeline. Each component has its own testbench for verification.

---

## 📄 License

This project is open source and available under the MIT License.

---

## 👥 Authors

- [Ujwal](https://github.com/MANDYA-ENGINE)
- [PRAFUL](https://github.com/3xplore-wrld) 
