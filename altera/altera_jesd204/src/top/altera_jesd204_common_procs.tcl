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

#--Configure the parameter to be VISIBLE or NOT VISIBLE
#--$param  - Parameter to be configured
#--$visible - 1 to VISIBLE otherwise 0 to NOT VISIBLE 
proc conf_params_visible { param visible } {
   set_parameter_property $param VISIBLE $visible
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
#--$terminate       - 1 to terminate this port otherwise 0  
proc common_add_reset { port_name port_dir associated_clk terminate } {
  array set in_out [list {output} {start} {input} {end} ]
  add_interface $port_name reset $in_out($port_dir)
  set_interface_property $port_name ASSOCIATED_CLOCK $associated_clk
#  set_interface_property $port_name synchronousEdges "None"
  add_interface_port $port_name $port_name reset_n $port_dir 1
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

# return 1 if DEVICE_FAMILY = Stratix 10 || Arria 10 , otherwise return 0
proc device_is_xseries {} {
   if {[param_matches DEVICE_FAMILY "Stratix 10"] || [param_matches DEVICE_FAMILY "Arria 10"] } {
      return 1
   } else {
      return 0
   }
}

# return 1 if DATA_PATH == TX or RX_TX , otherwise return 0
proc set_tx_interfaces_on {} {
   if {[param_matches DATA_PATH "RX"]} {
      return 0
   } else {
      return 1
   }
}

# return 1 if DATA_PATH == RX or RX_TX ,otherwise return 0
proc set_rx_interfaces_on {} {
   if {[param_matches DATA_PATH "TX"]} {
      return 0
   } else {
      return 1
   }
}

# Derive pma width for reference clock calculation
proc derive_pma_width {pcs_config} {
   if {$pcs_config == "JESD_PCS_CFG1"} { 
      return 20
   } elseif {$pcs_config == "JESD_PCS_CFG2"} {
      return 40
   } elseif {$pcs_config == "JESD_PCS_CFG3"} {
      return 10
   } else {
   # JESD_PCS_CFG4"
      return 80
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

# get transceiver reset controller component's name
proc get_xcvr_rst_controller_component_name {device} {
   if {$device == "Stratix 10"} {
      return "altera_xcvr_reset_control_s10"
   } else {
      return "altera_xcvr_reset_control"
   }
}

# get transceiver ATX PLL component's name
proc get_xcvr_atx_pll_component_name {device} {
   if {$device == "Arria 10"} {
      return "altera_xcvr_atx_pll_a10"
   }  elseif {$device == "Stratix 10"} {
      return "altera_xcvr_atx_pll_s10"
   }
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

# PCS reset sequencing setting for Stratix 10 device family
proc derive_pcs_reset_sequencing_s10 {} {
   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      return "not_bonded"
   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      return "not_bonded"
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
