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
# module altera_gmii_to_rgmii_adapter_core
# 
set_module_property DESCRIPTION "HPS GMII to RGMII Converter core"
set_module_property NAME altera_gmii_to_rgmii_adapter_core
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Processors and Peripherals/Hard Processor Components"
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "HPS GMII to RGMII Converter Core Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate
#set_module_property SUPPORTED_DEVICE_FAMILY {{Arria 10} {Arria V} {Cyclone V}}

# 
# file sets
# 
add_fileset synthesis_fileset QUARTUS_SYNTH "proc_add_synth_file" ""
set_fileset_property synthesis_fileset TOP_LEVEL altera_gmii_to_rgmii_adapter
set_fileset_property synthesis_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property synthesis_fileset ENABLE_FILE_OVERWRITE_MODE false

add_fileset sim_verilog_fileset SIM_VERILOG "proc_add_sim_file" ""
set_fileset_property sim_verilog_fileset TOP_LEVEL altera_gmii_to_rgmii_adapter
set_fileset_property sim_verilog_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property sim_verilog_fileset ENABLE_FILE_OVERWRITE_MODE false

add_fileset sim_vhdl_fileset SIM_VHDL "proc_add_sim_file" ""
set_fileset_property sim_vhdl_fileset TOP_LEVEL altera_gmii_to_rgmii_adapter
set_fileset_property sim_vhdl_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property sim_vhdl_fileset ENABLE_FILE_OVERWRITE_MODE false

#
# link to datasheet of component -- documentation of this component to be updated as part of embedded IP user guide 
#
add_documentation_link {Data Sheet } {http://www.altera.com/literature/ug/ug_embedded_ip.pdf}

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

add_parameter USE_ALTGPIO INTEGER 1
set_parameter_property USE_ALTGPIO DEFAULT_VALUE 1
set_parameter_property USE_ALTGPIO DISPLAY_NAME USE_ALTGPIO
set_parameter_property USE_ALTGPIO TYPE INTEGER
set_parameter_property USE_ALTGPIO DERIVED true
set_parameter_property USE_ALTGPIO VISIBLE false
set_parameter_property USE_ALTGPIO UNITS None
set_parameter_property USE_ALTGPIO HDL_PARAMETER true

add_parameter DEVICE_FAMILY STRING ""
set_parameter_property DEVICE_FAMILY SYSTEM_INFO "DEVICE_FAMILY"
set_parameter_property DEVICE_FAMILY VISIBLE false

# 
# display items
# 


# 
# connection point peri_clock
# 
add_interface peri_clock clock end
add_interface_port peri_clock clk clk Input 1
set_interface_property peri_clock ENABLED true



# 
# connection point peri_reset
# 
add_interface peri_reset reset end
add_interface_port peri_reset rst_n reset_n Input 1
set_interface_property peri_reset associatedClock peri_clock
set_interface_property peri_reset synchronousEdges DEASSERT
set_interface_property peri_reset ENABLED true



# 
# connection point hps_gmii
# 
add_interface hps_gmii conduit end
set_interface_property hps_gmii associatedClock ""
set_interface_property hps_gmii associatedReset ""
set_interface_property hps_gmii ENABLED true
set_interface_property hps_gmii EXPORT_OF ""
set_interface_property hps_gmii PORT_NAME_MAP ""
set_interface_property hps_gmii CMSIS_SVD_VARIABLES ""
set_interface_property hps_gmii SVD_ADDRESS_GROUP ""

add_interface_port hps_gmii mac_tx_clk_o phy_tx_clk_o Input 1
add_interface_port hps_gmii mac_rst_tx_n rst_tx_n Input 1
add_interface_port hps_gmii mac_rst_rx_n rst_rx_n Input 1
add_interface_port hps_gmii mac_txd phy_txd_o Input 8
add_interface_port hps_gmii mac_txen phy_txen_o Input 1
add_interface_port hps_gmii mac_txer phy_txer_o Input 1
add_interface_port hps_gmii mac_speed phy_mac_speed_o Input 2
add_interface_port hps_gmii mac_tx_clk_i phy_tx_clk_i Output 1
add_interface_port hps_gmii mac_rx_clk phy_rx_clk_i Output 1
add_interface_port hps_gmii mac_rxdv phy_rxdv_i Output 1
add_interface_port hps_gmii mac_rxer phy_rxer_i Output 1
add_interface_port hps_gmii mac_rxd phy_rxd_i Output 8
add_interface_port hps_gmii mac_col phy_col_i Output 1
add_interface_port hps_gmii mac_crs phy_crs_i Output 1


# 
# connection point phy_rgmii
# 
add_interface phy_rgmii conduit end
set_interface_property phy_rgmii associatedClock ""
set_interface_property phy_rgmii associatedReset ""
set_interface_property phy_rgmii ENABLED true
set_interface_property phy_rgmii EXPORT_OF ""
set_interface_property phy_rgmii PORT_NAME_MAP ""
set_interface_property phy_rgmii CMSIS_SVD_VARIABLES ""
set_interface_property phy_rgmii SVD_ADDRESS_GROUP ""

add_interface_port phy_rgmii rgmii_rx_clk rgmii_rx_clk Input 1
add_interface_port phy_rgmii rgmii_rxd rgmii_rxd Input 4
add_interface_port phy_rgmii rgmii_rx_ctl rgmii_rx_ctl Input 1
add_interface_port phy_rgmii rgmii_tx_clk rgmii_tx_clk Output 1
add_interface_port phy_rgmii rgmii_txd rgmii_txd Output 4
add_interface_port phy_rgmii rgmii_tx_ctl rgmii_tx_ctl Output 1





# 
# connection point pll_25m_clock
# 
add_interface pll_25m_clock clock end
add_interface_port pll_25m_clock pll_25m_clk clk Input 1
set_interface_property pll_25m_clock ENABLED true



# 
# connection point pll_2_5m_clock
# 
add_interface pll_2_5m_clock clock end
add_interface_port pll_2_5m_clock pll_2_5m_clk clk Input 1
set_interface_property pll_2_5m_clock ENABLED true

proc is_arriav_cyclonev {parameter} {
    if {[get_parameter_value $parameter] == "Arria V"} {
        return 1
    } elseif {[get_parameter_value $parameter] == "Cyclone V"} {
        return 1
    } else {
        return 0
    }
}

proc elaborate {} {
    
    # 
    # connection point altgpio
    # 
    add_interface rgmii_out4_pad conduit end
    add_interface_port rgmii_out4_pad rgmii_out4_pad export Input 4
    
    add_interface rgmii_out1_pad conduit end
    add_interface_port rgmii_out1_pad rgmii_out1_pad export Input 1

    add_interface rgmii_in4_dout conduit end
    add_interface_port rgmii_in4_dout rgmii_in4_dout export Input 8
    
    add_interface rgmii_in1_dout conduit end
    add_interface_port rgmii_in1_dout rgmii_in1_dout export Input 2
    
    add_interface rgmii_out4_din conduit end
    add_interface_port rgmii_out4_din rgmii_out4_din export Output 8
   
    add_interface rgmii_out4_ck conduit end
    add_interface_port rgmii_out4_ck rgmii_out4_ck export Output 1

    add_interface rgmii_out4_aclr conduit end
    add_interface_port rgmii_out4_aclr rgmii_out4_aclr export Output 1

    add_interface rgmii_out1_din conduit end
    add_interface_port rgmii_out1_din rgmii_out1_din export Output 2

    add_interface rgmii_out1_ck conduit end
    add_interface_port rgmii_out1_ck rgmii_out1_ck export Output 1

    add_interface rgmii_out1_aclr conduit end
    add_interface_port rgmii_out1_aclr rgmii_out1_aclr export Output 1

    add_interface rgmii_in4_pad conduit end
    add_interface_port rgmii_in4_pad rgmii_in4_pad export Output 4

    add_interface rgmii_in4_ck conduit end
    add_interface_port rgmii_in4_ck rgmii_in4_ck export Output 1

    add_interface rgmii_in1_pad conduit end
    add_interface_port rgmii_in1_pad rgmii_in1_pad export Output 1

    add_interface rgmii_in1_ck conduit end
    add_interface_port rgmii_in1_ck rgmii_in1_ck export Output 1

    if { [is_arriav_cyclonev DEVICE_FAMILY] } {

        set_parameter_value USE_ALTGPIO 0

        set_interface_property "rgmii_out4_din" ENABLED 0
        set_interface_property "rgmii_out4_pad" ENABLED 0
        set_interface_property "rgmii_out4_ck"  ENABLED 0
        set_interface_property "rgmii_out4_aclr" ENABLED 0

        set_interface_property "rgmii_out1_din" ENABLED 0
        set_interface_property "rgmii_out1_pad" ENABLED 0
        set_interface_property "rgmii_out1_ck"  ENABLED 0
        set_interface_property "rgmii_out1_aclr"  ENABLED 0

        set_interface_property "rgmii_in4_dout" ENABLED 0
        set_interface_property "rgmii_in4_pad"  ENABLED 0
        set_interface_property "rgmii_in4_ck"   ENABLED 0

        set_interface_property "rgmii_in1_dout" ENABLED 0
        set_interface_property "rgmii_in1_pad"  ENABLED 0
        set_interface_property "rgmii_in1_ck"   ENABLED 0
    } else {
        
        set_parameter_value USE_ALTGPIO 1
        
        set_interface_property "rgmii_out4_din" ENABLED 1
        set_interface_property "rgmii_out4_pad" ENABLED 1
        set_interface_property "rgmii_out4_ck"  ENABLED 1
        set_interface_property "rgmii_out4_aclr" ENABLED 1

        set_interface_property "rgmii_out1_din" ENABLED 1
        set_interface_property "rgmii_out1_pad" ENABLED 1
        set_interface_property "rgmii_out1_ck"  ENABLED 1
        set_interface_property "rgmii_out1_aclr"  ENABLED 1

        set_interface_property "rgmii_in4_dout" ENABLED 1
        set_interface_property "rgmii_in4_pad"  ENABLED 1
        set_interface_property "rgmii_in4_ck"   ENABLED 1

        set_interface_property "rgmii_in1_dout" ENABLED 1
        set_interface_property "rgmii_in1_pad"  ENABLED 1
        set_interface_property "rgmii_in1_ck"   ENABLED 1
    }

}


proc proc_add_synth_file { entity_name } {
    
    #set output_directory [create_temp_file ""]
    #set intended_family [get_parameter_value DEVICE_FAMILY]
    #set clock_mux_file [file join $output_directory altera_clock_mux.v]
    #exec qmegawiz -silent wizard=ALTCLKCTRL INTENDED_DEVICE_FAMILY=$intended_family clock_inputs=2 clksel_width=1 ena=NONE clock_type="AUTO" USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION=ON OPTIONAL_FILES=NONE $clock_mux_file

    add_fileset_file altera_gmii_to_rgmii_adapter.v VERILOG PATH altera_gmii_to_rgmii_adapter.v TOP_LEVEL_FILE
    add_fileset_file altera_gtr_mac_speed_filter.v VERILOG PATH altera_gtr_mac_speed_filter.v
    add_fileset_file altera_gtr_pipeline_stage.v VERILOG PATH altera_gtr_pipeline_stage.v
    add_fileset_file altera_gtr_rgmii_in1.v VERILOG PATH altera_gtr_rgmii_in1.v
    add_fileset_file altera_gtr_rgmii_in4.v VERILOG PATH altera_gtr_rgmii_in4.v
    add_fileset_file altera_gtr_rgmii_module.v VERILOG PATH altera_gtr_rgmii_module.v
    add_fileset_file altera_gtr_nf_rgmii_module.v VERILOG PATH altera_gtr_nf_rgmii_module.v
    add_fileset_file altera_gtr_rgmii_out1.v VERILOG PATH altera_gtr_rgmii_out1.v
    add_fileset_file altera_gtr_rgmii_out4.v VERILOG PATH altera_gtr_rgmii_out4.v
    add_fileset_file altera_gtr_clock_mux.v VERILOG PATH altera_gtr_clock_mux.v
    add_fileset_file altera_gtr_clock_gate.v VERILOG PATH altera_gtr_clock_gate.v
    add_fileset_file altera_gtr_reset_synchronizer.v VERILOG PATH altera_gtr_reset_synchronizer.v

}

proc proc_add_sim_file { entity_name } {

    #set output_directory [create_temp_file ""]
    #set intended_family [get_parameter_value DEVICE_FAMILY]
    #set clock_mux_file [file join $output_directory altera_clock_mux.v]
    #exec qmegawiz -silent wizard=ALTCLKCTRL INTENDED_DEVICE_FAMILY=$intended_family clock_inputs=2 clksel_width=1 ena=NONE clock_type="AUTO" USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION=ON OPTIONAL_FILES=NONE $clock_mux_file

    add_fileset_file altera_gmii_to_rgmii_adapter.v VERILOG PATH altera_gmii_to_rgmii_adapter.v
    add_fileset_file altera_gtr_mac_speed_filter.v VERILOG PATH altera_gtr_mac_speed_filter.v
    add_fileset_file altera_gtr_pipeline_stage.v VERILOG PATH altera_gtr_pipeline_stage.v
    add_fileset_file altera_gtr_rgmii_in1.v VERILOG PATH altera_gtr_rgmii_in1.v
    add_fileset_file altera_gtr_rgmii_in4.v VERILOG PATH altera_gtr_rgmii_in4.v
    add_fileset_file altera_gtr_rgmii_module.v VERILOG PATH altera_gtr_rgmii_module.v
    add_fileset_file altera_gtr_nf_rgmii_module.v VERILOG PATH altera_gtr_nf_rgmii_module.v
    add_fileset_file altera_gtr_rgmii_out1.v VERILOG PATH altera_gtr_rgmii_out1.v
    add_fileset_file altera_gtr_rgmii_out4.v VERILOG PATH altera_gtr_rgmii_out4.v
    add_fileset_file altera_gtr_clock_mux.v VERILOG PATH altera_gtr_clock_mux.v
    add_fileset_file altera_gtr_clock_gate.v VERILOG PATH altera_gtr_clock_gate.v
    add_fileset_file altera_gtr_reset_synchronizer.v VERILOG PATH altera_gtr_reset_synchronizer.v

}
