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



proc add_pcie_mc_parameters {} {

   set NUMBER_OF_CHANNELS 4
   add_parameter          NUMBER_OF_CHANNELS integer 4
   set_parameter_property NUMBER_OF_CHANNELS DISPLAY_NAME "Number of channels"
   set_parameter_property NUMBER_OF_CHANNELS ALLOWED_RANGES "2,4,8"
   set_parameter_property NUMBER_OF_CHANNELS HDL_PARAMETER true
   set_parameter_property NUMBER_OF_CHANNELS AFFECTS_ELABORATION true
   set_parameter_property NUMBER_OF_CHANNELS VISIBLE TRUE
   set_parameter_property NUMBER_OF_CHANNELS DESCRIPTION "specifies the number of channels"
   
   set PRIORITY_WEIGHT 4
   add_parameter          PRIORITY_WEIGHT integer 4
   set_parameter_property PRIORITY_WEIGHT DISPLAY_NAME "Channel priority weight"
   set_parameter_property PRIORITY_WEIGHT ALLOWED_RANGES "0,4,8"
   set_parameter_property PRIORITY_WEIGHT HDL_PARAMETER true
   set_parameter_property PRIORITY_WEIGHT AFFECTS_ELABORATION true
   set_parameter_property PRIORITY_WEIGHT VISIBLE TRUE
   set_parameter_property PRIORITY_WEIGHT DESCRIPTION "0: All of priority queue 0 sent first, 4: 4:1 ratio priority, 8: 8:1 ratio priority"
   
   set DESC_WIDTH 161
   add_parameter          DESC_WIDTH integer 161
   set_parameter_property DESC_WIDTH DISPLAY_NAME "Descriptor width"
   set_parameter_property DESC_WIDTH ALLOWED_RANGES "161 169"
   set_parameter_property DESC_WIDTH HDL_PARAMETER true
   set_parameter_property DESC_WIDTH AFFECTS_ELABORATION true
   set_parameter_property DESC_WIDTH VISIBLE TRUE

}

