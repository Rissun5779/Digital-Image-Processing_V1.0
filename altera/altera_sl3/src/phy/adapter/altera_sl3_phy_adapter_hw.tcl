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
source ./../../top/altera_sl3_common_procs.tcl

##########################
# module  altera_sl3_phy_adapter
##########################
set_module_property NAME altera_sl3_phy_adapter
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "SerialLite III Streaming PHY Adapter"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SerialLite"
set_module_property DISPLAY_NAME "SerialLite III Streaming PHY Adapter"
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

set_fileset_property synth2 TOP_LEVEL altera_sl3_phy_adapter
set_fileset_property sim_verilog TOP_LEVEL altera_sl3_phy_adapter
set_fileset_property sim_vhdl TOP_LEVEL altera_sl3_phy_adapter


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./../../top/altera_sl3_params.tcl
::altera_sl3::gui_params::params_phy_adapter_hw

##############################################################
##           Elaboration Callback
##############################################################
#------------------------------------------------------------------------
# 2. Ports and Interfaces
#------------------------------------------------------------------------
proc my_elaboration_callback {} {
    if {[param_matches DIRECTION "Tx" ]} {
         # tx_set_connections_xs <tx_enable>, 
         # if tx_enable = 1 : TX Interfaces & Ports  are exposed for connections
         # if tx_enable = 0 : Exposed TX Interfaces & Ports will be TERMINATED 
         # Likewise, for rx_set_connections
        tx_set_connections_xs_s10 1
        rx_set_connections_xs_s10 0  
    } elseif {[param_matches DIRECTION "Rx" ]} {
        tx_set_connections_xs_s10 0
        rx_set_connections_xs_s10 1
    } elseif {[param_matches DIRECTION "Duplex" ]} {
        tx_set_connections_xs_s10 1
        rx_set_connections_xs_s10 1
    }
}

#--------------------------------------
# Series 10 Device Family Connections
#--------------------------------------

# For series 10 device family only
# Expose Interface & Ports for RX connections OR TERMINATE THEM
# if rx_enable = 1 : RX Interfaces & Ports  are exposed for connections
# if rx_enable = 0 : Exposed RX Interfaces & Ports will be TERMINATED 
proc rx_set_connections_xs_s10 { rx_enable } {
      set d_L [get_parameter_value "LANES"]
      common_add_clock 		        rx_cdr_refclk_in 	    clock               input    1      std      true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_cdr_refclk_out       clk                 output   1      std      true    [expr {$rx_enable == 0}]

      common_add_clock              rxcore_clock            clock               input    1      std      true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_coreclkin_out        clk                 output   $d_L   vector   true    [expr {$rx_enable == 0}]

      common_add_optional_conduit   rx_fifo_pfull_in        rx_fifo_pfull       input    $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_fifo_pfull_out       rx_fifo_pfull       output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit 	rx_fifo_full_in         rx_fifo_full        input    $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_fifo_full_out        rx_fifo_full        output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_fifo_pempty_in       rx_fifo_pempty      input    $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_fifo_pempty_out      rx_fifo_pempty      output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_fifo_align_clr_out   rx_fifo_align_clr   output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_fifo_align_clr_in    rx_fifo_align_clr   input    $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_data_valid_in        rx_data_valid       input    $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_data_valid_out       rx_data_valid       output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_crc32_err_in         rx_enh_crc32err     input    $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_crc32_err_out        rx_crc32err         output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_frame_lock_in        rx_enh_frame_lock   input    $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_frame_lock_out       rx_frame_lock       output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_frame_lock_out2      rx_frame_lock_out2  output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_block_lock_in        rx_enh_blk_lock     input    $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_block_lock_out       rx_block_lock       output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit 	rx_parallel_data_out    rx_parallel_data    output   [expr {$d_L*64}]   vector     true [expr {$rx_enable == 0}]
      common_add_optional_conduit 	rx_parallel_data_in     rx_parallel_data    input    [expr {$d_L*64}]   vector     true [expr {$rx_enable == 0}]
      common_add_optional_conduit 	rx_control_in           rx_control          input    [expr {$d_L*10}]   vector     true [expr {$rx_enable == 0}]
      common_add_optional_conduit 	rx_control_out          rx_control          output   $d_L   vector   true [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_block_frame_lock_out rx_block_frame_lock output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_pcs_err_out1         rx_pcs_err          output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_pcs_err_out2         rx_pcs_err_sip      output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_sync_word_out        rx_sync_word        output   $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_scrm_word_out        rx_scrm_word        output   $d_L   vector   true    1
      common_add_optional_conduit   rx_skip_word_out        rx_skip_word        output   $d_L   vector   true    1
      common_add_optional_conduit   rx_diag_word_out        rx_diag_word        output   $d_L   vector   true    1
      common_add_optional_conduit   rx_fifo_rden_in         rx_fifo_rden        input    $d_L   vector   true    [expr {$rx_enable == 0}]
      common_add_optional_conduit   rx_fifo_rden_out        rx_fifo_rd_en       output   $d_L   vector   true    [expr {$rx_enable == 0}]

}

proc tx_set_connections_xs_s10 { tx_enable } {
      set d_L [get_parameter_value "LANES"]
      if {[param_is_true "TEST_COMPONENTS_EN" ]} {
         add_fragmented_qsys_interface  tx_serial_clk  hssi_serial_clock   clk   input    1  $d_L     vector  true  [expr {$tx_enable == 0}]
      } else {
         common_add_optional_conduit   tx_serial_clk   clk                 input   $d_L   vector   true   [expr {$tx_enable == 0}]
      }

      common_add_optional_conduit   tx_serial_clk_out   clk                 output   $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_clock              txcore_clock        clock               input    1      std      true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_coreclkin_out    clk                 output   $d_L   vector   true   [expr {$tx_enable == 0}]

      common_add_optional_conduit   tx_fifo_pfull_in    tx_fifo_pfull       input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_fifo_pfull_out   tx_fifo_pfull       output   $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_fifo_pempty_in   tx_fifo_pempty      input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_fifo_pempty_out  tx_fifo_pempty      output   $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_fifo_empty_in    tx_fifo_empty       input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_fifo_empty_out   tx_fifo_empty       output   $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_frame_diag_status_out    tx_enh_frame_diag_status      output    [expr {$d_L*2}]   vector   true    [expr {$tx_enable == 0}]
      common_add_optional_conduit 	tx_data_valid_out       tx_fifo_wr_en   output   $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit 	tx_data_valid_in        tx_data_valid   input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit 	tx_parallel_data_in     tx_parallel_data     input   [expr {$d_L*64}]  vector     true  [expr {$tx_enable == 0}] 
      common_add_optional_conduit 	tx_parallel_data_out    tx_parallel_data     output  [expr {$d_L*64}]  vector     true  [expr {$tx_enable == 0}]
      common_add_optional_conduit   unused_tx_parallel_data unused_tx_parallel_data   output   [get_parameter_value "UNUSED_TX_PARALLEL_WIDTH"]   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit   tx_enh_data_valid       tx_enh_data_valid   output   $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit 	tx_control_in           tx_control      input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit 	tx_control_out          tx_control      output   [expr $d_L*3]     vector     true  [expr {$tx_enable == 0}]
      common_add_optional_conduit 	tx_force_fill_in        tx_force_fill   input    1      std      true   [expr {$tx_enable == 0}] 	  
      common_add_optional_conduit 	dll_fifo_wr_en          dll_fifo_wr_en  input    $d_L   vector   true   [expr {$tx_enable == 0}] 
      common_add_optional_conduit 	tx_frame_in             tx_enh_frame    input    $d_L   vector   true   [expr {$tx_enable == 0}]
      common_add_optional_conduit 	tx_frame_out            tx_frame        output   $d_L   vector   true   [expr {$tx_enable == 0}]

}
#------------------------------------------------------------------------
# 3. Fileset
#------------------------------------------------------------------------
proc common_fileset {language gensim simulator} {
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
    add_fileset_file ${simulator_path}/altera_sl3_phy_adapter.v       $filekind PATH ${tmpdir}/${simulator_path}/altera_sl3_phy_adapter.v $simulator_specific     
}

#------------------------------------------------------------------------
# 4. Customer Demo Testbench
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# 5. Add fileset for synthesis and simulators
#------------------------------------------------------------------------
proc synthproc {name} {

    common_fileset "verilog" 0 synthesis
   
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

 
} 

