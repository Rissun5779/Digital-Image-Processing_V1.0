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




#These are helper functions to manipulate file paths as you would like, each returns what their name suggests



proc file_name {full_file_path} {
    set list_of_path [split $full_file_path "/" ]
    return   [lindex $list_of_path end]
}

proc file_path {full_file_path} {
    set list_of_full_path [split $full_file_path "/"]
    set list_of_path [lreplace $list_of_full_path end end]
    return [join $list_of_path "/"]
}
proc extension {full_file_path} {
    set list_of_path [split $full_file_path "."]
    return   [lindex $list_of_path end]
}

proc file_type {full_file_path} {
    set extension_value [extension $full_file_path] 
    if {[string toupper $extension_value] eq "VHD"} {
        return "VHDL_ENCRYPT"
    } elseif {[string toupper $extension_value] eq "V"} {
        return "SYSTEM_VERILOG_ENCRYPT"
    } elseif {[string toupper $extension_value] eq "SV"} {
        return "SYSTEM_VERILOG_ENCRYPT"
    } else {
        return "OTHER"
    }
}
