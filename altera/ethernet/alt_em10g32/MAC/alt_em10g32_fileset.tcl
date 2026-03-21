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



proc sim_ver_mac {name} {

    set simulation_files {
        alt_em10g32.v VERILOG_ENCRYPT
        alt_em10g32unit.v VERILOG_ENCRYPT
        rtl/alt_em10g32_clk_rst.v VERILOG_ENCRYPT
        rtl/alt_em10g32_clock_crosser.v VERILOG_ENCRYPT
        rtl/alt_em10g32_crc32.v VERILOG_ENCRYPT
        rtl/alt_em10g32_crc32_gf_mult32_kc.v VERILOG_ENCRYPT
        rtl/alt_em10g32_creg_map.v VERILOG_ENCRYPT
        rtl/alt_em10g32_creg_top.v VERILOG_ENCRYPT
        rtl/alt_em10g32_frm_decoder.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_rs_gmii_mii_layer.v VERILOG_ENCRYPT
        rtl/alt_em10g32_pipeline_base.v VERILOG_ENCRYPT
        rtl/alt_em10g32_reset_synchronizer.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rr_clock_crosser.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rst_cnt.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_fctl_filter_crcpad_rem.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_fctl_overflow.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_fctl_preamble.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_frm_control.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_pfc_flow_control.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_pfc_pause_conversion.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_pkt_backpressure_control.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_rs_gmii16b.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_rs_gmii16b_top.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_rs_gmii_mii.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_rs_layer.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_rs_xgmii.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_status_aligner.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_top.v VERILOG_ENCRYPT
        rtl/alt_em10g32_stat_mem.v VERILOG_ENCRYPT
        rtl/alt_em10g32_stat_reg.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_data_frm_gen.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_srcaddr_inserter.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_err_aligner.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_flow_control.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_frm_arbiter.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_frm_muxer.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_pause_beat_conversion.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_pause_frm_gen.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_pause_req.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_pfc_frm_gen.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rr_buffer.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_rs_gmii16b.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_rs_gmii16b_top.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_rs_layer.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_rs_xgmii_layer.v VERILOG_ENCRYPT
        rtl/alt_em10g32_sc_fifo.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_top.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_gmii_decoder.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_gmii_decoder_dfa.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_gmii_encoder.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_gmii_encoder_dfa.v VERILOG_ENCRYPT
        rtl/alt_em10g32_rx_gmii_mii_decoder_if.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_gmii_mii_encoder_if.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_mm_adapter/altera_eth_avalon_mm_adapter.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/altera_eth_avalon_st_adapter.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/avalon_st_adapter_avalon_st_rx.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/avalon_st_adapter_avalon_st_tx.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/avalon_st_adapter.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/alt_em10g32_vldpkt_rddly.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/sideband_adapter_rx.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/sideband_adapter_tx.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/sideband_adapter.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/altera_eth_sideband_crosser.v VERILOG_ENCRYPT
        adapters/altera_eth_avalon_st_adapter/altera_eth_sideband_crosser_sync.v VERILOG_ENCRYPT
        adapters/altera_eth_xgmii_width_adaptor/alt_em10g_32_64_xgmii_conversion.v VERILOG_ENCRYPT
        adapters/altera_eth_xgmii_width_adaptor/alt_em10g_32_to_64_xgmii_conversion.v VERILOG_ENCRYPT
        adapters/altera_eth_xgmii_width_adaptor/alt_em10g_64_to_32_xgmii_conversion.v VERILOG_ENCRYPT
        adapters/altera_eth_xgmii_width_adaptor/alt_em10g_dcfifo_32_to_64_xgmii_conversion.v VERILOG_ENCRYPT
        adapters/altera_eth_xgmii_width_adaptor/alt_em10g_dcfifo_64_to_32_xgmii_conversion.v VERILOG_ENCRYPT
        adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_32_to_64_adapter.v VERILOG_ENCRYPT
        adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_64_to_32_adapter.v VERILOG_ENCRYPT
        adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_data_format_adapter.v VERILOG_ENCRYPT
        rtl/alt_em10g32_altsyncram_bundle.v VERILOG_ENCRYPT
        rtl/alt_em10g32_altsyncram.v VERILOG_ENCRYPT
        rtl/alt_em10g32_avalon_dc_fifo_lat_calc.v VERILOG_ENCRYPT
        rtl/alt_em10g32_avalon_dc_fifo_hecc.v VERILOG_ENCRYPT
        rtl/alt_em10g32_avalon_dc_fifo_secc.v VERILOG_ENCRYPT
        rtl/alt_em10g32_avalon_sc_fifo.v VERILOG_ENCRYPT
        rtl/alt_em10g32_avalon_sc_fifo_hecc.v VERILOG_ENCRYPT
        rtl/alt_em10g32_avalon_sc_fifo_secc.v VERILOG_ENCRYPT
        rtl/alt_em10g32_ecc_dec_18_12.v VERILOG_ENCRYPT
        rtl/alt_em10g32_ecc_dec_39_32.v VERILOG_ENCRYPT
        rtl/alt_em10g32_ecc_enc_12_18.v VERILOG_ENCRYPT
        rtl/alt_em10g32_ecc_enc_32_39.v VERILOG_ENCRYPT
        rtl/alt_em10g32_tx_rs_xgmii_layer_ultra.v VERILOG
        rtl/alt_em10g32_rx_rs_xgmii_ultra.v VERILOG
    }
    
    set simulation_files_1588 {
        alt_em10g32_avst_to_gmii_if.v VERILOG_ENCRYPT
        alt_em10g32_gmii_to_avst_if.v VERILOG_ENCRYPT
        alt_em10g32_gmii_tsu.v VERILOG_ENCRYPT
        alt_em10g32_gmii16b_tsu.v VERILOG_ENCRYPT
        alt_em10g32_lpm_mult.v VERILOG_ENCRYPT
        alt_em10g32_rx_ptp_aligner.v VERILOG_ENCRYPT
        alt_em10g32_rx_ptp_detector.v VERILOG_ENCRYPT
        alt_em10g32_rx_ptp_top.v VERILOG_ENCRYPT
        alt_em10g32_tx_gmii_crc_inserter.v VERILOG_ENCRYPT
        alt_em10g32_tx_gmii16b_crc_inserter.v VERILOG_ENCRYPT
        alt_em10g32_tx_gmii_ptp_inserter.v VERILOG_ENCRYPT
        alt_em10g32_tx_gmii16b_ptp_inserter.v VERILOG_ENCRYPT
        alt_em10g32_tx_ptp_processor.v VERILOG_ENCRYPT
        alt_em10g32_tx_ptp_top.v VERILOG_ENCRYPT
        alt_em10g32_tx_xgmii_crc_inserter.v VERILOG_ENCRYPT
        alt_em10g32_tx_xgmii_ptp_inserter.v VERILOG_ENCRYPT
        alt_em10g32_xgmii_tsu.v VERILOG_ENCRYPT
        alt_em10g32_crc328generator.v VERILOG_ENCRYPT
        alt_em10g32_crc32ctl8.v VERILOG_ENCRYPT
        alt_em10g32_crc32galois8.v VERILOG_ENCRYPT
        alt_em10g32_gmii_crc_inserter.v VERILOG_ENCRYPT
        alt_em10g32_gmii16b_crc_inserter.v VERILOG_ENCRYPT
        alt_em10g32_gmii16b_crc32.v VERILOG_ENCRYPT
    }
        
    foreach {file_name filetype} $simulation_files {
        if {1} {
            add_fileset_file mentor/$file_name $filetype PATH mentor/$file_name  {MENTOR_SPECIFIC}
        }
        if {1} {
            add_fileset_file aldec/$file_name $filetype PATH aldec/$file_name  {ALDEC_SPECIFIC}
        }
        if {1} {
            add_fileset_file synopsys/$file_name $filetype PATH synopsys/$file_name  {SYNOPSYS_SPECIFIC}
        }
        if {1} {
            add_fileset_file cadence/$file_name $filetype PATH cadence/$file_name  {CADENCE_SPECIFIC}
        }
    }

    foreach {file_name filetype} $simulation_files_1588 {
        if {1} {
            add_fileset_file mentor/rtl/$file_name $filetype PATH ../1588/mentor/$file_name  {MENTOR_SPECIFIC}
        }
        if {1} {
            add_fileset_file aldec/rtl/$file_name $filetype PATH ../1588/aldec/$file_name  {ALDEC_SPECIFIC}
        }
        if {1} {
            add_fileset_file synopsys/rtl/$file_name $filetype PATH ../1588/synopsys/$file_name  {SYNOPSYS_SPECIFIC}
        }
        if {1} {
            add_fileset_file cadence/rtl/$file_name $filetype PATH ../1588/cadence/$file_name  {CADENCE_SPECIFIC}
        }
    }

    add_fileset_file alt_em10g32_avalon_dc_fifo.v VERILOG PATH "rtl/alt_em10g32_avalon_dc_fifo.v"
    add_fileset_file alt_em10g32_dcfifo_synchronizer_bundle.v VERILOG PATH "rtl/alt_em10g32_dcfifo_synchronizer_bundle.v"
    add_fileset_file alt_em10g32_std_synchronizer.v VERILOG PATH "rtl/alt_em10g32_std_synchronizer.v"
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH "$::env(QUARTUS_ROOTDIR)/../ip/altera/primitives/altera_std_synchronizer/altera_std_synchronizer_nocut.v"
    
}


proc compilation_list_mac {name} {

    add_fileset_file altera_reset_controller.sdc SDC PATH "$::env(QUARTUS_ROOTDIR)/../ip/altera/merlin/altera_reset_controller/altera_reset_controller.sdc" 
    add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH "$::env(QUARTUS_ROOTDIR)/../ip/altera/primitives/altera_std_synchronizer/altera_std_synchronizer_nocut.v"

    add_fileset_file alt_em10g32unit.v VERILOG PATH "alt_em10g32unit.v"
    add_fileset_file alt_em10g32.ocp OTHER PATH "alt_em10g32.ocp"
    add_fileset_file alt_em10g32_clock_crosser_timing_info.tcl OTHER PATH "alt_em10g32_clock_crosser_timing_info.tcl"
    add_fileset_file rtl/alt_em10g32_clk_rst.v VERILOG PATH "rtl/alt_em10g32_clk_rst.v"
    add_fileset_file rtl/alt_em10g32_clock_crosser.v VERILOG PATH "rtl/alt_em10g32_clock_crosser.v"
    add_fileset_file rtl/alt_em10g32_crc32.v VERILOG PATH "rtl/alt_em10g32_crc32.v"
    add_fileset_file rtl/alt_em10g32_crc32_gf_mult32_kc.v VERILOG PATH "rtl/alt_em10g32_crc32_gf_mult32_kc.v"
    add_fileset_file rtl/alt_em10g32_creg_map.v VERILOG PATH "rtl/alt_em10g32_creg_map.v"
    add_fileset_file rtl/alt_em10g32_creg_top.v VERILOG PATH "rtl/alt_em10g32_creg_top.v"
    add_fileset_file rtl/alt_em10g32_frm_decoder.v VERILOG PATH "rtl/alt_em10g32_frm_decoder.v"
    add_fileset_file rtl/alt_em10g32_tx_rs_gmii_mii_layer.v VERILOG PATH "rtl/alt_em10g32_tx_rs_gmii_mii_layer.v" 
    add_fileset_file rtl/alt_em10g32_pipeline_base.v VERILOG PATH "rtl/alt_em10g32_pipeline_base.v" 
    add_fileset_file rtl/alt_em10g32_reset_synchronizer.v VERILOG PATH "rtl/alt_em10g32_reset_synchronizer.v"
    add_fileset_file rtl/alt_em10g32_rr_clock_crosser.v VERILOG PATH "rtl/alt_em10g32_rr_clock_crosser.v"
    add_fileset_file rtl/alt_em10g32_rst_cnt.v VERILOG PATH "rtl/alt_em10g32_rst_cnt.v"
    add_fileset_file rtl/alt_em10g32_rx_fctl_filter_crcpad_rem.v VERILOG PATH "rtl/alt_em10g32_rx_fctl_filter_crcpad_rem.v" 
    add_fileset_file rtl/alt_em10g32_rx_fctl_overflow.v VERILOG PATH "rtl/alt_em10g32_rx_fctl_overflow.v" 
    add_fileset_file rtl/alt_em10g32_rx_fctl_preamble.v VERILOG PATH "rtl/alt_em10g32_rx_fctl_preamble.v" 
    add_fileset_file rtl/alt_em10g32_rx_frm_control.v VERILOG PATH "rtl/alt_em10g32_rx_frm_control.v" 
    add_fileset_file rtl/alt_em10g32_rx_pfc_flow_control.v VERILOG PATH "rtl/alt_em10g32_rx_pfc_flow_control.v" 
    add_fileset_file rtl/alt_em10g32_rx_pfc_pause_conversion.v VERILOG PATH "rtl/alt_em10g32_rx_pfc_pause_conversion.v" 
    add_fileset_file rtl/alt_em10g32_rx_pkt_backpressure_control.v VERILOG PATH "rtl/alt_em10g32_rx_pkt_backpressure_control.v" 
    add_fileset_file rtl/alt_em10g32_rx_rs_gmii16b.v VERILOG PATH "rtl/alt_em10g32_rx_rs_gmii16b.v"
    add_fileset_file rtl/alt_em10g32_rx_rs_gmii16b_top.v VERILOG PATH "rtl/alt_em10g32_rx_rs_gmii16b_top.v"
    add_fileset_file rtl/alt_em10g32_rx_rs_gmii_mii.v VERILOG PATH "rtl/alt_em10g32_rx_rs_gmii_mii.v" 
    add_fileset_file rtl/alt_em10g32_rx_rs_layer.v VERILOG PATH "rtl/alt_em10g32_rx_rs_layer.v" 
    add_fileset_file rtl/alt_em10g32_rx_rs_xgmii.v VERILOG PATH "rtl/alt_em10g32_rx_rs_xgmii.v" 
    add_fileset_file rtl/alt_em10g32_rx_status_aligner.v VERILOG PATH "rtl/alt_em10g32_rx_status_aligner.v" 
    add_fileset_file rtl/alt_em10g32_rx_top.v VERILOG PATH "rtl/alt_em10g32_rx_top.v" 
    add_fileset_file rtl/alt_em10g32_stat_mem.v VERILOG PATH "rtl/alt_em10g32_stat_mem.v" 
    add_fileset_file rtl/alt_em10g32_stat_reg.v VERILOG PATH "rtl/alt_em10g32_stat_reg.v" 
    add_fileset_file rtl/alt_em10g32_tx_data_frm_gen.v VERILOG PATH "rtl/alt_em10g32_tx_data_frm_gen.v" 
    add_fileset_file rtl/alt_em10g32_tx_srcaddr_inserter.v VERILOG PATH "rtl/alt_em10g32_tx_srcaddr_inserter.v" 
    add_fileset_file rtl/alt_em10g32_tx_err_aligner.v VERILOG PATH "rtl/alt_em10g32_tx_err_aligner.v" 
    add_fileset_file rtl/alt_em10g32_tx_flow_control.v VERILOG PATH "rtl/alt_em10g32_tx_flow_control.v" 
    add_fileset_file rtl/alt_em10g32_tx_frm_arbiter.v VERILOG PATH "rtl/alt_em10g32_tx_frm_arbiter.v" 
    add_fileset_file rtl/alt_em10g32_tx_frm_muxer.v VERILOG PATH "rtl/alt_em10g32_tx_frm_muxer.v" 
    add_fileset_file rtl/alt_em10g32_tx_pause_beat_conversion.v VERILOG PATH "rtl/alt_em10g32_tx_pause_beat_conversion.v" 
    add_fileset_file rtl/alt_em10g32_tx_pause_frm_gen.v VERILOG PATH "rtl/alt_em10g32_tx_pause_frm_gen.v" 
    add_fileset_file rtl/alt_em10g32_tx_pause_req.v VERILOG PATH "rtl/alt_em10g32_tx_pause_req.v" 
    add_fileset_file rtl/alt_em10g32_tx_pfc_frm_gen.v VERILOG PATH "rtl/alt_em10g32_tx_pfc_frm_gen.v" 
    add_fileset_file rtl/alt_em10g32_rr_buffer.v VERILOG PATH "rtl/alt_em10g32_rr_buffer.v" 
    add_fileset_file rtl/alt_em10g32_tx_rs_gmii16b.v VERILOG PATH "rtl/alt_em10g32_tx_rs_gmii16b.v"
    add_fileset_file rtl/alt_em10g32_tx_rs_gmii16b_top.v VERILOG PATH "rtl/alt_em10g32_tx_rs_gmii16b_top.v"
    add_fileset_file rtl/alt_em10g32_tx_rs_layer.v VERILOG PATH "rtl/alt_em10g32_tx_rs_layer.v" 
    add_fileset_file rtl/alt_em10g32_tx_rs_xgmii_layer.v VERILOG PATH "rtl/alt_em10g32_tx_rs_xgmii_layer.v" 
    add_fileset_file rtl/alt_em10g32_sc_fifo.v VERILOG PATH "rtl/alt_em10g32_sc_fifo.v" 
    add_fileset_file rtl/alt_em10g32_tx_top.v VERILOG PATH "rtl/alt_em10g32_tx_top.v" 
    add_fileset_file rtl/alt_em10g32_rx_gmii_decoder.v VERILOG PATH "rtl/alt_em10g32_rx_gmii_decoder.v" 
    add_fileset_file rtl/alt_em10g32_rx_gmii_decoder_dfa.v VERILOG PATH "rtl/alt_em10g32_rx_gmii_decoder_dfa.v" 
    add_fileset_file rtl/alt_em10g32_tx_gmii_encoder.v VERILOG PATH "rtl/alt_em10g32_tx_gmii_encoder.v" 
    add_fileset_file rtl/alt_em10g32_tx_gmii_encoder_dfa.v VERILOG PATH "rtl/alt_em10g32_tx_gmii_encoder_dfa.v" 
    add_fileset_file rtl/alt_em10g32_rx_gmii_mii_decoder_if.v VERILOG PATH "rtl/alt_em10g32_rx_gmii_mii_decoder_if.v" 
    add_fileset_file rtl/alt_em10g32_tx_gmii_mii_encoder_if.v VERILOG PATH "rtl/alt_em10g32_tx_gmii_mii_encoder_if.v"

    #adapters files    
    add_fileset_file adapters/altera_eth_avalon_mm_adapter/altera_eth_avalon_mm_adapter.v VERILOG PATH "adapters/altera_eth_avalon_mm_adapter/altera_eth_avalon_mm_adapter.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/altera_eth_avalon_st_adapter.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/altera_eth_avalon_st_adapter.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/avalon_st_adapter_avalon_st_rx.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/avalon_st_adapter_avalon_st_rx.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/avalon_st_adapter_avalon_st_tx.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/avalon_st_adapter_avalon_st_tx.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/avalon_st_adapter.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/avalon_st_adapter.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/alt_em10g32_vldpkt_rddly.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/alt_em10g32_vldpkt_rddly.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/sideband_adapter_rx.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/sideband_adapter_rx.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/sideband_adapter_tx.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/sideband_adapter_tx.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/sideband_adapter.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/sideband_adapter.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/altera_eth_sideband_crosser.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/altera_eth_sideband_crosser.v" 
    add_fileset_file adapters/altera_eth_avalon_st_adapter/altera_eth_sideband_crosser_sync.v VERILOG PATH "adapters/altera_eth_avalon_st_adapter/altera_eth_sideband_crosser_sync.v" 
    add_fileset_file adapters/altera_eth_xgmii_width_adaptor/alt_em10g_32_64_xgmii_conversion.v VERILOG PATH "adapters/altera_eth_xgmii_width_adaptor/alt_em10g_32_64_xgmii_conversion.v" 
    add_fileset_file adapters/altera_eth_xgmii_width_adaptor/alt_em10g_32_to_64_xgmii_conversion.v VERILOG PATH "adapters/altera_eth_xgmii_width_adaptor/alt_em10g_32_to_64_xgmii_conversion.v" 
    add_fileset_file adapters/altera_eth_xgmii_width_adaptor/alt_em10g_64_to_32_xgmii_conversion.v VERILOG PATH "adapters/altera_eth_xgmii_width_adaptor/alt_em10g_64_to_32_xgmii_conversion.v" 
    add_fileset_file adapters/altera_eth_xgmii_width_adaptor/alt_em10g_dcfifo_32_to_64_xgmii_conversion.v VERILOG PATH "adapters/altera_eth_xgmii_width_adaptor/alt_em10g_dcfifo_32_to_64_xgmii_conversion.v" 
    add_fileset_file adapters/altera_eth_xgmii_width_adaptor/alt_em10g_dcfifo_64_to_32_xgmii_conversion.v VERILOG PATH "adapters/altera_eth_xgmii_width_adaptor/alt_em10g_dcfifo_64_to_32_xgmii_conversion.v" 
    add_fileset_file adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_32_to_64_adapter.v VERILOG PATH "adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_32_to_64_adapter.v" 
    add_fileset_file adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_64_to_32_adapter.v VERILOG PATH "adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_64_to_32_adapter.v" 
    add_fileset_file adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_data_format_adapter.v VERILOG PATH "adapters/altera_eth_xgmii_data_format_adapter/alt_em10g32_xgmii_data_format_adapter.v" 
    
    
    add_fileset_file rtl/alt_em10g32_altsyncram_bundle.v VERILOG PATH "rtl/alt_em10g32_altsyncram_bundle.v"
    add_fileset_file rtl/alt_em10g32_altsyncram.v VERILOG PATH "rtl/alt_em10g32_altsyncram.v"
    
    add_fileset_file alt_em10g32_avalon_dc_fifo.v VERILOG PATH "rtl/alt_em10g32_avalon_dc_fifo.v"
    add_fileset_file alt_em10g32_dcfifo_synchronizer_bundle.v VERILOG PATH "rtl/alt_em10g32_dcfifo_synchronizer_bundle.v"
    add_fileset_file alt_em10g32_std_synchronizer.v VERILOG PATH "rtl/alt_em10g32_std_synchronizer.v"

    
    # ECC
    add_fileset_file rtl/alt_em10g32_avalon_dc_fifo_lat_calc.v VERILOG PATH "rtl/alt_em10g32_avalon_dc_fifo_lat_calc.v"
    add_fileset_file rtl/alt_em10g32_avalon_dc_fifo_hecc.v VERILOG PATH "rtl/alt_em10g32_avalon_dc_fifo_hecc.v"
    add_fileset_file rtl/alt_em10g32_avalon_dc_fifo_secc.v VERILOG PATH "rtl/alt_em10g32_avalon_dc_fifo_secc.v"
    add_fileset_file rtl/alt_em10g32_avalon_sc_fifo.v VERILOG PATH "rtl/alt_em10g32_avalon_sc_fifo.v"
    add_fileset_file rtl/alt_em10g32_avalon_sc_fifo_hecc.v VERILOG PATH "rtl/alt_em10g32_avalon_sc_fifo_hecc.v"
    add_fileset_file rtl/alt_em10g32_avalon_sc_fifo_secc.v VERILOG PATH "rtl/alt_em10g32_avalon_sc_fifo_secc.v"
    add_fileset_file rtl/alt_em10g32_ecc_dec_18_12.v VERILOG PATH "rtl/alt_em10g32_ecc_dec_18_12.v"
    add_fileset_file rtl/alt_em10g32_ecc_dec_39_32.v VERILOG PATH "rtl/alt_em10g32_ecc_dec_39_32.v"
    add_fileset_file rtl/alt_em10g32_ecc_enc_12_18.v VERILOG PATH "rtl/alt_em10g32_ecc_enc_12_18.v"
    add_fileset_file rtl/alt_em10g32_ecc_enc_32_39.v VERILOG PATH "rtl/alt_em10g32_ecc_enc_32_39.v"
    
    set ENABLE_TIMESTAMPING [get_parameter_value ENABLE_TIMESTAMPING]
    if {$ENABLE_TIMESTAMPING} {
        add_fileset_file rtl/alt_em10g32_avst_to_gmii_if.v VERILOG PATH "../1588/alt_em10g32_avst_to_gmii_if.v"
        add_fileset_file rtl/alt_em10g32_gmii_to_avst_if.v VERILOG PATH "../1588/alt_em10g32_gmii_to_avst_if.v"
        add_fileset_file rtl/alt_em10g32_gmii_tsu.v VERILOG PATH "../1588/alt_em10g32_gmii_tsu.v"
        add_fileset_file rtl/alt_em10g32_gmii_tsu.ocp OTHER PATH "../1588/alt_em10g32_gmii_tsu.ocp"
        add_fileset_file rtl/alt_em10g32_gmii16b_tsu.v VERILOG PATH "../1588/alt_em10g32_gmii16b_tsu.v"
        add_fileset_file rtl/alt_em10g32_gmii16b_tsu.ocp OTHER PATH "../1588/alt_em10g32_gmii16b_tsu.ocp"
        add_fileset_file rtl/alt_em10g32_lpm_mult.v VERILOG PATH "../1588/alt_em10g32_lpm_mult.v"
        add_fileset_file rtl/alt_em10g32_rx_ptp_aligner.v VERILOG PATH "../1588/alt_em10g32_rx_ptp_aligner.v"
        add_fileset_file rtl/alt_em10g32_rx_ptp_detector.v VERILOG PATH "../1588/alt_em10g32_rx_ptp_detector.v"


        add_fileset_file rtl/alt_em10g32_tx_gmii_crc_inserter.v VERILOG PATH "../1588/alt_em10g32_tx_gmii_crc_inserter.v"
        add_fileset_file rtl/alt_em10g32_tx_gmii16b_crc_inserter.v VERILOG PATH "../1588/alt_em10g32_tx_gmii16b_crc_inserter.v"
        add_fileset_file rtl/alt_em10g32_tx_gmii_ptp_inserter.v VERILOG PATH "../1588/alt_em10g32_tx_gmii_ptp_inserter.v"
        add_fileset_file rtl/alt_em10g32_tx_gmii16b_ptp_inserter.v VERILOG PATH "../1588/alt_em10g32_tx_gmii16b_ptp_inserter.v"
        add_fileset_file rtl/alt_em10g32_tx_ptp_processor.v VERILOG PATH "../1588/alt_em10g32_tx_ptp_processor.v"
        
        add_fileset_file rtl/alt_em10g32_tx_xgmii_crc_inserter.v VERILOG PATH "../1588/alt_em10g32_tx_xgmii_crc_inserter.v"
        add_fileset_file rtl/alt_em10g32_tx_xgmii_ptp_inserter.v VERILOG PATH "../1588/alt_em10g32_tx_xgmii_ptp_inserter.v"
        add_fileset_file rtl/alt_em10g32_xgmii_tsu.v VERILOG PATH "../1588/alt_em10g32_xgmii_tsu.v"
        add_fileset_file rtl/alt_em10g32_xgmii_tsu.ocp OTHER PATH "../1588/alt_em10g32_xgmii_tsu.ocp"
        add_fileset_file rtl/alt_em10g32_crc328generator.v VERILOG PATH "../1588/alt_em10g32_crc328generator.v"
        add_fileset_file rtl/alt_em10g32_crc32ctl8.v VERILOG PATH "../1588/alt_em10g32_crc32ctl8.v"
        add_fileset_file rtl/alt_em10g32_crc32galois8.v VERILOG PATH "../1588/alt_em10g32_crc32galois8.v"
        add_fileset_file rtl/alt_em10g32_gmii_crc_inserter.v VERILOG PATH "../1588/alt_em10g32_gmii_crc_inserter.v"
        add_fileset_file rtl/alt_em10g32_gmii16b_crc_inserter.v VERILOG PATH "../1588/alt_em10g32_gmii16b_crc_inserter.v"
        add_fileset_file rtl/alt_em10g32_gmii16b_crc32.v VERILOG PATH "../1588/alt_em10g32_gmii16b_crc32.v"
        add_fileset_file rtl/alt_em10g32_tx_ptp_top.v VERILOG PATH "../1588/alt_em10g32_tx_ptp_top.v"
        add_fileset_file rtl/alt_em10g32_rx_ptp_top.v VERILOG PATH "../1588/alt_em10g32_rx_ptp_top.v"
        
    }
    
    # Since all of the file sets are control by parameter, hence we can just add all the files. 
    add_fileset_file rtl/alt_em10g32_tx_rs_xgmii_layer_ultra.v VERILOG PATH "rtl/alt_em10g32_tx_rs_xgmii_layer_ultra.v"
    add_fileset_file rtl/alt_em10g32_rx_rs_xgmii_ultra.v VERILOG PATH "rtl/alt_em10g32_rx_rs_xgmii_ultra.v"
    
    # add fileset for Signaltap use
    add_fileset_file debug/stp/build_stp.tcl OTHER PATH "stp/build_stp.tcl"
    add_fileset_file debug/stp/LL10GMAC.xml OTHER PATH "stp/LL10GMAC.xml.txt"

    
    sdc_file_gen    
}
