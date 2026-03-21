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
# | $Header: //acds/rel/18.1std/ip/altera_parallel_flash_loader/altera_parallel_flash_loader_hw_proc.tcl#1 $
# | 
# +-----------------------------------


# +-----------------------------------
# | Set UI Interface during elaboration callback
# +-----------------------------------
proc elaboration {}		{

	# --- update ports in block diagram with regards to parameter changes --- #
	general_parameters_procedure port_settings
	
}

# +-----------------------------------
# | Callback function when generating variation file
# +-----------------------------------
proc generate_synth {entityname} {

	send_message info "generating top-level entity $entityname"
    
    # --- update ports in top level file via terp with regards to parameter changes --- #
    general_parameters_procedure rtl_file_gen

}