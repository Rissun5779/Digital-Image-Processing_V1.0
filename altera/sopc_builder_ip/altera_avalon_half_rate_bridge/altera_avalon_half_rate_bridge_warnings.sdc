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


set hrb_warning "This project appears to contain an SOPC Builder system with one or more instances of the Avalon MM Half Rate DDR Memory Bridge component. This component contains multi-cycle timing paths that are unconstrained by default. To constrain them, copy the file located at \$QUARTUS_ROOTDIR/../ip/altera/sopc_builder_ip/altera_avalon_half_rate_bridge/altera_avalon_half_rate_bridge_constraints.sdc into your project directory, open it in a text editor and follow the instructions in the comments to set the slow_clk and instance variables, and source it in your project."
post_message -type warning "${hrb_warning}"