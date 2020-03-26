################################################################
# This is a generated script based on design: lbus_sim
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

variable design_name
set design_name lbus_sim

create_bd_design $design_name

# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set gt_ref [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_ref ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
   ] $gt_ref

  set gt_rx [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_interlaken:gt_ports:2.0 gt_rx ]

  set gt_tx [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_interlaken:gt_ports:2.0 gt_tx ]

  set m_axis [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {298767066} \
   ] $m_axis

  set s_axis [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {298767066} \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $s_axis


  # Create ports
  set bus_clk [ create_bd_port -dir O -type clk bus_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axis:m_axis} \
   CONFIG.ASSOCIATED_RESET {usr_rst} \
   CONFIG.FREQ_HZ {298767066} \
 ] $bus_clk
  set init_clk [ create_bd_port -dir I -type clk init_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {rst} \
   CONFIG.FREQ_HZ {200000000} \
 ] $init_clk
  set rst [ create_bd_port -dir I -type rst rst ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $rst
  set rx_aligned [ create_bd_port -dir O rx_aligned ]
  set usr_rst [ create_bd_port -dir I -type rst usr_rst ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $usr_rst

  # Create instance: CHAN_IN, and set properties
  set CHAN_IN [ addip xlconstant CHAN_IN ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {11} \
 ] $CHAN_IN

  # Create instance: DRP_ADDR, and set properties
  set DRP_ADDR [ addip xlconstant DRP_ADDR ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {10} \
 ] $DRP_ADDR

  # Create instance: DRP_DI, and set properties
  set DRP_DI [ addip xlconstant DRP_DI ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {16} \
 ] $DRP_DI

  # Create instance: GT_LOOPBACK, and set properties
  set GT_LOOPBACK [ addip xlconstant GT_LOOPBACK ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {12} \
 ] $GT_LOOPBACK

  # Create instance: LANESTAT, and set properties
  set LANESTAT [ addip xlconstant LANESTAT ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {12} \
 ] $LANESTAT

  # Create instance: LOGIC_FALSE, and set properties
  set LOGIC_FALSE [ addip xlconstant LOGIC_FALSE ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $LOGIC_FALSE

  # Create instance: TX_ENABLE, and set properties
  set TX_ENABLE [ addip xlconstant TX_ENABLE ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ addip clk_wiz clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {24.82} \
   CONFIG.CLKOUT1_JITTER {73.499} \
   CONFIG.CLKOUT1_PHASE_ERROR {74.138} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {412} \
   CONFIG.CLKOUT2_JITTER {78.056} \
   CONFIG.CLKOUT2_PHASE_ERROR {74.138} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {300} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {11.125} \
   CONFIG.MMCM_CLKIN1_PERIOD {2.482} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.625} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
   CONFIG.MMCM_DIVCLK_DIVIDE {3} \
   CONFIG.NUM_OUT_CLKS {2} \
 ] $clk_wiz_0

  # Create instance: interlaken_0, and set properties
  set interlaken_0 [ addip interlaken interlaken_0 ]
  set_property -dict [ list \
   CONFIG.GT_DRP_CLK {200.00} \
   CONFIG.GT_REF_CLK_FREQ {322.265625} \
   CONFIG.GT_SELECT {X0Y16~X0Y19} \
   CONFIG.GT_TYPE {GTY} \
   CONFIG.ILKN_CORE_LOC {ILKNE4_X0Y2} \
   CONFIG.LANE10_GT_LOC {NA} \
   CONFIG.LANE11_GT_LOC {NA} \
   CONFIG.LANE12_GT_LOC {NA} \
   CONFIG.LANE1_GT_LOC {X0Y16} \
   CONFIG.LANE2_GT_LOC {X0Y17} \
   CONFIG.LANE3_GT_LOC {X0Y18} \
   CONFIG.LANE4_GT_LOC {X0Y19} \
   CONFIG.LANE5_GT_LOC {NA} \
   CONFIG.LANE6_GT_LOC {NA} \
   CONFIG.LANE7_GT_LOC {NA} \
   CONFIG.LANE8_GT_LOC {NA} \
   CONFIG.LANE9_GT_LOC {NA} \
   CONFIG.LINE_RATE {25.78125} \
   CONFIG.NUM_LANES {4} \
 ] $interlaken_0

  # Create instance: lbus_axis_converter_0, and set properties
  set lbus_axis_converter_0 [ addip lbus_axis_converter lbus_axis_converter_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ILKN_PORTS {1} \
   CONFIG.TX_OUTPUT_REG {true} \
 ] $lbus_axis_converter_0

  # Create instance: vivado_is_so_smart_0, and set properties
  set block_name vivado_is_so_smart
  set block_cell_name vivado_is_so_smart_0
  if { [catch {set vivado_is_so_smart_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $vivado_is_so_smart_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net gt_ref_1 [get_bd_intf_ports gt_ref] [get_bd_intf_pins interlaken_0/gt_ref_clk0_port]
  connect_bd_intf_net -intf_net gt_rx_0_1 [get_bd_intf_ports gt_rx] [get_bd_intf_pins interlaken_0/gt_rx]
  connect_bd_intf_net -intf_net interlaken_0_gt_tx [get_bd_intf_ports gt_tx] [get_bd_intf_pins interlaken_0/gt_tx]
  connect_bd_intf_net -intf_net interlaken_0_lbus_rx [get_bd_intf_pins interlaken_0/lbus_rx] [get_bd_intf_pins lbus_axis_converter_0/inkl_lbus_rx]
  connect_bd_intf_net -intf_net lbus_axis_converter_0_inkl_lbus_tx [get_bd_intf_pins interlaken_0/lbus_tx] [get_bd_intf_pins lbus_axis_converter_0/inkl_lbus_tx]
  connect_bd_intf_net -intf_net lbus_axis_converter_0_m_axis [get_bd_intf_ports m_axis] [get_bd_intf_pins lbus_axis_converter_0/m_axis]
  connect_bd_intf_net -intf_net s_axis_1 [get_bd_intf_ports s_axis] [get_bd_intf_pins lbus_axis_converter_0/s_axis]

  # Create port connections
  connect_bd_net -net CHAN_IN_dout [get_bd_pins CHAN_IN/dout] [get_bd_pins lbus_axis_converter_0/tx_lbus_seg0_chan_in] [get_bd_pins lbus_axis_converter_0/tx_lbus_seg1_chan_in] [get_bd_pins lbus_axis_converter_0/tx_lbus_seg2_chan_in] [get_bd_pins lbus_axis_converter_0/tx_lbus_seg3_chan_in]
  connect_bd_net -net DRP_ADDR_dout [get_bd_pins DRP_ADDR/dout] [get_bd_pins interlaken_0/drp_addr]
  connect_bd_net -net DRP_DI_dout [get_bd_pins DRP_DI/dout] [get_bd_pins interlaken_0/drp_di]
  connect_bd_net -net GT_LOOPBACK_dout [get_bd_pins GT_LOOPBACK/dout] [get_bd_pins interlaken_0/gt_loopback_in]
  connect_bd_net -net LANESTAT_dout [get_bd_pins LANESTAT/dout] [get_bd_pins interlaken_0/ctl_tx_diagword_lanestat]
  connect_bd_net -net LOGIC_FALSE_dout [get_bd_pins LOGIC_FALSE/dout] [get_bd_pins interlaken_0/core_drp_reset] [get_bd_pins interlaken_0/core_rx_reset] [get_bd_pins interlaken_0/core_tx_reset] [get_bd_pins interlaken_0/ctl_rx_force_resync] [get_bd_pins interlaken_0/ctl_tx_diagword_intfstat] [get_bd_pins interlaken_0/drp_clk] [get_bd_pins interlaken_0/drp_en] [get_bd_pins interlaken_0/drp_we] [get_bd_pins interlaken_0/gtwiz_reset_rx_datapath] [get_bd_pins interlaken_0/gtwiz_reset_tx_datapath] [get_bd_pins interlaken_0/lockedn] [get_bd_pins lbus_axis_converter_0/tx_lbus_seg0_bctlin_in] [get_bd_pins lbus_axis_converter_0/tx_lbus_seg1_bctlin_in] [get_bd_pins lbus_axis_converter_0/tx_lbus_seg2_bctlin_in] [get_bd_pins lbus_axis_converter_0/tx_lbus_seg3_bctlin_in]
  connect_bd_net -net TX_ENABLE_dout [get_bd_pins TX_ENABLE/dout] [get_bd_pins interlaken_0/ctl_tx_enable]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins vivado_is_so_smart_0/wire1_in]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_ports bus_clk] [get_bd_pins interlaken_0/lbus_clk] [get_bd_pins vivado_is_so_smart_0/wire2_out]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins lbus_axis_converter_0/tx_clk] [get_bd_pins lbus_axis_converter_0/rx_clk] [get_bd_pins vivado_is_so_smart_0/wire2_in]
  connect_bd_net -net init_clk_1 [get_bd_ports init_clk] [get_bd_pins interlaken_0/init_clk]
  connect_bd_net -net interlaken_0_gt_txusrclk2 [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins interlaken_0/gt_txusrclk2]
  connect_bd_net -net interlaken_0_stat_rx_aligned [get_bd_ports rx_aligned] [get_bd_pins interlaken_0/stat_rx_aligned]
  connect_bd_net -net rst_0_1 [get_bd_ports usr_rst] [get_bd_pins lbus_axis_converter_0/tx_rst] [get_bd_pins lbus_axis_converter_0/rx_rst]
  connect_bd_net -net rst_1 [get_bd_ports rst] [get_bd_pins clk_wiz_0/reset] [get_bd_pins interlaken_0/sys_reset]
  connect_bd_net -net vivado_is_so_smart_0_wire1_out [get_bd_pins interlaken_0/core_clk] [get_bd_pins vivado_is_so_smart_0/wire1_out]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


