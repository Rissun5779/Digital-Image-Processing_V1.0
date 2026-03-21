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


# $Id: //acds/rel/18.1std/ip/altera_remote_update/altera_avalon_remote_update_controller_hw.tcl#3 $
# $Revision: #3 $
# $Date: 2018/08/24 $
# $Author: cheehang $

# 
# altera_avalon_remote_update_controller "Avalon Remote Update Controller" v1.0
#  2014.10.04.18:19:04
# Avalon interface controller for remote update IP
# 

# 
# request TCL package from ACDS 14.1
# 
package require -exact qsys 14.1
package require -exact altera_terp 1.0
# Source files
source altera_remote_update_hw_core_proc.tcl

# 
# module altera_avalon_remote_update_controller
# 
set_module_property DESCRIPTION "Avalon interface controller for remote update IP"
set_module_property NAME altera_avalon_remote_update_controller
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Avalon Remote Update Controller"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set supported_device_families_list {"Arria 10" "Arria II GX" "Arria II GZ" "Arria V" "Arria V GZ" \
                                    "Cyclone IV E" "Cyclone IV GX" "Cyclone V" \
                                    "Stratix IV" "Stratix V" "Cyclone 10 LP"}

set supported_spi_devices_list {"EPCS1" "EPCS4" "EPCS16" "EPCS64" "EPCS128" \
                                "EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ256" "EPCQ512"\
                                "EPCQL256" "EPCQL512" "EPCQL1024" \
                                "EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" \
				                "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G" \
                                "MX25L128" "MX25U128" "MX25L256" "MX25L512"  "MX66U512" \
                                "S25FL128" "S25FL256" "S25FL512" \
                                "MX25U256" "MX25U512" "MX66U1G" "MX66U2G"}
                            
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list
set_module_property ELABORATION_CALLBACK elaboration_callback

# +-----------------------------------
# | Device family
# +-----------------------------------
add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY HDL_PARAMETER true
# +-----------------------------------
# | Device part
# +-----------------------------------
add_parameter DEVICE STRING
set_parameter_property DEVICE DISPLAY_NAME "Device part"
set_parameter_property DEVICE VISIBLE false
set_parameter_property DEVICE SYSTEM_INFO {DEVICE}

#select configuration device
add_parameter GUI_config_device STRING
set_parameter_property GUI_config_device DEFAULT_VALUE "EPCS128"
set_parameter_property GUI_config_device DISPLAY_NAME "Which configuration device will you be using?"
set_parameter_property GUI_config_device DESCRIPTION "Select the configuration device. This parameter is used for simulation purposes only."
set_parameter_property GUI_config_device TYPE STRING
set_parameter_property GUI_config_device AFFECTS_GENERATION true
set_parameter_property GUI_config_device AFFECTS_ELABORATION true
set_parameter_property GUI_config_device ALLOWED_RANGES $supported_spi_devices_list
add_display_item "General" GUI_config_device parameter

# add Add support for writing configuration parameters 
add_parameter m_support_write_config_check boolean 
set_parameter_property m_support_write_config_check DEFAULT_VALUE 0
set_parameter_property m_support_write_config_check DISPLAY_NAME "Add support for writing configuration parameters"
set_parameter_property m_support_write_config_check DESCRIPTION "Turn on this option to write configuration param"
set_parameter_property m_support_write_config_check AFFECTS_GENERATION true
set_parameter_property m_support_write_config_check AFFECTS_ELABORATION true
add_display_item "General" m_support_write_config_check parameter

# add Enable reconfig POF checking 
add_parameter check_app_pof boolean 
set_parameter_property check_app_pof DEFAULT_VALUE 0
set_parameter_property check_app_pof DISPLAY_NAME "Enable reconfig POF checking"
set_parameter_property check_app_pof DESCRIPTION "Turn on this option to allow POF checking."
set_parameter_property check_app_pof AFFECTS_GENERATION true
set_parameter_property check_app_pof AFFECTS_ELABORATION true
add_display_item "General" check_app_pof parameter

#set configuration device address
add_parameter config_device_addr_width INTEGER 
set_parameter_property config_device_addr_width DEFAULT_VALUE 24
set_parameter_property config_device_addr_width TYPE INTEGER
set_parameter_property config_device_addr_width AFFECTS_GENERATION true
set_parameter_property config_device_addr_width AFFECTS_ELABORATION true
set_parameter_property config_device_addr_width DERIVED true
set_parameter_property config_device_addr_width VISIBLE false

#set is epcq
add_parameter is_epcq boolean 
set_parameter_property is_epcq DEFAULT_VALUE false
set_parameter_property is_epcq AFFECTS_GENERATION true
set_parameter_property is_epcq AFFECTS_ELABORATION true
set_parameter_property is_epcq DERIVED true
set_parameter_property is_epcq VISIBLE false

#set data input width
add_parameter IN_DATA_WIDTH INTEGER 
set_parameter_property IN_DATA_WIDTH DEFAULT_VALUE 24
set_parameter_property IN_DATA_WIDTH TYPE INTEGER
set_parameter_property IN_DATA_WIDTH AFFECTS_GENERATION true
set_parameter_property IN_DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property IN_DATA_WIDTH DERIVED true
set_parameter_property IN_DATA_WIDTH VISIBLE false
set_parameter_property IN_DATA_WIDTH HDL_PARAMETER true

#set data output width
add_parameter OUT_DATA_WIDTH INTEGER 
set_parameter_property OUT_DATA_WIDTH DEFAULT_VALUE 24
set_parameter_property OUT_DATA_WIDTH TYPE INTEGER
set_parameter_property OUT_DATA_WIDTH AFFECTS_GENERATION true
set_parameter_property OUT_DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property OUT_DATA_WIDTH DERIVED true
set_parameter_property OUT_DATA_WIDTH VISIBLE false
set_parameter_property OUT_DATA_WIDTH HDL_PARAMETER true

#set configuration device address
add_parameter CSR_ADDR_WIDTH INTEGER 
set_parameter_property CSR_ADDR_WIDTH DEFAULT_VALUE 3
set_parameter_property CSR_ADDR_WIDTH TYPE INTEGER
set_parameter_property CSR_ADDR_WIDTH AFFECTS_GENERATION true
set_parameter_property CSR_ADDR_WIDTH AFFECTS_ELABORATION true
set_parameter_property CSR_ADDR_WIDTH DERIVED true
set_parameter_property CSR_ADDR_WIDTH VISIBLE false
set_parameter_property CSR_ADDR_WIDTH HDL_PARAMETER true

# file sets
# 

add_fileset quartus_synth QUARTUS_SYNTH add_synth_file
add_fileset quartus_synth SIM_VERILOG   add_synth_file
add_fileset sim_vhdl      SIM_VHDL      add_synth_file

# 
# connection point avl_csr
# 
add_interface avl_csr avalon end
set_interface_property avl_csr addressUnits WORDS
set_interface_property avl_csr associatedClock clk
set_interface_property avl_csr associatedReset reset
set_interface_property avl_csr bitsPerSymbol 8
set_interface_property avl_csr burstOnBurstBoundariesOnly false
set_interface_property avl_csr burstcountUnits WORDS
set_interface_property avl_csr explicitAddressSpan 0
set_interface_property avl_csr holdTime 0
set_interface_property avl_csr linewrapBursts false
set_interface_property avl_csr maximumPendingReadTransactions 1
set_interface_property avl_csr maximumPendingWriteTransactions 0
set_interface_property avl_csr readLatency 0
set_interface_property avl_csr readWaitTime 1
set_interface_property avl_csr setupTime 0
set_interface_property avl_csr timingUnits Cycles
set_interface_property avl_csr writeWaitTime 0
set_interface_property avl_csr ENABLED true
set_interface_property avl_csr EXPORT_OF ""
set_interface_property avl_csr PORT_NAME_MAP ""
set_interface_property avl_csr CMSIS_SVD_VARIABLES ""
set_interface_property avl_csr SVD_ADDRESS_GROUP ""

add_interface_port avl_csr avl_csr_write write Input 1
add_interface_port avl_csr avl_csr_read read Input 1
add_interface_port avl_csr avl_csr_wdata writedata Input 32
add_interface_port avl_csr avl_csr_rdata readdata Output 32
add_interface_port avl_csr avl_csr_readdatavalid readdatavalid Output 1
add_interface_port avl_csr avl_csr_waitrequest waitrequest Output 1

# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1

# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1

# 
# connection point read_param
# 
add_interface read_param conduit start
set_interface_property read_param associatedClock ""
set_interface_property read_param associatedReset ""
set_interface_property read_param ENABLED true
set_interface_property read_param EXPORT_OF ""
set_interface_property read_param PORT_NAME_MAP ""
set_interface_property read_param CMSIS_SVD_VARIABLES ""
set_interface_property read_param SVD_ADDRESS_GROUP ""

add_interface_port read_param ru_read_param read_param Output 1

# 
# connection point param
# 
add_interface param conduit start
set_interface_property param associatedClock ""
set_interface_property param associatedReset ""
set_interface_property param ENABLED true
set_interface_property param EXPORT_OF ""
set_interface_property param PORT_NAME_MAP ""
set_interface_property param CMSIS_SVD_VARIABLES ""
set_interface_property param SVD_ADDRESS_GROUP ""

add_interface_port param ru_param param Output 3

# 
# connection point reconfig
# 
add_interface reconfig conduit start
set_interface_property reconfig associatedClock ""
set_interface_property reconfig associatedReset ""
set_interface_property reconfig ENABLED true
set_interface_property reconfig EXPORT_OF ""
set_interface_property reconfig PORT_NAME_MAP ""
set_interface_property reconfig CMSIS_SVD_VARIABLES ""
set_interface_property reconfig SVD_ADDRESS_GROUP ""

add_interface_port reconfig ru_reconfig reconfig Output 1

# 
# connection point reset_timer
# 
add_interface reset_timer conduit start
set_interface_property reset_timer associatedClock ""
set_interface_property reset_timer associatedReset ""
set_interface_property reset_timer ENABLED true
set_interface_property reset_timer EXPORT_OF ""
set_interface_property reset_timer PORT_NAME_MAP ""
set_interface_property reset_timer CMSIS_SVD_VARIABLES ""
set_interface_property reset_timer SVD_ADDRESS_GROUP ""

add_interface_port reset_timer ru_reset_timer reset_timer Output 1

# 
# connection point busy
# 
add_interface busy conduit end
set_interface_property busy associatedClock ""
set_interface_property busy associatedReset ""
set_interface_property busy ENABLED true
set_interface_property busy EXPORT_OF ""
set_interface_property busy PORT_NAME_MAP ""
set_interface_property busy CMSIS_SVD_VARIABLES ""
set_interface_property busy SVD_ADDRESS_GROUP ""

add_interface_port busy ru_busy busy Input 1


# 
# connection point data_out
# 
add_interface data_out conduit end

#//////////////////////////////////////////////////////////////////////////
#
# Name:     elaboration_callback
#
# Purpose:  Update device parameters and port settings
#
#//////////////////////////////////////////////////////////////////////////
proc elaboration_callback {} {

    set get_device_family [get_parameter_value DEVICE_FAMILY]
    set_parameter_value CSR_ADDR_WIDTH 3
    if {$get_device_family == "Cyclone IV E" || $get_device_family == "Cyclone IV GX" || $get_device_family == "Cyclone 10 LP"} {
        add_interface read_source conduit end
        add_interface_port read_source ru_read_source read_source Output 2
        set_interface_property read_source ENABLED true
        set_parameter_value CSR_ADDR_WIDTH 5
    }
    add_interface_port avl_csr avl_csr_addr address Input [get_parameter_value CSR_ADDR_WIDTH]
    # +--------------------------------------
    # | EPCQ EPCS equivalent
    # +--------------------------------------

    set set_config_device [get_parameter_value GUI_config_device]

    # This to check old device EPCQ/S
    if { [string range $set_config_device 0 3] == "EPCQ" ||
         [string range $set_config_device 0 3] == "EPCS" } {
         if { [string range $set_config_device 4 6] <= 128 || [string index $set_config_device end] == "A" } {
            # For EPCQXXA: only support less than or equal 128
            set_parameter_value IN_DATA_WIDTH 24
            set_parameter_value OUT_DATA_WIDTH 24
            set_parameter_value config_device_addr_width 24
            
            if {$get_device_family == "Cyclone IV E" ||$get_device_family == "Cyclone IV GX" || $get_device_family == "Cyclone 10 LP"} {
                 set_parameter_value OUT_DATA_WIDTH 29
            }
        } else {
            set_parameter_value IN_DATA_WIDTH 32
            set_parameter_value OUT_DATA_WIDTH 32
            set_parameter_value config_device_addr_width 32
        }
    # This to check new added third party flashes 
    # these flashes are fixed 3 bytes address
    } elseif {$set_config_device == "MX25L128" || $set_config_device == "MX25U128" || 
               $set_config_device == "MX25L256" || $set_config_device == "MX25L512" ||
               $set_config_device == "MX66U512" || $set_config_device == "S25FL128" ||
               $set_config_device == "S25FL256" || $set_config_device == "S25FL512" } {

        set_parameter_value IN_DATA_WIDTH 24
        set_parameter_value OUT_DATA_WIDTH 24
        set_parameter_value config_device_addr_width 24
            
        if {$get_device_family == "Cyclone IV E" ||$get_device_family == "Cyclone IV GX" || $get_device_family == "Cyclone 10 LP"} {
            set_parameter_value OUT_DATA_WIDTH 29
        }
    # These Macronix are special, same device type but different suffix, one support 3 bytes, one 4 bytes
    } elseif {$set_config_device == "MX25U256" || $set_config_device == "MX25U512" ||
               $set_config_device == "MX66U1G" || $set_config_device == "MX66U2G"} {
        set_parameter_value IN_DATA_WIDTH 24
        set_parameter_value OUT_DATA_WIDTH 24
        set_parameter_value config_device_addr_width 24
            
        if {$get_device_family == "Cyclone IV E" ||$get_device_family == "Cyclone IV GX" || $get_device_family == "Cyclone 10 LP"} {
            set_parameter_value OUT_DATA_WIDTH 29
        }
        # Arria 10 Remote Update does not support device that smaller or equal 128
        if {$get_device_family == "Arria 10"} {
            # If A10, then turn on 4 byte address, but send info to users.
            set_parameter_value IN_DATA_WIDTH 32
            set_parameter_value OUT_DATA_WIDTH 32
            set_parameter_value config_device_addr_width 32
        }
    } else {
        # Those MT are more than 128
        set_parameter_value IN_DATA_WIDTH 32
        set_parameter_value OUT_DATA_WIDTH 32
        set_parameter_value config_device_addr_width 32      
    }
    
    if {[string first "EPCS" $set_config_device] == 0} {
        set_parameter_value is_epcq false
    } else {
        set_parameter_value is_epcq true
    }
    
    # +--------------------------------------
    # | Adjust ports width
    # +--------------------------------------

    #data_out width
    set set_data_out [get_parameter_value OUT_DATA_WIDTH]   
    add_interface_port data_out ru_data_out data_out Input $set_data_out
    
    # +----------------------------------------------------
    # | Enable support for writing configuration parameters
    # +----------------------------------------------------
    set set_writeparam [get_parameter_value m_support_write_config_check]   
    if {$set_writeparam == "true"} {
        add_interface write_param conduit end
        add_interface_port write_param ru_write_param write_param Output 1
        set_interface_property write_param ENABLED true
            
        add_interface data_in conduit end
        set set_data_in [get_parameter_value IN_DATA_WIDTH] 
        add_interface_port data_in ru_data_in data_in Output $set_data_in
        set_interface_property data_in ENABLED true
    }

    # +----------------------------------------------------
    # | Enable ctl_nupdt for Arria 10
    # +----------------------------------------------------
    
   
    if {$get_device_family == "Arria 10"} {
        add_interface ctl_nupdt conduit end
        add_interface_port ctl_nupdt ru_ctl_nupdt ctl_nupdt Output 1
        set_interface_property ctl_nupdt ENABLED true
    }

}   


proc add_synth_file {entity_name} {
    set DEVICE_FAMILY           [ get_parameter_value DEVICE_FAMILY ]

    # ---------------------------------
    #   Terp for top level wrapper
    # ---------------------------------
    set this_dir      [ get_module_property MODULE_DIRECTORY ]
    set template_file [ file join $this_dir "altera_avalon_remote_update_controller.sv.terp" ]

    set template    [ read [ open $template_file r ] ]

    set params(device) $DEVICE_FAMILY
    set params(output_name) $entity_name
    set result          [ altera_terp $template params ]

    set output_file     [ create_temp_file ${entity_name}.sv ]
    set output_handle   [ open $output_file w ]

    puts $output_handle $result
    close $output_handle

    add_fileset_file ${entity_name}.sv SYSTEM_VERILOG PATH ${output_file}

}

