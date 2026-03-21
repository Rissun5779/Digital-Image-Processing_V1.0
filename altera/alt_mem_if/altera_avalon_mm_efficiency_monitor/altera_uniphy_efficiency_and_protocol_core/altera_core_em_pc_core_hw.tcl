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


set alt_mem_if_tcl_libs_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/alt_mem_if/alt_mem_if_tcl_packages"
if {[lsearch -exact $auto_path $alt_mem_if_tcl_libs_dir] == -1} {
	lappend auto_path $alt_mem_if_tcl_libs_dir
}


package require -exact qsys 14.0

package require alt_mem_if::util::messaging
package require alt_mem_if::util::profiling
package require alt_mem_if::util::hwtcl_utils

namespace import ::alt_mem_if::util::messaging::*


set_module_property DESCRIPTION "Altera Avalon-MM Efficiency Monitor and Protocol Checker Core"
set_module_property NAME altera_avalon_em_pc_core
set_module_property VERSION 18.1
::alt_mem_if::util::hwtcl_utils::set_module_internal_mode
set_module_property GROUP [::alt_mem_if::util::hwtcl_utils::memory_perf_monitor_components_group_name]
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Altera Avalon-MM Efficiency Monitor and Protcol Checker Core"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true

add_fileset sim_vhdl SIM_VHDL generate_vhdl_sim
set_fileset_property sim_vhdl TOP_LEVEL em_top_ms
add_fileset sim_verilog SIM_VERILOG generate_verilog_sim
set_fileset_property sim_verilog TOP_LEVEL em_top_ms
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
set_fileset_property quartus_synth TOP_LEVEL em_top_ms


proc generate_verilog_fileset {} {
	set file_list [list \
		em_top_ms.v \
		em_single_top.v \
		em_count_fsm.v \
		em_protocol_fsm.v \
		em_rdlat_fsm.v \
		em_reset_sync.v \
	]

	return $file_list
}


proc generate_vhdl_sim {name} {
	_dprint 1 "Preparing to generate VHDL simulation fileset for $name"

	set non_encryp_simulators [::alt_mem_if::util::hwtcl_utils::get_simulator_attributes 1]

	foreach file_name [generate_verilog_fileset] {
		_dprint 1 "Preparing to add $file_name"

		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name] PATH $file_name $non_encryp_simulators

		add_fileset_file [file join mentor $file_name] [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name 1 1] PATH [file join mentor $file_name] {MENTOR_SPECIFIC}
	}
}

proc generate_verilog_sim {name} {
	_dprint 1 "Preparing to generate verilog simulation fileset for $name"

	foreach file_name [generate_verilog_fileset] {
		_dprint 1 "Preparing to add $file_name"
		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name] PATH $file_name
	}
}

proc generate_synth {name} {
	_dprint 1 "Preparing to generate verilog synthesis fileset for $name"

	foreach file_name [generate_verilog_fileset] {
		_dprint 1 "Preparing to add $file_name"
		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name 0] PATH $file_name
	}
}

add_parameter EMPC_AV_BURSTCOUNT_WIDTH INTEGER 3
set_parameter_property EMPC_AV_BURSTCOUNT_WIDTH DEFAULT_VALUE 3
set_parameter_property EMPC_AV_BURSTCOUNT_WIDTH DISPLAY_NAME "AV_BURSTCOUNT_WIDTH"
set_parameter_property EMPC_AV_BURSTCOUNT_WIDTH TYPE INTEGER
set_parameter_property EMPC_AV_BURSTCOUNT_WIDTH UNITS None
set_parameter_property EMPC_AV_BURSTCOUNT_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_AV_BURSTCOUNT_WIDTH HDL_PARAMETER true
set_parameter_property EMPC_AV_BURSTCOUNT_WIDTH DESCRIPTION "Specifies width of Avalon burst count signal."

add_parameter EMPC_AV_DATA_WIDTH INTEGER 64
set_parameter_property EMPC_AV_DATA_WIDTH DEFAULT_VALUE 64
set_parameter_property EMPC_AV_DATA_WIDTH DISPLAY_NAME "AV_DATA_WIDTH"
set_parameter_property EMPC_AV_DATA_WIDTH TYPE INTEGER
set_parameter_property EMPC_AV_DATA_WIDTH UNITS None
set_parameter_property EMPC_AV_DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_AV_DATA_WIDTH HDL_PARAMETER true
set_parameter_property EMPC_AV_DATA_WIDTH DESCRIPTION "Specifies width of Avalon data signal."

add_parameter EMPC_AV_POW2_DATA_WIDTH INTEGER 64
set_parameter_property EMPC_AV_POW2_DATA_WIDTH DEFAULT_VALUE 64
set_parameter_property EMPC_AV_POW2_DATA_WIDTH DISPLAY_NAME "AV_POW2_DATA_WIDTH"
set_parameter_property EMPC_AV_POW2_DATA_WIDTH TYPE INTEGER
set_parameter_property EMPC_AV_POW2_DATA_WIDTH UNITS None
set_parameter_property EMPC_AV_POW2_DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_AV_POW2_DATA_WIDTH HDL_PARAMETER true
set_parameter_property EMPC_AV_POW2_DATA_WIDTH DESCRIPTION "Specifies width of Avalon data signal."

add_parameter EMPC_AV_SYMBOL_WIDTH INTEGER 8
set_parameter_property EMPC_AV_SYMBOL_WIDTH DEFAULT_VALUE 8
set_parameter_property EMPC_AV_SYMBOL_WIDTH DISPLAY_NAME "AV_SYMBOL_WIDTH"
set_parameter_property EMPC_AV_SYMBOL_WIDTH TYPE INTEGER
set_parameter_property EMPC_AV_SYMBOL_WIDTH UNITS None
set_parameter_property EMPC_AV_SYMBOL_WIDTH ALLOWED_RANGES 1:2147483647
set_parameter_property EMPC_AV_SYMBOL_WIDTH DESCRIPTION "Specifies width of Avalon symbol."

add_parameter EMPC_AVM_ADDRESS_WIDTH INTEGER 23
set_parameter_property EMPC_AVM_ADDRESS_WIDTH DEFAULT_VALUE 23
set_parameter_property EMPC_AVM_ADDRESS_WIDTH DISPLAY_NAME "AVM_ADDRESS_WIDTH"
set_parameter_property EMPC_AVM_ADDRESS_WIDTH TYPE INTEGER
set_parameter_property EMPC_AVM_ADDRESS_WIDTH UNITS None
set_parameter_property EMPC_AVM_ADDRESS_WIDTH ALLOWED_RANGES 1:2147483647
set_parameter_property EMPC_AVM_ADDRESS_WIDTH DESCRIPTION ""
set_parameter_property EMPC_AVM_ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_AVM_ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property EMPC_AVM_ADDRESS_WIDTH DESCRIPTION "Specifies width of Avalon address signal of the interface to the master."

add_parameter EMPC_AVS_ADDRESS_WIDTH INTEGER 23
set_parameter_property EMPC_AVS_ADDRESS_WIDTH DEFAULT_VALUE 23
set_parameter_property EMPC_AVS_ADDRESS_WIDTH DISPLAY_NAME "AVS_ADDRESS_WIDTH"
set_parameter_property EMPC_AVS_ADDRESS_WIDTH TYPE INTEGER
set_parameter_property EMPC_AVS_ADDRESS_WIDTH UNITS None
set_parameter_property EMPC_AVS_ADDRESS_WIDTH ALLOWED_RANGES 1:2147483647
set_parameter_property EMPC_AVS_ADDRESS_WIDTH DESCRIPTION ""
set_parameter_property EMPC_AVS_ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_AVS_ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property EMPC_AVS_ADDRESS_WIDTH DESCRIPTION "Specifies width of Avalon address signal of the interface to the slave."

add_parameter EMPC_AV_BE_WIDTH INTEGER 8
set_parameter_property EMPC_AV_BE_WIDTH DEFAULT_VALUE 8
set_parameter_property EMPC_AV_BE_WIDTH DISPLAY_NAME "AV_BE_WIDTH"
set_parameter_property EMPC_AV_BE_WIDTH TYPE INTEGER
set_parameter_property EMPC_AV_BE_WIDTH UNITS None
set_parameter_property EMPC_AV_BE_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_AV_BE_WIDTH HDL_PARAMETER true
set_parameter_property EMPC_AV_BE_WIDTH DESCRIPTION "Specifies width of Avalon byte enable signal."

add_parameter EMPC_AV_POW2_BE_WIDTH INTEGER 8
set_parameter_property EMPC_AV_POW2_BE_WIDTH DEFAULT_VALUE 8
set_parameter_property EMPC_AV_POW2_BE_WIDTH DISPLAY_NAME "AV_POW2_BE_WIDTH"
set_parameter_property EMPC_AV_POW2_BE_WIDTH TYPE INTEGER
set_parameter_property EMPC_AV_POW2_BE_WIDTH UNITS None
set_parameter_property EMPC_AV_POW2_BE_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_AV_POW2_BE_WIDTH HDL_PARAMETER true
set_parameter_property EMPC_AV_POW2_BE_WIDTH DESCRIPTION "Specifies width of Avalon byte enable signal."

add_parameter EMPC_COUNT_WIDTH INTEGER 32
set_parameter_property EMPC_COUNT_WIDTH DEFAULT_VALUE 32
set_parameter_property EMPC_COUNT_WIDTH DISPLAY_NAME "COUNT_WIDTH"
set_parameter_property EMPC_COUNT_WIDTH TYPE INTEGER
set_parameter_property EMPC_COUNT_WIDTH UNITS None
set_parameter_property EMPC_COUNT_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_COUNT_WIDTH VISIBLE false
set_parameter_property EMPC_COUNT_WIDTH HDL_PARAMETER true
set_parameter_property EMPC_COUNT_WIDTH DESCRIPTION "Specifies width of counters measuring the statistics."

add_parameter EMPC_CSR_ADDR_WIDTH INTEGER 12
set_parameter_property EMPC_CSR_ADDR_WIDTH DEFAULT_VALUE 12
set_parameter_property EMPC_CSR_ADDR_WIDTH DISPLAY_NAME "CSR Address Width"
set_parameter_property EMPC_CSR_ADDR_WIDTH DESCRIPTION "CSR Address Width"
set_parameter_property EMPC_CSR_ADDR_WIDTH TYPE INTEGER
set_parameter_property EMPC_CSR_ADDR_WIDTH VISIBLE false
set_parameter_property EMPC_CSR_ADDR_WIDTH ENABLED false
set_parameter_property EMPC_CSR_ADDR_WIDTH UNITS None
set_parameter_property EMPC_CSR_ADDR_WIDTH ALLOWED_RANGES 1:32
set_parameter_property EMPC_CSR_ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_CSR_ADDR_WIDTH HDL_PARAMETER true

add_parameter EMPC_CSR_DATA_WIDTH INTEGER 32
set_parameter_property EMPC_CSR_DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property EMPC_CSR_DATA_WIDTH DISPLAY_NAME "CSR Data Width"
set_parameter_property EMPC_CSR_DATA_WIDTH DESCRIPTION "CSR Data Width"
set_parameter_property EMPC_CSR_DATA_WIDTH TYPE INTEGER
set_parameter_property EMPC_CSR_DATA_WIDTH VISIBLE false
set_parameter_property EMPC_CSR_DATA_WIDTH ENABLED false
set_parameter_property EMPC_CSR_DATA_WIDTH UNITS None
set_parameter_property EMPC_CSR_DATA_WIDTH ALLOWED_RANGES 32
set_parameter_property EMPC_CSR_DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property EMPC_CSR_DATA_WIDTH HDL_PARAMETER true

add_parameter EMPC_MAX_READ_TRANSACTIONS INTEGER 16
set_parameter_property EMPC_MAX_READ_TRANSACTIONS DESCRIPTION "Avalon-MM Max Pending Read Transactions"
set_parameter_property EMPC_MAX_READ_TRANSACTIONS DISPLAY_NAME "AV Max Pending Read Transactions"
set_parameter_property EMPC_MAX_READ_TRANSACTIONS DEFAULT_VALUE 16
set_parameter_property EMPC_MAX_READ_TRANSACTIONS TYPE INTEGER
set_parameter_property EMPC_MAX_READ_TRANSACTIONS UNITS None
set_parameter_property EMPC_MAX_READ_TRANSACTIONS AFFECTS_ELABORATION true

add_parameter EMPC_VERSION INTEGER 110
set_parameter_property EMPC_VERSION VISIBLE false
set_parameter_property EMPC_VERSION DERIVED true
set_parameter_property EMPC_VERSION HDL_PARAMETER true

add_parameter EMPC_LEGACY_VERSION BOOLEAN true
set_parameter_property EMPC_LEGACY_VERSION HDL_PARAMETER true

add_parameter SHORT_QSYS_INTERFACE_NAMES BOOLEAN false
set_parameter_property SHORT_QSYS_INTERFACE_NAMES DEFAULT_VALUE false
set_parameter_property SHORT_QSYS_INTERFACE_NAMES VISIBLE false


add_parameter EMPC_NUM_AVL_IFS INTEGER 1





if {[string compare -nocase [::alt_mem_if::util::hwtcl_utils::combined_callbacks] "false"] == 0} {
	set_module_property Validation_Callback ip_validate
	set_module_property elaboration_Callback ip_elaborate
} else {
	set_module_property elaboration_Callback combined_callback
}

proc combined_callback {} {
	ip_validate
	ip_elaborate
}

proc ip_validate {} {
	_dprint 1 "Running IP Validation"

	set effmon_version 18.1
	set effmon_version [expr {int($effmon_version * 10.0)}]
	set_parameter_value EMPC_VERSION $effmon_version

}

proc ip_elaborate {} {

   set legacy [expr {[string compare -nocase [get_parameter_value EMPC_LEGACY_VERSION] "true"] == 0}]
   set short_name [expr {[string compare -nocase [get_parameter_value SHORT_QSYS_INTERFACE_NAMES] "true"] == 0}]

   set num_avl_ifs [get_parameter_value EMPC_NUM_AVL_IFS]
   if {$legacy} {
      set input_clk_0 "avalon_clk"
   } else {
      set input_clk_0 [expr {$short_name ? "emif_usr_clk_in" : "emif_usr_clk_in_clock_sink"}]
      if {$num_avl_ifs == 2} {
         set input_clk_1 [expr {$short_name ? "emif_usr_clk_sec_in" : "emif_usr_clk_sec_in_clock_sink"}]
         add_interface $input_clk_1 clock end
         set_interface_property $input_clk_1 ENABLED true
         add_interface_port $input_clk_1 avm_clk_sec clk Input 1
      }
   }
   add_interface $input_clk_0 clock end
   set_interface_property $input_clk_0 ENABLED true
   add_interface_port $input_clk_0 avm_clk clk Input 1

   if {$legacy} {
      set input_reset_0 "reset_sink"
   } else {
      set input_reset_0 [expr {$short_name ? "emif_usr_reset_n_in" : "emif_usr_reset_in_reset_sink"}]
      if {$num_avl_ifs == 2} {
         set input_reset_1 [expr {$short_name ? "emif_usr_reset_n_sec_in" : "emif_usr_reset_sec_in_reset_sink"}]
         add_interface $input_reset_1 reset end
         set_interface_property $input_reset_1 synchronousEdges none
         set_interface_property $input_reset_1 ENABLED true
         add_interface_port $input_reset_1 ctl_reset_n_sec reset_n Input 1
      }
   }

   add_interface $input_reset_0 reset end
   set_interface_property $input_reset_0 synchronousEdges none
   set_interface_property $input_reset_0 ENABLED true
   add_interface_port $input_reset_0 ctl_reset_n reset_n Input 1

   if {!$legacy} {
      set if_emif_usr_clk_src   [expr {$short_name ? "emif_usr_clk"   : "emif_usr_clk_clock_source"}]
      set if_emif_usr_reset_src [expr {$short_name ? "emif_usr_reset_n" : "emif_usr_reset_reset_source"}]

      add_interface $if_emif_usr_clk_src clock start
      set_interface_property $if_emif_usr_clk_src ENABLED true
      add_interface_port $if_emif_usr_clk_src avm_clk_out clk Output 1

      add_interface $if_emif_usr_reset_src reset start
      set_interface_property $if_emif_usr_reset_src synchronousEdges none
      set_interface_property $if_emif_usr_reset_src associatedResetSinks $input_reset_0
      set_interface_property $if_emif_usr_reset_src ENABLED true
      add_interface_port $if_emif_usr_reset_src ctl_reset_n_out reset_n Output 1
      if {$num_avl_ifs == 2} {
         set if_emif_usr_sec_clk_src   [expr {$short_name ? "emif_usr_clk_sec"   : "emif_usr_clk_sec_clock_source"}]
         set if_emif_usr_sec_reset_src [expr {$short_name ? "emif_usr_reset_n_sec" : "emif_usr_reset_sec_reset_source"}]
         add_interface $if_emif_usr_sec_clk_src clock start
         set_interface_property $if_emif_usr_sec_clk_src ENABLED true
         add_interface_port $if_emif_usr_sec_clk_src avm_clk_out_sec clk Output 1

         add_interface $if_emif_usr_sec_reset_src reset start
         set_interface_property $if_emif_usr_sec_reset_src synchronousEdges none
         set_interface_property $if_emif_usr_sec_reset_src associatedResetSinks $input_reset_0
         set_interface_property $if_emif_usr_sec_reset_src ENABLED true
         add_interface_port $if_emif_usr_sec_reset_src ctl_reset_n_out_sec reset_n Output 1
      }
   }

   if {$legacy} {
      set num_avl_if 1
   } else {
      set num_avl_if 2
   }

     for {set i 0} {$i < $num_avl_if} {incr i} {
        if {$legacy} {
           set avalon_slave "avalon_slave_$i"
        } else {
           set avalon_slave [expr {$short_name ? "ctrl_amm_$i" : "ctrl_amm_avalon_slave_$i"}]
        }
        add_interface $avalon_slave avalon end
        set_interface_property $avalon_slave addressAlignment DYNAMIC
        set_interface_property $avalon_slave burstOnBurstBoundariesOnly false
        set_interface_property $avalon_slave constantBurstBehavior false
        set_interface_property $avalon_slave holdTime 0
        set_interface_property $avalon_slave isMemoryDevice 1
        set_interface_property $avalon_slave isNonVolatileStorage false
        set_interface_property $avalon_slave linewrapBursts false
        set_interface_property $avalon_slave maximumPendingReadTransactions [get_parameter_value EMPC_MAX_READ_TRANSACTIONS]
        set_interface_property $avalon_slave printableDevice false
        set_interface_property $avalon_slave readLatency 0
        set_interface_property $avalon_slave readWaitTime 1
        set_interface_property $avalon_slave setupTime 0
        set_interface_property $avalon_slave timingUnits Cycles
        set_interface_property $avalon_slave writeWaitTime 0
        set_interface_property $avalon_slave bitsPerSymbol [get_parameter_value EMPC_AV_SYMBOL_WIDTH]

        if {!$legacy} {
           if {$i == 1 && $num_avl_ifs == 2} {
              set_interface_property $avalon_slave associatedClock $if_emif_usr_sec_clk_src
              set_interface_property $avalon_slave associatedReset $if_emif_usr_sec_reset_src
           } else {
              set_interface_property $avalon_slave associatedClock $if_emif_usr_clk_src
              set_interface_property $avalon_slave associatedReset $if_emif_usr_reset_src
           }
        } else {
           set_interface_property $avalon_slave associatedClock $input_clk_0
           set_interface_property $avalon_slave associatedReset $input_reset_0
        }
        set_interface_property $avalon_slave ENABLED [expr {$i < $num_avl_ifs ? "true" : "false"}]

        add_interface_port $avalon_slave "avm_address_$i" address Input [get_parameter_value EMPC_AVM_ADDRESS_WIDTH]
        add_interface_port $avalon_slave "avm_be_$i" byteenable Input [get_parameter_value EMPC_AV_POW2_BE_WIDTH]
        add_interface_port $avalon_slave "avm_burstcount_$i" burstcount Input [get_parameter_value EMPC_AV_BURSTCOUNT_WIDTH]
        if {$legacy} {
           add_interface_port $avalon_slave "avm_beginbursttransfer_$i" beginbursttransfer Input 1
        }
        add_interface_port $avalon_slave "avm_waitrequest_$i" waitrequest Output 1
        add_interface_port $avalon_slave "avm_write_$i" write Input 1
        add_interface_port $avalon_slave "avm_read_$i" read Input 1
        add_interface_port $avalon_slave "avm_readvalid_$i" readdatavalid Output 1
        add_interface_port $avalon_slave "avm_wdata_$i" writedata Input [get_parameter_value EMPC_AV_POW2_DATA_WIDTH]
        add_interface_port $avalon_slave "avm_rdata_$i" readdata Output [get_parameter_value EMPC_AV_POW2_DATA_WIDTH]

        if {$legacy} {
           set avalon_master "avalon_master_$i"
        } else {
           set avalon_master [expr {$short_name ? "effmon_amm_master_$i" : "effmon_amm_master_avalon_master_$i"}]
        }

        add_interface $avalon_master avalon start
        set_interface_property $avalon_master burstOnBurstBoundariesOnly false
        set_interface_property $avalon_master constantBurstBehavior false
        set_interface_property $avalon_master doStreamReads false
        set_interface_property $avalon_master doStreamWrites false
        set_interface_property $avalon_master linewrapBursts false
        set_interface_property $avalon_master bitsPerSymbol [get_parameter_value EMPC_AV_SYMBOL_WIDTH]

        if {!$legacy && $i == 1 && $num_avl_ifs == 2} {
           set_interface_property $avalon_master associatedClock $input_clk_1
           set_interface_property $avalon_master associatedReset $input_reset_1
        } else {
           set_interface_property $avalon_master associatedClock $input_clk_0
           set_interface_property $avalon_master associatedReset $input_reset_0
        }
        set_interface_property $avalon_master ENABLED [expr {$i < $num_avl_ifs ? "true" : "false"}]

        add_interface_port $avalon_master "avs_address_$i" address Output [get_parameter_value EMPC_AVS_ADDRESS_WIDTH]
        add_interface_port $avalon_master "avs_be_$i" byteenable Output [get_parameter_value EMPC_AV_BE_WIDTH]
        add_interface_port $avalon_master "avs_burstcount_$i" burstcount Output [get_parameter_value EMPC_AV_BURSTCOUNT_WIDTH]
        if {$legacy} {
           add_interface_port $avalon_master "avs_beginbursttransfer_$i" beginbursttransfer Output 1
        }
        add_interface_port $avalon_master "avs_waitrequest_$i" waitrequest Input 1
        add_interface_port $avalon_master "avs_write_$i" write Output 1
        add_interface_port $avalon_master "avs_read_$i" read Output 1
        add_interface_port $avalon_master "avs_readvalid_$i" readdatavalid Input 1
        add_interface_port $avalon_master "avs_wdata_$i" writedata Output [get_parameter_value EMPC_AV_DATA_WIDTH]
        add_interface_port $avalon_master "avs_rdata_$i" readdata Input [get_parameter_value EMPC_AV_DATA_WIDTH]


        if {$legacy} {
           set csr "csr"
        } else {
           set csr [expr {$short_name ? "effmon_csr_$i" : "effmon_csr_avalon_slave_$i"}]
        }

        add_interface $csr avalon end
        set_interface_property $csr addressAlignment DYNAMIC
        if {$legacy} {
           set_interface_property $csr associatedClock $input_clk_0
           set_interface_property $csr associatedReset $input_reset_0
        } else {
           if {$num_avl_ifs == 2 && $i == 1} {
              set_interface_property $csr associatedClock $if_emif_usr_sec_clk_src
              set_interface_property $csr associatedReset $if_emif_usr_sec_reset_src
           } else {
              set_interface_property $csr associatedClock $if_emif_usr_clk_src
              set_interface_property $csr associatedReset $if_emif_usr_reset_src
           }
        }
        set_interface_property $csr burstOnBurstBoundariesOnly false
        set_interface_property $csr explicitAddressSpan 0
        set_interface_property $csr holdTime 0
        set_interface_property $csr isMemoryDevice false
        set_interface_property $csr isNonVolatileStorage false
        set_interface_property $csr linewrapBursts false
        set_interface_property $csr maximumPendingReadTransactions 1
        set_interface_property $csr printableDevice false
        set_interface_property $csr readLatency 0
        set_interface_property $csr readWaitTime 1
        set_interface_property $csr setupTime 0
        set_interface_property $csr timingUnits Cycles
        set_interface_property $csr writeWaitTime 0

        set_interface_property $csr ENABLED [expr {$i < $num_avl_ifs ? "true" : "false"}]

        set_interface_assignment $csr debug.visible true

        add_interface_port $csr "csr_addr_$i" address Input [get_parameter_value EMPC_CSR_ADDR_WIDTH]
        add_interface_port $csr "csr_be_$i" byteenable Input [expr [get_parameter_value EMPC_CSR_DATA_WIDTH]/8]
        add_interface_port $csr "csr_write_req_$i" write Input 1
        add_interface_port $csr "csr_wdata_$i" writedata Input [get_parameter_value EMPC_CSR_DATA_WIDTH]
        add_interface_port $csr "csr_read_req_$i" read Input 1
        add_interface_port $csr "csr_rdata_$i" readdata Output [get_parameter_value EMPC_CSR_DATA_WIDTH]
        add_interface_port $csr "csr_rdata_valid_$i" readdatavalid Output 1
        add_interface_port $csr "csr_waitrequest_$i" waitrequest Output 1
   }

   set status [expr {$short_name ? "effmon_status_in" : "effmon_status_in_conduit_end"}]
   add_interface $status conduit end
   add_interface_port $status "local_cal_success_in" local_cal_success Input 1
   add_interface_port $status "local_cal_fail_in"    local_cal_fail    Input 1

   set status [expr {$short_name ? "status" : "status_conduit_end"}]
   add_interface $status conduit start
   add_interface_port $status "local_cal_success" local_cal_success Output 1
   add_interface_port $status "local_cal_fail"    local_cal_fail    Output 1

   if {$legacy} {
      set_port_property "local_cal_success_in" TERMINATION true
      set_port_property "local_cal_success_in" TERMINATION_VALUE 1
   }

}

