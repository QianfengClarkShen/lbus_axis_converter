run_cmac_simulation: gen_ip
	make -C example run_cmac_sim
run_interlaken_simulation: gen_ip
	make -C example run_inkl_sim
gen_ip:
	make -C ip_repo
clean:
	make -C example clean
	make -C ip_repo clean
