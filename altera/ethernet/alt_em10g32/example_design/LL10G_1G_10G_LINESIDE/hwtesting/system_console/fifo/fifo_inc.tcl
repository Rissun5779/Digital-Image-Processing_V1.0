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
source fifo/fifo_reg_map.tcl

 proc SETFIFO_DROP_ON_ERROR {value} {
    	global 10G_RX_FIFO_BASE_ADDR
    	global RX_FIFO_DROP_ON_ERROR
        puts "\t 			enabling: drop on error in rx fifo"
    	reg_write $10G_RX_FIFO_BASE_ADDR $RXFIFO_DROP_ON_ERROR $value
	}