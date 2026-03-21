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


package require -exact qsys 13.1
package require ::altera::generic_pll
package require ::altera::pllc

# package ifneeded ::altera::pllc 1.0 {

    # switch $tcl_platform(platform) {
        # windows {
            # load [file join $::quartus(binpath) qcl_pllc_tcl.dll] pllc
        # }
        # unix {
            # load [file join $::quartus(binpath) libqcl_pllc_tcl[info sharedlibextension]] pllc
        # }
    # }
# }

set alt_mem_if_tcl_libs_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/alt_mem_if/alt_mem_if_tcl_packages"
if {[lsearch -exact $auto_path $alt_mem_if_tcl_libs_dir] == -1} {
    lappend auto_path $alt_mem_if_tcl_libs_dir
}
set alt_xcvr_packages_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages"
if { [lsearch -exact $auto_path $alt_xcvr_packages_dir] == -1 } {
  lappend auto_path $alt_xcvr_packages_dir
}

source ../../altera/sopc_builder_ip/altera_avalon_mega_common/ipcc_wrap_split.tcl

package require alt_xcvr::utils::common
namespace import ::alt_xcvr::utils::common::map_allowed_range
namespace import ::alt_xcvr::utils::common::get_mapped_allowed_range_value

source  clearbox.tcl

set_module_property ELABORATION_CALLBACK    elab
#set_module_property VALIDATION_CALLBACK     pllc_computation
set_module_property VALIDATION_CALLBACK     validate


#-----Validation callback
proc validate {} {

    set functional_mode [get_parameter_value FUNCTIONAL_MODE]
    set data_rate [get_parameter_value INPUT_DATA_RATE]
    set num_of_channels [get_parameter_value NUMBER_OF_CHANNELS]
    set data_width [get_parameter_value deserialization_factor]
	#FB 334191
	set dev_type [get_parameter_value DEVICE_TYPE]
 
    # Set parameters unconditionnally
    set_parameter_value DATA_RATE "$data_rate Mbps"
	set deser_factor [get_parameter_value DESERIALIZATION_FACTOR]
	##----- Checking for FMAX datarate and issue warning if exceeded 
		
	if {$dev_type == "Single Supply"} {#FB 334191
		if {$data_rate > 310.0} {
			 send_message warning "The data rate $data_rate Mbps specified might exceeds limit.Please refer to the datasheet for reference"
		 }
	} elseif {$dev_type == "Dual Supply"}  {
		if {$deser_factor == 1 && $data_rate > 360.0} {
			send_message warning "The data rate $data_rate Mbps specified might exceeds limit.Please refer to the datasheet for reference"
		} elseif { $deser_factor == 2 || $deser_factor == 4  || $deser_factor == 7 || $deser_factor == 8 || $deser_factor == 10 } {
			 if { $data_rate > 720.0 } { #FB322529,285260
			  send_message warning "The data rate $data_rate Mbps specified might exceeds limit.Please refer to the datasheet for reference"
			 }
		} elseif {$deser_factor == 5 || $deser_factor == 6} {
			if { $data_rate > 640.0 } {
			  send_message warning "The data rate $data_rate Mbps specified might exceeds limit.Please refer to the datasheet for reference"
			 }
		}
	}
	
    ##----- FUNCTIONAL_MODE
    if {$functional_mode == "TX"} {
        ##-------TX
        set_parameter_property FUNCTIONAL_MODE_UI_BOOL ENABLED true
        # --------
        # Set TX data rate = INPUT_DATA_RATE (for internal use only)
        # --------
        set_parameter_value OUTPUT_DATA_RATE $data_rate
        set tx "true"
    } else { 
        ##-------RX
        set_parameter_property FUNCTIONAL_MODE_UI_BOOL ENABLED false
        set tx "false"
    }


    ##------DESERIALIZATION FACTOR 
    if {$data_width == 1 || $data_width == 2} {
        set_parameter_property USE_EXTERNAL_PLL_UI ENABLED false
        set x1_x2_mode "true"
    } else {
        set_parameter_property USE_EXTERNAL_PLL_UI ENABLED true
        set x1_x2_mode "false"
    }


    ###----- USE_EXTERNAL_PLL and PLL settings
    set external_pll [get_parameter_value USE_EXTERNAL_PLL_UI]
    if {$x1_x2_mode == "false"} {
        if {$external_pll == "true"} {
            set_parameter_value USE_EXTERNAL_PLL "ON"

            # Disable internal PLL settings
            set_parameter_property INPUT_DATA_RATE ENABLED false
            #set_parameter_property INCLOCK_PERIOD_UI ENABLED false
            set_parameter_property COMMON_RX_TX_PLL_UI ENABLED false
            set_parameter_property PLL_SELF_RESET_ON_LOSS_LOCK_UI ENABLED false
            set_parameter_property VALID_FREQ ENABLED false
            set_parameter_property TX_INCLOCK_PHASE_SHIFT_UI ENABLED false
            set_parameter_property RX_INCLOCK_PHASE_SHIFT_UI ENABLED false
            set_parameter_property ENABLE_PLL_ARESET_PORT_UI ENABLED false
            set_parameter_property ENABLE_TX_LOCKED_PORT_UI ENABLED false
            set_parameter_property ENABLE_RX_LOCKED_PORT_UI ENABLED false
        
            if {$tx == "true"} {
                set_parameter_property ENABLE_PLL_TX_DATA_RESET_PORT_UI ENABLED true
                set_parameter_property ENABLE_PLL_RX_DATA_RESET_PORT_UI ENABLED false
                send_message info "Using the external PLL mode requires that:"
                send_message info "(i) The fast clock (running at data rate /2) from the PLL feeds tx_inclock"
                send_message info "(ii) The slow clock (data rate / deserialization_factor) from the PLL feeds tx_syncclock"
                send_message info "(iii) The inputs be pre-registered in the logic feeding the transmitter by the slow clock"
            } else {
                set_parameter_property ENABLE_PLL_RX_DATA_RESET_PORT_UI ENABLED true
                set_parameter_property ENABLE_PLL_TX_DATA_RESET_PORT_UI ENABLED false
                send_message info "Using the external PLL mode requires that:"
                send_message info "(i) The fast clock (running at data rate /2) from the PLL feeds rx_inclock"
                send_message info "(ii) The outputs be registered in the logic fed by the receiver"
                send_message info "The receiver starts capturing the LVDS stream at the fast clock edge"
            }

        } else {
            set_parameter_value USE_EXTERNAL_PLL "OFF"

            # Disable external PLL settings
            set_parameter_property ENABLE_PLL_TX_DATA_RESET_PORT_UI ENABLED false
            set_parameter_property ENABLE_PLL_RX_DATA_RESET_PORT_UI ENABLED false

            # Enable internal PLL settings
            set_parameter_property INPUT_DATA_RATE ENABLED true
            set_parameter_property VALID_FREQ ENABLED true
                # INCLOCK_PERIOD_UI is for internal usage only
           # set_parameter_property INCLOCK_PERIOD_UI ENABLED true 
            set_parameter_property ENABLE_PLL_ARESET_PORT_UI ENABLED true
            set_parameter_property PLL_SELF_RESET_ON_LOSS_LOCK_UI ENABLED true
            set_parameter_property COMMON_RX_TX_PLL_UI ENABLED true

            if {$tx == "true"} {
                set_parameter_property TX_INCLOCK_PHASE_SHIFT_UI ENABLED true
                set_parameter_property RX_INCLOCK_PHASE_SHIFT_UI ENABLED false
                set_parameter_property ENABLE_TX_LOCKED_PORT_UI ENABLED true
                set_parameter_property ENABLE_RX_LOCKED_PORT_UI ENABLED false
            } else {
                set_parameter_property RX_INCLOCK_PHASE_SHIFT_UI ENABLED true
                set_parameter_property TX_INCLOCK_PHASE_SHIFT_UI ENABLED false
                set_parameter_property ENABLE_TX_LOCKED_PORT_UI ENABLED false
                set_parameter_property ENABLE_RX_LOCKED_PORT_UI ENABLED true
            }
        } 
    } else {
        # X1 or X2 mode
        set_parameter_property ENABLE_PLL_TX_DATA_RESET_PORT_UI ENABLED false
        set_parameter_property ENABLE_PLL_RX_DATA_RESET_PORT_UI ENABLED false

        set_parameter_property INPUT_DATA_RATE ENABLED false
        #set_parameter_property INCLOCK_PERIOD_UI ENABLED false
        set_parameter_property COMMON_RX_TX_PLL_UI ENABLED false
        set_parameter_property PLL_SELF_RESET_ON_LOSS_LOCK_UI ENABLED false
        set_parameter_property VALID_FREQ ENABLED false
        set_parameter_property TX_INCLOCK_PHASE_SHIFT_UI ENABLED false
        set_parameter_property RX_INCLOCK_PHASE_SHIFT_UI ENABLED false
        set_parameter_property ENABLE_PLL_ARESET_PORT_UI ENABLED false
        set_parameter_property ENABLE_TX_LOCKED_PORT_UI ENABLED false
        set_parameter_property ENABLE_RX_LOCKED_PORT_UI ENABLED false
    }


    ###----- INCLOCK_PERIOD
    set refclk_freq [get_parameter_value VALID_FREQ]
    set inclock_period_1 [expr {(1/$refclk_freq)}]
    set inclock_period  [expr {round($inclock_period_1*1000000)}]
    if {$external_pll == "false" && $x1_x2_mode == "false"} {
        
        set_parameter_value INCLOCK_PERIOD $inclock_period
        
        # Check INPUT_DATA_RATE. For RX only.
        if {$functional_mode == "RX"} {
            set data_rate [get_parameter_value INPUT_DATA_RATE]
            set violation [expr {$data_rate} *{$inclock_period_1}]

            if {$violation > 30} {
                send_message error "Illegal values for INPUT_DATA_RATE parameter $data_rate and INCLOCK_PERIOD parameter $inclock_period. INPUT_DATA_RATE (in Mbps) * INCLOCK_PERIOD (in microseconds) must be an integer (1 to 30)"
            }
        }
    }
    
    ##----- COMMON_RX_TX_PLL
    set common_rx_tx_pll [get_parameter_value COMMON_RX_TX_PLL_UI]
    if {$common_rx_tx_pll == "true" && $external_pll == "false" && $x1_x2_mode == "false"} {
        set_parameter_value COMMON_RX_TX_PLL "ON"
    } else {
        set_parameter_value COMMON_RX_TX_PLL "OFF"
    }

    ##-----PLL_SELF_RESET_ON_LOSS_LOCK
    set pll_self_reset_on_loss_lock [get_parameter_value PLL_SELF_RESET_ON_LOSS_LOCK_UI]
    if {$pll_self_reset_on_loss_lock == "true" && $external_pll == "false" && $x1_x2_mode == "false"} {
        set_parameter_value PLL_SELF_RESET_ON_LOSS_LOCK "ON"
    } else {
        set_parameter_value PLL_SELF_RESET_ON_LOSS_LOCK "OFF"
    }

    ##-----TX/RX_INCLOCK_PHASE_SHIFT_UI
    if {$external_pll == "false" && $x1_x2_mode == "false"} {
        if {$tx == "true"} {
            set inclock_phase_shift_ui [get_parameter_value TX_INCLOCK_PHASE_SHIFT_UI]
        } else {
            set inclock_phase_shift_ui [get_parameter_value RX_INCLOCK_PHASE_SHIFT_UI]
        }
        set inclock_phase_shift [expr {round($inclock_phase_shift_ui/360*$inclock_period_1*1000000)}]
	
        set_parameter_value INCLOCK_PHASE_SHIFT $inclock_phase_shift
    #debug
	    puts "phase shift = $inclock_phase_shift" 
	}


    ###-----TX ONLY: REGISTERED_INPUT_ENABLED_UI, REGISTERED_INPUT_UI
    if {$tx == "true" && $external_pll == "false" && $x1_x2_mode == "false"} {
        set_parameter_property REGISTERED_INPUT_ENABLED_UI ENABLED true
        set registered_input_enabled [get_parameter_value REGISTERED_INPUT_ENABLED_UI]
    } else {
        set_parameter_property REGISTERED_INPUT_ENABLED_UI ENABLED false
        set registered_input_enabled "false"
    }
    
    set coreclock_value [expr {$data_rate / $data_width}]
    if {$registered_input_enabled == "true" && $external_pll == "false"} {
        set_parameter_property REGISTERED_INPUT_UI ENABLED true
        set registered_input_clock_resource [get_parameter_value REGISTERED_INPUT_UI]
        if {$registered_input_clock_resource == "tx_inclock"} {
            set_parameter_value REGISTERED_INPUT "TX_CLKIN"
            if {$coreclock_value != $refclk_freq} {
                send_message warning "Input port 'tx_inclock' may not be used to register the synchronization registers when the input clock frequency is not equal to the coreclock frequency."
                send_message warning "Do you want to use 'tx_coreclock' to clock the synchronization registers?"
            }
        } elseif {$registered_input_clock_resource == "tx_coreclock"} {
            set_parameter_value REGISTERED_INPUT "TX_CORECLK"
        } else {
            set_parameter_value REGISTERED_INPUT "OFF"
        }
    } else {
        set_parameter_property REGISTERED_INPUT_UI ENABLED false
        set_parameter_value REGISTERED_INPUT "OFF"
    }
  

    ###-----TX_OUTCLOCK_PORT
    if {$tx == "true" && $external_pll == "false" && $x1_x2_mode == "false"} {
        set_parameter_property ENABLE_TX_OUTCLOCK_PORT_UI ENABLED true
        set enable_tx_outclock_port [get_parameter_value ENABLE_TX_OUTCLOCK_PORT_UI]
    } else {
        set_parameter_property ENABLE_TX_OUTCLOCK_PORT_UI ENABLED false
        set enable_tx_outclock_port "false"
    }

    #------TX_OUTCLOCK_PHASE_SHIFT
    if {$enable_tx_outclock_port == "true"} {
        set_parameter_property TX_OUTCLOCK_PHASE_SHIFT_UI ENABLED true
        set tx_outclock_phase_shift_ui [get_parameter_value TX_OUTCLOCK_PHASE_SHIFT_UI]
        #set outclock_phase_shift [expr {round($tx_outclock_phase_shift_ui/360*$inclock_period_1*1000000)}
        set_parameter_value OUTCLOCK_PHASE_SHIFT $tx_outclock_phase_shift_ui
    } else {
        set_parameter_property TX_OUTCLOCK_PHASE_SHIFT_UI ENABLED false
    }

    #------OUTCLOCK_DIVIDE_BY
    if {$data_width==4} {
        map_allowed_range OUTCLOCK_DIVIDE_BY_UI  {"4" "2" "8"}
    } elseif {$data_width==6} {
        map_allowed_range OUTCLOCK_DIVIDE_BY_UI  {"6" "2" "4" "12"}
    } elseif {$data_width==8} {
        map_allowed_range OUTCLOCK_DIVIDE_BY_UI  {"8" "2" "4" "16"}
    } elseif {$data_width==10} {
        map_allowed_range OUTCLOCK_DIVIDE_BY_UI  {"10" "2" "4" "20"}
    } elseif {$data_width==5} {
        map_allowed_range OUTCLOCK_DIVIDE_BY_UI  {"5" "2" "10"}
    } elseif {$data_width==7} {
        map_allowed_range OUTCLOCK_DIVIDE_BY_UI  {"7" "2" "14"}
    } elseif {$data_width==9} {
        map_allowed_range OUTCLOCK_DIVIDE_BY_UI  {"9" "2" "18"}
    } else {
        map_allowed_range OUTCLOCK_DIVIDE_BY_UI  {"1"}
    }

    set outclk_divide_by_ui [get_parameter_value OUTCLOCK_DIVIDE_BY_UI]
    if {$enable_tx_outclock_port == "true"} {
        set_parameter_property OUTCLOCK_DIVIDE_BY_UI ENABLED true
        set_parameter_property OUTCLOCK_DIVIDE_BY ENABLED true
        
        set_parameter_value OUTCLOCK_DIVIDE_BY $outclk_divide_by_ui
    } else {
        set_parameter_property OUTCLOCK_DIVIDE_BY_UI ENABLED false
        set_parameter_property OUTCLOCK_DIVIDE_BY ENABLED false
    }

    #------OUTCLOCK_MULTIPLY_BY ######FB246426,321068
    set division_factor [get_parameter_value OUTCLOCK_DIVIDE_BY_UI]
     if {$data_width == $division_factor} {
		if {$data_width == 5 || $data_width == 6 || $data_width == 7 || $data_width == 9 || $data_width == 10 } {
			set_parameter_value OUTCLOCK_MULTIPLY_BY "2"
		 } else {
			set_parameter_value OUTCLOCK_MULTIPLY_BY "1"
		 }
     } else {
         set_parameter_value OUTCLOCK_MULTIPLY_BY "1"
	 }
	######FB246426

    #----OUTCLOCK_DUTY_CYCLE 
    if {$data_width == 5 && $outclk_divide_by_ui == 5} {
        map_allowed_range OUTCLOCK_DUTY_CYCLE_UI {"60"}
    } elseif {$data_width == 5 && $outclk_divide_by_ui == 10} {
        map_allowed_range OUTCLOCK_DUTY_CYCLE_UI {"50" "60"}
    } elseif {$data_width == 7 && $outclk_divide_by_ui == 7} {
        map_allowed_range OUTCLOCK_DUTY_CYCLE_UI {"57"}
    } elseif {$data_width == 7 && $outclk_divide_by_ui == 14} {
        map_allowed_range OUTCLOCK_DUTY_CYCLE_UI {"50" "57"}
    } elseif {$data_width == 9 && $outclk_divide_by_ui == 9} {
        map_allowed_range OUTCLOCK_DUTY_CYCLE_UI {"56"}
    } elseif {$data_width == 9 && $outclk_divide_by_ui == 18} {
        map_allowed_range OUTCLOCK_DUTY_CYCLE_UI {"50" "56"}
    } else {
        map_allowed_range OUTCLOCK_DUTY_CYCLE_UI {"50"}
    }

    if {$enable_tx_outclock_port == "true"} {
        #set_parameter_property OUTCLOCK_DUTY_CYCLE_UI ENABLED true

        set outclock_duty_cycle_ui [get_parameter_value OUTCLOCK_DUTY_CYCLE_UI]
        set_parameter_value OUTCLOCK_DUTY_CYCLE $outclock_duty_cycle_ui
		# the outclock duty cycle is greyed out for one option
			if {$data_width == 5 && $outclk_divide_by_ui == 5} {
				set_parameter_property OUTCLOCK_DUTY_CYCLE_UI ENABLED false
			} elseif {$data_width == 5 && $outclk_divide_by_ui == 10} {
				set_parameter_property OUTCLOCK_DUTY_CYCLE_UI ENABLED true
			} elseif {$data_width == 7 && $outclk_divide_by_ui == 7} {
				set_parameter_property OUTCLOCK_DUTY_CYCLE_UI ENABLED false
			} elseif {$data_width == 7 && $outclk_divide_by_ui == 14} {
				set_parameter_property OUTCLOCK_DUTY_CYCLE_UI ENABLED true
			} elseif {$data_width == 9 && $outclk_divide_by_ui == 9} {
				set_parameter_property OUTCLOCK_DUTY_CYCLE_UI ENABLED false
			} elseif {$data_width == 9 && $outclk_divide_by_ui == 18} {
				set_parameter_property OUTCLOCK_DUTY_CYCLE_UI ENABLED true
			} else {
				set_parameter_property OUTCLOCK_DUTY_CYCLE_UI ENABLED false
			}
		
	} else {
        set_parameter_property OUTCLOCK_DUTY_CYCLE_UI ENABLED false
        set_parameter_property OUTCLOCK_DUTY_CYCLE ENABLED false
    }
    

    ###----TX_CORECLOCK
    ###----USE_CORECLOCK_INPUT
    if {$data_width == 5 || $data_width == 7 || $data_width == 9} {
        set odd_mode "true"
    } else {
        set odd_mode "false"
    }

    if {$tx == "true" && $external_pll == "false" && $x1_x2_mode == "false"} {
        set_parameter_property ENABLE_TX_CORECLOCK_PORT_UI ENABLED true
        set enable_tx_coreclock_port [get_parameter_value ENABLE_TX_CORECLOCK_PORT_UI]
    } else {
        set_parameter_property ENABLE_TX_CORECLOCK_PORT_UI ENABLED false
        set enable_tx_coreclock_port false
    }

    #----OUTCLOCK_RESOURCE
    if {$enable_tx_coreclock_port == "true" && $odd_mode == "false"} {
        set_parameter_property OUTCLOCK_RESOURCE_UI ENABLED true
        set coreclock_resource_type [get_parameter_value OUTCLOCK_RESOURCE_UI]

        if {$coreclock_resource_type == "Auto selection"} {
            set_parameter_value OUTCLOCK_RESOURCE "AUTO"
        } elseif {$coreclock_resource_type == "Global clock"} {
            set_parameter_value OUTCLOCK_RESOURCE "Global Clock"
        } elseif {$coreclock_resource_type == "Regional clock"} {
            set_parameter_value OUTCLOCK_RESOURCE "Regional Clock"
        } elseif {$coreclock_resource_type == "Dual-Regional clock"} {
            set_parameter_value OUTCLOCK_RESOURCE "Dual-Regional Clock"
        } else {
            set_parameter_value OUTCLOCK_RESOURCE "AUTO"
        }
    } else {
        set_parameter_property OUTCLOCK_RESOURCE_UI ENABLED false
    }


    ###-----REGISTERED_OUTPUT (RX)
    if {$tx == "false" && $external_pll == "false" && $x1_x2_mode == "false"} {
        set_parameter_property REGISTERED_OUTPUT_UI ENABLED true
        set register_output [get_parameter_value REGISTERED_OUTPUT_UI]
        
        if {$register_output == "true"} {
            set_parameter_value REGISTERED_OUTPUT "ON"
        } else {
            set_parameter_value REGISTERED_OUTPUT "OFF"
            # RX x2 mode is of different module
            if {$data_width != 2} {
                send_message warning "Selecting to not register the outputs of the receiver will require that they be registered in the logic fed by the receiver."
            }
        }
    } else {
        set_parameter_property REGISTERED_OUTPUT_UI ENABLED false
        set_parameter_value REGISTERED_OUTPUT "OFF"
    }


    ###----PORT_RX_DATA_ALIGN (ENABLE BITSLIP)
    if {$tx == "false" && $x1_x2_mode == "false"} {
        set_parameter_property PORT_RX_DATA_ALIGN_UI ENABLED true
        set port_rx_data_align [get_parameter_value PORT_RX_DATA_ALIGN_UI]
		
        if {$num_of_channels == 1} {
            set_parameter_property PORT_RX_CHANNEL_DATA_ALIGN_UI ENABLED false
            set port_rx_channel_data_align "false"
        } else {
            if {$port_rx_data_align == "true"} {
                set_parameter_property PORT_RX_CHANNEL_DATA_ALIGN_UI ENABLED true
                set port_rx_channel_data_align [get_parameter_value PORT_RX_CHANNEL_DATA_ALIGN_UI]
            } else {
                set_parameter_property PORT_RX_CHANNEL_DATA_ALIGN_UI ENABLED false
                set port_rx_channel_data_align "false"
            }
        }
    } else {
        set_parameter_property PORT_RX_CHANNEL_DATA_ALIGN_UI ENABLED false
        set_parameter_property PORT_RX_DATA_ALIGN_UI ENABLED false
        set port_rx_data_align "false"    
        set port_rx_channel_data_align "false"
    }

    if {$port_rx_data_align == "true" && $port_rx_channel_data_align == "false"} {
        set_parameter_property DATA_ALIGN_ROLLOVER ENABLED true
        set_parameter_property PORT_RX_DATA_ALIGN_RESET_UI ENABLED true
        set_parameter_property USE_CDA_RESET_UI ENABLED false
        set_parameter_value PORT_RX_DATA_ALIGN "PORT_USED"  
        set_parameter_value PORT_RX_CHANNEL_DATA_ALIGN "PORT_UNUSED"
    } elseif {$port_rx_data_align == "true" && $port_rx_channel_data_align == "true"} {
        set_parameter_property DATA_ALIGN_ROLLOVER ENABLED true
        set_parameter_property PORT_RX_DATA_ALIGN_RESET_UI ENABLED false
        set_parameter_property USE_CDA_RESET_UI ENABLED true
        set_parameter_value PORT_RX_DATA_ALIGN "PORT_UNUSED"
        set_parameter_value PORT_RX_CHANNEL_DATA_ALIGN "PORT_USED"
    } else {
        set_parameter_property PORT_RX_DATA_ALIGN ENABLED "PORT_UNUSED"
        set_parameter_property PORT_RX_CHANNEL_DATA_ALIGN ENABLED "PORT_UNUSED" 
        set_parameter_property PORT_RX_DATA_ALIGN_RESET_UI ENABLED false
        set_parameter_property USE_CDA_RESET_UI ENABLED false
        set_parameter_property DATA_ALIGN_ROLLOVER ENABLED false
    }

    ##----REGISTERED_DATA_ALIGN_INPUT
    if {$port_rx_data_align == "true" && $external_pll == "false"} {
        set_parameter_property REGISTERED_DATA_ALIGN_INPUT_UI ENABLED true

        set registered_data_align_input [get_parameter_value REGISTERED_DATA_ALIGN_INPUT_UI]
		set port_data_align_rollover [get_parameter_value DATA_ALIGN_ROLLOVER] 
		#send_message info "DATA_ALIGN_ROLLOVER = $port_data_align_rollover"
		
        if {$registered_data_align_input == "true"} {
            set_parameter_value REGISTERED_DATA_ALIGN_INPUT "ON"
        } else {
            set_parameter_value REGISTERED_DATA_ALIGN_INPUT "OFF"
        }
    } else {
        set_parameter_value REGISTERED_DATA_ALIGN_INPUT "OFF"
        set_parameter_property REGISTERED_DATA_ALIGN_INPUT_UI ENABLED false
    }

    ###------BUFFER_IMPLEMENTATION
    ##----------For odd mode only
    if {$tx == "false" && $x1_x2_mode == "false"} {
        if {$data_width == 5 || $data_width == 7 || $data_width == 9} {
            
            set_parameter_property BUFFER_IMPLEMENTATION_RAM_UI ENABLED true
            set_parameter_property BUFFER_IMPLEMENTATION_MUX_UI ENABLED true
            set_parameter_property BUFFER_IMPLEMENTATION_LE_UI ENABLED true

            set buffer_imp_ram [get_parameter_value BUFFER_IMPLEMENTATION_RAM_UI]
            set buffer_imp_mux [get_parameter_value BUFFER_IMPLEMENTATION_MUX_UI]
            set buffer_imp_le [get_parameter_value BUFFER_IMPLEMENTATION_LE_UI]

            if {$buffer_imp_ram == "true" && $buffer_imp_mux == "false" && $buffer_imp_le == "false"} {
                set_parameter_value BUFFER_IMPLEMENTATION "RAM"
            } elseif {$buffer_imp_ram == "false" && $buffer_imp_mux == "true" && $buffer_imp_le == "false"} {
                set_parameter_value BUFFER_IMPLEMENTATION "MUX"
            } elseif {$buffer_imp_ram == "false" && $buffer_imp_mux == "false" && $buffer_imp_le == "true"} {
                set_parameter_value BUFFER_IMPLEMENTATION "LES"
            } elseif {$buffer_imp_ram == "false" && $buffer_imp_mux == "false" && $buffer_imp_le == "false"} {
                set_parameter_value BUFFER_IMPLEMENTATION "RAM"
            } else {
                send_message error "Please choose one buffer implementation to be used."
            }

        } else {
            set_parameter_property BUFFER_IMPLEMENTATION_RAM_UI ENABLED false
            set_parameter_property BUFFER_IMPLEMENTATION_MUX_UI ENABLED false
            set_parameter_property BUFFER_IMPLEMENTATION_LE_UI ENABLED false
        }
    } else {
        set_parameter_property BUFFER_IMPLEMENTATION_RAM_UI ENABLED false
        set_parameter_property BUFFER_IMPLEMENTATION_MUX_UI ENABLED false
        set_parameter_property BUFFER_IMPLEMENTATION_LE_UI ENABLED false
    }


    pllc_computation

}

proc elab {} {
    #-----Ports

    set functional_mode [get_parameter_value FUNCTIONAL_MODE]
    set data_rate [get_parameter_value INPUT_DATA_RATE]
    set num_of_channels [get_parameter_value NUMBER_OF_CHANNELS]
    set_parameter_value WIDTH [expr {$num_of_channels}]
    set_parameter_value LPM_WIDTH $num_of_channels
    set data_width [get_parameter_value DESERIALIZATION_FACTOR]
    set pll_areset_enabled [get_parameter_value ENABLE_PLL_ARESET_PORT_UI]
    set external_pll [get_parameter_value USE_EXTERNAL_PLL_UI]

    if {$functional_mode == "TX"} {
        set tx_in_width [expr {$data_width*$num_of_channels}] 

        if {$data_width == 1} {

            # No in/out clocks for x1 mode
            add_interface       tx_in    conduit       input
            add_interface_port  tx_in tx_in tx_in input $num_of_channels

            add_interface       tx_out    conduit       output
            add_interface_port  tx_out tx_out tx_out output $num_of_channels
            set_interface_assignment    tx_out  ui.blockdiagram.direction    output

        } elseif {$data_width == 2} {

            # CIII interface
            #add_interface tx_inclock conduit input
            #add_interface_port tx_inclock tx_inclock tx_inclock input 1

            #add_interface tx_outclock conduit output
            #add_interface_port tx_outclock tx_outclock tx_outclock output 1
            #set_interface_assignment tx_outclock ui.blockdiagram.direction output

            #add_interface       tx_in    conduit       input
            #add_interface_port  tx_in tx_in tx_in input $tx_in_width

            #add_interface       tx_out conduit output
            #add_interface_port tx_out tx_out tx_out output $num_of_channels
            #set_interface_assignment    tx_out  ui.blockdiagram.direction    output

            add_interface       outclock    conduit       input
            add_interface_port  outclock outclock outclock input 1

            set data_width [get_parameter_value deserialization_factor]
            set num_of_channels [get_parameter_value number_of_channels]
            set tx_in_width [expr {$num_of_channels}]
            add_interface       datain_l    conduit       input
            add_interface_port  datain_l datain_l datain_l input $tx_in_width

            add_interface       datain_h    conduit       input
            add_interface_port  datain_h datain_h datain_h input $tx_in_width

            set dataout_width [get_parameter_value NUMBER_OF_CHANNELS]
            add_interface       dataout conduit output
            add_interface_port dataout dataout dataout output $dataout_width
            set_interface_assignment    dataout  ui.blockdiagram.direction    output

        } else {

            # Clocks
            add_interface tx_inclock conduit input
            add_interface_port tx_inclock tx_inclock tx_inclock input 1

            set use_tx_outclock [get_parameter_value ENABLE_TX_OUTCLOCK_PORT_UI]
            add_interface tx_outclock conduit output
            add_interface_port tx_outclock tx_outclock tx_outclock output 1
            set_interface_assignment tx_outclock ui.blockdiagram.direction output
            if {$use_tx_outclock == "true" && $external_pll == "false"} {
                set_interface_property tx_outclock ENABLED true
            } else {
                set_interface_property tx_outclock ENABLED false
            }

            set tx_coreclock_en [get_parameter_value ENABLE_TX_CORECLOCK_PORT_UI]
            add_interface tx_coreclock conduit output
            add_interface_port tx_coreclock tx_coreclock tx_coreclock output 1
            set_interface_assignment    tx_coreclock  ui.blockdiagram.direction    output
            if {$tx_coreclock_en == "true" && $external_pll == "false"} {
                set_interface_property tx_coreclock ENABLED true
            } else {
                set_interface_property tx_coreclock ENABLED false
            }

            # PLL settings
            if {$pll_areset_enabled=="true" && $external_pll=="false"} {
                add_interface       pll_areset    conduit       input
                add_interface_port  pll_areset pll_areset pll_areset input 1
                set_interface_property pll_areset ENABLED true
            }

            # this is when external pll is enabled
            # pll_areset disabled/enabled
            if {$external_pll=="true"} {
                add_interface tx_syncclock conduit input
                add_interface_port tx_syncclock tx_syncclock tx_syncclock input 1
                set_interface_assignment    tx_syncclock  ui.blockdiagram.direction    input
                set_interface_property tx_syncclock ENABLED true
            }

            set tx_data_rst [get_parameter_value ENABLE_PLL_TX_DATA_RESET_PORT_UI]
            if {$tx_data_rst=="true" && $external_pll=="true"} {
                add_interface tx_data_reset conduit input
                add_interface_port tx_data_reset tx_data_reset tx_data_reset input 1
                set_interface_assignment    tx_data_reset  ui.blockdiagram.direction    input
                set_interface_property tx_data_reset ENABLED true
            }

            set tx_locked_port_enabled [get_parameter_value ENABLE_TX_LOCKED_PORT_UI]
            add_interface tx_locked conduit output
            add_interface_port tx_locked tx_locked tx_locked output 1
            set_interface_assignment    tx_locked  ui.blockdiagram.direction    output
            if {$tx_locked_port_enabled == "true" && $external_pll == "false"} {
                set_interface_property tx_locked ENABLED true
            } else {
                set_interface_property tx_locked ENABLED false
            }

            # Input data
            add_interface       tx_in    conduit       input
            add_interface_port  tx_in tx_in tx_in input $tx_in_width

            # Output interface
            add_interface       tx_out conduit output
            add_interface_port tx_out tx_out tx_out output $num_of_channels
            set_interface_assignment    tx_out  ui.blockdiagram.direction    output

        }
    } else {
        # RX
        set rx_out_width [expr {$data_width*$num_of_channels}] 

        if {$data_width == 1} {

            # CIII interface
            #set register_output [get_parameter_value REGISTERED_OUTPUT_UI]
            #if {$register_output} {
            #    add_interface       rx_inclock    conduit       input
            #    add_interface_port  rx_inclock rx_inclock rx_inclock input 1
            #}

            #add_interface       rx_in    conduit       input
            #add_interface_port  rx_in rx_in rx_in input $num_of_channels

            #add_interface       rx_out conduit output
            #add_interface_port rx_out rx_out rx_out output $rx_out_width
            #set_interface_assignment    rx_out  ui.blockdiagram.direction    output

            set num_of_channels [get_parameter_value number_of_channels]
            add_interface       data    conduit       input
            add_interface_port  data data data input $num_of_channels

            add_interface       clock    conduit       input
            add_interface_port  clock clock clock input 1

            add_interface       q    conduit       output
            add_interface_port  q q q output $num_of_channels

        } elseif {$data_width == 2} {

            add_interface       rx_inclock    conduit       input
            add_interface_port  rx_inclock rx_inclock rx_inclock input 1

            add_interface       rx_in    conduit       input
            add_interface_port  rx_in rx_in rx_in input $num_of_channels

            add_interface       rx_out conduit output
            add_interface_port rx_out rx_out rx_out output $rx_out_width
            set_interface_assignment    rx_out  ui.blockdiagram.direction    output

        } else {

            if {$data_width == 5 || $data_width == 7 || $data_width == 9} {
                set odd_mode "true"
            } else {
                set odd_mode "false"
            }

            # Clocks
            add_interface       rx_inclock    conduit       input
            add_interface_port  rx_inclock rx_inclock rx_inclock input 1

            if {$external_pll == "false"} { 
                add_interface rx_outclock conduit output
                add_interface_port rx_outclock rx_outclock rx_outclock output 1
                set_interface_assignment rx_outclock ui.blockdiagram.direction output
            }

            if {$external_pll == "true" && $odd_mode == "true"} {
                add_interface       rx_syncclock    conduit       input
                add_interface_port  rx_syncclock rx_syncclock rx_syncclock input 1

                add_interface       rx_readclock    conduit       input
                add_interface_port  rx_readclock rx_readclock rx_readclock input 1
            }

            # PLL
            if {$pll_areset_enabled == "true" && $external_pll == "false"} {
                add_interface       pll_areset    conduit       input
                add_interface_port  pll_areset pll_areset pll_areset input 1
                set_interface_property pll_areset ENABLED true
            }

            # Data interface
            add_interface       rx_in    conduit       input
            add_interface_port  rx_in rx_in rx_in input $num_of_channels

            # Output interface
            add_interface       rx_out conduit output
            add_interface_port rx_out rx_out rx_out output $rx_out_width
            set_interface_assignment    rx_out  ui.blockdiagram.direction    output

            set rx_locked_port_enabled [get_parameter_value ENABLE_RX_LOCKED_PORT_UI]
            add_interface rx_locked conduit output
            add_interface_port rx_locked rx_locked rx_locked output 1
            set_interface_assignment    rx_locked  ui.blockdiagram.direction    output
            if {$rx_locked_port_enabled == "true" && $external_pll == "false"} {
                set_interface_property rx_locked ENABLED true
            } else {
                set_interface_property rx_locked ENABLED false
            }


            set rx_data_rst [get_parameter_value ENABLE_PLL_RX_DATA_RESET_PORT_UI]
            if {$rx_data_rst == "true" && $external_pll == "true"} {
                add_interface rx_data_reset conduit input
                add_interface_port rx_data_reset rx_data_reset rx_data_reset input 1
                set_interface_assignment    rx_data_reset  ui.blockdiagram.direction    input
                set_interface_property rx_data_reset ENABLED true
            }

            set port_rx_data_align [get_parameter_value PORT_RX_DATA_ALIGN_UI]
            set port_rx_channel_data_align [get_parameter_value PORT_RX_CHANNEL_DATA_ALIGN_UI]
            set use_cda_reset [get_parameter_value USE_CDA_RESET_UI]

            add_interface rx_data_align conduit input
            add_interface_port rx_data_align rx_data_align rx_data_align input 1
            set_interface_assignment rx_data_align  ui.blockdiagram.direction    input
            if {$port_rx_data_align == "true" && $port_rx_channel_data_align == "false"} {
                set_interface_property rx_data_align ENABLED true
            } else {
                set_interface_property rx_data_align ENABLED false
            }

            add_interface rx_channel_data_align conduit input
            add_interface_port rx_channel_data_align rx_channel_data_align rx_channel_data_align input $num_of_channels
            set_interface_assignment rx_channel_data_align  ui.blockdiagram.direction    input
            if {$port_rx_data_align == "true" && $port_rx_channel_data_align == "true"} {
                set_interface_property rx_channel_data_align ENABLED true
            } else {
                set_interface_property rx_channel_data_align ENABLED false
            }

            ##----RX_CDA_RESET ( Turned on once RX_CHANNEL_DATA_ALIGN is turned on )
            add_interface rx_cda_reset conduit input
            add_interface_port rx_cda_reset rx_cda_reset rx_cda_reset input $num_of_channels
            set_interface_assignment rx_cda_reset  ui.blockdiagram.direction input
            if {$port_rx_data_align == "true" && $port_rx_channel_data_align == "true" && $use_cda_reset == "true"} {
                set_interface_property rx_cda_reset ENABLED true
            } else {
                set_interface_property rx_cda_reset ENABLED false
            }

            set port_rx_data_align_reset [get_parameter_value PORT_RX_DATA_ALIGN_RESET_UI]
            add_interface rx_data_align_reset conduit input
            add_interface_port rx_data_align_reset rx_data_align_reset rx_data_align_reset input 1
            set_interface_assignment rx_data_align_reset  ui.blockdiagram.direction    input
            if {$port_rx_data_align == "true" && $port_rx_data_align_reset == "true" && $port_rx_channel_data_align == "false"} {
                set_interface_property rx_data_align_reset ENABLED true
            } else {
                set_interface_property rx_data_align_reset ENABLED false
            }
        }
    }
}


proc get_valid_result_from_pllc {rule_name} {
    set data_rate [get_parameter_value INPUT_DATA_RATE]
    set pll_freq [get_parameter_value VALID_FREQ]
    set implement_in_les "ON"

    set device_family [get_parameter_value DEVICE_FAMILY]
    set intended_device_family $device_family
    set deserialization_factor [get_parameter_value DESERIALIZATION_FACTOR]
    set lvds_mode [get_parameter_value FUNCTIONAL_MODE]
    if {$lvds_mode=="TX"} {
        set lvds_rx "0"
    } else {
        set lvds_rx "1"
    }

    set coreclock_divide_by "2"
	
    if {$lvds_mode=="TX"} {
        set outclock_divide_factor [get_parameter_value OUTCLOCK_DIVIDE_BY_UI]
		
		##FB246426
		set data_width [get_parameter_value DESERIALIZATION_FACTOR]
			 if {$data_width == 4 && $outclock_divide_factor == 2} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "1"
				 set outclock_divide_by "1"
		     } elseif {$data_width == 4 && $outclock_divide_factor == 4} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "2"
				 set outclock_divide_by "2"
		     } elseif {$data_width == 4 && $outclock_divide_factor == 8} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "4"
				 set outclock_divide_by "4"
			 } elseif {$data_width == 6 && $outclock_divide_factor == 2} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "1"
				 set outclock_divide_by "1"
			 } elseif {$data_width == 6 && $outclock_divide_factor == 4} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "2"
				 set outclock_divide_by "1"
			 } elseif {$data_width == 6 && $outclock_divide_factor == 6} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "6"
				 set outclock_divide_by "6"			 
			 } elseif {$data_width == 6 && $outclock_divide_factor == 12} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "6"
				 set outclock_divide_by "6"				 
			 } elseif {$data_width == 8 && $outclock_divide_factor == 2} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "1"
				 set outclock_divide_by "1"				 
			 } elseif {$data_width == 8 && $outclock_divide_factor == 4} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "2"
				 set outclock_divide_by "2"				 
			 } elseif {$data_width == 8 && $outclock_divide_factor == 8} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "4"
				 set outclock_divide_by "4"				 
			 } elseif {$data_width == 8 && $outclock_divide_factor == 16} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "8"
				 set outclock_divide_by "8"				 
			 } elseif {$data_width == 10 && $outclock_divide_factor == 2} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "1"
				 set outclock_divide_by "1"
			 } elseif {$data_width == 10 && $outclock_divide_factor == 4} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "2"
				 set outclock_divide_by "2"
			 } elseif {$data_width == 10 && $outclock_divide_factor == 10} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "10"
				 set outclock_divide_by "10"
			 } elseif {$data_width == 10 && $outclock_divide_factor == 20} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "10"
				 set outclock_divide_by "10"
			 } elseif {$data_width == 5 && $outclock_divide_factor == 2} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "1"
				 set outclock_divide_by "1"
			 } elseif {$data_width == 5 && $outclock_divide_factor == 5} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "5"
				 set outclock_divide_by "5"
			 } elseif {$data_width == 5 && $outclock_divide_factor == 10} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "5"
				 set outclock_divide_by "5"
			 } elseif {$data_width == 7 && $outclock_divide_factor == 2} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "1"
				 set outclock_divide_by "1"
			 } elseif {$data_width == 7 && $outclock_divide_factor == 7} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "7"
				 set outclock_divide_by "7"
			 } elseif {$data_width == 7 && $outclock_divide_factor == 14} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "7"
				 set outclock_divide_by "7"
			 } elseif {$data_width == 9 && $outclock_divide_factor == 2} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "1"
				 set outclock_divide_by "1"
			 } elseif {$data_width == 9 && $outclock_divide_factor == 9} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "9"
				 set outclock_divide_by "9"
			 } elseif {$data_width == 9 && $outclock_divide_factor == 18} {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "9"
				 set outclock_divide_by "9"
			 } else {
				 set_parameter_value OUTCLOCK_DIVIDE_BY "1"
				 set outclock_divide_by "1"
			 }
	###
    } else {
        set_parameter_value OUTCLOCK_DIVIDE_BY "1"
		set outclock_divide_by "1"
    }

    set le_serdes "1"
    set outclock_divide_by_inclock_phase "0"
    set find_refclk "reference_clock_freq"
    set find_phase "phase"


    if {[string compare $rule_name "valid_freq" ] == 0} {
        set reference_list [list $data_rate $pll_freq $implement_in_les $intended_device_family $deserialization_factor $lvds_rx $coreclock_divide_by]
        set valid_list [get_valid_reference_clock_fequency $find_refclk $reference_list]
    } elseif {[string compare $rule_name "valid_inclock_phase" ] == 0} {
        set reference_list_inclock_phase [list $data_rate $pll_freq $implement_in_les $intended_device_family $deserialization_factor $lvds_rx $coreclock_divide_by $outclock_divide_by_inclock_phase $le_serdes]
        set valid_list [get_valid_reference_clock_fequency $find_phase $reference_list_inclock_phase]
	} else {
        set reference_list_outclock_phase [list $data_rate $pll_freq $implement_in_les $intended_device_family $deserialization_factor $lvds_rx $coreclock_divide_by $outclock_divide_by $le_serdes]
        set valid_list [get_valid_reference_clock_fequency $find_phase $reference_list_outclock_phase]
    
	}

    set valid_list_split [split $valid_list "|" ]
    regsub {([\{]+)} $valid_list_split {} valid_list_split
    regsub {([\}]+)} $valid_list_split {} valid_list_split
    return $valid_list_split
}

proc validate_freq_list {} {
    set speed 0
    set rule_name_freq "valid_freq"
    set result_freq [get_valid_result_from_pllc $rule_name_freq]

    return $result_freq
}

proc validate_inclock_phase_list {} {
    set rule_name_phase "valid_inclock_phase"
    set result_inclock_phase [get_valid_result_from_pllc $rule_name_phase]

    return $result_inclock_phase
}

proc validate_outclock_phase_list {} {
    set rule_name_phase "valid_outclock_phase"
    set result_outclock_phase [get_valid_result_from_pllc $rule_name_phase]

    return $result_outclock_phase
}

proc pllc_computation {} {
    set result_freq [validate_freq_list]
    map_allowed_range VALID_FREQ $result_freq

    set result_inclock_phase [validate_inclock_phase_list]
    set result_outclock_phase [validate_outclock_phase_list]

    map_allowed_range TX_OUTCLOCK_PHASE_SHIFT_UI $result_outclock_phase
    map_allowed_range TX_INCLOCK_PHASE_SHIFT_UI $result_inclock_phase
    map_allowed_range RX_OUTCLOCK_PHASE_SHIFT_UI $result_outclock_phase
    map_allowed_range RX_INCLOCK_PHASE_SHIFT_UI $result_inclock_phase
    
}
