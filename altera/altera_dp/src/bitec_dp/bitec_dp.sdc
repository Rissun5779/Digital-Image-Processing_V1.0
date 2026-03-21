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



## *********************************************************************
##
##
## Bitec Displayport IP Core
## 
##
## All rights reserved. Property of Bitec.
## Restricted rights to use, duplicate or disclose this code are
## granted through contract.
## 
## (C) Copyright Bitec 2010,2011,2012,2013,2014
##     All rights reserved
##
## *********************************************************************
## Author         : $Author: Marco $ @ bitec-dsp.com
## Department     : 
## Date           : $Date: 2016-11-03 16:48:37 +0100 (Thu, 03 Nov 2016) $
## Revision       : $Revision: 2509 $
## URL            : $URL: svn://10.9.0.1/dp/trunk/rtl/bitec_dp.sdc $
## *********************************************************************
## Description
##
## Timing constraints
## 
## *********************************************************************

## *********************************************************************
## Constrain all used DCFIFO, instance by instance
## *********************************************************************

# the embedded set_false_path within dcfifo component is disabled internally to the DP core using acf_disable_embedded_timing_constraint = "true"
# the following sdc will find all dcfifo instances within a bitec_dp core
# it will find for multiple bitec_dp core and constrain a dcfifo at a time
#
# do specify the appropriate clock period for the set_max_skew constraint, it must be one launch clock period
# for the read gray-code pointer that cross to the write clock domain, it should be one read clock period
# for the write gray-code pointer that cross to the read clock domain, it should be one write clock period
# the current 2.5ns is very conservative
set skew_clock_period 2.5

# Do not change anything below this line
set module_name bitec_dp:

# the dcfifo pointers register from read clock domain to write clock domain
set from_reg rdptr_g
set to_reg ws_dgrp|dffpipe
	
# check for number of dcfifo instances that has rdptr_g[0] path
set inst [get_registers *${module_name}*|${from_reg}\[0\]]
set inst_num [llength [query_collection -report -all $inst]]
#puts "${inst_num} instance(s) found"
	
# constraint one instance at a time to avoid set_max_skew apply to all instances
set inst_list [query_collection -list -all $inst]
set split_inst_list [split $inst_list]
foreach each_inst $split_inst_list {
   # get the path to instance
   regexp {.*bitec_dp.*dcfifo.*component} "${each_inst}" inst_path
	#puts "-- $inst_path"
   set_max_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] 100
   set_min_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -100
   set_net_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -max 2
   if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
     # specify one read clock (launch clock) period
     set_max_skew -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] ${skew_clock_period}
   }
}
	
# the dcfifo pointers register from write clock domain to read clock domain
set from_reg delayed_wrptr_g
set to_reg rs_dgwp|dffpipe

# check for number of dcfifo instances that has delayed_wrptr_g[0]
set inst [get_registers *${module_name}*|${from_reg}\[0\]]
set inst_num [llength [query_collection -report -all $inst]]
#puts "${inst_num} instance(s) found"
	
# constraint one instance at a time to avoid set_max_skew apply to all instances
set inst_list [query_collection -list -all $inst]
set split_inst_list [split $inst_list]
foreach each_inst $split_inst_list {
   # get the path to instance
   regexp {.*bitec_dp.*dcfifo.*component} "${each_inst}" inst_path
   set_max_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] 100
   set_min_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -100
   set_net_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -max 2
   if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
     # specify one write clock (launch clock) period
     set_max_skew -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] ${skew_clock_period}
   }
}

## *********************************************************************
## Constrain critical 8b10b decoding paths
## *********************************************************************

set_net_delay -max -from * -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[*]*data_to_8b10b*}] 5
set_net_delay -min -from * -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[*]*data_to_8b10b*}] 0
#report_path -panel_name "data_to_8b10b delays" -from * -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[*]*data_to_8b10b*}] -npaths 1000


# FB:497297, way to skip warnings
if { ![string equal "quartus_map" $::TimeQuestInfo(nameofexecutable)] } {
   set_max_skew -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[0]*data_to_8b10b*}] 2.0
   set_max_skew -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[1]*data_to_8b10b*}] 2.0
   set_max_skew -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[2]*data_to_8b10b*}] 2.0
   set_max_skew -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[3]*data_to_8b10b*}] 2.0
}


set_net_delay -max -from [get_keepers {*data_to_8b10b*}] -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[*]*disp_err_r*}] 10
set_net_delay -min -from [get_keepers {*data_to_8b10b*}] -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[*]*disp_err_r*}] 0
set_net_delay -max -from [get_keepers {*data_to_8b10b*}] -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[*]*code_err_r*}] 10
set_net_delay -min -from [get_keepers {*data_to_8b10b*}] -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[*]*code_err_r*}] 0
#report_path -panel_name "disp_err_r delays" -from [get_keepers {*data_to_8b10b*}] -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[*]*disp_err_r*}] -npaths 1000
#report_path -panel_name "code_err_r delays" -from [get_keepers {*data_to_8b10b*}] -to [get_keepers {*bitec_dp_rx_mac*c8b_10b_decoder_l[*]*code_err_r*}] -npaths 1000

## *********************************************************************
## Set False Path on DCFIFO clrn paths
## *********************************************************************

set_false_path -to [get_pins -nocase -compatibility_mode {*|bitec_dp_dcfifo:*:rdaclr*|dff*|clrn}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|bitec_dp_dcfifo:*:wraclr*|dff*|clrn}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|bitec_dp_dcfifo:*:ws_dgrp*|dff*|clrn}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|bitec_dp_dcfifo:*|counter_reg_bit*|clrn}]

## *********************************************************************
## Various constraints
## *********************************************************************

set_multicycle_path -from {*bitec_dp*bitec_dp_rx_alt_pcs_i*bitslip[*]} -to * -setup 3
set_multicycle_path -from {*bitec_dp*bitec_dp_rx_alt_pcs_i*bitslip[*]} -to * -hold 2
