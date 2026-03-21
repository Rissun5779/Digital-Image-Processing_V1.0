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
    set data_width      [expr {$params(data_width)-1}]
    set q_width         [expr {$params(q_width)-1}]
    set wraddress_width [expr {$params(wraddress_width) -1 }]
    set rdaddress_width [expr {$params(rdaddress_width) -1 }]
    set byte_width      [expr {$params(byte_width) -1 }]
   # set eccstatus_width [expr {$params(width_eccstatus) -1}]
   # set eccencparity_width	[expr {$params(width_eccencparity) -1}]
    if {$params(module_name) eq "altdpram"} {
        foreach port $params(port_list) {
            lappend module_port_list  $port
            switch -exact -- $port {
                "data"      {
                    lappend module_port_list    "IN"    $data_width -1
                }
                "wraddress" {
                    lappend module_port_list    "IN"    $wraddress_width    -1
                }
                "rdaddress" {
                    lappend module_port_list    "IN"    $rdaddress_width    -1
                }
                "q"    {
                    lappend module_port_list    "OUT"   $q_width    -1
                }
                "outclock"  -
                "wrclock"   -
                "clock"     -
                "inclock"   -
                "rdclock"   {
                    lappend module_port_list    "IN"    -1  -1
                }
                "aclr"      -
                "rd_aclr"   -
                "in_aclr"   -
                "out_aclr"  -
		"sclr"      -
                "wren"      -
                "rdaddressstall"   -
                "wraddressstall"   {
                    lappend module_port_list    "IN"    -1  0
                }
                default     {
                    lappend module_port_list    "IN"    -1  1
                }
            }
        }
    } else {
        foreach port $params(port_list) {
            #lappend module_port_list $port 
            #switch -exact -- $port {
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
                if {$port eq "q_a"} {
                    	lappend module_port_list  "q_a"  "OUT"   $data_width -1
			lappend module_output_port_only_list  "q_a"
					
		}
                if {$port eq "write_address_a"} {
			lappend module_port_list "address_a" "IN" $wraddress_width -1 
			lappend module_input_port_list "address_a" "IN" $wraddress_width -1 
			lappend module_input_port_only_list "address_a" 
		}
		if {$port eq "read_address_a"} {
			lappend module_port_list "address2_a" "IN" $rdaddress_width -1 
			lappend module_input_port_list "address2_a" "IN" $rdaddress_width -1 
			lappend module_input_port_only_list "address2_a" 
		}
                if {$port eq "wraddress"} {
                   	lappend module_port_list  "address_a"  "IN"    $wraddress_width    -1
			lappend module_input_port_list  "address_a"  "IN"    $wraddress_width    -1
			lappend module_input_port_only_list  "address_a" 
                }
               if {$port eq "write_address_b"} {
			lappend module_port_list "address_b" "IN" $wraddress_width -1 
			lappend module_input_port_list "address_b" "IN" $wraddress_width -1 
			lappend module_input_port_only_list "address_b" 
		}
		if {$port eq "read_address_b"} {
			lappend module_port_list "address2_b" "IN" $rdaddress_width -1 
			lappend module_input_port_list "address2_b" "IN" $rdaddress_width -1 
			lappend module_input_port_only_list "address2_b" 
		}
                if {$port eq "rdaddress"} {
                    	lappend module_port_list  "address_b"  "IN"    $rdaddress_width    -1
			lappend module_input_port_list  "address_b"  "IN"    $rdaddress_width    -1
			lappend module_input_port_only_list  "address_b" 
                }
              	if {$port eq "q"} {
                    	lappend module_port_list  "q_b"  "OUT"   $q_width -1
			lappend module_output_port_only_list  "q_b" 	
					
                }
		if {$port eq "q_b"} {
                    	lappend module_port_list  "q_b"  "OUT"   $q_width -1
			lappend module_output_port_only_list  "q_b"					
                }               
               if {$port eq "data_b"} {
                    	lappend module_port_list   "data_b" "IN"  $data_width    -1
		 	lappend module_input_port_list   "data_b" "IN"  $data_width    -1
			lappend module_input_port_only_list   "data_b"
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
                if {$port eq "aclr"} {
			lappend module_port_list "aclr0" "IN" -1 1
			lappend module_input_port_list "aclr0" "IN" -1 1
			lappend module_input_port_only_list "aclr0" 
		}
		if {$port eq "rd_aclr"} {
			lappend module_port_list "aclr1" "IN" -1 1
			lappend module_input_port_list "aclr1" "IN" -1 1
			lappend module_input_port_only_list "aclr1" 
		}
		if {$port eq "inaclr"} {
			lappend module_port_list "aclr0" "IN" -1 1
			lappend module_input_port_list "aclr0" "IN" -1 1
			lappend module_input_port_only_list "aclr0"
		}
		if {$port eq "outaclr"} {
			lappend module_port_list "aclr1" "IN" -1 1
			lappend module_input_port_list "aclr1" "IN" -1 1
			lappend module_input_port_only_list "aclr1"
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
                    #lappend module_port_list    "IN"    -1  1
                #}
            #}
        }
    }
    #----------------------------------------------------------------------------------
    # add all output wire connectin to wire_list and sub_wire_list #
    set wire_list [list ]
    set sub_wire_list [list ]
    set wire_number 0
    foreach {port direction width num} $module_port_list {
        if {$direction eq "OUT"} {
            lappend sub_wire_list   "sub_wire$wire_number"  $width 
            lappend wire_list   $port "sub_wire$wire_number" $width 0
            incr wire_number
        }
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
        set range_list {"aclr" 0 "sclr" 0 "byteena_a" 1  "enable" 1 "in_aclr" 0  "inclocken" 1 "out_aclr" 0 "out_sclr" 0 "outclocken" 1  "rd_aclr" 0"rd_sclr" 0 "rdaddressstall" 0  "rdclocken" 1 "rden" 1 "rdinclocken" 1 "rdoutclocken" 1 "wraddressstall" 0 "wrclocken" 1 "wren" 0 }
    } else {
        set range_list {"aclr" 0 "aclr_a" 0 "aclr_b" 0 "sclr" 0 "addressstall_a" 0 "addressstall_b" 0 "byteena_a" 1 "byteena_b" 1 "clock" 1 "clock_a" 1  "enable" 1 "enable_a" 1 "enable_b" 1  "in_aclr" 0 "inclock" 1 "inclocken" 1 "out_aclr" 0  "outclocken" 1  "rd_aclr" 0 "rd_addressstall" 0  "rdclocken" 1 "rden" 1 "rden_a" 1 "rden_b" 1 "rdinclocken" 1 "rdoutclocken" 1 "wr_addressstall" 0 "wrclock" 1 "wrclocken" 1 "wren" 0 "wren_a" 0 "wren_b" 0}
    }
    foreach {port num } $range_list {
        if {[info exists port_map($port)]} {
            if {$port eq "byteena_a" || $port eq "byteena_b"} {
                lappend tri_port_list $num $port $byte_width
            } else {
                lappend tri_port_list $num $port -1
            }
        }
    }

    #-----------------------------------------------------------------------------------
    # MODULE_NAME== altdpram #
    if {$params(module_name) eq "altdpram"} {
        # port_map_list #
        set altdpram_ports_list {
            aclr    0
            sclr    0
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
						#else {
                         #   lappend ports_not_added_list $port "1'b$num"
                        #}
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
			#else {
                         #   lappend ports_not_added_list $port "1'b$num"
                        #}
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
			#else {
                         #   lappend ports_not_added_list $port "1'b$num"
                        #}
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
			#else {
                         #   lappend ports_not_added_list $port "1'b$num"
                        #}
           	}
              	"q" {
			if {[info exists port_map(q)]} {
				lappend port_map_list "q" $port
				lappend port_map_output_list "q" $port
			}
		}
		"wren" {
			if {[info exists port_map(wren)]} {
				lappend port_map_list "wren" $port
				lappend port_map_input_list "wren" $port
			}
		}
		"rden" {
			if {[info exists port_map(rden)]} {
				lappend port_map_list "rden" $port
				lappend port_map_input_list "rden" $port
			}
		}
		"wraddress" {
			if {[info exists port_map(wraddress)]} {
				lappend port_map_list "wraddress" $port
				lappend port_map_input_list "wraddress" $port
			}
		}
		"rdaddress" {
			if {[info exists port_map(rdaddress)]} {
				lappend port_map_list "rdaddress" $port
				lappend port_map_input_list "rdaddress" $port
			}
		}
		"data" {
			if {[info exists port_map(data)]} {
				lappend port_map_list "data" $port
				lappend port_map_input_list "data" $port
			}
		}
		"byteena" {
			if {[info exists port_map(byteena)]} {
				lappend port_map_list "byteena" $port
				lappend port_map_input_list "byteena" $port
			}
		}
		"aclr" {
			if {[info exists port_map(aclr)]} {
				lappend port_map_list "aclr" $port
				lappend port_map_input_list "aclr" $port
			}				
		}
		"sclr" {
			if {[info exists port_map(sclr)]} {
				lappend port_map_list "sclr" $port
				lappend port_map_input_list "sclr" $port
			}
		}
					
                    #default {
                       # if {[info exists port_map($port)]} {
                        #    lappend port_map_list $port $port
                        #} else {
                       #     lappend ports_not_added_list $port "1'b$num"
                       # }
                    #}
            }
        }
        # params_list #
        lappend params_list "indata_aclr"       ;# indata_aclr
        lappend params_list "\"OFF\""
        lappend params_list "indata_reg"        ;# indata_reg
        lappend params_list "\"INCLOCK\""
        lappend params_list "intended_device_family" "\"$params(device_family)\""   ;#intended_device_family
        lappend params_list "lpm_type" "\"$params(module_name)\""   ;# lpm_type
        lappend params_list "ram_block_type"  "\"$params(ram_block_type)\""
		
		if {$params(blank_memory)} {
			set mif $params(mif_filename)
			regsub -all {\\} $mif / newpath
            lappend params_list "lpm_file" "\"$newpath\""
        }
        lappend params_list "outdata_aclr"      ;# outdata_aclr
        if {$params(aclr_read_output_qb)} {
            lappend params_list "\"ON\""
        } else {
            lappend params_list "\"OFF\""
        }
	lappend params_list "outdata_sclr"      ;# outdata_sclr
        if {$params(sclr_read_output_qb)} {
            lappend params_list "\"ON\""
        } else {
            lappend params_list "\"OFF\""
        }
        lappend params_list "outdata_reg"       ;# outdata_reg
        if {$params(read_output_qb)} {
            lappend params_list "\"OUTCLOCK\""
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
        lappend params_list "rdaddress_aclr"    ;# rdaddress_aclr
        if {$params(aclr_read_input_rdad"clocken0" {
                        set port_exist  0
                        foreach port_alt {enable enable_a wrclocken inclocken} {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                        #if {$port_exist ==0} {
                            #lappend ports_not_added_list $port "1'b1"
                        #}
                }dress)} {
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
        lappend params_list "\"OFF\""
        lappend params_list "rdcontrol_reg"     ;# rdcontrol_reg
        if {$params(rden_single)} {
            if {$params(clock_type)==1} {
                lappend params_list "\"OUTCLOCK\""
            } else {
                lappend params_list "\"INCLOCK\""
            }
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
        if {($params(device_family) ne "MAX II")&&($params(device_family) ne "MAX V")} {
            if {$params(clock_type)!=1} {
                lappend params_list "read_during_write_mode_mixed_ports" ;#read_dring_write_mode_mixed_ports
                if {$params(q_port_mode)==0} {
                    lappend params_list "\"NEW_DATA\""
                } elseif {$params(q_port_mode)==1} {
                    lappend params_list "\"OLD_DATA\""
                } else {
                    lappend params_list "\"DONT_CARE\""
                }
            }
        }
        if {$params(ram_block_type) eq "LCs"} {
             lappend params_list "use_eab"  "\"OFF\""    ;# use_eab
        }
        lappend params_list "width" "$params(data_width)"   ;#width
        lappend params_list "widthad" "$params(wraddress_width)"    ;# widthad
        if {($params(device_family) ne "MAX II")&&($params(device_family) ne "MAX V")} {
            lappend params_list "width_byteena" 1   ;# width_byteena
        }
        lappend params_list "wraddress_aclr"    ;# wraddress_aclr
        lappend params_list "\"OFF\""
        lappend params_list "wraddress_reg"     ;# wraddress_reg
        lappend params_list "\"INCLOCK\""
        lappend params_list "wrcontrol_aclr"    ;# wrcontrol_aclr
        lappend params_list "\"OFF\""
        lappend params_list "wrcontrol_reg"     ;# wrcontrol_reg
        lappend params_list "\"INCLOCK\""
    #--------------------------------------------------------------------------------------        
    # ip_name = altsyncram or altera_syncram #
    } else {
        # port_map_list #
        set ports_list_all_in   {"aclr1" "sclr" "address_a" "address2_a" "address2_b" "byteena_a" "clock0" "clocken0" "data_a" "rden_a" "wren_a" "aclr0" "address_b" "addressstall_a" "addressstall_b" "byteena_b" "clock1" "clocken1" "clocken2" "clocken3" "data_b" "rden_b" "wren_b" "eccstatus" "eccencbypass" "eccencparity"}
        set ports_list_all_out  {"q_b" "q_a"}
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
                        #if {$port_exist ==0} {
                           # lappend ports_not_added_list $port "1'b0"
                        #}
                }
                "clock1" {
                        set port_exist  0
                        if {$params(mode)==1} {
                            set port_alt_all    {clock_b outclock}
                        } else {
                            set port_alt_all    {rdclock outclock}
                        }
                        foreach port_alt $port_alt_all {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                        #if {$port_exist ==0} {
                            #lappend ports_not_added_list $port "1'b1"
                        #}
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
                        #if {$port_exist ==0} {
                           # lappend ports_not_added_list $port "1'b0"
                       # }
                }
                "aclr1" {
                        set port_exist  0
                        if {$params(mode)==0} {
                            set port_alt_all    {rd_aclr  out_aclr}
                        } else {
                            set port_alt_all    {out_aclr aclr_b}
                        }
                        foreach port_alt $port_alt_all  {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                       # if {$port_exist ==0} {
                           # lappend ports_not_added_list $port "1'b0"
                       # }
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
                       # if {$port_exist ==0} {
                            #lappend ports_not_added_list $port "1'b0"
                       #}
                }
                 "clocken0" {
                        set port_exist  0
                        if {$params(mode)==1} {
                            set port_alt_all    {enable_a inclocken}
                        } else {
                            set port_alt_all    {wrclocken wroutclocken inclocken}
                        }
                        foreach port_alt $port_alt_all {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                       # if {$port_exist ==0} {
                            #lappend ports_not_added_list $port "1'b1"
                        #}
                }
                "clocken1" {
                        set port_exist  0
                        if {$params(mode)==1} {
                            set port_alt_all    {enable_b outclocken}
                        } else {
                            set port_alt_all    {rdclocken rdoutclocken outclocken}
                        }
                        foreach port_alt $port_alt_all {
                            if {[info exists port_map($port_alt)]} {
                                set port_exist 1
                                lappend port_map_list   $port_alt   $port
				lappend port_map_input_list   $port_alt   $port
                            }
                        }
                       # if {$port_exist ==0} {
                            #lappend ports_not_added_list $port "1'b1"
                        #}
                }
                "clocken3" {
                        if {[info exists port_map(rdinclocken)]} {
                            	lappend port_map_list   $port   rdinclocken
				lappend port_map_input_list   $port   rdinclocken
                        } 
			#else {
                         #   lappend ports_not_added_list $port "1'b1"
                        #}
                }
                "clocken2"  {
                        #lappend ports_not_added_list $port "1'b1"
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
			#else {
                          #  lappend ports_not_added_list $port "\{$params(q_width)\{1'b1\}\}"
                        #}
                }
                "address_a" {
                        foreach port_alt {write_address_a wraddress} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list $port_alt $port
				lappend port_map_input_list $port_alt $port
                            }
                        }
                }
		"address2_a" {
                        foreach port_alt {read_address_a} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list  $port_alt $port
				lappend port_map_input_list  $port_alt $port
                            }
                        }
                }
                "address_b" {
                        foreach port_alt {write_address_b rdaddress} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list $port_alt $port
				lappend port_map_input_list  $port_alt $port
                            }
                        }
                }
		"address2_b" {
                        foreach port_alt {read_address_b} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list $port_alt $port
				lappend port_map_input_list  $port_alt $port
                            }
                        }
                }
                "wren_a" {
                         foreach port_alt {wren wren_a} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list  $port_alt  $port
				lappend port_map_input_list $port_alt $port
                            }
                        }
                }
                "wren_b" {
                        if {[info exists port_map(wren_b)]} {    
                            	lappend port_map_list $port wren_b
				lappend port_map_input_list $port wren_b
                        } 
			#else {
                         #   lappend ports_not_added_list $port "1'b0"
                        #}
                }
                "rden_b" {
                        set port_exit   0
                        foreach port_alt {rden rden_b} {
                            if {[info exists port_map($port_alt)]} {    
                                lappend port_map_list  $port_alt $port
				lappend port_map_input_list $port_alt $port
                                set port_exit 1
                            }
                        }
                        #if {$port_exit ==0} {
                            #lappend ports_not_added_list $port "1'b1"
                        #}
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
                        if {[info exists port_map($port)]} {
                            	lappend port_map_list   $port "q_b"
				lappend port_map_output_list   $port "q_b"
                        } 
			#elseif {[info exists port_map(q)]} {
                          #  if {[info exists port_map(eccstatus)]} {
                           #     lappend port_map_list  $port  "sub_wire1"
                           # } else {
                            #    lappend port_map_list   $port "sub_wire0"
                            #}
                        #} 
			#else {
 			# lappend ports_not_added_list $port ""
			#}
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
                "rden_a"    -
                "byteena_b" -
                "byteena_a" {
                        if {[info exists port_map($port)]}  {
                            	lappend port_map_list $port $port
				lappend port_map_input_list $port $port
                        } 
			#else {
                         #   lappend ports_not_added_list $port "1'b1"
                        #}
                }
            }
        }
       # array  set  ports_not_added_arr     [list ]
       # set ports_not_added_port    [list ]
       # set ports_not_added_new   [list ]
       # foreach {port value} $ports_not_added_list {
         #   set ports_not_added_arr($port)  $value
        #    lappend ports_not_added_port    $port
       # }
       # set ports_not_added_port    [lsort  -ascii $ports_not_added_port]
       # foreach port  $ports_not_added_port {
        #    lappend  ports_not_added_new  $port   $ports_not_added_arr($port)  
       # }
       # set ports_not_added_list    $ports_not_added_new
       # array unset ports_not_added_arr
        # params_list #
        if {$params(mode)==0} {                 ;# address_aclr_b
            lappend params_list  "address_aclr_b"
            if {$params(aclr_read_input_rdaddress)} {
                if {$params(clock_type)==1} {
                    lappend params_list  "\"CLEAR1\""
                } else {
                    lappend params_list  "\"CLEAR0\""
                }
            } else {
                lappend params_list  "\"NONE\""
            }
        }
        lappend params_list "address_reg_b"     ;# address_reg_b
        if {$params(mode)==0} {
            if {$params(clock_type)==1} {
                lappend params_list "\"CLOCK1\""
            } else {
                lappend params_list "\"CLOCK0\""
            }
        } else {
            if {$params(clock_type)==4} {
                lappend params_list "\"CLOCK1\""
            } else {
                lappend params_list "\"CLOCK0\""
            }
        }
        if {$params(byte_enable_b)} {       ;# byteena_reg_b
            lappend params_list     "byteena_reg_b"
            if {$params(clock_type)==4} {
                lappend params_list "\"CLOCK1\""
            } else {
                lappend params_list "\"CLOCK0\""
            }
        }
        if {$params(byte_enable_a)||$params(byte_enable_b)} {   ;# byte_size
            lappend params_list  "byte_size" $params(byte_enable_width)
        }
        if {$params(mode)==0} {         ;# clock_enable_input_a,clock_enable_input_b, clock_enable_output_b
            foreach {param param_out}  {clken_write_input_reg clock_enable_input_a clken_read_input_reg clock_enable_input_b clken_read_output_reg clock_enable_output_b} {
                set value   [set params($param)]
                if {$value} {
                    if {($param eq "clken_read_input_reg")&& $params(different_clkens)} {
                        lappend params_list $param_out  "\"ALTERNATE\""
                    } else {    
                        lappend params_list $param_out "\"NORMAL\""
                    }
                } else {
                    lappend params_list $param_out "\"BYPASS\""
                }
            }
            
        } else {
           # foreach {param param_out} {clken_input_reg_a clock_enable_input_a clken_input_reg_b clock_enable_input_b clken_output_reg_a clock_enable_output_a clken_output_reg_b clock_enable_output_b} { ;#clock_enable_input_a, clock_enable_input_b, clock_enable_output_a, clock_enable_output_b,
               # if {$params($param)} {
               #     lappend params_list $param_out "\"NORMAL\""
               # } else {
                #    lappend params_list $param_out "\"BYPASS\""
               # }
            #}
			
			 foreach {param param_out} {clken_input_reg_a} { ;#clock_enable_input_a, clock_enable_input_b, clock_enable_output_a, clock_enable_output_b,
                if {$params($param)} {
                    lappend params_list "clock_enable_input_a"  "\"NORMAL\""
					lappend params_list "clock_enable_input_b"  "\"NORMAL\""
					lappend params_list "clock_enable_output_a" "\"NORMAL\""
					lappend params_list "clock_enable_output_b" "\"NORMAL\""
                } else {
                    lappend params_list "clock_enable_input_a"  "\"BYPASS\""
					lappend params_list "clock_enable_input_b"  "\"BYPASS\""
					lappend params_list "clock_enable_output_a" "\"BYPASS\""
					lappend params_list "clock_enable_output_b" "\"BYPASS\""
                }
            }
        }
     
        if {$params(mode)==1} {                        ;# indata_reg_b
            lappend params_list "indata_reg_b"
            if {$params(clock_type)==4} {
                lappend params_list "\"CLOCK1\""
            } else {
                lappend params_list "\"CLOCK0\""
            }
        }
        if {$params(blank_memory)} {                ;#init_file
			set mif $params(mif_filename)
			regsub -all {\\} $mif / newpath
             lappend params_list "init_file"   "\"$newpath\""
            if {$params(var_width)} {
                lappend params_list "init_file_layout"  "\"$params(init_file_layout)\""
            }
        }

	
        lappend params_list "intended_device_family" "\"$params(device_family)\""   ;#intended_device_family
   
        lappend params_list "lpm_type" "\"$params(module_name)\"" ;# lpm_type
        if {$params(max_depth) ne "Auto"} {                            ;# maximum_depth
            lappend params_list "maximum_depth" $params(max_depth)
        }

        lappend params_list "numwords_a"   $params(numwords_a)       ;# numwords_a
        lappend params_list "numwords_b"   $params(numwords_b)       ;# numwords_b
        lappend params_list "operation_mode"                ;# opeartion_mode
        if {$params(mode)==1}  {
            lappend params_list "\"QUAD_PORT\""
        } else {
            lappend params_list "\"DUAL_PORT\""
        }
        if {$params(mode)==1} {        ;# mode==1
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
	    lappend params_list "outdata_sclr_a"    ;# outdata_sclr_a
            if {$params(sclr_read_output_qa)} {
                    lappend params_list "\"SCLEAR\""
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
        } else {
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
			lappend params_list "outdata_sclr_b"    ;# outdata_sclr_b
            if {$params(sclr_read_output_qb)} {
                    lappend params_list "\"SCLEAR\""
            } else {
                lappend params_list "\"NONE\""
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
        }
        if {$params(ram_block_type) ne "LCs"} {     ;# power_up_uninitialized
            if {$params(init_sim_to_x)} {
                lappend params_list "power_up_uninitialized" "\"TRUE\""
            } else {
                lappend params_list "power_up_uninitialized" "\"FALSE\""
            }
        }
        if {($params(ram_block_type) ne "LCs") &&($params(ram_block_type) ne "Auto")} { ;# ram_block_type
            lappend params_list "ram_block_type"  "\"$params(ram_block_type)\""
        }
        if {$params(mode)==0} {                     ;# rdcontrol_reg_b
            if {$params(rden_single)} {
                lappend params_list  "rdcontrol_reg_b"
                if {$params(clock_type)==1} {
                    lappend params_list "\"CLOCK1\""
                } else {
                    lappend params_list "\"CLOCK0\""
                }
            }
        }
	if {$params(force_to_zero)} {
		lappend params_list "enable_force_to_zero" "\"TRUE\""
	} else {
		lappend params_list "enable_force_to_zero" "\"FALSE\""	
	}
        if {($params(clock_type)!=1) && ($params(clock_type)!=4)} { ;#read_during_write_mode_mixed_ports
            if {$params(ram_block_type) eq "MLAB"} {    ;# ram block type MLAB
                if {$params(clock_type)==0} {       ;#clock_type 0
                    lappend params_list "read_during_write_mode_mixed_ports"
                    if {$params(q_port_mode)==1} {
                        lappend params_list "\"OLD_DATA\""
                    } elseif {$params(q_port_mode)==3} {
                        lappend params_list "\"NEW_DATA\""
                    } elseif {$params(constrained_dont_care)} {
                        lappend params_list  "\"DONT_CARE\""   
                    } else {
                        lappend params_list  "\"CONSTRAINED_DONT_CARE\""
                    }
                }
            } elseif {$params(ram_block_type) eq "M20K"} {
                
            } else {
                lappend params_list "read_during_write_mode_mixed_ports"
                if {$params(q_port_mode)==1} {
                    lappend params_list "\"OLD_DATA\""
                } elseif {$params(q_port_mode)==3} {
                    lappend params_list "\"NEW_DATA\""
                } else {
                    lappend params_list  "\"DONT_CARE\""   
                }
            }
        }
        if {$params(mode) == 1} {
            lappend params_list "read_during_write_mode_port_a"     ;#read_during_write_mode_port_a
            if {$params(rdw_a_mode) eq "New Data"} {
                if {$params(nbe_a)} {
                    lappend params_list "\"NEW_DATA_NO_NBE_READ\""
                } else {
                    lappend params_list "\"NEW_DATA_WITH_NBE_READ\""
                }
            } else {
                lappend params_list "\"DONT_CARE\""
            }
            lappend params_list "read_during_write_mode_port_b"     ;#read_during_write_mode_port_b
            if {$params(rdw_b_mode) eq "New Data"} {
                if {$params(nbe_b)} {
                    lappend params_list "\"NEW_DATA_NO_NBE_READ\""
                } else {
                    lappend params_list "\"NEW_DATA_WITH_NBE_READ\""
                }
            } else {
                lappend params_list "\"DONT_CARE\""
            }
        }
        lappend params_list "widthad_a" $params(wraddress_width)    ;# widthad_a
        lappend params_list "widthad_b" $params(rdaddress_width)    ;# widthad_b 
	lappend params_list "widthad2_a" $params(wraddress_width)    ;# widthad2_a
        lappend params_list "widthad2_b" $params(rdaddress_width)    ;# widthad2_b 
        lappend params_list "width_a"   $params(data_width)         ;# width_a
        lappend params_list "width_b"   $params(q_width)            ;# width_b
        lappend params_list "width_byteena_a"                       ;# width_byteena_a
        if {$params(byte_enable_a)} {
            lappend params_list $params(byte_width)
        } else {
            lappend params_list 1
        }
        

        if {$params(mode)==1} {
            lappend params_list "width_byteena_b"                   ;# width_byteena_b
            if {$params(byte_enable_b)} {
                lappend params_list $params(byte_width)
            } else {
                lappend params_list 1
            }
            if {$params(module_name) ne "altera_syncram"} {
                lappend params_list "wrcontrol_wraddress_reg_b"         ;# wrcontrol_wraddress_reg_b
                if {$params(write_input_ports)} {
                    if {$params(clock_type)==4} {
                        lappend params_list "\"CLOCK1\""
                    } else {
                        lappend params_list "\"CLOCK0\""
                    }
                } else {
                    lappend params_list  "\"UNREGISTERED\""
                }
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


