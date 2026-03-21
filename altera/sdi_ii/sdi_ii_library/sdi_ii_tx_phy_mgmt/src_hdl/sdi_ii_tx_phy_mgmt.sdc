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


#**************************************************************
# Set False Path
#**************************************************************
# Set false path for link_b transmit data as in usual case, txpll on both xcvr will be merged and hence no clock crossing will be encountered.
# However, in some cases which fitter detects that there are still space available and therefore these 2 tx plls will not be merged.
set phy_b_data_collection [get_keepers -nowarn {*u_phy_b|*|syncdatain}]
foreach_in_collection keeper $phy_b_data_collection {
  set phy_b_data_keeper_name [get_object_info -name $keeper]
  set_false_path -from [get_keepers {*u_tx_protocol|*u_scr|dout[*]}] -to [get_keepers $phy_b_data_keeper_name]
}
