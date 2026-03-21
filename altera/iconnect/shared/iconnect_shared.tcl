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



# Common procedure of declaring an interconnect module property
proc init_mm_iconnect_module_property {} {
   set_module_property VERSION 18.1
   set_module_property GROUP "Qsys Interconnect/Memory-Mapped Alpha"
   set_module_property AUTHOR "Altera Corporation"
   set_module_property HIDE_FROM_QUARTUS true
   set_module_property INTERNAL true
   set_module_property DATASHEET_URL http://www.altera.com/literature/hb/qts/qsys_interconnect.pdf
}


# This is a procedure to add packet related parameters
#  to be reused in components with ST interface
proc add_packet_parameter { name description low_index range } {
   
   if { $range == 0 } {
      add_parameter $name INTEGER $low_index
      set_parameter_property $name DISPLAY_NAME "Packet $description field index"
      set_parameter_property $name UNITS None
      set_parameter_property $name AFFECTS_ELABORATION true
      set_parameter_property $name HDL_PARAMETER true
      set_parameter_property $name DESCRIPTION "Packet $description field index"
   } else {
      set high_suffix _H
      set parameter_name $name$high_suffix
      set high_index [expr $low_index + $range - 1]
      add_parameter $parameter_name INTEGER $high_index
      set_parameter_property $parameter_name DISPLAY_NAME "Packet $description field index - high"
      set_parameter_property $parameter_name UNITS None
      set_parameter_property $parameter_name AFFECTS_ELABORATION true
      set_parameter_property $parameter_name HDL_PARAMETER true
      set_parameter_property $parameter_name DESCRIPTION "MSB of the packet $description index"
      
      set low_suffix _L
      set parameter_name $name$low_suffix
      add_parameter $parameter_name INTEGER $low_index
      set_parameter_property $parameter_name DISPLAY_NAME "Packet $description field index - low"
      set_parameter_property $parameter_name UNITS None
      set_parameter_property $parameter_name AFFECTS_ELABORATION true
      set_parameter_property $parameter_name HDL_PARAMETER true
      set_parameter_property $parameter_name DESCRIPTION "LSB of the packet $description index"
   }
}
