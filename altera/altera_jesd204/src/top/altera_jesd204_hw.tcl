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


#########################################
### request TCL package from ACDS
#########################################
package require -exact qsys 16.0
package require altera_tcl_testlib 1.0
package require -exact altera_terp 1.0

##########################
# module altera_jesd204b
##########################
set_module_property NAME altera_jesd204
set_module_property AUTHOR "Intel Corporation"
set_module_property DESCRIPTION "JESD204B Intel FPGA IP"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Interface Protocols/JESD"
set_module_property DISPLAY_NAME "JESD204B Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true
#set_module_property ANALYZE_HDL true
set_module_property SUPPORTED_DEVICE_FAMILIES {{Stratix 10} {Arria 10} {Stratix V} {Arria V GZ} {Arria V} {Cyclone V}} 
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_jesd204b.pdf"

######## Get Required JESD tcl command #########
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_jesd204/src/top/altera_jesd204_common_procs.tcl

########################
# Declare the callbacks
########################
set_module_property VALIDATION_CALLBACK my_validation_callback   
set_module_property COMPOSITION_CALLBACK my_compose_callback

#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./altera_jesd204_params.tcl
::altera_jesd204::gui_params::params_top_hw

#------------------------------------------------------------------------
# 2. Testbench
#------------------------------------------------------------------------
source ./../../ed/ip_sim/altera_jesd204_demo_tb_hw.tcl

proc is_LMF_support_ed {} {
	
    set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]
    
    set L [get_parameter_value "L"]
    set M [get_parameter_value "M"]
    
    if {[get_parameter_value GUI_EN_CFG_F] == 1} {
        set F [get_parameter_value "GUI_CFG_F"]
    } else {
        set F [get_parameter_value "F"]
    }
    
    if {[string equal $DEVICE_FAMILY "Stratix 10"]} {
	 # sequence:   L M F
	 set LMF_table(2,2,2) 1
	 set LMF_table(8,8,8) 1
    } elseif {[string equal $DEVICE_FAMILY "Arria 10"]} {
	 set LMF_table(1,1,2) 1
	 set LMF_table(1,1,4) 1
	 set LMF_table(1,2,4) 1
	 set LMF_table(1,4,8) 1
    
	 set LMF_table(2,1,1) 1
	 set LMF_table(2,1,2) 1
	 set LMF_table(2,1,4) 1
	 set LMF_table(2,2,2) 1
	 set LMF_table(2,2,4) 1
	 set LMF_table(2,4,4) 1
    
	 set LMF_table(4,2,1) 1
	 set LMF_table(4,2,2) 1
	 set LMF_table(4,4,2) 1
	 set LMF_table(4,4,4) 1
	 set LMF_table(4,8,4) 1
    
	 set LMF_table(8,1,1) 1
	 set LMF_table(8,2,1) 1
	 set LMF_table(8,4,1) 1
	 set LMF_table(8,4,2) 1
	
	 set LMF_table(4,1,1) 1
	 set LMF_table(6,1,1) 1
	 set LMF_table(6,3,1) 1
	 
	 set LMF_table(1,1,8) 1
	 set LMF_table(2,1,8) 1
	 set LMF_table(4,1,1) 1
	 set LMF_table(4,1,2) 1
	 set LMF_table(4,1,4) 1
	 set LMF_table(8,1,2) 1
	 
	 set LMF_table(1,2,8) 1
	 set LMF_table(2,2,8) 1
	 set LMF_table(4,2,4) 1
	 set LMF_table(4,2,8) 1
	 set LMF_table(8,2,2) 1
	 set LMF_table(8,2,4) 1
	 
	 set LMF_table(2,4,8) 1
	 set LMF_table(4,4,8) 1
	 set LMF_table(8,4,4) 1
	 set LMF_table(8,4,8) 1
	 
	 set LMF_table(2,8,8) 1
	 set LMF_table(4,8,8) 1
	 set LMF_table(8,8,2) 1
	 set LMF_table(8,8,4) 1
	 set LMF_table(8,8,8) 1
	 
	 set LMF_table(4,16,8) 1
	 set LMF_table(8,16,4) 1
	 set LMF_table(8,16,8) 1
	 
	 set LMF_table(8,32,8) 1	
    } else {
	 # sequence:   L M F
	 set LMF_table(1,1,2) 1
	 set LMF_table(1,1,4) 1
	 set LMF_table(1,2,4) 1
	 set LMF_table(1,4,8) 1
    
	 set LMF_table(2,1,1) 1
	 set LMF_table(2,1,2) 1
	 set LMF_table(2,1,4) 1
	 set LMF_table(2,2,2) 1
	 set LMF_table(2,2,4) 1
	 set LMF_table(2,4,4) 1
    
	 set LMF_table(4,2,1) 1
	 set LMF_table(4,2,2) 1
	 set LMF_table(4,4,2) 1
	 set LMF_table(4,4,4) 1
	 set LMF_table(4,8,4) 1
    
	 set LMF_table(8,1,1) 1
	 set LMF_table(8,2,1) 1
	 set LMF_table(8,4,1) 1
	 set LMF_table(8,4,2) 1
    }
    
    if {[info exists LMF_table($L,$M,$F)]} {
        return 1
    } else {
        return 0
    }
}

# returns ed type, options:
#   NIOS
#   RTL
#   NONE
proc get_supported_ed {} {
    # search for non-supported parameter values
    # if there are no non-supported value, consider it supports ed
    # return the supported ed type
    
    set LMF_support         0
    set ed_RTL_support      0
    set ed_NIOS_support     0
    set ed_DATAPATH_support 0
    set other_param_support 0
    
    set DEVICE_FAMILY       [get_parameter_value DEVICE_FAMILY]
    set bonded_mode         [get_parameter_value bonded_mode]
    set pll_reconfig_enable [get_parameter_value pll_reconfig_enable]
    set wrapper_opt         [get_parameter_value wrapper_opt]
    set DATA_PATH           [get_parameter_value DATA_PATH]
    set SUBCLASSV           [get_parameter_value SUBCLASSV]
    set lane_rate           [get_parameter_value lane_rate]
    set pll_type            [get_parameter_value pll_type]
    set REFCLK_FREQ         [get_parameter_value REFCLK_FREQ]
    set bitrev_en           [get_parameter_value bitrev_en]    
    set L                   [get_parameter_value L]
    set N                   [get_parameter_value N]
    set N_PRIME             [get_parameter_value N_PRIME]
    set CS                  [get_parameter_value CS]
    set CF                  [get_parameter_value CF]
    set HD                  [get_parameter_value HD]
    set SCR                 [get_parameter_value SCR]
    set ECC_EN              [get_parameter_value ECC_EN]
    set PCS_CONFIG	    [get_parameter_value PCS_CONFIG]
    
    if {[get_parameter_value GUI_EN_CFG_F] == 1} {
        set F [get_parameter_value GUI_CFG_F]
    } else {
        set F [get_parameter_value F]
    }
	
    # check LMF parameters
    set LMF_support [is_LMF_support_ed]
   
    
    # check for RTL ed or NIOS ed or DATAPATH ed support   
    if {[string equal $DEVICE_FAMILY "Stratix 10"]} {
	set ed_DATAPATH_support 1
    } else {	    
	if {[string equal $bonded_mode "non_bonded"] && $pll_reconfig_enable == "true"} {        
             if {[string equal $DEVICE_FAMILY "Arria 10"]} {
                 set ed_NIOS_support 1
             } else {
                 set ed_RTL_support 1
             }
        } elseif {[string equal $bonded_mode "bonded"] && $pll_reconfig_enable == "false"} {
             set ed_RTL_support 1
        }
    }
    
    # special expected value for lane rate and pll ref clock
    
    
    if {[string equal $DEVICE_FAMILY "Cyclone V"]} {
        set supported_lane_rate         5000
        if {$L == 8} {
            set supported_pll_refclk_freq   250.0
        } else {
            set supported_pll_refclk_freq   125.0
	}
    } elseif {[string equal $DEVICE_FAMILY "Stratix 10"]} {
	if {[string equal $PCS_CONFIG "JESD_PCS_CFG1"]} {
    	    if {$L == 2} {
	        set supported_lane_rate         5333
                set supported_pll_refclk_freq   133.325
	    } else {
	        set supported_lane_rate         6144
                set supported_pll_refclk_freq   153.6
           }
	} else {
	    set supported_lane_rate         12288
            set supported_pll_refclk_freq   153.6
	}
    } else {
	set supported_lane_rate         6144
        if {$L == 8} {
            set supported_pll_refclk_freq   307.2
        } else {
	    set supported_pll_refclk_freq   153.6
	}
    }
    
    #if {$L == 8} {
    #    set supported_pll_refclk_freq [expr $supported_pll_refclk_freq * 2]
    #}
    
    # check other parameters
    if {[string equal $DEVICE_FAMILY "Stratix 10"]} {
    	if {$L == 8} {
            if {![string equal $wrapper_opt "base_phy"]} {
	    } elseif {![string equal $DATA_PATH "RX_TX"]} {
	    } elseif {$SUBCLASSV != 1} {
	    } elseif {$lane_rate != $supported_lane_rate} {
	    } elseif {![string equal $pll_type "CMU"]} {
	    } elseif {$REFCLK_FREQ != $supported_pll_refclk_freq} {
	    } elseif {![string equal $bitrev_en "false"]} {
	    } elseif {$N != 12} {
	    } elseif {$N_PRIME != 12} {
	    } elseif {$CS != 0} {
	    } elseif {$CF != 0} {
	    } elseif {$HD != 0} {
	    } elseif {$SCR != 1} {
	    } elseif {$ECC_EN != 1} {
	    } else {
	        set other_param_support 1
	    }
	} else {
	    if {![string equal $wrapper_opt "base_phy"]} {
	    } elseif {![string equal $DATA_PATH "RX_TX"]} {
	    } elseif {$SUBCLASSV != 1} {
	    } elseif {$lane_rate != $supported_lane_rate} {
	    } elseif {![string equal $pll_type "CMU"]} {
	    } elseif {$REFCLK_FREQ != $supported_pll_refclk_freq} {
	    } elseif {![string equal $bitrev_en "false"]} {
	    } elseif {$N != 16} {
	    } elseif {$N_PRIME != 16} {
	    } elseif {$CS != 0} {
	    } elseif {$CF != 0} {
	    } elseif {$HD != 0} {
	    } elseif {$SCR != 1} {
	    } elseif {$ECC_EN != 1} {
	    } else {
	        set other_param_support 1
	    }
	}   
    } elseif {[string equal $DEVICE_FAMILY "Arria 10"]} {
        if {![string equal $wrapper_opt "base_phy"]} {
        } elseif {![string equal $DATA_PATH "RX_TX"]} {
        } elseif {$SUBCLASSV != 1} {
        } elseif {$lane_rate != $supported_lane_rate} {
        } elseif {![string equal $pll_type "CMU"]} {
        } elseif {$REFCLK_FREQ != $supported_pll_refclk_freq} {
        } elseif {![string equal $bitrev_en "false"]} {
        } elseif {$N > 16 || $N < 12} {
        } elseif {$N_PRIME != 16} {
        } elseif {$CS > 3 || $CS < 0} {
        } elseif {$CF != 0} {
        } elseif {$HD != 0 && $F!=1} {
        } elseif {$SCR != 1} {
        } elseif {$ECC_EN != 1} {
        } elseif {[param_is_true "GUI_EN_CFG_F"]} {
        } else {
            set other_param_support 1
        }
    } else {
	if {![string equal $wrapper_opt "base_phy"]} {
	} elseif {![string equal $DATA_PATH "RX_TX"]} {
	} elseif {$SUBCLASSV != 1} {
	} elseif {$lane_rate != $supported_lane_rate} {
	} elseif {![string equal $pll_type "CMU"]} {
	} elseif {$REFCLK_FREQ != $supported_pll_refclk_freq} {
	} elseif {![string equal $bitrev_en "false"]} {
	} elseif {$N != 16} {
	} elseif {$N_PRIME != 16} {
	} elseif {$CS != 0} {
	} elseif {$CF != 0} {
	} elseif {$HD != 0} {
	} elseif {$SCR != 1} {
	} elseif {$ECC_EN != 1} {
	} elseif {[param_is_true "GUI_EN_CFG_F"]} {
	} else {
	    set other_param_support 1
	}
    }
    
    if {$LMF_support && $other_param_support && $ed_NIOS_support} {
        return "NIOS"
    } elseif {$LMF_support && $other_param_support && $ed_RTL_support} {
        return "RTL"
    } elseif {$LMF_support && $other_param_support && $ed_DATAPATH_support} {
	return "DATAPATH"
    } else {
        return "NONE"
    }
}

#############################################################
#                  Validation Callback
#############################################################
proc my_validation_callback {} {
    set d_SUBCLASSV [get_parameter_value "SUBCLASSV"]
    set d_device [get_parameter_value "DEVICE_FAMILY"]
    set l_rate [get_parameter_value "lane_rate"]
    set d_PCS_CONFIG [get_parameter_value "PCS_CONFIG"] 
    set d_N [get_parameter_value "N"]
    set d_S [get_parameter_value "S"]
    set d_M [get_parameter_value "M"]
    set d_L [get_parameter_value "L"]
    set d_K [get_parameter_value "K"]
    set d_N_PRIME [get_parameter_value "N_PRIME"]
    set d_F [get_parameter_value "F"] 
    set d_pll_type [get_parameter_value "pll_type"]
    set d_REFCLK_FREQ [get_parameter_value "REFCLK_FREQ"]
    set d_SCR [get_parameter_value "SCR"]
    set d_HD [get_parameter_value "HD"]
    set d_CS [get_parameter_value "CS"]
    set d_CF [get_parameter_value "CF"]
    set d_ADJCNT [get_parameter_value "ADJCNT"]
    set d_ADJDIR [get_parameter_value "ADJDIR"]
    set d_PHADJ [get_parameter_value "PHADJ"]
    set d_DID [get_parameter_value "DID"]
    set d_BID [get_parameter_value "BID"]
    set d_LID0 [get_parameter_value "LID0"]
    set d_LID1 [get_parameter_value "LID1"]
    set d_LID2 [get_parameter_value "LID2"]
    set d_LID3 [get_parameter_value "LID3"]
    set d_LID4 [get_parameter_value "LID4"]
    set d_LID5 [get_parameter_value "LID5"]
    set d_LID6 [get_parameter_value "LID6"]
    set d_LID7 [get_parameter_value "LID7"]
    set d_JESDV [get_parameter_value "JESDV"]
    set d_RES1 [get_parameter_value "RES1"]
    set d_RES2 [get_parameter_value "RES2"]
    set d_pcs_pma_width [expr {[param_matches PCS_CONFIG "JESD_PCS_CFG1"] ? 20 : [param_matches PCS_CONFIG "JESD_PCS_CFG2"] ? 40 : [param_matches PCS_CONFIG "JESD_PCS_CFG4"] ? 80 : 10 }] 
    
#Configure all GUI parameters when to enabled or disabled
# conf_params_en     <param>       <enable>
    conf_params_en "DEVICE_FAMILY" 1
    conf_params_en "wrapper_opt"   1
    conf_params_en "DATA_PATH"     1
    conf_params_en "SUBCLASSV"     [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "lane_rate"     1
    conf_params_en "pll_type"      [expr {![device_is_xseries] && ![param_matches DATA_PATH "RX"] && ![param_matches wrapper_opt "base"] }]
    conf_params_en "bonded_mode"   [expr { ![param_matches DATA_PATH "RX"] && ![param_matches wrapper_opt "base"] && !([param_matches DEVICE_FAMILY "Arria V"] && [param_matches PCS_CONFIG "JESD_PCS_CFG4"])}]
    conf_params_en "REFCLK_FREQ"   [expr {![param_matches wrapper_opt "base"] && ![expr {[device_is_xseries] && [param_matches DATA_PATH "TX"]} ] }]
    conf_params_en "PCS_CONFIG"    [expr {![param_matches wrapper_opt "base"]}]
    conf_params_en "pll_reconfig_enable" [expr {![param_matches wrapper_opt "base"]}]
    conf_params_en "rcfg_jtag_enable" [expr {![param_matches wrapper_opt "base"] && [device_is_xseries] && [param_matches pll_reconfig_enable "true"]  }]
    conf_params_en "rcfg_shared"      [expr {![param_matches wrapper_opt "base"] && [device_is_xseries] && [param_matches pll_reconfig_enable "true"] && $d_L>1 }]
    conf_params_en "set_capability_reg_enable"  [expr {![param_matches wrapper_opt "base"] && [device_is_xseries] && [param_matches pll_reconfig_enable "true"]  }]
    conf_params_en "set_user_identifier"        [expr {![param_matches wrapper_opt "base"] && [device_is_xseries] && [param_matches pll_reconfig_enable "true"] && [param_matches set_capability_reg_enable "true"]  }]
    conf_params_en "set_csr_soft_logic_enable"  [expr {![param_matches wrapper_opt "base"] && [device_is_xseries] && [param_matches pll_reconfig_enable "true"]  }]
    conf_params_en "set_prbs_soft_logic_enable" [expr {![param_matches wrapper_opt "base"] && [device_is_xseries] && [param_matches pll_reconfig_enable "true"]  }]
#    conf_params_en "set_odi_soft_logic_enable"  [expr {![param_matches wrapper_opt "base"] && [device_is_xseries] && [param_matches pll_reconfig_enable "true"]  }]
    conf_params_en "bitrev_en"     [expr {![param_matches wrapper_opt "base"]}]
    conf_params_en "L"             1
    conf_params_en "M"             [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "GUI_EN_CFG_F"  [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "GUI_CFG_F"     [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "F"             [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "N"             [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "N_PRIME"       [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "S"             [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "K"             [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "SCR"           [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "CS"            [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "CF"            [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "HD"            [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "ECC_EN"        [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "TX"] }]
    conf_params_en "DLB_TEST"      [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "TX"]  }]
    conf_params_en "PHADJ"         [expr {![param_matches wrapper_opt "phy"] && [param_matches SUBCLASSV "2"]}]
    conf_params_en "ADJCNT"        [expr {![param_matches wrapper_opt "phy"] && [param_matches SUBCLASSV "2"] }]
    conf_params_en "ADJDIR"        [expr {![param_matches wrapper_opt "phy"] && [param_matches SUBCLASSV "2"] }]
    conf_params_en "DID"           [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"]}]
    conf_params_en "BID"           [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"]}]
    conf_params_en "LID0"          [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"]}]
    conf_params_en "LID1"          [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"] && $d_L >= 2}]
    conf_params_en "LID2"          [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"] && $d_L >= 3}]
    conf_params_en "LID3"          [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"] && $d_L >= 4}]
    conf_params_en "LID4"          [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"] && $d_L >= 5}]
    conf_params_en "LID5"          [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"] && $d_L >= 6}]
    conf_params_en "LID6"          [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"] && $d_L >= 7}]
    conf_params_en "LID7"          [expr {![param_matches wrapper_opt "phy"] && ![param_matches DATA_PATH "RX"] && $d_L == 8}]
    conf_params_en "FCHK0"         [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "FCHK1"         [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "FCHK2"         [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "FCHK3"         [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "FCHK4"         [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "FCHK5"         [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "FCHK6"         [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "FCHK7"         [expr {![param_matches wrapper_opt "phy"]}]
    conf_params_en "ED_TYPE"       1
    
   
   # Configure GUI parameters to be visible/not visible
   # conf_params_visible     <param>       <visible>
   conf_params_visible "pll_type"     [expr {![device_is_xseries]}]
   conf_params_visible "bonded_mode"  [expr {![param_matches DATA_PATH "RX"]}]
   # Transceiver reconfig options
   conf_params_visible "pll_reconfig_enable"        true
   set_display_item_property "gui_pll_reconfig_enable" VISIBLE true
   conf_params_visible "rcfg_jtag_enable"           [expr {[device_is_xseries]}]
   conf_params_visible "rcfg_shared"                [expr {[device_is_xseries]}]
   conf_params_visible "set_capability_reg_enable"  [expr {[device_is_xseries]}]
   conf_params_visible "set_user_identifier"        [expr {[device_is_xseries]}]
   conf_params_visible "set_csr_soft_logic_enable"  [expr {[device_is_xseries]}]
   conf_params_visible "set_prbs_soft_logic_enable" [expr {[device_is_xseries]}]

   #--DERIVE--PCS_CONFIG based on device family--
   if {[param_matches DEVICE_FAMILY "Stratix V"]} {
      set_parameter_property "PCS_CONFIG" ALLOWED_RANGES {"JESD_PCS_CFG1:Enabled Hard PCS" "JESD_PCS_CFG2:Enabled Soft PCS"}
   } elseif {[param_matches DEVICE_FAMILY "Arria V GZ"]} {
      set_parameter_property "PCS_CONFIG" ALLOWED_RANGES {"JESD_PCS_CFG1:Enabled Hard PCS" "JESD_PCS_CFG2:Enabled Soft PCS"}
   } elseif {[param_matches DEVICE_FAMILY "Arria V"]} {
      set_parameter_property "PCS_CONFIG" ALLOWED_RANGES {"JESD_PCS_CFG1:Enabled Hard PCS" "JESD_PCS_CFG4:Enabled PMA Direct"}
   } elseif {[param_matches DEVICE_FAMILY "Cyclone V"]} {
      set_parameter_property "PCS_CONFIG" ALLOWED_RANGES {"JESD_PCS_CFG1:Enabled Hard PCS"}
   } elseif {[param_matches DEVICE_FAMILY "Arria 10"]} {
      set_parameter_property "PCS_CONFIG" ALLOWED_RANGES {"JESD_PCS_CFG1:Enabled Hard PCS" "JESD_PCS_CFG2:Enabled Soft PCS"}
   } elseif {[param_matches DEVICE_FAMILY "Stratix 10"]} {
      set_parameter_property "PCS_CONFIG" ALLOWED_RANGES {"JESD_PCS_CFG1:Enabled Hard PCS" "JESD_PCS_CFG2:Enabled Soft PCS"}
   }

   #--DERIVE--lane_rate, pll_type based on device family--
   if {[param_matches wrapper_opt "base"]} {
       set_parameter_property "lane_rate" ALLOWED_RANGES 0:20000
   } elseif {[param_matches DEVICE_FAMILY "Stratix V"]} {
       if {[param_matches PCS_CONFIG "JESD_PCS_CFG1"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 2000:12200
       } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 2000:20000
       }
       #set_parameter_value "pll_type" "ATX"
       set_parameter_property "pll_type" ALLOWED_RANGES {"CMU" "ATX"}

   } elseif {[param_matches DEVICE_FAMILY "Arria V GZ"]} {
       if {[param_matches PCS_CONFIG "JESD_PCS_CFG1"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 2000:9900
       } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 2000:12500
       }
       #set_parameter_value "pll_type" "CMU"
       set_parameter_property "pll_type" ALLOWED_RANGES {"CMU" "ATX"}

   } elseif {[param_matches DEVICE_FAMILY "Arria V"]} {
       if {[param_matches PCS_CONFIG "JESD_PCS_CFG1"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 1000:6550
       } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG4"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 4000:9255
       }
       #set_parameter_value "pll_type" "CMU"
       set_parameter_property "pll_type" ALLOWED_RANGES {"CMU"}
  
   } elseif {[param_matches DEVICE_FAMILY "Cyclone V"]} {
       set_parameter_property "lane_rate" ALLOWED_RANGES 1000:5000
       #set_parameter_value "pll_type" "CMU"
       set_parameter_property "pll_type" ALLOWED_RANGES {"CMU"}

   } elseif {[param_matches DEVICE_FAMILY "Arria 10"]} {
       if {[param_matches PCS_CONFIG "JESD_PCS_CFG1"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 2000:12000
       } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 2000:20000
       }
   } elseif {[param_matches DEVICE_FAMILY "Stratix 10"]} {
       if {[param_matches PCS_CONFIG "JESD_PCS_CFG1"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 2000:12000
       } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2"]} {
          set_parameter_property "lane_rate" ALLOWED_RANGES 2000:20000
       }
   }
  
   #--DERIVE--reference clock--
   set_parameter_value "d_refclk_freq" [get_parameter_value "REFCLK_FREQ"]
   # Allow any values of refclk if disabled
   if {![param_is_enabled "REFCLK_FREQ"]} {
       set_parameter_property "REFCLK_FREQ" ALLOWED_RANGES {}
   }

   if {![param_matches wrapper_opt "base"]} {
      #--DERIVE--bitrev_en, PMA_WIDTH, SER_SIZE based on PCS_CONFIG--
      if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ] } {
         set_parameter_value "PMA_WIDTH" 32
         set_parameter_value "SER_SIZE" 4
      } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
         set_parameter_value "PMA_WIDTH" 40
      } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {
         set_parameter_value "PMA_WIDTH" 16
         set_parameter_value "SER_SIZE" 2
      } else { 
        #{[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]} 
         set_parameter_value "PMA_WIDTH" 80
      }
     
      #--DERIVE--BYTE_REVERSAL, BIT_REVERSAL and ALIGNMENT_PATTERN based on bitrev_en--
      if {[param_is_true "bitrev_en"]} {
         set_parameter_value "BIT_REVERSAL" 1
         set_parameter_value "BYTE_REVERSAL" 1
         set_parameter_value "ALIGNMENT_PATTERN" 0x3EB05
      } else {
         set_parameter_value "BIT_REVERSAL" 0
         set_parameter_value "BYTE_REVERSAL" 0
         set_parameter_value "ALIGNMENT_PATTERN" 0xA0D7C
      }
   
      #--DERIVE--unused tx and rx pcs parallel data width--
      if { [param_matches DEVICE_FAMILY "Stratix V"] || [param_matches DEVICE_FAMILY "Arria V GZ"]  } {
     if {[param_matches PCS_CONFIG "JESD_PCS_CFG1"]} {
            set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" [expr {64-[get_parameter_value "PMA_WIDTH"]-[get_parameter_value "SER_SIZE"]}]
            set_parameter_value "UNUSED_RX_PARALLEL_WIDTH" [expr {64-[get_parameter_value "PMA_WIDTH"] -24}]
         } elseif { [param_matches PCS_CONFIG "JESD_PCS_CFG2"]} {
        set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" [expr {64-[get_parameter_value "PMA_WIDTH"]}]
            set_parameter_value "UNUSED_RX_PARALLEL_WIDTH" [expr {64-[get_parameter_value "PMA_WIDTH"]}]
     }
      } elseif { [param_matches DEVICE_FAMILY "Arria V"] } {
         if {[param_matches PCS_CONFIG "JESD_PCS_CFG1"]} {
            set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" [expr {44-[get_parameter_value "PMA_WIDTH"]-[get_parameter_value "SER_SIZE"]}]
            set_parameter_value "UNUSED_RX_PARALLEL_WIDTH" [expr {44-[get_parameter_value "PMA_WIDTH"]-4}]
         } elseif { [param_matches PCS_CONFIG "JESD_PCS_CFG4"]} {
            # arbitrarily set to 1 for PMA direct mode
            set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" 1
            set_parameter_value "UNUSED_RX_PARALLEL_WIDTH" 1
         }
      } elseif { [param_matches DEVICE_FAMILY "Cyclone V"] } {
         set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" [expr {44-[get_parameter_value "PMA_WIDTH"]-[get_parameter_value "SER_SIZE"]}]
         set_parameter_value "UNUSED_RX_PARALLEL_WIDTH" [expr {44-[get_parameter_value "PMA_WIDTH"]-4}]
      } elseif { [param_matches DEVICE_FAMILY "Arria 10"] } {
     if {[param_matches PCS_CONFIG "JESD_PCS_CFG1"]} {
            set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" [expr {128-[get_parameter_value "PMA_WIDTH"]-[get_parameter_value "SER_SIZE"]}]
            set_parameter_value "UNUSED_RX_PARALLEL_WIDTH" [expr {128-[get_parameter_value "PMA_WIDTH"] -24}]
         } elseif { [param_matches PCS_CONFIG "JESD_PCS_CFG2"]} {
        set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" [expr {128-[get_parameter_value "PMA_WIDTH"]}]
            set_parameter_value "UNUSED_RX_PARALLEL_WIDTH" [expr {128-[get_parameter_value "PMA_WIDTH"]}]
         }
      } elseif { [param_matches DEVICE_FAMILY "Stratix 10"] } {
          if {[param_matches PCS_CONFIG "JESD_PCS_CFG1"]} {
            set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" [expr {80-[get_parameter_value "PMA_WIDTH"]-[get_parameter_value "SER_SIZE"]}]
            set_parameter_value "UNUSED_RX_PARALLEL_WIDTH" [expr {80-[get_parameter_value "PMA_WIDTH"] -24}]
         } elseif { [param_matches PCS_CONFIG "JESD_PCS_CFG2"]} {
            set_parameter_value "UNUSED_TX_PARALLEL_WIDTH" [expr {80-[get_parameter_value "PMA_WIDTH"]}]
            set_parameter_value "UNUSED_RX_PARALLEL_WIDTH" [expr {80-[get_parameter_value "PMA_WIDTH"]}]
         }
      }

      #--DERIVE--reconfig_address width and reconfig_shared (for Arria 10 and Stratix 10)
      if { [param_matches DEVICE_FAMILY "Arria 10"] && [param_is_true rcfg_shared] && $d_L>1 } {
         set_parameter_value "RECONFIG_ADDRESS_WIDTH" [expr { int (ceil ([log2 1024*$d_L]))}]
      } elseif { [param_matches DEVICE_FAMILY "Arria 10"] && (![param_is_true rcfg_shared] || $d_L==1) } {
         set_parameter_value "RECONFIG_ADDRESS_WIDTH" [expr { 10*$d_L }]
      } else {
         set_parameter_value "RECONFIG_ADDRESS_WIDTH" 7
      }

      #--DERIVE--pll locked's width-- 
      set_parameter_value "XCVR_PLL_LOCKED_WIDTH" [expr { [derive_bonded_mode] == "xN" ? 1 : $d_L  }] 
   }

   #--DERIVE--DATA_PATH--
   if {[param_matches wrapper_opt "base"]} {
      set_parameter_property "DATA_PATH" ALLOWED_RANGES { "RX:Receiver" "TX:Transmitter" }
   } else {
      set_parameter_property "DATA_PATH" ALLOWED_RANGES { "RX:Receiver" "TX:Transmitter" "RX_TX:Duplex" }
   }

   #--DERIVE--L--
   if {[param_matches wrapper_opt "phy"]} {
       set_parameter_property "L" ALLOWED_RANGES 1:32
   } else {
      if {[param_matches DEVICE_FAMILY "Arria V"]} {
      if {[param_matches bonded_mode "bonded"] && [param_is_enabled bonded_mode]} { 
             set_parameter_property "L" ALLOWED_RANGES 1:6
          } else {
         set_parameter_property "L" ALLOWED_RANGES 1:8
      } 
      } else {
          set_parameter_property "L" ALLOWED_RANGES 1:8
      }
   }

   if {![param_matches wrapper_opt "phy"]} {
      #--DERIVE--N_PRIME based on N--
      if {[expr {$d_CF == 0}]} {

         if {[expr {$d_N+$d_CS>= 1 }] && [expr {$d_N+$d_CS<= 4}] } {
         set_parameter_property "N_PRIME" ALLOWED_RANGES {4 8 12 16 20 24 28 32}
         } elseif {[expr {$d_N+$d_CS> 4 }] && [expr {$d_N+$d_CS<= 8}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {8 12 16 20 24 28 32}
         } elseif {[expr {$d_N+$d_CS> 8 }] && [expr {$d_N+$d_CS<= 12}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {12 16 20 24 28 32}
         } elseif {[expr {$d_N+$d_CS> 12 }] && [expr {$d_N+$d_CS<= 16}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {16 20 24 28 32}
         } elseif {[expr {$d_N+$d_CS> 16 }] && [expr {$d_N+$d_CS<= 20}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {20 24 28 32}
         } elseif {[expr {$d_N+$d_CS> 20 }] && [expr {$d_N+$d_CS<= 24}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {24 28 32}
         } elseif {[expr {$d_N+$d_CS> 24 }] && [expr {$d_N+$d_CS<= 28}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {28 32}
         } elseif {[expr {$d_N+$d_CS> 28 }] && [expr {$d_N+$d_CS<= 32}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {32}
         } elseif {[expr {$d_N+$d_CS> 32 }]} {
        send_message error "Sum of parameter N and parameter CS must be less than or equal 32 if parameter CF equal 0"
         }

      } else {

         if {[expr {$d_N>= 1 }] && [expr {$d_N<= 4}] } {
         set_parameter_property "N_PRIME" ALLOWED_RANGES {4 8 12 16 20 24 28 32}
         } elseif {[expr {$d_N> 4 }] && [expr {$d_N<= 8}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {8 12 16 20 24 28 32}
         } elseif {[expr {$d_N> 8 }] && [expr {$d_N<= 12}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {12 16 20 24 28 32}
         } elseif {[expr {$d_N> 12 }] && [expr {$d_N<= 16}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {16 20 24 28 32}
         } elseif {[expr {$d_N> 16 }] && [expr {$d_N<= 20}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {20 24 28 32}
         } elseif {[expr {$d_N> 20 }] && [expr {$d_N<= 24}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {24 28 32}
         } elseif {[expr {$d_N> 24 }] && [expr {$d_N<= 28}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {28 32}
         } elseif {[expr {$d_N> 28 }] && [expr {$d_N<= 32}] } {
           set_parameter_property "N_PRIME" ALLOWED_RANGES {32}
         }

      }
      
      #--DERIVE--F  
      #--If manual F configuration is enabled, get from User Input 
      #--otherwise, based on formula M*S*N'/(8*L)
      if {[param_is_true "GUI_EN_CFG_F"]} {
         set_parameter_value "F" [get_parameter_value "GUI_CFG_F"]
     set_parameter_property "GUI_CFG_F" ENABLED "true"
     set_parameter_property "GUI_CFG_F" VISIBLE "true"
     set_parameter_property "F" VISIBLE "false"
     
     #Update d_F variable
     set d_F [get_parameter_value "F"]

      } else {
         set d_float_F [expr {$d_M*$d_N_PRIME*$d_S*1.00/8/$d_L}]
         set_parameter_value "F" $d_float_F
     set_parameter_property "GUI_CFG_F" ENABLED "false"
     set_parameter_property "GUI_CFG_F" VISIBLE "false"
     set_parameter_property "F" VISIBLE "true"
     
     #Update d_F variable
     set d_F [get_parameter_value "F"] 

        #--LEGAL_CHECK--F must be integer
         if {$d_F != $d_float_F} {
        send_message error "Invalid F value : F = $d_float_F is not an integer. Please double check the setting of M, N', S, or L."
         }

      }
      #--DERIVE--K based on F--    
      set k_legal_range ""
      for {set i [expr int ([expr ceil ([expr {17.0/$d_F}])])] } {$i <= 32} {incr i} {
         if {[expr {[expr {$d_F*$i % 4}] == 0}] && [expr {$d_F*$i<= 1024}]} { 
            lappend k_legal_range "$i"
         }
      }
      set_parameter_property "K" ALLOWED_RANGES $k_legal_range
     
      #--DERIVE--F*K--
      set_parameter_value "FK" [expr {$d_F*$d_K}]

      #--DERIVE--calculate PULSE_WIDTH ( Formula: PULSE_WIDTH = ceil(link_clk/avs_clk) ;Assuming worse case avs_clk = 75MHz)--
      set_parameter_value "PULSE_WIDTH" [expr ceil ([get_parameter_value "lane_rate"]*1.00/(40*75))]
   
      #--DERIVE--calculate fifo depth required by rx_dll LS_FIFO_DEPTH = (2^ceil(log(min(256+2+1,(Fx32/4)+2+1),2)))--
      # Note : Added 2 location deep to FIFO to take account the late deassertion of fifo'empty signal and earlier assertion of fifo's full signal
      # Note : Added 1 locaion deep to FIFO. The maximum buffer size required from assertion of alldev_lane_aligned to the assertion of rbd_release is Fxk octets. However, there is one clock cycle to register the dev_lane_aligned that is generated from alignment_ready signals. Thus, the total buffer size should be FxK+4 octets
      set_parameter_value "LS_FIFO_DEPTH" [expr (pow ( 2 , ceil ( [ log2 [expr min (256 +3, [get_parameter_value "F"]*8 +3) ]] ))) ]

      #--DERIVE--fifo address width for LS_FIFO_DEPTH , LS_FIFO_WIDTHU = 1og2 (LS_FIFO_DEPTH)--
      set_parameter_value "LS_FIFO_WIDTHU" [log2 [get_parameter_value "LS_FIFO_DEPTH"]]

      #--LEGAL_CHECK--F=3 is not supported
      if {[get_parameter_value "F"]==3} {
         send_message error "Invalid F value : F equal to 3 is not supported"
      }

      #--LEGAL_CHECK--Check whether CF is divisible by L and M--
      if {[expr {$d_CF == 0}]} {

      } else {
         if { [expr {[expr {$d_L % $d_CF}]!= 0}] || [expr {[expr {$d_M % $d_CF}] != 0}] } { 
            send_message error  "CF must be common subdivisors of L and M"set_parameter_property
         }
      }

      #--LEGAL_CHECK--Inject warning if user is using auto-derived F with CF or HD are enabled--
      if {[param_matches DEVICE_FAMILY "Arria 10"]} {
	     if { ![param_is_true "GUI_EN_CFG_F"] && [expr {$d_CF !=0 }] } {
             send_message warning "The auto-derived F using formula F=M*S*N'/(8*L) is not supported with Control Word format. Thus, the auto-derived F value may be incorrect. Please enable manual F configuration and set the desired/correct value."
         }
      } else {
	     if { ![param_is_true "GUI_EN_CFG_F"] && [expr {$d_CF !=0 || [param_matches HD "1"]}] } {
             send_message warning "The auto-derived F using formula F=M*S*N'/(8*L) is not supported with Control Word and High Density format. Thus, the auto-derived F value may be incorrect. Please enable manual F configuration and set the desired/correct value."
         }
      }
       
      #--LEGAL_CHECK--Check Legal value for K, (17/F =< K <= min(32,1024/F) and F*K must be divisible by 4 )--
      if {[expr {$d_K < 17/$d_F || $d_K >32 || $d_F*$d_K % 4 != 0 || $d_F*$d_K > 1024}] } {
         send_message error  "Invalid K value : Legal range for K is 17/F &le K &le min(32,1024/F) and multiplication of F and K must be divisible by 4."
      }
        
      if { ![param_matches DATA_PATH "RX" ] } {
         for {set i 0} {$i < $d_L} {incr i} {
            #--DERIVE--calculate checksum for each lane--
            set p_LID [get_parameter_value "LID$i"]
            set_parameter_value "FCHK$i" [expr {[expr {$d_ADJCNT+$d_ADJDIR+$d_BID+$d_CF+$d_CS+$d_DID+($d_F-1)+$d_HD+$d_JESDV+($d_K-1)+($d_L-1)+ $p_LID +($d_M-1)+($d_N-1)+($d_N_PRIME-1)+$d_PHADJ+($d_S-1)+$d_SCR+$d_SUBCLASSV+$d_RES1+ $d_RES2}] %256}]
        #--LEGAL_CHECK--LID for each lane must be unique--
            if {$i< [ expr {$d_L-1} ] } {
             if {[get_parameter_value "LID$i"]==[get_parameter_value "LID[expr {$i+1}]"]} {
                  send_message error "Invalid LID value : Lane ID for each lane must be unique"
               }
            }
         }

         #--DERIVE--set unused Lane ID to 0--
         for {set i $d_L } {$i < 8} {incr i} {
           set_parameter_value "FCHK$i" 0
         }

         #--LEGAL_CHECK--Warns User if parameters ADJCNT, ADJDIR, and PHADJ are set for jesd204 subclass !=2-- 
         if {![param_matches SUBCLASSV 2 ] && ($d_ADJCNT !=0 || $d_ADJDIR !=0 ||$d_PHADJ !=0)} {
            send_message warning "Parameters ADJCNT, ADJDIR and PHADJ should be disabled or set to 0. They are used in Jesd204 subclass 2 only."
         } 
      } 
   } 

   #--LEGAL_CHECK--Send Error message if RX_TX is selected with wrapper_opt= base only
   if {[get_parameter_value "DATA_PATH"] == "RX_TX" && [get_parameter_value "wrapper_opt"] == "base"} {
      send_message error "Duplex mode (RX_TX) with base only is not supported."
   } 
   
   #--LEGAL_CHECK--Send Error message if bonded_mode with lane_rate > 15Gbps.
   if {[param_matches DEVICE_FAMILY "Arria 10"] && [param_matches bonded_mode "bonded"] && $l_rate > 15000 && [get_parameter_value "DATA_PATH"] != "RX" && [get_parameter_value "wrapper_opt"] != "base"} {
      send_message error "High data rate (>15000 Mbps) requires Non-Bonded mode for better jitter performance."
   }
   
   #--LEGAL_CHECK--Send Error message if ADME is enabled without reconfig_shared enabled
   if {[device_is_xseries] && [param_is_true rcfg_jtag_enable] && ![param_is_true rcfg_shared] && $d_L>1 } {
      send_message error "Enable Altera Debug Master Endpoint option requires Share Reconfiguration Interface option to be enabled."
   }

   # Hide Tranceiver Options tab for wrapper_opt == base
   set_display_item_property "Transceiver Options" VISIBLE [expr {![param_matches wrapper_opt "base"]}]

   # Print info message which are useful for user
   if {[param_matches DEVICE_FAMILY "Stratix V" ] } {
     send_message warning "The maximum lane rate is limited by different device speed grade and different transceiver pma speed grade. Please refer to user guide for details."
     if {[param_matches PCS_CONFIG "JESD_PCS_CFG2"] && $l_rate > 12500} {
       send_message warning "Lane rate selected exceeds maximum supported rate (12500 Mbps)."
     }
   } elseif {[param_matches DEVICE_FAMILY "Arria V GZ" ]} {
     send_message warning "The maximum lane rate is limited by different device speed grade and different transceiver pma speed grade. Please refer to user guide for details."
   } elseif {[param_matches DEVICE_FAMILY "Cyclone V" ]} {
     send_message warning "For Cyclone V family, only GT/ST devices can support data rate up to 5000 Mbps."
     send_message warning "The maximum lane rate is limited by different device speed grade and different transceiver pma speed grade. Please refer to user guide for details."
   } elseif {[param_matches DEVICE_FAMILY "Arria V" ]} {
     send_message warning "For Arria V family, only GT/ST devices can support data rate higher than 6550 Mbps with PMA Direct mode enabled."
     if {[param_matches PCS_CONFIG "JESD_PCS_CFG4"] && $l_rate > 7500} {
       send_message warning "Lane rate selected exceeds maximum supported rate (7500 Mbps)."
     }
   } elseif {[param_matches DEVICE_FAMILY "Arria 10" ]} {
     # Case:368924 Remove supported max data rate warning. Let UG speaks the words.
     #if {[param_matches PCS_CONFIG "JESD_PCS_CFG2"] && $l_rate > 13500} {
     #  send_message warning "Lane rate selected exceeds maximum supported rate (13500 Mbps)."
     #}
   }

   if {![param_matches DATA_PATH "RX" ] && [device_is_vseries] } {
      set_display_item_property "gui_bonded_mode" text \
      "<html><b>Note</b> 
      <br>- The bonding type is set to <b>\"[derive_bonded_mode]\"</b>.
      [expr {[derive_bonded_mode] == "fb_compensation" ? "<br>- For feedback compensation mode, the allowable reference clock frequency is limited to <b>lane_rate/$d_pcs_pma_width</b>." : ""}]
      </html>" 
   } else {
     set_display_item_property "gui_bonded_mode" text "" 
   }

   if {![param_matches wrapper_opt "base"]} {
      if {[device_is_vseries]} {
         if {[param_matches DATA_PATH TX]} {
            send_message info "PLL reference clock is set to [get_parameter_value "REFCLK_FREQ"] MHz ."
         } elseif {[param_matches DATA_PATH RX]} {
            send_message info "CDR reference clock is set to [get_parameter_value "REFCLK_FREQ"] MHz ."
         } else {
            send_message info "Both PLL and CDR reference clocks are set to [get_parameter_value "REFCLK_FREQ"] MHz ."
         }
      } else {
         if {[param_matches DATA_PATH TX]} {
         } elseif {[param_matches DATA_PATH RX]} {
            send_message info "CDR reference clock is set to [get_parameter_value "REFCLK_FREQ"] MHz ."
         } else {
            send_message info "CDR reference clock is set to [get_parameter_value "REFCLK_FREQ"] MHz ."
         }
      }       
   }

    send_message info "The IP core simulation testbench (ip_sim) is generated when the Generate Example Design button is pushed"
    
    # returns ed type, options:
    #   NIOS
    #   RTL
    #   DATAPATH
    #   NONE
    set ed_type [get_supported_ed]
    set_parameter_value ED_TYPE $ed_type
    
    set_display_item_property "gui_ed_type"         text ""
    set_display_item_property "gui_generic_ed_type" text ""
    
    set_parameter_property ED_GENERIC_5SERIES   VISIBLE false
    set_parameter_property ED_GENERIC_A10       VISIBLE false
    set_parameter_property ED_GENERIC_S10       VISIBLE false
    
    if {$ed_type == "NIOS"} {
        conf_params_en "ED_FILESET_SIM"         0
        conf_params_en "ED_FILESET_SYNTH"       1
        conf_params_en "ED_DEV_KIT"             1
    } elseif {$ed_type == "RTL"} {
        conf_params_en "ED_FILESET_SIM"         1
        conf_params_en "ED_FILESET_SYNTH"       1
        conf_params_en "ED_DEV_KIT"         	0
    } elseif {$ed_type == "DATAPATH"} {
	conf_params_en "ED_FILESET_SIM"         1
        conf_params_en "ED_FILESET_SYNTH"       1
	conf_params_en "ED_DEV_KIT"             1
    } else {
        # display for available example design
        set ED_NOT_SUPPORTED "No example  design that matches the parameters selected in the IP tab is available."
        send_message info $ED_NOT_SUPPORTED
        set_display_item_property "gui_ed_type" text \
            "<html>
                $ED_NOT_SUPPORTED
                <br>
            </html>" 
        
        # display for generic example design
        if {[param_matches DEVICE_FAMILY "Arria 10"]} {
            set_parameter_property "ED_GENERIC_A10" VISIBLE true
	    set_parameter_property "ED_DEV_KIT"     VISIBLE true
	    set_parameter_property "ED_DEV_KIT" ALLOWED_RANGES {"NONE:None" "A10_FPGA:Arria 10 GX FPGA Development Kit"}
            
            conf_params_en "ED_FILESET_SIM"         [param_matches ED_GENERIC_A10 "RTL"]
            conf_params_en "ED_FILESET_SYNTH"       [expr [param_matches ED_GENERIC_A10 "RTL"] || [param_matches ED_GENERIC_A10 "NIOS"]]
            conf_params_en "ED_DEV_KIT"             [param_matches ED_GENERIC_A10 "NIOS"]
	    
	    set WARN_GENERIC_ED_NOTE1 "Generic example design parameter selection may not match the parameters selected in the IP tab."
	    set WARN_GENERIC_ED_NOTE2 "Refer to the JESD204B User Guide for more details on the generic example design parameter assignments."
	    send_message warning "$WARN_GENERIC_ED_NOTE1 $WARN_GENERIC_ED_NOTE2"
	    set_display_item_property "gui_generic_ed_type" text \
            "<html><b>WARNING</b> 
            <br>- $WARN_GENERIC_ED_NOTE1</b>
            <br>- $WARN_GENERIC_ED_NOTE2</b>
            </html>"
	} elseif {[param_matches DEVICE_FAMILY "Stratix 10"]} {
	    set_parameter_property "ED_GENERIC_S10" VISIBLE false
	    set_parameter_property "ED_DEV_KIT"     VISIBLE true
	    set_parameter_property "ED_DEV_KIT" ALLOWED_RANGES {"NONE:None" "S10_SI:Stratix 10 Signal Integrity Development Kit"}
	    
	    conf_params_en "ED_FILESET_SIM"         [param_matches ED_GENERIC_S10 "DATAPATH"]
            conf_params_en "ED_FILESET_SYNTH"       [param_matches ED_GENERIC_S10 "DATAPATH"]
	    conf_params_en "ED_DEV_KIT"             [param_matches ED_GENERIC_S10 "DATAPATH"]
	} else {
            set_parameter_property "ED_GENERIC_5SERIES" VISIBLE true
	    set_parameter_property "ED_DEV_KIT"         VISIBLE false
            
            conf_params_en "ED_FILESET_SIM"         [param_matches ED_GENERIC_5SERIES "RTL"]
            conf_params_en "ED_FILESET_SYNTH"       [param_matches ED_GENERIC_5SERIES "RTL"]
            conf_params_en "ED_DEV_KIT"             0
	    
	    set WARN_GENERIC_ED_NOTE1 "Generic example design parameter selection may not match the parameters selected in the IP tab."
	    set WARN_GENERIC_ED_NOTE2 "Refer to the JESD204B User Guide for more details on the generic example design parameter assignments."
	    send_message warning "$WARN_GENERIC_ED_NOTE1 $WARN_GENERIC_ED_NOTE2"
	    set_display_item_property "gui_generic_ed_type" text \
            "<html><b>WARNING</b> 
            <br>- $WARN_GENERIC_ED_NOTE1</b>
            <br>- $WARN_GENERIC_ED_NOTE2</b>
            </html>"
        }
    }

    conf_params_en "ED_HDL_FORMAT_SIM"      [expr [param_is_true "ED_FILESET_SIM"] && [get_parameter_property "ED_FILESET_SIM" ENABLED]]
    conf_params_en "ED_HDL_FORMAT_SYNTH"    [expr [param_is_true "ED_FILESET_SYNTH"] && [get_parameter_property "ED_FILESET_SYNTH" ENABLED]]
    
    # display note of mixed HDL when simulation fileset is selected
    if {[expr [param_is_true "ED_FILESET_SIM"] && [get_parameter_property "ED_FILESET_SIM" ENABLED]]} {
        send_message info "Some submodules in example design simulation files will be generated in mixed language formats." 
    }
    
    # display note of mixed HDL when synthesis fileset is selected
    if {[expr [param_is_true "ED_FILESET_SYNTH"] && [get_parameter_property "ED_FILESET_SYNTH" ENABLED]]} {
        send_message info "Some submodules in example design synthesis files will be generated in mixed language formats." 
    }
    
    if {[param_matches DEVICE_FAMILY "Arria 10"]} {
        if {[param_matches ED_DEV_KIT "A10_FPGA"]} {
            set INFO_TARGET_BOARD1 "Family: Arria 10 Device: 10AX115S3F45E2SGE3"
            set INFO_TARGET_BOARD2 "Example design supports generation, simulation and Quartus compile flows for any selected device."
            set INFO_TARGET_BOARD3 "The hardware support is provided through selected development kit(s) with a specific device."
            set INFO_TARGET_BOARD4 "To exclude hardware aspects of example design, select None from the Target Development Kit pull down menu."
            
            send_message info       "Target development kit board: $INFO_TARGET_BOARD1. $INFO_TARGET_BOARD2 $INFO_TARGET_BOARD3 $INFO_TARGET_BOARD4"
            send_message warning    "Example design target device may not match the device selected for your project"
            
            set_display_item_property "gui_ed_dev_kit" text \
                "<html>
                    <blockquote><blockquote>$INFO_TARGET_BOARD1</blockquote></blockquote>
                    <br>$INFO_TARGET_BOARD2
                    <br>$INFO_TARGET_BOARD3
                    <br>$INFO_TARGET_BOARD4
                </html>"
        } else {
            set device [get_parameter_value part_trait_dp]
            set INFO_TARGET_BOARD1 "Family: Arria 10 Device: $device"
            
            set_display_item_property "gui_ed_dev_kit" text \
                "<html>
                    <blockquote><blockquote>$INFO_TARGET_BOARD1</blockquote></blockquote>
                </html>"
        }
    } elseif {[param_matches DEVICE_FAMILY "Stratix 10"]} {
	if {[param_matches ED_DEV_KIT "S10_SI"]} {
            set INFO_TARGET_BOARD1 "Family: Stratix 10 Device: SI Development Kit"
            set INFO_TARGET_BOARD2 "Example design supports generation, simulation and Quartus compile flows for any selected device."
            set INFO_TARGET_BOARD3 "The hardware support is provided through selected development kit(s) with a specific device."
            set INFO_TARGET_BOARD4 "To exclude hardware aspects of example design, select None from the Target Development Kit pull down menu."
            
            send_message info       "Target development kit board: $INFO_TARGET_BOARD1. $INFO_TARGET_BOARD2 $INFO_TARGET_BOARD3 $INFO_TARGET_BOARD4"
            send_message warning    "Example design target device may not match the device selected for your project"
            
            set_display_item_property "gui_ed_dev_kit" text \
                "<html>
                    <blockquote><blockquote>$INFO_TARGET_BOARD1</blockquote></blockquote>
                    <br>$INFO_TARGET_BOARD2
                    <br>$INFO_TARGET_BOARD3
                    <br>$INFO_TARGET_BOARD4
                </html>"
        } else {
            set device [get_parameter_value part_trait_dp]
            set INFO_TARGET_BOARD1 "Family: Stratix 10 Device: $device"
            
            set_display_item_property "gui_ed_dev_kit" text \
                "<html>
                    <blockquote><blockquote>$INFO_TARGET_BOARD1</blockquote></blockquote>
                </html>"
        }
    } else {
        set_display_item_property "gui_ed_dev_kit" text ""
    }
    
    

   #Debug
   send_message debug  "Derived F  = $d_F"
   send_message debug  "DEVICE_FAMILY =  [get_parameter_value "DEVICE_FAMILY"]"
   send_message debug  "part_trait_bd =  [get_parameter_value "part_trait_bd"]"
   send_message debug  "part_trait_dp =  [get_parameter_value "part_trait_dp"]"
   send_message debug  "pll_type =  [get_parameter_value "pll_type"]"
   send_message debug  "JESDV =  [get_parameter_value "JESDV"]"
   send_message debug  "PMA_WIDTH =  [get_parameter_value "PMA_WIDTH"]"
   send_message debug  "SER_SIZE =  [get_parameter_value "SER_SIZE"]"
   send_message debug  "FK =  [get_parameter_value "FK"]"
   send_message debug  "BIT_REVERSAL =  [get_parameter_value "BIT_REVERSAL"]"
   send_message debug  "BYTE_REVERSAL =  [get_parameter_value "BYTE_REVERSAL"]"
   send_message debug  "ALIGNMENT_PATTERN =  [get_parameter_value "ALIGNMENT_PATTERN"]"
   send_message debug  "OPTIMIZE =  [get_parameter_value "OPTIMIZE"]"
   send_message debug  "PULSE_WIDTH =  [get_parameter_value "PULSE_WIDTH"]"
   send_message debug  "LS_FIFO_DEPTH =  [get_parameter_value "LS_FIFO_DEPTH"]"
   send_message debug  "LS_FIFO_WIDTHU =  [get_parameter_value "LS_FIFO_WIDTHU"]"
   send_message debug  "UNUSED_TX_PARALLEL_WIDTH = [get_parameter_value "UNUSED_TX_PARALLEL_WIDTH"]"
   send_message debug  "UNUSED_RX_PARALLEL_WIDTH = [get_parameter_value "UNUSED_RX_PARALLEL_WIDTH"]"
   send_message debug  "XCVR_PLL_LOCKED_WIDTH    = [get_parameter_value "XCVR_PLL_LOCKED_WIDTH"]" 
   send_message debug  "Total defined parameters = [llength [get_parameters]]"

} 

#############################################################
#              Composed Callback
#############################################################
proc my_compose_callback {} {
   my_jesd_add_instance
   my_jesd_add_connection
   # Get allowed_range for reference clock from PHY
   if {![param_matches wrapper_opt "base"]} {
      if {[device_is_vseries]} {
         set refclk_range [get_instance_parameter_property "inst_phy" d_refclk_freq ALLOWED_RANGES]
         set ranges {}
         foreach refclk $refclk_range {
            lappend ranges [expr double([extract_Int_frm_str $refclk])]
         }
         conf_params_range "REFCLK_FREQ" $ranges
         send_message debug "Allowed Frequencies :$ranges"
      } else {
     if {![param_matches DATA_PATH "TX"]} {
            set refclk_range [get_instance_parameter_property "inst_phy" d_refclk_freq ALLOWED_RANGES]
            conf_params_range "REFCLK_FREQ" $refclk_range
            send_message debug "Allowed Frequencies :$refclk_range"
         }
      } 
   }

   if {[param_is_true "TERMINATE_RECONFIG_EN" ]} {
      my_jesd_reconfig_adapter 
   }

   if {[param_is_true "TEST_COMPONENTS_EN" ]} {
      # Case:368924 Use only 1 TX PLL
      set single_tx_pll 1
      if { [expr {$single_tx_pll == 1}] } {
         set g_xs_PLL 1
      } else {
         set g_xs_PLL [expr { int(ceil ([get_parameter_value "L"]*1.00/6)) }]
      }

      my_jesd_test_add_instance $g_xs_PLL
      my_jesd_test_add_connection $g_xs_PLL    
   }


   send_message debug  "Total number of defined ports = [get_total_ports [get_module_ports]]"
  
} 

# Add instance and set its parameters value
proc my_jesd_add_instance {} {

   if {[param_matches DATA_PATH "TX" ]} {

      add_instance                  inst_clk_bridge            altera_clock_bridge        18.1
      set_instance_parameter_value  inst_clk_bridge            NUM_CLOCK_OUTPUTS  2

      add_instance                  inst_rst_n_bridge          altera_reset_bridge        18.1
      set_instance_parameter_value  inst_rst_n_bridge          ACTIVE_LOW_RESET   1
      set_instance_parameter_value  inst_rst_n_bridge          NUM_RESET_OUTPUTS  2
       
      if {[param_matches wrapper_opt "base"] || [param_matches wrapper_opt "base_phy"] } {
         add_instance                  inst_tx                    altera_jesd204_tx          18.1
         set_instance_property         inst_tx                SUPPRESS_ALL_WARNINGS      true
         propagate_params              inst_tx         
      }
      if {[param_matches wrapper_opt "phy"] || [param_matches wrapper_opt "base_phy"] } {    
     add_instance                  inst_phy             altera_jesd204_phy         18.1 
     set_instance_property         inst_phy                SUPPRESS_ALL_WARNINGS      true
     #set_instance_property         inst_phy                SUPPRESS_ALL_INFO_MESSAGES      true
     propagate_params              inst_phy
      }

   } elseif {[param_matches DATA_PATH "RX" ]} {

      add_instance                  inst_clk_bridge            altera_clock_bridge        18.1
      set_instance_parameter_value  inst_clk_bridge            NUM_CLOCK_OUTPUTS  2

      add_instance                  inst_rst_n_bridge          altera_reset_bridge        18.1
      set_instance_parameter_value  inst_rst_n_bridge          ACTIVE_LOW_RESET   1
      set_instance_parameter_value  inst_rst_n_bridge          NUM_RESET_OUTPUTS  2

      if {[param_matches wrapper_opt "base"] || [param_matches wrapper_opt "base_phy"] } {
         add_instance                  inst_rx                    altera_jesd204_rx          18.1
         set_instance_property         inst_rx                 SUPPRESS_ALL_WARNINGS      true
         propagate_params              inst_rx
      }
      if {[param_matches wrapper_opt "phy"] || [param_matches wrapper_opt "base_phy"] } {    
         add_instance                  inst_phy                altera_jesd204_phy         18.1
     set_instance_property         inst_phy                SUPPRESS_ALL_WARNINGS      true
    # set_instance_property         inst_phy                SUPPRESS_ALL_INFO_MESSAGES      true
         propagate_params              inst_phy
      }
    } else { 
    # param_matches DATA_PATH "RX_TX"
      add_instance                  inst_tx_clk_bridge         altera_clock_bridge        18.1
      set_instance_parameter_value  inst_tx_clk_bridge         NUM_CLOCK_OUTPUTS  2

      add_instance                  inst_tx_rst_n_bridge       altera_reset_bridge        18.1
      set_instance_parameter_value  inst_tx_rst_n_bridge       ACTIVE_LOW_RESET   1
      set_instance_parameter_value  inst_tx_rst_n_bridge       NUM_RESET_OUTPUTS  2

      add_instance                  inst_rx_clk_bridge         altera_clock_bridge        18.1
      set_instance_parameter_value  inst_rx_clk_bridge         NUM_CLOCK_OUTPUTS  2

      add_instance                  inst_rx_rst_n_bridge       altera_reset_bridge        18.1
      set_instance_parameter_value  inst_rx_rst_n_bridge       ACTIVE_LOW_RESET   1
      set_instance_parameter_value  inst_rx_rst_n_bridge       NUM_RESET_OUTPUTS  2

      if {[param_matches wrapper_opt "base_phy"] } {
         add_instance                  inst_rx                    altera_jesd204_rx          18.1
         set_instance_property         inst_rx                SUPPRESS_ALL_WARNINGS      true
         propagate_params              inst_rx
         add_instance                  inst_tx                    altera_jesd204_tx          18.1
         set_instance_property         inst_tx                SUPPRESS_ALL_WARNINGS      true
         propagate_params              inst_tx      
      }

      if {[param_matches wrapper_opt "phy"] || [param_matches wrapper_opt "base_phy"]  } {              
         add_instance                  inst_phy                altera_jesd204_phy         18.1
         set_instance_property         inst_phy                SUPPRESS_ALL_WARNINGS      true
     #set_instance_property         inst_phy                SUPPRESS_ALL_INFO_MESSAGES      true
         propagate_params              inst_phy
      }
     
    }
}
# Set instances connection and set interface
proc my_jesd_add_connection {} {
   # Add prefix tx and rx to ensure the uniqueness interfaces naming for TX and RX
   set tx_ [expr {[param_matches DATA_PATH "RX_TX"] ? "tx_": ""}]
   set rx_ [expr {[param_matches DATA_PATH "RX_TX"] ? "rx_": ""}]
   set d_L [get_parameter_value "L"]

   #----------------------------------------------
   #                TX interfaces
   #----------------------------------------------
   send_message debug "prefix rx=$rx_, prefix tx=$tx_."
   # set_export_interface  <interface_name>      <interface_type>  <direction>  <instance_name>  <instance_interface>  <enable_condition>

   # Clocks and Resets
   set_export_interface   ${tx_}pll_ref_clk  clock      sink   inst_phy        ${tx_}pll_ref_clk   [expr {![param_matches wrapper_opt "base"] && \
                                                                                                      [set_tx_interfaces_on] && [device_is_vseries] }]
   set_export_interface   txlink_clk         clock      sink   inst_${tx_}clk_bridge    in_clk             [expr {[set_tx_interfaces_on]}]
   set_export_interface   txlink_rst_n       reset      sink   inst_${tx_}rst_n_bridge  in_reset           [expr {[set_tx_interfaces_on]}]
   set_connections        inst_${tx_}clk_bridge.out_clk        inst_${tx_}rst_n_bridge.clk         [expr {[set_tx_interfaces_on]}]
   # Management Interface (AV-MM) for JESD204B TX
   set_export_interface   jesd204_tx_avs_clk         clock   sink   inst_tx  jesd204_tx_avs_clk    [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   jesd204_tx_avs_rst_n       reset   sink   inst_tx  jesd204_tx_avs_rst_n  [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   jesd204_tx_avs             avalon  slave  inst_tx  jesd204_tx_avs        [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]    
       
   # AV-ST interface Signal (Sink) for JESD204B TX
   set_export_interface   jesd204_tx_link            avalon_streaming  sink  inst_tx  avst_tx      [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]    

   # Non AV-ST Interface Signal
   set_export_interface   ${tx_}somf                 conduit  start  inst_tx  somf                    [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]

   # OOB signals
   set_export_interface   jesd204_tx_int             interrupt  sender  inst_tx  jesd204_tx_int       [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]

   # JESD204B Specific Interface Signal 
   set_export_interface   ${tx_}sysref               conduit  end    inst_tx  sysref                  [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   sync_n                     conduit  end    inst_tx  sync_n                  [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}dev_sync_n           conduit  start  inst_tx  dev_sync_n              [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   mdev_sync_n                conduit  end    inst_tx  mdev_sync_n             [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }] 
   set_export_interface   jesd204_tx_frame_ready     conduit  start  inst_tx  jesd204_tx_frame_ready  [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }] 
                  
   # Configuration and status signals
   set_export_interface   ${tx_}csr_l                conduit  start  inst_tx  csr_l                   [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_f                conduit  start  inst_tx  csr_f                   [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_k                conduit  start  inst_tx  csr_k                   [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_m                conduit  start  inst_tx  csr_m                   [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_cs               conduit  start  inst_tx  csr_cs                  [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_n                conduit  start  inst_tx  csr_n                   [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_np               conduit  start  inst_tx  csr_np                  [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_s                conduit  start  inst_tx  csr_s                   [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_hd               conduit  start  inst_tx  csr_hd                  [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_cf               conduit  start  inst_tx  csr_cf                  [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   ${tx_}csr_lane_powerdown   conduit  start  inst_tx  csr_lane_powerdown      [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   csr_tx_testmode            conduit  start  inst_tx  csr_tx_testmode         [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   csr_tx_testpattern_a       conduit  start  inst_tx  csr_tx_testpattern_a    [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   csr_tx_testpattern_b       conduit  start  inst_tx  csr_tx_testpattern_b    [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   csr_tx_testpattern_c       conduit  start  inst_tx  csr_tx_testpattern_c    [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   csr_tx_testpattern_d       conduit  start  inst_tx  csr_tx_testpattern_d    [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }]
   set_export_interface   jesd204_tx_frame_error     conduit  end    inst_tx  jesd204_tx_frame_error  [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] }] 
   
   # Debug & Testing
   set_export_interface  jesd204_tx_dlb_data         conduit  start  inst_tx   jesd204_tx_pcs_data   [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}]
   set_export_interface  jesd204_tx_dlb_kchar_data   conduit  start  inst_tx   jesd204_tx_pcs_kchar_data   [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}]

   # PLL for device family = 10 series
   set_export_interface  pll_locked                  conduit  end    inst_tx  phy_csr_pll_locked    [expr {![param_matches wrapper_opt "phy"] && [set_tx_interfaces_on] && \
                                                                                                       ![device_is_vseries] && ![param_is_true "TEST_COMPONENTS_EN"] }]
   # PHY Interfaces
   set_export_interface  txphy_clk                   conduit  start  inst_phy   txphy_clk           [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] }]
   set_export_interface  tx_serial_data              conduit  start  inst_phy   tx_serial_data      [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] }]
   set_export_interface  pll_powerdown               conduit  end    inst_phy   pll_powerdown       [expr {![param_matches wrapper_opt "base"] && \
                                                                                                       [set_tx_interfaces_on] && [device_is_vseries] && ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_export_interface  tx_analogreset              conduit  end    inst_phy   tx_analogreset      [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] && \
                                                                                                            ![param_is_true "TEST_COMPONENTS_EN"] }]
   set_export_interface  tx_digitalreset             conduit  end    inst_phy   tx_digitalreset     [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] && \
                                                                                                            ![param_is_true "TEST_COMPONENTS_EN"] }]
   set_export_interface  tx_analogreset_stat         conduit  start  inst_phy   tx_analogreset_stat  [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] && \
                                                                                                            ![param_is_true "TEST_COMPONENTS_EN"] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
   set_export_interface  tx_digitalreset_stat        conduit  start  inst_phy   tx_digitalreset_stat [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] && \
                                                                                                            ![param_is_true "TEST_COMPONENTS_EN"] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
   set_export_interface  reconfig_to_xcvr            conduit  end    inst_phy   reconfig_to_xcvr    [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] && [device_is_vseries] &&\
                                                                                                       ![param_is_true "TERMINATE_RECONFIG_EN"]}]
   set_export_interface  reconfig_from_xcvr          conduit  start  inst_phy   reconfig_from_xcvr  [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] && [device_is_vseries] &&\
                                                                                                           ![param_is_true "TERMINATE_RECONFIG_EN"]}]
   set_export_interface  pll_locked                  conduit  start  inst_phy   phy_csr_pll_locked  [expr {![param_matches wrapper_opt "base"] && \
                                                                                                        [set_tx_interfaces_on] && [device_is_vseries] && ![param_is_true "TEST_COMPONENTS_EN"] }]
   set_export_interface  tx_cal_busy                 conduit  start  inst_phy   phy_csr_tx_cal_busy [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] && \
                                                                                                            ![param_is_true "TEST_COMPONENTS_EN"] }]
   
   # Non-bonded or Bonded hssi clk for device_family = 10 series
   if {$d_L == 1} {
      set_export_interface  "[derive_pll_mode_clk_xs $d_L clk_name]"   [derive_pll_mode_clk_xs $d_L clk_type]  end  inst_phy "[derive_pll_mode_clk_xs $d_L clk_name]" \
                             [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] && ![device_is_vseries] && ![param_is_true "TEST_COMPONENTS_EN"] }]
   } else {
      for { set i 0 } {$i < $d_L} {incr i} {
      set_export_interface  "[derive_pll_mode_clk_xs $d_L clk_name]_ch${i}"   [derive_pll_mode_clk_xs $d_L clk_type]  end  inst_phy "[derive_pll_mode_clk_xs $d_L clk_name]_ch${i}" \
                             [expr {![param_matches wrapper_opt "base"] && [set_tx_interfaces_on] && ![device_is_vseries] && ![param_is_true "TEST_COMPONENTS_EN"] }]
      }

   }

   # AV-MM Interface for Dynamic Reconfig
   set_export_interface   reconfig_clk         clock   sink   inst_phy   reconfig_clk              [expr {![param_matches wrapper_opt "base"] && \
                                                                                                               [param_is_true "pll_reconfig_enable"] && ![device_is_vseries] }]
     #RECONFIG_SHARED = 1
   set_export_interface   reconfig_clk         clock   sink   inst_phy   reconfig_clk              [expr {![param_matches wrapper_opt "base"] && [expr {[param_is_true rcfg_shared] || $d_L==1}] && \
                                                                                                               [param_is_true "pll_reconfig_enable"] && ![device_is_vseries] }]
   set_export_interface   reconfig_reset       reset   sink   inst_phy   reconfig_reset            [expr {![param_matches wrapper_opt "base"] && [expr {[param_is_true rcfg_shared] || $d_L==1}] && \
                                                                                                               [param_is_true "pll_reconfig_enable"] && ![device_is_vseries] }]
   set_export_interface   reconfig_avmm        avalon  slave  inst_phy   reconfig_avmm             [expr {![param_matches wrapper_opt "base"] && [expr {[param_is_true rcfg_shared] || $d_L==1}] \
                                                                                                               && [param_is_true "pll_reconfig_enable"] && ![device_is_vseries] }]
     #RECONFIG_SHARED = 0
   set_export_interface   reconfig_clk         conduit   sink   inst_phy   reconfig_clk              [expr {![param_matches wrapper_opt "base"] && ![expr {[param_is_true rcfg_shared] || $d_L==1}] && \
                                                                                                               [param_is_true "pll_reconfig_enable"] && ![device_is_vseries] }]
   set_export_interface   reconfig_reset       conduit   sink   inst_phy   reconfig_reset            [expr {![param_matches wrapper_opt "base"] && ![expr {[param_is_true rcfg_shared] || $d_L==1}] && \
                                                                                                               [param_is_true "pll_reconfig_enable"] && ![device_is_vseries] }]
   set_export_interface   reconfig_avmm        conduit   slave  inst_phy   reconfig_avmm             [expr {![param_matches wrapper_opt "base"] && ![expr {[param_is_true rcfg_shared] || $d_L==1}] \
                                                                                                               && [param_is_true "pll_reconfig_enable"] && ![device_is_vseries] }]

   # -------------- Base_Phy------------------#
   # set connections & interfaces for base_phy 
   set_connections   inst_${tx_}rst_n_bridge.out_reset           inst_tx.txlink_rst_n             [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}]
   set_connections   inst_${tx_}rst_n_bridge.out_reset_1         inst_phy.txlink_rst_n            [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}]
   set_connections   inst_${tx_}clk_bridge.out_clk               inst_tx.txlink_clk               [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}]
   set_connections   inst_${tx_}clk_bridge.out_clk_1             inst_phy.txlink_clk              [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}] 
   set_connections   inst_tx.jesd204_tx_pcs_data                 inst_phy.jesd204_tx_pcs_data        [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}] 
   set_connections   inst_tx.jesd204_tx_pcs_kchar_data           inst_phy.jesd204_tx_pcs_kchar_data  [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}]

   set_connections   inst_tx.csr_lane_polarity                   inst_phy.${tx_}csr_lane_polarity    [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}] 
   set_connections   inst_tx.csr_bit_reversal                    inst_phy.${tx_}csr_bit_reversal     [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}] 
   set_connections   inst_tx.csr_byte_reversal                   inst_phy.${tx_}csr_byte_reversal    [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}] 
   set_connections   inst_phy.phy_csr_pll_locked                 inst_tx.phy_csr_pll_locked          [expr {[param_matches wrapper_opt "base_phy"] && \
                                                                                                       [set_tx_interfaces_on] && [device_is_vseries] && ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_connections   inst_phy.phy_csr_tx_cal_busy                inst_tx.phy_csr_tx_cal_busy        [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]  && \
                                                                                                       ![param_is_true "TEST_COMPONENTS_EN"]}] 
   set_connections   inst_phy.phy_csr_tx_pcfifo_full             inst_tx.phy_csr_tx_pcfifo_full     [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}] 
   set_connections   inst_phy.phy_csr_tx_pcfifo_empty            inst_tx.phy_csr_tx_pcfifo_empty    [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}] 
   set_connections   inst_tx.phy_tx_elecidle                     inst_phy.phy_tx_elecidle           [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}] 
   set_connections   inst_tx.csr_lane_powerdown                  inst_phy.${tx_}csr_lane_powerdown     [expr {[param_matches wrapper_opt "base_phy"] && [set_tx_interfaces_on]}]
   
   # -------------- Phy Only------------------#
   # set connections & interfaces for phy 
   set_export_interface   phy_csr_tx_pcfifo_full      conduit   start     inst_phy    phy_csr_tx_pcfifo_full     [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]
   set_export_interface   phy_csr_tx_pcfifo_empty     conduit   start     inst_phy    phy_csr_tx_pcfifo_empty    [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]
   set_export_interface   ${tx_}csr_lane_polarity     conduit   end       inst_phy    ${tx_}csr_lane_polarity    [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]
   set_export_interface   ${tx_}csr_bit_reversal      conduit   end       inst_phy    ${tx_}csr_bit_reversal     [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]
   set_export_interface   ${tx_}csr_byte_reversal     conduit   end       inst_phy    ${tx_}csr_byte_reversal    [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]
   set_export_interface   jesd204_tx_pcs_data         conduit   end       inst_phy    jesd204_tx_pcs_data        [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]
   set_export_interface   jesd204_tx_pcs_kchar_data   conduit   end       inst_phy    jesd204_tx_pcs_kchar_data  [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]
   set_export_interface   phy_tx_elecidle             conduit   end       inst_phy    phy_tx_elecidle            [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]
   set_export_interface   ${tx_}csr_lane_powerdown    conduit   end       inst_phy    ${tx_}csr_lane_powerdown      [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]

   set_connections        inst_${tx_}rst_n_bridge.out_reset     inst_phy.txlink_rst_n   [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]
   set_connections        inst_${tx_}clk_bridge.out_clk         inst_phy.txlink_clk     [expr {[param_matches wrapper_opt "phy"] && [set_tx_interfaces_on]}]

   # -------------- Base Only------------------#
   # set connections & interfaces for base 
   set_export_interface   jesd204_tx_pcs_data        conduit   start  inst_tx  jesd204_tx_pcs_data        [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]
   set_export_interface   jesd204_tx_pcs_kchar_data  conduit   start  inst_tx  jesd204_tx_pcs_kchar_data  [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]          
   set_export_interface   pll_locked                 conduit   end    inst_tx  phy_csr_pll_locked         [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}] 
   set_export_interface   tx_cal_busy                conduit   end    inst_tx  phy_csr_tx_cal_busy        [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]
   set_export_interface   phy_csr_tx_pcfifo_full     conduit   end    inst_tx  phy_csr_tx_pcfifo_full     [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]
   set_export_interface   phy_csr_tx_pcfifo_empty    conduit   end    inst_tx  phy_csr_tx_pcfifo_empty    [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]
   set_export_interface   csr_lane_polarity          conduit   start  inst_tx  csr_lane_polarity          [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]
   set_export_interface   csr_bit_reversal           conduit   start  inst_tx  csr_bit_reversal           [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]
   set_export_interface   csr_byte_reversal          conduit   start  inst_tx  csr_byte_reversal          [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]
   set_export_interface   phy_tx_elecidle            conduit   start  inst_tx  phy_tx_elecidle            [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]

   set_connections        inst_rst_n_bridge.out_reset          inst_tx.txlink_rst_n  [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]
   set_connections        inst_clk_bridge.out_clk              inst_tx.txlink_clk    [expr {[param_matches wrapper_opt "base"] && [set_tx_interfaces_on]}]

   #----------------------------------------------
   #                RX interfaces
   #----------------------------------------------
   # set_export_interface  <interface_name>      <interface_type>  <direction>  <instance_name>  <instance_interface>  <enable_condition>

   # Clocks and Resets
   set_export_interface   ${rx_}pll_ref_clk     clock  sink  inst_phy        ${rx_}pll_ref_clk          [expr {![param_matches wrapper_opt "base"] && \
                                                                                                           [set_rx_interfaces_on] && [device_is_vseries]}]
   set_export_interface   ${rx_}pll_ref_clk     clock  sink  inst_phy        ${rx_}pll_ref_clk          [expr {![param_matches wrapper_opt "base"] && \
                                                                                                           [set_rx_interfaces_on] && ![device_is_vseries]}]
   set_export_interface   rxlink_clk            clock  sink  inst_${rx_}clk_bridge    in_clk            [expr {[set_rx_interfaces_on]}]
   set_export_interface   rxlink_rst_n          reset  sink  inst_${rx_}rst_n_bridge  in_reset          [expr {[set_rx_interfaces_on]}]
   set_connections        inst_${rx_}clk_bridge.out_clk      inst_${rx_}rst_n_bridge.clk                [expr {[set_rx_interfaces_on]}]
  
   # Management Interface (AV-MM) for JESD204B RX
   set_export_interface   jesd204_rx_avs_clk     clock   sink   inst_rx  jesd204_rx_avs_clk     [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_avs_rst_n   reset   sink   inst_rx  jesd204_rx_avs_rst_n    [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_avs         avalon  slave  inst_rx  jesd204_rx_avs            [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
      
   # AV-ST interface Signal (Source) for JESD204B RX
   set_export_interface   jesd204_rx_link        avalon_streaming  source  inst_rx  avst_rx    [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
  
   # Digital near-end loopback
   set_export_interface   jesd204_rx_dlb_data        conduit end inst_rx jesd204_rx_dlb_data        [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_dlb_data_valid  conduit end inst_rx jesd204_rx_dlb_data_valid  [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_dlb_kchar_data  conduit end inst_rx jesd204_rx_dlb_kchar_data  [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_dlb_errdetect   conduit end inst_rx jesd204_rx_dlb_errdetect   [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_dlb_disperr     conduit end inst_rx jesd204_rx_dlb_disperr     [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]

   # Non AV-ST Interface Signal (Source) for RX
   set_export_interface   alldev_lane_aligned        conduit  end    inst_rx  alldev_lane_aligned     [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}sysref               conduit  end    inst_rx  sysref                  [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_frame_error     conduit  end    inst_rx  jesd204_rx_frame_error  [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_int             interrupt   sender   inst_rx   jesd204_rx_int    [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   csr_rx_testmode            conduit  start  inst_rx  csr_rx_testmode         [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   dev_lane_aligned           conduit  start  inst_rx  dev_lane_aligned        [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}dev_sync_n           conduit  start  inst_rx  dev_sync_n              [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}sof                  conduit  start  inst_rx  sof                     [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}somf                 conduit  start  inst_rx  somf                    [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_f                conduit  start  inst_rx  csr_f                   [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_k                conduit  start  inst_rx  csr_k                   [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_l                conduit  start  inst_rx  csr_l                   [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_m                conduit  start  inst_rx  csr_m                   [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_n                conduit  start  inst_rx  csr_n                   [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_s                conduit  start  inst_rx  csr_s                   [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_cf               conduit  start  inst_rx  csr_cf                  [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_cs               conduit  start  inst_rx  csr_cs                  [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_hd               conduit  start  inst_rx  csr_hd                  [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_np               conduit  start  inst_rx  csr_np                  [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_lane_powerdown   conduit  start  inst_rx  csr_lane_powerdown      [expr {![param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]

   #Interfaces and connections for PHY
   set_export_interface   rxphy_clk                  conduit  start  inst_phy   rxphy_clk                  [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   rx_serial_data             conduit  end    inst_phy   rx_serial_data             [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   rx_analogreset             conduit  end    inst_phy   rx_analogreset             [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on] && \
                                                                                                                  ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_export_interface   rx_digitalreset            conduit  end    inst_phy   rx_digitalreset            [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on] && \
                                                                                                                  ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_export_interface   rx_analogreset_stat        conduit  start  inst_phy   rx_analogreset_stat        [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on] && \
                                                                                                                  ![param_is_true "TEST_COMPONENTS_EN"] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
   set_export_interface   rx_digitalreset_stat       conduit  start  inst_phy   rx_digitalreset_stat       [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on] && \
                                                                                                                  ![param_is_true "TEST_COMPONENTS_EN"] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
   set_export_interface   reconfig_to_xcvr           conduit  end    inst_phy   reconfig_to_xcvr           [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on] && \
                                                                                                               [device_is_vseries] && ![param_is_true "TERMINATE_RECONFIG_EN"]}]
   set_export_interface   reconfig_from_xcvr         conduit  start  inst_phy   reconfig_from_xcvr         [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on] && \
                                                                                                              [device_is_vseries] && ![param_is_true "TERMINATE_RECONFIG_EN"]}]
   set_export_interface   rx_islockedtodata          conduit  start  inst_phy   phy_csr_rx_locked_to_data  [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on] && \
                                                                                                                  ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_export_interface   rx_cal_busy                conduit  start  inst_phy   phy_csr_rx_cal_busy        [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on] && \
                                                                                                                  ![param_is_true "TEST_COMPONENTS_EN"]}]

   # Serial loopback port within transceiver (Valid for Duplex mode only)
   set_export_interface   rx_seriallpbken            conduit  end    inst_phy   rx_seriallpbken            [expr {![param_matches wrapper_opt "base"] && [set_rx_interfaces_on] && \
                                                              [set_tx_interfaces_on] }]

   # -------------- Base_Phy------------------#
   # set connections & interfaces for base_phy 

   set_connections   inst_${rx_}rst_n_bridge.out_reset      inst_rx.rxlink_rst_n    [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_${rx_}rst_n_bridge.out_reset_1    inst_phy.rxlink_rst_n   [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_${rx_}clk_bridge.out_clk          inst_rx.rxlink_clk      [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_${rx_}clk_bridge.out_clk_1        inst_phy.rxlink_clk     [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]

   set_connections   inst_phy.jesd204_rx_pcs_data           inst_rx.jesd204_rx_pcs_data         [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_phy.jesd204_rx_pcs_data_valid     inst_rx.jesd204_rx_pcs_data_valid   [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_phy.jesd204_rx_pcs_kchar_data     inst_rx.jesd204_rx_pcs_kchar_data   [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_phy.jesd204_rx_pcs_errdetect      inst_rx.jesd204_rx_pcs_errdetect    [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_phy.jesd204_rx_pcs_disperr        inst_rx.jesd204_rx_pcs_disperr      [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]

   set_connections   inst_rx.csr_lane_polarity              inst_phy.${rx_}csr_lane_polarity    [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_rx.csr_bit_reversal               inst_phy.${rx_}csr_bit_reversal     [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_rx.csr_byte_reversal              inst_phy.${rx_}csr_byte_reversal    [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_rx.patternalign_en                inst_phy.patternalign_en            [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]

   set_connections   inst_phy.phy_csr_rx_locked_to_data     inst_rx.phy_csr_rx_locked_to_data   [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on] && \
                                                                                                       ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_connections   inst_phy.phy_csr_rx_cal_busy           inst_rx.phy_csr_rx_cal_busy         [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on] && \
                                                                                                       ![param_is_true "TEST_COMPONENTS_EN"]}]
   set_connections   inst_phy.phy_csr_rx_pcfifo_full        inst_rx.phy_csr_rx_pcfifo_full      [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_phy.phy_csr_rx_pcfifo_empty       inst_rx.phy_csr_rx_pcfifo_empty     [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]
   set_connections   inst_rx.csr_lane_powerdown             inst_phy.${rx_}csr_lane_powerdown      [expr {[param_matches wrapper_opt "base_phy"] && [set_rx_interfaces_on]}]

   # -------------- Phy Only------------------#
   # set connections & interfaces for phy 

   set_export_interface   ${rx_}csr_lane_polarity      conduit   end       inst_phy    ${rx_}csr_lane_polarity    [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_bit_reversal       conduit   end       inst_phy    ${rx_}csr_bit_reversal     [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_byte_reversal      conduit   end       inst_phy    ${rx_}csr_byte_reversal    [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   patternalign_en              conduit   end       inst_phy    patternalign_en            [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_pcs_data          conduit   start     inst_phy    jesd204_rx_pcs_data        [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_pcs_data_valid    conduit   start     inst_phy    jesd204_rx_pcs_data_valid  [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_pcs_kchar_data    conduit   start     inst_phy    jesd204_rx_pcs_kchar_data  [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_pcs_errdetect     conduit   start     inst_phy    jesd204_rx_pcs_errdetect   [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_pcs_disperr       conduit   start     inst_phy    jesd204_rx_pcs_disperr     [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   phy_csr_rx_pcfifo_full       conduit   start     inst_phy    phy_csr_rx_pcfifo_full     [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   phy_csr_rx_pcfifo_empty      conduit   start     inst_phy    phy_csr_rx_pcfifo_empty    [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   set_export_interface   ${rx_}csr_lane_powerdown     conduit   end       inst_phy    ${rx_}csr_lane_powerdown      [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on]}]
   
   set_connections       inst_${rx_}rst_n_bridge.out_reset              inst_phy.rxlink_rst_n   [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on] }]
   set_connections       inst_${rx_}clk_bridge.out_clk                  inst_phy.rxlink_clk     [expr {[param_matches wrapper_opt "phy"] && [set_rx_interfaces_on] }]

   # -------------- Base Only------------------#
   # set connections & interfaces for base 

   set_export_interface   jesd204_rx_pcs_data          conduit  end    inst_rx  jesd204_rx_pcs_data         [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}] 
   set_export_interface   jesd204_rx_pcs_data_valid    conduit  end    inst_rx  jesd204_rx_pcs_data_valid   [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_pcs_kchar_data    conduit  end    inst_rx  jesd204_rx_pcs_kchar_data   [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_pcs_errdetect     conduit  end    inst_rx  jesd204_rx_pcs_errdetect    [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   jesd204_rx_pcs_disperr       conduit  end    inst_rx  jesd204_rx_pcs_disperr      [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   csr_lane_polarity            conduit  start  inst_rx  csr_lane_polarity           [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   csr_bit_reversal             conduit  start  inst_rx  csr_bit_reversal            [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   csr_byte_reversal            conduit  start  inst_rx  csr_byte_reversal           [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   patternalign_en              conduit  start  inst_rx  patternalign_en             [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   rx_islockedtodata            conduit  end    inst_rx  phy_csr_rx_locked_to_data   [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   rx_cal_busy                  conduit  end    inst_rx  phy_csr_rx_cal_busy         [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   phy_csr_rx_pcfifo_full       conduit  end    inst_rx  phy_csr_rx_pcfifo_full      [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_export_interface   phy_csr_rx_pcfifo_empty      conduit  end    inst_rx  phy_csr_rx_pcfifo_empty     [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}] 
   
   set_connections        inst_clk_bridge.out_clk        inst_rx.rxlink_clk      [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]
   set_connections        inst_rst_n_bridge.out_reset    inst_rx.rxlink_rst_n    [expr {[param_matches wrapper_opt "base"] && [set_rx_interfaces_on]}]

}
proc my_jesd_test_add_instance {g_xs_PLL} {
   set d_L [get_parameter_value "L"]
   add_instance                  inst_xcvr_rst_ctrl_clk_bridge      altera_clock_bridge        18.1
   set_instance_parameter_value  inst_xcvr_rst_ctrl_clk_bridge      NUM_CLOCK_OUTPUTS  1

   add_instance                  inst_xcvr_rst_ctrl_rst_bridge      altera_reset_bridge        18.1
   set_instance_parameter_value  inst_xcvr_rst_ctrl_rst_bridge      ACTIVE_LOW_RESET   0
   set_instance_parameter_value  inst_xcvr_rst_ctrl_rst_bridge      NUM_RESET_OUTPUTS  1
   
   # Add Transceiver Reset Controller
   add_instance                  inst_xcvr_rst_ctrl  [get_xcvr_rst_controller_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
   set_instance_parameter_value  inst_xcvr_rst_ctrl  CHANNELS $d_L
   set_instance_parameter_value  inst_xcvr_rst_ctrl  PLLS [expr { [device_is_vseries] ? 1: $g_xs_PLL}]
   set_instance_parameter_value  inst_xcvr_rst_ctrl  SYS_CLK_IN_MHZ 100
   if {[param_matches DEVICE_FAMILY "Arria 10"]} {
      set_instance_parameter_value  inst_xcvr_rst_ctrl  SYNCHRONIZE_RESET 1
   }
   set_instance_parameter_value  inst_xcvr_rst_ctrl  REDUCED_SIM_TIME 1
   set_instance_parameter_value  inst_xcvr_rst_ctrl  TX_PLL_ENABLE [set_tx_interfaces_on]
   set_instance_parameter_value  inst_xcvr_rst_ctrl  T_PLL_POWERDOWN 1000
   if {[param_matches DEVICE_FAMILY "Arria 10"]} {
      set_instance_parameter_value  inst_xcvr_rst_ctrl  SYNCHRONIZE_PLL_RESET 0
   }
   set_instance_parameter_value  inst_xcvr_rst_ctrl  TX_ENABLE [set_tx_interfaces_on]
   set_instance_parameter_value  inst_xcvr_rst_ctrl  TX_PER_CHANNEL 0

   set_instance_parameter_value  inst_xcvr_rst_ctrl  T_TX_ANALOGRESET [expr { [param_matches DEVICE_FAMILY "Arria 10"] ? 70000 : 0}]
   set_instance_parameter_value  inst_xcvr_rst_ctrl  T_TX_DIGITALRESET [expr { [param_matches DEVICE_FAMILY "Arria 10"] ? 70000: 20}]
   set_instance_parameter_value  inst_xcvr_rst_ctrl  T_PLL_LOCK_HYST 0
   set_instance_parameter_value  inst_xcvr_rst_ctrl  RX_ENABLE [set_rx_interfaces_on]
   set_instance_parameter_value  inst_xcvr_rst_ctrl  RX_PER_CHANNEL 0
   set_instance_parameter_value  inst_xcvr_rst_ctrl  T_RX_ANALOGRESET [expr { [param_matches DEVICE_FAMILY "Arria 10"] ? 70000 : 40}]
   set_instance_parameter_value  inst_xcvr_rst_ctrl  T_RX_DIGITALRESET 4000


   if {[param_matches DATA_PATH "TX" ] || [param_matches DATA_PATH "RX_TX" ] } {
      add_instance                  tx_cal_busy_fanout     altera_jesd204_fanout  18.1
      set_instance_parameter_value  tx_cal_busy_fanout     NUM_FANOUT 2
      set_instance_parameter_value  tx_cal_busy_fanout     WIDTH $d_L
      set_instance_parameter_value  tx_cal_busy_fanout     SIGNAL_TYPE tx_cal_busy


#      add_sig_adapter tx_cal_busy_adapter "direct"      conduit $d_L  1 tx_cal_busy $d_L tx_cal_busy  1  
      
      if {[device_is_vseries]} {
      
      add_instance                  pll_locked_fanout      altera_jesd204_fanout  18.1
      set_instance_parameter_value  pll_locked_fanout      NUM_FANOUT 2
      set_instance_parameter_value  pll_locked_fanout      WIDTH  $d_L
      set_instance_parameter_value  pll_locked_fanout      SIGNAL_TYPE pll_locked


      # add_sig_adapter     <inst_name>   <  mode >  <int_type>  <in_width_0>  <in_width_1>  <in_sig_type>  <out_width>  <out_sig_type>  <bit_multiplier>   

      add_sig_adapter pll_locked_adapter  "bus_to_bit"  conduit $d_L  1 pll_locked 1    pll_locked   1

      add_sig_adapter pll_powerdown_adapter [expr {[derive_bonded_mode]=="xN" ? "direct" : "bit_multiple" }]  conduit 1 1 pll_powerdown \
                                            [expr {[derive_bonded_mode]=="xN" ? 1 : $d_L }] pll_powerdown $d_L
      } else {
      
      add_instance       inst_pll_wrapper      altera_jesd204_pll_wrapper  18.1
      propagate_params   inst_pll_wrapper

      add_instance                  pll_locked_fanout            altera_jesd204_fanout  18.1
      set_instance_parameter_value  pll_locked_fanout            NUM_FANOUT 2
      set_instance_parameter_value  pll_locked_fanout            WIDTH $g_xs_PLL
      set_instance_parameter_value  pll_locked_fanout            SIGNAL_TYPE pll_locked

      add_sig_adapter pll_locked_adapter_0  [expr { $g_xs_PLL > 1 ? "concatenate" : "direct"}]  conduit 1 1 export $g_xs_PLL pll_locked 1 
      add_sig_adapter pll_locked_adapter_1  "direct"        conduit  $g_xs_PLL  1  pll_locked   $g_xs_PLL  pll_locked     1 
      add_sig_adapter pll_locked_adapter_2  "bus_to_bit"    conduit  $g_xs_PLL  1  pll_locked   1          pll_locked     1 
      add_sig_adapter pll_locked_adapter_3  "bit_multiple"  conduit  1          1  pll_locked   $d_L       pll_locked     $d_L 

      # Retain pll_powerdown connection for A10.
      if { [expr {[param_matches DEVICE_FAMILY "Arria 10"]} ] } {
         add_sig_adapter pll_powerdown_adapter [expr { $g_xs_PLL > 1 ? "split" : "direct"}]  conduit $g_xs_PLL 1 pll_powerdown 1 pll_powerdown 1
      }
      } 

   }
   if {[param_matches DATA_PATH "RX" ] || [param_matches DATA_PATH "RX_TX" ] } {

      add_instance                  rx_islockedtodata_fanout      altera_jesd204_fanout  18.1
      set_instance_parameter_value  rx_islockedtodata_fanout      NUM_FANOUT 2
      set_instance_parameter_value  rx_islockedtodata_fanout      WIDTH $d_L
      set_instance_parameter_value  rx_islockedtodata_fanout      SIGNAL_TYPE rx_is_lockedtodata

      add_instance                  rx_cal_busy_fanout            altera_jesd204_fanout  18.1
      set_instance_parameter_value  rx_cal_busy_fanout            NUM_FANOUT 2
      set_instance_parameter_value  rx_cal_busy_fanout            WIDTH $d_L
      set_instance_parameter_value  rx_cal_busy_fanout            SIGNAL_TYPE rx_cal_busy


#      add_sig_adapter rx_islockedtodata_adapter "direct"   conduit $d_L 1 rx_is_lockedtodata $d_L rx_is_lockedtodata 1  
#      add_sig_adapter rx_cal_busy_adapter       "direct"   conduit $d_L 1 rx_cal_busy $d_L rx_cal_busy        1  
   }

}
proc my_jesd_test_add_connection {g_xs_PLL} {
   set tx_ [expr {[param_matches DATA_PATH "RX_TX"] ? "tx_": ""}]
   set d_L [get_parameter_value "L"]

   #----------XCVR RST CTRL Interfaces----------
   set_export_interface   xcvr_rst_ctrl_clk          clock  sink    inst_xcvr_rst_ctrl_clk_bridge   in_clk      [expr {[param_is_true "TEST_COMPONENTS_EN"] }] 
   set_export_interface   xcvr_rst_ctrl_rst          reset  sink    inst_xcvr_rst_ctrl_rst_bridge   in_reset    [expr {[param_is_true "TEST_COMPONENTS_EN"] }]
   set_connections        inst_xcvr_rst_ctrl_clk_bridge.out_clk     inst_xcvr_rst_ctrl_rst_bridge.clk           [expr {[param_is_true "TEST_COMPONENTS_EN"] }]
   set_connections        inst_xcvr_rst_ctrl_clk_bridge.out_clk     inst_xcvr_rst_ctrl.clock                    [expr {[param_is_true "TEST_COMPONENTS_EN"] }]
   set_connections        inst_xcvr_rst_ctrl_rst_bridge.out_reset   inst_xcvr_rst_ctrl.reset                    [expr {[param_is_true "TEST_COMPONENTS_EN"] }]

   set_export_interface   xcvr_rst_ctrl_pll_select    conduit  start    inst_xcvr_rst_ctrl  pll_select    [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on] }] 
   set_export_interface   xcvr_rst_ctrl_tx_ready      conduit  start    inst_xcvr_rst_ctrl  tx_ready      [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on] }] 
   set_export_interface   xcvr_rst_ctrl_rx_ready      conduit  start    inst_xcvr_rst_ctrl  rx_ready      [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on] }] 
 
   set_connections   inst_phy.phy_csr_pll_locked            pll_locked_fanout.sig_input             [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]} && [device_is_vseries]]
   set_connections   pll_locked_fanout.sig_fanout0          inst_tx.phy_csr_pll_locked              [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]} && [device_is_vseries]]
   set_connections   pll_locked_fanout.sig_fanout1          pll_locked_adapter.sig_in_0             [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]} && [device_is_vseries]]
   set_connections   pll_locked_adapter.sig_out             inst_xcvr_rst_ctrl.pll_locked           [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]} && [device_is_vseries]] 

   set_connections   inst_phy.phy_csr_tx_cal_busy           tx_cal_busy_fanout.sig_input            [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]}]
   set_connections   tx_cal_busy_fanout.sig_fanout0         inst_tx.phy_csr_tx_cal_busy             [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]}]
#   set_connections   tx_cal_busy_fanout.sig_fanout1         tx_cal_busy_adapter.sig_in_0            [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]}]
#   set_connections   tx_cal_busy_adapter.sig_out            inst_xcvr_rst_ctrl.tx_cal_busy          [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]}]
   set_connections   tx_cal_busy_fanout.sig_fanout1         inst_xcvr_rst_ctrl.tx_cal_busy          [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]}]


   set_connections   inst_xcvr_rst_ctrl.pll_powerdown       pll_powerdown_adapter.sig_in_0          [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on] && [device_is_vseries]}]
   set_connections   pll_powerdown_adapter.sig_out          inst_phy.pll_powerdown                  [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on] && [device_is_vseries]}]
   set_connections   inst_xcvr_rst_ctrl.tx_analogreset      inst_phy.tx_analogreset                 [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]}]
   set_connections   inst_xcvr_rst_ctrl.tx_digitalreset     inst_phy.tx_digitalreset                [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on]}]
   set_connections   inst_xcvr_rst_ctrl.rx_analogreset      inst_phy.rx_analogreset                 [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
   set_connections   inst_xcvr_rst_ctrl.rx_digitalreset     inst_phy.rx_digitalreset                [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
   set_connections   inst_phy.tx_analogreset_stat           inst_xcvr_rst_ctrl.tx_analogreset_stat  [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
   set_connections   inst_phy.tx_digitalreset_stat          inst_xcvr_rst_ctrl.tx_digitalreset_stat [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
   set_connections   inst_phy.rx_analogreset_stat           inst_xcvr_rst_ctrl.rx_analogreset_stat  [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
   set_connections   inst_phy.rx_digitalreset_stat          inst_xcvr_rst_ctrl.rx_digitalreset_stat [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]

   set_connections   inst_phy.phy_csr_rx_locked_to_data     rx_islockedtodata_fanout.sig_input      [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
   set_connections   rx_islockedtodata_fanout.sig_fanout0   inst_rx.phy_csr_rx_locked_to_data       [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
#   set_connections   rx_islockedtodata_fanout.sig_fanout1   rx_islockedtodata_adapter.sig_in_0      [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
#   set_connections   rx_islockedtodata_adapter.sig_out      inst_xcvr_rst_ctrl.rx_is_lockedtodata   [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
   set_connections   rx_islockedtodata_fanout.sig_fanout1    inst_xcvr_rst_ctrl.rx_is_lockedtodata  [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]


   set_connections   inst_phy.phy_csr_rx_cal_busy           rx_cal_busy_fanout.sig_input            [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
   set_connections   rx_cal_busy_fanout.sig_fanout0         inst_rx.phy_csr_rx_cal_busy             [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
#   set_connections   rx_cal_busy_fanout.sig_fanout1         rx_cal_busy_adapter.sig_in_0            [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
#   set_connections   rx_cal_busy_adapter.sig_out            inst_xcvr_rst_ctrl.rx_cal_busy          [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]
   set_connections   rx_cal_busy_fanout.sig_fanout1         inst_xcvr_rst_ctrl.rx_cal_busy          [expr {[param_is_true "TEST_COMPONENTS_EN"] && [set_rx_interfaces_on]}]



   #--------------ATX PLL A10 Interfaces--------------
   set_export_interface   ${tx_}pll_ref_clk     clock      sink     inst_pll_wrapper  pll_refclk      [expr {[set_tx_interfaces_on] && ![device_is_vseries]}] 
   #TODO: For Vseries, this port is OR with tx_cal_busy/rx_cal_busy. However, leave this port dangling for now as it won't affect any test.   
#   set_export_interface   pll_cal_busy       conduit    start    inst_pll_wrapper  pll_cal_busy    [expr {[set_tx_interfaces_on] && ![device_is_vseries]}]        
   if {$d_L == 1} {
      set_connections   inst_pll_wrapper.tx_bonding_clocks   inst_phy.tx_bonding_clocks       [expr {[set_tx_interfaces_on] && ![device_is_vseries] && ![param_matches bonded_mode "non_bonded"]}]
      set_connections   inst_pll_wrapper.tx_serial_clk0      inst_phy.tx_serial_clk0          [expr {[set_tx_interfaces_on] && ![device_is_vseries] && [param_matches bonded_mode "non_bonded"]}]
   } else {      
      for {set i 0} {$i < $d_L} {incr i} {
      set_connections   inst_pll_wrapper.tx_bonding_clocks_ch${i}   inst_phy.tx_bonding_clocks_ch${i}   [expr {[set_tx_interfaces_on] && ![device_is_vseries] && \
                                                                                                     ![param_matches bonded_mode "non_bonded"]}]
      set_connections   inst_pll_wrapper.tx_serial_clk0_ch${i}      inst_phy.tx_serial_clk0_ch${i}      [expr {[set_tx_interfaces_on] && ![device_is_vseries] && \
                                                                                                     [param_matches bonded_mode "non_bonded"]}]
      }
   }

   # Retain pll_powerdown connection for A10.
   set_connections   inst_xcvr_rst_ctrl.pll_powerdown     pll_powerdown_adapter.sig_in_0      [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]
   set_connections   pll_powerdown_adapter.sig_out        inst_pll_wrapper.pll_powerdown_0    [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]
   set_connections   pll_powerdown_adapter.sig_out_1      inst_pll_wrapper.pll_powerdown_1    [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"] && $g_xs_PLL > 1}]

   set_connections   inst_pll_wrapper.pll_locked_0        pll_locked_adapter_0.sig_in_0       [expr {[set_tx_interfaces_on] && ![device_is_vseries]}]
   set_connections   inst_pll_wrapper.pll_locked_1        pll_locked_adapter_0.sig_in_1       [expr {[set_tx_interfaces_on] && ![device_is_vseries] && $g_xs_PLL > 1 }]
   set_connections   pll_locked_adapter_0.sig_out         pll_locked_fanout.sig_input         [expr {[set_tx_interfaces_on] && ![device_is_vseries]}]

   set_connections   pll_locked_fanout.sig_fanout0        pll_locked_adapter_1.sig_in_0       [expr {[set_tx_interfaces_on] && ![device_is_vseries]}]
   set_connections   pll_locked_adapter_1.sig_out         inst_xcvr_rst_ctrl.pll_locked       [expr {[set_tx_interfaces_on] && ![device_is_vseries]}]
 
   set_connections   pll_locked_fanout.sig_fanout1        pll_locked_adapter_2.sig_in_0       [expr {[set_tx_interfaces_on] && ![device_is_vseries]}]
   set_connections   pll_locked_adapter_2.sig_out         pll_locked_adapter_3.sig_in_0       [expr {[set_tx_interfaces_on] && ![device_is_vseries]}]
   set_connections   pll_locked_adapter_3.sig_out         inst_tx.phy_csr_pll_locked          [expr {[set_tx_interfaces_on] && ![device_is_vseries]}]
  
}
#Terminate reconfig signal for v series device family
proc my_jesd_reconfig_adapter {} {
   add_sig_adapter reconfig_adapter "terminate"  conduit 1 1 export [derive_reconfig_to_width] reconfig_to_xcvr 1
   set_connections  reconfig_adapter.sig_out     inst_phy.reconfig_to_xcvr     [expr {[device_is_vseries]}]
}
##############################################################

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/bhc1411117158599/bhc1411116797881
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697842482
