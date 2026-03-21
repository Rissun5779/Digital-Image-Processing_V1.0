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


package require -exact qsys 15.0
package require altera_terp

source "../lib/tcl/avalon_streaming_util.tcl"
source "../lib/tcl/dspip_hls_common.tcl"


#
# set the module properties
#
set_module_property NAME altera_rand_gen
set_module_property AUTHOR "Intel Corporation" 
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "DSP/Error Detection and Correction"
set_module_property DISPLAY_NAME "Random Number Generator"
set_module_property DESCRIPTION "The Random Number Generator core produces pseudo random numbers under uniform or Normal distribution"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property PREFERRED_SIMULATION_LANGUAGE Verilog
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
set_module_property HIDE_FROM_QSYS false
set_module_property HIDE_FROM_QUARTUS false
set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V} {CYCLONE V}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10} {STRATIX 10}
}


add_documentation_link "User Guide" https://documentation.altera.com/#/link/dmi1455632999173/dmi1455633326157 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408

#
# set the HLS component name, which is the name of .cpp file that describes the component
#
proc get_hls_component_name {} {
   return "altera_rand_gen_fn"
}


#
# add filesets, which calls generate_xxx procs
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
add_parameter GEN_TYPE integer 1
set_parameter_property GEN_TYPE DISPLAY_NAME "Generator type"
set_parameter_property GEN_TYPE DESCRIPTION "Select the type of the random number generator"
set_parameter_property GEN_TYPE ALLOWED_RANGES [list "1:Uniform distribution (integer)" "2:Uniform distribution (float)" "3:Normal distribution (float)"]
set_parameter_property GEN_TYPE AFFECTS_GENERATION true

add_parameter MODEL_OPTION integer 1
set_parameter_property MODEL_OPTION DISPLAY_NAME "Generator architecture"
set_parameter_property MODEL_OPTION DESCRIPTION "Select the architecture of the generator"
set_parameter_property MODEL_OPTION ALLOWED_RANGES [list "1:Central-limit Components (recommended)" "2:Box-Muller"]
set_parameter_property MODEL_OPTION AFFECTS_GENERATION true
set_parameter_property MODEL_OPTION VISIBLE false

add_parameter SEED_GEN string "Auto"
set_parameter_property SEED_GEN DISPLAY_NAME "Seed selection"
set_parameter_property SEED_GEN DESCRIPTION "Choose how the seed is determined for the generator"
set_parameter_property SEED_GEN ALLOWED_RANGES [list "Auto" "Manual"]
set_parameter_property SEED_GEN AFFECTS_GENERATION true

add_parameter SEED_VALUE POSITIVE 68997764
set_parameter_property SEED_VALUE DISPLAY_NAME "Value of the seed"
set_parameter_property SEED_VALUE DESCRIPTION "Value of the seed to be used by the generator"
set_parameter_property SEED_VALUE AFFECTS_GENERATION true
set_parameter_property SEED_VALUE ENABLED false

#
# device parameters
#
add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}


#
# this hidden parameter is reserved for testing, not to be accessed by user
#
add_parameter IS_TESTING BOOLEAN false 
set_parameter_property IS_TESTING VISIBLE false 




#
# the validation proc
#
proc validate {} {
	# Add validation code here
}


#
# the elaborate proc, which defines the interface of the module, displayed in qsys GUI
#
proc elaborate {} {
   
   set gen_type [get_parameter_value GEN_TYPE]
   if {$gen_type == 3} {
      set_parameter_property MODEL_OPTION VISIBLE true
   } else {
      set_parameter_property MODEL_OPTION VISIBLE false
   }
   set seed_gen [get_parameter_value SEED_GEN]
   if {$seed_gen eq "Auto"} {
      set_parameter_property SEED_VALUE ENABLED false
   } else {
      set_parameter_property SEED_VALUE ENABLED true
   }


   # These interface declarations come directly from the HLS generated _hw.tcl file

   add_interface clock clock end
   set_interface_property clock ENABLED true
   add_interface_port clock clock clk Input 1

   add_interface reset reset end
   set_interface_property reset associatedClock clock
   add_interface_port reset resetn reset_n Input 1

   add_interface rand_num avalon_streaming source
   set_interface_property rand_num associatedClock clock
   set_interface_property rand_num associatedReset reset
   set_interface_property rand_num maxChannel 0
   set_interface_property rand_num readyLatency 0
   set_interface_property rand_num dataBitsPerSymbol 32
   add_interface_port rand_num rand_num_data data Output 32
   add_interface_port rand_num rand_num_ready ready Input 1
   add_interface_port rand_num rand_num_valid valid Output 1

   # The function invocation protocol interface (call)
   add_interface call conduit sink
   set_interface_property call associatedClock clock
   set_interface_property call associatedReset reset
   add_interface_port call start enable Input 1
   add_interface_port call busy stall Output 1

   set_port_property busy TERMINATION true

   # The function return protocol interface (return)
   add_interface return conduit source
   set_interface_property return associatedClock clock
   set_interface_property return associatedReset reset
   add_interface_port return done valid Output 1
   add_interface_port return stall stall Input 1

   set_interface_property return ENABLED false

}


proc render_terp {output_name template_path} {
   set template_fd [open $template_path]
   set template [read $template_fd]
   close $template_fd

   set params(output_name) $output_name

   set contents [altera_terp $template params]
   return $contents
}

proc is_s10_or_a10 {} {
   set family [get_parameter_value selected_device_family]
   return [expr ([string match -nocase arria*10 $family] || [string match -nocase stratix*10 $family] ) ]
}


#
# currently expects acl resource to be available
#
proc call_compiler {working_dir} {

   # pass the parameters to the HLS component by including this header file, otherwise leave it blank
   set fp [open "$working_dir/defines.h" w]
   set gen_type [get_parameter_value GEN_TYPE]
   if {$gen_type == 1} {
      puts $fp "#define DATA_TYPE unsigned int"
      puts $fp "#define GEN_TYPE_OP 1"
   }
   if {$gen_type == 2} {
      puts $fp "#define DATA_TYPE float"
      puts $fp "#define GEN_TYPE_OP 2"
   }
   if {$gen_type == 3} {
      puts $fp "#define DATA_TYPE float"
      puts $fp "#define GEN_TYPE_OP 3"
   }
   set model_option [get_parameter_value MODEL_OPTION]
   puts $fp "#define MODEL_OPTION $model_option"
   set seed_value [get_parameter_value SEED_VALUE]
   puts $fp "#define SEED_VALUE $seed_value"
   close $fp

   
   #defines.h is in working_dir, but we change into working_dir before calling compiler, so -I. is sufficient
   set source_file [file join [get_module_property MODULE_DIRECTORY] [get_hls_component_name].cpp]
   set device_family [get_parameter_value selected_device_family]
   set command_line [get_hls_ip_compile_command [get_hls_component_name] $device_family \
                                                [list .] [list $source_file] [use_fpc]]

   send_message INFO $command_line
   # Expand command_line items into separate arguments, this will not expand the items themselves
   # If we expand the individual itmes, those items cannot have spaces and we cannot support
   # paths with spaces for example
   set prev_dir [pwd]
   cd $working_dir
   if { [ catch { exec {*}$command_line } output ] } {
      #the executable may write information messages to stderr, it's only definitely an error if errorCode is not NONE
      if { $::errorCode ne {NONE} } {
         # if there is an error change directory back before erroring as execution stops at error message
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


proc use_fpc {} {
   set gen_type [get_parameter_value GEN_TYPE]
   set do_it 1
   if {$gen_type != 1} {
      if { [is_s10_or_a10]} {
         set do_it 0
      }
   }
   return $do_it
}

#
# discover HLS generated RTL files from the HLS generated _hw.tcl file
#
proc discover_files { file_set working_dir } {

   set hls_generated_files_dir "${working_dir}/[get_hls_component_name].prj/components/[get_hls_component_name]"
   if { [catch {open "${hls_generated_files_dir}/[get_hls_component_name]_internal_hw.tcl"}  fd] } {
      send_message ERROR "IP geneneration failed at file discovery, please tell Altera"
      return -code error $fd
   }
   set contents [read -nonewline $fd]
   close $fd

   set lines [split $contents "\n"]

   #skip until we see an add_fileset with the correct file set.
   #then collect all add_fileset_file commands until we see a different add_fileset or end of file
   set in_region 0
   foreach line $lines {
      if { $in_region } {
         if { [string match "add_fileset *" $line] } {
            if { ! [string match $file_set $line] } {
               set in_region 0
            }
         } elseif { [string match "add_fileset_file*" $line] } {
            #we can't run the $line directly because relative paths are relative to the generated _hw.tcl file
            #they need to be either absolute or relative to this hw.tcl file

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



proc add_files { cmd_list working_dir output_name file_set } {
   # No encryption needed because the files are all generated by a++ compiler
   set top_file_name ${output_name}.sv
   set template_path "top.sv.terp"
   send_message INFO $top_file_name
   send_message INFO $template_path
   send_message INFO [pwd]
   set top_level_contents [render_terp $output_name $template_path]
   send_message INFO $top_level_contents

   #execute the commands
   foreach cmd $cmd_list {
      {*}$cmd
   }
   add_fileset_file $top_file_name SYSTEM_VERILOG TEXT $top_level_contents

   if { [get_parameter_value IS_TESTING] } {
      add_fileset_file defines.h OTHER PATH $working_dir/defines.h 
   }
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
