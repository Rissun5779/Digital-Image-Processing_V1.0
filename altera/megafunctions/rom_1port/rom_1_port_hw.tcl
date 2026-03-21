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


package require -exact qsys 14.0
package require altera_terp

#+-------------------------------------------
#|
#|  Source Files
#|
#+-------------------------------------------
source "csv_ui_loader.tcl"
source "make_var_wrapper.tcl"

#+--------------------------------------------
#|
#|  Module Property
#|
#+--------------------------------------------
set_module_property     NAME                    "rom_1port"
set_module_property     AUTHOR                  "Altera Corporation"
set_module_property     VERSION                 18.1
set_module_property     DISPLAY_NAME            "ROM: 1-PORT Intel FPGA IP"
set_module_property     EDITABLE                false
set_module_property     ELABORATION_CALLBACK    elab
set_module_property     GROUP                   "Basic Functions/On Chip Memory"
add_documentation_link  "Data Sheet"            http://www.altera.com/literature/ug/ug_ram_rom.pdf

set supported_device_families_list  {"Arria 10" "Stratix 10"}
set_module_property     SUPPORTED_DEVICE_FAMILIES   $supported_device_families_list
set_module_property   	HIDE_FROM_QSYS true

#+--------------------------------------------
#|
#|  Load the ui from CSV files
#|
#+--------------------------------------------
load_parameters "parameters.csv"
load_layout     "layout.csv"


#+--------------------------------------------
#|
#|  Elaboration callback
#|
#+--------------------------------------------
proc  elab  {}  {

    ##device information#
    set device_family   [get_parameter_value   DEVICE_FAMILY]
    send_message    COMPONENT_INFO        "Targeting device family: $device_family."

    #add input and output interface#
    add_interface   rom_input   conduit     input
    add_interface   rom_output  conduit     output
    set_interface_assignment    rom_input    ui.blockdiagram.direction   input
    set_interface_assignment    rom_output    ui.blockdiagram.direction   output
    
    # port dimension only available for PORT_A #
    set_parameter_property  GUI_INIT_FILE_LAYOUT    ENABLED     FALSE
    send_message    component_info      "The initial content file can only conforms to PORT_A's dimensions for ROM:1-PORT."

    #get the number of words in memory and data width#
    set width_a         [get_parameter_value    GUI_WIDTH_A]
    set numwords_a      [get_parameter_value    GUI_NUMWORDS_A]
    if {$width_a<1} {
        set width_a 1
    }
    if {$numwords_a<1} {
        set widthad_a   1
    } elseif {$numwords_a==1} {
        set widthad_a   1
    } else {
        set widthad_a_temp  [expr  {log($numwords_a)/log(2)}]
        set widthad_a [expr  {int(ceil($widthad_a_temp))}]
    }
    set_parameter_value     GUI_WIDTHAD_A   $widthad_a
    #add interface ports#
    add_interface_port  rom_output  q       dataout output  $width_a
    add_interface_port  rom_input   address address input   $widthad_a

    #set maximum block depth range list#
    set auto_depth_range_4096  {"0:Auto" 32 64 128 256 512 1024 2048 4096}
    set auto_depth_range_8192  "$auto_depth_range_4096 8192"
    set auto_depth_range_131072 "$auto_depth_range_8192 16384 32768 65536 131072"
    set mlab_depth_range    {"0:Auto" 32 64}
    set nd_mlab_depth_range {"0:Auto" 32}
    set m9k_depth_range     {"0:Auto" 128 256 512 1024 2048 4096 8192}
    set m10k_depth_range    {"0:Auto" 128 256 512 1024 2048 4096}
    set m20k_depth_range    {"0:Auto" 128 256 512 1024 2048 4096}
    set nf_m20k_depth_range {"0:Auto" 512 1024 2048 4096 8192 16384}
    set nd_m20k_depth_range {"0:Auto" 512 1024 2048}
    set m144k_depth_range   {"0:Auto" 4096 8192 16384 32768 65536 131072}
    set depth_range_cyclone {"0:Auto" 128 256 512 1024 2048 4096 8192}

    # get parameter values#
    # tab 1 #
    set ram_block_type      [get_parameter_value    GUI_RAM_BLOCK_TYPE]
    set singleclock         [get_parameter_value    GUI_SingleClock]
    # tab 2 #
    set regaddr     [get_parameter_value    GUI_RegAddr]
    set regoutput   [get_parameter_value    GUI_RegOutput]
    set clken_in    [get_parameter_value    GUI_CLOCK_ENABLE_INPUT_A]
    set clken_out   [get_parameter_value    GUI_CLOCK_ENABLE_OUTPUT_A]
    set addressstall_a  [get_parameter_value    GUI_ADDRESSSTALL_A]
    set aclr_a      [get_parameter_value    GUI_AclrAddr]
    set aclr_q      [get_parameter_value    GUI_AclrOutput]
    set sclr_q      [get_parameter_value    GUI_SclrOutput]
    set rden        [get_parameter_value    GUI_rden]
    set force_to_zero [get_parameter_value    GUI_FORCE_TO_ZERO]
    # tab 3 #
    set blankmemory     [get_parameter_value    GUI_BlankMemory]
    set miffilename     [get_parameter_value    GUI_MIFfilename]
    set jtag_enabled    [get_parameter_value    GUI_JTAG_ENABLED]
    set jtag_id         [get_parameter_value    GUI_JTAG_ID]

    # Mem init: leave memory blank is unavailable #
    set file_exist  [file exists $miffilename]
    if {$blankmemory== 0} {
        send_message    error   "Option of \'leave it blank\' is unavailable for ROM:1-PORT."
    } else {
		if {$miffilename eq "" } {
            send_message    warning   "Initialization data file containing the initial memory content must be specified."
        } elseif {![string match "*.mif" $miffilename] && ![string match "*.hex" $miffilename]} {
            send_message    error   "The file for initializing is not a MIF or HEX file. Please choose another one."
        }
    }
    set_parameter_property  GUI_INIT_TO_SIM_X   ENABLED FALSE
    # module name #
    if {[check_device_family_equivalence $device_family {"Arria 10" "Stratix 10"}]} {
        set_parameter_value     GUI_MODULE_NAME     "altera_syncram"
    } else {
        set_parameter_value     GUI_MODULE_NAME     "altsyncram"
    }

    #memory block type available for each device familiy#
    set pre_28nm_device_family_list  {"Arria II GX" "Arria II GZ" "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "Stratix III" "Stratix IV" "MAX 10 FPGA"}
    #for device families "Arria II GX" "Arria II GZ" "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "Stratix III" "Stratix IV"#
    if {[check_device_family_equivalence $device_family $pre_28nm_device_family_list]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "MLAB" "M9K" "M144K"}
        if {$ram_block_type eq "M9K"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $m9k_depth_range
        }
        # device families 'Arria II GX' #
        if {[check_device_family_equivalence $device_family {"Arria II GX"}]} {
            if {$ram_block_type eq "M144K"} {
                send_message    error   "Option of M144K memory block type is unavailable for device family $device_family"
            } elseif {$ram_block_type eq "Auto"} {
                set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $auto_depth_range_8192
            } elseif {$ram_block_type eq "MLAB"} {
                set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $mlab_depth_range
            }
        # device families "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" #
        } elseif {[check_device_family_equivalence $device_family {"Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "MAX 10 FPGA"}]} {
            if {$ram_block_type eq "MLAB"} {
                send_message    error   "Option of MLAB memory block type is unavailable for device family $device_family"
            } elseif {$ram_block_type eq "M144K"} {
                send_message    error   "Option of M144K memory block type is unavailable for device family $device_family"
            } elseif {$ram_block_type eq "Auto"} {
                set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $depth_range_cyclone
            }
        # device families "Arria II GZ" "Stratix III" "Stratix IV" #
        } elseif {[check_device_family_equivalence $device_family {"Arria II GZ" "Stratix III" "Stratix IV"}]} {
            if {$ram_block_type eq "Auto"} {
                set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $auto_depth_range_131072
            } elseif {$ram_block_type eq "MLAB"} {
                if {[check_device_family_equivalence $device_family {"Stratix III"}]} {
                    set_parameter_property  GUI_MAXIMUM_DEPTH   ALLOWED_RANGES  {"0: Auto"}
                } else {
                    set_parameter_property  GUI_MAXIMUM_DEPTH   ALLOWED_RANGES  $mlab_depth_range
                }
            } elseif {$ram_block_type eq "M144K"} {
                set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $m144k_depth_range
            }
        }
    # for device families "Arria V" Cyclone V" #
    } elseif {[check_device_family_equivalence $device_family {"Arria V" "Cyclone V"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "MLAB" "M10K"}
        if {$ram_block_type eq "Auto"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $auto_depth_range_4096
        } elseif {$ram_block_type eq "MLAB"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $mlab_depth_range
        } elseif {$ram_block_type eq "M10K"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $m10k_depth_range
        }
    # for device families "Stratix V" 'Arria V GZ"#
    } elseif {[check_device_family_equivalence $device_family  {"Stratix V" "Arria V GZ" "Arria 10"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto"  "MLAB" "M20K"}
        if {$ram_block_type eq "Auto"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $auto_depth_range_4096
        } elseif {$ram_block_type eq "MLAB"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $mlab_depth_range
        } elseif {$ram_block_type eq "M20K"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $nf_m20k_depth_range
        }
    } elseif {[check_device_family_equivalence $device_family  {"Stratix 10"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto"  "MLAB" "M20K"}
        if {$ram_block_type eq "Auto"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $auto_depth_range_4096
        } elseif {$ram_block_type eq "MLAB"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $nd_mlab_depth_range
        } elseif {$ram_block_type eq "M20K"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $nd_m20k_depth_range
        }
    }

	# checking seperated input and output double clock with output register conditon
	if {$singleclock ==1 && !$regoutput} {
			send_message error "\"Dual clock: separate input & output clocks\" clocking method is unavailable while output register is unused"			
	}
	
	
    # MLAB memory block type effects#
    if {$ram_block_type eq "MLAB"} {
        # for deivce family: Stratix V and Arria V GZ, addresstall_a is not available 
        if {[check_device_family_equivalence $device_family {"Stratix V" "Arria V GZ" "Arria V" "Cyclone V"}]} {
            if {$addressstall_a} {
                send_message    error    "Port \'addressstall_a\' is unavailable while using $device_family device family."
            }
        }
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
	    if {$addressstall_a} {
		send_message	error	 "Port \`addressstall_a\` is unavailable while using $device_family device family."
	    }
	}
        if {$rden} {
            send_message    error   "\'rden\' read enable port is unavailable while using MLAB memory block type."
        }
        if {$jtag_enabled} {
        send_message    error   "In-System Memory Content Editor is unavailable while using MLAB memory block type."
        }
    }


    #group In-system memory content editor#
    if {!$jtag_enabled} {       ;# when in-system memory checked
        if {($jtag_id ne "NONE") && ($jtag_id ne "")} {
            send_message    error   "The \'instance ID\' is only available when In-System Memory Content Editor is allowed."
        }
    } elseif {$aclr_a} {        ;# not available when Address aclr checked
        send_message    error   "The In-System Memory Content Editor is unavailable while \'aclr\' added to port \'address\'."
    }

	#Disable In-system memory Content Editor for nadder#
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$jtag_enabled eq "true"} {
			send_message	error	"In-System Memory Content Editor is unavailable for device family $device_family."
		}
	}
	
	
	#read input address aclrs no longer supported in Nadder#
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$aclr_a eq "true"} {
				send_message	error	"Input Address register clear  no longer supported in Stratix 10" ;#rule8.14/8.15#
		}
	}
	
	
	#Sclr specific#
	if {$sclr_q eq "true"} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"Synchronous clear feature only support for Stratix 10."
		}
	}
	
	
	#Aclr and Sclr cannot be ticked concurrently#
	if {$aclr_q eq "true" && $sclr_q eq "true"} {
		send_message	error	"Only asynchronous clear option or synchronous clear option can be chose at one time."
	}

	#force to zero feature#
	if {$force_to_zero eq "true"} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"Force-to-Zero feature only support for Stratix 10." ;#rule9.1#
		}
		if {$ram_block_type ne "M20K"} {
			send_message	error	"Force-to-Zero feature only support M20K ram block type." ;#rule9.2#
		}
	}
	

    # add ports: clock/clken/inclock/outclock/inclocken/outclocken/aclr/inaclr/outaclr #
    if {$singleclock==0} {
        add_interface_port   rom_input  clock   clk input   1
        if {$clken_in} {
            add_interface_port  rom_input   clken clken  input 1
        } elseif {$clken_out} {
            if {$regoutput} {
                add_interface_port  rom_input   clken   clken input 1
            } else {
                send_message    error  "Can't add port \'clken\' while \'q\' output port not added."
            }
        }
        # add port: aclrs#
        if {$aclr_a}  {
            add_interface_port rom_input    aclr    aclr    input   1
        } elseif {$aclr_q} {
            if {$ram_block_type eq "MLAB"} {
                if {$regoutput} {
                    add_interface_port  rom_input   aclr    aclr    input   1
                } else {
                    send_message    error   "Lutram cannot have output clear when output unregistered"
                }
            } else {
                add_interface_port  rom_input   aclr    aclr    input   1
            }
        } elseif {$sclr_q} {
            if {$ram_block_type eq "MLAB"} {
                if {$regoutput} {
                    add_interface_port  rom_input   sclr    sclr    input   1
                } else {
                    send_message    error   "Lutram cannot have output clear when output unregistered"
                }
            } else {
                add_interface_port  rom_input   sclr    sclr    input   1
            }
        } 	
    } else {
        if {$regaddr} {
            add_interface_port   rom_input  inclock  clk_in  input  1
        }
        if {$regoutput} {
            add_interface_port   rom_input  outclock clk_out input  1
            if {$clken_out}  {
                add_interface_port  rom_input  outclocken  clken_out  input  1
            }
            if {$clken_in} {
                add_interface_port  rom_input   inclocken   clken_in   input  1
            }
        } else {
            if {$clken_in} {
                add_interface_port  rom_input  inclocken    clken_in input 1
            }
            if { $clken_out} {
                send_message    error   "Can't add port \'outclocken\' while \'q\' output port not added."
            }
        }
        # add port: outaclr#
        if {$aclr_q} {
            if {$ram_block_type eq "MLAB"} {
                if {$regoutput} {
                    add_interface_port  rom_input   outaclr    outaclr    input   1
                } else {
                    send_message    error   "Lutram cannot have output clear when output unregistered"
                }
            } else {
                add_interface_port  rom_input   outaclr    outaclr    input   1
            }
        }
		
	# add port: outsclr#
        if {$sclr_q} {
            if {$ram_block_type eq "MLAB"} {
                if {$regoutput} {
                    add_interface_port  rom_input   sclr    sclr    input   1
                } else {
                    send_message    error   "Lutram cannot have output clear when output unregistered"
                }
            } else {
                add_interface_port  rom_input   sclr    sclr    input   1
            }
        }
		
        # add port: inaclr
        if {$aclr_a} {
            add_interface_port  rom_input inaclr    inaclr  input   1
        }
        # dual clock without reg_q #
        if {$jtag_enabled && $regoutput  && ($ram_block_type ne "MLAB")} {
                send_message    error   "\'System Memory Content Editor\' is unavailable while \'q\' output port is registered."
        }
    }

    # add port: addressstall_a #
    if {$addressstall_a} {
        add_interface_port  rom_input   addressstall_a  addressstall_a  input   1
    }
    # add port: rden #
    if {$rden} {
        add_interface_port  rom_input   rden    rden    input   1
    }

    # address ports should be registerd #
    if {!$regaddr} {
        send_message    error   "\'address\' input port should be registered in ROM:1-PORT."
    }


    #Resource estimation#
    set m20k_2k_size   2048
    set m20k_16k_size  16384
    set mlab_width     20
    set mlab_depth     32
    set m20k_size      20480
    set mlab_size      640
    set max_depth         [get_parameter_value    GUI_MAXIMUM_DEPTH]
    set total_size [expr {($width_a*$numwords_a)}]
    set total_num_usage "1 M20K"
   # set depth_div   [expr {double(pow(2,(ceil(log($numwords_a)/log(2)))))}]
    if {$max_depth eq "0" || $max_depth >= $numwords_a} {
        set depth_div   [expr {double(pow(2,(ceil(log($numwords_a)/log(2)))))}]
    } else {
	set depth_div $max_depth	
    }
    if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
    	    if {$depth_div >= $m20k_16k_size} {
	        set depth_div [expr {double($m20k_size)}]
    	    } else {
	        set depth_div [expr {double($depth_div)}]
    	    }
    } else {
    	if {$depth_div >= $m20k_2k_size} {
	    set depth_div [expr {double($m20k_size)}]
    	} else {
	    set depth_div [expr {double($depth_div)}]
    	}
    }
    set total_depth [expr {int(ceil(($numwords_a/$depth_div)))}]
    set width_div   [expr {($m20k_size/$depth_div)}]
    set total_width [expr {ceil(($width_a/$width_div))}]
    set total_usage [expr {int($total_width*$total_depth)}]

    if {$ram_block_type eq "MLAB"} {
	 set total_depth [expr {int(ceil($numwords_a/double($mlab_depth)))}]
	 set total_width [expr {int(ceil($width_a/double($mlab_width)))}]
         set total_usage [expr {int($total_width*$total_depth)}]
    }

    if {[check_device_family_equivalence $device_family {"Arria 10" "Stratix 10"}]} {
    	if {$ram_block_type eq "Auto" || $ram_block_type eq "M20K"} {
	    set total_num_usage "$total_usage M20K"
    	} elseif {$ram_block_type eq "MLAB"} {
            set total_num_usage "$total_usage MLAB"
        }
    } 
	set_parameter_value  GUI_RESOURCE_USAGE   $total_num_usage
}
#+--------------------------------------------
#|
#|  Do Quartus Synth
#|
#+--------------------------------------------
add_fileset quartus_synth   QUARTUS_SYNTH   do_quartus_synth
add_fileset verilog_sim     SIM_VERILOG     do_quartus_sim

proc do_quartus_sim {output_name} {

    set GUI_TBENCH [get_parameter_value	GUI_TBENCH]	 
	
    set file_name ${output_name}.v

    set terp_path params_to_v.v.terp

    set contents [params_to_wrapper_data $terp_path $output_name]

    add_fileset_file $file_name VERILOG TEXT $contents
	
	if {$GUI_TBENCH eq "true"} {
	source "make_var_wrapper_tb.tcl"
	set file_name_tb ${output_name}.vt
	set terp_path_tb params_to_v_tb.v.terp
	set contents_tb [params_to_wrapper_data_tb $terp_path_tb $output_name]
	
	add_fileset_file $file_name_tb VERILOG TEXT $contents_tb
	}
}

proc do_quartus_synth {output_name} {
	
    set file_name ${output_name}.v

    set terp_path params_to_v.v.terp

    set contents [params_to_wrapper_data $terp_path $output_name]

    add_fileset_file $file_name VERILOG TEXT $contents
}


#+--------------------------------------------
#|
#|  Do VHDL Simulation
#|
#+--------------------------------------------
add_fileset vhdl_sim SIM_VHDL do_vhdl_sim

proc do_vhdl_sim {output_name} {

    set file_name ${output_name}.vhd

    set terp_path params_to_vhd.vhd.terp

    set contents [params_to_wrapper_data $terp_path $output_name]

    add_fileset_file $file_name VHDL TEXT $contents
}
#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Procedure: params_to_wrapper_data
#|
#|  Purpose: get hw.tcl params into an array and pass to procedure make_var_wrapper
#|
#+-------------------------------------------------------------------------------------------------------------------------

proc  params_to_wrapper_data  {terp_path output_name}  {
 
        # get hw.tcl ip parameters #
        set param_list      [get_parameters]
        foreach param  $param_list  {
            if {$param eq "DEVICE_FAMILY"} {
                set params(device_family)   [get_parameter_value    $param]
            } elseif {$param eq "GUI_MIFfilename"} {
                set value   [get_parameter_value    $param]
                if {$value eq ""} {
                    send_message    error   "Generation is not complete if you did not specify a file containing the initial memory content."
                }
                set params(miffilename) $value
            } else {
                set param_lower         [string range [string tolower  $param] 4 end]
                set params($param_lower)    [get_parameter_value    $param]
            }
        }
        if {$params(file_reference)==1} {
            set abs_path_to_file        $params(miffilename)
            if {[string match  "*.hex" $params(miffilename)]} {
			    send_message component_info "Renaming [file tail $params(miffilename)]"
			    set params(miffilename) "[file rootname $params(miffilename)]_$output_name.hex"
                set params(miffilename)  [file tail $params(miffilename)]
			    send_message component_info "Renamed to $params(miffilename)"
                add_fileset_file  $params(miffilename)  HEX    PATH   $abs_path_to_file
            } else {
			    send_message component_info "Renaming [file tail $params(miffilename)]"
			    set params(miffilename) "[file rootname $params(miffilename)]_$output_name.mif"
                set params(miffilename)  [file tail $params(miffilename)]
			    send_message component_info "Renamed to $params(miffilename)"
                add_fileset_file  $params(miffilename)  MIF    PATH   $abs_path_to_file
            }
        }


        set ports_list                  [get_interface_ports]
        set params(port_list)           [lsort -ascii $ports_list]

        set terp_fd     [open $terp_path]
        set terp_contents [read $terp_fd]
        close  $terp_fd

        array set params_terp   [make_var_wrapper params]
        set params_terp(output_name)    $output_name

        set contents            [altera_terp    $terp_contents  params_terp]
        return $contents
}

#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Procedure: params_to_wrapper_data_tb
#|
#|  Purpose: get hw.tcl params into an array and pass to procedure make_var_wrapper
#|
#+-------------------------------------------------------------------------------------------------------------------------

proc  params_to_wrapper_data_tb  {terp_path_tb output_name}  {
 
        # get hw.tcl ip parameters #
        set param_list      [get_parameters]
        foreach param  $param_list  {
            if {$param eq "DEVICE_FAMILY"} {
                set params(device_family)   [get_parameter_value    $param]
            } elseif {$param eq "GUI_MIFfilename"} {
                set value   [get_parameter_value    $param]
                if {$value eq ""} {
                    send_message    error   "Generation is not complete if you did not specify a file containing the initial memory content."
                }
                set params(miffilename) $value
            } else {
                set param_lower         [string range [string tolower  $param] 4 end]
                set params($param_lower)    [get_parameter_value    $param]
            }
        }
        if {$params(file_reference)==1} {
            set abs_path_to_file        $params(miffilename)
            if {[string match  "*.hex" $params(miffilename)]} {
			    send_message component_info "Renaming [file tail $params(miffilename)]"
			    set params(miffilename) "[file rootname $params(miffilename)]_$output_name.hex"
                set params(miffilename)  [file tail $params(miffilename)]
			    send_message component_info "Renamed to $params(miffilename)"
                add_fileset_file  $params(miffilename)  HEX    PATH   $abs_path_to_file
            } else {
			    send_message component_info "Renaming [file tail $params(miffilename)]"
			    set params(miffilename) "[file rootname $params(miffilename)]_$output_name.mif"
                set params(miffilename)  [file tail $params(miffilename)]
			    send_message component_info "Renamed to $params(miffilename)"
                add_fileset_file  $params(miffilename)  MIF    PATH   $abs_path_to_file
            }
        }


        set ports_list                  [get_interface_ports]
        set params(port_list)           [lsort -ascii $ports_list]

        set terp_fd_tb     [open $terp_path_tb]
        set terp_contents_tb [read $terp_fd_tb]
        close  $terp_fd_tb

        array set params_terp_tb   [make_var_wrapper_tb params]
        set params_terp_tb(output_name)    $output_name

        set contents_tb            [altera_terp    $terp_contents_tb  params_terp_tb]
        return $contents_tb
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1413425716965/eis1413185370899
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
