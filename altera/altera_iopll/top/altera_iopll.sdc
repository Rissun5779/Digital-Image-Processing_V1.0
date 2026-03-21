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


#__ACDS_USER_COMMENT__####################################################################
#__ACDS_USER_COMMENT__
#__ACDS_USER_COMMENT__ THIS IS AN AUTO-GENERATED FILE!
#__ACDS_USER_COMMENT__ -------------------------------
#__ACDS_USER_COMMENT__ If you modify this files, all your changes will be lost if you
#__ACDS_USER_COMMENT__ regenerate the core!
#__ACDS_USER_COMMENT__
#__ACDS_USER_COMMENT__ FILE DESCRIPTION
#__ACDS_USER_COMMENT__ ----------------
#__ACDS_USER_COMMENT__ This file contains the timing constraints for the Altera PLL.
#__ACDS_USER_COMMENT__    * The helper routines are defined in altera_iopll_pin_map.tcl
#__ACDS_USER_COMMENT__
#__ACDS_USER_COMMENT__ NOTE
#__ACDS_USER_COMMENT__ ----

set script_dir [file dirname [info script]]

source "$script_dir/altera_iopll_parameters.tcl"
source "$script_dir/altera_iopll_pin_map.tcl"

#__ACDS_USER_COMMENT__###################
#__ACDS_USER_COMMENT__                  #
#__ACDS_USER_COMMENT__ GENERAL SETTINGS #
#__ACDS_USER_COMMENT__                  #
#__ACDS_USER_COMMENT__###################

#__ACDS_USER_COMMENT__ This is a global setting and will apply to the whole design.
#__ACDS_USER_COMMENT__ This setting is required for the memory interface to be
#__ACDS_USER_COMMENT__ properly constrained.
derive_clock_uncertainty

#__ACDS_USER_COMMENT__ Debug switch. Change to 1 to get more run-time debug information
set debug 0

#__ACDS_USER_COMMENT__ All timing requirements will be represented in nanoseconds with up to 3 decimal places of precision
set_time_format -unit ns -decimal_places 3

#__ACDS_USER_COMMENT__ Determine if entity names are on
set entity_names_on [ altera_iopll_are_entity_names_on ]

load_package atoms
load_package sdc_ext
load_package design
catch {read_atom_netlist} read_atom_netlist_out
set read_atom_netlist_error [regexp "ERROR" $read_atom_netlist_out]

#__ACDS_USER_COMMENT__ This is the main call to the netlist traversal routines
#__ACDS_USER_COMMENT__ that will automatically find all pins and registers required
#__ACDS_USER_COMMENT__ to apply timing constraints.
#__ACDS_USER_COMMENT__ During the fitter, the routines will be called only once
#__ACDS_USER_COMMENT__ and cached data will be used in all subsequent calls.



if {[info exists altera_iopll_pll_db]} {
    #__ACDS_USER_COMMENT__ Clean-up stale content
    unset altera_iopll_pll_db
}
altera_iopll_initialize_pll_db altera_iopll_pll_db

#__ACDS_USER_COMMENT__ If multiple instances of this core are present in the
#__ACDS_USER_COMMENT__ design they will all be constrained through the
#__ACDS_USER_COMMENT__ following loop
set instances [ array names altera_iopll_pll_db ]
foreach { inst } $instances {
	if { [ info exists pins ] } {
		#__ACDS_USER_COMMENT__ Clean-up stale content
		unset pins
	}
	array set pins $altera_iopll_pll_db($inst)
	
	#__ACDS_USER_COMMENT__ -------------------------------- #
	#__ACDS_USER_COMMENT__ -                              - #
	#__ACDS_USER_COMMENT__ --- Determine PLL Parameters --- #
	#__ACDS_USER_COMMENT__ -                              - #
	#__ACDS_USER_COMMENT__ -------------------------------- #
	
	set pll_atoms [get_atom_nodes -matching ${inst}* -type IOPLL]
	set num_pll_inst [get_collection_size $pll_atoms]
	
	if {$num_pll_inst > 1} { 
		#__ACDS_USER_COMMENT__ Error condition
		post_message -type error "SDC: More than one PLL atom found with instance name $inst"
	} else {
		#__ACDS_USER_COMMENT__ Use IP generated parameters
		if { $debug } {
			post_message -type info "SDC: using IP generated parameter values"
		}
	}
	
	#__ACDS_USER_COMMENT__ ------------------------ #
	#__ACDS_USER_COMMENT__ -                      - #
	#__ACDS_USER_COMMENT__ ---REFERENCE CLOCK(s)--- #
	#__ACDS_USER_COMMENT__ -                      - #
	#__ACDS_USER_COMMENT__ ------------------------ #

    # No output clocks are connected, skip constraint creation.
    if {$pins(skip_clock_constraints)} {
        post_sdc_message info "No IOPLL output clocks found, skipping constraint creation."
        break
    }
	#__ACDS_USER_COMMENT__ This is the reference clock used by the PLL to derive any other clock in the core
    set main_ref_clk_port [lindex $pins(main_ref_clk_port) 0]
    set is_fpga_pin_source [expr [string compare [lindex $pins(main_ref_clk_port) 1] ""] == 0]
    foreach refclk_port_name $pins(ref_clk_in_list) {
        
        if {$is_fpga_pin_source} {
            if {$refclk_port_name == $main_ref_clk_port} {
                set refclk_freq_string $::GLOBAL_pll_ref_freq
                set refclk_name "refclk"
            } else {
                set refclk_freq_string $::GLOBAL_pll_ref1_freq
                set refclk_name "refclk1"
            }

            if {[regexp {([0-9Ee\.]+)\s+MHz} $refclk_freq_string ref_clk_freq ref_clk_freq]} {
                    set ref_clk_period [expr 1/ ($ref_clk_freq * 1e6) * 1e9]
                } elseif {[regexp {([0-9Ee\.]+)\s+kHz} $refclk_freq_string ref_clk_freq ref_clk_freq]} {
                    set ref_clk_period [expr 1/ ($ref_clk_freq * 1e3) * 1e9]
                } elseif {[regexp {([0-9Ee\.]+)} $refclk_freq_string ref_clk_freq ref_clk_freq]} {
                    set ref_clk_period [expr 1/ ($ref_clk_freq) * 1e9]
                }	
            set half_ref_clk_period [expr $ref_clk_period / 2.0]
                
            set refclk_port [get_nodes $refclk_port_name]
            if {([string match "*|pll_cascade_out" $main_ref_clk_port])} {
                post_message -type info "Using pll_cascade_out clock from upstream PLL as refclk source for PLL ($inst)."
            } 
            create_clock -period $ref_clk_period -waveform [ list 0 $half_ref_clk_period ] -name ${inst}_$refclk_name $refclk_port
        } else {
            post_message -type info "Skipping creation of reference base clock..."
        }
    }
	
	#__ACDS_USER_COMMENT__ ------------------------- #
	#__ACDS_USER_COMMENT__ -                       - #
	#__ACDS_USER_COMMENT__ --- OUTPUT PLL CLOCKS --- #
	#__ACDS_USER_COMMENT__ -                       - #
	#__ACDS_USER_COMMENT__ ------------------------- #

    # If N Counter is enabled, create intermediate clock between N Counter and Refclk 
    if {$::GLOBAL_pll_n_cnt_val > 1} {
        # Create the clock from N to Refclk
        create_generated_clock -add \
            -source $pins(main_ref_clk_port) \
            -name ${inst}_n_cnt_clk \
            -multiply_by 1 \
            -divide_by $::GLOBAL_pll_n_cnt_val \
            $pins(n_cntr_port)
    }

	for { set i 0 } { $i < $::GLOBAL_num_pll_clock } { incr i } {
        if {[info exists pins(pll_out_clks$i)]} {

            set oclk $pins(pll_out_clks$i)

            # Set output clock name depending on whether it is global or not
            if {$::GLOBAL_pll_global_clock_names} {
                set oclk_name $::GLOBAL_pll_clock_name($i)
            } else {
                set oclk_name ${inst}_$::GLOBAL_pll_clock_name($i)
            }

            # If N Counter is enabled, create intermediate clock between N Counter and C Counter
            if {$::GLOBAL_pll_n_cnt_val > 1} {
                
                # Extract C Counter Div from total div
                # C = pll_div / N 
                set c_div [expr $::GLOBAL_pll_div($i) / $::GLOBAL_pll_n_cnt_val] 

                # Create the clock from C to N
                create_generated_clock -add \
                    -source $pins(n_cntr_port) \
                    -name $oclk_name \
                    -multiply_by $::GLOBAL_pll_mult($i) \
                    -divide_by $c_div \
                    -duty_cycle $::GLOBAL_pll_dutycycle($i) \
                    -phase $::GLOBAL_pll_phase($i) \
                    $oclk
            } else {
                create_generated_clock -add \
                    -source $pins(main_ref_clk_port) \
                    -name $oclk_name \
                    -multiply_by $::GLOBAL_pll_mult($i) \
                    -divide_by $::GLOBAL_pll_div($i) \
                    -phase $::GLOBAL_pll_phase($i) \
                    -duty_cycle $::GLOBAL_pll_dutycycle($i) \
                    $oclk
            }
        }
	}
    if {[info exists ::GLOBAL_ext_ports_enabled]} {
        if {$::GLOBAL_ext_ports_enabled} {
            for { set i 0 } { $i < $pins(num_extclks) } { incr i } {
                set extclk [lindex $pins(extclk_out_ports) $i]
                if {$::GLOBAL_pll_n_cnt_val > 1} {
                    # Extract C Counter Div from total div
                    # C = pll_div / N 
                    set c_div [expr $::GLOBAL_ext_div($i) / $::GLOBAL_pll_n_cnt_val] 
                    create_generated_clock -add \
                        -source $pins(n_cntr_port) \
                        -name ${inst}_extclk$i \
                        -multiply_by $::GLOBAL_ext_mult($i) \
                        -divide_by $c_div \
                        -phase $::GLOBAL_ext_phase($i) \
                        -duty_cycle $::GLOBAL_ext_dutycycle($i) \
                         $extclk
                } else {
                    create_generated_clock -add \
                    -source $pins(main_ref_clk_port) \
                    -name ${inst}_extclk$i \
                    -multiply_by $::GLOBAL_ext_mult($i) \
                    -divide_by $::GLOBAL_ext_div($i) \
                    -phase $::GLOBAL_ext_phase($i) \
                    -duty_cycle $::GLOBAL_ext_dutycycle($i) \
                     $extclk 
                }
            }
        }
    }
    if {[info exists ::GLOBAL_cascade_out_enabled]} {
        if {$::GLOBAL_cascade_out_enabled} {
            set cascade_out_target [lindex $pins(cascade_out_ports) 0]
            if {$::GLOBAL_pll_n_cnt_val > 1} {
                # Extract C Counter Div from total div
                # C = pll_div / N 
                set c_div [expr $::GLOBAL_cascade_out_div / $::GLOBAL_pll_n_cnt_val] 
                create_generated_clock -add \
                    -source $pins(n_cntr_port) \
                    -name ${inst}_cascade_out \
                    -multiply_by $::GLOBAL_cascade_out_mult \
                    -divide_by $c_div \
                    -phase $::GLOBAL_cascade_out_phase \
                    -duty_cycle $::GLOBAL_cascade_out_dutycycle \
                     $cascade_out_target 
            } else {
                create_generated_clock -add \
                -source $pins(main_ref_clk_port) \
                -name ${inst}_cascade_out \
                -multiply_by $::GLOBAL_cascade_out_mult \
                -divide_by $::GLOBAL_cascade_out_div \
                -phase $::GLOBAL_cascade_out_phase \
                -duty_cycle $::GLOBAL_cascade_out_dutycycle \
                 $cascade_out_target 
            }
        }
    } 
}
