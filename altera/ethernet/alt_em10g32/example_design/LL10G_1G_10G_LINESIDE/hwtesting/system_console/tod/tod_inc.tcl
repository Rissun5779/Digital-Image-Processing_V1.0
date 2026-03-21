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


source basic/basic.tcl
source system_base_addr_map.tcl
source tod/tod_reg_map.tcl
source test_parameter/parameter.tcl

proc CONFIG_CSR_TOD_1G10G {} {
		global TOD_10G_ADDR
		global TOD_1G_ADDR
		global TOD_MASTER_ADDR
		global MASTER_TOD
		global 1G_TOD
		global 10G_TOD
		
		puts "Configure TOD Master"
		CONFIG_CS_TOD $TOD_MASTER_ADDR $MASTER_TOD
		#0x3B9A8A46
		puts "Configure TOD 10G"
		CONFIG_CS_TOD $TOD_10G_ADDR $1G_TOD 
		#0x3B9AC900
		puts "Configure TOD 1G"
		CONFIG_CS_TOD $TOD_1G_ADDR $10G_TOD

}	 
proc CONFIG_CS_TOD {base_address value} {
       
	   global TOD_SECOND_H
		global TOD_SECOND_L
		global TOD_NANOSECOND
		
       reg_write $base_address  $TOD_SECOND_H 0x0000
       reg_write $base_address  $TOD_SECOND_L 0x0000
       reg_write $base_address  $TOD_NANOSECOND $value 
		 #
 
 }