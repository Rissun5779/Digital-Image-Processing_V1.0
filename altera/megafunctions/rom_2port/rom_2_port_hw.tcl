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
set_module_property     NAME                    "rom_2port"
set_module_property     AUTHOR                  "Altera Corporation"
set_module_property     VERSION                 18.1
set_module_property     DISPLAY_NAME            "ROM: 2-PORT Intel FPGA IP"
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
    add_interface   ram_input   conduit     input
    add_interface   ram_output  conduit     output
    set_interface_assignment    ram_input   ui.blockdiagram.direction   input
    set_interface_assignment    ram_output  ui.blockdiagram.direction   output

    # get all parameter values#
    set params_list      [get_parameters]
    foreach param  $params_list {
        set param_temp  [string tolower $param]
        set $param_temp [get_parameter_value  $param]
    }

    # check data width#
    set width_params_list {gui_memsize_bits gui_memsize_words gui_qa_width gui_qb_width}
    foreach param $width_params_list {
        set param_temp  [string toupper $param]
        set param_value     [get_parameter_value  $param_temp]
        if {$param_value <=0} {
            set $param  1
        }
    }
    # mem in bits/words #
    if {$gui_mem_in_bits} {
        set_parameter_property  GUI_MEMSIZE_WORDS   VISIBLE  false
        set_parameter_property  GUI_MEMSIZE_BITS    VISIBLE  true
    } else {
        set_parameter_property  GUI_MEMSIZE_WORDS   VISIBLE  true
        set_parameter_property  GUI_MEMSIZE_BITS    VISIBLE  false
    }

    # module name based on device family #
    if {[check_device_family_equivalence $device_family {"Arria 10" "Stratix 10"}]} {
        set module_name   "altera_syncram"
    } else {
        set module_name     "altsyncram"
    }

    ### GENERAL GUI RULE FOR ROM:2-PORT####-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    if {$gui_var_width eq "false"} { ;# use same data width on different ports #
        # q_b width choice unavailable #
        if {$gui_qb_width != $gui_qa_width} {
            send_message    error   "\'q_b\' and \'q_a\' output bus width should be the same while not using different widths on different ports."
        }
    }
    # clock type allowed range 0,2,4 #
    set_parameter_property  GUI_CLOCK_TYPE  ALLOWED_RANGES  {"0: Single" "2: Dual clock: use separate 'input' and 'output' clocks" "4: Customize clocks for A and B ports"}

    # register ports #
    if {$gui_clock_type ==2} {
        set registered_ports_list {gui_read_output_qa q_a gui_read_output_qb q_b}
        foreach {param port} $registered_ports_list {
            set param_value [set $param]
            if {!$param_value} {
                send_message    error   "The port \'$port\' should be registered while using current clocking method."
            }
        }
    }
    #  clock enable optons #
    if {$gui_clock_type ==0 ||$gui_clock_type==2} {
        if {$gui_clken_input_reg_a !=$gui_clken_input_reg_b} {
            send_message    error   "Use clock enable for port A and B input registers or not should be the same while using Single clock method."
        }
        if {$gui_read_output_qa && $gui_read_output_qb} {
            if {$gui_clken_output_reg_a != $gui_clken_output_reg_b} {
                send_message    error   "Use clock enable for port A and B output registers or not should be the same while using Single clock method."
            }
        }
        if {!$gui_read_output_qa} {
            if {$gui_clken_output_reg_a } {
                send_message    error   "Use clock enable for A output register is unavailable while QA port is not registered."
            }
        }
        if {!$gui_read_output_qb} {
            if {$gui_clken_output_reg_b } {
                send_message    error   "Use clock enable for B output register is unavailable while QB port is not registered."
            }
        }
    } elseif {$gui_clock_type ==4} {
        if {!$gui_read_output_ports} {
            if {$gui_clken_output_reg_a ||$gui_clken_output_reg_b} {
                send_message    error   "Use clock enable for output registers are unavailable while output ports are not registered."
            }
        }
    }

    # register/clken/aclr more options #----------------------------------------------------------------------------------------------------------
    # register  ports options #
    if {$gui_read_output_qa ||$gui_read_output_qb} {
        if {!$gui_read_output_ports} {
            send_message    error   "Can't register read output ports while \'Read output ports\' option not checked."
        }
    } elseif {$gui_read_output_ports} {
        send_message    error   "Please choose read output ports to register."
    }
    # address width: wraddress_width,rdaddress_width #
    if {$gui_mem_in_bits} {
        set addressa_temp         [expr {double($gui_memsize_bits)/$gui_qa_width}]
        set addressb_temp         [expr {double($gui_memsize_bits)/$gui_qb_width}]
    } else {
        set addressa_temp         $gui_memsize_words
        set addressb_temp         [expr {double($gui_memsize_words)*$gui_qa_width/$gui_qb_width}]
    }
    if {$addressa_temp <=1} {
        send_message    error   "The radio of memory to data width should be equal or greater than 2."
        set addressa_width         1
    } else {
        set addressa               [expr  {log($addressa_temp)/log(2)}]
        set addressa_width         [expr  {int(ceil($addressa))}]
    }
    if {$addressb_temp <=1} {
        send_message    error   "The radio of memory to data width should be equal or greater than 2."
        set addressb_width         1
    } else {
        set addressb               [expr  {log($addressb_temp)/log(2)}]
        set addressb_width         [expr  {int(ceil($addressb))}]
    }

    # mem init #
    set file_exist  [file exists $gui_mif_filename]
    if {$gui_blank_memory} {    ;#use init file#
        set_parameter_property  GUI_FILE_LAYOUT     ENABLED     true 
		if {$gui_mif_filename eq ""} {
			send_message    warning   "Initialization data file containing the initial memory content must be specified."
		} elseif {![string match "*.mif" $gui_mif_filename] && ![string match "*.hex" $gui_mif_filename]} {
            send_message    error   "The file for initializing is not a MIF or HEX file. Please choose another one."
        }
    } else {                    ;#leava it blank#
        set_parameter_property  GUI_FILE_LAYOUT     ENABLED     false    
        send_message    error    "\'Leave it blank\' for memory initialization is unavailable for ROM:2-PORT."
    }

    # device family effects #-----------------------------------------------------------------------------------------------------------------
    #set maximum block depth range list#
    set auto_depth_range_4096   {Auto 128 256 512 1024 2048 4096}
    set auto_depth_range_8192   {Auto 128 256 512 1024 2048 4096 8192}
    set m9k_depth_range         {Auto 128 256 512 1024 2048 4096 8192}
    set m10k_depth_range        {Auto 128 256 512 1024 2048 4096}
    set m20k_depth_range        {Auto 512 1024 2048 4096 8192 16384}
    set nd_m20k_depth_range     {Auto 512 1024 2048}
    set m144k_depth_range       {Auto 128 256 512 1024 2048 4096 8192}

    #memory block type available for each device familiy#
    set pre_28nm_device_family_list  {"Arria II GX" "Arria II GZ" "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "Stratix III" "Stratix IV" "MAX 10 FPGA"}
    #for device families "Arria II GX" "Arria II GZ" "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "Stratix III" "Stratix IV"#
    if {[check_device_family_equivalence $device_family $pre_28nm_device_family_list]} {
        # device families 'Arria II GX' #
        if {[check_device_family_equivalence $device_family {"Arria II GX"}]} {
            set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "M9K"}
            if {$gui_ram_block_type eq "M9K"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m9k_depth_range
            } elseif {$gui_ram_block_type eq "Auto"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192
            }
        # device families "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" #
        } elseif {[check_device_family_equivalence $device_family {"Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "MAX 10 FPGA"}]} {
            set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "M9K"}
            if {$gui_ram_block_type eq "M9K"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m9k_depth_range
            } elseif {$gui_ram_block_type eq "Auto"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192
            }
        # device families "Arria II GZ" "Stratix III" "Stratix IV" #
        } elseif {[check_device_family_equivalence $device_family {"Arria II GZ" "Stratix III" "Stratix IV"}]} {
            set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "M9K" "M144K"}
            if {$gui_ram_block_type eq "M9K"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m9k_depth_range
            } elseif {$gui_ram_block_type eq "Auto"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192
            } elseif {$gui_ram_block_type eq "M144K"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m144k_depth_range
            }
        }
    # for device families "Arria V" Cyclone V" #
    } elseif {[check_device_family_equivalence $device_family {"Arria V" "Cyclone V"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "M10K"}
        if {$gui_ram_block_type eq "Auto"} {
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_4096
        } elseif {$gui_ram_block_type eq "M10K"} {
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m10k_depth_range
        }
    # for device families "Stratix V" 'Arria V GZ"#
    } elseif {[check_device_family_equivalence $device_family  {"Stratix V" "Arria V GZ" "Arria 10"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto" "M20K"}
        if {$gui_ram_block_type eq "Auto"} {
			if {$gui_clock_type ==1 && (!$gui_read_output_qa || !$gui_read_output_qb)} {
			send_message error "\"Double clock\" clocking method is unavailable while output register is unused"			;# checking double clock with output register condition
			}
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_4096
        } elseif {$gui_ram_block_type eq "M20K"} {
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m20k_depth_range
        }
   } elseif {[check_device_family_equivalence $device_family  {"Stratix 10"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto" "M20K"}
        if {$gui_ram_block_type eq "Auto"} {
			if {$gui_clock_type ==1 && (!$gui_read_output_qa || !$gui_read_output_qb)} {
			send_message error "\"Double clock\" clocking method is unavailable while output register is unused"			;# checking double clock with output register condition
			}
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_4096
        } elseif {$gui_ram_block_type eq "M20K"} {
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $nd_m20k_depth_range
        }
   }

	
	#Aclr and Sclr cannot be ticked concurrently#
	if {($gui_aclr_read_output_qa eq "true" || $gui_aclr_read_output_qb eq "true") && ($gui_sclr_read_output_qa eq "true"|| $gui_sclr_read_output_qb eq "true")} {
		send_message	error	"Only asynchronous clear option or synchronous clear option can be chose at one time."
	}
    
    
	#Sclr specific#
	if {$gui_sclr_read_output_qa eq "true" || $gui_sclr_read_output_qb eq "true"} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"Synchronous clear feature only support for Stratix 10."
		}
	}
	
	#rom2port only support Single clocking method#
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$gui_clock_type != 0} {
			send_message	error	"Stratix 10 only support Single clocking mode."
		}	
	}

	#force to zero#
	if {$gui_force_to_zero eq "true"} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"Force-to-Zero feature only support for Stratix 10."
		}
		if {$gui_ram_block_type ne "M20K"} {
			send_message	error	"Force-to-Zero feature only support M20K ram block type."
		}
	}
    
     
    
   
    # add static ports #---------------------------------------------------------------------------------------------------------------------------
    #add static ports: (address_a,address_b,clock,q_a,q_b)#
    add_interface_port  ram_output  q_a     q_a   output  $gui_qa_width
    add_interface_port  ram_output  q_b     q_b   output  $gui_qb_width
    add_interface_port  ram_input   address_a address_a input   $addressa_width
    add_interface_port  ram_input   address_b address_b input   $addressb_width
    if {$gui_clock_type==4} {
        add_interface_port  ram_input   clock_a clock_a input   1
        add_interface_port  ram_input   clock_b clock_b input   1
    } elseif {$gui_clock_type==2} {
        add_interface_port  ram_input   inclock inclock input   1
        add_interface_port  ram_input   outclock outclock  input 1
    } elseif {$gui_clock_type ==0} {    ;#clock ==single clock#
        add_interface_port  ram_input   clock   clock   input   1
    }
    
    # add dynamic ports #----------------------------------------------------------------------------------------------------------------------------------
    # add dynamic ports: (rden_a,rden_b,aclr,outaclr,sclr,outsclr,addressstall_a,addressstall_b,enable_a,enable_b,)  #
    if {$gui_rden_double}   {   ;# add rden_a, rden_b #
        add_interface_port  ram_input   rden_a  rden_a  input   1
        add_interface_port  ram_input   rden_b  rden_b  input   1
    }
    if {$gui_clken_address_stall_a} {    ;# add port addressstall_a #
        add_interface_port  ram_input   addressstall_a  addressstall_a  input   1
    }
    if {$gui_clken_address_stall_b} {    ;# add port addressstall_b #
        add_interface_port  ram_input   addressstall_b addressstall_b  input   1
    }
    
    if {$gui_clock_type==0} {   ;# single clock #
        if {$gui_clken_input_reg_a||$gui_clken_output_reg_a||$gui_clken_input_reg_b ||$gui_clken_output_reg_b} {       ;# add port enable #
        add_interface_port  ram_input   enable  enable  input   1
        }
        if {$gui_aclr_read_output_qa||$gui_aclr_read_output_qb}  {       ;# add port aclr #
        add_interface_port  ram_input   aclr    aclr    input   1
        }
	if {$gui_sclr_read_output_qa||$gui_sclr_read_output_qb}  {       ;# add port sclr #
        add_interface_port  ram_input   sclr    sclr    input   1
        }
    } elseif {$gui_clock_type ==4} {    ;# dual clock: for A and B ports #
        if {$gui_clken_input_reg_a||$gui_clken_output_reg_a} {      ;# add port enable_a #
            add_interface_port  ram_input   enable_a  enable_a   input   1
        }
        if {$gui_clken_input_reg_b||$gui_clken_output_reg_b}  {     ;# add port enable_b #
            add_interface_port  ram_input   enable_b  enable_b   input   1
        }
        if {$gui_aclr_read_output_qa}  {    ;# add port aclr_a #
            add_interface_port  ram_input   aclr_a  aclr_a input   1
        }
        if {$gui_aclr_read_output_qb}  {    ;# add port aclr_b #
            add_interface_port  ram_input   aclr_b  aclr_b  input   1
        }
	if {$gui_sclr_read_output_qa}  {    ;# add port sclr_a #
            add_interface_port  ram_input   sclr_a  sclr_a input   1
        }
        if {$gui_sclr_read_output_qb}  {    ;# add port sclr_b #
            add_interface_port  ram_input   sclr_b  sclr_b  input   1
        }
    } elseif {$gui_clock_type ==2} {    ;# dual clock: input and output #
        if {$gui_clken_input_reg_a} {   ;# add port inclocken #
            add_interface_port  ram_input   inclocken   inclocken   input   1
        }
        if {$gui_clken_output_reg_a} {   ;# add port outclocken #
            add_interface_port  ram_input   outclocken  outclocken  input   1
        }
        if {$gui_aclr_read_output_qa || $gui_aclr_read_output_qb} {                ;# add port out_aclr #
            add_interface_port  ram_input   out_aclr out_aclr   input   1
        }
	if {$gui_sclr_read_output_qa || $gui_sclr_read_output_qb} {                ;# add port out_sclr #
            add_interface_port  ram_input   sclr sclr   input   1
        }
    }
    
    # get numwords_a numwords_b value #
    if {$gui_mem_in_bits} {
        set numwords_a_temp [expr   {double($gui_memsize_bits)/$gui_qa_width} ]
        set numwords_a      [expr   {int(ceil($numwords_a_temp))} ]
        set numwords_b_temp [expr   {double($gui_memsize_bits)/$gui_qb_width}]
        set numwords_b      [expr   {int(ceil($numwords_b_temp))} ]
    } else {
        set numwords_a      $gui_memsize_words
        set numwords_b_temp [expr   {double($gui_memsize_words)*$gui_qa_width/$gui_qb_width}]
        set numwords_b      [expr   {int(ceil($numwords_b_temp))} ]
    }
    # set derived parameter values #
    set_parameter_value GUI_MODULE_NAME $module_name
    set_parameter_value GUI_ADDRESSA_WIDTH $addressa_width
    set_parameter_value GUI_ADDRESSB_WIDTH $addressb_width
    set_parameter_value GUI_NUMWORDS_A  $numwords_a
    set_parameter_value GUI_NUMWORDS_B  $numwords_b
        
    
    #Resouce Estimation#
    set m20k_2k_size   2048
    set m20k_16k_size  16384
    set mlab_width     20
    set mlab_depth     32
    set m20k_size      20480
    set mlab_size      640
    set width_a        [get_parameter_value    GUI_QA_WIDTH]
    set numwords_a     [get_parameter_value    GUI_MEMSIZE_WORDS]
    set max_depth      [get_parameter_value    GUI_MAX_DEPTH]
    set total_size     [expr {($width_a*$numwords_a)}]
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

    if {$gui_ram_block_type eq "MLAB"} {
	 set total_depth [expr {int(ceil($numwords_a/$mlab_depth))}]
	 set total_width [expr {int(ceil($width_a/$width_div))}]
         set total_usage [expr {int($total_width*$total_depth)}]
    }

    if {[check_device_family_equivalence $device_family {"Arria 10" "Stratix 10"}]} {
    	if {$gui_ram_block_type eq "Auto" || $gui_ram_block_type eq "M20K"} {
	    set total_num_usage "$total_usage M20K"
    	} elseif {$gui_ram_block_type eq "MLAB"} {
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

proc    params_to_wrapper_data  {terp_path output_name}  {
 
        # get hw.tcl ip parameters #
        set param_list      [get_parameters]
        foreach param  $param_list  {
            if {$param eq "DEVICE_FAMILY"} {
                set param_lower     "device_family"
            } else {
                set param_lower     [string range [string tolower $param] 4 end]
            }
            set params($param_lower)    [get_parameter_value    $param]
        }
        if {$params(mif_filename) eq ""} {
            send_message    error   "Generation is not complete if you did not specify a file containing the initial memory content."
        } elseif {$params(file_reference)==1} {
            set abs_path_to_file        $params(mif_filename)
            if {[string match  "*.hex" $params(mif_filename)]} {
			    send_message component_info "Renaming [file tail $params(mif_filename)]"
			    set params(mif_filename) "[file rootname $params(mif_filename)]_$output_name.hex"
                set params(mif_filename)  [file tail $params(mif_filename)]
			    send_message component_info "Renamed to $params(mif_filename)"
                add_fileset_file  $params(mif_filename)  HEX    PATH   $abs_path_to_file
            } else {
			    send_message component_info "Renaming [file tail $params(mif_filename)]"
			    set params(mif_filename) "[file rootname $params(mif_filename)]_$output_name.mif"
                set params(mif_filename)  [file tail $params(mif_filename)]
			    send_message component_info "Renamed to $params(mif_filename)"
                add_fileset_file  $params(mif_filename)  MIF    PATH   $abs_path_to_file
            }
        }
        set ports_list_input    [lsort -ascii [get_interface_ports ram_input]]
        set ports_list_output   [lsort -ascii [get_interface_ports ram_output]]
        set ports_list          [concat  $ports_list_input $ports_list_output]
        set params(port_list)           $ports_list

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

proc    params_to_wrapper_data_tb  {terp_path_tb output_name}  {
 
        # get hw.tcl ip parameters #
        set param_list      [get_parameters]
        foreach param  $param_list  {
            if {$param eq "DEVICE_FAMILY"} {
                set param_lower     "device_family"
            } else {
                set param_lower     [string range [string tolower $param] 4 end]
            }
            set params($param_lower)    [get_parameter_value    $param]
        }
        if {$params(mif_filename) eq ""} {
            send_message    error   "Generation is not complete if you did not specify a file containing the initial memory content."
        } elseif {$params(file_reference)==1} {
            set abs_path_to_file        $params(mif_filename)
            if {[string match  "*.hex" $params(mif_filename)]} {
			    send_message component_info "Renaming [file tail $params(mif_filename)]"
			    set params(mif_filename) "[file rootname $params(mif_filename)]_$output_name.hex"
                set params(mif_filename)  [file tail $params(mif_filename)]
			    send_message component_info "Renamed to $params(mif_filename)"
                add_fileset_file  $params(mif_filename)  HEX    PATH   $abs_path_to_file
            } else {
			    send_message component_info "Renaming [file tail $params(mif_filename)]"
			    set params(mif_filename) "[file rootname $params(mif_filename)]_$output_name.mif"
                set params(mif_filename)  [file tail $params(mif_filename)]
			    send_message component_info "Renamed to $params(mif_filename)"
                add_fileset_file  $params(mif_filename)  MIF    PATH   $abs_path_to_file
            }
        }
        set ports_list_input    [lsort -ascii [get_interface_ports ram_input]]
        set ports_list_output   [lsort -ascii [get_interface_ports ram_output]]
        set ports_list          [concat  $ports_list_input $ports_list_output]
        set params(port_list)           $ports_list

        set terp_fd_tb     [open $terp_path_tb]
        set terp_contents_tb [read $terp_fd_tb]
        close  $terp_fd_tb

        array set params_terp_tb   [make_var_wrapper_tb params]
        set params_terp_tb(output_name)    $output_name

        set contents_tb           [altera_terp    $terp_contents_tb  params_terp_tb]
        return $contents_tb
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1413425716965/eis1413185370899
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
