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


proc get_peripheral_location {part atom peripheral_index} {
    load_package advanced_device

    load_device -part $part
    load_die_info

    set gids [get_die_gids -element $atom]
    set gid  [lindex $gids $peripheral_index]
    set location [get_die_data -gid $gid STRING_LOCATION]
    return $location
}

proc get_pad_to_pin_name {part} {
    
    load_package advanced_device
    load_device -part $part

    set pad_pin_name_map {}

    set pin_count [get_pkg_data INT_PIN_COUNT]
    
    for {set pin 0} {$pin < $pin_count} {incr pin} {
 
        if { [get_pkg_data -pin $pin BOOL_IS_BONDED]} {

            set pad [lindex [get_pkg_data -pin $pin LIST_PAD_IDS] 0]
                
            set valid_keys [get_pad_data_keys STRING -pad $pad]
            if { [lsearch $valid_keys STRING_HPS_PERIPHERY_SELECT] != -1 } {
                lappend pad_pin_name_map $pad
                lappend pad_pin_name_map [get_pkg_data STRING_USER_PIN_NAME -pin $pin] 
            }
        }
    }
        
    return $pad_pin_name_map
}


proc get_pinmux_data {part} {
    load_package advanced_device
    load_device -part $part

    set pad_pinmux_map {}
    set pad_count [get_pad_data INT_PAD_COUNT]

    for {set pad 0} {$pad < $pad_count} {incr pad} {

        set is_hps_pad 0
        set valid_keys [get_pad_data_keys BOOL -pad $pad]
        if { [lsearch $valid_keys BOOL_IS_HPS_PAD] != -1 } {
            set is_hps_pad  [get_pad_data BOOL_IS_HPS_PAD -pad $pad]
        }
        
        set pinmux_info "DDR"
        set valid_keys [get_pad_data_keys STRING -pad $pad]
        if { [lsearch $valid_keys STRING_HPS_PERIPHERY_SELECT] != -1 } {
            set pinmux_info [get_pad_data STRING_HPS_PERIPHERY_SELECT -pad $pad]
        }
        
        if {$is_hps_pad} {
            lappend pad_pinmux_map $pad 
            lappend pad_pinmux_map $pinmux_info
        }
    }
    
    return $pad_pinmux_map 
}