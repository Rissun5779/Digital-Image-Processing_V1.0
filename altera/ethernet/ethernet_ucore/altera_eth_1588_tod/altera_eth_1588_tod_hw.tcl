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
# | module altera_eth_1588_tod
# | 
set_module_property DESCRIPTION "Provides a stream of timestamps for use timestamping IEEE 1588 packets and other events."
set_module_property NAME altera_eth_1588_tod
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Interface Protocols/Ethernet/Reference Design Components"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Ethernet IEEE 1588 Time of Day Clock Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate
set_module_property ANALYZE_HDL false
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug-20019.pdf"
set_module_property SUPPORTED_DEVICE_FAMILIES {
   "MAX 10 FPGA"
   "Arria 10"
   "Stratix V" 
   "Arria V" 
   "Arria V GZ"
   "Cyclone V"} 


# +-----------------------------------
# | files
# | 
set rtl_files {
    altera_eth_1588_tod.v   VERILOG
    altera_eth_1588_tod_ojw.v   VERILOG
    altera_eth_1588_tod_xojw.v   VERILOG
    altera_eth_1588_tod_clock_crosser.v   VERILOG
}

add_fileset qsynth QUARTUS_SYNTH qsynth_proc
set_fileset_property qsynth TOP_LEVEL altera_eth_1588_tod

proc qsynth_proc { none } {
    
    global rtl_files
    
	foreach {file_name filetype} $rtl_files {
        add_fileset_file $file_name $filetype PATH $file_name
    }
    add_fileset_file altera_eth_1588_tod.sdc SDC PATH altera_eth_1588_tod.sdc
    
    set path [file join .. .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $path
}

add_fileset simulation_verilog SIM_VERILOG sim_ver
set_fileset_property simulation_verilog TOP_LEVEL altera_eth_1588_tod

proc sim_ver {name} {
    
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
    set path [file join .. .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $path
}

add_fileset simulation_vhdl SIM_VHDL sim_vhdl
set_fileset_property simulation_vhdl TOP_LEVEL altera_eth_1588_tod

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
    set path [file join .. .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $path
}
# | 
# +-----------------------------------


# | Callbacks
# | 
 proc elaborate {} {
    set ojw_mode [get_parameter_value OFFSET_JITTER_WANDER_EN]
    if {$ojw_mode == 1} {
        add_interface_port csr csr_address address Input 5
    } else {
        add_interface_port csr csr_address address Input 4
    }
 }

proc validate {} {
    set speed_mode [get_parameter_value PERIOD_CLOCK_FREQUENCY]
    set ojw_mode [get_parameter_value OFFSET_JITTER_WANDER_EN]
    
    if {$speed_mode == 1} {
        set_parameter_property OFFSET_JITTER_WANDER_EN ENABLED false
    } else {
        set_parameter_property OFFSET_JITTER_WANDER_EN ENABLED true
        if {$ojw_mode == 1} {
            set speed_mode 0
            set_parameter_property PERIOD_CLOCK_FREQUENCY ENABLED false
        } else {
            set speed_mode [get_parameter_value PERIOD_CLOCK_FREQUENCY]
            set_parameter_property PERIOD_CLOCK_FREQUENCY ENABLED true
        }
    }
    
    if {$speed_mode == 1} {
        set_parameter_property DEFAULT_NSEC_PERIOD ALLOWED_RANGES {0:15}
        set_parameter_property DEFAULT_NSEC_ADJPERIOD ALLOWED_RANGES {0:15}
    } else {
        set_parameter_property DEFAULT_NSEC_PERIOD ALLOWED_RANGES {0:511}
        set_parameter_property DEFAULT_NSEC_ADJPERIOD ALLOWED_RANGES {0:511}
    }

}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 

add_parameter PERIOD_CLOCK_FREQUENCY INTEGER 1
set_parameter_property PERIOD_CLOCK_FREQUENCY DISPLAY_NAME "Enable high clock frequency mode"
set_parameter_property PERIOD_CLOCK_FREQUENCY DESCRIPTION "check to support LL10GbE/40GbE/100GbE"
set_parameter_property PERIOD_CLOCK_FREQUENCY UNITS None
set_parameter_property PERIOD_CLOCK_FREQUENCY DISPLAY_HINT boolean
set_parameter_property PERIOD_CLOCK_FREQUENCY AFFECTS_GENERATION false
set_parameter_property PERIOD_CLOCK_FREQUENCY IS_HDL_PARAMETER true
set_parameter_property PERIOD_CLOCK_FREQUENCY ENABLED true

add_parameter OFFSET_JITTER_WANDER_EN INTEGER 0
set_parameter_property OFFSET_JITTER_WANDER_EN DISPLAY_NAME "Enable offset, jitter, and wander supports"
set_parameter_property OFFSET_JITTER_WANDER_EN DESCRIPTION "Refer to User Guide for device family support information"
set_parameter_property OFFSET_JITTER_WANDER_EN UNITS None
set_parameter_property OFFSET_JITTER_WANDER_EN DISPLAY_HINT boolean
set_parameter_property OFFSET_JITTER_WANDER_EN AFFECTS_GENERATION false
set_parameter_property OFFSET_JITTER_WANDER_EN IS_HDL_PARAMETER true
set_parameter_property OFFSET_JITTER_WANDER_EN ENABLED true

add_parameter DEFAULT_NSEC_PERIOD INTEGER 6
set_parameter_property DEFAULT_NSEC_PERIOD DISPLAY_NAME DEFAULT_NSEC_PERIOD
set_parameter_property DEFAULT_NSEC_PERIOD DESCRIPTION "Default nanosecond value of period"
set_parameter_property DEFAULT_NSEC_PERIOD UNITS None
set_parameter_property DEFAULT_NSEC_PERIOD DISPLAY_HINT ""
set_parameter_property DEFAULT_NSEC_PERIOD AFFECTS_GENERATION false
set_parameter_property DEFAULT_NSEC_PERIOD IS_HDL_PARAMETER true
set_parameter_property DEFAULT_NSEC_PERIOD ALLOWED_RANGES {0:15}
set_parameter_property DEFAULT_NSEC_PERIOD ENABLED true

add_parameter DEFAULT_FNSEC_PERIOD INTEGER 0x6666
set_parameter_property DEFAULT_FNSEC_PERIOD DISPLAY_NAME DEFAULT_FNSEC_PERIOD
set_parameter_property DEFAULT_FNSEC_PERIOD DESCRIPTION "Default fractional nanosecond value of period"
set_parameter_property DEFAULT_FNSEC_PERIOD UNITS None
set_parameter_property DEFAULT_FNSEC_PERIOD DISPLAY_HINT "hexadecimal"
set_parameter_property DEFAULT_FNSEC_PERIOD AFFECTS_GENERATION false
set_parameter_property DEFAULT_FNSEC_PERIOD IS_HDL_PARAMETER true
set_parameter_property DEFAULT_FNSEC_PERIOD ALLOWED_RANGES {0:65535}
set_parameter_property DEFAULT_FNSEC_PERIOD ENABLED true

add_parameter DEFAULT_NSEC_ADJPERIOD INTEGER 6
set_parameter_property DEFAULT_NSEC_ADJPERIOD DISPLAY_NAME DEFAULT_NSEC_ADJPERIOD
set_parameter_property DEFAULT_NSEC_ADJPERIOD DESCRIPTION "Default nanosecond value of adjust period"
set_parameter_property DEFAULT_NSEC_ADJPERIOD UNITS None
set_parameter_property DEFAULT_NSEC_ADJPERIOD DISPLAY_HINT ""
set_parameter_property DEFAULT_NSEC_ADJPERIOD AFFECTS_GENERATION false
set_parameter_property DEFAULT_NSEC_ADJPERIOD IS_HDL_PARAMETER true
set_parameter_property DEFAULT_NSEC_ADJPERIOD ALLOWED_RANGES {0:15}
set_parameter_property DEFAULT_NSEC_ADJPERIOD ENABLED true

add_parameter DEFAULT_FNSEC_ADJPERIOD INTEGER 0x6666
set_parameter_property DEFAULT_FNSEC_ADJPERIOD DISPLAY_NAME DEFAULT_FNSEC_ADJPERIOD
set_parameter_property DEFAULT_FNSEC_ADJPERIOD DESCRIPTION "Default fractional nanosecond value of adjust period"
set_parameter_property DEFAULT_FNSEC_ADJPERIOD UNITS None
set_parameter_property DEFAULT_FNSEC_ADJPERIOD DISPLAY_HINT "hexadecimal"
set_parameter_property DEFAULT_FNSEC_ADJPERIOD AFFECTS_GENERATION false
set_parameter_property DEFAULT_FNSEC_ADJPERIOD IS_HDL_PARAMETER true
set_parameter_property DEFAULT_FNSEC_ADJPERIOD ALLOWED_RANGES {0:65535}
set_parameter_property DEFAULT_FNSEC_ADJPERIOD ENABLED true
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point csr_clock
# | 
add_interface csr_clock clock end

set_interface_property csr_clock ENABLED true

add_interface_port csr_clock clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point csr_reset
# | 
add_interface csr_reset reset end
set_interface_property csr_reset associatedClock csr_clock

set_interface_property csr_reset ENABLED true

add_interface_port csr_reset rst_n reset_n Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point period_clock
# | 
add_interface period_clock clock end

set_interface_property period_clock ENABLED true

add_interface_port period_clock period_clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point period_clock_reset
# | 
add_interface period_clock_reset reset end
set_interface_property period_clock_reset associatedClock period_clock

set_interface_property period_clock_reset ENABLED true

add_interface_port period_clock_reset period_rst_n reset_n Input 1
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
set_interface_property csr readLatency 1
set_interface_property csr readWaitTime 0
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0

set_interface_property csr associatedClock csr_clock
set_interface_property csr associatedReset csr_reset
set_interface_property csr ENABLED true

add_interface_port csr csr_readdata readdata Output 32
add_interface_port csr csr_write write Input 1
add_interface_port csr csr_read read Input 1
#add_interface_port csr csr_address address Input 4
add_interface_port csr csr_writedata writedata Input 32
add_interface_port csr csr_waitrequest waitrequest Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point time_of_day_96b
# | 
add_interface time_of_day_96b conduit start
set_interface_assignment time_of_day_96b "ui.blockdiagram.direction" Output
set_interface_property time_of_day_96b ENABLED true

add_interface_port time_of_day_96b time_of_day_96b data Output 96
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point time_of_day_64b
# | 
add_interface time_of_day_64b conduit start
set_interface_assignment time_of_day_64b "ui.blockdiagram.direction" Output
set_interface_property time_of_day_64b ENABLED true

add_interface_port time_of_day_64b time_of_day_64b data Output 64
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point time_of_day_96b_load
# | 
add_interface time_of_day_96b_load conduit start
set_interface_assignment time_of_day_96b_load "ui.blockdiagram.direction" Input
set_interface_property time_of_day_96b_load ENABLED true

add_interface_port time_of_day_96b_load time_of_day_96b_load_data data Input 96
add_interface_port time_of_day_96b_load time_of_day_96b_load_valid valid Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point time_of_day_64b_load
# | 
add_interface time_of_day_64b_load conduit start
set_interface_assignment time_of_day_64b_load "ui.blockdiagram.direction" Input
set_interface_property time_of_day_64b_load ENABLED true

add_interface_port time_of_day_64b_load time_of_day_64b_load_data data Input 64
add_interface_port time_of_day_64b_load time_of_day_64b_load_valid valid Input 1
# | 
# +-----------------------------------

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/nfa1453869442912/nfa1453869574445
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
