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
# | module altera_eth_1588_tod_synchronizer
# | 
set_module_property DESCRIPTION "Provide synchronization between 2 TOD with different phase or ppm or freq, eg 1G and 10G."
set_module_property NAME altera_eth_1588_tod_synchronizer
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "Interface Protocols/Ethernet/Reference Design Components"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Ethernet IEEE 1588 TOD Synchronizer Intel FPGA IP"
set_module_property TOP_LEVEL_HDL_FILE altera_eth_1588_tod_synchronizer.v
set_module_property TOP_LEVEL_HDL_MODULE altera_eth_1588_tod_synchronizer
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elaborate
# set_module_property SIMULATION_MODEL_IN_VERILOG true
# set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property ANALYZE_HDL false
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug-20019.pdf"
set_module_property SUPPORTED_DEVICE_FAMILIES {
   "Arria 10"
   "Stratix V" 
   "Arria V" 
   "Arria V GZ"
   "Cyclone V"} 

# Utility routines

# +-----------------------------------
# | files
# | 
add_fileset qsynth QUARTUS_SYNTH qsynth_proc
set_fileset_property qsynth TOP_LEVEL altera_eth_1588_tod_synchronizer

proc qsynth_proc { none } {
    
    add_fileset_file altera_eth_1588_tod_synchronizer.v VERILOG PATH altera_eth_1588_tod_synchronizer.v
    add_fileset_file altera_eth_1588_tod_synchronizer_clock_crosser.v VERILOG PATH altera_eth_1588_tod_synchronizer_clock_crosser.v
    add_fileset_file altera_eth_1588_tod_synchronizer_clock_div.v VERILOG PATH altera_eth_1588_tod_synchronizer_clock_div.v
    add_fileset_file altera_eth_1588_tod_synchronizer_fifo.v VERILOG PATH altera_eth_1588_tod_synchronizer_fifo.v
    add_fileset_file altera_eth_1588_tod_synchronizer_gray_cnt.v VERILOG PATH altera_eth_1588_tod_synchronizer_gray_cnt.v
    add_fileset_file altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v VERILOG PATH altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v
    add_fileset_file altera_eth_1588_tod_synchronizer_std_sync.v VERILOG PATH altera_eth_1588_tod_synchronizer_std_sync.v
    add_fileset_file altera_eth_1588_tod_synchronizer.sdc SDC PATH altera_eth_1588_tod_synchronizer.sdc
    
    set path [file join .. .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $path
}

# | 
# +-----------------------------------

# -----------------------------------
# IEEE encryption
# ----------------------------------- 
set HDL_LIB_DIR "../lib"

add_fileset simulation_verilog SIM_VERILOG sim_ver
add_fileset simulation_vhdl SIM_VHDL sim_ver
set_fileset_property simulation_verilog TOP_LEVEL altera_eth_1588_tod_synchronizer
set_fileset_property simulation_vhdl TOP_LEVEL altera_eth_1588_tod_synchronizer

proc sim_ver {name} {
    if {1} {
        add_fileset_file mentor/altera_eth_1588_tod_synchronizer.v VERILOG_ENCRYPT PATH "mentor/altera_eth_1588_tod_synchronizer.v" {MENTOR_SPECIFIC}
        add_fileset_file mentor/altera_eth_1588_tod_synchronizer_clock_crosser.v VERILOG_ENCRYPT PATH "mentor/altera_eth_1588_tod_synchronizer_clock_crosser.v" {MENTOR_SPECIFIC}
        add_fileset_file mentor/altera_eth_1588_tod_synchronizer_clock_div.v VERILOG_ENCRYPT PATH "mentor/altera_eth_1588_tod_synchronizer_clock_div.v" {MENTOR_SPECIFIC}
        add_fileset_file mentor/altera_eth_1588_tod_synchronizer_fifo.v VERILOG_ENCRYPT PATH "mentor/altera_eth_1588_tod_synchronizer_fifo.v" {MENTOR_SPECIFIC}
        add_fileset_file mentor/altera_eth_1588_tod_synchronizer_gray_cnt.v VERILOG_ENCRYPT PATH "mentor/altera_eth_1588_tod_synchronizer_gray_cnt.v" {MENTOR_SPECIFIC}
        add_fileset_file mentor/altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v VERILOG_ENCRYPT PATH "mentor/altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v" {MENTOR_SPECIFIC}
        add_fileset_file mentor/altera_eth_1588_tod_synchronizer_std_sync.v VERILOG_ENCRYPT PATH "mentor/altera_eth_1588_tod_synchronizer_std_sync.v" {MENTOR_SPECIFIC}
    }
    if {1} {
        add_fileset_file aldec/altera_eth_1588_tod_synchronizer.v VERILOG_ENCRYPT PATH "aldec/altera_eth_1588_tod_synchronizer.v" {ALDEC_SPECIFIC}
        add_fileset_file aldec/altera_eth_1588_tod_synchronizer_clock_crosser.v VERILOG_ENCRYPT PATH "aldec/altera_eth_1588_tod_synchronizer_clock_crosser.v" {ALDEC_SPECIFIC}
        add_fileset_file aldec/altera_eth_1588_tod_synchronizer_clock_div.v VERILOG_ENCRYPT PATH "aldec/altera_eth_1588_tod_synchronizer_clock_div.v" {ALDEC_SPECIFIC}
        add_fileset_file aldec/altera_eth_1588_tod_synchronizer_fifo.v VERILOG_ENCRYPT PATH "aldec/altera_eth_1588_tod_synchronizer_fifo.v" {ALDEC_SPECIFIC}
        add_fileset_file aldec/altera_eth_1588_tod_synchronizer_gray_cnt.v VERILOG_ENCRYPT PATH "aldec/altera_eth_1588_tod_synchronizer_gray_cnt.v" {ALDEC_SPECIFIC}
        add_fileset_file aldec/altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v VERILOG_ENCRYPT PATH "aldec/altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v" {ALDEC_SPECIFIC}
        add_fileset_file aldec/altera_eth_1588_tod_synchronizer_std_sync.v VERILOG_ENCRYPT PATH "aldec/altera_eth_1588_tod_synchronizer_std_sync.v" {ALDEC_SPECIFIC}
    }
    if {1} {
        add_fileset_file cadence/altera_eth_1588_tod_synchronizer.v VERILOG_ENCRYPT PATH "cadence/altera_eth_1588_tod_synchronizer.v" {CADENCE_SPECIFIC}
        add_fileset_file cadence/altera_eth_1588_tod_synchronizer_clock_crosser.v VERILOG_ENCRYPT PATH "cadence/altera_eth_1588_tod_synchronizer_clock_crosser.v" {CADENCE_SPECIFIC}
        add_fileset_file cadence/altera_eth_1588_tod_synchronizer_clock_div.v VERILOG_ENCRYPT PATH "cadence/altera_eth_1588_tod_synchronizer_clock_div.v" {CADENCE_SPECIFIC}
        add_fileset_file cadence/altera_eth_1588_tod_synchronizer_fifo.v VERILOG_ENCRYPT PATH "cadence/altera_eth_1588_tod_synchronizer_fifo.v" {CADENCE_SPECIFIC}
        add_fileset_file cadence/altera_eth_1588_tod_synchronizer_gray_cnt.v VERILOG_ENCRYPT PATH "cadence/altera_eth_1588_tod_synchronizer_gray_cnt.v" {CADENCE_SPECIFIC}
        add_fileset_file cadence/altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v VERILOG_ENCRYPT PATH "cadence/altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v" {CADENCE_SPECIFIC}
        add_fileset_file cadence/altera_eth_1588_tod_synchronizer_std_sync.v VERILOG_ENCRYPT PATH "cadence/altera_eth_1588_tod_synchronizer_std_sync.v" {CADENCE_SPECIFIC}
    }
    if {1} {
        add_fileset_file synopsys/altera_eth_1588_tod_synchronizer.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_1588_tod_synchronizer.v" {SYNOPSYS_SPECIFIC}
        add_fileset_file synopsys/altera_eth_1588_tod_synchronizer_clock_crosser.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_1588_tod_synchronizer_clock_crosser.v" {SYNOPSYS_SPECIFIC}
        add_fileset_file synopsys/altera_eth_1588_tod_synchronizer_clock_div.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_1588_tod_synchronizer_clock_div.v" {SYNOPSYS_SPECIFIC}
        add_fileset_file synopsys/altera_eth_1588_tod_synchronizer_fifo.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_1588_tod_synchronizer_fifo.v" {SYNOPSYS_SPECIFIC}
        add_fileset_file synopsys/altera_eth_1588_tod_synchronizer_gray_cnt.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_1588_tod_synchronizer_gray_cnt.v" {SYNOPSYS_SPECIFIC}
        add_fileset_file synopsys/altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_1588_tod_synchronizer_sdpm_altsyncram.v" {SYNOPSYS_SPECIFIC}
        add_fileset_file synopsys/altera_eth_1588_tod_synchronizer_std_sync.v VERILOG_ENCRYPT PATH "synopsys/altera_eth_1588_tod_synchronizer_std_sync.v" {SYNOPSYS_SPECIFIC}
    }
    set path [file join .. .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $path
}



# | Callbacks
# | 
proc elaborate {} {
  set tod_mode [get_parameter_value TOD_MODE]
  set sync_mode [get_parameter_value SYNC_MODE]
  set sample_size [get_parameter_value SAMPLE_SIZE]
  
  if {$tod_mode == 1} {
	  set_port_property tod_master_data WIDTH 96
	  set_port_property tod_slave_data WIDTH 96
  } else {
	  set_port_property tod_master_data WIDTH 64
	  set_port_property tod_slave_data WIDTH 64  
  }
  
  if {$sync_mode == 2} {
	set_parameter_property PERIOD_NSEC ENABLED true
	set_parameter_property PERIOD_FNSEC ENABLED true
  } else {
	set_parameter_property PERIOD_NSEC ENABLED false
	set_parameter_property PERIOD_FNSEC ENABLED false
  }

}
# | 
# +-----------------------------------



# +-----------------------------------
# | parameters
# | 
add_parameter TOD_MODE INTEGER 1
set_parameter_property TOD_MODE DISPLAY_NAME TOD_MODE
set_parameter_property TOD_MODE UNITS None
set_parameter_property TOD_MODE DISPLAY_HINT ""
set_parameter_property TOD_MODE AFFECTS_GENERATION false
set_parameter_property TOD_MODE IS_HDL_PARAMETER true
set_parameter_property TOD_MODE ALLOWED_RANGES {0 1}
set_parameter_property TOD_MODE ENABLED true

add_parameter SYNC_MODE INTEGER 2
set_parameter_property SYNC_MODE DISPLAY_NAME SYNC_MODE
set_parameter_property SYNC_MODE UNITS None
set_parameter_property SYNC_MODE DISPLAY_HINT ""
set_parameter_property SYNC_MODE AFFECTS_GENERATION false
set_parameter_property SYNC_MODE IS_HDL_PARAMETER true
set_parameter_property SYNC_MODE ALLOWED_RANGES {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
set_parameter_property SYNC_MODE ENABLED true

add_parameter SAMPLE_SIZE INTEGER 64
set_parameter_property SAMPLE_SIZE DISPLAY_NAME SAMPLE_SIZE
set_parameter_property SAMPLE_SIZE UNITS None
set_parameter_property SAMPLE_SIZE DISPLAY_HINT ""
set_parameter_property SAMPLE_SIZE AFFECTS_GENERATION false
set_parameter_property SAMPLE_SIZE IS_HDL_PARAMETER true
set_parameter_property SAMPLE_SIZE ALLOWED_RANGES {64 128 256}
set_parameter_property SAMPLE_SIZE ENABLED true

add_parameter PERIOD_NSEC INTEGER 6
set_parameter_property PERIOD_NSEC DISPLAY_NAME PERIOD_NSEC
set_parameter_property PERIOD_NSEC UNITS None
set_parameter_property PERIOD_NSEC DISPLAY_HINT ""
set_parameter_property PERIOD_NSEC AFFECTS_GENERATION false
set_parameter_property PERIOD_NSEC IS_HDL_PARAMETER true
set_parameter_property PERIOD_NSEC ALLOWED_RANGES 0:15
set_parameter_property PERIOD_NSEC ENABLED true

add_parameter PERIOD_FNSEC INTEGER 0x6666
set_parameter_property PERIOD_FNSEC DISPLAY_NAME PERIOD_FNSEC
set_parameter_property PERIOD_FNSEC UNITS None
set_parameter_property PERIOD_FNSEC DISPLAY_HINT "hexadecimal"
set_parameter_property PERIOD_FNSEC AFFECTS_GENERATION false
set_parameter_property PERIOD_FNSEC IS_HDL_PARAMETER true
set_parameter_property PERIOD_FNSEC ALLOWED_RANGES 0:65535
set_parameter_property PERIOD_FNSEC ENABLED true
# | 
# +-----------------------------------



# +-----------------------------------
# | connection point clk_master
# | 
add_interface clk_master clock end

set_interface_property clk_master ENABLED true

add_interface_port clk_master clk_master clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point reset_master
# | 
add_interface reset_master reset end
set_interface_property reset_master associatedClock clk_master

set_interface_property reset_master ENABLED true

add_interface_port reset_master reset_master reset Input 1
# | 
# +-----------------------------------


# +-----------------------------------
# | connection point clk_slave
# | 
add_interface clk_slave clock end

set_interface_property clk_slave ENABLED true

add_interface_port clk_slave clk_slave clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point reset_slave
# | 
add_interface reset_slave reset end
set_interface_property reset_slave associatedClock clk_slave

set_interface_property reset_slave ENABLED true

add_interface_port reset_slave reset_slave reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk_sampling
# | 
add_interface clk_sampling clock end

set_interface_property clk_sampling ENABLED true

add_interface_port clk_sampling clk_sampling clk Input 1


# +-----------------------------------
# | connection point start_tod_sync
# | 
add_interface start_tod_sync conduit end
set_interface_assignment start_tod_sync "ui.blockdiagram.direction" Input
set_interface_property start_tod_sync ENABLED true

add_interface_port start_tod_sync start_tod_sync data Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point tod_master_data
# | 
add_interface tod_master_data conduit end
set_interface_assignment tod_master_data "ui.blockdiagram.direction" Input
set_interface_property tod_master_data ENABLED true

add_interface_port tod_master_data tod_master_data data Input 96
# | 
# +-----------------------------------


# +-----------------------------------
# | connection point tod_slave_data
# | 
add_interface tod_slave_data conduit start
set_interface_assignment tod_slave_data "ui.blockdiagram.direction" Output
set_interface_property tod_slave_data ENABLED true

add_interface_port tod_slave_data tod_slave_data data Output 96
add_interface_port tod_slave_data tod_slave_valid valid Output 1
# | 
# +-----------------------------------



## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/nfa1453869442912/nfa1453883240278
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
