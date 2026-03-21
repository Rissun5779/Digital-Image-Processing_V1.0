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
# | 
# $Id: //acds/rel/18.1std/ip/pgm/altera_asmi_parallel2_top/altera_asmi_parallel2_top_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2018/07/18 $
# $Author: psgswbuild $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 16.1

# +-----------------------------------
# | module ALTASMI_PARALLEL
# +-----------------------------------
set_module_property NAME                            altera_asmi_parallel2_top
set_module_property AUTHOR                          "Intel Corporation"
set_module_property DATASHEET_URL                   "https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug-asmi2.pdf"
set_module_property DESCRIPTION                     "The Altera ASMI Parallel megafunction provides access to erasable \
                                                        programmable configurable serial (EPCS) and quad-serial configuration \
                                                        (EPCQ) devices through parallel data input and output ports."
set_module_property DISPLAY_NAME                    "ASMI Parallel II Intel FPGA IP"
set_module_property EDITABLE                        false
set_module_property VERSION                         18.1
set_module_property GROUP                           "Basic Functions/Configuration and Programming"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE    true
set_module_property INTERNAL                        false

set_module_property     VALIDATION_CALLBACK    validation
set_module_property     COMPOSITION_CALLBACK    compose

# Source files
source altera_asmi_parallel2_top_hw_proc.tcl


# +-----------------------------------
# | device family info
# +-----------------------------------
set all_supported_device_families_list {"Max 10" "Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "Stratix IV" \
                                            "Cyclone IV GX" "Cyclone IV E" "Cyclone III GL" "Arria II GZ" "Arria II GX" "Cyclone 10 GX" "Cyclone 10 LP" "Stratix 10"}
                                    
proc check_device_ini {device_families_list}     {
    set enable_max10    [get_quartus_ini enable_max10_active_serial ENABLED]
  
    if {$enable_max10 == 1} {
        lappend device_families_list    "MAX 10 FPGA"
     } 
    return $device_families_list
}

set device_list    [check_device_ini $all_supported_device_families_list]
set_module_property SUPPORTED_DEVICE_FAMILIES    $device_list

add_parameter           DEVICE_FAMILY   STRING
set_parameter_property  DEVICE_FAMILY   SYSTEM_INFO     {DEVICE_FAMILY}
set_parameter_property  DEVICE_FAMILY   VISIBLE         false
set_parameter_property  DEVICE_FAMILY       HDL_PARAMETER   true

add_parameter           INTENDED_DEVICE_FAMILY  STRING
set_parameter_property  INTENDED_DEVICE_FAMILY  SYSTEM_INFO     {DEVICE_FAMILY}
set_parameter_property  INTENDED_DEVICE_FAMILY  VISIBLE         false


# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------
# check elaboration procedure for hidden devices
set all_supported_SPI_list {"EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "EPCQ256" \
                            "EPCQ512" "EPCQL256" "EPCQL512" "EPCQL1024"}

set all_support_io_mode {"NORMAL" "STANDARD" "DUAL" "QUAD"}
# --- Parameters for HDL parameters generation --- #
# SPI device selection
add_parameter           FLASH_TYPE   STRING              "EPCQ128"
set_parameter_property  FLASH_TYPE   DISPLAY_NAME        "Configuration device type"
set_parameter_property  FLASH_TYPE   ALLOWED_RANGES      $all_supported_SPI_list
set_parameter_property  FLASH_TYPE   DESCRIPTION         "Select targeted devices"
set_parameter_property  FLASH_TYPE   AFFECTS_GENERATION  true

# Data width
add_parameter           DATA_WIDTH          STRING              "STANDARD"
set_parameter_property  DATA_WIDTH          DISPLAY_NAME        "Choose I/O mode"
set_parameter_property  DATA_WIDTH          ALLOWED_RANGES      $all_support_io_mode
set_parameter_property  DATA_WIDTH          DESCRIPTION         "Select extended data width when Fast Read operation is enabled"
set_parameter_property  DATA_WIDTH          AFFECTS_GENERATION  true

# use asmiblock - currently is invert. when check means not using ASMIBLOCK, so a bit confusing. Need to change the parameter name when updating presets.
add_parameter           USE_ASMIBLOCK               BOOLEAN             0
set_parameter_property  USE_ASMIBLOCK               DISPLAY_NAME        "Disable dedicated Active Serial interface"
set_parameter_property  USE_ASMIBLOCK               DESCRIPTION         "Check to route ASMIBLOCK signals to top level of design"
set_parameter_property  USE_ASMIBLOCK               AFFECTS_GENERATION  true

# use gpio
add_parameter           USE_GPIO    BOOLEAN             0
set_parameter_property  USE_GPIO    DISPLAY_NAME        "Enable SPI pins interface"
set_parameter_property  USE_GPIO    DESCRIPTION         "Check to translate ASMIBLOCK signals to SPI pins interface"
set_parameter_property  USE_GPIO    AFFECTS_GENERATION  true

# enable_sim model
add_parameter           ENABLE_SIM_MODEL  BOOLEAN             0
set_parameter_property  ENABLE_SIM_MODEL  DISPLAY_NAME        "Enable flash simulation model"
set_parameter_property  ENABLE_SIM_MODEL  DESCRIPTION         "Check to use dedicated flash simulation model shipped with IP, or user has to connect flash model manually"
set_parameter_property  ENABLE_SIM_MODEL  AFFECTS_GENERATION  true

# Check the number of ncs connected to flash
add_parameter           NCS_NUM     INTEGER             1
set_parameter_property  NCS_NUM     DISPLAY_NAME        "Number of Chip Select used"
set_parameter_property  NCS_NUM     ALLOWED_RANGES      {1:3}
set_parameter_property  NCS_NUM     DESCRIPTION         "Select the number of chip select connected to flash"
set_parameter_property  NCS_NUM     AFFECTS_GENERATION  true

# Show chip select conduit
add_parameter           CHIP_SELECT_EN  BOOLEAN             true
set_parameter_property  CHIP_SELECT_EN  AFFECTS_GENERATION  true
set_parameter_property  CHIP_SELECT_EN  AFFECTS_ELABORATION true
set_parameter_property  CHIP_SELECT_EN  VISIBLE             false

# debug parameters
add_parameter               PIPE_CSR INTEGER 0
set_parameter_property      PIPE_CSR DISPLAY_NAME "Pipeline CSR output"
set_parameter_property      PIPE_CSR UNITS None
set_parameter_property      PIPE_CSR ALLOWED_RANGES { "0:None" "1:Pipeline"}
set_parameter_property      PIPE_CSR AFFECTS_ELABORATION true
set_parameter_property      PIPE_CSR AFFECTS_GENERATION true
set_parameter_property      PIPE_CSR DERIVED false
set_parameter_property      PIPE_CSR HDL_PARAMETER false
set_parameter_property      PIPE_CSR VISIBLE       false

add_parameter               PIPE_XIP INTEGER 0
set_parameter_property      PIPE_XIP DISPLAY_NAME "Pipeline XIP output"
set_parameter_property      PIPE_XIP UNITS None
set_parameter_property      PIPE_XIP ALLOWED_RANGES { "0:None" "1:Pipeline"}
set_parameter_property      PIPE_XIP AFFECTS_ELABORATION true
set_parameter_property      PIPE_XIP AFFECTS_GENERATION true
set_parameter_property      PIPE_XIP DERIVED false
set_parameter_property      PIPE_XIP HDL_PARAMETER false
set_parameter_property      PIPE_XIP VISIBLE       false

add_parameter               PIPE_CMD_GEN_CMD INTEGER 0
set_parameter_property      PIPE_CMD_GEN_CMD DISPLAY_NAME "Pipeline Cmd Generator output"
set_parameter_property      PIPE_CMD_GEN_CMD UNITS None
set_parameter_property      PIPE_CMD_GEN_CMD ALLOWED_RANGES { "0:None" "1:Pipeline"}
set_parameter_property      PIPE_CMD_GEN_CMD AFFECTS_ELABORATION true
set_parameter_property      PIPE_CMD_GEN_CMD AFFECTS_GENERATION true
set_parameter_property      PIPE_CMD_GEN_CMD DERIVED false
set_parameter_property      PIPE_CMD_GEN_CMD HDL_PARAMETER false
set_parameter_property      PIPE_CMD_GEN_CMD VISIBLE       false

add_parameter               PIPE_MUX_CMD INTEGER 0
set_parameter_property      PIPE_MUX_CMD DISPLAY_NAME "Pipeline Mux Output"
set_parameter_property      PIPE_MUX_CMD UNITS None
set_parameter_property      PIPE_MUX_CMD ALLOWED_RANGES { "0:None" "1:Pipeline"}
set_parameter_property      PIPE_MUX_CMD AFFECTS_ELABORATION true
set_parameter_property      PIPE_MUX_CMD AFFECTS_GENERATION true
set_parameter_property      PIPE_MUX_CMD DERIVED false
set_parameter_property      PIPE_MUX_CMD HDL_PARAMETER false
set_parameter_property      PIPE_MUX_CMD VISIBLE       false
