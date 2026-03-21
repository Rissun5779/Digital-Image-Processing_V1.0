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


#
# Cut the pseudostatic control/status signals
#
set_false_path -from [get_keepers {*u_state_machine|set_locktoref*}]
# bitec rx locked signal
set_false_path -from [get_keepers {*u_state_machine*enable_measure}]
set_false_path -from [get_keepers {*u_rate_detect*count_refclock[*]}] -to [get_keepers {*u_rate_detect*refclock_measure_min2[*]}]
set_false_path -from [get_keepers {*u_rate_detect*gate}] -to [get_keepers {*u_rate_detect*gate_min2}]
set_false_path -from [get_keepers {*u_rate_detect*capture}] -to [get_keepers {*u_rate_detect*capture_d}]
set_false_path -from [get_keepers {*u_rate_detect*sig_o_reg}] -to [get_keepers {*u_rate_detect*sig_o_d}]
