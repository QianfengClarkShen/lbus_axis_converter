# lbus_axis_converter
Lbus to AXI4-Stream converter in verilog

## Features

Support AXI4-Stream to LBUS and LBUS to AXI4-Stream
Support bridge with Xilinx CMAC or Interlaken core

## Performance and Resource Usage

### Latency 

AXI4-Stream to LBUS Latency: 0 cycle or 1 cycle (depends on if TX register is chosen)
LBUS to AXI4-Stream Latency: 0 cycle

### Clock Frequency

Up to 400 MHz for xczu19eg-ffvc1760-2-i

### Resource Usage (take xczu19eg-ffvc1760-2-i as an example)

|          Site Type         | Used | Fixed | Available | Util% |
| -------------------------- | ---- | ----- | --------- | ----- |
| CLB LUTs*                  | 2621 |     0 |    522720 |  0.50 |
|   LUT as Logic             | 2077 |     0 |    522720 |  0.40 |
|   LUT as Memory            |  544 |     0 |    161280 |  0.34 |
|     LUT as Distributed RAM |  544 |     0 |           |       |
|     LUT as Shift Register  |    0 |     0 |           |       |
| CLB Registers              | 1517 |     0 |   1045440 |  0.15 |
|   Register as Flip Flop    | 1517 |     0 |   1045440 |  0.15 |
|   Register as Latch        |    0 |     0 |   1045440 |  0.00 |
| CARRY8                     |    0 |     0 |     65340 |  0.00 |
| F7 Muxes                   |    0 |     0 |    261360 |  0.00 |
| F8 Muxes                   |    0 |     0 |    130680 |  0.00 |
| F9 Muxes                   |    0 |     0 |     65340 |  0.00 |
| Block RAM Tile             |    0 |     0 |       984 |  0.00 |
|   RAMB36/FIFO*             |    0 |     0 |       984 |  0.00 |

|   RAMB18                   |    0 |     0 |      1968 |  0.00 |
| URAM                       |    0 |     0 |       128 |  0.00 |
| DSPs                       |    0 |     0 |      1968 |  0.00 |
