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


#+---------------------------------------------------------------------------------------
#|
#| Name: make_var_wrapper
#|
#| Purpose: get ip parameters from hw.tcl file and transfer to terp params
#|
#| Return: ip specific vhd and verilog parameters array to pass to terp file
#|
#+----------------------------------------------------------------------------------------

proc make_var_wrapper_tb {params_ref} {

    upvar $params_ref   params
    #---------------------------------------------------------------------------------
    # loop through port_list and add to list module_port_list(port direction width value(for vhdl only)) #
    set module_port_list    [list ]
	set module_input_port_list [list ]
	set module_input_port_only_list [list ]
	set module_output_port_only_list [list ]
    set data_width      [expr {$params(qa_width)-1}]
    set q_width         [expr {$params(qb_width)-1}]
    set wraddress_width [expr {$params(addressa_width) -1 }]
    set rdaddress_width [expr {$params(addressb_width) -1 }]
    if {$params(module_name) eq "altdpram"} {
    foreach port $params(port_list) {
            #lappend module_port_list  $port
            #switch -exact -- $port {
               			if {$port eq "data"} {
                    			lappend module_port_list   "data" "IN"    $data_width -1
					lappend module_input_port_list   "data" "IN"    $data_width -1
					lappend module_input_port_only_list "data"
                		}
                		if {$port eq "wraddress"} {
                    			lappend module_port_list   "wraddress" "IN"    $wraddress_width    -1
					lappend module_input_port_list   "wraddress" "IN"    $wraddress_width    -1
					lappend module_input_port_only_list   "wraddress" 
                		}
               			if  {$port eq "rdaddress"} {
                    			lappend module_port_list    "rdaddress" "IN"    $rdaddress_width    -1
					lappend module_input_port_list    "rdaddress" "IN"    $rdaddress_width    -1
					lappend module_input_port_only_list   "rdaddress" 
                		}
                		if {$port eq "q"} {
                    			lappend module_port_list   "q" "OUT"   $q_width    -1
                		}
				if {$port eq "clock"} {
					lappend  module_port_list  "inclock"  "IN"	-1  1
					lappend  module_port_list  "outclock" "IN" -1   1
					lappend  module_input_port_list  "inclock"  "IN"	-1  1
					lappend  module_input_port_list  "outclock" "IN" -1   1
					lappend  module_input_port_only_list  "inclock"  
					lappend  module_input_port_only_list  "outclock" 
				}                
                		if {$port eq "wrclock"} {
					lappend module_port_list "wrclock" "IN" -1 1
					lappend module_input_port_list "wrclock" "IN" -1 1
					lappend module_input_port_only_list "wrclock" 
				}
				if {$port eq "rdclock"} {
					lappend module_port_list "rdclock" "IN" -1 1
					lappend module_input_port_list "rdclock" "IN" -1 1
					lappend module_input_port_only_list "rdclock" 
				} 
				if {$port eq "inclock"} {
					lappend module_port_list "inclock" "IN" -1 1
					lappend module_input_port_list "inclock" "IN" -1 1
					lappend module_input_port_only_list "inclock" 
				}
				if {$port eq "outclock"} {
					lappend module_port_list "outclock" "IN" -1 1
					lappend module_input_port_list "outclock" "IN" -1 1
					lappend module_input_port_only_list "outclock"					
				}
                		if {$port eq "aclr"} {
					lappend modlue_port_list "aclr" "IN" -1 1 
					lappend modlue_input_port_list "aclr" "IN" -1 1 
					lappend modlue_input_port_only_list "aclr" 
				}
				if {$port eq "wren"} {
					lappend module_port_list "wren" "IN" -1 1 
					lappend module_input_port_list "wren" "IN" -1 1 
					lappend module_input_port_only_list "wren" 
				}
                #default     {
                   # lappend module_port_list    "IN"    -1  1
                #}
            #}
        }
    } else {
         foreach port $params(port_list) {
           # lappend module_port_list $port 
           # switch -exact -- $port {
				if {$port eq "clock"} { 
					lappend module_port_list "clock0" "IN" -1 1
					lappend module_input_port_list "clock0" "IN" -1 1
					lappend module_input_port_only_list "clock0" 
				}
				if {$port eq "inclock"} {
					lappend module_port_list "clock0" "IN" -1 1
					lappend module_input_port_list "clock0" "IN" -1 1
					lappend module_input_port_only_list "clock0" 
				}
				if {$port eq "outclock"} {
					lappend module_port_list "clock1" "IN"	-1 1
					lappend module_input_port_list "clock1" "IN"	-1 1
					lappend module_input_port_only_list "clock1" 
			        }
				if {$port eq "clock_b"} {
					lappend module_port_list "clock1" "IN"	-1 1
					lappend module_input_port_list "clock1" "IN"	-1 1
					lappend module_input_port_only_list "clock1"
				}
				if {$port eq "rdclock"} {
					lappend module_port_list "clock1" "IN"	-1 1
					lappend module_input_port_list "clock1" "IN"	-1 1
					lappend module_input_port_only_list "clock1" 
				}
				if {$port eq "inclocken"} {
					lappend module_port_list "clocken0" "IN" -1 1
					lappend module_input_port_list "clocken0" "IN" -1 1
					lappend module_input_port_only_list "clocken0" 
				}
				if {$port eq "outclocken"} {
					lappend module_port_list "clocken1" "IN" -1 1
					lappend module_input_port_list "clocken1" "IN" -1 1
					lappend module_input_port_only_list "clocken1" 
				}
				if {$port eq "enable"} {
					lappend module_port_list "clocken0" "IN" -1 1
					lappend module_input_port_list "clocken0" "IN" -1 1
					lappend module_input_port_only_list "clocken0" 
				}
				if {$port eq "data"} {      
					lappend module_port_list "data_a" "IN" $data_width -1
					lappend module_input_port_list "data_a" "IN" $data_width -1
					lappend module_input_port_only_list "data_a" 
				}
                		if {$port eq "data_a"} {
                    			lappend module_port_list   "data_a" "IN" $data_width -1
					lappend module_input_port_list   "data_a" "IN" $data_width -1
					lappend module_input_port_only_list   "data_a" 
                		}
				if {$port eq "data_b"} {
                    			lappend module_port_list   "data_b" "IN"  $data_width    -1
					lappend module_input_port_list   "data_b" "IN"  $data_width    -1
					lappend module_input_port_only_list   "data_b"
                		}
				if {$port eq "q_a"} {
                    			lappend module_port_list  "q_a"  "OUT"   $data_width -1
					lappend module_output_port_only_list  "q_a"					
				}
				if {$port eq "address_a"} {
					lappend module_port_list "address_a" "IN" $wraddress_width -1 
					lappend module_input_port_list "address_a" "IN" $wraddress_width -1 
					lappend module_input_port_only_list "address_a" 
				}
				if {$port eq "address_b"} {
					lappend module_port_list "address_b" "IN" $rdaddress_width -1 
					lappend module_input_port_list "address_b" "IN" $rdaddress_width -1 
					lappend module_input_port_only_list "address_b" 
				}
                		if {$port eq "wraddress"} {
                    			lappend module_port_list  "address_a"  "IN"    $wraddress_width    -1
					lappend module_input_port_list  "address_a"  "IN"    $wraddress_width    -1
					lappend module_input_port_only_list  "address_a" 
                		}
				if {$port eq "rdaddress"} {
                    			lappend module_port_list  "address_b"  "IN"    $rdaddress_width    -1
					lappend module_input_port_list  "address_b"  "IN"    $rdaddress_width    -1
					lappend module_input_port_only_list  "address_b" 
                		}
				if {$port eq "eccencparity"} {
					lappend module_port_list	"eccencparity" "IN"	$eccencparity_width -1
					lappend module_input_port_list	"eccencparity" "IN"	$eccencparity_width -1
					lappend module_input_port_only_list	"eccencparity" 
				}
				if {$port eq "eccencbypass"} {
					lappend module_port_list "eccencparity"	"IN"	0	0
					lappend module_input_port_list "eccencparity"	"IN"	0	0
					lappend module_input_port_only_list "eccencparity"	
				}
				if {$port eq "eccstatus"} {
                    			lappend module_port_list  "eccstatus"  "OUT"   $eccstatus_width    -1    
                		}		
				if {$port eq "q"} {
                    			lappend module_port_list  "q_b"  "OUT"   $q_width -1
					lappend module_output_port_only_list  "q_b" 						
                		}
				if {$port eq "q_b"} {
                    			 lappend module_port_list  "q_b"  "OUT"   $q_width -1
					 lappend module_output_port_only_list  "q_b"					
                		}               
				if {$port eq "aclr"} {
					lappend module_port_list "aclr0" "IN" -1 1
					lappend module_input_port_list "aclr0" "IN" -1 1
					lappend module_input_port_only_list "aclr0" 
				}
				if {$port eq "rd_aclr"} {
					lappend module_port_list "rd_aclr" "IN" -1 1
					lappend module_input_port_list "rd_aclr" "IN" -1 1
					lappend module_input_port_only_list "rd_aclr" 
				}
				if {$port eq "in_aclr"} {
					lappend module_port_list "in_aclr" "IN" -1 1
					lappend module_input_port_only_list "in_aclr"
				}
				if {$port eq "out_aclr"} {
					lappend module_port_list "out_aclr" "IN" -1 1
					lappend module_input_port_list "out_aclr" "IN" -1 1
					lappend module_input_port_only_list "out_aclr"
				}
				if {$port eq "sclr"} {
					lappend module_port_list "sclr" "IN" -1 1
					lappend module_input_port_list "sclr" "IN" -1 1
					lappend module_input_port_only_list "sclr" 
				}
				if {$port eq "sclr_a"} {
					lappend module_port_list "sclr" "IN" -1 1
					lappend module_input_port_list "sclr" "IN" -1 1
					lappend module_input_port_only_list "sclr" 
				}
			    	if {$port eq "sclr_b"} {
					lappend module_port_list "sclr" "IN" -1 1
					lappend module_input_port_list "sclr" "IN" -1 1
					lappend module_input_port_port_list "sclr" 
				}
				if {$port eq "rden"} {
					lappend module_port_list "rden_b" "IN" -1 1
					lappend module_input_port_list "rden_b" "IN" -1 1
					lappend module_input_port_only_list "rden_b" 
				}
				if {$port eq "rden_a"} {
					lappend module_port_list "rden_a" "IN" -1 1
					lappend module_input_port_list "rden_a" "IN" -1 1
					lappend module_input_port_port_list "rden_a"
				}
				if {$port eq "rden_b"} {
					lappend module_port_list "rden_b" "IN" -1 1
					lappend module_input_port_list "rden_b" "IN" -1 1
					lappend module_input_port_only_list "rden_b" 
				}
				if {$port eq "wren"} {
					lappend module_port_list "wren_a" "IN" -1 1
					lappend module_input_port_list "wren_a" "IN" -1 1
					lappend module_input_port_only_list "wren_a" 
				}		   
				if {$port eq "wren_a"} {
					lappend module_port_list "wren_a" "IN" -1 1
					lappend module_input_port_list "wren_a" "IN" -1 1
					lappend module_input_port_only_list "wren_a" 
				}
				if {$port eq "wren_b"} {
					lappend module_port_list "wren_b" "IN" -1 1
					lappend module_input_port_list "wren_b" "IN" -1 1
					lappend module_input_port_only_list "wren_b" 
				}
				if {$port eq "rd_addressstall"} {
					lappend module_port_list "rd_addressstall" "IN" -1 1
					lappend module_input_port_list "rd_addressstall" "IN" -1 1
					lappend module_input_port_only_list "rd_addressstall" 
				}
				if {$port eq "wr_addressstall"} {
					lappend module_port_list "addressstall_a" "IN" -1 1
					lappend module_input_port_list "addressstall_a" "IN" -1 1
					lappend module_input_port_only_list "addressstall_a" 
				}
				if {$port eq "addressstall_a"} {
					lappend module_port_list "addressstall_a" "IN" -1 1
					lappend module_input_port_list "addressstall_a" "IN" -1 1
					lappend module_input_port_only_list "addressstall_a" 
				}
				if {$port eq "addressstall_b"} {
					lappend module_port_list "addressstall_b" "IN" -1 1
					lappend module_input_port_list "addressstall_b" "IN" -1 1
					lappend module_input_port_only_list "addressstall_b" 
				}
				if {$port eq "aclr_a"} {
					lappend module_port_list "aclr0" "IN" -1 1
					lappend module_input_port_list "aclr0" "IN" -1 1
					lappend module_input_port_only_list "aclr0" 				
				}
			    	if {$port eq "aclr_b"} {
					lappend module_port_list "aclr1" "IN" -1 1
					lappend module_input_port_list "aclr1" "IN" -1 1
					lappend module_input_port_port_list "aclr1" 
				}
				if {$port eq "byteena_a"} {
					lappend module_port_list "byteena_a" "IN"  $byte_width  2
					lappend module_input_port_list "byteena_a" "IN"  $byte_width  2
					lappend module_input_port_only_list "byteena_a"
				}
				if {$port eq "byteena_b"} {
					lappend module_port_list "byteena_b" "IN"  $byte_width 2
					lappend module_input_port_list "byteena_b" "IN"  $byte_width 2
					lappend module_input_port_only_list "byteena_b" 
				}
                #default     {
                  #  lappend module_port_list    "IN"    -1  1
                #}
            #}
        }
    }
    #----------------------------------------------------------------------------------
    # add all output wire connectin to wire_list and sub_wire_list #
    set wire_list [list ]
    set sub_wire_list [list ]
    if {$data_width == $q_width} {
        lappend sub_wire_list "sub_wire0"   $data_width   [expr {$data_width+1}]
        lappend sub_wire_list "sub_wire1"   -1    1
        lappend sub_wire_list "sub_wire2"   $data_width -1
        lappend sub_wire_list "sub_wire3"   $q_width    -1
        lappend wire_list "q_a" "sub_wire2"  $data_width  0
        lappend wire_list "q_b" "sub_wire3"  $q_width   0
    } else {
        lappend sub_wire_list "sub_wire0"   $data_width   [expr {$data_width+1}]
        lappend sub_wire_list  "sub_wire1"  $q_width    [expr {$q_width+1}]
        lappend sub_wire_list "sub_wire2"   -1    1
        lappend sub_wire_list "sub_wire3"   $data_width -1
        lappend sub_wire_list "sub_wire4"   $q_width    -1
        lappend wire_list "q_a" "sub_wire3"  $data_width  0
        lappend wire_list "q_b" "sub_wire4"  $q_width   0
    }
    #----------------------------------------------------------------------------------
    # get lib_name #
    if {$params(module_name) eq "altera_syncram"} {
        set lib_name "altera_lnsim"
    } else {
        set lib_name "altera_mf"
    }

    #----------------------------------------------------------------------------------
    set tri_port_list [list ]
    set port_map_list [list ]
	set port_map_input_list [list ]
	set port_map_output_list [list ]
    set params_list   [list ]
    set ports_not_added_list [list]

    #-----------------------------------------------------------------------------------
    foreach port $params(port_list) {
        set port_map($port) 1
    }
    # tri_port_list #
    if {$params(module_name) eq "altdpram"} {
        set range_list {"aclr" 0 "sclr" 0 "byteena_a" 1  "enable" 1 "in_aclr" 0  "inclocken" 1 "out_aclr" 0 "outclocken" 1  "rd_aclr" 0 "rdaddressstall" 0  "rdclocken" 1 "rden" 1 "rdinclocken" 1 "rdoutclocken" 1 "wraddressstall" 0 "wrclocken" 1 "wren" 0 }
    } else {
        set range_list {"aclr" 0 "sclr" 0  "aclr_a" 0 "aclr_b" 0 "sclr_a" 0 "sclr_b" 0 "addressstall_a" 0 "addressstall_b" 0 "byteena_a" 1 "byteena_b" 1 "clock" 1 "clock_a" 1  "enable" 1 "enable_a" 1 "enable_b" 1  "in_aclr" 0 "inclock" 1 "inclocken" 1 "out_aclr" 0 "outclocken" 1  "rd_aclr" 0 "rd_addressstall" 0  "rdclocken" 1 "rden" 1 "rden_a" 1 "rden_b" 1 "rdinclocken" 1 "rdoutclocken" 1 "wr_addressstall" 0 "wrclock" 1 "wrclocken" 1 "wren" 0 "wren_a" 0 "wren_b" 0}
    }
    foreach {port num } $range_list {
        if {[info exists port_map($port)]} {
            lappend tri_port_list $num $port -1
        }
    }

    #-----------------------------------------------------------------------------------
    # MODULE_NAME== altdpram #
    if {$params(module_name) eq "altdpram"} {
        # port_map_list #
        set altdpram_ports_list {
            aclr    0
            byteena 1
            data    -1
            inclock 1
            inclocken   1
            outclock    1
            outclocken  1
            rdaddress   -1
            rdaddressstall  0
            rden    1
            wraddress   -1
            wraddressstall  0
            wren    -1
            q   -1
        }

        foreach {port num} $altdpram_ports_list {
            switch -exact -- $port {
                    "inclock"   {
                        if {[info exists port_map(clock)]} {
                            lappend port_map_list "clock" $port
			    lappend port_map_input_list "clock" $port
                        } elseif {[info exists port_map(inclock)]} {
                            lappend port_map_list "inclock" $port
			    lappend port_map_input_list "inclock" $port
							
                        } elseif {[info exists port_map(wrclock)]} {
                            lappend port_map_list "wrclock" $port
			    lappend port_map_input_list "wrclock" $port
                        } 
                    }
                    "inclocken" {
                        if {[info exists port_map(enable)]} {
                            lappend port_map_list "enable" $port
			    lappend port_map_input_list "enable" $port
                        } elseif {[info exists port_map(inclocken)]} {
                            lappend port_map_list "inclocken" $port
			    lappend port_map_input_list "inclocken" $port
                        } elseif {[info exists port_map(wrclocken)]} {
                            lappend port_map_list "wrclocken" $port
			    lappend port_map_input_list "wrclocken" $port
                        } 
                    }
                    "outclock" {
                        if {[info exists port_map(clock)]} {
                            lappend port_map_list "clock" $port
			    lappend port_map_input_list "clock" $port
                        } elseif {[info exists port_map(outclock)]} {
                            lappend port_map_list "outclock" $port
			    lappend port_map_input_list "outclock" $port
                        } elseif {[info exists port_map(rdclock)]} {
                            lappend port_map_list "rdclock" $port
			    lappend port_map_input_list "rdclock" $port
                        } 
                    }
                    "outclocken" {
                        if {[info exists port_map(enable)]} {
                            lappend port_map_list "enable" $port
			    lappend port_map_input_list "enable" $port
                        } elseif {[info exists port_map(outclocken)]} {
                            lappend port_map_list "outclocken" $port
			    lappend port_map_input_list "outclocken" $port
                        } elseif {[info exists port_map(rdclocken)]} {
                            lappend port_map_list "rdclocken" $port
			    lappend port_map_input_list "rdclocken" $port
                        } 
                    }
                    "q" {
                        lappend port_map_list "q" $port
						lappend port_map_output_list "q" $port
                    }
                    default {
                        if {[info exists port_map($port)]} {
                            lappend port_map_list $port $port
                        } 
						#else {
                         #   lappend ports_not_added_list $port "1'b$num"
                        #}
                    }
            }
        }
        # params_list #
        lappend params_list "indata_aclr"       ;# indata_aclr
        if {$params(aclr_write_input_dataa)} {
            lappend params_list "\"ON\""
        } else {
            lappend params_list "\"OFF\""
        }
        lappend params_list "indata_reg"        ;# indata_reg
        if {$params(write_input_dataa)} {
            lappend params_list "\"INCLOCK\""
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
        lappend params_list "intended_device_family" "\"$params(device_family)\""   ;#intended_device_family
        lappend params_list "lpm_type" "\"$params(module_name)\""   ;# lpm_type
		if {$params(blank_memory)} {
			set mif $params(mif_filename)
			regsub -all {\\} $mif / newpath
            lappend params_list "lpm_file" "\"$newpath\""
        }
        lappend params_list "outdata_aclr"      ;# outdata_aclr
        if {$params(aclr_read_output_qa)} {
            lappend params_list "\"ON\""
        } else {
            lappend params_list "\"OFF\""
        }
        lappend params_list "outdata_reg"       ;# outdata_reg
        if {$params(read_output_qa)} {
            lappend params_list "\"OUTCLOCK\""
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
        lappend params_list "rdaddress_aclr"    ;# rdaddress_aclr
        if {$params(aclr_read_input_rdaddress)} {
            lappend params_list "\"ON\""
        } else {
            lappend params_list "\"OFF\""
        }
        lappend params_list "rdaddress_reg"     ;# rdaddress_reg
        if {$params(read_input_rdaddress)} {
            if {$params(clock_type)==1} {
                lappend params_list "\"OUTCLOCK\""
            } else {
                lappend params_list "\"INCLOCK\""
            }
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
        lappend params_list "rdcontrol_aclr"    ;# rdcontrol_aclr
        if {$params(aclr_read_input_rden)} {
            lappend params_list "\"ON\""
        } else {
            lappend params_list "\"OFF\""
        }
        lappend params_list "rdcontrol_reg"     ;# rdcontrol_reg
        if {$params(read_input_rden)} {
            if {$params(clock_type)==1} {
                lappend params_list "\"OUTCLOCK\""
            } else {
                lappend params_list "\"INCLOCK\""
            }
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
        if {$params(ram_block_type) eq "LCs"} {
             lappend params_list "use_eab"  "\"OFF\""    ;# use_eab
        }
        lappend params_list "width" "$params(data_width)"   ;#width
        lappend params_list "widthad" "$params(wraddress_width)"    ;# widthad
        if {($params(device_family) ne "MAX II")&&($params(device_family) ne "MAX V")} {
            lappend params_list "width_byteena" 1   ;# width_byteena
        }
        lappend params_list "wraddress_aclr"  "\"OFF\""    ;# wraddress_aclr
        lappend params_list "wraddress_reg" "\"UNREGISTERED\""    ;# wraddress_reg
        lappend params_list "wrcontrol_aclr"    ;# wrcontrol_aclr
        if {$params(aclr_write_input_wrena)} {
            lappend params_list "\"ON\""
        } else {
            lappend params_list "\"OFF\""
        }
        lappend params_list "wrcontrol_reg"     ;# wrcontrol_reg
        if {$params(write_input_wrena)} {
            lappend params_list "\"INCLOCK\""
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
    #--------------------------------------------------------------------------------------        
    # ip_name = altsyncram or altera_syncram #
    } else {
        # port_map_list #
        set ports_list_all_in   {"aclr1" "sclr" "address_a" "address2_a" "byteena_a" "clock0" "clocken0" "data_a" "rden_a" "wren_a" "aclr0" "address_b" "address2_b" "addressstall_a" "addressstall_b" "byteena_b" "clock1" "clocken1" "clocken2" "clocken3" "data_b" "rden_b" "wren_b" "eccencbypass" "eccencparity"}
        set ports_list_all_out  {"q_b" "q_a" "eccstatus"}
        set ports_list_all_in   [lsort -ascii $ports_list_all_in]
        set ports_list_all_out  [lsort -ascii $ports_list_all_out]
        set ports_list_all      [concat  $ports_list_all_in   $ports_list_all_out]
        foreach port $ports_list_all {
            switch -exact -- $port  {
                "clock0"  {
                        set port_exist  0
                        foreach port_alt {clock clock_a wrclock inclock} {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                }
                "clock1" {
                        set port_exist  0
                        #if {$params(mode)==1} {
                            set port_alt_all    {clock_b outclock}
                        #} else {
                         #   set port_alt_all    {rdclock outclock}
                       # }
                        foreach port_alt $port_alt_all {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                }
                "aclr0" {
                        set port_exist  0
                        foreach port_alt {aclr in_aclr aclr_a} {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                }
                "aclr1" {
                        set port_exist  0
                       # if {$params(mode)==0} {
                       #     set port_alt_all    {rd_aclr  out_aclr}
                       # } else {
                            set port_alt_all    {out_aclr aclr_b}
                        #}
                        foreach port_alt $port_alt_all  {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                }
		"sclr" {
                        set port_exist  0
			foreach port_alt {sclr} {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                }
                "clocken0" {
                        set port_exist  0
                        foreach port_alt {enable enable_a wrclocken inclocken} {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                }
                "clocken1" {
                        set port_exist  0
                        #if {$params(mode)==1} {
                            set port_alt_all    {enable_b outclocken}
                       # } else {
                        #    set port_alt_all    {rdclocken rdoutclocken outclocken}
                       # }
                        foreach port_alt $port_alt_all {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                }
                "clocken3" {
                        if {[info exists port_map(rdinclocken)]} {
                            lappend port_map_list   $port   rdinclocken
			    lappend port_map_input_list   $port   rdinclocken
                        } 
                }
                "clocken2"  {
                       # lappend ports_not_added_list $port "1'b1"
                }

                "data_a"  {
                        foreach port_alt {data data_a} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list $port_alt $port
				lappend port_map_input_list $port_alt $port
                            }
                        }
                }
                "data_b"    {
                        if {[info exists port_map(data_b)]} {    
                            lappend port_map_list $port "data_b"
			    lappend port_map_input_list $port "data_b"
                        } 
                }
                "address_a" {
                        foreach port_alt {address_a wraddress} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list $port_alt $port
				lappend port_map_input_list $port_alt $port
                            }
                        }
                }
                "address_b" {
                        foreach port_alt {address_b rdaddress} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list $port_alt $port
				lappend port_map_input_list $port_alt $port
                            }
                        }
                }						
                "wren_a" -
                "wren_b" {
                        if {[info exists port_map(wren_b)]} {    
                            lappend port_map_list $port wren_b
			    lappend port_map_input_list $port wren_b
                        }
                }
                "rden_b" {
                        set port_exit   0
                        foreach port_alt {rden rden_b} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list $port_alt $port
				lappend port_map_input_list $port_alt $port
                                set port_exit 1
                            }
                        }
                }
		"q"	{
			if {[info exists port_map($port)]} {
                            lappend port_map_list   $port "q_b"
			    lappend port_map_output_list   $port "q_b"
                        }
		}
                "q_a"   {
                        if {[info exists port_map($port)]} {
                            lappend port_map_list   $port "q_a"
			    lappend port_map_output_list   $port "q_a"
                        }
                 		#else {
                         #   lappend ports_not_added_list $port ""
                        #}
                }
                "q_b"   {
                        if {[info exists port_map(q_b)]} {
                            lappend port_map_list   $port "q_b"
			    lappend port_map_output_list   $port "q_b"
                        } 
                }
                "rden_a"    -
                "byteena_b" -
                "byteena_a" {
                        if {[info exists port_map($port)]}  {
                            lappend port_map_list $port $port
			    lappend port_map_input_list $port $port
                        } 
                }
		"wr_addressstall" {
			if {[info exists port_map($port)]} {
			    lappend port_map_list	$port "addressstall_a"
			    lappend port_map_input_list	$port "addressstall_a"
			}
		}
		"rd_addressstall" {
			if {[info exists port_map($port)]} {
			    lappend port_map_list	$port "addressstall_b"
			    lappend port_map_input_list	$port "addressstall_b"
			}
		}
                "addressstall_a" {
                        if {[info exists port_map(addressstall_a)]} {
                            lappend port_map_list $port $port
			    lappend port_map_input_list $port $port
                        } 
                }
                "addressstall_b" {
                        if {[info exists port_map(addressstall_b)]} {
                            lappend port_map_list $port $port
			    lappend port_map_input_list $port $port
                        }
                }
                "eccstatus" {
                        if {[info exists port_map($port)]} {
			    lappend port_map_list $port	"eccstatus"
			    lappend port_map_output_list $port	"eccstatus"
			} 
		#else {
                         #   lappend ports_not_added_list $port ""
                        #}
                }
            }
        }
      #  array  set  ports_not_added_arr     [list ]
      #  set ports_not_added_port    [list ]
      #  set ports_not_added_new   [list ]
      #  foreach {port value} $ports_not_added_list {
      #      set ports_not_added_arr($port)  $value
      #      lappend ports_not_added_port    $port
      #  }
       # set ports_not_added_port    [lsort  -ascii $ports_not_added_port]
       # foreach port  $ports_not_added_port {
           #lappend  ports_not_added_new  $port   $ports_not_added_arr($port)  
      #  }
       # set ports_not_added_list    $ports_not_added_new
      #  array unset ports_not_added_arr
        # params_list #
        lappend params_list "address_reg_b"     ;# address_reg_b
        if {$params(clock_type)==4} {
            lappend params_list "\"CLOCK1\""
        } else {
            lappend params_list "\"CLOCK0\""
        }
        foreach {param param_out} {clken_input_reg_a clock_enable_input_a clken_input_reg_b clock_enable_input_b clken_output_reg_a clock_enable_output_a clken_output_reg_b clock_enable_output_b} { ;#clock_enable_input_a, clock_enable_input_b, clock_enable_output_a, clock_enable_output_b,
            if {$params($param)} {
                lappend params_list $param_out "\"NORMAL\""
            } else {
                lappend params_list $param_out "\"BYPASS\""
            }
        }
        lappend params_list "indata_reg_b"  ;# indata_reg_b
        if {$params(clock_type)==4} {
            lappend params_list "\"CLOCK1\""
        } else {
            lappend params_list "\"CLOCK0\""
        }
        if {$params(blank_memory)} {                ;#init_file
			set mif $params(mif_filename)
			regsub -all {\\} $mif / newpath
            lappend params_list "init_file"  "\"$newpath\""
            if {$params(var_width)} {
                lappend params_list "init_file_layout"  "\"$params(file_layout)\""
            }
        }
        lappend params_list "intended_device_family" "\"$params(device_family)\""   ;#intended_device_family
   
        lappend params_list "lpm_type" "\"$params(module_name)\"" ;# lpm_type
        if {$params(max_depth) ne "Auto"} {                            ;# maximum_depth
            lappend params_list "maximum_depth" $params(max_depth)
        }

        lappend params_list "numwords_a"   $params(numwords_a)       ;# numwords_a
        lappend params_list "numwords_b"   $params(numwords_b)       ;# numwords_b
        lappend params_list "operation_mode"  "\"BIDIR_DUAL_PORT\""  ;# opeartion_mode
        lappend params_list "outdata_aclr_a"    ;# outdata_aclr_a
        if {$params(aclr_read_output_qa)} {
            if {$params(clock_type)==2} {
                lappend params_list "\"CLEAR1\""
            } else {
                lappend params_list "\"CLEAR0\""
            }
        } else {
            lappend params_list "\"NONE\""
        }
        lappend params_list "outdata_aclr_b"    ;# outdata_aclr_b
        if {$params(aclr_read_output_qb)} {
            if {$params(clock_type)==0} {
                lappend params_list "\"CLEAR0\""
            } else {
                lappend params_list "\"CLEAR1\""
            }
        } else {
            lappend params_list "\"NONE\""
        }
		lappend params_list "outdata_sclr_a"    ;# outdata_sclr_a
        if {$params(sclr_read_output_qa)} {
            lappend params_list "\"SCLEAR\""
        } else {
            lappend params_list "\"NONE\""
        }
        lappend params_list "outdata_sclr_b"    ;# outdata_sclr_b
        if {$params(sclr_read_output_qb)} {
            lappend params_list "\"SCLEAR\""
        } else {
            lappend params_list "\"NONE\""
        }
        lappend params_list "outdata_reg_a"     ;#outdata_reg_a
        if {$params(read_output_qa)} {
            if {$params(clock_type)==2} {
                lappend params_list "\"CLOCK1\""
            } else {
                lappend params_list "\"CLOCK0\""
            }
        } else {
            lappend params_list  "\"UNREGISTERED\""
        }
        lappend params_list "outdata_reg_b"     ;#outdata_reg_b
        if {$params(read_output_qb)} {
            if {$params(clock_type)==0} {
                lappend params_list "\"CLOCK0\""
            } else {
                lappend params_list "\"CLOCK1\""
            }
        } else {
            lappend params_list  "\"UNREGISTERED\""
        }
	if {$params(force_to_zero)} {
		lappend params_list "enable_force_to_zero"  "\"TRUE\""
	}
        if {$params(ram_block_type) ne "LCs"} {     ;# power_up_uninitialized
           lappend params_list "power_up_uninitialized" "\"FALSE\""
        }
        if {($params(ram_block_type) ne "LCs") &&($params(ram_block_type) ne "Auto")} { ;# ram_block_type
            lappend params_list "ram_block_type"  "\"$params(ram_block_type)\""
        }
        lappend params_list "widthad_a" $params(addressa_width)    ;# widthad_a
        lappend params_list "widthad_b" $params(addressb_width)    ;# widthad_b 
        lappend params_list "width_a"   $params(qa_width)         ;# width_a
        lappend params_list "width_b"   $params(qb_width)            ;# width_b
        lappend params_list "width_byteena_a" 1                      ;# width_byteena_a
        lappend params_list "width_byteena_b" 1                      ;# width_byteena_b
        if {$params(module_name) ne "altera_syncram"} {
            lappend params_list "wrcontrol_wraddress_reg_b"         ;# wrcontrol_wraddress_reg_b
            if {$params(clock_type)==4} {
                lappend params_list "\"CLOCK1\""
            } else {
                lappend params_list "\"CLOCK0\""
            }
        }
        
    }

    #---------------------------------------------------------------------------------------
    # add all terp params to array params_terp #
    set params_terp_tb(module_port_list)   $module_port_list
    set params_terp_tb(module_input_port_list)   $module_input_port_list
    set params_terp_tb(module_input_port_only_list)   $module_input_port_only_list
    set params_terp_tb(module_output_port_only_list)   $module_output_port_only_list
    set params_terp_tb(sub_wire_list)      $sub_wire_list
    set params_terp_tb(wire_list)          $wire_list
    set params_terp_tb(port_map_list)      $port_map_list
    set params_terp_tb(port_map_input_list)      $port_map_input_list
    set params_terp_tb(port_map_output_list)     $port_map_output_list
    set params_terp_tb(ports_not_added_list) $ports_not_added_list
    set params_terp_tb(tri_port_list)      $tri_port_list
    set params_terp_tb(params_list)        $params_list
    set params_terp_tb(ip_name)            $params(module_name)
    set params_terp_tb(lib_name)           $lib_name
    return [array get params_terp_tb]
}


