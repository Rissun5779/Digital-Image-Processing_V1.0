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


package require -exact qsys 13.1

# +-----------------------------------
# | module mdio
# | 
set_module_property DESCRIPTION "Altera Ethernet MDIO"
set_module_property NAME altera_eth_mdio
set_module_property VERSION 18.1
set_module_property AUTHOR "Altera Corporation"
set_module_property INTERNAL false
set_module_property GROUP "Interface Protocols/Ethernet/Reference Design Components"
set_module_property DISPLAY_NAME "Ethernet MDIO Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property VALIDATION_CALLBACK validate
set_module_property EDITABLE false
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_embedded_ip.pdf"
set_module_property SUPPORTED_DEVICE_FAMILIES {
   "Arria 10"
   "MAX 10"
   "Stratix V" 
   "Stratix IV" 
   "Arria II GX" 
   "Arria II GZ" 
   "Arria V" 
   "Arria V GZ"
   "Cyclone V" 
   "Cyclone IV E" 
   "Cyclone IV GX"} 
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
set rtl_files {
    altera_eth_mdio.v   VERILOG
}

add_fileset qsynth QUARTUS_SYNTH qsynth_proc
set_fileset_property qsynth TOP_LEVEL altera_eth_mdio

proc qsynth_proc { none } {
    
    global rtl_files
    
	foreach {file_name filetype} $rtl_files {
        add_fileset_file $file_name $filetype PATH $file_name
    }
}

add_fileset simulation_verilog SIM_VERILOG sim_ver
set_fileset_property simulation_verilog TOP_LEVEL altera_eth_mdio

proc sim_ver {name} {
    
    global rtl_files
    
    foreach {file_name filetype} $rtl_files {
        add_fileset_file $file_name $filetype PATH $file_name
    }
    
}

add_fileset simulation_vhdl SIM_VHDL sim_vhdl
set_fileset_property simulation_vhdl TOP_LEVEL altera_eth_mdio

proc sim_vhdl {name} {
    
    global rtl_files
    
    foreach {file_name filetype} $rtl_files {
        if {1} {
            add_fileset_file mentor/$file_name $filetype\_ENCRYPT PATH mentor/$file_name {MENTOR_SPECIFIC}
        }
        
        if {1} {
            add_fileset_file aldec/$file_name $filetype\_ENCRYPT PATH aldec/$file_name {ALDEC_SPECIFIC}
        }
        
        if {1} {
            add_fileset_file cadence/$file_name $filetype\_ENCRYPT PATH cadence/$file_name {CADENCE_SPECIFIC}
        }
        
        if {1} {
            add_fileset_file synopsys/$file_name $filetype\_ENCRYPT PATH synopsys/$file_name {SYNOPSYS_SPECIFIC}
        }
    }
    
}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter MDC_DIVISOR INTEGER 32 ""
set_parameter_property MDC_DIVISOR DISPLAY_NAME MDC_DIVISOR
set_parameter_property MDC_DIVISOR ENABLED true
set_parameter_property MDC_DIVISOR UNITS None
set_parameter_property MDC_DIVISOR ALLOWED_RANGES -2147483648:2147483647
set_parameter_property MDC_DIVISOR DESCRIPTION "Host Clock Divisor"
set_parameter_property MDC_DIVISOR DISPLAY_HINT ""
set_parameter_property MDC_DIVISOR AFFECTS_GENERATION false
set_parameter_property MDC_DIVISOR HDL_PARAMETER true

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock
# | 
add_interface clock clock end
set_interface_property clock ptfSchematicName ""

set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1
add_interface_port clock reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point csr
# | 
add_interface csr avalon end
set_interface_property csr addressAlignment DYNAMIC
set_interface_property csr bridgesToMaster ""
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr holdTime 0
set_interface_property csr isMemoryDevice false
set_interface_property csr isNonVolatileStorage false
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr printableDevice false
set_interface_property csr readLatency 0
set_interface_property csr readWaitTime 1
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0

set_interface_property csr ASSOCIATED_CLOCK clock
set_interface_property csr ENABLED true

add_interface_port csr csr_write write Input 1
add_interface_port csr csr_read read Input 1
add_interface_port csr csr_address address Input 6
add_interface_port csr csr_writedata writedata Input 32
add_interface_port csr csr_readdata readdata Output 32
add_interface_port csr csr_waitrequest waitrequest Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point MDIO out
# | 
add_interface "mdio" conduit end

set_interface_property "mdio" ENABLED true

add_interface_port "mdio" mdc export Output 1
add_interface_port "mdio" mdio_in export Input 1
add_interface_port "mdio" mdio_out export Output 1
add_interface_port "mdio" mdio_oen export Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | Validate
# | 
proc validate {} {
    
    #  Parameters
    #---------------------------------------------------------------------
    set MDC_DIVISOR [ get_parameter_value MDC_DIVISOR ]
    
    #  Validation
    #---------------------------------------------------------------------
    if { $MDC_DIVISOR < 8 } {
        send_message error "MDC_DIVISOR must be greater than 8"
    }

}
# | 
# +-----------------------------------


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/sfo1400787952932/iga1401395383139
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
