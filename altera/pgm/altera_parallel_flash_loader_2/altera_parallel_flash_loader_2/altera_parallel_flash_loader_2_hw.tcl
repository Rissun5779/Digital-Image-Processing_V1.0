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
# | $Header: //acds/rel/18.1std/ip/pgm/altera_parallel_flash_loader_2/altera_parallel_flash_loader_2/altera_parallel_flash_loader_2_hw.tcl#3 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 13.1
package require -exact altera_terp 1.0

# Source files
source altera_parallel_flash_loader_2_hw_proc.tcl


# +-----------------------------------
# | module Serial Flash Loader
# +-----------------------------------
set_module_property NAME 							altera_parallel_flash_loader_2
set_module_property VERSION 						18.1
set_module_property DISPLAY_NAME 					"Parallel Flash Loader II Intel FPGA IP"
set_module_property DESCRIPTION 					"The Parallel Flash Loader II Intel FPGA IP megafunction provides an in-system JTAG \
													programming method for Common Flash Interface (CFI) flash, and allow \
													FPGA configuration from the flash memory devices."
set_module_property GROUP 							"Basic Functions/Configuration and Programming"
set_module_property INTERNAL 						false
set_module_property AUTHOR 							"Intel Corporation"
set_module_property DATASHEET_URL 					"http://www.altera.com/literature/ug/ug_pfl.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE	true
set_module_property EDITABLE 						false

set_module_property     ELABORATION_CALLBACK        elaboration


# +-----------------------------------
# | Device Family Info
# +-----------------------------------

set supported_device_families_list {"Arria 10" \
									"Arria II GX" \
									"Arria II GZ" \
									"Arria V" \
									"Arria V GZ" \
                                    "Cyclone 10 LP" \
									"Cyclone IV E" \
									"Cyclone IV GX" \
									"Cyclone V" \
									"Max 10" \
									"Max II" \
									"Max V" \
									"Stratix IV" \
									"Stratix V"}

set_module_property SUPPORTED_DEVICE_FAMILIES	$supported_device_families_list


# +-----------------------------------
# | Tabs
# +-----------------------------------
add_display_item "" "General" GROUP tab
add_display_item "" "Flash Interface Setting" GROUP tab
add_display_item "" "Flash Programming" GROUP tab
add_display_item "" "FPGA Configuration" GROUP tab


# +-----------------------------------
# | Parameters  - General
# +-----------------------------------
add_parameter INTENDED_DEVICE_FAMILY STRING
set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE false

add_parameter OPERATING_MODE STRING
set_parameter_property OPERATING_MODE DEFAULT_VALUE "Flash Programming"
set_parameter_property OPERATING_MODE DISPLAY_NAME "What operating mode will be used?"
set_parameter_property OPERATING_MODE DESCRIPTION "Select operating mode"
set_parameter_property OPERATING_MODE AFFECTS_GENERATION TRUE
set_parameter_property OPERATING_MODE ALLOWED_RANGES {"Flash Programming" 
                                    "FPGA Configuration" "Flash Programming and FPGA Configuration"}
set_parameter_update_callback OPERATING_MODE update_ui_settings 
add_display_item "General" OPERATING_MODE parameter

add_parameter FLASH_TYPE_UI STRING
set_parameter_property FLASH_TYPE_UI DEFAULT_VALUE "CFI Parallel Flash"
set_parameter_property FLASH_TYPE_UI DISPLAY_NAME "What is the targeted flash?"
set_parameter_property FLASH_TYPE_UI DESCRIPTION "Select flash memory devices"
set_parameter_property FLASH_TYPE_UI AFFECTS_GENERATION TRUE
set_parameter_property FLASH_TYPE_UI ALLOWED_RANGES {"CFI Parallel Flash" "Quad SPI Flash"}
add_display_item "General" FLASH_TYPE_UI parameter

add_parameter TRISTATE_CHECKBOX BOOLEAN
set_parameter_property TRISTATE_CHECKBOX DEFAULT_VALUE 0
set_parameter_property TRISTATE_CHECKBOX DISPLAY_NAME "Set flash bus pins to tri-state when not in use"
set_parameter_property TRISTATE_CHECKBOX DESCRIPTION "Select to tri-state all pins interfacing with flash memory device when PFL megafunction does not require an access to the flash memory"
set_parameter_property TRISTATE_CHECKBOX AFFECTS_GENERATION TRUE
add_display_item "General" TRISTATE_CHECKBOX parameter

# +-----------------------------------
# | Parameters  - Flash Interface Setting
# +-----------------------------------

add_parameter NUM_FLASH INTEGER
set_parameter_property NUM_FLASH DEFAULT_VALUE 1
set_parameter_property NUM_FLASH DISPLAY_NAME "How many flash devices will be used?"
set_parameter_property NUM_FLASH DESCRIPTION "Select number of flash devices"
set_parameter_property NUM_FLASH AFFECTS_GENERATION TRUE
set_parameter_property NUM_FLASH ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 \
                                                 10 11 12 13 14 15 16}
add_display_item "Flash Interface Setting" NUM_FLASH parameter

add_parameter FLASH_DEVICE_DENSITY STRING
set_parameter_property FLASH_DEVICE_DENSITY DEFAULT_VALUE "CFI 8 Mbit"
set_parameter_property FLASH_DEVICE_DENSITY DISPLAY_NAME "What's the largest flash device that will be used?"
set_parameter_property FLASH_DEVICE_DENSITY DESCRIPTION "Select largest density of flash devices"
set_parameter_property FLASH_DEVICE_DENSITY AFFECTS_GENERATION TRUE
set_parameter_property FLASH_DEVICE_DENSITY ALLOWED_RANGES {"CFI 8 Mbit" "CFI 16 Mbit" "CFI 32 Mbit" \
                                                            "CFI 64 Mbit" "CFI 128 Mbit" "CFI 256 Mbit" \
                                                            "CFI 512 Mbit" "CFI 1 Gbit" "CFI 2 Gbit" \
                                                            "CFI 4 Gbit" }
add_display_item "Flash Interface Setting" FLASH_DEVICE_DENSITY parameter

add_parameter FLASH_DATA_WIDTH_UI STRING
set_parameter_property FLASH_DATA_WIDTH_UI DEFAULT_VALUE "16 bits"
set_parameter_property FLASH_DATA_WIDTH_UI DISPLAY_NAME "What is the flash interface data width?"
set_parameter_property FLASH_DATA_WIDTH_UI DESCRIPTION "Select flash data width in bits"
set_parameter_property FLASH_DATA_WIDTH_UI AFFECTS_GENERATION TRUE
set_parameter_property FLASH_DATA_WIDTH_UI ALLOWED_RANGES {"8 bits" "16 bits" "32 bits"}
add_display_item "Flash Interface Setting" FLASH_DATA_WIDTH_UI parameter

add_parameter FLASH_NRESET_CHECK BOOLEAN 1
set_parameter_property FLASH_NRESET_CHECK DEFAULT_VALUE 0
set_parameter_property FLASH_NRESET_CHECK DISPLAY_NAME "Allow user to control the FLASH_NRESET pin"
set_parameter_property FLASH_NRESET_CHECK DESCRIPTION "Select to connect reset pin of flash memory device"
set_parameter_property FLASH_NRESET_CHECK AFFECTS_GENERATION TRUE
add_display_item "Flash Interface Setting" FLASH_NRESET_CHECK parameter

#derived value for FLASH_NRESET
add_parameter FLASH_NRESET BOOLEAN 1
set_parameter_property FLASH_NRESET DEFAULT_VALUE 0
set_parameter_property FLASH_NRESET AFFECTS_GENERATION TRUE
set_parameter_property FLASH_NRESET VISIBLE false
set_parameter_property FLASH_NRESET DERIVED true

#For QSPI flash
add_parameter NUM_QSPI INTEGER
set_parameter_property NUM_QSPI DEFAULT_VALUE 1
set_parameter_property NUM_QSPI DISPLAY_NAME "How many flash devices will be used?"
set_parameter_property NUM_QSPI DESCRIPTION "Select number of flash devices"
set_parameter_property NUM_QSPI AFFECTS_GENERATION TRUE
set_parameter_property NUM_QSPI ALLOWED_RANGES {1 2 4 8}
add_display_item "Flash Interface Setting" NUM_QSPI parameter
add_parameter QSPI_MFC STRING
set_parameter_property QSPI_MFC DEFAULT_VALUE "Macronix"
set_parameter_property QSPI_MFC DISPLAY_NAME "What's the Quad SPI flash device manufacturer?"
set_parameter_property QSPI_MFC DESCRIPTION "Select device manufacturer of the quad SPI flash"
set_parameter_property QSPI_MFC AFFECTS_GENERATION TRUE
set_parameter_property QSPI_MFC ALLOWED_RANGES {"Altera EPCQ" "Macronix" "Micron" "Spansion"}
add_display_item "Flash Interface Setting" QSPI_MFC parameter
add_parameter QFLASH_FAST_SPEED BOOLEAN 1
set_parameter_property QFLASH_FAST_SPEED DEFAULT_VALUE 0
set_parameter_property QFLASH_FAST_SPEED DISPLAY_NAME "Flash support fast speed read"
set_parameter_property QFLASH_FAST_SPEED DESCRIPTION "Select for devices that support fast speed read"
set_parameter_property QFLASH_FAST_SPEED AFFECTS_GENERATION TRUE
add_display_item "Flash Interface Setting" QFLASH_FAST_SPEED parameter
add_parameter QSPI_DEVICE_DENSITY STRING
set_parameter_property QSPI_DEVICE_DENSITY DEFAULT_VALUE "QSPI 16 Mbit"
set_parameter_property QSPI_DEVICE_DENSITY DISPLAY_NAME "What's the Quad SPI flash device density?"
set_parameter_property QSPI_DEVICE_DENSITY DESCRIPTION "Select density of flash devices"
set_parameter_property QSPI_DEVICE_DENSITY AFFECTS_GENERATION TRUE
set_parameter_property QSPI_DEVICE_DENSITY ALLOWED_RANGES {"QSPI 8 Mbit" "QSPI 16 Mbit" "QSPI 32 Mbit" \
                                                            "QSPI 64 Mbit" "QSPI 128 Mbit" "QSPI 256 Mbit" \
                                                            "QSPI 512 Mbit" "QSPI 1 Gbit" "QSPI 2 Gbit"}
add_display_item "Flash Interface Setting" QSPI_DEVICE_DENSITY parameter
# +-----------------------------------
# | Parameters  - Flash Programming
# +-----------------------------------

add_parameter ENHANCED_FLASH_PROGRAMMING_UI STRING
set_parameter_property ENHANCED_FLASH_PROGRAMMING_UI DEFAULT_VALUE "Area"
set_parameter_property ENHANCED_FLASH_PROGRAMMING_UI DISPLAY_NAME "Flash programming IP optimization target"
set_parameter_property ENHANCED_FLASH_PROGRAMMING_UI DESCRIPTION "Select  flash programming IP optimization"
set_parameter_property ENHANCED_FLASH_PROGRAMMING_UI AFFECTS_GENERATION TRUE
set_parameter_property ENHANCED_FLASH_PROGRAMMING_UI ALLOWED_RANGES {"Area" "Speed"}
add_display_item "Flash Programming" ENHANCED_FLASH_PROGRAMMING_UI parameter

add_parameter FIFO_SIZE_UI INTEGER
set_parameter_property FIFO_SIZE_UI DEFAULT_VALUE 16
set_parameter_property FIFO_SIZE_UI DISPLAY_NAME "Flash programming IP FIFO size"
set_parameter_property FIFO_SIZE_UI DISPLAY_UNITS "words"
set_parameter_property FIFO_SIZE_UI DESCRIPTION "Select the FIFO size if you select Speed for flash programming IP optimization"
set_parameter_property FIFO_SIZE_UI AFFECTS_GENERATION TRUE
set_parameter_property FIFO_SIZE_UI ALLOWED_RANGES {16 32}
add_display_item "Flash Programming" FIFO_SIZE_UI parameter

add_parameter DISABLE_CRC_CHECK BOOLEAN
set_parameter_property DISABLE_CRC_CHECK DEFAULT_VALUE 1
set_parameter_property DISABLE_CRC_CHECK DISPLAY_NAME "Add Block-CRC verification acceleration support"
set_parameter_property DISABLE_CRC_CHECK DESCRIPTION "Select to add a block to accelerate verification"
set_parameter_property DISABLE_CRC_CHECK AFFECTS_GENERATION TRUE
add_display_item "Flash Programming" DISABLE_CRC_CHECK parameter

# +-----------------------------------
# | Parameters  - FPGA Configuration
# +-----------------------------------

add_parameter CLOCK_FREQUENCY FLOAT
set_parameter_property CLOCK_FREQUENCY DEFAULT_VALUE 100
set_parameter_property CLOCK_FREQUENCY DISPLAY_NAME "What is the external clock frequency?"
set_parameter_property CLOCK_FREQUENCY DISPLAY_UNITS "MHz"
set_parameter_property CLOCK_FREQUENCY DESCRIPTION "Specify the user-supplied clock frequency for the megafunction to configure the FPGA"
set_parameter_property CLOCK_FREQUENCY AFFECTS_GENERATION TRUE
set_parameter_property CLOCK_FREQUENCY ALLOWED_RANGES {0:125}
add_display_item "FPGA Configuration" CLOCK_FREQUENCY parameter

add_parameter FLASH_ACCESS_TIME INTEGER
set_parameter_property FLASH_ACCESS_TIME DEFAULT_VALUE 100
set_parameter_property FLASH_ACCESS_TIME DISPLAY_NAME "What is the flash access time?"
set_parameter_property FLASH_ACCESS_TIME DISPLAY_UNITS "ns"
set_parameter_property FLASH_ACCESS_TIME DESCRIPTION "Specify the access time of the CFI flash, in ns"
set_parameter_property FLASH_ACCESS_TIME AFFECTS_GENERATION TRUE
add_display_item "FPGA Configuration" FLASH_ACCESS_TIME parameter

add_parameter OPTION_BIT_ADDRESS LONG
set_parameter_property OPTION_BIT_ADDRESS DISPLAY_NAME "What is the byte address of the option bits, in hex?"
set_parameter_property OPTION_BIT_ADDRESS DISPLAY_HINT HEXADECIMAL
set_parameter_property OPTION_BIT_ADDRESS DESCRIPTION "Specify the start address in which option bits are stored in the flash"
set_parameter_property OPTION_BIT_ADDRESS AFFECTS_GENERATION TRUE
set_parameter_property OPTION_BIT_ADDRESS ALLOWED_RANGES {0:4294967295}
set_parameter_property OPTION_BIT_ADDRESS WIDTH 32
add_display_item "FPGA Configuration" OPTION_BIT_ADDRESS parameter

add_parameter FPGA_CONF_SCHEME STRING
set_parameter_property FPGA_CONF_SCHEME DEFAULT_VALUE "AvST x8" 
set_parameter_property FPGA_CONF_SCHEME DISPLAY_NAME "Which FPGA configuration scheme will be used?"
set_parameter_property FPGA_CONF_SCHEME DESCRIPTION "Select FPGA configuration scheme"
set_parameter_property FPGA_CONF_SCHEME AFFECTS_GENERATION TRUE
set_parameter_property FPGA_CONF_SCHEME ALLOWED_RANGES {"AvST x8" "AvST x16" "AvST x32"}
add_display_item "FPGA Configuration" FPGA_CONF_SCHEME parameter

add_parameter SAFE_MODE STRING
set_parameter_property SAFE_MODE DEFAULT_VALUE "Halt" 
set_parameter_property SAFE_MODE DISPLAY_NAME "What should occur on configuration failure?"
set_parameter_property SAFE_MODE DESCRIPTION "Select configuration behavior after configuration failure"
set_parameter_property SAFE_MODE AFFECTS_GENERATION TRUE
set_parameter_property SAFE_MODE ALLOWED_RANGES {"Halt" "Retry same page" "Retry from fixed address"}
add_display_item "FPGA Configuration" SAFE_MODE parameter

add_parameter SAFE_MODE_REVERT_ADDR_UI LONG
set_parameter_property SAFE_MODE_REVERT_ADDR_UI DISPLAY_NAME "What is the byte address to retry from on failure?"
set_parameter_property SAFE_MODE_REVERT_ADDR_UI DISPLAY_HINT HEXADECIMAL
set_parameter_property SAFE_MODE_REVERT_ADDR_UI DESCRIPTION "Specify the flash address for the PFL megafunction to read from reconfiguration for a configuration failure"
set_parameter_property SAFE_MODE_REVERT_ADDR_UI AFFECTS_GENERATION TRUE
set_parameter_property SAFE_MODE_REVERT_ADDR_UI ALLOWED_RANGES {0:4294967295}
set_parameter_property SAFE_MODE_REVERT_ADDR_UI WIDTH 32
add_display_item "FPGA Configuration" SAFE_MODE_REVERT_ADDR_UI parameter

add_parameter RECONFIGURE_CHECKBOX BOOLEAN
set_parameter_property RECONFIGURE_CHECKBOX DEFAULT_VALUE 0
set_parameter_property RECONFIGURE_CHECKBOX DISPLAY_NAME "Include input to force reconfiguration"
set_parameter_property RECONFIGURE_CHECKBOX DESCRIPTION "Select to enable optional pin for FPGA reconfiguration"
set_parameter_property RECONFIGURE_CHECKBOX AFFECTS_GENERATION TRUE
add_display_item "FPGA Configuration" RECONFIGURE_CHECKBOX parameter

add_parameter RSU_WATCHDOG_CHECKBOX BOOLEAN
set_parameter_property RSU_WATCHDOG_CHECKBOX DEFAULT_VALUE 0
set_parameter_property RSU_WATCHDOG_CHECKBOX DISPLAY_NAME "Enable watchdog timer on Remote System Update support"
set_parameter_property RSU_WATCHDOG_CHECKBOX DESCRIPTION "Select to enable watchdog timer for remote system upgrade support"
set_parameter_property RSU_WATCHDOG_CHECKBOX AFFECTS_GENERATION TRUE
add_display_item "FPGA Configuration" RSU_WATCHDOG_CHECKBOX parameter

#derived value for RSU_WATCHDOG_CHECKBOX
add_parameter RSU_WATCHDOG_ENABLE BOOLEAN 1
set_parameter_property RSU_WATCHDOG_ENABLE DEFAULT_VALUE 0
set_parameter_property RSU_WATCHDOG_ENABLE AFFECTS_GENERATION TRUE
set_parameter_property RSU_WATCHDOG_ENABLE VISIBLE false
set_parameter_property RSU_WATCHDOG_ENABLE DERIVED true

add_parameter RSU_WATCHDOG_COUNTER_UI FLOAT
set_parameter_property RSU_WATCHDOG_COUNTER_UI DEFAULT_VALUE 100
set_parameter_property RSU_WATCHDOG_COUNTER_UI DISPLAY_NAME "Time period before watchdog timed out"
set_parameter_property RSU_WATCHDOG_COUNTER_UI DISPLAY_UNITS "ms"
set_parameter_property RSU_WATCHDOG_COUNTER_UI DESCRIPTION "Specify time out period of the watchdog timer"
set_parameter_property RSU_WATCHDOG_COUNTER_UI AFFECTS_GENERATION TRUE
set_parameter_property RSU_WATCHDOG_COUNTER_UI ALLOWED_RANGES {0:9999.99}
add_display_item "FPGA Configuration" RSU_WATCHDOG_COUNTER_UI parameter

add_parameter READ_MODES STRING
set_parameter_property READ_MODES DEFAULT_VALUE "Normal Mode"
set_parameter_property READ_MODES DISPLAY_NAME "Use advance read mode?"
set_parameter_property READ_MODES DESCRIPTION "Select option to improve overall flash access time for the read process during the FPGA configuration"
set_parameter_property READ_MODES AFFECTS_GENERATION TRUE
set_parameter_property READ_MODES ALLOWED_RANGES {"Normal Mode" "Intel Burst Mode (P30 or P33 only)"
                                                  "16 Bytes Page Mode (GL only)" "32 Bytes Page Mode (MT28EW)" "Micron Burst Mode (M58BW)"}
add_display_item "FPGA Configuration" READ_MODES parameter

add_parameter LATENCY_COUNT INTEGER
set_parameter_property LATENCY_COUNT DEFAULT_VALUE 3
set_parameter_property LATENCY_COUNT DISPLAY_NAME "Latency count"
set_parameter_property LATENCY_COUNT DESCRIPTION "Specifiy then latency count for read mode. only avilable when Intel Burst Mode is selected"
set_parameter_property LATENCY_COUNT AFFECTS_GENERATION TRUE
set_parameter_property LATENCY_COUNT ALLOWED_RANGES {3 4 5}
add_display_item "FPGA Configuration" LATENCY_COUNT parameter

add_parameter READY_LATENCY INTEGER
set_parameter_property READY_LATENCY DEFAULT_VALUE 4
set_parameter_property READY_LATENCY DISPLAY_NAME "READY_LATENCY count"
set_parameter_property READY_LATENCY DESCRIPTION "Specifiy then ready latency count for read mode"
set_parameter_property READY_LATENCY AFFECTS_GENERATION TRUE
set_parameter_property READY_LATENCY ALLOWED_RANGES {3:7}
set_parameter_property READY_LATENCY VISIBLE FALSE
add_display_item "FPGA Configuration" READY_LATENCY parameter

# +-----------------------------------
# | Hidden HDL Parameters 
# +-----------------------------------


add_parameter ADDR_WIDTH INTEGER
set_parameter_property ADDR_WIDTH DEFAULT_VALUE 20
set_parameter_property ADDR_WIDTH VISIBLE false
set_parameter_property ADDR_WIDTH ENABLED true
set_parameter_property ADDR_WIDTH DERIVED true

add_parameter FLASH_DATA_WIDTH INTEGER
set_parameter_property FLASH_DATA_WIDTH DEFAULT_VALUE 16
set_parameter_property FLASH_DATA_WIDTH VISIBLE false
set_parameter_property FLASH_DATA_WIDTH ENABLED true
set_parameter_property FLASH_DATA_WIDTH DERIVED true

add_parameter N_FLASH INTEGER
set_parameter_property N_FLASH DEFAULT_VALUE 1
set_parameter_property N_FLASH VISIBLE false
set_parameter_property N_FLASH ENABLED true
set_parameter_property N_FLASH DERIVED true

add_parameter FLASH_MFC STRING
set_parameter_property FLASH_MFC DEFAULT_VALUE "Micron"
set_parameter_property FLASH_MFC VISIBLE false
set_parameter_property FLASH_MFC ENABLED true
set_parameter_property FLASH_MFC DERIVED true
add_parameter FLASH_NRESET_CHECKBOX INTEGER
set_parameter_property FLASH_NRESET_CHECKBOX DEFAULT_VALUE 1
set_parameter_property FLASH_NRESET_CHECKBOX VISIBLE false
set_parameter_property FLASH_NRESET_CHECKBOX ENABLED true
set_parameter_property FLASH_NRESET_CHECKBOX DERIVED true

add_parameter EXTRA_ADDR_BYTE INTEGER
set_parameter_property EXTRA_ADDR_BYTE DEFAULT_VALUE 0
set_parameter_property EXTRA_ADDR_BYTE VISIBLE false
set_parameter_property EXTRA_ADDR_BYTE ENABLED true
set_parameter_property EXTRA_ADDR_BYTE DERIVED true

add_parameter FIFO_SIZE INTEGER
set_parameter_property FIFO_SIZE DEFAULT_VALUE 0
set_parameter_property FIFO_SIZE VISIBLE false
set_parameter_property FIFO_SIZE ENABLED true
set_parameter_property FIFO_SIZE DERIVED true

add_parameter DISABLE_CRC_CHECKBOX INTEGER
set_parameter_property DISABLE_CRC_CHECKBOX DEFAULT_VALUE 0
set_parameter_property DISABLE_CRC_CHECKBOX VISIBLE false
set_parameter_property DISABLE_CRC_CHECKBOX ENABLED true
set_parameter_property DISABLE_CRC_CHECKBOX DERIVED true

add_parameter CLK_DIVISOR INTEGER
set_parameter_property CLK_DIVISOR DEFAULT_VALUE 1
set_parameter_property CLK_DIVISOR VISIBLE false
set_parameter_property CLK_DIVISOR ENABLED true
set_parameter_property CLK_DIVISOR DERIVED true

add_parameter PAGE_CLK_DIVISOR INTEGER
set_parameter_property PAGE_CLK_DIVISOR DEFAULT_VALUE 1
set_parameter_property PAGE_CLK_DIVISOR VISIBLE false
set_parameter_property PAGE_CLK_DIVISOR ENABLED true
set_parameter_property PAGE_CLK_DIVISOR DERIVED true

add_parameter FLASH_NRESET_COUNTER INTEGER
set_parameter_property FLASH_NRESET_COUNTER DEFAULT_VALUE 1
set_parameter_property FLASH_NRESET_COUNTER VISIBLE false
set_parameter_property FLASH_NRESET_COUNTER ENABLED true
set_parameter_property FLASH_NRESET_COUNTER DERIVED true

add_parameter NORMAL_MODE INTEGER
set_parameter_property NORMAL_MODE DEFAULT_VALUE 1
set_parameter_property NORMAL_MODE VISIBLE false
set_parameter_property NORMAL_MODE ENABLED true
set_parameter_property NORMAL_MODE DERIVED true

add_parameter BURST_MODE INTEGER
set_parameter_property BURST_MODE DEFAULT_VALUE 0
set_parameter_property BURST_MODE VISIBLE false
set_parameter_property BURST_MODE ENABLED true
set_parameter_property BURST_MODE DERIVED true

add_parameter PAGE_MODE INTEGER
set_parameter_property PAGE_MODE DEFAULT_VALUE 0
set_parameter_property PAGE_MODE VISIBLE false
set_parameter_property PAGE_MODE ENABLED true
set_parameter_property PAGE_MODE DERIVED true

add_parameter MT28EW_PAGE_MODE INTEGER
set_parameter_property MT28EW_PAGE_MODE DEFAULT_VALUE 0
set_parameter_property MT28EW_PAGE_MODE VISIBLE false
set_parameter_property MT28EW_PAGE_MODE ENABLED true
set_parameter_property MT28EW_PAGE_MODE DERIVED true

add_parameter BURST_MODE_SPANSION INTEGER
set_parameter_property BURST_MODE_SPANSION DEFAULT_VALUE 0
set_parameter_property BURST_MODE_SPANSION VISIBLE false
set_parameter_property BURST_MODE_SPANSION ENABLED true
set_parameter_property BURST_MODE_SPANSION DERIVED true

add_parameter BURST_MODE_INTEL INTEGER
set_parameter_property BURST_MODE_INTEL DEFAULT_VALUE 0
set_parameter_property BURST_MODE_INTEL VISIBLE false
set_parameter_property BURST_MODE_INTEL ENABLED true
set_parameter_property BURST_MODE_INTEL DERIVED true

add_parameter BURST_MODE_LATENCY_COUNT INTEGER
set_parameter_property BURST_MODE_LATENCY_COUNT DEFAULT_VALUE 4
set_parameter_property BURST_MODE_LATENCY_COUNT VISIBLE false
set_parameter_property BURST_MODE_LATENCY_COUNT ENABLED true
set_parameter_property BURST_MODE_LATENCY_COUNT DERIVED true

add_parameter BURST_MODE_NUMONYX INTEGER
set_parameter_property BURST_MODE_NUMONYX DEFAULT_VALUE 0
set_parameter_property BURST_MODE_NUMONYX VISIBLE false
set_parameter_property BURST_MODE_NUMONYX ENABLED true
set_parameter_property BURST_MODE_NUMONYX DERIVED true

add_parameter FLASH_BURST_EXTRA_CYCLE INTEGER
set_parameter_property FLASH_BURST_EXTRA_CYCLE DEFAULT_VALUE 0
set_parameter_property FLASH_BURST_EXTRA_CYCLE VISIBLE false
set_parameter_property FLASH_BURST_EXTRA_CYCLE ENABLED true
set_parameter_property FLASH_BURST_EXTRA_CYCLE DERIVED true

add_parameter FLASH_STATIC_WAIT_WIDTH INTEGER
set_parameter_property FLASH_STATIC_WAIT_WIDTH DEFAULT_VALUE 15
set_parameter_property FLASH_STATIC_WAIT_WIDTH VISIBLE false
set_parameter_property FLASH_STATIC_WAIT_WIDTH ENABLED true
set_parameter_property FLASH_STATIC_WAIT_WIDTH DERIVED true

add_parameter CONF_DATA_WIDTH INTEGER
set_parameter_property CONF_DATA_WIDTH DEFAULT_VALUE 1
set_parameter_property CONF_DATA_WIDTH VISIBLE false
set_parameter_property CONF_DATA_WIDTH ENABLED true
set_parameter_property CONF_DATA_WIDTH DERIVED true

add_parameter OPTION_START_ADDR INTEGER
set_parameter_property OPTION_START_ADDR DEFAULT_VALUE 0
set_parameter_property OPTION_START_ADDR VISIBLE false
set_parameter_property OPTION_START_ADDR ENABLED true
set_parameter_property OPTION_START_ADDR DERIVED true

add_parameter CONF_WAIT_TIMER_WIDTH INTEGER
set_parameter_property CONF_WAIT_TIMER_WIDTH DEFAULT_VALUE 16
set_parameter_property CONF_WAIT_TIMER_WIDTH VISIBLE false
set_parameter_property CONF_WAIT_TIMER_WIDTH ENABLED true
set_parameter_property CONF_WAIT_TIMER_WIDTH DERIVED true

add_parameter SAFE_MODE_HALT INTEGER
set_parameter_property SAFE_MODE_HALT DEFAULT_VALUE 0
set_parameter_property SAFE_MODE_HALT VISIBLE false
set_parameter_property SAFE_MODE_HALT ENABLED true
set_parameter_property SAFE_MODE_HALT DERIVED true

add_parameter SAFE_MODE_RETRY INTEGER
set_parameter_property SAFE_MODE_RETRY DEFAULT_VALUE 1
set_parameter_property SAFE_MODE_RETRY VISIBLE false
set_parameter_property SAFE_MODE_RETRY ENABLED true
set_parameter_property SAFE_MODE_RETRY DERIVED true

add_parameter SAFE_MODE_REVERT INTEGER
set_parameter_property SAFE_MODE_REVERT DEFAULT_VALUE 0
set_parameter_property SAFE_MODE_REVERT VISIBLE false
set_parameter_property SAFE_MODE_REVERT ENABLED true
set_parameter_property SAFE_MODE_REVERT DERIVED true

add_parameter SAFE_MODE_REVERT_ADDR INTEGER
set_parameter_property SAFE_MODE_REVERT_ADDR DEFAULT_VALUE 0
set_parameter_property SAFE_MODE_REVERT_ADDR VISIBLE false
set_parameter_property SAFE_MODE_REVERT_ADDR ENABLED true
set_parameter_property SAFE_MODE_REVERT_ADDR DERIVED true

add_parameter PFL_RSU_WATCHDOG_ENABLED BOOLEAN
set_parameter_property PFL_RSU_WATCHDOG_ENABLED DEFAULT_VALUE 0
set_parameter_property PFL_RSU_WATCHDOG_ENABLED VISIBLE false
set_parameter_property PFL_RSU_WATCHDOG_ENABLED ENABLED true
set_parameter_property PFL_RSU_WATCHDOG_ENABLED DERIVED true

add_parameter RSU_WATCHDOG_COUNTER INTEGER
set_parameter_property RSU_WATCHDOG_COUNTER DEFAULT_VALUE 100000000
set_parameter_property RSU_WATCHDOG_COUNTER VISIBLE false
set_parameter_property RSU_WATCHDOG_COUNTER ENABLED true
set_parameter_property RSU_WATCHDOG_COUNTER DERIVED true

add_parameter READY_SYNC_STAGES INTEGER
set_parameter_property READY_SYNC_STAGES DEFAULT_VALUE 2
set_parameter_property READY_SYNC_STAGES VISIBLE false
set_parameter_property READY_SYNC_STAGES ENABLED true
set_parameter_property READY_SYNC_STAGES DERIVED true

# --- FPGA Configuration text --- #
add_display_item	"FPGA Configuration"		"spacer1"			TEXT	""
add_display_item	"FPGA Configuration"		"note_text"			TEXT	"Note:"
add_display_item	"FPGA Configuration"		"avst_note"			TEXT	"- The selected configuration scheme is only supported in Stratix 10 device family"


#set_parameter_allowed_ranges



# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
add_fileset sim_verilog SIM_VERILOG generate_synth
add_fileset sim_vhdl SIM_VHDL generate_synth

set_fileset_property quartus_synth TOP_LEVEL altera_parallel_flash_loader_2
set_fileset_property sim_verilog TOP_LEVEL altera_parallel_flash_loader_2
set_fileset_property sim_vhdl TOP_LEVEL altera_parallel_flash_loader_2

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.altera.com/en_US/pdfs/literature/hb/stratix-10/ug-s10-config.pdf
