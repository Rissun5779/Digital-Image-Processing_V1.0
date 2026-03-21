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


# $Id: //acds/rel/18.1std/ip/altera_remote_update/altera_remote_update_hw.tcl#3 $
# $Revision: #3 $
# $Date: 2018/08/24 $
# $Author: cheehang $

package require -exact qsys 14.0
# Source files
source altera_remote_update_hw_core_proc.tcl
# +-----------------------------------
# | module Remote Update
# +-----------------------------------
set_module_property NAME altera_remote_update
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Remote Update Intel FPGA IP"
set_module_property DESCRIPTION "The Altera Remote Update megafunction provides features to download a new configuration image \
                                    from remote location, store in configuration device, and direct the dedicated remote system \
                                    upgrade circuitry to reconfigure itself with new configuration data."
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_altremote.pdf?GSA_pos=5&WT.oss_r=1&WT.oss=remote update"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true 
set_module_property VALIDATION_CALLBACK  validation
set_module_property COMPOSITION_CALLBACK compose

set supported_device_families_list {"Arria 10" "Arria II GX" "Arria II GZ" "Arria V" "Arria V GZ" \
                                    "Cyclone IV E" "Cyclone IV GX" "Cyclone V" \
                                    "Stratix IV" "Stratix V" "Cyclone 10 LP"}

set supported_spi_devices_list {"EPCS1" "EPCS4" "EPCS16" "EPCS64" "EPCS128" \
                                "EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ256" "EPCQ512"\
                                "EPCQL256" "EPCQL512" "EPCQL1024" \
                                "EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" \
                                "MX25L128" "MX25U128" "MX25L256" "MX25U256" \
                                "MX25L512" "MX25U512" "MX66U512" "MX66U1G" \
                                "MX66U2G" "S25FL128" "S25FL256" "S25FL512"}
                            
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list

add_display_item "" "General" GROUP tab


# +-----------------------------------
# | Device family
# +-----------------------------------
add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}

# +-----------------------------------
# | Device part
# +-----------------------------------
add_parameter DEVICE STRING
set_parameter_property DEVICE DISPLAY_NAME "Device part"
set_parameter_property DEVICE VISIBLE false
set_parameter_property DEVICE SYSTEM_INFO {DEVICE}

#+--------------------------------------------
#|  clearbox auto blackbox flag
#+--------------------------------------------
add_parameter           CBX_AUTO_BLACKBOX   STRING              "ALL"
set_parameter_property  CBX_AUTO_BLACKBOX   DESCRIPTION         "Flag clearbox to blackbox other clearbox components or include them in the output variation file."
set_parameter_property  CBX_AUTO_BLACKBOX   VISIBLE             false
set_parameter_property  CBX_AUTO_BLACKBOX   AFFECTS_GENERATION  true

# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------

#set operation mode 
add_parameter operation_mode STRING
set_parameter_property operation_mode DEFAULT_VALUE "REMOTE"
set_parameter_property operation_mode DISPLAY_NAME "Which operation mode will you be using?"
set_parameter_property operation_mode DESCRIPTION "Select the operation mode"
set_parameter_property operation_mode TYPE STRING
set_parameter_property operation_mode AFFECTS_GENERATION true
set_parameter_property operation_mode ALLOWED_RANGES {"REMOTE"}
set_parameter_property operation_mode ENABLED true
add_display_item "General" operation_mode parameter

#select configuration device
add_parameter GUI_config_device STRING
set_parameter_property GUI_config_device DEFAULT_VALUE "EPCQ256"
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

# add Add support for writing configuration parameters 
add_parameter check_avalon_interface boolean 
set_parameter_property check_avalon_interface DEFAULT_VALUE 0
set_parameter_property check_avalon_interface DISPLAY_NAME "Add support for Avalon Interface"
set_parameter_property check_avalon_interface DESCRIPTION "Turn on this option to use Avalon Interface"
set_parameter_property check_avalon_interface AFFECTS_GENERATION true
set_parameter_property check_avalon_interface AFFECTS_ELABORATION true
add_display_item "General" check_avalon_interface parameter

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
add_parameter in_data_width INTEGER 
set_parameter_property in_data_width DEFAULT_VALUE 24
set_parameter_property in_data_width TYPE INTEGER
set_parameter_property in_data_width AFFECTS_GENERATION true
set_parameter_property in_data_width AFFECTS_ELABORATION true
set_parameter_property in_data_width DERIVED true
set_parameter_property in_data_width VISIBLE false

#set data output width
add_parameter out_data_width INTEGER 
set_parameter_property out_data_width DEFAULT_VALUE 24
set_parameter_property out_data_width TYPE INTEGER
set_parameter_property out_data_width AFFECTS_GENERATION true
set_parameter_property out_data_width AFFECTS_ELABORATION true
set_parameter_property out_data_width DERIVED true
set_parameter_property out_data_width VISIBLE false

# +-----------------------------------
# | Fileset Callbacks and Generation
# +----------------------------------- 
proc validation { } {
    # --- check ini for hidden devices --- #
    set enable_MT25Q        1
    set get_spi_list        [get_parameter_property GUI_config_device   ALLOWED_RANGES]
    if {$enable_MT25Q == 1} {
        lappend get_spi_list    "MT25QL256"
        lappend get_spi_list    "MT25QL512"
        lappend get_spi_list    "MT25QU256"
        lappend get_spi_list    "MT25QU512"
        lappend get_spi_list    "MT25QU01G"
    }
    set_parameter_property  GUI_config_device   ALLOWED_RANGES      $get_spi_list       
}

proc compose { } {

    set get_device_family [get_parameter_value DEVICE_FAMILY]
    
    if {$get_device_family == "Cyclone IV E" || $get_device_family == "Cyclone IV GX" || $get_device_family == "Cyclone 10 LP"} {
        set read_source_port_used 1
    } else {
        set read_source_port_used 0
    }
    
    set check_app_pof_supported_families [list \
        "Arria II GX" \
        "Arria II GZ" \
        "Arria V" \
        "Arria V GZ" \
        "Cyclone IV E" \
        "Cyclone 10 LP" \
        "Cyclone IV GX" \
        "Cyclone V" \
        "Stratix IV" \
        "Stratix V" \
    ]
    
    if { [lsearch $check_app_pof_supported_families $get_device_family] == -1 } {
        set_parameter_property check_app_pof ENABLED false
    }

    # +--------------------------------------
    # | EPCQ EPCS equivalent
    # +--------------------------------------

    set set_config_device [get_parameter_value GUI_config_device]
   
    if {[string first "EPCS" $set_config_device] == 0} {
        set_parameter_value is_epcq false
    } else {
        set_parameter_value is_epcq true
    }

    set set_data_out [get_parameter_value out_data_width]   
    set set_writeparam [get_parameter_value m_support_write_config_check]   
    set set_pof [get_parameter_value check_app_pof] 
    set set_use_avalon [get_parameter_value check_avalon_interface] 

    # Instances and instance parameters
    add_instance clk_bridge altera_clock_bridge 18.1
    set_instance_parameter_value clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
    set_instance_parameter_value clk_bridge {NUM_CLOCK_OUTPUTS} {1}

    add_instance reset_bridge altera_reset_bridge 18.1
    set_instance_parameter_value reset_bridge {ACTIVE_LOW_RESET} {0}
    set_instance_parameter_value reset_bridge {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value reset_bridge {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value reset_bridge {USE_RESET_REQUEST} {0}

    add_instance remote_update_core altera_remote_update_core 18.1
    set_instance_parameter_value remote_update_core {CBX_AUTO_BLACKBOX} {ALL}
    set_instance_parameter_value remote_update_core {operation_mode} {REMOTE}
    set_instance_parameter_value remote_update_core {GUI_config_device} $set_config_device
    set_instance_parameter_value remote_update_core {m_support_write_config_check} $set_writeparam
    set_instance_parameter_value remote_update_core {check_app_pof} $set_pof

    # connections and connection parameters
    add_connection clk_bridge.out_clk reset_bridge.clk clock

    add_connection clk_bridge.out_clk remote_update_core.clock clock
    add_connection reset_bridge.out_reset remote_update_core.reset reset

    if {$set_use_avalon == "true"} {
        add_instance remote_update_controller altera_avalon_remote_update_controller 18.1
        set_instance_parameter_value remote_update_controller {GUI_config_device} $set_config_device
        set_instance_parameter_value remote_update_controller {m_support_write_config_check} $set_writeparam
        set_instance_parameter_value remote_update_controller {check_app_pof} $set_pof

        add_connection clk_bridge.out_clk remote_update_controller.clk clock
        add_connection reset_bridge.out_reset remote_update_controller.reset reset

        add_interface avl_csr avalon slave
        set_interface_property avl_csr EXPORT_OF remote_update_controller.avl_csr

        add_connection remote_update_controller.read_param remote_update_core.read_param conduit
        add_connection remote_update_controller.param remote_update_core.param conduit
        add_connection remote_update_controller.reconfig remote_update_core.reconfig conduit
        add_connection remote_update_controller.reset_timer remote_update_core.reset_timer conduit
        add_connection remote_update_controller.busy remote_update_core.busy conduit
        add_connection remote_update_controller.data_out remote_update_core.data_out conduit

        if {$set_writeparam == "true"} {
            add_connection remote_update_controller.write_param remote_update_core.write_param conduit
            add_connection remote_update_controller.data_in remote_update_core.data_in conduit
        }

        if {$read_source_port_used == 1} {
            add_connection remote_update_controller.read_source remote_update_core.read_source conduit
        }

        if {$get_device_family == "Arria 10"} {
            add_connection remote_update_controller.ctl_nupdt remote_update_core.ctl_nupdt conduit
        }
    } else {
        add_interface busy conduit start
        set_interface_property busy PORT_NAME_MAP "busy busy_busy"
        set_interface_property busy EXPORT_OF remote_update_core.busy
        add_interface data_out conduit start
        set_interface_property data_out EXPORT_OF remote_update_core.data_out
        add_interface param conduit end
        set_interface_property param EXPORT_OF remote_update_core.param
        add_interface read_param conduit end
        set_interface_property read_param EXPORT_OF remote_update_core.read_param
        add_interface reconfig conduit end
        set_interface_property reconfig EXPORT_OF remote_update_core.reconfig
        add_interface reset reset sink
        set_interface_property reset EXPORT_OF reset_bridge.in_reset
        add_interface reset_timer conduit end
        set_interface_property reset_timer EXPORT_OF remote_update_core.reset_timer
        if {$set_writeparam == "true"} {
            add_interface write_param conduit end
            set_interface_property write_param EXPORT_OF remote_update_core.write_param
            add_interface data_in conduit end
            set_interface_property data_in EXPORT_OF remote_update_core.data_in
        }
        if {$read_source_port_used == 1} {
            add_interface read_source conduit end
            set_interface_property read_source EXPORT_OF remote_update_core.read_source
        }

        if {$get_device_family == "Arria 10"} {
            add_interface ctl_nupdt conduit end
            set_interface_property ctl_nupdt EXPORT_OF remote_update_core.ctl_nupdt
        }
    }


    # exported interfaces
    add_interface clock clock sink
    set_interface_property clock EXPORT_OF clk_bridge.in_clk

    add_interface reset reset sink
    set_interface_property reset EXPORT_OF reset_bridge.in_reset

    if {$set_pof == "true"} {
        add_interface asmi_busy conduit end
        set_interface_property asmi_busy EXPORT_OF remote_update_core.asmi_busy
        add_interface asmi_data_valid conduit end
        set_interface_property asmi_data_valid EXPORT_OF remote_update_core.asmi_data_valid
        add_interface asmi_dataout conduit end
        set_interface_property asmi_dataout EXPORT_OF remote_update_core.asmi_dataout
        add_interface pof_error conduit end
        set_interface_property pof_error EXPORT_OF remote_update_core.pof_error
        add_interface asmi_addr conduit end
        set_interface_property asmi_addr EXPORT_OF remote_update_core.asmi_addr
        add_interface asmi_read conduit end
        set_interface_property asmi_read EXPORT_OF remote_update_core.asmi_read
        add_interface asmi_rden conduit end
        set_interface_property asmi_rden EXPORT_OF remote_update_core.asmi_rden
        add_interface pof_error conduit end
        set_interface_property pof_error EXPORT_OF remote_update_core.pof_error
    }
    # Call rename all ports only no avalon is in used
    # so that we can maintain the same port name 
    if {$set_use_avalon eq "false"} {
        rename_port_name
    } else {
        set_interface_property clock PORT_NAME_MAP "clock in_clk"
        set_interface_property reset PORT_NAME_MAP "reset in_reset"
    }
}

proc rename_port_name { } {
    #read interfaces from compose components
    foreach interface [get_interfaces] {
        #send_message INFO "interface found: $interface"
        # For each inteface, find the port in the child instance
        # and overwrite them to same name as child
        if {$interface eq "clock"} {
            set_interface_property clock PORT_NAME_MAP "clock in_clk"
        } elseif {$interface eq "reset"} {
            set_interface_property reset PORT_NAME_MAP "reset in_reset"
        } else {
            foreach port [get_instance_interface_ports remote_update_core $interface] {
                set the_ports($port) $port
            }
            set_interface_property $interface PORT_NAME_MAP [array get the_ports]
        }
        
    }
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sam1412657373811/sss1432869089964 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
