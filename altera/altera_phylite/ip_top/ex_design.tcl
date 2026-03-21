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


package provide altera_phylite::ip_top::ex_design 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::device_family

namespace eval ::altera_phylite::ip_top::ex_design:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*

   
}



proc ::altera_phylite::ip_top::ex_design::example_design_fileset_callback {name} {

   set rtl_only 0
   set encrypted 0
   
   set family_enum [get_device_family_enum]
   set curr_device_name [get_parameter_value SYS_INFO_DEVICE]
   
   if { [regexp  {^[ ]*$} $curr_device_name match] != 1 && [string compare -nocase $curr_device_name "unknown"] != 0} {
      set default_device $curr_device_name
   } else {
      set default_device [enum_data $family_enum DEFAULT_PART_FOR_ED]
   }
   
   set synth_qsys_name "ed_synth"
   set synth_qsys_file "${synth_qsys_name}.qsys"
   set synth_qsys_path [_create_and_get_temp_file_path $synth_qsys_file]
   
   set sim_qsys_name   "ed_sim"
   set sim_qsys_file   "${sim_qsys_name}.qsys"
   set sim_qsys_path   [_create_and_get_temp_file_path $sim_qsys_file]
 
    if {[get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION] && [get_parameter_value PHYLITE_GENERATE_DEBUG_DESIGN]} {
        set phy_qsys_name   "phylite_debug_kit"
        set phy_qsys_file   "${phy_qsys_name}.qsys"
      set phy_qsys_path   [_create_and_get_temp_file_path $phy_qsys_file]
    
        set file "issp.tcl"
        set path "../../ip_top/ex_design/phylite_niosii_bridge/${file}"
        add_fileset_file $file OTHER PATH $path

		set file "phylite_niosii_bridge_hw.tcl"
        set path "../../ip_top/ex_design/phylite_niosii_bridge/${file}"
        add_fileset_file $file OTHER PATH $path
        
        set file "phylite_niosii_bridge.v"
        set path "../../ip_top/ex_design/phylite_niosii_bridge/${file}"
        add_fileset_file $file OTHER PATH $path

        set file "debug_kit_readme.txt"
        set path "../../ip_top/ex_design/phylite_niosii_bridge/${file}"
        add_fileset_file $file OTHER PATH $path
        set file "hello_world.c"
        set path "../../ip_top/ex_design/phylite_niosii_bridge/${file}"
        add_fileset_file $file OTHER PATH $path
        set file "phylite_dynamic_reconfiguration.c"
        set path "../../ip_top/ex_design/phylite_niosii_bridge/${file}"
        add_fileset_file $file OTHER PATH $path
        set file "phylite_dynamic_reconfiguration.h"
        set path "../../ip_top/ex_design/phylite_niosii_bridge/${file}"
        add_fileset_file $file OTHER PATH $path    
   }	
   
   set params_file "params.tcl"
   set params_path [create_temp_file $params_file]
   set fh [open $params_path "w"]    
   
   puts $fh "# This file is auto-generated."
   puts $fh "# It is used by make_qii_design.tcl and make_sim_design.tcl, and"
   puts $fh "# is not intended to be executed directly."
   puts $fh ""

   foreach param_name [get_parameters] {
      set param_val [get_parameter_value $param_name]
      puts $fh "set ip_params(${param_name}) \"${param_val}\""
   }
   
   puts $fh "set pro_edition  [_is_pro_edition]"
   puts $fh "set ed_params(PHYLITE_NAME)                 \"$name\""
   puts $fh "set ed_params(DEFAULT_DEVICE)               \"$default_device\""
   puts $fh "set ed_params(SYNTH_QSYS_NAME)              \"$synth_qsys_name\""
   puts $fh "set ed_params(SIM_QSYS_NAME)                \"$sim_qsys_name\""
   puts $fh "set ed_params(TMP_SYNTH_QSYS_PATH)          \"$synth_qsys_path\""
   puts $fh "set ed_params(TMP_SIM_QSYS_PATH)            \"$sim_qsys_path\""
   if {[get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION] && [get_parameter_value PHYLITE_GENERATE_DEBUG_DESIGN]} {
	   puts $fh "set ed_params(TMP_PHY_NIOS_QSYS_PATH)   \"$phy_qsys_path\""
   }
    close $fh
   
   add_fileset_file $params_file [::altera_emif::util::hwtcl_utils::get_file_type $params_file $rtl_only $encrypted] PATH $params_path

   set qsys_script_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
   set platform [lindex $::tcl_platform(platform) 0]
   
   if {[_is_pro_edition]} {
      set pro_string "--pro"
   } else {
      set pro_string ""
   }
   
   if { $platform == "windows" } {
      set cmd [concat [list exec $qsys_script_exe_path $pro_string --quartus-project=none --cmd="source $params_path" --script=../../ip_top/ex_design/make_qsys.tcl --search-path=../../ip_top/ex_design/phylite_niosii_bridge,\$]]
   } else {
      set cmd [concat [list exec $qsys_script_exe_path $pro_string --quartus-project=none --cmd='source $params_path' --script=../../ip_top/ex_design/make_qsys.tcl --search-path=../../ip_top/ex_design/phylite_niosii_bridge,\$]]
   }

   set cmd_fail [catch { eval $cmd } tempresult]
   add_fileset_file $synth_qsys_file [::altera_emif::util::hwtcl_utils::get_file_type $synth_qsys_file $rtl_only $encrypted] PATH $synth_qsys_path
   add_fileset_file $sim_qsys_file   [::altera_emif::util::hwtcl_utils::get_file_type $sim_qsys_file $rtl_only $encrypted]   PATH $sim_qsys_path
    if {[get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION] && [get_parameter_value PHYLITE_GENERATE_DEBUG_DESIGN]} {
        add_fileset_file $phy_qsys_file OTHER PATH $phy_qsys_path
    }   

   if {[_is_pro_edition]} {
      set tmp_dir_path [create_temp_file ""]
      set ip_files [_ls_recursive "${tmp_dir_path}" "*.ip"]
      
      foreach path $ip_files {
         set file [_get_relative_path $tmp_dir_path $path]
         add_fileset_file $file OTHER PATH $path
      }
   }
   
   set file "make_qii_design.tcl"
   set path "../../ip_top/ex_design/${file}"
   add_fileset_file $file [::altera_emif::util::hwtcl_utils::get_file_type $file $rtl_only $encrypted] PATH $path

   set file "make_sim_design.tcl"
   set path "../../ip_top/ex_design/${file}"
   add_fileset_file $file [::altera_emif::util::hwtcl_utils::get_file_type $file $rtl_only $encrypted] PATH $path
   
   set file "readme.txt"
   set path "../../ip_top/ex_design/${file}"
   add_fileset_file $file [::altera_emif::util::hwtcl_utils::get_file_type $file $rtl_only $encrypted] PATH $path
}


proc ::altera_phylite::ip_top::ex_design::_is_pro_edition {} {
   
   if { [catch {is_qsys_edition QSYS_PRO} result] } {
      return 0
   } else {
      return $result
   }
}

proc ::altera_phylite::ip_top::ex_design::_ls_recursive {base glob} {
   set files [list]

   foreach f [glob -nocomplain -types f -directory $base $glob] {
      set file_path [file join $base $f]
      lappend files $file_path
   }

   foreach d [glob -nocomplain -types d -directory $base *] {
      set files_recursive [_ls_recursive [file join $base $d] $glob]
      lappend files {*}$files_recursive
   }

   return $files
}

proc ::altera_phylite::ip_top::ex_design::_get_relative_path {base path} {
   return [string trimleft [ string range $path [string length $base] [string length $path] ] "/"]
}

proc ::altera_phylite::ip_top::ex_design::_create_and_get_temp_file_path { filename } {
   set qsys_path [create_temp_file $filename]
   set fh [open $qsys_path "w"] 
   close $fh
   return $qsys_path
}

proc ::altera_phylite::ip_top::ex_design::_init {} {
}

::altera_phylite::ip_top::ex_design::_init
