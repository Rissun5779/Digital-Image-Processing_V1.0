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



package provide altera_xcvr_cal_a10::fileset 18.1

package require alt_xcvr::utils::fileset
package require alt_xcvr::ip_tcl::ip_module

namespace eval ::altera_xcvr_cal_a10::fileset:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::utils::fileset::*

  namespace export \
    declare_filesets \
    declare_files

  variable filesets

  set filesets {\
    { NAME            TYPE            CALLBACK                                                      TOP_LEVEL                 }\
    { quartus_synth   QUARTUS_SYNTH   ::altera_xcvr_cal_a10::fileset::callback_quartus_synth  altera_xcvr_cal_a10 }\
    { sim_verilog     SIM_VERILOG     ::altera_xcvr_cal_a10::fileset::callback_sim_verilog    altera_xcvr_cal_a10 }\
    { sim_vhdl        SIM_VHDL        ::altera_xcvr_cal_a10::fileset::callback_sim_vhdl       altera_xcvr_cal_a10 }\
  }
}

proc ::altera_xcvr_cal_a10::fileset::declare_filesets { } {
  variable filesets

  declare_files
  ip_declare_filesets $filesets
}

proc ::altera_xcvr_cal_a10::fileset::declare_files { {path "./"} } {
  # Common functions
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path [::alt_xcvr::utils::fileset::get_altera_xcvr_generic_path]]
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    altera_xcvr_functions.sv
  } {altera_xcvr_cal_a10}

  # Common resync module
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "${path}/ctrl/" {
    alt_xcvr_resync.sv
  } {altera_xcvr_cal_a10}

  # altera_xcvr_cal_a10 files
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_cal/altera_xcvr_cal_a10/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    altera_xcvr_cal_a10.sv
  } {altera_xcvr_cal_a10}

}

proc ::altera_xcvr_cal_a10::fileset::callback_quartus_synth {name} {
  common_add_fileset_files {altera_xcvr_cal_a10} {PLAIN QIP}
}

proc ::altera_xcvr_cal_a10::fileset::callback_sim_verilog {name} {
  common_add_fileset_files {altera_xcvr_cal_a10} [concat PLAIN [common_fileset_tags_all_simulators]]
}

proc ::altera_xcvr_cal_a10::fileset::callback_sim_vhdl {name} {
  common_add_fileset_files {altera_xcvr_cal_a10} [concat PLAIN [common_fileset_tags_all_simulators]]
}

