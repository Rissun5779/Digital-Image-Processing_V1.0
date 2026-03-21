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
## Bitec Clock Recovery IP Core
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
## Date           : $Date: 2014-12-17 19:20:16 +0200 (Wed, 17 Dec 2014) $
## Revision       : $Revision: 1529 $
## URL            : $URL: svn://nas-bitec-fi/dp/trunk/rtl/bitec_dp.sdc $
## *********************************************************************
## Description
##
## Timing constraints
##
## *********************************************************************

# bitec_cc_fifo and bitec_pixbuf_fifo have internal aclr synchronization to rd and wr clocks enabled
set_false_path -from [get_keepers {*bitec_clkrec*|reset_d*}] -to {*|dcfifo*rdaclr*}
set_false_path -from [get_keepers {*bitec_clkrec*|rec_reset*}] -to {*|dcfifo*rdaclr*}
set_false_path -from [get_keepers {*bitec_clkrec*|fifo_aclr*}] -to {*|dcfifo*rdaclr*}
set_false_path -from [get_keepers {*bitec_clkrec*|reset_d*}] -to {*|dcfifo*wraclr*}
set_false_path -from [get_keepers {*bitec_clkrec*|rec_reset*}] -to {*|dcfifo*wraclr*}
set_false_path -from [get_keepers {*bitec_clkrec*|fifo_aclr*}] -to {*|dcfifo*wraclr*}

## *********************************************************************
## Constrain all used DCFIFO, instance by instance
## *********************************************************************

# the embedded set_false_path within dcfifo component is disabled internally to the Clock Recovery using acf_disable_embedded_timing_constraint = "true"
# the following sdc will find all dcfifo instances within a bitec_clkrec core
# it will find for multiple bitec_clkrec core and constrain a dcfifo at a time
#
# do specify the appropriate clock period for the set_max_skew constraint, it must be one launch clock period
# for the read gray-code pointer that cross to the write clock domain, it should be one read clock period
# for the write gray-code pointer that cross to the read clock domain, it should be one write clock period
# the current 2.5ns is very conservative
set skew_clock_period 2.5

# Do not change anything below this line
set module_name bitec_clkrec

# Check if Quartus version is at least 14.1
regexp {[0-9]+.[0-9]+} $quartus(version) qver
if { $qver >= "14.1" } {
  set newver 1
  } else {
  set newver 0
  }

# the dcfifo pointers register from read clock domain to write clock domain
set from_reg rdptr_g
set to_reg ws_dgrp|dffpipe
	
# check for number of dcfifo instances that has rdptr_g[0] path
set inst [get_registers *${module_name}*|${from_reg}\[0\]]
set inst_num [llength [query_collection -report -all $inst]]
#puts "${inst_num} instance(s) found"
	
# constraint one instance at a time to avoid set_max_skew apply to all instances
set inst_list [query_collection -list -all $inst]
foreach each_inst $inst_list {
   # get the path to instance
   regexp {.*bitec_clkrec.*dcfifo.*component} "${each_inst}" inst_path
	#puts "-- $inst_path"
   set_max_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] 100
   set_min_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -100
   set_net_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -max 2
   #set_net_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -min 0
   if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
     # specify one read clock (launch clock) period
     if {$newver} {
       set_max_skew -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] ${skew_clock_period}
     } else {
       set_max_skew -to [get_registers ${inst_path}*${to_reg}*] ${skew_clock_period}
     }
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
foreach each_inst $inst_list {
   # get the path to instance
   regexp {.*bitec_clkrec.*dcfifo.*component} "${each_inst}" inst_path
   set_max_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] 100
   set_min_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -100
   set_net_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -max 2
   #set_net_delay -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] -min 0
   if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
     # specify one write clock (launch clock) period
     if {$newver} {
       set_max_skew -from [get_registers ${inst_path}*${from_reg}\[*\]] -to [get_registers ${inst_path}*${to_reg}*] ${skew_clock_period}
     } else {
       set_max_skew -to [get_registers ${inst_path}*${to_reg}*] ${skew_clock_period}
     }
   }
}

