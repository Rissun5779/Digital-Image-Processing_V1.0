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
#package require -exact qsys 14.1

#  -----------------------------------
# | altera_sl3_fanout
#  -----------------------------------
set_module_property NAME altera_sl3_fanout
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "Altera SL3 Fanout"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SerialLite"
set_module_property DISPLAY_NAME "SerialLite III Fanout"
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

   if { $SIGNAL_TYPE == "clock"} {
        # Input Interface
        add_interface "clk_input" clock input
        add_interface_port "clk_input" "clk_input" clk Input $WIDTH
        set_port_property   "clk_input"     VHDL_TYPE  std_logic


        # Output fanout Interfaces
        for { set s 0 } { $s < $NUM_FANOUT } { incr s } {
            add_interface "clk_fanout$s" clock output
            add_interface_port "clk_fanout${s}" "clk_fanout${s}" clk Output $WIDTH
            set_port_property "clk_fanout${s}" DRIVEN_BY "clk_input"
            set_interface_property "clk_fanout${s}" associatedDirectClock "clk_input"
        }

        # Input Interface
        add_interface "rst_input" reset input
        set_interface_property "rst_input" associatedClock "clk_input"
        set_interface_property "rst_input" synchronousEdges "both"
        add_interface_port "rst_input" "rst_input" reset input 1

        # Output fanout Interfaces
        for { set s 0 } { $s < $NUM_FANOUT } { incr s } {
            add_interface "rst_fanout$s" reset  output
            set_interface_property "rst_fanout${s}" associatedClock "clk_fanout${s}"
            set_interface_property "rst_fanout${s}" synchronousEdges "both"
            add_interface_port "rst_fanout${s}" "rst_fanout${s}" reset   Output $WIDTH
            set_port_property "rst_fanout${s}" DRIVEN_BY "rst_input"
            set_interface_property      "rst_fanout${s}"    associatedResetSinks    "rst_input"
        }
   } else {
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
}

