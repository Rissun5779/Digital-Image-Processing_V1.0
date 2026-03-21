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


package provide altera_phylite::ip_arch_nf::timing 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_phylite::util::enum_defs
package require altera_emif::util::enum_defs_interfaces
package require altera_emif::util::enum_defs_family_traits_and_features
package require altera_emif::util::device_family

package require altera_phylite::ip_arch_nf::enum_defs_timing_params
package require altera_emif::ip_arch_nf::util


namespace eval ::altera_phylite::ip_arch_nf::timing:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_arch_nf::util::*


}


proc ::altera_phylite::ip_arch_nf::timing::generate_files {top_level} {

   set module $top_level
   set ofile_prefix $top_level
   
   set file_list [list \
      [_generate_from_template $module timing/memphy_report_timing_core.tcl $ofile_prefix] \
      [_generate_from_template $module timing/memphy_report_timing.tcl $ofile_prefix] \
      [_generate_from_template $module timing/memphy_parameters.tcl $ofile_prefix] \
      [_generate_ip_params_tcl $module timing/memphy_ip_parameters.tcl $ofile_prefix] \
      [_generate_from_template $module timing/memphy_pin_map.tcl $ofile_prefix] \
      [_generate_from_template $module timing/memphy.sdc $ofile_prefix]]

   return $file_list
}


proc ::altera_phylite::ip_arch_nf::timing::_generate_ip_params_tcl {module ifile_name ofile_prefix} {

   set tmp [file split $ifile_name]
   set ofile_name [lindex $tmp end]
   set ofile_name [string map "memphy $ofile_prefix" $ofile_name]
   set ofile_name [create_temp_file $ofile_name]
   
   set ifh [open $ifile_name r]
   set ofh [open $ofile_name w] 
   
   while {[gets $ifh line] != -1} {
      puts $ofh $line
   }
   
   puts $ofh "set ::GLOBAL_${module}_corename $module"
   
   puts $ofh ""
   
   puts $ofh ""
   foreach tparam_hwtcl_enum [enums_of_type TPARAM_HWTCL] {
      set param_name [enum_data $tparam_hwtcl_enum HWTCL_PARAM]
      set val [get_parameter_value $param_name]
      if {[string first " " $val] != -1} {
         set val "\"${val}\""
      }
      puts $ofh "set [format "%-60s" "var(${tparam_hwtcl_enum})"] $val"
   }
   foreach tparam_hwtcl_enum [enums_of_type TPARAM_HWTCL_ENUM] {
      set param_name [enum_data $tparam_hwtcl_enum HWTCL_PARAM]
      set enum_name [enum_data $tparam_hwtcl_enum ENUM]
      set val [enum_data [get_parameter_value $param_name] $enum_name]
      if {[string first " " $val] != -1} {
         set val "\"${val}\""
      }
      puts $ofh "set [format "%-60s" "var(${tparam_hwtcl_enum})"] $val"
   }
   for {set igroup 0} {$igroup < [get_parameter_value PHYLITE_NUM_GROUPS]} {incr igroup} {
      foreach tparam_hwtcl_enum [enums_of_type TPARAM_HWTCL_GROUP] {
         set param_name "GROUP_${igroup}_[enum_data $tparam_hwtcl_enum HWTCL_PARAM]"
         set val [get_parameter_value $param_name] 
         if {[string first " " $val] != -1} {
            set val "\"${val}\""
         }
         puts $ofh "set [format "%-60s" "var(${param_name})"] $val"
      }
   }
   

   set family_enum [get_device_family_enum]
   set base_family_enum [enum_data $family_enum BASE_FAMILY_ENUM]

   if {[string compare $base_family_enum "FAMILY_ARRIA10"] == 0} {

      if {[ini_is_on "a10_iopll_es_fix"]} {
         puts $ofh "set var(ATB_USED) 1"
      } else {
         puts $ofh "set var(ATB_USED) 0"
      }
   }   

   puts $ofh ""
   set patterns [_get_hpath_patterns_to_buffers]
   foreach name [dict keys $patterns] {
      set var_name [string toupper $name]
      set val [join [dict get $patterns $name] " \\\n[string repeat " " 71]"]
      puts $ofh "set [format "%-60s" "var($var_name)"] \[list $val\]"
   }
   
   puts $ofh ""
   puts $ofh {initialize_emiftcl -protocol [choose_protocol [lindex $var(PLL_MEM_CLK_FREQ_PS_STR) 0]]}
   puts $ofh {set var(UI)  [expr [lindex $var(PLL_MEM_CLK_FREQ_PS_STR) 0]/1000.0]}


   
   close $ifh
   close $ofh
   
   return $ofile_name
}

proc ::altera_phylite::ip_arch_nf::timing::_get_hpath_patterns_to_buffers {} {

  
   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]

   set result_dict [dict create]

   for { set i_grp_idx 0 } { $i_grp_idx < $num_grps } { incr i_grp_idx} {
      set rclk      [list]   
      set rclk_n    [list]   
      set wclk      [list]   
      set wclk_n    [list]   
      set rdata     [list]   
      set wdata     [list]   

      set i_pin_type             [get_parameter_value "GROUP_${i_grp_idx}_PIN_TYPE"            ]
      set i_pin_width            [get_parameter_value "GROUP_${i_grp_idx}_PIN_WIDTH"           ]
      set i_ddr_mode             [get_parameter_value "GROUP_${i_grp_idx}_DDR_SDR_MODE"        ]
      set i_use_out_strobe       [get_parameter_value "GROUP_${i_grp_idx}_USE_OUTPUT_STROBE"   ]
      set i_use_separate_strobes [get_parameter_value "GROUP_${i_grp_idx}_USE_SEPARATE_STROBES"]
      set i_strobe_config        [get_parameter_value "GROUP_${i_grp_idx}_STROBE_CONFIG"       ]
      set i_data_config          [get_parameter_value "GROUP_${i_grp_idx}_DATA_CONFIG"       ]
      
      if {$i_pin_type == "INPUT" || $i_pin_type == "BIDIR"} {
         if {$i_strobe_config == "SINGLE_ENDED"} {
            lappend rclk "core|arch_inst|u_phylite_io_bufs|strobe_io_buf_gen\[${i_grp_idx}\].u_twentynm_io_ibuf|i"
         } elseif {$i_strobe_config == "DIFFERENTIAL"} {
            lappend rclk "core|arch_inst|u_phylite_io_bufs|strobe_io_buf_gen\[${i_grp_idx}\].u_strobe_ibuf|i"
         } elseif {$i_strobe_config == "COMPLEMENTARY"} {
            lappend rclk "core|arch_inst|u_phylite_io_bufs|strobe_io_buf_gen\[${i_grp_idx}\].u_strobe_ibuf|i"
            lappend rclk_n "core|arch_inst|u_phylite_io_bufs|strobe_io_buf_gen\[${i_grp_idx}\].u_strobe_n_ibuf|i"
         }

         for { set i_pin_idx 0 } { $i_pin_idx < $i_pin_width } { incr i_pin_idx } {
            if {$i_data_config == "SGL_ENDED"} {
               lappend rdata "core|arch_inst|u_phylite_io_bufs|data_io_buf_gen_grp\[${i_grp_idx}\].data_io_ibuf_gen\[${i_pin_idx}\].u_twentynm_io_ibuf|i"
            } else {
               lappend rdata "core|arch_inst|u_phylite_io_bufs|data_io_buf_gen_grp\[${i_grp_idx}\].data_io_ibuf_gen\[${i_pin_idx}\].u_data_ibuf|i"
            }
         }
      }
      if {$i_pin_type == "OUTPUT" || $i_pin_type == "BIDIR"} {

         if {$i_use_out_strobe == "true"} {
            lappend wclk "core|arch_inst|u_phylite_io_bufs|strobe_io_buf_gen\[${i_grp_idx}\].u_strobe_obuf|o"
            if {$i_strobe_config == "COMPLEMENTARY"} {
               lappend wclk_n "core|arch_inst|u_phylite_io_bufs|strobe_io_buf_gen\[${i_grp_idx}\].u_strobe_n_obuf|o"
            }
         }

         for { set i_pin_idx 0 } { $i_pin_idx < $i_pin_width } { incr i_pin_idx } {
            if {$i_data_config == "SGL_ENDED"} {
               lappend wdata "core|arch_inst|u_phylite_io_bufs|data_io_buf_gen_grp\[${i_grp_idx}\].data_io_obuf_gen\[${i_pin_idx}\].u_data_buf|o"
            } else {
               lappend wdata "core|arch_inst|u_phylite_io_bufs|data_io_buf_gen_grp\[${i_grp_idx}\].data_io_diff_obuf_gen\[${i_pin_idx}\].u_data_obuf|o"
               lappend wdata "core|arch_inst|u_phylite_io_bufs|data_io_buf_gen_grp\[${i_grp_idx}\].data_io_diff_obuf_gen\[${i_pin_idx}\].u_data_n_obuf|o"
            }
         }
      }
      dict append result_dict patterns_rclk,$i_grp_idx      $rclk 
      dict append result_dict patterns_rclk_n,$i_grp_idx    $rclk_n 
      dict append result_dict patterns_wclk,$i_grp_idx      $wclk 
      dict append result_dict patterns_wclk_n,$i_grp_idx    $wclk_n 
      dict append result_dict patterns_rdata,$i_grp_idx     $rdata 
      dict append result_dict patterns_wdata,$i_grp_idx     $wdata 
   }

   return $result_dict
}

proc ::altera_phylite::ip_arch_nf::timing::_generate_from_template {module ifile_name ofile_prefix} {

   set tmp [file split $ifile_name]
   set ofile_name [lindex $tmp end]
   set ofile_name [string map "memphy $ofile_prefix" $ofile_name]
   set ofile_name [create_temp_file $ofile_name]
   
   set ifh [open $ifile_name r]
   set ofh [open $ofile_name w] 
   
   set spaces "\[ \t\n\]"
   set notspaces "\[^ \t\n\]"   
   
   while {[gets $ifh line] != -1} {
      
      if {[regexp "memphy_${notspaces}*\.tcl" $line] } {
         set line [ string map "memphy $ofile_prefix" $line ]
      } elseif {[regexp "memphy${notspaces}*\.sdc" $line] } {
         set line [ string map "memphy $ofile_prefix" $line ]
      } elseif {[regexp "^proc${spaces}+memphy_" $line] } {
         set line [ string map "memphy $module" $line ]
      } elseif {[regexp {^memphy_\w+} $line] || [regexp {[\s\t\[]memphy_\w+} $line]} {
         set line [ string map "memphy_ ${module}_" $line ] 
      } elseif {[regexp {\$memphy_\w+} $line] } {
         set line [ string map "memphy_ ${module}_" $line ] 
      }
      
      if {[regexp {::GLOBAL_} $line]} {
         set line [ string map "::GLOBAL_ ::GLOBAL_${module}_" $line ]
      } 
      
      puts $ofh $line
   }

   close $ifh
   close $ofh
   
   return $ofile_name
}

proc ::altera_phylite::ip_arch_nf::timing::_init {} {
}

::altera_phylite::ip_arch_nf::timing::_init
