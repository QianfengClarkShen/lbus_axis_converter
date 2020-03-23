set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "inkl_lbus_sim"
set script_dir [file dirname [file normalize [info script]]]
create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
set_property ip_repo_paths "${project_dir}/../ip_repo/assembled_ips/" [current_project]
update_ip_catalog -rebuild
source $script_dir/util.tcl
import_files -norecurse [glob $project_dir/verilogs/*.v]
import_files -fileset sim_1 -norecurse [glob $project_dir/testbench/*.sv]
import_files -fileset sim_1 -norecurse [glob $project_dir/testbench/*.bin]
import_files -fileset sim_1 -norecurse [glob $project_dir/testbench/*.csv]

source $script_dir/${project_name}_bd.tcl

validate_bd_design
make_wrapper -files [get_files $project_dir/$project_name/${project_name}.srcs/sources_1/bd/lbus_sim/lbus_sim.bd] -top
add_files -norecurse $project_dir/$project_name/${project_name}.srcs/sources_1/bd/lbus_sim/hdl/lbus_sim_wrapper.v
save_bd_design

set_property top tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property -name {xsim.compile.xvlog.more_options} -value {-d SIM_SPEED_UP} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
close_project
exit
