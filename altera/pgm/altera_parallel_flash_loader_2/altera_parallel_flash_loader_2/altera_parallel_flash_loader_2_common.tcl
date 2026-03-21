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


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/pgm/altera_parallel_flash_loader_2/altera_parallel_flash_loader_2/altera_parallel_flash_loader_2_common.tcl#2 $
# | 
# +-----------------------------------



set	PFL_CFI_FLASH	"CFI Parallel Flash"
set	PFL_ASC_FLASH	"Altera Active Serial x4"
set	PFL_QSPI_FLASH	"Quad SPI Flash"
set	PFL_NAND_FLASH	"NAND Flash"


# +-----------------------------------
# | General procedures
# +-----------------------------------

# Get quartus_ini and sets the default value if INI not present
proc get_quartus_ini_string	{ini_setting	default} {
	set	ini_string 					[get_quartus_ini				$ini_setting		STRING]
	if	{ $ini_string eq "" } {
		set	ini_string					$default
	}
	
	return $ini_string
}

# Set HDL parameters with regards to parameter settings
proc set_hdl_parameters {parameter	value} {
	set_parameter_property		$parameter		HDL_PARAMETER		TRUE
	set_parameter_value			$parameter		$value
}

# Calculates PFL address width for CFI proc calculate_pfl_addr_width {flash_device		pfl_flash_data_width} {if { [regexp {([\d]+).([MG]bit)} $flash_device full flash_density unit] } {        if { $unit =="Mbit" } {            set  flash_density  [expr  $flash_density * 1024 * 1024]        } elseif { $unit =="Gbit" } {            set  flash_density [expr $flash_density * 1024 * 1024 * 1024]        }    }	set	pfl_addr_width		[log2	[expr {$flash_density / $pfl_flash_data_width}]]	return	[expr int($pfl_addr_width)]}
proc calculate_qspi_addr_width {flash_device    num_flash} {
set  total_flash_density 0
set pfl_flash_data_width 0
if {$num_flash == 1} {
    set pfl_flash_data_width 8
} else {
    set pfl_flash_data_width 8
}
if { [regexp {([\d]+).([MG]bit)} $flash_device full flash_density unit] } {
        if { $unit =="Mbit" } {
            set  total_flash_density  [expr  $flash_density * 1024 * 1024]
        } elseif { $unit =="Gbit" } {
            set  total_flash_density [expr $flash_density * 1024 * 1024 * 1024]
        }
    }
    set total_flash_density   [expr $total_flash_density * $num_flash]
    send_message debug " total_flash_density : $total_flash_density"
	set pfl_addr_width  [log2	[expr {$total_flash_density / $pfl_flash_data_width}]]
    send_message debug " pfl_addr_width : $pfl_addr_width"
	return	[expr int($pfl_addr_width)]
}
proc get_byte_flash_density {flash_device} {
    if { [regexp {([\d]+).([MG]bit)} $flash_device full flash_density unit] } {
            if { $unit =="Mbit" } {
                set  flash_density  [expr  $flash_density * 1024 * 1024]
            } elseif { $unit =="Gbit" } {
                set  flash_density [expr $flash_density * 1024 * 1024 * 1024]
            }
        }
        set byte_flash_density [expr {$flash_density /8}]
    	return	[expr int($byte_flash_density)]
}

# Ensure that value is at least one
proc return_at_least_one {arg} {
	if { $arg <= 0 } {
		set		arg		1
	}
	return $arg
}

# Logarithm base 2 function
proc log2 {value}	{
	set result	[expr	int(log($value) / log(2))]
	
	return $result
}
# +-----------------------------------# | Procedure for ports creation# +-----------------------------------proc my_add_interface_port {port_type megafunction_port_name module_port_name port_width port_gen} {		if {$port_gen eq "true"} {		if {$port_type eq "in"} {			add_interface $megafunction_port_name conduit end			add_interface_port $megafunction_port_name $megafunction_port_name $module_port_name Input $port_width		} elseif {$port_type eq "out"} {			add_interface $megafunction_port_name conduit start			set_interface_assignment $megafunction_port_name "ui.blockdiagram.direction" OUTPUT			add_interface_port $megafunction_port_name $megafunction_port_name $module_port_name Output $port_width		} elseif {$port_type eq "bidir"} {			add_interface $megafunction_port_name conduit start			set_interface_assignment $megafunction_port_name "ui.blockdiagram.direction" OUTPUT			add_interface_port $megafunction_port_name $megafunction_port_name $module_port_name Bidir $port_width		} else {			send_message error "Illegal port type"		}	}}