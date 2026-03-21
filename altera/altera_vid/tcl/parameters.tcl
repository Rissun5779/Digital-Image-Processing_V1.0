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


proc declare_parameters {} {
  add_device_parameters
  add_parameters
}

proc add_device_parameters {} {
  
  add_parameter DEVICE_FAMILY STRING
  set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
  set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
  set_parameter_property DEVICE_FAMILY DEFAULT_VALUE "Arria 10"
  set_parameter_property DEVICE_FAMILY ALLOWED_RANGES {"Arria 10"}
  set_parameter_property DEVICE_FAMILY ENABLED false
  set_parameter_property DEVICE_FAMILY VISIBLE true
  set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
  set_parameter_property DEVICE_FAMILY DESCRIPTION "Indicate the device family of the FPGA."

  add_parameter SPEED_GRADE STRING
  set_parameter_property SPEED_GRADE SYSTEM_INFO {DEVICE_SPEED_GRADE}
  set_parameter_property SPEED_GRADE DISPLAY_NAME "Core Speed Grade"
  set_parameter_property SPEED_GRADE DEFAULT_VALUE "Unknown"
  set_parameter_property SPEED_GRADE ENABLED false
  set_parameter_property SPEED_GRADE VISIBLE true
  set_parameter_property SPEED_GRADE HDL_PARAMETER false
  set_parameter_property SPEED_GRADE DESCRIPTION "Indicate the core fabric speed grade of the FPGA."

  add_parameter CORE_SPEED_GRADE STRING
  set_parameter_property CORE_SPEED_GRADE DEFAULT_VALUE "00"
  set_parameter_property CORE_SPEED_GRADE ENABLED false
  set_parameter_property CORE_SPEED_GRADE VISIBLE false
  set_parameter_property CORE_SPEED_GRADE DERIVED true
  set_parameter_property CORE_SPEED_GRADE HDL_PARAMETER true


  add_parameter parttrait_supportsvid STRING "0"
  set_parameter_property parttrait_supportsvid SYSTEM_INFO_TYPE PART_TRAIT
  set_parameter_property parttrait_supportsvid SYSTEM_INFO_ARG SUPPORTS_VID
  set_parameter_property parttrait_supportsvid VISIBLE false

  add_parameter DEVICE_SUPPORTS_AVS_GUI STRING
  set_parameter_property DEVICE_SUPPORTS_AVS_GUI DEFAULT_VALUE "No"
  set_parameter_property DEVICE_SUPPORTS_AVS_GUI DISPLAY_NAME "Device Supports VID"
  set_parameter_property DEVICE_SUPPORTS_AVS_GUI ENABLED false
  set_parameter_property DEVICE_SUPPORTS_AVS_GUI VISIBLE true
  set_parameter_property DEVICE_SUPPORTS_AVS_GUI DERIVED true
  set_parameter_property DEVICE_SUPPORTS_AVS_GUI HDL_PARAMETER false
  set_parameter_property DEVICE_SUPPORTS_AVS_GUI DESCRIPTION "Indicate whether the device supports VID"

  add_parameter DEVICE_SUPPORTS_AVS INTEGER
  set_parameter_property DEVICE_SUPPORTS_AVS DEFAULT_VALUE 0
  set_parameter_property DEVICE_SUPPORTS_AVS ENABLED false
  set_parameter_property DEVICE_SUPPORTS_AVS VISIBLE false
  set_parameter_property DEVICE_SUPPORTS_AVS DERIVED true
  set_parameter_property DEVICE_SUPPORTS_AVS HDL_PARAMETER true

  add_parameter DEVICE STRING
  set_parameter_property DEVICE SYSTEM_INFO {DEVICE}
  set_parameter_property DEVICE DISPLAY_NAME "Device"
  set_parameter_property DEVICE DEFAULT_VALUE ""
  set_parameter_property DEVICE ENABLED false
  set_parameter_property DEVICE VISIBLE false
  set_parameter_property DEVICE DERIVED false
  set_parameter_property DEVICE HDL_PARAMETER false

  add_parameter VID_TEMP_DEPEND INTEGER
  set_parameter_property VID_TEMP_DEPEND DEFAULT_VALUE 1
  set_parameter_property VID_TEMP_DEPEND ENABLED false
  set_parameter_property VID_TEMP_DEPEND VISIBLE false
  set_parameter_property VID_TEMP_DEPEND DERIVED true
  set_parameter_property VID_TEMP_DEPEND HDL_PARAMETER true


}

proc add_parameters {} {	

  add_parameter AVS_ENABLE INTEGER
  set_parameter_property AVS_ENABLE DEFAULT_VALUE 1
  set_parameter_property AVS_ENABLE VISIBLE false
  set_parameter_property AVS_ENABLE HDL_PARAMETER true


  add_parameter CALIBRATION_EN INTEGER 0
  set_parameter_property CALIBRATION_EN DISPLAY_NAME  "Enable calibration "
  set_parameter_property CALIBRATION_EN DEFAULT_VALUE 0
  set_parameter_property CALIBRATION_EN DISPLAY_HINT boolean
  set_parameter_property CALIBRATION_EN HDL_PARAMETER false
  set_parameter_property CALIBRATION_EN ENABLED false
  set_parameter_property CALIBRATION_EN VISIBLE false
  set_parameter_property CALIBRATION_EN DESCRIPTION "Requires handshaking signal to regulate the voltage"


  add_parameter CC1_VID_OP_START STRING "Yes"
  set_parameter_property CC1_VID_OP_START DISPLAY_NAME "Start operation"
  set_parameter_property CC1_VID_OP_START DEFAULT_VALUE "Yes"
  set_parameter_property CC1_VID_OP_START ALLOWED_RANGES {"No:No" "Yes:Yes"}
  set_parameter_property CC1_VID_OP_START HDL_PARAMETER false
  set_parameter_property CC1_VID_OP_START DESCRIPTION "Enable bit to start SmartVID operation after out-of-reset"

  add_parameter CC2_DYN_AVS_CONTROL STRING "Yes"
  set_parameter_property CC2_DYN_AVS_CONTROL DISPLAY_NAME "Enable SmartVID computation"
  set_parameter_property CC2_DYN_AVS_CONTROL DEFAULT_VALUE "Yes"
  set_parameter_property CC2_DYN_AVS_CONTROL ALLOWED_RANGES {"No:No" "Yes:Yes"}
  set_parameter_property CC2_DYN_AVS_CONTROL HDL_PARAMETER false
  set_parameter_property CC2_DYN_AVS_CONTROL DESCRIPTION "This parameter is to set the cc2_dyn_avs_control bit to 1 to enable the SmartVID computation"
  
  add_parameter CC2_VID_STEP INTEGER 10
  set_parameter_property CC2_VID_STEP DISPLAY_NAME "Step size in VID code"
  set_parameter_property CC2_VID_STEP DEFAULT_VALUE 10
  set_parameter_property CC2_VID_STEP HDL_PARAMETER false
  set_parameter_property CC2_VID_STEP DISPLAY_UNITS "mV"
  set_parameter_property CC2_VID_STEP ALLOWED_RANGES {5:5 10:10 15:15 20:20 25:25 30:30 35:35 40:40 45:45 50:50}
  set_parameter_property CC2_VID_STEP DESCRIPTION "The difference between two consecutive vid code in mV"

  add_parameter CC2_VID_COMPUTE_DELAY INTEGER 10
  set_parameter_property CC2_VID_COMPUTE_DELAY DISPLAY_NAME "Minimum time for VID code update"
  set_parameter_property CC2_VID_COMPUTE_DELAY DEFAULT_VALUE 10
  set_parameter_property CC2_VID_COMPUTE_DELAY HDL_PARAMETER false
  set_parameter_property CC2_VID_COMPUTE_DELAY ALLOWED_RANGES 10:1048
  set_parameter_property CC2_VID_COMPUTE_DELAY DISPLAY_UNITS "ms"
  set_parameter_property CC2_VID_COMPUTE_DELAY DESCRIPTION "The duration where a new vid code is computed after the previous vid code is read"

  add_parameter VID_OP_START INTEGER 1
  set_parameter_property VID_OP_START DEFAULT_VALUE 1
  set_parameter_property VID_OP_START ALLOWED_RANGES {0:0 1:1}
  set_parameter_property VID_OP_START HDL_PARAMETER true
  set_parameter_property VID_OP_START ENABLED false
   set_parameter_property VID_OP_START VISIBLE false
  set_parameter_property VID_OP_START DERIVED true

  add_parameter DYN_AVS_CONTROL INTEGER 1
  set_parameter_property DYN_AVS_CONTROL DEFAULT_VALUE 1
  set_parameter_property DYN_AVS_CONTROL ALLOWED_RANGES {0:0 1:1}
  set_parameter_property DYN_AVS_CONTROL HDL_PARAMETER true
  set_parameter_property DYN_AVS_CONTROL ENABLED false
  set_parameter_property DYN_AVS_CONTROL VISIBLE false
  set_parameter_property DYN_AVS_CONTROL DERIVED true

  add_parameter VID_STEP STD_LOGIC_VECTOR 2
  set_parameter_property VID_STEP DEFAULT_VALUE 2
  set_parameter_property VID_STEP HDL_PARAMETER true
  set_parameter_property VID_STEP ALLOWED_RANGES 0:48
  set_parameter_property VID_STEP VISIBLE false
  set_parameter_property VID_STEP ENABLED false
  set_parameter_property VID_STEP DERIVED true

  add_parameter VID_COMPUTE_DELAY STD_LOGIC_VECTOR 10000
  set_parameter_property VID_COMPUTE_DELAY DEFAULT_VALUE 10000
  set_parameter_property VID_COMPUTE_DELAY HDL_PARAMETER true
  set_parameter_property VID_COMPUTE_DELAY ALLOWED_RANGES 10000:1048575
  set_parameter_property VID_COMPUTE_DELAY ENABLED false
  set_parameter_property VID_COMPUTE_DELAY VISIBLE false
  set_parameter_property VID_COMPUTE_DELAY DERIVED true

}

proc validate_parameter {} {
  global CAL_EN
  set CAL_EN [get_parameter_value CALIBRATION_EN]
  set avs_enable_value [get_parameter_value AVS_ENABLE]
  set device_traits_value [get_parameter_value parttrait_supportsvid]

  validate_op_start [get_parameter_value CC1_VID_OP_START ]
  validate_dyn_avs [get_parameter_value CC2_DYN_AVS_CONTROL ]
  validate_compute_delay [get_parameter_value CC2_VID_COMPUTE_DELAY ]
  validate_vid_step [get_parameter_value CC2_VID_STEP ]
  validate_core_speed_grade [get_parameter_value SPEED_GRADE]
  validate_temp_depend [get_parameter_value DEVICE]
  validate_avs_params_enable $avs_enable_value $device_traits_value
}

proc validate_op_start { CC1_VID_OP_START } {
   if {$CC1_VID_OP_START == "No"} {
      set_parameter_value VID_OP_START 0
    } else {
      set_parameter_value VID_OP_START 1
   }
}

proc validate_dyn_avs { CC2_DYN_AVS_CONTROL } {
   if {$CC2_DYN_AVS_CONTROL == "No"} {
      set_parameter_value DYN_AVS_CONTROL 0
    } else {
      set_parameter_value DYN_AVS_CONTROL 1
   }
}

proc validate_compute_delay { CC2_VID_COMPUTE_DELAY } {
   set val 000
   set_parameter_value VID_COMPUTE_DELAY $CC2_VID_COMPUTE_DELAY$val
}

proc validate_vid_step { CC2_VID_STEP } {
   if {$CC2_VID_STEP == 5} {
      set_parameter_value VID_STEP 1
   } elseif {$CC2_VID_STEP == 10} {
      set_parameter_value VID_STEP 2
   } elseif {$CC2_VID_STEP == 15} {
      set_parameter_value VID_STEP 3
   } elseif {$CC2_VID_STEP == 20} {
      set_parameter_value VID_STEP 4
   } elseif {$CC2_VID_STEP == 25} {
      set_parameter_value VID_STEP 5
   } elseif {$CC2_VID_STEP == 30} {
      set_parameter_value VID_STEP 6
   } elseif {$CC2_VID_STEP == 35} {
      set_parameter_value VID_STEP 7
   } elseif {$CC2_VID_STEP == 40} {
      set_parameter_value VID_STEP 8
   } elseif {$CC2_VID_STEP == 45} {
      set_parameter_value VID_STEP 9
   } elseif {$CC2_VID_STEP == 50} {
      set_parameter_value VID_STEP 10
   } else {
      set_parameter_value VID_STEP 2
   }
}

proc validate_core_speed_grade { SPEED_GRADE } {
  if {$SPEED_GRADE == 3} {
    set_parameter_value CORE_SPEED_GRADE "00"
  } elseif {$SPEED_GRADE == 2} {
    set_parameter_value CORE_SPEED_GRADE "11"
  } elseif {$SPEED_GRADE == 1} {
    set_parameter_value CORE_SPEED_GRADE "10"
  } else {
    set_parameter_value CORE_SPEED_GRADE "00"
  }
}

proc validate_temp_depend { DEVICE} {
   if { [string match "*E2*" $DEVICE] ==1} {
   set_parameter_value VID_TEMP_DEPEND 0
   } elseif { [string match "*E1*" $DEVICE] ==1} {
   set_parameter_value VID_TEMP_DEPEND 0
   } elseif { [string match "*E3*" $DEVICE] ==1} {
   set_parameter_value VID_TEMP_DEPEND 0
   } elseif { [string match "*ES*" $DEVICE] ==1} {
   set_parameter_value VID_TEMP_DEPEND 0
   } else {
    set_parameter_value VID_TEMP_DEPEND 1
   }
}

proc validate_avs_params_enable { AVS_ENABLE device_traits_value } {

  if {$device_traits_value} {
    set_parameter_value DEVICE_SUPPORTS_AVS_GUI "Yes"
    set_parameter_value DEVICE_SUPPORTS_AVS  1
   
    set_parameter_property CC1_VID_OP_START ENABLED true
    set_parameter_property CC1_VID_OP_START VISIBLE true
    
    set_parameter_property CC2_DYN_AVS_CONTROL ENABLED true
    set_parameter_property CC2_DYN_AVS_CONTROL VISIBLE true
    
    set_parameter_property CC2_VID_STEP ENABLED true
    set_parameter_property CC2_VID_STEP VISIBLE true
   
    set_parameter_property CC2_VID_COMPUTE_DELAY ENABLED true
    set_parameter_property CC2_VID_COMPUTE_DELAY VISIBLE true
  } else {                                     
    set_parameter_value DEVICE_SUPPORTS_AVS_GUI "No"
    set_parameter_value DEVICE_SUPPORTS_AVS  0
    
    set_parameter_property CC1_VID_OP_START ENABLED false
    set_parameter_property CC1_VID_OP_START VISIBLE false
    
    set_parameter_property CC2_DYN_AVS_CONTROL ENABLED false
    set_parameter_property CC2_DYN_AVS_CONTROL VISIBLE false
    
    set_parameter_property CC2_VID_STEP ENABLED false
    set_parameter_property CC2_VID_STEP VISIBLE false
    
    set_parameter_property CC2_VID_COMPUTE_DELAY ENABLED false
    set_parameter_property CC2_VID_COMPUTE_DELAY VISIBLE false
  }

   if {[get_parameter_value AVS_ENABLE] == 1} {
     send_message info "Please ensure that ENABLE_SMART_VOLTAGE_ID QSF  is set to 'ON' in Quartus Setting File"
   }
}
