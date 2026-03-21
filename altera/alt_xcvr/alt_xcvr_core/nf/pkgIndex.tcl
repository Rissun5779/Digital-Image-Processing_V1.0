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


package ifneeded nf_xcvr_native::parameters 18.1 \
  "package provide nf_xcvr_native::parameters 18.1 ; \
   package require alt_xcvr::ip_tcl::messages ; \
   namespace eval ::nf_xcvr_native::parameters:: { \
    namespace import ::alt_xcvr::ip_tcl::messages::* ; \
    namespace import ::alt_xcvr::ip_tcl::ip_module::* \
  }
  source \[file join $dir tcl nf_cdr_pll_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_10g_rx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_10g_tx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_8g_rx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_8g_tx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_common_pcs_pma_interface_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_common_pld_pcs_interface_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_common_util.tcl\] ;
  source \[file join $dir tcl nf_hssi_param_mapping_util.tcl\] ;
  source \[file join $dir tcl nf_hssi_fifo_rx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_fifo_tx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_gen3_rx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_gen3_tx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_krfec_rx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_krfec_tx_pcs_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_parameters.tcl\] ;
  source \[file join $dir tcl nf_hssi_pipe_gen1_2_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_pipe_gen3_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_rx_pcs_pma_interface_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_rx_pld_pcs_interface_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_tx_pcs_pma_interface_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_tx_pld_pcs_interface_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_adapt_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_cdr_refclk_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_cgb_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_buf_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_deser_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_dfe_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_odi_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_sd_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_tx_buf_rbc.tcl\] ;
  source \[file join $dir tcl nf_pma_tx_ser_rbc.tcl\] ;
  source \[file join $dir tcl nf_cdr_pll_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_10g_rx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_10g_tx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_8g_rx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_8g_tx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_common_pcs_pma_interface_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_common_pld_pcs_interface_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_fifo_rx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_fifo_tx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_gen3_rx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_gen3_tx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_krfec_rx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_krfec_tx_pcs_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_pipe_gen1_2_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_pipe_gen3_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_rx_pcs_pma_interface_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_rx_pld_pcs_interface_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_tx_pcs_pma_interface_simple.tcl\] ;
  source \[file join $dir tcl nf_hssi_tx_pld_pcs_interface_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_adapt_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_cdr_refclk_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_cgb_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_buf_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_deser_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_dfe_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_odi_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_rx_sd_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_tx_buf_simple.tcl\] ;
  source \[file join $dir tcl nf_pma_tx_ser_simple.tcl\] ;"

  package ifneeded nf_cdr_pll::parameters 18.1 \
  "package provide nf_cdr_pll::parameters 18.1 ; \
   package require alt_xcvr::ip_tcl::messages ; \
   namespace eval ::nf_cdr_pll::parameters:: { \
    namespace import ::alt_xcvr::ip_tcl::messages::* ; \
    namespace import ::alt_xcvr::ip_tcl::ip_module::* \
  }
  source \[file join $dir tcl nf_cdr_pll_parameters.tcl\] ;"

  package ifneeded nf_atx_pll::parameters 18.1 \
  "package provide nf_atx_pll::parameters 18.1 ; \
   package require alt_xcvr::ip_tcl::messages ; \
   namespace eval ::nf_atx_pll::parameters:: { \
    namespace import ::alt_xcvr::ip_tcl::messages::* ; \
    namespace import ::alt_xcvr::ip_tcl::ip_module::* \
  }

  source \[file join $dir tcl nf_atx_pll_parameters.tcl\] ;
  source \[file join $dir tcl nf_hssi_refclk_divider_rbc.tcl\] ;
  source \[file join $dir tcl nf_hssi_pma_lc_refclk_select_mux_rbc.tcl\] ;
  source \[file join $dir tcl nf_atx_pll_rbc.tcl\] ;  
  source \[file join $dir tcl nf_atx_pll_util.tcl\];
  source \[file join $dir tcl nf_atx_pll_param_mapping_util.tcl\]; "

##
  package ifneeded nf_cmu_fpll::parameters 18.1 \
  "package provide nf_cmu_fpll::parameters 18.1 ; \
   package require alt_xcvr::ip_tcl::messages ; \
   namespace eval ::nf_cmu_fpll::parameters:: { \
    namespace import ::alt_xcvr::ip_tcl::messages::* ; \
    namespace import ::alt_xcvr::ip_tcl::ip_module::* \
  }

  source \[file join $dir tcl nf_cmu_fpll_parameters.tcl\] ;
  source \[file join $dir tcl nf_cmu_fpll_refclk_select_mux_rbc.tcl\] ;
  source \[file join $dir tcl nf_cmu_fpll_rbc.tcl\] ;  
  source \[file join $dir tcl nf_cmu_fpll_util.tcl\];
  source \[file join $dir tcl nf_cmu_fpll_param_mapping_util.tcl\]; "

##

  package ifneeded nf_hssi_pma_cgb_master::parameters 18.1 \
  "package provide nf_hssi_pma_cgb_master::parameters 18.1 ; \
   package require alt_xcvr::ip_tcl::messages ; \
   namespace eval ::nf_hssi_pma_cgb_master::parameters:: { \
    namespace import ::alt_xcvr::ip_tcl::messages::* ; \
    namespace import ::alt_xcvr::ip_tcl::ip_module::* \
  }
  
  source \[file join $dir tcl nf_mcgb_parameters.tcl\] ;  
  source \[file join $dir tcl nf_hssi_pma_cgb_master_rbc.tcl\] ;
  source \[file join $dir tcl nf_mcgb_util.tcl\] ;
  source \[file join $dir tcl nf_mcgb_param_mapping_util.tcl\] ;"
