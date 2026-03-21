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
set_module_property     NAME                    "ram_1port"
set_module_property     AUTHOR                  "Altera Corporation"
set_module_property     VERSION                 18.1
set_module_property     DISPLAY_NAME            "RAM: 1-PORT Intel FPGA IP"
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
    set_interface_assignment    ram_output    ui.blockdiagram.direction   output

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
    add_interface_port  ram_input   data    datain  input   $width_a
    add_interface_port  ram_output  q       dataout output  $width_a
    add_interface_port  ram_input   address address input   $widthad_a

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
    set lcs_depth_range     {"0:Auto"}

    # get parameter values#
    # tab 1 #
    set ram_block_type      [get_parameter_value    GUI_RAM_BLOCK_TYPE]
    set implement_in_les    [get_parameter_value    GUI_IMPLEMENT_IN_LES]
    set singleclock         [get_parameter_value    GUI_SingleClock]
    # tab 2 #
    set regdata     [get_parameter_value    GUI_RegData]
    set regaddr     [get_parameter_value    GUI_RegAddr]
    set regoutput   [get_parameter_value    GUI_RegOutput]
    set clken       [get_parameter_value    GUI_Clken]
    set clken_in    [get_parameter_value    GUI_CLOCK_ENABLE_INPUT_A]
    set clken_out   [get_parameter_value    GUI_CLOCK_ENABLE_OUTPUT_A]
    set addressstall_a  [get_parameter_value    GUI_ADDRESSSTALL_A]
    set byte_enable     [get_parameter_value    GUI_BYTE_ENABLE]
    set byte_size   [get_parameter_value    GUI_BYTE_SIZE]
    set aclr_d      [get_parameter_value    GUI_AclrData]
    set aclr_w      [get_parameter_value    GUI_WRCONTROL_ACLR_A]
    set aclr_a      [get_parameter_value    GUI_AclrAddr]
    set aclr_q      [get_parameter_value    GUI_AclrOutput]
    set sclr_q	    [get_parameter_value    GUI_SclrOutput]
    set aclr_b      [get_parameter_value    GUI_AclrByte]
    set rden        [get_parameter_value    GUI_rden]
    set force_to_zero [get_parameter_value    GUI_FORCE_TO_ZERO]
    # tab 3 #
    set rdwm_port_a     [get_parameter_value    GUI_READ_DURING_WRITE_MODE_PORT_A]
    set x_mask          [get_parameter_value    GUI_X_MASK]
    # tab 4 #
    set blankmemory     [get_parameter_value    GUI_BlankMemory]
    set init_to_sim_x   [get_parameter_value    GUI_INIT_TO_SIM_X]
    set miffilename     [get_parameter_value    GUI_MIFfilename]
    set init_file_layout    [get_parameter_value    GUI_INIT_FILE_LAYOUT]
    set jtag_enabled        [get_parameter_value    GUI_JTAG_ENABLED]
    set jtag_id         [get_parameter_value    GUI_JTAG_ID]

    # input interface port: wren/we #
    if {![check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {
        if {$ram_block_type eq "LCs" && !$implement_in_les} {
            add_interface_port  ram_input   we    we    input   1
        } else {
            add_interface_port  ram_input   wren    wren    input   1
        }
    } else {
        add_interface_port  ram_input   we  we  input   1
    }
    
    # module name initialization #
    set_parameter_value     GUI_MODULE_NAME     "altsyncram"

    #memory block type available for each device familiy#
    set pre_28nm_device_family_list  {"Arria II GX" "Arria II GZ" "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "Stratix III" "Stratix IV" "MAX 10 FPGA"}
    #for device families "Arria II GX" "Arria II GZ" "Cyclone III" "Cyclone III LS" "Cyclone IV E" "Cyclone IV GX" "Stratix III" "Stratix IV"#
    if {[check_device_family_equivalence $device_family $pre_28nm_device_family_list]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "MLAB" "M9K" "M144K" "LCs"}
        if {$ram_block_type eq "M9K"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $m9k_depth_range
        }
        # device families 'Arria II GX' #
        if {[check_device_family_equivalence $device_family {"Arria II GX"}]} {
            if {$ram_block_type eq "M144K"} {
                send_message    error   "Option of M144K memory block type is unavailable for device family $device_family"
            } elseif {$ram_block_type eq "Auto"} {
                set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "1: New Data" "2: Old Data"}
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
            } else {
                set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $depth_range_cyclone
                set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "1: New Data" "2: Old Data"}
            }
        # device families "Arria II GZ" "Stratix III" "Stratix IV" #
        } elseif {[check_device_family_equivalence $device_family {"Arria II GZ" "Stratix III" "Stratix IV"}]} {
            if {$ram_block_type eq "Auto"} {
                set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $auto_depth_range_131072
                set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "1: New Data" "2: Old Data"}
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
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto"  "MLAB" "M10K" "LCs"}
        if {$ram_block_type eq "Auto"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $auto_depth_range_4096
            set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "1: New Data"}
        } elseif {$ram_block_type eq "MLAB"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $mlab_depth_range
        } elseif {$ram_block_type eq "M10K"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $m10k_depth_range
        }
    # for device families "MAX II" "MAX V" #
    } elseif {[check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto" "M512" "M4K" "LCs"}
        set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  256
        if {$ram_block_type eq "M512"}  {
            send_message    error   "Option of M512 memory block type is unavailable for device family $device_family"
        } elseif {$ram_block_type eq "M4K"} {
            send_message    error   "Option of M4K memory block type is unavailable for device family $device_family"
        } elseif {$ram_block_type eq "Auto"} {
            if {$singleclock==0} {
                send_message    error   "\'Single clock\' clocking method is unavailable while using $device_family device family."
            }
            if {$rdwm_port_a!=1} {
                send_message    error   "\'Single Port Read-During-Write Option\' are unavailable while using $device_family device family, please reset to default: New Data."
            }
            if {!$x_mask} {
                send_message    error   "\'Single Port Read-During-Write Option\' are unavailable while using $device_family device family, please reset to default:Get Xs."
            }
            if {$byte_enable} {
                send_message    error   "Byte enable for port A is unavailable while using $device_family device family."
            }
            if {$jtag_enabled }  {
                send_message    error   "In-System Memory Content Editor is unavailable while using $device_family device family."
            }
            if {$clken || $clken_in || $clken_out || $addressstall_a} {
                send_message    error   "\'Clock Enable Options\' and \'Address Options\' are unavailable while using $device_family device family. "
            }
            if {$rden} {
                send_message    error   "Read Enable port is unavailable while using $device_family device family."
            }
            if {$init_to_sim_x} {
                send_message    error   "\'Memory Initialization\' is unavailable while using $device_family device family."
            }
            if {$aclr_q } {
                send_message    error   "\'Aclrs\' are unavailable while using LCs memory block type."
            }
	    if {$sclr_q } {
                send_message    error   "\'Sclrs\' are unavailable while using LCs memory block type."
            }
        } elseif {$ram_block_type eq "LCs"} {
            if {$implement_in_les!=0} {
                send_message    error   "\'LCs Options\' are unavailable while using $device_family device family. Please reset to default: Use default logic cell style."
            }
        }
    # for device families "Stratix V" 'Arria V GZ"#
    } elseif {[check_device_family_equivalence $device_family  {"Stratix V" "Arria V GZ" "Arria 10"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto" "MLAB" "M20K" "LCs"}
        if {$ram_block_type eq "Auto"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $auto_depth_range_4096
            set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "1: New Data"}
        } elseif {$ram_block_type eq "MLAB"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $mlab_depth_range
        } elseif {$ram_block_type eq "M20K"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $nf_m20k_depth_range
        }
    } elseif {[check_device_family_equivalence $device_family  {"Stratix 10"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto" "MLAB" "M20K" "LCs"}
        if {$ram_block_type eq "Auto"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $auto_depth_range_4096
            set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "1: New Data"}
        } elseif {$ram_block_type eq "MLAB"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $nd_mlab_depth_range
        } elseif {$ram_block_type eq "M20K"} {
            set_parameter_property  GUI_MAXIMUM_DEPTH ALLOWED_RANGES  $nd_m20k_depth_range
        }
    }

	
	#checking seperated input and output double clock with output register conditon
  	 if {$singleclock==1 && !$regoutput} {				
	 send_message error "\"Dual clock: separate input & output clocks\" clocking method is unavailable while output register is unused"
	}
	
    # get byte enable factor procedure #
    proc  ByteSizeFactor  {data_width factor_list}   {
        set factors [list ]
        foreach byte_size   $factor_list {
            if {[expr $data_width % $byte_size]== 0 } {
                lappend factors  $byte_size
            }
        }
        return  $factors
    }

    # memory block type effects#
    if {$ram_block_type eq "LCs"} {
        # tab 1#
        if {![check_device_family_equivalence $device_family {"MAX II" "MAX V"}] } {
            set_parameter_property  GUI_MAXIMUM_DEPTH  ALLOWED_RANGES  $lcs_depth_range
        }
        if {$singleclock==0} {
            send_message    error   "\'Single clock\' clocking method is unavailable while using LCs memory block type."
        }
        # tab 2 #
        if { $aclr_q } {
            send_message    error   "\'Aclrs\' are unavailable while using LCs memory block type."
        }
	if { $sclr_q } {
            send_message    error   "\'Sclrs\' are unavailable while using LCs memory block type."
        }
        if {$byte_enable} {
            send_message    error   "Byte enable for port A is unavailable while using LCs memory block type."
        }
        if {$clken || $clken_in || $clken_out || $addressstall_a} {
            send_message    error   "\'Clock Enable Options\' and \'Address Options\' are unavailable while using LCs memory block type. "
        }
        if {$rden} {
            send_message    error   "Read Enable port is unavailable while using LCs memory block type."
        }
        # tab 3 #
        if {$rdwm_port_a!=1} {
            send_message    error   "\'Single Port Read-During-Write Option\' are unavailable while using LCs memory block type, please reset to default: New Data."
        }
        if {!$x_mask} {
            send_message    error   "\'Single Port Read-During-Write Option\' are unavailable while using LCs memory block type, please reset to default:Get Xs."
        }
        # tab 4 #
        if {$blankmemory} {
            send_message    error   "\'Memory Initialization\' is unavailable while using LCs memory block type, please reset to default: No, leave it blank."
        }
        if {$init_to_sim_x} {
            send_message    error   "\'Memory Initialization\' is unavailable while using LCs memory block type."
        }
        if {$jtag_enabled } {
            send_message    error   "\'System Memory Content Editor\' is unavailable while using LCs memory block type."
        }
        if {$implement_in_les ==0} {
            set_parameter_value     GUI_MODULE_NAME     "LPM_RAM_DQ"
        } else {
            set_parameter_value     GUI_MODULE_NAME     "altsyncram"
        }
    } else {
        if {$implement_in_les!=0} {
            send_message    error   "\'Logic Cell Implementation Options\' are uavailable while not using LCs memory block type, please reset to default: Use default logic cell style."
        }
        set_parameter_value     GUI_MODULE_NAME     "altsyncram"
        if {$ram_block_type eq "MLAB"} {
            # for deivce family: Stratix V and Arria V GZ, addresstall_a is not available/ only dont care for RDWM 
            if {[check_device_family_equivalence $device_family {"Stratix V" "Arria V GZ" "Arria V" "Cyclone V" "Arria 10" "Stratix 10"}]} {
                if {$addressstall_a} {
                    send_message    error    "Port \'addressstall_a\' is unavailable while using $device_family device family."
                }
                set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care"}
            } else {
                set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "2: Old Data"}
            }
            if {$rden} {
                send_message    error   "\'rden\' read enable port is unavailable while using MLAB memory block type."
            }
            if {$x_mask && ($rdwm_port_a == 1)} {
                send_message    error   "\'X MASKs\' of q output is unavailable while using MLAB memory block type."
            }
            if {$jtag_enabled} {
                send_message    error   "In-System Memory Content Editor is unavailable while using MLAB memory block type."
            }
            # byte enable width #
			if {$byte_enable} {
				set_parameter_property GUI_BYTE_SIZE   ENABLED true
			
            if {$width_a >=10} {
                set byte_enable_range   [ByteSizeFactor  $width_a  {5 8 9 10}]
                if {$byte_enable_range eq ""} {
                    if {$byte_enable} {
                        send_message    error   "Byte enable for port A is unavailable while the width of output bus is not a multiple of 5, 8, 9 or 10."
                    }
                } else {
                    set_parameter_property  GUI_BYTE_SIZE   ALLOWED_RANGES  $byte_enable_range
                }
            } elseif {$byte_enable} {
                send_message    error   "Byte enable for port A is unavailable while the width of output bus is less than 10."
            }
			} else {
			set_parameter_property  GUI_BYTE_SIZE   ALLOWED_RANGES  {5 8 9 10}
			set_parameter_property GUI_BYTE_SIZE   ENABLED false
			}
        } elseif {$ram_block_type eq "M20K"} {
			if {$byte_enable} {
				set_parameter_property GUI_BYTE_SIZE   ENABLED true
				
            if {$width_a >=16} {
                set byte_enable_range   [ByteSizeFactor  $width_a  {5 8 9 10}]
                if {$byte_enable_range eq ""} {
                    if {$byte_enable} {
                        send_message    error   "Byte enable for port A is unavailable while the width of output bus is not a multiple of 5, 8, 9 or 10."
                    }
                } else {
                    set_parameter_property  GUI_BYTE_SIZE   ALLOWED_RANGES  $byte_enable_range
                }
            } elseif {$byte_enable} {
                send_message    error   "Byte enable for port A is unavailable while the width of output is less than 16."
            }
			} else {
			set_parameter_property  GUI_BYTE_SIZE   ALLOWED_RANGES  {5 8 9 10}
			set_parameter_property GUI_BYTE_SIZE   ENABLED false
			}
            set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "1: New Data" "2: Old Data"}
            if {!$x_mask && ($rdwm_port_a ==1) } {
                send_message    error   "\'X MASKs\' of q output should be checked while using \'NEW DATA\' for $ram_block_type memory block type."
            }
        } else {        ;# ram block type : M9K, M10K, M144K, Auto #
			if {$byte_enable} {
				set_parameter_property GUI_BYTE_SIZE   ENABLED true
				
            if {$width_a >=16} {
                set byte_enable_range   [ByteSizeFactor  $width_a  {8 9}]
                if {$byte_enable_range eq ""} {
                    if {$byte_enable} {
                        send_message    error   "Byte enable for port A is unavailable while the width of output bus is not a multiple of 8 or 9."
                    }
                } else {
                    set_parameter_property  GUI_BYTE_SIZE   ALLOWED_RANGES  $byte_enable_range
                }
            } elseif {$byte_enable} {
                send_message    error   "Byte enable for port A is unavailable while the width of output bus is less than 16."
            }
			} else {
			set_parameter_property  GUI_BYTE_SIZE   ALLOWED_RANGES  {5 8 9 10}
			set_parameter_property GUI_BYTE_SIZE   ENABLED false
			}
            # RDWM for M10K #
            if {$ram_block_type eq "M10K"} {
                set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "1: New Data"}
                if {!$x_mask && ($rdwm_port_a ==1) } {
                    send_message    error   "\'X MASKs\' of q output should be checked while using \'NEW DATA\' for $ram_block_type memory block type."
                }
            } elseif {$ram_block_type eq "Auto"} {
            	     if {!$x_mask && ($rdwm_port_a ==1) } {
            	         send_message    error   "\'X MASKs\' of q output should be checked while using \'NEW DATA\' for $ram_block_type memory block type."
            	     }
            } elseif {$ram_block_type ne "Auto"} {    ;# for ram_block_type M9K and M144K: 0,1,2 are available #
                set_parameter_property  GUI_READ_DURING_WRITE_MODE_PORT_A   ALLOWED_RANGES  {"0: Don't Care" "1: New Data" "2: Old Data"}
            }
        }
    }
    # decide module type #
    if {[check_device_family_equivalence $device_family {"Arria 10" "Stratix 10"}]} {
        if {($implement_in_les ==0) && ($ram_block_type eq "LCs")} {
            set_parameter_value     GUI_MODULE_NAME     "LPM_RAM_DQ"
        } else {
            set_parameter_value     GUI_MODULE_NAME     "altera_syncram"
        }
    } elseif {[check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {
        set_parameter_value     GUI_MODULE_NAME     "LPM_RAM_DQ"
    }

    #group In-system memory content editor#
    if {!$jtag_enabled} {
        if {($jtag_id ne "NONE") && ($jtag_id ne "")} {
            send_message    error   "The \'instance ID\' of this RAM is only available when In-System Memory Content Editor is allowed."
        }
    }
	
	#Disable in-system memory content editor for Nadder #
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$jtag_enabled eq "true"} {
			send_message	error	"In-System Memory Content Editor is unavailable for device family $device_family."
		}
	}
	
    # file initialization #
    set file_exist  [file exists $miffilename]
    if {!$blankmemory} {
        if {$miffilename ne ""} {
            send_message    error   "Can't use this file for initializing when initialization method chosen to be \'leave it blank\'."
        }
        if {$init_file_layout ne "PORT_A"} {
            send_message    error   "Can't use file initialization while initialization mode chosen to be \'leave it blank\'. Please reset to default:\'PORT_A\'."
        }
    } else {
		if {$miffilename eq ""} {
			send_message    warning   "Initialization data file containing the initial memory content must be specified."
		}
        if {$miffilename ne "" && ![string match "*.mif" $miffilename] && ![string match "*.hex" $miffilename]} {
            send_message    error   "Initialization data file [file tail $miffilename] should be MIF or HEX file."
        }
        if {$init_file_layout ne "PORT_A"} {
            send_message    error   "Only \'PORT_A\' is available for initial file conformation. Please reset to default: \'PORT_A\'."
        }
        if {$init_to_sim_x} {
            send_message    error   "Initialize to XX.XX is unavailable while using file initialization mode."
        }
    }
    # clken #
    if {$clken} {
        if {!($clken_in || $clken_out)} {
            send_message    error   "Please choose use clock enable for port A input registers, output registers or both."
        }
    }
	
	#RULE7.3(E)(ND): SP only support dont_care for RDW_Port_A #
	if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
		if {$rdwm_port_a == 1} {
			if {$ram_block_type eq "M20K"} {
				send_message	error	 "For Stratix 10, single port only support \'Dont care\' or \'Old Data\' for Read During Write Port A while using M20K memory block type."
			} else {
				if {$ram_block_type ne "LCs"} {
					send_message	error	 "For Stratix 10, single port only support \'Dont care\' for Read During Write Port A."
				}
			}
		}
	}
	
	
	#Sclr specific#
	if {$sclr_q eq "true"} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"Synchronous clear feature only support for Stratix 10."
		}
	}
	
	#Aclr and Sclr cannot chose concurrently#
	if {$aclr_q eq "true" && $sclr_q eq "true"} {
		send_message	error	"Only asynchronous clear option or synchronous clear option can be chose at one time."
	}


	#force to zero#
	if {$force_to_zero eq "true"} {
		if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
			send_message	error	"Force-to-Zero feature only support for Stratix 10."  ; #rule12.1#
		}
		if {$ram_block_type ne "M20K"} {
			send_message	error	"Force-to-Zero feature only support M20K ram block type." ;#rule12.2#
		}
	}
	
    # add ports: clock/clken/inclock/outclock/inclocken/outclocken/aclr/outaclr #
    if {$singleclock==0} {
        add_interface_port   ram_input  clock   clk input   1
        if {$clken_in} {
            add_interface_port  ram_input   clken clken  input 1
        } elseif {$clken_out} {
            if {$regoutput} {
                add_interface_port  ram_input   clken   clken input 1
            } else {
                send_message    error  "Can't add port \'clken\' while \'q\' output port not added."
            }
        }
        # add port: aclrs#
        if {$aclr_q} {
            if {$ram_block_type eq "MLAB"} {
                if {$regoutput} {
                    add_interface_port  ram_input   aclr    aclr    input   1
                } else {
                    send_message    error   "Lutram cannot have output clear when output unregistered"
                }
            } else {
                add_interface_port  ram_input   aclr    aclr    input   1
            }
        }
	# add port: sclrs#
        if {$sclr_q} {
            if {$ram_block_type eq "MLAB"} {
                if {$regoutput} {
                    add_interface_port  ram_input   sclr    sclr    input   1
                } else {
                    send_message    error   "Lutram cannot have output clear when output unregistered"
                }
            } else {
                add_interface_port  ram_input   sclr    sclr    input   1
            }
        }
    } else {
        if {$regdata || $regaddr} {
            add_interface_port   ram_input  inclock  clk_in  input  1
        }
        if {$regoutput} {
            add_interface_port   ram_output  outclock clk_out input  1
            if {$clken_out}  {
                add_interface_port  ram_output  outclocken  clken_out  input  1
            }
            if {$clken_in} {
                add_interface_port  ram_input   inclocken   clken_in   input  1
            }
        } else {
            if {$clken_in} {
                add_interface_port  ram_input  inclocken    clken_in input 1
            }
            if { $clken_out} {
                send_message    error   "Can't add port \'outclocken\' while \'q\' output port not added."
            }
        }
        # add port: outaclr#
        if {$aclr_q} {
            if {$ram_block_type eq "MLAB"} {
                if {$regoutput} {
                    add_interface_port  ram_input   outaclr    outaclr    input   1
                } else {
                    send_message    error   " Lutram cannot have output clear when output unregistered"
                }
            } else {
                add_interface_port  ram_input   outaclr    outaclr    input   1
            }
        }
	# add port: outsclr#
        if {$sclr_q} {
            if {$ram_block_type eq "MLAB"} {
                if {$regoutput} {
                    add_interface_port  ram_input   sclr    sclr    input   1
                } else {
                    send_message    error   " Lutram cannot have output clear when output unregistered"
                }
            } else {
                add_interface_port  ram_input   sclr    sclr    input   1
            }
        }
        # dual clock without reg_q #
        if {![check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {
            if {$jtag_enabled && $regoutput && ($ram_block_type ne "LCs") && ($ram_block_type ne "MLAB")} {
                send_message    error   "\'System Memory Content Editor\' is unavailable while \'q\' output port is registered."
            }
        }
    }

    # add port: addressstall_a #
    if {$addressstall_a} {
        add_interface_port  ram_input   addressstall_a  addressstall_a  input   1
    }
    # add port: rden #
    if {$rden} {
        add_interface_port  ram_input   rden    rden    input   1
    }

  # gui rules for all device families #
    # 'data' and 'wren' ports registerd #
    if {![check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {
        if {!$regdata} {
            send_message    error   "\'data\' and \'wren\' input ports should be registered in Single-port RAM."
        }
        if {!$regaddr} {
            send_message    error   "\'address\' input port should be registered in Single-port RAM."
        }
    }

    # Read during write option #
    if {$rdwm_port_a == 0} {
        if {$x_mask} {
            send_message    error   "Can't use x masks while the q output is \'Don't Care\'."
        }
    } elseif {$rdwm_port_a == 2} {
        if {$x_mask} {
            send_message    error   "Can't use x masks while the q output is \'Old Data\'."
        }
    }
    # aclr ports : data byte addr #
    if {$aclr_d} {
        send_message    error   "\'data\' port can't be affected by the \'aclr\' port in Single-port RAM."
    }
    if {$aclr_w} {
        send_message    error   "\'wren\' port can't be affected by the \'aclr\' port in Single-port RAM."
    }
    if {$aclr_a} {
        send_message    error   "\'address\' port can't be affected by the \'aclr\' port in Single-port RAM."
    }
    if {$aclr_b} {
        send_message    error   "\'byteena_a\' port can't be affected by the \'aclr\' port in Single-port RAM."
    }


    # byteena port #
    set_parameter_value     GUI_BYTE_WIDTH  1
    set width_byte  [expr   $width_a/$byte_size]
    if {![check_device_family_equivalence $device_family {"MAX II" "MAX V"}] && ($ram_block_type ne "LCs")} {
        if {[expr $width_a  % $byte_size]== 0 && ($width_a >= 10)} {
            set_parameter_value     GUI_BYTE_WIDTH  $width_byte
            if {$byte_enable} {
                add_interface_port  ram_input   byteena     byte_enable input   $width_byte
            }
        }
    }

 #Resource Estimation#
    set m20k_2k_size   2048
    set m20k_16k_size  16384
    set mlab_width     20
    set mlab_depth     32
    set m20k_size      20480
    set mlab_size      640
    #set width_a        [get_parameter_value    GUI_QA_WIDTH]
   # set numwords_a     [get_parameter_value    GUI_MEMSIZE_WORDS]
    set max_depth      [get_parameter_value    GUI_MAXIMUM_DEPTH]
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
        } else {
	    set total_num_usage "-"
	}
    } 
	set_parameter_value  GUI_RESOURCE_USAGE   $total_num_usage
   #end of resource estimation#


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
                set param_lower         "device_family"
            } else {
                set param_lower         [string range [string tolower  $param] 4 end]
            }
            set params($param_lower)    [get_parameter_value    $param]
        }
        if {$params(miffilename) eq ""} {
			if {$params(blankmemory)==1} {
            set params(miffilename)    "STRING"
			send_message    error   "Generation is not complete if you did not specify a file containing the initial memory content."
			}
		} elseif {$params(file_reference)==1} {
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

proc    params_to_wrapper_data_tb  {terp_path_tb output_name}  {
 
        # get hw.tcl ip parameters #
        set param_list      [get_parameters]
        foreach param  $param_list  {
            if {$param eq "DEVICE_FAMILY"} {
                set param_lower         "device_family"
            } else {
                set param_lower         [string range [string tolower  $param] 4 end]
            }
            set params($param_lower)    [get_parameter_value    $param]
        }
        if {$params(miffilename) eq ""} {
			if {$params(blankmemory)==1} {
            set params(miffilename)    "STRING"
			send_message    error   "Generation is not complete if you did not specify a file containing the initial memory content."
			}
		} elseif {$params(file_reference)==1} {
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
