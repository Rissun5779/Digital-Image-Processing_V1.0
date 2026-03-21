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


#  -----------------------------------
# | altera_jesd204_fanout
#  -----------------------------------
set_module_property NAME altera_jesd204_fanout
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "Altera JESD204 Fanout"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/JESD"
set_module_property DISPLAY_NAME "JESD204B Fanout"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property HIDE_FROM_SOPC true

#  ------------------------
# | Callback Declaration
#  ------------------------
set_module_property ELABORATION_CALLBACK my_elaboration_callback

#  -----------------------------------
# | Parameters
#  -----------------------------------
add_parameter NUM_FANOUT INTEGER 2  "Number of fanout interfaces"
set_parameter_property NUM_FANOUT DISPLAY_NAME {Number of fanout}
set_parameter_property NUM_FANOUT ALLOWED_RANGES 1:64
set_parameter_property NUM_FANOUT DESCRIPTION  {Number of fanout interfaces}

add_parameter INTERFACE_TYPE STRING "conduit"  "Fanout interface type - conduit, interrupt"
set_parameter_property INTERFACE_TYPE DISPLAY_NAME {Fanout interface type}
set_parameter_property INTERFACE_TYPE DESCRIPTION  {Fanout interface type}

add_parameter WIDTH INTEGER 1 "Data Width"
set_parameter_property WIDTH DISPLAY_NAME {Data Width}
set_parameter_property WIDTH ALLOWED_RANGES 1:31
set_parameter_property WIDTH DESCRIPTION  {Interfaces width}

add_parameter SIGNAL_TYPE STRING "export"  "Fanout signal type - export by default"
set_parameter_property SIGNAL_TYPE DISPLAY_NAME {Fanout signal type}
set_parameter_property SIGNAL_TYPE DESCRIPTION  {Fanout signal type}

#  -----------------------------------
# | Elaboration callback
#  -----------------------------------
proc my_elaboration_callback {} {
   set NUM_FANOUT [get_parameter_value "NUM_FANOUT"]
   set INTERFACE_TYPE [get_parameter_value "INTERFACE_TYPE"]
   set WIDTH [get_parameter_value "WIDTH"]
   set SIGNAL_TYPE [get_parameter_value "SIGNAL_TYPE"]

    # Input Interface
    add_interface "sig_input" $INTERFACE_TYPE input
    add_interface_port "sig_input" "sig_input" $SIGNAL_TYPE Input $WIDTH

    # Output fanout Interfaces
    for { set s 0 } { $s < $NUM_FANOUT } { incr s } {
        add_interface "sig_fanout$s" $INTERFACE_TYPE output
        add_interface_port "sig_fanout${s}" "sig_fanout${s}" $SIGNAL_TYPE Output $WIDTH
        set_port_property "sig_fanout${s}" DRIVEN_BY "sig_input"
    }
}

