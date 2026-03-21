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


#########################################
### request TCL package from ACDS
#########################################
package require -exact qsys 14.1
package require altera_tcl_testlib 1.0
package require -exact altera_terp 1.0

#########################################
### Source required procs
#########################################
source ../top/altera_sl3_common_procs.tcl

##########################
# module altera_sl3_source_mac
##########################
set_module_property NAME altera_sl3_source_mac
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "SerialLite III Streaming Source MAC"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SerialLite"
set_module_property DISPLAY_NAME "SerialLite III Streaming Source MAC"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true



########################
# Declare the callbacks
######################## 
set_module_property ELABORATION_CALLBACK my_elaboration_callback

########################
# Add fileset
########################
add_fileset synth2 QUARTUS_SYNTH synthproc
add_fileset sim_verilog SIM_VERILOG verilogsimproc
add_fileset sim_vhdl SIM_VHDL vhdlsimproc

set_fileset_property synth2 TOP_LEVEL altera_sl3_source_mac
set_fileset_property sim_verilog TOP_LEVEL altera_sl3_source_mac
set_fileset_property sim_vhdl TOP_LEVEL altera_sl3_source_mac


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./../top/altera_sl3_params.tcl
::altera_sl3::gui_params::params_source_mac_hw

##############################################################
##           Elaboration Callback
##############################################################
#------------------------------------------------------------------------
# 2. Ports and Interfaces
#------------------------------------------------------------------------
proc my_elaboration_callback {} {
    #common_add_clock { port_name int_type port_dir width vhdl_type used terminate } 
    common_add_clock    tx_user_clock                   clock   input   1   std     true    0

    #common_add_reset { port_name port_dir associated_clk syncEdge terminate } 
    common_add_reset    tx_user_clock_reset             reset   input   tx_user_clock       "both"    0

    common_add_clock    tx_user_clock_out                   clock   output   1   std     true    0
    common_add_reset    tx_user_clock_reset_out             reset   output   "tx_user_clock_out"       "both"    0
    set_interface_property   tx_user_clock_reset_out   associatedResetSinks  "tx_user_clock_reset"

    common_add_clock    phy_mgmt_clk                    clock   input   1   std     true    0
    common_add_reset    phy_mgmt_clk_reset              reset   input   "phy_mgmt_clk"      "both"    0 

    common_add_optional_conduit  tx_data              tx_data            input  [expr {[get_parameter_value "LANES"]*64}] vector true 0
    common_add_optional_conduit  tx_valid             tx_valid           input  1 vector true 0
    common_add_optional_conduit  tx_ready             tx_ready           output 1 vector true 0
    common_add_optional_conduit  tx_start_of_burst    tx_start_of_burst  input  1 vector true [expr {[param_matches STREAM "BASIC"]}]
    common_add_optional_conduit  tx_end_of_burst      tx_end_of_burst    input  1 vector true [expr {[param_matches STREAM "BASIC"]}]
    common_add_optional_conduit  tx_sync              tx_sync            input  8 vector true [expr {[param_matches STREAM "BASIC"]}]
    common_add_optional_conduit  tx_empty             tx_sync            input  8 vector true [expr {[param_matches STREAM "BASIC"]}]

    common_add_clock    txcore_clock            clock input     1  std     true  0
    common_add_reset    txcore_clock_reset      reset input      "txcore_clock"  "both"    0
    common_add_optional_conduit   tx_data_valid       tx_data_valid          output  [expr {[get_parameter_value "LANES"]}]  vector  true 0
    common_add_optional_conduit   tx_control          tx_control             output  [expr {[get_parameter_value "LANES"]}]  vector  true 0
    common_add_optional_conduit   tx_parallel_data    tx_parallel_data 	     output  [expr {[get_parameter_value "LANES"]*64}]  vector     true 0
    common_add_optional_conduit   tx_fifo_pempty      tx_fifo_pempty 	     input   [expr {[get_parameter_value "LANES"]}]  vector  true 0
    common_add_optional_conduit   tx_fifo_pfull       tx_fifo_pfull 	     input   [expr {[get_parameter_value "LANES"]}]  vector  true 0
    common_add_optional_conduit   tx_sync_done        tx_sync_done           input   1     std     true 0
    common_add_optional_conduit   tx_link_up          tx_link_up             output  1     std     true 0
    common_add_optional_conduit   tx_error            tx_error               output  4     vector  true 0
    common_add_optional_conduit   tx_sl3_interrupt_src  tx_sl3_interrupt_src output  256   vector  true 0

    
}

#------------------------------------------------------------------------
# 3. Fileset
#------------------------------------------------------------------------
proc common_fileset {language gensim simulator} {
	set topdir "./../top"
	set tmpdir "."
	
   if {[string compare -nocase ${simulator} synopsys] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "synopsys"
       set simulator_specific "SYNOPSYS_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} mentor] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "mentor"
       set simulator_specific "MENTOR_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} cadence] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "cadence"
       set simulator_specific "CADENCE_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} aldec] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "aldec"
       set simulator_specific "ALDEC_SPECIFIC"
   } else { 
       #for synthesis
       set filekind "VERILOG"
       set filekind_systemverilog "SYSTEMVERILOG"
       set simulator_path "."
       set simulator_specific ""
   } 

    # Top level - verilog file
 
    add_fileset_file ${simulator_path}/altera_sl3_source_csr.v             $filekind PATH ${tmpdir}/${simulator_path}/altera_sl3_source_csr.v  $simulator_specific 
    add_fileset_file ${simulator_path}/altera_sl3_source_application.v             $filekind PATH ${tmpdir}/${simulator_path}/altera_sl3_source_application.v  $simulator_specific 
    add_fileset_file ${simulator_path}/altera_sl3_source_adaptation.v             $filekind PATH ${tmpdir}/${simulator_path}/altera_sl3_source_adaptation.v  $simulator_specific 
    add_fileset_file ${simulator_path}/altera_sl3_source_adaptation_ecc.v             $filekind PATH ${tmpdir}/${simulator_path}/altera_sl3_source_adaptation_ecc.v  $simulator_specific 
    add_fileset_file ${simulator_path}/altera_sl3_source_mac.v             $filekind PATH ${tmpdir}/${simulator_path}/altera_sl3_source_mac.v $simulator_specific 

    # Add SDC and OCP files for Synthesis
    #-----------------------------------
    # Terp for SDC file
    #-----------------------------------
    #Set up Terp Variables
    set g_direction   [ get_parameter_value DIRECTION ]
    set g_DEVICE_FAMILY   [ get_parameter_value DEVICE_FAMILY ]
	if {[expr {[param_matches gui_user_input "0"]}]} {
       set g_user_clock_freq [ get_parameter_value "gui_user_clock_frequency"] 
	} else {
	   set g_user_clock_freq [ get_parameter_value "gui_actual_user_clock_frequency"]
	}
    set g_cdr_refclk_freq [get_parameter_value "gui_pll_ref_freq"]
    set g_ecc_mode    [get_parameter_value "gui_ecc_enable"]
    set g_acm_mode    [get_parameter_value "gui_clocking_mode"]
    set g_lane_rate   [get_parameter_value "lane_rate_recommended"]
	
    #Do Terp
    set template_file [ file join $topdir "altera_sl3.sdc.terp" ]  
    set template   [ read [ open $template_file r ] ] 
    set params(direction) $g_direction
    set params(device_family) $g_DEVICE_FAMILY
    set params(user_clock_freq) [format %.6f [expr {$g_user_clock_freq}]]
    set params(cdr_refclk_freq) [format %.6f [expr {$g_cdr_refclk_freq}]]
    set params(ecc_mode) $g_ecc_mode
    set params(acm_mode) $g_acm_mode
    set params(rclk) [format %.6f [expr {$g_lane_rate*1000/64}]]
    set result   [ altera_terp $template params ]
  
    if {[string compare -nocase ${simulator} synthesis] == 0} {
       # SDC for direction == TX and direction == RX_TX is genereted under TX instance while SDC for direction == RX is generated under RX instance
       if {[get_tx_interfaces_on]} {
          add_fileset_file altera_sl3.sdc SDC TEXT $result $simulator_specific 
       }
    }
    # OCP file
    if {[string compare -nocase ${simulator} synthesis] == 0} {
      # add_fileset_file altera_jesd204_rx_base.ocp OTHER PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_base.ocp $simulator_specific 
    }
    
     
}

proc add_common_files {} {
    set common_dir "./../lib/common"
    set filekind "VERILOG"

    add_fileset_file aclr_filter.v             $filekind PATH ${common_dir}/aclr_filter.v 
    add_fileset_file dcfifo_s5m20k.v           $filekind PATH ${common_dir}/dcfifo_s5m20k.v 
    add_fileset_file eq_5_ena.v                $filekind PATH ${common_dir}/eq_5_ena.v 
    add_fileset_file neq_5_ena.v               $filekind PATH ${common_dir}/neq_5_ena.v 
    add_fileset_file gray_cntr_5_sl.v          $filekind PATH ${common_dir}/gray_cntr_5_sl.v 
    add_fileset_file gray_to_bin_5.v           $filekind PATH ${common_dir}/gray_to_bin_5.v 
    add_fileset_file s5m20k_ecc_1r1w.v         $filekind PATH ${common_dir}/s5m20k_ecc_1r1w.v 
    add_fileset_file wys_lut.v                 $filekind PATH ${common_dir}/wys_lut.v
    add_fileset_file sync_regs_aclr_m2.v       $filekind PATH ${common_dir}/sync_regs_aclr_m2.v
}

#------------------------------------------------------------------------
# 4. Customer Demo Testbench
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# 5. Add fileset for synthesis and simulators
#------------------------------------------------------------------------
proc synthproc {name} {

    common_fileset "verilog" 0 synthesis
    add_common_files
}

proc verilogsimproc {name} {

    if {1} {
    common_fileset "verilog" 1 mentor
    }
    if {1} {
    common_fileset "verilog" 1 synopsys
    }
    if {1} {
    common_fileset "verilog" 1 cadence
    }
    if {1} {
    common_fileset "verilog" 1 aldec
    }
    add_common_files
}

proc vhdlsimproc {name} {
 
    if {1} {
    common_fileset "vhdl" 1 mentor
    }
    if {1} {
    common_fileset "vhdl" 1 synopsys
    }
    if {1} {
    common_fileset "vhdl" 1 cadence
    }
    if {1} {
    common_fileset "vhdl" 1 aldec
    }
    add_common_files
 
} 

