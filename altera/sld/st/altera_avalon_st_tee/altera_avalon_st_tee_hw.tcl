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



#+-------------------------------------------------------
#| Altera Avalon ST tee
#+-------------------------------------------------------
package require -exact qsys 14.0

#+-------------------------------------------------------
#| Module Properties
#+-------------------------------------------------------

set_module_property NAME altera_avalon_st_tee
set_module_property VERSION 18.1
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Avalon ST Tee"
set_module_property INTERNAL true
set_module_property GROUP "Verification/Debug & Performance"
set_module_property ELABORATION_CALLBACK elaborate

#------------------------------------------------------------------------------
# Parameters
#------------------------------------------------------------------------------
add_parameter          inBitsPerSymbol INTEGER           8
set_parameter_property inBitsPerSymbol DISPLAY_NAME      "Bits Per Symbol"
set_parameter_property inBitsPerSymbol DESCRIPTION       "Bits Per Symbol"
set_parameter_property inBitsPerSymbol UNITS             bits
set_parameter_property inBitsPerSymbol ALLOWED_RANGES    {1:128}
set_parameter_property inBitsPerSymbol GROUP             "Port Widths"

add_parameter          inSymbolsPerBeat INTEGER           1
set_parameter_property inSymbolsPerBeat DISPLAY_NAME      "Symbols Per Beat"
set_parameter_property inSymbolsPerBeat DESCRIPTION       "Number of symbols transferred in 1 cycle. Data bus width is inBitsPerSymbol * inSymbolsPerBeat."
set_parameter_property inSymbolsPerBeat ALLOWED_RANGES    {1:8}
set_parameter_property inSymbolsPerBeat GROUP             "Port Widths"

#add_parameter          inUsePackets    BOOLEAN            true
#set_parameter_property inUsePackets    DISPLAY_NAME       "Include SOP, EOP sinks"
#set_parameter_property inUsePackets    DESCRIPTION        "Set true to include startofpacket and endofpacket signals"
#set_parameter_property inUsePackets    GROUP              "Signal Sinks"

add_parameter          inChannelWidth INTEGER           1
set_parameter_property inChannelWidth DISPLAY_NAME      "Width of channel signal"
set_parameter_property inChannelWidth ALLOWED_RANGES    {0:8}
set_parameter_property inChannelWidth GROUP             "Port Widths"

add_parameter          numOutputInterfaces INTEGER           1
set_parameter_property numOutputInterfaces DISPLAY_NAME      "Number of output interfaces"
set_parameter_property numOutputInterfaces ALLOWED_RANGES    {1:8}
set_parameter_property numOutputInterfaces GROUP             "Port Widths"

#+-------------------------------------------------------
#| Constant Interfaces
#+-------------------------------------------------------
add_interface clk clock end
add_interface_port clk in_clk clk Input 1

add_interface reset reset end
add_interface_port reset in_reset reset Input 1
set_interface_property reset associatedClock clk

add_interface in avalon_streaming end
add_interface_port in in_valid valid Input 1
add_interface_port in in_data  data  Input inSymbolsPerBeat*inBitsPerSymbol

set_interface_property in associatedClock clk
set_interface_property in associatedReset reset

proc elaborate {} {
    set bps [get_parameter_value inBitsPerSymbol]
    set spb [get_parameter_value inSymbolsPerBeat]
    set chan_width [get_parameter_value inChannelWidth]

#    if { [ get_parameter_value inUsePackets ] == "true" } {
#        add_interface_port in in_sop   startofpacket Input 1
#        add_interface_port in in_eop   endofpacket   Input 1
#    }

    if {$chan_width > 0} {
        add_interface_port in in_channel channel Input $chan_width
    }

    set_interface_property in dataBitsPerSymbol $bps
    set_interface_property in symbolsPerBeat    $spb
    set_interface_property in maxChannel    [expr {(1 << $chan_width) - 1}]
    set n [get_parameter_value numOutputInterfaces]

    for { set i 0 } { $i < $n } { incr i } {
        set out out$i
        add_interface $out avalon_streaming start
        add_interface_port $out ${out}_valid valid Output 1
        add_interface_port $out ${out}_data  data  Output [expr {$spb * $bps}]

        set_interface_property $out dataBitsPerSymbol $bps
        set_interface_property $out symbolsPerBeat    $spb

        set_interface_property $out associatedClock clk
        set_interface_property $out associatedReset reset

        set_port_property ${out}_valid DRIVEN_BY in_valid
        set_port_property ${out}_data  DRIVEN_BY in_data

        if {$chan_width > 0} {
            add_interface_port $out ${out}_channel channel Output $chan_width
            set_port_property ${out}_channel DRIVEN_BY in_channel
            set_interface_property $out maxChannel    [expr {(1 << $chan_width) - 1}]
        }
    }
}

