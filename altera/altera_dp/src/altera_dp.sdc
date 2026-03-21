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


# Create a multi-cycle constraint for the bitslip signals
#set_multicycle_path -setup -from [get_keepers *|bitec_dp_mac:*rx_bitslip* ] 2
#set_multicycle_path -hold -from [get_keepers *|bitec_dp_mac:*rx_bitslip* ] 1

# Cut the path to the Pixel FIFO aclr
#set_false_path -to [get_keepers {*bitec_dp_rx_pixel_fifo*:*:rdaclr|*}]
#set_false_path -to [get_keepers {*bitec_dp_cdc_fifo*:*:wraclr|*}]

