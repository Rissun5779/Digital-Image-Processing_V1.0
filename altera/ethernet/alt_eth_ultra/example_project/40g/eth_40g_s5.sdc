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


derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

set RX_CORE_CLK [get_clocks *\|phy*\|*rxp\|*rx_pll*\|*\|divclk]
set TX_CORE_CLK [get_clocks *\|phy*\|*txp\|*tx_pll*\|*\|divclk]

if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
                # fitter
				set_clock_uncertainty 0.533ns -add -from $RX_CORE_CLK -to $RX_CORE_CLK -setup
				set_clock_uncertainty 0.533ns -add -from $TX_CORE_CLK -to $TX_CORE_CLK -setup
} else {
                # everywhere else
}


create_clock -name {clk_status} -period 10.0    -waveform { 0.000 5.000 } [get_ports {clk_status[0]}]

set_clock_groups -exclusive -group $TX_CORE_CLK -group $RX_CORE_CLK -group clk_status
