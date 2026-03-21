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
# | request TCL package from other libraries
# | 
package provide altera_xcvr_fpll_s10::fileset 18.1
package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::ipgen
package require alt_xcvr::ip_tcl::ip_module
package require altera_xcvr_fpll_s10::parameters
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::reconfiguration_stratix10
package require alt_xcvr::ip_tcl::file_utils
package require altera_terp

# +-----------------------------------
# | create CMU_FPLL fileset
# | 
namespace eval ::altera_xcvr_fpll_s10::fileset:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*
   namespace import ::alt_xcvr::utils::fileset::*
   namespace import ::alt_xcvr::ip_tcl::messages::*
   
   namespace export \
      declare_filesets \
      declare_files
	  
   variable filesets
   variable ip_params_for_timing
   
   set filesets {\
      { NAME            TYPE            CALLBACK                                                  TOP_LEVEL           }\
      { quartus_synth   QUARTUS_SYNTH   ::altera_xcvr_fpll_s10::fileset::callback_quartus_synth   }\
      { sim_verilog     SIM_VERILOG     ::altera_xcvr_fpll_s10::fileset::callback_sim_verilog     }\
      { sim_vhdl        SIM_VHDL        ::altera_xcvr_fpll_s10::fileset::callback_sim_vhdl        }\
   }

   set ip_params_for_timing {
       set_primary_use \
       set_refclk_cnt \
       output_clock_frequency \
       set_x1_core_clock \
       set_x2_core_clock \
       set_x4_core_clock
   }

}

# +-----------------------------------
# | 
# | 
proc ::altera_xcvr_fpll_s10::fileset::declare_filesets { } {
   variable filesets
   declare_files
   ip_declare_filesets $filesets
}

# +-----------------------------------
# | 
# |
proc ::altera_xcvr_fpll_s10::fileset::declare_files {} {
   #AVMM file
   #set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
   #set path "${path}/alt_xcvr_core/nd/"
   #set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
   #::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
   #   twentynm_xcvr_avmm.sv
   #} {altera_xcvr_fpll_s10}

    #alt_xcvr_resync used by AVMM wrapper
   #set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
   #set path "${path}/../altera_xcvr_generic/ctrl/"
   #set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
   #::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
   #   alt_xcvr_resync.sv
   #} {altera_xcvr_fpll_s10}

  # altera_xcvr_cmu_fpll_s10 files
   #set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
   #set path "${path}/altera_xcvr_pll/altera_xcvr_fpll_s10/source/"
   #set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
   #::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
   #   altera_xcvr_fpll_s10.sv
   #} {altera_xcvr_fpll_s10}
   
  # altera_xcvr_pll_embedded_debug files shared with native phy
   #set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
   #set path "${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/source"
   #set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
   #::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
   #   s10_avmm_h.sv
   #   altera_xcvr_native_s10_functions_h.sv
   #} {altera_xcvr_fpll_s10}

  # altera_xcvr_fpll_sv files
   #set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
   #set path "${path}/altera_xcvr_pll/altera_xcvr_fpll_s10/source/"
   #set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
   #::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
   #   alt_xcvr_pll_rcfg_arb.sv     
   #   alt_xcvr_pll_embedded_debug.sv
   #   alt_xcvr_pll_avmm_csr.sv
   #} {altera_xcvr_fpll_s10}

}

# +-----------------------------------
# |
# | 
proc ::altera_xcvr_fpll_s10::fileset::callback_quartus_synth {ip_name} {
   callback_generate_files $ip_name QUARTUS_SYNTH
   
   # use qsys_unique_name only for the top_level_file 
   # for other files, just mention the prefix, it will be appended with an unique random number 
   set list_of_unique_files_for_synth []
   lappend list_of_unique_files_for_synth altera_xcvr_fpll_s10.sv.terp qsys_unique_name

   set set_primary_use [ip_get "parameter.set_primary_use.value"]
   if {$set_primary_use == 0 } {
      lappend list_of_unique_files_for_synth alt_xcvr_fpll.sdc.terp alt_xcvr_fpll.sdc
      lappend list_of_unique_files_for_synth alt_xcvr_fpll_helper_functions.tcl.terp alt_xcvr_fpll_helper_functions.tcl
   }

   #if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
   #  lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
   #  lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
   #  lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_ctrl.sv.terp alt_xcvr_native_rcfg_strm_ctrl.sv
   #}
   #  lappend list_of_unique_files_for_synth alt_xcvr_pll_rcfg_opt_logic.sv.terp alt_xcvr_pll_rcfg_opt_logic.sv

   # generate a set of uniquely named files 
   # argument is the list of files (dict)
   generate_unique_files $ip_name $list_of_unique_files_for_synth 

   if {$set_primary_use == 0 } {
      set rcfg_multi_enable [ip_get "parameter.rcfg_multi_enable.value"]
      generate_parameters_file $ip_name "fpll" $rcfg_multi_enable 
   }
}

# +-----------------------------------
# |
# | 

proc ::altera_xcvr_fpll_s10::fileset::callback_sim_verilog {ip_name} {
   callback_generate_files $ip_name SIM_VERILOG

   #see FB: 256229 for details (\TODO make this operation part of common fileset.tcl) - this is only for simulation
   #set_fileset_file_attribute altera_xcvr_native_s10_functions_h.sv COMMON_SYSTEMVERILOG_PACKAGE altera_xcvr_native_s10_functions_h 

   # use qsys_unique_name only for the top_level_file 
   # for other files, just mention the prefix, we will append it with unique random number 
   set list_of_unique_files_for_sim_vlg []
   lappend list_of_unique_files_for_sim_vlg altera_xcvr_fpll_s10.sv.terp qsys_unique_name 

   #if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
   #  lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
   #  lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
   #  lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_ctrl.sv.terp alt_xcvr_native_rcfg_strm_ctrl.sv
   #}
   #  lappend list_of_unique_files_for_sim_vlg alt_xcvr_pll_rcfg_opt_logic.sv.terp alt_xcvr_pll_rcfg_opt_logic.sv

   # generate a set of uniquely named files 
   # argument is the list of files 
   generate_unique_files $ip_name $list_of_unique_files_for_sim_vlg

}

# +-----------------------------------
# |
# | 
proc ::altera_xcvr_fpll_s10::fileset::callback_sim_vhdl {ip_name} {
   callback_generate_files $ip_name SIM_VHDL
  
   #see FB: 256229 for details (\TODO make this operation part of common fileset.tcl) - this is only for simulation
   #set_fileset_file_attribute altera_xcvr_native_s10_functions_h.sv COMMON_SYSTEMVERILOG_PACKAGE altera_xcvr_native_s10_functions_h 

   # use qsys_unique_name only for the top_level_file 
   # for other files, just mention the prefix, we will append it with unique random number 
   # use qsys_unique_name only for the top_level_file 
   # for other files, just mention the prefix, it will be appended with an unique random number 
   set list_of_unique_files_for_sim_vhdl []
   lappend list_of_unique_files_for_sim_vhdl altera_xcvr_fpll_s10.sv.terp qsys_unique_name 

   #if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
   #  lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
   #  lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
   #  lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_ctrl.sv.terp alt_xcvr_native_rcfg_strm_ctrl.sv
   #}
   #  lappend list_of_unique_files_for_sim_vhdl alt_xcvr_pll_rcfg_opt_logic.sv.terp alt_xcvr_pll_rcfg_opt_logic.sv

   # generate a set of uniquely named files 
   # argument: dict specifying the terp file and the eventual output_filename desired 
   generate_unique_files $ip_name $list_of_unique_files_for_sim_vhdl
}

# +-----------------------------------
# |
# | 
proc ::altera_xcvr_fpll_s10::fileset::build_opcodes {} {
   set opcodes "fpll_refclk=[ip_get "parameter.gui_refclk_index.value"]"
   return $opcodes
}

# +-----------------------------------
# | Common fileset callback
# | 
proc ::altera_xcvr_fpll_s10::fileset::callback_generate_files { ip_name fileset } {
  variable ip_params_for_timing

  set rcfg_criteria {M_RCFG_REPORT 1}
  set regmap_list {fpll}
  set ip_core "fpll"

  # Add previously declared files to fileset
  set tags [expr {$fileset == "QUARTUS_SYNTH" ? {PLAIN QIP}
    : [concat PLAIN [common_fileset_tags_all_simulators]] }]
  common_add_fileset_files {altera_xcvr_fpll_s10} $tags

  # List of atoms  parameters
  # Setting list as empty because timing settings not required for PLL
  set fpll_atom_list {}

  ::alt_xcvr::utils::reconfiguration_stratix10::generate_config_files $ip_name $ip_core $fileset $rcfg_criteria $regmap_list $fpll_atom_list $ip_params_for_timing

  # Generate parameter documentation files if enabled
  if { [ip_get "parameter.generate_docs.value"] } {
    ::alt_xcvr::ip_tcl::file_utils::generate_doc_files $ip_name $fileset
  }

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
proc ::altera_xcvr_fpll_s10::fileset::generate_unique_files {qsys_output_name list_of_unique_files} {
  # terp files 
  # all terp files are in ${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/terp/"
  # top level 
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/terp/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
   # split the qsys_output_name to extract the ip_module_name, ip_component_name and random str 
  set elements [::alt_xcvr::utils::common::wsplit $qsys_output_name "_altera_xcvr_fpll_s10_"] 

  set ip_name [lindex $elements 0]
  set release_number [lindex [split [lindex $elements 1] "_"] 0]
  set ip_component_name altera_xcvr_fpll_s10_${release_number} 
  set random_str [lindex [split [lindex $elements 1] "_"] end]

  # iterate over all the dict keys i.e list of files 
  foreach file [dict keys $list_of_unique_files] {

    # Check if the unique file is altera_xcvr_fpll_s10.sv.terp or alt_xcvr_pll_rcfg_opt_logic.sv.terp or
    # fPLL IP SDC terp files which are specific to fPLL
    # Other unique files are from Native PHY
    if {$file eq "altera_xcvr_fpll_s10.sv.terp" || $file eq "alt_xcvr_pll_rcfg_opt_logic.sv.terp" ||
        $file eq "alt_xcvr_fpll.sdc.terp" || $file eq "alt_xcvr_fpll_helper_functions.tcl.terp" } {
      set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path] 
      set path "${path}/altera_xcvr_pll/altera_xcvr_fpll_s10/source/terp/"
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

    # add the file to the fileset 
    if {$file_ext eq "v" } {
      add_fileset_file "./${output_filename}" VERILOG TEXT $contents
    } elseif {$file_ext eq "sv" || $file_ext eq "qsys_unique_name"} {
      add_fileset_file "./${output_filename}" SYSTEM_VERILOG TEXT $contents
    } elseif {$file_ext eq "vhd"} {
      add_fileset_file "./${output_filename}" VHDL TEXT $contents
    } elseif {$file_ext eq "mif" || $file_ext eq "hex" || $file_ext eq "dat" || $file_ext eq "sdc"} {
      add_fileset_file "./${output_filename}" $file_ext TEXT $contents
    } else {
      add_fileset_file "./${output_filename}" OTHER TEXT $contents
    }
  } 
}

# +-----------------------------------
# |Generate parameter file for fPLL Configuration (if multi-profile is disabled)
# | @param ip_name - Top level name
proc ::altera_xcvr_fpll_s10::fileset::generate_parameters_file {ip_name ip_core rcfg_multi_enable} {
  variable ip_params_for_timing

  # Loop over every param and find its value for non-reconfig designs 
  if {!$rcfg_multi_enable} {
    set file_contents ""
 
    # extract the unique random string 
    set random_str [lindex [split $ip_name "_"] end]
    
    append file_contents "if {[info exists ip_params]} {\n"
    append file_contents "   unset ${ip_core}_ip_params\n"
    append file_contents "}\n\n"
    append file_contents "set ${ip_core}_ip_params \[dict create\]\n\n"

    append file_contents "dict set ${ip_core}_ip_params profile_cnt \"1\"\n"

    append file_contents "set ::GLOBAL_corename $ip_name\n\n"
    
    append file_contents "# -------------------------------- #\n"
    append file_contents "# --- Default Profile settings --- #\n" 
    append file_contents "# -------------------------------- #\n"

    foreach param $ip_params_for_timing {
      set param_value [ip_get "parameter.$param.value"]
      append file_contents "dict set ${ip_core}_ip_params ${param}_profile0 \"$param_value\"\n" 
    } 

    # Print out the ip_parameters.tcl file
    set filename "${ip_core}_ip_parameters_${random_str}.tcl"
    add_fileset_file "./${filename}" OTHER TEXT $file_contents

  }
}
