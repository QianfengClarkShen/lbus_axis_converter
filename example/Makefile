sim: cmac_lbus_sim inkl_lbus_sim
cmac_lbus_sim: scripts/cmac_lbus_sim.tcl scripts/cmac_lbus_sim_bd.tcl
	rm -rf cmac_lbus_sim
	vivado -mode tcl -source scripts/cmac_lbus_sim.tcl -nolog -nojournal
inkl_lbus_sim: scripts/inkl_lbus_sim.tcl scripts/inkl_lbus_sim_bd.tcl
	rm -rf inkl_lbus_sim
	vivado -mode tcl -source scripts/inkl_lbus_sim.tcl -nolog -nojournal
clean:
	rm -rf cmac_lbus_sim inkl_lbus_sim .Xil
