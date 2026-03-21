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

##########################
# module  altera_sl3
##########################
set_module_property NAME altera_sl3
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "Seriallite III Streaming MegaCore Function"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Interface Protocols/SerialLite"
set_module_property DISPLAY_NAME "SerialLite III Streaming"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true
set_module_property SUPPORTED_DEVICE_FAMILIES {{Stratix 10}}

######## Get Required SLIII tcl command #########
source ./altera_sl3_common_procs.tcl

########################
# Declare the callbacks
########################
#set_module_property PARAMETER_UPGRADE_CALLBACK my_upgrade_callback
set_module_property VALIDATION_CALLBACK my_validation_callback
set_module_property COMPOSITION_CALLBACK my_compose_callback

#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./altera_sl3_params.tcl
::altera_sl3::gui_params::params_top_hw

#------------------------------------------------------------------------
# 2. Testbench
#------------------------------------------------------------------------
 source ./../../ed/top/altera_sl3_ed_top_hw.tcl


#############################################################
#                  Validation Callback
#############################################################
proc my_validation_callback {} {
   #Derive DEVICE_FAMILY
   set dev_fam  [get_parameter_value system_family]
   set_parameter_value DEVICE_FAMILY $dev_fam
   set_parameter_value "METALEN" [get_parameter_value "meta_frame_length"]
   set_parameter_value "ADVANCED_CLOCKING" [get_parameter_value "gui_clocking_mode"]
   set_parameter_value "ECC_ENABLE" [get_parameter_value "gui_ecc_enable"]

   set var_devFamily [get_parameter_value "DEVICE_FAMILY"] 
   set var_ucf [get_parameter_value "gui_user_clock_frequency"] 
   set var_L [get_parameter_value "LANES"]
   set var_mfl [get_parameter_value "METALEN"]
   set cmode [get_parameter_value "ADVANCED_CLOCKING"]
   set gui_user_input [get_parameter_value gui_user_input]

#Configure all GUI parameters when to enabled or disabled
# conf_params_en     <param>       <enable>
   conf_params_en "DEVICE_FAMILY"      1
   conf_params_en "system_family"      1
   conf_params_en "LANES"              1
   conf_params_en "DIRECTION"          1
   conf_params_en "METALEN"            1
   conf_params_en "meta_frame_length"  1
   conf_params_en "ECC_ENABLE"         1
   conf_params_en "gui_ecc_enable"     1
   conf_params_en "gui_pll_ref_freq"   [expr {![expr {[param_matches DIRECTION "Tx"]} ] }]
   conf_params_en "gui_analog_voltage" 1
   conf_params_en "BURST_GAP"          1
   conf_params_en "ADAPT_PFULL_THRESHOLD" 1
   conf_params_en "PMA_MODE"           1
   conf_params_en "STREAM"             0
   conf_params_en "ADVANCED_CLOCKING"  1
   conf_params_en "gui_clocking_mode"  1
   conf_params_en "int_reference_clock_frequency"  [expr {[param_is_true "TEST_COMPONENTS_EN" ]}]
   
    if {[expr {[param_matches gui_user_input "1"]}]} {
      set_parameter_property "gui_xcvr_data_rate" VISIBLE true
      set_parameter_property "lane_rate_recommended" VISIBLE false
      set_parameter_property "gui_actual_user_clock_frequency" VISIBLE true
      set_parameter_property "gui_user_clock_frequency" VISIBLE false
    } else {
      set_parameter_property "gui_xcvr_data_rate" VISIBLE false
      set_parameter_property "lane_rate_recommended" VISIBLE true
      set_parameter_property "gui_actual_user_clock_frequency" VISIBLE false
      set_parameter_property "gui_user_clock_frequency" VISIBLE true
    }
   
   set_parameter_property "gui_pll_type" VISIBLE false

     # Input User clock frequency sanity checks
    set ucf_str "$var_ucf MHz"
    if { ![ validate_clock_freq_string $ucf_str ] }  {
       send_message error "User Clock Frequency is not in a recognizable format. A valid format is 138.526"
       return
    }

    set min_f 50

    #Seeting Max User Clock Values for Device Family and Clocking mode
    # Uclock values are hardcoded for Max allowed data rate for Device Family
    # ACM Mode hardcoded for Max Data Rate at mframe = 8191,
    # ucf = User Clock Freq, rcf = Ref Clock Freq
    if {$cmode == "false"} {
       set max_ucf 247.1590909 
    } else {
       set max_ucf 259.5746697
    }
      

    if { $var_ucf < $min_f} {
	send_message error "Minimum User Clock Frequency value is 50 MHz"  
	return
    } elseif { $var_ucf > $max_ucf} {
       send_message error "Maximum User Clock Frequency value is $max_ucf MHz"
       return
    }

    if {$gui_user_input == 1} {
       set xcvr_lane_rate [format %.6f [expr {[get_parameter_value gui_xcvr_data_rate]*1000}]]

       if {$cmode == "false"} {
	      set_parameter_value gui_actual_user_clock_frequency [format %.6f [expr {($xcvr_lane_rate/1.1/64)}]]
       } else {
          set_parameter_value gui_actual_user_clock_frequency [format %.6f [expr {($xcvr_lane_rate*($var_mfl-4)/(67*$var_mfl))}]]
       }
	   set user_input_ucf [get_parameter_value gui_actual_user_clock_frequency]
	   set_parameter_value "gui_aggregate_data_rate"  [format %.6f [expr {($user_input_ucf*64*$var_L)/1000}]]
    } else {	
       if {$cmode == "true"} {
          set xcvr_lane_rate [format %.6f [expr {($var_ucf*$var_mfl*67)/($var_mfl-4)}] ]
       } else {
          set xcvr_lane_rate [format %.6f [expr {($var_ucf*1.1*64)}] ]
       }
	   set_parameter_value "gui_aggregate_data_rate"  [format %.6f [expr {($var_ucf*64*$var_L)/1000}]]
    }

   #--DERIVE--in_lane_rate, lane_rate, and aggregate input data rate
   # Overhead and actual lane rate calculation
   set mfo [format %.6f [expr (4*$var_ucf*64) / ($var_mfl) ] ]
   send_message INFO "Meta-Frame Overhead  = $mfo Mbps"

   set pcs_input_rate [format %.6f [expr ($var_ucf*64*$var_mfl) / ($var_mfl - 4)] ]
   set pcs_output_rate [format %.6f [expr {($pcs_input_rate * 67/64)/1000}] ]
   set xcvr_lane_rate_round [format %.6f [expr {($xcvr_lane_rate/1000)}] ]
   send_message INFO "Encoding Overhead = [format %.6f [expr ($pcs_output_rate*1000 - $pcs_input_rate)] ] Mbps"
   set_parameter_value "in_lane_rate" [format %.6f [expr {($var_ucf*64)/1000}]]
   set_parameter_value "lane_rate" $xcvr_lane_rate_round
   set_parameter_value "lane_rate_recommended" $xcvr_lane_rate_round
   
   
   # Allow any values of refclk if disabled
   if {![param_is_enabled "gui_pll_ref_freq"]} {
       set_parameter_property "gui_pll_ref_freq" ALLOWED_RANGES {}
   }
   
    # Allow any values of refclk if disabled
   if {![param_is_enabled "gui_analog_voltage"]} {
    set_parameter_property "gui_pll_analog_voltage" ALLOWED_RANGES {}
   }


   #--DERIVE--SEVENTEENG_EN & PMA_MODE
   set_parameter_value "PMA_MODE" 64

   #--DERIVE-- PHY_DATA_WIDTH, TX_PHY_CTL_WIDTH, RX_PHY_CTL_WIDTH
   if {[param_matches DEVICE_FAMILY "Stratix 10"]} {
      set_parameter_value PHY_DATA_WIDTH 64
      set_parameter_value TX_PHY_CTL_WIDTH 3
      set_parameter_value RX_PHY_CTL_WIDTH 10
   }
   
   #--DERIVE--width of phy_mgmt_address
   if { $var_L ==  1} {
      set_parameter_value "ADDR_WIDTH" 11
   } else {
	  set mux_bits [clogb2 [expr {$var_L -1}]]
      set_parameter_value "ADDR_WIDTH" [expr { 11+$mux_bits }]
   }
   
   
   #--CHECK--user clock freq
      set pma_width [get_parameter_value "PMA_MODE"]
      set xcvr_clkout_freq [format %.4f [expr {[get_parameter_value "lane_rate"]/$pma_width}] ]
      set xcvr_clkout_freq_round [format %.6f [expr {[get_parameter_value "lane_rate_recommended"]/$pma_width}] ]
      set xcvr_clkout_freq_mbps [format %.6f [expr {$xcvr_clkout_freq_round*1000}]]
      send_message INFO "Transceiver Clkout Frequency = $xcvr_clkout_freq_mbps MHz"
      set_parameter_value "gui_actual_coreclkin_frequency" $xcvr_clkout_freq_mbps
      set_parameter_property "lane_rate" ALLOWED_RANGES 50:$xcvr_clkout_freq     

   #--CHECK--lane_rate  
   set_parameter_property "lane_rate" ALLOWED_RANGES 3.20:17.40
   set_parameter_property "lane_rate_recommended" ALLOWED_RANGES 3.20:17.40


    #--DERIVE--calculate PULSE_WIDTH ( Formula: PULSE_WIDTH = ceil(1.5*link_clk/avs_clk) ;Assuming worse case avs_clk = 100MHz)--
      set dest_clk 100
      set_parameter_value "PULSE_WIDTH" [expr ceil (($xcvr_clkout_freq_round*1000*1.50)/$dest_clk)]

    # Add a check to verify the BASE_DEVICE parameter before passing it to A10 PHY/PLL IP.  
    set local_base_device [get_parameter_value "part_trait_bd"]
    if { [string compare -nocase $local_base_device "unknown"] == 0 } {
       set local_device [get_parameter_value "part_trait_device"]
       send_message error "The current selected device \"$local_device\" is invalid, please select a valid device to generate the IP."
    }

	#--DERIVE--unused tx and rx pcs parallel data width--
	set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" [expr {$var_L*80 - $var_L*64 - $var_L*3 - $var_L*3}]

   ## Example Design ##
   set is_preset_config [is_preset_ed]
   if { $is_preset_config == "Standard Clocking Mode" } {
      map_allowed_range gui_ed_option {"Standard Clocking Mode"}
   } elseif { $is_preset_config == "Advanced Clocking Mode" } {
      map_allowed_range gui_ed_option {"Advanced Clocking Mode"}
   } else {
      map_allowed_range gui_ed_option $is_preset_config
   }
   ####################

   #Debug
   send_message debug  "DEVICE_FAMILY =  [get_parameter_value "DEVICE_FAMILY"]"
   send_message debug  "part_trait_bd =  [get_parameter_value "part_trait_bd"]"
   send_message debug  "part_trait_device =  [get_parameter_value "part_trait_device"]"
   send_message debug  "DIRECTION =  [get_parameter_value "DIRECTION"]"
   send_message debug  "LANES   =  [get_parameter_value "LANES"]"
   send_message debug  "METALEN  =  [get_parameter_value "METALEN"]"
   send_message debug  "STREAM   =  [get_parameter_value "STREAM"]"
   send_message debug  "ECC_ENABLE  =  [get_parameter_value "ECC_ENABLE"]"
   send_message debug  "ADVANCED_CLOCKING  =  [get_parameter_value "ADVANCED_CLOCKING"]"
   send_message debug  "PMA width  = [get_parameter_value "PMA_MODE"]"
   send_message debug  "PHY_DATA_WIDTH= [get_parameter_value "PHY_DATA_WIDTH"]"
   send_message debug  "TX_PHY_CTL_WIDTH = [get_parameter_value "TX_PHY_CTL_WIDTH"]"
   send_message debug  "RX_PHY_CTL_WIDTH = [get_parameter_value "RX_PHY_CTL_WIDTH"]"
   send_message debug  "ADDR_WIDTH    = [get_parameter_value "ADDR_WIDTH"]" 
   send_message debug  "PULSE_WIDTH =  [get_parameter_value "PULSE_WIDTH"]"
   send_message debug  "Total defined parameters = [llength [get_parameters]]"

} 


#############################################################
#              Composed Callback
#############################################################
proc my_compose_callback {} {
   my_sl3_add_instance
   my_sl3_add_connection
   

   if {[param_is_true "TEST_COMPONENTS_EN" ]} {
       set g_xs_PLL 1
       my_sl3_test_add_instance $g_xs_PLL
       my_sl3_test_add_connection $g_xs_PLL
   }

   send_message debug  "Total number of defined ports = [get_total_ports [get_module_ports]]"
  
} 

# Add instance and set its parameters value
proc my_sl3_add_instance {} {

   if {[param_matches DIRECTION "Tx" ]} {
       add_instance                inst_tx_mac             altera_sl3_source_mac      18.1
       propagate_params            inst_tx_mac 

       add_instance                  phy_mgmt_clk_fanout        altera_sl3_fanout  18.1
       set_instance_parameter_value  phy_mgmt_clk_fanout        NUM_FANOUT      2
       set_instance_parameter_value  phy_mgmt_clk_fanout        WIDTH           1 
       set_instance_parameter_value  phy_mgmt_clk_fanout        SIGNAL_TYPE     clock
       set_instance_parameter_value  phy_mgmt_clk_fanout        INTERFACE_TYPE  clock

       add_instance                inst_sl3_phy          altera_sl3_phy_top         18.1
       propagate_params              inst_sl3_phy
       
       set_parameter_property "gui_analog_voltage" ALLOWED_RANGES [get_instance_parameter_property "inst_sl3_phy" gui_analog_voltage ALLOWED_RANGES]

       add_instance                  sync_tx_fanout         altera_sl3_fanout          18.1
       set_instance_parameter_value  sync_tx_fanout         NUM_FANOUT  2
       set_instance_parameter_value  sync_tx_fanout         WIDTH       8
       set_instance_parameter_value  sync_tx_fanout         SIGNAL_TYPE tx_sync

   } elseif {[param_matches DIRECTION "Rx" ]} {
       add_instance                inst_rx_mac             altera_sl3_sink_mac        18.1
       propagate_params            inst_rx_mac
       add_instance                inst_sl3_phy                altera_sl3_phy_top         18.1
       propagate_params            inst_sl3_phy
       set_parameter_property "gui_pll_ref_freq" ALLOWED_RANGES [get_instance_parameter_property "inst_sl3_phy" gui_pll_ref_freq ALLOWED_RANGES]
       if {[param_matches SHOW_ALLOWED_CDR_FREQ_INFO "true"]} { 
          send_message info " Transceiver CDR/PLL refclk freq allowed ranges = [get_instance_parameter_property "inst_sl3_phy" gui_pll_ref_freq ALLOWED_RANGES]"
       }
       
       set_parameter_property "gui_analog_voltage" ALLOWED_RANGES [get_instance_parameter_property "inst_sl3_phy" gui_analog_voltage ALLOWED_RANGES]
    

   } else {  
       add_instance                 inst_tx_mac             altera_sl3_source_mac      18.1
       propagate_params             inst_tx_mac            
       add_instance                 inst_rx_mac             altera_sl3_sink_mac        18.1
       propagate_params             inst_rx_mac        
       add_instance                  phy_mgmt_clk_fanout        altera_sl3_fanout  18.1
       set_instance_parameter_value  phy_mgmt_clk_fanout        NUM_FANOUT      2
       set_instance_parameter_value  phy_mgmt_clk_fanout        WIDTH           1 
       set_instance_parameter_value  phy_mgmt_clk_fanout        SIGNAL_TYPE     clock
       set_instance_parameter_value  phy_mgmt_clk_fanout        INTERFACE_TYPE  clock

       add_instance                 inst_sl3_phy          altera_sl3_phy_top         18.1
       propagate_params             inst_sl3_phy
       set_parameter_property "gui_pll_ref_freq" ALLOWED_RANGES [get_instance_parameter_property "inst_sl3_phy" gui_pll_ref_freq ALLOWED_RANGES]
       if {[param_matches SHOW_ALLOWED_CDR_FREQ_INFO "true"]} { 
          send_message info " Transceiver CDR/PLL refclk freq allowed ranges = [get_instance_parameter_property "inst_sl3_phy" gui_pll_ref_freq ALLOWED_RANGES]"
       }
       
       set_parameter_property "gui_analog_voltage" ALLOWED_RANGES [get_instance_parameter_property "inst_sl3_phy" gui_analog_voltage ALLOWED_RANGES]

       add_instance                  sync_tx_fanout         altera_sl3_fanout          18.1
       set_instance_parameter_value  sync_tx_fanout         NUM_FANOUT  2
       set_instance_parameter_value  sync_tx_fanout         WIDTH       8
       set_instance_parameter_value  sync_tx_fanout         SIGNAL_TYPE tx_sync
   }
}

# Set instances connection and set interface
proc my_sl3_add_connection {} {
   set d_L [get_parameter_value "LANES"]
   if  {[param_matches DIRECTION "Rx" ]} {
        set_export_interface    phy_mgmt_clk          clock    end    inst_sl3_phy  phy_mgmt_clk        1
        set_export_interface    phy_mgmt_clk_reset    reset    end    inst_sl3_phy  phy_mgmt_clk_reset  1
   } else {
        set_export_interface    phy_mgmt_clk                    clock   end    phy_mgmt_clk_fanout    clk_input     1
        set_connections         phy_mgmt_clk_fanout.clk_fanout0         inst_sl3_phy.phy_mgmt_clk                   1 
        set_connections         phy_mgmt_clk_fanout.clk_fanout1         inst_tx_mac.phy_mgmt_clk                    1 
        set_export_interface    phy_mgmt_clk_reset              reset   end    phy_mgmt_clk_fanout    rst_input     1
        set_connections         phy_mgmt_clk_fanout.rst_fanout0         inst_sl3_phy.phy_mgmt_clk_reset             1 
        set_connections         phy_mgmt_clk_fanout.rst_fanout1         inst_tx_mac.phy_mgmt_clk_reset              1 
   }
   set_export_interface     phy_mgmt        avalon   end    inst_sl3_phy  phy_mgmt  1
   
   #----------------------------------------------
   #                TX interfaces
   #----------------------------------------------
   #set_export_interface  tx_serial_clk  hssi_serial_clock  end  inst_sl3_phy tx_serial_clk  [expr {[get_tx_interfaces_on] && ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_export_interface  tx_serial_clk        conduit            sink    inst_sl3_phy     tx_serial_clk  [expr {[get_tx_interfaces_on] && ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_export_interface  tx_serial_data       conduit            end    inst_sl3_phy     tx_serial_data       [expr {[get_tx_interfaces_on]}]
   set_export_interface  tx_pll_locked        conduit            end    inst_sl3_phy     pll_locked           [expr {[get_tx_interfaces_on] && ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_export_interface  crc_error_inject     conduit            start  inst_sl3_phy     tx_err_ins           [expr {[get_tx_interfaces_on]}]


   # Duplex configuration
   set_export_interface  user_clock_tx        clock              end    inst_tx_mac      tx_user_clock        [expr {[duplex_configuration]}]
   set_export_interface  user_clock_reset_tx  reset              end    inst_tx_mac      tx_user_clock_reset  [expr {[duplex_configuration]}] 

   set_export_interface  data_tx              conduit            end    inst_tx_mac      tx_data              [expr {[duplex_configuration]}]
   set_export_interface  valid_tx             conduit            end    inst_tx_mac      tx_valid             [expr {[duplex_configuration]}]
   set_export_interface  ready_tx             conduit            start  inst_tx_mac      tx_ready             [expr {[duplex_configuration]}]
   set_export_interface  sync_tx              conduit            end    sync_tx_fanout   sig_input            [expr {[duplex_configuration]}]
   set_export_interface  start_of_burst_tx    conduit            end    inst_tx_mac      tx_start_of_burst    [expr {[duplex_configuration]}]
   set_export_interface  end_of_burst_tx      conduit            end    inst_tx_mac      tx_end_of_burst      [expr {[duplex_configuration]}]

   set_export_interface  link_up_tx           conduit            start  inst_tx_mac      tx_link_up           [expr {[duplex_configuration]}]
   set_export_interface  error_tx             conduit            start  inst_tx_mac      tx_error             [expr {[duplex_configuration]}]
   set_export_interface  err_interrupt_tx     interrupt          sender inst_sl3_phy     tx_err_interrupt     [expr {[duplex_configuration]}]

   # Simplex configuration
   set_export_interface  user_clock           clock              end    inst_tx_mac      tx_user_clock        [expr {[simplex_src_configuration]}]
   set_export_interface  user_clock_reset     reset              end    inst_tx_mac      tx_user_clock_reset  [expr {[simplex_src_configuration]}] 

   set_export_interface  data                 conduit            end    inst_tx_mac      tx_data              [expr {[simplex_src_configuration]}]
   set_export_interface  valid                conduit            end    inst_tx_mac      tx_valid             [expr {[simplex_src_configuration]}]
   set_export_interface  ready                conduit            start  inst_tx_mac      tx_ready             [expr {[simplex_src_configuration]}]
   set_export_interface  sync                 conduit            end    sync_tx_fanout   sig_input            [expr {[simplex_src_configuration]}]
   set_export_interface  start_of_burst       conduit            end    inst_tx_mac      tx_start_of_burst    [expr {[simplex_src_configuration]}]
   set_export_interface  end_of_burst         conduit            end    inst_tx_mac      tx_end_of_burst      [expr {[simplex_src_configuration]}]

   set_export_interface  link_up              conduit            start  inst_tx_mac      tx_link_up           [expr {[simplex_src_configuration]}]
   set_export_interface  error                conduit            start  inst_tx_mac      tx_error             [expr {[simplex_src_configuration]}]
   set_export_interface  err_interrupt        interrupt          sender inst_sl3_phy     tx_err_interrupt     [expr {[simplex_src_configuration]}]

   set_connections   inst_tx_mac.tx_data_valid                    inst_sl3_phy.tx_data_valid       [expr {[get_tx_interfaces_on]}]
   set_connections   inst_tx_mac.tx_control                      inst_sl3_phy.tx_control          [expr {[get_tx_interfaces_on]}]
   set_connections   inst_tx_mac.tx_parallel_data                 inst_sl3_phy.tx_parallel_data    [expr {[get_tx_interfaces_on]}]
   set_connections   inst_tx_mac.tx_sl3_interrupt_src            inst_sl3_phy.tx_sl3_interrupt_src    [expr {[get_tx_interfaces_on]}]
   set_connections   inst_sl3_phy.tx_fifo_pempty               inst_tx_mac.tx_fifo_pempty        [expr {[get_tx_interfaces_on]}]
   set_connections   inst_sl3_phy.tx_fifo_pfull                inst_tx_mac.tx_fifo_pfull         [expr {[get_tx_interfaces_on]}]
   set_connections   inst_sl3_phy.tx_sync_done                 inst_tx_mac.tx_sync_done           [expr {[get_tx_interfaces_on]}]
   set_connections   inst_sl3_phy.txcore_clock                 inst_tx_mac.txcore_clock           [expr {[get_tx_interfaces_on]}]
   set_connections   inst_sl3_phy.txcore_clock_reset           inst_tx_mac.txcore_clock_reset     [expr {[get_tx_interfaces_on]}]
   set_connections   inst_tx_mac.tx_user_clock_out             inst_sl3_phy.tx_user_clock          [expr {[get_tx_interfaces_on]}]
   set_connections   inst_tx_mac.tx_user_clock_reset_out       inst_sl3_phy.tx_user_clock_reset    [expr {[get_tx_interfaces_on]}]
   set_connections   sync_tx_fanout.sig_fanout0                inst_tx_mac.tx_sync                 [expr {[get_tx_interfaces_on]}]
   set_connections   sync_tx_fanout.sig_fanout1                inst_tx_mac.tx_empty                [expr {[get_tx_interfaces_on]}]

## TODO update new connections for TX  
 
  
   #----------------------------------------------
   #                RX interfaces
   #----------------------------------------------
   # set_export_interface  <interface_name>      <interface_type>  <direction>  <instance_name>  <instance_interface>  <enable_condition>
   set_export_interface  xcvr_pll_ref_clk         clock              end      inst_sl3_phy     rx_cdr_refclk            [expr {[get_rx_interfaces_on]}] 
   set_export_interface  rx_serial_data           conduit            end      inst_sl3_phy     rx_serial_data           [expr {[get_rx_interfaces_on]}]
 
   # Duplex configuration
   set_export_interface  user_clock_rx            clock              end      inst_rx_mac      rx_user_clock            [expr {[duplex_configuration] && [param_matches ADVANCED_CLOCKING "false"]}]
   set_export_interface  user_clock_reset_rx      reset              end      inst_rx_mac      rx_user_clock_reset      [expr {[duplex_configuration] && [param_matches ADVANCED_CLOCKING "false"]}]
   set_export_interface  interface_clock_rx       clock              start    inst_rx_mac      rxcore_clock_out         [expr {[duplex_configuration] && [param_matches ADVANCED_CLOCKING "true"]}]
   set_export_interface  interface_clock_reset_rx reset              start    inst_rx_mac      rxcore_clock_reset_out   [expr {[duplex_configuration] && [param_matches ADVANCED_CLOCKING "true"]}]


   set_export_interface  data_rx              conduit             start    inst_rx_mac      rx_data            [expr {[duplex_configuration]}]
   set_export_interface  valid_rx             conduit             start    inst_rx_mac      rx_valid           [expr {[duplex_configuration]}]
   set_export_interface  sync_rx              conduit             start    inst_rx_mac      rx_sync            [expr {[duplex_configuration]}]
   set_export_interface  ready_rx             conduit             end      inst_rx_mac      rx_ready           [expr {[duplex_configuration]}]
   set_export_interface  start_of_burst_rx    conduit             start    inst_rx_mac      rx_start_of_burst  [expr {[duplex_configuration]}]
   set_export_interface  end_of_burst_rx      conduit             start    inst_rx_mac      rx_end_of_burst    [expr {[duplex_configuration]}]

   set_export_interface  link_up_rx           conduit             start    inst_rx_mac      rx_link_up           [expr {[duplex_configuration]}]
   set_export_interface  error_rx             conduit             start    inst_rx_mac      rx_error             [expr {[duplex_configuration]}]
   set_export_interface  err_interrupt_rx     interrupt           sender   inst_sl3_phy     rx_err_interrupt     [expr {[duplex_configuration]}]


   # Simplex configuration
   set_export_interface  user_clock            clock              end      inst_rx_mac      rx_user_clock            [expr {[simplex_snk_configuration] && [param_matches ADVANCED_CLOCKING "false"]}]
   set_export_interface  user_clock_reset      reset              end      inst_rx_mac      rx_user_clock_reset      [expr {[simplex_snk_configuration] && [param_matches ADVANCED_CLOCKING "false"]}]
   set_export_interface  interface_clock       clock              start    inst_rx_mac      rxcore_clock_out         [expr {[simplex_snk_configuration] && [param_matches ADVANCED_CLOCKING "true"]}]
   set_export_interface  interface_clock_reset reset              start    inst_rx_mac      rxcore_clock_reset_out   [expr {[simplex_snk_configuration] && [param_matches ADVANCED_CLOCKING "true"]}]
   set_export_interface  data                  conduit            start    inst_rx_mac      rx_data                  [expr {[simplex_snk_configuration]}]
   set_export_interface  valid                 conduit            start    inst_rx_mac      rx_valid                 [expr {[simplex_snk_configuration]}]
   set_export_interface  sync                  conduit            start    inst_rx_mac      rx_sync                  [expr {[simplex_snk_configuration]}]
   set_export_interface  ready                 conduit            end      inst_rx_mac      rx_ready                 [expr {[simplex_snk_configuration]}]
   set_export_interface  start_of_burst        conduit            start    inst_rx_mac      rx_start_of_burst        [expr {[simplex_snk_configuration]}]
   set_export_interface  end_of_burst          conduit            start    inst_rx_mac      rx_end_of_burst          [expr {[simplex_snk_configuration]}]

   set_export_interface  link_up               conduit            start    inst_rx_mac      rx_link_up               [expr {[simplex_snk_configuration]}]
   set_export_interface  error                 conduit            start    inst_rx_mac      rx_error                 [expr {[simplex_snk_configuration]}]
   set_export_interface  err_interrupt         interrupt          sender   inst_sl3_phy     rx_err_interrupt         [expr {[simplex_snk_configuration]}]


   set_connections   inst_rx_mac.rx_fifo_align_clr          inst_sl3_phy.rx_fifo_align_clr    [expr {[get_rx_interfaces_on]}]
   set_connections   inst_rx_mac.rx_fifo_rden               inst_sl3_phy.rx_fifo_rden         [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rxcore_clock            inst_rx_mac.rxcore_clock            [expr {[get_rx_interfaces_on]}]

# TODO, check if rxcore_clock_reset is needed in RX for ACM mode
   set_connections   inst_sl3_phy.rxcore_clock_reset      inst_rx_mac.rxcore_clock_reset      [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_control              inst_rx_mac.rx_control              [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_pcs_err              inst_rx_mac.rx_pcs_err              [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_frame_lock           inst_rx_mac.rx_frame_lock           [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_block_frame_lock     inst_rx_mac.rx_block_frame_lock     [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_fifo_pfull           inst_rx_mac.rx_fifo_pfull           [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_fifo_pempty          inst_rx_mac.rx_fifo_pempty          [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_data_valid           inst_rx_mac.rx_data_valid           [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_parallel_data        inst_rx_mac.rx_parallel_data        [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_sync_word            inst_rx_mac.rx_sync_word            [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_scrm_word            inst_rx_mac.rx_scrm_word            0
   set_connections   inst_sl3_phy.rx_skip_word            inst_rx_mac.rx_skip_word            0
   set_connections   inst_sl3_phy.rx_diag_word            inst_rx_mac.rx_diag_word            0
   set_connections   inst_rx_mac.rx_sl3_interrupt_src     inst_sl3_phy.rx_sl3_interrupt_src   [expr {[get_rx_interfaces_on]}]
   set_connections   inst_sl3_phy.rx_sl3_csr_control      inst_rx_mac.rx_sl3_csr_control      [expr {[get_rx_interfaces_on]}]
   
}

proc my_sl3_test_add_instance {g_xs_PLL} {

    add_instance       inst_sl3_pll_wrapper      altera_sl3_pll_wrapper     18.1
    propagate_params   inst_sl3_pll_wrapper
}

proc my_sl3_test_add_connection {g_xs_PLL} {
    set d_L [get_parameter_value "LANES"]
    set_export_interface   tx_pll_ref_clk     clock      sink     inst_sl3_pll_wrapper  atxpll_refclk0      [expr {[get_tx_interfaces_on]}] 
    set_export_interface   pll_cal_busy       conduit    start    inst_sl3_pll_wrapper  atxpll_cal_busy     [expr {[get_tx_interfaces_on]}]

#    set_connections   inst_sl3_phy.pll_powerdown                inst_sl3_pll_wrapper.atxpll_powerdown      [expr {[get_tx_interfaces_on]}]
    set_connections   inst_sl3_pll_wrapper.atxpll_locked        inst_sl3_phy.pll_locked                    [expr {[get_tx_interfaces_on]}]
    if { $d_L > 6 } {
	for {set i 0} {$i < $d_L} {incr i} { 
	  set_connections   inst_sl3_pll_wrapper.mcgb_serial_clk        inst_sl3_phy.tx_serial_clk_ch${i}                 [expr {[get_tx_interfaces_on]}]
	}
    } else {
    	for {set i 0} {$i < $d_L} {incr i} { 
	  set_connections   inst_sl3_pll_wrapper.tx_serial_clk        inst_sl3_phy.tx_serial_clk_ch${i}                 [expr {[get_tx_interfaces_on]}]
	}	
    }
    set_export_interface   usrclk_pll_outclk0    clock       start    inst_sl3_pll_wrapper   usrclk_pll_outclk0            1
    set_export_interface   usrclk_pll_locked     conduit     start    inst_sl3_pll_wrapper   usrclk_pll_locked             1
    set_export_interface   usrclk_pll_refclk     clock       sink     inst_sl3_pll_wrapper   usrclk_pll_refclk             1
    set_export_interface   usrclk_pll_reset      reset       sink     inst_sl3_pll_wrapper   usrclk_pll_reset              [expr {[param_matches GUI_USE_FPLL "false"]}]
    set_export_interface   usrclk_pll_powerdown  conduit     sink     inst_sl3_pll_wrapper   usrclk_pll_powerdown          [expr {[param_matches GUI_USE_FPLL "true"]}]
    set_export_interface   usrclk_pll_cal_busy   conduit     start    inst_sl3_pll_wrapper   usrclk_pll_cal_busy           [expr {[param_matches GUI_USE_FPLL "true"]}]


  
}


proc is_preset_ed {} {

    set var_LANES                    [get_parameter_value "LANES"]
    set var_meta_frame_length        [get_parameter_value "meta_frame_length"]
    set var_gui_pll_ref_freq         [get_parameter_value "gui_pll_ref_freq"]
    set var_STREAM                   [get_parameter_value "STREAM"]
    set var_gui_clocking_mode        [get_parameter_value "gui_clocking_mode"]
    set var_gui_user_input           [get_parameter_value "gui_user_input"]
    set var_gui_xcvr_data_rate       [get_parameter_value "gui_xcvr_data_rate"]
    set var_gui_user_clock_frequency [get_parameter_value "gui_user_clock_frequency"]
    set var_gui_analog_voltage       [get_parameter_value "gui_analog_voltage"]
    # config : [0] LANES,
    #          [1] meta_frame_length,
    #          [2] gui_pll_ref_freq
    #          [3] STREAM
    #          [4] gui_clocking_mode
    #          [5] gui_user_input
    #          [6] gui_xcvr_data_rate/gui_user_clock_frequncy
    set support_config(6,200,312.5,FULL,false,1,12.5) "Standard_Clocking_Mode_6x12.5G"
    set support_config(6,200,312.5,FULL,true,1,12.5) "Advanced_Clocking_Mode_6x12.5G"
    set support_config(6,200,312.5,FULL,false,0,177.556818) "Standard_Clocking_Mode_6x12.5G"
    set support_config(6,200,312.5,FULL,true,0,182.835821) "Advanced_Clocking_Mode_6x12.5G"
    set support_config(6,200,312.5,FULL,true,0,182.83582) "Advanced_Clocking_Mode_6x12.5G"

    if {$var_gui_user_input == 1} {
       if {[info exists support_config($var_LANES,$var_meta_frame_length,$var_gui_pll_ref_freq,$var_STREAM,$var_gui_clocking_mode,1,$var_gui_xcvr_data_rate)]} {
          return $support_config($var_LANES,$var_meta_frame_length,$var_gui_pll_ref_freq,$var_STREAM,$var_gui_clocking_mode,1,$var_gui_xcvr_data_rate)
       } elseif {$var_gui_clocking_mode == false} {
          return "Standard Clocking Mode"
       } else {
          return "Advanced Clocking Mode"
       }
    } else {
       if {[info exists support_config($var_LANES,$var_meta_frame_length,$var_gui_pll_ref_freq,$var_STREAM,$var_gui_clocking_mode,0,$var_gui_user_clock_frequency)]} {
          return $support_config($var_LANES,$var_meta_frame_length,$var_gui_pll_ref_freq,$var_STREAM,$var_gui_clocking_mode,0,$var_gui_user_clock_frequency)
       } elseif {$var_gui_clocking_mode == false} {
          return "Standard Clocking Mode"
       } else {
          return "Advanced Clocking Mode"
       }
    }

}

##############################################################
