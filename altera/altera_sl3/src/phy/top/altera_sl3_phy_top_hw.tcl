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


#########################################
### request TCL package from ACDS
#########################################
package require -exact qsys 14.1
package require altera_tcl_testlib 1.0
package require -exact altera_terp 1.0

#########################################
### Source required procs
#########################################
source ../../top/altera_sl3_common_procs.tcl

##########################
# module altera_jesd204b
##########################
set_module_property NAME altera_sl3_phy_top
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "Sub-Components of Altera Seriallite III Streaming"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SerialLite"
set_module_property DISPLAY_NAME "Seriallite III Streaming PHY TOP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true


########################
# Declare the callbacks
######################## 
set_module_property COMPOSITION_CALLBACK my_compose_callback   

#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ../../top/altera_sl3_params.tcl
::altera_sl3::gui_params::params_phy_hw

#############################################################
#                  Compose Callback
#############################################################

proc my_compose_callback {} {
   my_sl3_add_instance
   my_sl3_add_connection
}

# Add instance and set its parameters value
proc my_sl3_add_instance {} {
   add_instance            inst_interlaken_soft_phy  altera_sl3_phy_soft  18.1
   propagate_params        inst_interlaken_soft_phy

   add_instance            inst_phy_adapter  altera_sl3_phy_adapter  18.1
   propagate_params        inst_phy_adapter

   if {[param_matches DEVICE_FAMILY "Stratix 10" ] } {
       if {[param_matches DIRECTION "Tx" ]} {
          tx_add_instances_xs_s10 
          set_parameter_property "gui_analog_voltage" ALLOWED_RANGES [get_instance_parameter_property "inst_interlaken_phy" anlg_voltage ALLOWED_RANGES]
       } elseif {[param_matches DIRECTION "Rx" ]} {
          rx_add_instances_xs_s10
          set_parameter_property "gui_pll_ref_freq" ALLOWED_RANGES [get_instance_parameter_property "inst_interlaken_phy" set_cdr_refclk_freq ALLOWED_RANGES]
          set refclk_pll_ranges [get_instance_parameter_property "inst_interlaken_phy" set_cdr_refclk_freq ALLOWED_RANGES]
          send_message debug "Allowed Frequencies :$refclk_pll_ranges" 
          set_parameter_property "gui_analog_voltage" ALLOWED_RANGES [get_instance_parameter_property "inst_interlaken_phy" anlg_voltage ALLOWED_RANGES]
       } else { 
       #Duplex
          duplex_add_instances_xs_s10
          set_parameter_property "gui_pll_ref_freq" ALLOWED_RANGES [get_instance_parameter_property "inst_interlaken_phy" set_cdr_refclk_freq ALLOWED_RANGES]
          set refclk_pll_ranges [get_instance_parameter_property "inst_interlaken_phy" set_cdr_refclk_freq ALLOWED_RANGES]
          send_message debug "Allowed Frequencies :$refclk_pll_ranges" 
          set_parameter_property "gui_analog_voltage" ALLOWED_RANGES [get_instance_parameter_property "inst_interlaken_phy" anlg_voltage ALLOWED_RANGES]
       }
   }
}

# Set instances connection
proc my_sl3_add_connection {} {
      set_phy_connections 
}

# Proc to add instances for TX and set the parameters for series 10 device family
proc tx_add_instances_xs_s10 {} {
      add_instance                   inst_interlaken_phy   altera_xcvr_native_s10   18.1
      set_instance_property          inst_interlaken_phy   SUPPRESS_ALL_WARNINGS    true
      set_instance_parameter_value   inst_interlaken_phy   message_level "error" 
      set_instance_parameter_value   inst_interlaken_phy   protocol_mode "interlaken_mode" 
      set_instance_parameter_value   inst_interlaken_phy   duplex_mode [string tolower [get_parameter_value "DIRECTION"]]
      set_instance_parameter_value   inst_interlaken_phy   channels [get_parameter_value "LANES"]
      set_instance_parameter_value   inst_interlaken_phy   set_data_rate [expr {1000*[get_parameter_value "lane_rate_recommended"]}]
      set_instance_parameter_value   inst_interlaken_phy   rcfg_enable 1
      set_instance_parameter_value   inst_interlaken_phy   rcfg_shared [expr {[get_parameter_value "LANES"] != 1} ]
      set_instance_parameter_value   inst_interlaken_phy   enable_simple_interface 1
      set_instance_parameter_value   inst_interlaken_phy   pcs_reset_sequencing_mode "bonded"  
      set_instance_parameter_value   inst_interlaken_phy   anlg_voltage [get_parameter_value "gui_analog_voltage"]  

      set_instance_parameter_value   inst_interlaken_phy   bonded_mode "not_bonded"
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_pma_iqtxrx_clkout 0
      set_instance_parameter_value   inst_interlaken_phy   tx_clkout_sel "pcs_clkout"
      set_instance_parameter_value   inst_interlaken_phy   enh_pcs_pma_width 64
      set_instance_parameter_value   inst_interlaken_phy   enh_pld_pcs_width 67
      set_instance_parameter_value   inst_interlaken_phy   tx_fifo_mode Interlaken 
      set_instance_parameter_value   inst_interlaken_phy   tx_fifo_pfull 24
      set_instance_parameter_value   inst_interlaken_phy   tx_fifo_pempty  6
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_fifo_full 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_fifo_pfull 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_fifo_empty 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_fifo_pempty 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_dll_lock 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_frmgen_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_frmgen_mfrm_length [get_parameter_value "METALEN"]  
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_frmgen_burst_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_enh_frame 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_enh_frame_diag_status 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_enh_frame_burst_en 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_crcgen_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_crcerr_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_scram_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_scram_seed 81985529216486895
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_dispgen_enable 1 
}

# Proc to add instances for RX and set the parameters for series 10 device family
proc rx_add_instances_xs_s10 {} {
      add_instance                   inst_interlaken_phy   altera_xcvr_native_s10   18.1
      set_instance_property          inst_interlaken_phy   SUPPRESS_ALL_WARNINGS    true
      set_instance_parameter_value   inst_interlaken_phy   message_level "error" 
      set_instance_parameter_value   inst_interlaken_phy   protocol_mode "interlaken_mode" 
      set_instance_parameter_value   inst_interlaken_phy   duplex_mode [string tolower [get_parameter_value "DIRECTION"]]
      set_instance_parameter_value   inst_interlaken_phy   channels [get_parameter_value "LANES"]
      set_instance_parameter_value   inst_interlaken_phy   set_data_rate [expr {1000*[get_parameter_value "lane_rate_recommended"]}]
      set_instance_parameter_value   inst_interlaken_phy   rcfg_enable 1
      set_instance_parameter_value   inst_interlaken_phy   rcfg_shared [expr {[get_parameter_value "LANES"] != 1} ]
      set_instance_parameter_value   inst_interlaken_phy   enh_pcs_pma_width 64
      set_instance_parameter_value   inst_interlaken_phy   enh_pld_pcs_width 67
      set_instance_parameter_value   inst_interlaken_phy   set_cdr_refclk_freq [get_parameter_value "gui_pll_ref_freq"]  
      set_instance_parameter_value   inst_interlaken_phy   anlg_voltage [get_parameter_value "gui_analog_voltage"]  
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_pma_iqtxrx_clkout 0
      set_instance_parameter_value   inst_interlaken_phy   enable_ports_rx_manual_cdr_mode 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_seriallpbken 1 
      set_instance_parameter_value   inst_interlaken_phy   rx_fifo_mode Interlaken 
      set_instance_parameter_value   inst_interlaken_phy   rx_fifo_pfull 23
      set_instance_parameter_value   inst_interlaken_phy   rx_fifo_pempty  4
      set_instance_parameter_value   inst_interlaken_phy   enable_simple_interface 1
      set_instance_parameter_value   inst_interlaken_phy   rx_clkout_sel "pcs_clkout"
	  
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_full 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_pfull 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_empty 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_pempty 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_rd_en 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_align_clr 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_data_valid 1
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_frmsync_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_frmsync_mfrm_length [get_parameter_value "METALEN"]   
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_frame 0 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_frame_lock 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_frame_diag_status 0 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_crcchk_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_crc32_err 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_descram_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_dispchk_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_blksync_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_blk_lock 1
}

#Proc to add instances for duplex mode for series 10 device family
proc duplex_add_instances_xs_s10 {} {
      add_instance                   inst_interlaken_phy   altera_xcvr_native_s10   18.1
      set_instance_property          inst_interlaken_phy   SUPPRESS_ALL_WARNINGS    true
      set_instance_parameter_value   inst_interlaken_phy   message_level "error" 
      set_instance_parameter_value   inst_interlaken_phy   protocol_mode "interlaken_mode" 
      set_instance_parameter_value   inst_interlaken_phy   duplex_mode [string tolower [get_parameter_value "DIRECTION"]]
      set_instance_parameter_value   inst_interlaken_phy   channels [get_parameter_value "LANES"]
      set_instance_parameter_value   inst_interlaken_phy   set_data_rate [expr {1000*[get_parameter_value "lane_rate_recommended"]}]
      set_instance_parameter_value   inst_interlaken_phy   rcfg_enable 1
      set_instance_parameter_value   inst_interlaken_phy   rcfg_shared [expr {[get_parameter_value "LANES"] != 1} ]
      set_instance_parameter_value   inst_interlaken_phy   enable_simple_interface 1
      set_instance_parameter_value   inst_interlaken_phy   pcs_reset_sequencing_mode "bonded"      
      set_instance_parameter_value   inst_interlaken_phy   anlg_voltage [get_parameter_value "gui_analog_voltage"]  
	  
      set_instance_parameter_value   inst_interlaken_phy   bonded_mode "not_bonded"
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_pma_iqtxrx_clkout 0
      set_instance_parameter_value   inst_interlaken_phy   enh_pcs_pma_width 64
      set_instance_parameter_value   inst_interlaken_phy   enh_pld_pcs_width 67
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_frmgen_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_frmgen_mfrm_length [get_parameter_value "METALEN"]  
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_frmgen_burst_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_enh_frame 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_enh_frame_diag_status 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_enh_frame_burst_en 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_crcgen_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_crcerr_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_scram_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_scram_seed 81985529216486895 
      set_instance_parameter_value   inst_interlaken_phy   enh_tx_dispgen_enable 1 
	  set_instance_parameter_value   inst_interlaken_phy   tx_fifo_mode Interlaken 
      set_instance_parameter_value   inst_interlaken_phy   tx_fifo_pfull 24
      set_instance_parameter_value   inst_interlaken_phy   tx_fifo_pempty  6
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_fifo_full 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_fifo_pfull 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_fifo_empty 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_fifo_pempty 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_tx_dll_lock 1 
      set_instance_parameter_value   inst_interlaken_phy   tx_clkout_sel "pcs_clkout"

      set_instance_parameter_value   inst_interlaken_phy   set_cdr_refclk_freq [get_parameter_value "gui_pll_ref_freq"]  
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_pma_iqtxrx_clkout 0
      set_instance_parameter_value   inst_interlaken_phy   enable_ports_rx_manual_cdr_mode 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_seriallpbken 1 
      set_instance_parameter_value   inst_interlaken_phy   rx_fifo_mode Interlaken 
      set_instance_parameter_value   inst_interlaken_phy   rx_fifo_pfull 23
      set_instance_parameter_value   inst_interlaken_phy   rx_fifo_pempty  4
      set_instance_parameter_value   inst_interlaken_phy   rx_clkout_sel "pcs_clkout"

      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_full 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_pfull 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_empty 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_pempty 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_rd_en 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_fifo_align_clr 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_data_valid 1
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_frmsync_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_frmsync_mfrm_length [get_parameter_value "METALEN"]   
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_frame 0 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_frame_lock 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_frame_diag_status 0 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_crcchk_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_crc32_err 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_descram_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_dispchk_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enh_rx_blksync_enable 1 
      set_instance_parameter_value   inst_interlaken_phy   enable_port_rx_enh_blk_lock 1
}

proc set_phy_connections {  } {
   set d_L [get_parameter_value "LANES"]
   set_export_interface  phy_mgmt_clk          clock    end     inst_interlaken_soft_phy  phy_mgmt_clk        1
   set_export_interface  phy_mgmt_clk_reset    reset    end     inst_interlaken_soft_phy  phy_mgmt_clk_reset  1
   set_export_interface  phy_mgmt              avalon   end     inst_interlaken_soft_phy  phy_mgmt            1

   #--------------TX interfaces----------------
   # set_export_interface  <interface_name>  <interface_type>  <direction>  <instance_name>  <instance_interface>  <enable_condition>
   if {[param_is_true "TEST_COMPONENTS_EN" ]} {
      for {set i 0} {$i < $d_L} {incr i} { 
         set_export_interface  tx_serial_clk_ch${i}        hssi_serial_clock  end  inst_phy_adapter   tx_serial_clk_ch${i}       [expr {[get_tx_interfaces_on]}]
      }
   } else {
      set_export_interface  tx_serial_clk      conduit  end  inst_phy_adapter   tx_serial_clk       [expr {[get_tx_interfaces_on]}]
   }
   set_export_interface  txcore_clock         clock    start   inst_interlaken_soft_phy  txcore_clock           [expr {[get_tx_interfaces_on]}]
   set_export_interface  txcore_clock_reset   reset    start   inst_interlaken_soft_phy  txcore_clock_reset     [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_user_clock        clock    end   inst_interlaken_soft_phy  tx_user_clock           [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_user_clock_reset  reset    end   inst_interlaken_soft_phy  tx_user_clock_reset     [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_err_interrupt     interrupt   sender   inst_interlaken_soft_phy    tx_err_interrupt [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_fifo_pfull        conduit  start   inst_phy_adapter          tx_fifo_pfull_out      [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_fifo_pempty       conduit  start   inst_phy_adapter          tx_fifo_pempty_out     [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_err_ins           conduit  start   inst_interlaken_phy       tx_err_ins             [expr {[get_tx_interfaces_on]}]      
   set_export_interface  pll_locked           conduit  end     inst_interlaken_soft_phy  pll_locked             [expr {[get_tx_interfaces_on]}]
   #set_export_interface  pll_powerdown        conduit  end     inst_interlaken_soft_phy  pll_powerdown          [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_data_valid        conduit  end     inst_phy_adapter          tx_data_valid_in       [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_sync_done         conduit  start   inst_interlaken_soft_phy  tx_sync_done           [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_parallel_data     conduit  end     inst_phy_adapter          tx_parallel_data_in    [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_serial_data       conduit  end     inst_interlaken_phy       tx_serial_data         [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_control           conduit  end     inst_phy_adapter          tx_control_in          [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_sl3_interrupt_src conduit  end     inst_interlaken_soft_phy  tx_sl3_interrupt_src   [expr {[get_tx_interfaces_on]}]

   #--------------RX interfaces----------------
   set_export_interface  rx_cdr_refclk        clock    end     inst_phy_adapter          rx_cdr_refclk_in        [expr {[get_rx_interfaces_on]}] 
   set_export_interface  rxcore_clock         clock    start   inst_interlaken_soft_phy  rxcore_clock            [expr {[get_rx_interfaces_on]}]
   set_export_interface  rxcore_clock_reset   reset    start   inst_interlaken_soft_phy  rxcore_clock_reset      [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_parallel_data     conduit  start   inst_phy_adapter          rx_parallel_data_out    [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_err_interrupt     interrupt   sender   inst_interlaken_soft_phy    rx_err_interrupt  [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_fifo_pfull        conduit  start   inst_phy_adapter          rx_fifo_pfull_out       [expr {[get_rx_interfaces_on]}] 
   set_export_interface  rx_fifo_pempty       conduit  start   inst_phy_adapter          rx_fifo_pempty_out      [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_fifo_align_clr    conduit  end     inst_phy_adapter          rx_fifo_align_clr_in    [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_fifo_rden         conduit  end     inst_phy_adapter          rx_fifo_rden_in         [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_data_valid        conduit  start   inst_phy_adapter          rx_data_valid_out       [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_serial_data       conduit  end     inst_interlaken_phy       rx_serial_data          [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_control           conduit  start   inst_phy_adapter          rx_control_out          [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_frame_lock        conduit  start   inst_phy_adapter          rx_frame_lock_out       [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_block_frame_lock  conduit  start   inst_phy_adapter          rx_block_frame_lock_out [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_pcs_err           conduit  start   inst_phy_adapter          rx_pcs_err_out1         [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_sync_word         conduit  start   inst_phy_adapter          rx_sync_word_out        [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_scrm_word         conduit  start   inst_phy_adapter          rx_scrm_word_out        0
   set_export_interface  rx_skip_word         conduit  start   inst_phy_adapter          rx_skip_word_out        0
   set_export_interface  rx_diag_word         conduit  start   inst_phy_adapter          rx_diag_word_out        0
   set_export_interface  rx_sl3_interrupt_src conduit  end     inst_interlaken_soft_phy  rx_sl3_interrupt_src    [expr {[get_rx_interfaces_on]}]
   set_export_interface  rx_sl3_csr_control   conduit  start   inst_interlaken_soft_phy  rx_sl3_csr_control      [expr {[get_rx_interfaces_on]}]

   # Interfaces and connections for PHY 
   set_connections       inst_interlaken_soft_phy.xcvr_avs_clk          inst_interlaken_phy.reconfig_clk         1
   set_connections       inst_interlaken_soft_phy.xcvr_avs_reset        inst_interlaken_phy.reconfig_reset       1
   set_connections       inst_interlaken_soft_phy.xcvr_avs              inst_interlaken_phy.reconfig_avmm        1

   #--------------TX interfaces----------------
   set_connections       inst_phy_adapter.tx_serial_clk_out           inst_interlaken_phy.tx_serial_clk0         [expr {[get_tx_interfaces_on]}]
   set_connections       inst_phy_adapter.tx_coreclkin_out            inst_interlaken_phy.tx_coreclkin           [expr {[get_tx_interfaces_on]}]
   set_connections       inst_phy_adapter.tx_parallel_data_out        inst_interlaken_phy.tx_parallel_data       [expr {[get_tx_interfaces_on]}]
   set_connections       inst_phy_adapter.unused_tx_parallel_data     inst_interlaken_phy.unused_tx_parallel_data   [expr {[get_tx_interfaces_on]}]
   set_connections       inst_phy_adapter.tx_enh_data_valid           inst_interlaken_phy.tx_enh_data_valid      [expr {[get_tx_interfaces_on]}]    
   set_connections       inst_phy_adapter.tx_control_out              inst_interlaken_phy.tx_control             [expr {[get_tx_interfaces_on]}]
   set_connections       inst_phy_adapter.tx_data_valid_out           inst_interlaken_phy.tx_fifo_wr_en          [expr {[get_tx_interfaces_on]}]
   set_connections       inst_phy_adapter.tx_frame_diag_status_out    inst_interlaken_phy.tx_enh_frame_diag_status  [expr {[get_tx_interfaces_on]}]
   set_connections       inst_phy_adapter.tx_frame_out                inst_interlaken_soft_phy.tx_frame          [expr {[get_tx_interfaces_on]}]
   set_connections       inst_phy_adapter.tx_fifo_empty_out           inst_interlaken_soft_phy.tx_phy_fifo_empty [expr {[get_tx_interfaces_on]}]

   set_connections       inst_interlaken_phy.tx_clkout                inst_interlaken_soft_phy.tx_clkout         [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_phy.tx_cal_busy              inst_interlaken_soft_phy.tx_cal_busy       [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_phy.tx_digitalreset_stat     inst_interlaken_soft_phy.tx_digitalreset_stat [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_phy.tx_analogreset_stat      inst_interlaken_soft_phy.tx_analogreset_stat  [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_phy.tx_dll_lock              inst_interlaken_soft_phy.tx_dll_lock_in    [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_phy.tx_fifo_full             inst_interlaken_soft_phy.tx_phy_fifo_full  [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_phy.tx_enh_frame             inst_phy_adapter.tx_frame_in               [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_phy.tx_fifo_pfull            inst_phy_adapter.tx_fifo_pfull_in          [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_phy.tx_fifo_pempty           inst_phy_adapter.tx_fifo_pempty_in         [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_phy.tx_fifo_empty            inst_phy_adapter.tx_fifo_empty_in          [expr {[get_tx_interfaces_on]}]
   
   set_connections       inst_interlaken_soft_phy.tx_digitalreset     inst_interlaken_phy.tx_digitalreset        [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.tx_analogreset      inst_interlaken_phy.tx_analogreset         [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.tx_burst_en         inst_interlaken_phy.tx_enh_burst_en        [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.tx_force_fill       inst_phy_adapter.tx_force_fill_in          [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.dll_fifo_wr_en      inst_phy_adapter.dll_fifo_wr_en            [expr {[get_tx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.txcore_clock_phy_adpt        inst_phy_adapter.txcore_clock     [expr {[get_tx_interfaces_on]}]

   #--------------RX interfaces----------------
   set_connections       inst_interlaken_phy.rx_control               inst_phy_adapter.rx_control_in             [expr {[get_rx_interfaces_on]}]
   set_connections       inst_phy_adapter.rx_fifo_full_out            inst_interlaken_soft_phy.rx_phy_fifo_full  [expr {[get_rx_interfaces_on]}]
   set_connections       inst_phy_adapter.rx_block_lock_out           inst_interlaken_soft_phy.rx_block_lock     [expr {[get_rx_interfaces_on]}]
   set_connections       inst_phy_adapter.rx_frame_lock_out2          inst_interlaken_soft_phy.rx_frame_lock     [expr {[get_rx_interfaces_on]}]
   set_connections       inst_phy_adapter.rx_crc32_err_out            inst_interlaken_soft_phy.rx_crc32_err      [expr {[get_rx_interfaces_on]}]
   set_connections       inst_phy_adapter.rx_pcs_err_out2             inst_interlaken_soft_phy.rx_pcs_err        [expr {[get_rx_interfaces_on]}]
   set_connections       inst_phy_adapter.rx_cdr_refclk_out           inst_interlaken_phy.rx_cdr_refclk0         [expr {[get_rx_interfaces_on]}]
   set_connections       inst_phy_adapter.rx_coreclkin_out            inst_interlaken_phy.rx_coreclkin           [expr {[get_rx_interfaces_on]}]
   set_connections       inst_phy_adapter.rx_fifo_rden_out            inst_interlaken_phy.rx_fifo_rd_en          [expr {[get_rx_interfaces_on]}]
   set_connections       inst_phy_adapter.rx_fifo_align_clr_out       inst_interlaken_phy.rx_fifo_align_clr      [expr {[get_rx_interfaces_on]}]

   set_connections       inst_interlaken_phy.rx_clkout                inst_interlaken_soft_phy.rx_clkout         [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_is_lockedtodata       inst_interlaken_soft_phy.rx_is_lockedtodata   [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_is_lockedtoref        inst_interlaken_soft_phy.rx_is_lockedtoref [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_cal_busy              inst_interlaken_soft_phy.rx_cal_busy       [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_analogreset_stat      inst_interlaken_soft_phy.rx_analogreset_stat  [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_digitalreset_stat     inst_interlaken_soft_phy.rx_digitalreset_stat [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_parallel_data         inst_phy_adapter.rx_parallel_data_in       [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_data_valid            inst_phy_adapter.rx_data_valid_in          [expr {[get_rx_interfaces_on]}]   
   set_connections       inst_interlaken_phy.rx_enh_frame_lock        inst_phy_adapter.rx_frame_lock_in          [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_enh_crc32err          inst_phy_adapter.rx_crc32_err_in           [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_enh_blk_lock          inst_phy_adapter.rx_block_lock_in          [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_fifo_pfull            inst_phy_adapter.rx_fifo_pfull_in          [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_fifo_full             inst_phy_adapter.rx_fifo_full_in           [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_fifo_pempty           inst_phy_adapter.rx_fifo_pempty_in         [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_phy.rx_fifo_empty            inst_interlaken_soft_phy.rx_phy_fifo_empty [expr {[get_rx_interfaces_on]}]
   
   set_connections       inst_interlaken_soft_phy.phy_loopback_serial  inst_interlaken_phy.rx_seriallpbken      [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.rx_set_locktodata    inst_interlaken_phy.rx_set_locktodata    [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.rx_set_locktoref     inst_interlaken_phy.rx_set_locktoref     [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.rx_digitalreset      inst_interlaken_phy.rx_digitalreset      [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.rx_analogreset       inst_interlaken_phy.rx_analogreset       [expr {[get_rx_interfaces_on]}]
   set_connections       inst_interlaken_soft_phy.rxcore_clock_phy_adpt inst_phy_adapter.rxcore_clock           [expr {[get_rx_interfaces_on]}]
}

