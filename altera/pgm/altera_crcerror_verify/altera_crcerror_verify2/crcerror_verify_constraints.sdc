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



# ATTENTION: Replace below err_verify_in_clk with appropriate clock that was connected to err_verify_in_clk
#create_generated_clock -name ed_clk -source [get_ports {err_verify_in_clk}] -divide_by 2 [get_keepers {*crcerror_read_emr:crcerror_read_emr_component|current_state.STATE_CLOCKHIGH}]
