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
# | $Header: //acds/rel/18.1std/ip/pgm/altera_parallel_flash_loader_2/altera_parallel_flash_loader_2/altera_parallel_flash_loader_2_msgs.tcl#1 $
# | 
# +-----------------------------------

source altera_parallel_flash_loader_2_common.tcl

# --- Message definition --- #
set	PFL_OPTION_BIT_ADDRESS_ERROR_MSG			"Option bit address must fall on an 8K byte address boundary"
set	PFL_OPTION_BIT_ADDRESS_RANGE_ERROR_MSG		"Option bit address must fall within the flash address boundary"
set	PFL_FAILURE_RETRY_ADDRESS_ERROR_MSG			"Failure retry address must fall on an 8K byte address boundary"
set	PFL_FAILURE_RETRY_ADDRESS_RANGE_ERROR_MSG	"Failure retry address must fall within the flash address boundary"
set	PFL_FAILURE_FREQ_1_ERROR_MSG				"Clock frequency must be less than 125 MHz "
set	PFL_FAILURE_NO_FREQ_ERROR_MSG				"External clock frequency must not equal to 0 MHz "	set PFL_CFI_FLASH "CFI Parallel Flash"

# +-----------------------------------
# | FPGA Configuration Error Checking
# +-----------------------------------
proc check_for_fpga_conf_error {pfl_flash_data_width	pfl_address_width	pfl_num_flash	pfl_qflash_byte_size	operating_modes_cfg} {
	global	PFL_CFI_FLASH
	global	PFL_NAND_FLASH
	global	PFL_OPTION_BIT_ADDRESS_ERROR_MSG
	global	PFL_OPTION_BIT_ADDRESS_RANGE_ERROR_MSG
	global	PFL_FAILURE_RETRY_ADDRESS_ERROR_MSG
	global	PFL_FAILURE_RETRY_ADDRESS_RANGE_ERROR_MSG
	global	PFL_FAILURE_FREQ_1_ERROR_MSG
	global	PFL_FAILURE_NO_FREQ_ERROR_MSG
	
	set	status					"true"
	set	address_padding			0
	set	mask					[expr	0x1FFF]
	
	set TARGETTED_FLASH			[get_parameter_value 		flash_type_ui]
	set	option_bit_addr			[get_parameter_value		option_bit_address]
	set	safe_mode_revert_addr	[get_parameter_value		SAFE_MODE_REVERT_ADDR]
	set	clk_freq				[get_parameter_value		clock_frequency]
	
	if { ([string match -nocase $TARGETTED_FLASH $PFL_CFI_FLASH] == 1) } {
		if { $pfl_flash_data_width == 16 } {
			set	address_padding		1
		} elseif { $pfl_flash_data_width == 32 } {
			set	address_padding		2
		}
	}

	if { [expr	{$option_bit_addr & $mask}] != 0 } {
		# 13 LSBs must be 0
		send_message ERROR $PFL_OPTION_BIT_ADDRESS_ERROR_MSG
		set	status	"false"
	}

	if { ([string match -nocase $TARGETTED_FLASH $PFL_CFI_FLASH] == 1) || 
			([string match -nocase $TARGETTED_FLASH $PFL_NAND_FLASH] == 1) } {
		if { ($status eq "true") && ($option_bit_addr >= [expr	int(1 << ($pfl_address_width + $address_padding))]) } {
			# option bit address exceeds selected flash capacity
			send_message ERROR $PFL_OPTION_BIT_ADDRESS_RANGE_ERROR_MSG
			set	status	"false"	
		}
		
		if { ($status eq "true") && ($safe_mode_revert_addr >= [expr	int(1 << ($pfl_address_width + $address_padding))]) } {
			# safe mode revert address exceeds selected flash capacity
			send_message ERROR $PFL_FAILURE_RETRY_ADDRESS_RANGE_ERROR_MSG
			set	status	"false"	
		}
	} else {
		if { ($status eq "true") && ($option_bit_addr >= [expr	int($pfl_num_flash * $pfl_qflash_byte_size)]) } {
			# option bit address exceeds selected flash capacity
			send_message ERROR $PFL_OPTION_BIT_ADDRESS_RANGE_ERROR_MSG
			set	status	"false"	
		}		
		
		if { ($status eq "true") && ($safe_mode_revert_addr >= [expr	int($pfl_num_flash * $pfl_qflash_byte_size)]) } {
			# safe mode revert address exceeds selected flash capacity
			send_message ERROR $PFL_FAILURE_RETRY_ADDRESS_RANGE_ERROR_MSG
			set	status	"false"	
		}		
	}
	
	if { ($status eq "true") && ([expr	{$option_bit_addr & $mask}] != 0) } {
		# 13 LSBs must be 0
		send_message ERROR $PFL_OPTION_BIT_ADDRESS_ERROR_MSG
		set	status	"false"
	}
	
	if { ($status eq "true") && ([expr	{$safe_mode_revert_addr & $mask}] != 0) } {
		# 13 LSBs must be 0
		send_message ERROR $PFL_FAILURE_RETRY_ADDRESS_ERROR_MSG
		set	status	"false"
	}
	
	if { $operating_modes_cfg == 1 } {
		
		if { $clk_freq <= 0 } {
			send_message ERROR $PFL_FAILURE_NO_FREQ_ERROR_MSG
			set	status	"false"
		}
	}
}
