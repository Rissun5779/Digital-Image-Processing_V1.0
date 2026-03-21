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


#package require -exact qsys 18.1
##########################################################################
#
# Retrieve Port of a PCIe QSYS system and set pinout for A10 Dev Kit
# qsys-script --cmd='set argstring "project,device";' --script="a10-revd-devkit-pinout-qsys-script.tcl
#
# Create a txt file to be included in the QSF file

##########################################################################
#
# $qsys_system is defied in the input command argument --cmd
#
puts "--------- ::                                                                                                                 "
puts "--------- ::                       a10-revd-devkit-pinout-qsys-script.tcl                                                    "
puts "--------- ::          Retrieve Port of a PCIe QSYS system and set pinout for A10 Dev Kit                                     "
puts "--------- ::                                                                                                                 "

set arg_list            [split $argstring ","]
set project_name        [lindex $arg_list  0]
set DeviceQSF           [lindex $arg_list  1]
set IsA10DevkitDevicePinout   [string equal $DeviceQSF "10AX115S1F45I1SG"]
if {[string equal $DeviceQSF "10AX115S1F45I1SGE2"]} {
   set IsA10DevkitDevicePinout 1
}

puts "--------- ::  DeviceQSF    : $DeviceQSF                                                                                      "
puts "--------- ::  project_name : $project_name                                                                                   "
puts "--------- ::                                                                                                                 "

# Open QSYS system
set qsys_system "${project_name}.qsys"
load_system $qsys_system
set_project_property DEVICE "${DeviceQSF}"
save_system $qsys_system

set a10_devkit_tcl "${project_name}_a10_revd_devkit_qsf.tcl"
set a10_devkit_sdc "${project_name}_a10_revd_devkit_sdc.sdc"
set QSF_FILE [ open $a10_devkit_tcl "w" ]
set SDC_FILE [ open $a10_devkit_sdc "w" ]


puts "--------- ::---------------------------------------------------------------------------------------------------------------- "
puts "--------- ::                                                                                                                 "
puts "--------- ::                                                                                                                 "
puts "--------- ::                                                                                                                 "
puts $QSF_FILE "set_global_assignment -name FAMILY \"Arria 10\""
puts $QSF_FILE "set_global_assignment -name DEVICE ${DeviceQSF}"
puts $QSF_FILE ""

puts $SDC_FILE "derive_pll_clocks -create_base_clocks"
close $SDC_FILE


proc ParamExist {ComponentInstance ParameterName} {
   set res 0
   set DUT_Param [ get_instance_parameters $ComponentInstance ]
   foreach {i} $DUT_Param {
      if { $i == $ParameterName } {
         set res 1
         break
      }
   }
   return $res
}

proc SetSDCFalsePath {node_name node_is_a_port from_node sdc_file } {
   set SDC_FILE [ open $sdc_file "a" ]
   set get_node [expr ($node_is_a_port>0)?"get_ports":"get_registers"]
   puts $SDC_FILE "if \{ \[ get_collection_size \[${get_node} -nocase -nowarn \{\*${node_name}\}\]\] > 0 \} \{"
   if { ${from_node} == 1 } {
      puts $SDC_FILE "   set_false_path -from \[${get_node} \{\*${node_name}\}\] -to \*"
   } else {
      puts $SDC_FILE "   set_false_path  -from \* -to \[${get_node} \{\*${node_name}\}\] "
   }
   puts $SDC_FILE "\}"
   close $SDC_FILE
}

for {set i 0} {$i < 32} {incr i} {
   set node_name "altpcie_test_in_static_signal_to_be_false_path\[${i}\]"
   SetSDCFalsePath $node_name 0 1 $a10_devkit_sdc
}

foreach export_interface [ get_interfaces ] {
   set inner_interface [ get_interface_property $export_interface EXPORT_OF ]
   regsub {\.[^.]*} $inner_interface "" instance
   regsub {^.*\.} $inner_interface "" instance_interface
   set classname [ get_instance_interface_property $instance $instance_interface CLASS_NAME ]
   regsub {_[^_]*} $classname "" type
   regsub {^.*_} $classname "" direction

    set type [ get_instance_property $instance CLASS_NAME ]
    puts "--------- :: class_type : ${type} "
    if { $type == "altpcie_devkit"} {
      if { $instance_interface == "dk_board" } {
         if { $IsA10DevkitDevicePinout > 0 } {
            puts $QSF_FILE "set_location_assignment PIN_AV24 -to ${export_interface}\_free_clk"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD LVDS -to ${export_interface}\_free_clk"
            puts $QSF_FILE "set_location_assignment PIN_BA27 -to ${export_interface}\_lane_active_led\[0\]"
            puts $QSF_FILE "set_location_assignment PIN_BB27 -to ${export_interface}\_lane_active_led\[2\]"
            puts $QSF_FILE "set_location_assignment PIN_BD28 -to ${export_interface}\_lane_active_led\[3\]"
            puts $QSF_FILE "set_location_assignment PIN_BC28 -to ${export_interface}\_gen2_led"
            puts $QSF_FILE "set_location_assignment PIN_BC29 -to ${export_interface}\_gen3_led"
            puts $QSF_FILE "set_location_assignment PIN_L28 -to ${export_interface}\_L0_led"
            puts $QSF_FILE "set_location_assignment PIN_K26 -to ${export_interface}\_alive_led"
            puts $QSF_FILE "set_location_assignment PIN_K25 -to ${export_interface}\_comp_led"
            puts $QSF_FILE "set_location_assignment PIN_U12 -to ${export_interface}\_req_compliance_pb"
            puts $QSF_FILE "set_location_assignment PIN_A24 -to ${export_interface}\_set_compliance_mode"

            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_lane_active_led\[0\]"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_lane_active_led\[2\]"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_lane_active_led\[3\]"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_gen2_led"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_gen3_led"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_L0_led"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_alive_led"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_comp_led"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_req_compliance_pb"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_set_compliance_mode"
         } else {
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_free_clk"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_lane_active_led\[0\]"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_lane_active_led\[2\]"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_lane_active_led\[3\]"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_gen2_led"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_gen3_led"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_L0_led"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_alive_led"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_comp_led"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_req_compliance_pb"
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to ${export_interface}\_set_compliance_mode"
         }
         SetSDCFalsePath "${export_interface}\_lane_active_led\[0\]" 1 0 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_lane_active_led\[1\]" 1 0 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_lane_active_led\[2\]" 1 0 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_lane_active_led\[3\]" 1 0 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_gen2_led"             1 0 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_gen3_led"             1 0 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_L0_led"               1 0 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_alive_led"            1 0 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_comp_led"             1 0 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_req_compliance_pb"    1 1 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_set_compliance_mode"  1 1 $a10_devkit_sdc
      }
    }
    if { $type == "altera_generic_component" || $type == "altera_pcie_a10_hip" } {
      set VIRTUAL_PIN_INTERFACE "hip_pipe hip_ctrl currentspeed hip_status rx_bar tx_cred int_msi lmi power_mgnt config_bypass config_tl cseb config_tl flr cfg_status"
      set space 0
      foreach v $VIRTUAL_PIN_INTERFACE {
         if { $instance_interface == $v } {
            puts $QSF_FILE "set_instance_assignment -name VIRTUAL_PIN ON -to $export_interface\_\*"
            puts           "--------- :: set_instance_assignment -name VIRTUAL_PIN ON -to $export_interface\_\*"
            set space 1
            if { [regexp currentspeed $v] } {
               SetSDCFalsePath "${export_interface}\*" 1 0 $a10_devkit_sdc
            }
            if { [regexp hip_pipe $v] } {
               SetSDCFalsePath "${export_interface}\*ltssmstate\[\*\]" 1 0 $a10_devkit_sdc
            }
         }
      }
      if { $space==1 } {
         puts           "--------- ::"
      }
      set space 0
      if { $instance_interface == "npor" } {
         SetSDCFalsePath "${export_interface}\_pin_perst"  1 1 $a10_devkit_sdc
         SetSDCFalsePath "${export_interface}\_npor"       1 1 $a10_devkit_sdc
      }
      if { $instance_interface == "hip_ctrl" } {
         SetSDCFalsePath "${export_interface}\_\*"       1 1 $a10_devkit_sdc
      }
      if { $IsA10DevkitDevicePinout == 0 } {
         if { $instance_interface == "npor" } {
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_pin_perst"
         }
         if { $instance_interface == "refclk" } {
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD HCSL -to ${export_interface}_clk"
         }
      } else {
         if { $instance_interface == "npor" } {
            puts $QSF_FILE "set_location_assignment PIN_BC30 -to ${export_interface}\_pin_perst"
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"1.8 V\" -to ${export_interface}\_pin_perst"
            puts $QSF_FILE "set_location_assignment PIN_T12 -to ${export_interface}\_npor"
         }
         if { $instance_interface == "refclk" } {
            puts $QSF_FILE "set_location_assignment PIN_AL37 -to ${export_interface}_clk"
            puts $QSF_FILE "set_location_assignment PIN_AL38 -to \"${export_interface}_clk(n)\""
            puts $QSF_FILE "set_instance_assignment -name IO_STANDARD HCSL -to ${export_interface}_clk"
            puts $QSF_FILE "set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to ${export_interface}_clk"
         }
         if { $instance_interface == "hip_serial" } {
            array set rxn {
                 0 PIN_AT39
                 1 PIN_AP39
                 2 PIN_AN41
                 3 PIN_AM39
                 4 PIN_AL41
                 5 PIN_AK39
                 6 PIN_AJ41
                 7 PIN_AH39
            }
            array set rx {
                 0 PIN_AT40
                 1 PIN_AP40
                 2 PIN_AN42
                 3 PIN_AM40
                 4 PIN_AL42
                 5 PIN_AK40
                 6 PIN_AJ42
                 7 PIN_AH40
            }

            array set txn {
                 0 PIN_BB43
                 1 PIN_BA41
                 2 PIN_AY43
                 3 PIN_AW41
                 4 PIN_AV43
                 5 PIN_AU41
                 6 PIN_AT43
                 7 PIN_AR41
            }
            array set tx {
                 0 PIN_BB44
                 1 PIN_BA42
                 2 PIN_AY44
                 3 PIN_AW42
                 4 PIN_AV44
                 5 PIN_AU42
                 6 PIN_AT44
                 7 PIN_AR42
            }
            set nlanes 8
            if  { [ ParamExist $instance link_width_hwtcl ] == 1 } {
               set nlanes [string replace [ get_instance_parameter_value $instance link_width_hwtcl ] 0 0 "" ]
               puts "--------- :: Detected $nlanes lane(s)"
            }
            for {set i 0} {$i < $nlanes} {incr i} {
               set rxin "_rx_in$i"
               set txout "_tx_out$i"
               puts $QSF_FILE "set_location_assignment $rxn($i) -to \"${export_interface}$rxin\(n)\""
               puts $QSF_FILE "set_location_assignment $rx($i) -to ${export_interface}$rxin"
               puts $QSF_FILE "set_instance_assignment -name IO_STANDARD CML -to ${export_interface}$rxin"
               puts $QSF_FILE "set_location_assignment $txn($i) -to \"${export_interface}$txout\(n)\""
               puts $QSF_FILE "set_location_assignment $tx($i) -to ${export_interface}$txout"
               puts $QSF_FILE "set_instance_assignment -name IO_STANDARD \"HSSI DIFFERENTIAL I/O\" -to ${export_interface}$txout"
               puts $QSF_FILE "set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to ${export_interface}$rxin"
               puts $QSF_FILE "set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to ${export_interface}$txout"
            }
         }
      }
    }
}

close $QSF_FILE

puts "--------- ::                                                                                                                 "
puts "--------- ::                                                                                                                 "
puts "--------- :: Successfully generated : ${a10_devkit_tcl}, ${a10_devkit_sdc}                                                 "
puts "--------- ::                                                                                                                 "
puts "--------- ::---------------------------------------------------------------------------------------------------------------- "


#   set_global_assignment -name FAMILY "Arria 10"
#   set_global_assignment -name DEVICE 10AX115S1F45I1SG
#   set_global_assignment -name TOP_LEVEL_ENTITY top
#   set_global_assignment -name SMART_RECOMPILE ON
#   set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED
#   set_global_assignment -name FITTER_EFFORT "AUTO FIT"
#   set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON
#   set_instance_assignment -name VIRTUAL_PIN ON -to hip_pipe_*
#
#   set_location_assignment PIN_AT39 -to "hip_serial_rx_in0(n)"
#   set_location_assignment PIN_AT40 -to hip_serial_rx_in0
#   set_instance_assignment -name IO_STANDARD CML -to hip_serial_rx_in0
#   set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to hip_serial_rx_in0
#   set_location_assignment PIN_BB43 -to "hip_serial_tx_out0(n)"
#   set_location_assignment PIN_BB44 -to hip_serial_tx_out0
#   set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to hip_serial_tx_out0
#   set_location_assignment PIN_AP39 -to "hip_serial_rx_in1(n)"
#   set_location_assignment PIN_AP40 -to hip_serial_rx_in1
#   set_instance_assignment -name IO_STANDARD CML -to hip_serial_rx_in1
#   set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to hip_serial_rx_in1
#   set_location_assignment PIN_BA41 -to "hip_serial_tx_out1(n)"
#   set_location_assignment PIN_BA42 -to hip_serial_tx_out1
#   set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to hip_serial_tx_out1
#   set_location_assignment PIN_AN41 -to "hip_serial_rx_in2(n)"
#   set_location_assignment PIN_AN42 -to hip_serial_rx_in2
#   set_instance_assignment -name IO_STANDARD CML -to hip_serial_rx_in2
#   set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to hip_serial_rx_in2
#   set_location_assignment PIN_AY43 -to "hip_serial_tx_out2(n)"
#   set_location_assignment PIN_AY44 -to hip_serial_tx_out2
#   set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to hip_serial_tx_out2
#   set_location_assignment PIN_AM39 -to "hip_serial_rx_in3(n)"
#   set_location_assignment PIN_AM40 -to hip_serial_rx_in3
#   set_instance_assignment -name IO_STANDARD CML -to hip_serial_rx_in3
#   set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to hip_serial_rx_in3
#   set_location_assignment PIN_AW41 -to "hip_serial_tx_out3(n)"
#   set_location_assignment PIN_AW42 -to hip_serial_tx_out3
#   set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to hip_serial_tx_out3
#   set_location_assignment PIN_AL41 -to "hip_serial_rx_in4(n)"
#   set_location_assignment PIN_AL42 -to hip_serial_rx_in4
#   set_instance_assignment -name IO_STANDARD CML -to hip_serial_rx_in4
#   set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to hip_serial_rx_in4
#   set_location_assignment PIN_AV43 -to "hip_serial_tx_out4(n)"
#   set_location_assignment PIN_AV44 -to hip_serial_tx_out4
#   set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to hip_serial_tx_out4
#   set_location_assignment PIN_AK39 -to "hip_serial_rx_in5(n)"
#   set_location_assignment PIN_AK40 -to hip_serial_rx_in5
#   set_instance_assignment -name IO_STANDARD CML -to hip_serial_rx_in5
#   set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to hip_serial_rx_in5
#   set_location_assignment PIN_AU41 -to "hip_serial_tx_out5(n)"
#   set_location_assignment PIN_AU42 -to hip_serial_tx_out5
#   set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to hip_serial_tx_out5
#   set_location_assignment PIN_AJ41 -to "hip_serial_rx_in6(n)"
#   set_location_assignment PIN_AJ42 -to hip_serial_rx_in6
#   set_instance_assignment -name IO_STANDARD CML -to hip_serial_rx_in6
#   set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to hip_serial_rx_in6
#   set_location_assignment PIN_AT43 -to "hip_serial_tx_out6(n)"
#   set_location_assignment PIN_AT44 -to hip_serial_tx_out6
#   set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to hip_serial_tx_out6
#   set_location_assignment PIN_AH39 -to "hip_serial_rx_in7(n)"
#   set_location_assignment PIN_AH40 -to hip_serial_rx_in7
#   set_instance_assignment -name IO_STANDARD CML -to hip_serial_rx_in7
#   set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to hip_serial_rx_in7
#   set_location_assignment PIN_AR41 -to "hip_serial_tx_out7(n)"
#   set_location_assignment PIN_AR42 -to hip_serial_tx_out7
#   set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to hip_serial_tx_out7
#
#   set_location_assignment PIN_AL37 -to refclk_clk
#   set_location_assignment PIN_AL38 -to "refclk_clk(n)"
#   set_instance_assignment -name IO_STANDARD HCSL -to refclk_clk
#   set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to refclk_clk
#   set_location_assignment PIN_BC30 -to pnerstn_perstn
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to perstn_perstn
#   set_location_assignment PIN_AV24 -to dk_free_clk
#   set_instance_assignment -name IO_STANDARD LVDS -to dk_free_clk
#   set_location_assignment PIN_BA27 -to dk_lane_active_led[0]
#   set_location_assignment PIN_BB27 -to dk_lane_active_led[2]
#   set_location_assignment PIN_BD28 -to dk_lane_active_led[3]
#   set_location_assignment PIN_BC28 -to dk_gen2_led
#   set_location_assignment PIN_BC29 -to dk_gen3_led
#   set_location_assignment PIN_L28 -to dk_L0_led
#   set_location_assignment PIN_K26 -to dk_alive_led
#   set_location_assignment PIN_K25 -to dk_comp_led
#   #set_location_assignment PIN_D18 -to live_led
#   #set_location_assignment PIN_L25 -to out_led[3]
#   #set_location_assignment PIN_K25 -to out_led[2]
#   #set_location_assignment PIN_K26 -to out_led[1]
#   #set_location_assignment PIN_L28 -to out_led[0]
#
#   set_location_assignment PIN_T12 -to local_rstn_local_rstn
#   set_location_assignment PIN_U12 -to dk_req_compliance_pb
#   set_location_assignment PIN_A24 -to dk_set_compliance_mode
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_lane_active_led[0]
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_lane_active_led[2]
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_lane_active_led[3]
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_gen2_led
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_gen3_led
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_L0_led
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_alive_led
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_comp_led
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to local_rstn_local_rstn
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_req_compliance_pb
#   set_instance_assignment -name IO_STANDARD "1.8 V" -to dk_set_compliance_mode
#
#   set_instance_assignment -name XCVR_A10_RX_TERM_SEL R_R1 -to hip_serial_rx_in0
#   set_instance_assignment -name XCVR_A10_RX_ONE_STAGE_ENABLE NON_S1_MODE -to hip_serial_rx_in0
#   set_instance_assignment -name XCVR_A10_RX_ADP_CTLE_ACGAIN_4S RADP_CTLE_ACGAIN_4S_7 -to hip_serial_rx_in0
#   set_instance_assignment -name XCVR_A10_RX_EQ_DC_GAIN_TRIM STG1_GAIN7 -to hip_serial_rx_in0
#   set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to hip_serial_rx_in0
#   set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_03V -to hip_serial_rx_in0
#
#   set_instance_assignment -name XCVR_A10_RX_TERM_SEL R_R1 -to hip_serial_rx_in1
#   set_instance_assignment -name XCVR_A10_RX_ONE_STAGE_ENABLE NON_S1_MODE -to hip_serial_rx_in1
#   set_instance_assignment -name XCVR_A10_RX_ADP_CTLE_ACGAIN_4S RADP_CTLE_ACGAIN_4S_7 -to hip_serial_rx_in1
#   set_instance_assignment -name XCVR_A10_RX_EQ_DC_GAIN_TRIM STG1_GAIN7 -to hip_serial_rx_in1
#   set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to hip_serial_rx_in1
#   set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_03V -to hip_serial_rx_in1
#
#   set_instance_assignment -name XCVR_A10_RX_TERM_SEL R_R1 -to hip_serial_rx_in2
#   set_instance_assignment -name XCVR_A10_RX_ONE_STAGE_ENABLE NON_S1_MODE -to hip_serial_rx_in2
#   set_instance_assignment -name XCVR_A10_RX_ADP_CTLE_ACGAIN_4S RADP_CTLE_ACGAIN_4S_7 -to hip_serial_rx_in2
#   set_instance_assignment -name XCVR_A10_RX_EQ_DC_GAIN_TRIM STG1_GAIN7 -to hip_serial_rx_in2
#   set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to hip_serial_rx_in2
#   set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_03V -to hip_serial_rx_in2
#
#   set_instance_assignment -name XCVR_A10_RX_TERM_SEL R_R1 -to hip_serial_rx_in3
#   set_instance_assignment -name XCVR_A10_RX_ONE_STAGE_ENABLE NON_S1_MODE -to hip_serial_rx_in3
#   set_instance_assignment -name XCVR_A10_RX_ADP_CTLE_ACGAIN_4S RADP_CTLE_ACGAIN_4S_7 -to hip_serial_rx_in3
#   set_instance_assignment -name XCVR_A10_RX_EQ_DC_GAIN_TRIM STG1_GAIN7 -to hip_serial_rx_in3
#   set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to hip_serial_rx_in3
#   set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_03V -to hip_serial_rx_in3
#
#   set_instance_assignment -name XCVR_A10_RX_TERM_SEL R_R1 -to hip_serial_rx_in4
#   set_instance_assignment -name XCVR_A10_RX_ONE_STAGE_ENABLE NON_S1_MODE -to hip_serial_rx_in4
#   set_instance_assignment -name XCVR_A10_RX_ADP_CTLE_ACGAIN_4S RADP_CTLE_ACGAIN_4S_7 -to hip_serial_rx_in4
#   set_instance_assignment -name XCVR_A10_RX_EQ_DC_GAIN_TRIM STG1_GAIN7 -to hip_serial_rx_in4
#   set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to hip_serial_rx_in4
#   set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_03V -to hip_serial_rx_in4
#
#   set_instance_assignment -name XCVR_A10_RX_TERM_SEL R_R1 -to hip_serial_rx_in5
#   set_instance_assignment -name XCVR_A10_RX_ONE_STAGE_ENABLE NON_S1_MODE -to hip_serial_rx_in5
#   set_instance_assignment -name XCVR_A10_RX_ADP_CTLE_ACGAIN_4S RADP_CTLE_ACGAIN_4S_7 -to hip_serial_rx_in5
#   set_instance_assignment -name XCVR_A10_RX_EQ_DC_GAIN_TRIM STG1_GAIN7 -to hip_serial_rx_in5
#   set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to hip_serial_rx_in5
#   set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_03V -to hip_serial_rx_in5
#
#   set_instance_assignment -name XCVR_A10_RX_TERM_SEL R_R1 -to hip_serial_rx_in6
#   set_instance_assignment -name XCVR_A10_RX_ONE_STAGE_ENABLE NON_S1_MODE -to hip_serial_rx_in6
#   set_instance_assignment -name XCVR_A10_RX_ADP_CTLE_ACGAIN_4S RADP_CTLE_ACGAIN_4S_7 -to hip_serial_rx_in6
#   set_instance_assignment -name XCVR_A10_RX_EQ_DC_GAIN_TRIM STG1_GAIN7 -to hip_serial_rx_in6
#   set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to hip_serial_rx_in6
#   set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_03V -to hip_serial_rx_in6
#
#   set_instance_assignment -name XCVR_A10_RX_TERM_SEL R_R1 -to hip_serial_rx_in7
#   set_instance_assignment -name XCVR_A10_RX_ONE_STAGE_ENABLE NON_S1_MODE -to hip_serial_rx_in7
#   set_instance_assignment -name XCVR_A10_RX_ADP_CTLE_ACGAIN_4S RADP_CTLE_ACGAIN_4S_7 -to hip_serial_rx_in7
#   set_instance_assignment -name XCVR_A10_RX_EQ_DC_GAIN_TRIM STG1_GAIN7 -to hip_serial_rx_in7
#   set_instance_assignment -name XCVR_A10_RX_ADP_VGA_SEL RADP_VGA_SEL_4 -to hip_serial_rx_in7
#   set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_03V -to hip_serial_rx_in7

