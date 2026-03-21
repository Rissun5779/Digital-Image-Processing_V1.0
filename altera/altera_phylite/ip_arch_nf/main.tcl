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


package provide altera_phylite::ip_arch_nf::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_phylite::util::enum_defs
package require altera_emif::util::enum_defs_family_traits_and_features
package require altera_emif::util::device_family
package require altera_phylite::ip_top::exports

package require altera_phylite::ip_arch_nf::pll
package require altera_phylite::ip_arch_nf::sdc
package require altera_phylite::ip_arch_nf::ioaux_param_table
package require altera_emif::ip_arch_nf::enum_defs_ioaux
package require altera_phylite::ip_arch_nf::timing
package require altera_iopll_common::iopll

namespace eval ::altera_phylite::ip_arch_nf::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_iopll_common::iopll::*
   

   variable top_level_mod_name "phylite_core_20"
   variable max_grps 18
}


proc ::altera_phylite::ip_arch_nf::main::create_parameters {} {
   variable max_grps
	
   ::altera_iopll_common::iopll::init
   
   ::altera_phylite::ip_top::exports::inherit_top_level_parameter_defs

   set_parameter_property PHYLITE_NUM_GROUPS                  HDL_PARAMETER true
   set_parameter_property PHYLITE_RATE_ENUM                   HDL_PARAMETER true
   set_parameter_property PHYLITE_USE_DYNAMIC_RECONFIGURATION HDL_PARAMETER true
   set_parameter_property PHYLITE_INTERFACE_ID                HDL_PARAMETER true
   set_parameter_property PHYLITE_USE_CPA                     HDL_PARAMETER true
   set_parameter_property PLL_USE_CORE_REF_CLK                HDL_PARAMETER true

   for { set i 0 } { $i < ${max_grps} } {incr i } {
      set_parameter_property  "GROUP_${i}_PIN_TYPE"                      HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_PIN_WIDTH"                     HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_DDR_SDR_MODE"                  HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_DATA_CONFIG"                   HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_STROBE_CONFIG"                 HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_READ_LATENCY"                  HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_USE_INTERNAL_CAPTURE_STROBE"   HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_CAPTURE_PHASE_SHIFT"           HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_WRITE_LATENCY"                 HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_USE_OUTPUT_STROBE"             HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_OUTPUT_STROBE_PHASE"           HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_USE_SEPARATE_STROBES"          HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_SWAP_CAPTURE_STROBE_POLARITY"  HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_OCT_MODE"                      HDL_PARAMETER true
      set_parameter_property  "GROUP_${i}_OCT_SIZE"                      HDL_PARAMETER true
    }

   set_parameter_property DIAG_SYNTH_FOR_SIM HDL_PARAMETER true

   
   altera_phylite::ip_arch_nf::pll::add_pll_parameters
   add_derived_hdl_param	SILICON_REV	string	"20NM5"
 
   add_derived_hdl_param IO_AUX_CAL_CLK_DIV integer 0
   altera_phylite::ip_arch_nf::ioaux_param_table::add_parameters

   add_derived_hdl_param ENABLE_DFT boolean false

   add_derived_hdl_param PHYLITE_USE_CPA_LOCK boolean false

   add_derived_hdl_param DLL_MODE                           string ""
   add_derived_hdl_param DLL_CODEWORD                       integer 0   

   
   ::altera_iopll_common::iopll::declare_pll_physical_parameters
    
   return 1
}

proc ::altera_phylite::ip_arch_nf::main::elaboration_callback {} {

   ::altera_emif::util::device_family::load_data
	
   ::altera_iopll_common::iopll::init	

   _elaborate_interfaces
   
   set user_mem_clk_freq [get_parameter_value PHYLITE_MEM_CLK_FREQ_MHZ]
   set user_ref_clk_freq [get_parameter_value PHYLITE_REF_CLK_FREQ_MHZ]

   set rate_enum [get_parameter_value PHYLITE_RATE_ENUM]
   set user_afi_ratio [enum_data $rate_enum AFI_RATIO]
   set clk_ratios [dict create]
   dict set clk_ratios PHY_HMC $user_afi_ratio
   dict set clk_ratios C2P_P2C $user_afi_ratio 
   dict set clk_ratios USER    $user_afi_ratio
   set device_family [get_device]
   set dev_part "20nm5"
   
   if {[regexp -lineanchor -nocase {10AX057} $device_family] || [regexp -lineanchor -nocase {10AS057} $device_family] || [regexp -lineanchor -nocase {10AX066} $device_family] || [regexp -lineanchor -nocase {10AS066} $device_family]} {
	   set dev_part "20nm4"
   } elseif {[regexp -lineanchor -nocase {10AX027} $device_family] || [regexp -lineanchor -nocase {10AS027} $device_family] || [regexp -lineanchor -nocase {10AX032} $device_family] || [regexp -lineanchor -nocase {10AS032} $device_family]} {
	   set dev_part "20nm2"
   } elseif {[regexp -lineanchor -nocase {10AX016} $device_family] || [regexp -lineanchor -nocase {10AS016} $device_family] || [regexp -lineanchor -nocase {10AX022} $device_family] || [regexp -lineanchor -nocase {10AS022} $device_family]} {
	   set dev_part "20nm1"
   } elseif {[regexp -lineanchor -nocase {10AX048} $device_family] || [regexp -lineanchor -nocase {10AS048} $device_family]} {
	   set dev_part "20nm3"
   } 

   set silicon_param ""
   if {[regexp -lineanchor -nocase {E2$} $device_family]} {
	   append silicon_param $dev_part "es2"
   } elseif {[regexp -lineanchor -nocase {E3$} $device_family]} {
	   append silicon_param $dev_part "es3"
   } elseif {[regexp -lineanchor -nocase {ES$} $device_family]} {
	   append silicon_param $dev_part "es"
   } else {
	   set silicon_param $dev_part
   }

   set_parameter_value SILICON_REV $silicon_param
   set max_vco [altera_phylite::ip_arch_nf::pll::get_pll_vco_max]

   if { $user_mem_clk_freq <= $max_vco } {
      altera_phylite::ip_arch_nf::pll::derive_pll_parameters $user_mem_clk_freq $user_ref_clk_freq $clk_ratios
   }

   altera_phylite::ip_arch_nf::ioaux_param_table::derive_parameters

   set use_dyn_cfg [get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION]
   if {[string compare -nocase $use_dyn_cfg "true"] == 0} {
      set core_clk_freq [expr double(${user_mem_clk_freq}/${user_afi_ratio})]
      set ioaux_fmax 400
      set max_div 1.0

      set min_cal_clk_div_val 9999

      set core_clk_freq_div5 [expr ${core_clk_freq}/5.0]
      foreach cfg_div_cal_clk_enum [enums_of_type IOAUX_CFG_DIV_CAL_CLK] {
         set div [expr double([enum_data $cfg_div_cal_clk_enum DIV])]
         set cal_bus_freq [expr double(${ioaux_fmax}/${div})]
         if {[expr {($div < $min_cal_clk_div_val) && (${cal_bus_freq} <= ${core_clk_freq_div5})}] == 1} {
            set min_cal_clk_div_val $div
         }
         if { $div > $max_div } {
            set max_div $div
         }
      }

      if { ${min_cal_clk_div_val} == 9999 } {
         set min_supported_core_clock [expr (${ioaux_fmax}/${max_div})*5]
         post_ipgen_e_msg MSG_BELOW_ARCH_CAL_BUS_FMIN [list $core_clk_freq $min_supported_core_clock]
      }

      set_parameter_value IO_AUX_CAL_CLK_DIV $min_cal_clk_div_val

   }

   set use_dft [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_enable_dft_interface"]
   if { $use_dft == 1 } {
      set_parameter_value ENABLE_DFT true
   } else {
      set_parameter_value ENABLE_DFT false
   }

   set use_cpa_lock [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_enable_cpa_lock"]
   if { $use_cpa_lock == 1 } {
      set_parameter_value PHYLITE_USE_CPA_LOCK true
   } else {
      set_parameter_value PHYLITE_USE_CPA_LOCK false
   }
  
   set pll_settings [::altera_phylite::ip_arch_nf::pll::get_pll_settings $user_mem_clk_freq $user_ref_clk_freq $clk_ratios]
   set pll_vco_freq_mhz [dict get $pll_settings PLL_VCO_FREQ_MHZ_INT]
   set use_regular_dll [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_dll_mode"]

   if {$use_regular_dll || $pll_vco_freq_mhz >= 600} {
      set_parameter_value DLL_MODE "ctl_dynamic"
      set_parameter_value DLL_CODEWORD 0
   } else {
      set_parameter_value DLL_MODE "ctl_static"
      set_parameter_value DLL_CODEWORD 1023
   }

   ::altera_iopll_common::iopll::set_physical_parameter_values
   ::altera_iopll_common::iopll::declare_pll_interfaces
   set use_advanced_mode [get_parameter_value gui_enable_advanced_mode]
   set num_of_additional_clock [get_parameter_value gui_number_of_pll_output_clocks]

   set pll_valid_vco 1
   if {$num_of_additional_clock > 0} {
      set pll_settings [::altera_phylite::ip_arch_nf::pll::get_pll_settings $user_mem_clk_freq $user_ref_clk_freq $clk_ratios]
      set pll_vco_freq_mhz [dict get $pll_settings PLL_VCO_FREQ_MHZ_INT]
      set pll_extra_clks_min_vco_freq_mhz 600
      
      if {$pll_vco_freq_mhz < $pll_extra_clks_min_vco_freq_mhz} {
	 post_ipgen_e_msg MSG_PLL_EXTRA_CLKS_NOT_ALLOWED [list $pll_extra_clks_min_vco_freq_mhz $pll_vco_freq_mhz]
      }     
   }

   if {$use_advanced_mode && $num_of_additional_clock > 0} {
      ::altera_iopll_common::iopll::enable_pll_locked_port
   }
   
   _update_qip

   issue_pending_ipgen_e_msg_and_terminate
   
   return 1
}

proc ::altera_phylite::ip_arch_nf::main::sim_vhdl_fileset_callback {top_level} {
   variable top_level_mod_name
   set rtl_only 0
   set encrypted 1   
   
   set non_encryp_simulators [::altera_emif::util::hwtcl_utils::get_simulator_attributes 1]
   
   set file_paths [_generate_verilog_fileset $top_level]

   foreach file_path $file_paths {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]

      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only 0] PATH $file_path $non_encryp_simulators

      add_fileset_file [file join mentor $file_name] [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join mentor $file_path] {MENTOR_SPECIFIC}
   }
   
   set use_dyn_cfg [get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION]

   set extra_params [list]

   if {[string compare -nocase $use_dyn_cfg "true"] == 0} {
      set param_table_filename_param [::altera_phylite::ip_arch_nf::ioaux_param_table::get_param_table_filename_parameter_name]
      set param_table_filename       [::altera_phylite::ip_arch_nf::ioaux_param_table::get_param_table_filename $top_level]

      set extra_params [list [list $param_table_filename_param "\"${param_table_filename}\""]]
   }

   set all_simulators [::altera_emif::util::hwtcl_utils::get_simulator_attributes 0]
   set file_paths [concat [::altera_emif::util::hwtcl_utils::generate_top_level_vhd_wrapper $top_level $top_level_mod_name $extra_params] \
                          [_generate_common_fileset $top_level]]

   foreach file_path $file_paths {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only 0] PATH $file_path $all_simulators
   }      
}

proc ::altera_phylite::ip_arch_nf::main::sim_verilog_fileset_callback {top_level} {
   variable top_level_mod_name

   set rtl_only 0
   set encrypted 0

   set use_dyn_cfg [get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION]

   set extra_params [list]

   if {[string compare -nocase $use_dyn_cfg "true"] == 0} {
      set param_table_filename_param [::altera_phylite::ip_arch_nf::ioaux_param_table::get_param_table_filename_parameter_name]
      set param_table_filename       [::altera_phylite::ip_arch_nf::ioaux_param_table::get_param_table_filename $top_level]

      set extra_params [list [list $param_table_filename_param "\"${param_table_filename}\""]]
   }

   set file_paths [concat [::altera_emif::util::hwtcl_utils::generate_top_level_sv_wrapper $top_level $top_level_mod_name $extra_params] \
                          [_generate_verilog_fileset $top_level] \
                          [_generate_common_fileset $top_level]]
   
   foreach file_path $file_paths {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
}

proc ::altera_phylite::ip_arch_nf::main::quartus_synth_fileset_callback {top_level} {
   variable top_level_mod_name

   set rtl_only 0
   set encrypted 0
   

   set use_dyn_cfg [get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION]
   set generate_sdc [get_parameter_value GENERATE_SDC_FILE]

   set extra_params [list]

   if {[string compare -nocase $use_dyn_cfg "true"] == 0} {
      set param_table_filename_param [::altera_phylite::ip_arch_nf::ioaux_param_table::get_param_table_filename_parameter_name]
      set param_table_filename       [::altera_phylite::ip_arch_nf::ioaux_param_table::get_param_table_filename $top_level]

      set extra_params [list [list $param_table_filename_param "\"${param_table_filename}\""]]
   }

   set file_paths [concat [::altera_emif::util::hwtcl_utils::generate_top_level_sv_wrapper $top_level $top_level_mod_name $extra_params] \
                          [_generate_verilog_fileset $top_level] \
                          [_generate_common_fileset $top_level]]

   if {[string compare -nocase $generate_sdc "true"] == 0} {
      set file_paths [concat $file_paths [_generate_timing_fileset $top_level]]
   }
   
   foreach file_path $file_paths {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  


}



proc ::altera_phylite::ip_arch_nf::main::_generate_common_fileset {top_level} {
   set file_list [list]

   set use_dyn_cfg [get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION]
   if {[string compare -nocase $use_dyn_cfg "true"] == 0} {
      lappend file_list {*}[altera_phylite::ip_arch_nf::ioaux_param_table::generate_ioaux_files $top_level]
   }

   return $file_list
}

proc ::altera_phylite::ip_arch_nf::main::_generate_timing_fileset {top_level} {
   set file_list [list]
   
   lappend file_list {*}[altera_phylite::ip_arch_nf::timing::generate_files $top_level]
   
   return $file_list   
}



proc ::altera_phylite::ip_arch_nf::main::_generate_verilog_fileset {top_level} {
   set file_list [list \
      rtl/phylite_c2p_conns.sv \
      rtl/phylite_core_20.sv \
      rtl/phylite_group_tile_20.sv \
      rtl/phylite_io_bufs.sv \
      rtl/pll.sv
   ]
   return $file_list
}


proc ::altera_phylite::ip_arch_nf::main::_update_qip {} {
   variable max_grps

   set qip_strings [list ]
   
   set set_inst_asgmnt "set_instance_assignment -entity \"%entityName%\" -library \"%libraryName%\""
   lappend qip_strings "${set_inst_asgmnt} -name MESSAGE_DISABLE 10034"
   lappend qip_strings "${set_inst_asgmnt} -name MESSAGE_DISABLE 10230"
   lappend qip_strings "${set_inst_asgmnt} -name MESSAGE_DISABLE 10036"
   
   set num_grps        [get_parameter_value PHYLITE_NUM_GROUPS     ]
   set io_std          [get_parameter_value GUI_PHYLITE_IO_STD_ENUM]
 
   if { [string compare -nocase $io_std "PHYLITE_IO_STD_NONE"] != 0 } {
      set io_std_qsf      [enum_data ${io_std} QSF_NAME               ]
      set io_std_diff     [enum_data ${io_std} DF_IO_STD              ]
      set io_std_diff_qsf [enum_data ${io_std_diff} QSF_NAME          ]

      if { ${num_grps} <= ${max_grps} } {

         for { set i 0 } { $i < ${num_grps} } { incr i } {
            set pin_type        [get_parameter_value  "GROUP_${i}_PIN_TYPE"                  ]
            set pin_width       [get_parameter_value  "GROUP_${i}_PIN_WIDTH"                 ]
            set use_sep_strobes [get_parameter_value  "GROUP_${i}_USE_SEPARATE_STROBES"      ]
            set data_cfg        [get_parameter_value  "GROUP_${i}_DATA_CONFIG"               ]
            set strb_cfg        [get_parameter_value  "GROUP_${i}_STROBE_CONFIG"             ]
            set in_oct          [get_parameter_value  "GROUP_${i}_IN_OCT_ENUM"               ]
            set out_oct         [get_parameter_value  "GROUP_${i}_OUT_OCT_ENUM"              ]
 
            set in_oct_qsf      [enum_data $in_oct  QSF_NAME]
            set out_oct_qsf     [enum_data $out_oct QSF_NAME]

            set grp_prefix     "group_${i}"
            set data_pin       "${grp_prefix}_data_io"
            set strobe_pin     "${grp_prefix}_strobe_io"
            set strobe_pin_sep ""
 
            if {[string compare -nocase $pin_type "OUTPUT"] == 0} {
               set data_pin   "${grp_prefix}_data_out"
               set strobe_pin "${grp_prefix}_strobe_out"
            } elseif {[string compare -nocase $pin_type "INPUT"] == 0} {
               set data_pin   "${grp_prefix}_data_in"
               set strobe_pin "${grp_prefix}_strobe_in"
            } elseif { [string compare -nocase $use_sep_strobes "true"] == 0 } {
               set strobe_pin     "${grp_prefix}_strobe_in"
               set strobe_pin_sep "${grp_prefix}_strobe_out"
            }

            lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_qsf}\" -to \"ref_clk\""
 
            set num_strobes [::altera_phylite::ip_top::group::get_num_strobes_in_grp $i]
            set total_pins [expr ${pin_width}+${num_strobes}]
	    
	    if { $total_pins <= 48 } {
		    for { set pin 0 } { $pin < $pin_width } { incr pin } {
			    if { [string compare -nocase $data_cfg "SGL_ENDED"] == 0 } {
				    lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_qsf}\" -to \"${data_pin}\[${pin}\]\""
			    } else {
				    lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_diff_qsf}\" -to \"${data_pin}\[${pin}\]\""
				    lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_diff_qsf}\" -to \"${data_pin}_n\[${pin}\]\""
			    }
			    
			    if { [expr [string compare -nocase $pin_type "INPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0] } {
				    lappend qip_strings "${set_inst_asgmnt} -name INPUT_TERMINATION \"${in_oct_qsf}\" -to \"${data_pin}\[${pin}\]\""
			    }
			    if { [expr [string compare -nocase $pin_type "OUTPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0] } {
				    lappend qip_strings "${set_inst_asgmnt} -name OUTPUT_TERMINATION \"${out_oct_qsf}\" -to \"${data_pin}\[${pin}\]\""
			    }

			    if { [string compare -nocase $data_cfg "DIFF"] == 0 } {
				    if { [expr [string compare -nocase $pin_type "INPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0] } {
					    lappend qip_strings "${set_inst_asgmnt} -name INPUT_TERMINATION \"${in_oct_qsf}\" -to \"${data_pin}_n\[${pin}\]\""
				    }
				    if { [expr [string compare -nocase $pin_type "OUTPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0] } {
					    lappend qip_strings "${set_inst_asgmnt} -name OUTPUT_TERMINATION \"${out_oct_qsf}\" -to \"${data_pin}_n\[${pin}\]\""
				    }
			    }
		    }
	    }
	    
            if { [string compare -nocase $strb_cfg "SINGLE_ENDED"] == 0 } {
               lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_qsf}\" -to \"${strobe_pin}\""
               if { [string compare -nocase $use_sep_strobes "true"] == 0 } {
                  lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_qsf}\" -to \"${strobe_pin_sep}\""
               }
            } elseif { [string compare -nocase $strb_cfg "COMPLEMENTARY"] == 0 } {
	       set out_strb_io_std_qsf ${io_std_qsf}
	       if {[string compare -nocase $pin_type "OUTPUT"] == 0} {
	          set out_strb_io_std_qsf ${io_std_diff_qsf}
	       }
               lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${out_strb_io_std_qsf}\" -to \"${strobe_pin}\""
               lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${out_strb_io_std_qsf}\" -to \"${strobe_pin}_n\""
               if { [string compare -nocase $use_sep_strobes "true"] == 0 } {
                  lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_diff_qsf}\" -to \"${strobe_pin_sep}\""
                  lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_diff_qsf}\" -to \"${strobe_pin_sep}_n\""
               }
            } else {
               lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_diff_qsf}\" -to \"${strobe_pin}\""
               lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_diff_qsf}\" -to \"${strobe_pin}_n\""
               if { [string compare -nocase $use_sep_strobes "true"] == 0 } {
                  lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_diff_qsf}\" -to \"${strobe_pin_sep}\""
                  lappend qip_strings "${set_inst_asgmnt} -name IO_STANDARD \"${io_std_diff_qsf}\" -to \"${strobe_pin_sep}_n\""
               }
            }   

            if { [expr [string compare -nocase $pin_type "INPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0] } {
               lappend qip_strings "${set_inst_asgmnt} -name INPUT_TERMINATION \"${in_oct_qsf}\" -to \"${strobe_pin}\""
               if { [expr [string compare -nocase $strb_cfg "COMPLEMENTARY"] == 0 || [string compare -nocase $strb_cfg "DIFFERENTIAL"] == 0] } {
                  lappend qip_strings "${set_inst_asgmnt} -name INPUT_TERMINATION \"${in_oct_qsf}\" -to \"${strobe_pin}_n\""
               }
            }
            if { [expr [string compare -nocase $pin_type "OUTPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0] } {
               lappend qip_strings "${set_inst_asgmnt} -name OUTPUT_TERMINATION \"${out_oct_qsf}\" -to \"${strobe_pin}\""
               if { [expr [string compare -nocase $strb_cfg "COMPLEMENTARY"] == 0 || [string compare -nocase $strb_cfg "DIFFERENTIAL"] == 0] } {
                  lappend qip_strings "${set_inst_asgmnt} -name OUTPUT_TERMINATION \"${out_oct_qsf}\" -to \"${strobe_pin}_n\""
               }
            }	    

         }
      }
   }
   
   set_qip_strings $qip_strings
}

proc ::altera_phylite::ip_arch_nf::main::_elaborate_interfaces {} {
   variable max_grps
   set num_grps    [get_parameter_value PHYLITE_NUM_GROUPS]

   _elaborate_clk_rst_interface

   _elaborate_avl_interface

   for { set i 0 } { $i < ${max_grps} } {incr i } {
      _elaborate_grp_interface $i [expr $i < ${num_grps}]
   }

   _elaborate_dft_interface
}

proc ::altera_phylite::ip_arch_nf::main::_elaborate_clk_rst_interface {} {
   add_interface ref_clk_clock_sink clock sink
   set_interface_property ref_clk_clock_sink ENABLED true
   add_interface_port ref_clk_clock_sink ref_clk clk Input 1
 
   add_interface reset_reset_sink reset sink
   set_interface_property reset_reset_sink ENABLED true
   set_interface_property reset_reset_sink synchronousEdges NONE
   add_interface_port reset_reset_sink reset_n reset_n Input 1
 
   add_interface lock_conduit_end conduit end
   set_interface_property lock_conduit_end ENABLED true
   add_interface_port lock_conduit_end interface_locked locked Output 1
 
   add_interface core_clk_conduit_end conduit end
   set_interface_property core_clk_conduit_end ENABLED true
   add_interface_port core_clk_conduit_end core_clk_out core_clk Output 1
}

proc ::altera_phylite::ip_arch_nf::main::_elaborate_avl_interface {} {
   set use_dyn_cfg [get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION]

   add_interface avalon_interface_conduit_end conduit end
   set_interface_property avalon_interface_conduit_end ENABLED true
   add_interface_port avalon_interface_conduit_end avl_clk            avl_clk            Input   1
   add_interface_port avalon_interface_conduit_end avl_reset_n        avl_reset_n        Input   1
   add_interface_port avalon_interface_conduit_end avl_read           avl_read           Input   1
   add_interface_port avalon_interface_conduit_end avl_write          avl_write          Input   1
   add_interface_port avalon_interface_conduit_end avl_byteenable     avl_byteenable     Input   4
   set_port_property avl_byteenable VHDL_TYPE std_logic_vector
   add_interface_port avalon_interface_conduit_end avl_writedata      avl_writedata      Input  32
   set_port_property avl_writedata VHDL_TYPE std_logic_vector
   add_interface_port avalon_interface_conduit_end avl_address        avl_address        Input  28
   set_port_property avl_address VHDL_TYPE std_logic_vector
   add_interface_port avalon_interface_conduit_end avl_readdata       avl_readdata       Output 32
   set_port_property avl_readdata VHDL_TYPE std_logic_vector
   add_interface_port avalon_interface_conduit_end avl_readdata_valid avl_readdata_valid Output 1
   add_interface_port avalon_interface_conduit_end avl_waitrequest    avl_waitrequest    Output 1

   add_interface avalon_out_interface_conduit_end conduit end
   set_interface_property avalon_out_interface_conduit_end ENABLED true
   add_interface_port avalon_out_interface_conduit_end avl_out_clk            avl_out_clk            Output   1
   add_interface_port avalon_out_interface_conduit_end avl_out_reset_n        avl_out_reset_n        Output   1
   add_interface_port avalon_out_interface_conduit_end avl_out_read           avl_out_read           Output   1
   add_interface_port avalon_out_interface_conduit_end avl_out_write          avl_out_write          Output   1
   add_interface_port avalon_out_interface_conduit_end avl_out_byteenable     avl_out_byteenable     Output   4
   set_port_property avl_out_byteenable VHDL_TYPE std_logic_vector
   add_interface_port avalon_out_interface_conduit_end avl_out_writedata      avl_out_writedata      Output  32
   set_port_property avl_out_writedata VHDL_TYPE std_logic_vector
   add_interface_port avalon_out_interface_conduit_end avl_out_address        avl_out_address        Output  28
   set_port_property avl_out_address VHDL_TYPE std_logic_vector
   add_interface_port avalon_out_interface_conduit_end avl_out_readdata       avl_out_readdata       Input   32
   set_port_property avl_out_readdata VHDL_TYPE std_logic_vector
   add_interface_port avalon_out_interface_conduit_end avl_out_readdata_valid avl_out_readdata_valid Input    1
   add_interface_port avalon_out_interface_conduit_end avl_out_waitrequest    avl_out_waitrequest    Input    1

   if {[string compare -nocase $use_dyn_cfg "false"] == 0} {

      set_port_property avl_clk            TERMINATION true
      set_port_property avl_reset_n        TERMINATION true
      set_port_property avl_read           TERMINATION true
      set_port_property avl_write          TERMINATION true
      set_port_property avl_byteenable     TERMINATION true
      set_port_property avl_writedata      TERMINATION true
      set_port_property avl_address        TERMINATION true
      set_port_property avl_readdata       TERMINATION true
      set_port_property avl_readdata_valid TERMINATION true
      set_port_property avl_waitrequest    TERMINATION true

      set_port_property avl_out_clk            TERMINATION true
      set_port_property avl_out_reset_n        TERMINATION true
      set_port_property avl_out_read           TERMINATION true
      set_port_property avl_out_write          TERMINATION true
      set_port_property avl_out_byteenable     TERMINATION true
      set_port_property avl_out_writedata      TERMINATION true
      set_port_property avl_out_address        TERMINATION true
      set_port_property avl_out_readdata       TERMINATION true
      set_port_property avl_out_readdata_valid TERMINATION true
      set_port_property avl_out_waitrequest    TERMINATION true
   }
}

proc ::altera_phylite::ip_arch_nf::main::_elaborate_grp_interface {grp_idx elaborate_grp} {
   set rate                 [get_parameter_value "PHYLITE_RATE_ENUM"                    ]
   set pin_type             [get_parameter_value "GROUP_${grp_idx}_PIN_TYPE"            ]
   set pin_width            [get_parameter_value "GROUP_${grp_idx}_PIN_WIDTH"           ]
   set ddr_mode             [get_parameter_value "GROUP_${grp_idx}_DDR_SDR_MODE"        ]
   set use_out_strobe       [get_parameter_value "GROUP_${grp_idx}_USE_OUTPUT_STROBE"   ]
   set use_separate_strobes [get_parameter_value "GROUP_${grp_idx}_USE_SEPARATE_STROBES"]
   set data_config	    [get_parameter_value "GROUP_${grp_idx}_DATA_CONFIG"]

   if {$pin_width < 1} {
      set pin_width 1
   }
 
   set ddr_mult 1
   if {[string compare -nocase $ddr_mode "DDR"] == 0} {
      set ddr_mult 2
   }
   
   set num_strobes [::altera_phylite::ip_top::group::get_num_strobes_in_grp ${grp_idx}]
   
   set oe_width_mult 4
   set data_width_mult 4*$ddr_mult
   set strobe_width 8
   
   if {[string compare -nocase $rate "RATE_IN_HALF"] == 0} {
      set data_width_mult 2*$ddr_mult
      set strobe_width 4
      set oe_width_mult 2
   } elseif {[string compare -nocase $rate "RATE_IN_FULL"] == 0} {
      set data_width_mult $ddr_mult
      set strobe_width 2
      set oe_width_mult 1
   }

   set core_interface "group_${grp_idx}_core_interface_conduit_end"
   add_interface $core_interface conduit end
   set_interface_property $core_interface ENABLED true
 
   add_interface_port $core_interface group_${grp_idx}_oe_from_core   data_oe  Input $oe_width_mult*$pin_width
   set_port_property group_${grp_idx}_oe_from_core VHDL_TYPE std_logic_vector
   add_interface_port $core_interface group_${grp_idx}_data_from_core data_out Input $data_width_mult*$pin_width
   set_port_property group_${grp_idx}_data_from_core VHDL_TYPE std_logic_vector
   add_interface_port $core_interface group_${grp_idx}_strobe_out_in strobe_out Input $strobe_width
   set_port_property group_${grp_idx}_strobe_out_in VHDL_TYPE std_logic_vector
   add_interface_port $core_interface group_${grp_idx}_strobe_out_en strobe_oe  Input $oe_width_mult
   set_port_property group_${grp_idx}_strobe_out_en VHDL_TYPE std_logic_vector
   add_interface_port $core_interface group_${grp_idx}_data_to_core   data_in  Output $data_width_mult*$pin_width
   set_port_property group_${grp_idx}_data_to_core VHDL_TYPE std_logic_vector
   add_interface_port $core_interface group_${grp_idx}_rdata_en       read_en  Input  $oe_width_mult
   set_port_property group_${grp_idx}_rdata_en VHDL_TYPE std_logic_vector
   add_interface_port $core_interface group_${grp_idx}_rdata_valid    data_vld Output $oe_width_mult
   set_port_property group_${grp_idx}_rdata_valid VHDL_TYPE std_logic_vector
 
   set io_interface "group_${grp_idx}_io_interface_conduit_end"
   add_interface $io_interface conduit end
   set_interface_property $io_interface ENABLED true

   add_interface_port $io_interface group_${grp_idx}_data_out io_data_out Output $pin_width
   set_port_property group_${grp_idx}_data_out VHDL_TYPE std_logic_vector
   add_interface_port $io_interface group_${grp_idx}_data_out_n io_data_out_n Output $pin_width
   set_port_property group_${grp_idx}_data_out_n VHDL_TYPE std_logic_vector
   add_interface_port $io_interface group_${grp_idx}_strobe_out io_strobe_out Output 1
   add_interface_port $io_interface group_${grp_idx}_strobe_out_n io_strobe_out_n Output 1
   add_interface_port $io_interface group_${grp_idx}_data_in io_data_in Input $pin_width
   set_port_property group_${grp_idx}_data_in VHDL_TYPE std_logic_vector
   add_interface_port $io_interface group_${grp_idx}_data_in_n io_data_in_n Input $pin_width
   set_port_property group_${grp_idx}_data_in_n VHDL_TYPE std_logic_vector
   add_interface_port $io_interface group_${grp_idx}_strobe_in io_strobe_in Input 1
   add_interface_port $io_interface group_${grp_idx}_strobe_in_n io_strobe_in_n Input 1
   add_interface_port $io_interface group_${grp_idx}_data_io io_data_io Bidir $pin_width
   set_port_property group_${grp_idx}_data_io VHDL_TYPE std_logic_vector
   add_interface_port $io_interface group_${grp_idx}_data_io_n io_data_io_n Bidir $pin_width
   set_port_property group_${grp_idx}_data_io_n VHDL_TYPE std_logic_vector
   add_interface_port $io_interface group_${grp_idx}_strobe_io io_strobe_io Bidir 1
   add_interface_port $io_interface group_${grp_idx}_strobe_io_n io_strobe_io_n Bidir 1
 
   if { ${elaborate_grp} == 1 } {
      if {![expr [string compare -nocase $pin_type "OUTPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0]} {
         set_port_property group_${grp_idx}_oe_from_core   TERMINATION true
         set_port_property group_${grp_idx}_data_from_core TERMINATION true
         set_port_property group_${grp_idx}_strobe_out_in  TERMINATION true
         set_port_property group_${grp_idx}_strobe_out_en  TERMINATION true
      } elseif {[string compare -nocase $use_out_strobe "false"] == 0} {
         set_port_property group_${grp_idx}_strobe_out_in TERMINATION true
         set_port_property group_${grp_idx}_strobe_out_en TERMINATION true
      }
 
      if {![expr [string compare -nocase $pin_type "INPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0]} {
         set_port_property group_${grp_idx}_data_to_core TERMINATION true
         set_port_property group_${grp_idx}_rdata_en     TERMINATION true
         set_port_property group_${grp_idx}_rdata_valid  TERMINATION true
      }

      if {[string compare -nocase $pin_type "OUTPUT"] == 0} {
         set_port_property group_${grp_idx}_data_in  	TERMINATION true
         set_port_property group_${grp_idx}_data_io  	TERMINATION true
         set_port_property group_${grp_idx}_data_in_n	TERMINATION true
         set_port_property group_${grp_idx}_data_io_n	TERMINATION true
 
	 if { [string compare -nocase $data_config "SGL_ENDED"] == 0 } {
		 set_port_property group_${grp_idx}_data_out_n	TERMINATION true	
  	 }

	 set_port_property group_${grp_idx}_strobe_in    TERMINATION true
         set_port_property group_${grp_idx}_strobe_in_n  TERMINATION true
         set_port_property group_${grp_idx}_strobe_io    TERMINATION true
         set_port_property group_${grp_idx}_strobe_io_n  TERMINATION true

         if {$num_strobes == 0} {
            set_port_property group_${grp_idx}_strobe_out   TERMINATION true
            set_port_property group_${grp_idx}_strobe_out_n TERMINATION true
         }
         if {$num_strobes == 1} {
            set_port_property group_${grp_idx}_strobe_out_n TERMINATION true
         }
      } elseif {[string compare -nocase $pin_type "INPUT"] == 0} {
         set_port_property group_${grp_idx}_data_out 	TERMINATION true
         set_port_property group_${grp_idx}_data_io  	TERMINATION true
         set_port_property group_${grp_idx}_data_out_n 	TERMINATION true
         set_port_property group_${grp_idx}_data_io_n	TERMINATION true
 
	 if { [string compare -nocase $data_config "SGL_ENDED"] == 0 } {
		 set_port_property group_${grp_idx}_data_in_n	TERMINATION true	
  	 }

	 set_port_property group_${grp_idx}_strobe_out   TERMINATION true
         set_port_property group_${grp_idx}_strobe_out_n TERMINATION true
         set_port_property group_${grp_idx}_strobe_io    TERMINATION true
         set_port_property group_${grp_idx}_strobe_io_n  TERMINATION true

         if {$num_strobes == 0} {
            set_port_property group_${grp_idx}_strobe_in   TERMINATION true
            set_port_property group_${grp_idx}_strobe_in_n TERMINATION true
         }
         if {$num_strobes == 1} {
            set_port_property group_${grp_idx}_strobe_in_n TERMINATION true
         }
      } else { 
         set_port_property group_${grp_idx}_data_out 	TERMINATION true
         set_port_property group_${grp_idx}_data_in  	TERMINATION true
	 set_port_property group_${grp_idx}_data_out_n 	TERMINATION true
         set_port_property group_${grp_idx}_data_in_n  	TERMINATION true

	 if { [string compare -nocase $data_config "SGL_ENDED"] == 0 } {
		 set_port_property group_${grp_idx}_data_io_n	TERMINATION true	
  	 }

         if { [string compare -nocase $use_separate_strobes "true"] == 0 } {
            set_port_property group_${grp_idx}_strobe_io    TERMINATION true
            set_port_property group_${grp_idx}_strobe_io_n  TERMINATION true

            if {$num_strobes == 2} {
               set_port_property group_${grp_idx}_strobe_out_n TERMINATION true
               set_port_property group_${grp_idx}_strobe_in_n  TERMINATION true
            }
         } else {
            set_port_property group_${grp_idx}_strobe_out   TERMINATION true
            set_port_property group_${grp_idx}_strobe_out_n TERMINATION true
            set_port_property group_${grp_idx}_strobe_in    TERMINATION true
            set_port_property group_${grp_idx}_strobe_in_n  TERMINATION true

            if {$num_strobes == 0} {
               set_port_property group_${grp_idx}_strobe_io   TERMINATION true
               set_port_property group_${grp_idx}_strobe_io_n TERMINATION true
            }
            if {$num_strobes == 1} {
               set_port_property group_${grp_idx}_strobe_io_n TERMINATION true
            }
         }
      }
   } else {
      set_port_property group_${grp_idx}_oe_from_core   TERMINATION true
      set_port_property group_${grp_idx}_data_from_core TERMINATION true
      set_port_property group_${grp_idx}_strobe_out_in  TERMINATION true
      set_port_property group_${grp_idx}_strobe_out_en  TERMINATION true
      set_port_property group_${grp_idx}_data_to_core   TERMINATION true
      set_port_property group_${grp_idx}_rdata_en       TERMINATION true
      set_port_property group_${grp_idx}_rdata_valid    TERMINATION true

      set_port_property group_${grp_idx}_data_out     TERMINATION true
      set_port_property group_${grp_idx}_data_out_n   TERMINATION true
      set_port_property group_${grp_idx}_strobe_out   TERMINATION true
      set_port_property group_${grp_idx}_strobe_out_n TERMINATION true
      set_port_property group_${grp_idx}_data_in      TERMINATION true
      set_port_property group_${grp_idx}_data_in_n    TERMINATION true
      set_port_property group_${grp_idx}_strobe_in    TERMINATION true
      set_port_property group_${grp_idx}_strobe_in_n  TERMINATION true
      set_port_property group_${grp_idx}_data_io      TERMINATION true
      set_port_property group_${grp_idx}_data_io_n    TERMINATION true
      set_port_property group_${grp_idx}_strobe_io    TERMINATION true
      set_port_property group_${grp_idx}_strobe_io_n  TERMINATION true
   }
}

proc ::altera_phylite::ip_arch_nf::main::_elaborate_dft_interface {} {
   set use_dft [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_enable_dft_interface"]

   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]

   add_interface dft_conduit_end conduit end
   set_interface_property dft_conduit_end ENABLED true
   add_interface_port dft_conduit_end core_to_dft core_to_dft Input  [expr (3*4*${num_grps})+21]
   set_port_property core_to_dft VHDL_TYPE std_logic_vector
   add_interface_port dft_conduit_end dft_to_core dft_to_core Output [expr (15*4*${num_grps})+9]
   set_port_property dft_to_core VHDL_TYPE std_logic_vector

   if { $use_dft == 0 } {
      set_port_property core_to_dft TERMINATION true
      set_port_property dft_to_core TERMINATION true
   }
}

proc ::altera_phylite::ip_arch_nf::main::get_legal_read_latencies {} {
   set rate               [get_parameter_value "PHYLITE_RATE_ENUM"]
   set mem_clk_freq_mhz [get_parameter_value PHYLITE_MEM_CLK_FREQ_MHZ]
   set vco_ratio [altera_phylite::ip_arch_nf::pll::get_pll_vco_to_mem_clk_freq_ratio ]

   set max 63
   set min 1
   if { $vco_ratio == 1 } {
      if {[string compare -nocase $rate "RATE_IN_QUARTER"] == 0} {
         set min 7
      } elseif {[string compare -nocase $rate "RATE_IN_HALF"] == 0} {
         set min 5
      } else {
         set min 4
      }
   } elseif { $vco_ratio == 2 } {
      if {[string compare -nocase $rate "RATE_IN_QUARTER"] == 0} {
         set min 7
      } elseif {[string compare -nocase $rate "RATE_IN_HALF"] == 0} {
         set min 5
      } else {
         set min 4
      }
   } elseif { $vco_ratio == 4 } {
      if {[string compare -nocase $rate "RATE_IN_QUARTER"] == 0} {
         set min 7
      } elseif {[string compare -nocase $rate "RATE_IN_HALF"] == 0} {
         set min 4
      } else {
         set min 3
      }
   } else {
      if {[string compare -nocase $rate "RATE_IN_QUARTER"] == 0} {
         set min 7
      } elseif {[string compare -nocase $rate "RATE_IN_HALF"] == 0} {
         set min 4
      } else {
         set min 3
      }
   }

   return "${min}:${max}"
}

proc ::altera_phylite::ip_arch_nf::main::get_legal_write_latencies {} {

   set data_rate [get_parameter_value "PHYLITE_RATE_ENUM"]
   set mem_clk_freq_mhz [get_parameter_value PHYLITE_MEM_CLK_FREQ_MHZ]
   set vco_ratio [altera_phylite::ip_arch_nf::pll::get_pll_vco_to_mem_clk_freq_ratio ]

   set max 3
   set min 0
   if {[string compare -nocase $data_rate "RATE_IN_QUARTER"] == 0} {
      if { $vco_ratio == 8 } {
         set max 2
      } else {
         set max 3
      }
   } elseif {[string compare -nocase $data_rate "RATE_IN_HALF"] == 0} {
      set max 1
   } else {
      set max 0
   }

   return "${min}:${max}"
}

proc ::altera_phylite::ip_arch_nf::main::get_max_num_groups {} {
   variable max_grps

   return $max_grps
}

proc ::altera_phylite::ip_arch_nf::main::_init {} {
}

::altera_phylite::ip_arch_nf::main::_init
