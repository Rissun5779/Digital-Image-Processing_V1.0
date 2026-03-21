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


# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/altera_onchip_flash/altera_onchip_flash/altera_onchip_flash_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 14.0

# Source files
source ./altera_onchip_flash_hw_proc.tcl

# +-----------------------------------
# | module Altera Onchip Flash
# +-----------------------------------
set_module_property NAME                          altera_onchip_flash
set_module_property VERSION                       18.1
set_module_property DISPLAY_NAME                  "On-Chip Flash Intel FPGA IP"
set_module_property DESCRIPTION                   "Altera On-Chip Flash Megafunction with Avalon-MM Slave Interface."
set_module_property GROUP                         "Basic Functions/On Chip Memory"
set_module_property AUTHOR                        "Altera Corporation"
set_module_property DATASHEET_URL                 "http://www.altera.com/literature/hb/max-10/ug_m10_ufm.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE  true
set_module_property EDITABLE                      false
set_module_property HIDE_FROM_SOPC                true
set_module_property ELABORATION_CALLBACK          elaboration_callback
set_module_property PARAMETER_UPGRADE_CALLBACK    parameter_upgrade_callback
set_module_property INTERNAL                      false

set all_supported_device_families_list {"MAX 10"}
set_module_property SUPPORTED_DEVICE_FAMILIES     $all_supported_device_families_list

# +-----------------------------------
# | UI Interface
# +-----------------------------------
set PARAMETERS_GROUP "Parameters"
add_display_item {} $PARAMETERS_GROUP GROUP

set CONFIGURATION_MODE_GROUP "Configuration Mode"
add_display_item {} $CONFIGURATION_MODE_GROUP GROUP

set FLASH_MEMORY_GROUP "Flash Memory"
add_display_item {} $FLASH_MEMORY_GROUP GROUP

set FLASH_MEMORY_TABLE "Flash Memory Table"
add_display_item $FLASH_MEMORY_GROUP $FLASH_MEMORY_TABLE GROUP TABLE

set CLOCK_SOURCE_GROUP "Clock Source"
add_display_item {} $CLOCK_SOURCE_GROUP GROUP

set FLASH_INITIALIZATION_GROUP "Flash Initialization"
add_display_item {} $FLASH_INITIALIZATION_GROUP GROUP

# +-----------------------------------
# | Parameters
# +-----------------------------------

# Data Interface
add_parameter DATA_INTERFACE STRING "Parallel"
set_parameter_property DATA_INTERFACE DISPLAY_NAME "Data interface"
set_parameter_property DATA_INTERFACE DESCRIPTION "Avalon MM data slave interface mode"
set_parameter_property DATA_INTERFACE ALLOWED_RANGES {"Parallel" "Serial"}
set_parameter_property DATA_INTERFACE UNITS None
set_parameter_property DATA_INTERFACE DISPLAY_HINT ""
set_parameter_property DATA_INTERFACE HDL_PARAMETER false
set_parameter_property DATA_INTERFACE ENABLED true
add_display_item $PARAMETERS_GROUP DATA_INTERFACE parameter

# Read Burst Mode
add_parameter READ_BURST_MODE STRING "Incrementing"
set_parameter_property READ_BURST_MODE DISPLAY_NAME "Read burst mode"
set_parameter_property READ_BURST_MODE DESCRIPTION "Incrementing/Wrapping"
set_parameter_property READ_BURST_MODE ALLOWED_RANGES {"Incrementing" "Wrapping"}
set_parameter_property READ_BURST_MODE UNITS None
set_parameter_property READ_BURST_MODE DISPLAY_HINT ""
set_parameter_property READ_BURST_MODE HDL_PARAMETER false
set_parameter_property READ_BURST_MODE ENABLED true
add_display_item $PARAMETERS_GROUP READ_BURST_MODE parameter

# Read Burst Count
add_parameter READ_BURST_COUNT INTEGER 8
set_parameter_property READ_BURST_COUNT DISPLAY_NAME "Read burst count"
set_parameter_property READ_BURST_COUNT DESCRIPTION "Maximum burst count for 32-bits data"
set_parameter_property READ_BURST_COUNT ALLOWED_RANGES {2 4 8 16 32 64 128}
set_parameter_property READ_BURST_COUNT UNITS None
set_parameter_property READ_BURST_COUNT DISPLAY_HINT ""
set_parameter_property READ_BURST_COUNT HDL_PARAMETER false
set_parameter_property READ_BURST_COUNT ENABLED true
add_display_item $PARAMETERS_GROUP READ_BURST_COUNT parameter

# +-----------------------------------
# | Parameters - Clock Frequency
# +-----------------------------------

# Clock Frequency
add_parameter CLOCK_FREQUENCY FLOAT "116.0"
set_parameter_property CLOCK_FREQUENCY DISPLAY_NAME "Clock frequency"
set_parameter_property CLOCK_FREQUENCY DESCRIPTION "Specifies the clock frequency"
set_parameter_property CLOCK_FREQUENCY UNITS "megahertz"
set_parameter_property CLOCK_FREQUENCY DISPLAY_HINT ""
set_parameter_property CLOCK_FREQUENCY HDL_PARAMETER false
set_parameter_property CLOCK_FREQUENCY ENABLED true
add_display_item $CLOCK_SOURCE_GROUP CLOCK_FREQUENCY parameter

add_display_item $CLOCK_SOURCE_GROUP clockRateMessage TEXT ""

# +-----------------------------------
# | Parameters - Configuration Mode
# +-----------------------------------

# Configuration Mode
set configuration_scheme { \
	"Internal Configuration"
}

# Hidden support for MAX10 Active Serial mode
set enable_max10_active_serial [expr {[get_quartus_ini ENABLE_MAX10_ACTIVE_SERIAL ENABLED]==1 || [get_quartus_ini enable_max10_active_serial ENABLED]==1}]
if {$enable_max10_active_serial} {
	lappend configuration_scheme "Active Serial"
}

add_parameter CONFIGURATION_SCHEME STRING "Internal Configuration"
set_parameter_property CONFIGURATION_SCHEME DISPLAY_NAME "Configuration Scheme"
set_parameter_property CONFIGURATION_SCHEME DESCRIPTION "Configuration scheme."
set_parameter_property CONFIGURATION_SCHEME ALLOWED_RANGES $configuration_scheme
set_parameter_property CONFIGURATION_SCHEME UNITS None
set_parameter_property CONFIGURATION_SCHEME DISPLAY_HINT ""
if {$enable_max10_active_serial} {
	set_parameter_property CONFIGURATION_SCHEME ENABLED true
} else {
	set_parameter_property CONFIGURATION_SCHEME ENABLED false
}
add_display_item $CONFIGURATION_MODE_GROUP CONFIGURATION_SCHEME parameter

set configuration_mode { \
	"Dual Compressed Images" \
	"Single Uncompressed Image" \
	"Single Compressed Image" \
	"Single Uncompressed Image with Memory Initialization" \
	"Single Compressed Image with Memory Initialization" \
}
add_parameter CONFIGURATION_MODE STRING "Single Uncompressed Image"
set_parameter_property CONFIGURATION_MODE DISPLAY_NAME "Configuration Mode"
set_parameter_property CONFIGURATION_MODE DESCRIPTION "Configuration mode."
set_parameter_property CONFIGURATION_MODE UNITS None
set_parameter_property CONFIGURATION_MODE DISPLAY_HINT ""
set_parameter_property CONFIGURATION_MODE HDL_PARAMETER false
set_parameter_property CONFIGURATION_MODE ENABLED true
add_display_item $CONFIGURATION_MODE_GROUP CONFIGURATION_MODE parameter

# +-----------------------------------
# | Parameters - Flash memory + protection scheme Table
# +-----------------------------------

add_parameter SECTOR_ID STRING_LIST
set_parameter_property SECTOR_ID DISPLAY_NAME "Sector ID"
set_parameter_property SECTOR_ID DESCRIPTION "Flash Sector ID"
set_parameter_property SECTOR_ID UNITS None
set_parameter_property SECTOR_ID DISPLAY_HINT ""
set_parameter_property SECTOR_ID HDL_PARAMETER false
set_parameter_property SECTOR_ID ENABLED false
set_parameter_property SECTOR_ID DERIVED true
add_display_item $FLASH_MEMORY_TABLE SECTOR_ID parameter

add_parameter SECTOR_ACCESS_MODE STRING_LIST {"Read and write" "Read and write" "Read only" "Hidden" "Hidden"}
set_parameter_property SECTOR_ACCESS_MODE DISPLAY_NAME "Access Mode"
set_parameter_property SECTOR_ACCESS_MODE DESCRIPTION "Flash Sector Access Mode"
set_parameter_property SECTOR_ACCESS_MODE ALLOWED_RANGES {"Read and write" "Read only" "Hidden"}
set_parameter_property SECTOR_ACCESS_MODE UNITS None
set_parameter_property SECTOR_ACCESS_MODE DISPLAY_HINT ""
set_parameter_property SECTOR_ACCESS_MODE HDL_PARAMETER false
set_parameter_property SECTOR_ACCESS_MODE ENABLED true
set_parameter_update_callback SECTOR_ACCESS_MODE access_mode_change_callback ""
add_display_item $FLASH_MEMORY_TABLE SECTOR_ACCESS_MODE parameter

add_parameter SECTOR_ADDRESS_MAPPING STRING_LIST
set_parameter_property SECTOR_ADDRESS_MAPPING DISPLAY_NAME "Address Mapping"
set_parameter_property SECTOR_ADDRESS_MAPPING DESCRIPTION "Flash Sector Address Mapping"
set_parameter_property SECTOR_ADDRESS_MAPPING UNITS None
set_parameter_property SECTOR_ADDRESS_MAPPING DISPLAY_HINT ""
set_parameter_property SECTOR_ADDRESS_MAPPING HDL_PARAMETER false
set_parameter_property SECTOR_ADDRESS_MAPPING ENABLED false
set_parameter_property SECTOR_ADDRESS_MAPPING DERIVED true
add_display_item $FLASH_MEMORY_TABLE SECTOR_ADDRESS_MAPPING parameter

add_parameter SECTOR_STORAGE_TYPE STRING_LIST
set_parameter_property SECTOR_STORAGE_TYPE DISPLAY_NAME "Type"
set_parameter_property SECTOR_STORAGE_TYPE DESCRIPTION "Flash Sector Storage Type"
set_parameter_property SECTOR_STORAGE_TYPE UNITS None
set_parameter_property SECTOR_STORAGE_TYPE DISPLAY_HINT ""
set_parameter_property SECTOR_STORAGE_TYPE HDL_PARAMETER false
set_parameter_property SECTOR_STORAGE_TYPE ENABLED false
set_parameter_property SECTOR_STORAGE_TYPE DERIVED true
add_display_item $FLASH_MEMORY_TABLE SECTOR_STORAGE_TYPE parameter

# +-----------------------------------
# | Parameters - Flash init file options
# +-----------------------------------

# Enable init file name
add_parameter initFlashContent BOOLEAN
set_parameter_property initFlashContent DEFAULT_VALUE false
set_parameter_property initFlashContent DISPLAY_NAME "Initialize flash content"
set_parameter_property initFlashContent HDL_PARAMETER false
add_display_item $FLASH_INITIALIZATION_GROUP initFlashContent PARAMETER

add_parameter useNonDefaultInitFile BOOLEAN
set_parameter_property useNonDefaultInitFile DEFAULT_VALUE false
set_parameter_property useNonDefaultInitFile DISPLAY_NAME "Enable non-default initialization file"
set_parameter_property useNonDefaultInitFile HDL_PARAMETER false
add_display_item $FLASH_INITIALIZATION_GROUP useNonDefaultInitFile PARAMETER

add_parameter initializationFileName STRING
set_parameter_property initializationFileName DEFAULT_VALUE "altera_onchip_flash.hex"
set_parameter_property initializationFileName DISPLAY_NAME "          User created hex or mif file"
set_parameter_property initializationFileName DESCRIPTION "Type the filename (e.g: my_flash.hex) or select the hex or mif file using the file browser button."
set_parameter_property initializationFileName HDL_PARAMETER false
set_parameter_property initializationFileName DISPLAY_HINT "file"
set_display_item_property initializationFileName DISPLAY_HINT "file"
add_display_item $FLASH_INITIALIZATION_GROUP initializationFileName PARAMETER

add_parameter initializationFileNameForSim STRING
set_parameter_property initializationFileNameForSim DEFAULT_VALUE "altera_onchip_flash.dat"
set_parameter_property initializationFileNameForSim DISPLAY_NAME "          User created dat file for simulation"
set_parameter_property initializationFileNameForSim DESCRIPTION "Type the filename (e.g: my_flash.dat) or select the dat file using the file browser button."
set_parameter_property initializationFileNameForSim HDL_PARAMETER false
set_parameter_property initializationFileNameForSim DISPLAY_HINT "file"
set_display_item_property initializationFileNameForSim DISPLAY_HINT "file"
add_display_item $FLASH_INITIALIZATION_GROUP initializationFileNameForSim PARAMETER

add_display_item $FLASH_INITIALIZATION_GROUP flashInitMessage TEXT ""

# Auto initialization filename
add_parameter autoInitializationFileName STRING
set_parameter_property autoInitializationFileName DISPLAY_NAME {autoInitializationFileName}
set_parameter_property autoInitializationFileName VISIBLE false
set_parameter_property autoInitializationFileName HDL_PARAMETER false
set_parameter_property autoInitializationFileName SYSTEM_INFO {unique_id}
set_parameter_property autoInitializationFileName SYSTEM_INFO_TYPE {UNIQUE_ID}

# INIT_FILENAME is a HDL Parameter for synthesis
add_parameter INIT_FILENAME STRING ""
set_parameter_property INIT_FILENAME VISIBLE false
set_parameter_property INIT_FILENAME ENABLED false
set_parameter_property INIT_FILENAME HDL_PARAMETER true
set_parameter_property INIT_FILENAME DERIVED true

# INIT_FILENAME_SIM is a HDL Parameter for simulation
add_parameter INIT_FILENAME_SIM STRING ""
set_parameter_property INIT_FILENAME_SIM VISIBLE false
set_parameter_property INIT_FILENAME_SIM ENABLED false
set_parameter_property INIT_FILENAME_SIM HDL_PARAMETER true
set_parameter_property INIT_FILENAME_SIM DERIVED true

# +-----------------------------------
# | Parameters - Project Settings 
# +-----------------------------------
add_parameter DEVICE_FAMILY STRING "Unknown"
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY HDL_PARAMETER true

add_parameter PART_NAME STRING "Unknown"
set_parameter_property PART_NAME VISIBLE false
set_parameter_property PART_NAME SYSTEM_INFO {DEVICE}
set_parameter_property PART_NAME HDL_PARAMETER true

add_parameter AUTO_CLOCK_RATE LONG
set_parameter_property AUTO_CLOCK_RATE VISIBLE false
set_parameter_property AUTO_CLOCK_RATE SYSTEM_INFO_TYPE CLOCK_RATE
set_parameter_property AUTO_CLOCK_RATE SYSTEM_INFO_ARG clk

# parameter for simulation model
add_parameter DEVICE_ID STRING "Unknown"
set_parameter_property DEVICE_ID VISIBLE false
set_parameter_property DEVICE_ID HDL_PARAMETER true
set_parameter_property DEVICE_ID DERIVED true

# +-----------------------------------
# | Hidden Parameters - Device specific setting / flash size restriction
# +-----------------------------------
# UFM1 address range
add_parameter SECTOR1_START_ADDR INTEGER 0
set_parameter_property SECTOR1_START_ADDR VISIBLE false
set_parameter_property SECTOR1_START_ADDR ENABLED false
set_parameter_property SECTOR1_START_ADDR HDL_PARAMETER true
set_parameter_property SECTOR1_START_ADDR DERIVED true

add_parameter SECTOR1_END_ADDR INTEGER 0
set_parameter_property SECTOR1_END_ADDR VISIBLE false
set_parameter_property SECTOR1_END_ADDR ENABLED false
set_parameter_property SECTOR1_END_ADDR HDL_PARAMETER true
set_parameter_property SECTOR1_END_ADDR DERIVED true

# UFM0 address range
add_parameter SECTOR2_START_ADDR INTEGER 0
set_parameter_property SECTOR2_START_ADDR VISIBLE false
set_parameter_property SECTOR2_START_ADDR ENABLED false
set_parameter_property SECTOR2_START_ADDR HDL_PARAMETER true
set_parameter_property SECTOR2_START_ADDR DERIVED true

add_parameter SECTOR2_END_ADDR INTEGER 0
set_parameter_property SECTOR2_END_ADDR VISIBLE false
set_parameter_property SECTOR2_END_ADDR ENABLED false
set_parameter_property SECTOR2_END_ADDR HDL_PARAMETER true
set_parameter_property SECTOR2_END_ADDR DERIVED true

# CFM2 address range
add_parameter SECTOR3_START_ADDR INTEGER 0
set_parameter_property SECTOR3_START_ADDR VISIBLE false
set_parameter_property SECTOR3_START_ADDR ENABLED false
set_parameter_property SECTOR3_START_ADDR HDL_PARAMETER true
set_parameter_property SECTOR3_START_ADDR DERIVED true

add_parameter SECTOR3_END_ADDR INTEGER 0
set_parameter_property SECTOR3_END_ADDR VISIBLE false
set_parameter_property SECTOR3_END_ADDR ENABLED false
set_parameter_property SECTOR3_END_ADDR HDL_PARAMETER true
set_parameter_property SECTOR3_END_ADDR DERIVED true

# CFM1 address range
add_parameter SECTOR4_START_ADDR INTEGER 0
set_parameter_property SECTOR4_START_ADDR VISIBLE false
set_parameter_property SECTOR4_START_ADDR ENABLED false
set_parameter_property SECTOR4_START_ADDR HDL_PARAMETER true
set_parameter_property SECTOR4_START_ADDR DERIVED true

add_parameter SECTOR4_END_ADDR INTEGER 0
set_parameter_property SECTOR4_END_ADDR VISIBLE false
set_parameter_property SECTOR4_END_ADDR ENABLED false
set_parameter_property SECTOR4_END_ADDR HDL_PARAMETER true
set_parameter_property SECTOR4_END_ADDR DERIVED true

# CFM0 address range
add_parameter SECTOR5_START_ADDR INTEGER 0
set_parameter_property SECTOR5_START_ADDR VISIBLE false
set_parameter_property SECTOR5_START_ADDR ENABLED false
set_parameter_property SECTOR5_START_ADDR HDL_PARAMETER true
set_parameter_property SECTOR5_START_ADDR DERIVED true

add_parameter SECTOR5_END_ADDR INTEGER 0
set_parameter_property SECTOR5_END_ADDR VISIBLE false
set_parameter_property SECTOR5_END_ADDR ENABLED false
set_parameter_property SECTOR5_END_ADDR HDL_PARAMETER true
set_parameter_property SECTOR5_END_ADDR DERIVED true

# Record MIN and MAX available address, including both UFM and CFM
add_parameter MIN_VALID_ADDR INTEGER 0
set_parameter_property MIN_VALID_ADDR VISIBLE false
set_parameter_property MIN_VALID_ADDR ENABLED true
set_parameter_property MIN_VALID_ADDR HDL_PARAMETER true
set_parameter_property MIN_VALID_ADDR DERIVED true

add_parameter MAX_VALID_ADDR INTEGER 0
set_parameter_property MAX_VALID_ADDR VISIBLE false
set_parameter_property MAX_VALID_ADDR ENABLED true
set_parameter_property MAX_VALID_ADDR HDL_PARAMETER true
set_parameter_property MAX_VALID_ADDR DERIVED true

# Record UFM MIN and MAX available address
add_parameter MIN_UFM_VALID_ADDR INTEGER 0
set_parameter_property MIN_UFM_VALID_ADDR VISIBLE false
set_parameter_property MIN_UFM_VALID_ADDR ENABLED true
set_parameter_property MIN_UFM_VALID_ADDR HDL_PARAMETER true
set_parameter_property MIN_UFM_VALID_ADDR DERIVED true

add_parameter MAX_UFM_VALID_ADDR INTEGER 0
set_parameter_property MAX_UFM_VALID_ADDR VISIBLE false
set_parameter_property MAX_UFM_VALID_ADDR ENABLED true
set_parameter_property MAX_UFM_VALID_ADDR HDL_PARAMETER true
set_parameter_property MAX_UFM_VALID_ADDR DERIVED true

add_parameter SECTOR1_MAP INTEGER 0
set_parameter_property SECTOR1_MAP VISIBLE false
set_parameter_property SECTOR1_MAP ENABLED true
set_parameter_property SECTOR1_MAP HDL_PARAMETER true
set_parameter_property SECTOR1_MAP DERIVED true

add_parameter SECTOR2_MAP INTEGER 0
set_parameter_property SECTOR2_MAP VISIBLE false
set_parameter_property SECTOR2_MAP ENABLED true
set_parameter_property SECTOR2_MAP HDL_PARAMETER true
set_parameter_property SECTOR2_MAP DERIVED true

add_parameter SECTOR3_MAP INTEGER 0
set_parameter_property SECTOR3_MAP VISIBLE false
set_parameter_property SECTOR3_MAP ENABLED true
set_parameter_property SECTOR3_MAP HDL_PARAMETER true
set_parameter_property SECTOR3_MAP DERIVED true

add_parameter SECTOR4_MAP INTEGER 0
set_parameter_property SECTOR4_MAP VISIBLE false
set_parameter_property SECTOR4_MAP ENABLED true
set_parameter_property SECTOR4_MAP HDL_PARAMETER true
set_parameter_property SECTOR4_MAP DERIVED true

add_parameter SECTOR5_MAP INTEGER 0
set_parameter_property SECTOR5_MAP VISIBLE false
set_parameter_property SECTOR5_MAP ENABLED true
set_parameter_property SECTOR5_MAP HDL_PARAMETER true
set_parameter_property SECTOR5_MAP DERIVED true

add_parameter ADDR_RANGE1_END_ADDR INTEGER 0
set_parameter_property ADDR_RANGE1_END_ADDR VISIBLE false
set_parameter_property ADDR_RANGE1_END_ADDR ENABLED true
set_parameter_property ADDR_RANGE1_END_ADDR HDL_PARAMETER true
set_parameter_property ADDR_RANGE1_END_ADDR DERIVED true

add_parameter ADDR_RANGE2_END_ADDR INTEGER 0
set_parameter_property ADDR_RANGE2_END_ADDR VISIBLE false
set_parameter_property ADDR_RANGE2_END_ADDR ENABLED true
set_parameter_property ADDR_RANGE2_END_ADDR HDL_PARAMETER true
set_parameter_property ADDR_RANGE2_END_ADDR DERIVED true
add_parameter ADDR_RANGE1_OFFSET INTEGER 0
set_parameter_property ADDR_RANGE1_OFFSET VISIBLE false
set_parameter_property ADDR_RANGE1_OFFSET ENABLED true
set_parameter_property ADDR_RANGE1_OFFSET HDL_PARAMETER true
set_parameter_property ADDR_RANGE1_OFFSET DERIVED true

add_parameter ADDR_RANGE2_OFFSET INTEGER 0
set_parameter_property ADDR_RANGE2_OFFSET VISIBLE false
set_parameter_property ADDR_RANGE2_OFFSET ENABLED true
set_parameter_property ADDR_RANGE2_OFFSET HDL_PARAMETER true
set_parameter_property ADDR_RANGE2_OFFSET DERIVED true
add_parameter ADDR_RANGE3_OFFSET INTEGER 0
set_parameter_property ADDR_RANGE3_OFFSET VISIBLE false
set_parameter_property ADDR_RANGE3_OFFSET ENABLED true
set_parameter_property ADDR_RANGE3_OFFSET HDL_PARAMETER true
set_parameter_property ADDR_RANGE3_OFFSET DERIVED true

# Avmm data slave address bus width
add_parameter AVMM_DATA_ADDR_WIDTH INTEGER 19
set_parameter_property AVMM_DATA_ADDR_WIDTH VISIBLE false
set_parameter_property AVMM_DATA_ADDR_WIDTH ENABLED true
set_parameter_property AVMM_DATA_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property AVMM_DATA_ADDR_WIDTH DERIVED true

# Avmm data slave data bus width
add_parameter AVMM_DATA_DATA_WIDTH INTEGER 32
set_parameter_property AVMM_DATA_DATA_WIDTH VISIBLE false
set_parameter_property AVMM_DATA_DATA_WIDTH ENABLED true
set_parameter_property AVMM_DATA_DATA_WIDTH HDL_PARAMETER true
set_parameter_property AVMM_DATA_DATA_WIDTH DERIVED true

# Avmm data slave burstcount bus width
add_parameter AVMM_DATA_BURSTCOUNT_WIDTH INTEGER 4
set_parameter_property AVMM_DATA_BURSTCOUNT_WIDTH VISIBLE false
set_parameter_property AVMM_DATA_BURSTCOUNT_WIDTH ENABLED true
set_parameter_property AVMM_DATA_BURSTCOUNT_WIDTH HDL_PARAMETER true
set_parameter_property AVMM_DATA_BURSTCOUNT_WIDTH DERIVED true

# Sector read protection mode, the sector is not readable if the mode is set (1), else it is readable if the mode is clear (0)
add_parameter SECTOR_READ_PROTECTION_MODE INTEGER "0x1F"
set_parameter_property SECTOR_READ_PROTECTION_MODE VISIBLE false
set_parameter_property SECTOR_READ_PROTECTION_MODE ENABLED true
set_parameter_property SECTOR_READ_PROTECTION_MODE HDL_PARAMETER true
set_parameter_property SECTOR_READ_PROTECTION_MODE DERIVED true

# Avmm slave data interface parameters for parallel mode read operation. The value will changed based on selected device
add_parameter FLASH_SEQ_READ_DATA_COUNT INTEGER 2
set_parameter_property FLASH_SEQ_READ_DATA_COUNT VISIBLE false
set_parameter_property FLASH_SEQ_READ_DATA_COUNT ENABLED true
set_parameter_property FLASH_SEQ_READ_DATA_COUNT HDL_PARAMETER true
set_parameter_property FLASH_SEQ_READ_DATA_COUNT DERIVED true

add_parameter FLASH_ADDR_ALIGNMENT_BITS INTEGER 1
set_parameter_property FLASH_ADDR_ALIGNMENT_BITS VISIBLE false
set_parameter_property FLASH_ADDR_ALIGNMENT_BITS ENABLED true
set_parameter_property FLASH_ADDR_ALIGNMENT_BITS HDL_PARAMETER true
set_parameter_property FLASH_ADDR_ALIGNMENT_BITS DERIVED true

# Avmm slave data interface parameter for parallel mode read operation. The value will be dynamic adjusted based on clock frequency.
add_parameter FLASH_READ_CYCLE_MAX_INDEX INTEGER 4
set_parameter_property FLASH_READ_CYCLE_MAX_INDEX VISIBLE false
set_parameter_property FLASH_READ_CYCLE_MAX_INDEX ENABLED true
set_parameter_property FLASH_READ_CYCLE_MAX_INDEX HDL_PARAMETER true
set_parameter_property FLASH_READ_CYCLE_MAX_INDEX DERIVED true

# Avmm slave data interface parameter for reset period of write/erase operation. The value will be dynamic adjusted based on clock frequency.
add_parameter FLASH_RESET_CYCLE_MAX_INDEX INTEGER 29
set_parameter_property FLASH_RESET_CYCLE_MAX_INDEX VISIBLE false
set_parameter_property FLASH_RESET_CYCLE_MAX_INDEX ENABLED true
set_parameter_property FLASH_RESET_CYCLE_MAX_INDEX HDL_PARAMETER true
set_parameter_property FLASH_RESET_CYCLE_MAX_INDEX DERIVED true

# Avmm slave data interface parameter for write/erase flash busy timeout (960ns). The value will be dynamic adjusted based on clock frequency.
add_parameter FLASH_BUSY_TIMEOUT_CYCLE_MAX_INDEX INTEGER 112
set_parameter_property FLASH_BUSY_TIMEOUT_CYCLE_MAX_INDEX VISIBLE false
set_parameter_property FLASH_BUSY_TIMEOUT_CYCLE_MAX_INDEX ENABLED true
set_parameter_property FLASH_BUSY_TIMEOUT_CYCLE_MAX_INDEX HDL_PARAMETER true
set_parameter_property FLASH_BUSY_TIMEOUT_CYCLE_MAX_INDEX DERIVED true

# Avmm slave data interface parameter for flash erase timeout (350ms). The value will be dynamic adjusted based on clock frequency.
add_parameter FLASH_ERASE_TIMEOUT_CYCLE_MAX_INDEX INTEGER 40603248
set_parameter_property FLASH_ERASE_TIMEOUT_CYCLE_MAX_INDEX VISIBLE false
set_parameter_property FLASH_ERASE_TIMEOUT_CYCLE_MAX_INDEX ENABLED true
set_parameter_property FLASH_ERASE_TIMEOUT_CYCLE_MAX_INDEX HDL_PARAMETER true
set_parameter_property FLASH_ERASE_TIMEOUT_CYCLE_MAX_INDEX DERIVED true

# Avmm slave data interface parameter for flash write timeout (305us). The value will be dynamic adjusted based on clock frequency.
add_parameter FLASH_WRITE_TIMEOUT_CYCLE_MAX_INDEX INTEGER 35382
set_parameter_property FLASH_WRITE_TIMEOUT_CYCLE_MAX_INDEX VISIBLE false
set_parameter_property FLASH_WRITE_TIMEOUT_CYCLE_MAX_INDEX ENABLED true
set_parameter_property FLASH_WRITE_TIMEOUT_CYCLE_MAX_INDEX HDL_PARAMETER true
set_parameter_property FLASH_WRITE_TIMEOUT_CYCLE_MAX_INDEX DERIVED true

# Avmm slave interface parameter
add_parameter PARALLEL_MODE BOOLEAN true
set_parameter_property PARALLEL_MODE VISIBLE false
set_parameter_property PARALLEL_MODE ENABLED true
set_parameter_property PARALLEL_MODE HDL_PARAMETER true
set_parameter_property PARALLEL_MODE DERIVED true

# Avmm slave interface parameter
add_parameter READ_AND_WRITE_MODE BOOLEAN true
set_parameter_property READ_AND_WRITE_MODE VISIBLE false
set_parameter_property READ_AND_WRITE_MODE ENABLED true
set_parameter_property READ_AND_WRITE_MODE HDL_PARAMETER true
set_parameter_property READ_AND_WRITE_MODE DERIVED true

# Avmm slave interface parameter
add_parameter WRAPPING_BURST_MODE BOOLEAN false
set_parameter_property WRAPPING_BURST_MODE VISIBLE false
set_parameter_property WRAPPING_BURST_MODE ENABLED true
set_parameter_property WRAPPING_BURST_MODE HDL_PARAMETER true
set_parameter_property WRAPPING_BURST_MODE DERIVED true

# Atom parameter
add_parameter IS_DUAL_BOOT STRING "False"
set_parameter_property IS_DUAL_BOOT VISIBLE false
set_parameter_property IS_DUAL_BOOT ENABLED true
set_parameter_property IS_DUAL_BOOT HDL_PARAMETER true
set_parameter_property IS_DUAL_BOOT DERIVED true

add_parameter IS_ERAM_SKIP STRING "False"
set_parameter_property IS_ERAM_SKIP VISIBLE false
set_parameter_property IS_ERAM_SKIP ENABLED true
set_parameter_property IS_ERAM_SKIP HDL_PARAMETER true
set_parameter_property IS_ERAM_SKIP DERIVED true

add_parameter IS_COMPRESSED_IMAGE STRING "False"
set_parameter_property IS_COMPRESSED_IMAGE VISIBLE false
set_parameter_property IS_COMPRESSED_IMAGE ENABLED true
set_parameter_property IS_COMPRESSED_IMAGE HDL_PARAMETER true
set_parameter_property IS_COMPRESSED_IMAGE DERIVED true

# +-----------------------------------
# | Block Interface
# +-----------------------------------

# clk port
add_interface clk clock end
add_interface_port clk clock clk Input 1

# nreset port
add_interface nreset reset end
set_interface_property nreset associatedClock clk
add_interface_port nreset reset_n reset_n Input 1

# avalon_mm slave interface - data
set AVMM_SLAVE_DATA_INTERFACE "data"
add_interface $AVMM_SLAVE_DATA_INTERFACE avalon slave
add_interface_port $AVMM_SLAVE_DATA_INTERFACE avmm_data_addr address Input AVMM_DATA_ADDR_WIDTH
add_interface_port $AVMM_SLAVE_DATA_INTERFACE avmm_data_read read Input 1
add_interface_port $AVMM_SLAVE_DATA_INTERFACE avmm_data_writedata writedata Input AVMM_DATA_DATA_WIDTH
add_interface_port $AVMM_SLAVE_DATA_INTERFACE avmm_data_write write Input 1
add_interface_port $AVMM_SLAVE_DATA_INTERFACE avmm_data_readdata readdata Output AVMM_DATA_DATA_WIDTH
add_interface_port $AVMM_SLAVE_DATA_INTERFACE avmm_data_waitrequest waitrequest Output 1
add_interface_port $AVMM_SLAVE_DATA_INTERFACE avmm_data_readdatavalid readdatavalid Output 1
add_interface_port $AVMM_SLAVE_DATA_INTERFACE avmm_data_burstcount burstcount Input AVMM_DATA_BURSTCOUNT_WIDTH

set_interface_property $AVMM_SLAVE_DATA_INTERFACE addressAlignment {DYNAMIC}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE addressGroup {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE addressSpan {8}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE addressUnits {WORDS}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE alwaysBurstMaxBurst {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE associatedClock {clk}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE associatedReset {nreset}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE bitsPerSymbol {8}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE burstOnBurstBoundariesOnly {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE burstcountUnits {WORDS}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE constantBurstBehavior {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE explicitAddressSpan {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE holdTime {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE interleaveBursts {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE isBigEndian {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE isFlash {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE isMemoryDevice {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE isNonVolatileStorage {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE linewrapBursts {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE maximumPendingReadTransactions {1}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE minimumUninterruptedRunLength {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE printableDevice {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE readLatency {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE readWaitStates {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE readWaitTime {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE registerIncomingSignals {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE registerOutgoingSignals {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE setupTime {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE timingUnits {Cycles}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE transparentBridge {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE wellBehavedWaitrequest {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE writeLatency {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE writeWaitStates {0}
set_interface_property $AVMM_SLAVE_DATA_INTERFACE writeWaitTime {0}

# avalon_mm slave interface - csr
set AVMM_SLAVE_CSR_INTERFACE "csr"
add_interface $AVMM_SLAVE_CSR_INTERFACE avalon slave
add_interface_port $AVMM_SLAVE_CSR_INTERFACE avmm_csr_addr address Input 1
add_interface_port $AVMM_SLAVE_CSR_INTERFACE avmm_csr_read read Input 1
add_interface_port $AVMM_SLAVE_CSR_INTERFACE avmm_csr_writedata writedata Input 32
add_interface_port $AVMM_SLAVE_CSR_INTERFACE avmm_csr_write write Input 1
add_interface_port $AVMM_SLAVE_CSR_INTERFACE avmm_csr_readdata readdata Output 32
set_interface_property $AVMM_SLAVE_CSR_INTERFACE addressAlignment {DYNAMIC}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE addressGroup {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE addressSpan {8}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE addressUnits {WORDS}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE alwaysBurstMaxBurst {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE associatedClock {clk}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE associatedReset {nreset}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE bitsPerSymbol {8}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE burstOnBurstBoundariesOnly {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE burstcountUnits {WORDS}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE constantBurstBehavior {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE explicitAddressSpan {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE holdTime {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE interleaveBursts {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE isBigEndian {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE isFlash {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE isMemoryDevice {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE isNonVolatileStorage {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE linewrapBursts {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE maximumPendingReadTransactions {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE minimumUninterruptedRunLength {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE printableDevice {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE readLatency {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE readWaitStates {1}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE readWaitTime {1}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE registerIncomingSignals {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE registerOutgoingSignals {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE setupTime {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE timingUnits {Cycles}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE transparentBridge {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE wellBehavedWaitrequest {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE writeLatency {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE writeWaitStates {0}
set_interface_property $AVMM_SLAVE_CSR_INTERFACE writeWaitTime {0}

# +-------------------------------------
# | Add settings needed by Nios tools
# +-------------------------------------
# Tells us component is a flash but not a EPCS device 
set_module_assignment embeddedsw.memoryInfo.IS_FLASH 1

# This assignment indicates Nios tools should create a Flash initialization file
set_module_assignment embeddedsw.memoryInfo.HAS_BYTE_LANE 0

# These assignments tells tools to create byte_addressed .hex (syntehsis) and .dat (simulation) files
set_module_assignment embeddedsw.memoryInfo.GENERATE_HEX 1
set_module_assignment embeddedsw.memoryInfo.USE_BYTE_ADDRESSING_FOR_HEX 1
set_module_assignment embeddedsw.memoryInfo.GENERATE_DAT_SYM 1
set_module_assignment embeddedsw.memoryInfo.GENERATE_FLASH 1

# Width of memory
set_module_assignment embeddedsw.memoryInfo.MEM_INIT_DATA_WIDTH 32

# Output directories for programming files
set_module_assignment embeddedsw.memoryInfo.DAT_SYM_INSTALL_DIR {SIM_DIR}
set_module_assignment embeddedsw.memoryInfo.FLASH_INSTALL_DIR {APP_DIR}
set_module_assignment embeddedsw.memoryInfo.HEX_INSTALL_DIR {QPF_DIR}

# Interface assignments that indicate the slave is a non-volatile flash memory
set_interface_assignment $AVMM_SLAVE_DATA_INTERFACE embeddedsw.configuration.isFlash 1
set_interface_assignment $AVMM_SLAVE_DATA_INTERFACE embeddedsw.configuration.isMemoryDevice 1
set_interface_assignment $AVMM_SLAVE_DATA_INTERFACE embeddedsw.configuration.isNonVolatileStorage 1
set_interface_assignment $AVMM_SLAVE_DATA_INTERFACE embeddedsw.configuration.isPrintableDevice 0

# Module assignments related to names of simulation files
set_module_assignment postgeneration.simulation.init_file.param_name {INIT_FILENAME}
set_module_assignment postgeneration.simulation.init_file.type {MEM_INIT}

# +-----------------------------------
# | Fileset Callbacks
# +-----------------------------------

add_fileset           synthesis_fileset  QUARTUS_SYNTH  generate_synth
set_fileset_property  synthesis_fileset  TOP_LEVEL      altera_onchip_flash

add_fileset           sim_verilog        SIM_VERILOG    generate_verilog_sim
set_fileset_property  sim_verilog        TOP_LEVEL      altera_onchip_flash

add_fileset           sim_vhdl           SIM_VHDL       generate_sim_encrypt_file
set_fileset_property  sim_vhdl           TOP_LEVEL      altera_onchip_flash


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/vgo1395753117436/vgo1395811844282
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
