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

# This path is not available in single rate as rx_clkout_cnt would be synthesized away
set rx_clkout_cnt_collection [get_keepers -nowarn {*u_xcvr_ctrl_*|rx_clkout_cnt[*]}]
foreach_in_collection keeper $rx_clkout_cnt_collection {
  set rx_clkout_cnt_keeper_name [get_object_info -name $keeper]
  set_false_path -from [get_keepers $rx_clkout_cnt_keeper_name] -to [get_keepers {*u_xcvr_ctrl_*|rx_clkout_cnt_sync0[*]}]
}

# This path is available for all standards except SD-SDI.
set rate_detect_collection [get_keepers -nowarn {*u_rate_detect|rx_clkout_cnt_sync0[*]}]
foreach_in_collection keeper $rate_detect_collection {
  set rate_detect_keeper_name [get_object_info -name $keeper]
  set_false_path -from [get_keepers {*u_rate_detect|rx_clkout_cnt[*]}] -to [get_keepers $rate_detect_keeper_name]
  #set_false_path -from [get_keepers {*u_rate_detect|rx_clkout_is_ntsc_paln*}]
}
