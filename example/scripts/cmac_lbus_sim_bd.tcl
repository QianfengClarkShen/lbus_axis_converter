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

  set gt_rx [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_cmac_usplus:gt_ports:2.0 gt_rx ]

  set gt_tx [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_cmac_usplus:gt_ports:2.0 gt_tx ]

  set m_axis [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
   ] $m_axis

  set s_axis [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
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
   CONFIG.FREQ_HZ {322265625} \
 ] $bus_clk
  set init_clk [ create_bd_port -dir I -type clk init_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {rst} \
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

  # Create instance: CMAC_USPLUS, and set properties
  set CMAC_USPLUS [ addip cmac_usplus CMAC_USPLUS ]
  set_property -dict [ list \
   CONFIG.CMAC_CAUI4_MODE {1} \
   CONFIG.CMAC_CORE_SELECT {CMACE4_X0Y1} \
   CONFIG.GT_DRP_CLK {200.00} \
   CONFIG.GT_GROUP_SELECT {X0Y12~X0Y15} \
   CONFIG.GT_REF_CLK_FREQ {322.265625} \
   CONFIG.LANE10_GT_LOC {NA} \
   CONFIG.LANE1_GT_LOC {X0Y12} \
   CONFIG.LANE2_GT_LOC {X0Y13} \
   CONFIG.LANE3_GT_LOC {X0Y14} \
   CONFIG.LANE4_GT_LOC {X0Y15} \
   CONFIG.LANE5_GT_LOC {NA} \
   CONFIG.LANE6_GT_LOC {NA} \
   CONFIG.LANE7_GT_LOC {NA} \
   CONFIG.LANE8_GT_LOC {NA} \
   CONFIG.LANE9_GT_LOC {NA} \
   CONFIG.NUM_LANES {4} \
   CONFIG.RX_CHECK_PREAMBLE {1} \
   CONFIG.RX_CHECK_SFD {1} \
   CONFIG.RX_FLOW_CONTROL {0} \
   CONFIG.TX_FLOW_CONTROL {0} \
 ] $CMAC_USPLUS

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

  # Create instance: LOGIC_FALSE, and set properties
  set LOGIC_FALSE [ addip xlconstant LOGIC_FALSE ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $LOGIC_FALSE

  # Create instance: PREAMBLE, and set properties
  set PREAMBLE [ addip xlconstant PREAMBLE ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {56} \
 ] $PREAMBLE

  # Create instance: lbus_axis_converter_0, and set properties
  set lbus_axis_converter_0 [ addip lbus_axis_converter lbus_axis_converter_0 ]
  set_property -dict [ list \
   CONFIG.TX_OUTPUT_REG {true} \
 ] $lbus_axis_converter_0


  # Create instance: not_rx_aligned, and set properties
  set not_rx_aligned [ addip util_vector_logic not_rx_aligned ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $not_rx_aligned

  # Create instance: not_rx_reset, and set properties
  set not_rx_reset [ addip util_vector_logic not_rx_reset ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $not_rx_reset

  # Create instance: not_tx_reset, and set properties
  set not_tx_reset [ addip util_vector_logic not_tx_reset ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $not_tx_reset

  # Create instance: one_bit_and, and set properties
  set one_bit_and [ addip util_vector_logic one_bit_and ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $one_bit_and

  # Create interface connections
  connect_bd_intf_net -intf_net CMAC_USPLUS_gt_tx [get_bd_intf_ports gt_tx] [get_bd_intf_pins CMAC_USPLUS/gt_tx]
  connect_bd_intf_net -intf_net CMAC_USPLUS_lbus_rx [get_bd_intf_pins CMAC_USPLUS/lbus_rx] [get_bd_intf_pins lbus_axis_converter_0/cmac_lbus_rx]
  connect_bd_intf_net -intf_net gt_ref_1 [get_bd_intf_ports gt_ref] [get_bd_intf_pins CMAC_USPLUS/gt_ref_clk]
  connect_bd_intf_net -intf_net gt_rx_1 [get_bd_intf_ports gt_rx] [get_bd_intf_pins CMAC_USPLUS/gt_rx]
  connect_bd_intf_net -intf_net lbus_axis_converter_0_cmac_lbus_tx [get_bd_intf_pins CMAC_USPLUS/lbus_tx] [get_bd_intf_pins lbus_axis_converter_0/cmac_lbus_tx]
  connect_bd_intf_net -intf_net lbus_axis_converter_0_m_axis [get_bd_intf_ports m_axis] [get_bd_intf_pins lbus_axis_converter_0/m_axis]
  connect_bd_intf_net -intf_net s_axis_1 [get_bd_intf_ports s_axis] [get_bd_intf_pins lbus_axis_converter_0/s_axis]

  # Create port connections
  connect_bd_net -net CMAC_USPLUS_gt_txusrclk2 [get_bd_ports bus_clk] [get_bd_pins CMAC_USPLUS/gt_txusrclk2] [get_bd_pins CMAC_USPLUS/rx_clk] [get_bd_pins lbus_axis_converter_0/tx_clk] [get_bd_pins lbus_axis_converter_0/rx_clk]
  connect_bd_net -net CMAC_USPLUS_stat_rx_aligned [get_bd_ports rx_aligned] [get_bd_pins CMAC_USPLUS/ctl_tx_enable] [get_bd_pins CMAC_USPLUS/stat_rx_aligned] [get_bd_pins not_rx_aligned/Op1]
  connect_bd_net -net CMAC_USPLUS_usr_rx_reset [get_bd_pins CMAC_USPLUS/usr_rx_reset] [get_bd_pins not_rx_reset/Op1]
  connect_bd_net -net CMAC_USPLUS_usr_tx_reset [get_bd_pins CMAC_USPLUS/usr_tx_reset] [get_bd_pins not_tx_reset/Op1]
  connect_bd_net -net CMAC_dout [get_bd_pins CMAC_USPLUS/core_drp_reset] [get_bd_pins CMAC_USPLUS/core_rx_reset] [get_bd_pins CMAC_USPLUS/core_tx_reset] [get_bd_pins CMAC_USPLUS/ctl_rx_force_resync] [get_bd_pins CMAC_USPLUS/ctl_rx_test_pattern] [get_bd_pins CMAC_USPLUS/ctl_tx_send_idle] [get_bd_pins CMAC_USPLUS/ctl_tx_send_lfi] [get_bd_pins CMAC_USPLUS/ctl_tx_test_pattern] [get_bd_pins CMAC_USPLUS/drp_clk] [get_bd_pins CMAC_USPLUS/drp_en] [get_bd_pins CMAC_USPLUS/drp_we] [get_bd_pins CMAC_USPLUS/gtwiz_reset_rx_datapath] [get_bd_pins CMAC_USPLUS/gtwiz_reset_tx_datapath] [get_bd_pins LOGIC_FALSE/dout]
  connect_bd_net -net DRP_ADDR_dout [get_bd_pins CMAC_USPLUS/drp_addr] [get_bd_pins DRP_ADDR/dout]
  connect_bd_net -net DRP_DI_dout [get_bd_pins CMAC_USPLUS/drp_di] [get_bd_pins DRP_DI/dout]
  connect_bd_net -net GT_LOOPBACK_dout [get_bd_pins CMAC_USPLUS/gt_loopback_in] [get_bd_pins GT_LOOPBACK/dout]
  connect_bd_net -net PREAMBLE_dout [get_bd_pins CMAC_USPLUS/tx_preamblein] [get_bd_pins PREAMBLE/dout]
  connect_bd_net -net init_clk_1 [get_bd_ports init_clk] [get_bd_pins CMAC_USPLUS/init_clk]
  connect_bd_net -net not_rx_aligned_Res [get_bd_pins not_rx_aligned/Res] [get_bd_pins one_bit_and/Op1]
  connect_bd_net -net not_rx_reset_Res [get_bd_pins CMAC_USPLUS/ctl_rx_enable] [get_bd_pins not_rx_reset/Res]
  connect_bd_net -net not_tx_reset_Res [get_bd_pins not_tx_reset/Res] [get_bd_pins one_bit_and/Op2]
  connect_bd_net -net rst_0_1 [get_bd_ports usr_rst] [get_bd_pins lbus_axis_converter_0/tx_rst] [get_bd_pins lbus_axis_converter_0/rx_rst]
  connect_bd_net -net sys_reset_0_1 [get_bd_ports rst] [get_bd_pins CMAC_USPLUS/sys_reset]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins CMAC_USPLUS/ctl_tx_send_rfi] [get_bd_pins one_bit_and/Res]

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


