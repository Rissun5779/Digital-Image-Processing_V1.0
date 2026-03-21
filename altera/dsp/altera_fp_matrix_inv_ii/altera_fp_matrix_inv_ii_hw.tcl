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


package require -exact qsys 14.0
package require altera_terp

source "../lib/tcl/avalon_streaming_util.tcl"
source "../lib/tcl/dspip_hls_common.tcl"
load_strings altera_fp_matrix_inv_ii.properties

#
# module altera_fp_matrix_inv_ii 
# 
set_module_property NAME altera_fp_matrix_inv_ii
set_module_property AUTHOR [get_string AUTHOR]
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP [get_string GROUP]
set_module_property DISPLAY_NAME "ALTERA_FP_MATRIX_INV"
set_module_property DESCRIPTION [get_string DESCRIPTION]
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property PREFERRED_SIMULATION_LANGUAGE Verilog
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
set_module_property PARAMETER_UPGRADE_CALLBACK parameter_upgrade
set_module_property HIDE_FROM_QSYS true
set_module_property HIDE_FROM_QUARTUS true
set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10} {Stratix 10}
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1410764818924/eis1410936966508 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408


#
# file sets
#
proc add_filesets {} {
    foreach fileset {quartus_synth sim_verilog sim_vhdl} {
        add_fileset $fileset [string toupper $fileset] "generate_$fileset" 
    }
}

add_filesets

#
# parameters 
#
add_parameter FP_FORMAT string "SINGLE"
set_parameter_property FP_FORMAT DISPLAY_NAME [get_string FP_FORMAT_DISPLAY_NAME
 ]
set_parameter_property FP_FORMAT UNITS None
set_parameter_property FP_FORMAT DESCRIPTION [get_string FP_FORMAT_DESCRIPTION]
set_parameter_property FP_FORMAT ALLOWED_RANGES [list "SINGLE:[get_string FP_FORMAT_FLOAT_NAME]" \
                                                      "DOUBLE:[get_string FP_FORMAT_DOUBLE_NAME]"]
set_parameter_property FP_FORMAT AFFECTS_GENERATION true
set_parameter_property FP_FORMAT GROUP [get_string FLOATING_PT_DATA_GROUP]

add_parameter MATRIX_SIZE INTEGER 8
set_parameter_property MATRIX_SIZE DISPLAY_NAME [get_string MATRIX_SIZE_NAME ]
set_parameter_property MATRIX_SIZE DESCRIPTION [get_string MATRIX_SIZE_DESCRIPTION]
set_parameter_property MATRIX_SIZE ALLOWED_RANGES 2:256 
set_parameter_property MATRIX_SIZE AFFECTS_GENERATION true
set_parameter_property MATRIX_SIZE GROUP [get_string MATRIX_DIMENSIONS_GROUP]

add_parameter SCALARPROD_PIPELINE INTEGER 5
set_parameter_property SCALARPROD_PIPELINE DISPLAY_NAME [get_string SCALARPROD_PIPELINE_NAME ]
set_parameter_property SCALARPROD_PIPELINE DESCRIPTION [get_string SCALARPROD_PIPELINE_DESCRIPTION]
set_parameter_property SCALARPROD_PIPELINE ALLOWED_RANGES 3:256 
set_parameter_property SCALARPROD_PIPELINE AFFECTS_GENERATION true
set_parameter_property SCALARPROD_PIPELINE GROUP [get_string PIPELINE_GROUP]
set_parameter_property SCALARPROD_PIPELINE VISIBLE false

add_parameter RSQRT_PIPELINE INTEGER 4
set_parameter_property RSQRT_PIPELINE DISPLAY_NAME [get_string RSQRT_PIPELINE_NAME ]
set_parameter_property RSQRT_PIPELINE DESCRIPTION [get_string RSQRT_PIPELINE_DESCRIPTION]
set_parameter_property RSQRT_PIPELINE ALLOWED_RANGES 3:256 
set_parameter_property RSQRT_PIPELINE AFFECTS_GENERATION true
set_parameter_property RSQRT_PIPELINE GROUP [get_string PIPELINE_GROUP]
set_parameter_property RSQRT_PIPELINE VISIBLE false

add_parameter MULT_PIPELINE INTEGER 3
set_parameter_property MULT_PIPELINE DISPLAY_NAME [get_string MULT_PIPELINE_NAME ]
set_parameter_property MULT_PIPELINE DESCRIPTION [get_string MULT_PIPELINE_DESCRIPTION]
set_parameter_property MULT_PIPELINE ALLOWED_RANGES 3:256 
set_parameter_property MULT_PIPELINE AFFECTS_GENERATION true
set_parameter_property MULT_PIPELINE GROUP [get_string PIPELINE_GROUP]
set_parameter_property MULT_PIPELINE VISIBLE false

add_parameter B_SHIFT INTEGER 9
set_parameter_property B_SHIFT DISPLAY_NAME [get_string B_SHIFT_NAME ]
set_parameter_property B_SHIFT DESCRIPTION [get_string B_SHIFT_DESCRIPTION]
set_parameter_property B_SHIFT ALLOWED_RANGES 3:256 
set_parameter_property B_SHIFT AFFECTS_GENERATION true
set_parameter_property B_SHIFT GROUP [get_string PIPELINE_GROUP]
set_parameter_property B_SHIFT VISIBLE false

add_parameter FUNCTION string "INVERT"
set_parameter_property FUNCTION DISPLAY_NAME [get_string FUNCTION_DISPLAY_NAME
 ]
set_parameter_property FUNCTION UNITS None
set_parameter_property FUNCTION DESCRIPTION [get_string FUNCTION_DESCRIPTION]
set_parameter_property FUNCTION ALLOWED_RANGES [list "SOLVE:[get_string FUNCTION_SOLVE_NAME]" \
                                                      "INVERT:[get_string FUNCTION_INVERT_NAME]"]
set_parameter_property FUNCTION AFFECTS_GENERATION true
set_parameter_property FUNCTION GROUP [get_string FUNCTION_GROUP]

#
# device parameters
#
add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}


#
# procs
#

proc get_data_width {} {
   set data_type [get_parameter_value FP_FORMAT]
   set data_width 64
   if { $data_type eq "SINGLE" } {
      set data_width 32
   } elseif { $data_type eq "DOUBLE" } {
      set data_width 64
   }
   return $data_width
}

proc get_function {} {
    set func_type [get_parameter_value FUNCTION]
    if { $func_type eq {SOLVE} } {
        set func_value 1
    } elseif { $func_type eq {INVERT} } {
        set func_value 2
    } else {
        send_message ERROR "Internal Error: Invalid function"
    }
    return $func_value
}

proc elaborate {} {
   set data_width [get_data_width]

   add_interface clk clock end
   add_interface_port clk clk clk Input 1

   add_interface rst reset end
   set_interface_property rst associatedClock clk
   add_interface_port rst reset_n reset_n Input 1

   add_interface a avalon_streaming sink
   set_interface_property a associatedClock clk
   set_interface_property a dataBitsPerSymbol $data_width
   add_interface_port a a_valid valid Input 1
   add_interface_port a a_ready ready Output 1
   add_interface_port a a_data data Input $data_width

    set func_value [get_function]
    if { $func_value == 1 } {
        add_interface b avalon_streaming sink
        set_interface_property b associatedClock clk
        set_interface_property b dataBitsPerSymbol $data_width
        add_interface_port b b_valid valid Input 1
        add_interface_port b b_ready ready Output 1
        add_interface_port b b_data data Input $data_width

        add_interface c avalon_streaming sink
        set_interface_property c associatedClock clk
        set_interface_property c dataBitsPerSymbol 16
        add_interface_port c c_valid valid Input 1
        add_interface_port c c_ready ready Output 1
        add_interface_port c c_data data Input 16
    }

   add_interface x avalon_streaming source
   set_interface_property x associatedClock clk
   set_interface_property x dataBitsPerSymbol $data_width
   add_interface_port x x_valid valid Output 1
   add_interface_port x x_ready ready Input 1
   add_interface_port x x_data data Output $data_width 
   set_interface_assignment x "ui.blockdiagram.direction" OUTPUT
}

proc validate {} {
}

proc is_s10_or_a10 {} {
   set family [get_parameter_value selected_device_family]
   return [expr ([string match -nocase arria*10 $family] || [string match -nocase stratix*10 $family] ) ]
}

proc use_fpc {} {
   set data_type [get_parameter_value FP_FORMAT]
   if { [is_s10_or_a10] && $data_type eq {SINGLE}} {
      set do_it 0
   } else {
      set do_it 1
   }
   return $do_it
}

proc call_compiler {working_dir} {
    set data_type    [get_parameter_value FP_FORMAT]
   set family        [get_parameter_value selected_device_family]

    set fp [open "$working_dir/defines.h" w]
    if { $data_type eq {SINGLE} } {
        puts $fp "#define FP_PRECISION 1"
    } elseif { $data_type eq {DOUBLE} } {
        puts $fp "#define FP_PRECISION 2"
    } else {
        send_message ERROR "Internal Error: Invalid data format"
    }
    puts $fp "#define MATRIX_SIZE [get_parameter_value MATRIX_SIZE]"
    puts $fp "#define SCALARPROD_PIPELINE [get_parameter_value SCALARPROD_PIPELINE]"
    puts $fp "#define RSQRT_PIPELINE [get_parameter_value RSQRT_PIPELINE]"
    puts $fp "#define MULT_PIPELINE [get_parameter_value MULT_PIPELINE]"
    puts $fp "#define B_SHIFT [get_parameter_value B_SHIFT]"

    set func_value [get_function]
    puts $fp "#define FUNCTION ${func_value}"
    close $fp

   lappend args {*}[list --simulator "none"]
   lappend args --fp-relaxed
   lappend args {*}[list -o matrix_inv]
   lappend args {*}[list -march=\"$family\"]
   lappend args {*}[list --llc-arg --generate-altera-ip]
   if { [use_fpc] } {
      lappend args --fpc
   }

   #defines.h is in working_dir, but we change into working_dir before
   #calling compiler, so -I. is sufficient
   lappend args -I.

   set compiler [get_HLS_executable]
   set source_file [file join [get_module_property MODULE_DIRECTORY] matrix_inv.cpp]
   set command_line  [list $compiler {*}$args $source_file]

   send_message INFO $command_line
   # Expand command_line items into separate arguments. This will not
   # expand the items themselves. If we expand the individual itmes,
   # those items cannot have spaces and we cannot support paths with
   # spaces for example
   set prev_dir [pwd]
   cd $working_dir
   if { [ catch { exec {*}$command_line } output ] } {
      #the executable may write information messages to stderr, it's
      #only definitely an error if errorCode is not NONE
      if { $::errorCode ne {NONE} } {
         # if there is an error change directory back before erroring
         # as execution stops at error message
         cd $prev_dir
         send_message ERROR $output
      } else {
         cd $prev_dir
      }
   } else {
      cd $prev_dir
   }

   if { [string match -nocase *error* $output] } {
      if {[regexp -nocase {error\s+starting\s+the\s+process} $output]} {
         send_message ERROR $output
      } elseif {[regexp -nocase {could\s+not\s+acquire\s+opencl\s+sdk\s+license} $output]} {
         send_message ERROR $output
      } else {
         #we most likely have an error, but we can't be sure so just print an info message, an error may follow
         send_message INFO $output
      }
   }

}

# given an add_fileset_file command list, returns a command list
# where all system verilog files have the extension .sv
proc fix_extensions { cmd_list } {
   foreach cmd $cmd_list {
      if { [lindex $cmd 2] eq {SYSTEM_VERILOG} } {
         #just file rootname should be enough according to standard
         #tcl but it seems the implementation that we have prepends
         #the current directory
         #so we need to do tail as well
         lset cmd 1 "[file tail [file rootname [lindex $cmd 1]]].sv"
         lappend fixed_list $cmd
      } else {
         lappend fixed_list $cmd
      }
   }
   return $fixed_list
}

# Part-way through 16.1 development, the a++ directory layout changed
# (affecting standard and Pro in different builds). Previously the
# generated _hw.tcl file is in the matrix_inv.prj directory; now the
# file is in the directory
# matrix_inv.prj/components/altera_fp_matrix_inv.  Also a top-level
# file is no longer generated, so the template instantiates the
# "internal" generated entity.

proc discover_files { file_set working_dir } {
   set hls_generated_files_dir "${working_dir}/matrix_inv.prj"
   if { [catch {open "${hls_generated_files_dir}/altera_fp_matrixinv_internal_hw.tcl"}  fd] } {
      set hls_generated_files_dir ${hls_generated_files_dir}/components/altera_fp_matrixinv
      if { [catch {open "${hls_generated_files_dir}/altera_fp_matrixinv_internal_hw.tcl"}  fd] } {
         send_message ERROR "IP geneneration failed at file discovery, please tell Altera"
         return -code error $fd
      }
   }
   set contents [read -nonewline $fd]
   close $fd

   set lines [split $contents "\n"]

   #skip until we see an add_fileset with the correct file set.  then
   #collect all add_fileset_file commands until we see a different
   #add_fileset or end of file
   set in_region 0
   foreach line $lines {
      if { $in_region } {
         if { [string match "add_fileset *" $line] } {
            if { ! [string match $file_set $line] } {
               set in_region 0
            }
         } elseif { [string match "add_fileset_file*" $line] } {
            #we can't run the $line directly because relative paths
            #are relative to the generated _hw.tcl file they need to
            #be either absolute or relative to this hw.tcl file

            #split into words
            set tokens [regexp -inline -all -- {\S+} $line] 
            if { [llength $tokens] != 5 } {
               send_message ERROR "IP geneneration failed at file discovery, please tell Altera"
            }

            #this is needed to clear the list
            set cmd [list]
            #add_fileset_file
            lappend cmd [lindex $tokens 0]
            #output_file
            lappend cmd [lindex $tokens 1]
            #file_type
            lappend cmd [lindex $tokens 2]
            #file_source
            lappend cmd [lindex $tokens 3]

            #path
            #path may contain $::env(ALTERAOCLSDKROOT). So we must run subst
            lset tokens 4 [subst -nobackslashes -nocommands [lindex $tokens 4]]
            #this will leave absolute paths alone
            lappend cmd [file join "$hls_generated_files_dir" [lindex $tokens 4]] 
            
            #add the file to the list
            lappend cmd_list $cmd
         } 
      } else {
         if { [string match "add_fileset*$file_set*" $line] } {
            set in_region 1
         } 
      }
   }
   return $cmd_list
}

proc render_terp {output_name template_path} {
   set template_fd [open $template_path]
   set template [read $template_fd]
   close $template_fd

   set params(output_name) $output_name
   set params(data_width) [get_data_width] 
   set params(func_value) [get_function] 

   set contents [altera_terp $template params]
   return $contents
}

proc add_files { cmd_list working_dir output_name file_set } {
   set top_file_name ${output_name}.sv
   set template_path "top.sv.terp"
   set top_level_contents [render_terp $output_name $template_path]

      #execute the commands
      foreach cmd $cmd_list {
         {*}$cmd
      }

      add_fileset_file $top_file_name SYSTEM_VERILOG TEXT $top_level_contents

}

proc generate_all {output_name file_set} {
   set tmp_dir [create_temp_file ""]
   file mkdir $tmp_dir

   call_compiler $tmp_dir

   #HLS generated _hw.tcl file does not contain a SIM_VHDL fileset
   #so discover files for SIM_VERILOG instead
   if { $file_set eq {SIM_VHDL} } {
      set proxy_file_set SIM_VERILOG
   } else {
      set proxy_file_set $file_set
   }

   set cmd_list [discover_files $proxy_file_set $tmp_dir]

   add_files $cmd_list $tmp_dir $output_name $file_set
}

proc generate_quartus_synth {output_name} {  
   generate_all $output_name QUARTUS_SYNTH
}
proc generate_sim_verilog {output_name} {  
   generate_all $output_name SIM_VERILOG 
}
proc generate_sim_vhdl {output_name} {  
   generate_all $output_name SIM_VERILOG
}
