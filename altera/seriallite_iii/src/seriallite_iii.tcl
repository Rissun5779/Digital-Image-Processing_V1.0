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



set tcl_precision 10

# +-----------------------------------
# Use alt_xcvr TCL packages
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_reset_control
package require alt_xcvr::gui::pll_reconfig
package require alt_xcvr::gui::messages
package require alt_xcvr::utils::params_and_ports
package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::common
package require altera_xcvr_reset_control::fileset
package require alt_xcvr::ip_tcl::ip_module
package require -exact altera_terp 1.0
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_xcvr_generic/alt_xcvr_common.tcl
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_xcvr_generic/sv/sv_xcvr_native_fileset.tcl
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_xcvr_generic/ctrl/alt_xcvr_csr_fileset.tcl
#


#Filesets
add_fileset synth QUARTUS_SYNTH synth_proc
add_fileset example EXAMPLE_DESIGN example_proc
add_fileset sim_vlog SIM_VERILOG sim_proc
add_fileset sim_vhd SIM_VHDL sim_proc

# define parameters
source params.tcl

# PLL Clocking validation routines
source pll.tcl

add_documentation_link "Datasheet" "http://www.altera.com/literature/ug/ug_slite3_streaming.pdf"

proc my_local_get_quartus_bindir {} {

    set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

    set PLATFORM $::tcl_platform(platform)
    if { $PLATFORM == "java" } {
        set PLATFORM $::tcl_platform(host_platform)
    }

    if { [catch {set QUARTUS_BINDIR $::quartus(binpath)} errmsg] } {
        if { $PLATFORM == "windows" } {
            set BINDIRNAME "bin"
        } else {
            set BINDIRNAME "linux"
        }

        # Only the native tcl interpreter has 'tcl_platform(pointerSize)'
        # In Jacl however 'tcl_platform(machine)' is set to the JVM bitness, not the OS bitness
        if { [catch {set POINTERSIZE $::tcl_platform(pointerSize)} errmsg] } {
            if {[string match "*64" $::tcl_platform(machine)]} {
                set POINTERSIZE 8
            } else {
                set POINTERSIZE 4
            }
        }
        if { $POINTERSIZE == 8 } {
            set BINDIRNAME "${BINDIRNAME}64"
        }

        set QUARTUS_BINDIR "$QUARTUS_ROOTDIR/$BINDIRNAME"
    }

	return $QUARTUS_BINDIR

}
set QUARTUS_BINDIR [my_local_get_quartus_bindir]
source [file join $QUARTUS_BINDIR .. common tcl packages pll pll_legality.tcl]
package require ::quartus::pll::legality
#source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_iopll/tclpackages.tcl
#package require altera_iopll::util


# ------------------------------------------------------------------------------------------
proc get_nearest_achievable_frequency { desired_kernel_clk  \
                                        refclk_freq \
										device_speedgrade } {
#
# Description :  Returns the closest achievable IOPLL frequency less than or
#                equal to desired_kernel_clk.
#
# Parameters :
#    desired_kernel_clk  - The desired frequency in MHz (floating point)
#    refclk_freq         - The IOPLL's reference clock frequency in MHz (floating point)
#    device_speedgrade   - The device speedgrade (1, 2 or 3)
#
# Assumptions :  
#    - There are two desired output clocks, the kernel_clk and a kernel_clk_2x
#    - Both clocks have zero phase shift 
#    - The desired_kernel_clk frequency is > 10 MHz
#
# -------------------------------------------------------------------------------------------

	# If the kernel_clk_2x frequency is achievable from a given VCO frequency, 
	# then so must be the kernel_clk (assuming that it is not absurdly low).
	# So, we can simply and compute for an IOPLL with a single clock output of kernel_clk_2x.
	set desired_1x_clk [expr $desired_kernel_clk]
	
	# Use array get to ensure correct input formatting (and avoid curly braces)
	set desired_output(0) [list -type c -index 0 -freq $desired_1x_clk -phase 0.0 -is_degrees false -duty 50.0]
	set desired_counter [array get desired_output]
	
	# Prepare the arguments for a call to the PLL legality package.
	# The non-obvious parameters here are all effectively don't cares.
	set ref_list [list  -family                       "Arria 10" \
						-speedgrade                   $device_speedgrade \
						-refclk_freq                  $refclk_freq \
						-is_fractional                false \
						-compensation_mode            direct \
						-is_counter_cascading_enabled false \
						-x                            32 \
						-validated_counter_values     {} \
						-desired_counter_values       $desired_counter]
						
	if {[catch {::quartus::pll::legality::retrieve_output_clock_frequency_list $ref_list} result]} {
		puts "Call to retrieve_output_clock_frequency_list failed because:"
		puts $result
		return TCL_ERROR
		# ERROR
	}	
		
	# We get a list of six legal frequencies for kernel_clk_2x
	array set result_array $result
	set freq_list $result_array(freq)
   # set actual_valid_list [::altera_iopll::util::round_to_n_decimals $freq_list 6]
   # set_parameter_property gui_user_clock_freq_sel ALLOWED_RANGES $actual_valid_list
   # send_message info "List of IOPLL valid freq: $freq_list"
	
	# Pick the closest frequency that's still less than the desired frequency
	# Recover the legal kernel_clk frequencies as we go
	set best_freq 0
	set possible_kernel_freqs {}
	
	foreach freq_1x $freq_list {
		set freq [format %.6f [expr {$freq_1x}]]
		lappend possible_kernel_freqs $freq
		
		if { $freq > $desired_kernel_clk } {
			# The frequency exceeds fmax -- no good.
		} elseif { $freq > $best_freq } {
			set best_freq $freq
		}
	}
	
	# Debug output:
	#puts "Nearest achievable IOPLL clock frequencies:"
	#puts $possible_kernel_freqs
	
	if {$best_freq == 0} {
		puts "All of the frequencies were too high!"
		return TCL_ERROR
		# ERROR
	} else {
		return $best_freq
		# SUCCESS!
	}
									
}


proc validation_callback {} {
 
    set cmode [get_parameter_value gui_clocking_mode]
    set dir [get_parameter_value direction]
    set dev_fam  [get_parameter_value system_family]
    set num_lanes [get_parameter_value lanes]
    set pll_freq [get_parameter_value gui_pll_ref_freq]
    set mf [get_parameter_value meta_frame_length]
    set xcvr_capability_reg_en [get_parameter_value xcvr_capability_reg_en]
    set SELECT_TARGETED_DEVICE [get_parameter_value SELECT_TARGETED_DEVICE]
	set SELECT_CUSTOM_DEVICE [get_parameter_value SELECT_CUSTOM_DEVICE]
    set DEVICE [get_parameter_value DEVICE]
    set DEVKIT_DEVICE [get_parameter_value DEVKIT_DEVICE]
    set ENABLE_ED_FILESET_SYNTHESIS [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS]
    set ENABLE_ED_FILESET_SIM [get_parameter_value ENABLE_ED_FILESET_SIM]
    set user_input [get_parameter_value gui_user_input]	
    set xcvr_data_rate [get_parameter_value gui_xcvr_data_rate]
    set data_rate  [get_parameter_value data_rate]
    set_parameter_value DEVICE_FAMILY $dev_fam	   
    set rcfg_jtag_en [get_parameter_value rcfg_jtag_enable]

	if {$dev_fam eq "Arria 10" } {
        set max_xcvr_datarate 17.4
    } elseif { $dev_fam eq "Stratix V"} {
        set max_xcvr_datarate 14.1
    } else {
        set max_xcvr_datarate 12.5
    }	

    if {$cmode == "false"} {
        set min_xcvr_datarate 3.52
    } else {
        set min_xcvr_datarate 3.418367
    }
	
    if {$user_input == 1} {
        if { $xcvr_data_rate < $min_xcvr_datarate} {
            send_message error "Minimum Transceiver Data Rate value is $min_xcvr_datarate Gbps"  
	        return        
		} elseif {$xcvr_data_rate > $max_xcvr_datarate} {
            send_message error "Maximum Transceiver Data Rate value is $max_xcvr_datarate Gbps"
		    return
        }
    }
	
    if {$cmode == "true"} {
        if {$user_input == 0} {
            set_parameter_value gui_actual_user_clock_frequency "N.A."
            set ucf_val [get_parameter_value gui_user_clock_frequency]
        } else {
            set_parameter_value gui_actual_user_clock_frequency [format %.6f [expr [get_parameter_value gui_xcvr_data_rate]*1000/(($mf * 1.046875)/($mf - 4))/64]]
            set ucf_val [get_parameter_value gui_actual_user_clock_frequency]
        }
    } else {
        if {$user_input == 0} {
            set ucf_val [get_parameter_value gui_user_clock_frequency]
        } else {
            set_parameter_value gui_actual_user_clock_frequency [format %.6f [expr [get_parameter_value gui_xcvr_data_rate]*1000/1.1/64]]
            set ucf_val [get_parameter_value gui_actual_user_clock_frequency]
        }
    }
	
	if {$user_input == 1} {		
        set_parameter_property gui_xcvr_data_rate ENABLED true
        set_parameter_property gui_xcvr_data_rate VISIBLE true
        
        set_parameter_property lane_rate_parameter ENABLED false
        set_parameter_property lane_rate_parameter VISIBLE false
        
        set_parameter_property gui_user_clock_frequency ENABLED false
        set_parameter_property gui_user_clock_frequency VISIBLE false
    } else {       
        set_parameter_property gui_xcvr_data_rate ENABLED false
        set_parameter_property gui_xcvr_data_rate VISIBLE false

        set_parameter_property lane_rate_parameter ENABLED true
        set_parameter_property lane_rate_parameter VISIBLE true

        set_parameter_property gui_user_clock_frequency ENABLED true 
        set_parameter_property gui_user_clock_frequency VISIBLE true
    }
		
    if {$cmode == "true" && $num_lanes == 2 && $ucf_val == "150.839552" && $pll_freq == "644.53125"} {	  		     
       ::alt_xcvr::utils::common::map_allowed_range gui_ed_option {"Advanced_Clocking_Mode_2x10G"}
    } elseif {$cmode == "true" && $num_lanes == 6 && $ucf_val == "186.476056" && $pll_freq == "312.500000"} {
       ::alt_xcvr::utils::common::map_allowed_range gui_ed_option {"Advanced_Clocking_Mode_6x12.5G"}  
    } elseif {$cmode == "false" && $num_lanes == 2 && $data_rate == "10312.4992 Mbps" && $pll_freq == "644.531187" && $mf == 200 && $dev_fam == "Arria 10"} {
       ::alt_xcvr::utils::common::map_allowed_range gui_ed_option {"Standard_Clocking_Mode_2x10G"}
    } elseif {$cmode == "false" && $num_lanes == 2 && $ucf_val == "146.484375" && $pll_freq == "644.53125" && $mf == 200 && $dev_fam == "Stratix V"} {	
       ::alt_xcvr::utils::common::map_allowed_range gui_ed_option {"Standard_Clocking_Mode_2x10G"}
    } elseif {$cmode == "false" && $num_lanes == 6 && $ucf_val == "177.556818" && $pll_freq == "312.500000" && $mf == 8191} { 
       ::alt_xcvr::utils::common::map_allowed_range gui_ed_option {"Standard_Clocking_Mode_6x12.5G"} 
    } else {
       if {$cmode == "true"} {
          ::alt_xcvr::utils::common::map_allowed_range gui_ed_option {"Advanced Clocking Mode"}
       } else {
          ::alt_xcvr::utils::common::map_allowed_range gui_ed_option {"Standard Clocking Mode"}
       }
    }
	
    set_parameter_value ed_option [::alt_xcvr::utils::common::get_mapped_allowed_range_value gui_ed_option]	
    set ed_option [get_parameter_value ed_option] 
	
	## Example design options
    if {$dev_fam == "Arria V GZ"} {
       set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED false 
    } else {	   
       if {$ed_option == "Advanced_Clocking_Mode_2x10G"} {
          set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true  
       } elseif {$ed_option == "Advanced_Clocking_Mode_6x12.5G"} {
          set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true       		   
       } elseif {$ed_option == "Standard_Clocking_Mode_2x10G"} {
          set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true        
       } elseif {$ed_option == "Standard_Clocking_Mode_6x12.5G"} {
          set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED true       	   
       } else {
          set_parameter_property ENABLE_ED_FILESET_SYNTHESIS ENABLED false 
       }
    }   
	
	if {$ed_option == "Advanced_Clocking_Mode_2x10G" || $ed_option == "Advanced_Clocking_Mode_6x12.5G" || $ed_option == "Standard_Clocking_Mode_2x10G" || $ed_option == "Standard_Clocking_Mode_6x12.5G"} {
       if {$ENABLE_ED_FILESET_SYNTHESIS} {
          set_parameter_property SELECT_TARGETED_DEVICE ENABLED true
       } else {
          set_parameter_property SELECT_TARGETED_DEVICE ENABLED false
          set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false
       }
    } else {
       set_parameter_property SELECT_TARGETED_DEVICE ENABLED false
       set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false
    }
	
	if {$ENABLE_ED_FILESET_SYNTHESIS == 0 && $ENABLE_ED_FILESET_SIM == 0} {
       send_message warning "At least one of the \"Simulation\" and \"Synthesis\" check boxes from \"Example Design Files\" must be selected to allow generation of Example Design Files."
    }
	
    if {$SELECT_TARGETED_DEVICE == 3 || $dev_fam == "Arria V GZ"} {
       ## No development kit selection
       set_display_item_property target_dev TEXT "<html>Device Selected:&nbsp;&nbsp;&nbsp;&nbsp;Family: $dev_fam Device: $DEVICE<br><br></html>"
       
	   set_display_item_property explanation1 TEXT "<html>Example Design generation will produce necessary files for Quartus compile. The Quartus<br>
       Settings File (QSF) will have pin assignments set to virtual pins.<br>
       <br>
       The field Device Selected under the <b>Target Device</b> category below displays the target <br>
       device for this Example Design. If you need to change the target device, follow instructions <br> 
       provided in the field <b>To Change Target Device</b> under <b>Target Device</b> below.</html>"
       set_display_item_property explanation2 TEXT "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
       desired device. When completed, the <b>Device Selected</b> field above reflects the new device.</html>"
       
	   set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false
    } elseif {$SELECT_TARGETED_DEVICE == 1} {
       # Altera development kit selection
       if {$SELECT_CUSTOM_DEVICE == 1} {
          set_display_item_property target_dev TEXT "<html>Device Selected:Family:&nbsp;&nbsp;&nbsp;&nbsp;$dev_fam Device: $DEVICE<br><br></html>"
          if {![validate_custom_device]} {
             send_message WARNING "The device selected is not a valid variation of the device on the selected Altera Development kit. Allowed variations are only for 'SerDes Speed Grade',
             .etc. Check the device part number and try again."
             
			 set_display_item_property target_dev TEXT "<html>Device Selected:Family:&nbsp;&nbsp;&nbsp;&nbsp;$dev_fam Device: $DEVKIT_DEVICE<br><br></html>"
          }
       } else {
          set_display_item_property target_dev TEXT "<html>Device Selected:Family:&nbsp;&nbsp;&nbsp;&nbsp;$dev_fam Device: $DEVKIT_DEVICE<br><br></html>"
       }
       
	   set_display_item_property explanation1 TEXT "<html>Example Design generation produces the necessary files for Quartus Prime project targeted<br>
       to the selected Altera development kit.<br>
       <br>
       The field <b>Device Selected</b> under the <b>Targted Device</b> category below displays the target <br>
       device for the selected Altera development kit. If your board revision has a different grade <br>
       of this device, you should change it to correct device grade. To change the target device, <br>
       follow instructions provided in the field <b>To change Target Device</b> under <b>Target Device</b> <br>
       below.</html>"
       
	   set_display_item_property explanation2 TEXT "<html><b>To change Target Device</b>: First check the <b>Change Target Device</b> box above. Then from <br>
       the menu bar use <b>View</b> -> '<b>Device Family</b>' to select desired device. When completed, <br>
       the <b>Device Selected</b> field above reflects the new device.</html>"
       
	   set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
    } elseif {$SELECT_TARGETED_DEVICE == 2} {
       # Custom development kit selection
       set_display_item_property target_dev TEXT "<html>Device Selected:&nbsp;&nbsp;&nbsp;&nbsp;Family: $dev_fam Device: $DEVICE<br><br></html>"
       
	   set_display_item_property explanation1 TEXT "<html>Example Design generation produces the necessary files for Quartus Prime project. The <br>
       Quartus Settings File (QSF) includes pin assignment statements without pin number. After the <br>
       Example Design generation, you must edit the QSF file <b>ed_synth/seriallite_iii_streaming_demo.qsf</b> to add pin numbers according to your custom board layout.<br>
       <br>
       The field <b>Device Selected</b> under the <b>Targted Device</b> category below displays the target <br>
       device for this Example Design. If your board revision has a different device, you should <br>
       change it to correct device. To change the target device, follow instructions provided in <br>
       the field <b>To change Target Device</b> under <b>Target Device</b> below.</html>"
       
	   set_display_item_property explanation2 TEXT "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
       desired device. When completed, the <b>Device Selected</b> field above reflects the new device.</html>"
       
	   set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false
    } else {
       set_display_item_property target_dev TEXT "<html>Device Selected:&nbsp;&nbsp;&nbsp;&nbsp;Family: $dev_fam Device: $DEVICE<br><br></html>"
       
	   set_display_item_property explanation1 TEXT "<html>Example Design generation will produce necessary files for Quartus compile. The Quartus<br>
       Settings File (QSF) will have pin assignments set to virtual pins.<br>
       <br>
       The field <b>Device Selected</b> under the <b>Targted Device</b> category below displays the target <br>
       device for this Example Design. If you need to change the target device, follow instructions <br> 
       provided in the field <b>To change Target Device</b> under <b>Target Device</b> below.</html>"
       
	   set_display_item_property explanation2 TEXT "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
       desired device. When completed, the <b>Device Selected</b> field above reflect the new device.</html>"
       
	   set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false
    }
	
    if {$dev_fam == "Arria 10"} {
        set_parameter_property rcfg_jtag_enable ENABLED true
        set_parameter_property rcfg_jtag_enable VISIBLE true
    } else {
        set_parameter_property rcfg_jtag_enable ENABLED false
        set_parameter_property rcfg_jtag_enable VISIBLE false
    }
        
    # Hide PLL Type for A10
    if {$dev_fam == "Arria 10"} {
      set_parameter_property gui_enable_tx_pll VISIBLE false
      set_parameter_property gui_pll_type VISIBLE false
      ## Fix FB 284723, disable gui_pll_ref_freq when direction is Source and A10 
      if {$dir ==  "Source"} {
          set_parameter_property "gui_pll_ref_freq" ENABLED false
      } else {
          set_parameter_property "gui_pll_ref_freq" ENABLED true
      }
    } else {
      if {$dir == "Sink"} {
          set_parameter_property gui_pll_type VISIBLE false
      } else {
          set_parameter_property gui_pll_type VISIBLE true
      }
    }
    
     #ADME Option
     if {$dev_fam == "Arria 10"} {

        set_parameter_property xcvr_capability_reg_en VISIBLE true
	set_parameter_property xcvr_set_user_identifier VISIBLE true
	set_parameter_property xcvr_csr_soft_log_en VISIBLE true
	set_parameter_property xcvr_prbs_soft_log_en VISIBLE true

	if { $rcfg_jtag_en == "true" } {
	set_parameter_property xcvr_capability_reg_en ENABLED true
	set_parameter_property xcvr_set_user_identifier ENABLED true
	set_parameter_property xcvr_csr_soft_log_en ENABLED true
	set_parameter_property xcvr_prbs_soft_log_en ENABLED true
	} else {
	set_parameter_property xcvr_capability_reg_en ENABLED false
	set_parameter_property xcvr_set_user_identifier ENABLED false
	set_parameter_property xcvr_csr_soft_log_en ENABLED false
	set_parameter_property xcvr_prbs_soft_log_en ENABLED false
    	}

    } else {

        set_parameter_property xcvr_capability_reg_en VISIBLE false
	set_parameter_property xcvr_set_user_identifier VISIBLE false
	set_parameter_property xcvr_csr_soft_log_en VISIBLE false
	set_parameter_property xcvr_prbs_soft_log_en VISIBLE false

	set_parameter_property xcvr_capability_reg_en ENABLED false
	set_parameter_property xcvr_set_user_identifier ENABLED false
	set_parameter_property xcvr_csr_soft_log_en ENABLED false
	set_parameter_property xcvr_prbs_soft_log_en ENABLED false
    }


    # Add a check to verify the BASE_DEVICE parameter before passing it to A10 PHY/PLL IP.  
    if {$dev_fam == "Arria 10"} {
      set local_base_device [get_parameter_value "part_trait_bd"]
      if { [string compare -nocase $local_base_device "unknown"] == 0 } {
         set local_device [get_parameter_value "part_trait_device"]
         send_message error "The current selected device \"$local_device\" is invalid, please select a valid device to generate the IP."
      }
    }

    # Input User clock frequency sanity checks
    set ucf_str "$ucf_val MHz"
    if { ![ validate_clock_freq_string $ucf_str ] }  {
       send_message error "User Clock Frequency is not in a recognizable format. A valid format is 138.526"
       return
    }

    set sg [string range [get_parameter_value speedgrade] 0 1]
    set min_f 50
    
    #Setting Max User Clock Values for Device Family and Clocking mode
    # Uclock values are hardcoded for Max allowed data rate for Device Family
    # ACM Mode hardcoded for Max Data Rate at mframe = 8191,
    # ucf = User Clock Freq, rcf = Ref Clock Freq
    if {$dev_fam eq "Arria 10" } {
      if {$cmode == "false"} {
        set max_ucf 247.159091 
      } else {
        set max_ucf 259.574670
      }
      set max_rcf 390.625
    } elseif { $dev_fam eq "Stratix V"} {
      if {$cmode == "false"} {
        set max_ucf 200.284091
      } else {
        set max_ucf 210.344991
      }
      set max_rcf 352.5
    } else {
      set max_ucf 275
      set max_rcf 435
    }
	
	set ucf $ucf_val
	
    if {$user_input == 0} {
        if { $ucf < $min_f} {
	        send_message error "Minimum User Clock Frequency value is 50 MHz"  
	        return
        } elseif { $ucf > $max_ucf} {
            send_message error "Maximum User Clock Frequency value is $max_ucf MHz"
            return
        }
        send_message info "Supports user clock frequency value from 50 MHz to $max_ucf MHz"
    }
	
    # Evaluation of fPLL clock frequencies
    if { $cmode == "false" }  {
      set ref_clk [ find_valid_fpll_clocks ]
    } else {
      # fix to use ACM data rate formula
      set in_datarate [expr {double($ucf * 64)}]
      set pcs_in_rate [format %.4f [expr ($in_datarate * $mf) / ($mf - 4)] ]
      set rcf_check [format %.4f [expr {double(($pcs_in_rate * 67/64))}] ]

      if {$dev_fam == "Arria 10"} {
        send_message info "PMA Width Configured for 64 bits."
      }
    }

    set input_data_rate [expr {double($ucf * 64)}  ]
    if {$dev_fam== "Arria 10"} {
      set input_data_rate_param [format %.6f [expr {double($input_data_rate/1000)}] ]
    } else {
      set input_data_rate_param "[format %f [expr $input_data_rate/1000]]"
    }
	send_message info "User Interface Data Rate: $input_data_rate_param Gbps"
    # Overhead and actual lane rate calculation
    set mfl [get_parameter_value meta_frame_length]
    set mfo [format %.4f [expr (4 * $input_data_rate) / ($mfl) ] ]
    send_message INFO "Meta-Frame Overhead  = $mfo Mbps"
    #set pcs_input_rate [expr $input_data_rate + $mfo]
    set pcs_input_rate [format %.4f [expr ($input_data_rate * $mfl) / ($mfl - 4)] ]
    set pcs_output_rate [format %.4f [expr {double(($pcs_input_rate * 67/64))}] ]
    send_message INFO "Encoding Overhead = [format %.4f [expr ($pcs_output_rate - $pcs_input_rate)] ] Mbps"
    set lnr_empirical $pcs_output_rate

    if { $cmode == "true" }  {
      set lnr $lnr_empirical
    } else {
        if { $dev_fam == "Arria 10"} {
          set lnr [format %.4f [expr ($ref_clk*64)] ]
        } else {
          set lnr [format %.4f [expr ($ref_clk*40)] ]
        }
      send_message INFO "Additional Overheads = [format %.4f [expr ($lnr - $lnr_empirical)]] Mbps"
    }
    
    if {$user_input == 0} {
        if {$dev_fam == "Arria 10"} {
            set_parameter lane_rate_parameter "[format %f [expr {double($lnr/1000)}]]"
        } else {
            set_parameter lane_rate_parameter "[format %f [expr $lnr/1000]]"
        }
    } else {
        set_parameter lane_rate_parameter [get_parameter_value gui_xcvr_data_rate]
    }
    set_parameter gui_aggregate_data_rate "[format %f [expr ($input_data_rate * [get_parameter_value lanes])/1000]]"

    # Sanity checks for fpll reference and core clock frequenices
    if { $cmode == "false" }  {
      set rcf [get_parameter_value gui_reference_clock_frequency]
      set_parameter_value reference_clock_frequency  "$ref_clk MHz"
      set_parameter_value gui_interface_clock_frequency  "N.A."
      
      if { $rcf < $min_f} {
         send_message error "Minimum Reference Clock Frequency value is 50 MHz"    
      } elseif { $rcf > $max_rcf} {
         send_message error "Maximum fPLL Reference Clock Frequency value is $max_rcf MHz"
      }
    
    } else {
      if { $dev_fam == "Arria 10"} {
        set icf [format %.4f [expr "$lnr / 64.0"]]
      } else {
        set icf [format %.4f [expr "$lnr / 40.0"]]
      }
      set_parameter_value gui_interface_clock_frequency  "$icf"
      set_parameter gui_actual_coreclkin_frequency "N.A."
      set_parameter_value gui_reference_clock_frequency  "N.A."
      set_parameter_value int_reference_clock_frequency  "N.A."
    }

    # Transceiver reference clock frequency calculation and checks
    if { $dev_fam == "Arria 10" }  {
       set_parameter_value pll_ref_freq [get_parameter_value gui_pll_ref_freq] 
    } else {
       set trans_pll_refclk [pll_validation $lnr] 
       set_parameter_value pll_ref_freq  "$trans_pll_refclk MHz"
  
    }
   
    # Parameter settings
    set_parameter_value adaptation_fifo_depth 32

    set_parameter_value data_rate         "$lnr Mbps"
    set_parameter_value pll_type          [get_parameter_value gui_pll_type]
    set_parameter_value ecc_enable        [get_parameter_value gui_ecc_enable]

    if { $cmode == "true" }  {
      set_parameter_property user_clock_frequency IS_HDL_PARAMETER false
      set_parameter_property coreclkin_frequency IS_HDL_PARAMETER false
      set_parameter_property reference_clock_frequency  IS_HDL_PARAMETER false

    } else {
      set_parameter_property user_clock_frequency IS_HDL_PARAMETER true
      set_parameter_value user_clock_frequency "[get_parameter_value gui_actual_user_clock_frequency] MHz" 
      set_parameter_property coreclkin_frequency IS_HDL_PARAMETER true
      set_parameter_value coreclkin_frequency "[get_parameter_value gui_actual_coreclkin_frequency] MHz"
      set_parameter_property reference_clock_frequency  IS_HDL_PARAMETER true
    }

    # Display PLL note - only for A10
    if {$dev_fam== "Arria 10"} {
      if {$dir != "Sink"} {
        set pll_out_freq [format %f [expr [get_parameter_value lane_rate_parameter]*500] ]
        set message "<html><font color=\"blue\">Note - </font>An external TX PLL IP must be configured with an output clock frequency of <b>${pll_out_freq} MHz.</b></html>"
        send_message INFO $message
        set message "<html><font color=\"blue\">Note - </font>An external TX PLL IP must be used with Seriallite-III. Please see the note below</html>"
        set_display_item_property disp_note  text $message
      }	    
    }	   

    if { $dir == "Source" && $dev_fam== "Arria 10"} {
        set message "Transceiver reference clock frequency calculation is not available in Source-direction of the IP."
        send_message INFO $message
    }
	
}

proc pll_validation { lnr } {

    set family "Stratix V"
    #set family "Arria10"
    set pll_type [validate_pll_type $family]

    
    #### set BASE DATA RATE
    # The following statement/function shud enforce if the PLL type supports the data rate
    # but they are only partially working they do not differentiate between CMU with ATX plls (Faisal)
    set base_data_rate_list [::alt_xcvr::utils::rbc::get_valid_base_data_rates $family $lnr $pll_type]
    #send_message INFO "base_rate_list = $base_data_rate_list"
    if { [llength $base_data_rate_list] == 0 } {
      set base_data_rate_list {"N/A"}
      send_message error "Data rate chosen is not supported or is incompatible with selected PLL type"
    } 

    #|----------------
    # Validation for PLL
    #|---------------- 
    ## result variable returns the list of all available refclks for the current data rate
    if {$lnr != "N/A" && $lnr != "N.A"} {
      # May return "N/A"
      set result [::alt_xcvr::utils::rbc::get_valid_refclks $family $lnr $pll_type]
    } else {
      send_message info "setting result to be unavailable"
      set result "N/A"
    }
  
    if {$result == "N/A"} {
      send_message error "No valid transceiver reference clocks available with the selection"
      return
    } else {
      send_message INFO "It is recommended to choose the highest feasible transceiver reference clock among the available drop-down options" 
    }

    ## Adding following code for backwards compatibility, till 11.0SP2
    ## Interlaken was allowing only one refclk now allowing user to choose refclk from the list, at the same time
    ## we want to open the old designs with the same refclk as before
   
    set my_pll_ref_freq [format %.4f [expr {double($lnr / 16.0)}] ]
    set find_default_f "false"

    #set local_results [list]

    foreach val $result {
	regexp {([0-9.]+)} $val myval
	#set newval [format %f $myval]
	set newval [format %.4f [expr {double($myval)}] ]
        set xcvr_clk_freq [string trimright $val " MHz"]
	if { $newval == $my_pll_ref_freq} { 
	    set default_pll_ref_freq $xcvr_clk_freq
	    set find_default_f "true"
	} 
        if {$xcvr_clk_freq != "0"} {
            lappend local_results $xcvr_clk_freq
        }
    }

    if {$find_default_f == "true"} {
	::alt_xcvr::utils::common::map_allowed_range gui_pll_ref_freq $local_results $default_pll_ref_freq	
    } else {
	::alt_xcvr::utils::common::map_allowed_range gui_pll_ref_freq $local_results
    }
    set user_pll_refclk_freq [::alt_xcvr::utils::common::get_mapped_allowed_range_value gui_pll_ref_freq]
    return $user_pll_refclk_freq

}

proc validate_pll_type { device_family } {
  ::alt_xcvr::utils::common::map_allowed_range gui_pll_type [::alt_xcvr::utils::device::get_hssi_pll_types $device_family]
  return [::alt_xcvr::utils::common::get_mapped_allowed_range_value gui_pll_type]
}

proc validate_clock_freq_string { clock_freq_string } {

# Extract value and units
  regexp {([0-9.]+)} $clock_freq_string value 
  regexp -nocase {([a-z]+)} $clock_freq_string unit

  if {![info exist value] || ![info exist unit]} {
    return 0
  }

  if { [string compare -nocase $unit "MHz" ] != 0 } {
    if { [string compare -nocase $unit "GHz"] != 0 } {
      return 0
    }
  }
  return 1
}

proc update_ed_fileset_synthesis {arg} {
    set ENABLE_ED_FILESET_SYNTHESIS [get_parameter_value $arg]
    
    if {$ENABLE_ED_FILESET_SYNTHESIS == 0} {
       set_parameter_value SELECT_TARGETED_DEVICE 3
	   set_parameter_value SELECT_CUSTOM_DEVICE 0
    }
}

proc elaboration_callback {} {
    set num_lanes [get_parameter_value lanes]
    set dir [get_parameter_value direction]
    set cmode [get_parameter_value gui_clocking_mode]
    set dev_fam  [get_parameter_value system_family]
    set en_seventeeng [get_parameter_value enable_seventeeng]
    set pll_freq      [get_parameter_value gui_pll_ref_freq]
    set mf            [get_parameter_value meta_frame_length]
    set user_input    [get_parameter_value gui_user_input]	
	
    if {$dev_fam == "Arria 10"} {
        set_parameter_value DEVKIT_DEVICE "10AX115S4F45E3SGE3"
    } elseif {$dev_fam == "Stratix V"} {
        set_parameter_value DEVKIT_DEVICE "5SGXEA7N2F40C2"
    }
    
    if {$dev_fam == "Stratix V"} {
       set_parameter_property SELECT_TARGETED_DEVICE allowed_ranges { "1:Stratix V GX Transceiver Signal Integrity Development Kit" "2:Custom Development Kit" "3:No Development Kit"}
    } elseif {$dev_fam == "Arria V GZ"} {
       set_parameter_property SELECT_TARGETED_DEVICE allowed_ranges { "1:No Development Kit" "2:No Development Kit" "3:No Development Kit"}
    }
	
# Instantiate Native PHY and TX-PLL dynamically for A10
if {$dev_fam == "Arria 10"}  {
# update pll_ref_freq
    set xcvr_clk_freq [get_parameter_value pll_ref_freq]
    if { $xcvr_clk_freq == "none" }  {
        set xcvr_clk_freq "1"
    } else {

    set xcvr_clk_freq_mhz [get_parameter_value pll_ref_freq]
    set xcvr_clk_freq [string trimright $xcvr_clk_freq_mhz " MHz"]
    }
    set xcvr_out_freq [format %.4f [expr [get_parameter_value lane_rate_parameter]*500]]
    set xcvr_out_rate [format %.4f [expr [get_parameter_value lane_rate_parameter]*1000]]
    set mfl [get_parameter_value meta_frame_length]
    if {$num_lanes == 1 } {
    set bonding_mode "not_bonded" 	    
    } else {
    set bonding_mode "pma_only" 	    
    }
   # Set param depeding upon DUPLEX/TX/RX
    if {$dir == "Source"} {
     set plex_mode "tx" 	    
     set inst_name "native_ilk_wrapper_tx" 
    } elseif {$dir == "Sink"} {
     set plex_mode "rx" 	    
     set inst_name "native_ilk_wrapper_rx"
    } else {
     set plex_mode "duplex" 	    
     set inst_name "native_ilk_wrapper"
    }	
    
    if { $cmode == "false" }  {
      set iopll_ref      [get_parameter_value int_reference_clock_frequency]
      set core_clk_freq [get_parameter_value gui_coreclkin_frequency]
      if {$user_input == 0} {
          set user_clk_freq [get_parameter_value gui_user_clock_frequency]
      } else {
          set user_clk_freq [format %.6f [expr [get_parameter_value lane_rate_parameter]*1000/1.1/64]]
      }
      set speedgrade_val    [get_parameter_value "speedgrade"]
      set valid_closest_lower_outclk_iopll [format %.6f [expr [get_nearest_achievable_frequency $user_clk_freq $iopll_ref $speedgrade_val]]]
      send_message INFO "IOPLL closest lower frequency found: $valid_closest_lower_outclk_iopll"
      #set user_select_freq [get_parameter_value gui_user_clock_freq_sel]
      if { $valid_closest_lower_outclk_iopll != $user_clk_freq } {
          send_message WARNING "Able to implement IOPLL - Actual user clock settings differ from Requested settings"
          set user_clock_sel_freq $valid_closest_lower_outclk_iopll
      } else {
          set user_clock_sel_freq $user_clk_freq
      }

      add_hdl_instance altera_iopll_inst altera_iopll
      set_instance_parameter_value altera_iopll_inst system_info_device_family "Arria 10"
      set_instance_parameter_value altera_iopll_inst system_info_device_component [get_parameter_value "part_trait_device"]
      set_instance_parameter_value altera_iopll_inst system_info_device_speed_grade [get_parameter_value "device_speed_grade"]
      set_instance_parameter_value altera_iopll_inst system_part_trait_speed_grade [get_parameter_value "part_trait_device"]
      set_instance_parameter_value altera_iopll_inst gui_device_speed_grade [get_parameter_value "speedgrade"]
      set param_val_list [list gui_reference_clock_frequency $iopll_ref gui_number_of_clocks 1 gui_output_clock_frequency0 $user_clock_sel_freq]
      foreach {param val} $param_val_list {
        set_instance_parameter_value altera_iopll_inst $param $val
      } 
 
      set_parameter_value gui_actual_user_clock_frequency [format %.6f [expr ($user_clk_freq)]]
      set_parameter_value gui_actual_coreclkin_frequency  [format %.6f [expr ($core_clk_freq)]]
    }   

   #ADME option 
   set rcfg_jtag_enable           [get_parameter_value rcfg_jtag_enable]
   if { $rcfg_jtag_enable == "false"} {
   set xcvr_capability_reg_en   "false"
   set xcvr_set_user_identifier 0
   set xcvr_csr_soft_log_en     "false"
   set xcvr_prbs_soft_log_en    "false" 
   } else {
   set xcvr_capability_reg_en [get_parameter_value xcvr_capability_reg_en]
   set xcvr_set_user_identifier [get_parameter_value xcvr_capability_reg_en]
   set xcvr_csr_soft_log_en [get_parameter_value xcvr_csr_soft_log_en]
   set xcvr_prbs_soft_log_en  [get_parameter_value xcvr_prbs_soft_log_en]
   }

    add_hdl_instance $inst_name altera_xcvr_native_a10 
    set_instance_property $inst_name HDLINSTANCE_USE_GENERATED_NAME 1
    set_instance_parameter_value $inst_name BASE_DEVICE [get_parameter_value "part_trait_bd"]
    set_instance_parameter_value $inst_name device [get_parameter_value "DEVICE"]
    set_instance_parameter_value $inst_name   protocol_mode interlaken_mode 
    set_instance_parameter_value $inst_name   rcfg_enable 1
    set_instance_parameter_value $inst_name   rcfg_jtag_enable           [get_parameter_value rcfg_jtag_enable]
    set_instance_parameter_value $inst_name   set_capability_reg_enable  $xcvr_capability_reg_en
    set_instance_parameter_value $inst_name   set_user_identifier        $xcvr_set_user_identifier
    set_instance_parameter_value $inst_name   set_csr_soft_logic_enable  $xcvr_csr_soft_log_en
    set_instance_parameter_value $inst_name   set_prbs_soft_logic_enable $xcvr_prbs_soft_log_en

	
    if { $num_lanes == 1 } {
      set_instance_parameter_value $inst_name   rcfg_shared 0 
    } else {
      set_instance_parameter_value $inst_name   rcfg_shared 1
    }
	
    set_instance_parameter_value $inst_name   enh_pcs_pma_width 64
    set_instance_parameter_value $inst_name   message_level "warning" 
    set_instance_parameter_value $inst_name   duplex_mode $plex_mode
    set_instance_parameter_value $inst_name   channels $num_lanes
    set_instance_parameter_value $inst_name   set_data_rate $xcvr_out_rate 
    set_instance_parameter_value $inst_name   bonded_mode not_bonded
    set_instance_parameter_value $inst_name   enh_pld_pcs_width 67
    set_instance_parameter_value $inst_name   enable_port_tx_pma_iqtxrx_clkout 1
    set_instance_parameter_value $inst_name   enable_port_rx_pma_iqtxrx_clkout 1

    if {$dir == "Source" || $dir == "Duplex"} {
    set_instance_parameter_value $inst_name   enh_txfifo_mode Interlaken 
    set_instance_parameter_value $inst_name   enh_txfifo_pfull 11 
    set_instance_parameter_value $inst_name   enh_txfifo_pempty 7
    set_instance_parameter_value $inst_name   enable_port_tx_enh_fifo_full 1 
    set_instance_parameter_value $inst_name   enable_port_tx_enh_fifo_pfull 1 
    set_instance_parameter_value $inst_name   enable_port_tx_enh_fifo_empty 1 
    set_instance_parameter_value $inst_name   enable_port_tx_enh_fifo_pempty 1 
    set_instance_parameter_value $inst_name   enh_tx_frmgen_enable 1 
    set_instance_parameter_value $inst_name   enh_tx_frmgen_mfrm_length $mfl 
    set_instance_parameter_value $inst_name   enh_tx_frmgen_burst_enable 1 
    set_instance_parameter_value $inst_name   enable_port_tx_enh_frame 1 
    set_instance_parameter_value $inst_name   enable_port_tx_enh_frame_diag_status 1 
    set_instance_parameter_value $inst_name   enable_port_tx_enh_frame_burst_en 1 
    set_instance_parameter_value $inst_name   enh_tx_crcgen_enable 1 
    set_instance_parameter_value $inst_name   enh_tx_crcerr_enable 1 
    set_instance_parameter_value $inst_name   enh_tx_scram_enable 1 
    set_instance_parameter_value $inst_name   enh_tx_scram_seed 81985529216486895 
    set_instance_parameter_value $inst_name   enh_tx_dispgen_enable 1 
    }

    if {$dir == "Sink" || $dir == "Duplex"} {
    set_instance_parameter_value $inst_name   set_cdr_refclk_freq $xcvr_clk_freq 
    set_instance_parameter_value $inst_name   enable_ports_rx_manual_cdr_mode 1 
    set_instance_parameter_value $inst_name   enable_port_rx_seriallpbken 1 
    set_instance_parameter_value $inst_name   enh_rxfifo_mode Interlaken 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_data_valid 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_fifo_full 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_fifo_pfull 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_fifo_empty 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_fifo_pempty 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_fifo_rd_en 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_fifo_align_val 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_fifo_align_clr 1 
    set_instance_parameter_value $inst_name   enh_rx_frmsync_enable 1 
    set_instance_parameter_value $inst_name   enh_rx_frmsync_mfrm_length $mfl 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_frame 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_frame_lock 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_frame_diag_status 1 
    set_instance_parameter_value $inst_name   enh_rx_crcchk_enable 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_crc32_err 1 
    set_instance_parameter_value $inst_name   enh_rx_descram_enable 1 
    set_instance_parameter_value $inst_name   enh_rx_dispchk_enable 1 
    set_instance_parameter_value $inst_name   enh_rx_blksync_enable 1 
    set_instance_parameter_value $inst_name   enable_port_rx_enh_blk_lock 1 
    }

    #set allowed_ranges {}
    #set ref ""
    set all_freqs {"none"}
    catch { 
    set ref [get_instance_parameter_value $inst_name l_pll_settings] 
    set all_freqs [dict get $ref "allowed_ranges"]
    #send_message INFO "All freqs: $all_freqs"
    }

    #if { $plex_mode == "Source" } {
    #}
    ## Fix FB 284723, disable gui_pll_ref_freq when direction is Source and A10, allowed range of any value if condition is true
    if { $dir == "Source" && $dev_fam == "Arria 10"} {
        set_parameter_property gui_pll_ref_freq ALLOWED_RANGES {}
    } else {
        set_parameter_property gui_pll_ref_freq ALLOWED_RANGES $all_freqs
    }


    if {$dir == "Sink" || $dir == "Duplex"} {
      # Add ATX  TX PLLs for Example TB
      add_hdl_instance a10_atx_pll altera_xcvr_atx_pll_a10
      set_instance_parameter_value a10_atx_pll BASE_DEVICE [get_parameter_value "part_trait_bd"]
      set_instance_parameter_value a10_atx_pll device [get_parameter_value "DEVICE"]
      set_instance_parameter_value a10_atx_pll device_family "Arria 10" 
      set_instance_parameter_value a10_atx_pll set_output_clock_frequency $xcvr_out_freq
      set_instance_parameter_value a10_atx_pll set_auto_reference_clock_frequency $xcvr_clk_freq 
    }

    # Ensure parameters in child-instances added using add_hdl_instance get validated. Refer to case:281341 for details.
    if {$cmode == "false"} {
        set dummy_var_2 [get_instance_parameter_value "altera_iopll_inst" system_info_device_component]
        set outclk_freq [get_instance_parameter_value "altera_iopll_inst" output_clock_frequency0]
        send_message INFO "IOPLL actual frequencies = $outclk_freq"
        regexp {[0-9]+ *\. *[0-9]+} $outclk_freq actual_outclk 
        set_parameter_value gui_actual_user_clock_frequency [format %.6f [expr ($actual_outclk)]]
        
    }
    set dummy_var_0 [get_instance_parameter_value $inst_name BASE_DEVICE]
    if {$dir == "Sink" || $dir == "Duplex"} {
    set dummy_var_1 [get_instance_parameter_value "a10_atx_pll" BASE_DEVICE]
    }
}

    #Adding common ports
    #Add Asynchronous reset
    add_interface core_reset reset sink
    add_interface_port core_reset core_reset reset input 1
    set_interface_property core_reset synchronousEdges NONE

    #Adding Phy Mgmt Clk and Reset
    add_interface phy_mgmt_clk clock sink
    add_interface_port phy_mgmt_clk phy_mgmt_clk clk input 1
    add_interface phy_mgmt_clk_reset reset sink
    add_interface_port phy_mgmt_clk_reset phy_mgmt_clk_reset reset Input 1
    set_interface_property phy_mgmt_clk_reset associatedClock phy_mgmt_clk
    ##Adding PHY_MGMT interface
    add_interface phy_mgmt avalon slave 
    if {$dev_fam == "Arria 10"} {
        if {$num_lanes == 1} {	    
        set decode_msb  0
    } else  {
        set decode_msb [::alt_xcvr::utils::common::clogb2 [expr {$num_lanes-1}]]
        } 
    set mgmt_addr_width [expr {11+ $decode_msb}  ]
    } else {
    set mgmt_addr_width 9 	    
    }	    
    set_parameter_value ADDR_WIDTH  $mgmt_addr_width
    add_interface_port phy_mgmt phy_mgmt_address address input $mgmt_addr_width
    add_interface_port phy_mgmt phy_mgmt_read read input 1
    add_interface_port phy_mgmt phy_mgmt_readdata readdata output 32
    add_interface_port phy_mgmt phy_mgmt_write write input 1
    add_interface_port phy_mgmt phy_mgmt_writedata writedata input 32
    add_interface_port phy_mgmt phy_mgmt_waitrequest waitrequest output 1
    set_interface_property phy_mgmt associatedClock phy_mgmt_clk
    set_interface_property phy_mgmt associatedReset phy_mgmt_clk_reset
    #
    # Add serial-clock port if enbale_pll is not turned on
    if {$dir != "Sink"} {
     add_interface tx_serial_clk conduit sink
     add_interface_port tx_serial_clk tx_serial_clk clk input $num_lanes
     add_interface tx_pll_locked conduit sink
     add_interface_port tx_pll_locked tx_pll_locked conduit input 1
      if {$dev_fam != "Arria 10"}  {
      set_port_property tx_serial_clk TERMINATION "true"	       
      set_port_property tx_serial_clk TERMINATION_VALUE 0	       
      set_port_property tx_pll_locked TERMINATION "true"	       
      set_port_property tx_pll_locked TERMINATION_VALUE 0	       
      } 
    }

    add_interface xcvr_pll_ref_clk clock sink
    add_interface_port xcvr_pll_ref_clk xcvr_pll_ref_clk clk input 1
    if {$dev_fam == "Arria 10" && $dir == "Source"} {
        set_port_property xcvr_pll_ref_clk TERMINATION "true"	       
        set_port_property xcvr_pll_ref_clk TERMINATION_VALUE 0	               
    }
    #common_existing_interface reconfig_busy clock start input 1 
    add_interface reconfig_busy clock sink
    add_interface_port reconfig_busy reconfig_busy clk input 1

    if {$dir == "Source"} { 
	set port_dir_1 "input"
	set port_dir_2 "output"
    } elseif {$dir == "Sink"} {
	set port_dir_1 "output"
	set port_dir_2 "input"
    } elseif {$dir == "Duplex"} {
        add_duplex_ports
	return
    }

   
    common_add_interface data conduit $port_dir_1 [expr $num_lanes*64] true   
    common_add_interface sync conduit $port_dir_1 8 true   
    common_add_interface valid conduit $port_dir_1 1 true   
    common_add_interface start_of_burst conduit $port_dir_1 1 true
    common_add_interface end_of_burst conduit $port_dir_1 1 true
    common_add_interface link_up conduit output 1 true
  
    # clocking mode specific ports
    if { $cmode == "true" }  {
      if { $dir == "Source" } {
        #common_existing_interface user_clock_reset reset start input 1 
        #common_existing_interface user_clock clock start input 1 
        add_interface user_clock clock sink
        add_interface_port user_clock user_clock clk Input 1
        add_interface user_clock_reset reset sink
        add_interface_port user_clock_reset user_clock_reset reset Input 1
        set_interface_property user_clock_reset associatedClock user_clock
		
        common_add_interface interface_clock_reset conduit output 1 true
      } elseif { $dir == "Sink" } {
       # common_existing_interface interface_clock_reset reset end output 1 
       # common_existing_interface interface_clock clock end output 1 
        add_interface interface_clock clock source
        add_interface_port interface_clock interface_clock clk output 1
        #add_interface interface_clock_reset reset source
        #add_interface_port interface_clock_reset interface_clock_reset reset Output 1
        #set_interface_property interface_clock_reset associatedClock interface_clock

        common_add_interface interface_clock_reset conduit output 1 true

      } elseif { $dir == "Duplex" } {
        #add_interface user_clock_tx clock sink
        #add_interface_port user_clock user_clock clk Input 1
        #add_interface user_clock_reset_tx reset sink
        #add_interface_port user_clock_reset_tx user_clock_reset_tx reset Input 1
        #set_interface_property user_clock_reset_tx associatedClock user_clock_tx
        #add_interface interface_clock_rx clock source
        #add_interface_port interface_clock_rx interface_clock_rx clk output 1
        #add_interface interface_clock_reset_rx reset source
        #add_interface_port interface_clock_reset_rx interface_clock_reset_rx reset Output 1
        #set_interface_property interface_clock_reset_rx associatedClock interface_clock_rx
      }
    } else {
      #if { $dir == "Duplex" } {
      #  add_interface user_clock_tx clock source
      #  add_interface_port user_clock_tx user_clock_tx clk output 1
      #  add_interface user_clock_reset_tx reset source
      #  add_interface_port user_clock_reset_tx user_clock_reset_tx reset Output 1
      #  set_interface_property user_clock_reset_tx associatedClock user_clock_tx

      #  add_interface user_clock_rx clock source
      #  add_interface_port user_clock_rx user_clock_rx clk output 1
      #  add_interface user_clock_reset_rx reset source
      #  add_interface_port user_clock_reset_rx user_clock_reset_rx reset Output 1
      #  set_interface_property user_clock_reset_rx associatedClock user_clock_rx

      #} else {
        #common_existing_interface user_clock_reset reset end output 1 
        #common_existing_interface user_clock clock end output 1
        add_interface user_clock clock source
        add_interface_port user_clock user_clock clk Output 1
       
        # http://sw-wiki.altera.com/twiki/bin/view/Software/RtlToHwTclIp#Describing_your_IP_s_ports_as_in
        # The commented code below is not working even though we are doing according to above wiki guidelines
        #add_interface user_clock_reset reset source
        #add_interface_port user_clock_reset user_clock_reset reset Output 1
        #set_interface_property user_clock_reset associatedClock user_clock
        
        common_add_interface user_clock_reset conduit output 1 true
      #}
    }

    #Adding direction specific ports
    if {$dir == "Source"} {    
#      if { $cmode == "true" }  {
        common_add_interface error conduit output 4 true
#      } else {
#        common_add_interface error conduit output 3 true
#      }
      common_add_interface crc_error_inject conduit input 1 true
      common_add_interface tx_serial_data conduit output lanes true
        if {$dev_fam != "Arria 10"} {
         common_add_interface reconfig_to_xcvr conduit input [expr $num_lanes*140] true
         common_add_interface reconfig_from_xcvr conduit output [expr $num_lanes*92] true		
        } 	
      		
    } elseif { $dir == "Sink"} {

      common_add_interface error conduit output [expr $num_lanes + 5] true
      common_add_interface rx_serial_data conduit input lanes true
        if {$dev_fam != "Arria 10"} {
         common_add_interface reconfig_to_xcvr conduit input [expr $num_lanes*70] true
         common_add_interface reconfig_from_xcvr conduit output [expr $num_lanes*46] true		
        } 		
      
    }
    ## Adding Reconfig Interface for VHDL Sim
    if { $dev_fam == "Arria 10"} {  
         add_interface reconfig_to_xcvr conduit sink
         add_interface reconfig_from_xcvr conduit source
         if { $dir == "Source" } {
             set rbus_to_xcvr [expr $num_lanes*140]
             set rbus_from_xcvr [expr $num_lanes*92]
           } else {
             set rbus_to_xcvr [expr $num_lanes*70]
             set rbus_from_xcvr [expr $num_lanes*46]
         }
         add_interface_port reconfig_to_xcvr reconfig_to_xcvr conduit input $rbus_to_xcvr
         add_interface_port reconfig_from_xcvr reconfig_from_xcvr conduit output $rbus_from_xcvr
         set_port_property reconfig_to_xcvr TERMINATION "true"
         set_port_property reconfig_to_xcvr TERMINATION_VALUE 0
         set_port_property reconfig_from_xcvr TERMINATION "true"
       } 
}

proc add_duplex_ports { } {

    set num_lanes [get_parameter_value lanes]
    set cmode [get_parameter_value gui_clocking_mode]
    set dev_fam  [get_parameter_value system_family]
       
    if { $cmode == "true" }  {   
        add_interface user_clock_tx clock sink
        add_interface_port user_clock_tx user_clock_tx clk Input 1
        add_interface user_clock_reset_tx reset sink
        add_interface_port user_clock_reset_tx user_clock_reset_tx reset Input 1
        set_interface_property user_clock_reset_tx associatedClock user_clock_tx
        add_interface interface_clock_rx clock source
        add_interface_port interface_clock_rx interface_clock_rx clk output 1
        #add_interface interface_clock_reset_rx reset source
        #add_interface_port interface_clock_reset_rx interface_clock_reset_rx reset Output 1
        #set_interface_property interface_clock_reset_rx associatedClock interface_clock_rx
        common_add_interface interface_clock_reset_rx conduit output 1 true
        common_add_interface interface_clock_reset_tx conduit output 1 true
        
	common_add_interface error_tx conduit output 4 true
    } else {
        add_interface user_clock_tx clock source
        add_interface_port user_clock_tx user_clock_tx clk output 1
        #add_interface user_clock_reset_tx reset source
        #add_interface_port user_clock_reset_tx user_clock_reset_tx reset Output 1
        #set_interface_property user_clock_reset_tx associatedClock user_clock_tx
        common_add_interface user_clock_reset_tx conduit output 1 true

        add_interface user_clock_rx clock source
        add_interface_port user_clock_rx user_clock_rx clk output 1
        #add_interface user_clock_reset_rx reset source
        #add_interface_port user_clock_reset_rx user_clock_reset_rx reset Output 1
        #set_interface_property user_clock_reset_rx associatedClock user_clock_rx
        common_add_interface user_clock_reset_rx conduit output 1 true     
	common_add_interface error_tx conduit output 4 true
    }
   
    common_add_interface crc_error_inject conduit input 1 true
    common_add_interface data_tx conduit input [expr $num_lanes*64] true   
    common_add_interface sync_tx conduit input 8 true   
    common_add_interface valid_tx conduit input 1 true   
    common_add_interface start_of_burst_tx conduit input 1 true
    common_add_interface end_of_burst_tx conduit input 1 true
    common_add_interface link_up_tx conduit output 1 true

    common_add_interface data_rx conduit output [expr $num_lanes*64] true   
    common_add_interface sync_rx conduit output 8 true   
    common_add_interface valid_rx conduit output 1 true   
    common_add_interface start_of_burst_rx conduit output 1 true
    common_add_interface end_of_burst_rx conduit output 1 true
    common_add_interface link_up_rx conduit output 1 true
    common_add_interface error_rx conduit output [expr $num_lanes + 5] true
    common_add_interface tx_serial_data conduit output lanes true
    common_add_interface rx_serial_data conduit input lanes true
  
    if {$dev_fam != "Arria 10"} {
      common_add_interface reconfig_to_xcvr conduit input [expr $num_lanes*140] true
      common_add_interface reconfig_from_xcvr conduit output [expr $num_lanes*92] true
    } else { 
      ## Adding Reconfig Interface for VHDL Sim
      add_interface reconfig_to_xcvr conduit sink
      add_interface reconfig_from_xcvr conduit source
      add_interface_port reconfig_to_xcvr reconfig_to_xcvr conduit input [expr $num_lanes*140]
      add_interface_port reconfig_from_xcvr reconfig_from_xcvr conduit output [expr $num_lanes*92]

      set_port_property reconfig_to_xcvr TERMINATION "true"	       
      set_port_property reconfig_to_xcvr TERMINATION_VALUE 0 
      set_port_property reconfig_from_xcvr TERMINATION "true"
    }
	
}


proc common_existing_interface { port_name type port_dir signal width } {
      add_interface $port_name $type $port_dir
      set_interface_assignment $port_name ui.blockdiagram.direction $signal
      add_interface_port $port_name $port_name $type $signal $width
      if {$port_dir == "input"} {
		set_port_property $port_name TERMINATION_VALUE 0
      }
}
proc common_add_interface { port_name type port_dir width tags } {
	array set in_out [list {output} {start} {input} {end} ]
	add_interface $port_name $type $in_out($port_dir)
	set_interface_assignment $port_name "ui.blockdiagram.direction" $port_dir
	#set_interface_property $port_name ENABLED $used
	common_add_interface_port $port_name $port_name export $port_dir $width $tags
	if {$port_dir == "input"} {
		set_port_property $port_name TERMINATION_VALUE 0
	}
}

proc common_add_file {file_ {path ""} {file_name ""} } {
	set file_string [split $file_ /]
	if {$file_name == ""} {
          set file_name [lindex $file_string end]
	}
	if {[regexp {.sv} $file_name]} { 
	  add_fileset_file "$path$file_name" SYSTEM_VERILOG PATH ${file_}
          send_message INFO "Adding system verilog file $file_ as $file_name"
	} elseif {[regexp {.v} $file_name]} { 
	  add_fileset_file "$path$file_name" VERILOG PATH ${file_}
          send_message INFO "Adding verilog file $file_ as $file_name"
        } elseif {[regexp {.sdc} $file_name]} {
	  add_fileset_file $path$file_name SDC PATH ${file_}
          send_message INFO "Adding sdc file $file_ as $file_name"
        } else {
          add_fileset_file "$path$file_name" OTHER PATH ${file_} 
          send_message INFO "Adding file $file_ as $$path$file_name"
	}
}

proc common_add_file_sim {file_ {path ""} {file_name ""} } {
    set file_string [split $file_ /]
    if {$file_name == ""} {
	set file_name [lindex $file_string end]
    }
    if {[regexp {mentor} $path]} {
	add_fileset_file "$path$file_name" VERILOG_ENCRYPT PATH ${file_} MENTOR_SPECIFIC
        send_message INFO "Adding Mentor Encrypted file $file_ as $file_name"
    } elseif {[regexp {synopsys} $path]} {
	add_fileset_file "$path$file_name" VERILOG_ENCRYPT PATH  ${file_} SYNOPSYS_SPECIFIC
        send_message INFO "Adding Synopsys Encrypted file $file_ as $file_name"
    } elseif {[regexp {cadence} $path]} {
	add_fileset_file $path$file_name VERILOG_ENCRYPT PATH ${file_} CADENCE_SPECIFIC
        send_message INFO "Adding Cadence Encrypted file file $file_ as $file_name"
    } elseif {[regexp {aldec} $path]} {
	add_fileset_file $path$file_name VERILOG_ENCRYPT PATH ${file_} ALDEC_SPECIFIC
        send_message INFO "Adding Aldec Encrypted file file $file_ as $file_name"
    } 
}

proc synth_proc {outputName} {
   send_message INFO "Adding Synthesis files"
   set dest_path       "./"
   set tmpdir "."
   set cmode [get_parameter_value gui_clocking_mode]
   set dir [get_parameter_value direction]
   set ecc_mode  [get_parameter_value gui_ecc_enable]
   set df  [get_parameter_value system_family]
   set addr_width [get_parameter_value ADDR_WIDTH]
   set lanes   [get_parameter_value lanes]
   set fifo_depth [get_parameter_value adaptation_fifo_depth]
   set pll_ref_freq [get_parameter_value pll_ref_freq]
   set data_rate  [get_parameter_value data_rate]
   set mf      [get_parameter_value meta_frame_length]
   set burstgap [get_parameter_value "BURST_GAP"]
   set pll_type [get_parameter_value pll_type]
   set ref_freq [get_parameter_value reference_clock_frequency]
   set ccf_val [get_parameter_value gui_actual_coreclkin_frequency]
   set icf_val [get_parameter_value gui_interface_clock_frequency]
   set user_input [get_parameter_value gui_user_input]
   
   if {$dir == "Source"} {
      set inst_name "native_ilk_wrapper_tx" 
   } elseif {$dir == "Sink"} {   
      set inst_name "native_ilk_wrapper_rx"
   } else {	    
      set inst_name "native_ilk_wrapper"
   }

   if {$user_input == 0} {
      set ucf_val [get_parameter_value gui_user_clock_frequency]
   } else {
      set ucf_val [get_parameter_value gui_actual_user_clock_frequency]
   }
   
   if {$df == "Arria 10"} {
      set random_str [get_instance_property $inst_name HDLINSTANCE_GET_GENERATED_NAME]
      set params_ip(module_name) ${outputName}
      set params_ip(instance_name) "_${random_str}"
      
      #Do Terp for interlaken_native_wrapper_duplex.v.terp
      set template_inwd_path [ file join "common/" "interlaken_native_wrapper_duplex.v.terp" ]  
      set template_inwd_terpfile   [ read [ open $template_inwd_path r ] ]
      set params(instance_name) $random_str
      set result_inwd_file   [ altera_terp $template_inwd_terpfile params ]
   } else {
      set params_ip(instance_name) ""
	  set params_ip(module_name) ${outputName}  
   }
    
   set params_ip(device_family) "$df"
   set params_ip(addr_width)    $addr_width
   set params_ip(lanes)         $lanes 
   set params_ip(enable_tx_pll) "0"
   set params_ip(fifo_depth)    $fifo_depth
   set params_ip(freq)          "$pll_ref_freq"
   set params_ip(data_rate)     "$data_rate"
   set params_ip(mf_length)     $mf 
   set params_ip(burst_gap)     $burstgap
   set params_ip(ref_freq)      "$ref_freq"
   set params_ip(cclk_freq)     "$ccf_val MHz"
   set params_ip(user_freq)     "$ucf_val MHz"
   set params_ip(pll_type)      "$pll_type"
   
   if {$ecc_mode == "false"} {
      set params_ip(enable_ecc) "0"
   } else {
      set params_ip(enable_ecc) "1"
   }
  	
    if {$cmode == "true"} {
      add_fileset_file "source_absorber.v" VERILOG PATH  "common/source_absorber.v"
    } else {
      add_fileset_file "clock_gen.v" VERILOG PATH  "common/clock_gen.v"
    }
    
	######## SDC generation through terp ########
	
    set template_file [ file join "common/" "seriallite_iii_streaming_a10.sdc.terp" ]
	set template_file_sink_v [ file join "sink/" "seriallite_iii_streaming_sink.sdc.terp" ] 
	set template_file_source_v [ file join "source/" "seriallite_iii_streaming_source.sdc.terp" ] 
    set template      [ read [ open $template_file r ] ]
	set template_sink_v [ read [ open $template_file_sink_v r ] ]
	set template_source_v [ read [ open $template_file_source_v r ] ]
    set paramsdc(cmode) $cmode
	set paramsdc(ecc_mode) $ecc_mode
	set paramsdc(direction)   $dir
	set paramsdc(user_freq)   $ucf_val
	set paramsdc(coreclk_freq) $ccf_val
	set paramsdc(ifclk_freq)   $icf_val
	set paramsdc(module_name) $outputName

    set result        [ altera_terp $template paramsdc ]
	set result_sink   [ altera_terp $template_sink_v paramsdc ]
	set result_source [ altera_terp $template_source_v paramsdc ]
	
    #Do Terp for seriallite_iii_streaming.v.terp
    if {$dir == "Duplex"} {
       if {$cmode == "true"} {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_duplex_ac.v.terp" ]
       } else {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_duplex_nc.v.terp" ]
       }		  
    } elseif {$dir == "Sink"} {
       if {$cmode == "true"} {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_sink_ac.v.terp" ]
       } else {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_sink_nc.v.terp" ]
       }
    } else {
       if {$cmode == "true"} {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_source_ac.v.terp" ]
       } else {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_source_nc.v.terp" ]
       }
    }
	
    set sl3_inwd_terpfile   [ read [ open $sl3_inwd_path r ] ]
    set sl3_inwd_file   [ altera_terp $sl3_inwd_terpfile params_ip ]        	
			
    if {$df == "Stratix V"} {
       add_fileset_file "clkctrl.v" VERILOG PATH  "common/clkctrl_sv.v"
       add_fileset_file "interlaken_phy_ip_duplex.v" VERILOG PATH  "common/interlaken_phy_ip_duplex.v"
	   
	   if { $dir == "Sink"} {
	      add_fileset_file "seriallite_iii_streaming_sink.sdc" SDC TEXT $result_sink 
	   } elseif {$dir == "Source"} {
          add_fileset_file "seriallite_iii_streaming_source.sdc" SDC TEXT $result_source  
       } else {
          add_fileset_file "seriallite_iii_streaming_sink.sdc" SDC TEXT $result_sink    
          add_fileset_file "seriallite_iii_streaming_source.sdc" SDC TEXT $result_source 
       }  
    } elseif {$df == "Arria V GZ"} {
       add_fileset_file "clkctrl.v" VERILOG PATH  "common/clkctrl_av.v"
       add_fileset_file "interlaken_phy_ip_duplex.v" VERILOG PATH  "common/interlaken_phy_ip_duplex.v"
	   
	   if { $dir == "Sink"} {
	      add_fileset_file "seriallite_iii_streaming_sink.sdc" SDC TEXT $result_sink 
	   } elseif {$dir == "Source"} {
          add_fileset_file "seriallite_iii_streaming_source.sdc" SDC TEXT $result_source  
       } else {
          add_fileset_file "seriallite_iii_streaming_sink.sdc" SDC TEXT $result_sink    
          add_fileset_file "seriallite_iii_streaming_source.sdc" SDC TEXT $result_source 
       }  
    } elseif {$df == "Arria 10"} {  
       add_fileset_file "interlaken_native_wrapper_duplex$params(instance_name).v" VERILOG TEXT $result_inwd_file 
       add_fileset_file seriallite_iii_streaming.sdc SDC TEXT $result
       add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH "$::env(QUARTUS_ROOTDIR)/../ip/altera/primitives/altera_std_synchronizer/altera_std_synchronizer_nocut.v"
    }

    if {$cmode == "true"} {
       add_fileset_file "debug/stp/sl3_acm.xml" OTHER PATH "debug_stp/sl3_acm.xml.txt"
    } else {
       add_fileset_file "debug/stp/sl3_scm.xml" OTHER PATH "debug_stp/sl3_scm.xml.txt"       
    }
    
    add_fileset_file "debug/stp/build_stp.tcl" OTHER PATH "debug_stp/build_stp.tcl"
    add_fileset_file $outputName.v      VERILOG TEXT $sl3_inwd_file 
    add_fileset_file "aclr_filter.v"    VERILOG PATH "common/aclr_filter.v"
    add_fileset_file "dcfifo_s5m20k.v"  VERILOG PATH "common/dcfifo_s5m20k.v"
    add_fileset_file "delay_regs.v"     VERILOG PATH "common/delay_regs.v"
    add_fileset_file "eq_5_ena.v"       VERILOG PATH "common/eq_5_ena.v"
    add_fileset_file "gray_cntr_5_sl.v" VERILOG PATH "common/gray_cntr_5_sl.v"
    add_fileset_file "gray_to_bin_5.v"  VERILOG PATH "common/gray_to_bin_5.v"
    add_fileset_file "neq_5_ena.v"      VERILOG PATH "common/neq_5_ena.v"
    add_fileset_file "s5m20k_ecc_1r1w.v" VERILOG PATH "common/s5m20k_ecc_1r1w.v"
    add_fileset_file "sync_regs_aclr_m2.v" VERILOG PATH "common/sync_regs_aclr_m2.v"
    add_fileset_file "wys_lut.v"        VERILOG PATH "common/wys_lut.v"
    add_fileset_file "core_reset_logic.v"        VERILOG PATH "common/core_reset_logic.v"
    add_fileset_file "dp_hs_req.v"      VERILOG PATH "common/dp_hs_req.v"   
    add_fileset_file "dp_hs_resp.v"     VERILOG PATH "common/dp_hs_resp.v"
    add_fileset_file "dp_sync.v"        VERILOG PATH "common/dp_sync.v" 

    add_fileset_file "alt_xcvr_csr_common_h.sv" SYSTEM_VERILOG PATH  "common/header/alt_xcvr_csr_common_h.sv"   
    send_message INFO "Adding system verilog file common/header/alt_xcvr_csr_common_h.sv  as alt_xcvr_csr_common_h.sv"

    add_fileset_file "alt_xcvr_csr_pcs8g_h.sv" SYSTEM_VERILOG PATH "common/header/alt_xcvr_csr_pcs8g_h.sv"
    add_fileset_file "sv_xcvr_h.sv" SYSTEM_VERILOG PATH "common/header/sv_xcvr_h.sv"
    add_fileset_file "altera_xcvr_functions.sv" SYSTEM_VERILOG PATH "common/header/altera_xcvr_functions.sv"
    
    
    if {$df == "Arria 10"} {
         set folder_lst   {"common/a10_native"}
         add_fileset_file altera_xcvr_reset_control.sv   SYSTEM_VERILOG PATH    ${tmpdir}/../../alt_xcvr/altera_xcvr_reset_control/altera_xcvr_reset_control.sv        
         add_fileset_file alt_xcvr_reset_counter.sv      SYSTEM_VERILOG PATH    ${tmpdir}/../../alt_xcvr/altera_xcvr_reset_control/alt_xcvr_reset_counter.sv
         add_fileset_file alt_xcvr_resync.sv             SYSTEM_VERILOG PATH    ${tmpdir}/../../altera_xcvr_generic/ctrl/alt_xcvr_resync.sv
    } else {  	  
        set folder_lst   {"common/phyip"}
   }	
         foreach subDir ${folder_lst} {
         send_message INFO "Processing folder: $subDir"
           set file_lst [glob -nocomplain -- -path $subDir/*]
           send_message INFO $file_lst
           foreach file ${file_lst} {       
             set     is_dir  [file isdirectory $file]
             set     is_tcl  [regexp {tcl} $file]
                 if {$is_dir == 1} {
                     send_message INFO "Ignoring $file for synth"
                     #lappend SubDirList $file
                 } else {
                     common_add_file $file
                 }
             }
         }
	
   # add direction specific files
   if {$dir == "Sink" } {
      set folder_lst   {"sink"}
   } elseif {$dir == "Source" }  {
      set folder_lst   {"source"}
   } else {
      set folder_lst   {"sink" "source"}
   }
     
   foreach subDir ${folder_lst} {
      send_message INFO "Processing folder: $subDir"
      set file_lst [glob -nocomplain -- -path $subDir/*]
      send_message INFO $file_lst
      foreach file ${file_lst} {
       set file_string [split $file /]
       set file_name [lindex $file_string end]
       if {[regexp {.ocp} $file_name]} {
         add_fileset_file $file_name OTHER PATH ${file}
         send_message INFO "Adding file $file as $file_name"
       } elseif {![regexp {.sdc} $file_name]} {
         common_add_file $file
       }
     }
   }
}


proc sim_proc {outputName} {
    send_message INFO "Adding Simulation files"
    set cmode [get_parameter_value gui_clocking_mode]
    set dir [get_parameter_value direction]
    set df  [get_parameter_value system_family]
    set ecc_mode   [get_parameter_value gui_ecc_enable]
    set addr_width [get_parameter_value ADDR_WIDTH]
    set lanes   [get_parameter_value lanes]
    set fifo_depth [get_parameter_value adaptation_fifo_depth]
    set pll_ref_freq [get_parameter_value pll_ref_freq]
    set data_rate  [get_parameter_value data_rate]
    set mf      [get_parameter_value meta_frame_length]
    set burstgap [get_parameter_value "BURST_GAP"]
    set pll_type [get_parameter_value pll_type]
    set ref_freq [get_parameter_value reference_clock_frequency]
    set ccf_val [get_parameter_value gui_actual_coreclkin_frequency]
    set user_input [get_parameter_value gui_user_input]
   
    set tmpdir "."

    if {$dir == "Source"} {
       set inst_name "native_ilk_wrapper_tx" 
    } elseif {$dir == "Sink"} {   
       set inst_name "native_ilk_wrapper_rx"
    } else {	    
       set inst_name "native_ilk_wrapper"
    }
   
    if {$user_input == 0} {
       set ucf_val [get_parameter_value gui_user_clock_frequency]
    } else {
       set ucf_val [get_parameter_value gui_actual_user_clock_frequency]
    }
    if {$df == "Arria 10"} {
       set random_str [get_instance_property $inst_name HDLINSTANCE_GET_GENERATED_NAME]
       set params_ip(module_name) ${outputName}
       set params_ip(instance_name) "_${random_str}"
	   
       #Do Terp for interlaken_native_wrapper_duplex.v.terp
       set template_inwd_path [ file join "common/" "interlaken_native_wrapper_duplex.v.terp" ]  
       set template_inwd_terpfile   [ read [ open $template_inwd_path r ] ]
       set params(instance_name) "${random_str}"  
       set result_inwd_file   [ altera_terp $template_inwd_terpfile params ]
    } else {
       set params_ip(instance_name) ""
	   set params_ip(module_name) ${outputName}
    } 
	
    set params_ip(device_family) "$df"
    set params_ip(addr_width)    $addr_width
    set params_ip(lanes)         $lanes 
    set params_ip(enable_tx_pll) "0"
    set params_ip(fifo_depth)    $fifo_depth
    set params_ip(freq)          "$pll_ref_freq"
    set params_ip(data_rate)     "$data_rate"
    set params_ip(mf_length)     $mf 
    set params_ip(burst_gap)     $burstgap
    set params_ip(ref_freq)      "$ref_freq"
    set params_ip(cclk_freq)     "$ccf_val MHz"
    set params_ip(user_freq)     "$ucf_val MHz"
    set params_ip(pll_type)      "$pll_type"
   
    if {$ecc_mode == "false"} {
       set params_ip(enable_ecc) "0"
    } else {
       set params_ip(enable_ecc) "1"
    }

    #Do Terp for seriallite_iii_streaming.v.terp
    if {$dir == "Duplex"} {
       if {$cmode == "true"} {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_duplex_ac.v.terp" ]
       } else {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_duplex_nc.v.terp" ]
       }		  
    } elseif {$dir == "Sink"} {
       if {$cmode == "true"} {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_sink_ac.v.terp" ]
       } else {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_sink_nc.v.terp" ]
       }
    } else {
       if {$cmode == "true"} {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_source_ac.v.terp" ]
       } else {
          set sl3_inwd_path [ file join "common/" "seriallite_iii_streaming_source_nc.v.terp" ]
       }
    }
	
    set sl3_inwd_terpfile   [ read [ open $sl3_inwd_path r ] ]
    set sl3_inwd_file   [ altera_terp $sl3_inwd_terpfile params_ip ]
	
    if {$df == "Stratix V"} {
       add_fileset_file "clkctrl.v" VERILOG PATH  "common/clkctrl_sv.v"
       add_fileset_file "interlaken_phy_ip_duplex.v" VERILOG PATH  "common/interlaken_phy_ip_duplex.v"
    } elseif {$df == "Arria V GZ"} {
       add_fileset_file "clkctrl.v" VERILOG PATH  "common/clkctrl_av.v"
       add_fileset_file "interlaken_phy_ip_duplex.v" VERILOG PATH  "common/interlaken_phy_ip_duplex.v"
    } elseif {$df == "Arria 10"} {
       add_fileset_file "interlaken_native_wrapper_duplex$params(instance_name).v" VERILOG TEXT $result_inwd_file 
       add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH "$::env(QUARTUS_ROOTDIR)/../ip/altera/primitives/altera_std_synchronizer/altera_std_synchronizer_nocut.v"
    }
	
	#add the common files
	add_fileset_file $outputName.v  VERILOG TEXT $sl3_inwd_file
    add_fileset_file "dp_hs_req.v"  VERILOG PATH "common/dp_hs_req.v"   
    add_fileset_file "dp_hs_resp.v" VERILOG PATH "common/dp_hs_resp.v"
    add_fileset_file "dp_sync.v"    VERILOG PATH "common/dp_sync.v" 
    add_fileset_file "control_word_decoder.v" VERILOG PATH "common/sim/control_word_decoder.v"
    add_fileset_file "altera_xcvr_interlaken/alt_xcvr_csr_common_h.sv" SYSTEM_VERILOG PATH  "common/header/alt_xcvr_csr_common_h.sv"   
    send_message INFO "Adding system verilog file common/header/alt_xcvr_csr_common_h.sv  as alt_xcvr_csr_common_h.sv"

    add_fileset_file "altera_xcvr_interlaken/alt_xcvr_csr_pcs8g_h.sv" SYSTEM_VERILOG PATH "common/header/alt_xcvr_csr_pcs8g_h.sv"
    add_fileset_file "altera_xcvr_interlaken/sv_xcvr_h.sv" SYSTEM_VERILOG PATH "common/header/sv_xcvr_h.sv"
    add_fileset_file "altera_xcvr_interlaken/altera_xcvr_functions.sv" SYSTEM_VERILOG PATH "common/header/altera_xcvr_functions.sv"
	
    
    add_fileset_file "aclr_filter.v"    VERILOG PATH "common/aclr_filter.v"
    add_fileset_file "dcfifo_s5m20k.v"  VERILOG PATH "common/dcfifo_s5m20k.v"
    add_fileset_file "delay_regs.v"     VERILOG PATH "common/delay_regs.v"
    add_fileset_file "eq_5_ena.v"       VERILOG PATH "common/eq_5_ena.v"
    add_fileset_file "gray_cntr_5_sl.v" VERILOG PATH "common/gray_cntr_5_sl.v"
    add_fileset_file "gray_to_bin_5.v"  VERILOG PATH "common/gray_to_bin_5.v"
    add_fileset_file "neq_5_ena.v"      VERILOG PATH "common/neq_5_ena.v"
    add_fileset_file "s5m20k_ecc_1r1w.v" VERILOG PATH "common/s5m20k_ecc_1r1w.v"
    add_fileset_file "sync_regs_aclr_m2.v" VERILOG PATH "common/sync_regs_aclr_m2.v"
    add_fileset_file "wys_lut.v"        VERILOG PATH "common/wys_lut.v"
    add_fileset_file "core_reset_logic.v"        VERILOG PATH "common/core_reset_logic.v"
		
    if {$cmode == "true"} {
       add_fileset_file "clocking.v" VERILOG_INCLUDE PATH  "common/clocking_ac.v"
       add_fileset_file "source_absorber.v" VERILOG PATH  "common/source_absorber.v"
    } else {
       add_fileset_file "clocking.v" VERILOG_INCLUDE PATH  "common/clocking_nc.v"
       add_fileset_file "clock_gen.v" VERILOG PATH "common/clock_gen.v"
    }
    if {$df == "Arria 10"} {
    set common_path "common/"
    set folder_lst   {"a10_native" }
    add_fileset_file "a10_native/altera_xcvr_reset_control.sv"   SYSTEM_VERILOG PATH    ${tmpdir}/../../alt_xcvr/altera_xcvr_reset_control/altera_xcvr_reset_control.sv        
    add_fileset_file "a10_native/alt_xcvr_reset_counter.sv"      SYSTEM_VERILOG PATH    ${tmpdir}/../../alt_xcvr/altera_xcvr_reset_control/alt_xcvr_reset_counter.sv
    add_fileset_file "a10_native/alt_xcvr_resync.sv"             SYSTEM_VERILOG PATH    ${tmpdir}/../../altera_xcvr_generic/ctrl/alt_xcvr_resync.sv
	
    } else {	    
    set common_path "common/sim/"
    set folder_lst   {"altera_xcvr_interlaken" "alt_xcvr_reconfig/header" "alt_xcvr_reconfig" }
    }
    foreach subDir ${folder_lst} {
    send_message INFO "Processing folder: $common_path$subDir"
      set file_lst [glob -nocomplain -- -path $common_path$subDir/*]
      send_message INFO $file_lst
      foreach file ${file_lst} {       
        set     is_dir  [file isdirectory $file]
        set     is_tcl  [regexp {tcl} $file]
            if {$is_dir == 1} {
                send_message INFO "Ignoring directory-$file for simulation"
            } else {
	        send_message INFO "Adding file $file for simulation"
	        common_add_file $file "$subDir/"
            }
        }
    }

   # Adding Direction & Simulator Specific Encrypted Files
   set folder_lst   {"aldec" "mentor" "cadence" "synopsys"}
   
   if {$dir == "Sink" } {
      set direction "sink"
   } elseif {$dir == "Source" } {
      set direction "source"
   } else {
      set src "source"
      set snk "sink"     
   }	   


   foreach subDir ${folder_lst} {
     if {$dir == "Duplex"} {
       set file_lst [glob -nocomplain -- -path $subDir/$src/*]
       append file_lst " " 
       append file_lst [glob -nocomplain -- -path $subDir/$snk/*]
     } else {
       set file_lst [glob -nocomplain -- -path $subDir/$direction/*]
     }
     send_message INFO "Adding Files - $file_lst"

     foreach file ${file_lst} {
	if {![regexp {clock_gen.v} $file] || $cmode == "false"} {
	    common_add_file_sim $file "$subDir/"
	}
     }      
   }
}


proc example_proc {outputName} {
    source ../example/ed_sim/scripts/seriallite_iii_ed_sim_hw.tcl
	
    set enable_ed_sim [get_parameter_value ENABLE_ED_FILESET_SIM]
    if {$enable_ed_sim} {
       ed_sim
    }

    set cmode [get_parameter_value gui_clocking_mode]
    set dir [get_parameter_value direction]
    set df  [get_parameter_value system_family]
    set ecc_mode  [get_parameter_value gui_ecc_enable]
    set ccf_val [get_parameter_value gui_actual_coreclkin_frequency]
    set icf_val [get_parameter_value gui_interface_clock_frequency]
    set tmpdir "."
    set ENABLE_ED_FILESET_SYNTHESIS [get_parameter_value ENABLE_ED_FILESET_SYNTHESIS]
    set ENABLE_ED_FILESET_SIM [get_parameter_value ENABLE_ED_FILESET_SIM]
    set SELECT_TARGETED_DEVICE [get_parameter_value SELECT_TARGETED_DEVICE]
    set DEVKIT_DEVICE [get_parameter_value DEVKIT_DEVICE]
    set DEVICE [get_parameter_value DEVICE]
    set ed_option [get_parameter_value ed_option]
    set lanes [get_parameter_value lanes]
    set pll_ref_freq [get_parameter_value pll_ref_freq]
    set user_input   [get_parameter_value gui_user_input]

    # Get ACDS_VERSION_SHORT
    set ACDS_VER 18.1
    regsub {\.} $ACDS_VER {} ACDS_VER

    if {$user_input == 0} {
       set ucf_val [get_parameter_value gui_user_clock_frequency]
    } else {
       set ucf_val [get_parameter_value gui_actual_user_clock_frequency]
    }
    #Do Terp for seriallite_iii_streaming_demo
    if {$df == "Arria 10"} {
       if {$dir == "Duplex"} {
          set sl3_demo_path [file join "../example/example_design/top/" "seriallite_iii_streaming_demo_duplex_a10.v.terp"]
       } else {
          set sl3_demo_path [file join "../example/example_design/top/" "seriallite_iii_streaming_demo_simplex_a10.v.terp"]
       }
	} else {
       if {$dir == "Duplex"} {
          set sl3_demo_path [file join "../example/example_design/top/" "seriallite_iii_streaming_demo_duplex.v.terp"]
       } else {
          if {$cmode == "true"} {
             set sl3_demo_path [file join "../example/example_design/top/" "seriallite_iii_streaming_demo_simplex_ac.v.terp"]
          } else {
             set sl3_demo_path [file join "../example/example_design/top/" "seriallite_iii_streaming_demo_simplex_nc.v.terp"]
          }
       }
    }
    
    set paramsdemo(lanes) $lanes
	set paramsdemo(pll_ref_freq) $pll_ref_freq
	set paramsdemo(user_clock_frequency) $ucf_val
	
    if { $cmode == "true" }  {
        set path "ac"
    } else {
        set path "nc"
    }
 
	set template_file_sink_v [ file join "sink/" "seriallite_iii_streaming_sink.sdc.terp" ] 
	set template_file_source_v [ file join "source/" "seriallite_iii_streaming_source.sdc.terp" ] 
	set template_sink_v [ read [ open $template_file_sink_v r ] ]
	set template_source_v [ read [ open $template_file_source_v r ] ]
        set template_demo_v [ read [ open $sl3_demo_path r ] ]
        set paramsdc(cmode) $cmode
	set paramsdc(ecc_mode) $ecc_mode
	set paramsdc(direction)   $dir
	set paramsdc(user_freq)   $ucf_val
	set paramsdc(coreclk_freq) $ccf_val
	set paramsdc(ifclk_freq)   $icf_val
    set paramsdc(module_name)  $outputName

    set result_sink   [ altera_terp $template_sink_v paramsdc ]
	set result_source [ altera_terp $template_source_v paramsdc ]
    set result_demo   [ altera_terp $template_demo_v paramsdemo ]
	
	if {$ed_option == "Advanced_Clocking_Mode_2x10G" || $ed_option == "Advanced_Clocking_Mode_6x12.5G" || $ed_option == "Standard_Clocking_Mode_2x10G" || $ed_option == "Standard_Clocking_Mode_6x12.5G"} {
       set enable_synth 1  
       
       if {$ENABLE_ED_FILESET_SIM == 0 && $ENABLE_ED_FILESET_SYNTHESIS == 0} {
          send_message error "Neither \"Simulation\" nor \"Synthesis\" check boxes from \"Files Types Generated\" are selected to allow generation of Example Design Files."
       } else {
          send_message INFO "Adding example design"
       }	   
    } else {
       set enable_synth 0
       
       if {$ENABLE_ED_FILESET_SIM == 0} {
          send_message error "Neither \"Simulation\" nor \"Synthesis\" check boxes from \"Files Types Generated\" are selected to allow generation of Example Design Files."
       } else {
          send_message INFO "Adding example design"
       }	   
    }
	
 	
	if {$ENABLE_ED_FILESET_SYNTHESIS && $enable_synth} {
	    ed_synth
        if {$df != "Arria V GZ"} {
            
            #Adding Source and Sink SDC files to src/ directory of the Example Design
            if {$df == "Stratix V"} {
                add_fileset_file "ed_synth/src/seriallite_iii_streaming_source.sdc" SDC TEXT $result_source
                add_fileset_file "ed_synth/src/seriallite_iii_streaming_sink.sdc" SDC TEXT $result_sink 
            }
	
            if {$cmode == "true"} {
                add_fileset_file "ed_synth/src/clocking.v" VERILOG PATH  "common/clocking_ac.v"
            } else {
               add_fileset_file "ed_synth/src/clocking.v" VERILOG PATH  "common/clocking_nc.v"
            }
   
            if {$dir == "Duplex"} {	
                if {$df == "Stratix V"} {
                # Add qsf and qpf files too
                    common_add_file "../example/example_design/sv/duplex/seriallite_iii_streaming_demo.qpf" "ed_synth/" "seriallite_iii_streaming_demo.qpf"
                    
					set template_file_qsf [ file join "../example/example_design/sv/duplex/" "seriallite_iii_streaming_demo.qsf.terp" ] 
                    set template_filenodev_qsf [ file join "../example/example_design/sv/duplex/" "seriallite_iii_streaming_demo_no_device.qsf.terp" ] 
	                set template_file_qsf_v [ read [ open $template_file_qsf r ] ]
	                set template_filenodev_v [ read [ open $template_filenodev_qsf r ] ]
					
                    if {$SELECT_TARGETED_DEVICE == 1} {
                       if {![validate_custom_device]} {
					       set paramqsf(DEVKIT_DEVICE) $DEVKIT_DEVICE
                       } else {
					       set paramqsf(DEVKIT_DEVICE) $DEVICE
                       }
                       set result_qsf   [ altera_terp $template_file_qsf_v paramqsf ]
                    } else {
                       set paramqsf(DEVKIT_DEVICE) $DEVICE
                       set result_qsf   [ altera_terp $template_filenodev_v paramqsf ]
                    }		
                } elseif {$df == "Arria 10"} {
                # Add QSF, and QPF files
                    common_add_file "../example/example_design/a10/duplex/seriallite_iii_streaming_demo.qpf" "ed_synth/" "seriallite_iii_streaming_demo.qpf"
                    
                    set template_file_qsf [ file join "../example/example_design/a10/duplex/" "seriallite_iii_streaming_demo.qsf.terp" ] 
                    set template_filenodev_qsf [ file join "../example/example_design/a10/duplex/" "seriallite_iii_streaming_demo_no_device.qsf.terp" ] 
	                set template_file_qsf_v [ read [ open $template_file_qsf r ] ]
	                set template_filenodev_v [ read [ open $template_filenodev_qsf r ] ]
                    set paramqsf(cmode) $cmode 
					
                    if {$SELECT_TARGETED_DEVICE == 1} {
                       if {![validate_custom_device]} {
					       set paramqsf(DEVKIT_DEVICE) $DEVKIT_DEVICE
                       } else {
					       set paramqsf(DEVKIT_DEVICE) $DEVICE
                       }
                       set result_qsf   [ altera_terp $template_file_qsf_v paramqsf ]
                    } else {
                       set paramqsf(DEVICE) $DEVICE
                       set result_qsf   [ altera_terp $template_filenodev_v paramqsf ]
                    }		
                }
            } else {
                if {$df == "Stratix V"} {	  
                    add_fileset_file "ed_synth/seriallite_iii_streaming_demo.qpf" OTHER PATH "../example/example_design/sv/simplex/seriallite_iii_streaming_demo.qpf"   
                    
					set template_file_qsf [ file join "../example/example_design/sv/simplex/" "seriallite_iii_streaming_demo.qsf.terp" ] 
                    set template_filenodev_qsf [ file join "../example/example_design/sv/simplex/" "seriallite_iii_streaming_demo_no_device.qsf.terp" ] 
	                set template_file_qsf_v [ read [ open $template_file_qsf r ] ]
	                set template_filenodev_v [ read [ open $template_filenodev_qsf r ] ]
					
                    if {$SELECT_TARGETED_DEVICE == 1} {
                       if {![validate_custom_device]} {
					       set paramqsf(DEVKIT_DEVICE) $DEVKIT_DEVICE
                       } else {
					       set paramqsf(DEVKIT_DEVICE) $DEVICE
                       }
                       set result_qsf   [ altera_terp $template_file_qsf_v paramqsf ]
                    } else {
                       set paramqsf(DEVKIT_DEVICE) $DEVICE
                       set result_qsf   [ altera_terp $template_filenodev_v paramqsf ]
                    }			
                    
                } elseif {$df == "Arria 10"} {	  
                # Add QSF, and QPF files
                    add_fileset_file "ed_synth/seriallite_iii_streaming_demo.qpf" OTHER PATH "../example/example_design/a10/simplex/seriallite_iii_streaming_demo.qpf"   
                    
					set template_file_qsf [ file join "../example/example_design/a10/simplex/" "seriallite_iii_streaming_demo.qsf.terp" ] 
                    set template_filenodev_qsf [ file join "../example/example_design/a10/simplex/" "seriallite_iii_streaming_demo_no_device.qsf.terp" ] 
	                set template_file_qsf_v [ read [ open $template_file_qsf r ] ]
	                set template_filenodev_v [ read [ open $template_filenodev_qsf r ] ]
                    set paramqsf(cmode) $cmode 
                    set paramqsf(ACDS_VER) $ACDS_VER
					
                    if {$SELECT_TARGETED_DEVICE == 1} {
                       if {![validate_custom_device]} {
					       set paramqsf(DEVICE) $DEVKIT_DEVICE
                       } else {
					       set paramqsf(DEVICE) $DEVICE
                       }
                       set result_qsf   [ altera_terp $template_file_qsf_v paramqsf ]
                    } else {
                       set paramqsf(DEVICE) $DEVICE
                       set result_qsf   [ altera_terp $template_filenodev_v paramqsf ]
                    }						 
              }
            }
    
        ######## SDC generation through terp ########

            if {$df == "Arria 10"} {
                set sdcfile "seriallite_iii_streaming_demo_a10.sdc.terp"
            } else {
                set sdcfile "seriallite_iii_streaming_demo_sv.sdc.terp"
            }

            set sdcdir "$::env(QUARTUS_ROOTDIR)/../ip/altera/seriallite_iii/example/example_design/top/"
            set template_file [ file join $sdcdir "$sdcfile" ]
            set template      [ read [ open $template_file r ] ]
            set params(cmode) $cmode
            set result        [ altera_terp $template params ]
            
            add_fileset_file ed_synth/seriallite_iii_streaming_demo.sdc SDC TEXT $result

        ################################
	        add_fileset_file "ed_synth/src/seriallite_iii_streaming_demo.v" VERILOG TEXT $result_demo
            add_fileset_file "ed_synth/seriallite_iii_streaming_demo.qsf" OTHER TEXT $result_qsf	
            add_fileset_file "ed_synth/src/demo_mgmt.v" VERILOG PATH "../example/common/demo_mgmt.v"
            add_fileset_file "ed_synth/src/prbs_generator.v" VERILOG PATH "../example/common/prbs_generator.v"
	        add_fileset_file "ed_synth/src/prbs_poly.v" VERILOG PATH "../example/common/prbs_poly.v"					
            add_fileset_file "ed_synth/src/traffic_check.v" VERILOG PATH "../example/common/traffic_check.v"
            add_fileset_file "ed_synth/src/traffic_gen.sv" SYSTEM_VERILOG PATH "../example/common/traffic_gen.sv"
            add_fileset_file "ed_synth/src/sink_reconfig.v" VERILOG PATH "../example/common/sink_reconfig.v"
            add_fileset_file "ed_synth/src/source_reconfig.v" VERILOG PATH "../example/common/source_reconfig.v"
        }
		
    if {$df == "Stratix V" || $df == "Arria 10"} {
        set folder_lst   {"demo_control/software" "demo_control/software/src"}
        foreach subDir ${folder_lst} {
            set file_lst [glob -nocomplain -- -path ../example/example_design/$subDir/*]
            send_message INFO $file_lst
            foreach file ${file_lst} {
                set     is_dir  [file isdirectory $file]
                if {$is_dir == 1} {
                    send_message INFO "Ignoring $file for example design"
                } else {
                    set file_string [split $file /]
                    set file_name [lindex $file_string end]
                    set demo_control_sv [string match "*demo_control.c" $file]
                    set demo_control_a10 [string match "*demo_control_a10.c" $file]
                    set batch_script_sv [string match "*batch_script.sh" $file]
                    set batch_script_a10 [string match "*batch_script_a10.sh" $file]

                    if {$demo_control_sv == 0 && $demo_control_a10 == 0 && $batch_script_sv == 0 && $batch_script_a10 == 0} {
                        common_add_file $file "ed_hwtest/software/src/"
                    } elseif {$demo_control_sv == 1 && $df == "Stratix V"} {
                        common_add_file $file "ed_hwtest/software/src/" "demo_control.c"
                    } elseif {$demo_control_a10 == 1 && $df == "Arria 10"} {
                        common_add_file $file "ed_hwtest/software/src/" "demo_control.c"
                    } elseif {$batch_script_sv == 1 && $df == "Stratix V"} {
                        common_add_file $file "ed_hwtest/software/"
                    } elseif {$batch_script_a10 == 1 && $df == "Arria 10"} {
                        common_add_file $file "ed_hwtest/software/" "batch_script.sh"
                    }
                }
            }
        }
        common_add_file "../example/example_design/demo_control/master_export.v" "ed_hwtest/" "master_export.v"
        common_add_file "../example/example_design/demo_control/master_export_hw.tcl" "ed_hwtest/" "master_export_hw.tcl"
        common_add_file "../example/example_design/demo_control/Readme.txt" "ed_hwtest/" "Readme.txt"
    }

    if {$df == "Stratix V"} {
        common_add_file "../example/example_design/demo_control/build_demo_control.sh" "ed_hwtest/" "build_demo_control.sh"
        if {$dir == "Duplex"} {
            common_add_file "../example/example_design/demo_control/demo_control_edited_backup_sv_duplex.v" "ed_synth/src/demo_control/synthesis/" "demo_control.v"
        } else {
            common_add_file "../example/example_design/demo_control/demo_control_edited_backup_sv_simplex.v" "ed_synth/src/demo_control/synthesis/" "demo_control.v"
        }
    } elseif {$df == "Arria 10"} {
        ######## A10 build_demo_control.sh generation ########
        set build_demo_control_a10_dir "$::env(QUARTUS_ROOTDIR)/../ip/altera/seriallite_iii/example/example_design/demo_control/"

        set template_file [ file join $build_demo_control_a10_dir "build_demo_control_a10.sh.terp" ]
        set template      [ read [ open $template_file r ] ]
        set params(cmode) $cmode
        set params(dir) $dir

        set build_demo_control_a10_terp   [ altera_terp $template params ]
        add_fileset_file ed_hwtest/build_demo_control.sh  OTHER TEXT $build_demo_control_a10_terp
        #######################################################
    }
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

proc ed_synth {} {
    global env
    set qdir $env(QUARTUS_ROOTDIR)
    set quartus_sh_exe_path "$::env(QUARTUS_BINDIR)/quartus_sh"
    set qsys_script_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
    set ed_synth_scripts_dir "${qdir}/../ip/altera/seriallite_iii/example/example_design/demo_control"
    set tmpdir             "."
    set dir                [get_parameter_value direction]
    set df                 [get_parameter_value system_family]
    set cmode              [get_parameter_value gui_clocking_mode]
	set SELECT_TARGETED_DEVICE [get_parameter_value SELECT_TARGETED_DEVICE]
    set DEVKIT_DEVICE      [get_parameter_value DEVKIT_DEVICE]
    set DEVICE             [get_parameter_value DEVICE]
    set language           [get_parameter_value SELECT_ED_FILESET]
    set ed_option          [get_parameter_value ed_option]
    set tmp_dir_path       [create_temp_file ""]
    set tmp_ex_design_dir_path "${tmp_dir_path}tmp_ex_synth/"
    set tmp_demo_ctrl_dir_path        "${tmp_ex_design_dir_path}/ed_hwtest/"
    file mkdir $tmp_ex_design_dir_path
    file mkdir $tmp_demo_ctrl_dir_path

	if {$language == 0} {
       set hdl "verilog"
    } else {
       set hdl "vhdl"
    }

    if { $dir == "Duplex"} {
        set dir_qsys {"Duplex" ""}
    } else {
	    set dir_qsys {"Sink" "_sink" "Source" "_source"}
	}

    set variant_name_tx "seriallite_iii_streaming_source"
    set variant_name_rx "seriallite_iii_streaming_sink"
    set variant_name_dup "seriallite_iii_streaming"

    # Create QSYS script for IP core
    foreach {dir_qsys_tcl tail_output_name} $dir_qsys {
        set output_name "seriallite_iii_streaming${tail_output_name}"
        set gen_ip_qsys_script_file [create_temp_file gen_qsys.tcl]
        set out_ip_qsys_tcl [ open $gen_ip_qsys_script_file w ]
        if {$df == "Arria 10"} {
           puts $out_ip_qsys_tcl "package require \-exact qsys 14.1"
        } else {
           puts $out_ip_qsys_tcl "package require \-exact qsys 13.1"
        }
        puts $out_ip_qsys_tcl "create_system"
        puts $out_ip_qsys_tcl "set_project_property DEVICE_FAMILY \"[get_parameter_value "system_family"]\""
		
        if { $df == "Arria 10"} {
		   puts $out_ip_qsys_tcl "add_instance $output_name seriallite_iii_a10"
        } else {
           puts $out_ip_qsys_tcl "add_instance $output_name seriallite_iii_sv"
        }
        puts $out_ip_qsys_tcl "set_instance_property $output_name AUTO_EXPORT 1"

        foreach {param_name} [get_parameters] {
            set is_derived_param [get_parameter_property $param_name DERIVED]
            set param_value [get_parameter_value $param_name]
               
            # Print out the DUT parameters that are not derived
            if {$is_derived_param == 1} {
                continue
            } elseif {[string match "*direction*" $param_name]} {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name \"$dir_qsys_tcl\""
            } elseif {$dir != "Duplex" && [string match "*rcfg_jtag_enable*" $param_name]} {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name 0"
            } else {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name \"[get_parameter_value "$param_name"]\""
            }
        }
        puts $out_ip_qsys_tcl "save_system $output_name"
        close $out_ip_qsys_tcl

        file copy $gen_ip_qsys_script_file $tmp_ex_design_dir_path
        file rename ${tmp_ex_design_dir_path}gen_qsys.tcl ${tmp_ex_design_dir_path}gen_qsys_seriallite_iii_streaming${tail_output_name}.tcl   
    }

    foreach {sim_language} $hdl {

        set out_run_script_file [create_temp_file gen_quartus_synth.tcl]
        set out [ open $out_run_script_file w ]
        
        if {$SELECT_TARGETED_DEVICE == 1} {
            if {![validate_custom_device]} {
                set device_part $DEVKIT_DEVICE
            } else {
                set device_part $DEVICE
            }
        } else {
            set device_part $DEVICE
        }			
		
        puts $out "set qdir $::env(QUARTUS_ROOTDIR)"
        puts $out "set qsys_exec \[file join \$qdir sopc_builder bin\]"
        puts $out "set qsys_script \[file join \$qsys_exec qsys-script\]"
        puts $out "set qsys_generate \[file join \$qsys_exec qsys-generate\]"
		
		puts $out "set output_dir [file join src]"
        # gen_IP_QSYS (qsys-script)
        if {$dir == "Duplex"} {
            puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_seriallite_iii_streaming.tcl \]\} temp"
            puts $out "puts \$temp"
        } else {
            puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_seriallite_iii_streaming_source.tcl\]\} temp"
            puts $out "puts \$temp"
            puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_seriallite_iii_streaming_sink.tcl\]\} temp"
            puts $out "puts \$temp"
        }
        
        # gen_IP (qsys-generate)
        if {$dir == "Duplex"} {
            if {[is_qsys_edition QSYS_PRO]} {
                puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_dup.ip --synthesis=$sim_language --part=$device_part \]\} temp"
            } else {
                puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_dup.qsys --synthesis=$sim_language --part=$device_part \]\} temp"
            }				
			
            puts $out "puts \$temp"
        } else {
            if {[is_qsys_edition QSYS_PRO]} {
                puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_tx.ip --synthesis=$sim_language --part=$device_part \]\} temp"
            } else {
                puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_tx.qsys --synthesis=$sim_language --part=$device_part \]\} temp"
            } 
                puts $out "puts \$temp"
            if {[is_qsys_edition QSYS_PRO]} {
                puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_rx.ip --synthesis=$sim_language --part=$device_part \]\} temp"
            } else {
                puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_rx.qsys --synthesis=$sim_language --part=$device_part \]\} temp"
            } 
            puts $out "puts \$temp"		    
        }
		
        if {$cmode == "true"} {
            puts $out "set output_dir_iopll \[file join \$output_dir \"altera_iopll_inst\"\]" 
            puts $out "catch \{eval \[list exec \"\$qsys_generate\" altera_iopll_inst.qsys --synthesis=verilog --part=$device_part --output-directory=\$output_dir_iopll\]\} temp"   
            puts $out "puts \$temp"			
        }
        puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control.qsys --synthesis=verilog --part=$device_part --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"

        close $out

        if {$ed_option == "Advanced_Clocking_Mode_2x10G"} {
            file copy "../example/example_design/demo_control/altera_iopll_inst_10g.qsys" $tmp_ex_design_dir_path
            file rename ${tmp_ex_design_dir_path}altera_iopll_inst_10g.qsys ${tmp_ex_design_dir_path}altera_iopll_inst.qsys
        } elseif {$ed_option == "Advanced_Clocking_Mode_6x12.5G"} {
            file copy "../example/example_design/demo_control/altera_iopll_inst_12g.qsys" $tmp_ex_design_dir_path
            file rename ${tmp_ex_design_dir_path}altera_iopll_inst_12g.qsys ${tmp_ex_design_dir_path}altera_iopll_inst.qsys
        }

        if {$df == "Stratix V"} {
            if {$dir == "Duplex"} {
                file copy "../example/example_design/demo_control/demo_control_sv_duplex.qsys" $tmp_ex_design_dir_path
                file rename ${tmp_ex_design_dir_path}demo_control_sv_duplex.qsys ${tmp_ex_design_dir_path}demo_control.qsys
            } else {
                file copy "../example/example_design/demo_control/demo_control_sv_simplex.qsys" $tmp_ex_design_dir_path
                file rename ${tmp_ex_design_dir_path}demo_control_sv_simplex.qsys ${tmp_ex_design_dir_path}demo_control.qsys
            }
        } elseif {$df == "Arria 10"} {
            if {$dir == "Duplex"} {
                file copy "../example/example_design/demo_control/demo_control_a10_duplex.qsys" $tmp_ex_design_dir_path
                file rename ${tmp_ex_design_dir_path}demo_control_a10_duplex.qsys ${tmp_ex_design_dir_path}demo_control.qsys
            } else {
                file copy "../example/example_design/demo_control/demo_control_a10_simplex.qsys" $tmp_ex_design_dir_path
                file rename ${tmp_ex_design_dir_path}demo_control_a10_simplex.qsys ${tmp_ex_design_dir_path}demo_control.qsys
            }
        }
		file copy $out_run_script_file $tmp_ex_design_dir_path
        file rename ${tmp_ex_design_dir_path}gen_quartus_synth.tcl ${tmp_ex_design_dir_path}gen_synth_${sim_language}.tcl   	
    }

    
    set sim_gen_log_file "log_generate_eds.txt"
    set sim_gen_log_path [create_temp_file $sim_gen_log_file]
    set fh [open $sim_gen_log_path "w"]
    set hw_tcl_dir [pwd]
    cd "${tmp_ex_design_dir_path}"

    set cmd [concat [list exec $quartus_sh_exe_path -t "${tmp_ex_design_dir_path}gen_synth_${sim_language}.tcl"]]
    set cmd_fail [catch { eval $cmd } tempresult]
    cd "$hw_tcl_dir"
    puts $fh $tempresult

    close $fh
	
    set sim_files [ls_recursive "${tmp_ex_design_dir_path}" "*"]
    foreach path $sim_files {
        set file [ string range $path [string length $tmp_ex_design_dir_path] [string length $path] ]
        add_fileset_file ed_synth/$file [get_file_type $file 0 0] PATH $path
    }
	  

    add_fileset_file ed_synth/$sim_gen_log_file OTHER PATH $sim_gen_log_path

}
