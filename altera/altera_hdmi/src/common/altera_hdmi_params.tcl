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
proc altera_hdmi_common_params {} {

  # GUI 
  # Split to 2 tabs
  add_display_item "" "IP" GROUP tab
  add_display_item "" "Design Example" GROUP tab

  # IP tab
  # 
  add_display_item "IP" "Configuration Options" GROUP
  add_display_item "IP" "Status and Control Data Channel (SCDC) Options" GROUP

  add_parameter FAMILY string "STRATIX V"
  set_parameter_property FAMILY DISPLAY_NAME "Device family" 
  set_parameter_property FAMILY DESCRIPTION "Currently selected device family"
  set_parameter_property FAMILY SYSTEM_INFO {DEVICE_FAMILY}                     
  set fams [list_supported_families]
  set_parameter_property FAMILY ALLOWED_RANGES $fams
  set_parameter_property FAMILY AFFECTS_ELABORATION true
  set_parameter_property FAMILY HDL_PARAMETER true
  set_parameter_property FAMILY ENABLED false
  add_display_item "Configuration Options" FAMILY parameter 
  
  add_parameter DIRECTION string "tx"
  set_parameter_property DIRECTION DISPLAY_NAME "Direction" 
  set_parameter_property DIRECTION DESCRIPTION "Selects between HDMI transmit or HDMI receive"
  set dir [list_direction]
  set_parameter_property DIRECTION ALLOWED_RANGES $dir
  set_parameter_property DIRECTION AFFECTS_ELABORATION true
  #set_parameter_property DIRECTION HDL_PARAMETER true
  set_parameter_update_callback DIRECTION update_direction_params
  add_display_item "Configuration Options" DIRECTION parameter

  add_parameter SYMBOLS_PER_CLOCK integer 2
  set_parameter_property SYMBOLS_PER_CLOCK DISPLAY_NAME "Symbols per clock" 
  set_parameter_property SYMBOLS_PER_CLOCK DESCRIPTION "Select number of symbols per clock cycle"
  set_parameter_property SYMBOLS_PER_CLOCK ALLOWED_RANGES {1 2 4}
  set_parameter_property SYMBOLS_PER_CLOCK AFFECTS_ELABORATION true
  set_parameter_property SYMBOLS_PER_CLOCK HDL_PARAMETER true
  add_display_item "Configuration Options" SYMBOLS_PER_CLOCK parameter
  
  add_parameter DISABLE_ALIGN_DESKEW integer 0
  set_parameter_property DISABLE_ALIGN_DESKEW DISPLAY_NAME "Disable Align Deskew" 
  set_parameter_property DISABLE_ALIGN_DESKEW DESCRIPTION "Determine if the align deskew is required."
  set_parameter_property DISABLE_ALIGN_DESKEW ALLOWED_RANGES {0:1}
  set_parameter_property DISABLE_ALIGN_DESKEW DISPLAY_HINT "Boolean"
  set_parameter_property DISABLE_ALIGN_DESKEW AFFECTS_ELABORATION true
  set_parameter_property DISABLE_ALIGN_DESKEW HDL_PARAMETER true
  set_parameter_property DISABLE_ALIGN_DESKEW VISIBLE false
  set_parameter_update_callback DISABLE_ALIGN_DESKEW update_disable_align_deskew_params
  add_display_item "Configuration Options" DISABLE_ALIGN_DESKEW parameter
  
  add_parameter SUPPORT_AUXILIARY integer 1
  set_parameter_property SUPPORT_AUXILIARY DISPLAY_NAME "Support Auxiliary" 
  set_parameter_property SUPPORT_AUXILIARY DESCRIPTION "Determine if Auxiliary channel encoding/decoding is included."
  set_parameter_property SUPPORT_AUXILIARY ALLOWED_RANGES {0:1}
  set_parameter_property SUPPORT_AUXILIARY DISPLAY_HINT "Boolean"
  set_parameter_property SUPPORT_AUXILIARY AFFECTS_ELABORATION true
  set_parameter_property SUPPORT_AUXILIARY HDL_PARAMETER true
  set_parameter_update_callback SUPPORT_AUXILIARY update_support_auxiliary_params
  add_display_item "Configuration Options" SUPPORT_AUXILIARY parameter
  
  add_parameter SUPPORT_DEEP_COLOR integer 1
  set_parameter_property SUPPORT_DEEP_COLOR DISPLAY_NAME "Support Deep Color" 
  set_parameter_property SUPPORT_DEEP_COLOR DESCRIPTION "Determine if the core will encode/decode deep color formats."
  set_parameter_property SUPPORT_DEEP_COLOR ALLOWED_RANGES {0:1}
  set_parameter_property SUPPORT_DEEP_COLOR DISPLAY_HINT "Boolean"
  set_parameter_property SUPPORT_DEEP_COLOR AFFECTS_ELABORATION true
  set_parameter_property SUPPORT_DEEP_COLOR HDL_PARAMETER true	
  set_parameter_property SUPPORT_DEEP_COLOR VISIBLE TRUE	
  add_display_item "Configuration Options" SUPPORT_DEEP_COLOR parameter
  
  add_parameter SUPPORT_AUDIO integer 1
  set_parameter_property SUPPORT_AUDIO DISPLAY_NAME "Support Audio" 
  set_parameter_property SUPPORT_AUDIO DESCRIPTION "Determine if the core will encode/decode audio data."
  set_parameter_property SUPPORT_AUDIO ALLOWED_RANGES {0:1}
  set_parameter_property SUPPORT_AUDIO DISPLAY_HINT "Boolean"
  set_parameter_property SUPPORT_AUDIO AFFECTS_ELABORATION true
  set_parameter_property SUPPORT_AUDIO HDL_PARAMETER true
  set_parameter_update_callback SUPPORT_AUDIO update_support_audio_params
  add_display_item "Configuration Options" SUPPORT_AUDIO parameter
  
  add_parameter SUPPORT_32CHAN_AUDIO integer 0
  set_parameter_property SUPPORT_32CHAN_AUDIO DISPLAY_NAME "Support 32-channel Audio" 
  set_parameter_property SUPPORT_32CHAN_AUDIO DESCRIPTION "Determine if the core will support 32-channel audio."
  set_parameter_property SUPPORT_32CHAN_AUDIO ALLOWED_RANGES {0:1}
  set_parameter_property SUPPORT_32CHAN_AUDIO DISPLAY_HINT "Boolean"
  set_parameter_property SUPPORT_32CHAN_AUDIO AFFECTS_ELABORATION true
  set_parameter_property SUPPORT_32CHAN_AUDIO HDL_PARAMETER true
  set_parameter_property SUPPORT_32CHAN_AUDIO VISIBLE false	
  add_display_item "Configuration Options" SUPPORT_32CHAN_AUDIO parameter
  
  add_parameter SCDC_IEEE_ID std_logic_vector 0x000000
  set_parameter_property SCDC_IEEE_ID WIDTH 24
  set_parameter_property SCDC_IEEE_ID DISPLAY_NAME "Manufacturer OUI" 
  set_parameter_property SCDC_IEEE_ID DESCRIPTION "Manufacturer Organizationally Unique Identifier (OUI) assigned to the manufacturer to be written into SCDC registers of address 0xD0, 0xD1 and 0xD2.  User needs to enter 3-byte Hexadecimal data."
  set_parameter_property SCDC_IEEE_ID ALLOWED_RANGES {0x000:0xFFFFFF}
  set_parameter_property SCDC_IEEE_ID DISPLAY_HINT "Hexadecimal"
  set_parameter_property SCDC_IEEE_ID AFFECTS_ELABORATION true
  set_parameter_property SCDC_IEEE_ID HDL_PARAMETER false
  set_parameter_property SCDC_IEEE_ID VISIBLE TRUE	
  set_parameter_property SCDC_IEEE_ID ENABLED TRUE	
  set_parameter_update_callback SCDC_IEEE_ID update_support_scdc_ieee_id
  add_display_item "Status and Control Data Channel (SCDC) Options" SCDC_IEEE_ID parameter
  
  add_parameter SCDC_DEVICE_STRING std_logic_vector 0x0000000000000000
  set_parameter_property SCDC_DEVICE_STRING WIDTH 64
  set_parameter_property SCDC_DEVICE_STRING DISPLAY_NAME "Device ID String" 
  set_parameter_property SCDC_DEVICE_STRING DESCRIPTION "Identifies the sink device. You can enter up to eight ASCII characters."
  set_parameter_property SCDC_DEVICE_STRING ALLOWED_RANGES {0x00000000:0xFFFFFFFFFFFFFFFF}
  set_parameter_property SCDC_DEVICE_STRING DISPLAY_HINT "Hexadecimal"
  set_parameter_property SCDC_DEVICE_STRING AFFECTS_ELABORATION true
  set_parameter_property SCDC_DEVICE_STRING HDL_PARAMETER false
  set_parameter_property SCDC_DEVICE_STRING VISIBLE TRUE	
  set_parameter_property SCDC_DEVICE_STRING ENABLED TRUE	
  set_parameter_update_callback SCDC_DEVICE_STRING update_support_scdc_device_string
  add_display_item "Status and Control Data Channel (SCDC) Options" SCDC_DEVICE_STRING parameter
  
  add_parameter SCDC_HW_REVISION std_logic_vector 0x0
  set_parameter_property SCDC_HW_REVISION WIDTH 8
  set_parameter_property SCDC_HW_REVISION DISPLAY_NAME "Hardware Revision" 
  set_parameter_property SCDC_HW_REVISION DESCRIPTION "Indicates the hardware major and minor revision. You shall enter one byte of integer data. Upper byte represents hardware major revision. Lower byte represents hardware minor revision."
  set_parameter_property SCDC_HW_REVISION ALLOWED_RANGES {0x0:0xFF}
  set_parameter_property SCDC_HW_REVISION DISPLAY_HINT "Hexadecimal"
  set_parameter_property SCDC_HW_REVISION AFFECTS_ELABORATION true
  set_parameter_property SCDC_HW_REVISION HDL_PARAMETER false
  set_parameter_property SCDC_HW_REVISION VISIBLE TRUE
  set_parameter_property SCDC_HW_REVISION ENABLED TRUE	
  set_parameter_update_callback SCDC_HW_REVISION update_support_scdc_hw_revision
  add_display_item "Status and Control Data Channel (SCDC) Options" SCDC_HW_REVISION parameter

  # | Design Example tab  
  add_display_item "Design Example" "Available Design Example" GROUP
  add_display_item "Available Design Example" SELECT_SUPPORTED_VARIANT parameter

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
  add_display_item "Target Device" "target_dev" text "<html>Device Selected:     Family: Arria 10 Device 10AX115S4F45I3SGE2<br><br></html>"
  add_display_item "Target Device" SELECT_CUSTOM_DEVICE parameter
  add_display_item "Target Device" "custom_device_txt" text "<html></html>"

  # | 
  # +-----------------------------------

# +-----------------------------------
# | parameters
# | 

# Adding device family from system info, taken from reconfig
# controller setup, device_family must be lowercase
#add_parameter device_family STRING "Stratix V"
#set_parameter_property device_family DISPLAY_NAME "Device family"
#set_parameter_property device_family SYSTEM_INFO device_family ;#forces family to always match Qsys
#set_parameter_property device_family ALLOWED_RANGES {"Stratix V" "Arria V" "Arria V GZ" "Cyclone V" "Arria 10"}
#set_parameter_property device_family HDL_PARAMETER true 
#set_parameter_property device_family DESCRIPTION "Targeted device family"
#set_parameter_property device_family ENABLED false ; #Shows value, but must match family chosen

add_parameter DEVICE string "Unknown"
set_parameter_property DEVICE SYSTEM_INFO {DEVICE}
set_parameter_property DEVICE HDL_PARAMETER false
set_parameter_property DEVICE VISIBLE false

###add_parameter BASE_DEVICE string "Unknown"
###set_parameter_property BASE_DEVICE SYSTEM_INFO_TYPE {PART_TRAIT}
###set_parameter_property BASE_DEVICE SYSTEM_INFO_ARG {BASE_DEVICE}
###set_parameter_property BASE_DEVICE HDL_PARAMETER false
###set_parameter_property BASE_DEVICE VISIBLE false

add_parameter IGNORE_FAMILY INTEGER 0
set_parameter_property IGNORE_FAMILY HDL_PARAMETER false
set_parameter_property IGNORE_FAMILY VISIBLE false
set_parameter_property IGNORE_FAMILY AFFECTS_ELABORATION true

add_parameter ED_DEVICE string "Unknown"
set_parameter_property ED_DEVICE DERIVED true
set_parameter_property ED_DEVICE HDL_PARAMETER false
set_parameter_property ED_DEVICE VISIBLE false


  # Design Example Parameter
  add_parameter SELECT_SUPPORTED_VARIANT INTEGER 0
  set_parameter_property SELECT_SUPPORTED_VARIANT DEFAULT_VALUE "1"
  set_parameter_property SELECT_SUPPORTED_VARIANT DISPLAY_NAME "Select Design"
  set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES { "1:Arria10 DP RX-TX Retransmit with PCR" }
  set_parameter_property SELECT_SUPPORTED_VARIANT HDL_PARAMETER false
  set_parameter_update_callback SELECT_SUPPORTED_VARIANT update_support_var_params
  set_parameter_property SELECT_SUPPORTED_VARIANT DESCRIPTION \
        "<html>Please select available design for Design Example generation.<br> \
        <br> \
        We have the design example that come with specific IP and related parameter settings that \
        you may use by selecting one of the presets below.<br> \
        <br> \
        <i>Please note that when you apply preset, current IP and other parameter settings will be set to match those of selected preset. \
        If you like to save your current settings, you should do so before you hit apply preset. Also you can always save the new 'preset' \
        settings under a different name using File->Save as</i></html>"

  add_parameter ENABLE_ED_FILESET_SYNTHESIS INTEGER 0
  set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DEFAULT_VALUE 1
  set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_NAME "Synthesis"
  set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DESCRIPTION "When Synthesis box is checked, all necessary filesets required for synthesis will be generated."
  set_parameter_property ENABLE_ED_FILESET_SYNTHESIS TYPE INTEGER
  set_parameter_property ENABLE_ED_FILESET_SYNTHESIS UNITS None
  set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_HINT boolean
  set_parameter_property ENABLE_ED_FILESET_SYNTHESIS HDL_PARAMETER false

  add_parameter ENABLE_ED_FILESET_SIM INTEGER 0
  set_parameter_property ENABLE_ED_FILESET_SIM DEFAULT_VALUE 0
  set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_NAME "Simulation"
  set_parameter_property ENABLE_ED_FILESET_SIM DESCRIPTION "When Simulation box is checked, all necessary filesets required for simulation will be generated."
  set_parameter_property ENABLE_ED_FILESET_SIM TYPE INTEGER
  set_parameter_property ENABLE_ED_FILESET_SIM UNITS None
  set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_HINT boolean
  set_parameter_property ENABLE_ED_FILESET_SIM HDL_PARAMETER false
  #Un-comment line below to disable ENABLE_ED_FILESET_SIM
  #set_parameter_property ENABLE_ED_FILESET_SIM ENABLED false

  add_parameter SELECT_ED_FILESET string "VERILOG"
  set_parameter_property SELECT_ED_FILESET DEFAULT_VALUE "VERILOG"
  set_parameter_property SELECT_ED_FILESET DISPLAY_NAME "Generate File Format"
  set_parameter_property SELECT_ED_FILESET DESCRIPTION \
        "Please select an HDL format for the generated Design Example filesets. \
        Note that this will only affect the generated top level IP files."
  set_parameter_property SELECT_ED_FILESET ALLOWED_RANGES { "VERILOG:Verilog" "VHDL:VHDL"}
  set_parameter_property SELECT_ED_FILESET HDL_PARAMETER false

  add_parameter SELECT_TARGETED_BOARD INTEGER 0
  set_parameter_property SELECT_TARGETED_BOARD DEFAULT_VALUE "0"
  set_parameter_property SELECT_TARGETED_BOARD DISPLAY_NAME "Select Board"
  set_parameter_property SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" "1:Arria 10 GX FPGA Development Kit" "2:Custom Development Kit" }
  set_parameter_property SELECT_TARGETED_BOARD HDL_PARAMETER false
  set_parameter_update_callback SELECT_TARGETED_BOARD update_target_board_params
  set_parameter_property SELECT_TARGETED_BOARD DESCRIPTION \
        "<html>This option provides supports for various Development Kits listed. The details of Altera Development Kits can be found on Altera website \
        <a href='https://www.altera.com/products/boards_and_kits/all-development-kits.html'>https://www.altera.com/products/boards_and_kits/all-development-kits.html</a>. \
        If this menu is greyed out, it is because no board is supported for the options selected such as synthesis checked off. \
        If an Intel FPGA Development board is selected, the Target Device used for generation will be the one that matches the device on the Development Kit<br> \
        <br> \
        <b>Altera  Development Kit:</b><br> \
        This option allows the Design Example to be tested on the selected Altera development kit. \
        This selection automatically selects the Target Device to match the device on the selected Altera development kit. \
        If your board revision has a different grade of this device, you can correct it.<br> \
        <br> \
        <b>Custom Development Kit:</b><br> \
        This option allows the Design Example to be tested on a third party development kit with Altera device, \
        a custom designed board with Altera device, or a standard Altera development kit not available for selection. \
        You may also select a custom device for the custom development kit.<br> \
        <br> \
        <b>No Development Kit:</b><br> \
        This option excluding hardware aspects for the Design Example.</html>"

  add_parameter SELECT_CUSTOM_DEVICE INTEGER 0
  set_parameter_property SELECT_CUSTOM_DEVICE DEFAULT_VALUE 0
  set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_NAME "Change Target Device"
  set_parameter_property SELECT_CUSTOM_DEVICE DESCRIPTION \
        "<html>When select, user is able to select different device grade for Altera development kit. \
        For device specific details look for Device data sheet on <a href='http://www.altera.com/'>www.altera.com</a></html>"
  set_parameter_property SELECT_CUSTOM_DEVICE TYPE INTEGER
  set_parameter_property SELECT_CUSTOM_DEVICE UNITS None
  set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_HINT boolean
  set_parameter_property SELECT_CUSTOM_DEVICE HDL_PARAMETER false
  
}

proc list_supported_families { } {
  return [ list "Stratix V" "Arria V" "Arria V GZ" "Cyclone V" "Arria 10"]
}

# +-----------------------------------
# | Define list of supported direction
# |
proc get_bidir_name { } { return "du:Bidirectional" }
proc get_tx_name    { } { return "tx:Transmitter" }
proc get_rx_name    { } { return "rx:Receiver" }

proc list_direction { } {
  return [ list [get_tx_name] [get_rx_name] ]
}

proc update_support_auxiliary_params {arg} {	

  set support_aux [get_parameter_value SUPPORT_AUXILIARY]
  
  if { $support_aux } {
    set_parameter_value SUPPORT_DEEP_COLOR [get_parameter_property SUPPORT_DEEP_COLOR DEFAULT_VALUE] 
    set_parameter_value SUPPORT_AUDIO [get_parameter_property SUPPORT_AUDIO DEFAULT_VALUE] 
    set_parameter_value SUPPORT_32CHAN_AUDIO [get_parameter_property SUPPORT_32CHAN_AUDIO DEFAULT_VALUE]
  } else {
    set_parameter_value SUPPORT_DEEP_COLOR $support_aux
    set_parameter_value SUPPORT_AUDIO $support_aux
    set_parameter_value SUPPORT_32CHAN_AUDIO $support_aux
  }
	
}

proc update_support_audio_params {arg} {

  set support_audio [get_parameter_value SUPPORT_AUDIO]
  
  if { $support_audio } {
    set_parameter_value SUPPORT_32CHAN_AUDIO [get_parameter_property SUPPORT_32CHAN_AUDIO DEFAULT_VALUE]
  } else {
    set_parameter_value SUPPORT_32CHAN_AUDIO $support_audio
  }
}

proc update_direction_params {arg} {

  set dir [get_parameter_value DIRECTION]
  
  set_parameter_value DISABLE_ALIGN_DESKEW [get_parameter_property DISABLE_ALIGN_DESKEW DEFAULT_VALUE]
}


