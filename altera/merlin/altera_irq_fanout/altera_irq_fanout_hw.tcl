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


# $Id: //acds/rel/18.1std/ip/merlin/altera_irq_fanout/altera_irq_fanout_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

#  -----------------------------------
# | altera_irq_fanout
#  -----------------------------------
set_module_property NAME altera_irq_fanout
set_module_property VERSION 18.1
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Qsys Interconnect/Interrupt"
set_module_property DISPLAY_NAME "Merlin IRQ Fanout"
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property HIDE_FROM_SOPC true
set_module_property ANALYZE_HDL FALSE
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/qts/qsys_interconnect.pdf
set_module_property HIDE_FROM_QUARTUS true

#  -----------------------------------
# | parameters
#  -----------------------------------
add_parameter NUM_SENDERS INTEGER 2  "Number of sender interfaces"
set_parameter_property NUM_SENDERS DISPLAY_NAME {Number of senders}
set_parameter_property NUM_SENDERS ALLOWED_RANGES 1:64
set_parameter_property NUM_SENDERS DESCRIPTION {Number of sender interfaces}

#  -----------------------------------
# | Elaboration callback
#  -----------------------------------
proc elaborate {} {
    
    # Collect parameter values into local variables
    foreach var [ get_parameters ] {
        set $var [ get_parameter_value $var ]
    }

    # Clock interface
    add_interface clk clock end
    add_interface_port clk clk clk Input 1
    add_interface_port clk reset reset Input 1

    # Interrupt Receiver Interface
    add_interface "receiver" interrupt start
    set_interface_property "receiver" irqScheme        INDIVIDUAL_REQUESTS
    set_interface_property "receiver" ASSOCIATED_CLOCK clk
    add_interface_port "receiver" "receiver_irq" irq Input 1

    # Interrupt Sender Interfaces
    for { set s 0 } { $s < $NUM_SENDERS } { incr s } {
        add_interface "sender$s" interrupt end
        set_interface_property "sender$s" ASSOCIATED_CLOCK  clk
        add_interface_port "sender$s" "sender${s}_irq" irq Output 1
        set_port_property "sender${s}_irq" DRIVEN_BY "receiver_irq"
    }
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409958828732
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
