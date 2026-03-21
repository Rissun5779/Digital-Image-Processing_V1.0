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


package require -exact qsys 16.1
package require -exact altera_terp 1.0


# 
# module altera_trace_wrapper
# 
set_module_property DESCRIPTION "This component is a serial flash controller which allows user to access Altera EPCQ devices"
set_module_property NAME altera_epcq_controller2
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Serial Flash Controller II Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property HIDE_FROM_QUARTUS true
set_module_property EDITABLE true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property VALIDATION_CALLBACK 	validation
set_module_property COMPOSITION_CALLBACK    compose

# 
# parameters
#
# +-----------------------------------
# | device family info
# +-----------------------------------
set all_supported_device_families_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "Stratix IV" \
											"Cyclone IV GX" "Cyclone IV E" "Cyclone III GL" "Arria II GZ" "Arria II GX" "Cyclone 10 GX" "Cyclone 10 LP"}
									
proc check_device_ini {device_families_list}     {

    set enable_max10    [get_quartus_ini enable_max10_active_serial ENABLED]
    
    if {$enable_max10 == 1} {
        lappend device_families_list    "MAX 10 FPGA"
     } 
    return $device_families_list
}

set device_list    [check_device_ini $all_supported_device_families_list]
set_module_property SUPPORTED_DEVICE_FAMILIES    $device_list

add_parameter 			DEVICE_FAMILY 	STRING
set_parameter_property 	DEVICE_FAMILY 	SYSTEM_INFO 	{DEVICE_FAMILY}
set_parameter_property 	DEVICE_FAMILY 	VISIBLE 		false
set_parameter_property  DEVICE_FAMILY 	HDL_PARAMETER true

add_parameter ASI_WIDTH INTEGER 1
set_parameter_property ASI_WIDTH DEFAULT_VALUE 1
set_parameter_property ASI_WIDTH DISPLAY_NAME ASI_WIDTH
set_parameter_property ASI_WIDTH DERIVED true
set_parameter_property ASI_WIDTH TYPE INTEGER
set_parameter_property ASI_WIDTH VISIBLE false
set_parameter_property ASI_WIDTH UNITS None
set_parameter_property ASI_WIDTH ALLOWED_RANGES {1, 4}
set_parameter_property ASI_WIDTH HDL_PARAMETER true

add_parameter CS_WIDTH INTEGER 1
set_parameter_property CS_WIDTH DEFAULT_VALUE 1
set_parameter_property CS_WIDTH DISPLAY_NAME CS_WIDTH
set_parameter_property CS_WIDTH DERIVED true
set_parameter_property CS_WIDTH TYPE INTEGER
set_parameter_property CS_WIDTH VISIBLE false
set_parameter_property CS_WIDTH UNITS None
set_parameter_property CS_WIDTH ALLOWED_RANGES {1, 3}
set_parameter_property CS_WIDTH HDL_PARAMETER true

add_parameter ADDR_WIDTH INTEGER 19
set_parameter_property ADDR_WIDTH DEFAULT_VALUE 19
set_parameter_property ADDR_WIDTH DISPLAY_NAME ADDR_WIDTH
set_parameter_property ADDR_WIDTH DERIVED true
set_parameter_property ADDR_WIDTH TYPE INTEGER
set_parameter_property ADDR_WIDTH VISIBLE false
set_parameter_property ADDR_WIDTH UNITS None
# 16M-19bit, 32M-20bit, 64M-21bit, 128M-22bit, 256M-23bit, 512M-24bit, 1024M-25bit, 2048M-26bit...
set_parameter_property ADDR_WIDTH ALLOWED_RANGES {17, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28}		
set_parameter_property ADDR_WIDTH HDL_PARAMETER true

add_parameter ASMI_ADDR_WIDTH INTEGER 24
set_parameter_property ASMI_ADDR_WIDTH DEFAULT_VALUE 24
set_parameter_property ASMI_ADDR_WIDTH DISPLAY_NAME ASMI_ADDR_WIDTH
set_parameter_property ASMI_ADDR_WIDTH DERIVED true
set_parameter_property ASMI_ADDR_WIDTH TYPE INTEGER
set_parameter_property ASMI_ADDR_WIDTH VISIBLE false
set_parameter_property ASMI_ADDR_WIDTH UNITS None
set_parameter_property ASMI_ADDR_WIDTH ALLOWED_RANGES {24, 32}		
set_parameter_property ASMI_ADDR_WIDTH HDL_PARAMETER true

add_parameter ENABLE_4BYTE_ADDR	INTEGER "0"
set_parameter_property ENABLE_4BYTE_ADDR DISPLAY_NAME "Enable 4-byte addressing mode"
set_parameter_property ENABLE_4BYTE_ADDR DESCRIPTION "Check to enable 4-byte addressing mode for device larger than 128Mbyte"
set_parameter_property ENABLE_4BYTE_ADDR AFFECTS_GENERATION true
set_parameter_property ENABLE_4BYTE_ADDR VISIBLE false
set_parameter_property ENABLE_4BYTE_ADDR HDL_PARAMETER true
set_parameter_property ENABLE_4BYTE_ADDR DERIVED true

# +-----------------------------------

# add system info parameter
add_parameter           deviceFeaturesSystemInfo   STRING 			"None"
set_parameter_property  deviceFeaturesSystemInfo   system_info		"DEVICE_FEATURES"
set_parameter_property  deviceFeaturesSystemInfo   VISIBLE false

add_parameter DDASI	INTEGER "0"
set_parameter_property DDASI DISPLAY_NAME "Disable dedicated Active Serial interface"
set_parameter_property DDASI DESCRIPTION "Check to route ASMIBLOCK signals to top level of design"
set_parameter_property DDASI AFFECTS_GENERATION true
set_parameter_property DDASI VISIBLE false
set_parameter_property DDASI DERIVED false

add_parameter clkFreq LONG
set_parameter_property clkFreq DEFAULT_VALUE {0}
set_parameter_property clkFreq DISPLAY_NAME {clkFreq}
set_parameter_property clkFreq VISIBLE {0}
set_parameter_property clkFreq AFFECTS_GENERATION {1}
set_parameter_property clkFreq HDL_PARAMETER {0}
set_parameter_property clkFreq SYSTEM_INFO {clock_rate clk}
set_parameter_property clkFreq SYSTEM_INFO_TYPE {CLOCK_RATE}
set_parameter_property clkFreq SYSTEM_INFO_ARG {clock_sink}


proc proc_get_derive_addr_width {flash_type} {
    switch $flash_type {
        "EPCQ4A" {
            return 17
        }
        "EPCS16" - "EPCQ16" - "EPCQ16A" {
            return 19 
        }
        "EPCS64" - "EPCQ64" - "EPCQ64A" {
            return 21
        }
        "EPCS128" - "EPCQ128" - "EPCQ128A" {
            return 22
        }
		"EPCQ32" - "EPCQ32A" {
            return 20
		}
        "EPCQ256" - "EPCQL256" - "MT25QL256" - "MT25QU256" {
            return 23
        }
        "EPCQ512" - "EPCQL512" - "MT25QL512" - "MT25QU512" {
            return 24
        }
        "EPCQL1024" - "MT25QU01G" {
            return 25
        }
        default {
            # Should never enter this function
            send_message error "$flash_type is not a valid flash type"
        }
    
    }
}

set all_supported_SPI_list {"EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ256" \
							"EPCQ512" "EPCQL256" "EPCQL512" "EPCQL1024"}
							
# SPI device selection
add_parameter FLASH_TYPE STRING "EPCQ16"
set_parameter_property FLASH_TYPE DISPLAY_NAME "Configuration device type"
set_parameter_property FLASH_TYPE ALLOWED_RANGES $all_supported_SPI_list
set_parameter_property FLASH_TYPE DESCRIPTION "Select targeted EPCS/EPCQ devices"
set_parameter_property FLASH_TYPE AFFECTS_GENERATION true
set_parameter_property FLASH_TYPE VISIBLE true
set_parameter_property FLASH_TYPE DERIVED false

add_parameter IO_MODE STRING "STANDARD"
set_parameter_property IO_MODE DISPLAY_NAME "Choose I/O mode"
set_parameter_property IO_MODE ALLOWED_RANGES {"STANDARD" "QUAD"}
set_parameter_property IO_MODE DESCRIPTION "Select extended data width when Fast Read operation is enabled"

add_parameter CHIP_SELS INTEGER "1"
set_parameter_property CHIP_SELS DISPLAY_NAME "Number of Chip Selects used"
set_parameter_property CHIP_SELS ALLOWED_RANGES {1 2 3}
set_parameter_property CHIP_SELS DESCRIPTION "Number of EPCQ(L) devices that are attached and need a CHIPSEL"
set_parameter_property CHIP_SELS HDL_PARAMETER true
set_parameter_property CHIP_SELS AFFECTS_GENERATION true

proc validation { } {
    # --- check ini for hidden devices --- #
    set get_spi_list        [get_parameter_property FLASH_TYPE   ALLOWED_RANGES]
    set enable_MT25Q        [get_quartus_ini pgm_allow_mt25q ENABLED]
    if {$enable_MT25Q == 1} {
        lappend get_spi_list    "MT25QL256"
        lappend get_spi_list    "MT25QL512"
        lappend get_spi_list    "MT25QU256"
        lappend get_spi_list    "MT25QU512"
        lappend get_spi_list    "MT25QU01G"
    }
    set_parameter_property  FLASH_TYPE   ALLOWED_RANGES      $get_spi_list       
}


proc compose {} {
	# add component
	add_instance clk altera_clock_bridge 18.1
    set_instance_parameter_value clk {EXPLICIT_CLOCK_RATE} {0.0}
    set_instance_parameter_value clk {NUM_CLOCK_OUTPUTS} {1}

    add_instance reset altera_reset_bridge 18.1
    set_instance_parameter_value reset {ACTIVE_LOW_RESET} {1}
    set_instance_parameter_value reset {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value reset {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value reset {USE_RESET_REQUEST} {0}

	add_instance	asmi2_inst_epcq_ctrl altera_asmi_parallel2 18.1
	add_instance	addr_adaption_0 altera_qspi_address_adaption 18.1

	# QSPI that supported for 4-byte addressing - en4b_addr, ex4b_addr
	set supported_4byte_addr 	{"EPCQ256" "EPCQ512" "EPCQL256" "EPCQL512" "EPCQL1024" "N25Q512"  "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G"}
	set DDASI_ON 				[ get_parameter_value DDASI ]
	set FLASH_TYPE 				[ get_parameter_value FLASH_TYPE ]
	set IO_MODE 				[ get_parameter_value IO_MODE ]
	set DEVICE_FAMILY 			[ get_parameter_value DEVICE_FAMILY ]
	set ASI_WIDTH 				[ get_parameter_value ASI_WIDTH ]
	set CS_WIDTH 				[ get_parameter_value CS_WIDTH ]
	set ASMI_ADDR_WIDTH 		[ get_parameter_value ASMI_ADDR_WIDTH ]
	set CHIP_SELS			    [ get_parameter_value CHIP_SELS]
	set temp_addr_width 		[ proc_get_derive_addr_width [ get_parameter_value FLASH_TYPE ] ]
	set clkFreq 				[ get_parameter_value clkFreq ]
	set is_4byte_addr_support	"false"
	set is_qspi					"false"
	
	
	# check whether SPI device support 4-byte addressing
	foreach re_spi_1   $supported_4byte_addr {
		if {$re_spi_1 eq $FLASH_TYPE} {
			set is_4byte_addr_support	"true"
			break;
		 }
	 }
	 
	if {$is_4byte_addr_support eq "true"} {
		set_parameter_value 	ENABLE_4BYTE_ADDR "1"
		set_parameter_value		ASMI_ADDR_WIDTH 32
	} else {
		set_parameter_value 	ENABLE_4BYTE_ADDR "0"
		set_parameter_value		ASMI_ADDR_WIDTH 24
	}
	
	# check whether devices supporting multiple flash - only for Arria 10
	if {[check_device_family_equivalence $DEVICE_FAMILY "Arria 10"] || [check_device_family_equivalence $DEVICE_FAMILY "Cyclone 10 GX"]} {
		set is_multi_flash_support	"true"
		if {$CHIP_SELS eq 3 } {set_parameter_value 	ADDR_WIDTH 		[ expr $temp_addr_width + 2]}
		if {$CHIP_SELS eq 2 } {set_parameter_value 	ADDR_WIDTH 		[ expr $temp_addr_width + 1]}
		if {$CHIP_SELS eq 1 } {set_parameter_value 	ADDR_WIDTH 		$temp_addr_width }
	} else {
		set is_multi_flash_support	"false"
		set_parameter_value 	ADDR_WIDTH 		$temp_addr_width
	}
	
	
	set_instance_parameter_value	addr_adaption_0 DDASI $DDASI_ON
	set_instance_parameter_value	addr_adaption_0 FLASH_TYPE $FLASH_TYPE
	set_instance_parameter_value	addr_adaption_0 IO_MODE $IO_MODE
	set_instance_parameter_value	addr_adaption_0 ASI_WIDTH $ASI_WIDTH
	set_instance_parameter_value	addr_adaption_0 CS_WIDTH $CS_WIDTH
	set_instance_parameter_value	addr_adaption_0 CHIP_SELS $CHIP_SELS
	set_instance_parameter_value	addr_adaption_0 ASMI_ADDR_WIDTH [ get_parameter_value ASMI_ADDR_WIDTH ]
	set_instance_parameter_value	addr_adaption_0 ADDR_WIDTH [ get_parameter_value ADDR_WIDTH ]
	set_instance_parameter_value	addr_adaption_0 ENABLE_4BYTE_ADDR [ get_parameter_value ENABLE_4BYTE_ADDR ]

	set QSPI_list {"EPCQ4A" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ256" "EPCQ512" "EPCQL256" "EPCQL512" "EPCQL1024" \
					"N25Q512" "S25FL127S"  "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G"}
	
	# devices that supported QSPI - Quad/Dual data width, asmi_dataout, asmi_sdoin, asmi_dataoe
	set supported_QSPI_devices_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "Cyclone 10 GX"}
	
	# devices that supported simulation
	set supported_sim_devices_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "Cyclone 10 GX"}
	
	# check whether is QSPI devices
	foreach re_spi_0   $QSPI_list {
		if {$re_spi_0 eq $FLASH_TYPE} { 
			set is_qspi		"true"
			break;
		 }
	 }
	 
	if {[check_device_family_equivalence $DEVICE_FAMILY $supported_QSPI_devices_list]} {
		set is_qspi_devices_list	"true"
	} else {
		set is_qspi_devices_list	"false"
	}
	
	if {[check_device_family_equivalence $DEVICE_FAMILY $supported_sim_devices_list]} {
		set is_sim_devices_list	"true"
	} else {
		set is_sim_devices_list	"false"
	}
	
	if { $is_multi_flash_support eq "true"} {
		set_parameter_value CS_WIDTH 3
		set_parameter_property	CHIP_SELS	ENABLED		true
	} else {
		set_parameter_value CS_WIDTH 1
		set_parameter_property	CHIP_SELS	ENABLED		false
	}
	
	set_instance_parameter_value 	asmi2_inst_epcq_ctrl FLASH_TYPE 				$FLASH_TYPE
	apply_instance_preset 			asmi2_inst_epcq_ctrl 						${FLASH_TYPE}
	
	
	set_instance_parameter_value 	asmi2_inst_epcq_ctrl gui_use_asmiblock		$DDASI_ON
	set_instance_parameter_value 	asmi2_inst_epcq_ctrl CHIP_SELS		$CHIP_SELS
	
	
	if {$is_sim_devices_list eq "true"} {
		set_instance_parameter_value 	asmi2_inst_epcq_ctrl ENABLE_SIM_MODEL			true
	} else {
		set_instance_parameter_value 	asmi2_inst_epcq_ctrl ENABLE_SIM_MODEL			false
	}

	if {$is_qspi_devices_list eq "true" && $is_qspi eq "true"} {
		set_parameter_property	IO_MODE	ENABLED		true
		set_instance_parameter_value 	asmi2_inst_epcq_ctrl DATA_WIDTH 		$IO_MODE
		set_parameter_value ASI_WIDTH 4
    } else {
		set_parameter_property	IO_MODE	ENABLED		false
		set_parameter_value ASI_WIDTH 1
		set_instance_parameter_value 	asmi2_inst_epcq_ctrl DATA_WIDTH 		"STANDARD"
	}

    add_connection clk.out_clk reset.clk clock
    add_connection clk.out_clk asmi2_inst_epcq_ctrl.clk clock
    add_connection clk.out_clk addr_adaption_0.clock_sink clock
    add_connection reset.out_reset asmi2_inst_epcq_ctrl.reset reset
    add_connection reset.out_reset addr_adaption_0.reset reset

    add_connection addr_adaption_0.asmi_mem asmi2_inst_epcq_ctrl.avl_mem avalon
    add_connection addr_adaption_0.asmi_csr asmi2_inst_epcq_ctrl.avl_csr avalon
	add_connection addr_adaption_0.chip_select asmi2_inst_epcq_ctrl.chip_select conduit
    # exported interfaces
    add_interface avl_csr avalon slave
    set_interface_property avl_csr EXPORT_OF addr_adaption_0.avl_csr
    add_interface avl_mem avalon slave
    set_interface_property avl_mem EXPORT_OF addr_adaption_0.avl_mem
    add_interface interrupt_sender interrupt sender
    set_interface_property interrupt_sender EXPORT_OF addr_adaption_0.interrupt_sender
    add_interface clock_sink clock sink
    set_interface_property clock_sink EXPORT_OF clk.in_clk
    add_interface reset reset sink
    set_interface_property reset EXPORT_OF reset.in_reset

	# +-------------------------------------
	# | Add settings needed by Nios tools
	# +-------------------------------------
	# Tells us component is a flash 
	set_module_assignment embeddedsw.memoryInfo.IS_FLASH 1
	
	# interface assignments for embedded software
	#set_interface_assignment avl_mem embeddedsw.configuration.isFlash 1
	#set_interface_assignment avl_mem embeddedsw.configuration.isMemoryDevice 1
	#set_interface_assignment avl_mem embeddedsw.configuration.isNonVolatileStorage 1
	#set_interface_assignment avl_mem embeddedsw.configuration.isPrintableDevice 0
	
	# These assignments tells tools to create byte-addressed .hex files only
	set_module_assignment embeddedsw.memoryInfo.GENERATE_HEX 1
	set_module_assignment embeddedsw.memoryInfo.USE_BYTE_ADDRESSING_FOR_HEX 1
	set_module_assignment embeddedsw.memoryInfo.GENERATE_DAT_SYM 0
	set_module_assignment embeddedsw.memoryInfo.GENERATE_FLASH 0
	
	# Width of memory
	set_module_assignment embeddedsw.memoryInfo.MEM_INIT_DATA_WIDTH 32
	
	# Output directories for programming files
	#set_module_assignment embeddedsw.memoryInfo.DAT_SYM_INSTALL_DIR {SIM_DIR}
	#set_module_assignment embeddedsw.memoryInfo.FLASH_INSTALL_DIR {APP_DIR}
	set_module_assignment embeddedsw.memoryInfo.HEX_INSTALL_DIR {QPF_DIR}
	
	# Module assignments related to names of simulation files
	#set_module_assignment postgeneration.simulation.init_file.param_name {INIT_FILENAME}
	#set_module_assignment postgeneration.simulation.init_file.type {MEM_INIT}
	
	# +-------------------------------------
	# | Add settings needed by DTG tools
	# +-------------------------------------
	# add device tree properties
	set_module_assignment embeddedsw.dts.vendor "altr"
	set_module_assignment embeddedsw.dts.name "epcq"
	set_module_assignment embeddedsw.dts.group "epcq"
	set_module_assignment embeddedsw.dts.compatible "altr,epcq-1.0"

	# rename the port to match current epcq_controller1
	rename_port_name
	# set macro for eSW BSP setting
	set_cmacros $is_qspi $FLASH_TYPE
}

proc rename_port_name { } {
    #read interfaces from compose components
    foreach interface [get_interfaces] {
        #send_message INFO "interface found: $interface"
        # For each inteface, find the port in the child instance
        # and overwrite them to same name as child
        if {$interface eq "clock_sink"} {
            set_interface_property clock_sink PORT_NAME_MAP "clk in_clk"
        } elseif {$interface eq "reset"} {
            set_interface_property reset PORT_NAME_MAP "reset_n in_reset_n"
        } else {
            foreach port [get_instance_interface_ports addr_adaption_0 $interface] {
                set the_ports($port) $port
            }
            set_interface_property $interface PORT_NAME_MAP [array get the_ports]
        }
        
    }
}

# This proc is called by elaboration proc to set embeddedsw C Macros assignments 
# used by downstream tools
proc set_cmacros {is_qspi flash_type} {
    if {$is_qspi eq "true"} {
        set_module_assignment embeddedsw.CMacro.IS_EPCS 0
    } else {
        set_module_assignment embeddedsw.CMacro.IS_EPCS 1
    }

    #string name of flash
    set_module_assignment embeddedsw.CMacro.FLASH_TYPE $flash_type

    #page size in bytes
    set_module_assignment embeddedsw.CMacro.PAGE_SIZE 256
    
    #sector and subsector size in bytes
    set_module_assignment embeddedsw.CMacro.SUBSECTOR_SIZE 4096
    set_module_assignment embeddedsw.CMacro.SECTOR_SIZE 65536
  
    #set number of sectors
    switch $flash_type {
        "EPCQ4A" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 8
        }
        "EPCQ16" - "EPCQ16A" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 32
        }
        "EPCQ32" - "EPCQ32A" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 64
		}
        "EPCQ64" - "EPCQ64A" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 128
        }
        "EPCQ128" - "EPCQ128A" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 256
        }
        "EPCQ256" - "EPCQL256" - "MT25QL256" - "MT25QU256" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 512
        }
        "EPCQ512" - "EPCQL512" - "MT25QL512" - "MT25QU512" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 1024
        }
        "EPCQL1024" - "MT25QU01G" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 2048
        }
        default {
            # Should never enter this function
            send_message error "$flash_type is not a valid flash type"
        }
    }
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sfo1400787952932/iga1431459459085 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697689300
