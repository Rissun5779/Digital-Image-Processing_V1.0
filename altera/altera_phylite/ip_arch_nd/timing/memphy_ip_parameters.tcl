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


#####################################################################
#
# THIS IS AN AUTO-GENERATED FILE!
# -------------------------------
# If you modify this files, all your changes will be lost if you
# regenerate the core!
#
# FILE DESCRIPTION
# ----------------
# This file specifies the timing properties of the memory device and
# of the memory interface

package require ::quartus::emif_timing_model

proc choose_protocol {mem_period} {
	upvar var var
	set chosen_protocol ddr4
	set protocols [list ddr4 ddr3 qdriv qdrii rldram3]
	set largest_protocol_period_so_far 0.0
	foreach i $protocols {
		initialize_emiftcl -protocol  $i
		set i_period [emiftcl_get_parameter_value -parameter EXTRACTED_PERIOD]
		if { [expr floor($i_period)] <= [expr floor($mem_period)] && $i_period > $largest_protocol_period_so_far } { 
			set largest_protocol_period_so_far $i_period
			set chosen_protocol $i
		}	
      delete_emiftcl
	}
	set var(CHOSEN_PROTOCOL) $chosen_protocol
	return $chosen_protocol
}

