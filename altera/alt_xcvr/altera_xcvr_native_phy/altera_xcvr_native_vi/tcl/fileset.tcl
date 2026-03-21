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



package provide altera_xcvr_native_vi::fileset 18.1

package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::ipgen
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require altera_xcvr_native_vi::parameters
package require altera_terp

namespace eval ::altera_xcvr_native_vi::fileset:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::utils::fileset::*

  namespace export \
    declare_filesets \
    declare_files

  variable filesets
  variable ALT_XCVR_REL_PATH

  set ALT_XCVR_REL_PATH "../../..";# it seems like [get_alt_xcvr_path] using QUARTUS_ROOTDIR and this variable is not set properly in some test environments, instead will use relative path 

  set filesets {\
    { NAME            TYPE            CALLBACK                                                  TOP_LEVEL             }\
    { quartus_synth   QUARTUS_SYNTH   ::altera_xcvr_native_vi::fileset::callback_quartus_synth  }\
    { sim_verilog     SIM_VERILOG     ::altera_xcvr_native_vi::fileset::callback_sim_verilog    }\
    { sim_vhdl        SIM_VHDL        ::altera_xcvr_native_vi::fileset::callback_sim_vhdl       }\
  }

}

proc ::altera_xcvr_native_vi::fileset::declare_filesets { } {
  variable filesets

  declare_files
  ip_declare_filesets $filesets
}


proc ::altera_xcvr_native_vi::fileset::declare_files {} {
  variable ALT_XCVR_REL_PATH
  # Common files
  set path "${ALT_XCVR_REL_PATH}/../altera_xcvr_generic/ctrl/"
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    alt_xcvr_resync.sv
    alt_xcvr_arbiter.sv
  } {ALTERA_XCVR_NATIVE_NF}

  # NF Core files
  set path "${ALT_XCVR_REL_PATH}/alt_xcvr_core/nf/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    twentynm_pcs.sv
    twentynm_pma.sv
    twentynm_xcvr_avmm.sv
    twentynm_xcvr_native.sv
  } {ALTERA_XCVR_NATIVE_NF}

  # altera_xcvr_native_a10 files
  set path "${ALT_XCVR_REL_PATH}/altera_xcvr_native_phy/altera_xcvr_native_vi/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    altera_xcvr_native_a10_functions_h.sv
    a10_avmm_h.sv
    alt_xcvr_native_pipe_retry.sv
    alt_xcvr_native_avmm_csr.sv  
    alt_xcvr_native_prbs_accum.sv  
    alt_xcvr_native_odi_accel.sv  
    alt_xcvr_native_rcfg_arb.sv 
  } {ALTERA_XCVR_NATIVE_NF}
  

  # Add SDC files
  ::alt_xcvr::utils::fileset::common_fileset_group ./ $path SDC {
    altera_xcvr_native_a10_false_paths.sdc
  } {ALTERA_XCVR_NATIVE_NF} {QIP}

 
  # altera_xcvr_native_a10 files
  set path "${ALT_XCVR_REL_PATH}/altera_xcvr_native_phy/altera_xcvr_native_vi/pcie_dfe_ip/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    altera_xcvr_native_pcie_dfe_params_h.sv
    pcie_mgmt_commands_h.sv
    pcie_mgmt_functions_h.sv
    pcie_mgmt_program.sv
    pcie_mgmt_cpu.sv
    pcie_mgmt_master.sv
    altera_xcvr_native_pcie_dfe_ip.sv
  } {ALTERA_XCVR_NATIVE_NF}
}

##
# Fileset callback for Quartus synthesis
proc ::altera_xcvr_native_vi::fileset::callback_quartus_synth {ip_name} {
  callback_generate_files $ip_name QUARTUS_SYNTH
  
  # use qsys_unique_name only for the top_level_file 
  # for other files, just mention the prefix, it will be appended with an unique random number 
  set list_of_unique_files_for_synth []
  lappend list_of_unique_files_for_synth altera_xcvr_native_a10.sv.terp qsys_unique_name 

  if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
    lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
    lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
  }
    lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_opt_logic.sv.terp alt_xcvr_native_rcfg_opt_logic.sv

  # generate a set of uniquely named files 
  # argument is the list of files (dict)
  generate_unique_files $ip_name $list_of_unique_files_for_synth 
}

### 
# Generate unique file names and unique module names 
# @param qsys_output_name - unique random string generated by qsys 
# @param list_of_unique files - dict of files, contains the files and desired file names
#
proc ::altera_xcvr_native_vi::fileset::generate_unique_files {qsys_output_name list_of_unique_files} {
  variable ALT_XCVR_REL_PATH
  # terp files 
  # all terp files are in ${path}/altera_xcvr_native_phy/altera_xcvr_native_vi/terp/ 
  set path "${ALT_XCVR_REL_PATH}/altera_xcvr_native_phy/altera_xcvr_native_vi/terp/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
   # split the qsys_output_name to extract the ip_module_name, ip_component_name and random str 
  set elements [::alt_xcvr::utils::common::wsplit $qsys_output_name "_altera_xcvr_native_a10_"] 

  set ip_name [lindex $elements 0]
  set release_number [lindex [split [lindex $elements 1] "_"] 0]
  set ip_component_name altera_xcvr_native_a10_${release_number} 
  set random_str [lindex [split [lindex $elements 1] "_"] end]

  # iterate over all the dict keys i.e list of files 
  foreach file [dict keys $list_of_unique_files] {
    # get template 
    set filename ${path}/${file} 
    set file_handle [open ${filename} r] 
    set template [read $file_handle]

    # setup template parameters 
    # any variable used in terp template should be declared here 
    set value [dict get $list_of_unique_files $file] 
    set file_ext [lindex [split $value "."] end]
    set file_name [lindex [split $value "."] 0]

    set template_params(set_pcs_bonding_master) [ip_get "parameter.pcs_bonding_master.value"]
    
    # retain the qsys name for module if the file name desired is qsys_output_name 
    if {$value eq "qsys_unique_name"} {
      set template_params(module_name) ${qsys_output_name}
      set template_params(random_str) ${random_str}
    } else {
      set template_params(module_name) ${file_name}_${random_str}
      set template_params(random_str) ${random_str}
    }
    
    if { [ip_get "parameter.rcfg_multi_enable.value"] } {
      # produce output files for each reconfig_setting and pass the file name for each of these setting 
      # for testing, inserting dummy string
      set common_path "./${ip_name}/${ip_component_name}/synth/rcfg_timing_db"
      set template_params(rcfg_multi_enable) true 

      set split_qsys_output_name [split $qsys_output_name "_"]
      set xcvr_nphy_index [lsearch $split_qsys_output_name "altera"]
      if {$xcvr_nphy_index < 0} {
        set list_top_inst_name $split_qsys_output_name
      } else {
        set list_top_inst_name [lreplace $split_qsys_output_name $xcvr_nphy_index end]
      }
      set top_inst_name [join $list_top_inst_name "_"]

      set template_params(hssi_10g_rx_pcs_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_10g_rx_pcs_rcfg_settings_${random_str}.json\"
      set template_params(hssi_10g_tx_pcs_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_10g_tx_pcs_rcfg_settings_${random_str}.json\"
      set template_params(hssi_8g_rx_pcs_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_8g_rx_pcs_rcfg_settings_${random_str}.json\"
      set template_params(hssi_8g_tx_pcs_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_8g_tx_pcs_rcfg_settings_${random_str}.json\"
      set template_params(hssi_common_pcs_pma_interface_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_common_pcs_pma_interface_rcfg_settings_${random_str}.json\"
      set template_params(hssi_common_pld_pcs_interface_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_common_pld_pcs_interface_rcfg_settings_${random_str}.json\"
      set template_params(hssi_gen3_rx_pcs_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_gen3_rx_pcs_rcfg_settings_${random_str}.json\"
      set template_params(hssi_krfec_rx_pcs_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_krfec_rx_pcs_rcfg_settings_${random_str}.json\"
      set template_params(hssi_pipe_gen1_2_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_pipe_gen1_2_rcfg_settings_${random_str}.json\"
      set template_params(hssi_rx_pcs_pma_interface_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_rx_pcs_pma_interface_rcfg_settings_${random_str}.json\"
      set template_params(hssi_rx_pld_pcs_interface_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_rx_pld_pcs_interface_rcfg_settings_${random_str}.json\"
      set template_params(hssi_tx_pcs_pma_interface_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_tx_pcs_pma_interface_rcfg_settings_${random_str}.json\"
      set template_params(hssi_tx_pld_pcs_interface_reconfig_settings) \"${common_path}/${top_inst_name}_hssi_tx_pld_pcs_interface_rcfg_settings_${random_str}.json\" 
    } else {
      set template_params(rcfg_multi_enable) false
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

#####
# Generate reconfig settings for each atom 
# @param ip_name - unique qsys name 
# @param rcfg_profile_cnt - number of reconfig profiles 
# @param atom - name of the atom 
# @param all_rcfg_data - a dict of n keys (1 for each profile) 
# and n values (rcfg_data for each profile)
# rcfg_data is a dict of 2 subdictonaries; ascii_data and ram_data
# 
proc ::altera_xcvr_native_vi::fileset::generate_reconfig_settings {ip_name random_str rcfg_profile_cnt atom all_rcfg_data} {
  variable ALT_XCVR_REL_PATH
  # terp reconfig file  
  # all terp files are in ${path}/altera_xcvr_native_phy/altera_xcvr_native_vi/terp/ 
  set path "${ALT_XCVR_REL_PATH}/altera_xcvr_native_phy/altera_xcvr_native_vi/terp/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]

  
  # extract the unique random string 
  #set random_str [lindex [split $ip_name "_"] end]
  
  # get template
  set file_name "reconfig_settings.txt.terp"
  set filename ${path}/${file_name}
  set file_handle [open ${filename} r] 
  set template [read $file_handle]
  
  set dict_list_of_params [dict create] 
  set dict_list_of_values [dict create]
  
  # iterate over each profile 
  for {set index 0} {$index < $rcfg_profile_cnt} {incr index} {
    # first get the <value> for <key> index; <value> is a dict of 2 subdict 
    # second get the <value> for <key> ascii_data; <value> is a dict of [params:values]
    # last get the list of keys for the dict obtained in step 2 with keys *atom*; these contains list of params

    set list_of_params [dict keys [dict get [dict get $all_rcfg_data $index] ascii_data] *${atom}*]
    
    # strip off the atom name from the param
    set list_of_atom_params [list]
    foreach param $list_of_params {
      lappend list_of_atom_params [regsub -all ${atom}_ $param ""]
    } 
    dict set dict_list_of_params $index $list_of_atom_params
    
    # set up a list for the values field 
    set list_of_values [list] 
    # Follow Step 1 and 2 from above 
    # Filter the dict to have key,value pairs only for keys having *atom* 
    # get the list of values; note that values itself is a dict 
    # go through each item in the list and extract the value field for key value
    # finally construct a list of values 
    foreach item [dict values [dict filter [dict get [dict get $all_rcfg_data $index] ascii_data] key *${atom}*]] {
      lappend list_of_values [string trim [dict get $item value] \"]
    }
  
    # set the dict_list_of_values as dict with key:$index and value: list of values 
    dict set dict_list_of_values $index $list_of_values
  } 
  
  # setup template parameters 
  # extract the keys from rcfg_data dict, it has the list of profiles 
  set template_params(list_of_profiles) [dict keys $all_rcfg_data]
  set template_params(dict_list_of_params) $dict_list_of_params
  set template_params(dict_list_of_values) $dict_list_of_values

  set contents [altera_terp $template template_params]
  add_fileset_file "./rcfg_timing_db/${ip_name}_${atom}_rcfg_settings_${random_str}.json" OTHER TEXT $contents 
} 

##
# Fileset callback for Verilog simulation
proc ::altera_xcvr_native_vi::fileset::callback_sim_verilog {ip_name} {
  callback_generate_files $ip_name SIM_VERILOG
  #see FB: 256229 for details (\TODO make this operation part of common fileset.tcl) - this is only for simulation
  set_fileset_file_attribute altera_xcvr_native_a10_functions_h.sv COMMON_SYSTEMVERILOG_PACKAGE altera_xcvr_native_a10_functions_h 

  # use qsys_unique_name only for the top_level_file 
  # for other files, just mention the prefix, we will append it with unique random number 
  set list_of_unique_files_for_sim_vlg []
  lappend list_of_unique_files_for_sim_vlg altera_xcvr_native_a10.sv.terp qsys_unique_name 

  if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
  }
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_opt_logic.sv.terp alt_xcvr_native_rcfg_opt_logic.sv

  # generate a set of uniquely named files 
  # argument is the list of files 
  generate_unique_files $ip_name $list_of_unique_files_for_sim_vlg
}

##
# Fileset callback for VHDL simulation
proc ::altera_xcvr_native_vi::fileset::callback_sim_vhdl {ip_name} {
  callback_generate_files $ip_name SIM_VHDL
  #see FB: 256229 for details (\TODO make this operation part of common fileset.tcl) - this is only for simulation
  set_fileset_file_attribute altera_xcvr_native_a10_functions_h.sv COMMON_SYSTEMVERILOG_PACKAGE altera_xcvr_native_a10_functions_h 

  # use qsys_unique_name only for the top_level_file 
  # for other files, just mention the prefix, we will append it with unique random number 
  # use qsys_unique_name only for the top_level_file 
  # for other files, just mention the prefix, it will be appended with an unique random number 
  set list_of_unique_files_for_sim_vhdl []
  lappend list_of_unique_files_for_sim_vhdl altera_xcvr_native_a10.sv.terp qsys_unique_name 

  if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
    lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
    lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
  }
    lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_opt_logic.sv.terp alt_xcvr_native_rcfg_opt_logic.sv

  # generate a set of uniquely named files 
  # argument: dict specifying the terp file and the eventual output_filename desired 
  generate_unique_files $ip_name $list_of_unique_files_for_sim_vhdl
}


##
# Common fileset callback
proc ::altera_xcvr_native_vi::fileset::callback_generate_files {ip_name fileset} {
  set rcfg_criteria {M_RCFG_REPORT 1}
  set regmap_list {pcs pma}

  # Add previously declared files to fileset
  set tags [expr {$fileset == "QUARTUS_SYNTH" ? {PLAIN QIP}
    : [concat PLAIN [common_fileset_tags_all_simulators]] }]
  common_add_fileset_files {ALTERA_XCVR_NATIVE_NF} $tags

  generate_config_files $ip_name $fileset $rcfg_criteria $regmap_list
  
  # Generate the JTAG master if enabled
#  if { [ip_get "parameter.rcfg_jtag_enable.value"] } {
#    generate_jtag_master_files $fileset
#  }

  # Generate parameter documentation files if enabled
  if { [ip_get "parameter.generate_docs.value"] } {
    generate_doc_files $ip_name $fileset
  }

  # Generate the "add_hdl_instance" example file if enabled
  if {[ip_get "parameter.generate_add_hdl_instance_example.value"]} {
    generate_add_hdl_instance_example $ip_name $fileset
  }
}


###
# Generate files needed for dynamic reconfiguration.
# These include reconfiguration report files
#
# @param ip_name - The name of this IP core
# @param fileset - The fileset being generated (QUARTUS_SYNTH, SIM_VERILOG, SIM_VHDL)
# @param criteria - A dictionary of <parameter_property property_value> pairs that will act as
#                   criteria for which IP parameters should be included in reconfiguration
#                   report files.
# @param regmap_list - A list of which register maps to include. This list will be passed
#                     to the ::alt_xcvr::utils::device_get_arria10_regmap. (e.g. {pcs pma} or {atx} or {fpll}
proc ::altera_xcvr_native_vi::fileset::generate_config_files {ip_name fileset criteria regmap_list } {
  variable ALT_XCVR_REL_PATH

  # Bail if reconfiguration is disabled
  if { ![ip_get "parameter.rcfg_enable.value"] } {
    return
  }
 
  # Determine which files are requested
  set rcfg_sv_file_enable [ip_get "parameter.rcfg_sv_file_enable.value"]
  set rcfg_h_file_enable [ip_get "parameter.rcfg_h_file_enable.value"]
  set rcfg_mif_file_enable [ip_get "parameter.rcfg_mif_file_enable.value"]

  # Retrieve register map
  set regmap [::alt_xcvr::utils::device::get_arria10_regmap $regmap_list [ip_get "parameter.device_revision.value"]]
  if {$regmap == -1} {
    ::alt_xcvr::ip_tcl::messages::ip_message error "Register map data not available."
    return
  }

  # Collect useful parameters
  set rcfg_multi_enable [ip_get "parameter.rcfg_multi_enable.value"]
  set rcfg_emb_strm_enable [ip_get "parameter.rcfg_emb_strm_enable.value"]
  set rcfg_profile_cnt [expr {$rcfg_multi_enable ? [ip_get "parameter.rcfg_profile_cnt.value"] 
    : 1 }]
  # Get the configuration file prefix
  set rcfg_file_prefix [ip_get "parameter.rcfg_file_prefix.value"]
  set file_prefix "${rcfg_file_prefix}_reconfig_parameters"
  set this_file_prefix $file_prefix
  set profile_values [dict create]

  # For multiple configuration profiles, we put the framework in standalone
  # mode and re-validate; then build the config data for that profile
  # (Seriously spooky black magic stuff here! - Kids don't try this at home!)
  # Enable IP TCL framework standalone mode
  if {$rcfg_multi_enable} {
    ip_set_standalone_mode 1
    # Get the list of parameters to load
    set params [ip_get "parameter.rcfg_params.value"]
    for {set index 0} {$index < $rcfg_profile_cnt} {incr index} {
      dict set profile_values $index [ip_get "parameter.rcfg_param_vals${index}.value"]
    }
  }

  # Iterate over each configuration and build config data
  set rcfg_data [dict create]
  for {set index 0} {$index < $rcfg_profile_cnt} {incr index} {
    ::alt_xcvr::ip_tcl::messages::ip_message info "Building configuration data for reconfiguration profile $index"
    if {$rcfg_multi_enable} {
      # Get the parameter values to load for this configuration
      set param_values [dict get $profile_values $index]
      # Load the parameter values for this configuration
      for {set i 0} {$i < [llength $params]} {incr i} {
        ip_set "parameter.[lindex $params $i].value" [lindex $param_values $i]
      }
      # Re-validate IP with loaded parameters
      ::alt_xcvr::ip_tcl::messages::ip_message info "Validating reconfiguration profile $index"
      ip_validate_parameters
      ::alt_xcvr::ip_tcl::messages::issue_deferred_messages
    }
    # Build reconfiguration data for this configuration
    dict set rcfg_data $index [build_config_data $criteria $regmap]  
  }
  # produce reconfig_settings for each of the PCS atoms only if multi profile is enabled
  # this is essential in order to pull multiple timing modes 
  if {$rcfg_multi_enable} { 
    set pcs_atom_list { \
      hssi_10g_rx_pcs \
      hssi_10g_tx_pcs \
      hssi_8g_rx_pcs \
      hssi_8g_tx_pcs \
      hssi_common_pcs_pma_interface \
      hssi_common_pld_pcs_interface \
      hssi_gen3_rx_pcs \
      hssi_krfec_rx_pcs \
      hssi_pipe_gen1_2 \
      hssi_rx_pcs_pma_interface \
      hssi_rx_pld_pcs_interface \
      hssi_tx_pcs_pma_interface \
      hssi_tx_pld_pcs_interface \
    }
  
    set split_qsys_output_name [split $ip_name "_"]
    set xcvr_nphy_index [lsearch $split_qsys_output_name "altera"]
    if {$xcvr_nphy_index < 0} {
      set list_top_inst_name $split_qsys_output_name
    } else {
      set list_top_inst_name [lreplace $split_qsys_output_name $xcvr_nphy_index end]
    }
    set top_inst_name [join $list_top_inst_name "_"]

    set random_str [lindex [split $ip_name "_"] end]

    foreach item $pcs_atom_list {
      generate_reconfig_settings $top_inst_name $random_str $rcfg_profile_cnt $item $rcfg_data
    }
  }

  # Disable standalone mode if previously enabled
  if {$rcfg_multi_enable} {
    ip_set_standalone_mode 0
    # Reduce reconfiguration data if enabled
    if {[ip_get "parameter.rcfg_reduced_files_enable.value"]} {
      set rcfg_data [reduce_ram_config_data $rcfg_data]
      set rcfg_data [reduce_ascii_config_data $rcfg_data]
    }
  }

  # If no reconfiguration report files are requested when the embedded streamer is not enabled, return
  # Else, go ahead to generate the requested configuration file or the internal ROM initialization file for the streamer
  if {!$rcfg_emb_strm_enable && !$rcfg_sv_file_enable && !$rcfg_h_file_enable && !$rcfg_mif_file_enable} {
    return
  }

  # Hex file of concatenated config profiles used to initialize the rom for the embedded reconfiguration streamer if enabled
  set concat_hex_file_contents ""
  # List of config profile depths in order of increasing profile number
  set config_depths_list ""
  set rom_depth 0  

  # Iterate over profiles and generate config files
  for {set index 0} {$index < $rcfg_profile_cnt} {incr index} {
    ::alt_xcvr::ip_tcl::messages::ip_message info "Generating configuration files for reconfiguration profile $index"
    # Build reconfiguration data dictionary
    set ascii_data [dict get $rcfg_data $index ascii_data]
    set ram_data [dict get $rcfg_data $index ram_data]

    # Append suffix for multi-config
    if {$rcfg_multi_enable} {
      set this_file_prefix "${file_prefix}_CFG${index}"
    }

    # Generate the SystemVerilog package file if requested
    if { $rcfg_sv_file_enable } {
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating SystemVerilog configuration file for reconfiguration profile $index"
      set filename "${this_file_prefix}.sv"
      set file_contents [::alt_xcvr::utils::ipgen::create_system_verilog_param_package "arria10" ${this_file_prefix} $ascii_data $ram_data]
      add_fileset_file "./reconfig/${filename}" SYSTEM_VERILOG TEXT $file_contents
    }

    # Generate the C header file if requested
    if { $rcfg_h_file_enable } {
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating C header configuration file for reconfiguration profile $index"
      set filename "${this_file_prefix}.h"
      set macro_prefix $rcfg_file_prefix
      if {$rcfg_multi_enable} {
        set macro_prefix "${macro_prefix}_CFG${index}"
      }
      set file_contents [::alt_xcvr::utils::ipgen::create_c_param_header "arria10" ${this_file_prefix} $macro_prefix $ascii_data $ram_data]
      add_fileset_file "./reconfig/${filename}" OTHER TEXT $file_contents
    }

    # Generate the MIF file if requested
    if { $rcfg_mif_file_enable } {
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating MIF configuration file for reconfiguration profile $index"
      set filename "${this_file_prefix}.mif"
      set file_contents [::alt_xcvr::utils::ipgen::create_series10_style_mif "arria10" $ram_data]
      add_fileset_file "./reconfig/${filename}" OTHER TEXT $file_contents
    }

    # Add values to concatenated hex file if embedded reconfiguration enabled    
    if { $rcfg_emb_strm_enable } {
      set results [::alt_xcvr::utils::ipgen::create_raw_hex_file "arria10"  $ram_data]
      set concat_hex_file_contents "${concat_hex_file_contents}[lindex ${results} 1]"
      set config_depths_list "${config_depths_list}[lindex $results 0],"
      set rom_depth [expr {$rom_depth + [lindex $results 0]}]
    }
  }
 
  set random_str [lindex [split $ip_name "_"] end]
   
  if { $rcfg_emb_strm_enable } {
      # Generate SV package file for embedded reconfig
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating SystemVerilog package file with embedded reconfiguration parameters"
      set filename "alt_xcvr_native_rcfg_strm_params_${random_str}.sv"
      set file_contents [::alt_xcvr::utils::ipgen::create_rcfg_strm_params "arria10" "alt_xcvr_native_rcfg_strm_params_${random_str}" $config_depths_list $rom_depth $concat_hex_file_contents]
      add_fileset_file "./${filename}" SYSTEM_VERILOG TEXT $file_contents      

      # Generate embedded reconfig files 
      set path "${ALT_XCVR_REL_PATH}/altera_xcvr_native_phy/altera_xcvr_native_vi"
      set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]

      
      set embedded_rcfg_files { \
        alt_xcvr_native_rcfg_strm_functions.sv \
        alt_xcvr_native_rcfg_strm_ctrl.sv \
      }
      
      ::alt_xcvr::ip_tcl::messages::ip_message info "Generating embedded reconfiguration modules"
      # Read files and generate dynamically
      foreach file $embedded_rcfg_files {
        set filename "${path}/${file}"
        set file_handle [open ${filename} r] 
        set contents [read $file_handle]
        set output_filename $file
        add_fileset_file "./${output_filename}" SYSTEM_VERILOG TEXT $contents
      }
  }

}


##
# Generates files needed to include the optional JTAG master.
# This procedure generates a QSYS system and adds the needed files to
# the fileset
proc ::altera_xcvr_native_vi::fileset::generate_jtag_master_files { fileset } {
  variable ALT_XCVR_REL_PATH
  # Create temp file
  set filename [create_temp_file "ip_gen_script_${fileset}.tcl"]
  set filepath [file dirname $filename]

  set qsys_file "${ALT_XCVR_REL_PATH}/altera_xcvr_native_phy/altera_xcvr_native_vi/jtag_master.qsys"
  set arglist [list "--component-file=${qsys_file}" "--fileset=${fileset}"]
  # Call ip-generate
  set filelist [::alt_xcvr::utils::ipgen::ipgenerate $filepath $filename $fileset $arglist 1]
}


##
# Generates a file "<ip_name>_parameters.csv" that contains static information for this
# IP core's parameters.
# Fields in the CSV are:
# parameter name, display name, allowed ranges, default value, description
# The file is automatically added to the fileset
#
# @param ip_name - The name of this IP core or IP instance
# @param fileset - The fileset to which to add the generated file (QUARTUS_SYNTH, SIM_VERILOG, SIM_VHDL)
proc ::altera_xcvr_native_vi::fileset::generate_doc_files {ip_name fileset} {
  # Generate parameter documentation file
  set fields {NAME DISPLAY_NAME ALLOWED_RANGES DEFAULT_VALUE DESCRIPTION}

  set contents ""
  #Print out the header row
  for {set x 0} {$x < [llength $fields]} {incr x} {
    set field [lindex $fields $x]
    if {$x != 0} {
      set contents "${contents},"
    }
    set contents "${contents}${field}"
  }
  set contents "${contents}\n"

  set params [ip_get_matching_parameters {DERIVED 0 ENABLED 1}]
  foreach param $params {
    for {set x 0} {$x < [llength $fields]} {incr x} {
      set field [lindex $fields $x]
      if {$x != 0} {
        set contents "${contents},"
      }

      set val [ip_get "parameter.${param}.${field}"]

      # Create allowed_ranges for boolean display hint parameters if allowed_ranges is not specified
      if {$field == "ALLOWED_RANGES"} {
        set type [string toupper [ip_get "parameter.${param}.type"]]
        set display_hint [string toupper [ip_get "parameter.${param}.display_hint"]]
        if {$type == "INTEGER" && $display_hint == "BOOLEAN"} {
          if {${val} == "-2147483648:2147483647"} {
            set val "{0 1}"
          }
        }
        if {$type == "STRING" && $display_hint == "BOOLEAN"} {
          if {${val} == ""} {
            set val "{true false}"
         }
        }
      }
      set contents "${contents}\"${val}\""
    }
    set contents "${contents}\n"
  }
  set filename "${ip_name}_parameters.csv"
  add_fileset_file "./docs/${filename}" OTHER TEXT $contents
  
}


##
# Generates a file "<ip_name>_add_hdl_instance_example" that contains an example usages
# of the "_hw.tcl" add_hdl_instance API for the current configuration of this IP core.
# The file is automatically added to the fileset
#
# @param ip_name - The name of this IP core or IP instance
# @param fileset - The fileset to which to add the generated file (QUARTUS_SYNTH, SIM_VERILOG, SIM_VHDL)
proc ::altera_xcvr_native_vi::fileset::generate_add_hdl_instance_example { ip_name fileset } {
  set criteria [dict create DERIVED 0]
  set params [ip_get_matching_parameters $criteria]

  # Create list of param value pairs
  set param_list {}
  foreach param $params {
    # Only include parameters that are not set to the default (to reduce list)
    set param_val [ip_get "parameter.${param}.value"]
    set default_val [ip_get "parameter.${param}.default_value"]
    if { $param_val != $default_val } {
      lappend param_list $param
      lappend param_list $param_val
    }
  }

  # Create file
  set contents "add_hdl_instance ${ip_name}_inst $ip_name\n"
  if {[llength $param_list] > 0} {
    set contents "${contents}set param_val_list \{${param_list}\}\n"
    set contents "${contents}foreach \{param val\} \$param_val_list \{\n"
    set contents "${contents}  set_instance_parameter_value ${ip_name}_inst \$param \$val\n"
    set contents "${contents}\}\n"
  }
  
  set filename "${ip_name}_add_hdl_instance_example.tcl"
  add_fileset_file "./docs/${filename}" OTHER TEXT $contents
}

###
# Builds a dictionary containing register map information for parameters
# that can subsequently be used to create reconfiguration report files.
#
# @param criteria - A dictionary containing criteria for which IP parameters
#                   should be included in the returned data structure. This
#                   criteria will be passed to
#                   "::alt_xcvr::ip_tcl::ip_module::ip_get_matching_parameters"
#                   to obtain a parameter list.
#                   The criteria dictionary should contain a list of
#                   <parameter property->parameter property_value> pairs. Only
#                   those parameters whose properties meet all criteria will be
#                   included.
#
# @param rcfg_regmap - A dictionary of the format obtained from a call to
#                   "::alt_xcvr::utils::device::get_arria10_regmap" as an example.
#                   This dictionary contains register map data for each parameter.
#
# @return - Returns a dictionary that contains two important subdictionaries
#           ascii_data <data for creation of ascii report files>
#           ram_data <data for creation of address offset based files>
#
#           ascii_data is organized by parameter name
#           ram_data is organized by register offset
proc ::altera_xcvr_native_vi::fileset::build_config_data { criteria rcfg_regmap } {
  # Initialize our config data dictionaries
  set ascii_data [dict create]
  set ram_data [dict create]

  # Get list of parameters that match the criteria
  set params [ip_get_matching_parameters $criteria]

  # Iterate over each parameter
  foreach param $params {
    # Get parameter value
    set val [ip_get "parameter.${param}.value"]

    # Convert parameter value to string if necessary and add to ascii data
    set str_val $val
    if {[string toupper [ip_get "parameter.${param}.type"]] == "STRING"} {
      set str_val "\"${str_val}\""
    } else {
      set width [ip_get "parameter.${param}.width"];
      if {$width != "NOVAL" && $width != ""} {
        set str_val "${width}'d${str_val}"
      } 
    }

    dict set ascii_data $param "value" $str_val

    # Get register map data for this parameter
    set regmap "NOVAL"
    if { [dict exists $rcfg_regmap $param] } {
      set regmap [dict get $rcfg_regmap $param]
    }

    if {$regmap != "NOVAL"} {
      # Iterate over attribute possible attribute values
      dict for {attrib_value offset} $regmap {

        # For direct mapped parameters override attribute value
        set is_direct [expr {$attrib_value == "DIRECT MAPPED"}]

        # Proceed if the attribute value matches
        if {$attrib_value == $val || $is_direct} {
          # If there are multiple address offsets, give them indices
          set addr_idx ""
          if {[dict size $offset] > 1} {
            set addr_idx 0
          }

          # Iterate over address offsets in the regmap data
          dict for {this_offset bit_offset} $offset {
            # Add address offset
            set this_offset_dec [expr 0x${this_offset}]
            dict set ascii_data $param "ADDR${addr_idx}_OFST" $this_offset_dec

            # If there are multiple bit offsets, give them indices
            set field_idx ""
            if {[dict size $bit_offset] > 1} {
              set field_idx 0
            }

            # definining regular expressions to be used to extract high and low indices from a range definition
            # range could be one of the following three cases (due to the way information is presented in register map spreadsheet) 
            # [M:N] where M is high index and N is low index ()
            # or [M] where M is both high and low index 
            # or M where M is both high and low index
            set reg_exp_for_high_index {(\[)?([0-9]*)(:)?([0-9]*)?(\])?}
            set reg_exp_for_low_index   {(\[)?([0-9]*:)?([0-9]*)(\])?}

            # Iterate over bitfield offsets
            dict for {this_bit_offset bit_value} $bit_offset {
              # Find low and high bits of bitfield range
              set bit_l [regsub $reg_exp_for_low_index $this_bit_offset {\3}]
              set bit_h [regsub $reg_exp_for_high_index $this_bit_offset {\2}]
              set bit_s [expr {($bit_h + 1) - $bit_l}]

              if {$is_direct} {
                # Modify value for direct mapped parameters
                set val_range_l [regsub $reg_exp_for_low_index $bit_value {\3}]
                set val_range_h [regsub $reg_exp_for_high_index $bit_value {\2}]
                set val_range_mask 0
                # Mask off needed bits
                for {set x $val_range_l} {$x <= $val_range_h} {incr x} {
                  set val_range_mask [expr {$val_range_mask | (1 << $x)}]
                }
                set bit_value [expr {($val & $val_range_mask) >> $val_range_l}]
              } else {
                # Convert non-direct mapped parameters from binary to decimal
                set bit_value [regsub {[0-9]*'b([01]*)} $bit_value "\\1"]
                set bit_value [::alt_xcvr::utils::common::bin_to_dec $bit_value]
              }

              # Create bitfield mask
              set mask 0
              for {set x $bit_l} {$x <= $bit_h} {incr x} {
                set mask [expr {$mask | (1 << $x)}]
              }
              set mask_val [expr {$bit_value << $bit_l}]

              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_OFST" $bit_l
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_HIGH" $bit_h
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_SIZE" $bit_s
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_BITMASK" "32'h[format %08X $mask]"
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_VALMASK" "32'h[format %08X $mask_val]"
              dict set ascii_data $param "ADDR${addr_idx}_FIELD${field_idx}_VALUE" "$bit_s'h[format %X $bit_value]"

              dict set ram_data $this_offset_dec $bit_h mask $mask
              dict set ram_data $this_offset_dec $bit_h val_mask $mask_val
              dict set ram_data $this_offset_dec $bit_h param $param
              dict set ram_data $this_offset_dec $bit_h param_val $val
              dict set ram_data $this_offset_dec $bit_h bit_l $bit_l
              dict set ram_data $this_offset_dec $bit_h bit_h $bit_h
              dict set ram_data $this_offset_dec $bit_h bit_s $bit_s
              dict set ram_data $this_offset_dec $bit_h bit_value $bit_value

              # Increment to next field index if necessary
              if {$field_idx != ""} {
                incr field_idx
              }
            }
            # Increment to next address index if necessary
            if {$addr_idx != ""} {
              incr addr_idx
            }
          }
        }
      }
    }
  }
  #puts "\[build_config_data\] Returning"
  #::alt_xcvr::ip_tcl::ip_module::print_dict $ascii_data
  return [dict create ascii_data $ascii_data ram_data $ram_data]
}


##
# Analyzes multiple sets of config data and reduces there ascii data
# to only those parameters whose values are different. Note that this procedure
# does not reduce parameters whose settings might be different but the resulting
# bit data is the same. For example two parameter values that result in the same
# bit settings will not be reduced.
#
# @param config_data - A dictionary where each key contains a dictionary of
# reconfig data (both ascii_data and ram_data) as returned by the "build_config_data"
# procedure
#
# @return - The same dictionary as passed but with all redundant data removed.
proc ::altera_xcvr_native_vi::fileset::reduce_ascii_config_data { config_data } {

  set keys [dict keys $config_data]
  set config_cnt [llength $keys]
  if {$config_cnt < 2} {
    return $config_data
  }

  set config0 [lindex $keys 0]
  # Let's prune the ASCII data first 
  # Iterate over every parameter in the ASCII data
  dict for {param data} [dict get $config_data $config0 ascii_data] {
    set same 1
    # Compare the value for this parameter for each config.
    for {set index 1} {$index < $config_cnt} {incr index} {
      set key [lindex $keys $index]
      # If the parameter values are identical, remove the element
      if {[dict get $data value] != [dict get $config_data $key ascii_data $param value]} {
        set same 0
      }
    }

    if {$same} {
      for {set index 0} {$index < $config_cnt} {incr index} {
        set key [lindex $keys $index]
        dict set config_data $key ascii_data [dict remove [dict get $config_data $key ascii_data] $param]
      }
    }
  }
  return $config_data
}


##
# Analyzes multiple sets of config data and reduces the ram config data to only
# those data bits that differ between them all.
#
# @param config_data - A dictionary where each key contains a dictionary of
# reconfig data (both ascii_data and ram_data) as returned by the "build_config_data"
# procedure
#
# @return - The same dictionary as passed but with all redundant data removed.
proc ::altera_xcvr_native_vi::fileset::reduce_ram_config_data { config_data } {
  set keys [dict keys $config_data]
  set config_cnt [llength $keys]
  if {$config_cnt < 2} {
    return $config_data
  }

  set config0 [lindex $keys 0]
  dict for {offset high_bits} [dict get $config_data $config0 ram_data] {
    dict for {bit_h data} $high_bits {
      set same 1
      # Iterate over all configs to see if the data is the same
      for {set index 1} {$index < $config_cnt} {incr index} {
        set key [lindex $keys $index]
        if {[dict get $data val_mask] != [dict get $config_data $key ram_data $offset $bit_h val_mask]} {
          set same 0
        }
      }

      # Remove this entry from each config
      if {$same} {
        #puts "Removing [dict get $data param]:[dict get $data param_val] @ $offset:$bit_h"
        for {set index 0} {$index < $config_cnt} {incr index} {
          set key [lindex $keys $index]
          # Remove this bitfield if they were the same
          dict set config_data $key ram_data $offset [dict remove [dict get $config_data $key ram_data $offset] $bit_h]

          # If all bitfields for a given offset have been removed, remove the offset
          if {[llength [dict keys [dict get $config_data $key ram_data $offset]]] == 0} {
            dict set config_data $key ram_data [dict remove [dict get $config_data $key ram_data] $offset]
          }
        }
      }
      # Done with this bitfield
    }
    # Done with this offset
  }
  return $config_data
}


