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


# +----------------------------------
# | 
# | SDI II ED Loopback v12.1
# | Intel Corporation 2011.08.19.17:10:07
# | 
# +-----------------------------------

package require -exact qsys 16.0

source ../sdi_ii/sdi_ii_interface.tcl
source ../sdi_ii/sdi_ii_params.tcl

# +-----------------------------------------------
# | module SDI II Example Design Parallel Loopback
# | 
set_module_property DESCRIPTION "SDI II ED Loopback"
set_module_property NAME sdi_ii_ed_loopback
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SDI II/SDI II ED Loopback"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II ED Loopback"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
# set_module_property TOP_LEVEL_HDL_FILE src_hdl/sdi_ii_ed_loopback.v
# set_module_property TOP_LEVEL_HDL_MODULE sdi_ii_ed_loopback
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property SIMULATION_MODEL_IN_VERILOG true
#set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property ELABORATION_CALLBACK elaboration_callback

# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 

add_fileset simulation_verilog SIM_VERILOG   generate_files
add_fileset simulation_vhdl    SIM_VHDL      generate_files
add_fileset synthesis_fileset  QUARTUS_SYNTH generate_files

set_fileset_property simulation_verilog TOP_LEVEL   sdi_ii_ed_loopback
set_fileset_property simulation_vhdl    TOP_LEVEL   sdi_ii_ed_loopback
set_fileset_property synthesis_fileset  TOP_LEVEL   sdi_ii_ed_loopback

proc generate_files {name} {
   add_fileset_file sdi_ii_ed_loopback.v     VERILOG PATH src_hdl/sdi_ii_ed_loopback.v
   add_fileset_file sdi_ii_ed_loopback.sdc   SDC     PATH src_hdl/sdi_ii_ed_loopback.sdc
}

#set module_dir [get_module_property MODULE_DIRECTORY]
#add_file ${module_dir}/src_hdl/sdi_ii_ed_loopback.v   {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_ed_loopback.sdc {SDC}


# | 
# +-----------------------------------

sdi_ii_common_params
set_parameter_property DIRECTION               HDL_PARAMETER false
set_parameter_property TRANSCEIVER_PROTOCOL    HDL_PARAMETER false
#set_parameter_property VIDEO_STANDARD        HDL_PARAMETER false
set_parameter_property RX_INC_ERR_TOLERANCE    HDL_PARAMETER false
set_parameter_property RX_CRC_ERROR_OUTPUT     HDL_PARAMETER false
#set_parameter_property RX_EN_TRS_MISC          HDL_PARAMETER false
set_parameter_property RX_EN_VPID_EXTRACT      HDL_PARAMETER false
set_parameter_property TX_HD_2X_OVERSAMPLING   HDL_PARAMETER false
set_parameter_property TX_EN_VPID_INSERT       HDL_PARAMETER false
set_parameter_property SD_BIT_WIDTH            HDL_PARAMETER false
set_parameter_property XCVR_TX_PLL_SEL         HDL_PARAMETER false
set_parameter_property HD_FREQ                 HDL_PARAMETER false

set common_composed_mode 0

proc elaboration_callback {} {
  set  insert_vpid   [get_parameter_value TX_EN_VPID_INSERT]  
  set  extract_vpid  [get_parameter_value RX_EN_VPID_EXTRACT]
  set  a2b           [get_parameter_value RX_EN_A2B_CONV]
  set  b2a           [get_parameter_value RX_EN_B2A_CONV]
  set  std           [get_parameter_value VIDEO_STANDARD]
  
  if {$std == "mr"} {
      set num_streams 4
  } else {
      set num_streams 1
  }

  common_add_clock             rx_clk           input  true
  common_add_clock             tx_clk           input  true 
  # common_add_reset             tx_rst           input  tx_clk

  common_add_optional_conduit  rx_rst                export  input   1                  true  
  common_add_optional_conduit  rx_data               export  input  20*$num_streams     true
  common_add_optional_conduit  rx_data_valid         export  input   1                  true
  common_add_optional_conduit  rx_data_valid         export  input   1                  true
  common_add_optional_conduit  tx_data_valid         export  input   1                  true
  common_add_optional_conduit  tx_data               export  output 20*$num_streams     true
  common_add_optional_conduit  tx_data_valid_out     export  output  1                  true
  common_add_optional_conduit  rx_trs                export  input   1*$num_streams     true
  common_add_optional_conduit  tx_trs                export  output  1                  true  
  common_add_optional_conduit  tx_std                export  output  3                  true
  common_add_optional_conduit  rx_trs_locked         export  input   1*$num_streams     true
  common_add_optional_conduit  rx_frame_locked       export  input   1                  true
  common_add_optional_conduit  rx_std                export  input   3                  true
  common_add_optional_conduit  tx_trs_b              export  output  1                  true
  common_add_optional_conduit  tx_enable_crc         export  output  1                  true
  common_add_optional_conduit  tx_enable_ln          export  output  1                  true
  common_add_optional_conduit  tx_ln                 export  output 11*$num_streams     true
  common_add_optional_conduit  tx_ln_b               export  output 11*$num_streams     true
  common_add_optional_conduit  rx_data_b             export  input  20                  true
  common_add_optional_conduit  rx_data_valid_b       export  input   1                  true
  common_add_optional_conduit  tx_data_valid_b       export  input   1                  true
  common_add_optional_conduit  tx_data_b             export  output 20                  true
  common_add_optional_conduit  tx_data_valid_out_b   export  output  1                  true
  common_add_optional_conduit  tx_vpid_overwrite     export  output  1                  true
  common_add_optional_conduit  tx_vpid_byte1         export  output  8*$num_streams     true
  common_add_optional_conduit  tx_vpid_byte2         export  output  8*$num_streams     true
  common_add_optional_conduit  tx_vpid_byte3         export  output  8*$num_streams     true
  common_add_optional_conduit  tx_vpid_byte4         export  output  8*$num_streams     true
  common_add_optional_conduit  tx_line_f0            export  output  11*$num_streams    true
  common_add_optional_conduit  tx_line_f1            export  output  11*$num_streams    true 
  common_add_optional_conduit  tx_vpid_byte1_b       export  output  8*$num_streams     true
  common_add_optional_conduit  tx_vpid_byte2_b       export  output  8*$num_streams     true
  common_add_optional_conduit  tx_vpid_byte3_b       export  output  8*$num_streams     true
  common_add_optional_conduit  tx_vpid_byte4_b       export  output  8*$num_streams     true  
  common_add_optional_conduit  rx_ln                 export  input  11*$num_streams     true
  common_add_optional_conduit  rx_vpid_byte1         export  input   8*$num_streams     true
  common_add_optional_conduit  rx_vpid_byte2         export  input   8*$num_streams     true
  common_add_optional_conduit  rx_vpid_byte3         export  input   8*$num_streams     true
  common_add_optional_conduit  rx_vpid_byte4         export  input   8*$num_streams     true
  common_add_optional_conduit  rx_line_f0            export  input  11*$num_streams     true
  common_add_optional_conduit  rx_line_f1            export  input  11*$num_streams     true
  common_add_optional_conduit  rx_ln_b               export  input  11*$num_streams     true
  common_add_optional_conduit  rx_vpid_byte1_b       export  input   8*$num_streams     true
  common_add_optional_conduit  rx_vpid_byte2_b       export  input   8*$num_streams     true
  common_add_optional_conduit  rx_vpid_byte3_b       export  input   8*$num_streams     true
  common_add_optional_conduit  rx_vpid_byte4_b       export  input   8*$num_streams     true
 
  if { $a2b | $b2a } {
    terminate_port   rx_clk                   input 
    terminate_port   rx_rst                   input 
    terminate_port   tx_clk                   input 
    # terminate_port   tx_rst                   input 
    terminate_port   rx_trs_locked            input 
    terminate_port   rx_frame_locked          input 
  } else {
    terminate_port   rx_trs                   input
  }

  if { $a2b | $b2a | ($std != "ds" & $std != "tr" & $std != "mr" & $std != "threeg") } {
    terminate_port   rx_std                   input
  }

  if { !$a2b & $std != "ds" & !(($std == "tr" | $std == "threeg" | $std == "mr" ) & !$b2a) } {
    terminate_port   tx_std                   output
  }

  if { !$b2a & !( $std == "dl" & !$a2b) } {
    terminate_port   tx_trs_b                 output
    terminate_port   rx_data_b                input 
    terminate_port   rx_data_valid_b          input  
    terminate_port   tx_data_valid_b          input  
    terminate_port   tx_data_b                output 
    terminate_port   tx_data_valid_out_b      output
  }

  if { $std == "sd" } {
    terminate_port   tx_enable_crc            output
    terminate_port   tx_enable_ln             output
    terminate_port   tx_ln                    output
  }

  if { $std == "sd" | ($std != "dl" & $std != "tr" & $std != "mr" & $std != "threeg") } {
    terminate_port   tx_ln_b                  output
  }

  if { !$insert_vpid | $std == "sd" } {
    terminate_port   tx_vpid_overwrite        output
    terminate_port   tx_vpid_byte1            output
    terminate_port   tx_vpid_byte2            output
    terminate_port   tx_vpid_byte3            output
    terminate_port   tx_vpid_byte4            output
    terminate_port   tx_line_f0               output
    terminate_port   tx_line_f1               output
  }

  if { (!$insert_vpid | $std == "sd") | ($std != "dl" & $std != "threeg" & $std != "tr" & $std != "mr") } {
    terminate_port   tx_vpid_byte1_b          output
    terminate_port   tx_vpid_byte2_b          output
    terminate_port   tx_vpid_byte3_b          output
    terminate_port   tx_vpid_byte4_b          output
  }  
  
  if { !$extract_vpid | $std == "sd" } {
    terminate_port   rx_ln                    input
    terminate_port   rx_vpid_byte1            input 
    terminate_port   rx_vpid_byte2            input 
    terminate_port   rx_vpid_byte3            input 
    terminate_port   rx_vpid_byte4            input 
    terminate_port   rx_line_f0               input
    terminate_port   rx_line_f1               input 
  }

  if { (!$extract_vpid | $std == "sd") | ($std != "dl" & $std != "threeg" & $std != "tr" & $std != "mr") } {
    terminate_port   rx_ln_b                  input
    terminate_port   rx_vpid_byte1_b          input
    terminate_port   rx_vpid_byte2_b          input
    terminate_port   rx_vpid_byte3_b          input
    terminate_port   rx_vpid_byte4_b          input
  }    
}
