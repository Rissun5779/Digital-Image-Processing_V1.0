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


#####################################################################
#
# THIS IS AN AUTO-GENERATED FILE!
# -------------------------------
# If you modify this files, all your changes will be lost if you
# regenerate the core!
#
# FILE DESCRIPTION
# ----------------
# This file contains the traversal routines that are used by
# altera_iopll.sdc scripts. 
#
# These routines are only meant to support the SDC. 
# Trying to using them in a different context can have unexpected 
# results.

set script_dir [file dirname [info script]]

source [file join $script_dir altera_iopll_parameters.tcl]

# ----------------------------------------------------------------
#
proc post_sdc_message {msg_type msg} {
#
# Description: Posts a message in TimeQuest, but not in Fitter
#              The SDC is read mutliple times during compilation, so we'll wait
#              until final TimeQuest timing analysis to display messages
#
# ----------------------------------------------------------------
	if { $::TimeQuestInfo(nameofexecutable) != "quartus_fit"} {
		post_message -type $msg_type $msg
	}
}

# ----------------------------------------------------------------
#
proc altera_iopll_are_entity_names_on { } {
#
# Description: Determines if the entity names option is on
#
# ----------------------------------------------------------------
	return [set_project_mode -is_show_entity]	
}

# ----------------------------------------------------------------
#
proc altera_iopll_initialize_pll_db { pll_db_par } {
#
# Description: Gets the instances of this particular PLL IP and creates the pin
#              cache
#
# ----------------------------------------------------------------
	upvar $pll_db_par local_pll_db

	global ::GLOBAL_corename

	post_sdc_message info "Initializing PLL database for CORE $::GLOBAL_corename"
	set instance_list [altera_iopll_get_core_instance_list $::GLOBAL_corename]

	foreach instname $instance_list {
		post_sdc_message info "Finding port-to-pin mapping for CORE: $::GLOBAL_corename INSTANCE: $instname"

		altera_iopll_get_pll_pins $instname allpins

		set local_pll_db($instname) [ array get allpins ]
	}
}

# ----------------------------------------------------------------
#
proc altera_iopll_get_core_instance_list {corename} {
#
# Description: Converts node names from one style to another style
#
# ----------------------------------------------------------------
	set full_instance_list [altera_iopll_get_core_full_instance_list $corename]
	set instance_list [list]

	foreach inst $full_instance_list {
		if {[lsearch $instance_list [escape_brackets $inst]] == -1} {
			lappend instance_list $inst
		}
	}
	return $instance_list
}

# ----------------------------------------------------------------
#
proc altera_iopll_get_core_full_instance_list {corename} {
#
# Description: Finds the instances of the particular IP by searching through the cells
#
# ----------------------------------------------------------------

	set instance_list [design::get_instances -entity $corename]

	if {[ llength $instance_list ] == 0} {
		post_message -type error "The auto-constraining script was not able to detect any instance for core < $corename >"
		post_message -type error "Verify the following:"
		post_message -type error " The core < $corename > is instantiated within another component (wrapper)"
		post_message -type error " The core is not the top-level of the project"
	}

	return $instance_list
}


# ----------------------------------------------------------------
#
proc altera_iopll_get_pll_pins { instname allpins } {
#
# Description: Stores the pins of interest for the instance of the IP
#
# ----------------------------------------------------------------

	# We need to make a local copy of the allpins associative array
	upvar allpins pins
	
	# Set the pattern for the output clocks
	set pll_out_clks_id [list]

	for { set i 0 } { $i < $::GLOBAL_num_pll_clock } { incr i } {
        set pll_out_clk_pattern ${instname}|stratix10_altera_iopll_i|fourteennm_pll|outclk[$i]
        set pin_collection [get_pins -no_duplicates $pll_out_clk_pattern]
        if {[get_collection_size $pin_collection] ==  1} {
            foreach_in_collection id $pin_collection {
                lappend pll_out_clks_id $id
                set pll_out_clk [get_node_info -name $id]	
                set pins(pll_out_clks$i) $pll_out_clk
            }
        } elseif {[get_collection_size $pin_collection] < 1} {
            post_message -type "warning" "Could not find all outclk\[$i\] pin for IOPLL inst:${instname}"
        } else {
            post_message -type "warning" "Found more output clock pins than specified for IOPLL inst:${instname}"
        }
     
    }
    
    # Find the extclk pins if they exist.
    if {[info exists ::GLOBAL_ext_ports_enabled]} {
        if {$::GLOBAL_ext_ports_enabled} {
            # Get the extclk pins and store in array
            # Set the pattern for the output clocks

            set extclks [list]

            set extclk_pattern ${instname}|stratix10_altera_iopll_i|fourteennm_pll|extclk_output[*]

            set pin_collection [get_pins -no_duplicates $extclk_pattern]
            if {[get_collection_size $pin_collection] > 0} {
                foreach_in_collection id $pin_collection {
                    lappend pll_out_clks_id $id
                    lappend extclks [get_node_info -name $id]	
                }
            } else {
                post_message -type "error" "Could not find all extclk_out pins."
            }

            set pins(extclk_out_ports) [join $extclks] 
            set num_extclks [get_collection_size $pin_collection]
            set pins(num_extclks) $num_extclks
        }
    
    }

    # Find the cascade_out pins if they exist.
    if {[info exists ::GLOBAL_cascade_out_enabled]} {
        if {$::GLOBAL_cascade_out_enabled} {
            # Get the cascade_out pins and store in array
            # Set the pattern for the output clocks

            set cascade_out_clks [list]

            set cascade_out_pattern ${instname}|stratix10_altera_iopll_i|fourteennm_pll|pll_cascade_out

            set pin_collection [get_pins -no_duplicates $cascade_out_pattern]
            if {[get_collection_size $pin_collection] == 1} {
                foreach_in_collection id $pin_collection {
                    lappend pll_out_clks_id $id
                    lappend cascade_out_clks [get_node_info -name $id]	
                }
            } else {
                post_message -type "error" "Could not find cascade_out pins."
            }

            set pins(cascade_out_ports) [join $cascade_out_clks] 
        }
    }
 

	
	# Set the pattern for the main reference clock input
    if {[info exists ::GLOBAL_cascade_in_enabled]} {
        if {$::GLOBAL_cascade_in_enabled} {
            set main_ref_clk_pin ${instname}|stratix10_altera_iopll_i|fourteennm_pll|pll_cascade_in

        }
    } else {
        set main_ref_clk_pin ${instname}|stratix10_altera_iopll_i|fourteennm_pll|refclk[0]
    }
    #Get the name for the main refclk
	set main_pin_collection [get_pins -no_duplicates $main_ref_clk_pin]
    set main_ref_clk_id_list [list]
	if {[get_collection_size $main_pin_collection] < 1} {
		post_message -type "warning" "Could not find the main reference clk pin"
    } else {
        foreach_in_collection id $main_pin_collection {
			lappend main_ref_clk_id_list $id
		}
    }
    set main_ref_clk_id [lindex $main_ref_clk_id_list 0]
    set main_ref_clk_name [get_node_info -name $main_ref_clk_id]

    if {[info exists ::GLOBAL_cascade_in_enabled]} {
        if {$::GLOBAL_cascade_in_enabled} {
            set pins(pll_ref_clk_in) ${instname}|stratix10_altera_iopll_i|fourteennm_pll|pll_cascade_in
  
        }
    } else {
        set pins(pll_ref_clk_in) ${instname}|stratix10_altera_iopll_i|fourteennm_pll|refclk[*]
    }

	# Set the pattern for the reference clock PLL inputs
		
	# Get the node ID for the PLL input
	set pin_collection [get_pins -no_duplicates $pins(pll_ref_clk_in)]
	if {[get_collection_size $pin_collection] <= 2} {
		foreach_in_collection id $pin_collection {
			lappend pll_ref_clk_in_id $id
		}
	} elseif {[get_collection_size $pin_collection] == 0} {
		post_message -type "warning" "Could not find any reference clk pins"
	} else {
		post_message -type "warning" "Found more than two reference clk pins"
	}	



	set pin_collection [get_pins -no_duplicates $pins(pll_ref_clk_in)]



    set pins(ref_clk_in_list) [list]


    # If no outclks found, skip trying to find the refclk by traversing back.
    set pins(skip_clock_constraints) 0
    if {[llength $pll_out_clks_id] == 0} {
        set pins(skip_clock_constraints) 1
    }
        
    if {$pins(skip_clock_constraints) == 0} {
        # Now traverse to the source input of the reference clock input
        array set pll_ref_clock_pins_ports_array [altera_iopll_get_input_clk_id [lindex $pll_out_clks_id 0]]
        foreach {net_id name_port_list} [array get pll_ref_clock_pins_ports_array] {
            if {[llength $name_port_list] == 0} {
                post_message -type error "altera_iopll_pin_map.tcl: Failed to find PLL reference clock"
            } else {
                set pin_name [lindex $name_port_list 0]
                set port_id [lindex $name_port_list 1]
                if {$port_id == "_not_fpga_pin_"} {
                    # The PLL Refclk is coming from a non-FPGA pin source,
                    # don't make create_clock on refclk
                    set pins(main_ref_clk_port) [list $pin_name $port_id]
                    lappend pins(ref_clk_in_list) $port_id
                } else {
                    set port_name [get_node_info -name $port_id]
                    if {$pin_name == $main_ref_clk_name} {
                        # if using cascade_in, then don't use the refclk source port,
                        # just use the pin directly.
                        if {([string match "*|pll_cascade_in" $pin_name])} {
                            set main_ref_clk_port_name [get_node_info -name $pin_name]
                            set port_name $pin_name
                        } else {
                            set main_ref_clk_port_name [get_node_info -name $port_name]
                        }

                        set pins(main_ref_clk_port) [list $main_ref_clk_port_name ""]
                    }

                    lappend pins(ref_clk_in_list) $port_name
                }

            }
        }
        
        if {$::GLOBAL_pll_n_cnt_val > 1} {
            # Get the n_counter pin if it exists

            # Set the pattern for the main reference clock input
            set pins(n_cntr_port) ${instname}|stratix10_altera_iopll_i|fourteennm_pll~ncntr_reg
            #Get the name for the main refclk
            set pin_collection [get_registers -no_duplicates $pins(n_cntr_port)]
            set n_cntr_pin_list [list]
            if {[get_collection_size $pin_collection] < 1} {
                post_message -type "warning" "Could not find the N-Counter Register pin"
            } else {
                foreach_in_collection id $pin_collection {
                    lappend n_cntr_pin_list $id
                }
            }
            set n_cntr_pin_id [lindex $n_cntr_pin_list 0]
            set n_cntr_pin_name [get_node_info -name $n_cntr_pin_id]
            set pins(n_cntr_port) $n_cntr_pin_name
        }
        

    }
    


}

# ----------------------------------------------------------------
#
proc altera_iopll_get_input_clk_id { pll_output_node_id } {
#
# Description: Searches back from the output of the PLL to find the reference clock pin.
#              If the reference clock is fed by an input buffer, it finds that pin, otherwise
#              in cascading modes it will return the immediate reference clock input of the PLL.
#
# ----------------------------------------------------------------
	if {[altera_iopll_is_node_type_pll_clk $pll_output_node_id]} {



        #stores the refclk pin ids that were found by tracing the 
        #output clocks back up
		array set results_array [list]
		altera_iopll_traverse_fanin_up_to_depth $pll_output_node_id altera_iopll_is_node_type_pll_inclk clock results_array 20
        array set result_ports_array [list]
        foreach {net_id id} [array get results_array] {
            set net_name [get_node_info -name $net_id]
            set result_ports_array($net_id) [list $net_name "none"]
        }
        #only works if there is either 1 or 2 refclks
		if {[array size results_array] == 1 || [array size results_array] == 2} {
            #iterate over each refclk pin and trace back to find its input port
            foreach pll_inclk_id [array names result_ports_array] {
                # Found PLL inclk, now find the input pin


                array unset results_array
                # If fed by a pin, it should be fed by a dedicated input pin,
                # and not a global clock network.  Limit the search depth to
                # prevent finding pins fed by global clock (only allow io_ibuf pins)
                altera_iopll_traverse_fanin_up_to_depth $pll_inclk_id altera_iopll_is_node_type_pin clock results_array 5
                if {[array size results_array] == 1} {
                    # Fed by a dedicated input pin
                    set port_name [lindex [array names results_array] 0]



                    set result_ports_array($pll_inclk_id) [lreplace $result_ports_array($pll_inclk_id) 1 1 $port_name]


                } else {
                    set result_ports_array($pll_inclk_id) [lreplace $result_ports_array($pll_inclk_id) 1 1 "_not_fpga_pin_"] 
                }
            }
        } else {
			post_message -type critical_warning "Could not find PLL clock for [get_node_info -name $pll_output_node_id]"          
		}
	} else {
		post_message -type error "Internal error: altera_iopll_get_input_clk_id only works on PLL output clocks"
	}
	return [array get result_ports_array]
}

# ----------------------------------------------------------------
#
proc altera_iopll_is_node_type_pin { node_id } {
#
# Description: Determines if a node is a top-level port of the FPGA
#
# ----------------------------------------------------------------

	set node_type [get_node_info -type $node_id]
	if {$node_type == "port"} {
		set result 1
	} else {
		set result 0
	}
	return $result
}

# ----------------------------------------------------------------
#
proc altera_iopll_is_node_type_pll_clk { node_id } {
#
# Description: Determines if a node is an output of a PLL
#
# ----------------------------------------------------------------

	set cell_id [get_node_info -cell $node_id]
	
	if {$cell_id == ""} {
		set result 0
	} else {
		set atom_type [get_cell_info -atom_type $cell_id]
		if {$atom_type == "IOPLL"} {
			set node_name [get_node_info -name $node_id]
			if {[string match "*fourteennm_pll\|outclk\\\[*\\\]" $node_name]} {
				set result 1
            } elseif {[string match "*fourteennm_pll\|pll_cascade_out" $node_name]} {
				set result 1
			} else {
				set result 0
			}
		} else {
			set result 0
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc altera_iopll_is_node_type_pll_inclk { node_id } {
#
# Description: Determines if a node is an input of a PLL
#
# ----------------------------------------------------------------


	set cell_id [get_node_info -cell $node_id]
	
	if {$cell_id == ""} {
		set result 0
	} else {
		set atom_type [get_cell_info -atom_type $cell_id]
		if {$atom_type == "IOPLL"} {
			set node_name [get_node_info -name $node_id]
			set fanin_edges [get_node_info -clock_edges $node_id]
			if {([string match "*|refclk\\\[*\\\]" $node_name]) && [llength $fanin_edges] > 0} {
				set result 1
            } elseif {([string match "*|pll_cascade_in" $node_name]) && [llength $fanin_edges] > 0} {
				set result 1
			} else {
				set result 0
			}
		} else {
			set result 0
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc altera_iopll_traverse_fanin_up_to_depth { node_id match_command edge_type results_array_name depth} {
#
# Description: General traversal function up until a depth.  Use a function pointer to decide
#              ending conditions.
#
# ----------------------------------------------------------------

	upvar 1 $results_array_name results
	
	if {$depth < 0} {
		error "Internal error: Bad timing netlist search depth"
	}
	set fanin_edges [get_node_info -${edge_type}_edges $node_id]
	set number_of_fanin_edges [llength $fanin_edges]
	for {set i 0} {$i != $number_of_fanin_edges} {incr i} {
		set fanin_edge [lindex $fanin_edges $i]
		set fanin_id [get_edge_info -src $fanin_edge]
		if {$match_command == "" || [eval $match_command $fanin_id] != 0} {
			set results($fanin_id) 1
		} elseif {$depth == 0} {
		} else {
			altera_iopll_traverse_fanin_up_to_depth $fanin_id $match_command $edge_type results [expr {$depth - 1}]
		}
	}
}

# ----------------------------------------------------------------
#
proc altera_iopll_index_in_collection { col j } {
#
# Description: Returns a particular index in a collection.
#              Analagous to lindex for lists.
#
# ----------------------------------------------------------------

	set i 0
	foreach_in_collection path $col {
		if {$i == $j} {
			return $path
		}
		set i [expr $i + 1]
	}
	return ""
}

# ----------------------------------------------------------------
#
proc altera_iopll_get_pll_atom_parameters { pll_atoms  } {
#
# Description: Gets the PLL paramaters from the Quartus atom and not 
#              from the IP generated parameters.
#
# ----------------------------------------------------------------

	set pll_atom [altera_iopll_index_in_collection $pll_atoms 0]
	
	if {[get_atom_node_info -node $pll_atom -key  BOOL_IOPLL_M_CNT_BYPASS_EN] == 1} {
		set mcnt 1
	} else {
		set mcnt [expr [get_atom_node_info -node $pll_atom -key INT_IOPLL_M_CNT_HI_DIV] + [get_atom_node_info -node $pll_atom -key INT_IOPLL_M_CNT_LO_DIV]]
	}
	if {[get_atom_node_info -node $pll_atom -key  BOOL_IOPLL_N_CNT_BYPASS_EN] == 1} {
		set ncnt 1
	} else {
		set ncnt [expr [get_atom_node_info -node $pll_atom -key INT_IOPLL_N_CNT_HI_DIV] + [get_atom_node_info -node $pll_atom -key INT_IOPLL_N_CNT_LO_DIV]]
	}
	
	for { set i 0 } { $i < $::GLOBAL_num_pll_clock } { incr i } {
		set clk_prst [get_atom_node_info -node $pll_atom -key INT_IOPLL_C_CNT_${i}_PRST]
		set clk_ph_mux [get_atom_node_info -node $pll_atom -key INT_IOPLL_C_CNT_${i}_PH_MUX_PRST]

		set clk_duty_cycle [get_atom_node_info -node $pll_atom -key INT_DUTY_CYCLE_$i]
		if {[get_atom_node_info -node $pll_atom -key  BOOL_IOPLL_C_CNT_${i}_BYPASS_EN] == 1} {
			set ccnt 1
		} else {
			set ccnt [expr [get_atom_node_info -node $pll_atom -key INT_IOPLL_C_CNT_${i}_HI_DIV] + [get_atom_node_info -node $pll_atom -key INT_IOPLL_C_CNT_${i}_LO_DIV]]
		}
		
		set clk_mult $mcnt
		set clk_div [expr $ncnt*$ccnt]

		set clk_phase [expr 360 * ($clk_ph_mux  + 8*($clk_prst-1))/(8*$clk_div)]
	
		set ::GLOBAL_pll_mult(${i}) $clk_mult
		set ::GLOBAL_pll_div(${i}) $clk_div
		set ::GLOBAL_pll_phase(${i}) $clk_phase
		set ::GLOBAL_pll_dutycycle(${i}) $clk_duty_cycle
	}		
}
