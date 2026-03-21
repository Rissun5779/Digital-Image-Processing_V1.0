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



package provide altera_xcvr_cdr_pll_s10::fileset 18.1

package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::ipgen
package require alt_xcvr::ip_tcl::ip_module
package require altera_xcvr_cdr_pll_s10::parameters
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::reconfiguration_stratix10
package require alt_xcvr::ip_tcl::file_utils
package require altera_terp

namespace eval ::altera_xcvr_cdr_pll_s10::fileset:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::utils::fileset::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    declare_filesets \
    declare_files

  variable filesets


  set filesets {\
    { NAME            TYPE            CALLBACK                                               	    TOP_LEVEL    			}\
    { quartus_synth   QUARTUS_SYNTH   ::altera_xcvr_cdr_pll_s10::fileset::callback_quartus_synth                    }\
    { sim_verilog     SIM_VERILOG     ::altera_xcvr_cdr_pll_s10::fileset::callback_sim_verilog                      }\
    { sim_vhdl        SIM_VHDL        ::altera_xcvr_cdr_pll_s10::fileset::callback_sim_vhdl                         }\
  }

}

proc ::altera_xcvr_cdr_pll_s10::fileset::declare_filesets { } {
  variable filesets

  declare_files
  ip_declare_filesets $filesets
}

proc ::altera_xcvr_cdr_pll_s10::fileset::declare_files {} {  
  #alt_xcvr_resync used by AVMM wrapper
   set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
   set path "${path}/../altera_xcvr_generic/ctrl/"
   set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
   ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
      alt_xcvr_resync.sv
      alt_xcvr_arbiter.sv
   } {altera_xcvr_cdr_pll_s10}


  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/source"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
     s10_avmm_h.sv
     altera_xcvr_native_s10_functions_h.sv     
  } {altera_xcvr_cdr_pll_s10}

  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_pll/common/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
     alt_xcvr_pll_rcfg_arb.sv
     alt_xcvr_pll_embedded_debug.sv
     alt_xcvr_pll_avmm_csr.sv
  } {altera_xcvr_cdr_pll_s10}

}


proc ::altera_xcvr_cdr_pll_s10::fileset::callback_quartus_synth {ip_name} {

  callback_generate_files $ip_name QUARTUS_SYNTH

   # use qsys_unique_name only for the top_level_file 
   # for other files, just mention the prefix, it will be appended with an unique random number 
   set list_of_unique_files_for_synth []
   lappend list_of_unique_files_for_synth altera_xcvr_cdr_pll_s10.sv.terp qsys_unique_name 

   if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
     lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
     lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
     lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_ctrl.sv.terp alt_xcvr_native_rcfg_strm_ctrl.sv
   }
     lappend list_of_unique_files_for_synth alt_xcvr_pll_rcfg_opt_logic.sv.terp alt_xcvr_pll_rcfg_opt_logic.sv

   # generate a set of uniquely named files 
   # argument is the list of files (dict)
   generate_unique_files $ip_name $list_of_unique_files_for_synth 

}

proc ::altera_xcvr_cdr_pll_s10::fileset::callback_sim_verilog {ip_name} {

  callback_generate_files $ip_name SIM_VERILOG

  #TODO: make this operation part of common fileset.tcl) - this is only for simulation
  set_fileset_file_attribute altera_xcvr_native_s10_functions_h.sv COMMON_SYSTEMVERILOG_PACKAGE altera_xcvr_native_s10_functions_h 

  # use qsys_unique_name only for the top_level_file 
  # for other files, just mention the prefix, we will append it with unique random number 
  set list_of_unique_files_for_sim_vlg []
  lappend list_of_unique_files_for_sim_vlg altera_xcvr_cdr_pll_s10.sv.terp qsys_unique_name 

  if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_ctrl.sv.terp alt_xcvr_native_rcfg_strm_ctrl.sv
  }
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_pll_rcfg_opt_logic.sv.terp alt_xcvr_pll_rcfg_opt_logic.sv

  # generate a set of uniquely named files 
  # argument is the list of files 
  generate_unique_files $ip_name $list_of_unique_files_for_sim_vlg

}

proc ::altera_xcvr_cdr_pll_s10::fileset::callback_sim_vhdl {ip_name} {

 callback_generate_files $ip_name SIM_VHDL
 
 #TODO: make this operation part of common fileset.tcl) - this is only for simulation
 set_fileset_file_attribute altera_xcvr_native_s10_functions_h.sv COMMON_SYSTEMVERILOG_PACKAGE altera_xcvr_native_s10_functions_h 

 # use qsys_unique_name only for the top_level_file 
 # for other files, just mention the prefix, we will append it with unique random number 
 # use qsys_unique_name only for the top_level_file 
 # for other files, just mention the prefix, it will be appended with an unique random number 
 set list_of_unique_files_for_sim_vhdl []
 lappend list_of_unique_files_for_sim_vhdl altera_xcvr_cdr_pll_s10.sv.terp qsys_unique_name 

 if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
   lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
   lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
   lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_ctrl.sv.terp alt_xcvr_native_rcfg_strm_ctrl.sv
 }
   lappend list_of_unique_files_for_sim_vhdl alt_xcvr_pll_rcfg_opt_logic.sv.terp alt_xcvr_pll_rcfg_opt_logic.sv

 # generate a set of uniquely named files 
 # argument: dict specifying the terp file and the eventual output_filename desired 
 generate_unique_files $ip_name $list_of_unique_files_for_sim_vhdl

}

proc ::altera_xcvr_cdr_pll_s10::fileset::build_opcodes {} {
   set opcodes "channel_pll_refclk=[ip_get "parameter.refclk_index.value"]"
   return $opcodes
}

# Common fileset callback
proc ::altera_xcvr_cdr_pll_s10::fileset::callback_generate_files { ip_name fileset } {
  set rcfg_criteria {M_RCFG_REPORT 1}
  set regmap_list {pma}
  set ip_core "cdr_pll"

  # Add previously declared files to fileset
  set tags [expr {$fileset == "QUARTUS_SYNTH" ? {PLAIN QIP}
    : [concat PLAIN [common_fileset_tags_all_simulators]] }]
  common_add_fileset_files {altera_xcvr_cdr_pll_s10} $tags
  # List of atoms and timing parameters
  # Setting both lists as empty because timing settings not required for PLL
  set ip_params_for_timing {}
  set cdr_pll_atom_list {}

  ::alt_xcvr::utils::reconfiguration_stratix10::generate_config_files $ip_name $ip_core $fileset $rcfg_criteria $regmap_list $cdr_pll_atom_list $ip_params_for_timing

  # Generate the "add_hdl_instance" example file if enabled
  if {[ip_get "parameter.generate_add_hdl_instance_example.value"]} {
    ::alt_xcvr::ip_tcl::file_utils::generate_add_hdl_instance_example $ip_name $fileset
  }
}

### 
# Generate unique file names and unique module names 
# @param qsys_output_name - unique random string generated by qsys 
# @param list_of_unique files - dict of files, contains the files and desired file names
#
proc ::altera_xcvr_cdr_pll_s10::fileset::generate_unique_files {qsys_output_name list_of_unique_files} {
  
  # terp files 
  # all terp files are in ${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/terp/"
  # top level 
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/terp/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]

   # split the qsys_output_name to extract the ip_module_name, ip_component_name and random str 
  set elements [::alt_xcvr::utils::common::wsplit $qsys_output_name "altera_xcvr_cdr_pll_s10_"] 

  set ip_name [lindex $elements 0]
  set release_number [lindex [split [lindex $elements 1] "_"] 0]
  set ip_component_name altera_xcvr_atx_pll_s10_${release_number} 
  set random_str [lindex [split [lindex $elements 1] "_"] end]

  # iterate over all the dict keys i.e list of files 
  foreach file [dict keys $list_of_unique_files] {

    # altera_xcvr_cdr_pll_s10.sv.terp is is source/terp
    # alt_xcvr_pll_rcfg_opt_logic.sv.terp is in altera_xcvr_pll/common/ 
    # All other terp files are from altera_xcvr_native_s10/terp
    if        {$file eq "altera_xcvr_cdr_pll_s10.sv.terp"} {
      set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path] 
      set path "${path}/altera_xcvr_pll/altera_xcvr_cdr_pll_s10/source/terp/"
    } elseif {$file eq "alt_xcvr_pll_rcfg_opt_logic.sv.terp"} {
      set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path] 
      set path "${path}/altera_xcvr_pll/common"
    } else {
      set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path] 
      set path "${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/terp/"
    }

    # get template 
    set filename ${path}/${file} 
    set file_handle [open ${filename} r] 
    set template [read $file_handle]

    # setup template parameters 
    # any variable used in terp template should be declared here 
    set value [dict get $list_of_unique_files $file] 
    set file_ext [lindex [split $value "."] end]
    set file_name [lindex [split $value "."] 0]
    
    # retain the qsys name for module if the file name desired is qsys_output_name 
    if {$value eq "qsys_unique_name"} {
      set template_params(module_name) ${qsys_output_name}
      set template_params(random_str) ${random_str}
    } else {
      set template_params(module_name) ${file_name}_${random_str}
      set template_params(random_str) ${random_str}
    }

    set contents [altera_terp $template template_params]
    
    # extract the name desired from dict get
    # if the string matches qsys_unique_name, use the unique string generated by qsys
    # add to the fileset
    if {$value eq "qsys_unique_name"} {
      set output_filename ${qsys_output_name}.sv 
    } else {
      set output_filename ${file_name}_${random_str}.${file_ext}
    } 
    add_fileset_file "./${output_filename}" SYSTEM_VERILOG TEXT $contents  
  } 
}

