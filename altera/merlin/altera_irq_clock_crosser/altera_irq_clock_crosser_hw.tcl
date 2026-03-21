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


# $Id: //acds/rel/18.1std/ip/merlin/altera_irq_clock_crosser/altera_irq_clock_crosser_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $

package require -exact qsys 13.1

#  -----------------------------------
# | altera_irq_mapper
#  -----------------------------------
set_module_property NAME altera_irq_clock_crosser
set_module_property VERSION 18.1
set_module_property GROUP "Qsys Interconnect/Interrupt"
set_module_property DISPLAY_NAME "Merlin IRQ Clock Crosser"
set_module_property DESCRIPTION "Synchronizes interrupt senders and receivers that are in different clock domains."
set_module_property AUTHOR "Altera Corporation"
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true
set_module_property ANALYZE_HDL FALSE
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/qts/qsys_interconnect.pdf
set_module_property HIDE_FROM_QUARTUS true
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true

add_fileset sim_verilog SIM_VERILOG sim_verilog
set_fileset_property sim_verilog top_level altera_irq_clock_crosser

add_fileset sim_vhdl SIM_VHDL sim_vhdl
set_fileset_property sim_vhdl top_level altera_irq_clock_crosser

add_fileset quartus_synth QUARTUS_SYNTH quartus_synth_proc
set_fileset_property quartus_synth top_level altera_irq_clock_crosser


proc sim_verilog {altera_irq_clock_crosser} {
   add_fileset_file altera_irq_clock_crosser.sv SYSTEM_VERILOG PATH "altera_irq_clock_crosser.sv" 
}

proc quartus_synth_proc {altera_irq_clock_crosser} {
   add_fileset_file altera_irq_clock_crosser.sv SYSTEM_VERILOG PATH "altera_irq_clock_crosser.sv" 
}

# SIM_VHDL generation callback procedure
proc sim_vhdl {altera_irq_clock_crosser} {
   if { 1 } {
      add_fileset_file mentor/altera_irq_clock_crosser.sv SYSTEM_VERILOG_ENCRYPT PATH "mentor/altera_irq_clock_crosser.sv" {MENTOR_SPECIFIC}
   }
   if { 1 } {
      add_fileset_file aldec/altera_irq_clock_crosser.sv SYSTEM_VERILOG_ENCRYPT PATH "aldec/altera_irq_clock_crosser.sv" {ALDEC_SPECIFIC}
   }
   if { 1 } {
      add_fileset_file cadence/altera_irq_clock_crosser.sv SYSTEM_VERILOG_ENCRYPT PATH "cadence/altera_irq_clock_crosser.sv" {CADENCE_SPECIFIC}
   }
   if { 1 } {
      add_fileset_file synopsys/altera_irq_clock_crosser.sv SYSTEM_VERILOG_ENCRYPT PATH "synopsys/altera_irq_clock_crosser.sv" {SYNOPSYS_SPECIFIC}
   }
}

#  -----------------------------------
# | Parameters
#  -----------------------------------
add_parameter IRQ_WIDTH INTEGER 1  "Width of the irq signal for both the sender and receiver interfaces."
set_parameter_property IRQ_WIDTH DISPLAY_NAME {IRQ width}
set_parameter_property IRQ_WIDTH ALLOWED_RANGES 1:64
set_parameter_property IRQ_WIDTH HDL_PARAMETER true
set_parameter_property IRQ_WIDTH DESCRIPTION {Width of the irq signal for both the sender and receiver interfaces.}

#  -----------------------------------
# | Interfaces callback
#  -----------------------------------

# Clock interfaces
add_interface receiver_clk clock end
add_interface_port receiver_clk receiver_clk clk Input 1

add_interface sender_clk clock end
add_interface_port sender_clk sender_clk clk Input 1

# Reset interfaces
add_interface receiver_clk_reset reset end
add_interface_port receiver_clk_reset receiver_reset reset Input 1
set_interface_property receiver_clk_reset associatedClock receiver_clk

add_interface sender_clk_reset reset end
add_interface_port sender_clk_reset sender_reset reset Input 1
set_interface_property sender_clk_reset associatedClock sender_clk

# Interrupt Receiver interface
add_interface "receiver" interrupt start
set_interface_property "receiver" irqScheme         INDIVIDUAL_REQUESTS
set_interface_property "receiver" ASSOCIATED_CLOCK  receiver_clk
add_interface_port "receiver" "receiver_irq" irq input 1
set_port_property receiver_irq width_expr IRQ_WIDTH

# Interrupt Sender Interface
add_interface "sender" interrupt end
set_interface_property "sender" irqScheme         INDIVIDUAL_REQUESTS
set_interface_property "sender" ASSOCIATED_CLOCK  sender_clk
add_interface_port "sender" "sender_irq" irq output 1
set_port_property sender_irq width_expr IRQ_WIDTH



## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1409960181641/mwh1409958828732
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
