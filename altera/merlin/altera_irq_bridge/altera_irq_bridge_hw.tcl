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
# | altera_irq_bridge
#  -----------------------------------

package require -exact qsys 16.0

set_module_property NAME altera_irq_bridge
set_module_property VERSION 18.1
set_module_property GROUP "Basic Functions/Bridges and Adaptors/Interrupt"
set_module_property DISPLAY_NAME "IRQ Bridge"
set_module_property DESCRIPTION "Allows you to route interrupt wires between Qsys subsystems."
set_module_property AUTHOR "Altera Corporation"
set_module_property EDITABLE FALSE
set_module_property ELABORATION_CALLBACK elaborate
set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QUARTUS true
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/qts/qsys_interconnect.pdf

# ----------------------------------
# | files
# ----------------------------------
add_fileset          synth   QUARTUS_SYNTH 
set_fileset_property synth   TOP_LEVEL altera_irq_bridge
add_fileset_file altera_irq_bridge.v VERILOG PATH altera_irq_bridge.v

add_fileset          sim     SIM_VERILOG
set_fileset_property sim     TOP_LEVEL altera_irq_bridge
add_fileset_file altera_irq_bridge.v VERILOG PATH altera_irq_bridge.v

add_fileset          simvhdl SIM_VHDL
set_fileset_property simvhdl TOP_LEVEL altera_irq_bridge
add_fileset_file altera_irq_bridge.v VERILOG PATH altera_irq_bridge.v

#  -----------------------------------
# | parameters
#  -----------------------------------
add_parameter IRQ_WIDTH integer 32
set_parameter_property IRQ_WIDTH DISPLAY_NAME {IRQ signal width}
set_parameter_property IRQ_WIDTH ALLOWED_RANGES "1:32"
set_parameter_property IRQ_WIDTH affects_elaboration true
set_parameter_property IRQ_WIDTH HDL_PARAMETER true
set_parameter_property IRQ_WIDTH DESCRIPTION {Width of the IRQ signal}

add_parameter IRQ_N integer 0
set_parameter_property IRQ_N DISPLAY_NAME {IRQ signal polarity}
set_parameter_property IRQ_N affects_elaboration true
set_parameter_property IRQ_N ALLOWED_RANGES {"0:Active high" "1:Active low"}
#set_parameter_property IRQ_N HDL_PARAMETER true
set_parameter_property IRQ_N DESCRIPTION {Polarity of the IRQ signal}

# ----------------------------------
# | Connection points
#-----------------------------------

add_interface "clk" clock end
add_interface_port "clk" clk clk input 1

add_interface "receiver_irq" interrupt receiver
set_interface_property "receiver_irq" associatedClock "clk"

add_interface clk_reset reset end
add_interface_port clk_reset reset reset Input 1
set_interface_property clk_reset associatedClock clk

# +---------------------------------------------------------------------------- 
# | Function creates the irqMap for the irq bridge. irqMap is an xml 
# | representation of what receiver bit corresponds to which sender on the 
# | bridge. For this bridge, sender0_irq sends receiver bit 0 and so on.
# | Example xml for one sender: "<map><mapping port='0' sender='sender0_irq' /></map>
# +-----------------------------------------------------------------------------   
proc create_irq_map {irq_width} {
    set irq_map "<map>"
    
    for { set s 0 } { $s < $irq_width } { incr s } {
        append irq_map "<mapping " "port='${s}' " "sender='sender${s}_irq' " "/>"
    }

    append irq_map "</map>"

    return $irq_map
}

# +-----------------------------------
# | Elaboration callback
# +-----------------------------------

proc elaborate {} {
    set irq_n [get_parameter_value IRQ_N]

    set_interface_property "receiver_irq" irqScheme individualRequests

    set irq_width [get_parameter_value IRQ_WIDTH]

    if { $irq_n == 1 } {
        add_interface_port "receiver_irq" receiver_irq irq_n input $irq_width
    } else {
        add_interface_port "receiver_irq" receiver_irq irq input $irq_width
    }

    set_port_property receiver_irq vhdl_type std_logic_vector
    for { set s 0 } { $s < 32 } { incr s } {
        add_interface "sender${s}_irq" interrupt sender

        if { $irq_n == 1 } {
            add_interface_port "sender${s}_irq" sender${s}_irq irq_n output 1
        } else { 
            add_interface_port "sender${s}_irq" sender${s}_irq irq output 1
        }

        set_interface_property "sender${s}_irq" associatedClock "clk"

        if { $s < $irq_width} {
            set_interface_property sender${s}_irq bridgesToReceiver receiver_irq
            set_interface_property sender${s}_irq bridgedReceiverOffset ${s} 
        } else {
            set_interface_property sender${s}_irq ENABLED false
        }
    }

    #irqMap is a xml representation of what receiver bit each sender sends
    #Look at create_irq_map for more comments
    set_interface_property receiver_irq irqMap [create_irq_map $irq_width]
}

# +-----------------------------------
# | Validation callback
# +-----------------------------------
proc validate {} {
	set irq_width [get_parameter_value IRQ_WIDTH]
	if {$irq_width < 1} {
	   send_message error "IRQ_WIDTH < 0"
	}
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409958933301 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
