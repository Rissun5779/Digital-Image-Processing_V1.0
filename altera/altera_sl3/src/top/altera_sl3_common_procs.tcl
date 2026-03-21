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



# String extraction
proc extract_Int_frm_str { str } {
   regexp {[0-9]+ *\. *[0-9]+} $str out
   return $out
}

# logarithm to Base 2
proc log2 {x} {
    expr (log($x) / log(2))
}

proc clogb2 { input_num } {
  for {set retval 0} {$input_num > 0} {incr retval} {
    set input_num [expr {$input_num >> 1}]
  }
  if {$retval == 0} {
    set retval 1
  }
   
  return $retval
}


#-----------------------------
#   Common Parameter Procs
#-----------------------------

#--Return 1 if parameter's value matches with input value
proc param_matches {param value} {
   if {[string compare -nocase [get_parameter_value $param] $value] == 0} {
      return 1
   }
   return 0
}

#--Return 1 if parameter is TRUE
proc param_is_true {param} {
   return [param_matches $param "true"]
}

#--Return 1 if parameter is ENABLED
proc param_is_enabled {param} {
   if {[get_parameter_property $param ENABLED] == 1} {
      return 1
   }
   return 0   
}

#--Configure the parameter to be ENABLED or DISABLED
#--$param  - Parameter to be configured
#--$enable - 1 to ENABLE otherwise 0 to DISABLE 
proc conf_params_en { param enable } {
   set_parameter_property $param ENABLED $enable
}

#--Configure the ALLOWED RANGE for the parameter
#--$param - Parameter to be configured
#--$range - Allowed range for the parameter
proc conf_params_range { param range } {
   if {[param_is_enabled $param]} {
      set_parameter_property $param ALLOWED_RANGES $range
   } 
}

# Propagate the parameters of current instance to the lower level instances
proc propagate_params {instance} {
   foreach param_name [get_instance_parameters $instance] {
      set_instance_parameter_value $instance $param_name [get_parameter_value $param_name]
   }
}

#--Calculate number of ports defined in module
proc get_total_ports { ports } {
   return [llength $ports]
}

#-------------------------------------
#   Common Interface/Connection Procs
#-------------------------------------

#--Export interface from lower instance
#--$interface     - Name of interface to export
#--$type          - Type of interface to export
#--$dir           - Direction to export 
#--$instance      - Export interface from which lower instance
#--$inst_instance - Export interface from which lower instance's interface
#--$enable        - Enable or disable this procedure
proc set_export_interface { interface type dir instance inst_interface enable} {
   if {$enable == 1} {
      add_interface           $interface            $type     $dir
      set_interface_property  $interface  EXPORT_OF $instance.$inst_interface
      set_interface_property  $interface  PORT_NAME_MAP "$interface $inst_interface"
   }
}

#--Return add connection if enable == 1 , otherwise return ""
#--$from   - From which instance's interface
#--$to     - To which instance's interface
#--$enable - Enable or disable this function
proc set_connections {from to enable} {
   if {$enable == 1 } {
      return [add_connection $from $to]
   } else {
      return ""
   }
}

#--Add conduit interface and port of same name
#--$port_name   - Interface & port name 
#--$signal_type - Type of port.
#--$port_dir    - Direction of port and interface
#--$width       - Width of port
#--$vhdl_type   - Type of port in vhdl. 'std_logic' or 'std_logic_vector'
#--$used        - Enable or disable this interface. Can be "true" or "false"
#--$terminate   - 1 to terminate this port otherwise 0  
proc common_add_optional_conduit { port_name port_type port_dir width vhdl_type used terminate } {
#  array set in_out [list {output} {start} {input} {end} ]
#  add_interface $port_name conduit $in_out($port_dir)
  add_interface $port_name conduit $port_dir
  set_interface_assignment $port_name "ui.blockdiagram.direction" $port_dir
  set_interface_property $port_name ENABLED $used
  add_interface_port $port_name $port_name $port_type $port_dir $width
  if {[expr {$port_dir == "input" || $port_dir == "end"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
     set_port_property   $port_name   TERMINATION_VALUE   0
  }
  if {[expr {$port_dir == "output" || $port_dir == "start"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
  }
  if {[expr {$vhdl_type == "std"}]} {
     set_port_property   $port_name   VHDL_TYPE  std_logic
  }
  if {[expr {$vhdl_type == "vector"}]} {
     set_port_property   $port_name   VHDL_TYPE  std_logic_vector
  }
  
}

#--Add reset interface and port of same name
#--$port_name       - Interface & port name 
#--$port_dir        - Direction of port and interface
#--$asscociated_clk - Which clock is this reset associated with
#--$syncEdge        - synchronous edge
#--$terminate       - 1 to terminate this port otherwise 0  
proc common_add_reset { port_name port_type port_dir associated_clk syncEdge terminate } {
  array set in_out [list {output} {start} {input} {end} ]
  add_interface $port_name reset $in_out($port_dir)
 # set_interface_property $port_name ASSOCIATED_CLOCK $associated_clk
  set_interface_property $port_name associatedClock  $associated_clk
  set_interface_property $port_name synchronousEdges $syncEdge
  add_interface_port $port_name $port_name $port_type $port_dir 1
  if {[expr {$port_dir == "input" || $port_dir == "end"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
     set_port_property   $port_name   TERMINATION_VALUE   0
  }
  if {[expr {$port_dir == "output" || $port_dir == "start"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
  }
}

#--Add clock interface and port of same name
#--$port_name   - Interface & port name 
#--$int_type    - Type of interface. Can be "clock", "hssi_bonded_clock", "hssi_serial_clock"
#--$port_dir    - Direction of port and interface
#--$width       - Width of port
#--$vhdl_type   - Type of port in vhdl. 'std_logic' or 'std_logic_vector'
#--$used        - Enable or disable this interface. Can be "true" or "false"
#--$terminate   - 1 to terminate this port otherwise 0  
proc common_add_clock { port_name int_type port_dir width vhdl_type used terminate } {
#  array set in_out [list {output} {start} {input} {end} ]
#  add_interface $port_name $int_type $in_out($port_dir)
  add_interface $port_name $int_type $port_dir
  set_interface_property $port_name ENABLED $used
  add_interface_port $port_name $port_name clk $port_dir $width
  if {[expr {$port_dir == "input" || $port_dir == "end"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
     set_port_property   $port_name   TERMINATION_VALUE   0
  }
  if {[expr {$port_dir == "output" || $port_dir == "start"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
  }
  if {[expr {$vhdl_type == "std"}]} {
     set_port_property   $port_name   VHDL_TYPE  std_logic
  }
  if {[expr {$vhdl_type == "vector"}]} {
     set_port_property   $port_name   VHDL_TYPE  std_logic_vector
  }

}

#--Add fragmented qsys interface with port of same width for single RTL signal
#--$port_name   - Interface & port name
#--$int_type    - Type of interface 
#--$port_type   - Type of port.
#--$port_dir    - Direction of port and interface
#--$port_width  - Width of ports
#--$total_width - Width of RTL signal
#--$vhdl_type   - Type of port in vhdl. 'std_logic' or 'std_logic_vector'
#--$used        - Enable or disable this interface. Can be "true" or "false"
#--$terminate   - 1 to terminate this port otherwise 0  
proc add_fragmented_qsys_interface { port_name int_type port_type port_dir port_width total_width vhdl_type used terminate } {
  # Termination does NOT work properly for FRAGMENT_LIST. Thus, re-create interface & port without FRAGMENT_LIST for termination.
  if {$terminate == 1} {
     add_interface ${port_name} $int_type $port_dir
     add_interface_port ${port_name} ${port_name} $port_type $port_dir $total_width
     set_interface_property   ${port_name}   ENABLED  $used

     if {[expr {$port_dir == "input" || $port_dir == "end"}] && $terminate == 1} {
        set_port_property   ${port_name}   TERMINATION   true
        set_port_property   ${port_name}   TERMINATION_VALUE   0
     }
     if {[expr {$port_dir == "output" || $port_dir == "start"}] && $terminate == 1} {
        set_port_property   ${port_name}   TERMINATION   true
     }
     if {[expr {$vhdl_type == "std"}]} {
        set_port_property   ${port_name}   VHDL_TYPE  std_logic
     }
     if {[expr {$vhdl_type == "vector"}]} {
        set_port_property   ${port_name}   VHDL_TYPE  std_logic_vector
     }
  } else {
     for {set i 0} {$i < [expr $total_width/$port_width] } {incr i} {
        add_interface ${port_name}_ch${i} $int_type $port_dir
        add_interface_port ${port_name}_ch${i} ${port_name}_ch${i} $port_type $port_dir $port_width
        set_interface_property   ${port_name}_ch${i}   ENABLED  $used
        if {$port_width == "1"} {
           set_port_property ${port_name}_ch${i} FRAGMENT_LIST  ${port_name}@$i
        } else {
           set_port_property ${port_name}_ch${i} FRAGMENT_LIST  ${port_name}([expr [expr {$i + 1}]*$port_width-1]:[expr ${i}*$port_width])  
        }
          
        if {[expr {$vhdl_type == "std"}]} {
           set_port_property   ${port_name}_ch${i}   VHDL_TYPE  std_logic
        }
        if {[expr {$vhdl_type == "vector"}]} {
           set_port_property   ${port_name}_ch${i}   VHDL_TYPE  std_logic_vector
        }
     }
  }
}

#---------------------------------
#     JESD204 Specific Procs
# --------------------------------

# return 1 if DEVICE_FAMILY = Stratix V || Arria V || Arria V GZ || Cyclone V , otherwise return 0
proc device_is_vseries {} {
   if {[param_matches DEVICE_FAMILY "Stratix V"] || [param_matches DEVICE_FAMILY "Arria V"] || [param_matches DEVICE_FAMILY "Arria V GZ"] || [param_matches DEVICE_FAMILY "Cyclone V"] } {
      return 1
   } else {
      return 0
   }
}

# return 1 if direction == TX or RX_TX , otherwise return 0
proc get_tx_interfaces_on {} {
   if {[param_matches DIRECTION "Rx"]} {
      return 0
   } else {
      return 1
   }
}

# return 1 if direction == RX or RX_TX ,otherwise return 0
proc get_rx_interfaces_on {} {
   if {[param_matches DIRECTION "Tx"]} {
      return 0
   } else {
      return 1
   }
}

# return 1 if direction == Duplex, otherwise return 0
proc duplex_configuration {} {
   if {[param_matches DIRECTION "Duplex"]} {
      return 1
   } else {
      return 0
   }
}

# return 1 if direction == Tx, otherwise return 0
proc simplex_src_configuration {} {
   if {[param_matches DIRECTION "Tx"]} {
      return 1
   } else {
      return 0
   }
}

# return 1 if direction == Rx, otherwise return 0
proc simplex_snk_configuration {} {
   if {[param_matches DIRECTION "Rx"]} {
      return 1
   } else {
      return 0
   }
}

# Return the correct hssi clock's type based on bonded mode options for series 10 device family
proc derive_hssiclk_type_xs { } {
   if {[param_matches bonded_mode "non_bonded"]} {
      return "hssi_serial_clock"
   } else {
      return "hssi_bonded_clock"
   }
}

# Return the bonded mode (x1, xN or fb_compensation) based on L and device families
# If bonded - AV : return xN
#           - SV : return xN if L<6
#                : return fb_compensation if L >= 6
# If non-bonded  : return x1 for AV and SV.               
proc derive_bonded_mode {} {
   if {[param_matches DEVICE_FAMILY "ARRIA V"]} {
      return [expr { [param_matches bonded_mode "bonded"] ? "xN" : "x1"}]
   } elseif {[param_matches DEVICE_FAMILY "Cyclone V"]} {
      return [expr { [param_matches bonded_mode "bonded"] ? "xN" : "x1"}]
   } elseif {[param_matches DEVICE_FAMILY "Stratix V"] || [param_matches DEVICE_FAMILY "Arria V GZ"]} {
      return [expr { [param_matches bonded_mode "bonded"] ? [get_parameter_value "L"] < 6  ? "xN" : "fb_compensation" : "x1"}]
   }
}

# Return the width of reconfig_to_xcvr 
proc derive_reconfig_to_width {} {
   set d_L [get_parameter_value "L"]
   if {[param_matches DATA_PATH "RX"]} {
        return [expr { $d_L*70 }]
   } else {
      if {[derive_bonded_mode] == "xN"} {
         return [expr { ($d_L + 1)*70 }]
      } else {
         return [expr {$d_L*2*70}]
      }
   }
}

# get transceiver component's name
proc get_xcvr_component_name {device} {
   if {$device == "Stratix V"} {
      return "altera_xcvr_native_sv"
   } elseif {$device == "Arria V GZ"} {
      return "altera_xcvr_native_avgz"
   } elseif {$device == "Arria V"} {
      return "altera_xcvr_native_av"
   } elseif {$device == "Cyclone V"} {
      return "altera_xcvr_native_cv"
   }  elseif {$device == "Arria 10"} {
      return "altera_xcvr_native_a10"
   }  elseif {$device == "Stratix 10"} {
      return "altera_xcvr_native_s10"
   }
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


# This function is dedicated for series 10 device family
# -- set bonded_mode = non_bonded if L =1 , otherwise bonded_mode = pma_only
# -- derive hssi clock's name based on L
# -- derive hssi clock's type based on L
proc derive_pll_mode_clk_xs { lane get_info} {
   if {[param_matches bonded_mode "non_bonded"]} {
      if {$get_info == "bonded_mode"} {
         return "not_bonded"
      } elseif {$get_info == "clk_name"} {
         return "tx_serial_clk0"
      } elseif {$get_info == "clk_type"} {
         return "hssi_serial_clock"
      }
   } else {
      if {$get_info == "bonded_mode"} {
         return "pma_only"
      } elseif {$get_info == "clk_name"} {
         return "tx_bonding_clocks"
      } elseif {$get_info == "clk_type"} {
         return "hssi_bonded_clock"
      }
   }
}

# Add signal adapter instance 
proc add_sig_adapter {inst_name mode int_type in_width_0 in_width_1 in_sig_type out_width out_sig_type bit_multiplier} {
   add_instance                   $inst_name   altera_jesd204_signal_adapter  18.1
   set_instance_parameter_value   $inst_name   MODE $mode
   set_instance_parameter_value   $inst_name   INTERFACE_TYPE $int_type
   set_instance_parameter_value   $inst_name   IN_WIDTH_0 $in_width_0
   set_instance_parameter_value   $inst_name   IN_WIDTH_1 $in_width_1
   set_instance_parameter_value   $inst_name   FROM_SIG_TYPE $in_sig_type
   set_instance_parameter_value   $inst_name   OUT_WIDTH $out_width
   set_instance_parameter_value   $inst_name   TO_SIG_TYPE $out_sig_type
   set_instance_parameter_value   $inst_name   BIT_MULTIPLIER $bit_multiplier

}

#Add altera_jesd204_fanout instance
proc add_jesd_fanout { inst_name fanout int_type sig_type width } {
   add_instance                   $inst_name   altera_jesd204_fanout  18.1
   set_instance_parameter_value   $inst_name   NUM_FANOUT $fanout
   set_instance_parameter_value   $inst_name   WIDTH $width
   set_instance_parameter_value   $inst_name   INTERFACE_TYPE $int_type
   set_instance_parameter_value   $inst_name   SIGNAL_TYPE $sig_type
}

# Proc copied from alt_xcvr/alt_xcvr_tcl_packages/utils/common.tcl
# +-----------------------------------
# | Map legal values in allowed range to fixed symbolic values
# | 
# | Inputs:
# |   $gui_param_name - symbolic parameter used for GUI display map
# |     Symbols are normal values like "8", or "16", or "32.5 MHz".
# |     At most one symbol will be mapped for any given parameter,
# |     typically because the default value or the last value entered
# |     by the user is no longer valid.
# |     If the current value of a parameter is legal, there will be
# |     no entries in the symbolic map array.
# |     The legal value set is given in the $legal_values parameter
# |   $legal_values   - list of currently legal real values
# | 
# | Returns:
# |   nothing, but does the following:
# |   - sets ALLOWED_RANGE for named parameter
# |   - saves mapping in global array for retrieval using [get_mapped_allowed_range_value gui_param]
# |   # $allowed_range - list that maps symbolic values to legal values for GUI selection
proc map_allowed_range { gui_param_name legal_values {map_value "NO_MAP_VALUE"} {should_sanitize true}} {
  variable allowed_range_symbolic_map
  array set local_map {}
  
  set current_symbol [get_parameter_value $gui_param_name]
  # check for legacy code symbolic value of "u@<val>"
  if {[ regexp {@(.*)} $current_symbol matchresult val ]} {
    set current_value $val
  } else {
    set current_value $current_symbol
  }

  # Strip out all unsafe characters
  regsub -all {[^-A-Za-z_0-9 ]+} $current_value {.} current_value
  # ... and from legal values list
  if {$should_sanitize} {
	set sanitized_legal [list]
	foreach val $legal_values {
		regsub -all {[^-A-Za-z_0-9 ]+} $val {.} val
		lappend sanitized_legal $val
	}
  } else {
	set sanitized_legal $legal_values
	regsub -all {\"} $map_value {} map_value
  }

  # if current value doesn't exist in legal value set, switch to first legal value
  set legal_value [lindex $sanitized_legal 0]
  if {[lsearch -exact $sanitized_legal $current_value ] < 0 } {
    # record remapped symbol-value pair
    # If caller specified a mapping, use it
    if { $map_value != "NO_MAP_VALUE" } {
      if {[lsearch -exact $sanitized_legal $map_value] >= 0} {
        set legal_value $map_value
      }
    }
    set local_map($current_symbol) $legal_value
  } else {
    set legal_value $current_value  ;# current value is in legal set
  }

  # map legal values to symbols, making sure to re-use current symbol
  set allowed_range [list]
  foreach val $sanitized_legal {
    # when at assigned matching legal value, create symbol mapping if needed
    if {$val == $legal_value && $val != $current_symbol} {
      lappend allowed_range "${current_symbol}:$val"
    } else {
      # add legal value without symbolic encoding
      lappend allowed_range "$val"
    }
  }
  
  set_parameter_property $gui_param_name ALLOWED_RANGES $allowed_range

  # clear global ALLOWED_RANGES symbolic mapping, to prepare for new mapping
  set allowed_range_symbolic_map($gui_param_name) [array get local_map]
  #common_log "$gui_param_name ALLOWED_RANGES is $allowed_range, set:sym_map to $allowed_range_symbolic_map($gui_param_name)"

  #return $allowed_range
}
