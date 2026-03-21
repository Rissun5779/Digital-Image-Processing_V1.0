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


# +----------------------------------
# | 
# | Audio Embed v10.1
# | Altera Corporation 2009.08.19.17:10:07
# | 
# +-----------------------------------

package require -exact qsys 16.0
package require altera_terp

source altera_hdmi_qsys_ed.tcl
source altera_hdmi_params.tcl
source altera_hdmi_common_proc.tcl
source altera_hdmi_interface.tcl

# +-----------------------------------
# | general
# | 
set_module_property DESCRIPTION "HDMI Intel FPGA IP"
set_module_property NAME altera_hdmi
set_module_property VERSION 18.1
#set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/Audio & Video"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "HDMI Intel FPGA IP"
#set_module_property DATASHEET_URL 
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_QSYS false
set_module_property VALIDATION_CALLBACK validate_callback
set_module_property COMPOSITION_CALLBACK compose_callback
set_module_property SUPPORTED_DEVICE_FAMILIES {{Arria V} {Stratix V} {Arria 10}}

# | 
# +-----------------------------------

# +-----------------------------------
# | Add fileset
# | 
#add_fileset          simulation_verilog SIM_VERILOG   generate_files
#add_fileset          simulation_vhdl    SIM_VHDL      generate_files
#add_fileset          synthesis_fileset  QUARTUS_SYNTH generate_ed_files

#set_fileset_property simulation_verilog TOP_LEVEL   audio_embed
#set_fileset_property simulation_vhdl    TOP_LEVEL   audio_embed
#set_fileset_property synthesis_fileset  TOP_LEVEL   audio_embed
# | 
# +-----------------------------------

# +-----------------------------------
# | Add parameters
# |
altera_hdmi_common_params
# | 
# +-----------------------------------

set common_composed_mode 0

# +-----------------------------------
# | Elaboration Callback
# | 
#proc elaborate_callback {} {

#  set dir [get_parameter_value DIRECTION]
  
  #add_hdmi_export_interface $dir
#}

# +-----------------------------------
# | Validation Callback
# | 
proc validate_callback {} {
    set support_aux [get_parameter_value SUPPORT_AUXILIARY]
    set support_audio [get_parameter_value SUPPORT_AUDIO]
    set dir [get_parameter_value DIRECTION]
    set fam [get_parameter_value FAMILY]
    set device_part [get_parameter_value DEVICE]
    set device_family [get_parameter_value FAMILY]
    set ignore_family [get_parameter_value IGNORE_FAMILY]

    ## Print unsupported message for Ncsim and Xcelium simulator for VHDL
    send_message INFO "HDMI Intel FPGA IP does not support Ncsim and Xcelium simulator for VHDL."

    if { $support_aux == 0 } {
        set_parameter_property SUPPORT_DEEP_COLOR ENABLED false
        set_parameter_property SUPPORT_AUDIO ENABLED false
    } else {
        set_parameter_property SUPPORT_DEEP_COLOR ENABLED true   
        set_parameter_property SUPPORT_AUDIO ENABLED true
    }
    if {$fam == "Cyclone 10 GX" && $ignore_family == 0 } {
        set_parameter_property SYMBOLS_PER_CLOCK ALLOWED_RANGES {2}
    } elseif {$fam == "Arria 10" && $ignore_family == 0 } {
        set_parameter_property SYMBOLS_PER_CLOCK ALLOWED_RANGES {2}
    } elseif {$fam == "Stratix V" && $ignore_family == 0 } {
        set_parameter_property SYMBOLS_PER_CLOCK ALLOWED_RANGES {1 2}
    } else {
        set_parameter_property SYMBOLS_PER_CLOCK ALLOWED_RANGES {1 2 4}
    }
    if { $support_audio == 0 || $support_aux == 0} {
        set_parameter_property SUPPORT_32CHAN_AUDIO ENABLED false
    } else {
        set_parameter_property SUPPORT_32CHAN_AUDIO ENABLED true
    }
  
  if { $dir == "tx" } {
    set_parameter_property SCDC_IEEE_ID HDL_PARAMETER false    
    set_parameter_property SCDC_IEEE_ID ENABLED false
    set_parameter_property SCDC_DEVICE_STRING HDL_PARAMETER false
    set_parameter_property SCDC_DEVICE_STRING ENABLED false
    set_parameter_property SCDC_HW_REVISION HDL_PARAMETER false
    set_parameter_property SCDC_HW_REVISION ENABLED false
    set_parameter_property DISABLE_ALIGN_DESKEW HDL_PARAMETER false
    set_parameter_property DISABLE_ALIGN_DESKEW ENABLED false
    
  } else {
    set_parameter_property SCDC_IEEE_ID HDL_PARAMETER TRUE
    set_parameter_property SCDC_IEEE_ID ENABLED TRUE
    set_parameter_property SCDC_DEVICE_STRING HDL_PARAMETER TRUE
    set_parameter_property SCDC_DEVICE_STRING ENABLED TRUE
    set_parameter_property SCDC_HW_REVISION HDL_PARAMETER TRUE
    set_parameter_property SCDC_HW_REVISION ENABLED TRUE
    set_parameter_property DISABLE_ALIGN_DESKEW HDL_PARAMETER TRUE
    set_parameter_property DISABLE_ALIGN_DESKEW ENABLED TRUE
    
  }

# ##############################################
# Example Design tab validation
# ##############################################

    if {$device_family == "Cyclone 10 GX"} {
       set_display_item_property "Design Example" VISIBLE true
       set_parameter_property  SELECT_SUPPORTED_VARIANT ALLOWED_RANGES { "1:Cyclone10 HDMI RX-TX Retransmit" }
       
    } elseif {$device_family == "Arria 10"} {
       set_display_item_property "Design Example" VISIBLE true
       set_parameter_property  SELECT_SUPPORTED_VARIANT ALLOWED_RANGES { "1:Arria10 HDMI RX-TX Retransmit" }

    } else {
       set_display_item_property "Design Example" VISIBLE false
    }


    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] != 0 } {
        set_parameter_property ENABLE_ED_FILESET_SYNTHESIS  ENABLED true
        set_parameter_property ENABLE_ED_FILESET_SIM        ENABLED true
        set_parameter_property SELECT_ED_FILESET            ENABLED true
        set_parameter_property SELECT_TARGETED_BOARD        ENABLED true
    }

    if {[get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 0 && [get_parameter_value ENABLE_ED_FILESET_SIM] == 0} {
        send_message warning "At least one of the \"Simulation\" and \"Synthesis\" check boxes from \"Design Example Files\" must be selected to allow generation of Design Example Files."
    }

    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 1 } {
       if {$device_family == "Cyclone 10 GX"} {
       set_parameter_property  SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" "1:Cyclone 10 GX FPGA Development Kit" "2:Custom Development Kit" }
       } else {
       set_parameter_property  SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" "1:Arria 10 GX FPGA Development Kit" "2:Custom Development Kit" }
       }
    }

    if { [get_parameter_value SELECT_TARGETED_BOARD] == 0 } {
        ## No development kit selection
        set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $device_part<br><br></html>"
        set_parameter_value ED_DEVICE $device_part

        set_display_item_property target_devkit_txt TEXT \
            "<html>Design Example generation will produce necessary files for Quartus compile. The Quartus<br>
            Settings File (QSF) will have pin assignments set to virtual pins.<br>
            <br>
            The field Device Selected under the <b>Target Device</b> category below displays the target <br>
            device for this Design Example. If you need to change the target device, follow instructions <br> 
            provided in the field <b>To Change Target Device</b> under <b>Target Device</b> below.</html>"

        set_display_item_property custom_device_txt TEXT \
            "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
            desired device. When completed, the <b>Device Selected</b> field above reflects the new device.</html>"

    } elseif { [get_parameter_value SELECT_TARGETED_BOARD] == 1 } {
        # Altera development kit selection
        set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
        if {$device_family == "Cyclone 10 GX"} {
        set devkit_part "10CX220F780C5G"
        } else {
        set devkit_part "10AX115S2F45I1SG"
        }

        if {[get_parameter_value SELECT_CUSTOM_DEVICE] == 1} {
            if {![validate_custom_device $devkit_part]} {
                send_message WARNING "The device selected is not a valid variation of the device on the selected Altera Development kit. \
                                        Allowed variations are only for 'SerDes Speed Grade'.etc. Check the device part number and try again."
                set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $devkit_part<br><br></html>"
                set_parameter_value ED_DEVICE $devkit_part
            } else {
                set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $device_part<br><br></html>"
                set_parameter_value ED_DEVICE $device_part
            }
        } else {
          set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $devkit_part<br><br></html>"
          set_parameter_value ED_DEVICE $devkit_part
        }

        set_display_item_property target_devkit_txt TEXT \
            "<html>Design Example generation produces the necessary files for Quartus Prime project targeted<br>
            to the selected Altera development kit.<br>
            <br>
            The field <b>Device Selected</b> under the <b>Targeted Device</b> category below displays the target <br>
            device for the selected Altera development kit. If your board revision has a different grade <br>
            of this device, you should change it to correct device grade. To change the target device, <br>
            follow instructions provided in the field <b>To change Target Device</b> under <b>Target Device</b> <br>
            below.</html>"

        set_display_item_property custom_device_txt TEXT \
            "<html><b>To change Target Device</b>: First check the <b>Change Target Device</b> box above. Then from <br>
            the menu bar use <b>View</b> -> '<b>Device Family</b>' to select desired device. When completed, <br>
            the <b>Device Selected</b> field above reflects the new device.</html>"

    } else {
        # Custom development kit selection
        set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $device_part<br><br></html>"
        set_parameter_value ED_DEVICE $device_part

        set_display_item_property target_devkit_txt TEXT \
            "<html>Design Example generation produces the necessary files for Quartus Prime project. The <br>
            Quartus Settings File (QSF) includes pin assignment statements without pin number. After the <br>
            Design Example generation, you must edit the QSF file in quartus folder to add pin numbers according to your custom board layout.<br>
            <br>
            The field <b>Device Selected</b> under the <b>Targeted Device</b> category below displays the target <br>
            device for this Design Example. If your board revision has a different device, you should <br>
            change it to correct device. To change the target device, follow instructions provided in <br>
            the field <b>To change Target Device</b> under <b>Target Device</b> below.</html>"

        set_display_item_property custom_device_txt TEXT "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
        desired device. When completed, the <b>Device Selected</b> field above reflects the new device.</html>"
    }

}

proc validate_custom_device { devkit_part } {
    set DEVICE [get_parameter_value DEVICE]
    set DEVKIT_DEVICE $devkit_part

    set success_extract_device_info [regexp -nocase {(^[0-9]*[a-z]*[0-9]*[a-z]*)[0-9]*([a-z]*[0-9]*)[a-z]*[0-9]*[a-z](G)(.*$)} $DEVICE \
                                    full_match device_info_1 device_info_2 device_info_3 device_info_4]
    set success_extract_devkit_device_info [regexp -nocase {(^[0-9]*[a-z]*[0-9]*[a-z]*)[0-9]*([a-z]*[0-9]*)[a-z]*[0-9]*[a-z](G)(.*$)} $DEVKIT_DEVICE \
                                            full_match_devkit devkit_device_info_1 devkit_device_info_2 devkit_device_info_3 devkit_device_info_4]

    if {$success_extract_device_info == 1 && $success_extract_devkit_device_info == 1} {
        if {![string compare -nocase $device_info_1 $devkit_device_info_1] && ![string compare -nocase $device_info_2 $devkit_device_info_2] \
            && ![string compare -nocase $device_info_3 $devkit_device_info_3] && \
            ( [string equal $device_info_4 "E3"] || [string equal $device_info_4 "" ])} {
            ## Added above line to not support NF5ES and ES2 devices, as VCXOless solution is not supported for those device parts
            return 1;
        } else {
            return 0;
        }
    } else {
        return 0;
    }

}


# +-----------------------------------
# | Compose Callback
# | 
proc compose_callback {} {

  set dir [get_parameter_value DIRECTION]
  
  #add_instance clock_bridge altera_clock_bridge

  if { $dir == "tx" } {
    add_instance      u_bitec_hdmi_tx    bitec_hdmi_tx
    propagate_params  u_bitec_hdmi_tx
    
    add_hdmi_tx_export_interface  u_bitec_hdmi_tx
  }
  
  if { $dir == "rx" } {
    add_instance      u_bitec_hdmi_rx    bitec_hdmi_rx
    propagate_params  u_bitec_hdmi_rx
    
    add_hdmi_rx_export_interface  u_bitec_hdmi_rx
  }
  
}

# +-----------------------------------
# | Example design fileset generation
# | 

add_fileset example_design EXAMPLE_DESIGN generate_example
set_fileset_property example_design ENABLE_FILE_OVERWRITE_MODE true

proc generate_example {name} {
    set family [get_parameter_value FAMILY]
    set sv "Stratix V"
    set av "Arria V"
    set avgz "Arria V GZ"
    set design_name($av) "av_sk_hdmi2"
    set design_name($sv) "sv_hdmi2"
    set design_name($avgz) "av_gz_hdmi2"

    if { $family == "Arria V" || $family == "Stratix V" || $family == "Arria V GZ" } {
        generate_copy_ed $design_name($family)
    } else {
        generate_qsys_ed
    }
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.intel.com/content/www/us/en/programmable/documentation/vgo1401099304599.html
add_documentation_link "Release Notes" https://www.intel.com/content/www/us/en/programmable/documentation/hco1421697823968.html
add_documentation_link "Design Example User Guide for Intel Arria 10" https://www.intel.com/content/www/us/en/programmable/documentation/aky1476080261496.html

