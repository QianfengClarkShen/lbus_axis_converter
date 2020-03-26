set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "cmac_lbus_sim"
set script_dir [file dirname [file normalize [info script]]]
open_project ${project_dir}/${project_name}/${project_name}.xpr
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
generate_target Simulation [get_files ${project_dir}/${project_name}/${project_name}.srcs/sources_1/bd/lbus_sim/lbus_sim.bd]
export_ip_user_files -of_objects [get_files ${project_dir}/${project_name}/${project_name}.srcs/sources_1/bd/lbus_sim/lbus_sim.bd] -no_script -sync -force -quiet
export_simulation -of_objects [get_files ${project_dir}/${project_name}/${project_name}.srcs/sources_1/bd/lbus_sim/lbus_sim.bd] -directory ${project_dir}/${project_name}/${project_name}.ip_user_files/sim_scripts -ip_user_files_dir ${project_dir}/${project_name}/${project_name}.ip_user_files -ipstatic_source_dir ${project_dir}/${project_name}/${project_name}.ip_user_files/ipstatic -use_ip_compiled_libs -force -quiet
launch_simulation
run all
put "type <start_gui> to see the waveform "
