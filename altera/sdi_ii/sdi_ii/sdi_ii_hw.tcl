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
# | SDI II v18.1
# | Intel Corporation
# | 
# +-----------------------------------

package require -exact qsys 16.0
package require altera_terp

source sdi_ii_params.tcl
source sdi_ii_ed.tcl
source sdi_ii_qsys_ed.tcl
source sdi_ii_interface.tcl
source sdi_ii_compose_v_series.tcl
source sdi_ii_compose_arria_10.tcl

# +-----------------------------------
# | module SDI II
# | 
set_module_property DESCRIPTION "SDI II"
set_module_property NAME sdi_ii
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Interface Protocols/Audio & Video"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II Intel FPGA IP"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
# set_module_property SIMULATION_MODEL_IN_VERILOG true
# set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property VALIDATION_CALLBACK validate_callback
set_module_property COMPOSITION_CALLBACK compose_callback
# set_module_property HIDE_FROM_QSYS true
set_module_property supported_device_families {{stratix v} {arria v gz} {arria v} {cyclone v} {arria 10}}
set_module_property PARAMETER_UPGRADE_CALLBACK parameter_upgrade_callback
## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.intel.com/content/www/us/en/programmable/documentation/bhc1410937441525.html
add_documentation_link "Release Notes" https://www.intel.com/content/www/us/en/programmable/documentation/hco1421697949076.html
add_documentation_link "Design Example User Guide for Intel Arria 10" https://www.intel.com/content/www/us/en/programmable/documentation/smx1471929114447.html

# | 
# +-----------------------------------
sdi_ii_gui
sdi_ii_common_params
sdi_ii_test_params
sdi_ii_test_pattgen_params

set_parameter_property TEST_GEN_ANC        HDL_PARAMETER false
set_parameter_property TEST_GEN_VPID       HDL_PARAMETER false
set_parameter_property TEST_VPID_PKT_COUNT HDL_PARAMETER false
set_parameter_property TEST_ERR_VPID       HDL_PARAMETER false

set common_composed_mode 0

proc parameter_upgrade_callback {ip_core_type version parameters} {
   foreach { name value } $parameters {
      # This parameter was removed since 17.0
      if { $name != "IS_RTL_SIM" } {
         set_parameter_value $name $value
      }
   }

   if { [get_parameter_value FAMILY] == "Arria 10" } {
      # Upgrade previous SD mode to TR mode as SD is no longer supported on Arria 10
      if { [get_parameter_value VIDEO_STANDARD] == "sd" | [get_parameter_value VIDEO_STANDARD] == "ds" } {
          set_parameter_value VIDEO_STANDARD "tr"
          set_parameter_value RX_EN_VPID_EXTRACT 1
      }
      # Default supported DE variant for HD and 3G single rate was 'None' back in 16.1
      if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 0 } {
          set_parameter_value SELECT_SUPPORTED_VARIANT 1
      }
   }
}

proc validate_callback {} {
    set_parameter_property RX_INC_ERR_TOLERANCE         ENABLED false
    set_parameter_property RX_CRC_ERROR_OUTPUT          ENABLED false
    set_parameter_property RX_EN_VPID_EXTRACT           ENABLED false
    # set_parameter_property RX_EN_TRS_MISC             ENABLED false
    set_parameter_property RX_EN_A2B_CONV               ENABLED false
    set_parameter_property RX_EN_B2A_CONV               ENABLED false
    set_parameter_property TX_HD_2X_OVERSAMPLING        ENABLED false
    set_parameter_property TX_EN_VPID_INSERT            ENABLED false
    set_parameter_property XCVR_TXPLL_TYPE              ENABLED false
    set_parameter_property XCVR_TX_PLL_SEL              ENABLED false
    set_parameter_property SD_BIT_WIDTH                 ENABLED false
    set_parameter_property XCVR_ATXPLL_DATA_RATE        ENABLED false
    set_parameter_property HD_FREQ                      ENABLED false
    set_parameter_property ED_TXPLL_SWITCH              ENABLED false
    set_parameter_property SELECT_CUSTOM_DEVICE         ENABLED false
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS  ENABLED false
    set_parameter_property ENABLE_ED_FILESET_SIM        ENABLED false
    set_parameter_property SELECT_ED_FILESET            ENABLED false
    set_parameter_property SELECT_TARGETED_BOARD        ENABLED false
    set_parameter_property ED_TXPLL_TYPE                ENABLED false

    set fam             [get_parameter_value FAMILY]
    set std             [get_parameter_value VIDEO_STANDARD]
    set dir             [get_parameter_value DIRECTION]
    set a2b             [get_parameter_value RX_EN_A2B_CONV]
    set b2a             [get_parameter_value RX_EN_B2A_CONV]
    set config          [get_parameter_value TRANSCEIVER_PROTOCOL]
    set vpid_insert     [get_parameter_value TX_EN_VPID_INSERT]
    set vpid_extract    [get_parameter_value RX_EN_VPID_EXTRACT]
    set hd_2xos         [get_parameter_value TX_HD_2X_OVERSAMPLING]
    set xcvr_tx_pll_sel [get_parameter_value XCVR_TX_PLL_SEL]
    set txpll           [get_parameter_value XCVR_TXPLL_TYPE]
    set device_part     [get_parameter_value DEVICE]
    # set trs_misc      [get_parameter_value RX_EN_TRS_MISC]

# ############################################################################################
# Configuration options validation
# ############################################################################################
    if { ($std == "tr" | $std == "ds") & $config != "xcvr" } {
        set_parameter_property SD_BIT_WIDTH ENABLED true
    }

# ############################################################################################
# Transceiver options validation
# ############################################################################################
    if { $config != "proto" } {
        set_parameter_property HD_FREQ ENABLED true
        if { $txpll == "ATX" | ($std != "hd" & $std != "dl") } {
            set_parameter_property HD_FREQ ALLOWED_RANGES  {"148.5:148.5 MHz/148.35 MHz"}
        } else {
            set_parameter_property HD_FREQ ALLOWED_RANGES  [list_hd_freq]
        }
    }

    if { $dir != "rx" & $config != "proto" } {
        set_parameter_property  XCVR_TXPLL_TYPE  ENABLED  true
        if { $fam != "Stratix V" & $fam != "Arria V GZ" } {
            set_parameter_property XCVR_TXPLL_TYPE ALLOWED_RANGES "CMU:CMU"
        }
    }

    if { $dir != "rx" & $config != "proto" & $std != "sd"} {
        set_parameter_property XCVR_TX_PLL_SEL  ENABLED true
    }

    if { $txpll == "ATX" } {
        set_parameter_property XCVR_TX_PLL_SEL ALLOWED_RANGES {"0: Off" "1: Tx PLL switching"}
    } else {
        set_parameter_property XCVR_TX_PLL_SEL ALLOWED_RANGES {"0: Off" "1: Tx PLL switching" "2:Tx PLL reference clock switching"}
    }

    if { $fam == "Stratix V" & $txpll == "ATX" } {
        set_parameter_property  XCVR_ATXPLL_DATA_RATE  ENABLED  true
        send_message { Info Text } "Bottom ATX PLLs in transceiver banks of the Stratix V transceiver speed grade 3 devices do not support the data rate required. \
                                    Use top ATX PLL or CMU PLL when targeting transceiver speed grade 3 devices."
    }

    if { $xcvr_tx_pll_sel } {
        if {$dir == "rx"} {
            send_message error "Tx PLL switching can only be enabled for Duplex or Tx direction."
        }
        if {$config == "proto"} {
            send_message error "Tx PLL switching can only be enabled for Transceiver or Combined transceiver/protocol configuration."
        }
        if {$std == "sd"} {
            send_message error "Tx PLL switching is not supported for SD video standard."
        }
    }

# ############################################################################################
# Receiver options validation
# ############################################################################################
    if { ($dir == "du" | $dir == "rx") & $config != "xcvr" } {
        set_parameter_property RX_INC_ERR_TOLERANCE  ENABLED true

        if { $std != "sd"} {
            set_parameter_property RX_CRC_ERROR_OUTPUT ENABLED true
        }
        if { $std != "threeg" && $std != "dl" && $std != "tr" && $std != "mr" } {
            set_parameter_property RX_EN_VPID_EXTRACT    ENABLED true
        }
        # set_parameter_property RX_EN_TRS_MISC     ENABLED true
    } 

    if { $dir == "rx" & $config != "xcvr" } {
        if { $std == "threeg" } {
            set_parameter_property RX_EN_B2A_CONV      ENABLED true
        } elseif { $std == "dl" } {
            set_parameter_property RX_EN_A2B_CONV      ENABLED true
        }
    }

    if { $a2b } {
        if { $dir == "rx" & $std == "dl" & ($config == "xcvr_proto" | $config == "proto") } {
            #send_message info "Enable SMPTE 352M payload extraction for SMPTE 372M example design demonstration"
        } else {
            send_message error "Level A to level B conversion is only supported for HD dual link receiver with protocol block"
        }

        if { !$vpid_extract } {
            send_message error "Enable extract payload ID (SMPTE ST 352) for SMPTE ST 372 design example demonstration"
        }

        # if { !$trs_misc } {
            # send_message error "Enable TRS miscellaneous output ports for SMPTE 372M example design demonstration"
        # }
    }

    if { $b2a } {
        if { $dir == "rx" & $std == "threeg" & ($config == "xcvr_proto" | $config == "proto") } {
            #send_message info "Enable SMPTE 352M payload extraction for SMPTE 372M example design demonstration"
        } else {
            send_message error "Level B to level A conversion is only supported for 3G-SDI receiver with protocol block"
        }

        if { !$vpid_extract } {
            send_message error "Enable extract payload ID (SMPTE ST 352) for SMPTE ST 372 design example demonstration"
        }

        # if { !$trs_misc } {
            # send_message error "Enable TRS miscellaneous output ports for SMPTE 372M example design demonstration"
        # }
    }

    if { ($dir == "rx" | $dir == "du" ) & ($std == "mr" | $std == "tr" | $std == "threeg" | $std == "dl") & $config != "xcvr" } {
        if { !$vpid_extract } {
            send_message error "Enable extract payload ID (SMPTE ST 352) for consistent 1080p video format indication"
        } else {
            send_message { Info Text } "Extract payload ID (SMPTE ST 352) must be enabled for consistent 1080p video format indication"
        }
    }

# ############################################################################################
# Transmitter options validation
# ############################################################################################
    if { ($dir == "du" | $dir == "tx") & $config != "xcvr" } {
        set_parameter_property TX_EN_VPID_INSERT  ENABLED true
    } 

    if { ($hd_2xos) & ($std == "hd") } {
        if { $dir == "du" } {
            send_message error "Two times oversample mode is only supported for HD Transmitter"  
        }
    }

# ############################################################################################
# Arria 10 (or possibly future devices) specific validation
# ############################################################################################
    if { $fam == "Arria 10" } {
        set_parameter_property HD_FREQ                VISIBLE           false
        set_parameter_property XCVR_TXPLL_TYPE        VISIBLE           false
        set_parameter_property XCVR_TX_PLL_SEL        VISIBLE           false
        set_parameter_property TRANSCEIVER_PROTOCOL   VISIBLE           false
        set_parameter_property RX_EN_A2B_CONV         VISIBLE           false
        set_parameter_property RX_EN_B2A_CONV         VISIBLE           false
        set_parameter_property ED_TXPLL_TYPE          VISIBLE           true
        set_parameter_property ED_TXPLL_SWITCH        VISIBLE           true
        set_parameter_property HD_FREQ                HDL_PARAMETER     false
        set_parameter_property XCVR_TXPLL_TYPE        HDL_PARAMETER     false
        set_parameter_property XCVR_TX_PLL_SEL        HDL_PARAMETER     false
        set_parameter_property TRANSCEIVER_PROTOCOL   HDL_PARAMETER     false
        set_parameter_property RX_EN_A2B_CONV         HDL_PARAMETER     false
        set_parameter_property RX_EN_B2A_CONV         HDL_PARAMETER     false
        set_parameter_property VIDEO_STANDARD         ALLOWED_RANGES    [list [get_hd_name] [get_3g_name] [get_tr_name] [get_mr_name]]
        set_display_item_property  "Design Example"   VISIBLE           true
    } else {
        set_parameter_property     VIDEO_STANDARD      ALLOWED_RANGES  [list [get_sd_name] [get_hd_name] [get_3g_name] [get_dl_name] [get_ds_name] [get_tr_name]]
        set_display_item_property  "Design Example"    VISIBLE         false
    }

# ##############################################
# Example Design tab validation
# ##############################################
    # VCXOless design hasn't been tested on ES device before, no char report is available as well.
    if { $std == "mr" | [get_parameter_value BASE_DEVICE] == "NIGHTFURY4ES" | [get_parameter_value BASE_DEVICE] == "NIGHTFURY5ES" | \
        [get_parameter_value BASE_DEVICE] == "NIGHTFURY5ES2" } {
        set_parameter_property  SELECT_SUPPORTED_VARIANT ALLOWED_RANGES { "1:Parallel loopback with external VCXO" "3:Serial loopback"}
    } elseif { $fam == "Arria 10" } {
        set_parameter_property  SELECT_SUPPORTED_VARIANT ALLOWED_RANGES { "1:Parallel loopback with external VCXO" "2:Parallel loopback without external VCXO" \
                                                                          "3:Serial loopback" }
    }
    
    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] != 0 } {
        set_parameter_property ENABLE_ED_FILESET_SYNTHESIS  ENABLED true
        set_parameter_property ENABLE_ED_FILESET_SIM        ENABLED true
        set_parameter_property SELECT_ED_FILESET            ENABLED true
        set_parameter_property SELECT_TARGETED_BOARD        ENABLED true
    }

    if {[get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 0 && [get_parameter_value ENABLE_ED_FILESET_SIM] == 0 && [get_parameter_value FAMILY] == "Arria 10"} {
        send_message warning "At least one of the \"Simulation\" and \"Synthesis\" check boxes from \"Design Example Files\" must be selected to allow generation of Design Example Files."
    }

    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 0 } {
        set_parameter_property  SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" }
    } elseif { $std == "mr" && $dir == "du"} {
        set_parameter_property  SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" "2:Custom Development Kit" }
        send_message { Info Text } "Multi rate Duplex design example is not available on Arria 10 GX FPGA Dev Kit due to Nextera daughter card's pins limitation."
    } else {
        set_parameter_property  SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" "1:Arria 10 GX FPGA Development Kit" "2:Custom Development Kit" }
    }

    if { [get_parameter_value SELECT_TARGETED_BOARD] == 0 } {
        ## No development kit selection
        set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $fam Device $device_part<br><br></html>"
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
        # Intel FPGA development kit selection
        set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
        set devkit_part "10AX115S2F45I1SG"

        if {[get_parameter_value SELECT_CUSTOM_DEVICE] == 1} {
            if {![validate_custom_device $devkit_part]} {
                send_message WARNING "The device selected is not a valid variation of the device on the selected Intel FPGA Development kit. \
                                        Allowed variations are only for 'SerDes Speed Grade'.etc. Check the device part number and try again."
                set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $fam Device $devkit_part<br><br></html>"
                set_parameter_value ED_DEVICE $devkit_part
            } else {
                set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $fam Device $device_part<br><br></html>"
                set_parameter_value ED_DEVICE $device_part
            }
        } else {
          set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $fam Device $devkit_part<br><br></html>"
          set_parameter_value ED_DEVICE $devkit_part
        }

        set_display_item_property target_devkit_txt TEXT \
            "<html>Design Example generation produces the necessary files for Quartus Prime project targeted<br>
            to the selected Intel FPGA development kit.<br>
            <br>
            The field <b>Device Selected</b> under the <b>Targeted Device</b> category below displays the target <br>
            device for the selected Intel FPGA development kit. If your board revision has a different grade <br>
            of this device, you should change it to correct device grade. To change the target device, <br>
            follow instructions provided in the field <b>To change Target Device</b> under <b>Target Device</b> <br>
            below.</html>"

        set_display_item_property custom_device_txt TEXT \
            "<html><b>To change Target Device</b>: First check the <b>Change Target Device</b> box above. Then from <br>
            the menu bar use <b>View</b> -> '<b>Device Family</b>' to select desired device. When completed, <br>
            the <b>Device Selected</b> field above reflects the new device.</html>"

    } else {
        # Custom development kit selection
        set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $fam Device $device_part<br><br></html>"
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
  
    if { $std == "mr" | [get_parameter_value SELECT_SUPPORTED_VARIANT] == 2} {
        set_parameter_property ED_TXPLL_TYPE ALLOWED_RANGES {"fPLL"}
    } else {
        set_parameter_property ED_TXPLL_TYPE ALLOWED_RANGES {"CMU" "fPLL"}
    }

    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] != 0 } {
        set_parameter_property ED_TXPLL_TYPE    ENABLED true
    }

    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 3} {
        set_parameter_property ED_TXPLL_SWITCH              ENABLED true   
    }

    # if { $fam == "Arria 10" & [get_parameter_value ED_TXPLL_TYPE] == "ATX" } {
    #     set_parameter_property ED_TXPLL_SWITCH ALLOWED_RANGES {"0: Off" "2:Tx PLL reference clocks switching"}
    # } else {
    #     set_parameter_property ED_TXPLL_SWITCH ALLOWED_RANGES {"0: Off" "1: Tx PLLs switching" "2:Tx PLL reference clocks switching"}
    # }

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

proc compose_callback {} {
  
  set config       [get_parameter_value TRANSCEIVER_PROTOCOL]
  set dir          [get_parameter_value DIRECTION]
  set insert_vpid  [get_parameter_value TX_EN_VPID_INSERT]
  set extract_vpid [get_parameter_value RX_EN_VPID_EXTRACT]
  set video_std    [get_parameter_value VIDEO_STANDARD]
  set crc_err      [get_parameter_value RX_CRC_ERROR_OUTPUT]
  # set trs_misc     [get_parameter_value RX_EN_TRS_MISC]
  set a2b          [get_parameter_value RX_EN_A2B_CONV]
  set b2a          [get_parameter_value RX_EN_B2A_CONV]
  set device       [get_parameter_value FAMILY]
  set 2xhd         [get_parameter_value TX_HD_2X_OVERSAMPLING]
  set txpll        [get_parameter_value XCVR_TXPLL_TYPE]
  set xcvr_tx_pll_sel [get_parameter_value XCVR_TX_PLL_SEL]
  set atxpll_data_rate [get_parameter_value XCVR_ATXPLL_DATA_RATE]
  set hd_frequency [get_parameter_value HD_FREQ]

   if { $device == "Cyclone V" || $device == "Arria V" || $device == "Stratix V" || $device == "Arria V GZ" } {
      compose_v_series $dir $config $device $video_std $2xhd $txpll $xcvr_tx_pll_sel $insert_vpid $extract_vpid $crc_err $a2b $b2a $atxpll_data_rate $hd_frequency
   } elseif { $device == "Arria 10" } {
      compose_arria_10 $dir $config $device $video_std $2xhd $txpll $xcvr_tx_pll_sel $insert_vpid $extract_vpid $crc_err $a2b $b2a $atxpll_data_rate $hd_frequency
   } 
}

# +-----------------------------------
# | Example design fileset generation
# | 

add_fileset example_design EXAMPLE_DESIGN generate_example
set_fileset_property example_design ENABLE_FILE_OVERWRITE_MODE true

proc generate_example {name} {  
    set family [get_parameter_value FAMILY]

    if { $family == "Cyclone V" || $family == "Arria V" || $family == "Stratix V" || $family == "Arria V GZ" } {
        generate_composed_ed $name $family
    } else {
        generate_qsys_ed
    }
}
