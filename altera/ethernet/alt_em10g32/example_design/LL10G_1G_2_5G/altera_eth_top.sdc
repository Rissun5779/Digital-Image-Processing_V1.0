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


# (C) 2001-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

#**************************************************************
# Create input reference Clocks
#**************************************************************

create_clock -period "125 MHz" -name {refclk} [get_ports refclk]

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

#**************************************************************
# Set False Path for alt_mge_reset_synchronizer
#**************************************************************
set reset_sync_aclr_counter 0
set reset_sync_clrn_counter 0
set reset_sync_aclr_collection [get_pins -compatibility_mode -nocase -nowarn *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|aclr]
set reset_sync_clrn_collection [get_pins -compatibility_mode -nocase -nowarn *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|clrn]

foreach_in_collection reset_sync_aclr_pin $reset_sync_aclr_collection {
    set reset_sync_aclr_counter [expr $reset_sync_aclr_counter + 1]
}

foreach_in_collection reset_sync_clrn_pin $reset_sync_clrn_collection {
    set reset_sync_clrn_counter [expr $reset_sync_clrn_counter + 1]
}

if {$reset_sync_aclr_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|aclr]
}

if {$reset_sync_clrn_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|clrn]
}
