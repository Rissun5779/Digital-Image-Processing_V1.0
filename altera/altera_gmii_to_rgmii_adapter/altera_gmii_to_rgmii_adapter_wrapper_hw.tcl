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

# 
# Wrapper for altera_gmii_to_rgmii_adapter
# 
set_module_property DESCRIPTION "HPS GMII to RGMII Converter"
set_module_property NAME altera_gmii_to_rgmii_adapter
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Processors and Peripherals/Hard Processor Components"
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "HPS GMII to RGMII Converter Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property COMPOSITION_CALLBACK compose
set_module_property supported_device_families {{Stratix 10} {Arria 10} {Arria V} {Cyclone V}}


# 
# parameters
# 
add_parameter TX_PIPELINE_DEPTH INTEGER 0 ""
set_parameter_property TX_PIPELINE_DEPTH DEFAULT_VALUE 0
set_parameter_property TX_PIPELINE_DEPTH DISPLAY_NAME TX_PIPELINE_DEPTH
set_parameter_property TX_PIPELINE_DEPTH TYPE INTEGER
set_parameter_property TX_PIPELINE_DEPTH ALLOWED_RANGES {"0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
set_parameter_property TX_PIPELINE_DEPTH DESCRIPTION "Number of register stage between HPS transmit output and FPGA I/O buffer"
set_parameter_property TX_PIPELINE_DEPTH HDL_PARAMETER true

add_parameter RX_PIPELINE_DEPTH INTEGER 0 ""
set_parameter_property RX_PIPELINE_DEPTH DEFAULT_VALUE 0
set_parameter_property RX_PIPELINE_DEPTH DISPLAY_NAME RX_PIPELINE_DEPTH
set_parameter_property RX_PIPELINE_DEPTH TYPE INTEGER
set_parameter_property RX_PIPELINE_DEPTH ALLOWED_RANGES {"0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
set_parameter_property RX_PIPELINE_DEPTH DESCRIPTION "Number of register stage between FPGA I/O buffer and HPS receive input"
set_parameter_property RX_PIPELINE_DEPTH HDL_PARAMETER true


add_parameter DEVICE_FAMILY STRING ""
set_parameter_property DEVICE_FAMILY SYSTEM_INFO "DEVICE_FAMILY"
set_parameter_property DEVICE_FAMILY VISIBLE false


proc is_arriav_cyclonev {parameter} {
    if {[get_parameter_value $parameter] == "Arria V"} {
        return 1
    } elseif {[get_parameter_value $parameter] == "Cyclone V"} {
        return 1
    } else {
        return 0
    }
}

proc compose {} {
    
    set TX_PIPELINE_DEPTH [get_parameter_value TX_PIPELINE_DEPTH] 
    set RX_PIPELINE_DEPTH [get_parameter_value RX_PIPELINE_DEPTH]

    add_instance u_altera_gmii_to_rgmii_adapter_core altera_gmii_to_rgmii_adapter_core
    set_instance_parameter u_altera_gmii_to_rgmii_adapter_core TX_PIPELINE_DEPTH $TX_PIPELINE_DEPTH
    set_instance_parameter u_altera_gmii_to_rgmii_adapter_core RX_PIPELINE_DEPTH $RX_PIPELINE_DEPTH

    
    add_interface peri_clock clock end
    set_interface_property peri_clock EXPORT_OF u_altera_gmii_to_rgmii_adapter_core.peri_clock

    add_interface peri_reset reset end
    set_interface_property peri_reset EXPORT_OF u_altera_gmii_to_rgmii_adapter_core.peri_reset
    
    add_interface hps_gmii conduit end
    set_interface_property hps_gmii EXPORT_OF u_altera_gmii_to_rgmii_adapter_core.hps_gmii
    
    add_interface phy_rgmii conduit end
    set_interface_property phy_rgmii EXPORT_OF u_altera_gmii_to_rgmii_adapter_core.phy_rgmii
    
    add_interface pll_25m_clock clock end
    set_interface_property pll_25m_clock EXPORT_OF u_altera_gmii_to_rgmii_adapter_core.pll_25m_clock
    
    add_interface pll_2_5m_clock clock end
    set_interface_property pll_2_5m_clock EXPORT_OF u_altera_gmii_to_rgmii_adapter_core.pll_2_5m_clock



    if { [is_arriav_cyclonev DEVICE_FAMILY] } {

    } else {
        add_instance rgmii_in4 altera_gpio
        set_instance_parameter rgmii_in4 SIZE 4
        set_instance_parameter rgmii_in4 PIN_TYPE_GUI "Input"
        set_instance_parameter rgmii_in4 gui_io_reg_mode "DDIO"
   
        add_instance rgmii_in1 altera_gpio
        set_instance_parameter rgmii_in1 SIZE 1
        set_instance_parameter rgmii_in1 PIN_TYPE_GUI "Input"
        set_instance_parameter rgmii_in1 gui_io_reg_mode "DDIO"
   
        add_instance rgmii_out4 altera_gpio
        set_instance_parameter rgmii_out4 SIZE 4
        set_instance_parameter rgmii_out4 PIN_TYPE_GUI "Output"
        set_instance_parameter rgmii_out4 gui_io_reg_mode "DDIO"
        set_instance_parameter rgmii_out4 gui_areset_mode "Clear"
   
        add_instance rgmii_out1 altera_gpio
        set_instance_parameter rgmii_out1 SIZE 1
        set_instance_parameter rgmii_out1 PIN_TYPE_GUI "Output"
        set_instance_parameter rgmii_out1 gui_io_reg_mode "DDIO"
        set_instance_parameter rgmii_out1 gui_areset_mode "Clear"

        add_connection rgmii_in4.pad_in u_altera_gmii_to_rgmii_adapter_core.rgmii_in4_pad
        add_connection rgmii_in4.dout u_altera_gmii_to_rgmii_adapter_core.rgmii_in4_dout
        add_connection rgmii_in4.ck u_altera_gmii_to_rgmii_adapter_core.rgmii_in4_ck
   
        add_connection rgmii_in1.pad_in u_altera_gmii_to_rgmii_adapter_core.rgmii_in1_pad
        add_connection rgmii_in1.dout u_altera_gmii_to_rgmii_adapter_core.rgmii_in1_dout
        add_connection rgmii_in1.ck u_altera_gmii_to_rgmii_adapter_core.rgmii_in1_ck
   
        add_connection rgmii_out4.pad_out u_altera_gmii_to_rgmii_adapter_core.rgmii_out4_pad
        add_connection rgmii_out4.din u_altera_gmii_to_rgmii_adapter_core.rgmii_out4_din
        add_connection rgmii_out4.ck u_altera_gmii_to_rgmii_adapter_core.rgmii_out4_ck
        add_connection rgmii_out4.aclr u_altera_gmii_to_rgmii_adapter_core.rgmii_out4_aclr
   
        add_connection rgmii_out1.pad_out u_altera_gmii_to_rgmii_adapter_core.rgmii_out1_pad
        add_connection rgmii_out1.din u_altera_gmii_to_rgmii_adapter_core.rgmii_out1_din
        add_connection rgmii_out1.ck u_altera_gmii_to_rgmii_adapter_core.rgmii_out1_ck
        add_connection rgmii_out1.aclr u_altera_gmii_to_rgmii_adapter_core.rgmii_out1_aclr

    }

}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sfo1400787952932/lro1402373605599
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
