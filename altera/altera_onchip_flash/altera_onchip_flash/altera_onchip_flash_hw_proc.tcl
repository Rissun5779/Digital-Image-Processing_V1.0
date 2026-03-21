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


# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/altera_onchip_flash/altera_onchip_flash/altera_onchip_flash_hw_proc.tcl#1 $
# | 
# +-----------------------------------

# +-----------------------------------
# | Global value
# +-----------------------------------
set selected_device_family "Unknown"
set selected_device "Unknown"
set selected_family_code "Unknown"
set selected_device_code "Unknown"
set selected_supply_code "Unknown"      
set selected_feature_code "Unknown"
set selected_interface_mode "Unknown"
set selected_virtual_zb2 0

set all_sectors [list SECTOR1 SECTOR2 SECTOR3 SECTOR4 SECTOR5]
set total_sectors [llength $all_sectors]

set sector_id_list []
set sector_addr_mapping_list []
set sector_storage_type_list []
set sector_start_addr_list []
set sector_end_addr_list []


# Regular expression to parse device name
# parameter #1 - family_code
# parameter #2 - device_code
# parameter #3 - feature_code
array set device_name_pattern {
    "MAX 10"     "^(10M)(\\d+)([SD])([CFA]).(\\d+)"
}

# Sector size in Kbits (1K=1024 bits) - key format is <device family>_<sector>
# | Sector 1 - UFM1
# | Sector 2 - UFM0
# | Sector 3 - CFM2
# | Sector 4 - CFM1
# | Sector 5 - CFM0
array set device_sector_size {
    # ZB1
    "10M01_SECTOR2" "48"
    "10M01_SECTOR5" "544"
    # ZB2
    "10M02_SECTOR1"    "48"
    "10M02_SECTOR2"    "48"
    "10M02_SECTOR5"    "544"
    # ZB2
    "10M02SC324_SECTOR1"    "48"
    "10M02SC324_SECTOR2"    "48"
    "10M02SC324_SECTOR5"    "544"
    # ZB4
    "10M04_SECTOR2"    "128"
    "10M04_SECTOR3"    "656"
    "10M04_SECTOR4"    "464"
    "10M04_SECTOR5"    "1120"
    # ZB8
    "10M08_SECTOR1"    "128"
    "10M08_SECTOR2"    "128"
    "10M08_SECTOR3"    "656"
    "10M08_SECTOR4"    "464"
    "10M08_SECTOR5"    "1120"
    # ZB16
    "10M16_SECTOR1"    "128"
    "10M16_SECTOR2"    "128"
    "10M16_SECTOR3"    "1216"
    "10M16_SECTOR4"    "896"
    "10M16_SECTOR5"    "2112"
    # ZB25
    "10M25_SECTOR1"    "128"
    "10M25_SECTOR2"    "128"
    "10M25_SECTOR3"    "1664"
    "10M25_SECTOR4"    "1280"
    "10M25_SECTOR5"    "2944"
    # ZB40
    "10M40_SECTOR1"    "256"
    "10M40_SECTOR2"    "256"
    "10M40_SECTOR3"    "3072"
    "10M40_SECTOR4"    "2304"
    "10M40_SECTOR5"    "5376"
    # ZB50
    "10M50_SECTOR1"    "256"
    "10M50_SECTOR2"    "256"
    "10M50_SECTOR3"    "3072"
    "10M50_SECTOR4"    "2304"
    "10M50_SECTOR5"    "5376"
}

# Sector address offset - key format is <device family>_<sector>
# | Sector 1 - UFM1
# | Sector 2 - UFM0
# | Sector 3 - CFM2
# | Sector 4 - CFM1
# | Sector 5 - CFM0
array set device_sector_address_offset {
    # ZB1
    "10M01_SECTOR2"    "0x800"
    "10M01_SECTOR5"    "0xE00"
    # ZB2
    "10M02_SECTOR1"    "0x200"
    "10M02_SECTOR2"    "0x800"
    "10M02_SECTOR5"    "0xE00"
    # ZB2
    "10M02SC324_SECTOR1"    "0x200"
    "10M02SC324_SECTOR2"    "0x1200"
    "10M02SC324_SECTOR5"    "0xAE00"
    # ZB4
    "10M04_SECTOR2"    "0x1200"
    "10M04_SECTOR3"    "0x2200"
    "10M04_SECTOR4"    "0x7400"
    "10M04_SECTOR5"    "0xAE00"
    # ZB8
    "10M08_SECTOR1"    "0x200"
    "10M08_SECTOR2"    "0x1200"
    "10M08_SECTOR3"    "0x2200"
    "10M08_SECTOR4"    "0x7400"
    "10M08_SECTOR5"    "0xAE00"
    # ZB16
    "10M16_SECTOR1"    "0x400"
    "10M16_SECTOR2"    "0x1400"
    "10M16_SECTOR3"    "0x2400"
    "10M16_SECTOR4"    "0xBC00"
    "10M16_SECTOR5"    "0x12C00"
    # ZB25
    "10M25_SECTOR1"    "0x400"
    "10M25_SECTOR2"    "0x1400"
    "10M25_SECTOR3"    "0x2400"
    "10M25_SECTOR4"    "0xF400"
    "10M25_SECTOR5"    "0x19400"
    # ZB40
    "10M40_SECTOR1"    "0x800"
    "10M40_SECTOR2"    "0x2800"
    "10M40_SECTOR3"    "0x4800"
    "10M40_SECTOR4"    "0x1C800"
    "10M40_SECTOR5"    "0x2E800"
    # ZB50
    "10M50_SECTOR1"    "0x800"
    "10M50_SECTOR2"    "0x2800"
    "10M50_SECTOR3"    "0x4800"
    "10M50_SECTOR4"    "0x1C800"
    "10M50_SECTOR5"    "0x2E800"
}

# Pre-define sector protect mode corresponding value
# | Sector 1 - UFM1 - 2 power of 0
# | Sector 2 - UFM0 - 2 power of 1
# | Sector 3 - CFM2 - 2 power of 2
# | Sector 4 - CFM1 - 2 power of 3
# | Sector 5 - CFM0 - 2 power of 4
array set device_sector_protection_mode {
    "SECTOR1"    "0x01"
    "SECTOR2"    "0x02"
    "SECTOR3"    "0x04"
    "SECTOR4"    "0x08"
    "SECTOR5"    "0x10"
}

# +-----------------------------------
# | Parameter callback
# +-----------------------------------

proc access_mode_change_callback {arg} {
    
    global total_sectors all_sectors

    array set sector_type_pair_list [get_sector_type_pair_filtered_by_configuration_mode]
    set supported_sectors [setup_supported_sector]
    set sector_access_modes [get_parameter_value SECTOR_ACCESS_MODE]
    set updated_sector_access_modes []
    
    set pre_cfm_mode "NONE"
    set pre_cfm_type "NONE"
    for {set i 0} {$i < $total_sectors} {incr i} {
        
        set sector [lindex $all_sectors $i]
        set mode [lindex $sector_access_modes $i]

        set cur_sector_index [lsearch $supported_sectors $sector]
        if {$cur_sector_index == -1} {
            lappend updated_sector_access_modes $mode
        } else {
            set type $sector_type_pair_list($sector)
            if {[regexp {UFM} $type match]} {
                lappend updated_sector_access_modes $mode
            } else {
                if {$pre_cfm_type == $type} {
                    lappend updated_sector_access_modes $pre_cfm_mode
                } else {
                    lappend updated_sector_access_modes $mode
                    set pre_cfm_mode $mode
                    set pre_cfm_type $type
                }
            }
        }
    }
    
    set_parameter_value SECTOR_ACCESS_MODE $updated_sector_access_modes
}

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------

proc get_sector_type_pair_filtered_by_configuration_mode {} {

    array set sector_type_pair_list {}
    set sector_type_pair_list(SECTOR1) "UFM"
    set sector_type_pair_list(SECTOR2) "UFM"
    
    set conf_scheme [get_parameter_value CONFIGURATION_SCHEME]
    set bool_dual_boot [get_parameter_value IS_DUAL_BOOT]
    set bool_eram_skip [get_parameter_value IS_ERAM_SKIP]
    set bool_compressed_image [get_parameter_value IS_COMPRESSED_IMAGE]
    
    if {$conf_scheme == "Active Serial"} {
        set sector_type_pair_list(SECTOR3) "UFM/CFM"
        set sector_type_pair_list(SECTOR4) "UFM/CFM"
        set sector_type_pair_list(SECTOR5) "CFM"
    } else {
        if {$bool_dual_boot} {
            set sector_type_pair_list(SECTOR3) "CFM (Image 2)"
            set sector_type_pair_list(SECTOR4) "CFM (Image 2)"
            set sector_type_pair_list(SECTOR5) "CFM (Image 1)"
        } elseif {!$bool_eram_skip} {
            set sector_type_pair_list(SECTOR3) "CFM"
            set sector_type_pair_list(SECTOR4) "CFM"
            set sector_type_pair_list(SECTOR5) "CFM"
        } else {
            if {$bool_eram_skip} {
                if {$bool_compressed_image} {
                    set sector_type_pair_list(SECTOR3) "UFM"
                    set sector_type_pair_list(SECTOR4) "UFM"
                    set sector_type_pair_list(SECTOR5) "CFM"
                } else {
                    set sector_type_pair_list(SECTOR3) "UFM"
                    set sector_type_pair_list(SECTOR4) "CFM"
                    set sector_type_pair_list(SECTOR5) "CFM"
                }
            } 
        }
    }
    
    return [array get sector_type_pair_list]
}

proc set_flash_protection_mode {} {

    global total_sectors device_sector_protection_mode
    global sector_id_list
    
    set sector_access_modes [get_parameter_value SECTOR_ACCESS_MODE]
    set sector_read_protection 0

    for {set i 0} {$i < $total_sectors} {incr i} {
    
        set is_protected 0

        set sector_id [expr ($i+1)]
        set sector_key "SECTOR${sector_id}"
        set sector_index [lsearch $sector_id_list $sector_id]

        if {$sector_index == -1} {
            # hidden sector
            set is_protected 1
        } else {
            # read only sector
            if {[lindex $sector_access_modes $sector_index] == "Read only"} {
                set is_protected 1
            }
        }
        
        if {$is_protected == 1} {
            incr sector_read_protection $device_sector_protection_mode($sector_key)
        }
    }
    
    set_parameter_value SECTOR_READ_PROTECTION_MODE $sector_read_protection
    
    set message [format "SECTOR_READ_PROTECTION_MODE - 0x%05x" [get_parameter_value SECTOR_READ_PROTECTION_MODE]]
    send_message debug $message
}

proc set_flash_sector_map {} {

    global total_sectors sector_id_list
    
    set sector_read_protection 0

    for {set i 0} {$i < $total_sectors} {incr i} {
    
        set sector_id [expr ($i+1)]
        set sector_key "SECTOR${sector_id}"
        set sector_index [lsearch $sector_id_list $sector_id]
            
        if {$sector_index != -1} {
            set_parameter_value "${sector_key}_MAP" [expr ($sector_index+1)]
        } else {
            set_parameter_value "${sector_key}_MAP" 0
        }
        
        send_message debug "${sector_key}_MAP = [get_parameter_value ${sector_key}_MAP]"
    }    
}

proc set_flash_address_offset {} {

    global total_sectors device_sector_address_offset
    global selected_family_code selected_device_code selected_supply_code selected_feature_code selected_virtual_zb2
    global sector_id_list sector_end_addr_list

    if {$selected_virtual_zb2 == 1} {
        set device_family_code "10M02SC324"
    } else {
        set device_family_code "${selected_family_code}${selected_device_code}"
    }

    set range1_first_sector_index -1
    set range1_last_sector_index -1
    set range2_first_sector_index -1
    set range2_last_sector_index -1
    set range3_first_sector_index -1
    set pre_sector_index 0
    if { $device_family_code == "10M02SC324"} {
        for {set i 0} {$i < $total_sectors} {incr i} {
    
                set sector_id [expr ($i+1)]
                set sector_key "SECTOR${sector_id}"
                set sector_index [lsearch $sector_id_list $sector_id]
                if {$sector_index != -1} {
                    if {$range1_first_sector_index == -1} {
                        set range1_first_sector_index $sector_index
                    } elseif {$range2_first_sector_index == -1} {
                        set range2_first_sector_index $sector_index
                    } elseif {$range3_first_sector_index == -1} {
                        set range3_first_sector_index $sector_index
                    }
                   if {$range1_last_sector_index == -1} {
                        set range1_last_sector_index $sector_index
                   } elseif {$range2_last_sector_index == -1} {
                        set range2_last_sector_index $sector_index
                   }
                }
            }
     } else {
    for {set i 0} {$i < $total_sectors} {incr i} {
    
        set sector_id [expr ($i+1)]
        set sector_key "SECTOR${sector_id}"
        set sector_index [lsearch $sector_id_list $sector_id]
            
        if {$sector_index != -1} {
            
            if {$range1_first_sector_index == -1} {
                set range1_first_sector_index $sector_index
            } else {
                if {$range1_last_sector_index == -1} {
                    if {[expr ($pre_sector_index+1)] != $sector_index} {
                        set range1_last_sector_index $pre_sector_index
                        set range2_first_sector_index $sector_index
                    }
                }
            }
            
            set pre_sector_index $sector_index
            }
        }
    }

    set sector_id [expr $range1_first_sector_index+1]
    set sector_key "${device_family_code}_SECTOR${sector_id}"
    set_parameter_value ADDR_RANGE1_OFFSET $device_sector_address_offset($sector_key)
    
    if {$range1_last_sector_index != -1} {
        set range1_end_addr [lindex $sector_end_addr_list $range1_last_sector_index]
    } else {
        set range1_end_addr [lindex $sector_end_addr_list $pre_sector_index]
    }
    set_parameter_value ADDR_RANGE1_END_ADDR $range1_end_addr
    
    if {$range2_last_sector_index != -1} {
        set range2_end_addr [lindex $sector_end_addr_list $range2_last_sector_index]
    } else {
        set range2_end_addr [lindex $sector_end_addr_list $pre_sector_index]
    }
    set_parameter_value ADDR_RANGE2_END_ADDR $range2_end_addr
    if {$range2_first_sector_index != -1} {
        set sector_id [expr $range2_first_sector_index+1]
        set sector_key "${device_family_code}_SECTOR${sector_id}"
        set_parameter_value ADDR_RANGE2_OFFSET [expr $device_sector_address_offset($sector_key) - $range1_end_addr - 1]
    }
    if {$range3_first_sector_index != -1} {
        set sector_id [expr $range3_first_sector_index+1]
        set sector_key "${device_family_code}_SECTOR${sector_id}"
        set_parameter_value ADDR_RANGE3_OFFSET [expr $device_sector_address_offset($sector_key) - $range2_end_addr - 1]
    }
    set message [format "0x%05x" [get_parameter_value ADDR_RANGE1_END_ADDR]]
    send_message debug "ADDR_RANGE1_END_ADDR    = $message"
    set message [format "0x%05x" [get_parameter_value ADDR_RANGE2_END_ADDR]]
    send_message debug "ADDR_RANGE2_END_ADDR    = $message"
    set message [format "0x%05x" [get_parameter_value ADDR_RANGE1_OFFSET]]
    send_message debug "ADDR_RANGE1_OFFSET = $message"
    set message [format "0x%05x" [get_parameter_value ADDR_RANGE2_OFFSET]]
    send_message debug "ADDR_RANGE2_OFFSET = $message"
    set message [format "0x%05x" [get_parameter_value ADDR_RANGE3_OFFSET]]
    send_message debug "ADDR_RANGE3_OFFSET = $message"
}

proc set_flash_min_max_address {} {

    global total_sectors device_sector_address_offset
    global selected_family_code selected_device_code
    global sector_id_list sector_storage_type_list sector_end_addr_list

    set device_family_code "${selected_family_code}${selected_device_code}"

    set_parameter_value MIN_VALID_ADDR 0
    set_parameter_value MIN_UFM_VALID_ADDR 0
    
    set max_addr 0
    set max_ufm_addr 0
    for {set i 0} {$i < $total_sectors} {incr i} {
    
        set sector_id [expr ($i+1)]
        set sector_key "SECTOR${sector_id}"
        set sector_index [lsearch $sector_id_list $sector_id]
            
        if {$sector_index != -1} {
            
            set max_addr [lindex $sector_end_addr_list $sector_index]
            if {[lindex $sector_storage_type_list $sector_index] == "UFM"} {
                set max_ufm_addr $max_addr
            }
        }
    }
    set_parameter_value MAX_VALID_ADDR $max_addr
    set_parameter_value MAX_UFM_VALID_ADDR $max_ufm_addr
    
    # set min and max available address, including UFM and CFM
    set min_addr_value [get_parameter_value MIN_VALID_ADDR]
    set max_addr_value [get_parameter_value MAX_VALID_ADDR]
    # print BYTE-based address, this is the common unit in QSYS
    set message [format "Available address range: (0x%X, 0x%X)" $min_addr_value [expr ($max_addr_value*4)+3]]
    send_message debug "$message"

    # set min and max available address, including UFM
    set min_ufm_addr_value [get_parameter_value MIN_UFM_VALID_ADDR]
    set max_ufm_addr_value [get_parameter_value MAX_UFM_VALID_ADDR]
    # print BYTE-based address, this is the common unit in QSYS
    set message [format "Available ufm address range: (0x%X, 0x%X)" $min_ufm_addr_value [expr ($max_ufm_addr_value*4)+3]]
    send_message debug "$message"

    # calculate data address bus size
    set explicit_address_span [expr ($max_addr_value-$min_addr_value)]    
    binary scan [binary format I* $explicit_address_span] B* end_address_binary
    set end_address_binary [string range $end_address_binary [string first "1" $end_address_binary] [string length $end_address_binary]]
    set end_address_binary_size [string length $end_address_binary]
    set_parameter_value AVMM_DATA_ADDR_WIDTH $end_address_binary_size

    # set the address span on the avmm slave interface in BYTE-based.
    set explicit_byte_address_span [expr ($explicit_address_span+1)*4]
    set_interface_property data explicitAddressSpan $explicit_byte_address_span
    set message [format "explicit_byte_address_span = %d (0x%0X)" $explicit_byte_address_span $explicit_byte_address_span]
    send_message debug "$message"    
}

proc set_flash_start_end_address {} {

    global total_sectors sector_id_list sector_start_addr_list sector_end_addr_list
    
    for {set i 0} {$i < $total_sectors} {incr i} {
    
        set sector_id [expr ($i+1)]
        set sector_key "SECTOR${sector_id}"
        set sector_index [lsearch $sector_id_list $sector_id]

        set param_start "${sector_key}_START_ADDR"
        set param_end   "${sector_key}_END_ADDR"
            
        if {$sector_index != -1} {

            set start_addr [lindex $sector_start_addr_list $sector_index]
            set end_addr [lindex $sector_end_addr_list $sector_index]

            set_parameter_property $param_start ENABLED true
            set_parameter_property $param_end ENABLED true
            set_parameter_value $param_start $start_addr
            set_parameter_value $param_end $end_addr
            
            # Publish SECTORs information in "system.h"
            set_module_assignment "embeddedsw.CMacro.${sector_key}_ENABLED" 1
            set_module_assignment "embeddedsw.CMacro.${param_start}" [expr ($start_addr)*4]
            set_module_assignment "embeddedsw.CMacro.${param_end}" [expr (($end_addr)*4)+3]

            set message [format "0x%05x,0x%05x" [expr ($start_addr)*4] [expr (($end_addr)*4)+3]]
            send_message debug "set_flash_start_end_address -> ($param_start, $param_end) $message"

        } else {
            
            set_parameter_property $param_start ENABLED false
            set_parameter_property $param_end ENABLED false
            
            # Publish SECTORs information in "system.h"
            set_module_assignment "embeddedsw.CMacro.${sector_key}_ENABLED" 0
            set_module_assignment "embeddedsw.CMacro.${param_start}" -1
            set_module_assignment "embeddedsw.CMacro.${param_end}" -1
            
            send_message debug "set_flash_start_end_address -> ($param_start, $param_end) -1,-1"
        }
    }    
}

proc access_mode_legality_check {} {
    
    global total_sectors all_sectors

    array set sector_type_pair_list [get_sector_type_pair_filtered_by_configuration_mode]
    set supported_sectors [setup_supported_sector]
    set sector_access_modes [get_parameter_value SECTOR_ACCESS_MODE]
    
    set pre_cfm_mode "NONE"
    set pre_cfm_type "NONE"
    for {set i 0} {$i < $total_sectors} {incr i} {
        
        set sector [lindex $all_sectors $i]
        set mode [lindex $sector_access_modes $i]

        set cur_sector_index [lsearch $supported_sectors $sector]
        if {$cur_sector_index != -1} {
            set type $sector_type_pair_list($sector)
            if {[regexp {UFM} $type match]} {
                # UFM access mode legality check
                if {$mode == "Hidden"} {
                    send_message error "$type sector does not support \"Hidden\" mode. Please update the Access Mode setting."
                }
            } else {
                # CFM access mode legality check
                if {$pre_cfm_type == $type} {
                    if { $pre_cfm_mode != $mode } {
                        send_message error "$type sectors must have same Access Mode setting. Please update the Access Mode setting."
                    }
                } else {
                    set pre_cfm_mode $mode
                    set pre_cfm_type $type
                }
            }
        }
    }
}

proc set_flash_memory_table {supported_sectors} {

    global all_sectors total_sectors device_sector_protection_mode device_sector_size device_sector_address_offset
    global selected_family_code selected_device_code selected_supply_code selected_feature_code selected_virtual_zb2
    global sector_id_list sector_addr_mapping_list sector_storage_type_list sector_start_addr_list sector_end_addr_list
 #   set selected_supply_code "S"
    if {$selected_virtual_zb2 == 1} {
        set device_family_code "10M02SC324"
    } else {
    set device_family_code "${selected_family_code}${selected_device_code}"
    }
    array set sector_type_pair_list [get_sector_type_pair_filtered_by_configuration_mode]

    set sector_access_modes [get_parameter_value SECTOR_ACCESS_MODE]

    send_message debug "supported_sectors = $supported_sectors"
    send_message debug "device_family_code = $device_family_code"
    send_message debug "selected_supply_code = $selected_supply_code"
    set sector_id_list []
    set sector_addr_mapping_list []
    set sector_storage_type_list []
    set sector_start_addr_list []
    set sector_end_addr_list []

    set cur_sector_id 1
    set cur_sector_start_addr 0
    set cur_sector_end_addr 0
    
    for {set i 0} {$i < $total_sectors} {incr i} {
        
        set sector [lindex $all_sectors $i]
        set mode [lindex $sector_access_modes $i]

        set cur_sector_index [lsearch $supported_sectors $sector]
        if {$cur_sector_index == -1 || $mode == "Hidden"} {
            lappend sector_id_list "NA"
            lappend sector_addr_mapping_list "NA"
            lappend sector_start_addr_list 0
            lappend sector_end_addr_list 0

            if {$cur_sector_index == -1} {
                lappend sector_storage_type_list "NA"
            } else {
                lappend sector_storage_type_list "$sector_type_pair_list($sector)"                
            }
        } else {
            set sector_key "${device_family_code}_${sector}"
            set sector_size $device_sector_size($sector_key)
            set sector_offset $device_sector_address_offset($sector_key)

            set cur_sector_end_addr [expr (($cur_sector_start_addr+(($sector_size*1024)/32))-1)]

            set cur_sector_start_byte_addr [expr ($cur_sector_start_addr*4)]
            set cur_sector_end_byte_addr [expr (($cur_sector_end_addr*4)+3)]
            
            lappend sector_id_list $cur_sector_id
            set message [format "0x%05x - 0x%05x" $cur_sector_start_byte_addr $cur_sector_end_byte_addr]
            lappend sector_addr_mapping_list "$message"
            lappend sector_start_addr_list $cur_sector_start_addr
            lappend sector_end_addr_list $cur_sector_end_addr
            lappend sector_storage_type_list "$sector_type_pair_list($sector)"

            incr cur_sector_id
            set cur_sector_start_addr [expr ($cur_sector_end_addr+1)]
        }
    }    

    set_parameter_value SECTOR_ID $sector_id_list
    set_parameter_value SECTOR_ADDRESS_MAPPING $sector_addr_mapping_list
    set_parameter_value SECTOR_STORAGE_TYPE $sector_storage_type_list
    
    send_message debug "SECTOR_ID              = [get_parameter_value SECTOR_ID]"
    send_message debug "SECTOR_ACCESS_MODE     = [get_parameter_value SECTOR_ACCESS_MODE]"
    send_message debug "SECTOR_ADDRESS_MAPPING = [get_parameter_value SECTOR_ADDRESS_MAPPING]"
    send_message debug "SECTOR_STORAGE_TYPE    = [get_parameter_value SECTOR_STORAGE_TYPE]"
        
    access_mode_legality_check    
}

proc setup_supported_sector {} {
    
    global selected_family_code selected_device_code selected_feature_code
    global all_sectors device_sector_size

    set supported_sectors [list]
    foreach sector $all_sectors {
        set sector_key "${selected_family_code}${selected_device_code}_${sector}"
        
        if {[info exists device_sector_size(${sector_key})]} {
            if {!([string toupper $selected_feature_code] == "C" && $sector == "SECTOR3")} {
                lappend supported_sectors $sector
            }
        }
    }
    
    return $supported_sectors;
}

proc setup_address_range {} {
    
    set supported_sectors [setup_supported_sector]
    set_flash_memory_table $supported_sectors
    set_flash_protection_mode
    set_flash_sector_map
    set_flash_address_offset
    set_flash_min_max_address
    set_flash_start_end_address
}

proc setup_device_id {} {

    global selected_device_code selected_supply_code selected_feature_code selected_virtual_zb2
    #10M02SCU324 is using ZB8 die
    if {$selected_virtual_zb2 == 1} {
        set_parameter_value DEVICE_ID "08"
    } else {
        set_parameter_value DEVICE_ID $selected_device_code
    }
}

proc setup_avmm_if_based_on_access_mode {} {

    global total_sectors sector_id_list
    
    set sector_access_modes [get_parameter_value SECTOR_ACCESS_MODE]
    set is_read_write_mode 0

    for {set i 0} {$i < $total_sectors} {incr i} {
    
        set sector_id [expr ($i+1)]
        set sector_key "SECTOR${sector_id}"
        set sector_index [lsearch $sector_id_list $sector_id]

        if {$sector_index != -1} {
            if {[lindex $sector_access_modes $sector_index] == "Read and write"} {
                set is_read_write_mode 1
                break
            }
        }
    }
    
    if {$is_read_write_mode} {
        set_parameter_value READ_AND_WRITE_MODE true
        set_interface_property "csr" ENABLED true
        set_port_property avmm_data_writedata TERMINATION false
        set_port_property avmm_data_write TERMINATION false

        # Publish page erase information to "system.h"
        set_module_assignment "embeddedsw.CMacro.READ_ONLY_MODE" 0

    } else {
        set_parameter_value READ_AND_WRITE_MODE false
        set_interface_property "csr" ENABLED false
        set_port_property avmm_data_writedata TERMINATION true
        set_port_property avmm_data_writedata TERMINATION_VALUE 0
        set_port_property avmm_data_write TERMINATION true
        set_port_property avmm_data_write TERMINATION_VALUE 0

        # Publish page erase information to "system.h"
        set_module_assignment "embeddedsw.CMacro.READ_ONLY_MODE" 1
    }

    send_message debug "READ_AND_WRITE_MODE = [get_parameter_value READ_AND_WRITE_MODE]"
}

proc setup_avmm_if_data_bus_width {} {
    
    global selected_interface_mode

    if {$selected_interface_mode != "s_to_s"} {
        set_interface_property data bitsPerSymbol 8
        set_parameter_value AVMM_DATA_DATA_WIDTH 32
    } else {
        set_interface_property data bitsPerSymbol 1
        set_parameter_value AVMM_DATA_DATA_WIDTH 1
    }
    
    send_message debug "AVMM_DATA_DATA_WIDTH = [get_parameter_value AVMM_DATA_DATA_WIDTH]"    
}

proc setup_avmm_if_burstread_properties {} {
    
    global selected_device selected_device_code selected_supply_code selected_feature_code selected_interface_mode selected_virtual_zb2

    set is_parallel_mode [get_parameter_value PARALLEL_MODE]
    set read_burst_mode_value [get_parameter_value READ_BURST_MODE]    
    set read_burst_count_value [get_parameter_value READ_BURST_COUNT]
    set max_data_burst_count 4

    set_parameter_property READ_BURST_MODE ENABLED true
    set_parameter_property READ_BURST_COUNT ENABLED true
    
    if {$selected_interface_mode != "s_to_s"} {

        if {$read_burst_mode_value == "Incrementing"} {
            set_parameter_value WRAPPING_BURST_MODE false
            set_interface_property data linewrapBursts 0
            set max_data_burst_count $read_burst_count_value
        } else {
            
            if {$selected_interface_mode == "p_to_s"} {
                send_message error "Target device $selected_device does not support wrapping read burst mode."
            }
            
            set_parameter_value WRAPPING_BURST_MODE true
            set_interface_property data linewrapBursts 1
            # Wrapping mode only supports fixed max burst count
            set_parameter_property READ_BURST_COUNT ENABLED false
            if {[regexp {(04|08)} $selected_device_code match] || $selected_virtual_zb2 ==1} {
                set max_data_burst_count 2
            } else {
                set max_data_burst_count 4
            }
        }

    } else {

        set_parameter_property READ_BURST_MODE ENABLED false
        set_parameter_value WRAPPING_BURST_MODE false
        set max_data_burst_count [expr ($read_burst_count_value * 32)]
        
    }
    
    binary scan [binary format I* $max_data_burst_count] B* burst_count_binary
    set burst_count_binary [string range $burst_count_binary [string first "1" $burst_count_binary] [string length $burst_count_binary]]
    set burst_count_binary_size [string length $burst_count_binary]
    set_parameter_value AVMM_DATA_BURSTCOUNT_WIDTH $burst_count_binary_size

    send_message debug "WRAPPING_BURST_MODE = [get_parameter_value WRAPPING_BURST_MODE]"
    send_message debug "AVMM_DATA_BURSTCOUNT_WIDTH = [get_parameter_value AVMM_DATA_BURSTCOUNT_WIDTH]"
    send_message debug "linewrapBursts = [get_interface_property data linewrapBursts]"    
}

proc setup_parallel_mode {} {
    
    global selected_device selected_device_code selected_supply_code selected_feature_code selected_interface_mode selected_virtual_zb2
    
    set data_interface_value [get_parameter_value DATA_INTERFACE]
    if {$data_interface_value == "Serial"} {
        set selected_interface_mode "s_to_s"
    } else {
        if {$selected_device_code == "02" || $selected_device_code == "01"} {
            if {$selected_virtual_zb2 == 1} {
                set selected_interface_mode "p_to_p"
            } else { 
                set selected_interface_mode "p_to_s"
            }
        } else {
            set selected_interface_mode "p_to_p"
        }
    }
    
    if {$selected_interface_mode == "p_to_p"} {
        set_parameter_value PARALLEL_MODE true
    } else {
        set_parameter_value PARALLEL_MODE false
    }
    
    send_message debug "selected_interface_mode = $selected_interface_mode"
    send_message debug "PARALLEL_MODE = [get_parameter_value PARALLEL_MODE]"
}

proc setup_configuration_mode {} {
    global selected_feature_code
    set configuration_mode_cvariant { \
	"Single Uncompressed Image" \
	"Single Compressed Image" 
    }
    set configuration_mode_other_variant { \
	"Dual Compressed Images" \
	"Single Uncompressed Image" \
	"Single Compressed Image" \
	"Single Uncompressed Image with Memory Initialization" \
	"Single Compressed Image with Memory Initialization" \
    }
    # C variant only support single uncompress/compress image
    if {[string toupper $selected_feature_code] == "C"} {
        send_message debug "selected_feature_code = $selected_feature_code"
        send_message debug "C variant device is selected"
        set_parameter_property CONFIGURATION_MODE ALLOWED_RANGES $configuration_mode_cvariant
    } else {
        send_message debug "selected_feature_code = $selected_feature_code"
        send_message debug "C variant device is not selected"
        set_parameter_property CONFIGURATION_MODE ALLOWED_RANGES $configuration_mode_other_variant
    }
    # Check configuration scheme
    set conf_scheme [get_parameter_value CONFIGURATION_SCHEME]
    set conf_mode [get_parameter_value CONFIGURATION_MODE]
    if {$conf_scheme == "Internal Configuration"} {
        set_parameter_property CONFIGURATION_MODE ENABLED true
    } else {
        set_parameter_property CONFIGURATION_MODE ENABLED false
        set conf_mode "Single Uncompressed Image with Memory Initialization"
    }
    
    # Check configuration mode
    if {$conf_mode == "Dual Compressed Images"} {
        set_parameter_value IS_DUAL_BOOT "True"
        set_parameter_value IS_ERAM_SKIP "True"
        set_parameter_value IS_COMPRESSED_IMAGE "True"
    } else {
        set_parameter_value IS_DUAL_BOOT "False"
        
        if {$conf_mode == "Single Uncompressed Image" ||
            $conf_mode == "Single Uncompressed Image with Memory Initialization"} {
            set_parameter_value IS_COMPRESSED_IMAGE "False"
        } else {
            set_parameter_value IS_COMPRESSED_IMAGE "True"
        }
        
        if {$conf_mode == "Single Uncompressed Image with Memory Initialization" ||
            $conf_mode == "Single Compressed Image with Memory Initialization"} {
            set_parameter_value IS_ERAM_SKIP "False"
        } else {
            set_parameter_value IS_ERAM_SKIP "True"
        }
    }
    
    send_message debug "IS_DUAL_BOOT = [get_parameter_value IS_DUAL_BOOT]"
    send_message debug "IS_ERAM_SKIP = [get_parameter_value IS_ERAM_SKIP]"
    send_message debug "IS_COMPRESSED_IMAGE = [get_parameter_value IS_COMPRESSED_IMAGE]"
}

proc setup_fsm_cycle_info {} {

    global selected_device_code selected_supply_code selected_feature_code selected_interface_mode selected_virtual_zb2

    # ++++++++++++++++++++++++++++++
    # Set parallel mode read cycle parameter based on device
    # ++++++++++++++++++++++++++++++
    if {[regexp {(04|08)} $selected_device_code match] || $selected_virtual_zb2 == 1} {
        # ZB2 and ZB4 have 64-bit (2 32-bit) data register in flash IP, ZB2 does not support parallel mode.
        set read_data_count 2
        set addr_align_bits 1
    } else {
        # All other ZB devices have 128-bit (4 32-bit) data register in flash IP.
        set read_data_count 4
        set addr_align_bits 2
    }
    set_parameter_value FLASH_SEQ_READ_DATA_COUNT $read_data_count
    set_parameter_value FLASH_ADDR_ALIGNMENT_BITS $addr_align_bits
    send_message debug "FLASH_SEQ_READ_DATA_COUNT = [get_parameter_value FLASH_SEQ_READ_DATA_COUNT]"
    send_message debug "FLASH_ADDR_ALIGNMENT_BITS = [get_parameter_value FLASH_ADDR_ALIGNMENT_BITS]"
    
    # ++++++++++++++++++++++++++++++
    # Dynamic adjust parameters based on clock
    # ++++++++++++++++++++++++++++++
    
    set auto_system_clock_rate [get_parameter_value AUTO_CLOCK_RATE]
    if {$auto_system_clock_rate > 0} {
        # Align with system clock, change from HZ to MHZ
        set clock_frequency_hz $auto_system_clock_rate
        set_parameter_property CLOCK_FREQUENCY ENABLED false
        # Display clock source message
        set clockRateMessage "<b>The on-chip flash megafunction will be run with $clock_frequency_hz Hz clock frequency. </b><br>"
    } else {
        # External clock, user to define the frequency
        set clock_frequency_hz [expr ([get_parameter_value CLOCK_FREQUENCY] * 1000000)]
        set_parameter_property CLOCK_FREQUENCY ENABLED true
        set clockRateMessage "<b>User is required to provide the clock frequency.</b><br>"
        set clockRateMessage "$clockRateMessage<b>The on-chip flash megafunction will be run with $clock_frequency_hz Hz clock frequency. </b><br>"
    }
    set htmlClockRateMessage "<html><table border=\"0\" width=\"100%\"><tr><td valign=\"top\"><font size=3>$clockRateMessage</td></tr></table></html>"
    set_display_item_property clockRateMessage TEXT $htmlClockRateMessage
    
    # Restricted to maximum frequency
    if {$selected_interface_mode == "p_to_p"} {
        if {$clock_frequency_hz > 116000000} {
            send_message warning "Clock frequency is set to $clock_frequency_hz Hz, but the target device only supports maximum 116000000 Hz for the selected interface."
            set clock_frequency_hz 116000000
        }
    } else {
        if {$clock_frequency_hz > 7250000} {
            send_message warning "Clock frequency is set to $clock_frequency_hz Hz, but the target device only supports maximum 7250000 Hz for the selected interface."
            set clock_frequency_hz 7250000
        }
    }
    
    set clock_period_ps [expr (1000000000000/$clock_frequency_hz)]
    
    # Set parallel mode read cycle
    if {[regexp {(40|50)} $selected_device_code match]} {
        set required_read_cycle_max_index 5
    } else {
        set required_read_cycle_max_index 4
    }

    set_parameter_value FLASH_READ_CYCLE_MAX_INDEX $required_read_cycle_max_index
    send_message debug "FLASH_READ_CYCLE_MAX_INDEX = [get_parameter_value FLASH_READ_CYCLE_MAX_INDEX]"
    send_message debug "    auto_system_clock_rate = $auto_system_clock_rate"
    send_message debug "    clock_frequency_hz     = $clock_frequency_hz"
    send_message debug "    clock_period_ps        = $clock_period_ps"

    # Set required clock cycle for each timeout
    array set convert_timeout_to_clock_cycle {
        FLASH_RESET_CYCLE_MAX_INDEX 250000
        FLASH_BUSY_TIMEOUT_CYCLE_MAX_INDEX 1200000
        FLASH_ERASE_TIMEOUT_CYCLE_MAX_INDEX 350000000000
        FLASH_WRITE_TIMEOUT_CYCLE_MAX_INDEX 305000000
    }
    
    foreach { timeout_type timeout_period_ps } [array get convert_timeout_to_clock_cycle] {
        set required_clock_cycle [expr ($timeout_period_ps/$clock_period_ps)]
        if {$required_clock_cycle < 1} {
            set required_clock_cycle 1
        }
        set_parameter_value $timeout_type $required_clock_cycle
        send_message debug "$timeout_type = [get_parameter_value $timeout_type]"
    }
}

proc setup_flash_init_file {} {
    
    # read parameter    
    set autoInitializationFileName [ get_parameter_value autoInitializationFileName ]
    set initFlashContent [ get_parameter_value initFlashContent ]
    set useNonDefaultInitFile [ get_parameter_value useNonDefaultInitFile ]
    set initializationFileName [ get_parameter_value initializationFileName ]
    set initializationFileNameForSim [ get_parameter_value initializationFileNameForSim ]
    set flashInitMessage "</br>"

    # Update useNonDefaultInitFile & initializationFileName PARAM
    set_parameter_property useNonDefaultInitFile ENABLED $initFlashContent
    set_parameter_property initializationFileName ENABLED [ expr {[ expr {$useNonDefaultInitFile && $initFlashContent}] ? 1 : 0 }]
    set_parameter_property initializationFileNameForSim ENABLED [ expr {[ expr {$useNonDefaultInitFile && $initFlashContent}] ? 1 : 0 }]

    if { $initFlashContent } {

        # Derive the filename
        if { $useNonDefaultInitFile } {

            # if user provided name
            set derived_init_file_name "${initializationFileName}"
            set derived_init_file_name_for_sim "${initializationFileNameForSim}"
            
            # Display init file message
            set flashInitMessage "$flashInitMessage</br><b>User is required to provide the flash initialization file.</b><br>"
            set flashInitMessage "$flashInitMessage<b>The on-chip flash will be initialized from \"$derived_init_file_name\"</b><br>"
            set flashInitMessage "$flashInitMessage<b>The on-chip flash will be initialized from \"$derived_init_file_name_for_sim\" for simulation</b><br>"

        } else {

            if { $autoInitializationFileName == "" } {
                set autoInitializationFileName "altera_onchip_flash"
            }
            # else, default name, which is UNIQUE_ID/module name with ".hex"            

            set derived_init_file_name "${autoInitializationFileName}.hex"

            # Auto assign simulation file name
            set init_filename_without_extension [ file tail [ file rootname "$derived_init_file_name" ] ]
            set derived_init_file_name_for_sim "${init_filename_without_extension}.dat"

            # Display init file message  
            set flashInitMessage "$flashInitMessage</br><b>The on-chip flash will be initialized from \"$derived_init_file_name\"</b><br>"
            set flashInitMessage "$flashInitMessage<b>The on-chip flash will be initialized from \"$derived_init_file_name_for_sim\" for simulation</b><br>"
        }
        
        # Get the filename no ext, for BSP (embeddedsw component)
        set init_filename_without_extension [ file tail [ file rootname "$derived_init_file_name" ] ]
        set_module_assignment embeddedsw.memoryInfo.MEM_INIT_FILENAME "$init_filename_without_extension"
        
        # Update filename
        set_parameter_value INIT_FILENAME     $derived_init_file_name
        set_parameter_value INIT_FILENAME_SIM $derived_init_file_name_for_sim

    } else {
    
        # Update filename
        set_parameter_value INIT_FILENAME     ""
        set_parameter_value INIT_FILENAME_SIM ""
        
        set flashInitMessage "$flashInitMessage</br><b>The on-chip flash is not initialized during device programming.</b>" 
    }
  
    set htmlflashInitMessage "<html><table border=\"0\" width=\"100%\"><tr><td valign=\"top\"><font size=3>$flashInitMessage</td></tr></table></html>"
    set_display_item_property flashInitMessage TEXT $htmlflashInitMessage
}

proc setup_page_erase_info {} {

    global selected_device_code

    # Publish page erase information to "system.h"
    if {$selected_device_code == "50" || $selected_device_code == "40"} {
        set_module_assignment "embeddedsw.CMacro.BYTES_PER_PAGE" 8192
    } elseif {$selected_device_code == "16" || $selected_device_code == "25"} {
        set_module_assignment "embeddedsw.CMacro.BYTES_PER_PAGE" 4096
    } else {
        set_module_assignment "embeddedsw.CMacro.BYTES_PER_PAGE" 2048
    }    
}

proc elaboration_callback {} {
    
    global device_name_pattern selected_device_family selected_device selected_family_code selected_device_code selected_supply_code selected_feature_code selected_virtual_zb2

    set selected_device_family [string toupper [get_parameter_value DEVICE_FAMILY]]
    set selected_device [string toupper [get_parameter_value PART_NAME]]
    set is_supported_family 1
    set is_supported_device 1

    send_message debug "Altera Onchip Flash megafunction - $selected_device_family, $selected_device"
    if {[string toupper $selected_device] == "UNKNOWN"} {
        set is_supported_device 0
        send_message error "Must assign a valid Device for Altera Onchip Flash megafunction."
    }

    if {$is_supported_family && $is_supported_device} {

        setup_parallel_mode

        if {[info exists device_name_pattern($selected_device_family)]} {
            set pattern $device_name_pattern($selected_device_family)
            if {[regexp $pattern $selected_device match selected_family_code selected_device_code selected_supply_code selected_feature_code selected_package_code]} {

                if {$selected_device_code == "02"  && $selected_supply_code == "S" && $selected_feature_code == "C" && $selected_package_code == "324"} {
                    set selected_virtual_zb2 1
                } else {
                    set selected_virtual_zb2 0
                }
                send_message debug "FAMILY_CODE = $selected_family_code, DEVICE_CODE = $selected_device_code, PACKAGE_CODE = $selected_package_code"    
                send_message debug "Virtual_zb2 = $selected_virtual_zb2"    
                setup_configuration_mode
                setup_device_id
                setup_address_range
                setup_page_erase_info
                setup_fsm_cycle_info

            } else {
                # report error
                send_message error "Illegal device name format - $selected_device."
            }
        } else {
            # report error
            send_message error "Missing device name format setting for $selected_device_family."
        }

        setup_avmm_if_based_on_access_mode
        setup_avmm_if_data_bus_width
        setup_avmm_if_burstread_properties
        setup_flash_init_file
    } 

    #Disable the STA warning 332060 for non-clock nodes
    set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 332060 -entity altera_onchip_flash" }
}

proc parameter_upgrade_callback {ip_core_type version parameters} {
    
    ###########################################
    # Migrate from 14.0 -> 14.1
    #    Old parameters
    #        BOOL_DUAL_BOOT
    #    New parameters
    #        CONFIGURATION_SCHEME
    #        CONFIGURATION_MODE
    #        initializationFileName
    ###########################################
    if {$version == "14.0" || $version == "14.0.2"} {

        set bool_dual_boot "false"
        set initializationFileName ""
    
        # Go through parameters
        foreach { name value } $parameters {

            if {$name == "BOOL_DUAL_BOOT"} {
                # Replaced by CONFIGURATION_SCHEME and CONFIGURATION_MODE to support 5 SDM modes.
                set bool_dual_boot $value
            
            } elseif {$name == "AUTO_CLK_CLOCK_RATE"} {
                # Replaced by AUTO_CLOCK_RATE.
                set auto_block_rate $value

            } elseif {$name == "ACCESS_MODE"} {
                # Replaced by SECTOR_ACCESS_MODE.
                set access_mode $value

            } else {

                # All other parameters those are compatible
                set_parameter_value $name $value
                
                # Need to fill up new param 'initializationFileNameForSim'. Separate simulation init file from synth init file.
                if {$name == "initializationFileName"} {
                    set initializationFileName $value
                }
            }
        }
        
        # Migration for dual boot param, replaced by configuration mode params
        if {$bool_dual_boot == "true"} {
            set_parameter_value CONFIGURATION_SCHEME "Internal Configuration"
            set_parameter_value CONFIGURATION_MODE "Dual Compressed Images"
        }
        
        # Migration for AUTO_CLK_CLOCK_RATE param, replaced by AUTO_CLOCK_RATE params
        set_parameter_value AUTO_CLOCK_RATE $auto_block_rate
        
        # Migration for ACCESS_MODE param, replaced by SECTOR_ACCESS_MODE params
        set sector_access_modes []
        lappend sector_access_modes $access_mode
        lappend sector_access_modes $access_mode
        lappend sector_access_modes $access_mode
        if {$bool_dual_boot == "true"} {
            lappend sector_access_modes $access_mode
            lappend sector_access_modes $access_mode
        } else {
            lappend sector_access_modes "Hidden"
            lappend sector_access_modes "Hidden"
        }
        set_parameter_value SECTOR_ACCESS_MODE $sector_access_modes            

        # Migration for initializationFileNameForSim, new param in 14.1
        if {$initializationFileName == ""} {
            # Auto assign default file name
            set_parameter_value initializationFileName "altera_onchip_flash.hex"
            set_parameter_value initializationFileNameForSim "altera_onchip_flash.dat"
        } else {
            # Auto assign simulation file name
            set init_filename_without_extension [ file tail [ file rootname "$initializationFileName" ] ]
            set initializationFileNameForSim "${init_filename_without_extension}.dat"
            set_parameter_value initializationFileNameForSim $initializationFileNameForSim
        }
    } else {

        # For all other releases, all parameters are compatible
        foreach { name value } $parameters {
            set_parameter_value $name $value
        }
    }
}

proc generate_synth {entityname} {

    global selected_interface_mode
    
    set read_and_write_mode [get_parameter_value READ_AND_WRITE_MODE]

    send_message info "Generating top-level entity $entityname"
    add_fileset_file altera_onchip_flash_util.v                        VERILOG PATH altera_onchip_flash_util.v    
    add_fileset_file altera_onchip_flash.v                             VERILOG PATH altera_onchip_flash.v    
    if {$selected_interface_mode == "p_to_p"} {
        add_fileset_file altera_onchip_flash_avmm_data_controller.v    VERILOG PATH altera_onchip_flash_avmm_data_controller.v
    } elseif {$selected_interface_mode == "p_to_s"} {
        add_fileset_file altera_onchip_flash_avmm_data_controller.v    VERILOG PATH altera_onchip_flash_avmm_p_to_s_data_controller.v
    } else {
        add_fileset_file altera_onchip_flash_avmm_data_controller.v    VERILOG PATH altera_onchip_flash_avmm_serial_data_controller.v
    }
    if {$read_and_write_mode} {
        add_fileset_file altera_onchip_flash_avmm_csr_controller.v     VERILOG PATH altera_onchip_flash_avmm_csr_controller.v
        add_fileset_file altera_onchip_flash.sdc                       SDC     PATH altera_onchip_flash.sdc
    }
    add_fileset_file ../rtl/altera_onchip_flash_block.v                VERILOG PATH ../rtl/altera_onchip_flash_block.v
}

proc generate_verilog_sim {entityname} {

    global selected_interface_mode

    set read_and_write_mode [get_parameter_value READ_AND_WRITE_MODE]
    
    add_fileset_file altera_onchip_flash_util.v                        VERILOG PATH altera_onchip_flash_util.v    
    add_fileset_file altera_onchip_flash.v                             VERILOG PATH altera_onchip_flash_sim.v
    if {$selected_interface_mode == "p_to_p"} {
        add_fileset_file altera_onchip_flash_avmm_data_controller.v        VERILOG PATH altera_onchip_flash_avmm_data_controller.v
    } elseif {$selected_interface_mode == "p_to_s"} {
        add_fileset_file altera_onchip_flash_avmm_data_controller.v        VERILOG PATH altera_onchip_flash_avmm_p_to_s_data_controller.v
    } else {
        add_fileset_file altera_onchip_flash_avmm_data_controller.v        VERILOG PATH altera_onchip_flash_avmm_serial_data_controller.v
    }
    if {$read_and_write_mode} {
        add_fileset_file altera_onchip_flash_avmm_csr_controller.v     VERILOG PATH altera_onchip_flash_avmm_csr_controller.v
    }
}

proc generate_sim_encrypt_file {entityname} {

    if {1} {
        generate_vendor_encrypt_fileset_file mentor
    }
    if {1} {
        generate_vendor_encrypt_fileset_file aldec
    }
    if {1} {
        generate_vendor_encrypt_fileset_file cadence
    }
    if {1} {
        generate_vendor_encrypt_fileset_file synopsys
    }
}

proc generate_vendor_encrypt_fileset_file { vendor } {

    global selected_interface_mode
    
    set read_and_write_mode [get_parameter_value READ_AND_WRITE_MODE]    
    set vendor_uppercase "[ string toupper $vendor ]"

    add_fileset_file ${vendor}/altera_onchip_flash_util.v                     VERILOG_ENCRYPT PATH "${vendor}/altera_onchip_flash_util.v"                  "${vendor_uppercase}_SPECIFIC"
    add_fileset_file ${vendor}/altera_onchip_flash.v                          VERILOG_ENCRYPT PATH "${vendor}/altera_onchip_flash_sim.v"                  "${vendor_uppercase}_SPECIFIC"
    if {$selected_interface_mode == "p_to_p"} {
        add_fileset_file ${vendor}/altera_onchip_flash_avmm_data_controller.v     VERILOG_ENCRYPT PATH "${vendor}/altera_onchip_flash_avmm_data_controller.v" "${vendor_uppercase}_SPECIFIC"
    } elseif {$selected_interface_mode == "p_to_s"} {
        add_fileset_file ${vendor}/altera_onchip_flash_avmm_data_controller.v     VERILOG_ENCRYPT PATH "${vendor}/altera_onchip_flash_avmm_p_to_s_data_controller.v" "${vendor_uppercase}_SPECIFIC"
    } else {
        add_fileset_file ${vendor}/altera_onchip_flash_avmm_data_controller.v     VERILOG_ENCRYPT PATH "${vendor}/altera_onchip_flash_avmm_serial_data_controller.v" "${vendor_uppercase}_SPECIFIC"
    }
    if {$read_and_write_mode} {
        add_fileset_file ${vendor}/altera_onchip_flash_avmm_csr_controller.v  VERILOG_ENCRYPT PATH "${vendor}/altera_onchip_flash_avmm_csr_controller.v"  "${vendor_uppercase}_SPECIFIC"
    }
}
