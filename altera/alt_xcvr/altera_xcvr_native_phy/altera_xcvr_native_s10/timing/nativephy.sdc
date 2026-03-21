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


#__ACDS_USER_COMMENT__####################################################################
#__ACDS_USER_COMMENT__
#__ACDS_USER_COMMENT__ THIS IS AN AUTO-GENERATED FILE!
#__ACDS_USER_COMMENT__ -------------------------------
#__ACDS_USER_COMMENT__ If you modify this files, all your changes will be lost if you
#__ACDS_USER_COMMENT__ regenerate the core!
#__ACDS_USER_COMMENT__
#__ACDS_USER_COMMENT__ FILE DESCRIPTION
#__ACDS_USER_COMMENT__ ----------------
#__ACDS_USER_COMMENT__ This file specifies the timing constraints of NATIVE PHY 

#__ACDS_USER_COMMENT__ ------------------------------------------- #
#__ACDS_USER_COMMENT__ -                                         - #
#__ACDS_USER_COMMENT__ --- Some useful functions and variables --- #
#__ACDS_USER_COMMENT__ -                                         - #
#__ACDS_USER_COMMENT__ ------------------------------------------- #

set script_dir [file dirname [info script]] 
source "$script_dir/nativephy_ip_parameters.tcl"
source "$script_dir/nativephy_helper_functions.tcl"

#__ACDS_USER_COMMENT__--------------------------------------------#
#__ACDS_USER_COMMENT__ -                                        - #
#__ACDS_USER_COMMENT__ --- Determine when SDC is being loaded --- #
#__ACDS_USER_COMMENT__ -                                        - #
#__ACDS_USER_COMMENT__--------------------------------------------#

set syn_flow 0
set sta_flow 0
set fit_flow 0
set pow_flow 0
if { $::TimeQuestInfo(nameofexecutable) == "quartus_map" } {
   set syn_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_sta" } {
   set sta_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_fit" } {
   set fit_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_pow" } {
   set pow_flow 1
}
#__ACDS_USER_COMMENT__ Debug switch. Change to 1 to get more run-time debug information
set debug 0

#__ACDS_USER_COMMENT__ -------------------------------------------------------------------- #
#__ACDS_USER_COMMENT__ -                                                                  - #
#__ACDS_USER_COMMENT__ --- This is the main call to the netlist traversal routines      --- #
#__ACDS_USER_COMMENT__ --- that will automatically find all pins and registers required --- #
#__ACDS_USER_COMMENT__ --- to apply timing constraints.                                 --- #
#__ACDS_USER_COMMENT__ --- During the fitter, the routines will be called only once     --- #
#__ACDS_USER_COMMENT__ --- and cached data will be used in all subsequent calls.        --- #
#__ACDS_USER_COMMENT__ -                                                                  - #
#__ACDS_USER_COMMENT__ -------------------------------------------------------------------- #

if { ! [ info exists nativephy_sdc_cache ] } {
   nativephy_initialize_db memphy_ddr_db var
   set nativephy_sdc_cache 1
} else {
   if { $debug } {
      post_message -type info "SDC: reusing cached NATIVEPHY DB"
   }
}

#__ACDS_USER_COMMENT__ ------------------------------ #
#__ACDS_USER_COMMENT__ -                            - #
#__ACDS_USER_COMMENT__ --- FALSE PATH CONSTRAINTS --- #
#__ACDS_USER_COMMENT__ -                            - #
#__ACDS_USER_COMMENT__ ------------------------------ #

#TODO: Add the condition for bonded and non bonded configurations 
if { [get_collection_size [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pmaif_tx_pld_rst_n]] > 0 } {
  set_max_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pmaif_tx_pld_rst_n] 50ns
  set_min_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_pmaif_tx_pld_rst_n] -50ns
}

if { [get_collection_size [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_8g_g3_tx_pld_rst_n]] > 0 } {
  set_max_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_8g_g3_tx_pld_rst_n] 50ns
  set_min_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_8g_g3_tx_pld_rst_n] -50ns
}

if { [get_collection_size [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_krfec_tx_pld_rst_n]] > 0 } {
  set_max_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_krfec_tx_pld_rst_n] 50ns
  set_min_delay -to [get_pins -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_krfec_tx_pld_rst_n] -50ns
}

# Create a set of all asynchronous signals to be looped over for setting false paths
set altera_xcvr_native_a10_async_signals {
  pld_10g_krfec_rx_pld_rst_n
  pld_10g_krfec_rx_clr_errblk_cnt
  pld_10g_rx_clr_ber_count
  pld_10g_rx_align_clr
  pld_10g_tx_diag_status
  pld_10g_tx_bitslip
  pld_8g_g3_rx_pld_rst_n
  pld_8g_a1a2_size
  pld_8g_bitloc_rev_en
  pld_8g_byte_rev_en
  pld_8g_encdt
  pld_8g_tx_boundary_sel
  pld_8g_rxpolarity
  pld_pma_rxpma_rstb
  pld_pmaif_rx_pld_rst_n
  pld_bitslip
  pld_rx_prbs_err_clr
  pld_rate
  pld_polinv_tx
  pld_polinv_rx
}

if { [ info exists altera_xcvr_native_a10_async_xcvr_pins ] } {
  unset altera_xcvr_native_a10_async_xcvr_pins
}

# Set false paths for each item in the set
foreach altera_xcvr_native_a10_async_signale_name $altera_xcvr_native_a10_async_signals {
  set altera_xcvr_native_a10_async_xcvr_pins [get_pins -nowarn -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|${altera_xcvr_native_a10_async_signale_name}*]
  if { [get_collection_size $altera_xcvr_native_a10_async_xcvr_pins] > 0 } {
    set_false_path -to $altera_xcvr_native_a10_async_xcvr_pins
  }
}


# For TX burst enable, even though its an asynchronous signal, set a bound, since we need the fitter to place it some-what close to the periphery for interlaken
set altera_xcvr_native_a10_async_xcvr_pins [get_pins -nowarn -compatibility_mode *twentynm_xcvr_native_inst\|*inst_twentynm_pcs\|*twentynm_hssi_*_pld_pcs_interface*\|pld_10g_tx_burst_en*]
if { [get_collection_size $altera_xcvr_native_a10_async_xcvr_pins] > 0 } {
  set_max_delay -to $altera_xcvr_native_a10_async_xcvr_pins 20ns
  set_min_delay -to $altera_xcvr_native_a10_async_xcvr_pins -20ns
}

# When using the PRBS Error Accumulation logic, set multicycle constraints to reduce routing error and congestion.  Also false path the asynchronous resets
if { [get_collection_size   [get_registers -nowarn *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_prbs_err_snapshot*]] > 0 } {
  set_multicycle_path -from [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_prbs_err_snapshot*] \
                      -to   [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|avmm_prbs_err_count*] \
                      -hold -end 2             
  set_multicycle_path -from [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_prbs_err_snapshot*] \
                      -to   [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|avmm_prbs_err_count*] \
                      -setup -end 3

  set_false_path      -through [get_pins -compatibility_mode  *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_clk_reset_sync*sync_r*clrn] \
                      -to      [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_clk_reset_sync*sync_r[?]]
  set_false_path      -from    [get_registers *xcvr_native*optional_chnl_reconfig_logic*avmm_csr_enabled*embedded_debug_soft_csr*prbs_reg*] \
                      -to      [get_registers *xcvr_native*optional_chnl_reconfig_logic*prbs_accumulators_enable*prbs_soft_accumulators\|rx_clk_prbs_reset_sync*sync_r[?]]
}
