# lbus_axis_converter
Lbus to AXI4-Stream converter in verilog

## IP core installation
1. download the git repo
2. run 'make gen_ip'
3. In Vivado, using "IP Catalog" to add <path_to_this_git_repo/ip_repo> as a new user ip repository.

## Features

Support AXI4-Stream to LBUS and LBUS to AXI4-Stream

Support bridge with Xilinx CMAC or Interlaken core

## Performance and Resource Usage

### Latency 

AXI4-Stream to LBUS Latency: 0 cycle or 1 cycle (depends on if TX register is enabled)

LBUS to AXI4-Stream Latency: 0 cycle or 1 cycle (depends on if RX register is enabled)

### Clock Frequency

Up to 400 MHz for xczu19eg-ffvc1760-2-i

### Resource Usage (take xczu19eg-ffvc1760-2-i as an example, usage varies based on different synthesis parameters)

|          Site Type         |    Used   |
| -------------------------- | --------- |
| CLB LUTs*                  | 2000~3000 |
| CLB Registers as Flip Flop | 1000~2100 |
| Block RAM Tile             |    0      |
| URAM                       |    0      |
| DSPs                       |    0      |
