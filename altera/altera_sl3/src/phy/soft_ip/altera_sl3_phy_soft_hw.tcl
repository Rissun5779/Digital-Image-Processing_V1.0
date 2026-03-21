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
source ../../top/altera_sl3_common_procs.tcl

##########################
# module altera_sl3_phy_soft
##########################
set_module_property NAME altera_sl3_phy_soft
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "SerialLite III Streaming Phy Soft"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SerialLite"
set_module_property DISPLAY_NAME "SerialLite III Streaming Phy Soft"
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

set_fileset_property synth2 TOP_LEVEL altera_sl3_phy_soft_ip
set_fileset_property sim_verilog TOP_LEVEL altera_sl3_phy_soft_ip
set_fileset_property sim_vhdl TOP_LEVEL altera_sl3_phy_soft_ip


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ../../top/altera_sl3_params.tcl
::altera_sl3::gui_params::params_interlaken_soft_hw

##############################################################
##           Elaboration Callback
##############################################################
#------------------------------------------------------------------------
# 2. Ports and Interfaces
#------------------------------------------------------------------------
proc my_elaboration_callback {} {
	set d_L [get_parameter_value "LANES"]        
	set d_ADDR_WIDTH [get_parameter_value "ADDR_WIDTH"] 
     
	# To/From Mac
	common_add_clock   phy_mgmt_clk  clock input 1 std true 0
	common_add_reset   phy_mgmt_clk_reset reset input  "phy_mgmt_clk" "both" 0 
    
    add_interface 	           phy_mgmt       avalon 		    end
    set_interface_property     phy_mgmt       associatedClock       phy_mgmt_clk
    set_interface_property     phy_mgmt       associatedReset       phy_mgmt_clk_reset
    set_interface_property     phy_mgmt       ENABLED                1
    add_interface_port         phy_mgmt       phy_mgmt_address 	    address 	    Input 	$d_ADDR_WIDTH
    add_interface_port         phy_mgmt       phy_mgmt_read 	    read 		    Input 	1
    add_interface_port         phy_mgmt       phy_mgmt_readdata	    readdata 	    Output 	32
    add_interface_port         phy_mgmt       phy_mgmt_waitrequest	waitrequest 	Output 	1
    add_interface_port         phy_mgmt       phy_mgmt_write 	    write 		    Input 	1
    add_interface_port         phy_mgmt       phy_mgmt_writedata	writedata 	    Input 	32

	common_add_clock    tx_user_clock           clock input  1  std     true  [expr {![get_tx_interfaces_on]}] 
	common_add_reset    tx_user_clock_reset      reset input  "tx_user_clock"  "both"    [expr {![get_tx_interfaces_on]}] 
	common_add_clock    txcore_clock            clock output  1  std     true  [expr {![get_tx_interfaces_on]}] 
	common_add_clock    txcore_clock_phy_adpt   clock output  1  std     true  [expr {![get_tx_interfaces_on]}] 
	common_add_reset    txcore_clock_reset      reset output  "txcore_clock"  "both"    [expr {![get_tx_interfaces_on]}] 
    set_interface_property      txcore_clock_reset  associatedResetSinks    "phy_mgmt_clk_reset"

    add_interface           tx_err_interrupt    interrupt         sender
	set_interface_property  tx_err_interrupt    ASSOCIATED_CLOCK  phy_mgmt_clk
	set_interface_property  tx_err_interrupt    associatedAddressablePoint  phy_mgmt
    add_interface_port      tx_err_interrupt    tx_err_interrupt    irq  output 1   
    if {![get_tx_interfaces_on]} {
        set_port_property   tx_err_interrupt    TERMINATION   true
    }

	common_add_optional_conduit 	tx_clkout               clk                  input   $d_L  vector     true  [expr {![get_tx_interfaces_on]}] 
	common_add_optional_conduit 	tx_sl3_interrupt_src    tx_sl3_interrupt_src input   256   vector     true  [expr {![get_tx_interfaces_on]}] 
	
    common_add_optional_conduit 	pll_locked              pll_locked           input   1  std     true  [expr {![get_tx_interfaces_on] }] 
	#common_add_optional_conduit 	pll_powerdown           pll_powerdown        output  1  std     true  [expr {![get_tx_interfaces_on] }] 
	common_add_optional_conduit 	tx_sync_done            tx_sync_done         output  1  std     true  [expr {![get_tx_interfaces_on]}] 
    common_add_optional_conduit 	tx_force_fill           tx_force_fill        output  1  std     true  [expr {![get_tx_interfaces_on]}] 
    common_add_optional_conduit 	dll_fifo_wr_en          dll_fifo_wr_en       output  $d_L  vector     true  [expr {![get_tx_interfaces_on]}] 

	common_add_clock    rxcore_clock            clock output  1  std     true  [expr {![get_rx_interfaces_on]}] 
	common_add_clock    rxcore_clock_phy_adpt   clock output  1  std     true  [expr {![get_rx_interfaces_on]}] 
	common_add_reset    rxcore_clock_reset      reset output  "rxcore_clock"  "both"    [expr {![get_rx_interfaces_on]}] 
    set_interface_property      rxcore_clock_reset  associatedResetSinks    "phy_mgmt_clk_reset"

    add_interface           rx_err_interrupt    interrupt         sender
	set_interface_property  rx_err_interrupt    ASSOCIATED_CLOCK  phy_mgmt_clk
	set_interface_property  rx_err_interrupt    associatedAddressablePoint  phy_mgmt
    add_interface_port      rx_err_interrupt    rx_err_interrupt    irq  output 1   
    if {![get_rx_interfaces_on]} {
        set_port_property   rx_err_interrupt    TERMINATION   true
    }

    common_add_optional_conduit     rx_sl3_csr_control      rx_sl3_csr_control      output  16    vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_clkout               clk                     input   $d_L  vector     true [expr {![get_rx_interfaces_on]}] 
	common_add_optional_conduit 	rx_sl3_interrupt_src    rx_sl3_interrupt_src    input   256   vector     true [expr {![get_rx_interfaces_on]}] 
	common_add_optional_conduit 	rx_crc32_err            rx_crc32err             input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_pcs_err              rx_pcs_err_sip          input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_frame_lock           rx_frame_lock_out2      input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]

	# To/From XCVR
 	common_add_optional_conduit 	tx_cal_busy              tx_cal_busy            input   $d_L  vector     true [expr {![get_tx_interfaces_on]}]
    common_add_optional_conduit 	tx_digitalreset_stat     tx_digitalreset_stat   input   $d_L  vector     true [expr {![get_tx_interfaces_on]}]
 	common_add_optional_conduit 	tx_analogreset_stat      tx_analogreset_stat    input   $d_L  vector     true [expr {![get_tx_interfaces_on]}]
 	common_add_optional_conduit 	tx_digitalreset          tx_digitalreset        output  $d_L  vector     true [expr {![get_tx_interfaces_on]}]
 	common_add_optional_conduit 	tx_analogreset           tx_analogreset         output  $d_L  vector     true [expr {![get_tx_interfaces_on]}]
	common_add_optional_conduit 	tx_frame                 tx_frame               input   $d_L  vector     true [expr {![get_tx_interfaces_on]}]
 	common_add_optional_conduit 	tx_phy_fifo_full         tx_fifo_full           input   $d_L  vector     true [expr {![get_tx_interfaces_on]}]
 	common_add_optional_conduit 	tx_phy_fifo_empty        tx_fifo_empty          input   $d_L  vector     true [expr {![get_tx_interfaces_on]}]
 	common_add_optional_conduit 	tx_burst_en              tx_enh_frame_burst_en  output  $d_L  vector     true [expr {![get_tx_interfaces_on]}]
 	common_add_optional_conduit 	tx_dll_lock_in           tx_dll_lock            input   $d_L  vector     true [expr {![get_tx_interfaces_on]}]
	
 	common_add_optional_conduit 	rx_is_lockedtodata       rx_is_lockedtodata     input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_is_lockedtoref        rx_is_lockedtoref      input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_cal_busy              rx_cal_busy            input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	phy_loopback_serial      rx_seriallpbken        output  $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_set_locktodata        rx_set_locktodata      output  $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_set_locktoref         rx_set_locktoref       output  $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_digitalreset          rx_digitalreset        output  $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_analogreset           rx_analogreset         output  $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_digitalreset_stat     rx_digitalreset_stat   input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]
	common_add_optional_conduit 	rx_analogreset_stat      rx_analogreset_stat    input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]
 	common_add_optional_conduit 	rx_phy_fifo_full         rx_fifo_full           input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]
 	common_add_optional_conduit 	rx_phy_fifo_empty        rx_fifo_empty          input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]
 	common_add_optional_conduit 	rx_block_lock            rx_block_lock          input   $d_L  vector     true [expr {![get_rx_interfaces_on]}]

	common_add_optional_conduit 	xcvr_avs_clk        clk    output  1  std     true 0
	common_add_optional_conduit 	xcvr_avs_reset      reset  output  1  std     true 0

    add_interface 	           xcvr_avs       conduit 		 start
    set_interface_property     xcvr_avs       ENABLED        1
    add_interface_port         xcvr_avs       xcvr_avs_address 	    address 	    Output  $d_ADDR_WIDTH
    add_interface_port         xcvr_avs       xcvr_avs_read 	    read 		    Output 	1
    add_interface_port         xcvr_avs       xcvr_avs_readdata	    readdata 	    Input 	32
    add_interface_port         xcvr_avs       xcvr_avs_waitrequest	waitrequest 	Input 	1
    add_interface_port         xcvr_avs       xcvr_avs_write 	    write 		    Output 	1
    add_interface_port         xcvr_avs       xcvr_avs_writedata	writedata 	    Output 	32
    set_port_property          xcvr_avs_address       TERMINATION         0
    set_port_property          xcvr_avs_read          TERMINATION         0 
    set_port_property          xcvr_avs_readdata      TERMINATION         0 
    set_port_property          xcvr_avs_readdata      TERMINATION_VALUE   0
    set_port_property          xcvr_avs_waitrequest   TERMINATION         0 
    set_port_property          xcvr_avs_waitrequest   TERMINATION_VALUE   0
    set_port_property          xcvr_avs_write         TERMINATION         0 
    set_port_property          xcvr_avs_writedata     TERMINATION         0 
        
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

    add_fileset_file ${simulator_path}/altera_sl3_csr.v                 $filekind PATH      ${tmpdir}/${simulator_path}/altera_sl3_csr.v $simulator_specific       
    add_fileset_file ${simulator_path}/altera_sl3_clk_rst.v             $filekind PATH      ${tmpdir}/${simulator_path}/altera_sl3_clk_rst.v $simulator_specific        
    add_fileset_file ${simulator_path}/altera_xcvr_functions.sv         $filekind_systemverilog PATH    ${tmpdir}/../../../../altera_xcvr_generic/altera_xcvr_functions.sv $simulator_specific 
    add_fileset_file ${simulator_path}/altera_xcvr_reset_control_s10.sv     $filekind_systemverilog PATH    ${tmpdir}/../../../../alt_xcvr/altera_xcvr_reset_control_s10/altera_xcvr_reset_control_s10.sv $simulator_specific        
    add_fileset_file ${simulator_path}/alt_xcvr_reset_counter_s10.sv        $filekind_systemverilog PATH    ${tmpdir}/../../../../alt_xcvr/altera_xcvr_reset_control_s10/alt_xcvr_reset_counter_s10.sv $simulator_specific        
    add_fileset_file ${simulator_path}/alt_xcvr_csr_common_h.sv         $filekind_systemverilog PATH    ${tmpdir}/../../../../altera_xcvr_generic/ctrl/alt_xcvr_csr_common_h.sv $simulator_specific        
    add_fileset_file ${simulator_path}/alt_xcvr_csr_common.sv           $filekind_systemverilog PATH    ${tmpdir}/../../../../altera_xcvr_generic/ctrl/alt_xcvr_csr_common.sv $simulator_specific        
    add_fileset_file ${simulator_path}/alt_xcvr_resync.sv               $filekind_systemverilog PATH    ${tmpdir}/../../../../altera_xcvr_generic/ctrl/alt_xcvr_resync.sv $simulator_specific        

    add_fileset_file ${simulator_path}/altera_sl3_dp_sync.v             $filekind PATH      ${tmpdir}/${simulator_path}/altera_sl3_dp_sync.v $simulator_specific        
    add_fileset_file ${simulator_path}/altera_sl3_pulse_extension_sync.v  $filekind PATH    ${tmpdir}/${simulator_path}/altera_sl3_pulse_extension_sync.v $simulator_specific        
    if { [get_tx_interfaces_on] } {
        add_fileset_file ${simulator_path}/altera_sl3_tx_csr.v          $filekind PATH      ${tmpdir}/${simulator_path}/altera_sl3_tx_csr.v $simulator_specific 
        add_fileset_file ${simulator_path}/altera_sl3_tx_regmap.v       $filekind PATH      ${tmpdir}/${simulator_path}/altera_sl3_tx_regmap.v $simulator_specific 
        add_fileset_file ${simulator_path}/altera_sl3_tx_soft_bond.v    $filekind PATH      ${tmpdir}/${simulator_path}/altera_sl3_tx_soft_bond.v $simulator_specific           }
    if { [get_rx_interfaces_on] } {
        add_fileset_file ${simulator_path}/altera_sl3_rx_csr.v          $filekind PATH      ${tmpdir}/${simulator_path}/altera_sl3_rx_csr.v $simulator_specific 
        add_fileset_file ${simulator_path}/altera_sl3_rx_regmap.v       $filekind PATH      ${tmpdir}/${simulator_path}/altera_sl3_rx_regmap.v $simulator_specific 
    }
    add_fileset_file ${simulator_path}/altera_sl3_phy_soft_ip.v         $filekind PATH      ${tmpdir}/${simulator_path}/altera_sl3_phy_soft_ip.v $simulator_specific   
}

proc add_common_files {} {
   set filekind "VERILOG"

   add_fileset_file altera_std_synchronizer_nocut.v $filekind PATH "$::env(QUARTUS_ROOTDIR)/../ip/altera/primitives/altera_std_synchronizer/altera_std_synchronizer_nocut.v"
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

