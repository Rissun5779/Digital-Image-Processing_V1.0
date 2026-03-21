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


# +-----------------------------------
# | request TCL package from ACDS 12.1
# |
package require -exact qsys 12.1
# |
# +-----------------------------------

# +-----------------------------------
# | module altera_eth_tse_pcs_pma_lvds
# |
set_module_property NAME altera_eth_tse_pcs_pma_lvds
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION "18.1"
set_module_property INTERNAL true
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property ANALYZE_HDL false
set_module_property HIDE_FROM_SOPC true

# Add synthesis and simulation fileset callback
add_fileset synthesis_fileset QUARTUS_SYNTH fileset_cb
add_fileset sim_ver_fileset SIM_VERILOG fileset_sim_cb
add_fileset sim_vhd_fileset SIM_VHDL fileset_sim_cb

#################################################################################################
# Global variables (constants)
#################################################################################################
source ../../altera_eth_tse/altera_eth_tse_common_constants.tcl

#################################################################################################
# HDL Parameters
#################################################################################################
array set pcs_hdl_parameters {
   "PHY_IDENTIFIER"           {INTEGER 0}
   "DEV_VERSION"              {INTEGER 0}
   "ENABLE_SGMII"             {BOOLEAN 0}
   "ENABLE_CLK_SHARING"       {BOOLEAN 0}
   "ENABLE_TIMESTAMPING"      {BOOLEAN 0}
   "SYNCHRONIZER_DEPTH"       {INTEGER 3}
   "DEVICE_FAMILY"            {STRING ""}
   "ENABLE_REV_LOOPBACK"      {BOOLEAN 0}
   "ENABLE_ECC"               {BOOLEAN 0}
}

foreach {param_name} [array names pcs_hdl_parameters] {
   set param_type [lindex $pcs_hdl_parameters($param_name) 0]
   set param_default_val [lindex $pcs_hdl_parameters($param_name) 1]

   add_parameter $param_name $param_type $param_default_val
   set_parameter_property $param_name HDL_PARAMETER 1
}

#################################################################################################
# Core parameters
#################################################################################################
add_parameter connect_to_mac BOOLEAN 0
set_parameter_property connect_to_mac DISPLAY_NAME "Connect this PCS to MAC"
add_parameter enable_use_internal_fifo BOOLEAN 0
add_parameter enable_hd_logic BOOLEAN 0

#################################################################################################
# Synthesis and simulation fileset callback
#################################################################################################
proc fileset_cb {entityname} {
   global pcs_rtl_files
   global common_rtl_files
   global lvds_rtl_files
   global pcs_ocp_files

   set top_level_file altera_eth_tse_pcs_pma_lvds.v

   add_fileset_file $top_level_file VERILOG PATH $top_level_file
   foreach {file_name filetype} $pcs_rtl_files {
      add_fileset_file $file_name $filetype PATH ../../altera_eth_tse/$file_name {SYNTHESIS}
   }
   
   foreach {file_name filetype} $lvds_rtl_files {
      add_fileset_file $file_name $filetype PATH ../../altera_eth_tse/$file_name {SYNTHESIS}
   }

   foreach {file_name filetype} $common_rtl_files {
      add_fileset_file $file_name $filetype PATH ../../altera_eth_tse/$file_name {SYNTHESIS}
   }

   foreach {file_name filetype} $pcs_ocp_files {
      add_fileset_file $file_name $filetype PATH ../../altera_eth_tse/$file_name {SYNTHESIS}
   }
   
   # Standard Synchronizer
   set std_sync_path [file join .. .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
   add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $std_sync_path
   
   sdc_file_gen
}

proc sdc_file_gen {} {
   set sdc_template "altera_eth_tse_pcs_pma_lvds.sdc"
   set sdc_out_file [create_temp_file altera_eth_tse_pcs_pma_lvds.sdc]
   set out [ open $sdc_out_file w ]
   set in [open $sdc_template r]

   # SDC file parameters
   # Mapping between SDC file parameter with core parameter
   set mac_sdc_parameters {
      IS_SGMII             ENABLE_SGMII
      CONNECT_TO_MAC       connect_to_mac
      IS_INT_FIFO          enable_use_internal_fifo
      IS_HD_LOGIC          enable_hd_logic
      ENABLE_REV_LOOPBACK  ENABLE_REV_LOOPBACK
      ENABLE_TIMESTAMPING  ENABLE_TIMESTAMPING
   }

   while {[gets $in line] != -1} {
      if [string match "*CORE_PARAMETERS*" $line] {
         puts $out $line

         foreach {sdc_param module_param} $mac_sdc_parameters {
            set param_value [get_parameter_value $module_param]
      
            if { [string match -nocase "BOOLEAN" [get_parameter_property $module_param TYPE]] } {
               # Convert boolean parameter to 0/1 value
               if {[get_parameter_value $module_param]} {
                  puts $out "set $sdc_param 1"
               } else {
                  puts $out "set $sdc_param 0"
               }
            } else {
               puts $out "set $sdc_param $param_value"
            }
         }

      } else {
         puts $out $line
      }
   }
   close $in
   close $out
   add_fileset_file altera_eth_tse_pcs_pma_lvds.sdc SDC PATH $sdc_out_file {SYNTHESIS}
}

proc fileset_sim_cb {entityname} {
   global pcs_rtl_files
   global common_rtl_files
   global lvds_rtl_files

   set top_level_file altera_eth_tse_pcs_pma_lvds.v

   # Simulation files
   if {1} {
      add_fileset_file mentor/$top_level_file   VERILOG_ENCRYPT PATH mentor/$top_level_file     {MENTOR_SPECIFIC}
   }
   if {1} {
      add_fileset_file aldec/$top_level_file    VERILOG_ENCRYPT PATH aldec/$top_level_file      {ALDEC_SPECIFIC}
   }
   if {1} {
      add_fileset_file synopsys/$top_level_file VERILOG_ENCRYPT PATH synopsys/$top_level_file   {SYNOPSYS_SPECIFIC}
   }
   if {1} {
      add_fileset_file cadence/$top_level_file   VERILOG_ENCRYPT PATH cadence/$top_level_file    {CADENCE_SPECIFIC}
   }

   # PCS files
   foreach {file_name filetype} $pcs_rtl_files {
      if {1} {
         add_fileset_file mentor/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/mentor/$file_name  {MENTOR_SPECIFIC}
      }
      if {1} {
         add_fileset_file aldec/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/aldec/$file_name  {ALDEC_SPECIFIC}
      }
      if {1} {
         add_fileset_file synopsys/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/synopsys/$file_name  {SYNOPSYS_SPECIFIC}
      }
      if {1} {
         add_fileset_file cadence/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/cadence/$file_name  {CADENCE_SPECIFIC}
      }
   }

   # LVDS files
   foreach {file_name filetype} $lvds_rtl_files {
      if {1} {
         add_fileset_file mentor/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/mentor/$file_name  {MENTOR_SPECIFIC}
      }
      if {1} {
         add_fileset_file aldec/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/aldec/$file_name  {ALDEC_SPECIFIC}
      }
      if {1} {
         add_fileset_file synopsys/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/synopsys/$file_name  {SYNOPSYS_SPECIFIC}
      }
      if {1} {
         add_fileset_file cadence/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/cadence/$file_name  {CADENCE_SPECIFIC}
      }
   }

   # Common files
   foreach {file_name filetype} $common_rtl_files {
      if {1} {
         add_fileset_file mentor/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/mentor/$file_name  {MENTOR_SPECIFIC}
      }
      if {1} {
         add_fileset_file aldec/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/aldec/$file_name  {ALDEC_SPECIFIC}
      }
      if {1} {
         add_fileset_file synopsys/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/synopsys/$file_name  {SYNOPSYS_SPECIFIC}
      }
      if {1} {
         add_fileset_file cadence/$file_name $filetype\_ENCRYPT PATH ../../altera_eth_tse/cadence/$file_name  {CADENCE_SPECIFIC}
      }
   }
   
   # Standard Synchronizer
   set std_sync_path [file join .. .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
   add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $std_sync_path
}

#################################################################################################
# Elaboration callback
#################################################################################################
proc elaborate {} {
   set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]
   
   # Set the fileset top level module
   set_fileset_property synthesis_fileset TOP_LEVEL "altera_eth_tse_pcs_pma_lvds"
   set_fileset_property sim_ver_fileset TOP_LEVEL "altera_eth_tse_pcs_pma_lvds"
   set_fileset_property sim_vhd_fileset TOP_LEVEL "altera_eth_tse_pcs_pma_lvds"

   # Build interfaces connection point for this module
   build_interfaces
}

#################################################################################################
# Interfaces
#################################################################################################
proc build_interfaces {} {
   # Connection point names
   global AVALON_CP_NAME
   global AVALON_CLOCK_CP_NAME
   global AVALON_RESET_CP_NAME

   global PCS_TX_CLK_NAME
   global PCS_RX_CLK_NAME

   global PCS_TX_RESET_NAME
   global PCS_RX_RESET_NAME

   global PCS_GMII_CP_NAME
   global PCS_MII_CP_NAME

   global PCS_CLKENA_CP_NAME

   global PCS_SGMII_STATUS_CP_NAME
   global PCS_STATUS_LED_CP_NAME

   global PCS_REF_CLK_CP_NAME

   global PMA_SERIAL_CP_NAME
   global PCS_SERDES_CONTROL_CP_NAME
   
   global PCS_PHASE_MEASURE_CLK
   global RX_LATENCY_ADJ
   global TX_LATENCY_ADJ   
   global TX_PTP_ALIGNMENT   

   global WIRE_PCS_ECCSTATUS_CP_NAME

   set ENABLE_ECC [get_parameter_value ENABLE_ECC]
   set connect_to_mac [get_parameter_value connect_to_mac]

   # Avalon clock, reset and slave interface
   build_avalon_clock_interface $AVALON_CLOCK_CP_NAME
   build_avalon_reset_interface $AVALON_CLOCK_CP_NAME $AVALON_RESET_CP_NAME
   build_avalon_slave_interface $AVALON_CLOCK_CP_NAME $AVALON_RESET_CP_NAME $AVALON_CP_NAME

   build_ref_clk_clock_interface $PCS_REF_CLK_CP_NAME

   # PCS clock enable
   # GMII
   # MII
   # SGMII status
   build_pcs_misc_interfaces $PCS_CLKENA_CP_NAME $PCS_GMII_CP_NAME $PCS_MII_CP_NAME $PCS_SGMII_STATUS_CP_NAME
   
   # PCS clocks and resets
   build_pcs_clock_reset_interface $PCS_TX_CLK_NAME $PCS_RX_CLK_NAME $PCS_TX_RESET_NAME $PCS_RX_RESET_NAME

   # Status LED   
   build_pcs_status_led_interface $PCS_STATUS_LED_CP_NAME

   # SERDES control interface
   build_pcs_serdes_control_interface $PCS_SERDES_CONTROL_CP_NAME

   # Serial interface
   build_pma_serial_interface $PMA_SERIAL_CP_NAME
   
   # Timestamp signal for PHY
   build_phy_timestamp_interface $PCS_PHASE_MEASURE_CLK $RX_LATENCY_ADJ $TX_LATENCY_ADJ $TX_PTP_ALIGNMENT

   
   # ECC status
   build_eccstatus_conduit_interface $WIRE_PCS_ECCSTATUS_CP_NAME

   # Enable/disable the ECC status ports based on user parameter
   set_interface_property $WIRE_PCS_ECCSTATUS_CP_NAME ENABLED $ENABLE_ECC
}

proc build_avalon_clock_interface {args} {
   set AVALON_CLOCK_CP_NAME [lindex $args 0]

   add_interface $AVALON_CLOCK_CP_NAME clock end
   add_interface_port $AVALON_CLOCK_CP_NAME clk clk Input 1
   set_interface_property $AVALON_CLOCK_CP_NAME ENABLED true
}

proc build_avalon_reset_interface {args} {
   set AVALON_CLOCK_CP_NAME [lindex $args 0]
   set AVALON_RESET_CP_NAME [lindex $args 1]

   add_interface $AVALON_RESET_CP_NAME reset end
   set_interface_property $AVALON_RESET_CP_NAME associatedClock $AVALON_CLOCK_CP_NAME
   set_interface_property $AVALON_RESET_CP_NAME synchronousEdges DEASSERT
   set_interface_property $AVALON_RESET_CP_NAME ENABLED true
   add_interface_port $AVALON_RESET_CP_NAME reset reset Input 1
}

proc build_avalon_slave_interface {args} {
   set AVALON_CLOCK_CP_NAME [lindex $args 0]
   set AVALON_RESET_CP_NAME [lindex $args 1]
   set AVALON_CP_NAME [lindex $args 2]

   add_interface $AVALON_CP_NAME avalon end
   set_interface_property $AVALON_CP_NAME addressAlignment DYNAMIC
   set_interface_property $AVALON_CP_NAME readWaitTime 1
   set_interface_property $AVALON_CP_NAME writeWaitTime 1
   set_interface_property $AVALON_CP_NAME associatedClock $AVALON_CLOCK_CP_NAME
   set_interface_property $AVALON_CP_NAME associatedReset $AVALON_RESET_CP_NAME
   add_interface_port $AVALON_CP_NAME reg_addr address Input 5
   add_interface_port $AVALON_CP_NAME reg_data_out readdata Output 16
   add_interface_port $AVALON_CP_NAME reg_rd read Input 1
   add_interface_port $AVALON_CP_NAME reg_data_in writedata Input 16
   add_interface_port $AVALON_CP_NAME reg_wr write Input 1
   add_interface_port $AVALON_CP_NAME reg_busy waitrequest Output 1
}

proc build_ref_clk_clock_interface {args} {
   set PCS_REF_CLK_CP_NAME [lindex $args 0]

   add_interface $PCS_REF_CLK_CP_NAME clock end
   add_interface_port $PCS_REF_CLK_CP_NAME ref_clk clk Input 1
}

proc build_pcs_clock_reset_interface {args} {
   set PCS_TX_CLK_NAME [lindex $args 0]
   set PCS_RX_CLK_NAME [lindex $args 1]
   set PCS_TX_RESET_NAME [lindex $args 2]
   set PCS_RX_RESET_NAME [lindex $args 3]

   add_interface $PCS_TX_CLK_NAME clock source
   add_interface_port $PCS_TX_CLK_NAME tx_clk clk Output 1
   set_interface_property $PCS_TX_CLK_NAME ENABLED true

   add_interface $PCS_RX_CLK_NAME clock source
   add_interface_port $PCS_RX_CLK_NAME rx_clk clk Output 1
   set_interface_property $PCS_RX_CLK_NAME ENABLED true

   add_interface $PCS_TX_RESET_NAME reset end
   set_interface_property $PCS_TX_RESET_NAME associatedClock $PCS_TX_CLK_NAME
   set_interface_property $PCS_TX_RESET_NAME synchronousEdges DEASSERT
   set_interface_property $PCS_TX_RESET_NAME ENABLED true
   add_interface_port $PCS_TX_RESET_NAME reset_tx_clk reset Input 1

   add_interface $PCS_RX_RESET_NAME reset end
   set_interface_property $PCS_RX_RESET_NAME associatedClock $PCS_RX_CLK_NAME
   set_interface_property $PCS_RX_RESET_NAME synchronousEdges DEASSERT
   set_interface_property $PCS_RX_RESET_NAME ENABLED true
   add_interface_port $PCS_RX_RESET_NAME reset_rx_clk reset Input 1
}

proc build_pcs_misc_interfaces {args} {
   set PCS_CLKENA_CP_NAME [lindex $args 0] 
   set PCS_GMII_CP_NAME [lindex $args 1]
   set PCS_MII_CP_NAME [lindex $args 2]
   set PCS_SGMII_STATUS_CP_NAME [lindex $args 3]

   set connect_to_mac [get_parameter_value connect_to_mac]
   set ENABLE_SGMII [get_parameter_value ENABLE_SGMII]

   # Clock enables
   add_interface $PCS_CLKENA_CP_NAME conduit end
   add_interface_port $PCS_CLKENA_CP_NAME tx_clkena tx_clkena Output 1
   add_interface_port $PCS_CLKENA_CP_NAME rx_clkena rx_clkena Output 1
   set_interface_property $PCS_CLKENA_CP_NAME ENABLED $ENABLE_SGMII
   if {$connect_to_mac} {
      set_interface_property $PCS_CLKENA_CP_NAME ENABLED 1
   } else {
      set_interface_property $PCS_CLKENA_CP_NAME ENABLED $ENABLE_SGMII
   }

   # GMII
   add_interface $PCS_GMII_CP_NAME conduit end
   add_interface_port $PCS_GMII_CP_NAME gmii_rx_dv    gmii_rx_dv     Output   1
   add_interface_port $PCS_GMII_CP_NAME gmii_rx_d     gmii_rx_d      Output   8
   add_interface_port $PCS_GMII_CP_NAME gmii_rx_err   gmii_rx_err    Output   1
   add_interface_port $PCS_GMII_CP_NAME gmii_tx_en    gmii_tx_en     Input    1
   add_interface_port $PCS_GMII_CP_NAME gmii_tx_d     gmii_tx_d      Input    8
   add_interface_port $PCS_GMII_CP_NAME gmii_tx_err   gmii_tx_err    Input    1
   
   # MII
   add_interface $PCS_MII_CP_NAME conduit end
   add_interface_port $PCS_MII_CP_NAME mii_rx_dv      mii_rx_dv      Output   1
   add_interface_port $PCS_MII_CP_NAME mii_rx_d       mii_rx_d       Output   4
   add_interface_port $PCS_MII_CP_NAME mii_rx_err     mii_rx_err     Output   1
   add_interface_port $PCS_MII_CP_NAME mii_tx_en      mii_tx_en      Input    1
   add_interface_port $PCS_MII_CP_NAME mii_tx_d       mii_tx_d       Input    4
   add_interface_port $PCS_MII_CP_NAME mii_tx_err     mii_tx_err     Input    1
   add_interface_port $PCS_MII_CP_NAME mii_col        mii_col        Output   1
   add_interface_port $PCS_MII_CP_NAME mii_crs        mii_crs        Output   1
   if {$connect_to_mac} {
      set_interface_property $PCS_MII_CP_NAME ENABLED 1
   } else {
      set_interface_property $PCS_MII_CP_NAME ENABLED $ENABLE_SGMII
   }

   # SGMII Status
   add_interface $PCS_SGMII_STATUS_CP_NAME conduit end
   add_interface_port $PCS_SGMII_STATUS_CP_NAME set_10    set_10     Output   1
   add_interface_port $PCS_SGMII_STATUS_CP_NAME set_1000  set_1000   Output   1
   if {$connect_to_mac} {
      set_interface_property $PCS_SGMII_STATUS_CP_NAME ENABLED 1
   } else {
      set_interface_property $PCS_SGMII_STATUS_CP_NAME ENABLED $ENABLE_SGMII
   }

   if {$connect_to_mac} {
      # Terminate the following unused ports
      set UNUSED_WIRE_CP $PCS_SGMII_STATUS_CP_NAME\_UNUSED
      add_interface UNUSED_WIRE_CP conduit end
      set_interface_property UNUSED_WIRE_CP ENABLED false

      add_interface_port UNUSED_WIRE_CP set_100  set_100    Output   1
      add_interface_port UNUSED_WIRE_CP hd_ena   hd_ena     Output   1
   } else {
      add_interface_port $PCS_SGMII_STATUS_CP_NAME set_100  set_100     Output   1
      add_interface_port $PCS_SGMII_STATUS_CP_NAME hd_ena   hd_ena      Output   1
   }   
}

proc build_pcs_status_led_interface {args} {
   set PCS_STATUS_LED_CP_NAME [lindex $args 0]

   # Status LED
   add_interface $PCS_STATUS_LED_CP_NAME conduit end
   add_interface_port $PCS_STATUS_LED_CP_NAME led_crs        export   Output   1
   add_interface_port $PCS_STATUS_LED_CP_NAME led_link       export   Output   1
   add_interface_port $PCS_STATUS_LED_CP_NAME led_panel_link export   Output   1
   add_interface_port $PCS_STATUS_LED_CP_NAME led_col        export   Output   1
   add_interface_port $PCS_STATUS_LED_CP_NAME led_an         export   Output   1
   add_interface_port $PCS_STATUS_LED_CP_NAME led_char_err   export   Output   1
   add_interface_port $PCS_STATUS_LED_CP_NAME led_disp_err   export   Output   1

}

proc build_pcs_serdes_control_interface {args} {
   set PCS_SERDES_CONTROL_CP_NAME [lindex $args 0]
   
   # Serdes control interface
   add_interface $PCS_SERDES_CONTROL_CP_NAME conduit end
   add_interface_port $PCS_SERDES_CONTROL_CP_NAME rx_recovclkout  export   Output   1
}

proc build_pma_serial_interface {args} {
   set PMA_SERIAL_CP_NAME [lindex $args 0]

   # Serial interface
   add_interface $PMA_SERIAL_CP_NAME conduit end
   add_interface_port $PMA_SERIAL_CP_NAME txp   export   Output   1
   add_interface_port $PMA_SERIAL_CP_NAME rxp   export   Input    1
   
}

proc build_phy_timestamp_interface {args} {
   set PCS_PHASE_MEASURE_CLK [lindex $args 0]
   set RX_LATENCY_ADJ [lindex $args 1]
   set TX_LATENCY_ADJ [lindex $args 2]
   set TX_PTP_ALIGNMENT [lindex $args 3]
   
   set enable_timestamping [get_parameter_value ENABLE_TIMESTAMPING]
   
   if {$enable_timestamping} {
      # pcs measure clock
      add_interface $PCS_PHASE_MEASURE_CLK clock end
      add_interface_port $PCS_PHASE_MEASURE_CLK pcs_phase_measure_clk clk Input 1  

      # rx latency adjustment
      add_interface $RX_LATENCY_ADJ conduit end
      add_interface_port $RX_LATENCY_ADJ rx_latency_adj       export   Output   22
      
      # tx latency adjustment
      add_interface $TX_LATENCY_ADJ conduit end
      add_interface_port $TX_LATENCY_ADJ tx_latency_adj       export   Output   22
	  
      # tx ptp alignment
      add_interface $TX_PTP_ALIGNMENT conduit end
      add_interface_port $TX_PTP_ALIGNMENT tx_ptp_alignment    data   Output   1	  
   } else {
      add_interface pcs_phase_measure_clk_unused clock end
      add_interface_port pcs_phase_measure_clk_unused pcs_phase_measure_clk clk Input 1
      set_interface_property pcs_phase_measure_clk_unused ENABLED 0  

      add_interface terminate_lat_adj_unused conduit end
      add_interface_port terminate_lat_adj_unused rx_latency_adj data Output 22
      add_interface_port terminate_lat_adj_unused tx_latency_adj data Output 22
      add_interface_port terminate_lat_adj_unused tx_ptp_alignment data Output 1
      set_interface_property terminate_lat_adj_unused ENABLED 0        
   }

}

proc build_eccstatus_conduit_interface {args} {
   set WIRE_CP_NAME [lindex $args 0]

   add_interface $WIRE_CP_NAME conduit end
   add_interface_port $WIRE_CP_NAME "pcs_eccstatus" "pcs_eccstatus" Output 2

}
