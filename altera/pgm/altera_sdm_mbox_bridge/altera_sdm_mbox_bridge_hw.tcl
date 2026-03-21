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

# module properties
set_module_property NAME {altera_sdm_mbox_bridge}
set_module_property DISPLAY_NAME {Altera SDM Mbox Bridge}

# default module properties
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property DESCRIPTION {default description}
set_module_property AUTHOR {author}
set all_supported_device_families_list {"Stratix 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES       $all_supported_device_families_list

set_module_property COMPOSITION_CALLBACK compose
set_module_property opaque_address_map false

# +-----------------------------------
# | parameters
# | 
add_parameter SETTINGS string ""
set_parameter_property SETTINGS DISPLAY_NAME "TCL encoding of the connected slave"
set_parameter_property SETTINGS UNITS None
set_parameter_property SETTINGS DESCRIPTION "The debug connection transform will set this up for you"
set_parameter_property SETTINGS DISPLAY_HINT "rows:5"
set_parameter_property SETTINGS AFFECTS_GENERATION true
set_parameter_property SETTINGS HDL_PARAMETER false
set_parameter_property SETTINGS STATUS experimental

# testing
#add_interface master_0 avalon end

proc compose { } {
    # Instances and instance parameters
    # (disabled instances are intentionally culled)
    # Add in internal oscilator for and export the clock to feed the mbox fabric
    add_instance int_osc altera_s10_configuration_clock 18.1
    # Clock bridge to connect to sub component
    add_instance clock altera_clock_bridge 18.1
    set_instance_parameter_value clock {EXPLICIT_CLOCK_RATE} {0.0}
    set_instance_parameter_value clock {NUM_CLOCK_OUTPUTS} {1}
    # Clock bridge to export to output 
    add_instance clk_bridge_out altera_clock_bridge 18.1
    set_instance_parameter_value clk_bridge_out {EXPLICIT_CLOCK_RATE} {0.0}
    set_instance_parameter_value clk_bridge_out {NUM_CLOCK_OUTPUTS} {1}

    # Rest signal
    add_instance sdm_fpga_reset altera_sdm_fpga_core_rst 18.1

    add_instance sdm_axi_fpga2sdm_0 altera_sdm_axi_fpga2sdm 18.1

    add_instance sdm_axi_sdm2fpga_0 altera_sdm_axi_sdm2fpga 18.1

    add_instance sdm_gpi_0 altera_sdm_gpi 18.1
    set_instance_parameter_value sdm_gpi_0 {WIDTH} {4}

    add_instance sdm_gpo_0 altera_sdm_gpo 18.1
    set_instance_parameter_value sdm_gpo_0 {WIDTH} {9}


    add_instance sdm_gpio_irq_0 altera_sdm_gpio_irq 18.1
    set_instance_parameter_value sdm_gpio_irq_0 {WIDTH} {1}

    
    add_instance reset altera_reset_bridge 18.1
    set_instance_parameter_value reset {ACTIVE_LOW_RESET} {0}
    set_instance_parameter_value reset {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value reset {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value reset {USE_RESET_REQUEST} {0}

    # Export Reset signal
    add_instance reset_ex altera_reset_bridge 18.1
    set_instance_parameter_value reset_ex {ACTIVE_LOW_RESET} {0}
    set_instance_parameter_value reset_ex {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value reset_ex {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value reset_ex {USE_RESET_REQUEST} {0}


# testing
    #add_instance dummy_master_inst dummy_master 1.0
    #add_connection clock.out_clk dummy_master_inst.clock clock
    #add_connection reset.out_reset dummy_master_inst.reset reset
    #set_interface_property master_0 EXPORT_OF dummy_master_inst.master_0

    # connections and connection parameters
    add_connection clock.out_clk reset.clk clock

    add_connection reset.out_reset sdm_axi_fpga2sdm_0.reset reset

    add_connection reset.out_reset sdm_axi_sdm2fpga_0.reset reset

    add_connection clock.out_clk sdm_axi_sdm2fpga_0.clock clock

    add_connection clock.out_clk sdm_axi_fpga2sdm_0.clock clock

    # exported interfaces
    #add_interface clk clock sink
    #set_interface_property clk EXPORT_OF clock.in_clk
    
    #add_interface clk_in clock sink
    #set_interface_property clk_in EXPORT_OF clock.in_clk
    
    # Export clock out with name clk_0
    add_interface clk_0 clock source
    #set_interface_property clk_0 EXPORT_OF clock.in_clk
    add_connection int_osc.clkout clock.in_clk clock
    add_connection int_osc.clkout clk_bridge_out.in_clk clock
    set_interface_property clk_0 EXPORT_OF clk_bridge_out.out_clk

    # Connect reset
    add_connection sdm_fpga_reset.out_reset reset.in_reset reset
    
    add_interface reset_0 reset source
    set_interface_property reset_0 EXPORT_OF reset_ex.out_reset
    add_connection clock.out_clk reset_ex.clk clock
    add_connection sdm_fpga_reset.out_reset reset_ex.in_reset reset


    #add_interface fpga2sdm axi4 end
    #set_interface_property fpga2sdm EXPORT_OF sdm_axi_fpga2sdm_0.axi_slave
    
    add_interface axi_master_0 axi4 end
    set_interface_property axi_master_0 EXPORT_OF sdm_axi_fpga2sdm_0.axi_slave
    # Declare it to be master to match with the mbox fabric hub, but it is slave
    #add_interface master_0 axi4 end
    #set_interface_property master_0 EXPORT_OF sdm_axi_fpga2sdm_0.axi_slave

    #add_interface sdm2fpga axi4 start
    #set_interface_property sdm2fpga EXPORT_OF sdm_axi_sdm2fpga_0.axi_master
    add_interface axi_slave_0 axi4 start
    set_interface_property axi_slave_0 EXPORT_OF sdm_axi_sdm2fpga_0.axi_master

    #add_interface sdm_gpi conduit end
    #set_interface_property sdm_gpi EXPORT_OF sdm_gpi_0.gpi
    
    add_interface sdm_gpi_0 conduit end
    set_interface_property sdm_gpi_0 EXPORT_OF sdm_gpi_0.gpi

    #add_interface sdm_gpo conduit end
    #set_interface_property sdm_gpo EXPORT_OF sdm_gpo_0.gpo
    add_interface sdm_gpo_0 conduit end
    set_interface_property sdm_gpo_0 EXPORT_OF sdm_gpo_0.gpo

    #add_interface sdm_irq interrupt receiver
    add_interface sdm_gpi_irq_0 conduit end
    set_interface_property sdm_gpi_irq_0 EXPORT_OF sdm_gpio_irq_0.irq
}
