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


set script_dir [file dirname [info script]]

load_package sdc_ext
package require ::quartus::emif_timing_model
package require ::quartus::clock_uncertainty
initialize_clock_uncertainty_data

proc memphy_index_in_collection { col j } {
   set i 0
   foreach_in_collection path $col {
      if {$i == $j} {
         return $path
      }
      set i [expr $i + 1]
   }
   return ""
}


proc memphy_get_clock_to_pin_name_mapping {} {
   set result [list]
   set clocks_collection [get_clocks -nowarn]
   foreach_in_collection clock $clocks_collection { 
      set clock_name [get_clock_info -name $clock] 
      set clock_target [get_clock_info -targets $clock]
      set first_index [memphy_index_in_collection $clock_target 0]
      set catch_exception_net [catch {get_net_info -name $first_index} pin_name_net]
      if {$catch_exception_net == 0} {
         lappend result [list $clock_name $pin_name_net]
      } else {
         set catch_exception_port [catch {get_port_info -name $first_index} pin_name_port]
         if {$catch_exception_port == 0} {
            lappend result [list $clock_name $pin_name_port]
         } else {
            set catch_exception_reg [catch {get_register_info -name $first_index} pin_name_reg]
            if {$catch_exception_reg == 0} {
               lappend result [list $clock_name $pin_name_reg]
            } else {
               set catch_exception_pin [catch {get_pin_info -name $first_index} pin_name_pin]
               if {$catch_exception_pin == 0} {
                  lappend result [list $clock_name $pin_name_pin]
               } 
            }
         }
      }
   }
   return $result
}


proc memphy_get_clock_name_from_pin_name { pin_name } {
   set table [memphy_get_clock_to_pin_name_mapping]
   foreach entry $table {
      if {[string compare [lindex [lindex [split $entry] 1] 0] $pin_name] == 0} {
         return [lindex $entry 0]
      }
   }
   return ""
}



proc memphy_find_all_keepers { mystring } {
   set allkeepers [get_keepers $mystring ]

   foreach_in_collection keeper $allkeepers {
      set keepername [ get_node_info -name $keeper ]

      puts "$keepername"
   }
}

proc memphy_round_3dp { x } {
   return [expr { round($x * 1000) / 1000.0  } ]
}

proc memphy_get_current_timequest_report_folder {} {

   set catch_exception [catch {get_current_timequest_report_folder} error_message]
   if {[regexp ERROR $error_message] == 1} {
      return "ReportDDR"
   } else {
      return [get_current_timequest_report_folder]
   }
}

proc memphy_get_timequest_name {hier_name} {
   set sta_name ""
   for {set inst_start [string first ":" $hier_name]} {$inst_start != -1} {} {
      incr inst_start
      set inst_end [string first "|" $hier_name $inst_start]
      if {$inst_end == -1} {
         append sta_name [string range $hier_name $inst_start end]
         set inst_start -1
      } else {
         append sta_name [string range $hier_name $inst_start $inst_end]
         set inst_start [string first ":" $hier_name $inst_end]
      }
   }
   return $sta_name
}

proc memphy_are_entity_names_on { } {
   set entity_names_on 1


   return [set_project_mode -is_show_entity]   
}

proc memphy_get_core_instance_list {corename} {

   set full_instance_list [memphy_get_core_full_instance_list $corename]
   set instance_list [list]

   foreach inst $full_instance_list {
      set sta_name [memphy_get_timequest_name $inst]
      if {[lsearch $instance_list [escape_brackets $sta_name]] == -1} {
         lappend instance_list $sta_name
      }
   }

   return $instance_list
}

proc memphy_get_or_add_generated_clock {args} {
   array set opts { /
      -name "" /
      -target "" /
      -source "" /
      -multiply_by 1 /
      -divide_by 1 /
      -phase 0 }

   array set opts $args

   set multiply_by [expr int($opts(-multiply_by))]
   if {[expr $multiply_by - $opts(-multiply_by)] != 0.0} {
      post_message -type error "Specify an integer ranging from 0 to 99999999 for the option -multiply_by"
      return ""
   }

   set clock_name [memphy_get_clock_name_from_pin_name $opts(-target)]
   
   if {[string compare -nocase $clock_name ""] == 0} {
      set nets [get_nets $opts(-target) -nowarn]
      if {[get_collection_size $nets] > 0} {
         set pin_name [get_pin_info -name [get_net_info -pin $nets]]
         set clock_name [memphy_get_clock_name_from_pin_name $pin_name]

         if {[string compare -nocase $clock_name ""] != 0} {
            if {[regexp -nocase "lvds_clk" $pin_name] || [regexp -nocase "loaden" $pin_name] } {
               remove_clock $clock_name
               set clock_name ""
            }
         }
      }
   } else {
      if {([string compare -nocase $opts(-name) ""] != 0) && ([string compare -nocase $opts(-name) $clock_name])} {

         if {[regexp -nocase "pll_inst\|outclk" $opts(-target)]} {
            remove_clock $clock_name
            set clock_name ""
         }
      }
   }


   if {[string compare -nocase $clock_name ""] == 0} {
      set clock_name $opts(-name)

      create_generated_clock \
         -name $clock_name \
         -source $opts(-source) \
         -multiply_by $multiply_by \
         -divide_by $opts(-divide_by) \
         -phase $opts(-phase) \
         $opts(-target)
   }

   return $clock_name
}

proc memphy_get_core_full_instance_list {corename} {
   set allkeepers [get_keepers * ]

   set_project_mode -always_show_entity_name on

   set instance_list [list]

   set inst_regexp {(^.*}
   append inst_regexp {:[A-Za-z0-9\.\\_\[\]\-\$():]+)\|}
   append inst_regexp "${corename}"
   append inst_regexp {:core|}
   append inst_regexp phylite_core_*
   append inst_regexp {:arch_inst}   

   foreach_in_collection keeper $allkeepers {
      set name [ get_node_info -name $keeper ]

      if {[regexp -- $inst_regexp $name -> hier_name] == 1} {
         if {[lsearch $instance_list [escape_brackets $hier_name]] == -1} {
            lappend instance_list $hier_name
         }
      }
   }

   set_project_mode -always_show_entity_name qsf

   if {[ llength $instance_list ] == 0} {
      post_message -type critical_warning "The auto-constraining script was not able to detect any instance for core < $corename >"
      post_message -type critical_warning "Make sure the core < $corename > is instantiated within another component (wrapper)"
      post_message -type critical_warning "and it's not the top-level for your project"
   }

   return $instance_list
}


proc memphy_traverse_fanin_up_to_depth { node_id match_command edge_type results_array_name depth} {
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
         memphy_traverse_fanin_up_to_depth $fanin_id $match_command $edge_type results [expr {$depth - 1}]
      }
   }
}

proc memphy_is_node_type_pin { node_id } {
   set node_type [get_node_info -type $node_id]
   if {$node_type == "port"} {
      set result 1
   } else {
      set result 0
   }
   return $result
}




proc memphy_get_pll_clock_name { clock_id } {
   set clock_name [get_node_info -name $clock_id]

   return $clock_name
}




proc post_sdc_message {msg_type msg} {
   global ::io_only_analysis

   if {$::TimeQuestInfo(nameofexecutable) != "quartus_fit"} {
      post_message -type $msg_type $msg
   }
}

proc memphy_get_names_in_collection { col } {
   set res [list]
   foreach_in_collection node $col {
      lappend res [ get_node_info -name $node ]
   }
   return $res
}

proc memphy_format_3dp { x } {
   return [format %.3f $x]
}

proc memphy_get_colours { x y } {

   set fcolour [list "black"]
   if {$x < 0} {
      lappend fcolour "red"
   } else {
      lappend fcolour "blue"
   }
   if {$y < 0} {
      lappend fcolour "red"
   } else {
      lappend fcolour "blue"
   }

   return $fcolour
}

proc min { a b } {
   if { $a == "" } { 
      return $b
   } elseif { $a < $b } {
      return $a
   } else {
      return $b
   }
}

proc max { a b } {
   if { $a == "" } { 
      return $b
   } elseif { $a > $b } {
      return $a
   } else {
      return $b
   }
}

proc memphy_max_in_collection { col attribute } {
   set i 0
   set max 0
   foreach_in_collection path $col {
      if {$i == 0} {
         set max [get_path_info $path -${attribute}]
      } else {
         set temp [get_path_info $path -${attribute}]
         if {$temp > $max} {
            set max $temp
         } 
      }
      set i [expr $i + 1]
   }
   return $max
}

proc memphy_min_in_collection { col attribute } {
   set i 0
   set min 0
   foreach_in_collection path $col {
      if {$i == 0} {
         set min [get_path_info $path -${attribute}]
      } else {
         set temp [get_path_info $path -${attribute}]
         if {$temp < $min} {
            set min $temp
         } 
      }
      set i [expr $i + 1]
   }
   return $min
}

proc memphy_min_in_collection_to_name { col attribute name } {
   set i 0
   set min 0
   foreach_in_collection path $col {
      if {[get_node_info -name [get_path_info $path -to]] == $name} {
         if {$i == 0} {
            set min [get_path_info $path -${attribute}]
         } else {
            set temp [get_path_info $path -${attribute}]
            if {$temp < $min} {
               set min $temp
            } 
         }
         set i [expr $i + 1]
      }
   }
   return $min
}

proc memphy_min_in_collection_from_name { col attribute name } {
   set i 0
   set min 0
   foreach_in_collection path $col {
      if {[get_node_info -name [get_path_info $path -from]] == $name} {
         if {$i == 0} {
            set min [get_path_info $path -${attribute}]
         } else {
            set temp [get_path_info $path -${attribute}]
            if {$temp < $min} {
               set min $temp
            } 
         }
         set i [expr $i + 1]
      }
   }
   return $min
}

proc memphy_max_in_collection_to_name { col attribute name } {
   set i 0
   set max 0
   foreach_in_collection path $col {
      if {[get_node_info -name [get_path_info $path -to]] == $name} {
         if {$i == 0} {
            set max [get_path_info $path -${attribute}]
         } else {
            set temp [get_path_info $path -${attribute}]
            if {$temp > $max} {
               set max $temp
            } 
         }
         set i [expr $i + 1]
      }
   }
   return $max
}

proc memphy_max_in_collection_from_name { col attribute name } {
   set i 0
   set max 0
   foreach_in_collection path $col {
      if {[get_node_info -name [get_path_info $path -from]] == $name} {
         if {$i == 0} {
            set max [get_path_info $path -${attribute}]
         } else {
            set temp [get_path_info $path -${attribute}]
            if {$temp > $max} {
               set max $temp
            } 
         }
         set i [expr $i + 1]
      }
   }
   return $max
}


proc memphy_min_in_collection_to_name2 { col attribute name } {
   set i 0
   set min 0
   foreach_in_collection path $col {
      if {[regexp $name [get_node_info -name [get_path_info $path -to]]]} {
         if {$i == 0} {
            set min [get_path_info $path -${attribute}]
         } else {
            set temp [get_path_info $path -${attribute}]
            if {$temp < $min} {
               set min $temp
            } 
         }
         set i [expr $i + 1]
      }
   }
   return $min
}

proc memphy_min_in_collection_from_name2 { col attribute name } {
   set i 0
   set min 0
   foreach_in_collection path $col {
      if {[regexp $name [get_node_info -name [get_path_info $path -from]]]} {
         if {$i == 0} {
            set min [get_path_info $path -${attribute}]
         } else {
            set temp [get_path_info $path -${attribute}]
            if {$temp < $min} {
               set min $temp
            } 
         }
         set i [expr $i + 1]
      }
   }
   return $min
}

proc memphy_max_in_collection_to_name2 { col attribute name } {
   set i 0
   set max 0
   foreach_in_collection path $col {
      if {[regexp $name [get_node_info -name [get_path_info $path -to]]]} {
         if {$i == 0} {
            set max [get_path_info $path -${attribute}]
         } else {
            set temp [get_path_info $path -${attribute}]
            if {$temp > $max} {
               set max $temp
            } 
         }
         set i [expr $i + 1]
      }
   }
   return $max
}

proc memphy_max_in_collection_from_name2 { col attribute name } {
   set i 0
   set max 0
   foreach_in_collection path $col {
      if {[regexp $name [get_node_info -name [get_path_info $path -from]]]} {
         if {$i == 0} {
            set max [get_path_info $path -${attribute}]
         } else {
            set temp [get_path_info $path -${attribute}]
            if {$temp > $max} {
               set max $temp
            } 
         }
         set i [expr $i + 1]
      }
   }
   return $max
}


proc memphy_sort_proc {a b} {
   set idxs [list 1 2 0]
   foreach i $idxs {
      set ai [lindex $a $i]
      set bi [lindex $b $i]
      if {$ai > $bi} {
         return 1
      } elseif { $ai < $bi } {
         return -1
      }
   }
   return 0
}

proc memphy_gcd {p q} {
   set p [expr {abs($p)}]
   set q [expr {abs($q)}]
   while {$q != 0} {
      set r [expr {$p % $q}]
      set p $q
      set q $r
   }
   return $p
}

proc memphy_traverse_atom_path {atom_id atom_oport_id path} {
   # Return list of {atom oterm_id} pairs by tracing the atom netlist starting from the given atom_id through the given path
   # Path consists of list of {atom_type fanin|fanout|end <port_type> <-optional>}
   set result [list]
   if {[llength $path] > 0} {
      set path_point [lindex $path 0]
      set atom_type [lindex $path_point 0]
      set next_direction [lindex $path_point 1]
      set port_type [lindex $path_point 2]
      set atom_optional [lindex $path_point 3]
      if {[get_atom_node_info -key type -node $atom_id] == $atom_type} {
         if {$next_direction == "end"} {
            if {[get_atom_port_info -key type -node $atom_id -port_id $atom_oport_id -type oport] == $port_type} {
               lappend result [list $atom_id $atom_oport_id]
            }
         } elseif {$next_direction == "atom"} {
            lappend result [list $atom_id]
         } elseif {$next_direction == "fanin"} {
            set atom_iport [get_atom_iport_by_type -node $atom_id -type $port_type]
            if {$atom_iport != -1} {
               set iport_fanin [get_atom_port_info -key fanin -node $atom_id -port_id $atom_iport -type iport]
               set source_atom [lindex $iport_fanin 0]
               set source_oterm [lindex $iport_fanin 1]
               set result [memphy_traverse_atom_path $source_atom $source_oterm [lrange $path 1 end]]
            } elseif {$atom_optional == "-optional"} {
               set result [memphy_traverse_atom_path $atom_id $atom_oport_id [lrange $path 1 end]]
            }
         } elseif {$next_direction == "fanout"} {
            set atom_oport [get_atom_oport_by_type -node $atom_id -type $port_type]
            if {$atom_oport != -1} {
               set oport_fanout [get_atom_port_info -key fanout -node $atom_id -port_id $atom_oport -type oport]
               foreach dest $oport_fanout {
                  set dest_atom [lindex $dest 0]
                  set dest_iterm [lindex $dest 1]
                  set fanout_result_list [memphy_traverse_atom_path $dest_atom -1 [lrange $path 1 end]]
                  foreach fanout_result $fanout_result_list {
                     if {[lsearch $result $fanout_result] == -1} {
                        lappend result $fanout_result
                     }
                  }
               }
            }
         } else {
            error "Unexpected path"
         }
      } elseif {$atom_optional == "-optional"} {
         set result [memphy_traverse_atom_path $atom_id $atom_oport_id [lrange $path 1 end]]
      }
   }
   return $result
}


proc memphy_get_operating_conditions_number {} {
   set cur_operating_condition [get_operating_conditions]
   set counter 0
   foreach_in_collection op [get_available_operating_conditions] {
      if {[string compare $cur_operating_condition $op] == 0} {
         return $counter
      }
      incr counter
   }
   return $counter
}

proc memphy_calculate_counter_value { cnt_hi cnt_lo cnt_bypass } {
   if {$cnt_bypass == "true"} {
      set result 1
   } else {
      set result [expr $cnt_hi + $cnt_lo]
   }
   return $result
}

proc memphy_get_ddr_pins { instname allpins rate var_array_name} {
   # We need to make a local copy of the allpins associative array
   upvar allpins pins
   upvar 1 $var_array_name var
   set debug 0

   if {[is_fitter_in_qhd_mode]} {
      set plloutput_name phy_clk_phs
      set c0_periph_clock_name "phy_clk\[1\]"
      set c1_periph_clock_name "phy_clk\[0\]"
   } else {
      set plloutput_name pll_vcoph
      set c0_periph_clock_name "pll_lvds_clk\[0\]"
      set c1_periph_clock_name "pll_loaden\[0\]"
   }
   # with the hyper-retimer, the tdb netlist may contain the full set of routing nodes, so we need
   # to search deeper
   if {[expr [get_global_assignment -name "HYPER_RETIMER"] == "ON"]} {
      set var(pll_inclock_search_depth) 250
      set var(pll_outclock_search_depth) 250
      set var(pll_vcoclock_search_depth) 50
   } else {
      set var(pll_inclock_search_depth) 25
      set var(pll_outclock_search_depth) 20
      set var(pll_vcoclock_search_depth) 5
   }

   # ########################################
   #  1.0 find all of the PLL output clocks

   #  C0 output in the periphery
   set pins(pll_c0_periph_clock) [list]
   set pins(pll_c0_periph_clock_id) [get_nets -nowarn [list ${instname}|core|arch_inst|pll_inst|${c0_periph_clock_name}  ${instname}|core|arch_inst|pll_inst|pll_inst*LVDS_CLK0]]
   foreach_in_collection c $pins(pll_c0_periph_clock_id) {
      lappend pins(pll_c0_periph_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }
   set pins(pll_c0_periph_clock) [memphy_join [memphy_sort_duplicate_names $pins(pll_c0_periph_clock)]]

   #  C1 output in the periphery
   set pins(pll_c1_periph_clock) [list]
   set pins(pll_c1_periph_clock_id) [get_nets -nowarn [list ${instname}|core|arch_inst|pll_inst|${c1_periph_clock_name}  ${instname}|core|arch_inst|pll_inst|pll_inst*LOADEN0]]
   foreach_in_collection c $pins(pll_c1_periph_clock_id) {
      lappend pins(pll_c1_periph_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }
   set pins(pll_c1_periph_clock) [memphy_join [memphy_sort_duplicate_names $pins(pll_c1_periph_clock)]]

   #  C0 output to the core
   set pins(pll_c0_core_clock) [list]
   set pins(pll_c0_core_clock_id) [get_nets -nowarn [list ${instname}|core|arch_inst|pll_inst|core_clks_from_pll\[0\]  ${instname}|core|arch_inst|pll_inst|pll_inst*outclk\[0\]]]
   foreach_in_collection c $pins(pll_c0_core_clock_id) {
      lappend pins(pll_c0_core_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }
   set pins(pll_c0_core_clock) [memphy_join [memphy_sort_duplicate_names $pins(pll_c0_core_clock)]]

   set pins(pll_c0_cpa_core_clock) [list]
   set pins(pll_c0_cpa_core_clock_id) [get_pins -nowarn [list ${instname}|core|arch_inst|group_gen\[*\].u_phylite_group_tile_14|u_forteennm_tile_ctrl|pa_core_clk_out\[0\]]]
   foreach_in_collection c $pins(pll_c0_cpa_core_clock_id) {
      lappend pins(pll_c0_cpa_core_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }
   set pins(pll_c0_cpa_core_clock) [memphy_join [memphy_sort_duplicate_names $pins(pll_c0_cpa_core_clock)]]
   if {[llength $pins(pll_c0_cpa_core_clock)] > 0} {
      append pins(pll_c0_cpa_core_clock) " "
      append pins(pll_c0_cpa_core_clock) $pins(pll_c0_core_clock)
      set pins(pll_c0_core_clock) $pins(pll_c0_cpa_core_clock)
   }

   #  C1 output to the core
   set pins(pll_c1_core_clock) [list]
   set pins(pll_c1_core_clock_id) [get_nets -nowarn [list ${instname}|core|arch_inst|pll_inst|core_clks_from_pll\[1\]  ${instname}|core|arch_inst|pll_inst|pll_inst*outclk\[1\]]]
   foreach_in_collection c $pins(pll_c1_core_clock_id) {
      lappend pins(pll_c1_core_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }
   set pins(pll_c1_core_clock) [memphy_join [memphy_sort_duplicate_names $pins(pll_c1_core_clock)]]

   #  VCO clock (used for the system clock)
   set pins(vco_clock) [list]
   set pins(vco_clock_id) [get_nets -nowarn [list ${instname}|core|arch_inst|pll_inst|${plloutput_name}\[0\]  ${instname}|core|arch_inst|pll_inst|pll_inst*VCOPH0]]
   foreach_in_collection c $pins(vco_clock_id) {
      lappend pins(vco_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }
   set pins(vco_clock) [memphy_join [memphy_sort_duplicate_names $pins(vco_clock)]]

   if {$rate == 4} {
      #  Quarter rate      
      set pins(pll_usr_clock_a) $pins(pll_c1_core_clock)
      set pins(pll_c2p_p2c_clock) [list]
      set pins(pll_usr_clock) $pins(pll_c0_core_clock)
      set pins(pll_phy_clock) $pins(pll_c1_periph_clock)
      set pins(pll_phy_clock_l) $pins(pll_c0_periph_clock)
      set pins(pll_vco_clock) $pins(vco_clock)
   } elseif {$rate == 2} {
      #  Half rate
      set pins(pll_usr_clock_a) $pins(pll_c1_core_clock)
      set pins(pll_c2p_p2c_clock) [list]
      set pins(pll_usr_clock) $pins(pll_c0_core_clock)
      set pins(pll_phy_clock) $pins(pll_c1_periph_clock)
      set pins(pll_phy_clock_l) $pins(pll_c0_periph_clock)
      set pins(pll_vco_clock) $pins(vco_clock)
   } elseif {$rate == 1} {
      #  Full rate
      set pins(pll_usr_clock_a) $pins(pll_c1_core_clock)
      set pins(pll_c2p_p2c_clock) [list]
      set pins(pll_usr_clock) $pins(pll_c0_core_clock)
      set pins(pll_phy_clock) $pins(pll_c1_periph_clock)
      set pins(pll_phy_clock_l) $pins(pll_c0_periph_clock)
      set pins(pll_vco_clock) $pins(vco_clock)

   } else {
      post_message -type error "The auto-constraining script was not able to detect an appropriate rate for $instname"
   }

   if {$debug == 1} {
     puts "VCO:     $pins(pll_vco_clock)"
     puts "USR:     $pins(pll_usr_clock)"
     puts "HMC_A:   $pins(pll_usr_clock_a)"
     puts "PHY:     $pins(pll_phy_clock)"   
     puts "PHY_L:   $pins(pll_phy_clock_l)"   
     puts "C2P/P2C: $pins(pll_c2p_p2c_clock)"
     puts ""
   }


   #########################################
   # 2.0  Find the actual master core clock 
   #      As it could come from another interface
   #      In master/slave configurations
   
   set pins(usr_reg) "${instname}|core|arch_inst|post_lock_cnt\[0\]"
   set pll_master_usr_clk "_UNDEFINED_PIN_"

   set msg_list [ list ]

   set pll_master_usr_clk_id [memphy_get_output_clock_id $pins(usr_reg) "Usr clock" msg_list var]
   if {$pll_master_usr_clk_id == -1} {
      foreach {msg_type msg} $msg_list {
         post_message -type $msg_type "memphy_pin_map.tcl: $msg"
      }
      post_message -type error "memphy_pin_map.tcl: Failed to find PLL clock for pins [join $pins(usr_reg)].  Please verify the connectivity of these pins."
   } else {
      set pll_master_usr_clk [memphy_get_pll_clock_name $pll_master_usr_clk_id]
   }

   set pins(pll_master_usr_clk) $pll_master_usr_clk
   if {$debug == 1} {
     puts "Master USR: $pins(pll_master_usr_clk)"
   }

   if {[regexp {(^.*)\|core\|arch_inst\|group_gen\[[0-9]\].u_phylite_group_tile_14\|u_forteennm_tile_ctrl(.*)\|pa_core_clk_out\[[0-9]\]$} $pins(pll_master_usr_clk) matched pins(master_instname) pins(master_instnum)] == 1} {
      set pins(master_vco_clock) [list]
      set pins(master_vco_clock_id) [get_nets $pins(master_instname)|core|arch_inst|pll_inst${pins(master_instnum)}|${plloutput_name}\[0\]]
      foreach_in_collection c $pins(master_vco_clock_id) {
         lappend pins(master_vco_clock) [get_node_info -name $c]
      }
      set pins(master_vco_clock) [memphy_join [lsort $pins(master_vco_clock)]]
      set pins(uses_cpa) 1
   } elseif {[regexp {(^.*)\|core\|arch_inst\|pll_inst(.*)\|core_clks_from_pll\[[0-9]\]$} $pins(pll_master_usr_clk) matched pins(master_instname) pins(master_instnum)] == 1} {
      set pins(master_vco_clock) [list]
      set pins(master_vco_clock_id) [get_nets $pins(master_instname)|core|arch_inst|pll_inst${pins(master_instnum)}|${plloutput_name}\[0\]]
      foreach_in_collection c $pins(master_vco_clock_id) {
         lappend pins(master_vco_clock) [get_node_info -name $c]
      }
      set pins(master_vco_clock) [memphy_join [lsort $pins(master_vco_clock)]]
      set pins(uses_cpa) 0
   } elseif {[regexp {(^.*)\|core\|arch_inst\|pll_inst\|pll_inst(.*)outclk\[[0-9]\]$} $pins(pll_master_usr_clk) matched pins(master_instname) pins(master_instnum)] == 1} {
      set pins(master_vco_clock) [list]
      set pins(master_vco_clock_id) [get_nets $pins(master_instname)|core|arch_inst|pll_inst${pins(master_instnum)}${plloutput_name}\[0\]]
      foreach_in_collection c $pins(master_vco_clock_id) {
         lappend pins(master_vco_clock) [get_node_info -name $c]
      }
      set pins(master_vco_clock) [memphy_join [lsort $pins(master_vco_clock)]]
      set pins(uses_cpa) 0
   }

   if {$debug == 1} {
     puts "Master VCO: $pins(master_vco_clock)"
     puts ""
   }

   # ########################################
   #  2.5 Find the reference clock input of the PLL

   if {$var(PLL_USE_CORE_REF_CLK) == "true"} {
      set pll_port_name "core_refclk"
   } else {
      set pll_port_name "pll_cascade_in"
   }

   set pins(pll_cascade_in_id) [get_pins -compatibility_mode ${pins(master_instname)}|core|arch_inst|pll_inst|pll_inst|$pll_port_name]

   if {$var(PLL_USE_CORE_REF_CLK) == "true"} { 
      if {$pins(pll_cascade_in_id) == -1} {
         post_message -type critical_warning "memphy_pin_map.tcl: Failed to find PLL reference clock"
      } else {
         set pins(pll_ref_clock) "${pins(master_instname)}|core|arch_inst|pll_inst|pll_inst|$pll_port_name"
      }
   } else {
      set pll_ref_clock_id [memphy_get_input_clk_id $pins(pll_cascade_in_id) var]
      if {$pll_ref_clock_id == -1} {
         post_message -type critical_warning "memphy_pin_map.tcl: Failed to find PLL reference clock"
      } else {
         set pll_ref_clock [get_node_info -name $pll_ref_clock_id]
      }
      set pins(pll_ref_clock) $pll_ref_clock
   }

   if {$debug == 1} {
     puts "REF:     $pins(pll_ref_clock)"
     puts ""
   }

   #########################################
   # 3.0  find the FPGA pins

   # The hierarchy paths to all the pins are stored in the *_ip_parameters.tcl
   # file which is a generated file. Pins are divided into the following
   # protocol-agnostic categories. For each pin category, we need to
   # fully-resolve the hierarchy path patterns and store the results into
   # the "pins" arrays.
   set num_grps $var(PHYLITE_NUM_GROUPS)
   for {set i_grp_idx 0} {$i_grp_idx < $num_grps} {incr i_grp_idx} {
      set pin_categories [list rclk,$i_grp_idx \
                               rclk_n,$i_grp_idx \
                               wclk,$i_grp_idx \
                               wclk_n,$i_grp_idx \
                               rdata,$i_grp_idx \
                               wdata,$i_grp_idx ]

      set patterns [ list ]
      foreach pin_category $pin_categories {
         set pins($pin_category) [list]

         foreach pattern $var(PATTERNS_[string toupper $pin_category]) {
            set pattern "${instname}|$pattern"
            lappend patterns $pin_category $pattern
         }
      }

      foreach {pin_type pattern} $patterns { 
         if {($pin_type == "rdata,$i_grp_idx") || ($pin_type == "rclk,$i_grp_idx") || ($pin_type == "rclk_n,$i_grp_idx")} {
            set local_pins [ memphy_get_names_in_collection [ get_fanins $pattern ] ]
         } else {
            set local_pins [ memphy_get_names_in_collection [ get_fanouts $pattern ] ]
         }

         if {[llength $local_pins] == 0} {
            post_message -type critical_warning "Could not find pin of type $pin_type from pattern $pattern"
         } else {
            foreach pin [lsort -unique $local_pins] {
               lappend pins($pin_type) $pin
            }
         }
      }
   }

   #########################################
   # 4.0  setup extra PLL clocks parameters

   # User can use remaining PLL clocks from PHYLite GUI and this is to
   # setup the parameters for those clocks such as multiply_by 
   # and divide_by

   if {$var(gui_enable_advanced_mode)} {
      set pll_master_user_clock_base [string range $pins(master_vco_clock) 0 [string last "|" $pins(master_vco_clock)] ]pll_inst|outclk
      set var(max_number_of_reserved_clocks) 5
      set var(m_cnt) [memphy_calculate_counter_value $var(m_cnt_hi_div) $var(m_cnt_lo_div) $var(m_cnt_bypass_en)]
      set var(n_cnt) [memphy_calculate_counter_value $var(n_cnt_hi_div) $var(n_cnt_lo_div) $var(n_cnt_bypass_en)]
      for {set i 0} {$i < $var(gui_number_of_pll_output_clocks)}  {incr i} {
         set i_cnt_num [expr $i + $var(max_number_of_reserved_clocks)]
         set var(c${i_cnt_num}_cnt) [memphy_calculate_counter_value $var(c_cnt_hi_div${i_cnt_num}) $var(c_cnt_lo_div${i_cnt_num}) $var(c_cnt_bypass_en${i_cnt_num})]
         set pins(pll_extra_clock${i}) "$pll_master_user_clock_base\[$i_cnt_num\]"
      }
   }


}


proc memphy_initialize_ddr_db { ddr_db_par rate var_array_name} {
   upvar $ddr_db_par local_ddr_db
   upvar 1 $var_array_name var

   global ::GLOBAL_corename


   post_sdc_message info "Initializing DDR database for CORE $::GLOBAL_corename"
   set instance_list [memphy_get_core_instance_list $::GLOBAL_corename]

   foreach instname $instance_list {


      post_sdc_message info "Finding port-to-pin mapping for CORE: $::GLOBAL_corename INSTANCE: $instname"
      memphy_get_ddr_pins $instname allpins $rate var
      memphy_verify_ddr_pins allpins $rate

      set local_ddr_db($instname) [ array get allpins ]
   }
}

proc memphy_verify_ddr_pins { pins_par rate} {
   upvar $pins_par pins

   if { [ llength $pins(pll_phy_clock) ] != [ llength $pins(pll_vco_clock) ] } {
      post_message -type critical_warning "Found different amounts of the phy_clocks compared to the vco_clocks"
   }
   if {$rate == 8} {
      if { [ llength $pins(pll_c2p_p2c_clock) ] != 1 } {
         post_message -type critical_warning "Found  [ llength $pins(pll_c2p_p2c_clock) ] of c2p_p2c_clks when there should only be 1"
      }
   }
}


proc memphy_get_all_instances_dqs_pins { ddr_db_par } {
   upvar $ddr_db_par local_ddr_db

   set dqs_pins [ list ]
   set instnames [ array names local_ddr_db ]
   foreach instance $instnames {
      array set pins $local_ddr_db($instance)

      foreach { dqs_pin } $pins(dqs_pins) {
         lappend dqs_pins ${dqs_pin}_IN
         lappend dqs_pins ${dqs_pin}_OUT
      }
      foreach { dqsn_pin } $pins(dqsn_pins) {
         lappend dqs_pins ${dqsn_pin}_OUT
      }
      foreach { ck_pin } $pins(ck_pins) {
         lappend dqs_pins $ck_pin
      }
   }

   return $dqs_pins
}

proc memphy_get_input_clk_id { pll_inclk_id var_array_name} {
   upvar 1 $var_array_name var
	
   array set results_array [list]

   memphy_traverse_fanin_up_to_depth $pll_inclk_id memphy_is_node_type_pin clock results_array $var(pll_inclock_search_depth)
   if {[array size results_array] == 1} {
      set pin_id [lindex [array names results_array] 0]
      set result $pin_id
   } else {
      post_message -type critical_warning "Could not find PLL clock for [get_node_info -name $pll_inclk_id]"
      set result -1
   }

   return $result
}

proc memphy_get_output_clock_id { pin_list pin_type msg_list_name var_array_name} {
   upvar 1 $msg_list_name msg_list
   upvar 1 $var_array_name var
   set output_clock_id -1

   set output_id_list [list]
   set pin_collection [get_keepers -no_duplicates $pin_list]
   if {[get_collection_size $pin_collection] == [llength $pin_list]} {
      foreach_in_collection id $pin_collection {
         lappend output_id_list $id
      }
   } elseif {[get_collection_size $pin_collection] == 0} {
      lappend msg_list "warning" "Could not find any $pin_type pins"
   } else {
      lappend msg_list "warning" "Could not find all $pin_type pins"
   }
   memphy_get_pll_clock $output_id_list $pin_type output_clock_id $var(pll_outclock_search_depth)
   return $output_clock_id
}

proc memphy_get_pll_clock { dest_id_list node_type clock_id_name search_depth} {
   if {$clock_id_name != ""} {
      upvar 1 $clock_id_name clock_id
   }
   set clock_id -1

   array set clk_array [list]
   foreach node_id $dest_id_list {
      memphy_traverse_fanin_up_to_depth $node_id memphy_is_node_type_pll_clk clock clk_array $search_depth
   }
   if {[array size clk_array] == 1} {
      set clock_id [lindex [array names clk_array] 0]
      set clk [get_node_info -name $clock_id]
   } elseif {[array size clk_array] > 1} {
      puts "Found more than 1 clock driving the $node_type"
      set clk ""
   } else {
      set clk ""
   }

   return $clk
}

proc memphy_get_vco_clk_id { wf_clock_id var_array_name} {
   upvar 1 $var_array_name var

   array set results_array [list]

   memphy_traverse_fanin_up_to_depth $wf_clock_id memphy_is_node_type_vco clock results_array $var(pll_vcoclock_search_depth)
   if {[array size results_array] == 1} {
      set pin_id [lindex [array names results_array] 0]
      set result $pin_id
   } else {
      post_message -type critical_warning "Could not find VCO clock for [get_node_info -name $wf_clock_id]"
      set result -1
   }

   return $result
}

proc memphy_is_node_type_pll_clk { node_id } {
   set cell_id [get_node_info -cell $node_id]

   if {$cell_id == ""} {
      set result 0
   } else {
      set atom_type [get_cell_info -atom_type $cell_id]
      if {$atom_type == "IOPLL"} {
         set node_name [get_node_info -name $node_id]

         if {[regexp {pll_inst.*\|core_clks_from_pll\[[0-9]\]$} $node_name]} {
            set result 1
         } elseif  {[regexp {pll_inst.*outclk\[[0-9]\]$} $node_name]} {
            set result 1
         } else {
            set result 0
         }
      } elseif {$atom_type == "TILE_CTRL"} {
         set node_name [get_node_info -name $node_id]

         if {[regexp {u_forteennm_tile_ctrl\|pa_core_clk_out\[[0-9]\]$} $node_name]} {
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

proc memphy_is_node_type_vco { node_id } {
   set cell_id [get_node_info -cell $node_id]

   if {$cell_id == ""} {
      set result 0
   } else {
      set atom_type [get_cell_info -atom_type $cell_id]
      if {$atom_type == "IOPLL"} {
         set node_name [get_node_info -name $node_id]

         if {[regexp {pll_inst.*\|.*vcoph\[0\]$} $node_name]} {
            set result 1
         } elseif {[regexp {pll_inst.*VCOPH0$} $node_name]} {
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

proc memphy_does_ref_clk_exist { ref_clk_name } {

   set ref_clock_found 0
   foreach_in_collection iclk [get_clocks -nowarn] {
      set clk_targets [get_clock_info -target $iclk]
      foreach_in_collection itgt $clk_targets {
         set node_name [get_node_info -name $itgt]
         if {[string compare $node_name $ref_clk_name] == 0} {
            set ref_clock_found 1
            break
         }
      }
      if {$ref_clock_found == 1} {
         break;
      }
   }

   return $ref_clock_found
}

proc memphy_get_p2c_c2p_clock_uncertainty { instname var_array_name } {

   set success 1
   set error_message ""
   set clock_uncertainty 0
   set debug 0

   package require ::quartus::atoms
   upvar 1 $var_array_name var

   catch {read_atom_netlist} read_atom_netlist_out
   set read_atom_netlist_error [regexp "ERROR" $read_atom_netlist_out]

   if {$read_atom_netlist_error == 0} {

      if {[memphy_are_entity_names_on]} {
         regsub -all {\|} $instname "|*:" instname
      }
      regsub -all {\\} $instname {\\\\} instname
      regsub -all {\[} $instname "\\\[" instname
      regsub -all {\]} $instname "\\\]" instname

      # Find the IOPLLs
      if {$success == 1} {
         if {[memphy_are_entity_names_on]} {
            set pll_atoms [get_atom_nodes -matching *${instname}|*:core|*:arch_inst|*:pll_inst|* -type IOPLL]
         } else {
            set pll_atoms [get_atom_nodes -matching *${instname}|core|arch_inst|pll_inst|* -type IOPLL]
         }
         set num_pll_inst [get_collection_size $pll_atoms]

         if {$num_pll_inst == 0} {
            set success 0
            post_message -type critical_warning "The auto-constraining script was not able to detect any PLLs in the < $instname > memory interface."
         }
      }

      # Get atom parameters
      if {$success == 1} {

         set mcnt_list [list]
         set bw_list   [list]
         set cp_setting_list [list]
         set vco_period_list [list]

         foreach_in_collection pll_atom $pll_atoms {

            # M-counter value
            if {[get_atom_node_info -node $pll_atom -key  BOOL_IOPLL_M_CNT_BYPASS_EN] == 1} {
               set mcnt 1
            } else {
               set mcnt [expr [get_atom_node_info -node $pll_atom -key INT_IOPLL_M_CNT_HI_DIV] + [get_atom_node_info -node $pll_atom -key INT_IOPLL_M_CNT_LO_DIV]]
            }
            lappend mcnt_list $mcnt

            # BW
            set bw [get_atom_node_info -node $pll_atom -key  ENUM_IOPLL_BW_MODE]
            if {[string compare -nocase $bw "AUTO"] == 0} {
               set bw "LBW"
            } elseif  {[string compare -nocase $bw "LOW_BW"] == 0} {
                set bw "LBW"
            } elseif  {[string compare -nocase $bw "MID_BW"] == 0} {
                set bw "MBW"
            } elseif  {[string compare -nocase $bw "HI_BW"] == 0} {
                set bw "HBW"
            }
            lappend bw_list $bw

            # CP current setting
            set cp_setting [get_atom_node_info -node $pll_atom -key ENUM_IOPLL_PLL_CP_CURRENT]
            lappend cp_setting_list $cp_setting

            # VCO frequency setting
            set vco_period [get_atom_node_info -node $pll_atom -key TIME_VCO_FREQUENCY]
            lappend vco_period_list $vco_period
         }

         # Make sure all IOPLL parameters are the same
         for {set i [expr [llength $mcnt_list] - 1]} {$i > 0} {set i [expr $i - 1]} {
            if {[lindex $mcnt_list $i] != [lindex $mcnt_list [expr $i - 1]]} {
               set success 0
               post_message -type critical_warning "The auto-constraining script found multiple PLLs in the < $instname > memory interface with different parameters."
            }
         }
         for {set i [expr [llength $bw_list] - 1]} {$i > 0} {set i [expr $i - 1]} {
            set bw_a [lindex $bw_list $i]
            set bw_b [lindex $bw_list [expr $i - 1]]
            if {[string compare -nocase $bw_a $bw_b] != 0} {
               set success 0
               post_message -type critical_warning "The auto-constraining script found multiple PLLs in the < $instname > memory interface with different parameters."
            }
         }
         for {set i [expr [llength $cp_setting_list] - 1]} {$i > 0} {set i [expr $i - 1]} {
            set cp_a [lindex $cp_setting_list $i]
            set cp_b [lindex $cp_setting_list [expr $i - 1]]
            if {[string compare -nocase $cp_a $cp_b] != 0} {
               set success 0
               post_message -type critical_warning "The auto-constraining script found multiple PLLs in the < $instname > memory interface with different parameters."
            }
         }

         for {set i [expr [llength $vco_period_list] - 1]} {$i > 0} {set i [expr $i - 1]} {
            set vco_a [lindex $vco_period_list $i]
            set vco_b [lindex $vco_period_list [expr $i - 1]]
            if {[string compare -nocase $vco_a $vco_b] != 0} {
               set success 0
               post_message -type critical_warning "The auto-constraining script found multiple PLLs in the < $instname > memory interface with different parameters."
            }
         }
      }

      # Calculate clock uncertainty
      if {$success == 1} {

         set mcnt [lindex $mcnt_list 0]
         set bw   [string toupper [lindex $bw_list 0]]
         set cp_setting [lindex $cp_setting_list 0]
         set cp_current [memphy_get_cp_current_from_setting $cp_setting]
         set vco_period [lindex $vco_period_list 0]
         if {[regexp {([0-9]+) ps} $vco_period matched vco_period] == 1} {
         } else {
            post_message -type critical_warning "The auto-constraining script was not able to read the netlist."
            set success 0
         }
	 set vco_frequency_in_mhz [expr 1000000 / $vco_period]

         if {$debug} {
            puts "MCNT : $mcnt"
            puts "BW   : $bw"
            puts "CP   : $cp_setting ($cp_current)"
            puts "VCO  : $vco_period"
         }

         set HFR  [get_clock_frequency_uncertainty_data PLL $vco_frequency_in_mhz $bw OFFSET${mcnt} HFR]
         set LFD  [get_clock_frequency_uncertainty_data PLL $vco_frequency_in_mhz $bw OFFSET${mcnt} LFD]
         set SPE  [memphy_get_spe_from_cp_current $cp_current]

         if {$success == 1} {
            set clock_uncertainty_sqrt  [expr sqrt(($LFD/2)*($LFD/2) + ($LFD/2)*($LFD/2))]
            set clock_uncertainty [memphy_round_3dp [expr ($clock_uncertainty_sqrt + $SPE)*1e9]]

            if {$debug} {
               puts "HFR  : $HFR"
               puts "LFD  : $LFD"
               puts "SPE  : $SPE"
               puts "TOTAL: $clock_uncertainty"
            }
         }
      }

   } else {
      set success 0
      post_message -type critical_warning "The auto-constraining script was not able to read the netlist."
   }

   # Output warning in the case that clock uncertainty can't be determined
   if {$success == 0} {
      post_message -type critical_warning "Verify the following:"
      post_message -type critical_warning " The core < $instname > is instantiated within another component (wrapper)"
      post_message -type critical_warning " The core is not the top-level of the project"
      post_message -type critical_warning " The memory interface pins are exported to the top-level of the project"
      post_message -type critical_warning " The core  < $instname > RTL has not been modified manually"
   }

   return $clock_uncertainty
}


proc memphy_get_cp_current_from_setting { cp_setting } {

   set cp_current 0

   if {[string compare -nocase $cp_setting "PLL_CP_SETTING0"] == 0} {
      set cp_current 0
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING1"] == 0} {
      set cp_current 5	
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING2"] == 0} {
      set cp_current 10
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING3"] == 0} {
      set cp_current 15
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING4"] == 0} {
      set cp_current 20	
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING5"] == 0} {
      set cp_current 25		
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING6"] == 0} {
      set cp_current 30
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING7"] == 0} {
      set cp_current 35	
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING8"] == 0} {
      set cp_current 40	
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING9"] == 0} {
      set cp_current 45
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING10"] == 0} {
      set cp_current 50	
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING11"] == 0} {
      set cp_current 55			
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING12"] == 0} {
      set cp_current 60
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING13"] == 0} {
      set cp_current 65			
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING14"] == 0} {
      set cp_current 70	
   } elseif {[string compare -nocase $cp_setting "PLL_CP_SETTING15"] == 0} {
      set cp_current 75			
	} else {
      set cp_current 0
   }
}

proc memphy_get_spe_from_cp_current { cp_current } {

   set spe 158.0e-12

   if {$cp_current <= 15} {
      set spe 158e-012 
   } elseif {$cp_current <= 20} {
      set spe 130.62e-12 
   } elseif {$cp_current <= 25} {
      set spe 117.3e-12 
   } elseif {$cp_current <= 30} {
      set spe 109.5e-12 
   } elseif {$cp_current <= 35} {
      set spe 104.5e-12 
   } elseif {$cp_current <= 40} {
      set spe 100.9e-12 
   } elseif {$cp_current <= 60} {
      set spe 93.3e-12 
   } else {
      set spe 93.3e-12 
   }
}

proc memphy_get_periphery_clock_uncertainty { results_array_name var_array_name } {
   upvar 1 $results_array_name results
   upvar 1 $var_array_name var

   set speed_temp_grade [get_speedgrade_name]

   set c2p_setup  0.0
   set c2p_hold   0.0
   set p2c_setup  0.0
   set p2c_hold   0.0

   set results [list $c2p_setup $c2p_hold $p2c_setup $p2c_hold]
}

proc memphy_get_core_clock_uncertainty { results_array_name var_array_name } {
   upvar 1 $results_array_name results
   upvar 1 $var_array_name var

   set speed_temp_grade [get_speedgrade_name]

   set c2c_same_setup  0
   set c2c_same_hold   0
   set c2c_diff_setup  0
   set c2c_diff_hold   0
   
   set results [list $c2c_same_setup $c2c_same_hold $c2c_diff_setup $c2c_diff_hold]
}

proc memphy_sort_duplicate_names { names_array } {

   set main_name ""
   set duplicate_names [list]

   # Find the main name as opposed to all the duplicate names
   foreach { name } $names_array {
      if  {[regexp {Duplicate} $name]} {
         lappend duplicate_names $name
      } else {
         if {$main_name == ""} {
            set main_name $name
         } else {
            post_message -type error "More than one main tile name ($main_name and $name).  Please verify the connectivity of these pins."
         }
      }
   }

   # Now sort the duplicate names
   set duplicate_names [join [lsort -decreasing $duplicate_names]]

   # Prepend the main name and then return
   set result [join [linsert $duplicate_names 0 $main_name]]

   return $result
}


proc memphy_join {the_list} { 
   return [regsub -all {\\} [join $the_list] {\\\\}] 
}
