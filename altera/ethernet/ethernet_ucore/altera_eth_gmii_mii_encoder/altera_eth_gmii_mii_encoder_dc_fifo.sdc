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


# $File: //acds/main/ip/sopc/components/altera_avalon_dc_fifo/altera_avalon_dc_fifo.sdc $
# $Revision: #10 $
# $Date: 2016/02/18 $
# $Author: jyeap $

#-------------------------------------------------------------------------------
# TimeQuest constraints to constrain the timing across asynchronous clock domain crossings.
# The idea is to minimize skew to less than one launch clock period to keep the gray encoding, 
# and to minimize latency on the pointer crossings.
#
# The paths are from the Gray Code read and write pointers to their respective synchronizer banks.
#
# *** Important note *** 
#
# Do not declare the FIFO clocks as asynchronous at the top level, or false path these crossings,
# because that will override these constraints.
#-------------------------------------------------------------------------------


set_max_delay -from [get_registers {*|in_wr_ptr_gray[*]}] -to [get_registers {*|altera_eth_gmii_mii_encoder_dcfifo_synchronizer_bundle:write_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] 100
set_min_delay -from [get_registers {*|in_wr_ptr_gray[*]}] -to [get_registers {*|altera_eth_gmii_mii_encoder_dcfifo_synchronizer_bundle:write_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] -100

set_max_delay -from [get_registers {*|out_rd_ptr_gray[*]}] -to [get_registers {*|altera_eth_gmii_mii_encoder_dcfifo_synchronizer_bundle:read_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] 100
set_min_delay -from [get_registers {*|out_rd_ptr_gray[*]}] -to [get_registers {*|altera_eth_gmii_mii_encoder_dcfifo_synchronizer_bundle:read_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] -100

if { [ string equal -nocase on [ get_global_assignment -name TIMEQUEST2 ] ] } {
    set_net_delay -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8 -from [get_pins -compatibility_mode {*|in_wr_ptr_gray[*]*}] -to [get_registers {*|altera_eth_gmii_mii_encoder_dcfifo_synchronizer_bundle:write_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] 
    set_net_delay -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8 -from [get_pins -compatibility_mode {*|out_rd_ptr_gray[*]*}] -to [get_registers {*|altera_eth_gmii_mii_encoder_dcfifo_synchronizer_bundle:read_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}]
} else {
    set_net_delay -max 2 -from [get_pins -compatibility_mode {*|in_wr_ptr_gray[*]*}] -to [get_registers {*|altera_eth_gmii_mii_encoder_dcfifo_synchronizer_bundle:write_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}] 
    set_net_delay -max 2 -from [get_pins -compatibility_mode {*|out_rd_ptr_gray[*]*}] -to [get_registers {*|altera_eth_gmii_mii_encoder_dcfifo_synchronizer_bundle:read_crosser|altera_std_synchronizer_nocut:sync[*].u|din_s1}]
}

# add in timing constraints across asynchronous clock domain crossings for simple dual clock memory inference

set mem_regs [get_registers -nowarn *|altera_eth_gmii_mii_encoder_dc_fifo:*|mem*];
if {![llength [query_collection -report -all $mem_regs]] > 0} {
    set mem_regs [get_registers -nowarn altera_eth_gmii_mii_encoder_dc_fifo:*|mem*];
}

set internal_out_payload_regs [get_registers -nowarn *|altera_eth_gmii_mii_encoder_dc_fifo:*|internal_out_payload*];
if {![llength [query_collection -report -all $internal_out_payload_regs]] > 0} {
    set internal_out_payload_regs [get_registers -nowarn altera_eth_gmii_mii_encoder_dc_fifo:*|internal_out_payload*];
}

if {[llength [query_collection -report -all $internal_out_payload_regs]] > 0 && [llength [query_collection -report -all $mem_regs]] > 0} {
    set_max_delay -from $mem_regs -to $internal_out_payload_regs 100
    set_min_delay -from $mem_regs -to $internal_out_payload_regs -100
    if { [ string equal -nocase on [ get_global_assignment -name TIMEQUEST2 ] ] } {
        set_net_delay -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8 -from $mem_regs -to $internal_out_payload_regs
    } else {
        set_net_delay -max 2 -from $mem_regs -to $internal_out_payload_regs
    }
    #set_max_skew 2 -from $mem_regs -to $internal_out_payload_regs
}

# -----------------------------------------------------------------------------
# This procedure constrains the skew between the pointer bits, and should
# be called from the top level SDC, once per instance of the FIFO.
#
# The hierarchy path to the FIFO instance is required as an 
# argument.
# -----------------------------------------------------------------------------
proc constrain_altera_eth_gmii_mii_encoder_dc_fifo_ptr_skew { path } {

    if { [ string equal -nocase on [ get_global_assignment -name TIMEQUEST2 ] ] } {
        set_max_skew -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8 -from [ get_registers $path|in_wr_ptr_gray\[*\] ] -to [ get_registers $path|write_crosser|sync\[*\].u|din_s1 ]
        set_max_skew -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8 -from [ get_registers $path|out_rd_ptr_gray\[*\] ] -to [ get_registers $path|read_crosser|sync\[*\].u|din_s1 ]
    } else {
        set_max_skew 1.5 -from [ get_registers $path|in_wr_ptr_gray\[*\] ] -to [ get_registers $path|write_crosser|sync\[*\].u|din_s1 ]
        set_max_skew 1.5 -from [ get_registers $path|out_rd_ptr_gray\[*\] ] -to [ get_registers $path|read_crosser|sync\[*\].u|din_s1 ]
    }

}
