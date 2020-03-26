# lbus_axis_converter
LBUS to AXI4-Stream converter in verilog, tested in Vivado 2019.1

## IP core installation
1. download this git repo
2. run 'make gen_ip'
3. In Vivado, using "IP Catalog" to add <path_to_this_git_repo/ip_repo> as a new user ip repository.

## Example designs
There are example designs for Xilinx CMAC and Interlaken IP core.

To launch simulation with CMAC, run 'make run_cmac_simulation'

To launch simulation with Interlaken, run 'make run_interlaken_simulation'

## Features
Support AXI4-Stream to LBUS and LBUS to AXI4-Stream

Support bridge with Xilinx CMAC or Interlaken core

Support both small endian and big endian for AXI4-Stream

## Performance and Resource Usage

### Latency 
AXI4-Stream to LBUS Latency: 0 cycle or 1 cycle (depends on if TX register is enabled)

LBUS to AXI4-Stream Latency: 0 cycle or 1 cycle (depends on if RX register is enabled)

### Clock Frequency
Up to 400 MHz for xczu19eg-ffvc1760-2-i

### Resource Usage (take xczu19eg-ffvc1760-2-i as an example, usage varies based on different synthesis parameters)
|        Resource Type       |    Used   |
| -------------------------- | --------- |
| CLB LUTs                   | 2000~3000 |
| CLB Registers as Flip Flop | 1000~2100 |
| Block RAM Tile             |    0      |
| URAM                       |    0      |
| DSPs                       |    0      |
