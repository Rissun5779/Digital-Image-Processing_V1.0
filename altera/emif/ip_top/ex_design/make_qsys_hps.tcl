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


package require -exact qsys 15.0

if {! [info exists ip_params] || ! [info exists ed_params]} {
   source "params.tcl"
}  

set emif $ed_params(EMIF_NAME)
set emif_module $ed_params(EMIF_MODULE_NAME)

create_system
set_project_property DEVICE_FAMILY $ip_params(SYS_INFO_DEVICE_FAMILY)
set_project_property DEVICE $ed_params(DEFAULT_DEVICE)


set_validation_property AUTOMATIC_VALIDATION false

add_instance $emif $emif_module

foreach param_name [array names ip_params] {
   set_instance_parameter_value $emif $param_name $ip_params($param_name)
}

validate_system
set_validation_property AUTOMATIC_VALIDATION true

foreach if_name [get_instance_interfaces $emif] {
   if {$if_name == "hps_emif"} {
      continue
   }
   if {$if_name == "global_reset_n"} {
      set if_type "reset"
      set if_dir "sink"
   } elseif {$if_name == "pll_ref_clk"} {
      set if_type "clock"
      set if_dir "sink"
   } elseif {$if_name == "oct"} {
      set if_type "conduit"
      set if_dir "end"
   } elseif {$if_name == "mem"} {
      set if_type "conduit"
      set if_dir "end"
   } else {
      set if_type ""
      set if_dir ""
   }
   
   set exported_if_name "${emif}_${if_name}"
   add_interface $exported_if_name $if_type $if_dir
   set_interface_property $exported_if_name EXPORT_OF "${emif}.${if_name}"
}

save_system $ed_params(TMP_SYNTH_QSYS_PATH)


save_system $ed_params(TMP_SIM_QSYS_PATH)



