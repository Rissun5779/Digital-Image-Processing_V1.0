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


lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_pcie_hip_native/altera_xcvr_pcie_hip_native_s10

package require -exact qsys 16.0
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages
package require altera_terp

package provide altera_xcvr_pcie_hip_native::altera_xcvr_pcie_hip_native_s10 16.1

namespace eval ::altera_xcvr_pcie_hip_native_s10:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  # Declare the module using a nested list. First list is header, second list is property values
  variable module {\
    {NAME                             VERSION             SUPPORTED_DEVICE_FAMILIES   EDITABLE  INTERNAL VALIDATION_CALLBACK                                                              ELABORATION_CALLBACK                                                                DISPLAY_NAME                           GROUP                                 AUTHOR            }\
    {altera_xcvr_pcie_hip_native_s10  18.1    {"Stratix 10"}              false     true     ::altera_xcvr_pcie_hip_native_s10::altera_xcvr_pcie_hip_native_s10_val_callback  ::altera_xcvr_pcie_hip_native_s10::altera_xcvr_pcie_hip_native_s10_elab_callback    "Altera Transciever PCIe HIP Native"   "Interface Protocols/Transceiver PHY" "Altera Corporation"}\
  }

  # Declare the fileset using a nested list. First list is a header row.
  variable filesets {\
    {NAME            TYPE            CALLBACK                                                   TOP_LEVEL     }\
    {quartus_synth   QUARTUS_SYNTH   ::altera_xcvr_pcie_hip_native_s10::callback_quartus_synth  }\
    {sim_verilog     SIM_VERILOG     ::altera_xcvr_pcie_hip_native_s10::callback_sim_verilog    }\
    {sim_vhdl        SIM_VHDL        ::altera_xcvr_pcie_hip_native_s10::callback_sim_vhdl       }\
  }


  # Declare the parameters using a nested list. First list is a header row.
  variable parameters {\
    {NAME                 TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES                                     DISPLAY_HINT    DISPLAY_NAME                     ENABLED       VISIBLE   VALIDATION_CALLBACK}\
    {device_family        STRING   false   false         "Stratix 10"  NOVAL                                              NOVAL           NOVAL                            true          false     NOVAL}\
    {device               STRING   false   false         "Unknown"     NOVAL                                              NOVAL           NOVAL                            true          false     NOVAL}\
    {base_device          STRING   false   false         "Unknown"     NOVAL                                              NOVAL           NOVAL                            true          false     NOVAL}\
    {design_environment   STRING   false   false         "Native"      NOVAL                                              NOVAL           NOVAL                            true          false     NOVAL}\
    {unique_string        INTEGER  false   false         "random"      NOVAL                                              NOVAL           NOVAL                            true          false     NOVAL}\
    \
    {HIP_PROTOCOL_MODE    STRING   false   false         "pipe_g3"     {"pipe_g1" "pipe_g2" "pipe_g3"}                    NOVAL           "Protocol Mode"                  true          true      NOVAL}\
    {HIP_PROT_MODE        STRING   true    false         "gen3"        {"gen1" "gen2" "gen3"}                             NOVAL           NOVAL                            true          false     ::altera_xcvr_pcie_hip_native_s10::validate_hip_prot_mode}\
    {HIP_CHANNELS         STRING   true    false         "x1"          {"x1" "x2" "x3" "x4" "x8" "x16"}                   NOVAL           NOVAL                            true          false     ::altera_xcvr_pcie_hip_native_s10::validate_hip_channels}\
    {HIP_RECONFIG_ENABLE  boolean  false   false         0             NOVAL                                              NOVAL           "Enable dynamic reconfiguration" true          true      NOVAL}\
    {USED_CHANNELS        integer  false   false         1             {1 2 4 8 16}                                       NOVAL           "Channels"                       true          true      NOVAL}\
    {CHANNELS             integer  true    false         8             {8 16}                                             NOVAL           NOVAL                            true          false     ::altera_xcvr_pcie_hip_native_s10::validate_channels}\
    {HIP_GEN3_RM_FIFO     STRING   true    false         "600 ppm"     {"Bypass" "0 ppm" "600 ppm"}                       NOVAL           NOVAL                            true          false     ::altera_xcvr_pcie_hip_native_s10::validate_hip_gen3_rm_fifo}\
    {HIP_DATA_RATE        integer  true    false         5000          {2500 5000}                                        NOVAL           NOVAL                            true          false     ::altera_xcvr_pcie_hip_native_s10::validate_hip_data_rate}\
    {HIP_TX_PLL_NUM       integer  true    false         1             {1 2}                                              NOVAL           NOVAL                            true          false     ::altera_xcvr_pcie_hip_native_s10::validate_hip_tx_pll_num}\
    {HIP_BONDED_MODE      STRING   true    false         "pma_pcs"     {"pma_pcs" "not_bonded"}                           NOVAL           NOVAL                            true          false     ::altera_xcvr_pcie_hip_native_s10::validate_hip_bonded_mode}\
    {split_interfaces     boolean  false   false         0             NOVAL                                              NOVAL           "Use Split Interfaces"           true          true      NOVAL}\
  }

  # Declare the ports and interfaces using a nested list. First list is a header row.
  variable interfaces {\
   {NAME                          DIRECTION UI_DIRECTION  WIDTH_EXPR    ROLE                     TERMINATION                 TERMINATION_VALUE IFACE_NAME                   IFACE_TYPE        IFACE_DIRECTION DYNAMIC SPLIT                   SPLIT_WIDTH         SPLIT_COUNT   ELABORATION_CALLBACK }\
   {pipe_sw_done                  input     input         2             pipe_sw_done             false                       NOVAL             pipe_sw_done                 conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {pipe_sw                       output    output        2             pipe_sw                  false                       NOVAL             pipe_sw                      conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   \
   {tx_analogreset                input     input         CHANNELS      tx_analogreset           false                       NOVAL             tx_analogreset               conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {tx_digitalreset               input     input         CHANNELS      tx_digitalreset          false                       NOVAL             tx_digitalreset              conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_analogreset                input     input         CHANNELS      rx_analogreset           false                       NOVAL             rx_analogreset               conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_digitalreset               input     input         CHANNELS      rx_digitalreset          false                       NOVAL             rx_digitalreset              conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {tx_aibreset                   input     input         CHANNELS      tx_aibreset              false                       NOVAL             tx_aibreset                  conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_aibreset                   input     input         CHANNELS      rx_aibreset              false                       NOVAL             rx_aibreset                  conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {tx_transfer_ready             output    output        CHANNELS      tx_transfer_ready        false                       NOVAL             tx_transfer_ready            conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_transfer_ready             output    output        CHANNELS      rx_transfer_ready        false                       NOVAL             rx_transfer_ready            conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {tx_cal_busy                   output    output        CHANNELS      tx_cal_busy              false                       NOVAL             tx_cal_busy                  conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_cal_busy                   output    output        CHANNELS      rx_cal_busy              false                       NOVAL             rx_cal_busy                  conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {tx_bonding_clocks             input     input         6             tx_bonding_clocks        false                       NOVAL             tx_bonding_clocks            conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {rx_cdr_refclk0                input     input         1             rx_cdr_refclk0           false                       NOVAL             rx_cdr_refclk0               conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {tx_serial_data                output    output        CHANNELS      tx_serial_data           false                       NOVAL             tx_serial_data               conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_serial_data                input     input         CHANNELS      rx_serial_data           false                       NOVAL             rx_serial_data               conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_is_lockedtoref             output    output        CHANNELS      rx_is_lockedtoref        false                       NOVAL             rx_is_lockedtoref            conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_is_lockedtodata            output    output        CHANNELS      rx_is_lockedtodata       false                       NOVAL             rx_is_lockedtodata           conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_parallel_data              output    output        CHANNELS*80   rx_parallel_data         false                       NOVAL             rx_parallel_data             conduit           end             true    split_interfaces        80                  CHANNELS      NOVAL}\
   {tx_parallel_data              input     input         CHANNELS*80   tx_parallel_data         false                       NOVAL             tx_parallel_data             conduit           end             true    split_interfaces        80                  CHANNELS      NOVAL}\
   \
   {tx_clkout                     output    output        CHANNELS      tx_clkout                false                       NOVAL             tx_clkout                    conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {tx_clkout2                    output    output        CHANNELS      tx_clkout2               false                       NOVAL             tx_clkout2                   conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {rx_clkout                     output    output        CHANNELS      rx_clkout                false                       NOVAL             rx_clkout                    conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   {pipe_hclk_in                  input     input         1             pipe_hclk_in             false                       NOVAL             pipe_hclk_in                 conduit           end             true    NOVAL                   1                   NOVAL         NOVAL}\
   {tx_serial_clk0                input     input         1             tx_serial_clk0           false                       NOVAL             tx_serial_clk0               conduit           end             true    NOVAL                   1                   NOVAL         NOVAL}\
   {tx_serial_clk1                input     input         1             tx_serial_clk1           false                       NOVAL             tx_serial_clk1               conduit           end             true    NOVAL                   1                   NOVAL         NOVAL}\
   \
   {pipe_rx_eidleinfersel         input     input         CHANNELS*3    pipe_rx_eidleinfersel    false                       NOVAL             pipe_rx_eidleinfersel        conduit           end             true    split_interfaces        3                   CHANNELS      NOVAL}\
   {pipe_rx_elecidle              output    output        CHANNELS      pipe_rx_elecidle         false                       NOVAL             pipe_rx_elecidle             conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   \
   {hip_aib_data_in               input     input         CHANNELS*101  hip_aib_data_in          false                       NOVAL             hip_aib_data_in              conduit           end             true    split_interfaces        101                 CHANNELS      NOVAL}\
   {hip_aib_data_out              output    output        CHANNELS*132  hip_aib_data_out         false                       NOVAL             hip_aib_data_out             conduit           end             true    split_interfaces        132                 CHANNELS      NOVAL}\
   {hip_pcs_data_in               input     input         CHANNELS*92   hip_pcs_data_in          false                       NOVAL             hip_pcs_data_in              conduit           end             true    split_interfaces        92                  CHANNELS      NOVAL}\
   {hip_pcs_data_out              output    output        CHANNELS*62   hip_pcs_data_out         false                       NOVAL             hip_pcs_data_out             conduit           end             true    split_interfaces        62                  CHANNELS      NOVAL}\
   {hip_aib_fsr_in                input     input         CHANNELS*4    hip_aib_fsr_in           false                       NOVAL             hip_aib_fsr_in               conduit           end             true    split_interfaces        4                   CHANNELS      NOVAL}\
   {hip_aib_ssr_in                input     input         CHANNELS*40   hip_aib_ssr_in           false                       NOVAL             hip_aib_ssr_in               conduit           end             true    split_interfaces        40                  CHANNELS      NOVAL}\
   {hip_aib_fsr_out               output    output        CHANNELS*4    hip_aib_fsr_out          false                       NOVAL             hip_aib_fsr_out              conduit           end             true    split_interfaces        4                   CHANNELS      NOVAL}\
   {hip_aib_ssr_out               output    output        CHANNELS*8    hip_aib_ssr_out          false                       NOVAL             hip_aib_ssr_out              conduit           end             true    split_interfaces        8                   CHANNELS      NOVAL}\
   {hip_cal_done                  output    output        CHANNELS      hip_cal_done             false                       NOVAL             hip_cal_done                 conduit           end             true    split_interfaces        1                   CHANNELS      NOVAL}\
   \
   {reconfig_clk                  input     input         1             reconfig_clk             !HIP_RECONFIG_ENABLE        NOVAL             reconfig_clk                 conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {reconfig_reset                input     input         1             reconfig_reset           !HIP_RECONFIG_ENABLE        NOVAL             reconfig_reset               conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {reconfig_write                input     input         1             reconfig_write           !HIP_RECONFIG_ENABLE        NOVAL             reconfig_write               conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {reconfig_read                 input     input         1             reconfig_read            !HIP_RECONFIG_ENABLE        NOVAL             reconfig_read                conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {reconfig_address              input     input         14            reconfig_address         !HIP_RECONFIG_ENABLE        NOVAL             reconfig_address             conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {reconfig_writedata            input     input         32            reconfig_writedata       !HIP_RECONFIG_ENABLE        NOVAL             reconfig_writedata           conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {reconfig_readdata             output    output        32            reconfig_readdata        !HIP_RECONFIG_ENABLE        NOVAL             reconfig_readdata            conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
   {reconfig_waitrequest          output    output        1             reconfig_waitrequest     !HIP_RECONFIG_ENABLE        NOVAL             reconfig_waitrequest         conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
  }
}

proc ::altera_xcvr_pcie_hip_native_s10::declare_module { {device_family "Stratix 10"} } {
  variable interfaces
  variable parameters
  variable module
  variable filesets

  ip_declare_module $module
  ip_declare_filesets $filesets
  ip_declare_parameters $parameters
  ip_set "parameter.unique_string.SYSTEM_INFO" GENERATION_ID
  ip_set "parameter.device_family.SYSTEM_INFO" DEVICE_FAMILY
  ip_set "parameter.device_family.DEFAULT_VALUE" $device_family
  ip_set "parameter.design_environment.SYSTEM_INFO" DESIGN_ENVIRONMENT
  ip_set "parameter.device.SYSTEM_INFO" DEVICE
  ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
  ip_set "parameter.base_device.SYSTEM_INFO_ARG" BASE_DEVICE

  ip_set_auto_conduit_in_native_mode 1
  ip_set_iface_split_suffix "_ch"
  ip_declare_interfaces $interfaces
}

proc ::altera_xcvr_pcie_hip_native_s10::altera_xcvr_pcie_hip_native_s10_val_callback {} {  
  ip_validate_parameters
}

proc ::altera_xcvr_pcie_hip_native_s10::altera_xcvr_pcie_hip_native_s10_elab_callback {} {
  ::altera_xcvr_pcie_hip_native_s10::elaborate_add_hdl_instance
  ip_elaborate_interfaces
}

# Create Validation Call Backs
proc ::altera_xcvr_pcie_hip_native_s10::validate_hip_gen3_rm_fifo { HIP_PROTOCOL_MODE } {
  if { $HIP_PROTOCOL_MODE == "pipe_g3" } {
    ip_set "parameter.HIP_GEN3_RM_FIFO.value" "600 ppm" 
  } else {
    ip_set "parameter.HIP_GEN3_RM_FIFO.value" "Bypass"
  }
}

proc ::altera_xcvr_pcie_hip_native_s10::validate_hip_data_rate { HIP_PROTOCOL_MODE } {
  if { $HIP_PROTOCOL_MODE == "pipe_g1" } {
    ip_set "parameter.HIP_DATA_RATE.value" 2500 
  } elseif { $HIP_PROTOCOL_MODE == "pipe_g2" } {
    ip_set "parameter.HIP_DATA_RATE.value" 5000
  } else {
    ip_set "parameter.HIP_DATA_RATE.value" 5000
  }
}

proc ::altera_xcvr_pcie_hip_native_s10::validate_hip_prot_mode { HIP_PROTOCOL_MODE } {
  if { $HIP_PROTOCOL_MODE == "pipe_g1" } {
    ip_set "parameter.HIP_PROT_MODE.value" "gen1"
  } elseif { $HIP_PROTOCOL_MODE == "pipe_g2" } {
    ip_set "parameter.HIP_PROT_MODE.value" "gen2"
  } else {
    ip_set "parameter.HIP_PROT_MODE.value" "gen3"
  }
}

proc ::altera_xcvr_pcie_hip_native_s10::validate_hip_bonded_mode { USED_CHANNELS } {
  if { $USED_CHANNELS == 1 } {
    ip_set "parameter.HIP_BONDED_MODE.value" "not_bonded"
  } else {
    ip_set "parameter.HIP_BONDED_MODE.value" "pma_pcs"
  }
}

proc ::altera_xcvr_pcie_hip_native_s10::validate_hip_tx_pll_num { HIP_PROTOCOL_MODE USED_CHANNELS } {
  if { $USED_CHANNELS == 1 && $HIP_PROTOCOL_MODE == "pipe_g3" } {
    ip_set "parameter.HIP_TX_PLL_NUM.value" 2
  } else {
    ip_set "parameter.HIP_TX_PLL_NUM.value" 1
  }
}

proc ::altera_xcvr_pcie_hip_native_s10::validate_hip_channels { USED_CHANNELS } {
  ip_set "parameter.hip_channels.value" "x$USED_CHANNELS"
}

proc ::altera_xcvr_pcie_hip_native_s10::validate_channels { USED_CHANNELS } {
  ip_set "parameter.CHANNELS.value" [expr $USED_CHANNELS == 16 ? 16 : 8]
}

# table to deocde the values of each channels bonding mode
proc ::altera_xcvr_pcie_hip_native_s10::decode_pcs_bonding_mode { channel_num master_channel } {
  if        { $channel_num == $master_channel }  { return "ctrl_master"  
  } elseif  { $channel_num >  $master_channel }  { return "ctrl_slave_abv"     
  } else                                         { return "ctrl_slave_blw"  
  }
}

# table to decode the values for the channels bonding mode compensation counter
proc ::altera_xcvr_pcie_hip_native_s10::decode_pcs_bonding_comp { used_channels channel_num master_channel } {
  set max_distance_above    [expr $used_channels - $master_channel - 1]
  set max_bonding_comp_cnt  [expr ($master_channel > $max_distance_above) ? $master_channel : $max_distance_above]
  set count_value           [expr abs($max_bonding_comp_cnt - abs($channel_num - $master_channel))]
  return [expr 2 * $count_value]
}

# table to deocde the values of each aib's bonding mode
proc ::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_mode { channel_num } {
  if        { $channel_num == 0 }  { return "ctrl_master_bot"  
  } elseif  { $channel_num == 3 }  { return "ctrl_slave_top"  
  } elseif  { $channel_num == 4 }  { return "ctrl_master_bot" 
  } elseif  { $channel_num == 7 }  { return "ctrl_slave_top"  
  } elseif  { $channel_num == 8 }  { return "ctrl_master_bot" 
  } elseif  { $channel_num == 15 } { return "ctrl_slave_top"  
  } else                           { return "ctrl_slave_abv"  
  }
}

# table to decode the values for the aib bonding mode compensation counter
proc ::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_comp { channel_num } {
  if        { $channel_num == 0 } { return 6                               
  } elseif  { $channel_num == 1 } { return 4                               
  } elseif  { $channel_num == 2 } { return 2                               
  } elseif  { $channel_num == 3 } { return 0                               
  } elseif  { $channel_num == 4 } { return 6                               
  } elseif  { $channel_num == 5 } { return 4                               
  } elseif  { $channel_num == 6 } { return 2                               
  } elseif  { $channel_num == 7 } { return 0                               
  } else                          { return [expr (15 - $channel_num) * 2]  
  }
}

# table to decode the master channel
proc ::altera_xcvr_pcie_hip_native_s10::decode_master_channel { total_channels } {
  if        { $total_channels == "1" }   { return 0                             
  } elseif  { $total_channels == "2" }   { return 1                           
  } elseif  { $total_channels == "4" }   { return 1                             
  } elseif  { $total_channels == "8" }   { return 1                             
  } elseif  { $total_channels == "16" }  { return 7 
  }
}

# Defaults:
#  manual_pcs_bonding_mode                 = indiv
#  manual_pcs_bonding_comp_cnt             = 0
#  manual_tx_hssi_aib_bonding_mode         = indiv
#  manual_tx_hssi_aib_bonding_comp_cnt     = 0
#  manual_tx_core_aib_bonding_mode         = indiv
#  manual_tx_core_aib_bonding_comp_cnt     = 0
#  manual_rx_hssi_aib_bonding_mode         = indiv
#  manual_rx_hssi_aib_bonding_comp_cnt     = 0
#  manual_rx_core_aib_bonding_mode         = indiv
#  manual_rx_core_aib_bonding_comp_cnt     = 0
proc ::altera_xcvr_pcie_hip_native_s10::decode_channel_param_values { native_inst pcie_powered_channels master_channel channel_num pcie_gen } {
  # If we are in x16 then the bonding is very different from x1-x8
  # Handle PCS bonding
  if { ($pcie_powered_channels > 1) && ($channel_num < $pcie_powered_channels) } {
    set bonding_mode    [::altera_xcvr_pcie_hip_native_s10::decode_pcs_bonding_mode $channel_num $master_channel]
    set bonding_comp    [::altera_xcvr_pcie_hip_native_s10::decode_pcs_bonding_comp $pcie_powered_channels $channel_num $master_channel]
    set_instance_parameter_value $native_inst {manual_pcs_bonding_mode}     $bonding_mode
    set_instance_parameter_value $native_inst {manual_pcs_bonding_comp_cnt} $bonding_comp
  }
  
  # Handle configuring the bonding in x16 mode
  if { $pcie_powered_channels == 16 && $pcie_gen == "pipe_g3"} {
    # If we have more then 8 channels, switch to debug_chnl rather than user_chnl
    if { $channel_num >=8 } {
      set_instance_parameter_value $native_inst {hip_mode} {debug_chnl}
      set_instance_parameter_value $native_inst {tx_clkout_sel} {pcs_clkout}
      set_instance_parameter_value $native_inst {enable_port_tx_clkout2} {1}
      set_instance_parameter_value $native_inst {tx_clkout2_sel} {pcs_x2_clkout}
      set_instance_parameter_value $native_inst {rx_clkout_sel} {pcs_clkout}
    }

    # If channels are 0-3, bond tx(aib) indiv tx(pcs), master (1)
    if { $channel_num < 4 } {
      set bonding_mode  [::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_mode $channel_num]
      set bonding_comp  [::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_comp $channel_num]
      set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_mode}     $bonding_mode
      set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_comp_cnt} $bonding_comp
      set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_mode}     $bonding_mode
      set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_comp_cnt} $bonding_comp
      set_instance_parameter_value $native_inst {manual_tx_hssi_aib_indv} {indv_en}
      set_instance_parameter_value $native_inst {manual_rx_hssi_aib_indv} {indv_en}
      set_instance_parameter_value $native_inst {manual_tx_core_aib_indv} {indv_dis}
      set_instance_parameter_value $native_inst {manual_rx_core_aib_indv} {indv_en}
      
    # If channels are 4-7, bond rx(pcs) indiv rx(aib), master(4)
    # If channels are 8-15, bond rx, bond tx, master(8)
    } else {

      # Set bonding
      set bonding_mode  [::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_mode $channel_num]
      set bonding_comp  [::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_comp $channel_num]
      set_instance_parameter_value $native_inst {manual_rx_core_aib_bonding_mode}     $bonding_mode
      set_instance_parameter_value $native_inst {manual_rx_core_aib_bonding_comp_cnt} $bonding_comp
      set_instance_parameter_value $native_inst {manual_rx_hssi_aib_bonding_mode}     $bonding_mode
      set_instance_parameter_value $native_inst {manual_rx_hssi_aib_bonding_comp_cnt} $bonding_comp
      set_instance_parameter_value $native_inst {manual_tx_hssi_aib_indv} {indv_en}
      set_instance_parameter_value $native_inst {manual_rx_hssi_aib_indv} {indv_dis}
      set_instance_parameter_value $native_inst {manual_tx_core_aib_indv} {indv_en}
      set_instance_parameter_value $native_inst {manual_rx_core_aib_indv} {indv_en}

      if { $channel_num >= 8 } {

        # Set FIFO PFULL
        set_instance_parameter_value $native_inst {tx_fifo_pfull} {5}
        set_instance_parameter_value $native_inst {rx_fifo_pfull} {5}

        # Set bonding for debug channels
        set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_mode}     $bonding_mode
        set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_comp_cnt} $bonding_comp
        set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_mode}     $bonding_mode
        set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_comp_cnt} $bonding_comp
        set_instance_parameter_value $native_inst {manual_tx_core_aib_indv} {indv_dis}
        set_instance_parameter_value $native_inst {manual_rx_core_aib_indv} {indv_dis}
        set_instance_parameter_value $native_inst {manual_tx_hssi_aib_indv} {indv_dis}
        set_instance_parameter_value $native_inst {manual_rx_hssi_aib_indv} {indv_dis}
      }
    } 
    
  # handle all other cases
  } else {

    # disable channels if the channel number is greater than the number of channels else handle the pcs bonding
    if { $channel_num >= $pcie_powered_channels } {
      set_instance_parameter_value $native_inst {protocol_mode} {disabled} 
      set_instance_parameter_value $native_inst {enable_channel_powerdown} {1}
      set_instance_parameter_value $native_inst {rx_ppm_detect_threshold} {other}
      set_instance_parameter_value $native_inst {std_tx_byte_ser_mode} {Disabled}
      set_instance_parameter_value $native_inst {std_rx_byte_deser_mode} {Disabled}
      set_instance_parameter_value $native_inst {std_tx_8b10b_disp_ctrl_enable} {0}
      set_instance_parameter_value $native_inst {std_rx_rmfifo_mode} {disabled}
      set_instance_parameter_value $native_inst {std_rx_word_aligner_pattern} {0}
      set_instance_parameter_value $native_inst {std_rx_word_aligner_renumber} {3}
      set_instance_parameter_value $native_inst {std_rx_word_aligner_rgnumber} {3}
      set_instance_parameter_value $native_inst {enable_ports_adaptation} {1}
      set_instance_parameter_value $native_inst {pcie_rate_match} {Bypass}
      set_instance_parameter_value $native_inst {std_rx_rmfifo_pattern_n} {0}
      set_instance_parameter_value $native_inst {std_rx_rmfifo_pattern_p} {0}
    }

    # Set bonding for AIB
    if { $channel_num < 4 } {
      set bonding_mode  [::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_mode $channel_num]
      set bonding_comp  [::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_comp $channel_num]
      set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_mode}     $bonding_mode
      set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_comp_cnt} $bonding_comp
      set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_mode}     $bonding_mode
      set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_comp_cnt} $bonding_comp
      # Set the indv settings for the AIB
      set_instance_parameter_value $native_inst {manual_tx_hssi_aib_indv} {indv_dis}
      set_instance_parameter_value $native_inst {manual_rx_hssi_aib_indv} {indv_en}
      set_instance_parameter_value $native_inst {manual_tx_core_aib_indv} {indv_dis}
      set_instance_parameter_value $native_inst {manual_rx_core_aib_indv} {indv_en}
    
    # If channels are 4-7, bond rx(pcs) indiv rx(aib), master(4)
    # If channels are 8-15, bond rx, bond tx, master(8)
    } else {
      set bonding_mode  [::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_mode $channel_num]
      set bonding_comp  [::altera_xcvr_pcie_hip_native_s10::decode_aib_bonding_comp $channel_num]
      set_instance_parameter_value $native_inst {manual_rx_core_aib_bonding_mode}     $bonding_mode
      set_instance_parameter_value $native_inst {manual_rx_core_aib_bonding_comp_cnt} $bonding_comp
      set_instance_parameter_value $native_inst {manual_rx_hssi_aib_bonding_mode}     $bonding_mode
      set_instance_parameter_value $native_inst {manual_rx_hssi_aib_bonding_comp_cnt} $bonding_comp
      set_instance_parameter_value $native_inst {manual_tx_hssi_aib_indv} {indv_en}
      set_instance_parameter_value $native_inst {manual_rx_hssi_aib_indv} {indv_dis}
      set_instance_parameter_value $native_inst {manual_tx_core_aib_indv} {indv_en} 
      set_instance_parameter_value $native_inst {manual_rx_core_aib_indv} {indv_dis}

      if { $channel_num >= 8 } {
        # Set AIB to DEBUG
        set_instance_parameter_value $native_inst {hip_mode} {debug_chnl}
        set_instance_parameter_value $native_inst {tx_clkout_sel} {pcs_clkout}
        set_instance_parameter_value $native_inst {enable_port_tx_clkout2} {1}
        set_instance_parameter_value $native_inst {tx_clkout2_sel} {pcs_x2_clkout}
        set_instance_parameter_value $native_inst {rx_clkout_sel} {pcs_clkout}

        # Change bonding to match debug channels
        set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_mode}     $bonding_mode
        set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_comp_cnt} $bonding_comp
        set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_mode}     $bonding_mode
        set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_comp_cnt} $bonding_comp
        set_instance_parameter_value $native_inst {manual_tx_core_aib_indv} {indv_dis}
        set_instance_parameter_value $native_inst {manual_rx_core_aib_indv} {indv_dis}
        set_instance_parameter_value $native_inst {manual_tx_hssi_aib_indv} {indv_dis}
        set_instance_parameter_value $native_inst {manual_rx_hssi_aib_indv} {indv_dis}

        # Set FIFO PFULL
        set_instance_parameter_value $native_inst {tx_fifo_pfull} {5}
        set_instance_parameter_value $native_inst {rx_fifo_pfull} {5}
      }
    } 
  }
}

# TODO: Figure out how the tx_bonding clocks are going to be used in 1 channel designs given that manual bonding is enabled
proc ::altera_xcvr_pcie_hip_native_s10::elaborate_add_hdl_instance { } {
  set pcie_powered_channels   [ip_get "parameter.USED_CHANNELS.value"]
  set total_channels          [ip_get "parameter.CHANNELS.value"]
  set master_channel          [::altera_xcvr_pcie_hip_native_s10::decode_master_channel $pcie_powered_channels]
  set pcie_gen                [ip_get "parameter.HIP_PROTOCOL_MODE.value"]
  set unique_identifier       [ip_get "parameter.unique_string.value"]

  for { set i 0 } { $i < $total_channels} { incr i } {
    #set native_inst "altera_xcvr_pcie_hip_native_channel_s10_ch${i}"
    set native_inst "altera_xcvr_pcie_hip_channel_s10_ch${i}_$unique_identifier"
    add_hdl_instance $native_inst altera_xcvr_native_s10
    # TODO: this line should be changed to error....
    set_instance_parameter_value $native_inst {message_level} {error}
    #set_instance_parameter_value $native_inst {message_level} {warning}

    # Set device info
    set_instance_parameter_value $native_inst {device_family}       [ip_get "parameter.device_family.value"]
    set_instance_parameter_value $native_inst {device}              [ip_get "parameter.device.value"]
    set_instance_parameter_value $native_inst {base_device}         [ip_get "parameter.base_device.value"]
    set_instance_parameter_value $native_inst {design_environment}  [ip_get "parameter.design_environment.value"]

    # Parameter values that need to be resolved based upon the protocol mode
    set_instance_parameter_value $native_inst {protocol_mode}   [ip_get "parameter.HIP_PROTOCOL_MODE.value"]
    set_instance_parameter_value $native_inst {set_data_rate}   [ip_get "parameter.HIP_DATA_RATE.value"]
    set_instance_parameter_value $native_inst {pcie_rate_match} [ip_get "parameter.HIP_GEN3_RM_FIFO.value"]
    set_instance_parameter_value $native_inst {plls}            [ip_get "parameter.HIP_TX_PLL_NUM.value"]
    set_instance_parameter_value $native_inst {bonded_mode}     [ip_get "parameter.HIP_BONDED_MODE.value"]
    set_instance_parameter_value $native_inst {hip_prot_mode}   [ip_get "parameter.HIP_PROT_MODE.value"]
    set_instance_parameter_value $native_inst {hip_channels}    [ip_get "parameter.HIP_CHANNELS.value"]
    set_instance_parameter_value $native_inst {pll_select}      {0}

    # TODO: Does this need to be set to 600?
    #set_instance_parameter_value xcvr_native_s10_0 {rx_ppm_detect_threshold} {other}

    # Set FIFO PFULL
    set_instance_parameter_value $native_inst {tx_fifo_pfull} {10}
    set_instance_parameter_value $native_inst {rx_fifo_pfull} {10}

    set_instance_parameter_value $native_inst {set_cdr_refclk_freq} {100.000}
    set_instance_parameter_value $native_inst {enable_manual_bonding_settings} {1}
    set_instance_parameter_value $native_inst {enable_hip} {1}
    set_instance_parameter_value $native_inst {rcfg_enable} {1}
    set_instance_parameter_value $native_inst {hip_mode} {user_chnl}
    set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_mode} {individual}
    set_instance_parameter_value $native_inst {manual_tx_hssi_aib_bonding_comp_cnt} {0}
    set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_mode} {individual}
    set_instance_parameter_value $native_inst {manual_tx_core_aib_bonding_comp_cnt} {0}
    set_instance_parameter_value $native_inst {manual_rx_hssi_aib_bonding_mode} {individual}
    set_instance_parameter_value $native_inst {manual_rx_hssi_aib_bonding_comp_cnt} {0}
    set_instance_parameter_value $native_inst {manual_rx_core_aib_bonding_mode} {individual}
    set_instance_parameter_value $native_inst {manual_rx_core_aib_bonding_comp_cnt} {0}
    set_instance_parameter_value $native_inst {enable_hard_reset} {1}
    set_instance_parameter_value $native_inst {set_hip_cal_en} {1}
    set_instance_parameter_value $native_inst {std_tx_byte_ser_mode} {Serialize x4}
    set_instance_parameter_value $native_inst {std_rx_byte_deser_mode} {Deserialize x4}
    set_instance_parameter_value $native_inst {std_tx_8b10b_enable} {1}
    set_instance_parameter_value $native_inst {std_tx_8b10b_disp_ctrl_enable} {1}
    set_instance_parameter_value $native_inst {std_rx_8b10b_enable} {1}
    set_instance_parameter_value $native_inst {std_rx_rmfifo_mode} {pipe}
    set_instance_parameter_value $native_inst {std_rx_rmfifo_pattern_n} {192892}
    set_instance_parameter_value $native_inst {std_rx_rmfifo_pattern_p} {855683}
    set_instance_parameter_value $native_inst {std_rx_word_aligner_mode} {synchronous state machine}
    set_instance_parameter_value $native_inst {std_rx_word_aligner_pattern_len} {10}
    set_instance_parameter_value $native_inst {std_rx_word_aligner_pattern} {380.0}
    set_instance_parameter_value $native_inst {std_rx_word_aligner_renumber} {16}
    set_instance_parameter_value $native_inst {std_rx_word_aligner_rgnumber} {15}
    set_instance_parameter_value $native_inst {enable_ports_pipe_sw} {1}
    set_instance_parameter_value $native_inst {enable_ports_pipe_rx_elecidle} {1}
    set_instance_parameter_value $native_inst {enable_ports_pipe_hclk} {1}
    set_instance_parameter_value $native_inst {tx_clkout_sel} {pcs_clkout}
    set_instance_parameter_value $native_inst {enable_port_tx_clkout2} {1}
    set_instance_parameter_value $native_inst {tx_clkout2_sel} {pcs_x2_clkout}
    set_instance_parameter_value $native_inst {rx_clkout_sel} {pcs_clkout}
    set_instance_parameter_value $native_inst {pcs_reset_sequencing_mode} {bonded}
    ::altera_xcvr_pcie_hip_native_s10::decode_channel_param_values $native_inst $pcie_powered_channels $master_channel $i $pcie_gen
  }
}

# Enable the design to be run off of a terp file
proc ::altera_xcvr_pcie_hip_native_s10::callback_elaborate_altera_terp { entity ip_name random_str } {
  # Set a file handle, read the file contents, then close the handle
  set template_fh [open "altera_xcvr_pcie_hip_native_s10.sv.terp"]
  set template [read $template_fh]
  close $template_fh

  # Setup the parameters for the terp file
  set params(output_name)         $entity
  set params(random_str)          $random_str
  set params(ip_name)             $ip_name
  set params(num_channels)        [ip_get "parameter.CHANNELS.value"]
  set params(used_channels)       [ip_get "parameter.USED_CHANNELS.value"]
  set params(unique_identifier)   [ip_get "parameter.unique_string.value"]
  set params(protocol_mode)       [ip_get "parameter.HIP_PROTOCOL_MODE.value"]
  set params(aib_bonding_chnl)    1
  set params(aib_debug_clock)     8
  set params(address_bits)        11
  set params(avmm_data_width)     32
  set params(sel_bit_width)       4
  set params(master_channel)      [decode_master_channel [ip_get "parameter.USED_CHANNELS.value"]]

  # elaborate the terp file
  return [altera_terp $template params]
}

# Enable the design to be run off of a terp file
proc ::altera_xcvr_pcie_hip_native_s10::callback_elaborate_sdc { entity ip_name random_str } {
  # Set a file handle, read the file contents, then close the handle
  set template_fh [open "altera_xcvr_pcie_hip_native_s10.sdc.terp"]
  set template [read $template_fh]
  close $template_fh

  # Setup the parameters for the terp file
  set params(output_name)         $entity
  set params(random_str)          $random_str
  set params(ip_name)             $ip_name
  set params(num_channels)        [ip_get "parameter.CHANNELS.value"]
  set params(used_channels)       [ip_get "parameter.USED_CHANNELS.value"]
  set params(unique_identifier)   [ip_get "parameter.unique_string.value"]
  set params(protocol_mode)       [ip_get "parameter.HIP_PROTOCOL_MODE.value"]
  set params(aib_bonding_chnl)    1
  set params(aib_debug_clock)     8
  set params(address_bits)        11
  set params(avmm_data_width)     32
  set params(sel_bit_width)       4
  set params(master_channel)      [decode_master_channel [ip_get "parameter.USED_CHANNELS.value"]]

  # elaborate the terp file
  return [altera_terp $template params]
}

proc ::altera_xcvr_pcie_hip_native_s10::callback_quartus_synth { entity } {
  regexp -nocase {(\w+)_altera_xcvr_pcie_hip_native_s10_(\w+)_(\w+)} $entity matched ip_name release_number random_str
  add_fileset_file ./$entity.sv                           SYSTEM_VERILOG TEXT [::altera_xcvr_pcie_hip_native_s10::callback_elaborate_altera_terp $entity $ip_name $random_str]
  add_fileset_file ./$entity.sdc                          SDC TEXT            [::altera_xcvr_pcie_hip_native_s10::callback_elaborate_sdc $entity $ip_name $random_str]
  add_fileset_file altera_xcvr_native_s10_functions_h.sv  SYSTEM_VERILOG PATH ../../altera_xcvr_native_phy/altera_xcvr_native_s10/source/altera_xcvr_native_s10_functions_h.sv
  add_fileset_file alt_xcvr_native_dig_reset_seq.sv       SYSTEM_VERILOG PATH ../../altera_xcvr_native_phy/altera_xcvr_native_s10/source/alt_xcvr_native_dig_reset_seq.sv
  add_fileset_file alt_xcvr_resync_std.sv                 SYSTEM_VERILOG PATH ../../alt_xcvr_generic/alt_xcvr_resync_std.sv
}

proc ::altera_xcvr_pcie_hip_native_s10::callback_sim_verilog { entity } {
  regexp -nocase {(\w+)_altera_xcvr_pcie_hip_native_s10_(\w+)_(\w+)} $entity matched ip_name release_number random_str
  add_fileset_file ./$entity.sv                           SYSTEM_VERILOG TEXT [::altera_xcvr_pcie_hip_native_s10::callback_elaborate_altera_terp $entity $ip_name $random_str]
  add_fileset_file altera_xcvr_native_s10_functions_h.sv  SYSTEM_VERILOG PATH ../../altera_xcvr_native_phy/altera_xcvr_native_s10/source/altera_xcvr_native_s10_functions_h.sv
  add_fileset_file alt_xcvr_native_dig_reset_seq.sv       SYSTEM_VERILOG PATH ../../altera_xcvr_native_phy/altera_xcvr_native_s10/source/alt_xcvr_native_dig_reset_seq.sv
  add_fileset_file alt_xcvr_resync_std.sv                 SYSTEM_VERILOG PATH ../../alt_xcvr_generic/alt_xcvr_resync_std.sv
}

proc ::altera_xcvr_pcie_hip_native_s10::callback_sim_vhdl { entity } {
  regexp -nocase {(\w+)_altera_xcvr_pcie_hip_native_s10_(\w+)_(\w+)} $entity matched ip_name release_number random_str
  add_fileset_file ./$entity.sv                           SYSTEM_VERILOG TEXT [::altera_xcvr_pcie_hip_native_s10::callback_elaborate_altera_terp $entity $ip_name $random_str]
  add_fileset_file altera_xcvr_native_s10_functions_h.sv  SYSTEM_VERILOG PATH ../../altera_xcvr_native_phy/altera_xcvr_native_s10/source/altera_xcvr_native_s10_functions_h.sv
  add_fileset_file alt_xcvr_native_dig_reset_seq.sv       SYSTEM_VERILOG PATH ../../altera_xcvr_native_phy/altera_xcvr_native_s10/source/alt_xcvr_native_dig_reset_seq.sv
  add_fileset_file alt_xcvr_resync_std.sv                 SYSTEM_VERILOG PATH ../../alt_xcvr_generic/alt_xcvr_resync_std.sv
}

::altera_xcvr_pcie_hip_native_s10::declare_module
