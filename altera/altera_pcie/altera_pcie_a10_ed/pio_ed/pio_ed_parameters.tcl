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


global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

proc add_parameters_ui_system_settings {} {
   send_message debug "proc:add_parameters_ui_system_settings"

   set group_name "System Settings"

   add_parameter pcie_qsys integer 1
   set_parameter_property pcie_qsys VISIBLE false

   # Application Interface
   add_parameter          DBUS_WIDTH integer 64
   set_parameter_property DBUS_WIDTH DISPLAY_NAME "Avalon-ST interface width"
   set_parameter_property DBUS_WIDTH ALLOWED_RANGES {64,128}
   set_parameter_property DBUS_WIDTH GROUP $group_name
   set_parameter_property DBUS_WIDTH VISIBLE true
   set_parameter_property DBUS_WIDTH HDL_PARAMETER true
   set_parameter_property DBUS_WIDTH DESCRIPTION "Selects the width of the data interface between the transaction layer and the application layer implemented in the PLD fabric. The IP core supports interfaces of 64 and 128 bits."
}