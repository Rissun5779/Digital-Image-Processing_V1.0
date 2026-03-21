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


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/altera_remote_update/altera_remote_update_core_hw.tcl#2 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1
# Source files
source altera_remote_update_hw_core_proc.tcl

# +-----------------------------------
# | module Remote Update
# +-----------------------------------
set_module_property NAME altera_remote_update_core
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Altera Remote Update Core"
set_module_property DESCRIPTION "The Altera Remote Update megafunction provides features to download a new configuration image \
									from remote location, store in configuration device, and direct the dedicated remote system \
									upgrade circuitry to reconfigure itself with new configuration data."
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL true
set_module_property AUTHOR "Altera Corporation"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_altremote.pdf?GSA_pos=5&WT.oss_r=1&WT.oss=remote update"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true 


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

#set configuration device 
#add_parameter config_device_addr_width STRING
#set_parameter_property config_device_addr_width DEFAULT_VALUE 24 
#set_parameter_property config_device_addr_width DISPLAY_NAME "Which configuration device will you be using?"
#set_parameter_property config_device_addr_width DESCRIPTION "Select the configuration device"
#set_parameter_property config_device_addr_width TYPE STRING
#set_parameter_property config_device_addr_width UNITS BITS
#set_parameter_property config_device_addr_width AFFECTS_GENERATION true
#set_parameter_property config_device_addr_width AFFECTS_ELABORATION true
#set_parameter_property config_device_addr_width ALLOWED_RANGES {"24:EPCQ1" "10:EPCQ16" "32:EPCQ512"}
#set_parameter_property config_device_addr_width ENABLED true
#add_display_item "General" config_device_addr_width parameter

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
# | static connection point - input
# +-----------------------------------
add_interface read_param conduit end
add_interface_port read_param read_param read_param Input 1
set_interface_assignment read_param "ui.blockdiagram.direction" INPUT
set_interface_property read_param ENABLED true

add_interface param conduit end
add_interface_port param param param Input 3
set_interface_assignment param "ui.blockdiagram.direction" INPUT
set_interface_property param ENABLED true

add_interface reconfig conduit end
add_interface_port reconfig reconfig reconfig Input 1
set_interface_assignment reconfig "ui.blockdiagram.direction" INPUT
set_interface_property reconfig ENABLED true  

add_interface reset_timer conduit end
add_interface_port reset_timer reset_timer reset_timer Input 1
set_interface_assignment reset_timer "ui.blockdiagram.direction" INPUT
set_interface_property reset_timer ENABLED true 

set clock "clock"
add_interface $clock clock end
add_interface_port $clock $clock clk Input 1
set_interface_assignment clock "ui.blockdiagram.direction" INPUT
set_interface_property clock ENABLED true 

set reset "reset"
add_interface $reset reset end
set_interface_property $reset associatedClock clock
add_interface_port $reset $reset reset Input 1
set_interface_assignment reset "ui.blockdiagram.direction" INPUT
set_interface_property reset ENABLED true 

# +-----------------------------------
# | static connection point - output
# +----------------------------------- 
add_interface busy conduit start
add_interface_port busy busy busy Output 1
set_interface_assignment busy "ui.blockdiagram.direction" OUTPUT
set_interface_property busy ENABLED true

add_interface data_out conduit start
#data_out port width set in elaboration callback
set_interface_assignment data_out "ui.blockdiagram.direction" OUTPUT
set_interface_property data_out ENABLED true

# +-----------------------------------
# | Fileset Callbacks and Generation
# +----------------------------------- 
set_module_property ELABORATION_CALLBACK elaboration_callback

#+-------------------------------------------------------------------------------------------------------------------------
#|  Quartus synth
#+-------------------------------------------------------------------------------------------------------------------------

add_fileset             quartus_synth   QUARTUS_SYNTH   do_quartus_synth
set_fileset_property    quartus_synth   TOP_LEVEL       altera_remote_update_core


proc do_quartus_synth {output_name} {
    send_message    info    "Generating top-level entity $output_name."
    # Find out if the family is Arria 10 but not NF5ES
    set is_arria10_except_nf5es [check_arria10_except_nf5es]
    if {$is_arria10_except_nf5es == 1} {
    # if Arria 10 uses new source file
    add_fileset_file altera_remote_update_core.sv SYSTEM_VERILOG PATH "altera_remote_update_core.sv"
    } else {
        do_quartus_synth_cbx altera_remote_update_core
    }
}

proc do_quartus_synth_cbx {output_name} {
    
    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file   [create_temp_file "parameter_list"]
    set cbx_var_file     [create_temp_file ${output_name}.v]

    #get all parameters and ports#
    set parameters_list   [parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
     }
    set ports_list     [ports_transfer]
    if {$ports_list eq ""}  {
        send_message error "Failure in proc ports_transfer, stopping synthesis fileset generation!"
     }

    # Generate clearbox parameter file
    set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
    if {$status eq "false"} {
        send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
        return
     }

    # Execute clearbox to produce a variation file
    set status      [do_clearbox_gen altremote_update $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
     }

    # Add the variation to the fileset
    add_fileset_file ${output_name}.v VERILOG PATH $cbx_var_file
}


#+-------------------------------------------------------------------------------------------------------------------------
#|  Quartus simulation 
#+-------------------------------------------------------------------------------------------------------------------------
add_fileset             verilog_sim SIM_VERILOG     do_quartus_synth
set_fileset_property    verilog_sim TOP_LEVEL       altera_remote_update_core

add_fileset             vhdl_sim    SIM_VHDL    do_vhdl_sim
set_fileset_property    vhdl_sim    TOP_LEVEL   altera_remote_update_core

proc do_vhdl_sim {output_name} {
 # Find out if the family is Arria 10 (not NF5ES)
    set is_arria10_except_nf5es [check_arria10_except_nf5es]
    if {$is_arria10_except_nf5es == 1} {
        do_vhdl_sim_encrypt_file altera_remote_update_core
    } else {
        do_vhdl_sim_cbx altera_remote_update_core
    }
}

proc do_vhdl_sim_cbx {output_name} {
    # Create temp files for clearbox parameters and variation file output
    set cbx_param_file   [create_temp_file "parameter_list"]
    set cbx_var_file     [create_temp_file ${output_name}.vhd]

    #get all parameters and ports#
    set parameters_list   [parameters_transfer]
    if {$parameters_list eq ""} {
        send_message error "Failure in proc parameters_transfer, stopping synthesis fileset generation! "
        return
     }
    set ports_list     [ports_transfer]
    if {$ports_list eq ""}  {
        send_message error "Failure in proc ports_transfer, stopping synthesis fileset generation!"
     }

    # Generate clearbox parameter file
    set status [generate_clearbox_parameter_file $cbx_param_file $parameters_list $ports_list]
    if {$status eq "false"} {
        send_message error "Failure in proc generate_clearbox_parameter_file, stopping synthesis fileset generation!"
        return
     }

    # Execute clearbox to produce a variation file
    set status      [do_clearbox_gen altremote_update $cbx_param_file $cbx_var_file]
    if {$status eq "false"} {
        send_message error "Failure in proc do_clearbox_gen, stopping synthesis fileset generation!"
        return
     }


     # Add the variation to the fileset
    add_fileset_file ${output_name}.vhd VHDL PATH $cbx_var_file

}

#//////////////////////////////////////////////////////////////////////////
#
# Name:     elaboration_callback
#
# Purpose:  Update device parameters and port settings
#
#//////////////////////////////////////////////////////////////////////////
proc elaboration_callback {} {

    set get_device_family [get_parameter_value DEVICE_FAMILY]

    update_device_type_params $get_device_family
    if {$get_device_family == "Arria 10"} {
        check_arria10_device_is_not_unknown 
    }
    # +---------------------------------------------
    # | Enable ports/options based on device family
    # +----------------------------------------------
    
    if {$get_device_family == "Cyclone IV E" || $get_device_family == "Cyclone IV GX" || $get_device_family == "Cyclone 10 LP"} {
        add_interface read_source conduit end
        add_interface_port read_source read_source read_source Input 2
        set_interface_assignment read_source "ui.blockdiagram.direction" INPUT
        set_interface_property read_source ENABLED true
    }
    
    set check_app_pof_supported_families [list \
        "Arria II GX" \
        "Arria II GZ" \
        "Arria V" \
        "Arria V GZ" \
        "Cyclone IV E" \
        "Cyclone IV GX" \
        "Cyclone 10 LP" \
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

    # This to check old device EPCQ/S
    if { [string range $set_config_device 0 3] == "EPCQ" ||
         [string range $set_config_device 0 3] == "EPCS" } {
         if { [string range $set_config_device 4 6] <= 128 || [string index $set_config_device end] == "A" } {
            # For EPCQXXA: only support less than or equal 128
            set_parameter_value in_data_width 24
            set_parameter_value out_data_width 24
            set_parameter_value config_device_addr_width 24
            
            if {$get_device_family == "Cyclone IV E" ||$get_device_family == "Cyclone IV GX" || $get_device_family == "Cyclone 10 LP"} {
                 set_parameter_value out_data_width 29
            }
            # Arria 10 Remote Update does not support device that smaller or equal 128
            if {$get_device_family == "Arria 10"} {
                send_message error "altera_remote_update for Arria 10 does not support configuration devices smaller or equal 128 Mbits"
            }
        } else {
            set_parameter_value in_data_width 32
            set_parameter_value out_data_width 32
            set_parameter_value config_device_addr_width 32
        }
    # This to check new added third party flashes 
    # these flashes are fixed 3 bytes address, so they cannot be used with A10
    } elseif {$set_config_device == "MX25L128" || $set_config_device == "MX25U128" || 
               $set_config_device == "MX25L256" || $set_config_device == "MX25L512" ||
               $set_config_device == "MX66U512" || $set_config_device == "S25FL128" ||
               $set_config_device == "S25FL256" || $set_config_device == "S25FL512" } {

        set_parameter_value in_data_width 24
        set_parameter_value out_data_width 24
        set_parameter_value config_device_addr_width 24
            
        if {$get_device_family == "Cyclone IV E" ||$get_device_family == "Cyclone IV GX" || $get_device_family == "Cyclone 10 LP"} {
            set_parameter_value out_data_width 29
        }
        # Arria 10 Remote Update does not support device that smaller or equal 128
        if {$get_device_family == "Arria 10"} {
            send_message error "altera_remote_update for Arria 10 does not support these configuration devices"
        }
    # These Macronix are special, same device type but different suffix, one support 3 bytes, one 4 bytes
    } elseif {$set_config_device == "MX25U256" || $set_config_device == "MX25U512" ||
               $set_config_device == "MX66U1G" || $set_config_device == "MX66U2G"} {
        set_parameter_value in_data_width 24
        set_parameter_value out_data_width 24
        set_parameter_value config_device_addr_width 24
            
        if {$get_device_family == "Cyclone IV E" ||$get_device_family == "Cyclone IV GX" || $get_device_family == "Cyclone 10 LP"} {
            set_parameter_value out_data_width 29
        }
        # Arria 10 Remote Update does not support device that smaller or equal 128
        if {$get_device_family == "Arria 10"} {
            send_message info "Please make sure to use flash OPN with default 4 bytes address mode - suffix: 54"
            # If A10, then turn on 4 byte address, but send info to users.
            set_parameter_value in_data_width 32
            set_parameter_value out_data_width 32
            set_parameter_value config_device_addr_width 32
        }
    } else {
        # Those MT are more than 128
        set_parameter_value in_data_width 32
        set_parameter_value out_data_width 32
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
    set set_data_out [get_parameter_value out_data_width]   
    add_interface_port data_out data_out data_out Output $set_data_out
    
    # +----------------------------------------------------
    # | Enable support for writing configuration parameters
    # +----------------------------------------------------
    set set_writeparam [get_parameter_value m_support_write_config_check]   
    #VERIFY:double check on naming
    # +----------------------------------------------------------------------
    # | This is a trick to deal with clearbox and IPUTF generate flow
    # | clearbox: generate the port it need and write to HDL file
    # | IPUTF generate: the ports are ALWAYS exist in HDL file (unless use terp file)
    # | So for new code in Arria10. Add in the two ports first then only terminated (only
    # | inside the hw.tcl) -> the top wrapper file will not connect these ports to top level
    # | and assign default value (0) to these Inputs. Which from user point of view,
    # | the write function is disable and inside the HDL, these ports are fed with 0
    # | this to avoid unwanted operation and break clearbox generation
    # +----------------------------------------------------------------------
    set is_arria10_except_nf5es [check_arria10_except_nf5es]
    if {$is_arria10_except_nf5es == 1} {
            add_interface write_param conduit end
            add_interface_port write_param write_param write_param Input 1
            set_interface_assignment write_param "ui.blockdiagram.direction" INPUT
            add_interface data_in conduit end
            set set_data_in [get_parameter_value in_data_width] 
            add_interface_port data_in data_in data_in Input $set_data_in
            set_interface_assignment data_in "ui.blockdiagram.direction" INPUT
            if {$set_writeparam == "true"} {
                set_interface_property write_param ENABLED true
                set_interface_property data_in ENABLED true
            } else {
                set_interface_property write_param ENABLED false
                set_interface_property data_in ENABLED false
            }
    } else {
        if {$set_writeparam == "true"} {
            add_interface write_param conduit end
            add_interface_port write_param write_param write_param Input 1
            set_interface_assignment write_param "ui.blockdiagram.direction" INPUT
            set_interface_property write_param ENABLED true
            
            add_interface data_in conduit end
            set set_data_in [get_parameter_value in_data_width] 
            add_interface_port data_in data_in data_in Input $set_data_in
            set_interface_assignment data_in "ui.blockdiagram.direction" INPUT
            set_interface_property data_in ENABLED true
        }
    }

    
    # +------------------------------
    # | Enable reconfig POF checking
    # +------------------------------
    set set_pof [get_parameter_value check_app_pof] 
    
    if {$set_pof == "true"} {
        add_interface asmi_busy conduit end
        add_interface_port asmi_busy asmi_busy asmi_busy Input 1
        set_interface_assignment asmi_busy "ui.blockdiagram.direction" INPUT
        set_interface_property asmi_busy ENABLED true
        
        add_interface asmi_data_valid conduit end
        add_interface_port asmi_data_valid asmi_data_valid asmi_data_valid Input 1
        set_interface_assignment asmi_data_valid "ui.blockdiagram.direction" INPUT
        set_interface_property asmi_data_valid ENABLED true
        
        add_interface asmi_dataout conduit end
        add_interface_port asmi_dataout asmi_dataout asmi_dataout Input 8
        set_interface_assignment asmi_dataout "ui.blockdiagram.direction" INPUT
        set_interface_property asmi_dataout ENABLED true
        
        add_interface pof_error conduit start
        add_interface_port pof_error pof_error pof_error Output 1
        set_interface_assignment pof_error "ui.blockdiagram.direction" OUTPUT
        set_interface_property pof_error ENABLED true
        
        add_interface asmi_addr conduit start       
        set set_asmi_addr [get_parameter_value config_device_addr_width]    
        add_interface_port asmi_addr asmi_addr asmi_addr Output $set_asmi_addr
        set_interface_assignment asmi_addr "ui.blockdiagram.direction" OUTPUT
        set_interface_property asmi_addr ENABLED true
        
        add_interface asmi_read conduit start
        add_interface_port asmi_read asmi_read asmi_read Output 1
        set_interface_assignment asmi_read "ui.blockdiagram.direction" OUTPUT
        set_interface_property asmi_read ENABLED true
        
        add_interface asmi_rden conduit start
        add_interface_port asmi_rden asmi_rden asmi_rden Output 1
        set_interface_assignment asmi_rden "ui.blockdiagram.direction" OUTPUT
        set_interface_property asmi_rden ENABLED true
    } 
    
    # +----------------------------------------------------
    # | Enable ctl_nupdt for Arria 10
    # +----------------------------------------------------
    
    add_interface ctl_nupdt conduit end
    add_interface_port ctl_nupdt ctl_nupdt ctl_nupdt Input 1
    set_interface_assignment ctl_nupdt "ui.blockdiagram.direction" INPUT
        
    if {$get_device_family == "Arria 10"} {
        set_interface_property ctl_nupdt ENABLED true
    } else {
        set_interface_property ctl_nupdt ENABLED false
    }
}   

#+----------------------------------------------------------------------------------------------------------------------------
#|  Parameters and ports transfer procedure
#+----------------------------------------------------------------------------------------------------------------------------

proc parameters_transfer {}   {

     #get all parameters#
     set param_list   [get_parameters]
     foreach param   $param_list    {
        set  param_arr($param)    [get_parameter_value  $param]
     }
	
	 #set lpm_file [get_parameter_value LPM_FILE]
	 #if {$lpm_file == ""} {
	#	unset param_arr(LPM_FILE)
	 #}

     set parameters_list     [array get param_arr]
     return $parameters_list
}

proc ports_transfer {}   {

      set all_ports [get_interface_ports]
      return $all_ports
}

proc do_vhdl_sim_encrypt_file {output_name} {

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

    set vendor_uppercase "[ string toupper $vendor ]"
    add_fileset_file ${vendor}/altera_remote_update_core.sv SYSTEM_VERILOG_ENCRYPT PATH "${vendor}/altera_remote_update_core.sv"   "${vendor_uppercase}_SPECIFIC"
}

