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
    # loop through port_list and add to list module_port_list #
    set module_port_list [list ]
	set module_input_port_list [list ]
	set module_input_port_only_list [list ]
	set module_output_port_only_list [list ]
    set data_width [expr {$params(width_a)-1}]
    set address_width [expr {$params(widthad_a) -1 }]
    set byte_width [expr {$params(byte_width) -1 }]
    set ports_0  {"aclr" "sclr" "addressstall_a"}
    if {$params(module_name) eq "LPM_RAM_DQ"} {
        set ports_1  {"clken" "clock" "inclocken" "outclocken" "rden" "we"}
    } else {
        set ports_1  {"clken" "clock" "inclock" "inclocken" "outclocken" "rden" "we"}
    }
    foreach port $params(port_list) {
        if {$port eq "data"} {
            lappend module_port_list "data_a" "IN" $data_width -1
			lappend module_input_port_list "data_a" "IN" $data_width -1
			lappend module_input_port_only_list "data_a"
        } 
		if {$port eq "address"} {
            lappend module_port_list "address_a" "IN" $address_width -1
			lappend module_input_port_list "address_a" "IN" $address_width -1
			lappend module_input_port_only_list "address_a"
        } 
		if {$port eq "byteena"} {
            lappend module_port_list "byteena_a" "IN" $byte_width 2
			lappend module_input_port_list "byteena_a" "IN" $byte_width 2
			lappend module_input_port_only_list "byteena_a"
         }
		#elseif {[lsearch $ports_0 $port]>=0} {
         #   lappend module_port_list $port "IN" -1 0
        #} elseif {[lsearch $ports_1 $port]>=0} {
           # lappend module_port_list $port "IN" -1 1
        #} elseif {$port ne "q"} {
          #  lappend module_port_list "q_a" "IN" -1 -1
		  #}
		if {$port eq "clock"} {
			lappend module_port_list "clock0" "IN" -1 -1
			lappend module_input_port_list "clock0" "IN" -1 -1
			lappend module_input_port_only_list "clock0"
		} 
		if {$port eq "clken"} {
			lappend module_port_list "clocken0" "IN" -1 -1
			lappend module_input_port_list "clocken0" "IN" -1 -1
			lappend module_input_port_only_list "clocken0"
		} 
		if {$port eq "wren"} {
			lappend module_port_list "wren_a" "IN" -1 -1
			lappend module_input_port_list "wren_a" "IN" -1 -1
			lappend module_input_port_only_list "wren_a"
		} 
		if {$port eq "addressstall_a"} {
			lappend module_port_list "addressstall_a" "IN" -1 -1
			lappend module_input_port_list "addressstall_a" "IN" -1 -1
			lappend module_input_port_only_list "addressstall_a" 
		} 
		if {$port eq "inclock"} {
			lappend module_port_list "clock0" "IN" -1 -1
			lappend module_input_port_list "clock0" "IN" -1 -1
			lappend module_input_port_only_list "clock0"
		} 
		if {$port eq "outclock"} {
			lappend module_port_list "clock1" "IN" -1 -1
			lappend module_input_port_list "clock1" "IN" -1 -1
			lappend module_input_port_only_list "clock1" 
		} 
		if {$port eq "inclocken"} {
			lappend module_port_list "clocken0" "IN" -1 -1
			lappend module_input_port_list "clocken0" "IN" -1 -1
			lappend module_input_port_only_list "clocken0" 
		} 
		if {$port eq "outclocken"} {
			lappend module_port_list "clocken1" "IN" -1 -1
			lappend module_input_port_list "clocken1" "IN" -1 -1
			lappend module_input_port_only_list "clocken1"
		} 
		if {$port eq "rden"} {
			lappend module_port_list "rden_a" "IN" -1 -1
			lappend module_input_port_list "rden_a" "IN" -1 -1
			lappend module_input_port_only_list "rden_a" 
		}
		if {$port eq "q"} {
			lappend module_port_list "q_a" "OUT" $data_width -1
			lappend module_output_port_only_list "q_a" 
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
			lappend module_port_list "aclr0" "IN" -1 1
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
			lappend module_input_port_only_list "sclr" 
		}
    }
  #  lappend module_port_list "q" "OUT" $data_width -1
	#lappend module_output_port_only_list "q"

    #----------------------------------------------------------------------------------
    # add all output wire connectin to wire_list and sub_wire_list #
    set wire_list [list ]
    set sub_wire_list [list ]
    lappend sub_wire_list  "sub_wire0" $data_width
    lappend wire_list   "q" "sub_wire0" $data_width 0

    #----------------------------------------------------------------------------------
    # get lib_name #
    if {$params(module_name) eq "LPM_RAM_DQ"} {
        set lib_name "lpm"
    } elseif {$params(module_name) eq "altera_syncram"} {
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
    # MODULE_NAME== LPM_RAM_DQ #
    if {$lib_name eq "lpm"} {
        # tri_port_list #
        lappend tri_port_list  1 "we" -1
        # port_map_list #
        foreach port $params(port_list) {
            if {$port ne "q"} {
                lappend port_map_list $port $port
            }
        }
        lappend port_map_list "q" "sub_wire0"
        if {[lsearch $params(port_list) "inclock"] <0} {
            lappend ports_not_added_list "inclock" "1'b1"
        }
        if {[lsearch $params(port_list) "outclock"] <0} {
            lappend ports_not_added_list "outclock" "1'b1"
        }
        # params_list #
        lappend params_list "intended_device_family" "\"$params(device_family)\""
        lappend params_list "lpm_address_control" 
        if {$params(regaddr)} {
            lappend params_list "\"REGISTERED\""
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
        if {$params(blankmemory)} {
            lappend params_list "lpm_file" "\"$params(miffilename)\""
        }
        lappend params_list "lpm_indata"
        if {$params(regdata)} {
            lappend params_list "\"REGISTERED\""
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
        lappend params_list "lpm_outdata"
        if {$params(regoutput)} {
            lappend params_list "\"REGISTERED\""
        } else {
            lappend params_list "\"UNREGISTERED\""
        }
        lappend params_list "lpm_type" "\"$params(module_name)\""
        lappend params_list "lpm_width" "$params(width_a)"
        lappend params_list "lpm_widthad" "$params(widthad_a)"
        if {$params(ram_block_type) eq "LCs"} {
            lappend params_list "use_eab" "\"OFF\""
        }
    #-----------------------------------------------------------------------------------------    
    # ip_name = altsyncram or altera_syncram #
    } else {
        # tri_port_list #
        set range_list_0 {"aclr" "sclr" "addressstall_a"}
        set range_list_1 {"clken" "clock" "rden" "inclock" "outclocken" "inclocken"}
        foreach port $params(port_list) {
            if {[lsearch $range_list_0 $port]>=0} {
                lappend tri_port_list 0 $port -1
            } elseif {[lsearch $range_list_1 $port]>=0} {
                lappend tri_port_list 1 $port -1
            } elseif {$port eq "byteena"} {
                lappend tri_port_list 1 $port $byte_width
            }
        }
        # port_map_list #
        foreach port $params(port_list) {
            set used_port_set($port)  1
        }
        set ports_list_all {"aclr1" "sclr" "address_a" "address2_a" "byteena_a" "clock0" "clocken0" "data_a" "rden_a" "wren_a" "aclr0" "address_b" "address2_b" "addressstall_a" "addressstall_b" "byteena_b" "clock1" "clocken1" "clocken2" "clocken3" "data_b" "eccstatus" "q_b" "rden_b" "wren_b" "eccencbypass" "eccencparity"}
        set ports_list_all [lsort -ascii $ports_list_all]
        set range_list_0  {"addressstall_b" "wren_b"}
        set range_list_1  {"address_b" "byteena_b" "clocken2" "clocken3" "data_b" "rden_b"}
        set dualclock  $params(singleclock)
        foreach port $ports_list_all {
            if {$port eq "clocken0"} {
                if {$dualclock} {
                    if {[info exists used_port_set(inclocken)]}  {
                        lappend port_map_list "inclocken" $port
			lappend port_map_input_list "inclocken" $port

                    } 
					#else {
                     #   lappend ports_not_added_list $port "1'b1"
                    #}
                } else {
                    if {[info exists used_port_set(clken)]}  {
                        lappend port_map_list "clken" $port 
			lappend port_map_input_list "clken" $port 
                    } 
					#else {
                     #   lappend ports_not_added_list $port "1'b1"
                    #}
                }
            } elseif {$port eq "clock0"}  {
                if {$dualclock}  {
                   if {[info exists used_port_set(inclock)]} {
                        lappend port_map_list "inclock" $port
						lappend port_map_input_list "inclock" $port
                    } 
					#else {
                     #   lappend ports_not_added_list $port "1'b0"
                    #}
                } else {
                    lappend port_map_list "clock" $port
					lappend port_map_input_list "clock" $port
                }
            } elseif {$port eq "clock1"} {
                if {[info exists used_port_set(outclock)]}  {
                    lappend port_map_list "outclock" $port
					lappend port_map_input_list "outclock" $port
                } 
				#else {
                 #   lappend ports_not_added_list $port "1'b1"
                #}
            } elseif {$port eq "aclr0"} {
                if {[info exists used_port_set(aclr)]}  {
                    lappend port_map_list "aclr" $port
					lappend port_map_input_list "aclr" $port
                } 
				#else {
                 #   lappend ports_not_added_list  $port "1'b0"
                #}
            } elseif {$port eq "aclr1"} {
                if {[info exists used_port_set(outaclr)]}  {
                    lappend port_map_list "outaclr" $port
					lappend port_map_input_list "outaclr" $port
                } 
				# else {
                   # lappend ports_not_added_list $port "1'b0"
                #}
	    } elseif {$port eq "sclr"} {
                if {[info exists used_port_set(sclr)]}  {
                    lappend port_map_list "sclr" $port
					lappend port_map_input_list "sclr" $port
                } 
				#else {
                 #   lappend ports_not_added_list  $port "1'b0"
                #}
            } elseif {$port eq "clocken1"} {
                if {[info exists used_port_set(outclocken)]}  {
                    lappend port_map_list "outclocken" $port
					lappend port_map_input_list "outclocken" $port
                } 
				#else {
                 #   lappend ports_not_added_list $port "1'b1"
                #}
            } elseif {$port eq "data_a"}  {
                lappend port_map_list "data" $port
				lappend port_map_input_list "data" $port
            } elseif {$port eq "address_a"} {
                lappend port_map_list "address" $port
				lappend port_map_input_list "address" $port
            } elseif {$port eq "wren_a"} {
                lappend port_map_list "wren" $port
				lappend port_map_input_list "wren" $port
            } elseif {$port eq "rden_a"} {
                if {[info exists used_port_set(rden)]}  {
                    lappend port_map_list "rden" $port
					lappend port_map_input_list "rden" $port
                } 
				#else {
                 #   lappend ports_not_added_list $port "1'b1"
                #}
            } elseif {$port eq "byteena_a"} {
                if {[info exists used_port_set(byteena)]}  {
                    lappend port_map_list  "byteena" $port
					lappend port_map_input_list  "byteena" $port
                } 
				#else {
                 #   lappend ports_not_added_list $port "1'b1"
                #}
            } elseif {$port eq "addressstall_a"} {
                if {[info exists used_port_set($port)]}  {
                    lappend port_map_list $port $port
					lappend port_map_input_list $port $port
                } 
				#else {
                 #   lappend ports_not_added_list  $port "1'b0"
                #}
            } elseif {$port eq "address2_a"} {
	    	#lappend ports_not_added_list  $port "1'b1"  
	    } elseif {$port eq "address2_b"} {
	    	#lappend ports_not_added_list  $port "1'b1"
	    } elseif {$port eq "eccencbypass"} {
		#lappend ports_not_added_list  $port "1'b0"
	    } elseif {$port eq "eccencparity"} {
		#lappend ports_not_added_list  $port "8'b0"		
	    } elseif {[lsearch $range_list_0 $port] >=0} {
               # lappend ports_not_added_list $port "1'b0"
            } elseif {[lsearch $range_list_1 $port] >=0} {
               # lappend ports_not_added_list $port "1'b1"
            } else {
               # lappend ports_not_added_list $port " "
            }
        }
        lappend port_map_list "q" "q_a"
		lappend port_map_output_list "q" "q_a"
		
        # params_list #
        if {$params(byte_enable)} {
            lappend params_list  "byte_size" $params(byte_size)
        }
        foreach param  {clock_enable_input_a clock_enable_output_a} {
            if {$params($param)} {
                lappend params_list $param "\"NORMAL\""
            } else {
                lappend params_list $param "\"BYPASS\""
            }
        }
        if {$params(implement_in_les)} {
            lappend params_list "implement_in_les" "\"ON\""
        }
        if {$params(blankmemory)} {
	    set mif $params(miffilename)
	    regsub -all {\\} $mif / newpath
            lappend params_list "init_file" "\"$newpath\""
           # lappend params_list "init_file"  "\"$params(miffilename)\""
        }
        lappend params_list "intended_device_family" "\"$params(device_family)\""
        if {($params(ram_block_type) ne "MLAB") && ($params(ram_block_type) ne "LCs")} {
            if {$dualclock } {
                if {!$params(regoutput)} {
                    if {$params(jtag_enabled)} {
                        lappend params_list "lpm_hint" "\"ENABLE_RUNTIME_MOD=YES,INSTANCE_NAME=$params(jtag_id)\""
                    } else {
                        lappend params_list "lpm_hint" "\"ENABLE_RUNTIME_MOD=NO\""
                    }
                }
            } else {
                if {$params(jtag_enabled)} {
                    lappend params_list "lpm_hint" "\"ENABLE_RUNTIME_MOD=YES,INSTANCE_NAME=$params(jtag_id)\""
                } else {
                    lappend params_list "lpm_hint" "\"ENABLE_RUNTIME_MOD=NO\""
                }
            }
        }
        if {$params(implement_in_les)} {
            lappend params_list "lpm_type" "\"LPM_RAM_DQ\""
        } else {
            lappend params_list "lpm_type" "\"$params(module_name)\""
        }
        if {$params(maximum_depth)} {
            lappend params_list "maximum_depth" $params(maximum_depth)
        }
        lappend params_list "numwords_a" $params(numwords_a)
        lappend params_list "operation_mode" "\"SINGLE_PORT\""
        if {$params(singleclock)} {
            if {$params(aclroutput)} {
                lappend params_list "outdata_aclr_a" "\"CLEAR1\""
            } else {
                lappend params_list "outdata_aclr_a" "\"NONE\""
            }
			if {$params(sclroutput)} {
                lappend params_list "outdata_sclr_a" "\"SCLEAR\""
            } else {
                lappend params_list "outdata_sclr_a" "\"NONE\""
            }
			
            if {$params(regoutput)} {
                lappend params_list "outdata_reg_a" "\"CLOCK1\""
            } else {
                lappend params_list "outdata_reg_a" "\"UNREGISTERED\""
            }
        } else {
            if {$params(aclroutput)} {
                lappend params_list "outdata_aclr_a" "\"CLEAR0\""
            } else {
                lappend params_list "outdata_aclr_a" "\"NONE\""
            }
			if {$params(sclroutput)} {
                lappend params_list "outdata_sclr_a" "\"SCLEAR\""
            } else {
                lappend params_list "outdata_sclr_a" "\"NONE\""
            }
            if {$params(regoutput)} {
                lappend params_list "outdata_reg_a" "\"CLOCK0\""
            } else {
                lappend params_list "outdata_reg_a" "\"UNREGISTERED\""
            }
        }
	if {$params(force_to_zero)} {
	    lappend params_list "enable_force_to_zero" "\"TRUE\""
	} else {
	    lappend params_list "enable_force_to_zero" "\"FALSE\""
	}
        if {$params(ram_block_type) ne "LCs"} {
            if {$params(init_to_sim_x)} {
                lappend params_list "power_up_uninitialized" "\"TRUE\""
            } else {
                lappend params_list "power_up_uninitialized" "\"FALSE\""
            }
        }
        if {$params(ram_block_type) ne "LCs"} {
            if {$params(ram_block_type) ne "Auto"} {
                lappend params_list "ram_block_type"  "\"$params(ram_block_type)\""
            }
            lappend params_list "read_during_write_mode_port_a"
            if {$params(read_during_write_mode_port_a)==1} {
                if {$params(x_mask)} {
                    lappend params_list "\"NEW_DATA_NO_NBE_READ\""
                } else {
                    lappend params_list "\"NEW_DATA_WITH_NBE_READ\""
                }
            } elseif {$params(read_during_write_mode_port_a)==0} {
                lappend params_list "\"DONT_CARE\""
            } else {
                lappend params_list "\"OLD_DATA\""
            }
        }
        lappend params_list "widthad_a" $params(widthad_a)
        lappend params_list "width_a"  $params(width_a)
        if {$params(byte_width) == 0} {
            lappend params_list "width_byteena_a" 1
        } else {
            lappend params_list "width_byteena_a" $params(byte_width)
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


