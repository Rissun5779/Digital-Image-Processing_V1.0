# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


package require -exact qsys 12.1

# 
# module altera_eth_tse_nf_lvds_terminator
# 
set_module_property NAME altera_eth_tse_nf_lvds_terminator
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION "18.1"
set_module_property INTERNAL true
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property HIDE_FROM_SOPC true
set_module_property ELABORATION_CALLBACK elaborate

# Source the common parameters for TSE
source ../../altera_eth_tse/altera_eth_tse_common_constants.tcl

#################################################################################################
# Global parameter
#################################################################################################
array set lvds_port_list {
   pll_locked_tx                    {export                 Input    1}
   pll_locked_rx                    {export                 Input    1}
   pll_areset_tx                    {export                 Output   1}
   pll_areset_rx                    {export                 Output   1}
   rx_coreclock                     {export                 Input    1}
   lvds_tx_inclock                  {export                 Output   1}
   lvds_rx_inclock                  {export                 Output   1}
}

array set lvds_port_variable_width_list {
   rx_out                           {export                 Input    10}
   tx_in                            {export                 Output   10}
   rx_in                            {export                 Output   1}
   tx_out                           {export                 Input    1}
   rx_divfwdclk                     {export                 Input    1}
   rx_dpa_reset                     {export                 Output   1}
   rx_dpa_locked                    {export                 Input    1}
}

array set lvds_port_per_channel_list {
   tbi_tx_d_muxed                   {tbi_tx_d_muxed         Input    10}
   tbi_rx_d_lvds                    {tbi_rx_d_lvds          Output   10}
   tbi_rx_clk                       {tbi_rx_clk             Output   1}
   rx_reset_sequence_done           {rx_reset_sequence_done Output   1}
   rx_reset                         {rx_reset               Output   1}
   tx_reset                         {tx_reset               Output   1}
}

#################################################################################################
# Add synthesis and simulation fileset callback
#################################################################################################
add_fileset synthesis_fileset QUARTUS_SYNTH fileset_cb
add_fileset sim_ver_fileset SIM_VERILOG fileset_sim_cb
add_fileset sim_vhd_fileset SIM_VHDL fileset_sim_cb

#################################################################################################
# Parameters
#################################################################################################
add_parameter NUM_CHANNELS INTEGER 1
set_parameter_property NUM_CHANNELS HDL_PARAMETER 1
set_parameter_property NUM_CHANNELS ALLOWED_RANGES {1 4 8 10 12}

add_parameter SYNCHRONIZER_DEPTH INTEGER 3
set_parameter_property SYNCHRONIZER_DEPTH HDL_PARAMETER 3

#################################################################################################
# Elaboration callback
#################################################################################################
proc elaborate {} {
   set hdl_top_module altera_eth_tse_nf_lvds_terminator
   
   global PMA_SERIAL_CP_NAME
   global lvds_port_list
   global lvds_port_variable_width_list
   global lvds_port_per_channel_list

   set NUM_CHANNELS [get_parameter_value NUM_CHANNELS]

   # LVDS clockin
   add_interface lvds_inclock clock end
   add_interface_port lvds_inclock lvds_inclock clk Input 1

   # Reset
   add_interface reset_in reset end
   set_interface_property reset_in associatedClock lvds_inclock
   set_interface_property reset_in synchronousEdges DEASSERT
   set_interface_property reset_in ENABLED true
   add_interface_port reset_in reset reset Input 1

   # Interfaces to the lvds and pcs
   foreach {lvds_port} [array names lvds_port_list] {
      set role [lindex $lvds_port_list($lvds_port) 0]
      set direction [lindex $lvds_port_list($lvds_port) 1]
      set width [lindex $lvds_port_list($lvds_port) 2]

      add_interface $lvds_port conduit end
      add_interface_port $lvds_port $lvds_port $role $direction $width
   }

   foreach {lvds_port} [array names lvds_port_variable_width_list] {
      set role [lindex $lvds_port_variable_width_list($lvds_port) 0]
      set direction [lindex $lvds_port_variable_width_list($lvds_port) 1]
      set width [lindex $lvds_port_variable_width_list($lvds_port) 2]

      add_interface $lvds_port conduit end
      add_interface_port $lvds_port $lvds_port $role $direction [expr $width * $NUM_CHANNELS]
	  set_port_property $lvds_port vhdl_type std_logic_vector 
   }

   for {set index 0} { $index < 12} {incr index} {
      # Serial conduit interface
      add_interface $PMA_SERIAL_CP_NAME\_$index conduit end
      add_interface_port $PMA_SERIAL_CP_NAME\_$index rxp_$index "export" Input 1
      add_interface_port $PMA_SERIAL_CP_NAME\_$index txp_$index "export" Output 1
      if {$index < $NUM_CHANNELS} {
         set_interface_property $PMA_SERIAL_CP_NAME\_$index ENABLED true
      } else {
         set_interface_property $PMA_SERIAL_CP_NAME\_$index ENABLED false
      }

      foreach {lvds_port} [array names lvds_port_per_channel_list] {
         set role [lindex $lvds_port_per_channel_list($lvds_port) 0]
         set direction [lindex $lvds_port_per_channel_list($lvds_port) 1]
         set width [lindex $lvds_port_per_channel_list($lvds_port) 2]

         add_interface $lvds_port\_$index conduit end
         add_interface_port $lvds_port\_$index $lvds_port\_$index $role $direction $width
         if {$index < $NUM_CHANNELS} {
            set_interface_property $lvds_port\_$index ENABLED true
         } else {
            set_interface_property $lvds_port\_$index ENABLED false
         }
      }
   }

   # Set the fileset top level
   set_fileset_property synthesis_fileset TOP_LEVEL $hdl_top_module
   set_fileset_property sim_ver_fileset TOP_LEVEL $hdl_top_module
   set_fileset_property sim_vhd_fileset TOP_LEVEL $hdl_top_module
}

#################################################################################################
# Synthesis and simulation fileset callback
#################################################################################################
proc fileset_cb {entityname} {
   set rtl_files {
      altera_eth_tse_std_synchronizer.v               VERILOG
      altera_eth_tse_nf_lvds_terminator.v             VERILOG
      altera_tse_reset_synchronizer.v                 VERILOG
      altera_tse_nf_lvds_channel_reset_sequencer.v    VERILOG
      altera_tse_nf_lvds_common_reset_sequencer.v     VERILOG
   }
   
   foreach {file_name filetype} $rtl_files {
      add_fileset_file $file_name $filetype PATH $file_name {SYNTHESIS}
   }
   
    # Standard Synchronizer
    set std_sync_path [file join .. .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $std_sync_path
}

proc fileset_sim_cb {entityname} {
   set rtl_files {
      altera_eth_tse_std_synchronizer.v               VERILOG
      altera_eth_tse_nf_lvds_terminator.v             VERILOG
      altera_tse_reset_synchronizer.v                 VERILOG
      altera_tse_nf_lvds_channel_reset_sequencer.v    VERILOG
      altera_tse_nf_lvds_common_reset_sequencer.v     VERILOG
   }

   # Simulation files
   foreach {file_name filetype} $rtl_files {
      if {1} {
         add_fileset_file mentor/$file_name $filetype\_ENCRYPT PATH mentor/$file_name  {MENTOR_SPECIFIC}
      }
      if {1} {
         add_fileset_file aldec/$file_name $filetype\_ENCRYPT PATH aldec/$file_name  {ALDEC_SPECIFIC}
      }
      if {1} {
         add_fileset_file synopsys/$file_name $filetype\_ENCRYPT PATH synopsys/$file_name  {SYNOPSYS_SPECIFIC}
      }
      if {1} {
         add_fileset_file cadence/$file_name $filetype\_ENCRYPT PATH cadence/$file_name  {CADENCE_SPECIFIC}
      }
   }
   
    # Standard Synchronizer
    set std_sync_path [file join .. .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $std_sync_path
}
