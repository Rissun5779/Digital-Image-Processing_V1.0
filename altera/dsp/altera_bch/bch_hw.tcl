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


# Owner: Jaden Liu


# Include the package of the API.
# The second package "altera_hdl_wrapper" is a package that helps defining top level entity.
package require -exact qsys 14.0
package require altera_hdl_wrapper 1.0
package require altera_terp


# This command executes the .tcl file called "avalon_streaming_util.tcl" which provides functions like "dsp_add_streaming_interface"
source ../lib/tcl/avalon_streaming_util.tcl
source ../lib/tcl/dspip_common.tcl

source bch_lib.tcl
source design_gen_utility.tcl
source ./bch_dec/polysys_generate.tcl
source ./bch_dec/gfm_generate.tcl
source ./bch_dec/parameter_generate.tcl




# These are declarations that are mendatory to the .tcl script. They define the properties of the IP core in question.
set_module_property NAME "altera_bch" 
set_module_property DISPLAY_NAME "BCH" 
set_module_property AUTHOR "Altera Corporation" 
set_module_property GROUP "DSP/Error Detection and Correction"
set_module_property DESCRIPTION "Altera BCH"
set_module_property VERSION 18.1

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/dmi1423232706057/dmi1423232847303
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/dmi1436953439900


# device parameters
add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}

add_parameter BCH string "Encoder"
set_parameter_property BCH DISPLAY_NAME "BCH module"
set_parameter_property BCH DESCRIPTION "Encoder or Decoder"
set_parameter_property BCH DISPLAY_HINT radio
set_parameter_property BCH ALLOWED_RANGES {"Encoder" "Decoder"}

add_parameter M_BITS integer 14;
set_parameter_property M_BITS DISPLAY_NAME "Number of bits per symbol (m)"; 
set_parameter_property M_BITS DESCRIPTION "Total number of bits per symbol"

add_parameter N_BITS integer 8784;
set_parameter_property N_BITS DISPLAY_NAME "Codeword length (n)"; 
set_parameter_property N_BITS DESCRIPTION "Number of bits in the BCH codeword"

add_parameter T_BITS integer 40;
set_parameter_property T_BITS DISPLAY_NAME "Error correction capability (t)"; 
set_parameter_property T_BITS DESCRIPTION "The error correction capability in bits"

add_parameter PARITY_BITS integer 560;
set_parameter_property PARITY_BITS DISPLAY_NAME "Parity bits"; 
set_parameter_property PARITY_BITS DESCRIPTION "Number of parity bits is determined by t and m"
set_parameter_property PARITY_BITS DERIVED true

add_parameter K_BITS integer 8224;
set_parameter_property K_BITS DISPLAY_NAME "Message length (k)"; 
set_parameter_property K_BITS DESCRIPTION "Number of bits in the message word"
set_parameter_property K_BITS DERIVED true

add_parameter IRRPOL integer 17475;
set_parameter_property IRRPOL DISPLAY_NAME "Primitive polynomial"; 
set_parameter_property IRRPOL DESCRIPTION "Field primitive polynomial is determined by m"
set_parameter_property IRRPOL DERIVED true

add_parameter DATA_WIDTH integer 20;
set_parameter_property DATA_WIDTH DISPLAY_NAME "Parallel input data width"; 
set_parameter_property DATA_WIDTH DESCRIPTION "Parallel input data width every clock cycle"

# Qsys will evaluate the elaboration callback anytime a parameter value is changed. This means the border will always be correct per the callback code.
set_module_property ELABORATION_CALLBACK do_elaboration
set_module_property VALIDATION_CALLBACK validateTOP_bch


# Example design procedure
add_fileset example_design EXAMPLE_DESIGN example_fileset "BCH Example Design"
# These are functions that will be called by clicking the Generate HDL button in Qsys. These functions basically gather all relevant RTL files and wrap them up with generated HDL top level entity.
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
add_fileset sim_verilog SIM_VERILOG generate_sim_verilog
add_fileset sim_vhdl SIM_VHDL generate_sim_vhdl

proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}

proc generate_synth {entity} {
   generate QUARTUS_SYNTH $entity
}
proc generate_sim_verilog {entity} {
   generate SIM_VERILOG $entity
}
proc generate_sim_vhdl {entity} {
   generate SIM_VHDL $entity
}
proc generate_simgen {entity} {
      set bch_type [get_parameter_value BCH] 
      if {$bch_type eq "Encoder"} {
        set bch_type "enc"
      } else {
        set bch_type "dec"
      }

      # Generate design files and gather rtl files
      set support_fileset [get_common_files_bch_${bch_type}]

      set simulator_list [get_simulator_list]




        foreach that_fileset $support_fileset {
	    set cur_file [lindex $that_fileset 0]
	    dsp_add_fileset_file $cur_file "SIM_VHDL" $simulator_list
        }

    # wrapping the core into a top_level instance named as the entity
    set template_path [file join "bch_${bch_type}" "src" "testbench" "top_${bch_type}.vhd.terp" ]
    set top_level_contents [render_terp $entity 1 $template_path ]
    add_fileset_file "top_${bch_type}.vhd" VHDL TEXT $top_level_contents



}
proc generate {type entity} {
   # Generate IIR structure configuration file
   set bch_type [get_parameter_value BCH] 
   if {$bch_type eq "Encoder"} {
     set bch_type "enc"
   } else {
     set bch_type "dec"
   }


   #####################################
   #set type QUARTUS_SYNTH
   #####################################
   if {$type eq "QUARTUS_SYNTH"} {

     # Generate design files and gather rtl files
     #send_message INFO "set support_fileset \[get_common_files_bch_${bch_type}\]"
     set support_fileset [get_common_files_bch_${bch_type}]

     foreach thatfileset $support_fileset {
        set thatfile [lindex $thatfileset 0]
        switch -glob $thatfile {
               *.vhd { set language VHDL}
               *.v   { set language VERILOG}
               *.sv  { set language SYSTEMVERILOG}
               *.hex { set language HEX}
               default  { set language OTHER}
        }
        add_fileset_file [file tail $thatfile] $language PATH $thatfile
     }
      add_fileset_file bchp_decoder.ocp OTHER PATH bch_dec/src/bchp_decoder.ocp
      add_fileset_file bch_encoder.ocp OTHER PATH bch_enc/src/bch_encoder.ocp

      # Generate the top level wrapper entity (similar to altera_hdl_wrapper)
      set terp_output_dir [create_temp_file ""];
      file mkdir $terp_output_dir
      set template_path [file join "bch_${bch_type}" "src" "testbench" "top_${bch_type}.vhd.terp" ]
      set top_level_contents [render_terp $entity 0 $template_path ]
      set top_level_file_path [file join $terp_output_dir "${entity}.vhd"] 
      set f_handle [open $top_level_file_path w+]
      puts $f_handle $top_level_contents
      close $f_handle
      add_fileset_file "${entity}.vhd" VHDL PATH $top_level_file_path

   } elseif { $type eq "SIM_VERILOG" } {
       generate_simgen $entity
   } elseif { $type eq "SIM_VHDL"}  {
       generate_simgen $entity
   }
   
}


# This is the body of the callback function
proc do_elaboration {} {

   set N_BITS [get_parameter_value N_BITS]
   set K_BITS [get_parameter_value K_BITS]
   set M_BITS [get_parameter_value M_BITS]
   set T_BITS [get_parameter_value T_BITS]
   set DATA_WIDTH [get_parameter_value DATA_WIDTH]
   set bch_type [get_parameter_value BCH]




   if {$bch_type eq "Encoder"} {

     # Elaboration of a BCH encoder

     # This adds the clock signal input (set to 100 MHz)
     add_interface clk clock end
     add_interface_port clk clk clk Input 1
     set_interface_property clk clockRate 100000000

     # This adds the reset signal input. It needs to be associated to a clock signal.
     add_interface rst reset end
     set_interface_property rst associatedClock clk
     add_interface_port rst reset reset Input 1

     # This declares a Avalon ST interface. Such interface gathers all input/output ports and combine them into a single one for Qsys.
     # dsp_add_streaming_interface <name> <type>
     # dsp_set_interface_property <name of the interface> dataBitsPerSymbol <width of the interface>
     dsp_add_streaming_interface in sink
     dsp_set_interface_property in associatedClock clk
     add_interface_port in load valid Input 1
     add_interface_port in ready ready Output 1
     add_interface_port in sop_in startofpacket Input 1
     add_interface_port in eop_in endofpacket Input 1
     dsp_set_interface_property in dataBitsPerSymbol $DATA_WIDTH
     set fraglist_in       [list ]    
     lappend fraglist_in  data_in $DATA_WIDTH
     # Then call the function to add the ports in the list to the interface.
     # dsp_add_interface_port <name of the interface> <display name of the combined ports> <type> <direction> <width of the combined ports> <list of ports>
     dsp_add_interface_port in sink_data data Input $DATA_WIDTH $fraglist_in


     # Same as above, this time we add an Avalon ST interface for output port(s)
     dsp_add_streaming_interface out source
     dsp_set_interface_property out associatedClock clk
     add_interface_port out valid_out valid Output 1
     add_interface_port out sink_ready ready Input 1
     add_interface_port out sop_out startofpacket Output 1
     add_interface_port out eop_out endofpacket Output 1
     dsp_set_interface_property out dataBitsPerSymbol $DATA_WIDTH
     set fraglist_out       [list ]    
     lappend fraglist_out data_out $DATA_WIDTH
     dsp_add_interface_port out source_data data Output $DATA_WIDTH $fraglist_out 

   } else {

     # Elaboration of a BCH decoder

     # This adds the clock signal input (set to 100 MHz)
     add_interface clk clock end
     add_interface_port clk clk clk Input 1
     set_interface_property clk clockRate 100000000

     # This adds the reset signal input. It needs to be associated to a clock signal.
     add_interface rst reset end
     set_interface_property rst associatedClock clk
     add_interface_port rst reset reset Input 1

     # This declares a Avalon ST interface. Such interface gathers all input/output ports and combine them into a single one for Qsys.
     # dsp_add_streaming_interface <name> <type>
     # dsp_set_interface_property <name of the interface> dataBitsPerSymbol <width of the interface>
     dsp_add_streaming_interface in sink
     dsp_set_interface_property in associatedClock clk
     add_interface_port in load valid Input 1
     add_interface_port in ready ready Output 1
     add_interface_port in sop_in startofpacket Input 1
     add_interface_port in eop_in endofpacket Input 1
     dsp_set_interface_property in dataBitsPerSymbol $DATA_WIDTH
     set fraglist_in       [list ]    
     lappend fraglist_in  data_in $DATA_WIDTH
     # Then call the function to add the ports in the list to the interface.
     # dsp_add_interface_port <name of the interface> <display name of the combined ports> <type> <direction> <width of the combined ports> <list of ports>
     dsp_add_interface_port in sink_data data Input $DATA_WIDTH $fraglist_in


     # Same as above, this time we add an Avalon ST interface for output port(s)
     dsp_add_streaming_interface out source
     dsp_set_interface_property out associatedClock clk
     add_interface_port out valid_out valid Output 1
     add_interface_port out sink_ready ready Input 1
     add_interface_port out sop_out startofpacket Output 1
     add_interface_port out eop_out endofpacket Output 1
     dsp_set_interface_property out dataBitsPerSymbol [expr $DATA_WIDTH+8]
     set fraglist_out       [list ]    
     lappend fraglist_out data_out [expr $DATA_WIDTH] number_errors 8
     dsp_add_interface_port out source_data data Output [expr $DATA_WIDTH+8] $fraglist_out 

   }


}




# -----------------------------------------------------
# Example Fileset Generates: (in order)
#                             A SystemVerilog Test program
#                             Test stimuli
#                             SystemVerilog Bus Functional models to drive the simulation
#                             Simulation scripts for the simulators using ip-make-simscript
# -----------------------------------------------------
proc example_fileset {output_name} {

   set cwd [pwd]

   set bch_type [get_parameter_value BCH] 
   if {$bch_type eq "Encoder"} {
     set bch_type "enc"
   } else {
     set bch_type "dec"
   }

   # STEP 1: Generate Test Program
   send_message INFO "Generating Test Program"
   set source_files_path src
   set template_path "bch_${bch_type}/src/testbench/bch_${bch_type}_testbench.sv.terp"
   set terp_contents [render_terp $output_name 0 $template_path ]
   set test_program_file "${output_name}_test_program.sv" 
   add_fileset_file "[file join $source_files_path $test_program_file]" [filetype $test_program_file] TEXT $terp_contents


   # STEP 2: Generate Test Data
   send_message INFO "Generating Test Data"
   set test_data_dir    [create_temp_file ""]
   generate_test_data_bch_${bch_type} $test_data_dir


   # STEP 3: Generate Testbenching System
   send_message INFO "Generating Testbench System"
   set family "[get_parameter_value selected_device_family]"
   set bch_example_name "core" 
   set qsys_system "${output_name}.qsys"

   # Generate the testbench files
   set temp_dir  [create_temp_file ""]
   file mkdir $temp_dir
   cd $temp_dir

   set script_name "$temp_dir/${output_name}.tcl"
   set sim_script_name "$temp_dir/${output_name}_tmp.spd"
   set sim_script [open $sim_script_name w+]


   set f_handle [open $script_name w+]

   puts $f_handle    "package require -exact qsys 14.0"
   puts $f_handle    "set_project_property DEVICE_FAMILY \"${family}\""
   puts $f_handle    "add_instance ${bch_example_name} altera_bch"
   foreach param [lsort [get_parameters]] {
      if {[get_parameter_property $param DERIVED] == 0} {
         #Screen for design environment, only QSYS flow is supported, because Native steps all over the BFMs by creating conduits
         if { $param ne "design_env" } { 
            puts $f_handle "set_instance_parameter_value $bch_example_name $param \"[get_parameter_value $param]\""
         } else {
            puts $f_handle "set_instance_parameter_value $bch_example_name $param \"QSYS\""

         }
      }
   }
   puts $f_handle    "add_interface ${bch_example_name}_rst reset sink"
   puts $f_handle    "set_interface_property ${bch_example_name}_rst EXPORT_OF ${bch_example_name}.rst"
   puts $f_handle    "add_interface ${bch_example_name}_clk clock sink"
   puts $f_handle    "set_interface_property ${bch_example_name}_clk EXPORT_OF ${bch_example_name}.clk"
   puts $f_handle    "add_interface ${bch_example_name}_sink avalon_sink sink"
   puts $f_handle    "set_interface_property ${bch_example_name}_in EXPORT_OF ${bch_example_name}.in"
   puts $f_handle    "add_interface ${bch_example_name}_source avalon_source source"
   puts $f_handle    "set_interface_property ${bch_example_name}_out EXPORT_OF ${bch_example_name}.out"
   puts $f_handle    "save_system ${qsys_system}"

   close $f_handle


   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-script"] 
   set cmd [list  $program --script=$script_name ]
   send_message INFO "Build qsys system:"
   send_message INFO "cmd = $cmd"
   set status [catch {exec {*}$cmd} err]

   

   #now use this qsys SYSTEM
   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-generate"] 
   set cmd "$program $qsys_system --testbench=STANDARD --testbench-simulation=VERILOG";
   send_message INFO "Generate simulation model from qsys system:"
   send_message INFO "cmd = $cmd"
   set status [catch {exec {*}$cmd} err]
   


   # The report varies based on whether its the new fileset or old.
   set filename "$temp_dir/${output_name}/${output_name}_generation.rpt"
   if { [file exists $filename ] == 0 } {
      set filename "$temp_dir/${output_name}_tb/${output_name}_generation.rpt"
   } 
   set pattern {ERROR:.*}
   set count 0

   set fid [open $filename r]
   while {[gets $fid line] != -1} {
       incr count [regexp -all -- $pattern $line]
   }
   close $fid



   # send_message INFO "$err"

   if {$count > 0} {
        send_message ERROR [get_string EXAMPLE_DESIGN_TB_ERROR]
   } else {
        send_message NOTE "BCH Example Testbench Generation Complete"
   }        


    set simulator_list { \
             {mentor   modelsim} \
             {aldec    riviera} \
             {synopsys vcs} \
             {cadence  ncsim} \
           }

    set test_file_dir [file join "${temp_dir}"]
    set all_files [get_all_file_abs $test_file_dir]
    foreach module [lsearch -inline -all -glob $all_files *] {
        if { [regexp  {.*(\.hex$)|(\.mif$)|(\.v$)|(\.vo$)|(\.vho$)} [file tail $module] ] == 1 } {
            set ext [filetype submodule]
            add_fileset_file [file join "src" [file tail $module]] $ext PATH $module
        }
        if { [regexp  {.*(\.sv$)|(\.vhd$)} [file tail $module] ] == 1 } {
            switch -glob $module {
               *.vhd    { set language VHDL}
               *.sv     { set language SYSTEM_VERILOG}
            }

            set added 0
            foreach simulator $simulator_list {
                set sim [lindex $simulator 0]
                # if it has encryption it will be located in the simulator sub-directory
                if {[string match *$sim*  $module ] == 1} {
                    add_fileset_file [file join "src/$sim" [file tail $module]] ${language}_ENCRYPT PATH $module [string toupper $sim]_SPECIFIC
                    set added 1
                    break
                }
            }
            if {!$added} {
                add_fileset_file [file join "src" [file tail $module]] $language PATH $module
            }
        }
    }
   # set file_tails {} 
   # foreach full_name $all_files {
   #     lappend file_tails [file tail $full_name]   
   # } 
   # set all_files      [lsort -unique $file_tails]

    #set all_tails {}
    set packages {}
    set top_files {}
    set generic_files {}
    set memory_files {}

    foreach cur_file $all_files {
        if { [regexp  {.*(tb\.)(v|(sv)|(vhd))} $cur_file ] == 1 } {
            lappend top_files $cur_file
        } elseif { [regexp  {.*((\.vo)|(\.vho)|(pack\.vhd)|(pkg\.v)|(pkg\.sv)|(pkg\.vhd))} $cur_file] == 1 } {
            lappend packages $cur_file
        } elseif { [regexp  {.*\.(v|(sv)|(vhd))} $cur_file] == 1 } {
            if {[regexp  {.*((_inst\.)|(_bb\.))(v|(sv)|(vhd))} $cur_file ] == 0} {
                lappend generic_files $cur_file
            }
        } elseif { [regexp  {.*\.((hex)|(mif))}  $cur_file] == 1 } {
            lappend memory_files $cur_file
        }
    }

   #set packages [lsort -ascii -decreasing $packages]



    # reordering the generic file 
    set generic_files_temp $generic_files
    if {[string match $bch_type "dec"]} {
        set priority_files {bchp_parameters.vhd bchp_functions.vhd bchp_parameters.vhd  bchp_package.vhd bchp_auto_package.vhd bchp_roots.vhd}
    } else {
        set priority_files {bch_enc_package.vhd}
    }

    set priority_file_list [list ]

    foreach priority_file $priority_files {
        foreach current_file $generic_files_temp {
            if {[string match -nocase [file tail $current_file]  $priority_file]} {
                # add the file to the priority list
                lappend priority_file_list $current_file
                set pos [lsearch $generic_files $current_file]
                # remove the file to the generic_files
                set generic_files [lreplace $generic_files $pos $pos]
            }
        }
    }

    #puting the package files first
    set rtl_files [concat $packages $priority_file_list $generic_files]



   # STEP 4: Generating simulation scripts
   send_message INFO "Generating Simulation Scripts"

   #set the spd
   puts $sim_script "<simPackage>"
   set library "work"

   foreach file $rtl_files {
      if { [lsearch $all_files $file] != -1 } {
         # remove the current element from the list
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         if { [string match -nocase SYSTEM_VERILOG $file_type]==1 || [string match -nocase VHDL $file_type]==1 } { 
            set added 0
            foreach simulator $simulator_list {
                set sim [lindex $simulator 0]
                set tool [lindex $simulator 1]
                if {[string match *$sim*  $file ] == 1} {
                    set file_name [file join $source_files_path $sim [file tail $file]]
                    puts $sim_script [convert_to_spd_xml  $file_name ${file_type}_ENCRYPT $library $tool]
                    set added 1
                    break
                } 
            }
            if {!$added} {
                set file_name [file join $source_files_path [file tail $file]]
                puts $sim_script [convert_to_spd_xml  $file_name $file_type $library ""]
            }
         } else { 
             set file_name [file join $source_files_path [file tail $file]]
             puts $sim_script [convert_to_spd_xml  $file_name $file_type $library ""]
         }
      }
   }

   foreach file $memory_files {
      if { [lsearch $all_files $file] != -1 } {
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         set file_name [file join $source_files_path [file tail $file]]
         puts $sim_script [convert_to_spd_xml  $file_name "Memory" $library]
      }
   }
   foreach file $top_files {
      set file_type [filetype $file]
      set file_name [file join $source_files_path [file tail $file]]
      puts $sim_script [convert_to_spd_xml  $file_name $file_type $library]
   }

   #Add the top level 
   set file_name [file join $source_files_path $test_program_file]
   set file_type [filetype $file_name]
   puts $sim_script [convert_to_spd_xml  $file_name $file_type $library]


   #add input files
   set input_files [glob -directory $test_data_dir  -tails *{.txt}]
   foreach file $input_files {
      set file_type "Memory"
      set file_name [file tail $file]
      puts $sim_script [convert_to_spd_xml  [file join "test_data" $file_name] $file_type 0]
   }
   puts $sim_script "<topLevel name=\"test_program\"/>"
   puts $sim_script "<deviceFamily name=\"[get_parameter_value selected_device_family]\"/>"
   puts $sim_script "</simPackage>"
   close $sim_script

   file mkdir "sim_scripts"
   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "ip-make-simscript"] 
   set cmd [list  $program --spd=$sim_script_name --use-relativepaths --output_directory=[file join [pwd] "sim_scripts"]]
   send_message INFO "Make simulation scripts:"
   send_message INFO "cmd = $cmd"
   set status [catch {exec {*}$cmd} err]
   send_message INFO "$err"
   set root     [file join [pwd] "sim_scripts" ] 
   add_files_recursive $root

   cd $cwd

}

proc filetype { file_name } {
   switch -glob $file_name {
      *.vhd {     return VHDL}
      *.v {       return VERILOG}
      *.sv {      return SYSTEM_VERILOG}
      *.svo {     return SYSTEM_VERILOG}
      *.vho {     return VHDL}
      *.vo {      return VERILOG}
      default {   return OTHER }
   }
}

