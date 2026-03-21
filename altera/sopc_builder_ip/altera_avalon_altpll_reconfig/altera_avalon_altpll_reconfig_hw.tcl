# +---------------------------------------------------------
# | 
# | Name: altera_avalon_altpll_reconfig_hw.tcl
# | 
# | Description: _hw.tcl file for the Avalon bus-compatible 
# | 		 Altera PLL RECONFIG module
# | 
# | Version: 1.0
# |
# +---------------------------------------------------------

package require -exact sopc 9.0

# +---------------------------------------------------------
# |
# | NOTE: This section has to be in this file (and not in the
# | 	  common code) as it seems that the SOPC builder checks
# |	  for this section to see it should bother with the rest
# |	  of this script
# | 

set_module_property DESCRIPTION "Avalon-compatible PLL RECONFIG Intel FPGA IP. For Stratix V and newer families, use PLL RECONFIG Intel FPGA IP"
set_module_property NAME altpll_reconfig
set_module_property VERSION 18.1
set_module_property GROUP "Basic Functions/Clocks; PLLs and Resets/PLL"
set_module_property INTERNAL false
set_module_property HIDE_FROM_QSYS false
set_module_property HIDE_FROM_QUARTUS true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "ALTPLL RECONFIG Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property SIMULATION_MODEL_IN_VERILOG true  
set_module_property SUPPORTED_DEVICE_FAMILIES {"Max 10"}
# | 
# +---------------------------------------------------------

# +---------------------------------------------------------
# | Set the component-specific constants
# | _hw_tcl file.
# |

set WIZARD_NAME "ALTPLL_RECONFIG"

# |
# +---------------------------------------------------------

# +---------------------------------------------------------
# | Include the common code for the Altera megafunction
# | _hw_tcl file.
# |
# | Note: The sourcing should come AFTER the above
# |	  module property setting section. If SOPC
# | 	  builder does not see the above section
# |	  in the *_hw.tcl script, it does not continue
# |       to run it at all.
# |

source "../altera_avalon_mega_common/sopc_mwizc.tcl"

#List out all the parameters from the wizard (GUI) that hw tcl needs
set MF_EXPOSED_PARAMETERS [ list	\
	INTENDED_DEVICE_FAMILY	\
        INIT_FROM_EXTERNAL_ROM_CHECKBOX_CHECKED \
       
]

# ============================================================
#		Custom (MF-specific) Routines
# ============================================================
proc get_exposed_mf_param_list { } {
	
	global MF_EXPOSED_PARAMETERS
	return $MF_EXPOSED_PARAMETERS
}

# Start the script run
# Add parameters
add_parameter HIDDEN_CUSTOM_ELABORATION STRING "altpll_avalon_elaboration" "CustomElaborationFunction"
add_parameter HIDDEN_CUSTOM_POST_EDIT STRING "altpll_avalon_post_edit" "CustomPostEditFunction"

# +---------------------------------------------------------
# |
# | Adding Connection Points
# |

add_interface clock clock sink
add_interface_port clock clock clk Input 1
add_interface_port clock reset reset Input 1

add_interface counter_param conduit end 
add_interface_port counter_param counter_param export Input 3

add_interface counter_type conduit end 
add_interface_port counter_type counter_type export Input 4

add_interface data_in conduit end 
add_interface_port data_in data_in export Input 9

add_interface pll_areset_in conduit end 
add_interface_port pll_areset_in pll_areset_in export Input 1

add_interface pll_scandataout conduit end 
add_interface_port pll_scandataout pll_scandataout export Input 1

add_interface pll_scandone conduit end 
add_interface_port pll_scandone pll_scandone export Input 1

add_interface read_param conduit end 
add_interface_port read_param read_param export Input 1

add_interface reconfig conduit end 
add_interface_port reconfig reconfig export Input 1

add_interface write_param conduit end 
add_interface_port write_param write_param export Input 1

add_interface write_param conduit end 
add_interface_port write_param write_param export Input 1

add_interface busy conduit end 
add_interface_port busy busy export Output 1

add_interface data_out conduit end 
add_interface_port data_out data_out export Output 9

add_interface pll_areset conduit end 
add_interface_port pll_areset pll_areset export Output 1

add_interface pll_configupdate conduit end 
add_interface_port pll_configupdate pll_configupdate export Output 1

add_interface pll_scanclk clock source 
add_interface_port pll_scanclk pll_scanclk "clk" Output 1

add_interface pll_scanclkena conduit end 
add_interface_port pll_scanclkena pll_scanclkena export Output 1

add_interface pll_scandata conduit end 
add_interface_port pll_scandata pll_scandata export Output 1

add_interface reset_rom_address conduit end
add_interface_port reset_rom_address reset_rom_address export Input 1

add_interface rom_data_in conduit end
add_interface_port rom_data_in rom_data_in export Input 1

add_interface write_from_rom conduit end
add_interface_port write_from_rom write_from_rom export Input 1

add_interface rom_address_out conduit end
add_interface_port rom_address_out rom_address_out export Output 8

add_interface write_rom_ena conduit end
add_interface_port write_rom_ena write_rom_ena export Output 1

# +---------------------------------------------------------

do_init  

# +---------------------------------------------------------
#
# The altpll_avalon_post_edit is a function called at 
# the end of the standard edit callback.  This function 
# looks for a parameter in the privates list and adds it to
# the constants list so that it is written out as a megafunction 
# parameter
#
# +---------------------------------------------------------
proc altpll_avalon_post_edit {} {
}

proc altpll_avalon_elaboration {} {

        set init_from_external_rom [get_parameter_value INIT_FROM_EXTERNAL_ROM_CHECKBOX_CHECKED]
        if {$init_from_external_rom == "YES"} {   
		set_interface_property reset_rom_address ENABLED true
		set_interface_property rom_data_in ENABLED true
		set_interface_property rom_address_out ENABLED true
		set_interface_property write_rom_ena ENABLED true
		set_interface_property write_from_rom ENABLED true
	} else {
		set_interface_property reset_rom_address ENABLED false
		set_interface_property rom_data_in ENABLED false
		set_interface_property rom_address_out ENABLED false
		set_interface_property write_rom_ena ENABLED false
		set_interface_property write_from_rom ENABLED false
	}

	#send_message info "init_from_external_rom=$init_from_external_rom\n"
	
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.altera.com/en_US/pdfs/literature/hb/max-10/ug_m10_clkpll.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
