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


add_display_item "" "IP" GROUP tab
add_display_item "IP" "MAC" GROUP tab
add_display_item "MAC" "MAC Options" GROUP
add_display_item "MAC Options" ENABLE_1G10G_MAC parameter
add_display_item "MAC Options" DATAPATH_OPTION parameter
add_display_item "MAC Options" ENABLE_MEM_ECC parameter
add_display_item "MAC Options" PREAMBLE_PASSTHROUGH parameter
add_display_item "MAC Options" ENABLE_PFC parameter
add_display_item "MAC Options" PFC_PRIORITY_NUMBER parameter
add_display_item "MAC Options" ENABLE_UNIDIRECTIONAL parameter
add_display_item "MAC Options" ENABLE_10GBASER_REG_MODE parameter
add_display_item "MAC Options" ENABLE_SUPP_ADDR parameter
add_display_item "MAC Options" INSTANTIATE_STATISTICS parameter
add_display_item "MAC Options" REGISTER_BASED_STATISTICS parameter

add_display_item "MAC" "Timestamp Options" GROUP
add_display_item "Timestamp Options" ENABLE_TIMESTAMPING parameter
add_display_item "Timestamp Options" ENABLE_PTP_1STEP parameter
add_display_item "Timestamp Options" ENABLE_ASYMMETRY parameter
add_display_item "Timestamp Options" TSTAMP_FP_WIDTH parameter
add_display_item "Timestamp Options" TIME_OF_DAY_FORMAT parameter

add_display_item "MAC" "Legacy Ethernet 10G MAC Interfaces" GROUP
add_display_item "Legacy Ethernet 10G MAC Interfaces" INSERT_XGMII_ADAPTOR parameter
add_display_item "Legacy Ethernet 10G MAC Interfaces" INSERT_CSR_ADAPTOR parameter
add_display_item "Legacy Ethernet 10G MAC Interfaces" INSERT_ST_ADAPTOR parameter
add_display_item "Legacy Ethernet 10G MAC Interfaces" USE_ASYNC_ADAPTOR parameter

add_display_item "" "Example Design" GROUP tab
add_display_item "Example Design" "Available Example Designs" GROUP
add_display_item "Available Example Designs" SELECT_SUPPORTED_VARIANT parameter
#add_display_item "Example Design parameters" SELECT_SUPPORTED_FIFO parameter
#add_display_item "Example Design parameters" ENABLE_SYNCE parameter
add_display_item "Example Design" "Example Design Files" GROUP
add_display_item "Example Design Files" ENABLE_ED_FILESET_SIM parameter
add_display_item "Example Design Files" ENABLE_ED_FILESET_SYNTHESIS parameter
add_display_item "Example Design Files" "explanation3" text "<html><br>The example design supports generation, simulation, and Quartus compilation flows for any selected device. To use the <br>
example design for simulation, select the 'Simulation' option above. To use the example design for compilation and <br>
hardware, select the 'Synthesis' option above.</html>"
add_display_item "Example Design" "Generated HDL Format" GROUP
add_display_item "Generated HDL Format" SELECT_ED_FILESET parameter
add_display_item "Example Design" "Target Development Kit" GROUP
add_display_item "Target Development Kit" SELECT_TARGETED_DEVICE parameter
add_display_item "Target Development Kit" "explanation1" text "<html>Example design supports generation, simulation and Quartus compilation flows for any selected device.<br>
 The hardware support is provided through selected development kit with a specific device.<br> 
 To exclude hardware aspects of example design, select 'None' from the Target Development Kit pull down menu.</html>"
#add_display_item "Target Development Kit" "explanation2" text "The hardware support is provided through selected Development kit(s) with a specific device. To exclude"
#add_display_item "Target Development Kit" "explanation3" text "hardware aspects of example design, select \"none\" from the \"Target Development Kit\" pull down menu"
add_display_item "Example Design" "Target Device" GROUP
add_display_item "Target Device" "device" text "<html>Device Selected:     Family: Arria 10 Device 10AX115S4F45I3SGE2<br><br></html>"
add_display_item "Target Device" SELECT_CUSTOM_DEVICE parameter
add_display_item "Target Device" "explanation2" text "<html></html>"
add_display_item "Example Design" "Example Design Parameters" GROUP
add_display_item "Example Design Parameters" SELECT_NUMBER_OF_CHANNEL parameter
add_display_item "Example Design Parameters" ENABLE_ADME parameter



