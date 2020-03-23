set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "lbus_axis_converter"
set script_dir [file dirname [file normalize [info script]]]

create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i

set source_repo "${project_dir}/../../src"
set interface_repo "${project_dir}/../interfaces"
import_files -norecurse [glob ${source_repo}/*.v]

ipx::package_project -root_dir ${project_dir}/${project_name}/${project_name}.srcs/sources_1 -vendor clarkshen.com -library user -taxonomy /UserIP
set_property vendor_display_name {clarkshen.com} [ipx::current_core]
set_property name $project_name [ipx::current_core]
set_property display_name $project_name [ipx::current_core]
set_property description $project_name [ipx::current_core]
set_property core_revision 2 [ipx::current_core]

#cmac
foreach bus {cmac_lbus_tx cmac_lbus_rx} direction {tx rx} type {master slave} {
	ipx::add_bus_interface $bus [ipx::current_core]
	set_property abstraction_type_vlnv xilinx.com:display_cmac_usplus:lbus_ports:2.0 [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
	set_property bus_type_vlnv xilinx.com:display_cmac_usplus:lbus_ports_int:2.0 [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
	set_property interface_mode $type [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
	set_property display_name lbus_${direction} [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]

	foreach field {data ena sop eop err mty} {
		for {set i 0} {$i < 4} {incr i} {
			ipx::add_port_map lbus_seg${i}_${field} [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
			set_property physical_name ${direction}_lbus_seg${i}_${field} [ipx::get_port_maps lbus_seg${i}_${field} -of_objects [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]]
		}
	}
}
ipx::add_port_map tx_rdyout [ipx::get_bus_interfaces cmac_lbus_tx -of_objects [ipx::current_core]]
set_property physical_name tx_lbus_ready [ipx::get_port_maps tx_rdyout -of_objects [ipx::get_bus_interfaces cmac_lbus_tx -of_objects [ipx::current_core]]]

#interlaken
foreach bus {inkl_lbus_tx inkl_lbus_rx} direction {tx rx} type {master slave} {
    ipx::add_bus_interface $bus [ipx::current_core]
    set_property abstraction_type_vlnv xilinx.com:display_interlaken:lbus_ports:2.0 [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
    set_property bus_type_vlnv xilinx.com:display_interlaken:lbus_ports_int:2.0 [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
    set_property interface_mode $type [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
    set_property display_name lbus_${direction} [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]

    foreach field {data ena sop eop err mty} {
        for {set i 0} {$i < 4} {incr i} {
            ipx::add_port_map lbus_seg${i}_${field} [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
            set_property physical_name ${direction}_lbus_seg${i}_${field} [ipx::get_port_maps lbus_seg${i}_${field} -of_objects [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]]
        }
    }
}

ipx::add_port_map tx_rdyout [ipx::get_bus_interfaces inkl_lbus_tx -of_objects [ipx::current_core]]
set_property physical_name tx_lbus_ready [ipx::get_port_maps tx_rdyout -of_objects [ipx::get_bus_interfaces inkl_lbus_tx -of_objects [ipx::current_core]]]

set bus inkl_lbus_tx
for {set i 0} {$i < 4} {incr i} {
	ipx::add_port_map tx_bctlin${i} [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
	set_property physical_name tx_lbus_seg${i}_bctlin_out [ipx::get_port_maps tx_bctlin${i} -of_objects [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]]
}

foreach bus {inkl_lbus_tx inkl_lbus_rx} direction {tx rx} field {chan_out chan_in} {
	for {set i 0} {$i < 4} {incr i} {
		ipx::add_port_map lbus_seg${i}_chan [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]
		set_property physical_name ${direction}_lbus_seg${i}_${field} [ipx::get_port_maps lbus_seg${i}_chan -of_objects [ipx::get_bus_interfaces $bus -of_objects [ipx::current_core]]]
	}
}

foreach bus {cmac_lbus_tx cmac_lbus_rx inkl_lbus_tx inkl_lbus_rx} {
	ipx::associate_bus_interfaces -busif cmac_lbus_tx -clock clk [ipx::current_core]
}

set_property widget {comboBox} [ipgui::get_guiparamspec -name "ENDIANNESS" -component [ipx::current_core] ]
set_property value_validation_type pairs [ipx::get_user_parameters ENDIANNESS -of_objects [ipx::current_core]]
set_property value_validation_pairs {{Big Endian} 1 {Small Endian} 0} [ipx::get_user_parameters ENDIANNESS -of_objects [ipx::current_core]]
set_property widget {comboBox} [ipgui::get_guiparamspec -name "ENABLE_ILKN_PORTS" -component [ipx::current_core] ]
set_property value_validation_type pairs [ipx::get_user_parameters ENABLE_ILKN_PORTS -of_objects [ipx::current_core]]
set_property value_validation_pairs {CMAC 0 Interlaken 1} [ipx::get_user_parameters ENABLE_ILKN_PORTS -of_objects [ipx::current_core]]
set_property display_name {TX output register} [ipgui::get_guiparamspec -name "TX_OUTPUT_REG" -component [ipx::current_core] ]
set_property widget {checkBox} [ipgui::get_guiparamspec -name "TX_OUTPUT_REG" -component [ipx::current_core] ]
set_property value true [ipx::get_user_parameters TX_OUTPUT_REG -of_objects [ipx::current_core]]
set_property value true [ipx::get_hdl_parameters TX_OUTPUT_REG -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_user_parameters TX_OUTPUT_REG -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_hdl_parameters TX_OUTPUT_REG -of_objects [ipx::current_core]]
set_property display_name {Interface} [ipgui::get_guiparamspec -name "ENABLE_ILKN_PORTS" -component [ipx::current_core]]
set_property display_name {AXI-4 Stream Endianness} [ipgui::get_guiparamspec -name "ENDIANNESS" -component [ipx::current_core]]
set_property value false [ipx::get_user_parameters TX_OUTPUT_REG -of_objects [ipx::current_core]]
set_property value false [ipx::get_hdl_parameters TX_OUTPUT_REG -of_objects [ipx::current_core]]

foreach direction {tx tx tx tx rx rx} field {chan_in chan_out bctlin_in bctlin_out chan_in chan_out} {
	for {set i 0} {$i < 4} {incr i} {
		set_property driver_value 0 [ipx::get_ports ${direction}_lbus_seg${i}_${field} -of_objects [ipx::current_core]]
		set_property enablement_dependency {$ENABLE_ILKN_PORTS = 1} [ipx::get_ports ${direction}_lbus_seg${i}_${field} -of_objects [ipx::current_core]]
	}
}
set_property driver_value 0 [ipx::get_ports tx_lbus_ready_out -of_objects [ipx::current_core]]
set_property enablement_dependency {$ENABLE_ILKN_PORTS = 1} [ipx::get_ports tx_lbus_ready_out -of_objects [ipx::current_core]]
set_property enablement_dependency {$ENABLE_ILKN_PORTS = 0} [ipx::get_bus_interfaces cmac_lbus_tx -of_objects [ipx::current_core]]
set_property enablement_dependency {$ENABLE_ILKN_PORTS = 0} [ipx::get_bus_interfaces cmac_lbus_rx -of_objects [ipx::current_core]]
set_property enablement_dependency {$ENABLE_ILKN_PORTS = 1} [ipx::get_bus_interfaces inkl_lbus_tx -of_objects [ipx::current_core]]
set_property enablement_dependency {$ENABLE_ILKN_PORTS = 1} [ipx::get_bus_interfaces inkl_lbus_rx -of_objects [ipx::current_core]]

set_property supported_families {virtexu Beta virtexuplus Beta virtexuplusHBM Beta zynquplus Beta kintexu Beta kintexuplus Beta} [ipx::current_core]
set_property core_revision 0 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::check_integrity -quiet [ipx::current_core]
ipx::archive_core $project_dir/$project_name/${project_name}_1.0.zip [ipx::current_core]
close_project
exit

