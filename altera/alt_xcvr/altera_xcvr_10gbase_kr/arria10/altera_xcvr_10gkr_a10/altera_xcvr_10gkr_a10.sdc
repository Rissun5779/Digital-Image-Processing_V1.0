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


set old_mode [set_project_mode -get_mode_value always_show_entity_name] 
set_project_mode -always_show_entity_name on


# Procedure to put a Fitter net constraint, for instance on double-sync, rather than letting the net "loose"
# period value is as below:
# 0: net_delay = Launch clock period * multiplier
# 1: net_delay = Latch clock period * multiplier
# 2: net_delay = Min clock period * multiplier
# 3: net_delay = Max clock period * multipler
# >3: net_delay = delay_val
#
# DO NOT use this for clock crosser or DCFIFO as this is meant to be generic
# **************************************************************

proc net_constraint_proc {from_node to_node period multiplier delay_val} {
    if {$period == 0} {
        set clock_period src_clock_period
    } elseif {$period == 1} {
        set clock_period dst_clock_period
    } elseif {$period == 2} {
        set clock_period min_clock_period
    } elseif {$period == 3} {
        set clock_period max_clock_period
    }

    set reg_check1 [get_registers *$from_node]
    set reg_check2 [get_registers *$to_node]

    if { [llength [query_collection -list -all $reg_check1]] != 0 && [llength [query_collection -list -all $reg_check2]] != 0 } {
        if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
                puts "SDC Info (TQ): relax soft PHY timing check:"
                puts "From: $from_node"
                puts "To: $to_node"
                set_max_delay -from [get_registers $from_node] -to [get_registers $to_node] 100ns
                set_min_delay -from [get_registers $from_node] -to [get_registers $to_node] -100ns
        } else {
            if {$period < 4} {
                set_net_delay -from [get_pins -compatibility_mode $from_node|q] -to [get_registers $to_node] -max -get_value_from_clock_period $clock_period -value_multiplier $multiplier
            } else {
                set_net_delay -from [get_pins -compatibility_mode $from_node|q] -to [get_registers $to_node] -max $delay_val
            }
            
            puts "SDC Info (Fitter): Impose Fitter net constraint on soft PHY:"
            puts "From: $from_node"
            puts "To: $to_node"
            set_max_delay -from [get_registers $from_node] -to [get_registers $to_node] 20ns
            set_min_delay -from [get_registers $from_node] -to [get_registers $to_node] -100ns
        }
    } else {
        puts "Launch or/and latch register is not found ..."
        puts "Launch: [query_collection $reg_check1]"
        puts "Latch: [query_collection $reg_check2]"
    }
    ##
}

# False path between Sequencer and HSSI data
set inst [get_registers -nowarn *seqa10_sm*pcs_mode*]
set inst_num [llength [query_collection -report -all $inst]]
if {$inst_num > 0} {
   set_false_path -from [get_registers *altera_xcvr_10gkr_a10:*|seqa10_sm:SEQ_GEN.SEQUENCER|pcs_mode_rc\[*\]*] -to [get_registers *altera_xcvr_10gkr_a10:*|ultra_chnl:CHANNEL|tx_parallel_ctrl_to_pcs\[*\]*]
   set_false_path -from [get_registers *altera_xcvr_10gkr_a10:*|seqa10_sm:SEQ_GEN.SEQUENCER|pcs_mode_rc\[*\]*] -to [get_registers *altera_xcvr_10gkr_a10:*|ultra_chnl:CHANNEL|tx_parallel_data_to_pcs\[*\]*]
}

net_constraint_proc *ultra_chnl:CHANNEL|rx_10g_control_inter[*]    *ultra_chnl:CHANNEL|csr_kra10top:csr_kra10top_inst|readdata[*] 1 1.5 3ns
net_constraint_proc *ultra_chnl:CHANNEL|rx_parallel_data_native*   *ultra_chnl:CHANNEL|csr_kra10top:csr_kra10top_inst|readdata[*] 1 1.5 3ns
net_constraint_proc *ultra_chnl:CHANNEL|rx_10g_control_inter[*]    *ultra_chnl:CHANNEL|csr_kra10top:csr_kra10top_inst|readdata[*] 1 1.5 3ns

# 1588 false paths
set inst [get_registers -nowarn *async_fifo*dcfifo_componenet*]
set inst_num [llength [query_collection -report -all $inst]]
if {$inst_num > 0} {
  set_false_path -from [get_registers *altera_xcvr_10gkr_a10:*|seqa10_sm:SEQ_GEN.SEQUENCER|pcs_mode_rc\[*\]*] -to [get_registers *altera_xcvr_10gkr_a10:*|ultra_chnl:CHANNEL|tx_10g_data_valid_to_pcs]
}


# False path between HSSI, and GIGE CSR
set inst [get_registers -nowarn *kr_gige_pcs_top*]
set inst_num [llength [query_collection -report -all $inst]]
if {$inst_num > 0} {
   set_false_path -from [get_registers *altera_xcvr_10gkr_a10:*|ultra_chnl:CHANNEL|rx_parallel_data_native\[*\]*] -to [get_registers *altera_xcvr_10gkr_a10:*|ultra_chnl:CHANNEL|csr_krgige:GIGE_ENABLE.csr_krgige_inst|readdata\[*\]*]
}
set_project_mode -always_show_entity_name $old_mode
