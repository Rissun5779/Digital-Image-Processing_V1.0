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
set_module_property     NAME                    "ram_2port"
set_module_property     AUTHOR                  "Altera Corporation"
set_module_property     VERSION                 18.1
set_module_property     DISPLAY_NAME            "RAM: 2-PORT Intel FPGA IP"
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
    set width_params_list {gui_memsize_bits gui_memsize_words gui_qa_width gui_qb_width gui_dataa_width gui_width_eccencparity}
    foreach param $width_params_list {
        set param_temp  [string toupper $param]
        set param_value     [get_parameter_value  $param_temp]
        if {$param_value <=0} {
            set $param  1
        }
    }

    # param list for output1 , output2, memory init,reg visible,clken visible/invisible, aclr visible #
    set params_output1_list {GUI_Q_PORT_MODE GUI_CONSTRAINED_DONT_CARE}
    set params_output2_list {GUI_RDW_A_MODE GUI_NBE_A GUI_RDW_B_MODE GUI_NBE_B}
    set params_meminit_list {GUI_BLANK_MEMORY GUI_INIT_SIM_TO_X GUI_MIF_FILENAME GUI_INIT_FILE_LAYOUT}
    set params_regclkenaclr_list {GUI_WRITE_INPUT_PORTS GUI_READ_INPUT_RDADDRESS GUI_READ_OUTPUT_QA GUI_DIFFERENT_CLKENS GUI_CLKEN_WRITE_INPUT_REG GUI_CLKEN_READ_INPUT_REG GUI_CLKEN_READ_OUTPUT_REG GUI_CLKEN_WRADDRESSSTALL GUI_CLKEN_RDADDRESSSTALL GUI_ACLR_READ_INPUT_RDADDRESS GUI_ACLR_READ_OUTPUT_QA GUI_ACLR_READ_OUTPUT_QB GUI_SCLR_READ_OUTPUT_QA GUI_SCLR_READ_OUTPUT_QB}
	#set params_sclr_list {GUI_SCLR_READ_OUTPUT_QA GUI_SCLR_READ_OUTPUT_QB}
    set reg_invisible_list  {GUI_READ_OUTPUT_QA}
    set clken_visible_list {GUI_CLKEN_WRITE_INPUT_REG GUI_CLKEN_READ_INPUT_REG GUI_CLKEN_READ_OUTPUT_REG GUI_CLKEN_WRADDRESSSTALL GUI_CLKEN_RDADDRESSSTALL}
    set clken_invisible_list   {GUI_CLKEN_INPUT_REG_A GUI_CLKEN_OUTPUT_REG_A GUI_CLKEN_INPUT_REG_B GUI_CLKEN_OUTPUT_REG_B GUI_CLKEN_ADDRESS_STALL_A GUI_CLKEN_ADDRESS_STALL_B}
    set aclr_invisible_list {GUI_ACLR_READ_OUTPUT_QA}
    set sclr_invisible_list {GUI_SCLR_READ_OUTPUT_QA}


    # tab: output1 enable initialization#
    foreach param $params_output1_list {
        set_parameter_property  $param  ENABLED     true
    }
    # tab: output2 enable initialization #
    foreach param $params_output2_list {
        set_parameter_property  $param  ENABLED     true 
    }
    # tab: mem init enable initialization #
    foreach param $params_meminit_list {
        set_parameter_property  $param  ENABLED     true
    }
    # tab:Reg/Clkens/Aclrs initialization #
    foreach param $params_regclkenaclr_list {
        set_parameter_property  $param  ENABLED     true 
    }
    
    # Error checking initialization #
    set_parameter_property  GUI_ECC_DOUBLE      VISIBLE true 
    set_parameter_property  GUI_ECC_TRIPLE      VISIBLE false
    set_parameter_property  GUI_ECC_PIPELINE    VISIBLE true
    set_parameter_property  GUI_ECCENCBYPASS 	VISIBLE	true
    
    # module name based on device family #
    if {[check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {
        set module_name   "altdpram"
    } elseif {($gui_lc_implemention_options ==0) && ($gui_ram_block_type eq "LCs")} {
        set module_name     "altdpram"
    } elseif {($gui_ram_block_type eq "MLAB") && !($gui_read_input_rdaddress)} {
        set module_name     "altdpram"
    } elseif {[check_device_family_equivalence $device_family {"Arria 10" "Stratix 10"}]} {
        set module_name   "altera_syncram"
    } else {
        set module_name     "altsyncram"
    }

    # data_width q_width eccstatus_width numwords_a numwords_b   initialization #
    set data_width  8
    set q_width     8
    set eccstatus_width 2
    set eccencparity_width      [get_parameter_value    GUI_WIDTH_ECCENCPARITY]
    
    # RAM port mode effects: one read and one write/ two read and write ports #--------------------------------------------------------------------
    if {$gui_mode == 0} {           ;# one read port and one write port#
        if {$gui_var_width eq "false"} {        ;# use same data width on different ports #
            # q_b width  choice unavailable #
            if {$gui_qb_width != $gui_dataa_width} {
                send_message    error   "\'q_b\' output bus width should be the same as the width of \'data_a\' input bus."
            }
            set data_width  $gui_dataa_width
            set q_width     $gui_dataa_width
        } else {                    ;# use different data width on different ports #
            set data_width  $gui_dataa_width
            set q_width     $gui_qb_width
        }
        # q_a width  choice unavailable #
        if {$gui_qa_width != 8} {
            send_message    component_info   "\'q_a\' output bus width will be ignored while using one read port and one write port mode."
        }
        # clock type allowed range 0,1,2 ,for device family "NAX II" "MAX V": 0, 1, 2, 3#
        if {$gui_clock_type ==3} {
            if {[check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {  ;# tab Reg/Clkens/Aclrs #
                foreach param $params_regclkenaclr_list {
                    set_parameter_property  $param  ENABLED     FALSE
                }
                send_message    component_info    "Tab Reg'Clkens/Aclrs is unavailable while using \'No clock (fully asynchronous)\'."
            } else {
                send_message    error   "The \'No clock\' option is unavailable while using one read port and one write port."
            }
        } elseif {$gui_clock_type ==4} {
            send_message    error   "The \'Dual clock: use separate clocks for A and B ports\' option is unavailable while using one read port and one write port."
        }
        # single rden option #
        set_parameter_property  GUI_RDEN_SINGLE     VISIBLE true
        set_parameter_property  GUI_RDEN_DOUBLE     VISIBLE false
        # register ports #
        foreach param $reg_invisible_list {
            set_parameter_property  $param  VISIBLE false
        }
        # clock enable optons #
        foreach param $clken_visible_list {
            set_parameter_property  $param  VISIBLE TRUE
        }
        foreach param $clken_invisible_list {
            set_parameter_property  $param  VISIBLE FALSE
        }
        if {$gui_clock_type ==0} {
            if {$gui_clken_read_input_reg !=$gui_clken_write_input_reg} {
                send_message    error   "Use clock enable for write inputs and read inputs or not should be the same while using Single clock method."
            }
            if {$gui_read_output_qb} {
                if {$gui_clken_read_output_reg!=$gui_clken_write_input_reg} {
                    send_message    error   "Use clock enable for write inputs and read outputs or not should be the same while using Single clock method."
                }
            } elseif {$gui_clken_read_output_reg} {
                    send_message    error   "Use clock enable for output ports are unavailable while output ports are not registered."
            }
        } elseif {$gui_clock_type ==1} {
            if {$gui_read_output_qb} {
                if {!$gui_different_clkens} {
                    if {$gui_clken_read_input_reg !=$gui_clken_read_output_reg} {
                        send_message    error   "Use clock enable for read inputs and read outputs or not should be the same while using Dual clock method."
                    }
                }
            } elseif {$gui_clken_read_output_reg} {
                    send_message    error   "Use clock enable for output ports are unavailable while output ports are not registered."
            }
        } elseif {$gui_clock_type ==2} {
            if {$gui_clken_write_input_reg !=$gui_clken_read_input_reg} {
                send_message    error   "Use clock enable for write inputs and read inputs or not should be the same while using Dual clock method."
            }
        }
        # aclr options #
        foreach param $aclr_invisible_list    {
            set_parameter_property  $param  VISIBLE FALSE
        }
	# sclr options #
        foreach param $sclr_invisible_list    {
            set_parameter_property  $param  VISIBLE FALSE
        }
        #  aclr/output1/output2 gui rules for device family not MAX II or MAX V #
        if {![check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {
            # aclr for rdaddress is only available when rdaddress is checked #
            if {$gui_aclr_read_input_rdaddress} {
                if {!$gui_read_input_rdaddress} {
                    send_message    error   "\'aclr\' for port \'rdaddress\' is unavailable while the port is not registered."
                }
            }
            # tab: output1 unavailable when clock type ==1 #
            if {$gui_clock_type ==1} {
                foreach param $params_output1_list {
                    set_parameter_property  $param  ENABLED     FALSE
                }
                send_message    component_info    "Tab Output1 is unavailable while using \'Dual clock: use separate read and write clocks\'."
            }
            # tab: output2 unavailable#
            foreach param $params_output2_list {
                set_parameter_property  $param  ENABLED    FALSE
            }
            send_message    component_info    "Tab Output2 is unavailable while using one read port and one write port."
            # rdaddress register should be check when ram block type not MLAB
            if {$gui_ram_block_type ne "MLAB"} {
                set registered_ports_list {gui_read_input_rdaddress rdaddress}
                foreach {param port} $registered_ports_list {
                    set param_value [set $param]
                    if {!$param_value} {
                        send_message    error   "The port \'$port\' should be registered when ram block type is not MLAB."
                    }
                }
            }
        }
    } elseif {![check_device_family_equivalence $device_family {"MAX II" "MAX V"}]}  {     ;# two read/write ports #
        if {$gui_var_width eq "false"} { ;# use same data width on different ports #
            # q_a width and q width choice unavailable #
            if {$gui_qa_width != $gui_dataa_width} {
                send_message    error   "\'data_a\' input bus width should be the same as the width of \'q_a\' output bus."
            }
            if {$gui_qb_width != $gui_qa_width} {
                send_message    error   "\'q_b\' output bus width should be the same as the width of \'q_a\' output bus."
            }
            set data_width  $gui_qa_width
            set q_width     $gui_qa_width
        } else {    ;# use different data width on different ports #
             # q_a width  choice unavailable #
            if {$gui_qa_width != $gui_dataa_width} {
                send_message    error   "\'data_a\' input bus width should be the same as the width of \'q_a\' output bus."
            }
            set data_width  $gui_qa_width
            set q_width     $gui_qb_width
        }
        # MLAB and LCs unavailable while GUI_MODE ==1 #
        if {$gui_ram_block_type eq "MLAB"} {
            send_message    error   "\'MLAB\' memory block type is unavailable while using two read/write ports."
        } elseif {$gui_ram_block_type eq "LCs"} {
            send_message    error   "\'LCs\' memory block type is unavailable while using two read/write ports."
        }
        # clock type allowed range 0,2,4 #
        if {$gui_clock_type ==3} {
            send_message    error   "The \'No clock\' option is unavailable while using two read/write ports."
        } elseif {$gui_clock_type ==1} {
            send_message    error   "The \'Dual clock: use separate \'read\' and \'write\' clocks\' option is unavailable while using two read/write ports."
        }
        # single rden option #
        set_parameter_property  GUI_RDEN_SINGLE     VISIBLE false
        set_parameter_property  GUI_RDEN_DOUBLE     VISIBLE true
        # register ports #
        foreach param $reg_invisible_list {
            set_parameter_property  $param  VISIBLE true
        }

        set registered_ports_list {gui_read_input_rdaddress rdaddress}
        foreach {param port} $registered_ports_list {
            set param_value [set $param]
            if {!$param_value} {
                send_message    error   "The port \'$port\' should be registered while using two read/write ports."
            }
        }
        #  clock enable optons #
        foreach param $clken_invisible_list {
            set_parameter_property  $param  VISIBLE TRUE
        }
        foreach param $clken_visible_list {
            set_parameter_property  $param  VISIBLE FALSE
        }
        if {$gui_clock_type ==0 ||$gui_clock_type==2} {
            if {$gui_clock_type ==0} {  ;# single clock
                if {$gui_clken_input_reg_a !=$gui_clken_input_reg_b} {
                    send_message    error   "Use clock enable for port A and port B input registers or not should be the same while using Single Clock method."
                }
                if {$gui_read_output_qa && $gui_read_output_qb} {
                    if {$gui_clken_output_reg_a != $gui_clken_output_reg_b} {
                        send_message    error   "Use clock enable for port A and port B output registers or not should be the same while using Single Clock method."
                    }
                }
            } else {        ;# separate in/out clocks
                if {$gui_clken_input_reg_a !=$gui_clken_input_reg_b} {
                    send_message    error   "Use clock enable for port A and port B input registers or not should be the same while using Separate in/out clock method."
                }
                if {$gui_read_output_qa && $gui_read_output_qb} {
                    if {$gui_clken_output_reg_a != $gui_clken_output_reg_b} {
                        send_message    error   "Use clock enable for port A and port B output registers or not should be the same while using Separate in/out clock method."
                    }
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
        }
        # aclr options #
        foreach param $aclr_invisible_list    {
            set_parameter_property  $param  VISIBLE true
        }
	foreach param $sclr_invisible_list    {
            set_parameter_property  $param  VISIBLE true
        }
		
        set params_false_list   {gui_aclr_read_input_rdaddress rdaddress}
        foreach {param port} $params_false_list {
            set param_value [set $param]
            if {$param_value} {
                send_message    error   "\'aclr\' for the port \'$port\' is unavailable while using two read/write ports."
            }
        }
        # tab: output1 , unavailable when clock_type ==4 #
        if {$gui_clock_type ==4} {
            foreach param $params_output1_list {
                set_parameter_property  $param  ENABLED     FALSE
            }
            send_message    component_info    "Tab Output1 is unavailable while using \'Dual clock: use separate clocks for A and B ports\'."
        }
        # tab: output2 . available #
        foreach param $params_output2_list {
            set_parameter_property  $param  ENABLED     true
        }
        if {[check_device_family_equivalence $device_family {"Arria V" "Cyclone V" "Arria 10" "Stratix V" "Arria V GZ" "Stratix 10"}]} { ;#for these device families: only New Data available #
            if {$gui_rdw_a_mode eq "Old Data"} {
                send_message    error   "The \'Old Data\' option is unavailable for device family $device_family."
            } elseif {!$gui_nbe_a} {
                send_message    error   "The X's for write masked bytes should be checked for device family $device_family."
            }
            if {$gui_rdw_b_mode eq "Old Data"} {
                send_message    error   "The \'Old Data\' option is unavailable for device family $device_family."
            } elseif {!$gui_nbe_b} {
                send_message    error   "The X's for write masked bytes should be checked for device family $device_family."
            }
        } else {    ;# for other device family: New data and Old data available #
            if {$gui_rdw_a_mode eq "Old Data"} {
                if {$gui_nbe_a} {
                    send_message    error   "The X's for write masked bytes is unavailable while using \'Old Data\' option."
                }
            } elseif {!$gui_byte_enable_a} {
                if {!$gui_nbe_a} {
                    send_message    error   "The X's for write masked bytes should be checked while Byte enable for port A is not used."
                }
            }
            if {$gui_rdw_b_mode eq "Old Data"} {
                if {$gui_nbe_b} {
                    send_message    error   "The X's for write masked bytes is unavailable while using \'Old Data\' option."
                }
            } elseif {!$gui_byte_enable_b} {
                if {!$gui_nbe_b} {
                    send_message    error   "The X's for write masked bytes should be checked while Byte enable for port B is not used."
                }
            }
        }
    } else {  ;# end of two read/write mode#
        send_message    error   "\'With two read/write ports is unavailable for device family $device_family."
    }


    # register/clken/aclr more options #----------------------------------------------------------------------------------------------------------
    # register  ports options #
    if {!$gui_write_input_ports} {
		send_message    error   "All write inputs ports should be registered"
    }
	
    # address width: wraddress_width,rdaddress_width #----------------------------------------------------------------------------------------------
    # generate the allowed range for memsize_bits according to the input data bus width#
    proc  MemsizeBitsRange  {data_width}   {
        set ranges [list ]
        set end [expr {20-int(ceil(log($data_width)/log(2)))}]
        for {set i 4} {$i <$end} {incr i} {
            lappend ranges [expr $data_width*int(pow(2,$i))]
        }
        return  $ranges
    }
    # generate the allowed range for memsize_word
    proc MemsizeWordsRange {} {
        set ranges [list]
        for {set i 4} {$i<=16} {incr i} {
            lappend ranges [expr int(pow(2,$i))]
        }
        return $ranges
    }
    # check if the input and output width ratio is right
    proc CheckWidthRatio {data_in data_out} {
    set device_family   [get_parameter_value	DEVICE_FAMILY]
    set gui_mode        [get_parameter_value	GUI_MODE]
	if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
	    if {$gui_mode==0} {	
        	set right_ratios {1 2 4 8 16 32}
	    } elseif {$gui_mode==1} {
	    	set right_ratios {1 2 4 8 16}
	    }
	} elseif {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		set right_ratios {1 2 4}
	}

        set right 0
        foreach ratio $right_ratios {
            if {[expr $data_in* $ratio]==$data_out} {
                set right 1
            } elseif {[expr $data_out* $ratio]==$data_in}  {
                set right 1
            }
        }
        return $right
    }
	
	#check data width ratio#
	proc CheckDataWidthRatio {data_in data_out} {
        set right_ratios {1 2 4}
        set right 0
        foreach ratio $right_ratios {
            if {[expr $data_in/$data_out]==$ratio} {
                set right 1
            } elseif {[expr $data_out/ $data_in]==$ratio}  {
                set right 1
            }
        }
        return $right
    }
	
	
    # get numwords_a numwords_b value #
    if {$gui_mem_in_bits} {
        set_parameter_property  GUI_MEMSIZE_WORDS   VISIBLE  false
        set_parameter_property  GUI_MEMSIZE_BITS    VISIBLE  true
        set numwords_a      [expr   {int($gui_memsize_bits/$data_width)}]
        set numwords_b      [expr   {int($gui_memsize_bits/$q_width)}]
        set memsize         $gui_memsize_bits
    } else {
        set_parameter_property  GUI_MEMSIZE_WORDS   VISIBLE  true
        set_parameter_property  GUI_MEMSIZE_BITS    VISIBLE  false
        set numwords_a      $gui_memsize_words
        set numwords_b      [expr   {int($gui_memsize_words * $data_width/$q_width)}]
        set memsize         [expr  {int($gui_memsize_words * $data_width)}]
    }
	
    set wraddress_width 1
    set rdaddress_width 1
    if {$numwords_a<=0} {
        send_message    error   "The memory size must be equal to or larger than input data width."
        set numwords_a 1
    } elseif {$numwords_b<=0} {
        send_message    error   "The memory size must be equal to or larger than output data width."
        set numwords_b 1
    } elseif {[expr {$memsize % $q_width}]!=0} {
        if {$gui_mode==0} {
            send_message    error   "Memory size must be divisible by output_width."
        } elseif {$gui_mode==1} {
            send_message    error   "Memory size must be divisible by q_b width."
        }
        set numwords_b 1
    } elseif {[CheckWidthRatio $data_width $q_width]==0} {
	 if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
		if {$gui_mode==0} {
        	send_message    error   "The valid ratio between port A and port B widths are 1, 2, 4, 8, 16 and 32 for device family $device_family while using one read port and one write port mode."
		} elseif {$gui_mode==1} {
		send_message	error	"The valid ratio between port A and port B widths are 1, 2, 4, 8 and 16 for device family $device_family while using two read/write ports."
		}
    	} elseif {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		send_message	error	"The valid ratio between port A and port B widths are 1,2 and 4 for device family $device_family."
	}
    } else {
		if { $numwords_a == 1 || $numwords_b == 1 } {
			send_message    error   "Memory must be greater than 1 word."
		} else {
			set wraddress_width   [expr {int(ceil(log($numwords_a)/log(2)))}]
			set rdaddress_width   [expr {int(ceil(log($numwords_b)/log(2)))}]
		}
    }


    # use different clock enables for rdaddress and q registers #
    set different_clkens 0
        if {$gui_different_clkens} {
		if {$gui_clock_type ==1} {
            if {$gui_ram_block_type eq "MLAB" || $gui_ram_block_type eq "LCs"}   {
                send_message    error   "Use different clock enables is unavailable for RAM BLOCK TYPE \'$gui_ram_block_type\'."
            } elseif {[check_device_family_equivalence $device_family {"MAX II" "MAX V"}]}  {
                send_message    error   "Use different clock enables is unavailable for device family $device_family."
            } else {
                set different_clkens 1
            }
        } else {
			 send_message    error   "Use different clock enables is only available while using \'Dual clock: use separate read and write clocks\' option."
        }
    }

    # mem init #
    set file_exist  [file exists $gui_mif_filename]
    if {$gui_blank_memory} {    ;#use init file#
        if {$gui_init_sim_to_x} {
            send_message    error   "Initialize memory content data to XXX is unavailable while using file initialization."
        }
		if {$gui_mif_filename eq ""} {
			send_message    warning   "Initialization data file containing the initial memory content must be specified."
		}
		if {($gui_mif_filename ne "") && ![string match "*.mif" $gui_mif_filename] && ![string match "*.hex" $gui_mif_filename]} {
            send_message    error   "The file for initializing is not a MIF or HEX file. Please choose another one."
        }
        set_parameter_property  GUI_INIT_FILE_LAYOUT     ENABLED     true 
    } else {                    ;#leava it blank#
        if {$gui_mif_filename ne ""} {
            send_message    error   "File name for initialization is unavailable while using \'leave it blank\' initialization. Please leave it blank."
        }
        set_parameter_property  GUI_INIT_FILE_LAYOUT     ENABLED     false    
    }

    # device family effects #-----------------------------------------------------------------------------------------------------------------
    #set maximum block depth range list#
    set auto_depth_range_8192_0  {Auto 32 64 128 256 512 1024 2048 4096 8192}
    set auto_depth_range_16384_0  "$auto_depth_range_8192_0 16384"
    set auto_depth_range_131072_0 "$auto_depth_range_16384_0 32768 65536 131072"
    set auto_depth_range_8192_1  {Auto 128 256 512 1024 2048 4096 8192}
    set auto_depth_range_16384_1  "$auto_depth_range_8192_1 16384"
    set auto_depth_range_131072_1 "$auto_depth_range_16384_1 32768 65536 131072"
    set mlab_depth_range    {Auto 32 64}
    set nd_mlab_depth_range {Auto 32}
    set mlab_depth_range_v  {Auto 16 32 64}
    set m9k_depth_range     {Auto 128 256 512 1024 2048 4096 8192}
    set m10k_depth_range    {Auto 128 256 512 1024 2048 4096 8192}
    set m20k_depth_range    {Auto 512 1024 2048 4096 8192 16384}
    set nd_m20k_depth_range {Auto 512 1024 2048}
    set m144k_depth_range   {Auto 4096 8192 16384 32768 65536 131072}
    set lcs_depth_range     {Auto}

    #memory block type available for each device familiy#
    set pre_28nm_device_family_list  {"Arria II GX" "Arria II GZ" "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "Stratix III" "Stratix IV" "MAX 10 FPGA"}
    #for device families "Arria II GX" "Arria II GZ" "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "Stratix III" "Stratix IV"#
    if {[check_device_family_equivalence $device_family $pre_28nm_device_family_list]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "MLAB" "M9K" "M144K" "LCs"}
        if {$gui_ram_block_type eq "M9K"} {
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m9k_depth_range
        }
        # device families 'Arria II GX' #
        if {[check_device_family_equivalence $device_family {"Arria II GX"}]} {
            if {$gui_ram_block_type eq "M144K"} {
                send_message    error   "Option of M144K memory block type is unavailable for device family $device_family"
            } elseif {$gui_ram_block_type eq "Auto"} {
                if {$gui_mode} {    ;# two read/write ports #
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192_1
                } elseif {$gui_var_width}  {            ;# different port width #
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192_1
                } else {            ;# one read/write port #
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES    $auto_depth_range_8192_0
                }
            } elseif {$gui_ram_block_type eq "MLAB"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $mlab_depth_range
            }
        # device families "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" #
        } elseif {[check_device_family_equivalence $device_family {"Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "MAX 10 FPGA"}]} {
            if {($gui_ram_block_type eq "MLAB") && ($gui_mode==0)} {
                send_message    error   "Option of MLAB memory block type is unavailable for device family $device_family"
            } elseif {$gui_ram_block_type eq "M144K"} {
                send_message    error   "Option of M144K memory block type is unavailable for device family $device_family"
            } elseif {$gui_ram_block_type eq "Auto"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192_1
            }
        # device families "Arria II GZ" "Stratix III" "Stratix IV" #
        } elseif {[check_device_family_equivalence $device_family {"Arria II GZ" "Stratix III" "Stratix IV"}]} {
            if {$gui_ram_block_type eq "Auto"} {
                if {$gui_mode} {    ;# two read/write ports #
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_131072_1
                } elseif {$gui_var_width} {            ;# different port width #
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_131072_1
                } else {            ;# one read/write port #
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_131072_0
                }
            } elseif {$gui_ram_block_type eq "MLAB"} {
                if {[check_device_family_equivalence $device_family {"Stratix III"}]} {
                    set_parameter_property  GUI_MAX_DEPTH   ALLOWED_RANGES  {Auto}
                } else {
                    set_parameter_property  GUI_MAX_DEPTH   ALLOWED_RANGES  $mlab_depth_range
                }
            } elseif {$gui_ram_block_type eq "M144K"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m144k_depth_range
            }
        }
    # for device families "Arria V" Cyclone V" #
    } elseif {[check_device_family_equivalence $device_family {"Arria V" "Cyclone V"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "MLAB" "M10K" "M144K" "LCs"}
        if {$gui_ram_block_type eq "M144K"} {
            send_message    error   "Option of M144K memory block type is unavailable for device family $device_family"
        } elseif {$gui_ram_block_type eq "Auto"} {
            if {$gui_mode}  {   ;# two read/write ports #
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192_1
            } elseif {$gui_var_width} {            ;# with different port width#
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192_1
            } else {            ;# one read/write port #
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192_0
            }
        } elseif {$gui_ram_block_type eq "MLAB"} {
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $mlab_depth_range
        } elseif {$gui_ram_block_type eq "M10K"} {
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m10k_depth_range
        }
    # for device families "MAX II" "MAX V" #
    } elseif {[check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto" "M512" "M4K"  "LCs"}
        set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  {256}
        if {$gui_ram_block_type eq "M512"}  {
            send_message    error   "Option of M512 memory block type is unavailable for device family $device_family"
        } elseif {$gui_ram_block_type eq "M4K"} {
            send_message    error   "Option of M4K memory block type is unavailable for device family $device_family"
        } elseif {$gui_ram_block_type eq "LCs"} {
            if {$gui_lc_implemention_options!=0} {
                send_message    error   "\'LCs Options\' are uavailable while using $device_family device family. Please reset to default: Use default logic cell style."
            }
        }
        if {$gui_var_width} {   ;# use different data width unavailable #
            send_message    error   "\'Use different data widths on different ports\' is unavailable for device family $device_family."
        }
        # tab: mem init unavailable #
        foreach param $params_meminit_list {
            set_parameter_property  $param  ENABLED     FALSE
        }
        send_message    component_info      "Tab Mem Init is unavailable for device family $device_family."
        # byte enable unavailable #
        if {$gui_byte_enable_a } {
            send_message    error   "Byte Enable is unavailable for device family $device_family."
        }
        # tab: output2 unavailable #
        foreach param $params_output2_list {
            set_parameter_property  $param  ENABLED     FALSE 
        }
        send_message    component_info      "Tab Output2 is unavailable for device family $device_family."
        # general gui rules for MAX II and MAX V #
        # tab: output1 unavailable #
        foreach param $params_output1_list {
            set_parameter_property  $param  ENABLED     FALSE
        }
        send_message    component_info    "Tab Output1 is unavailable for device family $device_family."
        # gui rules for register ports #
        if {$gui_clken_wraddressstall} {    ;# wraddressstall port unavailable #
            send_message    error   "The port \'wraddressstall\' unavailable for device family $device_family."
        }
        if {$gui_clken_rdaddressstall} {    ;# rdaddressstall port unavailable #
            send_message    error   "The port \'rdaddressstall\' unavailable for device family $device_family."
        }
        if {$gui_clock_type==2} {       ;# q output port remain registered while using dual clock method #
            if {!$gui_read_output_qa} {
                send_message    error   "\'q\' output port should be registered while using \'Dual clock: use separate input and output clocks\'."
            }
        }
        if {!($gui_write_input_ports)} {    ;# no write input ports registered #
            if {$gui_clken_write_input_reg } {
                send_message    error   "Can't create clock enable for write input ports while no write input ports are registered."
            }
        }
        if {!$gui_read_input_rdaddress} {       ;# no read input port registered #
            if {$gui_clken_read_input_reg} {
                send_message    error   "Can't create clock enable for read input rdaddress port while read input rdaddress port is not registered."
            }
            if {$gui_aclr_read_input_rdaddress} {
                send_message    error   "Can't create \'aclr\' for read input rdaddress ports while read input rdaddress port is not registered."
            }
        }
        if {!($gui_read_output_qa || $gui_read_output_qb)} {       ;# no read output ports registered #
            if {$gui_clken_read_output_reg} {
                send_message    error   "Can't create clock enable for read output ports while no read output ports are registered."
            }
            if {$gui_aclr_read_output_qa} {
                send_message    error   "Can't create \'aclr\' for read output ports while no read output ports registered."
            }
	    if {$gui_sclr_read_output_qa} {
                send_message    error   "Can't create \'sclr\' for read output ports while no read output ports registered."
            }
        }
    # for device families "Stratix V" 'Arria V GZ"#
    } elseif {[check_device_family_equivalence $device_family  {"Stratix V" "Arria V GZ" "Arria 10" "Stratix 10"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto" "MLAB" "M20K" "M144K" "LCs"}
        set_parameter_property  GUI_ECC_DOUBLE      VISIBLE false 
        set_parameter_property  GUI_ECC_TRIPLE      VISIBLE true
        if {$gui_ram_block_type eq "M144K"} {
            send_message    error   "Option of M144K memory block type is unavailable for device family $device_family"
        } elseif {$gui_ram_block_type eq "Auto"} {
            if {$gui_mode}  {   ;# two read/write ports #
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_16384_1
            } elseif {$gui_var_width}  {            ;# with different port width #
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_16384_1
            } else {            ;# one read/write port #
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_16384_0
            }
        } elseif {$gui_ram_block_type eq "MLAB"} {
            if {[check_device_family_equivalence $device_family  {"Arria 10"}]} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $mlab_depth_range
            } elseif {[check_device_family_equivalence $device_family  {"Stratix 10"}]} {
		set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $nd_mlab_depth_range
            } else {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $mlab_depth_range_v
            }
        } elseif {$gui_ram_block_type eq "M20K"} {
	    if {[check_device_family_equivalence $device_family  {"Stratix 10"}]} {
		set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $nd_m20k_depth_range
	    } else {
            set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m20k_depth_range
	    }        
	}
   }

   #checking seperated input and output double clock with output register conditon
  	 if {$gui_mode==1} {
			if {($gui_clock_type==2) && (!$gui_read_output_qa ||!$gui_read_output_qb)} {				
			send_message error "\"Dual clock: separate input & output clocking\" method is unavailable while output register is unused"
			} 
			} elseif {$gui_mode==0} {
				if {($gui_clock_type==2) && !$gui_read_output_qb} {
				send_message error "\"Dual clock: separate input & output clocks\" clocking method is unavailable while output register is unused"
				}
			}
	
	
    # get byte enable factor procedure #
    proc  ByteSizeFactor  {data_width factor_list}   {
        set factors [list ]
        foreach byte_size   $factor_list {
            if {[expr {$data_width % $byte_size}]== 0 } {
                lappend factors  $byte_size
            }
        }
        return  $factors
    }

    # memory block type effects#------------------------------------------------------------------------------------------------------------------
    if {$gui_ram_block_type ne "MLAB"} {        ;# for any ram block type not MLAB: old memory and dont care available #
        if {$gui_q_port_mode==3} {  ;# new data option unavailable #
            send_message    error   "\'New Data\' option is unavailable for $gui_ram_block_type ram block type."
        }
        if {!$gui_constrained_dont_care} {   ;#constrained_dont care not available,default to true #
            send_message    error   "Analyzing the timing between write and read operation is unavailable for $gui_ram_block_type ram block type."
        }
    }
    if {$gui_ram_block_type eq "LCs"} {
        if {![check_device_family_equivalence $device_family  {"MAX II" "MAX V"}]} {
            # tab: mem init unavailable #
            foreach param $params_meminit_list {
                set_parameter_property  $param  ENABLED     FALSE
            }
            send_message    component_info      "Tab Mem Init is unavailable for ram block type \'LCs\'."
            # byte enable unavailable #
            if {$gui_byte_enable_a||$gui_byte_enable_b} {
                send_message    error   "Byte Enable is unavailable for ram block type \'LCs\'."
            }
            # tab: output2 unavailable #
            foreach param $params_output2_list {
                set_parameter_property  $param  ENABLED     FALSE 
            }
            send_message    component_info      "Tab Output2 is unavailable for ram block type \'LCs\'."
            # max depth: only auto #
            set_parameter_property  GUI_MAX_DEPTH   ALLOWED_RANGES  {Auto}
            # use different data width unavailable #
            if {$gui_var_width} {
                send_message    error   "\'Use different data widths on different ports\' is unavailable for ram block type \'LCs\'."
            }
        }
    } else {
        if {$gui_lc_implemention_options!=0} {
            send_message    error   "\'LCs Options\' are uavailable while not using LCs memory block type, please reset to default: Use default logic cell style."
        }
        if {$gui_ram_block_type eq "MLAB"} {
            # for deivce family: Stratix V,Arria V GZ,Arria V,Cyclone V wraddressstall is not available 
            if {[check_device_family_equivalence $device_family {"Arria 10" "Stratix V" "Arria V GZ" "Arria V" "Cyclone V" "Stratix 10"}]} {
                if {$gui_clken_wraddressstall} {
                    send_message    error    "Port \'wraddressstall\' is unavailable while using $device_family device family."
                }
            }
            if {!$gui_read_input_rdaddress} {
                if {$gui_clken_rdaddressstall} {
                    send_message    error   "Port \'rdaddressstall\' is unavailable while \'rdaddress\' port has not registered."
                }
            }
            if {$gui_rden_single||$gui_rden_double} {
                send_message    error   "\'rden\' read enable port is unavailable while using MLAB memory block type."
            }
            # byte enable width for port A #
			if {$gui_byte_enable_b} {
			send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
			}
			if {$gui_byte_enable_a} {
				set_parameter_property GUI_BYTE_ENABLE_WIDTH   ENABLED true
				
            if {$data_width >=5} {
                set byte_enable_range   [ByteSizeFactor  $data_width {5 8 9 10}]
                if {$byte_enable_range eq ""} {
                    if {$gui_byte_enable_a} {
                        send_message    error   "Byte enable for port A is unavailable while the width of output bus is not a multiple of 5, 8, 9 or 10."
                    }
                } elseif {$data_width==10} {  ;# only 5 of byte width available when data width equals 10 #
					set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  {5}
				} else {
                    set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  $byte_enable_range                  
                }
            } elseif {$gui_byte_enable_a} {
                send_message    error   "Byte enable for port A is unavailable while the width of output bus less than 5."
            }
            if {$gui_aclr_read_input_rdaddress} {   ;# output1 unavailable when aclr rdaddress added
                # tab: output1 unavailable #
                foreach param $params_output1_list {
                    set_parameter_property  $param  ENABLED     FALSE
                }
                send_message    component_info    "Tab Output1 is unavailable when aclr rdaddress added while using MLAB ram block type."
            } elseif {$gui_clock_type==2} {   ;# output1 unavailable when clock_type =2
                # tab: output1 unavailable #
                foreach param $params_output1_list {
                    set_parameter_property  $param  ENABLED     FALSE
                }
                send_message    component_info    "Tab Output1 is unavailable for device family $device_family."
            } elseif {$gui_clock_type ==1} {    ;# all options of output1 is available when clock_type ==0 #
                if {!$gui_constrained_dont_care} {
                    if {$gui_q_port_mode!=2} {  ;# constrained option only avaiable when dont care is chosen #
                        send_message    error   "Analyzing the timing between write and read operation is only available when \'I do not care\' option is checked."
                    }
                }
            }
            # use different data width unavailable #
            if {$gui_var_width} {
                send_message    error   "\'Use different data widths on different ports\' is unavailable for ram block type \'MLAB\'."
            }
		} else {
		set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  {5 8 9 10}
		set_parameter_property GUI_BYTE_ENABLE_WIDTH   ENABLED false
		}
		
        } elseif {$gui_ram_block_type eq "M20K"} {  ;# ram block type M20k #
            
		if {$gui_byte_enable_a || (($gui_byte_enable_b) && ($gui_mode==1))} {

			set_parameter_property GUI_BYTE_ENABLE_WIDTH   ENABLED true

			# byte enable for port A and B#
            if {$data_width == $q_width} {  ;# byte enable is only available when input data width equals output data width #
                if {$data_width >=10} {
                    set byte_enable_range   [ByteSizeFactor  $data_width  {8 9 10}]
					
                    if {$byte_enable_range eq ""} {
                        if {$gui_byte_enable_a} {
                            send_message    error   "Byte enable for port A is unavailable while the width of output bus is not a multiple of 8, 9 or 10."
                        }
						if {$gui_byte_enable_b} {
							if {$gui_mode ==1} {
							send_message    error   "Byte enable for port B is unavailable while the width of output bus is not a multiple of 8, 9 or 10."
							} else {
							send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
							}						
						}    
                    } elseif {$data_width==10} {  ;# only 5 of byte width available when data width equals 10 #
						 if {$gui_byte_enable_a} {
                            set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  {5}
                        }
						if {$gui_byte_enable_b} {
							if {$gui_mode ==1} {
							set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  {5}
							} else {
							send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
							}						
						}    						
					} else {
						if {$gui_byte_enable_b} {
							if {$gui_mode ==1} {
							set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  $byte_enable_range
							} else {
							send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
							}						
						}    	
						set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  $byte_enable_range
					}
					
                } else {
					if {$gui_byte_enable_a} {
					send_message    error   "Byte enable for port A is unavailable while the width of output is less than 10."
					} elseif {$gui_byte_enable_b} {
						if {$gui_mode ==1} {
							send_message    error   "Byte enable for port B is unavailable while the width of output is less than 10."
						} else {
							send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
						}	
					}
				}

			} 
			#else {
            #    send_message    error   "Byte enable is unavailable while using different data widths on different ports."
            #}
           
            } 
			 # ecc triple available when gui_mode == 0 and byte enable == false#
			if {($gui_mode==0) && !($gui_byte_enable_a)} {
                if {!$gui_ecc_triple} {     ;# ecc triple not checked #
                    if {$gui_ecc_pipeline} {
                        send_message    error   "Enable ECC pipeline registers is only available while ECC option is checked.."
                    }
                } else {    ;# ecc triple checked #
                    # add port eccstatus when ecc_triple ==true , port with 2 #
                        add_interface_port ram_output   eccstatus   eccstatus   output  2
                        set eccstatus_width 2
                    
                    # tab: output1 unavailable when ecc checked#
                    foreach param $params_output1_list {
                        set_parameter_property  $param  ENABLED     FALSE
                    }
                    send_message    component_info    "Tab Output1 is unavailable when error checking is enabled."
                }
			} elseif {$gui_mode==1} { ;# clock type =1 #
                if {$gui_ecc_triple} {
                    send_message    error   "ECC check is unavailable while using two read/write ports."
                }
            } elseif {(($gui_byte_enable_a) || ($gui_byte_enable_b)) } {    ;# byte enable added #
                if {$gui_ecc_triple} {
                    send_message    error   "ECC check is unavailable while byte enable is added."
				}
		} else {
			if {($gui_byte_enable_b) && ($gui_mode==0)} {
			send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
			} else {
			set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  {5 8 9 10}
			set_parameter_property GUI_BYTE_ENABLE_WIDTH   ENABLED false
			}

		}
       } else {     ;# ram block type not M20K, LCS, MLAB #
            if {$gui_ram_block_type eq "M144K"} {   ;# ram block type M144K #
                # ecc pipeline unavailable #
                if {$gui_ecc_pipeline} {
                    send_message    error   "ECC pipeline registers is unavailable for ram block type $gui_ram_block_type."
                }
                # ecc double available when gui_mode == 0 and byte enable == false#
                if {($gui_mode==0) && !($gui_byte_enable_a)} {  ;# clock type =0 and byte enable not add: ecc double available #
                    if {$gui_ecc_double} {  ;# ecc double checked #
                        if {($data_width!=$q_width) || ($data_width !=64)} {
                            send_message    error   "ECC check is only available while port width equals to 64 bits."
                        } else {  ;# add port eccstatus when ecc_double ==true, port width 3 #
                            add_interface_port  ram_output  eccstatus   eccstatus   output  3
                            set eccstatus_width 3
                        }
                    }
                } elseif {$gui_mode==1} { ;# clock type =1 #
                    if {$gui_ecc_double} {
                        send_message    error   "ECC check is unavailable while using two read/write ports."
                    }
                } else {    ;# byte enable added #
                    if {$gui_ecc_double} {
                        send_message    error   "ECC check is unavailable while byte enable is added."
                    }
                }
            }
            # byte enable for port A and B for ram block type not M20K, LCS, MLAB #
			if {$gui_byte_enable_a || (($gui_byte_enable_b) && ($gui_mode==1))} {

			set_parameter_property GUI_BYTE_ENABLE_WIDTH   ENABLED true
			
            if {$data_width == $q_width} {  ;# byte enable is only available when input data width equals output data width #
                if {$data_width >=16} {
                    set byte_enable_range   [ByteSizeFactor  $data_width  {8 9}]
                    if {$byte_enable_range eq ""} {
                        if {$gui_byte_enable_a} {
                            send_message    error   "Byte enable for port A is unavailable while the width of output bus is not a multiple of 8 or 9."
                        }
                        if {$gui_byte_enable_b} {
                            if {$gui_mode ==0} {
                                send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
                            } else {
                                send_message    error   "Byte enable for port B is unavailable while the width of output bus is not a multiple of 8 or 9."
                            }
                        }
                   } else {
						if {$gui_byte_enable_b} {
							if {$gui_mode ==1} {
							set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  $byte_enable_range
							} else {
							send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
							}						
						}    	
						set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  $byte_enable_range
					}
                } else {
					if {$gui_byte_enable_a} {
					send_message    error   "Byte enable for port A is unavailable while the width of output is less than 16."
					} elseif {$gui_byte_enable_b} {
						if {$gui_mode ==1} {
							send_message    error   "Byte enable for port B is unavailable while the width of output is less than 16."
							} else {
							send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
							}	
					}
				}
            } 
			#else {    
             #   send_message    error   "Byte enable is unavailable while using different data widths on different ports."
            #}
        } else {
			if {($gui_byte_enable_b) && ($gui_mode==0)} {
			send_message    error   "Byte enable for port B is unavailable while using one read and one write port."
			} else {
			set_parameter_property  GUI_BYTE_ENABLE_WIDTH   ALLOWED_RANGES  {5 8 9 10}
			set_parameter_property GUI_BYTE_ENABLE_WIDTH   ENABLED false
			}

		}
    }
}

	#Previously missing legality add  to this part to avoid complexity
	if {$gui_ram_block_type eq "MLAB"} {
		if {$gui_read_output_qb ne "true" && $gui_q_port_mode !=2} {
			send_message	error	"MLAB must be output registered when Mixed Port Read-During-Write is using New Data or Old Data." 
		}
	}
	#Cannot set READ_DURING_WRITE_MODE_MIXED_PORTS parameter value set to OLD_DATA for device family Stratix 10#
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$gui_mode ==1 && $gui_q_port_mode !=2} {
			send_message	error	"For device family $device_family, two read /write ports only support \'Dont Care\' option for Mixed Port Read-During-Write."
		}
	}

	#Port addressstall_a can only be used when parameter OPERATION_MODE is set to SINGLE_PORT|ROM|DUAL_PORT#
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$gui_mode == 1} {
			if {$gui_clken_address_stall_a eq "true"} {
				send_message	error	"The port \`addressstall_a\` is unavailable while using two read/write ports."
			} 
			if {$gui_clken_address_stall_b eq "true"} {
				send_message	error	"The port \`addressstall_b\` is unavailable while using two read/write ports."
			} 
		}
	}	
	
	#clocken3 is unavailable for Stratix10#
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$gui_mode == 0 && $gui_clock_type == 1 && $gui_clken_read_input_reg} {
			send_message	error	"Clock enable for read input registers is unavailable while using \'Dual clock: use separate read and write clocks\' for $device_family device family."
		} 
	}

	#data width ratio when byte enable is turn on# #ruleset 1.17#
	if {$gui_var_width eq "true"} {
		if {$gui_qa_width > $gui_qb_width} {
			if {$gui_byte_enable_a eq "true"} {
				if {[CheckDataWidthRatio $gui_qa_width $gui_qb_width] == 0} {
					send_message	error	"The valid ratio between port A and port B widths when byte enable being turned on are 1,2 and 4."
				}
			}
		} else {
			if {$gui_byte_enable_b eq "true"} {
				if {[CheckDataWidthRatio $gui_qa_width $gui_qb_width] == 0} {
					send_message	error	"The valid ratio between port A and port B widths when byte enable being turned on are 1,2 and 4."
				}
			}
		}
	}
    
	#width_a==width_b(TDP Mode) Ruleset 1.18 #
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$gui_mode == 1 && $gui_var_width eq "true"} {
			send_message	error	"Two read/write ports only support same data widths on different ports."
		}
	
	}
		
	
	#Sclr specific#
	if {$gui_sclr_read_output_qa eq "true" || $gui_sclr_read_output_qb eq "true"} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"Synchronous clear feature only support for Stratix 10."
		}
	}
	
	
	#Aclr and Sclr cannot chose concurrently#
	if {($gui_aclr_read_output_qa eq "true" || $gui_aclr_read_output_qb eq "true") && ($gui_sclr_read_output_qa eq "true" || $gui_sclr_read_output_qb eq "true")} {
		send_message	error	"Only asynchronous clear option or synchronous clear option can be chose at one time."
	}
	
	
	#LUTram specific#
	if {$gui_aclr_read_output_qb || $gui_sclr_read_output_qb} {
		if {$gui_ram_block_type eq "MLAB"} {
			if {$gui_read_output_qb eq "false"} {
				send_message	error	" Lutram cannot have output clear when output unregistered"
			}
		}
	}
	
	if {$gui_ram_block_type eq "MLAB"} {
		if {$gui_var_width eq "true"} {
			send_message	error	"Width q_a must be equal to width q_b for MLAB."  ;#rule1.14#
		}
	}
	
	
	# ECC check #
    if {($gui_ram_block_type ne "M20K") && ($gui_ram_block_type ne "M144K")} {   ;# ram block type not M20K or M144K, ECC options are unavailable #
        if {$gui_ecc_pipeline} {
            send_message    error   "Enable ECC pipeline is unavailable for ram block type $gui_ram_block_type."
        }
        if {[get_parameter_property GUI_ECC_DOUBLE VISIBLE]} {
            if {$gui_ecc_double} {
                send_message    error   "Enable ECC check is unavailable for ram block type $gui_ram_block_type."
            }
        } else {
            if {$gui_ecc_triple} {
                send_message    error   "Enable ECC check is unavailable for ram block type $gui_ram_block_type."
            }
        }
    }

	#ECC pipeline#
	if {$gui_ecc_pipeline eq "true"} {
		if {$gui_read_output_qb eq "false"} {
			send_message	error	"Output register must be turned on when ecc_pipeline register is on."
		}
	}
	
	if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
		#ECC check only support same port widths#
		if {$gui_ecc_triple} {
			if {$gui_var_width} {
				send_message	error	"Enable ECC check only support same port width."
			}
		}
	}

	#read input aclrs no longer supported in Nadder#
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$gui_aclr_read_input_rdaddress eq "true" && $gui_ram_block_type ne "MLAB"} {
				send_message	error	"Input Address register clear  no longer supported in Stratix 10" ;#rule8.14/8.15#
		}
	}
	
		
	# TDP only support single clocking mode#
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$gui_clock_type != 0 && $gui_mode == 1} {
			send_message	error	"Two read/write ports only support Single clocking mode." ;#rule3.12#	
		}
	}
	
	
	# ECC enc bypass feature #
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		#set ecc_enc_parity_width 8
		if {!$gui_ecc_triple} { 
			if {$gui_eccencbypass} {
				send_message	error	"Enable ECC enc bypass feature is only available while ECC option is checked" ;#rule6.6#
			} 	
		} else {
			if {$gui_eccencbypass} {
				add_interface_port  ram_input    eccencparity    eccencparity      input   $gui_width_eccencparity  ;#rule6.7#
				add_interface_port	ram_input	 eccencbypass    eccencbypass      input   1
			}
		}
	}
	
	#ECC enc parity#
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$gui_eccencbypass eq "false"} {
				set_parameter_property	GUI_WIDTH_ECCENCPARITY	ENABLED	FALSE

		} else {
			#set_parameter_property	GUI_WIDTH_ECCENCPARITY	VISIBLE	TRUE
			set_parameter_property	GUI_WIDTH_ECCENCPARITY	ENABLED	FALSE
			set_parameter_property	GUI_WIDTH_ECCENCPARITY	ALLOWED_RANGES	{8}
		}
	}
	
	#ECC bypass only for Nadder#
	if {$gui_eccencbypass} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"ECC enc bypass feature only support for Stratix 10."
		}
	}
	
	
	# Coherent Read check #
	if {$gui_coherent_read eq "true"} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"Coherent Read feature only support Stratix 10." ;#rule10.5#
		}
		if {($gui_mode == 1)} {        
			send_message	error	 "Enable Coherent Read feature is unavailable while using two read/write ports." ;#rule10.1#
		}	
		if {$gui_var_width eq "true"} {
			send_message	error	"Coherent Read feature only support same port width."	;#rule10.2#	
		} 
		if {$gui_ecc_double eq "true" || $gui_ecc_triple eq "true"} {
			send_message	error	"Coherent Read cannot be used together with ECC feature." ;#rule10.3#
		} 
		if {($gui_byte_enable_a eq "true" || $gui_byte_enable_b eq "true")} {
			send_message	error	"Byte Enable cannot be connected when Coherent Read is on."  ;#rule10.4#
		}  
		if {$gui_ram_block_type eq "MLAB"} {
			send_message	error	"MLAB doesnt support Coherent Read feature." ;#rule10.6#
		}
		if {$gui_ram_block_type ne "M20K"} {
			send_message	error	"Coherent Read feature only support M20K ram block type." ;#rule10.7#
		}
		if {$gui_clock_type != 0} {
			send_message	error	"Coherent Read feature only support Single clocking mode."	
		}
		if {$gui_q_port_mode == 1} {
			send_message	error	"The \`Old Data\` option is unavailable while Coherent Read feature is turned on."
		}		
	}

	#Force to Zero#
	if {$gui_force_to_zero eq "true"} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"Force-to-Zero feature only support Stratix 10." ;#rule13.1#
		} 
		if {$gui_ram_block_type ne "M20K"} {
			send_message	error	"Force-to-Zero feature only support M20K ram block type." ;#rule13.2#
		}	
	}
	
    #Resource Estimation#
    set m20k_2k_size   2048
    set m20k_16k_size  16384
    set mlab_width     20
    set mlab_depth     32
    set m20k_size      20480
    set mlab_size      640
    if {$gui_qb_width > $gui_dataa_width} {
	set width_a        $gui_qb_width
    } else {
        set width_a        $gui_dataa_width
    }
    set numwords_a     $numwords_a
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
	 set total_depth [expr {int(ceil($numwords_a/double($mlab_depth)))}]
	 set total_width [expr {int(ceil($width_a/double($mlab_width)))}]
         set total_usage [expr {int($total_width*$total_depth)}]
    }

    if {[check_device_family_equivalence $device_family {"Arria 10" "Stratix 10"}]} {
    	if {$gui_ram_block_type eq "Auto" || $gui_ram_block_type eq "M20K"} {
	    set total_num_usage "$total_usage M20K"
    	} elseif {$gui_ram_block_type eq "MLAB"} {
            set total_num_usage "$total_usage MLAB"
        } else {
	    set total_num_usage "-"
	}
    } 
	set_parameter_value  GUI_RESOURCE_USAGE   $total_num_usage
   #end of resource estimation#
	
	
    # add static ports #---------------------------------------------------------------------------------------------------------------------------
    #add static ports: (data,wraddress,rdaddress,wren,clock,q) (data_a,data_b,address_a,address_b,wren_a,wren_b,clock,q_a,q_b)#
    if {$gui_mode==0}   {       ;# for one read port and one write port option #
        add_interface_port  ram_input   data    datain      input   $data_width
        add_interface_port  ram_output  q       dataout     output  $q_width
        add_interface_port  ram_input   wraddress wraddress input   $wraddress_width
        add_interface_port  ram_input   rdaddress rdaddress input   $rdaddress_width
        add_interface_port  ram_input   wren    wren        input   1
        if {$gui_clock_type==1} {
            if {$gui_write_input_ports} {   ;# add wrclock with any write port registered #
                add_interface_port  ram_input   wrclock wrclock input   1
            }
            if {$gui_read_input_rdaddress||$gui_read_output_qb } {    ;# add rdclock with any read port registered#
                add_interface_port  ram_input   rdclock rdclock input   1
            }
        } elseif {$gui_clock_type==2} {
            if {$gui_write_input_ports} {   ;# add inclock with any write port registered #
                add_interface_port  ram_input   inclock inclock input   1
            }
            if {$gui_read_input_rdaddress||$gui_read_output_qb} {    ;#add outclock with any read port registered #
                add_interface_port  ram_input   outclock outclock input 1
            }
        } elseif {$gui_clock_type ==0} {    ;#clock ==single clock#
            if {$gui_write_input_ports||$gui_read_input_rdaddress||$gui_read_output_qb } {    ;# add port clock when any port registered #
                add_interface_port  ram_input   clock   clock   input   1
            }
        }
    } else {                    ;# for two read/write ports #
        add_interface_port  ram_input   data_a  datain_a    input   $data_width
        add_interface_port  ram_output  q_a     dataout_a   output  $data_width
        add_interface_port  ram_input   data_b  datain_b    input   $q_width
        add_interface_port  ram_output  q_b     dataout_b   output  $q_width
        add_interface_port  ram_input   address_a address_a input   $wraddress_width
        add_interface_port  ram_input   address_b address_b input   $rdaddress_width
        add_interface_port  ram_input   wren_a  wren_a      input   1
        add_interface_port  ram_input   wren_b  wren_b      input   1
        if {$gui_clock_type==4} {
            add_interface_port  ram_input   clock_a clock_a input   1
            add_interface_port  ram_input   clock_b clock_b input   1
        } elseif {$gui_clock_type==2} {
            add_interface_port  ram_input   inclock inclock input   1
            add_interface_port  ram_input   outclock outclock  input 1
        } elseif {$gui_clock_type ==0} {    ;#clock ==single clock#
            if {$gui_write_input_ports||$gui_read_input_rdaddress||$gui_read_output_qa || $gui_read_output_qb} {    ;# add port clock when any port registered #
                add_interface_port  ram_input   clock   clock   input   1
            }
        }
    }

    # add dynamic ports #----------------------------------------------------------------------------------------------------------------------------------
    # add dynamic ports: (rden,byteena_a,wr_addressstall,rd_addressstall,enable,aclr) (rden_a,rden_b,byteena_a,byteena_b,aclr,outaclr,addressstall_a,addressstall_b,enable_a,enable_b,)  #
    if {$gui_mode ==0} {            ;# one read and write port #
        if {$gui_rden_single} {     ;# add port rden #
            add_interface_port  ram_input   rden    rden    input   1
        }
        if {$gui_clken_wraddressstall} {    ;# add port wraddressstall #
            if {$module_name eq "altdpram"} {
                add_interface_port  ram_input   wraddressstall  wr_addressstall  input   1
            } else {
                add_interface_port  ram_input   wr_addressstall  wr_addressstall  input   1
            }
        }
        if {$gui_clken_rdaddressstall} {    ;# add port rdaddressstall #
            if {$module_name eq "altdpram"} {
                add_interface_port  ram_input   rdaddressstall  rd_addressstall  input   1
            } else {
                add_interface_port  ram_input   rd_addressstall  rd_addressstall  input   1
            }
        }
        if {$gui_clock_type==0} {   ;# single clock #
            if {$gui_clken_write_input_reg  || $gui_clken_read_input_reg  || $gui_clken_read_output_reg} {       ;# add port enable #
                add_interface_port  ram_input   enable  enable  input   1
            }
            if {$gui_aclr_read_input_rdaddress || $gui_aclr_read_output_qb} {    ;# add port aclr #
                add_interface_port  ram_input  aclr aclr    input   1
            }
	    if {$gui_sclr_read_output_qb eq "true"} {    ;# add port sclr #
                add_interface_port  ram_input  sclr sclr    input   1
            }
        } elseif {$gui_clock_type ==1} {    ;# dual clock: read and write #
            if {$gui_clken_write_input_reg} {               ;# add port wrclocken #
                add_interface_port  ram_input   wrclocken   wrclocken   input   1
            }
            if {$gui_clken_read_input_reg||$gui_clken_read_output_reg}  {
                if {$different_clkens}  {   ;# add port rdinclocken/rdoutclocken #
                    if {$gui_clken_read_input_reg} {
                        add_interface_port  ram_input   rdinclocken rdinclocken input   1
                    }
                    if {$gui_clken_read_output_reg} {
                        add_interface_port  ram_input   rdoutclocken rdoutclocken  input 1
                    }
                } elseif {$gui_read_input_rdaddress||$gui_read_output_qb} {    ;# add port rdclocken #
                    add_interface_port  ram_input   rdclocken   rdclocken   input   1
                }
            }
            if {$gui_aclr_read_input_rdaddress || $gui_aclr_read_output_qb}  {   ;# add port rd_aclr #
                if {$module_name eq "altdpram" } {
                    add_interface_port  ram_input   aclr    aclr    input   1
                } else {
                    add_interface_port  ram_input   rd_aclr rd_aclr input   1
                }
            }
	    if {$gui_sclr_read_output_qb eq "true"}  {   ;# add port rd_sclr #
                if {$module_name eq "altdpram" } {
                    add_interface_port  ram_input   sclr    sclr    input   1
                } else {
                    add_interface_port  ram_input   sclr sclr input   1
                }
            }
        } elseif {$gui_clock_type ==2} {    ;# dual clock: input and output #
            if {$gui_clken_write_input_reg} {   ;# add port inclocken #
                add_interface_port  ram_input   inclocken   inclocken   input   1
            }
            if {$gui_clken_read_output_reg} {   ;# add port outclocken #
                add_interface_port  ram_input   outclocken  outclocken  input   1
            }
            if {$module_name eq "altdpram"} {
                if {$gui_aclr_read_input_rdaddress || $gui_aclr_read_output_qb} {
                    add_interface_port  ram_input   aclr    aclr    input   1
                }
            } else {
                if {$gui_aclr_read_input_rdaddress} {   ;# add port in_aclr #
                    add_interface_port  ram_input   in_aclr in_aclr input   1
                }
                if {$gui_aclr_read_output_qb} {     ;# add port out_aclr #
                    add_interface_port  ram_input   out_aclr out_aclr   input   1
                }
		if {$gui_sclr_read_output_qb eq "true"} {     ;# add port out_aclr #
                    add_interface_port  ram_input   sclr sclr   input   1
                }
           }
        }
    } else {        ;# two read/write ports #
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
            if {$gui_clken_input_reg_a || $gui_clken_output_reg_a || $gui_clken_input_reg_b || $gui_clken_output_reg_b} {       ;# add port enable #
                add_interface_port  ram_input   enable  enable  input   1
            }
            if {$gui_aclr_read_input_rdaddress || $gui_aclr_read_output_qa || $gui_aclr_read_output_qb}  {       ;# add port aclr #
                add_interface_port  ram_input   aclr    aclr    input   1
            }
			if {$gui_sclr_read_output_qa eq "true" || $gui_sclr_read_output_qb eq "true"}  {       ;# add port sclr #
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
	    if {$gui_sclr_read_output_qa}  {    ;# add port sclr_a #
                add_interface_port  ram_input   sclr_a  sclr_a input   1
            }
            if {$gui_aclr_read_output_qb}  {    ;# add port aclr_b #
                add_interface_port  ram_input   aclr_b  aclr_b  input   1
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
    }
    # byteena port #
    set byte_width_a    [expr   $data_width/$gui_byte_enable_width]
    set byte_width_b    [expr   $q_width/$gui_byte_enable_width]
    set byte_width      0
    if {![check_device_family_equivalence $device_family {"MAX II" "MAX V"}] && ($gui_ram_block_type ne "LCs")} {
       # if {$byte_width_a == $byte_width_b} {
            if {[expr $data_width  % $gui_byte_enable_width]== 0 && ($data_width >= 8)} {
                set byte_width   $byte_width_a
                if {$gui_byte_enable_a} {
                    add_interface_port  ram_input   byteena_a   byte_enable_a   input   $byte_width_a
                }
            }
            if {[expr $q_width % $gui_byte_enable_width]==0 && ($q_width >=10)} {    
                if {$gui_byte_enable_b && $gui_mode ==1} {
                    add_interface_port  ram_input   byteena_b   byte_enable_b   input   $byte_width_b
                }
            }
        #}
    }
    # set derived parameter values #
    set_parameter_value GUI_BYTE_WIDTH  $byte_width
    set_parameter_value GUI_MODULE_NAME $module_name
    set_parameter_value GUI_DATA_WIDTH  $data_width
    set_parameter_value GUI_Q_WIDTH     $q_width
    set_parameter_value GUI_WRADDRESS_WIDTH $wraddress_width
    set_parameter_value GUI_RDADDRESS_WIDTH $rdaddress_width
    set_parameter_value GUI_WIDTH_ECCSTATUS  $eccstatus_width
    set_parameter_value GUI_NUMWORDS_A  $numwords_a
    set_parameter_value GUI_NUMWORDS_B  $numwords_b
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
			if {$params(blank_memory)==1} {
            set params(mif_filename)    "STRING"
			send_message    error   "Generation is not complete if you did not specify a file containing the initial memory content."
			}
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
			if {$params(blank_memory)==1} {
            set params(mif_filename)    "STRING"
			send_message    error   "Generation is not complete if you did not specify a file containing the initial memory content."
			}
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

        set contents_tb            [altera_terp    $terp_contents_tb  params_terp_tb]
        return $contents_tb
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1413425716965/eis1413185370899
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
