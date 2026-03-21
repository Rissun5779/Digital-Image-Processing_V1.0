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
load_strings altera_fp_matrix_mult.properties

# |
# +-----------------------------------

# +-----------------------------------
# | module Altera_fp_matrix_mult
# |
set_module_property NAME altera_fp_matrix_mult
set_module_property AUTHOR [get_string AUTHOR]
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP [get_string GROUP]
set_module_property DISPLAY_NAME "ALTERA_FP_MATRIX_MULT"
set_module_property DESCRIPTION [get_string DESCRIPTION]
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
set_module_property HIDE_FROM_QSYS TRUE
set_module_property HIDE_FROM_QUARTUS TRUE
set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10}
}
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1410764818924/eis1410936966508 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408




proc send_message_from_strings {type id} {
    set message [get_string $id]
    send_message $type [uplevel [list subst -nocommands $message]]
}

###################### Parameters 

# Floating Point Parameters

add_parameter PRECISION string "SINGLE"
set_parameter_property PRECISION DISPLAY_NAME [get_string PRECISION_DISPLAY_NAME ]
set_parameter_property PRECISION UNITS None
set_parameter_property PRECISION DESCRIPTION [get_string PRECISION_DESCRIPTION]
set_parameter_property PRECISION ALLOWED_RANGES [list "SINGLE:[get_string PRECISION_FLOAT_NAME]" "DOUBLE:[get_string PRECISION_DOUBLE_NAME]"]
set_parameter_property PRECISION AFFECTS_GENERATION true
set_parameter_property PRECISION GROUP [get_string FLOATING_PT_DATA_GROUP]

add_parameter VECTOR_SIZE INTEGER 8
set_parameter_property VECTOR_SIZE DISPLAY_NAME [get_string VECTOR_SIZE_NAME ]
set_parameter_property VECTOR_SIZE DESCRIPTION [get_string VECTOR_SIZE_DESCRIPTION]
set_parameter_property VECTOR_SIZE AFFECTS_GENERATION true
set_parameter_property VECTOR_SIZE GROUP [get_string MATRIX_FORMAT_GROUP]

add_parameter BLOCK_SIZE INTEGER 2
set_parameter_property BLOCK_SIZE DISPLAY_NAME [get_string BLOCK_SIZE_NAME ]
set_parameter_property BLOCK_SIZE DESCRIPTION [get_string BLOCK_SIZE_DESCRIPTION]
set_parameter_property BLOCK_SIZE AFFECTS_GENERATION true
set_parameter_property BLOCK_SIZE GROUP [get_string MATRIX_FORMAT_GROUP]

add_parameter AA_COLUMNS INTEGER 8
set_parameter_property AA_COLUMNS DISPLAY_NAME [get_string AA_COLUMNS_NAME ]
set_parameter_property AA_COLUMNS DESCRIPTION [get_string AA_COLUMNS_DESCRIPTION]
set_parameter_property AA_COLUMNS AFFECTS_GENERATION true
set_parameter_property AA_COLUMNS GROUP [get_string MATRIX_FORMAT_GROUP]

add_parameter AA_ROWS INTEGER 8
set_parameter_property AA_ROWS DISPLAY_NAME [get_string AA_ROWS_NAME ]
set_parameter_property AA_ROWS DESCRIPTION [get_string AA_ROWS_DESCRIPTION]
set_parameter_property AA_ROWS AFFECTS_GENERATION true
set_parameter_property AA_ROWS GROUP [get_string MATRIX_FORMAT_GROUP]

add_parameter BB_COLUMNS INTEGER 8
set_parameter_property BB_COLUMNS DISPLAY_NAME [get_string BB_COLUMNS_NAME ]
set_parameter_property BB_COLUMNS DESCRIPTION [get_string BB_COLUMNS_DESCRIPTION]
set_parameter_property BB_COLUMNS AFFECTS_GENERATION true
set_parameter_property BB_COLUMNS GROUP [get_string MATRIX_FORMAT_GROUP]



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
    set precision     [get_parameter_value PRECISION]
    set vector_size   [get_parameter_value VECTOR_SIZE]
    set block_size    [get_parameter_value BLOCK_SIZE]
    set aa_columns    [get_parameter_value AA_COLUMNS]
    set aa_rows       [get_parameter_value AA_ROWS]
    set bb_columns    [get_parameter_value BB_COLUMNS]
    set reset_port    [get_parameter_value RESET_PORT]
    set enable_port   [get_parameter_value ENABLE_PORT]

    set exponent 11
    set mantisaa 52
    if { $precision eq "SINGLE" } {
        set exponent 8
        set mantisaa 23
    }

    set device_family [get_parameter_value selected_device_family]
    set temp_dir [create_temp_file ""]
    set cur_dir [pwd]
    file mkdir $temp_dir
    cd $temp_dir

    lappend CBX_ARGUMENTS "ALTFP_MATRIX_MULT"
    lappend CBX_ARGUMENTS "CBX_AUTO_BLACKBOX=ALL"
    lappend CBX_ARGUMENTS "CBX_OUTPUT_DIRECTORY=${temp_dir}"
    lappend CBX_ARGUMENTS "CBX_FILE=${output_name}${ext}"
    lappend CBX_ARGUMENTS "DEVICE_FAMILY=${device_family}"
    lappend CBX_ARGUMENTS "OUTPUT_SUFFIX=$output_name"


    lappend CBX_ARGUMENTS "BLOCKS=${block_size}"
    lappend CBX_ARGUMENTS "COLUMNSAA=${aa_columns}"
    lappend CBX_ARGUMENTS "COLUMNSBB=${bb_columns}"
    lappend CBX_ARGUMENTS "ROWSAA=${aa_rows}"
    lappend CBX_ARGUMENTS "VECTORSIZE=${vector_size}"
    lappend CBX_ARGUMENTS "WIDTH_EXP=${exponent}"
    lappend CBX_ARGUMENTS "WIDTH_MAN=${mantisaa}"



    lappend PORT_LIST "loaddata"
    lappend PORT_LIST "calcmatrix"
    lappend PORT_LIST "loadaa"
    lappend PORT_LIST "loadbb"
    lappend PORT_LIST "sysclk"
    lappend PORT_LIST "outdata"
    lappend PORT_LIST "ready"
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
    set precision     [get_parameter_value PRECISION]
    set vector_size   [get_parameter_value VECTOR_SIZE]
    set block_size    [get_parameter_value BLOCK_SIZE]
    set aa_columns    [get_parameter_value AA_COLUMNS]
    set aa_rows       [get_parameter_value AA_ROWS]
    set bb_columns    [get_parameter_value BB_COLUMNS]
    set reset_port    [get_parameter_value RESET_PORT]
    set enable_port   [get_parameter_value ENABLE_PORT]
    set data_width 64
    if { $precision eq "SINGLE" } {
        set data_width 32
    }

    lappend IN_PORT "loaddata"
    lappend IN_PORT "calcmatrix"
    lappend IN_PORT "loadaa"
    lappend IN_PORT "loadbb"
    lappend IN_PORT "sysclk"
    lappend OUT_PORT "outdata"
    lappend OUT_PORT "ready"
    lappend OUT_PORT "outvalid"
    lappend OUT_PORT "done"

    if { $reset_port == 1 } {
        lappend IN_PORT "reset"
    }
    if { $enable_port == 1 } {
        lappend IN_PORT "enable"
    }

    foreach cur_port $OUT_PORT {
        add_interface $cur_port conduit end
        set_interface_property $cur_port EXPORT_OF $cur_port
        if { $cur_port == "outdata"} {
            add_interface_port $cur_port $cur_port conduit output $data_width
        } else {
            add_interface_port $cur_port $cur_port conduit output 1
        }
    }
    foreach cur_port $IN_PORT {
        add_interface $cur_port conduit start 
        set_interface_property $cur_port EXPORT_OF $cur_port
        if { $cur_port == "loaddata"} {
            add_interface_port $cur_port $cur_port conduit input $data_width
        } else {
            add_interface_port $cur_port $cur_port conduit input 1
        }
    }





}

proc send_message_from_strings {type id} {
    set message [get_string $id]
    send_message $type [uplevel [list subst -nocommands $message]]
}

proc validate {} {
    set precision     [get_parameter_value PRECISION]
    set vector_size   [get_parameter_value VECTOR_SIZE]
    set block_size    [get_parameter_value BLOCK_SIZE]
    set aa_columns    [get_parameter_value AA_COLUMNS]
    set aa_rows       [get_parameter_value AA_ROWS]
    set bb_columns    [get_parameter_value BB_COLUMNS]
    set reset_port    [get_parameter_value RESET_PORT]
    set enable_port   [get_parameter_value ENABLE_PORT]
    set ratio [expr (1.0*$vector_size/(2*$block_size))]

    if { $block_size % 2 != 0 || $block_size > 48 || $block_size < 2} {
        send_message_from_strings ERROR BLOCK_SIZE_INVALID_MSG
    } elseif { ($ratio < 2 || $ratio > 6) || ($ratio != floor($ratio)) } {
        send_message_from_strings ERROR INCORRECT_RATIO_MSG
    } elseif { $aa_columns % (2*$block_size) != 0 } {
        send_message_from_strings ERROR COLUMNSAA_MOD_NOT_ZERO_MSG
    } elseif { $aa_rows*$aa_columns > $block_size*2048 } {
        send_message_from_strings ERROR MATRIX_TOO_LARGE_MSG
    } elseif { ($aa_columns % $vector_size) != 0 } {
        send_message_from_strings ERROR INCORRECT_MOD_VALUE_MSG
    } elseif { ($aa_rows * $bb_columns  > 512*$vector_size)} {
        send_message_from_strings ERROR MATRIX_BB_TOO_LARGE_MSG
     } elseif { ($bb_columns  < $block_size )} {
         send_message_from_strings ERROR MATRIX_DIMENSIONS_MSG
     } elseif { ($aa_rows  < $block_size )} {
         send_message_from_strings ERROR MATRIX_DIMENSIONS_MSG
     }

}   

