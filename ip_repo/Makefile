lbus_axis_converter: $(shell find ../src -name *.v)
	rm -rf lbus_axis_converter
	vivado -nolog -nojournal -mode tcl -source scripts/lbus_axis_converter.tcl

clean:
	rm -rf lbus_axis_converter
