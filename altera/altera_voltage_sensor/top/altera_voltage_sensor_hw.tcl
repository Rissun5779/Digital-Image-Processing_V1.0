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





# 
# altera_voltage_sensor "Altera Voltage Sensor core" v1.0
# Altera Corporation 2014.07.21.11:45:51
# Altera Modular ADC - Top Compose core
# 

# 
# request TCL package from ACDS 14.1
# 
package require -exact qsys 14.0


# 
# module altera_voltage_sensor
# 
set_module_property DESCRIPTION "Altera Voltage Sensor"
set_module_property NAME altera_voltage_sensor
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property HIDE_FROM_QUARTUS false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Voltage Sensor Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property COMPOSITION_CALLBACK do_compose
set supported_device_families_list {"Arria 10"}
set_module_property   SUPPORTED_DEVICE_FAMILIES  $supported_device_families_list


# Core Configuration
add_parameter               CORE_VAR INTEGER 0
set_parameter_property      CORE_VAR DISPLAY_NAME "Core Variant"
set_parameter_property      CORE_VAR UNITS None
set_parameter_property      CORE_VAR ALLOWED_RANGES { "0:Voltage controller with Avalon-MM sample storage" "1:Voltage controller with external sample storage"}
set_parameter_property      CORE_VAR AFFECTS_ELABORATION true
set_parameter_property      CORE_VAR AFFECTS_GENERATION true
set_parameter_property      CORE_VAR DERIVED false
set_parameter_property      CORE_VAR HDL_PARAMETER false
add_display_item "Controller Configuration"   CORE_VAR    PARAMETER

add_parameter               MEM_TYPE INTEGER 0
set_parameter_property      MEM_TYPE DISPLAY_NAME "Memory Type"
set_parameter_property      MEM_TYPE UNITS None
set_parameter_property      MEM_TYPE ALLOWED_RANGES { "0:On-chip Memory" "1:Register"}
set_parameter_property      MEM_TYPE AFFECTS_ELABORATION true
set_parameter_property      MEM_TYPE AFFECTS_GENERATION true
set_parameter_property      MEM_TYPE DERIVED false
set_parameter_property      MEM_TYPE HDL_PARAMETER true
add_display_item "Sample Storage Configuration"   MEM_TYPE    PARAMETER


proc add_splitter {{num_outputs 2}} {
    add_instance st_splitter_internal altera_avalon_st_splitter
    set_instance_parameter st_splitter_internal NUMBER_OF_OUTPUTS $num_outputs
    set_instance_parameter st_splitter_internal QUALIFY_VALID_OUT 0
    set_instance_parameter st_splitter_internal USE_READY 0
    set_instance_parameter st_splitter_internal USE_VALID 1
    set_instance_parameter st_splitter_internal USE_PACKETS 1
    set_instance_parameter st_splitter_internal USE_CHANNEL 1
    set_instance_parameter st_splitter_internal USE_ERROR 0
    set_instance_parameter st_splitter_internal USE_DATA 1
    set_instance_parameter st_splitter_internal DATA_WIDTH 12
    set_instance_parameter st_splitter_internal CHANNEL_WIDTH 5
    set_instance_parameter st_splitter_internal BITS_PER_SYMBOL 12
    set_instance_parameter st_splitter_internal MAX_CHANNELS 31
}

proc do_compose {} {


# ------------------------------------------------------------------------------
# Create internal clock and reset instance
# ------------------------------------------------------------------------------
add_instance cb_inst altera_clock_bridge

add_instance rst_inst altera_reset_bridge
set_instance_parameter_value rst_inst ACTIVE_LOW_RESET 0


# ------------------------------------------------------------------------------
# Compose sub component and assign parameters
# ------------------------------------------------------------------------------
set CORE_VAR [get_parameter_value CORE_VAR]
add_instance control_internal altera_voltage_sensor_control

switch $CORE_VAR {
    0 {
        add_instance sample_store_internal altera_voltage_sensor_sample_store
        set_instance_parameter sample_store_internal MEM_TYPE [ get_parameter_value MEM_TYPE ]
    }
    1 {

    }
}

# ------------------------------------------------------------------------------
# Declare interfaces and make connection
# ------------------------------------------------------------------------------

add_interface clock clock end
set_interface_property clock EXPORT_OF cb_inst.in_clk

add_interface reset_sink reset end
set_interface_property reset_sink EXPORT_OF rst_inst.in_reset

add_connection cb_inst.out_clk rst_inst.clk clock ""

switch $CORE_VAR {
    0 {
        add_interface controller_csr avalon end
        set_interface_property controller_csr EXPORT_OF control_internal.csr
        add_connection cb_inst.out_clk control_internal.clock clock ""
        add_connection rst_inst.out_reset control_internal.reset_sink

        add_interface sample_store_csr avalon end
        set_interface_property sample_store_csr EXPORT_OF sample_store_internal.csr
        add_interface sample_store_irq interrupt end
        set_interface_property sample_store_irq EXPORT_OF sample_store_internal.interrupt_sender
        add_connection cb_inst.out_clk sample_store_internal.clock clock ""
        add_connection rst_inst.out_reset sample_store_internal.reset_sink

        add_connection control_internal.response sample_store_internal.response
    }
    1 {
        add_interface controller_csr avalon end
        set_interface_property controller_csr EXPORT_OF control_internal.csr
        add_connection cb_inst.out_clk control_internal.clock clock ""
        add_connection rst_inst.out_reset control_internal.reset_sink

        add_interface response avalon_streaming start
        set_interface_property response EXPORT_OF control_internal.response

    }
}
}



## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/wtw1426059034681/wtw1425276826802
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
