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


package provide altera_emif::ip_top::ex_design 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::ex_design:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::util::hwtcl_utils::*


}


proc ::altera_emif::ip_top::ex_design::example_design_fileset_callback {name} {

   set rtl_only 0
   set encrypted 0
   
   set name [regsub -lineanchor "_example_design$" $name ""]

   set add_test_emifs [get_parameter_value DIAG_EX_DESIGN_ADD_TEST_EMIFS]

   set is_hps [get_is_hps]
   set family_enum [get_device_family_enum]
   set curr_device_name [get_parameter_value SYS_INFO_DEVICE]

   if { [regexp  {^[ ]*$} $curr_device_name match] != 1 && [string compare -nocase $curr_device_name "unknown"] != 0} {
      set default_device $curr_device_name
   } else {
      set default_device [enum_data $family_enum DEFAULT_PART_FOR_ED]
   }

   set synth_qsys_name "ed_synth"
   set synth_qsys_file "${synth_qsys_name}.qsys"
   set synth_qsys_path [create_temp_file $synth_qsys_file]

   set sim_qsys_name   "ed_sim"
   set sim_qsys_file   "${sim_qsys_name}.qsys"
   set sim_qsys_path   [create_temp_file $sim_qsys_file]


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


   puts $fh "set ip_params(SHORT_QSYS_INTERFACE_NAMES) \"true\""

   puts $fh "set ed_params(EMIF_MODULE_NAME)    \"[get_module_property NAME]\""
   puts $fh "set ed_params(EMIF_NAME)           \"$name\""
   puts $fh "set ed_params(DEFAULT_DEVICE)      \"$default_device\""
   puts $fh "set ed_params(SYNTH_QSYS_NAME)     \"$synth_qsys_name\""
   puts $fh "set ed_params(SIM_QSYS_NAME)       \"$sim_qsys_name\""
   puts $fh "set ed_params(TMP_SYNTH_QSYS_PATH) \"$synth_qsys_path\""
   puts $fh "set ed_params(TMP_SIM_QSYS_PATH)   \"$sim_qsys_path\""
   puts $fh "set pro_edition  [_is_pro_edition]"

   if {$add_test_emifs != ""} {
      set supported_protocol_enums [list]
      foreach protocol_enum [enums_of_type PROTOCOL] {
         if {$protocol_enum == "PROTOCOL_INVALID"} {
            continue
         }

         if { [get_feature_support_level FEATURE_EMIF $protocol_enum] != 0 } {
            lappend supported_protocol_enums $protocol_enum
         }
      }
      set supported_protocol_enums [join $supported_protocol_enums " "]
      puts $fh "set ed_params(SUPPORTED_PROTOCOL_ENUMS)   \[list $supported_protocol_enums\]"
   }
   close $fh

   add_fileset_file $params_file [::altera_emif::util::hwtcl_utils::get_file_type $params_file $rtl_only $encrypted] PATH $params_path

   set qsys_script_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
   set quartus_sh_exe_path "$::env(QUARTUS_BINDIR)/quartus_sh"
   set emif_root_path "$::env(QUARTUS_ROOTDIR)/../ip/altera/emif"
   set ex_design_path "$emif_root_path/ip_top/ex_design"
   set make_qsys_script_path [expr {$is_hps ? "${ex_design_path}/make_qsys_hps.tcl" : "${ex_design_path}/make_qsys.tcl"}]

   set platform [lindex $::tcl_platform(platform) 0]
   if { [_is_pro_edition] } {
      set pro_string "--pro"
   } else {
      set pro_string ""
   }

   if { $platform == "windows" } {
      set cmd [concat [list exec $qsys_script_exe_path $pro_string --quartus-project=none --cmd="source $params_path" --script=$make_qsys_script_path]]
   } else {
      set cmd [concat [list exec $qsys_script_exe_path $pro_string --quartus-project=none --cmd='source $params_path' --script=$make_qsys_script_path]]
   }
   set cmd_fail [catch { eval $cmd } tempresult]

   add_fileset_file $synth_qsys_file [::altera_emif::util::hwtcl_utils::get_file_type $synth_qsys_file $rtl_only $encrypted] PATH $synth_qsys_path

   if {[get_parameter_value MEM_HAS_SIM_SUPPORT]} {
      add_fileset_file $sim_qsys_file   [::altera_emif::util::hwtcl_utils::get_file_type $sim_qsys_file $rtl_only $encrypted] PATH $sim_qsys_path
   }

   set tmp_dir_path [create_temp_file ""]
   if {[_is_pro_edition]} {
      set ip_files [_ls_recursive "${tmp_dir_path}" "*.ip"]

      foreach path $ip_files {
          set file [_get_relative_path $tmp_dir_path $path]
          add_fileset_file $file OTHER PATH $path
      }
   }

   set file "make_qii_design.tcl"
   set path "${ex_design_path}/${file}"
   add_fileset_file $file [::altera_emif::util::hwtcl_utils::get_file_type $file $rtl_only $encrypted] PATH $path
   set make_qii_design_path $path

   set file "make_sim_design.tcl"
   set path "${ex_design_path}/${file}"
   add_fileset_file $file [::altera_emif::util::hwtcl_utils::get_file_type $file $rtl_only $encrypted] PATH $path
   set make_sim_design_path $path

   set ex_design_param_prefix [_get_protocol_specific_param_prefix "EX_DESIGN_GUI"]
   set phy_param_prefix [_get_protocol_specific_param_prefix "PHY"]

   if {[get_parameter_value "${ex_design_param_prefix}_GEN_SYNTH"] && ![errors_were_thrown]} {
      file copy $make_qii_design_path $tmp_dir_path

      set synth_gen_log_file "make_qii_design_errors.log"
      set synth_gen_log_path [create_temp_file $synth_gen_log_file]
      set fh [open $synth_gen_log_path "w"]

      set cmd [concat [list exec $quartus_sh_exe_path -t "${tmp_dir_path}make_qii_design.tcl"]]
      set cmd_fail [catch { eval $cmd } tempresult]
      puts $fh $tempresult

      close $fh

      if {$cmd_fail == 1} {
         add_fileset_file $synth_gen_log_file [::altera_emif::util::hwtcl_utils::get_file_type $synth_gen_log_file $rtl_only $encrypted] PATH $synth_gen_log_path
         send_message error "An error has occurred when generating the synthesis example design. See $synth_gen_log_file for details."
      }

      set default_dev_kit [get_parameter_property EX_DESIGN_GUI_TARGET_DEV_KIT DEFAULT_VALUE]
      set user_dev_kit [get_parameter_value "${ex_design_param_prefix}_TARGET_DEV_KIT"]
      if {$user_dev_kit != $default_dev_kit} {
         set hw_tcl_dir [pwd]
         cd "${tmp_dir_path}qii"

         set io_voltage [get_parameter_value "${phy_param_prefix}_IO_VOLTAGE"]

         set make_devkit_script "${ex_design_path}/make_devkit_ex_design.tcl"
         set cmd [concat [list exec $quartus_sh_exe_path -t $make_devkit_script $synth_qsys_name "${synth_qsys_name}_top" $user_dev_kit $name $io_voltage]]
         set cmd_fail [catch { eval $cmd } tempresult]

         cd $hw_tcl_dir
      }

      set syn_files [_ls_recursive "${tmp_dir_path}qii" "*"]
      foreach path $syn_files {
         set file [ string range $path [string length $tmp_dir_path] [string length $path] ]
         if {[regexp -nocase {^[ ]*qii\/db\/} $file] == 1} {
            continue
         }
         add_fileset_file $file [::altera_emif::util::hwtcl_utils::get_file_type $file $rtl_only $encrypted] PATH $path
      }
   }

   if {[get_parameter_value "${ex_design_param_prefix}_GEN_SIM"] && ![errors_were_thrown]} {
      file copy $make_sim_design_path $tmp_dir_path

      set sim_gen_log_file "make_sim_design_errors.log"
      set sim_gen_log_path [create_temp_file $sim_gen_log_file]
      set fh [open $sim_gen_log_path "w"]

      set cmd [concat [list exec $quartus_sh_exe_path -t "${tmp_dir_path}make_sim_design.tcl"]]
      if {[get_parameter_value "${ex_design_param_prefix}_HDL_FORMAT"] == "HDL_FORMAT_VHDL"} {
         set cmd [concat $cmd "VHDL"]
      }
      set cmd_fail [catch { eval $cmd } tempresult]
      puts $fh $tempresult

      close $fh

      if {$cmd_fail == 1} {
         add_fileset_file $sim_gen_log_file [::altera_emif::util::hwtcl_utils::get_file_type $sim_gen_log_file $rtl_only $encrypted] PATH $sim_gen_log_path
         send_message error "An error has occurred when generating the simulation example design. See $sim_gen_log_file for details."
      }

      set sim_files [_ls_recursive "${tmp_dir_path}sim" "*"]
      foreach path $sim_files {
         set file [ string range $path [string length $tmp_dir_path] [string length $path] ]
         add_fileset_file $file [::altera_emif::util::hwtcl_utils::get_file_type $file $rtl_only $encrypted] PATH $path
      }
   }

   set file "readme.txt"
   set path "${ex_design_path}/${file}"
   add_fileset_file $file [::altera_emif::util::hwtcl_utils::get_file_type $file $rtl_only $encrypted] PATH $path
}


proc ::altera_emif::ip_top::ex_design::_get_protocol_specific_param_prefix {package_prefix} {
   set protocol_enum  [get_parameter_value "PROTOCOL_ENUM"]
   set module_name    [string toupper [enum_data $protocol_enum MODULE_NAME]]
   return "${package_prefix}_${module_name}"
}

proc ::altera_emif::ip_top::ex_design::_is_pro_edition {} {
   if { [catch {is_qsys_edition QSYS_PRO} result] } {
      return 0
   } else {
      return $result
   }
}

proc ::altera_emif::ip_top::ex_design::_ls_recursive {base glob} {
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

proc ::altera_emif::ip_top::ex_design::_get_relative_path {base path} {
    return [string trimleft [ string range $path [string length $base] [string length $path] ] "/"]
}

proc ::altera_emif::ip_top::ex_design::_init {} {
}

::altera_emif::ip_top::ex_design::_init
