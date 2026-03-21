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


# +-------------------------------------
# | 
# | SDI II Video Pattern Generator v12.0
# | Intel Corporation 2009.08.19.17:10:07
# | 
# +-------------------------------------

package require -exact qsys 16.0

source ../sdi_ii/sdi_ii_interface.tcl
source ../sdi_ii/sdi_ii_params.tcl

# +--------------------------------------
# | module SDI II Video Pattern Generator
# | 
set_module_property DESCRIPTION "SDI II Video Pattern Generator"
set_module_property NAME sdi_ii_ed_vid_pattgen
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SDI II Video Pattern Generator"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II Video Pattern Generator"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
# set_module_property TOP_LEVEL_HDL_FILE src_hdl/sdi_ii_ed_vid_pattgen.v
# set_module_property TOP_LEVEL_HDL_MODULE sdi_ii_ed_vid_pattgen
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

set_fileset_property simulation_verilog TOP_LEVEL   sdi_ii_ed_vid_pattgen
set_fileset_property simulation_vhdl    TOP_LEVEL   sdi_ii_ed_vid_pattgen
set_fileset_property synthesis_fileset  TOP_LEVEL   sdi_ii_ed_vid_pattgen

proc generate_files {name} {
   add_fileset_file sdi_ii_ed_vid_pattgen.v   VERILOG PATH src_hdl/sdi_ii_ed_vid_pattgen.v
   add_fileset_file sdi_ii_makeframe.v        VERILOG PATH src_hdl/sdi_ii_makeframe.v
   add_fileset_file sdi_ii_colorbar_gen.v     VERILOG PATH src_hdl/sdi_ii_colorbar_gen.v 
   add_fileset_file sdi_ii_patho_gen.v        VERILOG PATH src_hdl/sdi_ii_patho_gen.v 
}

#set module_dir [get_module_property MODULE_DIRECTORY]
#add_file ${module_dir}/src_hdl/sdi_ii_ed_vid_pattgen.v   {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_makeframe.v        {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_colorbar_gen.v     {SYNTHESIS}
#add_file ${module_dir}/src_hdl/sdi_ii_patho_gen.v        {SYNTHESIS}


# | 
# +-----------------------------------
sdi_ii_common_params
set_parameter_property FAMILY HDL_PARAMETER false
set_parameter_property VIDEO_STANDARD HDL_PARAMETER false
set_parameter_property DIRECTION HDL_PARAMETER false
set_parameter_property TRANSCEIVER_PROTOCOL HDL_PARAMETER false
set_parameter_property RX_INC_ERR_TOLERANCE HDL_PARAMETER false
set_parameter_property RX_CRC_ERROR_OUTPUT HDL_PARAMETER false
set_parameter_property RX_EN_VPID_EXTRACT HDL_PARAMETER false
set_parameter_property RX_EN_A2B_CONV HDL_PARAMETER false
set_parameter_property RX_EN_B2A_CONV HDL_PARAMETER false
set_parameter_property TX_HD_2X_OVERSAMPLING HDL_PARAMETER false
set_parameter_property TX_EN_VPID_INSERT HDL_PARAMETER false
set_parameter_property XCVR_TX_PLL_SEL HDL_PARAMETER false
set_parameter_property HD_FREQ HDL_PARAMETER false

sdi_ii_test_pattgen_params
sdi_ii_test_params

set_parameter_property TEST_VPID_OVERWRITE HDL_PARAMETER true

add_parameter OUTW_MULTP integer 1
set_parameter_property OUTW_MULTP ALLOWED_RANGES {1 4}
set_parameter_property OUTW_MULTP HDL_PARAMETER true

set common_composed_mode 0

proc elaboration_callback {} {
  set insert_vpid [get_parameter_value TX_EN_VPID_INSERT]
  set video_std   [get_parameter_value VIDEO_STANDARD]

  if { $video_std == "mr" } {
     set num_streams 4
  } else {
     set num_streams 1
  }

  common_add_clock            clk              input   true
  common_add_reset            rst              input   clk
  common_add_optional_conduit bar_100_75n      export  input  1                 true
  common_add_optional_conduit enable           export  input  1                 true
  common_add_optional_conduit patho            export  input  1                 true
  common_add_optional_conduit blank            export  input  1                 true
  common_add_optional_conduit no_color         export  input  1                 true  
  common_add_optional_conduit sgmt_frame       export  input  1                 true  
  common_add_optional_conduit tx_std           export  input  3                 true
  common_add_optional_conduit tx_format        export  input  4                 true
  common_add_optional_conduit dl_mapping       export  input  1                 true
  common_add_optional_conduit ntsc_paln        export  input  1                 true
  common_add_optional_conduit dout             export  output 20*$num_streams   true
  common_add_optional_conduit dout_valid       export  output 1                 true
  common_add_optional_conduit trs              export  output 1                 true
  common_add_optional_conduit ln               export  output 11*$num_streams   true
  common_add_optional_conduit dout_b           export  output 20                true
  common_add_optional_conduit dout_valid_b     export  output 1                 true
  common_add_optional_conduit trs_b            export  output 1                 true
  common_add_optional_conduit ln_b             export  output 11*$num_streams   true
  common_add_optional_conduit vpid_byte1       export  output 8*$num_streams    true
  common_add_optional_conduit vpid_byte2       export  output 8*$num_streams    true
  common_add_optional_conduit vpid_byte3       export  output 8*$num_streams    true
  common_add_optional_conduit vpid_byte4       export  output 8*$num_streams    true
  common_add_optional_conduit vpid_byte1_b     export  output 8*$num_streams    true
  common_add_optional_conduit vpid_byte2_b     export  output 8*$num_streams    true
  common_add_optional_conduit vpid_byte3_b     export  output 8*$num_streams    true
  common_add_optional_conduit vpid_byte4_b     export  output 8*$num_streams    true
  common_add_optional_conduit line_f0          export  output 11*$num_streams   true
  common_add_optional_conduit line_f1          export  output 11*$num_streams   true

  if { $video_std != "dl" } {
    terminate_port dout_b         output
    terminate_port dout_valid_b   output
    terminate_port trs_b          output
  }

  if { $video_std == "sd" && !($insert_vpid)} {
      terminate_port ln               output
      terminate_port ln_b             output
  } else {
        if { $video_std == "ds" | $video_std == "sd" | $video_std == "hd" } {
        terminate_port ln_b             output
        }
  }

  if !{$insert_vpid} {
      terminate_port line_f0          output
      terminate_port line_f1          output
      terminate_port vpid_byte1       output
      terminate_port vpid_byte2       output
      terminate_port vpid_byte3       output
      terminate_port vpid_byte4       output
      terminate_port vpid_byte1_b     output
      terminate_port vpid_byte2_b     output
      terminate_port vpid_byte3_b     output
      terminate_port vpid_byte4_b     output
  } else {
      if { $video_std == "ds" | $video_std == "sd" | $video_std == "hd" } {
          terminate_port vpid_byte1_b     output
          terminate_port vpid_byte2_b     output
          terminate_port vpid_byte3_b     output
          terminate_port vpid_byte4_b     output
      }
  }
}
