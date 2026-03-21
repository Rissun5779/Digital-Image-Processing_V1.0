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


# +-----------------------------------
# | Add Clock interface and port of same name
# | 
# | $port_dir - can be 'input' or 'output'
proc common_add_clock { port_name port_dir used } {
  global common_composed_mode
  array set in_out [list {output} {start} {input} {end} ]
  add_interface $port_name clock $in_out($port_dir)
  if {$common_composed_mode == 0} {
    set_interface_property $port_name ENABLED $used
    add_interface_port $port_name $port_name clk $port_dir 1
  } else {
    # create clock source instance for composed mode
    add_instance $port_name clock_source
    set_interface_property $port_name export_of $port_name.clk_in
  }  
}

# +-----------------------------------
# | Add Clock interface and port of same name
# | 
# | $port_dir - can be 'input' or 'output'
# | $port_width - indicate how many bits is this clock
proc common_add_clock_bus { port_name port_dir used port_width} {
  global common_composed_mode
  array set in_out [list {output} {start} {input} {end} ]
  add_interface $port_name clock $in_out($port_dir)
  if {$common_composed_mode == 0} {
    set_interface_property $port_name ENABLED $used
    add_interface_port $port_name $port_name clk $port_dir $port_width
  } else {
    # create clock source instance for composed mode
    add_instance $port_name clock_source
    set_interface_property $port_name export_of $port_name.clk_in
  }  
}



# +-----------------------------------
# | Add Reset interface and port of same name
# | 
# | $port_dir - can be 'input' or 'output'
# | $associated_clk - which clock is this reset associated with
proc common_add_reset { port_name port_dir associated_clk } {
  array set in_out [list {output} {start} {input} {end} ]
  add_interface $port_name reset $in_out($port_dir)
  set_interface_property $port_name ASSOCIATED_CLOCK $associated_clk
  add_interface_port $port_name $port_name reset $port_dir 1
}

# +-----------------------------------
# | Add Reset interface and port of same name 
# | 
# | $port_dir - can be 'input' or 'output'
# | $associated_clk - which clock is this reset associated with
# | $associated_clk - which input reset is this reset associated with
proc common_add_reset_associated_sinks { port_name port_dir associated_clk sinks} {
  array set in_out [list {output} {start} {input} {end} ]
  add_interface $port_name reset $in_out($port_dir)
  set_interface_property $port_name ASSOCIATED_CLOCK $associated_clk  
  add_interface_port $port_name $port_name reset $port_dir 1
  set_interface_property $port_name associatedResetSinks $sinks

}




# +-----------------------------------
# | Add optional conduit interface and port of same name
# | 
# | $port_dir - can be 'input' or 'output'
# | $used     - can be 'true' or 'false'
proc common_add_optional_conduit { port_name signal_type port_dir width used } {
  global common_composed_mode
  array set in_out [list {output} {start} {input} {end} ]
  add_interface $port_name conduit $in_out($port_dir)
  set_interface_assignment $port_name "ui.blockdiagram.direction" $port_dir
  if {$common_composed_mode == 0} {
    set_interface_property $port_name ENABLED $used
    add_interface_port $port_name $port_name $signal_type $port_dir $width
  }
}

# +---------------------------------------------------------------------------
# proc: add_export_rename_interface
#
# Renames all ports on the interface of the supplied instance to be named the
# same as the instance ports. This is used when exporting the interface but
# wanting to keep the ports named appended with instance name.
#
proc add_export_rename_interface {instance interface interface_type port_dir} {
  array set in_out [list {output} {start} {input} {end}]
  add_interface ${instance}_${interface} $interface_type $in_out($port_dir)
  set_interface_property ${instance}_${interface} export_of $instance.$interface
  set port_map [list]
  lappend port_map ${instance}_${interface}
  lappend port_map $interface    
  set_interface_property ${instance}_${interface} PORT_NAME_MAP $port_map
}

# +---------------------------------------------------------------------------
# proc: add_export_free_rename_interface
#
# Freely renames all ports on the interface of with supplied input name and 
# desired output name
#
proc add_export_free_rename_interface {instance interface_int interface_ext interface_type port_dir} {
  array set in_out [list {output} {start} {input} {end}]
  add_interface ${interface_ext} $interface_type $in_out($port_dir)
  set_interface_property ${interface_ext} export_of $instance.$interface_int
  set port_map [list]
  lappend port_map $interface_ext
  lappend port_map $interface_int    
  set_interface_property ${interface_ext} PORT_NAME_MAP $port_map
}


# +---------------------------------------------------------------------------
# proc: add_export_interface
#
# Add and export interface without renaming
#
proc add_export_interface {instance interface interface_type port_dir} {
  array set in_out [list {output} {start} {input} {end}]
  add_interface ${interface} $interface_type $in_out($port_dir)
  set_interface_property ${interface} export_of $instance.$interface
  set port_map [list]
  lappend port_map $interface
  lappend port_map $interface    
  set_interface_property ${interface} PORT_NAME_MAP $port_map
}

proc add_export_interface_b {instance interface interface_type port_dir} {
  array set in_out [list {output} {start} {input} {end}]
  add_interface ${interface}_b $interface_type $in_out($port_dir)
  set_interface_property ${interface}_b export_of $instance.$interface
  set port_map [list]
  lappend port_map $interface
  lappend port_map $interface    
  set_interface_property ${interface}_b PORT_NAME_MAP $port_map
}

# +-----------------------------------------------------------------------------
# proc: propagate_params
#
# Propagate the parameters of current instance to the lower level instances
#
proc propagate_params {instance} {
  foreach param_name [get_instance_parameters $instance] {
    #_dprint 1 "Assigning parameter $param_name = [get_parameter_value $param_name] for dut"
    set_instance_parameter $instance $param_name [get_parameter_value $param_name]
  }
}

# +-----------------------------------------------------------------------------
# proc: add_clk_bridge
#
# Allow one single clock bridging to multiple clocks
#
proc add_clk_bridge {interface} {
  add_instance           ${interface}_bridge     altera_clock_bridge
  add_interface          ${interface}            clock                 end
  set_interface_property ${interface}            export_of             ${interface}_bridge.in_clk
  set port_map_clk [list]
  lappend port_map_clk $interface
  lappend port_map_clk in_clk    
  set_interface_property ${interface} PORT_NAME_MAP $port_map_clk
}

# +-----------------------------------------------------------------------------
# proc: add_rst_bridge
#
# Allow one single reset bridging to multiple resets
#
proc add_rst_bridge {interface} {
  add_instance           ${interface}_rst_bridge altera_reset_bridge
  add_interface          ${interface}_rst        reset                 end
  set_interface_property ${interface}_rst        export_of             ${interface}_rst_bridge.in_reset
  set port_map_rst [list]
  lappend port_map_rst ${interface}_rst
  lappend port_map_rst in_reset    
  set_interface_property ${interface}_rst PORT_NAME_MAP $port_map_rst
}