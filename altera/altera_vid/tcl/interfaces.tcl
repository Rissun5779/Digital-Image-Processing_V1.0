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


proc add_connection {} {
  add_jtag_connections
  add_vid_connections
}

proc add_jtag_connections {} {
  common_add_clock                jtag_core_clk 		clock   input   		1   std   true  0
  common_add_reset 				  vid_jtag_rst_b 		input 	jtag_core_clk  	0

  # Conduit interface
  common_add_conduit     vidctl_tdocore        			export   input 1  std true   0
  common_add_conduit     vidctl_ntrstcore				export   output 1 	std true   0
  common_add_conduit     vidctl_tckcore					export   output 1 	std true   0
  common_add_conduit     vidctl_corectl_jtag			export   output 1 	std true   0
  common_add_conduit     vidctl_tmscore					export   output 1 	std true   0
  common_add_conduit     vidctl_tdicore					export   output 1 	std true   0
}

proc add_vid_connections {} {
  common_add_clock                vid_clk              	clock   input   	1   std   true  0
  common_add_reset 				  vid_rst_b 			input 	vid_clk  	0

  # Management Interface (AV-MM) for JESD204B RX
  add_interface 	              vid_ctl_avmm	       avalon 		                end
  set_interface_property          vid_ctl_avmm          ASSOCIATED_CLOCK                vid_clk
  add_interface_port              vid_ctl_avmm          vidctl_avmm_address 		address 	Input 	3
  add_interface_port              vid_ctl_avmm          vidctl_avmm_read 		read 		Input 	1
  add_interface_port              vid_ctl_avmm          vidctl_avmm_readdata	        readdata 	Output 	32
  add_interface_port              vid_ctl_avmm          vidctl_avmm_write 		write 		Input 	1
  add_interface_port              vid_ctl_avmm          vidctl_avmm_writedata	writedata 	Input 	32

  # Conduit interface
  common_add_conduit     vidctl_vid_ack        			export   input 	1  	std true   0
  common_add_conduit     vidctl_temp	        		export   input 	10  vector true   0
  common_add_conduit     vidctl_eoc		        		export   input 	1  	std true   0
  common_add_conduit     vidctl_temp_sense_enable		export   output 1  	std true   0
  common_add_conduit     vidctl_temp_sense_reset		export   output 1  	std true   0
  common_add_conduit     vidctl_vid_code_avail			export   output 1  	std true   0
  common_add_conduit     vidctl_avs_status				export   output 1  	std true   0
  common_add_conduit     vidctl_vid_code				export   output 6  	vector true   0
  common_add_conduit     vidctl_temp_code				export   output 10 	vector true   0
  common_add_conduit     vidctl_temp_code_valid			export   output 1 	std true   0
  common_add_conduit     cal_done_persistent       export   output 1    std true   0
}

proc validate_connections {} {
   global CAL_EN
   if {$CAL_EN == 1} {
      common_add_conduit     cal_pending         export   output 1    std true   0
      common_add_conduit     cal_start       export   input 1  std true   0
      common_add_conduit     cal_done         export   output 1    std true   0
   } else {
      common_add_conduit     cal_pending         export   output 1    std false   0
      common_add_conduit     cal_start       export   input 1  std false   0
      common_add_conduit     cal_done         export   output 1    std false   0
   }
}

#--Add clock interface and port of same name
#--$port_name   - Interface & port name
#--$int_type    - Type of interface. Can be "clock", "hssi_bonded_clock", "hssi_serial_clock"
#--$port_dir    - Direction of port and interface
#--$width       - Width of port
#--$vhdl_type   - Type of port in vhdl. 'std_logic' or 'std_logic_vector'
#--$used        - Enable or disable this interface. Can be "true" or "false"
#--$terminate   - 1 to terminate this port otherwise 0
proc common_add_clock { port_name int_type port_dir width vhdl_type used terminate } {
#  array set in_out [list {output} {start} {input} {end} ]
#  add_interface $port_name $int_type $in_out($port_dir)
  add_interface $port_name $int_type $port_dir
  set_interface_property $port_name ENABLED $used
  add_interface_port $port_name $port_name clk $port_dir $width
  if {[expr {$port_dir == "input" || $port_dir == "end"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
     set_port_property   $port_name   TERMINATION_VALUE   0
  }
  if {[expr {$port_dir == "output" || $port_dir == "start"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
  }
  if {[expr {$vhdl_type == "std"}]} {
     set_port_property   $port_name   VHDL_TYPE  std_logic
  }
  if {[expr {$vhdl_type == "vector"}]} {
     set_port_property   $port_name   VHDL_TYPE  std_logic_vector
  }

}

#--Add reset interface and port of same name
#--$port_name       - Interface & port name
#--$port_dir        - Direction of port and interface
#--$asscociated_clk - Which clock is this reset associated with
#--$terminate       - 1 to terminate this port otherwise 0
proc common_add_reset { port_name port_dir associated_clk terminate } {
  array set in_out [list {output} {start} {input} {end} ]
  add_interface $port_name reset $in_out($port_dir)
  set_interface_property $port_name ASSOCIATED_CLOCK $associated_clk
#  set_interface_property $port_name synchronousEdges "None"
  add_interface_port $port_name $port_name reset_n $port_dir 1
  if {[expr {$port_dir == "input" || $port_dir == "end"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
     set_port_property   $port_name   TERMINATION_VALUE   0
  }
  if {[expr {$port_dir == "output" || $port_dir == "start"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
  }
}

#--Add conduit interface and port of same name
#--$port_name   - Interface & port name
#--$signal_type - Type of port.
#--$port_dir    - Direction of port and interface
#--$width       - Width of port
#--$vhdl_type   - Type of port in vhdl. 'std_logic' or 'std_logic_vector'
#--$used        - Enable or disable this interface. Can be "true" or "false"
#--$terminate   - 1 to terminate this port otherwise 0
proc common_add_conduit { port_name port_type port_dir width vhdl_type used terminate } {
#  array set in_out [list {output} {start} {input} {end} ]
#  add_interface $port_name conduit $in_out($port_dir)
  add_interface $port_name conduit $port_dir
  set_interface_assignment $port_name "ui.blockdiagram.direction" $port_dir
  set_interface_property $port_name ENABLED $used
  add_interface_port $port_name $port_name $port_type $port_dir $width
  if {[expr {$port_dir == "input" || $port_dir == "end"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
     set_port_property   $port_name   TERMINATION_VALUE   0
  }
  if {[expr {$port_dir == "output" || $port_dir == "start"}] && $terminate == 1} {
     set_port_property   $port_name   TERMINATION   true
  }
  if {[expr {$vhdl_type == "std"}]} {
     set_port_property   $port_name   VHDL_TYPE  std_logic
  }
  if {[expr {$vhdl_type == "vector"}]} {
     set_port_property   $port_name   VHDL_TYPE  std_logic_vector
  }

}
