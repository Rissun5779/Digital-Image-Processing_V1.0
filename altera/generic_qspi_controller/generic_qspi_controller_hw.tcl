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


package require -exact qsys 14.1
package require -exact altera_terp 1.0


# 
# module altera_trace_wrapper
# 
set_module_property DESCRIPTION "This component is a generic QSPI controller which allows user to access any QSPI devices"
set_module_property NAME altera_generic_quad_spi_controller
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Memory Interfaces and Controllers/Flash"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Generic QUAD SPI Controller Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property HIDE_FROM_QUARTUS true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate

add_fileset QUARTUS_SYNTH QUARTUS_SYNTH quartus_synth_proc
add_fileset SIM_VERILOG SIM_VERILOG simverilog

proc simverilog { instance_name } {
   add_topwrapper_fileset_proc "generic_qspi_controller.sv.terp" $instance_name
}

proc quartus_synth_proc { instance_name } {
    add_topwrapper_fileset_proc "generic_qspi_controller.sv.terp" $instance_name
}
	
# 
# parameters
#
# +-----------------------------------
# | device family info
# +-----------------------------------

set device_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "Max 10 FPGA"}    
							
set_module_property SUPPORTED_DEVICE_FAMILIES    $device_list

# system info parameters

add_parameter 			DEVICE_FAMILY 	STRING
set_parameter_property 	DEVICE_FAMILY 	SYSTEM_INFO 	{DEVICE_FAMILY}
set_parameter_property 	DEVICE_FAMILY 	VISIBLE 		false
set_parameter_property  DEVICE_FAMILY 	HDL_PARAMETER true

add_parameter 		UNIQUE_ID 	STRING
set_parameter_property 	UNIQUE_ID 	SYSTEM_INFO 	{UNIQUE_ID}
set_parameter_property 	UNIQUE_ID 	VISIBLE 		false
set_parameter_property  UNIQUE_ID 	HDL_PARAMETER   false

add_parameter clkFreq LONG
set_parameter_property clkFreq DEFAULT_VALUE {0}
set_parameter_property clkFreq DISPLAY_NAME {clkFreq}
set_parameter_property clkFreq VISIBLE {0}
set_parameter_property clkFreq AFFECTS_GENERATION {1}
set_parameter_property clkFreq HDL_PARAMETER {0}
set_parameter_property clkFreq SYSTEM_INFO {clock_rate clock_sink}
set_parameter_property clkFreq SYSTEM_INFO_TYPE {CLOCK_RATE}
set_parameter_property clkFreq SYSTEM_INFO_ARG {clock_sink}

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
set_parameter_property ADDR_WIDTH ALLOWED_RANGES {19, 20, 21, 22, 23, 24, 25, 26, 27, 28}	
set_parameter_property ADDR_WIDTH HDL_PARAMETER true

add_parameter ASI_WIDTH INTEGER 1
set_parameter_property ASI_WIDTH DEFAULT_VALUE 1
set_parameter_property ASI_WIDTH DISPLAY_NAME ASI_WIDTH
set_parameter_property ASI_WIDTH DERIVED true
set_parameter_property ASI_WIDTH TYPE INTEGER
set_parameter_property ASI_WIDTH VISIBLE false
set_parameter_property ASI_WIDTH UNITS None
set_parameter_property ASI_WIDTH ALLOWED_RANGES {1, 4}
set_parameter_property ASI_WIDTH HDL_PARAMETER true

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

add_parameter DDASI	INTEGER "0"
set_parameter_property DDASI DISPLAY_NAME "Disable dedicated Active Serial interface"
set_parameter_property DDASI DESCRIPTION "Check to route ASMIBLOCK signals to top level of design"
set_parameter_property DDASI AFFECTS_GENERATION true
set_parameter_property DDASI VISIBLE false
set_parameter_property DDASI DERIVED true

# SPI device selection
add_parameter FLASH_TYPE STRING "EPCQ16"
set_parameter_property FLASH_TYPE DISPLAY_NAME "Configuration device type"
set_parameter_property FLASH_TYPE DESCRIPTION "Select targeted flash devices"
set_parameter_property FLASH_TYPE AFFECTS_GENERATION true
set_parameter_property FLASH_TYPE VISIBLE true
set_parameter_property FLASH_TYPE DERIVED false

add_parameter IO_MODE STRING "QUAD"
set_parameter_property IO_MODE DISPLAY_NAME "Choose I/O mode"
set_parameter_property IO_MODE DESCRIPTION "Select extended data width when Fast Read operation is enabled"
set_parameter_property IO_MODE HDL_PARAMETER true
set_parameter_property IO_MODE AFFECTS_GENERATION true
set_parameter_property IO_MODE VISIBLE true

add_parameter CHIP_SELS INTEGER "1"
set_parameter_property CHIP_SELS DISPLAY_NAME "Number of Chip Selects used"
set_parameter_property CHIP_SELS ALLOWED_RANGES {1 2 3}
set_parameter_property CHIP_SELS DESCRIPTION "Number of EPCQ(L) devices that are attached and need a CHIPSEL"
set_parameter_property CHIP_SELS HDL_PARAMETER true
set_parameter_property CHIP_SELS AFFECTS_GENERATION true

# +-----------------------------------

# add system info parameter
add_parameter           deviceFeaturesSystemInfo   STRING 		"None"
set_parameter_property  deviceFeaturesSystemInfo   system_info		"DEVICE_FEATURES"
set_parameter_property  deviceFeaturesSystemInfo   VISIBLE false

# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock_sink
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point avl_csr
# 
add_interface avl_csr avalon end
set_interface_property avl_csr addressUnits WORDS
set_interface_property avl_csr associatedClock clock_sink
set_interface_property avl_csr associatedReset reset
set_interface_property avl_csr bitsPerSymbol 8
set_interface_property avl_csr burstOnBurstBoundariesOnly false
set_interface_property avl_csr burstcountUnits WORDS
set_interface_property avl_csr explicitAddressSpan 0
set_interface_property avl_csr holdTime 0
set_interface_property avl_csr linewrapBursts false
set_interface_property avl_csr maximumPendingReadTransactions 1
set_interface_property avl_csr maximumPendingWriteTransactions 0
set_interface_property avl_csr readLatency 0
set_interface_property avl_csr readWaitTime 0
set_interface_property avl_csr setupTime 0
set_interface_property avl_csr timingUnits Cycles
set_interface_property avl_csr writeWaitTime 0
set_interface_property avl_csr ENABLED true
set_interface_property avl_csr EXPORT_OF ""
set_interface_property avl_csr PORT_NAME_MAP ""
set_interface_property avl_csr CMSIS_SVD_VARIABLES ""
set_interface_property avl_csr SVD_ADDRESS_GROUP ""

add_interface_port avl_csr avl_csr_read read Input 1
add_interface_port avl_csr avl_csr_waitrequest waitrequest Output 1
add_interface_port avl_csr avl_csr_write write Input 1
add_interface_port avl_csr avl_csr_addr address Input 3
add_interface_port avl_csr avl_csr_wrdata writedata Input 32
add_interface_port avl_csr avl_csr_rddata readdata Output 32
add_interface_port avl_csr avl_csr_rddata_valid readdatavalid Output 1

set svd_path [file join $::env(QUARTUS_ROOTDIR) .. ip altera generic_qspi_controller altera_generic_quad_spi_controller.svd]
set_interface_property avl_csr CMSIS_SVD_FILE $svd_path

# 
# connection point avl_mem
# 
add_interface avl_mem avalon end
set_interface_property avl_mem addressUnits WORDS
set_interface_property avl_mem associatedClock clock_sink
set_interface_property avl_mem associatedReset reset
set_interface_property avl_mem bitsPerSymbol 8
set_interface_property avl_mem burstOnBurstBoundariesOnly false
set_interface_property avl_mem burstcountUnits WORDS
set_interface_property avl_mem explicitAddressSpan 0
set_interface_property avl_mem holdTime 0
set_interface_property avl_mem linewrapBursts true
set_interface_property avl_mem maximumPendingReadTransactions 1
set_interface_property avl_mem maximumPendingWriteTransactions 0
set_interface_property avl_mem constantBurstBehavior true
set_interface_property avl_mem readLatency 0
set_interface_property avl_mem readWaitTime 0
set_interface_property avl_mem setupTime 0
set_interface_property avl_mem timingUnits Cycles
set_interface_property avl_mem writeWaitTime 0
set_interface_property avl_mem ENABLED true
set_interface_property avl_mem EXPORT_OF ""
set_interface_property avl_mem PORT_NAME_MAP ""
set_interface_property avl_mem CMSIS_SVD_VARIABLES ""
set_interface_property avl_mem SVD_ADDRESS_GROUP ""

add_interface_port avl_mem avl_mem_write write Input 1
add_interface_port avl_mem avl_mem_burstcount burstcount Input 7
add_interface_port avl_mem avl_mem_waitrequest waitrequest Output 1
add_interface_port avl_mem avl_mem_read read Input 1
add_interface_port avl_mem avl_mem_addr address Input ADDR_WIDTH
add_interface_port avl_mem avl_mem_wrdata writedata Input 32
add_interface_port avl_mem avl_mem_rddata readdata Output 32
add_interface_port avl_mem avl_mem_rddata_valid readdatavalid Output 1
add_interface_port avl_mem avl_mem_byteenable byteenable Input 4

# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint avl_csr
set_interface_property interrupt_sender associatedClock clock_sink
set_interface_property interrupt_sender associatedReset reset
set_interface_property interrupt_sender bridgedReceiverOffset ""
set_interface_property interrupt_sender bridgesToReceiver ""
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender irq irq Output 1

add_interface      flash_dataout conduit end
add_interface_port flash_dataout flash_dataout conduit_dataout Bidir 4

add_interface      flash_dclk_out conduit end
add_interface_port flash_dclk_out flash_dclk_out conduit_dclk_out Output 1

add_interface      flash_ncs conduit end
add_interface_port flash_ncs flash_ncs conduit_ncs Output CS_WIDTH

proc proc_get_derive_addr_width {flash_type} {
    switch $flash_type {
        "EPCQ16" - "EPCQ16A" - "N25Q16" {
            return 19 
        }
        "EPCQ32" - "EPCQ32A" - "N25Q32" {
            return 20
        }
        "EPCQ64" - "EPCQ64A" - "N25Q64" {
            return 21
        }
        "EPCQ128" - "EPCQ128A" - "N25Q128" {
            return 22
        }
        "EPCQ256" - "EPCQL256" - "N25Q256" - "N25Q256-L" - "MT25QL256" - "MT25QU256" {
            return 23
        }
        "EPCQ512" - "EPCQL512" - "N25Q512" - "N25Q512-L" - "Micron512" - "MT25QL512" - "MT25QU512" {
            return 24
        }
        "EPCQL1024" - "N25Q1024-L" - "MT25QU01G" {
            return 25
        }
        default {
            # Should never enter this function
            send_message error "$flash_type is not a valid flash type"
        }
    }
}

proc add_topwrapper_fileset_proc {template_file file_name} {
	
#--------------------------------------------- settings that exist in all procedure ------------------------------------------------
set EPCQ_SPI_list {"EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128"  "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "EPCQ256" "EPCQL256" "EPCQ512" "EPCQL512" "EPCQL1024" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G"}

# QSPI that supported for 4-byte addressing - en4b_addr
set supported_4byte_addr 	{"EPCQ256" "EPCQ512" "EPCQL256" "EPCQL512" "EPCQL1024" "N25Q256" "N25Q256-L" "N25Q512" "N25Q512-L" "N25Q1024-L" "Micron512" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G"}

set QSPI_list {"EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128"  "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "EPCQ256" "EPCQL256" "EPCQ512" "EPCQL512" "EPCQL1024" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G" \
						"N25Q16" "N25Q32" "N25Q64" "N25Q128" "N25Q256" "N25Q256-L" "N25Q512" "N25Q512-L" "N25Q1024-L" "Micron512"}

# devices that supported QSPI - Quad/Dual data width, asmi_dataout, asmi_sdoin, asmi_dataoe
set supported_QSPI_devices_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "MAX 10 FPGA"}

# devices that supported simulation
set supported_sim_devices_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "MAX 10 FPGA"}

set stacked_die_device {"EPCQL512" "EPCQL1024" "N25Q512-L" "N25Q1024-L" "Micron512" "MT25QU01G"}
#-----------------------------------------------------------------------------------------------------------------------------------
	
	set DEVICE_FAMILY 		[ get_parameter_value DEVICE_FAMILY ]
	set FLASH_TYPE 			[ get_parameter_value FLASH_TYPE ]
	set DDASI 			[ get_parameter_value DDASI ]
	set ADDR_WIDTH			[ get_parameter_value ADDR_WIDTH ]
	set UNIQUE_ID                   [ get_parameter_value UNIQUE_ID ]
	set is_4byte_addr_support	"false"
	set ENABLE_BULK_ERASE 		"true"
	
	# check whether devices supporting multiple flash - only for Arria 10
	if {[check_device_family_equivalence $DEVICE_FAMILY "Arria 10"]} {
		set MULTICHIP 1
	} else {
		set MULTICHIP 0
	}

	foreach non_bulk_erase_device   $stacked_die_device {
		if {$non_bulk_erase_device eq $FLASH_TYPE} {
			set ENABLE_BULK_ERASE	"false"
			break;
		 }
	}
	
	 # check whether SPI device support 4-byte addressing
	foreach re_spi_1   $supported_4byte_addr {
		if {$re_spi_1 eq $FLASH_TYPE} {
			set is_4byte_addr_support	"true"
			break;
		 }
	}
	 
	if { $DDASI eq "1" } {
		set DDASI_ON 1
	} else {
		set DDASI_ON 0
	}
	 
	if {$is_4byte_addr_support eq "true"} {
		set ENABLE_4BYTE_ADDR_CODE 1
	} else {
		set ENABLE_4BYTE_ADDR_CODE 0
	}
	
	# ---------------------------------
	#   Terp for top level wrapper
	# ---------------------------------
	#Do Terp
	set this_dir           [ get_module_property MODULE_DIRECTORY ]
	set template_file      [ file join $this_dir $template_file ]   
        set template           [ read [ open $template_file r ] ]

	set params(DDASI_ON) 		$DDASI_ON 	
	set params(MULTICHIP) 		$MULTICHIP
	set params(BULK_ERASE_EN) 	$ENABLE_BULK_ERASE
	set params(4BYTE_ADDR_EN) 	$ENABLE_4BYTE_ADDR_CODE
	set params(file_name)           $file_name
	set autogeneratedfixedname0     [ get_instance_property asmi_parallel_instance_name HDLINSTANCE_GET_GENERATED_NAME ]
	set params(substitute_hdlinstance_asmi_parallel_instance_name) $autogeneratedfixedname0
	set autogeneratedfixedname1     [ get_instance_property epcq_controller_instance_name HDLINSTANCE_GET_GENERATED_NAME ]
	set params(substitute_hdlinstance_epcq_controller_instance_name) $autogeneratedfixedname1
	set autogeneratedfixedname2     [ get_instance_property soft_asmiblock_instance_name HDLINSTANCE_GET_GENERATED_NAME ]
	set params(substitute_hdlinstance_soft_asmiblock_instance_name) $autogeneratedfixedname2
	
	set result                      [ altera_terp $template params ]
	set output_file                 "$file_name.sv"
	
	#Add top wrapper file
	add_fileset_file $output_file SYSTEM_VERILOG TEXT $result
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
        "N25Q16" - "EPCQ16" - "EPCQ16A" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 32
        }
        "EPCQ32" - "EPCQ32A" - "N25Q32" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 64
		}
        "N25Q64" - "EPCQ64A" - "EPCQ64" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 128
        }
        "N25Q128" - "EPCQ128A" - "EPCQ128" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 256
        }
        "EPCQ256" - "EPCQL256" - "N25Q256" - "N25Q256-L" - "MT25QL256" - "MT25QU256" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 512
        }
        "EPCQ512" - "EPCQL512" - "N25Q512" - "N25Q512-L" - "Micron512" - "MT25QL512" - "MT25QU512" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 1024
        }
        "EPCQL1024" - "N25Q1024-L" - "MT25QU01G" {
            set_module_assignment embeddedsw.CMacro.NUMBER_OF_SECTORS 2048
        }
        default {
            # Should never enter this function
            send_message error "$flash_type is not a valid flash type"
        }
    }
}

proc validate {} {
	set FLASH_TYPE           [ get_parameter_value FLASH_TYPE ]
	set enable_MT25Q         [ get_quartus_ini pgm_allow_mt25q ENABLED ]
	
    set all_supported_SPI_list_w_ini {"EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "EPCQ256" "EPCQL256" "EPCQ512" "EPCQL512" "EPCQL1024" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G" \
							"N25Q16:N25Q016A13ESF40" "N25Q32:N25Q032A13ESF40" "N25Q64:N25Q064A13ESF40" "N25Q128:N25Q128A13ESF40" "N25Q256:N25Q256A13ESF40" "N25Q256-L:N25Q256A11E1240(low voltage)" "N25Q512:MT25QL512ABA" "N25Q512-L:N25Q512A11G1240(low voltage)" "N25Q1024-L:N25Q00AA11G1240(low voltage)" \
							"Micron512:N25Q512A83GSF40F"}
	
    set all_supported_SPI_list {"EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "EPCQ256" "EPCQL256" "EPCQ512" "EPCQL512" "EPCQL1024" \
							"N25Q16:N25Q016A13ESF40" "N25Q32:N25Q032A13ESF40" "N25Q64:N25Q064A13ESF40" "N25Q128:N25Q128A13ESF40" "N25Q256:N25Q256A13ESF40" "N25Q256-L:N25Q256A11E1240(low voltage)" "N25Q512:MT25QL512ABA" "N25Q512-L:N25Q512A11G1240(low voltage)" "N25Q1024-L:N25Q00AA11G1240(low voltage)" \
							"Micron512:N25Q512A83GSF40F"}
							
    if {$enable_MT25Q == 1} {
        set_parameter_property FLASH_TYPE ALLOWED_RANGES $all_supported_SPI_list_w_ini
    } else {
		set_parameter_property FLASH_TYPE ALLOWED_RANGES $all_supported_SPI_list
    }
}

proc elaborate {} {
#--------------------------------------------- settings that exist in all procedure ------------------------------------------------
set EPCQ_SPI_list {"EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "EPCQ256" "EPCQL256" "EPCQ512" "EPCQL512" "EPCQL1024" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G"}

# QSPI that supported for 4-byte addressing - en4b_addr
set supported_4byte_addr 	{"EPCQ256" "EPCQ512" "EPCQL256" "EPCQL512" "EPCQL1024" "N25Q256" "N25Q256-L" "N25Q512" "N25Q512-L" "N25Q1024-L" "Micron512" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G"}

set QSPI_list {"EPCQ16" "EPCQ32" "EPCQ64" "EPCQ128" "EPCQ16A" "EPCQ32A" "EPCQ64A" "EPCQ128A" "EPCQ256" "EPCQL256" "EPCQ512" "EPCQL512" "EPCQL1024" "MT25QL256" "MT25QL512" "MT25QU256" "MT25QU512" "MT25QU01G" \
						"N25Q16" "N25Q32" "N25Q64" "N25Q128" "N25Q256" "N25Q256-L" "N25Q512" "N25Q512-L" "N25Q1024-L" "Micron512"}

# devices that supported QSPI - Quad/Dual data width, asmi_dataout, asmi_sdoin, asmi_dataoe
set supported_QSPI_devices_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "MAX 10 FPGA"}

# devices that supported simulation
set supported_sim_devices_list {"Arria 10" "Cyclone V" "Arria V GZ" "Arria V" "Stratix V" "MAX 10 FPGA"}

set stacked_die_device {"EPCQL512" "EPCQL1024" "N25Q512-L" "N25Q1024-L" "Micron512" "MT25QU01G"}
#-----------------------------------------------------------------------------------------------------------------------------------
	
set FLASH_TYPE 				[ get_parameter_value FLASH_TYPE ]
set IO_MODE 				[ get_parameter_value IO_MODE ]
set DEVICE_FAMILY 			[ get_parameter_value DEVICE_FAMILY ]
set CS_WIDTH 				[ get_parameter_value CS_WIDTH ]
set CHIP_SELS               [ get_parameter_value CHIP_SELS]
set temp_addr_width         [ proc_get_derive_addr_width [ get_parameter_value FLASH_TYPE ] ]
set clkFreq 				[ get_parameter_value clkFreq ]
set UNIQUE_ID               [ get_parameter_value UNIQUE_ID ]
set is_4byte_addr_support	        "false"
set is_qspi				"false"
set is_epcq_spi				"false"
set ENABLE_BULK_ERASE       "true"   

    # add ASMI BLOCK
    add_hdl_instance        soft_asmiblock_instance_name soft_asmiblock
    set_instance_property   soft_asmiblock_instance_name HDLINSTANCE_USE_GENERATED_NAME 1
	
    # add ASMI PARALLEL
    add_hdl_instance        asmi_parallel_instance_name altera_asmi_parallel
    set_instance_property   asmi_parallel_instance_name HDLINSTANCE_USE_GENERATED_NAME 1
    
    # add EPCQ CONTROLLER
    add_hdl_instance        epcq_controller_instance_name altera_epcq_controller_core
    set_instance_property   epcq_controller_instance_name HDLINSTANCE_USE_GENERATED_NAME 1
	
	# check whether SPI device support 4-byte addressing
	foreach re_spi_1   $supported_4byte_addr {
		if {$re_spi_1 eq $FLASH_TYPE} {
			set is_4byte_addr_support	"true"
			break;
		 }
	 }
	 
	if { $clkFreq > 25000000 } {
		send_message error "Input clock frequency for Quad SPI controller need to be lesser than 25Mhz to operate properly"
	}
	 
	if {$is_4byte_addr_support eq "true"} {
		set_parameter_value 	ENABLE_4BYTE_ADDR "1"
		set_parameter_value		ASMI_ADDR_WIDTH 32
	} else {
		set_parameter_value 	ENABLE_4BYTE_ADDR "0"
		set_parameter_value		ASMI_ADDR_WIDTH 24
	}
	
	foreach epcq_list_0  $EPCQ_SPI_list {
		if {$epcq_list_0 eq $FLASH_TYPE} {
			set is_epcq_spi	"true"
			break;
		 }
	 }
	 
       if {$is_epcq_spi eq "true"} {
		set_parameter_value		DDASI 0
	} else {
		set_parameter_value		DDASI 1
	}
	
	if {$is_epcq_spi eq "true" && [check_device_family_equivalence $DEVICE_FAMILY "MAX 10 FPGA"]} {
		send_message error "EPCQ devices are not supported in MAX 10 FPGA"
	}
	
	# check whether devices supporting multiple flash - only for Arria 10
	if {[check_device_family_equivalence $DEVICE_FAMILY "Arria 10"]} {
		set is_multi_flash_support	"true"
		if {$CHIP_SELS eq 3 } {set_parameter_value 	ADDR_WIDTH 		[ expr $temp_addr_width + 2]}
		if {$CHIP_SELS eq 2 } {set_parameter_value 	ADDR_WIDTH 		[ expr $temp_addr_width + 1]}
		if {$CHIP_SELS eq 1 } {set_parameter_value 	ADDR_WIDTH 		$temp_addr_width }
	} else {
		set is_multi_flash_support	"false"
		set_parameter_value 	ADDR_WIDTH 		$temp_addr_width
	}
	
	if {[check_device_family_equivalence $DEVICE_FAMILY "MAX 10 FPGA"]} {
		set_parameter_property IO_MODE ALLOWED_RANGES {"QUAD"}
	} else {
		set_parameter_property IO_MODE ALLOWED_RANGES {"STANDARD" "QUAD"}
	}
	
	#-------------------------------- Set epcq_controller_instance_name --------------------------------------------------
	
	if { $FLASH_TYPE eq "N25Q16"} {		#Micron
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			"EPCQ16"
	} elseif { $FLASH_TYPE eq "N25Q32"} {	#Micron
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			"EPCQ32"
	} elseif { $FLASH_TYPE eq "N25Q64"} {	#Micron
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			"EPCQ64"
	} elseif { $FLASH_TYPE eq "N25Q128"} {	#Micron
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			"EPCQ128"
	} elseif { $FLASH_TYPE eq "N25Q256"} {	#Micron
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			"EPCQ256"
	} elseif { $FLASH_TYPE eq "N25Q256-L" || $FLASH_TYPE eq "MT25QL256" || $FLASH_TYPE eq "MT25QU256"} {	#Micron
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			"EPCQL256"
	} elseif { $FLASH_TYPE eq "N25Q512"} {	#Micron
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			"EPCQ512"
	} elseif { $FLASH_TYPE eq "N25Q512-L" || $FLASH_TYPE eq "Micron512" || $FLASH_TYPE eq "MT25QL512" || $FLASH_TYPE eq "MT25QU512"} {	#Micron
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			"EPCQL512"
	} elseif { $FLASH_TYPE eq "N25Q1024-L" || $FLASH_TYPE eq "MT25QU01G"} {	#Micron
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			"EPCQL1024"
	} else {								#Altera EPCQ
		set_instance_parameter_value 	epcq_controller_instance_name FLASH_TYPE 			$FLASH_TYPE
	}
	
	set_instance_parameter_value	epcq_controller_instance_name DDASI [ get_parameter_value DDASI ]
	set_instance_parameter_value	epcq_controller_instance_name IO_MODE $IO_MODE
	set_instance_parameter_value	epcq_controller_instance_name ASI_WIDTH [ get_parameter_value ASI_WIDTH ]
	set_instance_parameter_value	epcq_controller_instance_name CS_WIDTH $CS_WIDTH
	set_instance_parameter_value	epcq_controller_instance_name CHIP_SELS $CHIP_SELS
	set_instance_parameter_value	epcq_controller_instance_name ASMI_ADDR_WIDTH [ get_parameter_value ASMI_ADDR_WIDTH ]
	set_instance_parameter_value	epcq_controller_instance_name ADDR_WIDTH [ get_parameter_value ADDR_WIDTH ]
	set_instance_parameter_value	epcq_controller_instance_name ENABLE_4BYTE_ADDR [ get_parameter_value ENABLE_4BYTE_ADDR ]

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
	
	if {$is_qspi_devices_list eq "true" && $is_qspi eq "true"} {
		set_instance_parameter_value 	asmi_parallel_instance_name DATA_WIDTH 		$IO_MODE
		set_parameter_value ASI_WIDTH 4
    } else {
		set_parameter_value ASI_WIDTH 1
	}
	
	#-------------------------------Set asmi_parallel_instance_name -------------------------------------------------
	if {[check_device_family_equivalence $DEVICE_FAMILY "MAX 10 FPGA"]} {
		set_instance_parameter_value 	asmi_parallel_instance_name   DEVICE_FAMILY 		"Arria V"
	} else {
		set_instance_parameter_value 	asmi_parallel_instance_name   DEVICE_FAMILY 		$DEVICE_FAMILY
	}
	set_instance_parameter_value	epcq_controller_instance_name DEVICE_FAMILY        $DEVICE_FAMILY
	
	foreach non_bulk_erase_device   $stacked_die_device {
		if {$non_bulk_erase_device eq $FLASH_TYPE} {
			set ENABLE_BULK_ERASE	"false"
			break;
		 }
	 }
	
	if { $ENABLE_BULK_ERASE eq "true" } {
		set_instance_parameter_value 	asmi_parallel_instance_name gui_bulk_erase 		true
	} else {
		set_instance_parameter_value 	asmi_parallel_instance_name gui_bulk_erase 		false
	}
	
	if { $is_multi_flash_support eq "true"} {
		set_parameter_value CS_WIDTH 3
		set_parameter_property	CHIP_SELS	ENABLED		true
	} else {
		set_parameter_value CS_WIDTH 1
		set_parameter_property	CHIP_SELS	ENABLED		false
	}
	
	if { $FLASH_TYPE eq "N25Q16"} {		#Micron
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			"EPCQ16"
	} elseif { $FLASH_TYPE eq "N25Q32"} {	#Micron
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			"EPCQ32"
	} elseif { $FLASH_TYPE eq "N25Q64"} {	#Micron
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			"EPCQ64"
	} elseif { $FLASH_TYPE eq "N25Q128"} {	#Micron
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			"EPCQ128"
	} elseif { $FLASH_TYPE eq "N25Q256"} {	#Micron
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			"EPCQ256"
	} elseif { $FLASH_TYPE eq "N25Q256-L" || $FLASH_TYPE eq "MT25QL256" || $FLASH_TYPE eq "MT25QU256"} {	#Micron
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			"EPCQL256"
	} elseif { $FLASH_TYPE eq "N25Q512" || $FLASH_TYPE eq "MT25QL512" || $FLASH_TYPE eq "MT25QU512"} {	#Micron
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			"EPCQ512"
	} elseif { $FLASH_TYPE eq "N25Q512-L" || $FLASH_TYPE eq "Micron512"} {	#Micron
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			"EPCQL512"
	} elseif { $FLASH_TYPE eq "N25Q1024-L" || $FLASH_TYPE eq "MT25QU01G"} {	#Micron
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			"EPCQL1024"
	} else {								#Altera EPCQ
		set_instance_parameter_value 	asmi_parallel_instance_name EPCS_TYPE 			$FLASH_TYPE
	}
	
	if { $FLASH_TYPE eq "Micron512" } {
		set_instance_parameter_value 	asmi_parallel_instance_name FLASH_RSTPIN			TRUE
	} else {
		set_instance_parameter_value 	asmi_parallel_instance_name FLASH_RSTPIN			FALSE
	}
	
	set_instance_parameter_value 	asmi_parallel_instance_name gui_fast_read 		true
	set_instance_parameter_value 	asmi_parallel_instance_name gui_page_write 		true
	set_instance_parameter_value 	asmi_parallel_instance_name gui_read_sid 			false
	set_instance_parameter_value 	asmi_parallel_instance_name gui_read_rdid 		true
	set_instance_parameter_value 	asmi_parallel_instance_name gui_read_status 		true
	set_instance_parameter_value 	asmi_parallel_instance_name gui_sector_erase 		true
	set_instance_parameter_value 	asmi_parallel_instance_name gui_sector_protect 	true
	set_instance_parameter_value 	asmi_parallel_instance_name gui_wren 				true
	set_instance_parameter_value 	asmi_parallel_instance_name gui_write 			true
    set_instance_parameter_value 	asmi_parallel_instance_name gui_read_dummyclk		true
	set_instance_parameter_value 	asmi_parallel_instance_name PAGE_SIZE 			256
	
	if {$is_epcq_spi eq "true"} {
		set_instance_parameter_value 	asmi_parallel_instance_name gui_use_asmiblock		false
	} else {
		set_instance_parameter_value 	asmi_parallel_instance_name gui_use_asmiblock		true
	}
	
	if {$is_sim_devices_list eq "true"} {
		set_instance_parameter_value 	asmi_parallel_instance_name ENABLE_SIM			true
	} else {
		set_instance_parameter_value 	asmi_parallel_instance_name ENABLE_SIM			false
	}
	
	set_cmacros $is_qspi $FLASH_TYPE
	#------------------------ Set SOFT_ASMIBLOCK -------------------------------------------------------------------
	set_instance_parameter_value	soft_asmiblock_instance_name IO_MODE [ get_parameter_value IO_MODE ]
	set_instance_parameter_value	soft_asmiblock_instance_name CS_WIDTH $CS_WIDTH
	
	#------------------------ Export ports to flash ----------------------------------------------------------------
	if {[ get_parameter_value DDASI ] eq "1"} {
	    set_port_property flash_dataout  TERMINATION 0
	    set_port_property flash_dclk_out TERMINATION 0
	    set_port_property flash_ncs      TERMINATION 0
	} else {
	    set_port_property flash_dataout  TERMINATION 1
	    set_port_property flash_dclk_out TERMINATION 1
	    set_port_property flash_ncs      TERMINATION 1
	}
	
	set_port_property flash_dataout  TERMINATION_VALUE 0
	set_port_property flash_dclk_out TERMINATION_VALUE 0
	set_port_property flash_ncs      TERMINATION_VALUE 0
}

# +-------------------------------------
# | Add settings needed by Nios tools
# +-------------------------------------
# Tells us component is a flash 
set_module_assignment embeddedsw.memoryInfo.IS_FLASH 1

# interface assignments for embedded software
set_interface_assignment avl_mem embeddedsw.configuration.isFlash 1
set_interface_assignment avl_mem embeddedsw.configuration.isMemoryDevice 1
set_interface_assignment avl_mem embeddedsw.configuration.isNonVolatileStorage 1
set_interface_assignment avl_mem embeddedsw.configuration.isPrintableDevice 0

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
set_module_assignment embeddedsw.dts.name "quadspi"
set_module_assignment embeddedsw.dts.group "quadspi"
set_module_assignment embeddedsw.dts.compatible "altr,quadspi-1.0"
## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sfo1400787952932/iga1431459053861
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
