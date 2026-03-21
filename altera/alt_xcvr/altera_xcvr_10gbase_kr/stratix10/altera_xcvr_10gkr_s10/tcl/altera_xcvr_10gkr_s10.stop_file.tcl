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


# Stop at the native_phy so all the violations don't show up
# each of the native_phy variants are listed.
set_option stop {native_10g_322 native_10g_1588_322 native_10g_644 native_10g_1588_644 native_10g_fec_322 native_10g_fec_1588_322 native_10g_fec_644 native_10g_fec_1588_644 native_gige_1588 native_gige kra10_debug_cpu kra10_cpu}
