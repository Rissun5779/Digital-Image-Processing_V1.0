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
# | $Header: //acds/rel/18.1std/ip/altera_parallel_flash_loader/altera_parallel_flash_loader_common.tcl#1 $
# | 
# +-----------------------------------


set	NAND_BOUNDARY	[expr 0x20000]
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

# Calculates PFL address width for CFI and NAND Flash
proc calculate_pfl_addr_width {flash_device		pfl_flash_data_width} {
	set	pfl_addr_width				[get_value_based_on_row_value	"PARALLEL_FLASH_LOADER_FLASH_DEVICE_TABLE"		$flash_device		"address_width"]
	set	data_width_is_eigth			[expr {$pfl_flash_data_width == 8}]
	set	data_width_is_thirtytwo		[expr {$pfl_flash_data_width == 32}]
	
	set	pfl_addr_width				[expr $pfl_addr_width + $data_width_is_eigth - $data_width_is_thirtytwo]

	return	$pfl_addr_width
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
	set result	[expr	ceil(log($value) / log(2))]
	
	return $result
}


# +-----------------------------------
# | NAND flash interface
# +-----------------------------------

# Calculate how much size should be reserved for NAND flash
proc calculate_nand_reserved_size {size} {
	global	NAND_BOUNDARY
	set reserved_size	[expr $size / 100 * 2]
	set remaining		[expr $reserved_size % $NAND_BOUNDARY]
	
	if {$remaining != 0}	{
		set reserved_size	[expr $reserved_size + $NAND_BOUNDARY - $remaining]
	}
	
	return $reserved_size
}

# Calculate guarded size for NAND flash
proc calculate_nand_guarded_size {size} {
	set guarded_size [calculate_nand_reserved_size $size]
	set guarded_size [expr	{$size - $guarded_size}]
	
	return $guarded_size
}


# +-----------------------------------
# | FPGA Configuration
# +-----------------------------------

# Calculate DCLK after considering the ratio
proc calculate_dclk {}	{
	set dclk_value			[expr {double(0)}]
	set	divisor_value		[get_parameter_value	dclk_divisor_combo]
	set clk_freq			[get_parameter_value	clock_frequency]

	if {$divisor_value == 1 ||
			$divisor_value == 2 ||
			$divisor_value == 4 ||
			$divisor_value == 8} {
		set dclk_value [expr {double($clk_freq / $divisor_value)}]
	}
	
	return $dclk_value
}

# Updates enhanced bitstream-decompression mode
proc update_decompression_control {} {
	set	decompression_count			3
	set	selection_string			[string toupper				[get_parameter_value		decompressor_combo]]
	
	set fpga_conf_scheme			[get_parameter_value		fpga_conf_scheme_combo]
	
	if { [string match -nocase $fpga_conf_scheme "PS (passive serial)"] == 1 } {
		set	decompression_count		2
	}
	
	if { $decompression_count == 1} {
		set_parameter_property		decompressor_combo		ENABLED			0
	} else {
		set_parameter_property		decompressor_combo		ENABLED			1
	}
	
	list $decompression_count	$selection_string
}