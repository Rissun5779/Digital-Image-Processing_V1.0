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
# parameters
# 
add_parameter DEVICE_FAMILY STRING "Stratix V"
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY DESCRIPTION "Target device family for ethernet 10G MAC IP"
# set_parameter_property DEVICE_FAMILY ALLOWED_RANGES {"Stratix V" "Arria 10" "Arria V GZ"}
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY IS_HDL_PARAMETER true
set_parameter_property DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_update_callback DEVICE_FAMILY update_device_family

set_module_property supported_device_families {{Stratix V} {Arria V GZ} {Arria V} {Arria 10} {Stratix 10}}

add_parameter DEVICE STRING "10AX115S4F45I3SGE2"
set_parameter_property DEVICE DISPLAY_NAME "Device part"
set_parameter_property DEVICE DESCRIPTION "Target device part for ethernet 10G MAC IP"
# set_parameter_property DEVICE_FAMILY ALLOWED_RANGES {"Stratix V" "Arria 10" "Arria V GZ"}
set_parameter_property DEVICE VISIBLE false
set_parameter_property DEVICE IS_HDL_PARAMETER false
set_parameter_property DEVICE SYSTEM_INFO DEVICE

add_parameter INSERT_ST_ADAPTOR INTEGER 0 ""
set_parameter_property INSERT_ST_ADAPTOR DEFAULT_VALUE 0
set_parameter_property INSERT_ST_ADAPTOR DISPLAY_NAME "Use legacy Ethernet 10G MAC Avalon Streaming interface"
set_parameter_property INSERT_ST_ADAPTOR DESCRIPTION "Select this option to maintain compatibility with the legacy 10-Gbps Ethernet MAC IP core on the Avalon Streaming Interface"
set_parameter_property INSERT_ST_ADAPTOR TYPE INTEGER
set_parameter_property INSERT_ST_ADAPTOR UNITS None
set_parameter_property INSERT_ST_ADAPTOR DISPLAY_HINT boolean
set_parameter_property INSERT_ST_ADAPTOR HDL_PARAMETER true
set_parameter_update_callback INSERT_ST_ADAPTOR update_st_adaptor

add_parameter INSERT_CSR_ADAPTOR INTEGER 0
set_parameter_property INSERT_CSR_ADAPTOR DEFAULT_VALUE 0
set_parameter_property INSERT_CSR_ADAPTOR DISPLAY_NAME "Use legacy Ethernet 10G MAC Avalon Memory-Mapped interface"
set_parameter_property INSERT_CSR_ADAPTOR DESCRIPTION "Turning on this option will map Low Latency 10G MAC registers address to legacy 10-Gbps Ethernet MAC IP core registers address"
set_parameter_property INSERT_CSR_ADAPTOR TYPE INTEGER
set_parameter_property INSERT_CSR_ADAPTOR UNITS None
set_parameter_property INSERT_CSR_ADAPTOR DISPLAY_HINT boolean
set_parameter_property INSERT_CSR_ADAPTOR HDL_PARAMETER true
set_parameter_update_callback INSERT_CSR_ADAPTOR update_csr_adaptor

add_parameter INSERT_XGMII_ADAPTOR INTEGER 1
set_parameter_property INSERT_XGMII_ADAPTOR DEFAULT_VALUE 1
set_parameter_property INSERT_XGMII_ADAPTOR DISPLAY_NAME "Use legacy Ethernet 10G MAC XGMII interface"
set_parameter_property INSERT_XGMII_ADAPTOR DESCRIPTION "Select this option to maintain compatibility with the legacy 10-Gbps Ethernet MAC IP core on the XGMII"
set_parameter_property INSERT_XGMII_ADAPTOR TYPE INTEGER
set_parameter_property INSERT_XGMII_ADAPTOR UNITS None
set_parameter_property INSERT_XGMII_ADAPTOR DISPLAY_HINT boolean
set_parameter_property INSERT_XGMII_ADAPTOR HDL_PARAMETER true
set_parameter_update_callback INSERT_XGMII_ADAPTOR update_xgmii_adaptor

add_parameter USE_ASYNC_ADAPTOR INTEGER 1
set_parameter_property USE_ASYNC_ADAPTOR DEFAULT_VALUE 1
set_parameter_property USE_ASYNC_ADAPTOR DISPLAY_NAME "Use DC FIFO based 64-bit Ethernet 10G MAC XGMII adaptor"
set_parameter_property USE_ASYNC_ADAPTOR DESCRIPTION "Use DC FIFO based adapter for Ethernet 64-bit MAC XGMII interface"
set_parameter_property USE_ASYNC_ADAPTOR TYPE INTEGER
set_parameter_property USE_ASYNC_ADAPTOR UNITS None
set_parameter_property USE_ASYNC_ADAPTOR DISPLAY_HINT boolean
set_parameter_property USE_ASYNC_ADAPTOR HDL_PARAMETER true
set_parameter_property USE_ASYNC_ADAPTOR DERIVED true
set_parameter_property USE_ASYNC_ADAPTOR VISIBLE false

add_parameter DATAPATH_OPTION INTEGER 3
set_parameter_property DATAPATH_OPTION DEFAULT_VALUE 3
set_parameter_property DATAPATH_OPTION DISPLAY_NAME "Datapath options"
set_parameter_property DATAPATH_OPTION TYPE INTEGER
set_parameter_property DATAPATH_OPTION UNITS None
set_parameter_property DATAPATH_OPTION allowed_ranges {"1:TX only" "2:RX only" "3:TX & RX"}
set_parameter_property DATAPATH_OPTION DESCRIPTION "Choose the variation to instantiate"
set_parameter_property DATAPATH_OPTION HDL_PARAMETER true
set_parameter_update_callback DATAPATH_OPTION update_option

add_parameter ENABLE_SUPP_ADDR INTEGER 0
set_parameter_property ENABLE_SUPP_ADDR DEFAULT_VALUE 1
set_parameter_property ENABLE_SUPP_ADDR DISPLAY_NAME "Enable supplementary address"
set_parameter_property ENABLE_SUPP_ADDR DESCRIPTION "Select to use supplementary addresses"
set_parameter_property ENABLE_SUPP_ADDR TYPE INTEGER
set_parameter_property ENABLE_SUPP_ADDR UNITS None
set_parameter_property ENABLE_SUPP_ADDR DISPLAY_HINT boolean
set_parameter_property ENABLE_SUPP_ADDR HDL_PARAMETER true

add_parameter ENABLE_PFC INTEGER 0
set_parameter_property ENABLE_PFC DEFAULT_VALUE 0
set_parameter_property ENABLE_PFC DISPLAY_NAME "Enable priority-based flow control (PFC)"
set_parameter_property ENABLE_PFC DESCRIPTION "Select to turn on the priority-based flow control"
set_parameter_property ENABLE_PFC TYPE INTEGER
set_parameter_property ENABLE_PFC UNITS None
set_parameter_property ENABLE_PFC DISPLAY_HINT boolean
set_parameter_property ENABLE_PFC HDL_PARAMETER true
set_parameter_update_callback ENABLE_PFC update_pfc

add_parameter PFC_PRIORITY_NUMBER INTEGER 8
set_parameter_property PFC_PRIORITY_NUMBER DEFAULT_VALUE 8
set_parameter_property PFC_PRIORITY_NUMBER DISPLAY_NAME "Number of PFC queues"
set_parameter_property PFC_PRIORITY_NUMBER DESCRIPTION "Specify the number of PFC queues. Valid number of queues is 2 to 8"
set_parameter_property PFC_PRIORITY_NUMBER TYPE INTEGER
set_parameter_property PFC_PRIORITY_NUMBER UNITS None
set_parameter_property PFC_PRIORITY_NUMBER ALLOWED_RANGES {2:8}
set_parameter_property PFC_PRIORITY_NUMBER HDL_PARAMETER true

add_parameter INSTANTIATE_STATISTICS INTEGER 0
set_parameter_property INSTANTIATE_STATISTICS DEFAULT_VALUE 1
set_parameter_property INSTANTIATE_STATISTICS DISPLAY_NAME "Enable statistics collection"
set_parameter_property INSTANTIATE_STATISTICS DESCRIPTION "Select to collect statistics"
set_parameter_property INSTANTIATE_STATISTICS TYPE INTEGER
set_parameter_property INSTANTIATE_STATISTICS UNITS None
set_parameter_property INSTANTIATE_STATISTICS DISPLAY_HINT boolean
set_parameter_property INSTANTIATE_STATISTICS HDL_PARAMETER true

add_parameter REGISTER_BASED_STATISTICS INTEGER 0
set_parameter_property REGISTER_BASED_STATISTICS DEFAULT_VALUE 0
set_parameter_property REGISTER_BASED_STATISTICS DISPLAY_NAME "Statistics counters"
set_parameter_property REGISTER_BASED_STATISTICS DESCRIPTION "Choose the implementation of the statistics counters"
set_parameter_property REGISTER_BASED_STATISTICS TYPE INTEGER
set_parameter_property REGISTER_BASED_STATISTICS UNITS None
set_parameter_property REGISTER_BASED_STATISTICS allowed_ranges {"0:Memory-based" "1:Register-based"}
set_parameter_property REGISTER_BASED_STATISTICS HDL_PARAMETER true

add_parameter PREAMBLE_PASSTHROUGH INTEGER 0
set_parameter_property PREAMBLE_PASSTHROUGH DEFAULT_VALUE 0
set_parameter_property PREAMBLE_PASSTHROUGH DISPLAY_NAME "Enable preamble pass-through mode"
set_parameter_property PREAMBLE_PASSTHROUGH DESCRIPTION "Select to turn on the preamble passthrough mode. This mode allows user-defined preamble in client frames"
set_parameter_property PREAMBLE_PASSTHROUGH TYPE INTEGER
set_parameter_property PREAMBLE_PASSTHROUGH UNITS None
set_parameter_property PREAMBLE_PASSTHROUGH DISPLAY_HINT boolean
set_parameter_property PREAMBLE_PASSTHROUGH HDL_PARAMETER true
set_parameter_update_callback PREAMBLE_PASSTHROUGH update_preamble_passthrough

add_parameter ENABLE_TIMESTAMPING INTEGER 0
set_parameter_property ENABLE_TIMESTAMPING DEFAULT_VALUE 0
set_parameter_property ENABLE_TIMESTAMPING DISPLAY_NAME "Enable time stamping"
set_parameter_property ENABLE_TIMESTAMPING DESCRIPTION "Instantiate time stamping component"
set_parameter_property ENABLE_TIMESTAMPING TYPE INTEGER
set_parameter_property ENABLE_TIMESTAMPING UNITS None
set_parameter_property ENABLE_TIMESTAMPING DISPLAY_HINT boolean
set_parameter_property ENABLE_TIMESTAMPING HDL_PARAMETER true
set_parameter_update_callback ENABLE_TIMESTAMPING update_timestamping

add_parameter ENABLE_PTP_1STEP INTEGER 0
set_parameter_property ENABLE_PTP_1STEP DEFAULT_VALUE 0
set_parameter_property ENABLE_PTP_1STEP DISPLAY_NAME "Enable PTP one-step clock support"
set_parameter_property ENABLE_PTP_1STEP DESCRIPTION "Select to turn on PTP one-step clock support"
set_parameter_property ENABLE_PTP_1STEP TYPE INTEGER
set_parameter_property ENABLE_PTP_1STEP UNITS None
set_parameter_property ENABLE_PTP_1STEP DISPLAY_HINT boolean
set_parameter_property ENABLE_PTP_1STEP HDL_PARAMETER true
set_parameter_update_callback ENABLE_PTP_1STEP update_ptp_1step

add_parameter ENABLE_ASYMMETRY INTEGER 0
set_parameter_property ENABLE_ASYMMETRY DEFAULT_VALUE 0
set_parameter_property ENABLE_ASYMMETRY DISPLAY_NAME "Enable asymmetry support"
set_parameter_property ENABLE_ASYMMETRY DESCRIPTION "Select to turn on asymmetry support (PTP one-step clock support is required)"
set_parameter_property ENABLE_ASYMMETRY TYPE INTEGER
set_parameter_property ENABLE_ASYMMETRY UNITS None
set_parameter_property ENABLE_ASYMMETRY DISPLAY_HINT boolean
set_parameter_property ENABLE_ASYMMETRY HDL_PARAMETER true
set_parameter_update_callback ENABLE_ASYMMETRY update_ptp_1step_asym

add_parameter TSTAMP_FP_WIDTH INTEGER 4
set_parameter_property TSTAMP_FP_WIDTH DEFAULT_VALUE 4
set_parameter_property TSTAMP_FP_WIDTH DISPLAY_NAME "Timestamp fingerprint width"
set_parameter_property TSTAMP_FP_WIDTH DESCRIPTION "Specify the width of the timestamp fingerprint for the TX datapath. Valid number of width is 1 to 32"
set_parameter_property TSTAMP_FP_WIDTH TYPE INTEGER
set_parameter_property TSTAMP_FP_WIDTH UNITS None
set_parameter_property TSTAMP_FP_WIDTH ALLOWED_RANGES {1:32}
set_parameter_property TSTAMP_FP_WIDTH HDL_PARAMETER true

add_parameter TIME_OF_DAY_FORMAT INTEGER 0
set_parameter_property TIME_OF_DAY_FORMAT DEFAULT_VALUE 2
set_parameter_property TIME_OF_DAY_FORMAT DISPLAY_NAME "Time Of Day Format"
set_parameter_property TIME_OF_DAY_FORMAT DESCRIPTION "Select the format of the time of day"
set_parameter_property TIME_OF_DAY_FORMAT TYPE INTEGER
set_parameter_property TIME_OF_DAY_FORMAT DISPLAY_HINT radio
set_parameter_property TIME_OF_DAY_FORMAT UNITS None
set_parameter_property TIME_OF_DAY_FORMAT ALLOWED_RANGES {"0:Enable 96b Time Of Day Format only" "1:Enable 64b Time Of Day Format only" "2:Enable both 96b and 64b Time Of Day Format"}
set_parameter_property TIME_OF_DAY_FORMAT HDL_PARAMETER true

add_parameter ENABLE_1G10G_MAC INTEGER 0
set_parameter_property ENABLE_1G10G_MAC DEFAULT_VALUE 0
set_parameter_property ENABLE_1G10G_MAC DISPLAY_NAME "Speed"
set_parameter_property ENABLE_1G10G_MAC DESCRIPTION "Select the operating data rates"
set_parameter_property ENABLE_1G10G_MAC TYPE INTEGER
set_parameter_property ENABLE_1G10G_MAC DISPLAY_HINT radio
set_parameter_property ENABLE_1G10G_MAC UNITS None
set_parameter_property ENABLE_1G10G_MAC ALLOWED_RANGES {
   "0:10G"
   "1:1G/10G"
   "2:10M/100M/1G/10G"
   "3:1G/2.5G"
   "4:1G/2.5G/10G"
   "5:10M/100M/1G/2.5G/5G/10G (USXGMII)"
}
set_parameter_property ENABLE_1G10G_MAC HDL_PARAMETER true
set_parameter_update_callback ENABLE_1G10G_MAC update_speed_setting

add_parameter ENABLE_MEM_ECC INTEGER 0
set_parameter_property ENABLE_MEM_ECC DEFAULT_VALUE 0
set_parameter_property ENABLE_MEM_ECC DISPLAY_NAME "Enable ECC on memory blocks"
set_parameter_property ENABLE_MEM_ECC DESCRIPTION "Select to turn on the error code correction"
set_parameter_property ENABLE_MEM_ECC TYPE INTEGER
set_parameter_property ENABLE_MEM_ECC UNITS None
set_parameter_property ENABLE_MEM_ECC DISPLAY_HINT boolean
set_parameter_property ENABLE_MEM_ECC HDL_PARAMETER true
set_parameter_update_callback ENABLE_MEM_ECC update_ecc_setting

add_parameter ENABLE_UNIDIRECTIONAL INTEGER 0
set_parameter_property ENABLE_UNIDIRECTIONAL DEFAULT_VALUE 0
set_parameter_property ENABLE_UNIDIRECTIONAL DISPLAY_NAME "Enable unidirectional feature"
set_parameter_property ENABLE_UNIDIRECTIONAL DESCRIPTION "Select to turn on unidirectional. This feature implements the IEEE 802.3 (Clause 66) standard"
set_parameter_property ENABLE_UNIDIRECTIONAL TYPE INTEGER
set_parameter_property ENABLE_UNIDIRECTIONAL UNITS None
set_parameter_property ENABLE_UNIDIRECTIONAL DISPLAY_HINT boolean
set_parameter_property ENABLE_UNIDIRECTIONAL HDL_PARAMETER true
set_parameter_update_callback ENABLE_UNIDIRECTIONAL update_unidirection_setting

add_parameter ENABLE_10GBASER_REG_MODE INTEGER 0
set_parameter_property ENABLE_10GBASER_REG_MODE DEFAULT_VALUE 0
set_parameter_property ENABLE_10GBASER_REG_MODE DISPLAY_NAME "Enable 10GBASE-R register mode"
set_parameter_property ENABLE_10GBASER_REG_MODE DESCRIPTION "Select to turn on the 10GBASE-R register mode. Using the MAC and Transceiver Native PHY Intel FPGA IP in this mode reduces the latency on both TX and RX datapaths"
set_parameter_property ENABLE_10GBASER_REG_MODE TYPE INTEGER
set_parameter_property ENABLE_10GBASER_REG_MODE UNITS None
set_parameter_property ENABLE_10GBASER_REG_MODE DISPLAY_HINT boolean
set_parameter_property ENABLE_10GBASER_REG_MODE HDL_PARAMETER true
set_parameter_update_callback ENABLE_10GBASER_REG_MODE update_ultra_setting

add_parameter SHOW_HIDDEN_OPTIONS INTEGER 0
set_parameter_property SHOW_HIDDEN_OPTIONS DEFAULT_VALUE 0
set_parameter_property SHOW_HIDDEN_OPTIONS DISPLAY_NAME "Show hidden options"
set_parameter_property SHOW_HIDDEN_OPTIONS DESCRIPTION "Enable hidden options in GUI"
set_parameter_property SHOW_HIDDEN_OPTIONS TYPE INTEGER
set_parameter_property SHOW_HIDDEN_OPTIONS UNITS None
set_parameter_property SHOW_HIDDEN_OPTIONS DISPLAY_HINT boolean
set_parameter_property SHOW_HIDDEN_OPTIONS HDL_PARAMETER false
set_parameter_property SHOW_HIDDEN_OPTIONS visible false

# ED GUI parameters. temporary put here

add_parameter SELECT_SUPPORTED_VARIANT INTEGER 10
set_parameter_property SELECT_SUPPORTED_VARIANT DEFAULT_VALUE "10"
set_parameter_property SELECT_SUPPORTED_VARIANT DISPLAY_NAME "Select Design"
set_parameter_property SELECT_SUPPORTED_VARIANT DESCRIPTION "<html>Please select available design for Example Design generation.<br><br><b>None</b>: When there is 'None' available, it means there is no example design available for current parameter selections. However, we have other example designs that come with specific IP and related parameter settings that you may use by selecting one of the presets below.<br><br><i>Please note that when you apply preset, current IP and other parameter settings will be set to match those of selected preset. If you like to save your current settings, you should do so before you hit apply preset. Also you can always save the new 'preset' settings under a different name using File->Save as</i></html>"
set_parameter_property SELECT_SUPPORTED_VARIANT allowed_ranges { 
"0:None"
"1:10M/100M/1G/10G Ethernet"
"2:10M/100M/1G/10G Ethernet with 1588"
"3:10GBase-R Register Mode"
"4:1G/10G Ethernet"
"5:1G/10G Ethernet with 1588"
"6:1G/2.5G Ethernet"
"7:1G/2.5G/10G Ethernet"
"8:1G/2.5G Ethernet with 1588"
"9:10M/100M/1G/2.5G/5G/10G (USXGMII) Ethernet"
"10:10GBase-R"
}
set_parameter_property SELECT_SUPPORTED_VARIANT HDL_PARAMETER false
set_parameter_update_callback SELECT_SUPPORTED_VARIANT update_supported_variant

# add_parameter ENABLE_SHARED_REFCLK INTEGER 0
# set_parameter_property ENABLE_SHARED_REFCLK DEFAULT_VALUE 0
# set_parameter_property ENABLE_SHARED_REFCLK DISPLAY_NAME "Enable shared refclk"
# set_parameter_property ENABLE_SHARED_REFCLK DESCRIPTION "Enable shared refclk"
# set_parameter_property ENABLE_SHARED_REFCLK TYPE INTEGER
# set_parameter_property ENABLE_SHARED_REFCLK UNITS None
# set_parameter_property ENABLE_SHARED_REFCLK DISPLAY_HINT boolean
# set_parameter_property ENABLE_SHARED_REFCLK HDL_PARAMETER false

# add_parameter SELECT_SUPPORTED_FIFO INTEGER 0
# set_parameter_property SELECT_SUPPORTED_FIFO DEFAULT_VALUE "0"
# set_parameter_property SELECT_SUPPORTED_FIFO DISPLAY_NAME "Choose supported variant"
# set_parameter_property SELECT_SUPPORTED_FIFO DESCRIPTION "Select to generate example design"
# set_parameter_property SELECT_SUPPORTED_FIFO allowed_ranges {
# "0:SC FIFO"
# "1:DC FIFO"
# }
# set_parameter_property SELECT_SUPPORTED_FIFO HDL_PARAMETER false

# add_parameter ENABLE_SYNCE INTEGER 0
# set_parameter_property ENABLE_SYNCE DEFAULT_VALUE 0
# set_parameter_property ENABLE_SYNCE DISPLAY_NAME "Enable SYNCE"
# set_parameter_property ENABLE_SYNCE DESCRIPTION "Enable SYNCE"
# set_parameter_property ENABLE_SYNCE TYPE INTEGER
# set_parameter_property ENABLE_SYNCE UNITS None
# set_parameter_property ENABLE_SYNCE DISPLAY_HINT boolean
# set_parameter_property ENABLE_SYNCE HDL_PARAMETER false

# add_parameter ENABLE_ED_FILESET INTEGER 0
# set_parameter_property ENABLE_ED_FILESET DEFAULT_VALUE 0
# set_parameter_property ENABLE_ED_FILESET DISPLAY_NAME "Generate Files for"
# set_parameter_property ENABLE_ED_FILESET DESCRIPTION "Select the example design fileset"
# set_parameter_property ENABLE_ED_FILESET TYPE INTEGER
# set_parameter_property ENABLE_ED_FILESET DISPLAY_HINT radio
# set_parameter_property ENABLE_ED_FILESET UNITS None
# set_parameter_property ENABLE_ED_FILESET ALLOWED_RANGES {
   # "0:Simulation files only"
   # "1:Synthesis files only "
   # "2:Both"
# }
# set_parameter_property ENABLE_ED_FILESET HDL_PARAMETER false

add_parameter ENABLE_ED_FILESET_SYNTHESIS INTEGER 1
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DEFAULT_VALUE 1
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_NAME "Synthesis"
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DESCRIPTION "When Synthesis box is checked, all necessary filesets required for synthesis will be generated."
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS TYPE INTEGER
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS UNITS None
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_HINT boolean
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS HDL_PARAMETER false
set_parameter_update_callback ENABLE_ED_FILESET_SYNTHESIS update_ed_fileset_synthesis

add_parameter ENABLE_ED_FILESET_SIM INTEGER 1
set_parameter_property ENABLE_ED_FILESET_SIM DEFAULT_VALUE 1
set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_NAME "Simulation"
set_parameter_property ENABLE_ED_FILESET_SIM DESCRIPTION "When Simulation box is checked, all necessary filesets required for simulation will be generated."
set_parameter_property ENABLE_ED_FILESET_SIM TYPE INTEGER
set_parameter_property ENABLE_ED_FILESET_SIM UNITS None
set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_HINT boolean
set_parameter_property ENABLE_ED_FILESET_SIM HDL_PARAMETER false

add_parameter SELECT_ED_FILESET INTEGER 0
set_parameter_property SELECT_ED_FILESET DEFAULT_VALUE "0"
set_parameter_property SELECT_ED_FILESET DISPLAY_NAME "Generate File Format"
set_parameter_property SELECT_ED_FILESET DESCRIPTION "Please select an HDL format for the generated Example Design filesets."
set_parameter_property SELECT_ED_FILESET allowed_ranges {
"0:Verilog"
"1:VHDL"
}
set_parameter_property SELECT_ED_FILESET HDL_PARAMETER false

add_parameter SELECT_TARGETED_DEVICE INTEGER 0
set_parameter_property SELECT_TARGETED_DEVICE DEFAULT_VALUE "0"
set_parameter_property SELECT_TARGETED_DEVICE DISPLAY_NAME "Select Board"
set_parameter_property SELECT_TARGETED_DEVICE DESCRIPTION "<html>This option provides supports for various Development Kits listed. The details of Intel FPGA IP Development Kits can be found on Intel FPGA IP website <a href='https://www.altera.com/products/boards_and_kits/all-development-kits.html'>https://www.altera.com/products/boards_and_kits/all-development-kits.html</a>. If this menu is greyed out, it is because no board is supported for the options selected such as synthesis checked off. If an Intel FPGA IP Development board is selected, the Target Device used for generation will be the one that matches the device on the Development Kit<br><br>
<b>Intel FPGA IP  Development Kit:</b><br>
This option allows the Example Design to be tested on the selected Intel FPGA IP development kit. This selection automatically selects the Target Device to match the device on the selected Intel FPGA IP development kit. If your board revision has a different grade of this device, you can correct it.<br><br>
<b>Custom Development Kit:</b><br>
This option allows the Example Design to be tested on a third party development kit with Intel FPGA IP device, a custom designed board with Intel FPGA IP device, or a standard Intel FPGA IP development kit not available for selection.  You may also select a custom device for the custom development kit.<br><br>
<b>No Development Kit:</b><br>
This option excluding hardware aspects for the Example Design.</html>"
set_parameter_property SELECT_TARGETED_DEVICE allowed_ranges {
"0:No Development Kit"
"1:Arria 10 GX Transceiver Signal Integrity Development Kit"
"2:Custom Development Kit"
}
set_parameter_property SELECT_TARGETED_DEVICE HDL_PARAMETER false
set_parameter_update_callback SELECT_TARGETED_DEVICE update_select_targeted_device

add_parameter SELECT_CUSTOM_DEVICE INTEGER 1
set_parameter_property SELECT_CUSTOM_DEVICE DEFAULT_VALUE 1
set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_NAME "Change Target Device"
set_parameter_property SELECT_CUSTOM_DEVICE DESCRIPTION "<html>When select, user is able to select different device grade for Intel FPGA IP development kit. For device specific details look for Device data sheet on <a href='http://www.altera.com/'>www.altera.com</a></html>"
set_parameter_property SELECT_CUSTOM_DEVICE TYPE INTEGER
set_parameter_property SELECT_CUSTOM_DEVICE UNITS None
set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_HINT boolean
set_parameter_property SELECT_CUSTOM_DEVICE HDL_PARAMETER false

add_parameter SELECT_NUMBER_OF_CHANNEL INTEGER 2
set_parameter_property SELECT_NUMBER_OF_CHANNEL DEFAULT_VALUE 2
set_parameter_property SELECT_NUMBER_OF_CHANNEL DISPLAY_NAME "Specify Number of Channels"
set_parameter_property SELECT_NUMBER_OF_CHANNEL DESCRIPTION "Please specify the number of channels. Valid number of queues is 1 to 12"
set_parameter_property SELECT_NUMBER_OF_CHANNEL UNITS None
set_parameter_property SELECT_NUMBER_OF_CHANNEL ALLOWED_RANGES {
1:1
2:2
3:3
4:4
5:5
6:6
7:7
8:8
9:9
10:10
11:11
12:12
}
set_parameter_property SELECT_NUMBER_OF_CHANNEL HDL_PARAMETER false

add_parameter ENABLE_ADME INTEGER 0
set_parameter_property ENABLE_ADME DEFAULT_VALUE 0
set_parameter_property ENABLE_ADME DISPLAY_NAME "Enable ADME support"
set_parameter_property ENABLE_ADME DESCRIPTION "When the box is checked, it enables Trasceiver ADME feature."
set_parameter_property ENABLE_ADME TYPE INTEGER
set_parameter_property ENABLE_ADME UNITS None
set_parameter_property ENABLE_ADME DISPLAY_HINT boolean
set_parameter_property ENABLE_ADME HDL_PARAMETER false

add_parameter DEVKIT_DEVICE STRING "10AX115S4F45E3SGE3"
set_parameter_property DEVKIT_DEVICE DISPLAY_NAME "Devkit device part"
set_parameter_property DEVKIT_DEVICE DESCRIPTION "Device part for supported devkit"
set_parameter_property DEVKIT_DEVICE HDL_PARAMETER false
set_parameter_property DEVKIT_DEVICE VISIBLE false

add_parameter QSF_PATH STRING "LL10G_10GBASER/"
set_parameter_property QSF_PATH DISPLAY_NAME "QSF Path"
set_parameter_property QSF_PATH DESCRIPTION "Path for QSF file"
set_parameter_property QSF_PATH HDL_PARAMETER false
set_parameter_property QSF_PATH VISIBLE false
 


