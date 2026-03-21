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



package provide altera_xcvr_native_s10::fileset 18.1

package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::ipgen
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::utils::reconfiguration_stratix10
package require altera_xcvr_native_s10::parameters
package require altera_terp


namespace eval ::altera_xcvr_native_s10::fileset:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::utils::fileset::*
  namespace import ::alt_xcvr::utils::reconfiguration_stratix10::*

  namespace export \
    declare_filesets \
    declare_files

  variable filesets
  variable reconfig_timing_atoms
  variable ip_params_for_timing

  set filesets {\
    { NAME            TYPE            CALLBACK                                                  TOP_LEVEL             }\
    { quartus_synth   QUARTUS_SYNTH   ::altera_xcvr_native_s10::fileset::callback_quartus_synth  }\
    { example_design  EXAMPLE_DESIGN  ::altera_xcvr_native_s10::design_example::callback_design_example }\
    { sim_verilog     SIM_VERILOG     ::altera_xcvr_native_s10::fileset::callback_sim_verilog    }\
    { sim_vhdl        SIM_VHDL        ::altera_xcvr_native_s10::fileset::callback_sim_vhdl       }\
  }

  set reconfig_timing_atoms { \
      hssi_10g_rx_pcs \
      hssi_10g_tx_pcs \
      hssi_8g_rx_pcs \
      hssi_8g_tx_pcs \
      hssi_gen3_rx_pcs \
      hssi_gen3_tx_pcs \
      hssi_common_pcs_pma_interface \
      hssi_common_pld_pcs_interface \
      hssi_krfec_rx_pcs \
      hssi_pipe_gen1_2 \
      hssi_pipe_gen3 \
      hssi_rx_pcs_pma_interface \
      hssi_rx_pld_pcs_interface \
      hssi_tx_pcs_pma_interface \
      hssi_tx_pld_pcs_interface \
      hssi_pldadapt_rx \
      hssi_pldadapt_tx
    }

  set ip_params_for_timing { \
      set_data_rate \
      bonded_mode \
      tx_enable \
      rx_enable \
      l_tx_fifo_transfer_mode \
      l_rx_fifo_transfer_mode \
      std_pcs_pma_width \
      enh_pcs_pma_width \
      pcs_direct_width \
      datapath_select \
      protocol_mode \
      tx_fifo_mode \
      rx_fifo_mode \
      std_tx_byte_ser_mode \
      std_rx_byte_deser_mode \
      duplex_mode \
      enable_hip \
      tx_clkout_sel \
      rx_clkout_sel \
      enable_port_tx_clkout2 \
      enable_port_rx_clkout2 \
      tx_clkout2_sel \
      rx_clkout2_sel \
      l_tx_transfer_clk_hz \
      l_rx_transfer_clk_hz \
      tx_pma_div_clkout_divider \
      rx_pma_div_clkout_divider
  }

}

proc ::altera_xcvr_native_s10::fileset::declare_filesets { } {
  variable filesets

  declare_files
  ip_declare_filesets $filesets
}

proc ::altera_xcvr_native_s10::fileset::declare_files {} {
  # Common files
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/../altera_xcvr_generic/ctrl/"
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    alt_xcvr_arbiter.sv
  } {ALTERA_XCVR_NATIVE_S10}

  set quartus_rootdir $::env(QUARTUS_ROOTDIR)
  set path "${quartus_rootdir}/../ip/altera/primitives/altera_std_synchronizer/"
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    altera_std_synchronizer_nocut.v
  } {ALTERA_XCVR_NATIVE_S10}
 
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/alt_xcvr_generic/"
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    alt_xcvr_resync_std.sv
  } {ALTERA_XCVR_NATIVE_S10}    

  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_reset_control_s10/"
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    alt_xcvr_reset_counter_s10.sv
  } {ALTERA_XCVR_NATIVE_S10}

  # altera_xcvr_native_s10 files
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/source"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    altera_xcvr_native_s10_functions_h.sv
    s10_avmm_h.sv
    alt_xcvr_native_avmm_csr.sv  
    alt_xcvr_native_prbs_accum.sv  
    alt_xcvr_native_odi_accel.sv  
    alt_xcvr_native_rcfg_arb.sv
    alt_xcvr_native_anlg_reset_seq.sv 
    alt_xcvr_native_dig_reset_seq.sv
    alt_xcvr_native_reset_seq.sv
  } {ALTERA_XCVR_NATIVE_S10}

}

##
# Fileset callback for Quartus synthesis
proc ::altera_xcvr_native_s10::fileset::callback_quartus_synth {ip_name} {
  callback_generate_files $ip_name QUARTUS_SYNTH
  
  # use qsys_unique_name only for the top_level_file 
  # for other files, just mention the prefix, it will be appended with an unique random number 
  set list_of_unique_files_for_synth []
  lappend list_of_unique_files_for_synth altera_xcvr_native_s10.sv.terp qsys_unique_name 

  set enable_hip [ip_get "parameter.enable_hip.value"]
  if {!$enable_hip} {
    lappend list_of_unique_files_for_synth alt_xcvr_native.sdc.terp alt_xcvr_native.sdc
    lappend list_of_unique_files_for_synth alt_xcvr_native_helper_functions.tcl.terp alt_xcvr_native_helper_functions.tcl
  }

  if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
    lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
    lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
    lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_strm_ctrl.sv.terp alt_xcvr_native_rcfg_strm_ctrl.sv
  }
  lappend list_of_unique_files_for_synth alt_xcvr_native_rcfg_opt_logic.sv.terp alt_xcvr_native_rcfg_opt_logic.sv

  # generate a set of uniquely named files. Argument is the list of files (dict)
  generate_unique_files $ip_name $list_of_unique_files_for_synth

  set rcfg_multi_enable [ip_get "parameter.rcfg_multi_enable.value"]
  generate_parameters_file $ip_name "native_phy" $rcfg_multi_enable $enable_hip

}


### 
# Generate unique file names and unique module names 
# @param qsys_output_name - unique random string generated by qsys 
# @param list_of_unique files - dict of files, contains the files and desired file names
#
proc ::altera_xcvr_native_s10::fileset::generate_unique_files {qsys_output_name list_of_unique_files} {
	variable reconfig_timing_atoms

	# terp files; all terp files are in ${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/terp/
	set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
	set path "${path}/altera_xcvr_native_phy/altera_xcvr_native_s10/terp/"
	set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  
	# split the qsys_output_name to extract the ip_module_name, ip_component_name and random str 
	#		e.g. test_altera_xcvr_native_s10_160_hzymdhi
	regexp -nocase {(\w+)_altera_xcvr_native_s10_(\w+)_(\w+)} $qsys_output_name matched ip_name release_number random_str 
	set ip_component_name "altera_xcvr_native_s10_${release_number}"  

	# iterate over all the dict keys i.e list of files 
	foreach file [dict keys $list_of_unique_files] {
		# get template 
		set filename ${path}/${file} 
		set file_handle [open ${filename} r] 
		set template [read $file_handle]

		# setup template parameters 
		# any variable used in terp template should be declared here 
		set value [dict get $list_of_unique_files $file] 
                set file_split [split $value "."]
		set file_ext [lindex $file_split end]
		set file_name [lindex $file_split 0]

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
		  foreach atom $reconfig_timing_atoms {
			set template_params(${atom}_reconfig_settings) \"${common_path}/${atom}_reconfig_settings_${random_str}.json\"
		  }
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

                # add the file to the fileset 
                if {$file_ext eq "v" } {
                      add_fileset_file "./$output_filename" VERILOG TEXT $contents
                } elseif {$file_ext eq "sv" || $file_ext eq "qsys_unique_name"} {
                      add_fileset_file "./$output_filename" SYSTEM_VERILOG TEXT $contents
                } elseif {$file_ext eq "vhd"} {
                      add_fileset_file "./$output_filename" VHDL TEXT $contents
                } elseif {$file_ext eq "mif" || $file_ext eq "hex" || $file_ext eq "dat" || $file_ext eq "sdc"} {
                      add_fileset_file "./$output_filename" $file_ext TEXT $contents
                } else {
                      add_fileset_file "./$output_filename" OTHER TEXT $contents
                }

	} 
}

####
# Generate parameter file for each Native PHY Configuration
# @param ip_name - Top level name
#
proc ::altera_xcvr_native_s10::fileset::generate_parameters_file {ip_name ip_core rcfg_multi_enable enable_hip} {
  variable ip_params_for_timing

  # Loop over every param and find its value for non-reconfig designs 
  if {!$rcfg_multi_enable && !$enable_hip} {
    set file_contents ""
 
    # extract the unique random string 
    set random_str [lindex [split $ip_name "_"] end]
        
    append file_contents "if {[info exists ip_params]} {\n"
    append file_contents "   unset ${ip_core}_ip_params\n"
    append file_contents "}\n\n"
    append file_contents "set ${ip_core}_ip_params \[dict create\]\n\n"

    append file_contents "dict set ${ip_core}_ip_params profile_cnt \"1\"\n"

    append file_contents "set ::GLOBAL_corename $ip_name\n"
    
    append file_contents "# -------------------------------- #\n"
    append file_contents "# --- Default Profile settings --- #\n" 
    append file_contents "# -------------------------------- #\n"

    foreach param $ip_params_for_timing {
      set param_value [ip_get "parameter.$param.value"]
      append file_contents "dict set ${ip_core}_ip_params ${param}_profile0 \"$param_value\"\n" 
    } 
  
    #TODO: for STRATIX10
    set tx_coreclkin_freq [ip_get "parameter.set_data_rate.value"]
    append file_contents "dict set ${ip_core}_ip_params tx_coreclkin_freq_profile0 \"156.25\""

    # Print out the ip_parameters.tcl file
    set filename "${ip_core}_ip_parameters_${random_str}.tcl"
    add_fileset_file "./${filename}" OTHER TEXT $file_contents

  }
}


##
# Fileset callback for Verilog simulation
proc ::altera_xcvr_native_s10::fileset::callback_sim_verilog {ip_name} {
  callback_generate_files $ip_name SIM_VERILOG
  set_fileset_file_attribute altera_xcvr_native_s10_functions_h.sv COMMON_SYSTEMVERILOG_PACKAGE altera_xcvr_native_s10_functions_h 

  # use qsys_unique_name only for the top_level_file 
  # for other files, just mention the prefix, we will append it with unique random number 
  set list_of_unique_files_for_sim_vlg []
  lappend list_of_unique_files_for_sim_vlg altera_xcvr_native_s10.sv.terp qsys_unique_name 
    
  if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
    lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_strm_ctrl.sv.terp alt_xcvr_native_rcfg_strm_ctrl.sv
  }
  lappend list_of_unique_files_for_sim_vlg alt_xcvr_native_rcfg_opt_logic.sv.terp alt_xcvr_native_rcfg_opt_logic.sv

  # generate a set of uniquely named files. Argument is the list of files 
  generate_unique_files $ip_name $list_of_unique_files_for_sim_vlg
}

##
# Fileset callback for VHDL simulation
proc ::altera_xcvr_native_s10::fileset::callback_sim_vhdl {ip_name} {
  callback_generate_files $ip_name SIM_VHDL  
  set_fileset_file_attribute altera_xcvr_native_s10_functions_h.sv COMMON_SYSTEMVERILOG_PACKAGE altera_xcvr_native_s10_functions_h 

  # use qsys_unique_name only for the top_level_file 
  # for other files, just mention the prefix, we will append it with unique random number 
  set list_of_unique_files_for_sim_vhdl []
  lappend list_of_unique_files_for_sim_vhdl altera_xcvr_native_s10.sv.terp qsys_unique_name 
    
  if { [ip_get "parameter.rcfg_emb_strm_enable.value"] } {
    lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_rom.sv.terp alt_xcvr_native_rcfg_strm_rom.sv 
    lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_top.sv.terp alt_xcvr_native_rcfg_strm_top.sv
    lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_strm_ctrl.sv.terp alt_xcvr_native_rcfg_strm_ctrl.sv
  }
  lappend list_of_unique_files_for_sim_vhdl alt_xcvr_native_rcfg_opt_logic.sv.terp alt_xcvr_native_rcfg_opt_logic.sv

  # generate a set of uniquely named files
  # argument: dict specifying the terp file and the eventual output_filename desired 
  generate_unique_files $ip_name $list_of_unique_files_for_sim_vhdl
}


##
# Common fileset callback
proc ::altera_xcvr_native_s10::fileset::callback_generate_files {ip_name fileset} {
  variable reconfig_timing_atoms
  variable ip_params_for_timing

  set rcfg_criteria {M_RCFG_REPORT 1}
  set regmap_list {pcs pma}
  set ip_core "native_phy"

  # Add previously declared files to fileset
  set tags [expr {$fileset == "QUARTUS_SYNTH" ? {PLAIN QIP}
    : [concat PLAIN [common_fileset_tags_all_simulators]] }]
  common_add_fileset_files {ALTERA_XCVR_NATIVE_S10} $tags

  generate_config_files $ip_name $ip_core $fileset $rcfg_criteria $regmap_list $reconfig_timing_atoms $ip_params_for_timing

  # Generate parameter documentation files if enabled
  if { [ip_get "parameter.generate_docs.value"] } {
    generate_doc_files $ip_name $fileset
  }

  # Generate the "add_hdl_instance" example file if enabled
  if {[ip_get "parameter.generate_add_hdl_instance_example.value"]} {
    generate_add_hdl_instance_example $ip_name $fileset
  }
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
proc ::altera_xcvr_native_s10::fileset::generate_doc_files {ip_name fileset} {
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
proc ::altera_xcvr_native_s10::fileset::generate_add_hdl_instance_example { ip_name fileset } {
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
