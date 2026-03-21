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


# +-----------------------------------
# | parameters
# |
proc sdi_ii_gui {} {
    # | Split to 2 tabs
    add_display_item "" "IP" GROUP tab
    add_display_item "" "Design Example" GROUP tab

    # | IP tab
    add_display_item "IP" "Configuration Options" GROUP
    add_display_item "Configuration Options" FAMILY parameter
    add_display_item "Configuration Options" VIDEO_STANDARD parameter 
    add_display_item "Configuration Options" SD_BIT_WIDTH parameter
    add_display_item "Configuration Options" DIRECTION parameter exp
    add_display_item "Configuration Options" TRANSCEIVER_PROTOCOL parameter

    add_display_item "IP" "Transceiver Options" GROUP
    add_display_item "Transceiver Options" HD_FREQ parameter 
    add_display_item "Transceiver Options" XCVR_TXPLL_TYPE parameter
    add_display_item "Transceiver Options" XCVR_ATXPLL_DATA_RATE parameter
    add_display_item "Transceiver Options" XCVR_TX_PLL_SEL parameter

    add_display_item "IP" "Receiver Options" GROUP
    add_display_item "Receiver Options" RX_INC_ERR_TOLERANCE parameter
    add_display_item "Receiver Options" RX_CRC_ERROR_OUTPUT parameter
    add_display_item "Receiver Options" RX_EN_VPID_EXTRACT parameter
    add_display_item "Receiver Options" RX_EN_A2B_CONV parameter
    add_display_item "Receiver Options" RX_EN_B2A_CONV parameter

    add_display_item "IP" "Transmitter Options" GROUP
    add_display_item "Transmitter Options" TX_HD_2X_OVERSAMPLING parameter
    add_display_item "Transmitter Options" TX_EN_VPID_INSERT parameter

    # | Design Example tab  
    add_display_item "Design Example" "Available Design Example" GROUP
    add_display_item "Available Design Example" SELECT_SUPPORTED_VARIANT parameter

    add_display_item "Design Example" "Design Example Options" GROUP
    add_display_item "Design Example Options" ED_TXPLL_TYPE parameter
    add_display_item "Design Example Options" ED_TXPLL_SWITCH parameter

    add_display_item "Design Example" "Design Example Files" GROUP
    add_display_item "Design Example Files" ENABLE_ED_FILESET_SIM parameter
    add_display_item "Design Example Files" ENABLE_ED_FILESET_SYNTHESIS parameter
    add_display_item "Design Example Files" "ed_fileset_txt" text \
        "<html>The design example supports generation, simulation, and Quartus compilation flows for any selected device. To use the <br> \
        design example for simulation, select the 'Simulation' option above. To use the design example for compilation and <br> \
        hardware, select the 'Synthesis' option above.</html>"

    add_display_item "Design Example" "Generated HDL Format" GROUP
    add_display_item "Generated HDL Format" SELECT_ED_FILESET parameter

    add_display_item "Design Example" "Target Development Kit" GROUP
    add_display_item "Target Development Kit" SELECT_TARGETED_BOARD parameter
    add_display_item "Target Development Kit" "target_devkit_txt" text \
        "<html>Design Example supports generation, simulation and Quartus compilation flows for any selected device.<br> \
        The hardware support is provided through selected development kit with a specific device.<br> \
        To exclude hardware aspects of design example, select 'None' from the Target Development Kit pull down menu.</html>"

    add_display_item "Design Example" "Target Device" GROUP
    add_display_item "Target Device" "target_dev" text "<html>Device Selected:     Family: Arria 10 Device 10AX115S2F45I1SG<br><br></html>"
    add_display_item "Target Device" SELECT_CUSTOM_DEVICE parameter
    add_display_item "Target Device" "custom_device_txt" text "<html></html>"
}

proc sdi_ii_common_params {} {
  add_parameter FAMILY string "STRATIX V"
  set_parameter_property FAMILY DISPLAY_NAME "Device family" 
  set_parameter_property FAMILY DESCRIPTION "Currently selected device family"
  set_parameter_property FAMILY SYSTEM_INFO {DEVICE_FAMILY}                       ;# forces family to always match Qsys
  set fams [list_s4_style_hssi_families]
  set_parameter_property FAMILY ALLOWED_RANGES $fams
  set_parameter_property FAMILY AFFECTS_ELABORATION true
  set_parameter_property FAMILY HDL_PARAMETER true
  set_parameter_property FAMILY ENABLED false
  
  add_parameter DEVICE string "Unknown"
  set_parameter_property DEVICE SYSTEM_INFO {DEVICE}
  set_parameter_property DEVICE HDL_PARAMETER false
  set_parameter_property DEVICE VISIBLE false
 
  add_parameter BASE_DEVICE string "Unknown"
  set_parameter_property BASE_DEVICE SYSTEM_INFO_TYPE {PART_TRAIT}
  set_parameter_property BASE_DEVICE SYSTEM_INFO_ARG {BASE_DEVICE}
  set_parameter_property BASE_DEVICE HDL_PARAMETER false
  set_parameter_property BASE_DEVICE VISIBLE false

  add_parameter ED_DEVICE string "Unknown"
  set_parameter_property ED_DEVICE DERIVED true
  set_parameter_property ED_DEVICE HDL_PARAMETER false
  set_parameter_property ED_DEVICE VISIBLE false

  add_parameter VIDEO_STANDARD string "hd"
  set_parameter_property VIDEO_STANDARD DISPLAY_NAME "Video standard" 
  set_parameter_property VIDEO_STANDARD DESCRIPTION "Selects the video standard"
  set std [list_vid_std]
  set_parameter_property VIDEO_STANDARD ALLOWED_RANGES $std
  set_parameter_property VIDEO_STANDARD AFFECTS_ELABORATION true
  set_parameter_property VIDEO_STANDARD HDL_PARAMETER true
  set_parameter_update_callback VIDEO_STANDARD update_vid_std_params


  add_parameter SD_BIT_WIDTH integer 10
  set_parameter_property SD_BIT_WIDTH DISPLAY_NAME "SD interface bit width" 
  set_parameter_property SD_BIT_WIDTH DESCRIPTION "Selects the SD interface bit width for dual rate or triple rate"
  set_parameter_property SD_BIT_WIDTH ALLOWED_RANGES {10 20}
  set_parameter_property SD_BIT_WIDTH AFFECTS_ELABORATION true
  set_parameter_property SD_BIT_WIDTH HDL_PARAMETER true


  add_parameter DIRECTION string "du"
  set_parameter_property DIRECTION DISPLAY_NAME "Direction" 
  set_parameter_property DIRECTION DESCRIPTION "Selects between SDI transmit, SDI receive or SDI bidirectional"
  set dir [list_direction]
  set_parameter_property DIRECTION ALLOWED_RANGES $dir
  set_parameter_property DIRECTION AFFECTS_ELABORATION true
  set_parameter_property DIRECTION HDL_PARAMETER true
  set_parameter_update_callback DIRECTION update_dir_params

  add_parameter TRANSCEIVER_PROTOCOL string "xcvr_proto"
  set_parameter_property TRANSCEIVER_PROTOCOL DISPLAY_NAME "Transceiver and/or protocol" 
  set_parameter_property TRANSCEIVER_PROTOCOL DESCRIPTION "Selects the transceiver and/or protocol blocks"
  set blks [list_blocks]
  set_parameter_property TRANSCEIVER_PROTOCOL ALLOWED_RANGES $blks
  set_parameter_property TRANSCEIVER_PROTOCOL AFFECTS_ELABORATION true
  set_parameter_property TRANSCEIVER_PROTOCOL HDL_PARAMETER true
  set_parameter_update_callback TRANSCEIVER_PROTOCOL update_config_params


  add_parameter HD_FREQ string "148.5"
  set_parameter_property HD_FREQ DISPLAY_NAME "Transceiver reference clock frequency" 
  set_parameter_property HD_FREQ DESCRIPTION "Selects the core and transceiver reference clock frequency"
  set hd_freq [list_hd_freq]
  set_parameter_property HD_FREQ ALLOWED_RANGES $hd_freq
  set_parameter_property HD_FREQ AFFECTS_ELABORATION true
  set_parameter_property HD_FREQ HDL_PARAMETER true
  #set_parameter_property HD_FREQ VISIBLE false
  
  add_parameter XCVR_TXPLL_TYPE string "CMU"
  set_parameter_property XCVR_TXPLL_TYPE DISPLAY_NAME "Tx PLL type" 
  set_parameter_property XCVR_TXPLL_TYPE DESCRIPTION "Selects the transceiver Tx PLL type. Options depend on the selected device family"
  set txpll_type [list_txpll_type]
  set_parameter_property XCVR_TXPLL_TYPE ALLOWED_RANGES $txpll_type
  set_parameter_property XCVR_TXPLL_TYPE AFFECTS_ELABORATION true
  set_parameter_update_callback XCVR_TXPLL_TYPE update_txpll_type_params
  
  add_parameter XCVR_ATXPLL_DATA_RATE string "11880"
  set_parameter_property XCVR_ATXPLL_DATA_RATE DISPLAY_NAME "ATX PLL data rate" 
  set_parameter_property XCVR_ATXPLL_DATA_RATE DESCRIPTION "Selects the transceiver ATX PLL data rate"
  set atxpll_data_rate [list_atxpll_data_rate]
  set_parameter_property XCVR_ATXPLL_DATA_RATE ALLOWED_RANGES $atxpll_data_rate
  set_parameter_property XCVR_ATXPLL_DATA_RATE AFFECTS_ELABORATION true
  set_parameter_property XCVR_ATXPLL_DATA_RATE VISIBLE false

  add_parameter XCVR_TX_PLL_SEL integer 0
  set_parameter_property XCVR_TX_PLL_SEL DISPLAY_NAME "Dynamic Tx clock switching" 
  set_parameter_property XCVR_TX_PLL_SEL DESCRIPTION "Selects the method to execute dynamic Tx clock switching between 1/1.000 or 1/1.001 data rate factor."
  set_parameter_property XCVR_TX_PLL_SEL ALLOWED_RANGES {"0: Off" "1: Tx PLL switching" "2:Tx PLL reference clock switching"}
  set_parameter_property XCVR_TX_PLL_SEL AFFECTS_ELABORATION true
  set_parameter_property XCVR_TX_PLL_SEL HDL_PARAMETER true

  
  #add_parameter USE_SOFT_LOGIC integer 0
  #set_parameter_property USE_SOFT_LOGIC DISPLAY_NAME "Use soft logic for transceiver" 
  #set_parameter_property USE_SOFT_LOGIC DESCRIPTION "Soft logic transceiver is only available for SD-SDI"
  #set_parameter_property USE_SOFT_LOGIC ALLOWED_RANGES {0:1}
  #set_parameter_property USE_SOFT_LOGIC DISPLAY_HINT "Boolean"
  #set_parameter_property USE_SOFT_LOGIC AFFECTS_ELABORATION true
  #set_parameter_property USE_SOFT_LOGIC HDL_PARAMETER true
  #set_parameter_property USE_SOFT_LOGIC VISIBLE false
  #add_display_item "Transceiver Options" USE_SOFT_LOGIC parameter 

  #add_parameter STARTING_CHANNEL_NUMBER integer 0
  #set_parameter_property STARTING_CHANNEL_NUMBER DISPLAY_NAME "Starting channel number" 
  #set_parameter_property STARTING_CHANNEL_NUMBER DESCRIPTION "Each SDI core must have a unique starting channel number"
  #set_parameter_property STARTING_CHANNEL_NUMBER ALLOWED_RANGES {0 4 8 12 16 20 24 28 32 36 40}
  ##set_parameter_property STARTING_CHANNEL_NUMBER AFFECTS_ELABORATION false
  #set_parameter_property STARTING_CHANNEL_NUMBER AFFECTS_ELABORATION true
  #set_parameter_property STARTING_CHANNEL_NUMBER HDL_PARAMETER true
  #set_parameter_property STARTING_CHANNEL_NUMBER VISIBLE false
  #add_display_item "Transceiver Options" STARTING_CHANNEL_NUMBER parameter

  add_parameter RX_INC_ERR_TOLERANCE integer 0
  set_parameter_property RX_INC_ERR_TOLERANCE DISPLAY_NAME "Increase error tolerance level" 
  set_parameter_property RX_INC_ERR_TOLERANCE DESCRIPTION "Enable to increase TRS and frame error tolerance from 4 to 15. Consecutive TRS or frame errors exceeding the tolerance level will cause the respective lock signals to be deasserted."
  set_parameter_property RX_INC_ERR_TOLERANCE ALLOWED_RANGES {0:1}
  set_parameter_property RX_INC_ERR_TOLERANCE DISPLAY_HINT "Boolean"
  set_parameter_property RX_INC_ERR_TOLERANCE AFFECTS_ELABORATION true
  set_parameter_property RX_INC_ERR_TOLERANCE HDL_PARAMETER true


  # add_parameter ERR_TOLERANCE integer 1
  # set_parameter_property ERR_TOLERANCE DISPLAY_NAME "Tolerance to consecutive missed EAV/SAV(s)" 
  # set_parameter_property ERR_TOLERANCE DESCRIPTION "Specify the accepted number of tolerable consecutive missed EAV/SAV(s)"
  # set_parameter_property ERR_TOLERANCE ALLOWED_RANGES {1:15}
  # #set_parameter_property ERR_TOLERANCE AFFECTS_ELABORATION false
  # set_parameter_property ERR_TOLERANCE AFFECTS_ELABORATION true
  # set_parameter_property ERR_TOLERANCE HDL_PARAMETER true
  # add_display_item "Receiver Options" ERR_TOLERANCE parameter

  add_parameter RX_CRC_ERROR_OUTPUT integer 0
  set_parameter_property RX_CRC_ERROR_OUTPUT DISPLAY_NAME "CRC error output" 
  set_parameter_property RX_CRC_ERROR_OUTPUT DESCRIPTION "Enable to generate crc error output ports"
  set_parameter_property RX_CRC_ERROR_OUTPUT ALLOWED_RANGES {0:1}
  set_parameter_property RX_CRC_ERROR_OUTPUT DISPLAY_HINT "Boolean"
  #set_parameter_property RX_CRC_ERROR_OUTPUT AFFECTS_ELABORATION false
  set_parameter_property RX_CRC_ERROR_OUTPUT AFFECTS_ELABORATION true
  set_parameter_property RX_CRC_ERROR_OUTPUT HDL_PARAMETER true


  # add_parameter RX_EN_TRS_MISC integer 0
  # set_parameter_property RX_EN_TRS_MISC DISPLAY_NAME "TRS miscellaneous output" 
  # set_parameter_property RX_EN_TRS_MISC DESCRIPTION "Enable to generate TRS miscellaneous output ports"
  # set_parameter_property RX_EN_TRS_MISC ALLOWED_RANGES {0:1}
  # set_parameter_property RX_EN_TRS_MISC DISPLAY_HINT "Boolean"
  # set_parameter_property RX_EN_TRS_MISC AFFECTS_ELABORATION true
  # set_parameter_property RX_EN_TRS_MISC HDL_PARAMETER false
  # add_display_item "Receiver Options" RX_EN_TRS_MISC parameter

  add_parameter RX_EN_VPID_EXTRACT integer 0
  set_parameter_property RX_EN_VPID_EXTRACT DISPLAY_NAME "Extract payload ID (SMPTE ST 352)" 
  set_parameter_property RX_EN_VPID_EXTRACT DESCRIPTION "Enable to extract payload ID defined by SMPTE ST 352"
  set_parameter_property RX_EN_VPID_EXTRACT ALLOWED_RANGES {0:1}
  set_parameter_property RX_EN_VPID_EXTRACT DISPLAY_HINT "Boolean"
  set_parameter_property RX_EN_VPID_EXTRACT AFFECTS_ELABORATION true
  set_parameter_property RX_EN_VPID_EXTRACT HDL_PARAMETER true
  # set_parameter_update_callback RX_EN_VPID_EXTRACT update_vpid_params


  add_parameter RX_EN_A2B_CONV integer 0
  set_parameter_property RX_EN_A2B_CONV DISPLAY_NAME "Convert HD-SDI dual link to 3G-SDI (level B)" 
  set_parameter_property RX_EN_A2B_CONV DESCRIPTION "Enable to convert HD-SDI dual link (direct image format mapping) to 3G-SDI level B (2 x SMPTE ST 292 HD-SDI mapping including SMPTE ST 372 dual link mapping) for HD dual link receiver output"
  set_parameter_property RX_EN_A2B_CONV ALLOWED_RANGES {0:1}
  set_parameter_property RX_EN_A2B_CONV DISPLAY_HINT "Boolean"
  set_parameter_property RX_EN_A2B_CONV AFFECTS_ELABORATION true
  set_parameter_property RX_EN_A2B_CONV HDL_PARAMETER true


  add_parameter RX_EN_B2A_CONV integer 0
  set_parameter_property RX_EN_B2A_CONV DISPLAY_NAME "Convert 3G-SDI (level B) to HD-SDI dual link" 
  set_parameter_property RX_EN_B2A_CONV DESCRIPTION "Enable to convert 3G-SDI level B (2 x SMPTE ST 292 HD-SDI mapping including SMPTE ST 372 dual link mapping) to HD-SDI dual link (direct image format mapping) for 3G or triple rate receiver output"
  set_parameter_property RX_EN_B2A_CONV ALLOWED_RANGES {0:1}
  set_parameter_property RX_EN_B2A_CONV DISPLAY_HINT "Boolean"
  set_parameter_property RX_EN_B2A_CONV AFFECTS_ELABORATION true
  set_parameter_property RX_EN_B2A_CONV HDL_PARAMETER true


  add_parameter TX_HD_2X_OVERSAMPLING integer 0
  set_parameter_property TX_HD_2X_OVERSAMPLING DISPLAY_NAME "2x oversample mode for HD-SDI" 
  set_parameter_property TX_HD_2X_OVERSAMPLING DESCRIPTION "Enable to run HD transmitter in 2x oversampling mode"
  set_parameter_property TX_HD_2X_OVERSAMPLING ALLOWED_RANGES {0:1}
  set_parameter_property TX_HD_2X_OVERSAMPLING DISPLAY_HINT "Boolean"
  set_parameter_property TX_HD_2X_OVERSAMPLING AFFECTS_ELABORATION true
  set_parameter_property TX_HD_2X_OVERSAMPLING VISIBLE false
 
  add_parameter TX_EN_VPID_INSERT integer 0
  set_parameter_property TX_EN_VPID_INSERT DISPLAY_NAME "Insert payload ID (SMPTE ST 352)" 
  set_parameter_property TX_EN_VPID_INSERT DESCRIPTION "Enable to insert payload ID defined by SMPTE ST 352"
  set_parameter_property TX_EN_VPID_INSERT ALLOWED_RANGES {0:1}
  set_parameter_property TX_EN_VPID_INSERT DISPLAY_HINT "Boolean"
  set_parameter_property TX_EN_VPID_INSERT AFFECTS_ELABORATION true
  set_parameter_property TX_EN_VPID_INSERT HDL_PARAMETER true
  # set_parameter_update_callback TX_EN_VPID_INSERT enable_pattgen_vpid_params
  # set_parameter_update_callback TX_EN_VPID_INSERT update_vpid_params

  add_parameter ED_TXPLL_TYPE string "CMU"
  set_parameter_property ED_TXPLL_TYPE DISPLAY_NAME "Tx PLL type" 
  set_parameter_property ED_TXPLL_TYPE DESCRIPTION "Selects the transceiver Tx PLL type."
  # set_parameter_property ED_TXPLL_TYPE ALLOWED_RANGES $txpll_type
  set_parameter_property ED_TXPLL_TYPE AFFECTS_ELABORATION true
  set_parameter_property ED_TXPLL_TYPE VISIBLE           false
  set_parameter_property ED_TXPLL_TYPE HDL_PARAMETER     false

  add_parameter ED_TXPLL_SWITCH integer 0
  set_parameter_property ED_TXPLL_SWITCH DISPLAY_NAME "Dynamic Tx clock switching" 
  set_parameter_property ED_TXPLL_SWITCH DESCRIPTION "Selects the method to execute dynamic Tx clock switching between 1/1.000 or 1/1.001 data rate factor."
  set_parameter_property ED_TXPLL_SWITCH ALLOWED_RANGES {"0: Off" "1: Tx PLL switching" "2:Tx PLL reference clock switching"}
  set_parameter_property ED_TXPLL_SWITCH AFFECTS_ELABORATION true
  set_parameter_property ED_TXPLL_SWITCH VISIBLE       false
  set_parameter_property ED_TXPLL_SWITCH HDL_PARAMETER false

    add_parameter SELECT_SUPPORTED_VARIANT INTEGER 1
    set_parameter_property SELECT_SUPPORTED_VARIANT DEFAULT_VALUE "1"
    set_parameter_property SELECT_SUPPORTED_VARIANT DISPLAY_NAME "Select Design"
    set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES { "0:None" "1:Parallel loopback with external VCXO" "2:Parallel loopback without external VCXO" \
                                                                     "3:Serial loopback" }
    set_parameter_property SELECT_SUPPORTED_VARIANT HDL_PARAMETER false
    set_parameter_update_callback SELECT_SUPPORTED_VARIANT update_support_var_params
    set_parameter_property SELECT_SUPPORTED_VARIANT DESCRIPTION \
        "<html>Please select available design for Design Example generation.<br> \
        <br> \
        <b>None</b>: When there is 'None' available, it means there is no design example available for current parameter selections. \
        However, we have other design example that come with specific IP and related parameter settings that \
        you may use by selecting one of the presets below.<br> \
        <br> \
        <i>Please note that when you apply preset, current IP and other parameter settings will be set to match those of selected preset. \
        If you like to save your current settings, you should do so before you hit apply preset. Also you can always save the new 'preset' \
        settings under a different name using File->Save as</i></html>"

    add_parameter ENABLE_ED_FILESET_SYNTHESIS INTEGER 1
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DEFAULT_VALUE 1
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_NAME "Synthesis"
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DESCRIPTION "When Synthesis box is checked, all necessary filesets required for synthesis will be generated."
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS TYPE INTEGER
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS UNITS None
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_HINT boolean
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS HDL_PARAMETER false

    add_parameter ENABLE_ED_FILESET_SIM INTEGER 1
    set_parameter_property ENABLE_ED_FILESET_SIM DEFAULT_VALUE 1
    set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_NAME "Simulation"
    set_parameter_property ENABLE_ED_FILESET_SIM DESCRIPTION "When Simulation box is checked, all necessary filesets required for simulation will be generated."
    set_parameter_property ENABLE_ED_FILESET_SIM TYPE INTEGER
    set_parameter_property ENABLE_ED_FILESET_SIM UNITS None
    set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_HINT boolean
    set_parameter_property ENABLE_ED_FILESET_SIM HDL_PARAMETER false

    add_parameter SELECT_ED_FILESET string "VERILOG"
    set_parameter_property SELECT_ED_FILESET DEFAULT_VALUE "VERILOG"
    set_parameter_property SELECT_ED_FILESET DISPLAY_NAME "Generate File Format"
    set_parameter_property SELECT_ED_FILESET DESCRIPTION \
        "Please select an HDL format for the generated Design Example filesets. \
        Note that this will only affect the generated top level IP files."
    set_parameter_property SELECT_ED_FILESET ALLOWED_RANGES { "VERILOG:Verilog" "VHDL:VHDL"}
    set_parameter_property SELECT_ED_FILESET HDL_PARAMETER false

    add_parameter SELECT_TARGETED_BOARD INTEGER 1
    set_parameter_property SELECT_TARGETED_BOARD DEFAULT_VALUE "1"
    set_parameter_property SELECT_TARGETED_BOARD DISPLAY_NAME "Select Board"
    set_parameter_property SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" "1:Arria 10 GX FPGA Development Kit" "2:Custom Development Kit" }
    set_parameter_property SELECT_TARGETED_BOARD HDL_PARAMETER false
    set_parameter_update_callback SELECT_TARGETED_BOARD update_target_board_params
    set_parameter_property SELECT_TARGETED_BOARD DESCRIPTION \
        "<html>This option provides supports for various Development Kits listed. The details of Intel FPGA Development Kits can be found on Intel FPGA website \
        <a href='https://www.altera.com/products/boards_and_kits/all-development-kits.html'>https://www.altera.com/products/boards_and_kits/all-development-kits.html</a>. \
        If this menu is greyed out, it is because no board is supported for the options selected such as synthesis checked off. \
        If an Intel FPGA Development board is selected, the Target Device used for generation will be the one that matches the device on the Development Kit<br> \
        <br> \
        <b>Intel FPGA Development Kit:</b><br> \
        This option allows the Design Example to be tested on the selected Intel FPGA development kit. \
        This selection automatically selects the Target Device to match the device on the selected Intel FPGA development kit. \
        If your board revision has a different grade of this device, you can correct it.<br> \
        <br> \
        <b>Custom Development Kit:</b><br> \
        This option allows the Design Example to be tested on a third party development kit with Intel FPGA device, \
        a custom designed board with Intel FPGA device, or a standard Intel FPGA development kit not available for selection. \
        You may also select a custom device for the custom development kit.<br> \
        <br> \
        <b>No Development Kit:</b><br> \
        This option excluding hardware aspects for the Design Example.</html>"

    add_parameter SELECT_CUSTOM_DEVICE INTEGER 0
    set_parameter_property SELECT_CUSTOM_DEVICE DEFAULT_VALUE 0
    set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_NAME "Change Target Device"
    set_parameter_property SELECT_CUSTOM_DEVICE DESCRIPTION \
        "<html>When select, user is able to select different device grade for Intel FPGA development kit. \
        For device specific details look for Device data sheet on <a href='http://www.altera.com/'>www.altera.com</a></html>"
    set_parameter_property SELECT_CUSTOM_DEVICE TYPE INTEGER
    set_parameter_property SELECT_CUSTOM_DEVICE UNITS None
    set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_HINT boolean
    set_parameter_property SELECT_CUSTOM_DEVICE HDL_PARAMETER false
}

proc update_vid_std_params {arg} {
  set std [get_parameter_value $arg]

  set_parameter_value DIRECTION [get_parameter_property DIRECTION DEFAULT_VALUE] 
  set_parameter_value TRANSCEIVER_PROTOCOL [get_parameter_property TRANSCEIVER_PROTOCOL DEFAULT_VALUE]
  set_parameter_value RX_INC_ERR_TOLERANCE [get_parameter_property RX_INC_ERR_TOLERANCE DEFAULT_VALUE] 
  set_parameter_value RX_CRC_ERROR_OUTPUT [get_parameter_property RX_CRC_ERROR_OUTPUT DEFAULT_VALUE]
  #set_parameter_value RX_EN_TRS_MISC [get_parameter_property RX_EN_TRS_MISC DEFAULT_VALUE] 
  set_parameter_value RX_EN_VPID_EXTRACT [get_parameter_property RX_EN_VPID_EXTRACT DEFAULT_VALUE]
  set_parameter_value RX_EN_A2B_CONV [get_parameter_property RX_EN_A2B_CONV DEFAULT_VALUE] 
  set_parameter_value RX_EN_B2A_CONV [get_parameter_property RX_EN_B2A_CONV DEFAULT_VALUE]
  set_parameter_value TX_HD_2X_OVERSAMPLING [get_parameter_property TX_HD_2X_OVERSAMPLING DEFAULT_VALUE] 
  set_parameter_value TX_EN_VPID_INSERT [get_parameter_property TX_EN_VPID_INSERT DEFAULT_VALUE]
  set_parameter_value SD_BIT_WIDTH [get_parameter_property SD_BIT_WIDTH DEFAULT_VALUE]
  set_parameter_value XCVR_TX_PLL_SEL [get_parameter_property XCVR_TX_PLL_SEL DEFAULT_VALUE]
  set_parameter_value HD_FREQ [get_parameter_property HD_FREQ DEFAULT_VALUE]
  set_parameter_value ED_TXPLL_SWITCH [get_parameter_property ED_TXPLL_SWITCH DEFAULT_VALUE]
  set_parameter_value SELECT_SUPPORTED_VARIANT [get_parameter_property SELECT_SUPPORTED_VARIANT DEFAULT_VALUE]
  set_parameter_value SELECT_CUSTOM_DEVICE [get_parameter_property SELECT_CUSTOM_DEVICE DEFAULT_VALUE]

  if { $std == "ds" } {
    #set_parameter_value TEST_LN_OUTPUT    0
    set_parameter_value TEST_SYNC_OUTPUT  0
    set_parameter_value TEST_RECONFIG_SEQ "HDSD"
  } elseif { $std == "tr" | $std == "mr" } {
    #set_parameter_value TEST_LN_OUTPUT    0
    set_parameter_value TEST_SYNC_OUTPUT  0
    set_parameter_value RX_EN_VPID_EXTRACT 1
    set_parameter_value TX_EN_VPID_INSERT 1
    if { $std == "mr" } {
       set_parameter_value ED_TXPLL_TYPE     "fPLL"
       set_parameter_value TEST_RECONFIG_SEQ "half"
    } else {
       set_parameter_value TEST_RECONFIG_SEQ "full"
    }
  } elseif { $std == "threeg" } {
    set_parameter_value TEST_RECONFIG_SEQ "3GA"
    set_parameter_value RX_EN_VPID_EXTRACT 1
    set_parameter_value TX_EN_VPID_INSERT 1
  } elseif { $std == "dl" } {
     set_parameter_value RX_EN_VPID_EXTRACT 1
     set_parameter_value TX_EN_VPID_INSERT 1
  }
  
  #############################
  # Design Example supported
  #############################
  if { $std == "mr" && [get_parameter_value DIRECTION] == "du" } {
      set_parameter_value     SELECT_TARGETED_BOARD      0
  } else {
      set_parameter_value     SELECT_TARGETED_BOARD      1
  }
}

proc update_dir_params {arg} {
  set std [get_parameter_value VIDEO_STANDARD]
  set dir [get_parameter_value DIRECTION]
  set fam [get_parameter_value FAMILY]
  set config [get_parameter_value TRANSCEIVER_PROTOCOL]

  set_parameter_value RX_INC_ERR_TOLERANCE [get_parameter_property RX_INC_ERR_TOLERANCE DEFAULT_VALUE] 
  set_parameter_value RX_CRC_ERROR_OUTPUT [get_parameter_property RX_CRC_ERROR_OUTPUT DEFAULT_VALUE]
  #set_parameter_value RX_EN_TRS_MISC [get_parameter_property RX_EN_TRS_MISC DEFAULT_VALUE] 
  set_parameter_value RX_EN_VPID_EXTRACT [get_parameter_property RX_EN_VPID_EXTRACT DEFAULT_VALUE]
  set_parameter_value RX_EN_A2B_CONV [get_parameter_property RX_EN_A2B_CONV DEFAULT_VALUE] 
  set_parameter_value RX_EN_B2A_CONV [get_parameter_property RX_EN_B2A_CONV DEFAULT_VALUE]
  #set_parameter_value TX_HD_2X_OVERSAMPLING [get_parameter_property TX_HD_2X_OVERSAMPLING DEFAULT_VALUE]
  set_parameter_value TX_EN_VPID_INSERT [get_parameter_property TX_EN_VPID_INSERT DEFAULT_VALUE]
  set_parameter_value XCVR_TX_PLL_SEL [get_parameter_property XCVR_TX_PLL_SEL DEFAULT_VALUE]
  set_parameter_value HD_FREQ [get_parameter_property HD_FREQ DEFAULT_VALUE]
  
  if { $std == "threeg" || $std == "tr" || $std == "dl" || $std == "mr"} {
     if { $dir == "du" & $config != "xcvr" } {
        set_parameter_value RX_EN_VPID_EXTRACT 1
        set_parameter_value TX_EN_VPID_INSERT 1
     } elseif { $dir == "rx" & $config != "xcvr" } {
        set_parameter_value RX_EN_VPID_EXTRACT 1
     }
  }

  if { ($fam != "Stratix V" || $fam != "Arria V GZ") | $dir == "rx"} {
    set_parameter_value XCVR_TXPLL_TYPE [get_parameter_property XCVR_TXPLL_TYPE DEFAULT_VALUE]
  }

  if { $std == "mr" && $dir == "du" } {
    set_parameter_value     SELECT_TARGETED_BOARD      0
    set_parameter_value     SELECT_CUSTOM_DEVICE       0
  } else {
    set_parameter_value     SELECT_TARGETED_BOARD      1
    set_parameter_value     SELECT_CUSTOM_DEVICE       0
  }
}

proc update_config_params {arg} {
  set config [get_parameter_value TRANSCEIVER_PROTOCOL]
  set dir [get_parameter_value DIRECTION]
  set std [get_parameter_value VIDEO_STANDARD]

  set_parameter_value RX_INC_ERR_TOLERANCE [get_parameter_property RX_INC_ERR_TOLERANCE DEFAULT_VALUE] 
  set_parameter_value RX_CRC_ERROR_OUTPUT [get_parameter_property RX_CRC_ERROR_OUTPUT DEFAULT_VALUE]
  #set_parameter_value RX_EN_TRS_MISC [get_parameter_property RX_EN_TRS_MISC DEFAULT_VALUE] 
  set_parameter_value RX_EN_VPID_EXTRACT [get_parameter_property RX_EN_VPID_EXTRACT DEFAULT_VALUE]
  set_parameter_value RX_EN_A2B_CONV [get_parameter_property RX_EN_A2B_CONV DEFAULT_VALUE] 
  set_parameter_value RX_EN_B2A_CONV [get_parameter_property RX_EN_B2A_CONV DEFAULT_VALUE]
  #set_parameter_value TX_HD_2X_OVERSAMPLING [get_parameter_property TX_HD_2X_OVERSAMPLING DEFAULT_VALUE]
  set_parameter_value TX_EN_VPID_INSERT [get_parameter_property TX_EN_VPID_INSERT DEFAULT_VALUE]
  set_parameter_value XCVR_TX_PLL_SEL [get_parameter_property XCVR_TX_PLL_SEL DEFAULT_VALUE]
  set_parameter_value HD_FREQ [get_parameter_property HD_FREQ DEFAULT_VALUE]
  
  if { $config == "proto" } {
    set_parameter_value XCVR_TXPLL_TYPE [get_parameter_property XCVR_TXPLL_TYPE DEFAULT_VALUE]
    set_parameter_value XCVR_TX_PLL_SEL [get_parameter_property XCVR_TX_PLL_SEL DEFAULT_VALUE]
  }
  
  if { $std == "threeg" || $std == "tr" || $std == "dl" || $std == "mr"} {
     if { $dir == "du" & $config != "xcvr" } {
        set_parameter_value RX_EN_VPID_EXTRACT 1
        set_parameter_value TX_EN_VPID_INSERT 1
     } elseif { $dir == "rx" & $config != "xcvr" } {
        set_parameter_value RX_EN_VPID_EXTRACT 1
     }
  }
}

proc update_txpll_type_params {arg} {
  set_parameter_value HD_FREQ [get_parameter_property HD_FREQ DEFAULT_VALUE]
  if { [get_parameter_value XCVR_TX_PLL_SEL] == 2 } {
      set_parameter_value XCVR_TX_PLL_SEL 1
  }  
}

proc update_support_var_params {arg} {
    set support_var [get_parameter_value SELECT_SUPPORTED_VARIANT]

    set_parameter_value ED_TXPLL_SWITCH [get_parameter_property ED_TXPLL_SWITCH DEFAULT_VALUE]
    if { $support_var == 2} {
        set_parameter_value ED_TXPLL_TYPE   "fPLL"
    }
}

proc update_target_board_params {arg} {
    set target_board [get_parameter_value SELECT_TARGETED_BOARD]
    
    if {$target_board != 0} {
        set_parameter_value SELECT_CUSTOM_DEVICE 1
    } else {
        set_parameter_value SELECT_CUSTOM_DEVICE 0
    }
}

# proc update_vpid_params {arg} {
#   set vpid_param_en [get_parameter_value $arg]
#   set dir           [get_parameter_value DIRECTION]
#   
#   if { $vpid_param_en && $dir == "du"} {
#     set_parameter_value TX_EN_VPID_INSERT 1
#     set_parameter_value RX_EN_VPID_EXTRACT 1
#   }
# }

# +-----------------------------------
# | Define list of supported device families
# |
proc list_s4_style_hssi_families { } {
  return [ list "Stratix V" "Arria V" "Arria V GZ" "Cyclone V" "Arria 10"]
}

# +-----------------------------------
# | Define list of supported video standard
# |
proc get_sd_name    { } { return "sd:SD-SDI" }
proc get_hd_name    { } { return "hd:HD-SDI" }
proc get_3g_name    { } { return "threeg:3G-SDI" }
proc get_dl_name    { } { return "dl:HD-SDI dual link" }
proc get_ds_name    { } { return "ds:Dual rate (up to HD-SDI)" }
proc get_tr_name    { } { return "tr:Triple rate (up to 3G-SDI)" }
proc get_mr_name    { } { return "mr:Multi rate (up to 12G-SDI)" }

proc list_vid_std { } {
  return [ list [get_sd_name] [get_hd_name] [get_3g_name] [get_dl_name] [get_ds_name] [get_tr_name] [get_mr_name]]
}

# +-----------------------------------
# | Define list of supported direction
# |
proc get_bidir_name { } { return "du:Bidirectional" }
proc get_tx_name    { } { return "tx:Transmitter" }
proc get_rx_name    { } { return "rx:Receiver" }

proc list_direction { } {
  return [ list [get_bidir_name] [get_tx_name] [get_rx_name]]
}

# +-----------------------------------
# | Define list of supported blocks
# |
proc get_xcvr_proto_name { } { return "xcvr_proto:Combined" }
proc get_xcvr_name       { } { return "xcvr:Transceiver" }
proc get_proto_name      { } { return "proto:Protocol" }

proc list_blocks { } {
  return [ list [get_xcvr_proto_name] [get_xcvr_name] [get_proto_name]]
}

# +-----------------------------------
# | Define list of Tx PLL type
# |
proc get_cmu_name { } { return "CMU:CMU" }
proc get_atx_name { } { return "ATX:ATX" }

proc list_txpll_type { } {
  return [ list [get_cmu_name] [get_atx_name]]
}

# +-----------------------------------
# | Define list of ATX PLL data rates
# |
proc get_11880 { } { return "11880:11880 Mbps" }
proc get_5940  { } { return "5940:5940 Mbps" }
proc get_2970  { } { return "2970:2970 Mbps" }

proc list_atxpll_data_rate { } {
  return [ list [get_11880] [get_5940] [get_2970]]
}

# +-----------------------------------
# | Define list of core & xcvr refclk freq
# |
proc get_148_5 { } { return "148.5:148.5 MHz/148.35 MHz" }
proc get_74_25 { } { return "74.25:74.25 MHz/74.175 MHz" }

proc list_hd_freq { } {
  return [ list [get_148_5] [get_74_25]]
}

# +-----------------------------------
# | Testbench, Design Example 
# | Common parameters
# |
proc sdi_ii_tb_ed_common_params {} {
  add_parameter NUM_INST integer 4
  set_parameter_property NUM_INST DISPLAY_NAME "Number of SDI core required for design example" 
  set_parameter_property NUM_INST AFFECTS_ELABORATION true
  set_parameter_property NUM_INST DERIVED true

  add_parameter INST1 string "dut_du_proto"
  set_parameter_property INST1 DISPLAY_NAME "Variation name of sub instance 1"
  set_parameter_property INST1 AFFECTS_ELABORATION true
  set_parameter_property INST1 DERIVED true

  add_parameter INST2 string "dut_du_proto"
  set_parameter_property INST2 DISPLAY_NAME "Variation name of sub instance 2"
  set_parameter_property INST2 AFFECTS_ELABORATION true
  set_parameter_property INST2 DERIVED true

  add_parameter INST3 string "dut_du_proto"
  set_parameter_property INST3 DISPLAY_NAME "Variation name of sub instance 3"
  set_parameter_property INST3 AFFECTS_ELABORATION true
  set_parameter_property INST3 DERIVED true

  add_parameter INST4 string "dut_du_proto"
  set_parameter_property INST4 DISPLAY_NAME "Variation name of sub instance 4"
  set_parameter_property INST4 AFFECTS_ELABORATION true
  set_parameter_property INST4 DERIVED true
}

# +-----------------------------------
# | Testbench, Design Example 
# | Common parameters
# |
proc sdi_ii_tb_ed_common_params {} {
  add_parameter NUM_INST integer 4
  set_parameter_property NUM_INST DISPLAY_NAME "Number of SDI core required for design example" 
  set_parameter_property NUM_INST AFFECTS_ELABORATION true
  set_parameter_property NUM_INST DERIVED true

  add_parameter INST1 string "dut_du_proto"
  set_parameter_property INST1 DISPLAY_NAME "Variation name of sub instance 1"
  set_parameter_property INST1 AFFECTS_ELABORATION true
  set_parameter_property INST1 DERIVED true

  add_parameter INST2 string "dut_du_proto"
  set_parameter_property INST2 DISPLAY_NAME "Variation name of sub instance 2"
  set_parameter_property INST2 AFFECTS_ELABORATION true
  set_parameter_property INST2 DERIVED true

  add_parameter INST3 string "dut_du_proto"
  set_parameter_property INST3 DISPLAY_NAME "Variation name of sub instance 3"
  set_parameter_property INST3 AFFECTS_ELABORATION true
  set_parameter_property INST3 DERIVED true

  add_parameter INST4 string "dut_du_proto"
  set_parameter_property INST4 DISPLAY_NAME "Variation name of sub instance 4"
  set_parameter_property INST4 AFFECTS_ELABORATION true
  set_parameter_property INST4 DERIVED true
}

# +-----------------------------------
# | Design Example 
# | Specific parameters
# |
proc sdi_ii_ed_params {} {
  add_parameter INST1_DIR string "du"
  set_parameter_property INST1_DIR DISPLAY_NAME "Direction of sub instance 1"
  set_parameter_property INST1_DIR AFFECTS_ELABORATION true
  set_parameter_property INST1_DIR DERIVED true

  add_parameter INST2_DIR string "du"
  set_parameter_property INST2_DIR DISPLAY_NAME "Direction of sub instance 2"
  set_parameter_property INST2_DIR AFFECTS_ELABORATION true
  set_parameter_property INST2_DIR DERIVED true

  add_parameter INST3_DIR string "du"
  set_parameter_property INST3_DIR DISPLAY_NAME "Direction of sub instance 3"
  set_parameter_property INST3_DIR AFFECTS_ELABORATION true
  set_parameter_property INST3_DIR DERIVED true

  add_parameter INST4_DIR string "du"
  set_parameter_property INST4_DIR DISPLAY_NAME "Direction of sub instance 4"
  set_parameter_property INST4_DIR AFFECTS_ELABORATION true
  set_parameter_property INST4_DIR DERIVED true

  add_parameter INST1_CONFIG string "xcvr_proto"
  set_parameter_property INST1_CONFIG DISPLAY_NAME "Configuration of sub instance 1"
  set_parameter_property INST1_CONFIG AFFECTS_ELABORATION true
  set_parameter_property INST1_CONFIG DERIVED true

  add_parameter INST2_CONFIG string "xcvr_proto"
  set_parameter_property INST2_CONFIG DISPLAY_NAME "Configuration of sub instance 2"
  set_parameter_property INST2_CONFIG AFFECTS_ELABORATION true
  set_parameter_property INST2_CONFIG DERIVED true

  add_parameter INST3_CONFIG string "xcvr_proto"
  set_parameter_property INST3_CONFIG DISPLAY_NAME "Configuration of sub instance 3"
  set_parameter_property INST3_CONFIG AFFECTS_ELABORATION true
  set_parameter_property INST3_CONFIG DERIVED true

  add_parameter INST4_CONFIG string "xcvr_proto"
  set_parameter_property INST4_CONFIG DISPLAY_NAME "Configuration of sub instance 4"
  set_parameter_property INST4_CONFIG AFFECTS_ELABORATION true
  set_parameter_property INST4_CONFIG DERIVED true

}

proc sdi_ii_ed_reconfig_params {} {

  add_parameter NUM_CHS integer 1
  set_parameter_property NUM_CHS HDL_PARAMETER false
  set_parameter_property NUM_CHS ALLOWED_RANGES {1 2 3 4 5 6}
  set_parameter_property NUM_CHS VISIBLE false
  
  add_parameter NUM_INTERFACES integer 1
  set_parameter_property NUM_INTERFACES HDL_PARAMETER false
  set_parameter_property NUM_INTERFACES VISIBLE false
}

# +-----------------------------------
# | Testbench 
# | Specific parameters
# |
proc sdi_ii_test_params {} {
  add_parameter INTERNAL_TEST integer 0
  set_parameter_property INTERNAL_TEST ALLOWED_RANGES {0:1}
  set_parameter_property INTERNAL_TEST HDL_PARAMETER false
  set_parameter_property INTERNAL_TEST VISIBLE false

  add_parameter TEST_LN_OUTPUT integer 1
  set_parameter_property TEST_LN_OUTPUT ALLOWED_RANGES {0:1}
  set_parameter_property TEST_LN_OUTPUT HDL_PARAMETER false
  set_parameter_property TEST_LN_OUTPUT VISIBLE false

  add_parameter TEST_SYNC_OUTPUT integer 1
  set_parameter_property TEST_SYNC_OUTPUT ALLOWED_RANGES {0:1}
  set_parameter_property TEST_SYNC_OUTPUT HDL_PARAMETER false
  set_parameter_property TEST_SYNC_OUTPUT VISIBLE false

  add_parameter TEST_RECONFIG_SEQ string "full"
  set_parameter_property TEST_RECONFIG_SEQ HDL_PARAMETER false
  set_parameter_property TEST_RECONFIG_SEQ VISIBLE false

  add_parameter TEST_DISTURB_SERIAL integer 0
  set_parameter_property TEST_DISTURB_SERIAL ALLOWED_RANGES {0:1}
  set_parameter_property TEST_DISTURB_SERIAL HDL_PARAMETER false
  set_parameter_property TEST_DISTURB_SERIAL VISIBLE false

  add_parameter TEST_DATA_COMPARE integer 0
  set_parameter_property TEST_DATA_COMPARE ALLOWED_RANGES {0:1}
  set_parameter_property TEST_DATA_COMPARE HDL_PARAMETER false
  set_parameter_property TEST_DATA_COMPARE VISIBLE false  

  add_parameter TEST_DL_SYNC integer 0
  set_parameter_property TEST_DL_SYNC ALLOWED_RANGES {0:1}
  set_parameter_property TEST_DL_SYNC HDL_PARAMETER false
  set_parameter_property TEST_DL_SYNC VISIBLE false

  add_parameter TEST_TRS_LOCKED integer 0
  set_parameter_property TEST_TRS_LOCKED ALLOWED_RANGES {0:1}
  set_parameter_property TEST_TRS_LOCKED HDL_PARAMETER false
  set_parameter_property TEST_TRS_LOCKED VISIBLE false

  add_parameter TEST_FRAME_LOCKED integer 0
  set_parameter_property TEST_FRAME_LOCKED ALLOWED_RANGES {0:1}
  set_parameter_property TEST_FRAME_LOCKED HDL_PARAMETER false
  set_parameter_property TEST_FRAME_LOCKED VISIBLE false
  
  add_parameter TEST_VPID_OVERWRITE integer 1
  set_parameter_property TEST_VPID_OVERWRITE ALLOWED_RANGES {0:1}
  set_parameter_property TEST_VPID_OVERWRITE HDL_PARAMETER false
  set_parameter_property TEST_VPID_OVERWRITE VISIBLE false
  
  add_parameter TEST_MULTI_RECON integer 0
  set_parameter_property TEST_MULTI_RECON ALLOWED_RANGES {0:1}
  set_parameter_property TEST_MULTI_RECON HDL_PARAMETER false
  set_parameter_property TEST_MULTI_RECON VISIBLE false

  add_parameter TEST_SERIAL_DELAY integer 0
  set_parameter_property TEST_SERIAL_DELAY ALLOWED_RANGES {0:1}
  set_parameter_property TEST_SERIAL_DELAY HDL_PARAMETER false
  set_parameter_property TEST_SERIAL_DELAY VISIBLE false 

  add_parameter TEST_RESET_SEQ integer 0
  set_parameter_property TEST_RESET_SEQ ALLOWED_RANGES {0:1}
  set_parameter_property TEST_RESET_SEQ HDL_PARAMETER false
  set_parameter_property TEST_RESET_SEQ VISIBLE false 

  add_parameter TEST_RESET_RECON integer 0
  set_parameter_property TEST_RESET_RECON ALLOWED_RANGES {0:1}
  set_parameter_property TEST_RESET_RECON HDL_PARAMETER false
  set_parameter_property TEST_RESET_RECON VISIBLE false 

  add_parameter TEST_RST_PRE_OW integer 0
  set_parameter_property TEST_RST_PRE_OW ALLOWED_RANGES {0:1}
  set_parameter_property TEST_RST_PRE_OW HDL_PARAMETER false
  set_parameter_property TEST_RST_PRE_OW VISIBLE false 

  add_parameter TEST_RXSAMPLE_CHK integer 0
  set_parameter_property TEST_RXSAMPLE_CHK ALLOWED_RANGES {0:1}
  set_parameter_property TEST_RXSAMPLE_CHK HDL_PARAMETER false
  set_parameter_property TEST_RXSAMPLE_CHK VISIBLE false 

}

proc sdi_ii_test_pattgen_params {} {
  add_parameter TEST_GEN_ANC integer 0
  set_parameter_property TEST_GEN_ANC HDL_PARAMETER true
  set_parameter_property TEST_GEN_ANC ALLOWED_RANGES {0:1}
  set_parameter_property TEST_GEN_ANC DISPLAY_HINT boolean
  set_parameter_property TEST_GEN_ANC VISIBLE false

  add_parameter TEST_GEN_VPID integer 0
  set_parameter_property TEST_GEN_VPID HDL_PARAMETER true
  set_parameter_property TEST_GEN_VPID ALLOWED_RANGES {0:1}
  set_parameter_property TEST_GEN_VPID DISPLAY_HINT boolean
  set_parameter_property TEST_GEN_VPID VISIBLE false

  add_parameter TEST_VPID_PKT_COUNT integer 1
  set_parameter_property TEST_VPID_PKT_COUNT HDL_PARAMETER true
  set_parameter_property TEST_VPID_PKT_COUNT ALLOWED_RANGES {1 2 3}
  set_parameter_property TEST_VPID_PKT_COUNT VISIBLE false

  add_parameter TEST_ERR_VPID integer 0
  set_parameter_property TEST_ERR_VPID HDL_PARAMETER true
  set_parameter_property TEST_ERR_VPID ALLOWED_RANGES {0:1}
  set_parameter_property TEST_ERR_VPID DISPLAY_HINT boolean
  set_parameter_property TEST_ERR_VPID VISIBLE false
}

# proc enable_pattgen_vpid_params {arg} {
#   set_parameter_value TEST_GEN_ANC  1
#   set_parameter_value TEST_GEN_VPID 1
# }

proc sdi_ii_test_multi_ch_params {} {
  add_parameter CH_NUMBER integer 1
  set_parameter_property CH_NUMBER HDL_PARAMETER false
  set_parameter_property CH_NUMBER ALLOWED_RANGES {0 1 2 3}
  set_parameter_property CH_NUMBER VISIBLE false
}

proc enable_tx_pll_switch { instance pll_type data_rate_0 pll_refclk_freq_0 data_rate_1 pll_refclk_freq_1 } {
  set_instance_parameter_value $instance gui_pll_reconfig_enable_pll_reconfig false
  set_instance_parameter_value $instance gui_embedded_reset 0
  set_instance_parameter_value $instance gui_pll_reconfig_pll_count 2
  set_instance_parameter_value $instance gui_pll_reconfig_refclk_count 2
  set_instance_parameter_value $instance gui_pll_reconfig_pll0_pll_type $pll_type
  set_instance_parameter_value $instance gui_pll_reconfig_pll0_data_rate $data_rate_0
  set_instance_parameter_value $instance gui_pll_reconfig_pll0_refclk_freq $pll_refclk_freq_0
  set_instance_parameter_value $instance gui_pll_reconfig_pll0_refclk_sel 0
  
  set_instance_parameter_value $instance gui_pll_reconfig_pll1_pll_type $pll_type
  set_instance_parameter_value $instance gui_pll_reconfig_pll1_data_rate $data_rate_1
  set_instance_parameter_value $instance gui_pll_reconfig_pll1_refclk_freq $pll_refclk_freq_1
  set_instance_parameter_value $instance gui_pll_reconfig_pll1_refclk_sel 1

}
