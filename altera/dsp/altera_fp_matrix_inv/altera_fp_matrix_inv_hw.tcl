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
load_strings altera_fp_matrix_inv.properties
source "../lib/tcl/dspip_common.tcl"

# |
# +-----------------------------------

# +-----------------------------------
# | module Altera_fp_matrix_inv
# |
set_module_property NAME altera_fp_matrix_inv
set_module_property AUTHOR [get_string AUTHOR]
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP [get_string GROUP]
set_module_property DISPLAY_NAME "ALTERA_FP_MATRIX_INV"
set_module_property DESCRIPTION [get_string DESCRIPTION]
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
set_module_property HIDE_FROM_QSYS TRUE
set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10} {Stratix 10}
}



## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1410764818924/eis1410936966508 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408



proc send_message_from_strings {type id} {
    set message [get_string $id]
    send_message $type [uplevel [list subst -nocommands $message]]
}

###################### Parameters 

# Floating Point Parameters

add_parameter MATRIX_SIZE INTEGER 64
set_parameter_property MATRIX_SIZE DISPLAY_NAME [get_string MATRIX_SIZE_NAME ]
set_parameter_property MATRIX_SIZE VISIBLE true
set_parameter_property MATRIX_SIZE DESCRIPTION [get_string MATRIX_SIZE_DESCRIPTION]
set_parameter_property MATRIX_SIZE AFFECTS_GENERATION true
set_parameter_property MATRIX_SIZE ALLOWED_RANGES [get_string MATRIX_SIZE_PARAMETER]
set_parameter_property MATRIX_SIZE GROUP [get_string FLOATING_PT_DATA_GROUP]

add_parameter BLOCK_SIZE INTEGER 16
set_parameter_property BLOCK_SIZE DISPLAY_NAME [get_string BLOCK_SIZE_NAME ]
set_parameter_property BLOCK_SIZE DESCRIPTION [get_string BLOCK_SIZE_DESCRIPTION]
set_parameter_property BLOCK_SIZE AFFECTS_GENERATION true
set_parameter_property BLOCK_SIZE GROUP [get_string FLOATING_PT_DATA_GROUP]
set_parameter_property BLOCK_SIZE ALLOWED_RANGES {2 4 8 16}

# Optional Port Parameters
add_parameter RESET_PORT INTEGER 0
set_parameter_property RESET_PORT DISPLAY_NAME [get_string RESET_PORT_DISPLAY_NAME ]
set_parameter_property RESET_PORT DESCRIPTION [get_string RESET_PORT_DESCRIPTION]
set_parameter_property RESET_PORT DISPLAY_HINT boolean
set_parameter_property RESET_PORT AFFECTS_GENERATION true
set_parameter_property RESET_PORT GROUP [get_string OPTIONAL_PORTS_GROUP]

add_parameter ENABLE_PORT INTEGER 0
set_parameter_property ENABLE_PORT DISPLAY_NAME [get_string ENABLE_PORT_DISPLAY_NAME ]
set_parameter_property ENABLE_PORT DESCRIPTION [get_string ENABLE_PORT_DESCRIPTION]
set_parameter_property ENABLE_PORT DISPLAY_HINT boolean
set_parameter_property ENABLE_PORT AFFECTS_GENERATION true
set_parameter_property ENABLE_PORT GROUP [get_string OPTIONAL_PORTS_GROUP]





#Add all parameters

add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}




proc generate_all {output_name language} \
{
    if { $language eq "VERILOG" } {
        set ext ".v"
    } else {
        set ext ".vhd"
    }
    set matrix_size   [get_parameter_value matrix_size]
    set block_size    [get_parameter_value block_size]
    set reset_port    [get_parameter_value reset_port]
    set enable_port   [get_parameter_value enable_port]
    set device_family [get_parameter_value selected_device_family]
    set cur_dir [pwd]
    set temp_dir [create_temp_file ""]
    file mkdir $temp_dir
    cd $temp_dir

    lappend CBX_ARGUMENTS "ALTFP_MATRIX_INV"
    lappend CBX_ARGUMENTS "CBX_AUTO_BLACKBOX=ALL"
    if {$matrix_size < 16 } {
        lappend CBX_ARGUMENTS "BLOCKS=2"
    } else {
        lappend CBX_ARGUMENTS "BLOCKS=${block_size}"
    }
    lappend CBX_ARGUMENTS "DIMENSION=${matrix_size}"
    lappend CBX_ARGUMENTS "CBX_OUTPUT_DIRECTORY=${temp_dir}"
    lappend CBX_ARGUMENTS "CBX_FILE=${output_name}${ext}"
    lappend CBX_ARGUMENTS "DEVICE_FAMILY=${device_family}"
    lappend CBX_ARGUMENTS "CBX_FORCE_HDL_GENERATION=ON"
    lappend CBX_ARGUMENTS "OUTPUT_SUFFIX=$output_name"

    lappend PORT_LIST "datain"
    lappend PORT_LIST "dataout"
    lappend PORT_LIST "load"
    lappend PORT_LIST "sysclk"
    lappend PORT_LIST "busy"
    lappend PORT_LIST "outvalid"
    lappend PORT_LIST "done"
    if { $reset_port == 1 } {
        lappend PORT_LIST "reset"
    }
    if { $enable_port == 1 } {
        lappend PORT_LIST "enable"
    }



     set program "clearbox"

    set cmd [list  $program  {*}$CBX_ARGUMENTS {*}$PORT_LIST ]
    send_message INFO "Launching RTL Generator"
    send_message DEBUG "$cmd"
    set status [catch {exec {*}$cmd } err]

    if { [string match -nocase "*error*" $err] == 1 } {
        send_message ERROR "$err"
    }
    
    # File dependencies happen to be alphabetical
    set input_files [lsort [glob -directory $temp_dir  -tails  "*$ext" ] ] 
    foreach cur_file $input_files {
        send_message INFO "Adding $cur_file"
        add_fileset_file $cur_file $language PATH "${temp_dir}${cur_file}"
    }
    cd $cur_dir
}



proc generate_quartus_synth {output_name} {  
    generate_all $output_name "VERILOG"
}
proc generate_sim_verilog {output_name} {  
    generate_all $output_name "VERILOG"
}
proc generate_sim_vhdl {output_name} {  
    generate_all $output_name "VHDL"
}




proc add_filesets {} {
    foreach fileset {quartus_synth sim_verilog sim_vhdl} {
        add_fileset $fileset [string toupper $fileset] "generate_$fileset" 
    }
}

add_filesets



proc get_simulator_list {} {
    return { \
       {mentor   0   } \ #0
       {aldec    0    } \ #0
       {synopsys 0 } \ #0
       {cadence  0  } \ #0
   }
}

# | 
# +-----------------------------------












proc elaborate {} {
    set matrix_size   [get_parameter_value matrix_size]
    set block_size    [get_parameter_value block_size]
    set reset_port    [get_parameter_value reset_port]
    set enable_port   [get_parameter_value enable_port]
    set device_family [get_parameter_value selected_device_family]


    lappend IN_PORT "datain"
    lappend OUT_PORT "dataout"
    lappend IN_PORT "load"
    lappend IN_PORT "sysclk"
    lappend OUT_PORT "busy"
    lappend OUT_PORT "outvalid"
    lappend OUT_PORT "done"
    if { $reset_port == 1 } {
        lappend IN_PORT "reset"
    }
    if { $enable_port == 1 } {
        lappend IN_PORT "enable"
    }

    foreach cur_port $OUT_PORT {
        add_interface $cur_port conduit output
        if { $cur_port == "dataout"} {
            add_interface_port $cur_port $cur_port conduit output 32
        } else {
            add_interface_port $cur_port $cur_port conduit output 1
        }
    }
    foreach cur_port $IN_PORT {
        add_interface $cur_port conduit input 
        if { $cur_port == "datain"} {
            add_interface_port $cur_port $cur_port conduit input 32
        } else {
            add_interface_port $cur_port $cur_port conduit input 1
        }
    }





}



proc validate {} {
    set matrix_size   [get_parameter_value matrix_size]
    set block_size    [get_parameter_value block_size]
    set reset_port    [get_parameter_value reset_port]
    set enable_port   [get_parameter_value enable_port]

    if {$matrix_size < 16 } {
        set_parameter_property BLOCK_SIZE VISIBLE false
    } else {
        set_parameter_property BLOCK_SIZE VISIBLE true
        if {$matrix_size == 16} {
            set range "2 or 4"
            if { $block_size != 2 && $block_size != 4 } {
                send_message_from_strings error BLOCK_ERROR
            }
        } elseif {$matrix_size == 32} {
            set range "4 or 8"
            if { $block_size != 4 && $block_size != 8 } {
                send_message_from_strings error BLOCK_ERROR
            }
        } elseif {$matrix_size == 64} {
            set range "8 or 16"     
            if { $block_size != 8 && $block_size != 16 } {
                send_message_from_strings error BLOCK_ERROR
            }
        }
    }
}   


