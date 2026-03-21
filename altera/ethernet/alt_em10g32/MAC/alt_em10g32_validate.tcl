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


proc validate {} {
    set ENABLE_TIMESTAMPING [get_parameter_value ENABLE_TIMESTAMPING]
    set ENABLE_UNIDIRECTIONAL [get_parameter_value ENABLE_UNIDIRECTIONAL]
    set ENABLE_PTP_1STEP [get_parameter_value ENABLE_PTP_1STEP]
    set INSERT_ST_ADAPTOR [get_parameter_value INSERT_ST_ADAPTOR]
    set INSERT_CSR_ADAPTOR [get_parameter_value INSERT_CSR_ADAPTOR]
    set INSERT_XGMII_ADAPTOR [get_parameter_value INSERT_XGMII_ADAPTOR]
    set ENABLE_1G10G_MAC [get_parameter_value ENABLE_1G10G_MAC]
    set ENABLE_MEM_ECC [get_parameter_value ENABLE_MEM_ECC]
    set ENABLE_PFC [get_parameter_value ENABLE_PFC]
    set DATAPATH_OPTION [get_parameter_value DATAPATH_OPTION]
    set INSTANTIATE_STATISTICS [get_parameter_value INSTANTIATE_STATISTICS]
    set PREAMBLE_PASSTHROUGH [get_parameter_value PREAMBLE_PASSTHROUGH]
    set ENABLE_10GBASER_REG_MODE [get_parameter_value ENABLE_10GBASER_REG_MODE]
    set SHOW_HIDDEN_OPTIONS [get_parameter_value SHOW_HIDDEN_OPTIONS]
    set ENABLE_ED_FILESET_SYNTHESIS [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS]
    set ENABLE_ED_FILESET_SIM [get_parameter_value ENABLE_ED_FILESET_SIM]
    set SELECT_TARGETED_DEVICE [get_parameter_value SELECT_TARGETED_DEVICE]
    set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]
    set DEVICE [get_parameter_value DEVICE]
    set DEVKIT_DEVICE [get_parameter_value DEVKIT_DEVICE]
    set SELECT_CUSTOM_DEVICE [get_parameter_value SELECT_CUSTOM_DEVICE]
    set QSF_PATH [get_parameter_value QSF_PATH]
    
    #example design parameters
    set SELECT_SUPPORTED_VARIANT [get_parameter_value SELECT_SUPPORTED_VARIANT]

    set_parameter_property PREAMBLE_PASSTHROUGH ENABLED true
    set_parameter_property ENABLE_UNIDIRECTIONAL ENABLED true    
    set_parameter_property ENABLE_PFC ENABLED true  
    set_parameter_property PFC_PRIORITY_NUMBER ENABLED true
    set_parameter_property ENABLE_MEM_ECC ENABLED true
    set_parameter_property INSERT_XGMII_ADAPTOR ENABLED true
    set_parameter_property ENABLE_TIMESTAMPING ENABLED true
    set_parameter_property INSERT_ST_ADAPTOR ENABLED true
    set_parameter_property INSERT_CSR_ADAPTOR ENABLED true
 
    if {[_is_device_family "Arria V"]} {
        set_parameter_property ENABLE_MEM_ECC ENABLED false
    } else {
        set_parameter_property ENABLE_MEM_ECC ENABLED true
    }
    
    if {$ENABLE_1G10G_MAC != 0} {
        set_parameter_property PREAMBLE_PASSTHROUGH ENABLED false
        set_parameter_property ENABLE_UNIDIRECTIONAL ENABLED false    
        set_parameter_property ENABLE_PFC ENABLED false  
        set_parameter_property PFC_PRIORITY_NUMBER ENABLED false

        # 1G/2.5G don't support these options
        if {$ENABLE_1G10G_MAC == 3} {
            set_parameter_property INSERT_XGMII_ADAPTOR ENABLED false
            set_parameter_property INSERT_ST_ADAPTOR ENABLED false
            set_parameter_property INSERT_CSR_ADAPTOR ENABLED false
        }
        
        if {$ENABLE_1G10G_MAC == 4} {
            set_parameter_property ENABLE_TIMESTAMPING ENABLED false
        }
        # NBASET does not need xgmii adaptor. also not support 1588
        if {$ENABLE_1G10G_MAC == 5} {
            set_parameter_property INSERT_XGMII_ADAPTOR ENABLED false
            set_parameter_property ENABLE_PTP_1STEP ENABLED false
            set_parameter_property ENABLE_TIMESTAMPING ENABLED false
        }
        
    } else {
        if {$ENABLE_10GBASER_REG_MODE == 1} {
            set_parameter_property INSERT_XGMII_ADAPTOR ENABLED false
            set_parameter_property PREAMBLE_PASSTHROUGH ENABLED false
            set_parameter_property ENABLE_TIMESTAMPING ENABLED false
            set_parameter_property ENABLE_UNIDIRECTIONAL ENABLED false
            set_parameter_property ENABLE_PFC ENABLED false
            set_parameter_property INSERT_ST_ADAPTOR ENABLED false
        } else {
            
        }

        if {$DATAPATH_OPTION == 2} {
            set_parameter_property ENABLE_UNIDIRECTIONAL ENABLED false
        }
    }

    if {$ENABLE_TIMESTAMPING == 1} {
        if {$DATAPATH_OPTION != 2} {
        set_parameter_property ENABLE_PTP_1STEP ENABLED true
        
        } else {
        set_parameter_property ENABLE_PTP_1STEP ENABLED false
        
        }
        set_parameter_property TSTAMP_FP_WIDTH ENABLED true
        set_parameter_property TIME_OF_DAY_FORMAT ENABLED true
    } else {
        set_parameter_property ENABLE_PTP_1STEP ENABLED false
        set_parameter_property TSTAMP_FP_WIDTH ENABLED false
        set_parameter_property TIME_OF_DAY_FORMAT ENABLED false
    }
    
    if {$ENABLE_PFC == 1} {
        set_parameter_property PFC_PRIORITY_NUMBER ENABLED true
    } else {
        set_parameter_property PFC_PRIORITY_NUMBER ENABLED false
    }
    
    if {$ENABLE_UNIDIRECTIONAL == 1 || $DATAPATH_OPTION == 1 || $DATAPATH_OPTION == 2 || $ENABLE_PFC == 1 || $PREAMBLE_PASSTHROUGH == 1} {
        set_parameter_property ENABLE_10GBASER_REG_MODE ENABLED false
        set_parameter_property ENABLE_1G10G_MAC ENABLED false
    } else {
        if {$ENABLE_TIMESTAMPING == 1 || $ENABLE_1G10G_MAC != 0 || $INSERT_ST_ADAPTOR == 1} {
            set_parameter_property ENABLE_10GBASER_REG_MODE ENABLED false
        } else {
            set_parameter_property ENABLE_10GBASER_REG_MODE ENABLED true
        }
        set_parameter_property ENABLE_1G10G_MAC ENABLED true
    }

    if {$ENABLE_10GBASER_REG_MODE == 1} {
       set_parameter_property ENABLE_1G10G_MAC ENABLED false
    }
    
    if {$ENABLE_1G10G_MAC != 0} {
        set_parameter_property DATAPATH_OPTION allowed_ranges {"3:TX & RX"}
    } else {
        if {$ENABLE_UNIDIRECTIONAL == 1 || $ENABLE_PTP_1STEP == 1} {
            set_parameter_property DATAPATH_OPTION allowed_ranges {"1:TX only" "3:TX & RX"}
        } else {
            set_parameter_property DATAPATH_OPTION allowed_ranges {"1:TX only" "2:RX only" "3:TX & RX"}
        }

        if {$ENABLE_10GBASER_REG_MODE == 1} {
            set_parameter_property DATAPATH_OPTION allowed_ranges {"3:TX & RX"}
        }
    }
    
    if {$DATAPATH_OPTION == 1} {
        set_parameter_property ENABLE_SUPP_ADDR ENABLED false
    } else {
        set_parameter_property ENABLE_SUPP_ADDR ENABLED true
    } 

    if {$INSTANTIATE_STATISTICS == 1} {
        set_parameter_property REGISTER_BASED_STATISTICS ENABLED true
    } else {
        set_parameter_property REGISTER_BASED_STATISTICS ENABLED false
    }
    
    if {[_is_device_family "Arria V"]} {
        set_parameter_property ENABLE_1G10G_MAC ALLOWED_RANGES {
            "3:1G/2.5G"
        }
    } elseif {[_is_device_family "Arria V GZ"] || [_is_device_family "Stratix V"]} {
        set_parameter_property ENABLE_1G10G_MAC ALLOWED_RANGES {
            "0:10G"
            "1:1G/10G"
            "2:10M/100M/1G/10G"
        }
    } elseif {[_is_device_family "Stratix 10"]} {
        # Remove/update this condition when Stratix 10 supports more option
        set_parameter_property ENABLE_1G10G_MAC ALLOWED_RANGES {
            "0:10G"
        }
        set_parameter_property ENABLE_TIMESTAMPING ENABLED false
    } else {
        set_parameter_property ENABLE_1G10G_MAC ALLOWED_RANGES {
            "0:10G"
            "1:1G/10G"
            "2:10M/100M/1G/10G"
            "3:1G/2.5G"
            "4:1G/2.5G/10G"
            "5:10M/100M/1G/2.5G/5G/10G (USXGMII)"
        }
    }
    
    update_adaptor
    
    # validation for example design
    set ed_validation_success 1
    # Need to check whether the current SELECT_SUPPORTED_VARIANT is 'None' (default value) to avoid error when user use ip-generate without specify SELECT_SUPPORTED_VARIANT parameter.
    if {$ENABLE_MEM_ECC == 1 || $PREAMBLE_PASSTHROUGH == 1 || $ENABLE_PFC == 1 || $ENABLE_UNIDIRECTIONAL == 1 || $DATAPATH_OPTION != 3 || $SELECT_SUPPORTED_VARIANT == 0 || ![validate_ed_device_family]} {
        set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED false
        set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED false
        set_parameter_property ENABLE_ED_FILESET_SIM ENABLED false 
        set_parameter_property SELECT_ED_FILESET ENABLED false
        set_parameter_property SELECT_TARGETED_DEVICE ENABLED false 
        set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false   
        set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
            "0:None"
            "1:10M/100M/1G/10G Ethernet"
            "2:10M/100M/1G/10G Ethernet with 1588"
            "3:10GBase-R Register Mode"
            "4:1G/10G Ethernet"
            "5:1G/10G Ethernet with 1588"
            "6:1G/2.5G Ethernet"
            "7:1G/2.5G/10G Ethernet"
            "8:1G/2.5G Ethernet with 1588"
            "9:10M/100M/1G/2.5G/5G/10G (USXGMII) Ethernet"
            "10:10GBase-R"
        }
        set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
            1:1
            2:2
            3:3
            4:4
            5:5
            6:6
            7:7
            8:8
            9:9
            10:10
            11:11
            12:12
        }
        # send_message INFO "To get the example design, please ensure speed is 10G or 10M/100M/1G/10G \n"
        # send_message INFO "Datapath options: TX & RX "
        # send_message INFO "Disable ECC on memory blocks "
        # send_message INFO "Disable PFC"
        #send_message INFO "Disable unidirectional"
        set ed_validation_success 0
        if {![validate_ed_device_family]} {
            send_message WARNING "Example Design is not supported for $DEVICE_FAMILY family. Please refer to User Guide for supported family"
        } else {
            send_message WARNING "Example Design for this setting is not available. Please refer to Presets to apply setting for example design"
        }
    } else {
        if {$ENABLE_1G10G_MAC == 0 && $ENABLE_10GBASER_REG_MODE == 1 && $INSERT_CSR_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "3:10GBase-R Register Mode"
            }
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }            
        } elseif {$ENABLE_1G10G_MAC == 2 && $ENABLE_TIMESTAMPING == 0 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 1 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "1:10M/100M/1G/10G Ethernet"
            }
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }        
        } elseif {$ENABLE_1G10G_MAC == 2 && $ENABLE_TIMESTAMPING == 1 && $ENABLE_PTP_1STEP == 1 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 1 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "2:10M/100M/1G/10G Ethernet with 1588"
            }
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }        
        } elseif {$ENABLE_1G10G_MAC == 1 && $ENABLE_TIMESTAMPING == 0 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 1 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "4:1G/10G Ethernet"
            }
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }               
        } elseif {$ENABLE_1G10G_MAC == 1 && $ENABLE_TIMESTAMPING == 1 && $ENABLE_PTP_1STEP == 1 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 1 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "5:1G/10G Ethernet with 1588"
            }
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }
        } elseif {$ENABLE_1G10G_MAC == 3 && $ENABLE_TIMESTAMPING == 0 && $ENABLE_PTP_1STEP == 0 && $INSERT_ST_ADAPTOR == 0 && $INSERT_CSR_ADAPTOR == 0 && $INSERT_XGMII_ADAPTOR == 0 && [_is_device_family "Arria 10"]} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "6:1G/2.5G Ethernet without 1588"
            }        
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }
        } elseif {$ENABLE_1G10G_MAC == 4 && $ENABLE_TIMESTAMPING == 0 && $ENABLE_PTP_1STEP == 0 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 0 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "7:1G/2.5G/10G Ethernet without 1588"
            }        
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }
        } elseif {$ENABLE_1G10G_MAC == 3 && $ENABLE_TIMESTAMPING == 1 && $ENABLE_PTP_1STEP == 1 && $INSERT_ST_ADAPTOR == 0 && $INSERT_CSR_ADAPTOR == 0 && $INSERT_XGMII_ADAPTOR == 0 && [_is_device_family "Arria 10"]} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "8:1G/2.5G Ethernet with 1588"
            }    
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }
        } elseif {$ENABLE_1G10G_MAC == 5 && $ENABLE_TIMESTAMPING == 0 && $ENABLE_PTP_1STEP == 0 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 0 && $INSERT_XGMII_ADAPTOR == 0 && [_is_device_family "Arria 10"]} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "9:10M/100M/1G/2.5G/5G/10G (USXGMII) Ethernet"
            }
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }  
        } elseif {$ENABLE_1G10G_MAC == 0 && $ENABLE_10GBASER_REG_MODE == 0 && $INSERT_XGMII_ADAPTOR == 1 && $INSERT_ST_ADAPTOR == 0 && $INSERT_CSR_ADAPTOR == 0 && $ENABLE_TIMESTAMPING == 0 && $ENABLE_PTP_1STEP == 0} {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED true
            set_parameter_property SELECT_ED_FILESET ENABLED true
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED true 
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "10:10GBase-R"
            }
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
            }  
        } else {
            set_parameter_property SELECT_SUPPORTED_VARIANT ENABLED false
            set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED false
            set_parameter_property ENABLE_ED_FILESET_SIM ENABLED false
            set_parameter_property SELECT_ED_FILESET ENABLED false
            set_parameter_property SELECT_TARGETED_DEVICE ENABLED false   
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false
            set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
                "0:None"
                "1:10M/100M/1G/10G Ethernet"
                "2:10M/100M/1G/10G Ethernet with 1588"
                "3:10GBase-R Register Mode"
                "4:1G/10G Ethernet"
                "5:1G/10G Ethernet with 1588"
                "6:1G/2.5G Ethernet"
                "7:1G/2.5G/10G Ethernet"
                "8:1G/2.5G Ethernet with 1588"
                "9:10M/100M/1G/2.5G/5G/10G (USXGMII) Ethernet"
                "10:10GBase-R"
            }
            set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
                1:1
                2:2
                3:3
                4:4
                5:5
                6:6
                7:7
                8:8
                9:9
                10:10
                11:11
                12:12
            }
            set ed_validation_success 0
            if {[_is_device_family "Stratix 10"]} {
                send_message WARNING "The selected Example Design Preset is not supported for Stratix 10. Please refer to User Guide for supported family and Example Design variants"
            } else {
                send_message WARNING "Example Design for this setting is not available. Please refer to Presets to apply setting for example design"
            }
        }
    }
    
    
    # if {$ENABLE_1G10G_MAC == 2} {
        # if {$ENABLE_TIMESTAMPING == 1} {
            # set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {
                # "1:10M/100M/1G/10G Ethernet Lineside with 1588"         
            # }
        # } else {
            # set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {
                # "0:10M/100M/1G/10G Ethernet Lineside without 1588"         
            # } 
        # }
        
    # } else {
        # set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES {            
            # "2:10GBASE-R register mode"
        # }
    # }
    
    if {$SELECT_SUPPORTED_VARIANT == 3 || $SELECT_SUPPORTED_VARIANT == 6 || $SELECT_SUPPORTED_VARIANT == 7 || $SELECT_SUPPORTED_VARIANT == 8 || $SELECT_SUPPORTED_VARIANT == 9 || $SELECT_SUPPORTED_VARIANT == 10 || $ed_validation_success == 0} {
        set_parameter_property SELECT_NUMBER_OF_CHANNEL ENABLED false   
    } else {
        set_parameter_property SELECT_NUMBER_OF_CHANNEL ENABLED true   
    }

    if {$ENABLE_ED_FILESET_SYNTHESIS == 0} {
        set_parameter_property SELECT_TARGETED_DEVICE ENABLED false
        set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false
    }

    if {$ENABLE_ED_FILESET_SYNTHESIS == 0 && $ENABLE_ED_FILESET_SIM == 0} {
        # Ensure either synthesis or simulation fileset is selected, cannot both unchecked.
        send_message WARNING "At least one of the \"Simulation\" and \"Synthesis\" check boxes from \"Example Design Files\" must be selected to allow generation of Example Design Files."
    }
   
    # Legacy Ethernet 10G MAC interface parameter had no impact toward example design
#    send_message INFO "Legacy Ethernet 10G MAC Interface parameter had no impact toward example design "
    

    if {[validate_ed_device_family]} {
        if {$SELECT_TARGETED_DEVICE == 0} {
            ## No development kit selection
            set_display_item_property device TEXT "<html>Device Selected:&nbsp;&nbsp;&nbsp;&nbsp;Family: $DEVICE_FAMILY Device: $DEVICE<br><br></html>"
            set_display_item_property explanation1 TEXT "<html>Example Design generation will produce necessary files for Quartus compile. The Quartus<br>
Settings File (QSF) will have pin assignments set to virtual pins.<br>
<br>
The field <b>Device Selected</b> under the <b>Targted Device</b> category below displays the target <br>
device for this Example Design. If you need to change the target device, follow instructions <br> 
provided in the field <b>To change Target Device</b> under <b>Target Device</b> below.</html>"
            set_display_item_property explanation2 TEXT "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
desired device from supported families (Arria 10,Stratix 10). When completed, the <b>Device <br>
Selected</b> field above reflects the new device.</html>"
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false

        } elseif {$SELECT_TARGETED_DEVICE == 1} {
            # Intel FPGA IP A10 development kit selection
            if {$SELECT_CUSTOM_DEVICE == 1} {
                set_display_item_property device TEXT "<html>Device Selected:Family:&nbsp;&nbsp;&nbsp;&nbsp;$DEVICE_FAMILY Device: $DEVICE<br><br></html>"
                if {![validate_custom_device]} {
                    send_message WARNING "The device selected is not a valid variation of the device on the selected Intel FPGA IP Development kit. Allowed variations are only for 'SerDes Speed Grade',
.etc. Check the device part number and try again."
                    set_display_item_property device TEXT "<html>Device Selected:Family:&nbsp;&nbsp;&nbsp;&nbsp;Arria 10 Device: $DEVKIT_DEVICE<br><br></html>"
                }
            } else {
                set_display_item_property device TEXT "<html>Device Selected:Family:&nbsp;&nbsp;&nbsp;&nbsp;Arria 10 Device: $DEVKIT_DEVICE<br><br></html>"
            }
            set_display_item_property explanation1 TEXT "<html>Example Design generation produces the necessary files for Quartus Prime project targeted<br>
to the selected Intel FPGA IP development kit.<br>
<br>
The field <b>Device Selected</b> under the <b>Targted Device</b> category below displays the target <br>
device for the selected Intel FPGA IP development kit. If your board revision has a different grade <br>
of this device, you should change it to correct device grade. To change the target device, <br>
follow instructions provided in the field <b>To change Target Device</b> under <b>Target Device</b> <br>
below.</html>"
            set_display_item_property explanation2 TEXT "<html><b>To change Target Device</b>: First check the <b>Change Target Device</b> box above. Then from <br>
the menu bar use <b>View</b> -> '<b>Device Family</b>' to select desired device from supported families <br>
(Arria 10,Stratix 10). When completed, the <b>Device Selected</b> field above reflects the new device.</html>"
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true

        } elseif {$SELECT_TARGETED_DEVICE == 2} {
            # Custom development kit selection
            set_display_item_property device TEXT "<html>Device Selected:&nbsp;&nbsp;&nbsp;&nbsp;Family: $DEVICE_FAMILY Device: $DEVICE<br><br></html>"
            set_display_item_property explanation1 TEXT "<html>Example Design generation provides the necessary files for Quartus Prime project. The <br>
Quartus Settings File (QSF) includes pin assignment statements without pin number. After the <br>
Example Design generation, you must edit the QSF file <b>${QSF_PATH}<br>
altera_eth_top.qsf</b> to add pin numbers according to your custom board layout.<br>
<br>
The field <b>Device Selected</b> under the <b>Targted Device</b> category below displays the target <br>
device for this Example Design. If your board has a different device, you should change <br>
it to correct device. You can do so with the instructions provided under the same category.</html>"
            set_display_item_property explanation2 TEXT "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
desired device from supported families (Arria 10,Stratix 10). When completed, the <b>Device <br>
Selected</b> field above reflects the new device.</html>"
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false

        } else {
            set_display_item_property device TEXT "<html>Device Selected:&nbsp;&nbsp;&nbsp;&nbsp;Family: $DEVICE_FAMILY Device: $DEVICE<br><br></html>"
            set_display_item_property explanation1 TEXT "<html>Example Design generation will produce necessary files for Quartus compile. The Quartus<br>
Settings File (QSF) will have pin assignments set to virtual pins.<br>
<br>
The field <b>Device Selected</b> under the <b>Targted Device</b> category below displays the target <br>
device for this Example Design. If you need to change the target device, follow instructions <br> 
provided in the field <b>To change Target Device</b> under <b>Target Device</b> below.</html>"
            set_display_item_property explanation2 TEXT "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
desired device from supported families (Arria 10,Stratix 10). When completed, the <b>Device <br>
Selected</b> field above reflect the new device.</html>"
            set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false

        }
    }
   
}

# update GUI parameter
proc update_unidirection_setting {arg1} {
    set ENABLE_UNIDIRECTIONAL [get_parameter_value $arg1]
    
    update_supported_variant_value
}

proc update_option {arg2} {
    set datapath_option [get_parameter_value $arg2]
    
    if {$datapath_option == 1} {
        set_parameter_value ENABLE_SUPP_ADDR 0
        set_parameter_value ENABLE_1G10G_MAC 0
        
    }
    
    if {$datapath_option == 2} {
        set_parameter_value ENABLE_1G10G_MAC 0
    }

    update_supported_variant_value
}

proc update_timestamping {arg3} {
    set enable_timestamping [get_parameter_value $arg3]
    if {$enable_timestamping == 0} {
        set_parameter_value ENABLE_PTP_1STEP 0
    }

    update_supported_variant_value
}

proc update_ptp_1step {arg} {
    set enable_ptp_1step [get_parameter_value $arg]

    update_supported_variant_value
}


proc update_ultra_setting {arg4} {
    set ENABLE_10GBASER_REG_MODE [get_parameter_value $arg4]
    
    if {$ENABLE_10GBASER_REG_MODE == 1} {
        set_parameter_value ENABLE_PTP_1STEP 0
        set_parameter_value ENABLE_1G10G_MAC 0
        set_parameter_value DATAPATH_OPTION 3
        set_parameter_value ENABLE_PFC 0
        set_parameter_value PREAMBLE_PASSTHROUGH 0
        set_parameter_value ENABLE_UNIDIRECTIONAL 0
        set_parameter_value INSERT_XGMII_ADAPTOR 0
        set_parameter_value INSERT_ST_ADAPTOR 0
    }

    update_supported_variant_value    
}

proc update_speed_setting {arg} {
    set ENABLE_1G10G_MAC [get_parameter_value $arg]
    set ENABLE_TIMESTAMPING [get_parameter_value ENABLE_TIMESTAMPING]
    
    if {[_is_device_family "Arria V"]} {
       set_parameter_value ENABLE_MEM_ECC 0
    }
    
    # 1G/2.5G don't support these options
    if {$ENABLE_1G10G_MAC == 3} {
       set_parameter_value INSERT_XGMII_ADAPTOR 0
       set_parameter_value INSERT_ST_ADAPTOR 0
       set_parameter_value INSERT_CSR_ADAPTOR 0
    }
    
    if {$ENABLE_1G10G_MAC == 4} {
       set_parameter_value ENABLE_TIMESTAMPING 0
       set_parameter_value ENABLE_PTP_1STEP 0
    }
    
    if {$ENABLE_1G10G_MAC == 5} {
       set_parameter_value INSERT_XGMII_ADAPTOR 0
       set_parameter_value ENABLE_TIMESTAMPING 0
       set_parameter_value ENABLE_PTP_1STEP 0
    }

    update_supported_variant_value    

}

proc update_adaptor {} {
    set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]
    
    if {![string compare $DEVICE_FAMILY "Arria 10"]} {
        set_parameter_value USE_ASYNC_ADAPTOR 0
    } else {
        set_parameter_value USE_ASYNC_ADAPTOR 0
    }
}

proc update_ecc_setting {arg} {
    set ENABLE_MEM_ECC [get_parameter_value $arg]

    update_supported_variant_value
}

proc update_preamble_passthrough {arg} {
    set PREAMBLE_PASSTHROUGH [get_parameter_value $arg]

    update_supported_variant_value
}


proc update_pfc {arg} {
    set ENABLE_PFC [get_parameter_value $arg]

    update_supported_variant_value
}


proc update_supported_variant {arg} {
    set SELECT_SUPPORTED_VARIANT [get_parameter_value $arg]

    # 1G/2.5G don't support these options
    if {$SELECT_SUPPORTED_VARIANT == 3 || $SELECT_SUPPORTED_VARIANT == 10} {      
       set_parameter_value SELECT_NUMBER_OF_CHANNEL 1
    } else if {$SELECT_SUPPORTED_VARIANT == 6 || $SELECT_SUPPORTED_VARIANT == 7 || $SELECT_SUPPORTED_VARIANT == 8 || $SELECT_SUPPORTED_VARIANT == 9} {      
       set_parameter_value SELECT_NUMBER_OF_CHANNEL 2
    }  
 
}

proc update_device_family {dev_family} {
    if {[_is_device_family "Arria V"]} {
        set_parameter_value ENABLE_MEM_ECC 0
        set_parameter_value ENABLE_1G10G_MAC 3
            
    } 

    update_supported_variant_value
}

proc _is_device_family {dev_family} {
    set device_family [get_parameter_value DEVICE_FAMILY]
    
    if {![string compare $device_family $dev_family]} {
        return 1;
    } else {
        return 0;
    }
}

proc update_ed_fileset_synthesis {arg} {
    set ENABLE_ED_FILESET_SYNTHESIS [get_parameter_value $arg]

    if {$ENABLE_ED_FILESET_SYNTHESIS == 0} {
       set_parameter_value SELECT_TARGETED_DEVICE 0
    }
}

proc validate_custom_device {} {
    set DEVICE [get_parameter_value DEVICE]
    set DEVKIT_DEVICE [get_parameter_value DEVKIT_DEVICE]

    set success_extract_device_info [regexp -nocase {(^[0-9]*[a-z]*[0-9]*[a-z]*)[0-9]*([a-z]*[0-9]*)[a-z]*[0-9]*[a-z](G).*$} $DEVICE full_match device_info_1 device_info_2 device_info_3]
    set success_extract_devkit_device_info [regexp -nocase {(^[0-9]*[a-z]*[0-9]*[a-z]*)[0-9]*([a-z]*[0-9]*)[a-z]*[0-9]*[a-z](G).*$} $DEVKIT_DEVICE full_match_devkit devkit_device_info_1 devkit_device_info_2 devkit_device_info_3]

    if {$success_extract_device_info == 1 && $success_extract_devkit_device_info == 1} {
        if {![string compare -nocase $device_info_1 $devkit_device_info_1] && ![string compare -nocase $device_info_2 $devkit_device_info_2] && ![string compare -nocase $device_info_3 $devkit_device_info_3]} {
            return 1;          
        } else {
            return 0;
        }
    } else {
        return 0;
    }

}

proc validate_ed_device_family {} {
    if {[_is_device_family "Arria 10"] || [_is_device_family "Stratix 10"]} {    
        return 1;
    } else {
        return 0;
    }
}

proc update_select_targeted_device {arg} {
    set SELECT_TARGETED_DEVICE [get_parameter_value $arg]
    set DEVICE [get_parameter_value DEVICE]
    set ENABLE_TIMESTAMPING [get_parameter_value ENABLE_TIMESTAMPING]
    set ENABLE_1G10G_MAC [get_parameter_value ENABLE_1G10G_MAC]

    if {[_is_device_family "Stratix 10"]} {
            set_parameter_value DEVKIT_DEVICE "1SG280LU3F50E1VG"
    } else {
        if {$ENABLE_TIMESTAMPING == 1 || $ENABLE_1G10G_MAC == 0} {
            set_parameter_value DEVKIT_DEVICE "10AX115S3F45E2SGE3"
        } else {
            set_parameter_value DEVKIT_DEVICE "10AX115S4F45E3SGE3"
        }
    }

    set DEVKIT_DEVICE [get_parameter_value DEVKIT_DEVICE]

    if {$SELECT_TARGETED_DEVICE == 2 || $SELECT_TARGETED_DEVICE == 0} {
        set_parameter_value SELECT_CUSTOM_DEVICE 1
    } elseif {$SELECT_TARGETED_DEVICE == 1} {
        set_parameter_value SELECT_CUSTOM_DEVICE 0
    }
}

proc update_st_adaptor {arg} {
    set INSERT_ST_ADAPTOR [get_parameter_value $arg]

    update_supported_variant_value
}

proc update_csr_adaptor {arg} {
    set INSERT_CSR_ADAPTOR [get_parameter_value $arg]

    update_supported_variant_value
}

proc update_xgmii_adaptor {arg} {
    set INSERT_XGMII_ADAPTOR [get_parameter_value $arg]
    
    update_supported_variant_value
    
}

proc update_supported_variant_value {} {
    set ENABLE_TIMESTAMPING [get_parameter_value ENABLE_TIMESTAMPING]
    set ENABLE_UNIDIRECTIONAL [get_parameter_value ENABLE_UNIDIRECTIONAL]
    set ENABLE_PTP_1STEP [get_parameter_value ENABLE_PTP_1STEP]
    set INSERT_ST_ADAPTOR [get_parameter_value INSERT_ST_ADAPTOR]
    set INSERT_CSR_ADAPTOR [get_parameter_value INSERT_CSR_ADAPTOR]
    set INSERT_XGMII_ADAPTOR [get_parameter_value INSERT_XGMII_ADAPTOR]
    set ENABLE_1G10G_MAC [get_parameter_value ENABLE_1G10G_MAC]
    set ENABLE_MEM_ECC [get_parameter_value ENABLE_MEM_ECC]
    set ENABLE_PFC [get_parameter_value ENABLE_PFC]
    set DATAPATH_OPTION [get_parameter_value DATAPATH_OPTION]
    set PREAMBLE_PASSTHROUGH [get_parameter_value PREAMBLE_PASSTHROUGH]
    set ENABLE_10GBASER_REG_MODE [get_parameter_value ENABLE_10GBASER_REG_MODE]

    if {$ENABLE_MEM_ECC == 1 || $PREAMBLE_PASSTHROUGH == 1 || $ENABLE_PFC == 1 || $ENABLE_UNIDIRECTIONAL == 1 || $DATAPATH_OPTION != 3 || ![_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 0
        set_parameter_value QSF_PATH ""
    } elseif {$ENABLE_1G10G_MAC == 0 && $ENABLE_10GBASER_REG_MODE == 1 && $INSERT_CSR_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 3
        set_parameter_value SELECT_NUMBER_OF_CHANNEL 1
        set_parameter_value QSF_PATH "LL10G_10GBASER_RegMode/"
    } elseif {$ENABLE_1G10G_MAC == 2 && $ENABLE_TIMESTAMPING == 0 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 1 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 1
        set_parameter_value QSF_PATH "LL10G_LINESIDE/"
    } elseif {$ENABLE_1G10G_MAC == 2 && $ENABLE_TIMESTAMPING == 1 && $ENABLE_PTP_1STEP == 1 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 1 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 2
        set_parameter_value QSF_PATH "LL10G_LINESIDE_1588v2/"
    } elseif {$ENABLE_1G10G_MAC == 1 && $ENABLE_TIMESTAMPING == 0 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 1 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 4
        set_parameter_value QSF_PATH "LL10G_1G_10G_LINESIDE/"
    } elseif {$ENABLE_1G10G_MAC == 1 && $ENABLE_TIMESTAMPING == 1 && $ENABLE_PTP_1STEP == 1 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 1 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 5
        set_parameter_value QSF_PATH "LL10G_1G_10G_LINESIDE_1588v2/"
    } elseif {$ENABLE_1G10G_MAC == 3 && $ENABLE_TIMESTAMPING == 0 && $ENABLE_PTP_1STEP == 0 && $INSERT_ST_ADAPTOR == 0 && $INSERT_CSR_ADAPTOR == 0 && $INSERT_XGMII_ADAPTOR == 0 && [_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 6
        set_parameter_value SELECT_NUMBER_OF_CHANNEL 2
        set_parameter_value QSF_PATH "LL10G_1G_2_5G/"
    } elseif {$ENABLE_1G10G_MAC == 4 && $ENABLE_TIMESTAMPING == 0 && $ENABLE_PTP_1STEP == 0 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 0 && $INSERT_XGMII_ADAPTOR == 1 && [_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 7
        set_parameter_value SELECT_NUMBER_OF_CHANNEL 2
        set_parameter_value QSF_PATH "LL10G_1G_2_5G_10G/"
    } elseif {$ENABLE_1G10G_MAC == 3 && $ENABLE_TIMESTAMPING == 1 && $ENABLE_PTP_1STEP == 1 && $INSERT_ST_ADAPTOR == 0 && $INSERT_CSR_ADAPTOR == 0 && $INSERT_XGMII_ADAPTOR == 0 && [_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 8
        set_parameter_value SELECT_NUMBER_OF_CHANNEL 2
        set_parameter_value QSF_PATH "LL10G_1G_2_5G_1588v2/"
    } elseif {$ENABLE_1G10G_MAC == 5 && $ENABLE_TIMESTAMPING == 0 && $ENABLE_PTP_1STEP == 0 && $INSERT_ST_ADAPTOR == 1 && $INSERT_CSR_ADAPTOR == 0 && $INSERT_XGMII_ADAPTOR == 0 && [_is_device_family "Arria 10"]} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 9
        set_parameter_value SELECT_NUMBER_OF_CHANNEL 2
        set_parameter_value QSF_PATH "LL10G_10G_USXGMII/"
    } elseif {$ENABLE_1G10G_MAC == 0 && $ENABLE_10GBASER_REG_MODE == 0 && $INSERT_XGMII_ADAPTOR == 1 && $INSERT_ST_ADAPTOR == 0 && $INSERT_CSR_ADAPTOR == 0 && $ENABLE_TIMESTAMPING == 0 && $ENABLE_PTP_1STEP == 0} {
        set_parameter_value SELECT_SUPPORTED_VARIANT 10
        set_parameter_value SELECT_NUMBER_OF_CHANNEL 2
        set_parameter_value QSF_PATH "LL10G_10GBASER/"
    } else {
        set_parameter_value SELECT_SUPPORTED_VARIANT 0
        set_parameter_value QSF_PATH ""
    }
    
}
