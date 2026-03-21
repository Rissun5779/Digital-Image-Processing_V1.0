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
# | SDI II TX Protocol v12.0
# | Intel Corporation 2011.08.19.17:10:07
# | 
# +-----------------------------------

package require -exact qsys 16.0

source ../../sdi_ii/sdi_ii_interface.tcl
source ../../sdi_ii/sdi_ii_params.tcl

# +-----------------------------------
# | module SDI II TX Protocol
# | 
set_module_property DESCRIPTION "SDI II TX Protocol"
set_module_property NAME sdi_ii_tx_protocol
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SDI II/SDI II TX Protocol"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II TX Protocol"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
# set_module_property TOP_LEVEL_HDL_FILE src_hdl/sdi_ii_tx_protocol.v
# set_module_property TOP_LEVEL_HDL_MODULE sdi_ii_tx_protocol
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property SIMULATION_MODEL_IN_VERILOG true
#set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property ELABORATION_CALLBACK elaboration_callback

# | 
# +-----------------------------------

# +-----------------------------------
# | IEEE Encryption
# | 

add_fileset          simulation_verilog SIM_VERILOG   generate_files
add_fileset          simulation_vhdl    SIM_VHDL      generate_files
add_fileset          synthesis_fileset  QUARTUS_SYNTH generate_ed_files

set_fileset_property simulation_verilog TOP_LEVEL   sdi_ii_tx_protocol
set_fileset_property simulation_vhdl    TOP_LEVEL   sdi_ii_tx_protocol
set_fileset_property synthesis_fileset  TOP_LEVEL   sdi_ii_tx_protocol

proc generate_files {name} {
  if {1} {
    add_fileset_file mentor/src_hdl/sdi_ii_tx_protocol.v     VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_tx_protocol.v"                       {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/sdi_ii_hd_crc.v          VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_hd_crc.v"                            {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/sdi_ii_hd_insert_ln.v    VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_hd_insert_ln.v"                      {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/sdi_ii_scrambler.v       VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_scrambler.v"                         {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/sdi_ii_transmit.v        VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_transmit.v"                          {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/sdi_ii_vpid_insert.v     VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_vpid_insert.v"                       {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/sdi_ii_trsmatch.v        VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_trsmatch.v"                          {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/sdi_ii_sd_bits_conv.v    VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_sd_bits_conv.v"                      {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/sdi_ii_sync_bit_ins.v    VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_sync_bit_ins.v"                      {MENTOR_SPECIFIC}
  }
  if {1} {
    add_fileset_file aldec/src_hdl/sdi_ii_tx_protocol.v      VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_tx_protocol.v"                        {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/sdi_ii_hd_crc.v           VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_hd_crc.v"                             {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/sdi_ii_hd_insert_ln.v     VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_hd_insert_ln.v"                       {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/sdi_ii_scrambler.v        VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_scrambler.v"                          {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/sdi_ii_transmit.v         VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_transmit.v"                           {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/sdi_ii_vpid_insert.v      VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_vpid_insert.v"                        {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/sdi_ii_trsmatch.v         VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_trsmatch.v"                           {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/sdi_ii_sd_bits_conv.v     VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_sd_bits_conv.v"                       {ALDEC_SPECIFIC} 
    add_fileset_file aldec/src_hdl/sdi_ii_sync_bit_ins.v     VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_sync_bit_ins.v"                       {ALDEC_SPECIFIC} 
  }
  if {1} {
    add_fileset_file cadence/src_hdl/sdi_ii_tx_protocol.v    VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_tx_protocol.v"                        {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/sdi_ii_hd_crc.v         VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_hd_crc.v"                             {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/sdi_ii_hd_insert_ln.v   VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_hd_insert_ln.v"                       {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/sdi_ii_scrambler.v      VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_scrambler.v"                          {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/sdi_ii_transmit.v       VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_transmit.v"                           {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/sdi_ii_vpid_insert.v    VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_vpid_insert.v"                        {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/sdi_ii_trsmatch.v       VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_trsmatch.v"                           {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/sdi_ii_sd_bits_conv.v   VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_sd_bits_conv.v"                       {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/sdi_ii_sync_bit_ins.v   VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_sync_bit_ins.v"                       {CADENCE_SPECIFIC}
  }
  if {1} {
    add_fileset_file synopsys/src_hdl/sdi_ii_tx_protocol.v     VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_tx_protocol.v"                       {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/sdi_ii_hd_crc.v          VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_hd_crc.v"                            {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/sdi_ii_hd_insert_ln.v    VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_hd_insert_ln.v"                      {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/sdi_ii_scrambler.v       VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_scrambler.v"                         {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/sdi_ii_transmit.v        VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_transmit.v"                          {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/sdi_ii_vpid_insert.v     VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_vpid_insert.v"                       {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/sdi_ii_trsmatch.v        VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_trsmatch.v"                          {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/sdi_ii_sd_bits_conv.v    VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_sd_bits_conv.v"                      {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/sdi_ii_sync_bit_ins.v    VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_sync_bit_ins.v"                      {SYNOPSYS_SPECIFIC}
  }
}

#proc sim_vhd {name} {
#  if {1} {
#    add_fileset_file mentor/src_hdl/sdi_ii_tx_protocol.v   VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_tx_protocol.v"  {MENTOR_SPECIFIC}
#    add_fileset_file mentor/src_hdl/sdi_ii_hd_crc.v        VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_hd_crc.v"       {MENTOR_SPECIFIC}
#    add_fileset_file mentor/src_hdl/sdi_ii_hd_insert_ln.v  VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_hd_insert_ln.v" {MENTOR_SPECIFIC}
#    add_fileset_file mentor/src_hdl/sdi_ii_scrambler.v     VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_scrambler.v"    {MENTOR_SPECIFIC}
#    add_fileset_file mentor/src_hdl/sdi_ii_transmit.v      VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_transmit.v"     {MENTOR_SPECIFIC}
#    add_fileset_file mentor/src_hdl/sdi_ii_vpid_insert.v   VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_vpid_insert.v"  {MENTOR_SPECIFIC}
#    add_fileset_file mentor/src_hdl/sdi_ii_trsmatch.v      VERILOG_ENCRYPT PATH "mentor/src_hdl/sdi_ii_trsmatch.v"     {MENTOR_SPECIFIC}
#  }
  #if {1} {
  #  add_fileset_file aldec/src_hdl/sdi_ii_tx_protocol.v    VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_ii_tx_protocol.v"    {ALDEC_SPECIFIC}
  #  add_fileset_file aldec/src_hdl/hdsdi_crc.v             VERILOG_ENCRYPT PATH "aldec/src_hdl/hdsdi_crc.v"             {ALDEC_SPECIFIC}
  #  add_fileset_file aldec/src_hdl/hdsdi_insert_ln.v       VERILOG_ENCRYPT PATH "aldec/src_hdl/hdsdi_insert_ln.v"       {ALDEC_SPECIFIC}
  #  add_fileset_file aldec/src_hdl/sdi_scrambler.v         VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_scrambler.v"         {ALDEC_SPECIFIC}
  #  add_fileset_file aldec/src_hdl/sdi_transmit.v          VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_transmit.v"          {ALDEC_SPECIFIC}
  #  add_fileset_file aldec/src_hdl/sdi_vpid_insert.v       VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_vpid_insert.v"       {ALDEC_SPECIFIC}
  #  add_fileset_file aldec/src_hdl/sdi_trsmatch.v          VERILOG_ENCRYPT PATH "aldec/src_hdl/sdi_trsmatch.v"          {ALDEC_SPECIFIC}
  #}
  #if {1} {
  #  add_fileset_file cadence/src_hdl/sdi_ii_tx_protocol.v  VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_ii_tx_protocol.v"  {CADENCE_SPECIFIC}
  #  add_fileset_file cadence/src_hdl/hdsdi_crc.v           VERILOG_ENCRYPT PATH "cadence/src_hdl/hdsdi_crc.v"           {CADENCE_SPECIFIC}
  #  add_fileset_file cadence/src_hdl/hdsdi_insert_ln.v     VERILOG_ENCRYPT PATH "cadence/src_hdl/hdsdi_insert_ln.v"     {CADENCE_SPECIFIC}
  #  add_fileset_file cadence/src_hdl/sdi_scrambler.v       VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_scrambler.v"       {CADENCE_SPECIFIC}
  #  add_fileset_file cadence/src_hdl/sdi_transmit.v        VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_transmit.v"        {CADENCE_SPECIFIC}
  #  add_fileset_file cadence/src_hdl/sdi_vpid_insert.v     VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_vpid_insert.v"     {CADENCE_SPECIFIC}
  #  add_fileset_file cadence/src_hdl/sdi_trsmatch.v        VERILOG_ENCRYPT PATH "cadence/src_hdl/sdi_trsmatch.v"        {CADENCE_SPECIFIC}
  #}
  #if {1} {
  #  add_fileset_file synopsys/src_hdl/sdi_ii_tx_protocol.v VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_ii_tx_protocol.v" {SYNOPSYS_SPECIFIC}
  #  add_fileset_file synopsys/src_hdl/hdsdi_crc.v          VERILOG_ENCRYPT PATH "synopsys/src_hdl/hdsdi_crc.v"          {SYNOPSYS_SPECIFIC}
  #  add_fileset_file synopsys/src_hdl/hdsdi_insert_ln.v    VERILOG_ENCRYPT PATH "synopsys/src_hdl/hdsdi_insert_ln.v"    {SYNOPSYS_SPECIFIC}
  #  add_fileset_file synopsys/src_hdl/sdi_scrambler.v      VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_scrambler.v"      {SYNOPSYS_SPECIFIC}
  #  add_fileset_file synopsys/src_hdl/sdi_transmit.v       VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_transmit.v"       {SYNOPSYS_SPECIFIC}
  #  add_fileset_file synopsys/src_hdl/sdi_vpid_insert.v    VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_vpid_insert.v"    {SYNOPSYS_SPECIFIC}
  #  add_fileset_file synopsys/src_hdl/sdi_trsmatch.v       VERILOG_ENCRYPT PATH "synopsys/src_hdl/sdi_trsmatch.v"       {SYNOPSYS_SPECIFIC}
  #}
#}

# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
proc generate_ed_files {name} {
   add_fileset_file sdi_ii_tx_protocol.v       VERILOG PATH src_hdl/sdi_ii_tx_protocol.v
   add_fileset_file sdi_ii_hd_crc.v            VERILOG PATH src_hdl/sdi_ii_hd_crc.v
   add_fileset_file sdi_ii_hd_insert_ln.v      VERILOG PATH src_hdl/sdi_ii_hd_insert_ln.v 
   add_fileset_file sdi_ii_scrambler.v         VERILOG PATH src_hdl/sdi_ii_scrambler.v
   add_fileset_file sdi_ii_transmit.v          VERILOG PATH src_hdl/sdi_ii_transmit.v
   add_fileset_file sdi_ii_vpid_insert.v       VERILOG PATH src_hdl/sdi_ii_vpid_insert.v 
   add_fileset_file sdi_ii_trsmatch.v          VERILOG PATH src_hdl/sdi_ii_trsmatch.v
   add_fileset_file sdi_ii_sd_bits_conv.v      VERILOG PATH src_hdl/sdi_ii_sd_bits_conv.v
   add_fileset_file sdi_ii_sync_bit_ins.v      VERILOG PATH src_hdl/sdi_ii_sync_bit_ins.v
   add_fileset_file sdi_ii_tx_protocol.ocp     OTHER   PATH src_hdl/sdi_ii_tx_protocol.ocp
}

#set module_dir [get_module_property MODULE_DIRECTORY]
#add_file ${module_dir}/src_hdl/sdi_ii_tx_protocol.v   {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_tx_protocol.ocp {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_hd_crc.v        {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_hd_insert_ln.v  {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_scrambler.v     {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_transmit.v      {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_vpid_insert.v   {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_trsmatch.v      {SYNTHESIS}

# | 
# +-----------------------------------

sdi_ii_common_params
set_parameter_property FAMILY               HDL_PARAMETER false
set_parameter_property DIRECTION            HDL_PARAMETER false
set_parameter_property TRANSCEIVER_PROTOCOL HDL_PARAMETER false
set_parameter_property RX_EN_A2B_CONV       HDL_PARAMETER false
set_parameter_property RX_EN_B2A_CONV       HDL_PARAMETER false
set_parameter_property RX_INC_ERR_TOLERANCE HDL_PARAMETER false
# set_parameter_property RX_EN_TRS_MISC       HDL_PARAMETER false
set_parameter_property RX_EN_VPID_EXTRACT   HDL_PARAMETER false
set_parameter_property RX_CRC_ERROR_OUTPUT  HDL_PARAMETER false
set_parameter_property XCVR_TX_PLL_SEL      HDL_PARAMETER false
set_parameter_property HD_FREQ              HDL_PARAMETER false

set common_composed_mode 0

proc elaboration_callback {} {
  set family      [get_parameter_value FAMILY]
  set insert_vpid [get_parameter_value TX_EN_VPID_INSERT]
  set video_std   [get_parameter_value VIDEO_STANDARD]
  if { $video_std == "mr" } {
     set num_streams 4
  } else {
     set num_streams 1
  }

  common_add_clock              tx_pclk              input   true
  common_add_reset              tx_rst               input   tx_pclk

  common_add_optional_conduit   tx_datain_valid      export  input  1  true
  common_add_optional_conduit   tx_trs               export  input  1  true
  common_add_optional_conduit   tx_std               export  input  3  true
  common_add_optional_conduit   tx_std_out           export  output 3  true
  common_add_optional_conduit   tx_enable_ln         export  input  1  true
  common_add_optional_conduit   tx_enable_crc        export  input  1  true
  common_add_optional_conduit   tx_vpid_overwrite    export  input  1  true
  common_add_optional_conduit   tx_dataout_valid     export  output 1  true
  common_add_optional_conduit   tx_datain_b          export  input  20 true
  common_add_optional_conduit   tx_datain_valid_b    export  input  1  true
  common_add_optional_conduit   tx_trs_b             export  input  1  true 
  common_add_optional_conduit   tx_dataout_valid_b   export  output 1  true

  common_add_optional_conduit   tx_datain            export  input  20*$num_streams true
  common_add_optional_conduit   tx_ln                export  input  11*$num_streams true
  common_add_optional_conduit   tx_ln_b              export  input  11*$num_streams true
  common_add_optional_conduit   tx_vpid_byte1        export  input  8*$num_streams  true
  common_add_optional_conduit   tx_vpid_byte2        export  input  8*$num_streams  true
  common_add_optional_conduit   tx_vpid_byte3        export  input  8*$num_streams  true
  common_add_optional_conduit   tx_vpid_byte4        export  input  8*$num_streams  true
  common_add_optional_conduit   tx_vpid_byte1_b      export  input  8*$num_streams  true
  common_add_optional_conduit   tx_vpid_byte2_b      export  input  8*$num_streams  true
  common_add_optional_conduit   tx_vpid_byte3_b      export  input  8*$num_streams  true
  common_add_optional_conduit   tx_vpid_byte4_b      export  input  8*$num_streams  true
  common_add_optional_conduit   tx_line_f0           export  input  11*$num_streams true
  common_add_optional_conduit   tx_line_f1           export  input  11*$num_streams true

  if { $family == "Arria 10" } {
    common_add_optional_conduit   tx_dataout         tx_parallel_data  output 20*$num_streams true
    common_add_optional_conduit   tx_dataout_b       tx_parallel_data  output 20 true
  } else {
    common_add_optional_conduit   tx_dataout         export  output 20*$num_streams true
    common_add_optional_conduit   tx_dataout_b       export  output 20 true
  }

  if { $video_std != "threeg" & $video_std != "ds" & $video_std != "tr" & $video_std != "mr" } {
    terminate_port   tx_std              input
  }

  if { ($video_std != "threeg" & $video_std != "ds" & $video_std != "tr" & $video_std != "mr") | ($family == "Arria 10" & $video_std == "threeg")} {
    terminate_port   tx_std_out          output
  }

  if { $video_std == "sd" } {
    terminate_port   tx_enable_ln        input
    terminate_port   tx_enable_crc       input
  }
  if { $video_std == "sd" & !$insert_vpid } {
    terminate_port   tx_ln               input
  }
  if { $video_std != "threeg" & $video_std != "dl" & $video_std != "tr" & $video_std != "mr"} {
    terminate_port   tx_ln_b             input
  }

  if {!$insert_vpid} {
    terminate_port   tx_vpid_overwrite   input
    terminate_port   tx_vpid_byte1       input
    terminate_port   tx_vpid_byte2       input
    terminate_port   tx_vpid_byte3       input
    terminate_port   tx_vpid_byte4       input
    terminate_port   tx_line_f0          input
    terminate_port   tx_line_f1          input
  }

  if { !$insert_vpid | ($video_std != "dl" & $video_std != "threeg" & $video_std != "tr" & $video_std != "mr")} {
    terminate_port   tx_vpid_byte1_b  input
    terminate_port   tx_vpid_byte2_b  input
    terminate_port   tx_vpid_byte3_b  input
    terminate_port   tx_vpid_byte4_b  input 
  }

  if {$video_std != "dl"} {
    terminate_port   tx_datain_b         input
    terminate_port   tx_datain_valid_b   input
    terminate_port   tx_trs_b            input
    terminate_port   tx_dataout_b        output
    terminate_port   tx_dataout_valid_b  output
  }
}
