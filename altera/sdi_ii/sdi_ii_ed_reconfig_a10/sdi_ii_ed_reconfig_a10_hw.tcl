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


# +----------------------------------------
# | 
# | SDI II Reconfig Arria 10 v14.0
# | Intel Corporation 2009.08.19.17:10:07
# | 
# +----------------------------------------

package require -exact qsys 16.0
package require altera_terp

source ../sdi_ii/sdi_ii_interface.tcl
source ../sdi_ii/sdi_ii_params.tcl

# +-----------------------------------
# | module SDI II Reconfig Management
# | 
set_module_property DESCRIPTION "SDI II Reconfig Arria 10"
set_module_property NAME sdi_ii_ed_reconfig_a10
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SDI II Reconfig Arria 10"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II Reconfig Arria 10"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
# set_module_property TOP_LEVEL_HDL_FILE src_hdl/sdi_ii_ed_reconfig_mgmt.v
# set_module_property TOP_LEVEL_HDL_MODULE sdi_ii_ed_reconfig_mgmt
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property SIMULATION_MODEL_IN_VERILOG true
#set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property ELABORATION_CALLBACK elaboration_callback

# | 
# +-----------------------------------
sdi_ii_common_params
# +-----------------------------------
# | files
# | 
add_fileset simulation_verilog SIM_VERILOG   generate_files
add_fileset simulation_vhdl    SIM_VHDL      generate_files
add_fileset synthesis_fileset  QUARTUS_SYNTH generate_files

set_fileset_property simulation_verilog TOP_LEVEL   sdi_ii_ed_reconfig_a10
set_fileset_property simulation_vhdl    TOP_LEVEL   sdi_ii_ed_reconfig_a10
set_fileset_property synthesis_fileset  TOP_LEVEL   sdi_ii_ed_reconfig_a10

proc generate_files {name} {
   add_fileset_file sdi_ii_ed_reconfig_a10.sv   SYSTEM_VERILOG PATH src_hdl/sdi_ii_ed_reconfig_a10.sv
   add_fileset_file a10_reconfig_arbiter.sv     SYSTEM_VERILOG PATH src_hdl/a10_reconfig_arbiter.sv
   add_fileset_file rcfg_pll_sw.sv              SYSTEM_VERILOG PATH src_hdl/rcfg_pll_sw.sv
   add_fileset_file rcfg_refclk_sw.sv           SYSTEM_VERILOG PATH src_hdl/rcfg_refclk_sw.sv
   add_fileset_file edge_detector.sv            SYSTEM_VERILOG PATH src_hdl/edge_detector.sv
   if { [get_parameter_value VIDEO_STANDARD] == "tr" | [get_parameter_value VIDEO_STANDARD] == "mr" } {
      # Open and read terp file
      set terp_path     "src_hdl/rcfg_sdi_cdr.sv.terp"
      set terp_fd       [open $terp_path]
      set terp_contents [read $terp_fd]
      close $terp_fd

      set terp_params(param0)  [get_parameter_value VIDEO_STANDARD]
      # Expand terp w/ parameters into design file
      set top_file_contents [altera_terp $terp_contents terp_params]
      add_fileset_file rcfg_sdi_cdr.sv          SYSTEM_VERILOG TEXT $top_file_contents
   }
}

# | 
# +-----------------------------------
set common_composed_mode 0

set_parameter_property    FAMILY                 HDL_PARAMETER false
# set_parameter_property    VIDEO_STANDARD         HDL_PARAMETER false
set_parameter_property    SD_BIT_WIDTH           HDL_PARAMETER false
set_parameter_property    DIRECTION              HDL_PARAMETER false
set_parameter_property    TRANSCEIVER_PROTOCOL   HDL_PARAMETER false
set_parameter_property    HD_FREQ                HDL_PARAMETER false
set_parameter_property    XCVR_TX_PLL_SEL        HDL_PARAMETER false
set_parameter_property    RX_INC_ERR_TOLERANCE   HDL_PARAMETER false
set_parameter_property    RX_CRC_ERROR_OUTPUT    HDL_PARAMETER false
set_parameter_property    RX_EN_VPID_EXTRACT     HDL_PARAMETER false
set_parameter_property    RX_EN_A2B_CONV         HDL_PARAMETER false
set_parameter_property    RX_EN_B2A_CONV         HDL_PARAMETER false
set_parameter_property    TX_EN_VPID_INSERT      HDL_PARAMETER false
set_parameter_property    ED_TXPLL_SWITCH        HDL_PARAMETER true

add_parameter XCVR_RCFG_IF_TYPE string "channel"
set_parameter_property XCVR_RCFG_IF_TYPE ALLOWED_RANGES {"channel" "atx_pll" "fpll"}
set_parameter_property XCVR_RCFG_IF_TYPE HDL_PARAMETER true

proc elaboration_callback {} {

  set video_std    [get_parameter_value VIDEO_STANDARD]
  set txpll_switch [get_parameter_value ED_TXPLL_SWITCH]

  common_add_clock            xcvr_reconfig_clk                          input                  true
  common_add_reset            xcvr_reconfig_reset                        input                  xcvr_reconfig_clk
  if { $txpll_switch != "0" } {
    common_add_reset_associated_sinks    rst_tx_phy                        output                 xcvr_reconfig_clk       xcvr_reconfig_reset
  }

  if { $txpll_switch == "2" } {
     set avmm_itf_name reconfig_avmm0
     set avmm_itf_type avalon
  } else {
     set avmm_itf_name reconfig_avmm
     set avmm_itf_type conduit
  }
  
  add_interface rx_$avmm_itf_name $avmm_itf_type start
  add_interface tx_$avmm_itf_name $avmm_itf_type start
  if { $txpll_switch == "2" } {
    set_interface_property tx_$avmm_itf_name ASSOCIATED_CLOCK xcvr_reconfig_clk
    set_interface_property tx_$avmm_itf_name addressUnits WORDS
  }
  add_interface_port rx_$avmm_itf_name rx_xcvr_reconfig_write                 write         output  1
  add_interface_port rx_$avmm_itf_name rx_xcvr_reconfig_read                  read          output  1
  add_interface_port rx_$avmm_itf_name rx_xcvr_reconfig_address               address       output  10
  add_interface_port rx_$avmm_itf_name rx_xcvr_reconfig_writedata             writedata     output  32
  add_interface_port rx_$avmm_itf_name rx_xcvr_reconfig_readdata              readdata      input   32
  add_interface_port rx_$avmm_itf_name rx_xcvr_reconfig_waitrequest           waitrequest   input   1
  add_interface_port tx_$avmm_itf_name tx_xcvr_reconfig_write                 write         output  1
  add_interface_port tx_$avmm_itf_name tx_xcvr_reconfig_read                  read          output  1
  add_interface_port tx_$avmm_itf_name tx_xcvr_reconfig_address               address       output  10
  add_interface_port tx_$avmm_itf_name tx_xcvr_reconfig_writedata             writedata     output  32
  add_interface_port tx_$avmm_itf_name tx_xcvr_reconfig_readdata              readdata      input   32
  add_interface_port tx_$avmm_itf_name tx_xcvr_reconfig_waitrequest           waitrequest   input   1

  common_add_optional_conduit rx_analogreset_ack                          rx_analogreset_ack   input   1    true
  common_add_optional_conduit rx_cal_busy                                 rx_cal_busy   input   1    true
  common_add_optional_conduit cdr_reconfig_sel                            export        input   3    true
  common_add_optional_conduit cdr_reconfig_req                            export        input   1    true
  common_add_optional_conduit cdr_reconfig_busy                           export        output  1    true
  common_add_optional_conduit tx_analogreset_ack                          tx_analogreset_ack   input   1    true
  common_add_optional_conduit pll_powerdown                               pll_powerdown input   1    true
  common_add_optional_conduit pll_sel                                     export        input   1    true
  common_add_optional_conduit pll_sw_busy                                 export        output  1    true

  if { $video_std == "dl" } {
     common_add_optional_conduit tx_cal_busy                                 tx_cal_busy      input   2    true
  } else {
     common_add_optional_conduit tx_cal_busy                                 tx_cal_busy      input   1    true
  }

  if { $video_std != "mr" & $video_std != "tr" & $video_std != "ds" } {
     terminate_port   cdr_reconfig_sel                            input
     terminate_port   cdr_reconfig_req                            input
     terminate_port   cdr_reconfig_busy                           output
     terminate_port   rx_analogreset_ack                          input
     terminate_port   rx_cal_busy                                 input
  }

  if { $txpll_switch == "0" } {
     terminate_port   pll_sel                                     input
     terminate_port   pll_sw_busy                                 output
  }

  if { $txpll_switch != "1" } {
     terminate_port   tx_cal_busy                                 input
     terminate_port   tx_analogreset_ack                          input
  }  
  
  if { $txpll_switch != "2" } {
     terminate_port   pll_powerdown                               input
  }
  
  if { $txpll_switch == "0" } {
     terminate_port     tx_xcvr_reconfig_write                      output
     terminate_port     tx_xcvr_reconfig_read                       output
     terminate_port     tx_xcvr_reconfig_address                    output
     terminate_port     tx_xcvr_reconfig_writedata                  output
     terminate_port     tx_xcvr_reconfig_readdata                   input
     terminate_port     tx_xcvr_reconfig_waitrequest                input
  } 
  
  if { $video_std != "mr" & $video_std != "tr" } {
     terminate_port     rx_xcvr_reconfig_write                      output
     terminate_port     rx_xcvr_reconfig_read                       output
     terminate_port     rx_xcvr_reconfig_address                    output
     terminate_port     rx_xcvr_reconfig_writedata                  output
     terminate_port     rx_xcvr_reconfig_readdata                   input
     terminate_port     rx_xcvr_reconfig_waitrequest                input
  }
  
  if { $video_std == "tr" | $video_std == "mr" } {
    set qii_ver 18.1
    set split_array [split $qii_ver "."]
    set folder_suffix [concat [lindex $split_array 0][lindex $split_array 1]]

    set     qip_string  "\"set_global_assignment -library \\\"%libraryName%\\\" -name SYSTEMVERILOG_FILE \
                        \[file join \$::quartus(qip_path) \\\"altera_xcvr_native_a10_${folder_suffix}/synth/reconfig/altera_xcvr_native_a10_reconfig_parameters_CFG0.sv\\\"\]\""
    lappend qip_string  "set_global_assignment -library \"%libraryName%\" -name SYSTEMVERILOG_FILE \
                        \[file join \$::quartus(qip_path) \"altera_xcvr_native_a10_${folder_suffix}/synth/reconfig/altera_xcvr_native_a10_reconfig_parameters_CFG1.sv\"\]"

    if { $video_std == "mr" } {
        lappend qip_string  "set_global_assignment -library \"%libraryName%\" -name SYSTEMVERILOG_FILE \
                            \[file join \$::quartus(qip_path) \"altera_xcvr_native_a10_${folder_suffix}/synth/reconfig/altera_xcvr_native_a10_reconfig_parameters_CFG2.sv\"\]"
        lappend qip_string  "set_global_assignment -library \"%libraryName%\" -name SYSTEMVERILOG_FILE \
                            \[file join \$::quartus(qip_path) \"altera_xcvr_native_a10_${folder_suffix}/synth/reconfig/altera_xcvr_native_a10_reconfig_parameters_CFG3.sv\"\]"
    }
    set_qip_strings  ${qip_string}
  }
}

