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


proc compose_ed_arria_10 {dir config device video_std insert_vpid extract_vpid crc_err a2b b2a cmp_data txpll_switch} {

   if { $insert_vpid } {
      set extract_vpid      1
   }

   if { ($video_std == "tr" | $video_std == "dl" | $video_std == "threeg" | $video_std == "mr" ) } {
      set ch0_vpid_insert  $insert_vpid
      set ch0_vpid_extract 1
      set ch1_vpid_insert  $insert_vpid
      set ch1_vpid_extract 1
      set ch2_vpid_insert  1
      set ch2_vpid_extract 1
   } elseif { $video_std == "sd" } {
      set ch0_vpid_insert  0
      set ch0_vpid_extract 0
      set ch1_vpid_insert  $insert_vpid
      set ch1_vpid_extract $extract_vpid
   } else {
      set ch0_vpid_insert  $insert_vpid
      set ch0_vpid_extract $extract_vpid
      set ch1_vpid_insert  $insert_vpid
      set ch1_vpid_extract $extract_vpid
   }

   add_instance      pattgen  sdi_ii_ed_vid_pattgen
   # Special handling for OUTW_MULTP as this param is not available from sdi_ii hwtcl
   foreach pattgen_param [get_instance_parameters pattgen] {
      if { $pattgen_param == "OUTW_MULTP" } {
        set_instance_parameter_value pattgen OUTW_MULTP     1
      } else {
        set_instance_parameter_value pattgen $pattgen_param [get_parameter_value $pattgen_param]
      }
   }

   if { $ch1_vpid_insert } {
      set_instance_parameter_value pattgen TX_EN_VPID_INSERT   1
   }

   if { !$ch1_vpid_insert & $ch1_vpid_extract } {
      set_instance_parameter_value pattgen TEST_GEN_ANC    1
      set_instance_parameter_value pattgen TEST_GEN_VPID   1
   }
   
   if { $video_std == "mr" } {
      set_instance_parameter_value pattgen OUTW_MULTP  4
   }

   set  ch                   ch1
   derive_instance_name   $dir xcvr_proto  $video_std
   derive_instance_param  $dir xcvr_proto
   set  inst1                [get_parameter_value INST1]
   set  inst3                [get_parameter_value INST3]

   add_ch_instance           ch1   $inst1   $inst3   ch1_tx_native_phy   ch1_rx_native_phy   $video_std   $dir $ch1_vpid_insert  $ch1_vpid_extract   $cmp_data   $txpll_switch
   add_export_ch_interface   ch1   $inst1   $inst3   ch1_tx_native_phy   ch1_rx_native_phy   $video_std   $dir $crc_err   $ch1_vpid_insert   $ch1_vpid_extract   $a2b   $b2a   $txpll_switch
   add_common_connection     ch1   $inst1   $inst3   ch1_tx_native_phy   ch1_rx_native_phy   $video_std   $txpll_switch
   add_ch1_connection        ch1   $inst1   $inst3   $video_std   $ch1_vpid_insert
   add_pattgen_connection    $inst1   $video_std   $ch1_vpid_insert $cmp_data
   
   if { $a2b & $dir == "rx" } {
      add_ch_instance           ch2   ch2_smpte372_tx_3g   ch2_smpte372_rx_3g   ch2_tx_native_phy   ch2_rx_native_phy   threeg   rx   $ch2_vpid_insert  $ch2_vpid_extract   $cmp_data   0
      add_export_ch_interface   ch2   ch2_smpte372_tx_3g   ch2_smpte372_rx_3g   ch2_tx_native_phy   ch2_rx_native_phy   threeg   rx   $crc_err   $ch2_vpid_insert   $ch2_vpid_extract   0   0   0
      add_common_connection     ch2   ch2_smpte372_tx_3g   ch2_smpte372_rx_3g   ch2_tx_native_phy   ch2_rx_native_phy   threeg   0
      add_ch2_connection        $inst3   a2b_loopback   ch2_smpte372_tx_3g   ch2_smpte372_rx_3g   $b2a
   } elseif { $b2a & $dir == "rx" } {
      add_ch_instance           ch2   ch2_smpte372_tx_dl   ch2_smpte372_rx_dl   ch2_tx_native_phy   ch2_rx_native_phy   dl   rx   $ch2_vpid_insert  $ch2_vpid_extract   $cmp_data   0
      add_export_ch_interface   ch2   ch2_smpte372_tx_dl   ch2_smpte372_rx_dl   ch2_tx_native_phy   ch2_rx_native_phy   dl   rx   $crc_err   $ch2_vpid_insert   $ch2_vpid_extract   0   0   0
      add_common_connection     ch2   ch2_smpte372_tx_dl   ch2_smpte372_rx_dl   ch2_tx_native_phy   ch2_rx_native_phy   dl   0
      add_ch2_connection        $inst3   b2a_loopback   ch2_smpte372_tx_dl   ch2_smpte372_rx_dl   $b2a
   }

   add_ch_instance           ch0   ch0_loopback_du_$video_std   ch0_loopback_du_$video_std   ch0_native_phy   ch0_native_phy   $video_std   $dir   $ch0_vpid_insert   $ch0_vpid_extract   \
                             $cmp_data   0
   add_export_ch_interface   ch0   ch0_loopback_du_$video_std   ch0_loopback_du_$video_std   ch0_native_phy   ch0_native_phy   $video_std   $dir   $crc_err   $ch0_vpid_insert   \
                             $ch0_vpid_extract   0   0   0
   add_common_connection     ch0   ch0_loopback_du_$video_std   ch0_loopback_du_$video_std   ch0_native_phy   ch0_native_phy   $video_std   0
   add_ch0_connection        ch0   loopback_du_$video_std   $video_std   $ch0_vpid_insert   $ch0_vpid_extract

    # Pattgen - export
    add_export_rename_interface  pattgen bar_100_75n  conduit  input 
    add_export_rename_interface  pattgen patho        conduit  input
    add_export_rename_interface  pattgen blank        conduit  input
    add_export_rename_interface  pattgen no_color     conduit  input
    add_export_rename_interface  pattgen sgmt_frame   conduit  input
    add_export_rename_interface  pattgen tx_std       conduit  input
    add_export_rename_interface  pattgen tx_format    conduit  input
    add_export_rename_interface  pattgen dl_mapping   conduit  input
    add_export_rename_interface  pattgen ntsc_paln    conduit  input

    # if { $insert_vpid } {
      # add_export_fanout_rename_interface     pattgen   line_f0        conduit   output
      # add_export_fanout_rename_interface     pattgen   line_f1        conduit   output
    # }

    if { $cmp_data } {
      add_export_fanout_rename_interface     pattgen   dout           conduit   output
      add_export_fanout_rename_interface     pattgen   dout_valid     conduit   output
      if { $video_std == "dl"} {
        add_export_fanout_rename_interface   pattgen   dout_b         conduit   output
        add_export_fanout_rename_interface   pattgen   dout_valid_b   conduit   output
      }
    }
}

proc add_ch_instance {ch  tx_inst_name rx_inst_name tx_phy_name rx_phy_name video_std dir vpid_insert  vpid_extract cmp_data txpll_switch } {
   if {$video_std == "mr"} {
      set num_streams 4
   } else {
      set num_streams 1
   }

   if { $ch == "ch0" } {
      add_instance                   $tx_inst_name  sdi_ii
      propagate_params               $tx_inst_name
      set_instance_parameter_value         $tx_inst_name  DIRECTION             du
      set_instance_parameter_value         $tx_inst_name  TRANSCEIVER_PROTOCOL  xcvr_proto
      set_instance_parameter_value         $tx_inst_name  VIDEO_STANDARD        $video_std
      set_instance_parameter_value         $tx_inst_name  RX_EN_A2B_CONV        0
      set_instance_parameter_value         $tx_inst_name  RX_EN_B2A_CONV        0
      set_instance_parameter_value         $tx_inst_name  TX_EN_VPID_INSERT     $vpid_insert
      set_instance_parameter_value         $tx_inst_name  RX_EN_VPID_EXTRACT    $vpid_extract
   } else {
      add_instance                   $tx_inst_name  sdi_ii
      propagate_params               $tx_inst_name
      set_instance_parameter_value         $tx_inst_name  DIRECTION             [get_parameter_value INST1_DIR]
      set_instance_parameter_value         $tx_inst_name  TRANSCEIVER_PROTOCOL  xcvr_proto
      set_instance_parameter_value         $tx_inst_name  VIDEO_STANDARD        $video_std
      set_instance_parameter_value         $tx_inst_name  RX_EN_A2B_CONV        0
      set_instance_parameter_value         $tx_inst_name  RX_EN_B2A_CONV        0
      set_instance_parameter_value         $tx_inst_name  TX_EN_VPID_INSERT     $vpid_insert

      if { $dir != "du" } {
         # Instantiate second instance of IP core (TEST) with combined xcvr_proto
         # this could be tx OR rx
         add_instance                $rx_inst_name  sdi_ii
         propagate_params            $rx_inst_name
         set_instance_parameter_value      $rx_inst_name  DIRECTION             [get_parameter_value INST3_DIR]
         set_instance_parameter_value      $rx_inst_name  TRANSCEIVER_PROTOCOL  xcvr_proto
         set_instance_parameter_value      $rx_inst_name  VIDEO_STANDARD        $video_std
         if { $dir == "tx" } {
            set_instance_parameter_value   $rx_inst_name  RX_EN_VPID_EXTRACT  $vpid_extract
         }
         if { $ch == "ch2" } {
            set_instance_parameter_value         $rx_inst_name  RX_EN_A2B_CONV        0
            set_instance_parameter_value         $rx_inst_name  RX_EN_B2A_CONV        0
         }
      }
   }

   add_instance                      ${ch}_phy_adapter  sdi_ii_phy_adapter
   set_instance_parameter_value            ${ch}_phy_adapter  VIDEO_STANDARD        $video_std
   set_instance_parameter_value            ${ch}_phy_adapter  DIRECTION             du
   # set_instance_parameter_value            ${ch}_phy_adapter  ED_TXPLL_TYPE         [get_parameter_value ED_TXPLL_TYPE]
   set_instance_parameter_value            ${ch}_phy_adapter  ED_TXPLL_SWITCH       $txpll_switch
   if { $video_std == "dl" } {
      set_instance_parameter_value            ${ch}_phy_adapter  XCVR_RST_CTRL_CHS     2
   }

   if { $ch == "ch0" } {
      add_instance                   ${ch}_loopback     sdi_ii_ed_loopback
      propagate_params               ${ch}_loopback
      set_instance_parameter_value         ${ch}_loopback     RX_EN_A2B_CONV        0
      set_instance_parameter_value         ${ch}_loopback     RX_EN_B2A_CONV        0
      set_instance_parameter_value         ${ch}_loopback     TX_EN_VPID_INSERT     $vpid_insert
      set_instance_parameter_value         ${ch}_loopback     RX_EN_VPID_EXTRACT    $vpid_extract
   } elseif { $ch == "ch2" } {
      if { [get_parameter_value RX_EN_A2B_CONV] } {
         set loopback_name a2b_loopback
      } elseif { [get_parameter_value RX_EN_B2A_CONV] } {
         set loopback_name b2a_loopback
      }
      add_instance                   $loopback_name     sdi_ii_ed_loopback
      propagate_params               $loopback_name
      set_instance_parameter_value         $loopback_name     TX_EN_VPID_INSERT     $vpid_insert
   }

   set base_device [get_parameter_value BASE_DEVICE]
   if { $video_std == "mr" } {
      set pll_out_freq  "5940.0"
      set pll_out_freq1 "5934.0"
      set pll_refclk    "297.000000"
      set pll_refclk1   "296.700000"
   } elseif { [get_parameter_value ED_TXPLL_TYPE] == "CMU" } {
      set pll_out_freq  "2970.0"
      set pll_out_freq1 "2967.0"
      set pll_refclk    "148.500000"
      set pll_refclk1   "148.350000"
   } else {
      set pll_out_freq  "1485.0"
      set pll_out_freq1 "1483.5"
      set pll_refclk    "148.500000"
      set pll_refclk1   "148.350000"
   }

   if { [get_parameter_value ED_TXPLL_TYPE] == "ATX"} {
      add_instance                      ${ch}_tx_pll       altera_xcvr_atx_pll_a10
      set_instance_parameter_value      ${ch}_tx_pll       set_output_clock_frequency           $pll_out_freq
      set_instance_parameter_value      ${ch}_tx_pll       set_auto_reference_clock_frequency   $pll_refclk

      if { $txpll_switch == "1" } {
         add_instance                      ${ch}_tx_pll_alt       altera_xcvr_atx_pll_a10
         set_instance_parameter_value      ${ch}_tx_pll_alt       set_output_clock_frequency           $pll_out_freq1
         set_instance_parameter_value      ${ch}_tx_pll_alt       set_auto_reference_clock_frequency   $pll_refclk1
      } elseif { $txpll_switch == "2" } {
         set_instance_parameter_value      ${ch}_tx_pll       refclk_cnt   2
         set_instance_parameter_value      ${ch}_tx_pll       enable_pll_reconfig   1
         set_instance_parameter_value      ${ch}_tx_pll       rcfg_sv_file_enable   1
      }
   } elseif { [get_parameter_value ED_TXPLL_TYPE] == "fPLL" } {
      add_instance                      ${ch}_tx_pll       altera_xcvr_fpll_a10
      set_instance_parameter_value      ${ch}_tx_pll       gui_hssi_output_clock_frequency  $pll_out_freq
      set_instance_parameter_value      ${ch}_tx_pll       gui_desired_refclk_frequency     $pll_refclk
      set_instance_parameter_value      ${ch}_tx_pll       gui_bw_sel                       "high"

      if { $txpll_switch == "1" } {
         add_instance                      ${ch}_tx_pll_alt       altera_xcvr_fpll_a10
         set_instance_parameter_value      ${ch}_tx_pll_alt       gui_hssi_output_clock_frequency   $pll_out_freq1
         set_instance_parameter_value      ${ch}_tx_pll_alt       gui_desired_refclk_frequency      $pll_refclk1
         set_instance_parameter_value      ${ch}_tx_pll_alt       gui_bw_sel                        "high"
      } elseif { $txpll_switch == "2" } {
         set_instance_parameter_value      ${ch}_tx_pll       gui_refclk_cnt   2
         set_instance_parameter_value      ${ch}_tx_pll       enable_pll_reconfig   1
         set_instance_parameter_value      ${ch}_tx_pll       rcfg_sv_file_enable   1
      }
   } else {
      add_instance                      ${ch}_tx_pll       altera_xcvr_cdr_pll_a10
      set_instance_parameter_value      ${ch}_tx_pll       output_clock_frequency      $pll_out_freq
      set_instance_parameter_value      ${ch}_tx_pll       reference_clock_frequency   $pll_refclk

      if { $txpll_switch == "1" } {
         add_instance                      ${ch}_tx_pll_alt       altera_xcvr_cdr_pll_a10
         set_instance_parameter_value      ${ch}_tx_pll_alt       output_clock_frequency      $pll_out_freq1
         set_instance_parameter_value      ${ch}_tx_pll_alt       reference_clock_frequency   $pll_refclk1
      } elseif { $txpll_switch == "2" } {
         set_instance_parameter_value      ${ch}_tx_pll       refclk_cnt   2
         set_instance_parameter_value      ${ch}_tx_pll       enable_pll_reconfig   1
         set_instance_parameter_value      ${ch}_tx_pll       rcfg_sv_file_enable   1
      }
   }

   if {$video_std == "mr"} {
      set data_rate         "11880"
      set pma_clk_div       1
      set tx_ser_mode       "Disabled"
      set rx_deser_mode     "Disabled"
      set anlg_volt         "1_0V"
   } elseif {$video_std == "hd" || $video_std == "dl"} {
      set data_rate         "1485"
      if { [get_parameter_value ED_TXPLL_TYPE] == "CMU"} {
        set pma_clk_div       4
      } else {
        set pma_clk_div       2
      }
      set tx_ser_mode       "Serialize x2"
      set rx_deser_mode     "Deserialize x2"
      if { [get_parameter_value BASE_DEVICE] == "NIGHTFURY5ES2" } {
        set anlg_volt         "1_0V"
      } else {
        set anlg_volt         "0_9V"
      }
   } else {
      set data_rate         "2970"
      if { [get_parameter_value ED_TXPLL_TYPE] == "CMU"} {
        set pma_clk_div       2
      } else {
        set pma_clk_div       1
      }
      set tx_ser_mode       "Serialize x2"
      set rx_deser_mode     "Deserialize x2"
      if { [get_parameter_value BASE_DEVICE] == "NIGHTFURY5ES2" } {
        set anlg_volt         "1_0V"
      } else {
        set anlg_volt         "0_9V"
      }
   }

   if { $ch == "ch0" } {
      add_instance                   $tx_phy_name         altera_xcvr_native_a10
      set_instance_parameter_value   $tx_phy_name         set_data_rate                         $data_rate
      set_instance_parameter_value   $tx_phy_name         set_cdr_refclk_freq                   "148.500"
      set_instance_parameter_value   $tx_phy_name         enable_ports_rx_manual_cdr_mode       1
      set_instance_parameter_value   $tx_phy_name         std_tx_byte_ser_mode                  $tx_ser_mode
      set_instance_parameter_value   $tx_phy_name         std_rx_byte_deser_mode                $rx_deser_mode
      set_instance_parameter_value   $tx_phy_name         duplex_mode                           "duplex"
      set_instance_parameter_value   $tx_phy_name         tx_pma_clk_div                        $pma_clk_div
      set_instance_parameter_value   $tx_phy_name         anlg_voltage                          $anlg_volt
      set_instance_parameter_value   $tx_phy_name         anlg_link                             "sr"
      if { $video_std == "tr" | $video_std == "ds" | $video_std == "mr"} {
         set_instance_parameter_value   $tx_phy_name         rcfg_enable   1
         set_instance_parameter_value   $tx_phy_name         rcfg_sv_file_enable   1
         set_instance_parameter_value   $tx_phy_name         enable_port_rx_analog_reset_ack   1
      }
      if {$video_std == "mr"} {
         set_instance_parameter_value   $tx_phy_name         protocol_mode                      "basic_enh"
         set_instance_parameter_value   $tx_phy_name         rcfg_iface_enable                  1
         set_instance_parameter_value   $tx_phy_name         std_tx_8b10b_enable                1
         set_instance_parameter_value   $tx_phy_name         std_rx_8b10b_enable                1
         set_instance_parameter_value   $tx_phy_name         std_rx_word_aligner_mode           "synchronous state machine"
         set_instance_parameter_value   $tx_phy_name         std_rx_word_aligner_pattern_len    10
         set_instance_parameter_value   $tx_phy_name         enh_rxtxfifo_double_width          1
         set_instance_parameter_value   $tx_phy_name         enable_port_tx_pma_div_clkout      1
         set_instance_parameter_value   $tx_phy_name         tx_pma_div_clkout_divider          2
         set_instance_parameter_value   $tx_phy_name         enable_port_rx_pma_div_clkout      1
         set_instance_parameter_value   $tx_phy_name         rx_pma_div_clkout_divider          2
      }

      if { $video_std == "dl" } {
         add_instance                   ${tx_phy_name}_b         altera_xcvr_native_a10
         set_instance_parameter_value   ${tx_phy_name}_b         set_data_rate                         $data_rate
         set_instance_parameter_value   ${tx_phy_name}_b         set_cdr_refclk_freq                   "148.500"
         set_instance_parameter_value   ${tx_phy_name}_b         enable_ports_rx_manual_cdr_mode       1
         set_instance_parameter_value   ${tx_phy_name}_b         std_tx_byte_ser_mode                  $tx_ser_mode
         set_instance_parameter_value   ${tx_phy_name}_b         std_rx_byte_deser_mode                $rx_deser_mode
         set_instance_parameter_value   ${tx_phy_name}_b         duplex_mode                           "duplex"
         set_instance_parameter_value   ${tx_phy_name}_b         tx_pma_clk_div                        $pma_clk_div
        set_instance_parameter_value    ${tx_phy_name}_b         anlg_voltage                          $anlg_volt
        set_instance_parameter_value    ${tx_phy_name}_b         anlg_link                             "sr"
      }

   } else {
      add_instance                   $tx_phy_name      altera_xcvr_native_a10
      set_instance_parameter_value   $tx_phy_name      set_data_rate                         $data_rate
      set_instance_parameter_value   $tx_phy_name      std_tx_byte_ser_mode                  $tx_ser_mode
      set_instance_parameter_value   $tx_phy_name      duplex_mode                           "tx"
      set_instance_parameter_value   $tx_phy_name      tx_pma_clk_div                        $pma_clk_div
      set_instance_parameter_value   $tx_phy_name      anlg_voltage                          $anlg_volt
      set_instance_parameter_value   $tx_phy_name      anlg_link                             "sr"
      if { $txpll_switch == "1" } {
         set_instance_parameter_value   $tx_phy_name         plls          2
         set_instance_parameter_value   $tx_phy_name         rcfg_enable   1
         set_instance_parameter_value   $tx_phy_name         rcfg_sv_file_enable   1
         set_instance_parameter_value   $tx_phy_name         enable_port_tx_analog_reset_ack   1
      }
      if {$video_std == "mr"} {
         set_instance_parameter_value   $tx_phy_name         protocol_mode                  "basic_enh"
         set_instance_parameter_value   $tx_phy_name         enh_rxtxfifo_double_width      1
         set_instance_parameter_value   $tx_phy_name         enable_port_tx_pma_div_clkout      1
         set_instance_parameter_value   $tx_phy_name         tx_pma_div_clkout_divider          2
      }

      add_instance                   $rx_phy_name      altera_xcvr_native_a10
      set_instance_parameter_value   $rx_phy_name      set_data_rate                         $data_rate
      set_instance_parameter_value   $rx_phy_name      set_cdr_refclk_freq                   "148.500"
      set_instance_parameter_value   $rx_phy_name      enable_ports_rx_manual_cdr_mode       1
      set_instance_parameter_value   $rx_phy_name      std_rx_byte_deser_mode                $rx_deser_mode
      set_instance_parameter_value   $rx_phy_name      duplex_mode   "rx"
      set_instance_parameter_value   $rx_phy_name      anlg_voltage                          $anlg_volt
      set_instance_parameter_value   $rx_phy_name      anlg_link                             "sr"
      if { $video_std == "tr" | $video_std == "ds" | $video_std == "mr"} {
         set_instance_parameter_value   $rx_phy_name         rcfg_enable                1
         set_instance_parameter_value   $rx_phy_name         rcfg_sv_file_enable        1
         set_instance_parameter_value   $rx_phy_name         rcfg_multi_enable          1
         set_instance_parameter_value   $rx_phy_name         rcfg_reduced_files_enable  1
         set_instance_parameter_value   $rx_phy_name         rcfg_profile_select        0
         set_instance_parameter_value   $rx_phy_name         enable_port_rx_analog_reset_ack    1
      }
      if {$video_std == "mr"} {
         set_instance_parameter_value   $rx_phy_name         protocol_mode                      "basic_enh"
         set_instance_parameter_value   $rx_phy_name         enh_rxtxfifo_double_width          1
         set_instance_parameter_value   $rx_phy_name         rcfg_iface_enable                  1
         set_instance_parameter_value   $rx_phy_name         std_rx_8b10b_enable                1
         set_instance_parameter_value   $rx_phy_name         std_rx_word_aligner_mode           "synchronous state machine"
         set_instance_parameter_value   $rx_phy_name         std_rx_word_aligner_pattern_len    10
         set_instance_parameter_value   $rx_phy_name         enable_port_rx_pma_div_clkout      1
         set_instance_parameter_value   $rx_phy_name         rx_pma_div_clkout_divider          2

         set_instance_parameter_value   $rx_phy_name         rcfg_profile_cnt                   4
         set_instance_parameter_value   $rx_phy_name         rcfg_profile_data0                 "support_mode user_mode protocol_mode basic_enh pma_mode basic duplex_mode rx channels 1 \
                                                                                                 set_data_rate 11880 rcfg_iface_enable 1 enable_simple_interface 0 enable_split_interface 0 \
                                                                                                 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode not_bonded \
                                                                                                 set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 1 pll_select 0 enable_port_tx_pma_clkout 0 \
                                                                                                 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 \
                                                                                                 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 \
                                                                                                 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 \
                                                                                                 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 \
                                                                                                 set_cdr_refclk_freq 148.500000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual \
                                                                                                 rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 \
                                                                                                 enable_ports_adaptation 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 1 \
                                                                                                 rx_pma_div_clkout_divider 2 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 \
                                                                                                 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 \
                                                                                                 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 \
                                                                                                 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 \
                                                                                                 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 \
                                                                                                 std_tx_pcfifo_mode low_latency std_rx_pcfifo_mode low_latency enable_port_tx_std_pcfifo_full 0 \
                                                                                                 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 \
                                                                                                 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode Disabled std_rx_byte_deser_mode Disabled \
                                                                                                 std_tx_8b10b_enable 0 std_tx_8b10b_disp_ctrl_enable 0 std_rx_8b10b_enable 1 \
                                                                                                 std_rx_rmfifo_mode disabled std_rx_rmfifo_pattern_n 0 std_rx_rmfifo_pattern_p 0 \
                                                                                                 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 pcie_rate_match Bypass \
                                                                                                 std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 \
                                                                                                 std_rx_word_aligner_mode {synchronous state machine} std_rx_word_aligner_pattern_len 10 \
                                                                                                 std_rx_word_aligner_pattern 0 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 3 \
                                                                                                 std_rx_word_aligner_rgnumber 3 std_rx_word_aligner_fast_sync_status_enable 0 \
                                                                                                 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 \
                                                                                                 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 \
                                                                                                 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 \
                                                                                                 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 \
                                                                                                 std_rx_polinv_enable 0 enable_port_rx_polinv 0 enable_port_rx_std_signaldetect 0 \
                                                                                                 enable_ports_pipe_sw 0 enable_ports_pipe_hclk 0 enable_ports_pipe_g3_analog 0 \
                                                                                                 enable_ports_pipe_rx_elecidle 0 enable_port_pipe_rx_polarity 0 enh_pcs_pma_width 40 \
                                                                                                 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 1 \
                                                                                                 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 \
                                                                                                 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 \
                                                                                                 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 \
                                                                                                 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 \
                                                                                                 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 \
                                                                                                 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 \
                                                                                                 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 \
                                                                                                 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 \
                                                                                                 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 \
                                                                                                 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 \
                                                                                                 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 \
                                                                                                 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 \
                                                                                                 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 \
                                                                                                 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 \
                                                                                                 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 \
                                                                                                 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 \
                                                                                                 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 \
                                                                                                 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 \
                                                                                                 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 \
                                                                                                 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 \
                                                                                                 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 \
                                                                                                 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 \
                                                                                                 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 \
                                                                                                 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 40 anlg_voltage $anlg_volt anlg_link sr
                                                                                                 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 \
                                                                                                 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable \
                                                                                                 anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable non_s1_mode \
                                                                                                 anlg_rx_eq_dc_gain_trim no_dc_gain anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_0 \
                                                                                                 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_0 anlg_rx_adp_vga_sel radp_vga_sel_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1 enable_port_tx_analog_reset_ack 0 \
                                                                                                 enable_port_rx_analog_reset_ack 1"
         set_instance_parameter_value   $rx_phy_name         rcfg_profile_data1                 "support_mode user_mode protocol_mode basic_std pma_mode basic duplex_mode rx channels 1 \
                                                                                                 set_data_rate 5940 rcfg_iface_enable 1 enable_simple_interface 0 enable_split_interface 0 \
                                                                                                 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode not_bonded \
                                                                                                 set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 1 pll_select 0 enable_port_tx_pma_clkout 0 \
                                                                                                 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 \
                                                                                                 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 \
                                                                                                 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 \
                                                                                                 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 \
                                                                                                 set_cdr_refclk_freq 148.500000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual \
                                                                                                 rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 \
                                                                                                 enable_ports_adaptation 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 1 \
                                                                                                 rx_pma_div_clkout_divider 2 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 \
                                                                                                 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 \
                                                                                                 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 \
                                                                                                 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 20 \
                                                                                                 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 \
                                                                                                 std_tx_pcfifo_mode low_latency std_rx_pcfifo_mode low_latency enable_port_tx_std_pcfifo_full 0 \
                                                                                                 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 \
                                                                                                 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode Disabled \
                                                                                                 std_rx_byte_deser_mode {Deserialize x2} std_tx_8b10b_enable 0 std_tx_8b10b_disp_ctrl_enable 0 \
                                                                                                 std_rx_8b10b_enable 0 std_rx_rmfifo_mode disabled std_rx_rmfifo_pattern_n 0 \
                                                                                                 std_rx_rmfifo_pattern_p 0 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 \
                                                                                                 pcie_rate_match Bypass std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 \
                                                                                                 std_rx_word_aligner_mode bitslip std_rx_word_aligner_pattern_len 7 \
                                                                                                 std_rx_word_aligner_pattern 0 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 3 \
                                                                                                 std_rx_word_aligner_rgnumber 3 std_rx_word_aligner_fast_sync_status_enable 0 \
                                                                                                 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 \
                                                                                                 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 \
                                                                                                 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 \
                                                                                                 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 \
                                                                                                 std_rx_polinv_enable 0 enable_port_rx_polinv 0 enable_port_rx_std_signaldetect 0 \
                                                                                                 enable_ports_pipe_sw 0 enable_ports_pipe_hclk 0 enable_ports_pipe_g3_analog 0 \
                                                                                                 enable_ports_pipe_rx_elecidle 0 enable_port_pipe_rx_polarity 0 enh_pcs_pma_width 64 \
                                                                                                 enh_pld_pcs_width 64 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 \
                                                                                                 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 \
                                                                                                 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 \
                                                                                                 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 \
                                                                                                 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 \
                                                                                                 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 \
                                                                                                 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 \
                                                                                                 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 \
                                                                                                 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 \
                                                                                                 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 \
                                                                                                 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 \
                                                                                                 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 \
                                                                                                 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 \
                                                                                                 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 \
                                                                                                 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 \
                                                                                                 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 \
                                                                                                 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 \
                                                                                                 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 \
                                                                                                 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 \
                                                                                                 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 \
                                                                                                 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 \
                                                                                                 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 \
                                                                                                 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 \
                                                                                                 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 \
                                                                                                 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 40 anlg_voltage $anlg_volt anlg_link sr
                                                                                                 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 \
                                                                                                 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable \
                                                                                                 anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable non_s1_mode \
                                                                                                 anlg_rx_eq_dc_gain_trim no_dc_gain anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_0 \
                                                                                                 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_0 anlg_rx_adp_vga_sel radp_vga_sel_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1 enable_port_tx_analog_reset_ack 0 \
                                                                                                 enable_port_rx_analog_reset_ack 1"
         set_instance_parameter_value   $rx_phy_name         rcfg_profile_data2                 "support_mode user_mode protocol_mode basic_std pma_mode basic duplex_mode rx channels 1 \
                                                                                                 set_data_rate 2970 rcfg_iface_enable 1 enable_simple_interface 0 enable_split_interface 0 \
                                                                                                 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode not_bonded \
                                                                                                 set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 1 pll_select 0 enable_port_tx_pma_clkout 0 \
                                                                                                 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 \
                                                                                                 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 \
                                                                                                 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 \
                                                                                                 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 \
                                                                                                 set_cdr_refclk_freq 148.500000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual \
                                                                                                 rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 \
                                                                                                 enable_ports_adaptation 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 1 \
                                                                                                 rx_pma_div_clkout_divider 2 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 \
                                                                                                 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 \
                                                                                                 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 \
                                                                                                 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 \
                                                                                                 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 \
                                                                                                 std_tx_pcfifo_mode low_latency std_rx_pcfifo_mode low_latency enable_port_tx_std_pcfifo_full 0 \
                                                                                                 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 \
                                                                                                 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode Disabled \
                                                                                                 std_rx_byte_deser_mode {Deserialize x2} std_tx_8b10b_enable 0 std_tx_8b10b_disp_ctrl_enable 0 \
                                                                                                 std_rx_8b10b_enable 0 std_rx_rmfifo_mode disabled std_rx_rmfifo_pattern_n 0 \
                                                                                                 std_rx_rmfifo_pattern_p 0 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 \
                                                                                                 pcie_rate_match Bypass std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 \
                                                                                                 std_rx_word_aligner_mode bitslip std_rx_word_aligner_pattern_len 7 \
                                                                                                 std_rx_word_aligner_pattern 0 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 3 \
                                                                                                 std_rx_word_aligner_rgnumber 3 std_rx_word_aligner_fast_sync_status_enable 0 \
                                                                                                 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 \
                                                                                                 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 \
                                                                                                 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 \
                                                                                                 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 \
                                                                                                 std_rx_polinv_enable 0 enable_port_rx_polinv 0 enable_port_rx_std_signaldetect 0 \
                                                                                                 enable_ports_pipe_sw 0 enable_ports_pipe_hclk 0 enable_ports_pipe_g3_analog 0 \
                                                                                                 enable_ports_pipe_rx_elecidle 0 enable_port_pipe_rx_polarity 0 enh_pcs_pma_width 64 \
                                                                                                 enh_pld_pcs_width 64 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 \
                                                                                                 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 \
                                                                                                 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 \
                                                                                                 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 \
                                                                                                 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 \
                                                                                                 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 \
                                                                                                 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 \
                                                                                                 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 \
                                                                                                 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 \
                                                                                                 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 \
                                                                                                 enh_tx_frmgen_enable 0 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 \
                                                                                                 enable_port_tx_enh_frame 0 enable_port_tx_enh_frame_diag_status 0 \
                                                                                                 enable_port_tx_enh_frame_burst_en 0 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 \
                                                                                                 enable_port_rx_enh_frame 0 enable_port_rx_enh_frame_lock 0 \
                                                                                                 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 enh_tx_crcerr_enable 0 \
                                                                                                 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 enable_port_rx_enh_highber 0 \
                                                                                                 enable_port_rx_enh_highber_clr_cnt 0 enable_port_rx_enh_clr_errblk_count 0 \
                                                                                                 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 enh_tx_sh_err 0 enh_tx_scram_enable 0 \
                                                                                                 enh_tx_scram_seed 0 enh_rx_descram_enable 0 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 \
                                                                                                 enh_tx_randomdispbit_enable 0 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 \
                                                                                                 enh_tx_bitslip_enable 0 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 \
                                                                                                 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 \
                                                                                                 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 \
                                                                                                 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 \
                                                                                                 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 40 anlg_voltage $anlg_volt anlg_link sr
                                                                                                 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 \
                                                                                                 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable \
                                                                                                 anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable non_s1_mode \
                                                                                                 anlg_rx_eq_dc_gain_trim no_dc_gain anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_0 \
                                                                                                 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_0 anlg_rx_adp_vga_sel radp_vga_sel_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1 enable_port_tx_analog_reset_ack 0 \
                                                                                                 enable_port_rx_analog_reset_ack 1"
         set_instance_parameter_value   $rx_phy_name         rcfg_profile_data3                 "support_mode user_mode protocol_mode basic_std pma_mode basic duplex_mode rx channels 1 \
                                                                                                 set_data_rate 1485 rcfg_iface_enable 1 enable_simple_interface 0 enable_split_interface 0 \
                                                                                                 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode not_bonded \
                                                                                                 set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 1 pll_select 0 enable_port_tx_pma_clkout 0 \
                                                                                                 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 \
                                                                                                 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 \
                                                                                                 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 \
                                                                                                 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 \
                                                                                                 set_cdr_refclk_freq 148.500000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual \
                                                                                                 rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 \
                                                                                                 enable_ports_adaptation 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 1 \
                                                                                                 rx_pma_div_clkout_divider 2 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 \
                                                                                                 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 \
                                                                                                 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 \
                                                                                                 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 \
                                                                                                 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 \
                                                                                                 std_tx_pcfifo_mode low_latency std_rx_pcfifo_mode low_latency enable_port_tx_std_pcfifo_full 0 \
                                                                                                 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 \
                                                                                                 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode Disabled \
                                                                                                 std_rx_byte_deser_mode {Deserialize x2} std_tx_8b10b_enable 0 std_tx_8b10b_disp_ctrl_enable 0 \
                                                                                                 std_rx_8b10b_enable 0 std_rx_rmfifo_mode disabled std_rx_rmfifo_pattern_n 0 \
                                                                                                 std_rx_rmfifo_pattern_p 0 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 \
                                                                                                 pcie_rate_match Bypass std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 \
                                                                                                 std_rx_word_aligner_mode bitslip std_rx_word_aligner_pattern_len 7 \
                                                                                                 std_rx_word_aligner_pattern 0 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 3 \
                                                                                                 std_rx_word_aligner_rgnumber 3 std_rx_word_aligner_fast_sync_status_enable 0 \
                                                                                                 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 \
                                                                                                 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 \
                                                                                                 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 \
                                                                                                 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 \
                                                                                                 std_rx_polinv_enable 0 enable_port_rx_polinv 0 enable_port_rx_std_signaldetect 0 \
                                                                                                 enable_ports_pipe_sw 0 enable_ports_pipe_hclk 0 enable_ports_pipe_g3_analog 0 \
                                                                                                 enable_ports_pipe_rx_elecidle 0 enable_port_pipe_rx_polarity 0 enh_pcs_pma_width 64 \
                                                                                                 enh_pld_pcs_width 64 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 \
                                                                                                 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 \
                                                                                                 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 \
                                                                                                 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 \
                                                                                                 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 \
                                                                                                 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 \
                                                                                                 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 \
                                                                                                 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 \
                                                                                                 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 \
                                                                                                 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 \
                                                                                                 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 \
                                                                                                 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 \
                                                                                                 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 \
                                                                                                 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 \
                                                                                                 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 \
                                                                                                 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 \
                                                                                                 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 \
                                                                                                 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 \
                                                                                                 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 \
                                                                                                 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 \
                                                                                                 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 \
                                                                                                 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 \
                                                                                                 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 \
                                                                                                 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 \
                                                                                                 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 40 anlg_voltage $anlg_volt anlg_link sr
                                                                                                 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 \
                                                                                                 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable \
                                                                                                 anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable non_s1_mode \
                                                                                                 anlg_rx_eq_dc_gain_trim no_dc_gain anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_0 \
                                                                                                 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_0 anlg_rx_adp_vga_sel radp_vga_sel_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1 enable_port_tx_analog_reset_ack 0 \
                                                                                                 enable_port_rx_analog_reset_ack 1"
      } elseif {$video_std == "tr"} {
         set_instance_parameter_value   $rx_phy_name         rcfg_profile_cnt                   2
         set_instance_parameter_value   $rx_phy_name         rcfg_profile_data0                 "support_mode user_mode protocol_mode basic_std pma_mode basic duplex_mode rx channels 1 \
                                                                                                 set_data_rate 2970 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 \
                                                                                                 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode not_bonded \
                                                                                                 set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 1 pll_select 0 enable_port_tx_pma_clkout 0 \
                                                                                                 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 \
                                                                                                 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 \
                                                                                                 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 \
                                                                                                 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 \
                                                                                                 set_cdr_refclk_freq 148.500000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual \
                                                                                                 rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 \
                                                                                                 enable_ports_adaptation 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 \
                                                                                                 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 \
                                                                                                 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 \
                                                                                                 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 \
                                                                                                 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 \
                                                                                                 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 \
                                                                                                 std_tx_pcfifo_mode low_latency std_rx_pcfifo_mode low_latency enable_port_tx_std_pcfifo_full 0 \
                                                                                                 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 \
                                                                                                 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode Disabled \
                                                                                                 std_rx_byte_deser_mode {Deserialize x2} std_tx_8b10b_enable 0 std_tx_8b10b_disp_ctrl_enable 0 \
                                                                                                 std_rx_8b10b_enable 0 std_rx_rmfifo_mode disabled std_rx_rmfifo_pattern_n 0 \
                                                                                                 std_rx_rmfifo_pattern_p 0 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 \
                                                                                                 pcie_rate_match Bypass std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 \
                                                                                                 std_rx_word_aligner_mode bitslip std_rx_word_aligner_pattern_len 7 \
                                                                                                 std_rx_word_aligner_pattern 0 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 3 \
                                                                                                 std_rx_word_aligner_rgnumber 3 std_rx_word_aligner_fast_sync_status_enable 0 \
                                                                                                 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 \
                                                                                                 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 \
                                                                                                 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 \
                                                                                                 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 \
                                                                                                 std_rx_polinv_enable 0 enable_port_rx_polinv 0 enable_port_rx_std_signaldetect 0 \
                                                                                                 enable_ports_pipe_sw 0 enable_ports_pipe_hclk 0 enable_ports_pipe_g3_analog 0 \
                                                                                                 enable_ports_pipe_rx_elecidle 0 enable_port_pipe_rx_polarity 0 enh_pcs_pma_width 40 \
                                                                                                 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 \
                                                                                                 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 \
                                                                                                 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 \
                                                                                                 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 \
                                                                                                 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 \
                                                                                                 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 \
                                                                                                 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 enable_port_rx_enh_fifo_empty 0 \
                                                                                                 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 enable_port_rx_enh_fifo_del 0 \
                                                                                                 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 \
                                                                                                 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 \
                                                                                                 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 \
                                                                                                 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 \
                                                                                                 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 \
                                                                                                 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 \
                                                                                                 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 \
                                                                                                 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 \
                                                                                                 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 \
                                                                                                 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 \
                                                                                                 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 \
                                                                                                 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 \
                                                                                                 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 \
                                                                                                 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 \
                                                                                                 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 \
                                                                                                 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 \
                                                                                                 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 anlg_voltage $anlg_volt anlg_link sr \
                                                                                                 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 \
                                                                                                 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable \
                                                                                                 anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable non_s1_mode \
                                                                                                 anlg_rx_eq_dc_gain_trim no_dc_gain anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_0 \
                                                                                                 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_0 anlg_rx_adp_vga_sel radp_vga_sel_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1 enable_port_tx_analog_reset_ack 0 \
                                                                                                 enable_port_rx_analog_reset_ack 1"
         set_instance_parameter_value   $rx_phy_name         rcfg_profile_data1                 "support_mode user_mode protocol_mode basic_std pma_mode basic duplex_mode rx channels 1 \
                                                                                                 set_data_rate 1485 rcfg_iface_enable 0 enable_simple_interface 0 enable_split_interface 0 \
                                                                                                 set_enable_calibration 1 enable_parallel_loopback 0 bonded_mode not_bonded \
                                                                                                 set_pcs_bonding_master Auto tx_pma_clk_div 1 plls 1 pll_select 0 enable_port_tx_pma_clkout 0 \
                                                                                                 enable_port_tx_pma_div_clkout 0 tx_pma_div_clkout_divider 0 enable_port_tx_pma_iqtxrx_clkout 0 \
                                                                                                 enable_port_tx_pma_elecidle 0 enable_port_tx_pma_qpipullup 0 enable_port_tx_pma_qpipulldn 0 \
                                                                                                 enable_port_tx_pma_txdetectrx 0 enable_port_tx_pma_rxfound 0 enable_port_rx_seriallpbken_tx 0 \
                                                                                                 number_physical_bonding_clocks 1 cdr_refclk_cnt 1 cdr_refclk_select 0 \
                                                                                                 set_cdr_refclk_freq 148.500000 rx_ppm_detect_threshold 1000 rx_pma_ctle_adaptation_mode manual \
                                                                                                 rx_pma_dfe_adaptation_mode disabled rx_pma_dfe_fixed_taps 3 \
                                                                                                 enable_ports_adaptation 0 enable_port_rx_pma_clkout 0 enable_port_rx_pma_div_clkout 0 \
                                                                                                 rx_pma_div_clkout_divider 0 enable_port_rx_pma_iqtxrx_clkout 0 enable_port_rx_pma_clkslip 0 \
                                                                                                 enable_port_rx_pma_qpipulldn 0 enable_port_rx_is_lockedtodata 1 enable_port_rx_is_lockedtoref 1 \
                                                                                                 enable_ports_rx_manual_cdr_mode 1 enable_ports_rx_manual_ppm 0 enable_port_rx_signaldetect 0 \
                                                                                                 enable_port_rx_seriallpbken 0 enable_ports_rx_prbs 0 std_pcs_pma_width 10 \
                                                                                                 std_low_latency_bypass_enable 0 enable_hip 0 enable_hard_reset 0 set_hip_cal_en 0 \
                                                                                                 std_tx_pcfifo_mode low_latency std_rx_pcfifo_mode low_latency enable_port_tx_std_pcfifo_full 0 \
                                                                                                 enable_port_tx_std_pcfifo_empty 0 enable_port_rx_std_pcfifo_full 0 \
                                                                                                 enable_port_rx_std_pcfifo_empty 0 std_tx_byte_ser_mode Disabled \
                                                                                                 std_rx_byte_deser_mode {Deserialize x2} std_tx_8b10b_enable 0 std_tx_8b10b_disp_ctrl_enable 0 \
                                                                                                 std_rx_8b10b_enable 0 std_rx_rmfifo_mode disabled std_rx_rmfifo_pattern_n 0 \
                                                                                                 std_rx_rmfifo_pattern_p 0 enable_port_rx_std_rmfifo_full 0 enable_port_rx_std_rmfifo_empty 0 \
                                                                                                 pcie_rate_match Bypass std_tx_bitslip_enable 0 enable_port_tx_std_bitslipboundarysel 0 \
                                                                                                 std_rx_word_aligner_mode bitslip std_rx_word_aligner_pattern_len 7 \
                                                                                                 std_rx_word_aligner_pattern 0 std_rx_word_aligner_rknumber 3 std_rx_word_aligner_renumber 3 \
                                                                                                 std_rx_word_aligner_rgnumber 3 std_rx_word_aligner_fast_sync_status_enable 0 \
                                                                                                 enable_port_rx_std_wa_patternalign 0 enable_port_rx_std_wa_a1a2size 0 \
                                                                                                 enable_port_rx_std_bitslipboundarysel 0 enable_port_rx_std_bitslip 0 std_tx_bitrev_enable 0 \
                                                                                                 std_tx_byterev_enable 0 std_tx_polinv_enable 0 enable_port_tx_polinv 0 std_rx_bitrev_enable 0 \
                                                                                                 enable_port_rx_std_bitrev_ena 0 std_rx_byterev_enable 0 enable_port_rx_std_byterev_ena 0 \
                                                                                                 std_rx_polinv_enable 0 enable_port_rx_polinv 0 enable_port_rx_std_signaldetect 0 \
                                                                                                 enable_ports_pipe_sw 0 enable_ports_pipe_hclk 0 enable_ports_pipe_g3_analog 0 \
                                                                                                 enable_ports_pipe_rx_elecidle 0 enable_port_pipe_rx_polarity 0 enh_pcs_pma_width 40 \
                                                                                                 enh_pld_pcs_width 40 enh_low_latency_enable 0 enh_rxtxfifo_double_width 0 \
                                                                                                 enh_txfifo_mode {Phase compensation} enh_txfifo_pfull 11 enh_txfifo_pempty 2 \
                                                                                                 enable_port_tx_enh_fifo_full 0 enable_port_tx_enh_fifo_pfull 0 enable_port_tx_enh_fifo_empty 0 \
                                                                                                 enable_port_tx_enh_fifo_pempty 0 enable_port_tx_enh_fifo_cnt 0 \
                                                                                                 enh_rxfifo_mode {Phase compensation} enh_rxfifo_pfull 23 enh_rxfifo_pempty 2 \
                                                                                                 enh_rxfifo_align_del 0 enh_rxfifo_control_del 0 enable_port_rx_enh_data_valid 0 \
                                                                                                 enable_port_rx_enh_fifo_full 0 enable_port_rx_enh_fifo_pfull 0 \
                                                                                                 enable_port_rx_enh_fifo_empty 0 enable_port_rx_enh_fifo_pempty 0 enable_port_rx_enh_fifo_cnt 0 \
                                                                                                 enable_port_rx_enh_fifo_del 0 enable_port_rx_enh_fifo_insert 0 enable_port_rx_enh_fifo_rd_en 0 \
                                                                                                 enable_port_rx_enh_fifo_align_val 0 enable_port_rx_enh_fifo_align_clr 0 enh_tx_frmgen_enable 0 \
                                                                                                 enh_tx_frmgen_mfrm_length 2048 enh_tx_frmgen_burst_enable 0 enable_port_tx_enh_frame 0 \
                                                                                                 enable_port_tx_enh_frame_diag_status 0 enable_port_tx_enh_frame_burst_en 0 \
                                                                                                 enh_rx_frmsync_enable 0 enh_rx_frmsync_mfrm_length 2048 enable_port_rx_enh_frame 0 \
                                                                                                 enable_port_rx_enh_frame_lock 0 enable_port_rx_enh_frame_diag_status 0 enh_tx_crcgen_enable 0 \
                                                                                                 enh_tx_crcerr_enable 0 enh_rx_crcchk_enable 0 enable_port_rx_enh_crc32_err 0 \
                                                                                                 enable_port_rx_enh_highber 0 enable_port_rx_enh_highber_clr_cnt 0 \
                                                                                                 enable_port_rx_enh_clr_errblk_count 0 enh_tx_64b66b_enable 0 enh_rx_64b66b_enable 0 \
                                                                                                 enh_tx_sh_err 0 enh_tx_scram_enable 0 enh_tx_scram_seed 0 enh_rx_descram_enable 0 \
                                                                                                 enh_tx_dispgen_enable 0 enh_rx_dispchk_enable 0 enh_tx_randomdispbit_enable 0 \
                                                                                                 enh_rx_blksync_enable 0 enable_port_rx_enh_blk_lock 0 enh_tx_bitslip_enable 0 \
                                                                                                 enh_tx_polinv_enable 0 enh_rx_bitslip_enable 0 enh_rx_polinv_enable 0 \
                                                                                                 enable_port_tx_enh_bitslip 0 enable_port_rx_enh_bitslip 0 enh_rx_krfec_err_mark_enable 0 \
                                                                                                 enh_rx_krfec_err_mark_type 10G enh_tx_krfec_burst_err_enable 0 enh_tx_krfec_burst_err_len 1 \
                                                                                                 enable_port_krfec_tx_enh_frame 0 enable_port_krfec_rx_enh_frame 0 \
                                                                                                 enable_port_krfec_rx_enh_frame_diag_status 0 pcs_direct_width 8 anlg_voltage $anlg_volt anlg_link sr
                                                                                                 enable_analog_settings 0 anlg_tx_analog_mode user_custom anlg_enable_tx_default_ovr 0 \
                                                                                                 anlg_tx_vod_output_swing_ctrl 0 anlg_tx_pre_emp_sign_pre_tap_1t fir_pre_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_1t 0 anlg_tx_pre_emp_sign_pre_tap_2t fir_pre_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_pre_tap_2t 0 anlg_tx_pre_emp_sign_1st_post_tap fir_post_1t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_1st_post_tap 0 anlg_tx_pre_emp_sign_2nd_post_tap fir_post_2t_neg \
                                                                                                 anlg_tx_pre_emp_switching_ctrl_2nd_post_tap 0 anlg_tx_slew_rate_ctrl slew_r7 anlg_tx_compensation_en enable \
                                                                                                 anlg_tx_term_sel r_r1 anlg_enable_rx_default_ovr 0 anlg_rx_one_stage_enable non_s1_mode \
                                                                                                 anlg_rx_eq_dc_gain_trim no_dc_gain anlg_rx_adp_ctle_acgain_4s radp_ctle_acgain_4s_0 \
                                                                                                 anlg_rx_adp_ctle_eqz_1s_sel radp_ctle_eqz_1s_sel_0 anlg_rx_adp_vga_sel radp_vga_sel_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap1 radp_dfe_fxtap1_0 anlg_rx_adp_dfe_fxtap2 radp_dfe_fxtap2_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap3 radp_dfe_fxtap3_0 anlg_rx_adp_dfe_fxtap4 radp_dfe_fxtap4_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap5 radp_dfe_fxtap5_0 anlg_rx_adp_dfe_fxtap6 radp_dfe_fxtap6_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap7 radp_dfe_fxtap7_0 anlg_rx_adp_dfe_fxtap8 radp_dfe_fxtap8_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap9 radp_dfe_fxtap9_0 anlg_rx_adp_dfe_fxtap10 radp_dfe_fxtap10_0 \
                                                                                                 anlg_rx_adp_dfe_fxtap11 radp_dfe_fxtap11_0 anlg_rx_term_sel r_r1 enable_port_tx_analog_reset_ack 0 \
                                                                                                 enable_port_rx_analog_reset_ack 1"
      }

      if { $video_std == "dl" } {
         add_instance                   ${tx_phy_name}_b      altera_xcvr_native_a10
         set_instance_parameter_value   ${tx_phy_name}_b      set_data_rate                         $data_rate
         set_instance_parameter_value   ${tx_phy_name}_b      std_tx_byte_ser_mode                  $tx_ser_mode
         set_instance_parameter_value   ${tx_phy_name}_b      duplex_mode                           "tx"
         set_instance_parameter_value   ${tx_phy_name}_b      tx_pma_clk_div                        $pma_clk_div
         set_instance_parameter_value   ${tx_phy_name}_b      anlg_voltage                          $anlg_volt
         set_instance_parameter_value   ${tx_phy_name}_b      anlg_link                             "sr"
         if { $txpll_switch == "1"  } {
            set_instance_parameter_value   ${tx_phy_name}_b   plls          2
            set_instance_parameter_value   ${tx_phy_name}_b   rcfg_enable   1
            set_instance_parameter_value   ${tx_phy_name}_b   rcfg_sv_file_enable   1
            set_instance_parameter_value   ${tx_phy_name}_b   enable_port_tx_analog_reset_ack   1
         }

         add_instance                   ${rx_phy_name}_b      altera_xcvr_native_a10
         set_instance_parameter_value   ${rx_phy_name}_b      set_data_rate                         $data_rate
         set_instance_parameter_value   ${rx_phy_name}_b      set_cdr_refclk_freq                   "148.500"
         set_instance_parameter_value   ${rx_phy_name}_b      enable_ports_rx_manual_cdr_mode       1
         set_instance_parameter_value   ${rx_phy_name}_b      std_rx_byte_deser_mode                $rx_deser_mode
         set_instance_parameter_value   ${rx_phy_name}_b      duplex_mode   "rx"
         set_instance_parameter_value   ${rx_phy_name}_b      anlg_voltage                          $anlg_volt
         set_instance_parameter_value   ${rx_phy_name}_b      anlg_link                             "sr"
      }
   }

   add_instance                   ${ch}_tx_xcvr_rst_ctrl   altera_xcvr_reset_control
   set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   SYNCHRONIZE_RESET         0
   set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   TX_PLL_ENABLE             1
   set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   TX_ENABLE                 1
   set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   T_TX_ANALOGRESET          70000
   set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   T_TX_DIGITALRESET         70000
   set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   RX_ENABLE                 0
   set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   gui_tx_auto_reset         0
   if { $video_std == "mr" } {
      set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   SYS_CLK_IN_MHZ            297
   } else {
      set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   SYS_CLK_IN_MHZ            149
   }
   if { $txpll_switch == "1" } {
      set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   PLLS                      2
   } else {
      set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   PLLS                      1
   }
   if { $video_std == "dl" } {
      set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl   CHANNELS                  2
   }

   add_instance                   ${ch}_rx_xcvr_rst_ctrl   altera_xcvr_reset_control
   set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl   SYS_CLK_IN_MHZ            149
   set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl   SYNCHRONIZE_RESET         0
   set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl   TX_PLL_ENABLE             0
   set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl   TX_ENABLE                 0
   set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl   RX_ENABLE                 1
   set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl   RX_PER_CHANNEL            1
   set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl   T_RX_ANALOGRESET          70000
   set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl   gui_rx_auto_reset         2
   if { $video_std == "dl" } {
      set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl   CHANNELS                      2
   }
   
   if { $video_std == "tr" | $video_std == "mr" } {
      add_instance                   ${ch}_reconfig   sdi_ii_ed_reconfig_a10
      set_instance_parameter_value   ${ch}_reconfig   VIDEO_STANDARD   $video_std
   }

   if { $txpll_switch != "0" } {
      add_instance                   ${ch}_tx_reconfig   sdi_ii_ed_reconfig_a10
      set_instance_parameter_value   ${ch}_tx_reconfig   ED_TXPLL_SWITCH   $txpll_switch
      if { $video_std == "dl" } {
         set_instance_parameter_value   ${ch}_tx_reconfig   VIDEO_STANDARD   $video_std
      }
      if { [get_parameter_value ED_TXPLL_TYPE] == "ATX" } {
         set_instance_parameter_value   ${ch}_tx_reconfig   XCVR_RCFG_IF_TYPE   "atx_pll"
      } elseif { [get_parameter_value ED_TXPLL_TYPE] == "fPLL" } {
         set_instance_parameter_value   ${ch}_tx_reconfig   XCVR_RCFG_IF_TYPE   "fpll"
      } else {
         set_instance_parameter_value   ${ch}_tx_reconfig   XCVR_RCFG_IF_TYPE   "channel"
      }
      if { $txpll_switch == "1" && $video_std == "dl" } {
         add_instance                   ${ch}_tx_reconfig_b   sdi_ii_ed_reconfig_a10
         set_instance_parameter_value   ${ch}_tx_reconfig_b   ED_TXPLL_SWITCH   $txpll_switch
         set_instance_parameter_value   ${ch}_tx_reconfig_b   VIDEO_STANDARD    $video_std
      }
   }

   add_clk_bridge  ${ch}_tx_pll_refclk
   if { $video_std == "mr" } {
      set_instance_parameter_value   ${ch}_tx_pll_refclk_bridge   EXPLICIT_CLOCK_RATE "297000000"
   } else {
      set_instance_parameter_value   ${ch}_tx_pll_refclk_bridge   EXPLICIT_CLOCK_RATE "148500000"
   }

    if { $txpll_switch != "0" } {
        add_clk_bridge  ${ch}_tx_pll_refclk_alt

        if { $txpll_switch == "2" & $video_std == "mr" } {
            set_instance_parameter_value   ${ch}_tx_pll_refclk_alt_bridge   EXPLICIT_CLOCK_RATE "297000000"
        } elseif { $txpll_switch == "2" } {
            set_instance_parameter_value   ${ch}_tx_pll_refclk_alt_bridge   EXPLICIT_CLOCK_RATE "148500000"
        } elseif { $txpll_switch == "1" & $video_std == "mr" } {
            set_instance_parameter_value   ${ch}_tx_pll_refclk_alt_bridge   EXPLICIT_CLOCK_RATE "296700000"
        } else {
            set_instance_parameter_value   ${ch}_tx_pll_refclk_alt_bridge   EXPLICIT_CLOCK_RATE "148350000"
        }
    }
   add_clk_bridge  ${ch}_rx_cdr_refclk
   add_clk_bridge  ${ch}_rx_coreclk
   add_clk_bridge  ${ch}_tx_xcvr_rst_ctrl_clk
   if { $video_std == "tr" | $video_std == "ds" | $video_std == "mr" | $txpll_switch != "0" } {
      add_clk_bridge  ${ch}_reconfig_clk
   }
   add_rst_bridge  ${ch}_tx
   add_rst_bridge  ${ch}_rx
   if { $video_std == "tr" | $video_std == "mr" | $txpll_switch != "0" } {
      add_rst_bridge  ${ch}_reconfig
   }

   add_instance                   ${tx_phy_name}_tx_clkout_fanout     altera_fanout
   set_instance_parameter_value         ${tx_phy_name}_tx_clkout_fanout     SPECIFY_SIGNAL_TYPE         1
   set_instance_parameter_value         ${tx_phy_name}_tx_clkout_fanout     SIGNAL_TYPE            clk
   if { $video_std == "dl" } {
      set_instance_parameter_value         ${tx_phy_name}_tx_clkout_fanout     NUM_FANOUT                  3
   }

   add_instance                   ${rx_phy_name}_rx_clkout_fanout     altera_fanout
   set_instance_parameter_value         ${rx_phy_name}_rx_clkout_fanout     SPECIFY_SIGNAL_TYPE         1
   set_instance_parameter_value         ${rx_phy_name}_rx_clkout_fanout     SIGNAL_TYPE            clk

   add_instance                   ${ch}_phy_adapter_rx_clkout_fanout     altera_fanout
   set_instance_parameter_value         ${ch}_phy_adapter_rx_clkout_fanout     TYPE_FANOUT            clock
   add_instance                   ${ch}_phy_adapter_tx_clkout_fanout     altera_fanout
   set_instance_parameter_value         ${ch}_phy_adapter_tx_clkout_fanout     TYPE_FANOUT            clock

   add_instance                   ${ch}_rx_xcvr_rst_ctrl_reset_sync             altera_reset_controller
   set_instance_parameter_value   ${ch}_rx_xcvr_rst_ctrl_reset_sync             NUM_RESET_INPUTS            1

   add_instance                   ${ch}_tx_xcvr_rst_ctrl_reset_sync             altera_reset_controller
   if { $txpll_switch != "0" } {
     if {$txpll_switch == "1" & $video_std == "dl"} {
        set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl_reset_sync             NUM_RESET_INPUTS            3
     } else {
        set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl_reset_sync             NUM_RESET_INPUTS            2
     }
   } else {
     set_instance_parameter_value   ${ch}_tx_xcvr_rst_ctrl_reset_sync             NUM_RESET_INPUTS            1
   }

   add_instance                   ${rx_inst_name}_rx_set_locktoref_fanout     altera_fanout
   set_instance_parameter_value         ${rx_inst_name}_rx_set_locktoref_fanout     SPECIFY_SIGNAL_TYPE         1
   set_instance_parameter_value         ${rx_inst_name}_rx_set_locktoref_fanout     SIGNAL_TYPE            rx_set_locktoref
   
   add_instance                   ${rx_phy_name}_rx_is_lockedtoref_fanout     altera_fanout
   set_instance_parameter_value         ${rx_phy_name}_rx_is_lockedtoref_fanout     SPECIFY_SIGNAL_TYPE         1
   set_instance_parameter_value         ${rx_phy_name}_rx_is_lockedtoref_fanout     SIGNAL_TYPE            rx_is_lockedtoref
   
   add_instance                   ${rx_phy_name}_rx_is_lockedtodata_fanout    altera_fanout
   set_instance_parameter_value         ${rx_phy_name}_rx_is_lockedtodata_fanout    SPECIFY_SIGNAL_TYPE         1
   set_instance_parameter_value         ${rx_phy_name}_rx_is_lockedtodata_fanout    SIGNAL_TYPE            rx_is_lockedtodata

   add_instance                   ${ch}_tx_pll_pll_locked_fanout                altera_fanout
   set_instance_parameter_value         ${ch}_tx_pll_pll_locked_fanout                SPECIFY_SIGNAL_TYPE         1
   set_instance_parameter_value         ${ch}_tx_pll_pll_locked_fanout                SIGNAL_TYPE            pll_locked

   add_instance                   ${ch}_rx_xcvr_rst_ctrl_rx_ready_fanout        altera_fanout
   set_instance_parameter_value         ${ch}_rx_xcvr_rst_ctrl_rx_ready_fanout        SPECIFY_SIGNAL_TYPE         1
   set_instance_parameter_value         ${ch}_rx_xcvr_rst_ctrl_rx_ready_fanout        SIGNAL_TYPE            rx_ready
   if { $video_std == "dl" } {
      set_instance_parameter_value         ${ch}_rx_xcvr_rst_ctrl_rx_ready_fanout        WIDTH                  2
      set_instance_parameter_value         ${ch}_rx_xcvr_rst_ctrl_rx_ready_fanout        NUM_FANOUT                  2
   } else {
      set_instance_parameter_value         ${ch}_rx_xcvr_rst_ctrl_rx_ready_fanout        NUM_FANOUT                  3
   }

   if { $video_std == "dl" } {
      add_instance                   ${rx_phy_name}_b_rx_clkout_fanout     altera_fanout
      set_instance_parameter_value         ${rx_phy_name}_b_rx_clkout_fanout     SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${rx_phy_name}_b_rx_clkout_fanout     SIGNAL_TYPE                 clk

      add_instance                   ${rx_inst_name}_rx_set_locktoref_b_fanout     altera_fanout
      set_instance_parameter_value         ${rx_inst_name}_rx_set_locktoref_b_fanout     SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${rx_inst_name}_rx_set_locktoref_b_fanout     SIGNAL_TYPE            rx_set_locktoref

      add_instance                   ${rx_phy_name}_b_rx_is_lockedtoref_fanout     altera_fanout
      set_instance_parameter_value         ${rx_phy_name}_b_rx_is_lockedtoref_fanout     SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${rx_phy_name}_b_rx_is_lockedtoref_fanout     SIGNAL_TYPE            rx_is_lockedtoref

      add_instance                   ${rx_phy_name}_b_rx_is_lockedtodata_fanout    altera_fanout
      set_instance_parameter_value         ${rx_phy_name}_b_rx_is_lockedtodata_fanout    SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${rx_phy_name}_b_rx_is_lockedtodata_fanout    SIGNAL_TYPE            rx_is_lockedtodata

      add_instance                   ${ch}_phy_adapter_tx_serial_clk_fanout        altera_fanout
      set_instance_parameter_value         ${ch}_phy_adapter_tx_serial_clk_fanout        SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${ch}_phy_adapter_tx_serial_clk_fanout        SIGNAL_TYPE            clk
   }

   if { $txpll_switch == "1" } {
      add_instance                   ${ch}_tx_pll_alt_pll_locked_fanout                altera_fanout
      set_instance_parameter_value         ${ch}_tx_pll_alt_pll_locked_fanout                SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${ch}_tx_pll_alt_pll_locked_fanout                SIGNAL_TYPE            pll_locked
      
      add_instance                   ${ch}_phy_adapter_tx_cal_busy_out_fanout                altera_fanout
      set_instance_parameter_value         ${ch}_phy_adapter_tx_cal_busy_out_fanout                SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${ch}_phy_adapter_tx_cal_busy_out_fanout                SIGNAL_TYPE            tx_cal_busy

      if { $video_std == "dl" } {
         set_instance_parameter_value         ${ch}_phy_adapter_tx_cal_busy_out_fanout          WIDTH                  2
         set_instance_parameter_value         ${ch}_phy_adapter_tx_cal_busy_out_fanout          NUM_FANOUT             3
      
         add_instance                   ${ch}_phy_adapter_tx_serial_clk_alt_fanout        altera_fanout
         set_instance_parameter_value         ${ch}_phy_adapter_tx_serial_clk_alt_fanout        SPECIFY_SIGNAL_TYPE         1
         set_instance_parameter_value         ${ch}_phy_adapter_tx_serial_clk_alt_fanout        SIGNAL_TYPE            clk
      }
   } elseif { $txpll_switch == "2" } {
      add_instance                   ${ch}_tx_xcvr_rst_ctrl_pll_powerdown_fanout                altera_fanout
      set_instance_parameter_value         ${ch}_tx_xcvr_rst_ctrl_pll_powerdown_fanout                SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${ch}_tx_xcvr_rst_ctrl_pll_powerdown_fanout                SIGNAL_TYPE            pll_powerdown
   }

   if { $ch != "ch2" } {
      add_instance                   ${tx_inst_name}_tx_dataout_valid_fanout       altera_fanout
      if { $ch == "ch0" & $video_std == "dl" } {
         add_instance                   ${tx_inst_name}_tx_dataout_valid_b_fanout       altera_fanout
      }
   }
   
   if { $txpll_switch == "1" & ($video_std == "ds" | $video_std == "tr" | $video_std == "dl" | $video_std == "mr") } {
      add_instance                   ${ch}_phy_adapter_reconfig_clk_fanout        altera_fanout
      set_instance_parameter_value         ${ch}_phy_adapter_reconfig_clk_fanout        SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${ch}_phy_adapter_reconfig_clk_fanout        SIGNAL_TYPE            clk
      add_instance                   ${ch}_phy_adapter_reconfig_rst_fanout        altera_fanout
      set_instance_parameter_value         ${ch}_phy_adapter_reconfig_rst_fanout        SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${ch}_phy_adapter_reconfig_rst_fanout        SIGNAL_TYPE            reset
   }
   
   if { ($video_std == "tr" | $video_std == "mr") } {
      add_instance                   ${rx_phy_name}_rx_cal_busy_fanout       altera_fanout
      set_instance_parameter_value         ${rx_phy_name}_rx_cal_busy_fanout       SPECIFY_SIGNAL_TYPE         1
      set_instance_parameter_value         ${rx_phy_name}_rx_cal_busy_fanout       SIGNAL_TYPE            rx_cal_busy
   }

   if { $ch == "ch0" } {
      add_instance                   ${rx_inst_name}_rx_trs_locked_fanout          altera_fanout
      set_instance_parameter_value         ${rx_inst_name}_rx_trs_locked_fanout          WIDTH                       [expr 1*$num_streams]
      add_instance                   ${rx_inst_name}_rx_frame_locked_fanout        altera_fanout
      add_instance                   ${rx_inst_name}_rx_dataout_fanout             altera_fanout
      set_instance_parameter_value         ${rx_inst_name}_rx_dataout_fanout             WIDTH                       [expr 20*$num_streams]
      add_instance                   ${rx_inst_name}_rx_dataout_valid_fanout       altera_fanout
      add_instance                   ${rx_inst_name}_rx_rst_proto_out_fanout       altera_fanout

      if { $video_std == "tr" | $video_std == "ds" | $video_std == "mr" } {
         add_instance                   ${ch}_reconfig_cdr_reconfig_busy_fanout   altera_fanout
      }

      if { $video_std == "mr" | $video_std == "tr" | $video_std == "ds" | $video_std == "threeg" } {
         add_instance                   ${rx_inst_name}_rx_std_fanout             altera_fanout
         set_instance_parameter_value         ${rx_inst_name}_rx_std_fanout             WIDTH                       3
         
         if { $video_std == "mr" } {
            set_instance_parameter_value         ${rx_inst_name}_rx_std_fanout             NUM_FANOUT                  4
         } elseif { $video_std == "tr" | $video_std == "ds" } {
            set_instance_parameter_value         ${rx_inst_name}_rx_std_fanout             NUM_FANOUT                  3
         }
      }

      if { $video_std == "dl" } {
         add_instance                   ${rx_inst_name}_rx_dataout_b_fanout             altera_fanout
         set_instance_parameter_value         ${rx_inst_name}_rx_dataout_b_fanout             WIDTH                       20
         add_instance                   ${rx_inst_name}_rx_dataout_valid_b_fanout       altera_fanout
      }
   
      if { $vpid_extract } {
         if {$video_std != "sd"} {
            add_instance                   ${rx_inst_name}_rx_ln_fanout         altera_fanout
            set_instance_parameter_value         ${rx_inst_name}_rx_ln_fanout         WIDTH                       [expr 11*$num_streams]
         }
         add_instance                   ${rx_inst_name}_rx_vpid_byte1_fanout         altera_fanout
         set_instance_parameter_value         ${rx_inst_name}_rx_vpid_byte1_fanout         WIDTH                       [expr 8*$num_streams]
         add_instance                   ${rx_inst_name}_rx_vpid_byte2_fanout         altera_fanout
         set_instance_parameter_value         ${rx_inst_name}_rx_vpid_byte2_fanout         WIDTH                       [expr 8*$num_streams]
         add_instance                   ${rx_inst_name}_rx_vpid_byte3_fanout         altera_fanout
         set_instance_parameter_value         ${rx_inst_name}_rx_vpid_byte3_fanout         WIDTH                       [expr 8*$num_streams]
         add_instance                   ${rx_inst_name}_rx_vpid_byte4_fanout         altera_fanout
         set_instance_parameter_value         ${rx_inst_name}_rx_vpid_byte4_fanout         WIDTH                       [expr 8*$num_streams]
         add_instance                   ${rx_inst_name}_rx_line_f0_fanout         altera_fanout
         set_instance_parameter_value         ${rx_inst_name}_rx_line_f0_fanout         WIDTH                       [expr 11*$num_streams]
         add_instance                   ${rx_inst_name}_rx_line_f1_fanout         altera_fanout
         set_instance_parameter_value         ${rx_inst_name}_rx_line_f1_fanout         WIDTH                       [expr 11*$num_streams]

         if { $video_std == "threeg" | $video_std == "dl" | $video_std == "tr" | $video_std == "mr" } {
            add_instance                   ${rx_inst_name}_rx_ln_b_fanout         altera_fanout
            set_instance_parameter_value         ${rx_inst_name}_rx_ln_b_fanout         WIDTH                       [expr 11*$num_streams]
            add_instance                   ${rx_inst_name}_rx_vpid_byte1_b_fanout         altera_fanout
            set_instance_parameter_value         ${rx_inst_name}_rx_vpid_byte1_b_fanout         WIDTH                       [expr 8*$num_streams]
            add_instance                   ${rx_inst_name}_rx_vpid_byte2_b_fanout         altera_fanout
            set_instance_parameter_value         ${rx_inst_name}_rx_vpid_byte2_b_fanout         WIDTH                       [expr 8*$num_streams]
            add_instance                   ${rx_inst_name}_rx_vpid_byte3_b_fanout         altera_fanout
            set_instance_parameter_value         ${rx_inst_name}_rx_vpid_byte3_b_fanout         WIDTH                       [expr 8*$num_streams]
            add_instance                   ${rx_inst_name}_rx_vpid_byte4_b_fanout         altera_fanout
            set_instance_parameter_value         ${rx_inst_name}_rx_vpid_byte4_b_fanout         WIDTH                       [expr 8*$num_streams]
         }
      }
   } elseif { $ch == "ch1" } {
      if { $video_std == "tr" | $video_std == "ds" | $video_std == "mr" } {
         add_instance                   ${ch}_reconfig_cdr_reconfig_busy_fanout   altera_fanout
         add_instance                   ${rx_inst_name}_rx_std_fanout         altera_fanout
         set_instance_parameter_value         ${rx_inst_name}_rx_std_fanout         WIDTH                       3
         if {$video_std == "mr" } {
            set_instance_parameter_value      ${rx_inst_name}_rx_std_fanout         NUM_FANOUT                  3
         }
      }

      if { $txpll_switch == "1" } {
         add_instance                   ${ch}_tx_reconfig_pll_sel_fanout   altera_fanout
      }

      # if { $vpid_insert } {
         # add_instance            pattgen_line_f0_fanout               altera_fanout
         # set_instance_parameter_value  pattgen_line_f0_fanout               WIDTH 11
         # add_instance            pattgen_line_f1_fanout               altera_fanout
         # set_instance_parameter_value  pattgen_line_f1_fanout               WIDTH 11
      # }

        if { $cmp_data } {
            add_instance                        pattgen_dout_fanout         altera_fanout
            if {$video_std == "mr" } {
                set_instance_parameter_value    pattgen_dout_fanout         WIDTH   80
            } else {
                set_instance_parameter_value    pattgen_dout_fanout         WIDTH   20
            }
            add_instance                        pattgen_dout_valid_fanout   altera_fanout

            if { $video_std == "dl"} {
                add_instance            pattgen_dout_b_fanout               altera_fanout
                set_instance_parameter_value  pattgen_dout_b_fanout               WIDTH 20
                add_instance            pattgen_dout_valid_b_fanout               altera_fanout
            }
        }
   }
}

proc add_export_ch_interface {ch tx_inst_name rx_inst_name tx_phy_name rx_phy_name std dir crc_err vpid_insert vpid_extract a2b b2a txpll_switch} {

   add_interface                           ${tx_phy_name}_tx_clkout     clock              start
   set_interface_property                  ${tx_phy_name}_tx_clkout     export_of          ${ch}_phy_adapter_tx_clkout_fanout.sig_fanout0
   set_interface_property                  ${tx_phy_name}_tx_clkout     PORT_NAME_MAP      "${tx_phy_name}_tx_clkout sig_fanout0"
   add_interface                           ${rx_phy_name}_rx_clkout     clock              start
   set_interface_property                  ${rx_phy_name}_rx_clkout     export_of          ${ch}_phy_adapter_rx_clkout_fanout.sig_fanout0
   set_interface_property                  ${rx_phy_name}_rx_clkout     PORT_NAME_MAP      "${rx_phy_name}_rx_clkout sig_fanout0"

   if { $ch == "ch1" } {
      if { $std != "sd" } {
         add_export_rename_interface             $tx_inst_name            tx_enable_ln    conduit input
         add_export_rename_interface             $tx_inst_name            tx_enable_crc    conduit input
      }

      if { $vpid_insert } {
         add_export_rename_interface             $tx_inst_name            tx_vpid_overwrite    conduit input
      }

      if { $std == "threeg" | $std == "ds" | $std == "tr" | $std == "mr" } {
         add_export_rename_interface $tx_inst_name   tx_std          conduit input
      }
   }
   add_export_rename_interface             $tx_phy_name               tx_serial_data     conduit output
   add_export_rename_interface             $rx_phy_name               rx_serial_data     conduit input
   add_export_fanout_rename_interface      $rx_phy_name               rx_is_lockedtoref  conduit output
   add_export_fanout_rename_interface      $rx_phy_name               rx_is_lockedtodata conduit output
   if { $std == "dl" } {
      add_export_rename_interface          ${tx_phy_name}_b             tx_serial_data     conduit output
      add_export_rename_interface          ${rx_phy_name}_b             rx_serial_data     conduit input
      add_export_fanout_rename_interface   ${rx_phy_name}_b             rx_is_lockedtoref  conduit output
      add_export_fanout_rename_interface   ${rx_phy_name}_b             rx_is_lockedtodata conduit output
   }

   add_export_rename_interface             ${ch}_tx_xcvr_rst_ctrl         tx_ready           conduit output
   add_export_fanout_rename_interface      ${ch}_rx_xcvr_rst_ctrl         rx_ready           conduit output
   add_export_fanout_rename_interface      ${ch}_tx_pll                   pll_locked         conduit output
   if { $txpll_switch == "1" } {
      add_export_fanout_rename_interface      ${ch}_tx_pll_alt            pll_locked         conduit output
   }
   add_export_rename_interface             $rx_inst_name                  rx_align_locked    conduit output

   if { $ch == "ch1" & ( $a2b | $b2a ) } {
      set ch1_in_loopback_mode 1
   } else {
      set ch1_in_loopback_mode 0
   }

   if { $ch == "ch0" } {
      add_export_fanout_rename_interface      $rx_inst_name            rx_trs_locked      conduit output
      add_export_fanout_rename_interface      $rx_inst_name            rx_frame_locked    conduit output
      add_export_fanout_rename_interface      $rx_inst_name            rx_rst_proto_out   conduit output
   } else {
      add_export_rename_interface      $rx_inst_name            rx_trs_locked      conduit output
      add_export_rename_interface      $rx_inst_name            rx_frame_locked    conduit output
      add_export_rename_interface      $rx_inst_name            rx_rst_proto_out   conduit output
   }
   
   if { $std == "dl" } {
      add_export_rename_interface             $rx_inst_name            rx_align_locked_b    conduit output
      add_export_rename_interface             $rx_inst_name            rx_trs_locked_b    conduit output
      add_export_rename_interface             $rx_inst_name            rx_frame_locked_b    conduit output
      add_export_rename_interface             $rx_inst_name            rx_dl_locked    conduit output
   }

   if { $ch != "ch2" } {
      add_export_fanout_rename_interface      $tx_inst_name            tx_dataout_valid   conduit output

      if { $ch == "ch0" & $std == "dl" } {
         add_export_fanout_rename_interface      $tx_inst_name            tx_dataout_valid_b   conduit output
      } elseif { $std == "dl" } {
         add_export_rename_interface      $tx_inst_name            tx_dataout_valid_b   conduit output
      }
   }

   if { $ch == "ch0" } {
      add_export_fanout_rename_interface      $rx_inst_name            rx_dataout         conduit output
      add_export_fanout_rename_interface      $rx_inst_name            rx_dataout_valid   conduit output
      if { $std == "dl" } {
         add_export_fanout_rename_interface      $rx_inst_name            rx_dataout_b         conduit output
         add_export_fanout_rename_interface      $rx_inst_name            rx_dataout_valid_b   conduit output
      }   
   } elseif { !$ch1_in_loopback_mode } {
      add_export_rename_interface      $rx_inst_name            rx_dataout         conduit output
      add_export_rename_interface      $rx_inst_name            rx_dataout_valid   conduit output
      if { $std == "dl" } {
         add_export_rename_interface      $rx_inst_name            rx_dataout_b         conduit output
         add_export_rename_interface      $rx_inst_name            rx_dataout_valid_b   conduit output
      }   
   }

   add_export_rename_interface             $rx_inst_name            rx_f               conduit output
   add_export_rename_interface             $rx_inst_name            rx_v               conduit output
   add_export_rename_interface             $rx_inst_name            rx_h               conduit output
   add_export_rename_interface             $rx_inst_name            rx_ap              conduit output
   add_export_rename_interface             $rx_inst_name            rx_format          conduit output
   add_export_rename_interface             $rx_inst_name            rx_eav             conduit output
   
   if { !$ch1_in_loopback_mode } {
      add_export_rename_interface             $rx_inst_name            rx_trs             conduit output
   }

   if { $std == "tr" | $std == "ds" | $std == "threeg" | $std == "mr" } {
     if { ($ch == "ch1" | $ch == "ch2") & $std == "threeg" } {
        add_export_rename_interface           $rx_inst_name            rx_std             conduit output
     } else {
        add_export_fanout_rename_interface    $rx_inst_name            rx_std             conduit output
     }
   }
 
   if { $crc_err } {
      add_export_rename_interface         $rx_inst_name   rx_crc_error_c   conduit   output
      add_export_rename_interface         $rx_inst_name   rx_crc_error_y   conduit   output
      if { $std == "threeg" | $std == "dl" | $std == "tr" | $std == "mr" } {
         add_export_rename_interface       $rx_inst_name   rx_crc_error_c_b conduit   output
         add_export_rename_interface       $rx_inst_name   rx_crc_error_y_b conduit   output
      }
   }

   if { $std != "sd" } {
      add_export_rename_interface       $rx_inst_name   rx_coreclk_is_ntsc_paln conduit   output
      add_export_rename_interface       $rx_inst_name   rx_clkout_is_ntsc_paln  conduit   output
      if { ! $vpid_extract & !$ch1_in_loopback_mode } {
         add_export_rename_interface       $rx_inst_name   rx_ln  conduit   output
         if { $std == "threeg" | $std == "dl" | $std == "tr" | $std == "mr" } {
            add_export_rename_interface       $rx_inst_name   rx_ln_b  conduit   output
         }
      }
   }

   if { $vpid_extract & !$ch1_in_loopback_mode} {
      if { $ch == "ch0" } {
         if { $std != "sd" } {
            add_export_fanout_rename_interface       $rx_inst_name   rx_ln conduit   output
         }
         add_export_fanout_rename_interface       $rx_inst_name   rx_line_f0 conduit   output
         add_export_fanout_rename_interface       $rx_inst_name   rx_line_f1 conduit   output
         add_export_fanout_rename_interface       $rx_inst_name   rx_vpid_byte1 conduit   output
         add_export_fanout_rename_interface       $rx_inst_name   rx_vpid_byte2 conduit   output
         add_export_fanout_rename_interface       $rx_inst_name   rx_vpid_byte3 conduit   output
         add_export_fanout_rename_interface       $rx_inst_name   rx_vpid_byte4 conduit   output
      } else {
         if { $std != "sd" } {
            add_export_rename_interface              $rx_inst_name   rx_ln conduit   output
         }
         add_export_rename_interface              $rx_inst_name   rx_line_f0 conduit   output
         add_export_rename_interface              $rx_inst_name   rx_line_f1 conduit   output
         add_export_rename_interface              $rx_inst_name   rx_vpid_byte1  conduit   output
         add_export_rename_interface              $rx_inst_name   rx_vpid_byte2  conduit   output
         add_export_rename_interface              $rx_inst_name   rx_vpid_byte3  conduit   output
         add_export_rename_interface              $rx_inst_name   rx_vpid_byte4  conduit   output
      }

      if { $std == "threeg" | $std == "dl" | $std == "tr" | $std == "mr" } {
         if { $ch == "ch0" } {
            add_export_fanout_rename_interface       $rx_inst_name   rx_ln_b conduit   output
            add_export_fanout_rename_interface       $rx_inst_name   rx_vpid_byte1_b conduit   output
            add_export_fanout_rename_interface       $rx_inst_name   rx_vpid_byte2_b conduit   output
            add_export_fanout_rename_interface       $rx_inst_name   rx_vpid_byte3_b conduit   output
            add_export_fanout_rename_interface       $rx_inst_name   rx_vpid_byte4_b conduit   output
         } else {
            add_export_rename_interface       $rx_inst_name   rx_ln_b conduit   output
            add_export_rename_interface       $rx_inst_name   rx_vpid_byte1_b conduit   output
            add_export_rename_interface       $rx_inst_name   rx_vpid_byte2_b conduit   output
            add_export_rename_interface       $rx_inst_name   rx_vpid_byte3_b conduit   output
            add_export_rename_interface       $rx_inst_name   rx_vpid_byte4_b conduit   output
         }
      }
   }
   
   if { $vpid_extract } {
      add_export_rename_interface              $rx_inst_name   rx_vpid_valid   conduit   output
      add_export_rename_interface              $rx_inst_name   rx_vpid_checksum_error  conduit   output
      if { $std == "threeg" | $std == "dl" | $std == "tr" | $std == "mr" } {
         add_export_rename_interface              $rx_inst_name   rx_vpid_valid_b conduit   output
         add_export_rename_interface              $rx_inst_name   rx_vpid_checksum_error_b conduit   output
      }
   }

   if { $std == "tr" | $std == "mr" } {
      add_export_fanout_rename_interface   ${ch}_reconfig           cdr_reconfig_busy   conduit   output
   }

   if { $txpll_switch != "0" } {
      if { $txpll_switch == "1" } {
        add_interface              ${ch}_tx_reconfig_pll_sel   conduit                     input
        set_interface_property     ${ch}_tx_reconfig_pll_sel   export_of                   ${ch}_tx_reconfig_pll_sel_fanout.sig_input
        set_interface_property     ${ch}_tx_reconfig_pll_sel   PORT_NAME_MAP              "${ch}_tx_reconfig_pll_sel sig_input"
      } else {
        add_export_rename_interface   ${ch}_tx_reconfig   pll_sel       conduit   input
      }
      add_export_rename_interface   ${ch}_tx_reconfig   pll_sw_busy   conduit   output

      if { $txpll_switch == "1" && $std == "dl" } {
         add_export_rename_interface            ${ch}_tx_reconfig_b                 pll_sel       conduit   input
         add_export_rename_interface            ${ch}_tx_reconfig_b                 pll_sw_busy   conduit   output
      }
   }
}

proc add_ch0_connection {lb_ch  lb_ch_name  video_std  ch0_vpid_insert  ch0_vpid_extract } {
    # Output from Core
    add_connection   ${lb_ch}_${lb_ch_name}.tx_dataout                            ${lb_ch}_phy_adapter.xcvr_tx_datain
    add_connection   ${lb_ch}_${lb_ch_name}.tx_dataout_valid                      ${lb_ch}_${lb_ch_name}_tx_dataout_valid_fanout.sig_input
    add_connection   ${lb_ch}_${lb_ch_name}_tx_dataout_valid_fanout.sig_fanout1   ${lb_ch}_loopback.tx_data_valid
    add_connection   ${lb_ch}_${lb_ch_name}.gxb_ltd                               ${lb_ch}_native_phy.rx_set_locktodata
    add_connection   ${lb_ch}_${lb_ch_name}.gxb_ltr                               ${lb_ch}_${lb_ch_name}_rx_set_locktoref_fanout.sig_input
    add_connection   ${lb_ch}_${lb_ch_name}_rx_set_locktoref_fanout.sig_fanout0   ${lb_ch}_native_phy.rx_set_locktoref            
    add_connection   ${lb_ch}_${lb_ch_name}_rx_set_locktoref_fanout.sig_fanout1   ${lb_ch}_phy_adapter.rx_set_locktoref            
    add_connection   ${lb_ch}_${lb_ch_name}.trig_rst_ctrl                         ${lb_ch}_rx_xcvr_rst_ctrl_reset_sync.reset_in0
    add_connection   ${lb_ch}_${lb_ch_name}.rx_trs_locked                         ${lb_ch}_${lb_ch_name}_rx_trs_locked_fanout.sig_input
    add_connection   ${lb_ch}_${lb_ch_name}.rx_frame_locked                       ${lb_ch}_${lb_ch_name}_rx_frame_locked_fanout.sig_input
    add_connection   ${lb_ch}_${lb_ch_name}.rx_dataout                            ${lb_ch}_${lb_ch_name}_rx_dataout_fanout.sig_input
    add_connection   ${lb_ch}_${lb_ch_name}.rx_dataout_valid                      ${lb_ch}_${lb_ch_name}_rx_dataout_valid_fanout.sig_input
    add_connection   ${lb_ch}_${lb_ch_name}.rx_rst_proto_out                      ${lb_ch}_${lb_ch_name}_rx_rst_proto_out_fanout.sig_input
    add_connection   ${lb_ch}_${lb_ch_name}_rx_rst_proto_out_fanout.sig_fanout1   ${lb_ch}_loopback.rx_rst
    add_connection   ${lb_ch}_${lb_ch_name}_rx_dataout_fanout.sig_fanout1         ${lb_ch}_loopback.rx_data
    add_connection   ${lb_ch}_${lb_ch_name}_rx_dataout_valid_fanout.sig_fanout1   ${lb_ch}_loopback.rx_data_valid
    add_connection   ${lb_ch}_${lb_ch_name}_rx_trs_locked_fanout.sig_fanout1      ${lb_ch}_loopback.rx_trs_locked
    add_connection   ${lb_ch}_${lb_ch_name}_rx_frame_locked_fanout.sig_fanout1    ${lb_ch}_loopback.rx_frame_locked

    if { $video_std == "tr" | $video_std == "mr" } { 
       add_connection   ${lb_ch}_${lb_ch_name}.rx_std                             ${lb_ch}_${lb_ch_name}_rx_std_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}_rx_std_fanout.sig_fanout1          ${lb_ch}_loopback.rx_std
       add_connection   ${lb_ch}_${lb_ch_name}_rx_std_fanout.sig_fanout2          ${lb_ch}_reconfig.cdr_reconfig_sel
       if {$video_std == "mr"} {
          add_connection   ${lb_ch}_${lb_ch_name}_rx_std_fanout.sig_fanout3       ${lb_ch}_phy_adapter.rx_std
       }
    } elseif { $video_std == "threeg" } {
       add_connection   ${lb_ch}_${lb_ch_name}.rx_std                             ${lb_ch}_${lb_ch_name}_rx_std_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}_rx_std_fanout.sig_fanout1          ${lb_ch}_loopback.rx_std
    }

    if { $video_std == "tr" | $video_std == "ds" | $video_std == "mr" } {
       add_connection   ${lb_ch}_${lb_ch_name}.rx_sdi_start_reconfig                     ${lb_ch}_reconfig.cdr_reconfig_req
    }

    if { $video_std == "dl" } {
       add_connection   ${lb_ch}_${lb_ch_name}.gxb_ltd_b                          ${lb_ch}_native_phy_b.rx_set_locktodata
       add_connection   ${lb_ch}_${lb_ch_name}.gxb_ltr_b                          ${lb_ch}_${lb_ch_name}_rx_set_locktoref_b_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}_rx_set_locktoref_b_fanout.sig_fanout0     ${lb_ch}_native_phy_b.rx_set_locktoref
       add_connection   ${lb_ch}_${lb_ch_name}_rx_set_locktoref_b_fanout.sig_fanout1     ${lb_ch}_phy_adapter.rx_set_locktoref_b
       add_connection   ${lb_ch}_${lb_ch_name}.tx_dataout_b                       ${lb_ch}_phy_adapter.xcvr_tx_datain_b
       add_connection   ${lb_ch}_${lb_ch_name}.tx_dataout_valid_b                 ${lb_ch}_${lb_ch_name}_tx_dataout_valid_b_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}.rx_dataout_b                       ${lb_ch}_${lb_ch_name}_rx_dataout_b_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}.rx_dataout_valid_b                 ${lb_ch}_${lb_ch_name}_rx_dataout_valid_b_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}_rx_dataout_b_fanout.sig_fanout1                       ${lb_ch}_loopback.rx_data_b
       add_connection   ${lb_ch}_${lb_ch_name}_rx_dataout_valid_b_fanout.sig_fanout1                 ${lb_ch}_loopback.rx_data_valid_b
       add_connection   ${lb_ch}_${lb_ch_name}_tx_dataout_valid_b_fanout.sig_fanout1                 ${lb_ch}_loopback.tx_data_valid_b
    }

    if { $ch0_vpid_extract } {
       add_connection   ${lb_ch}_${lb_ch_name}.rx_ln                                     ${lb_ch}_${lb_ch_name}_rx_ln_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}.rx_vpid_byte1                             ${lb_ch}_${lb_ch_name}_rx_vpid_byte1_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}.rx_vpid_byte2                             ${lb_ch}_${lb_ch_name}_rx_vpid_byte2_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}.rx_vpid_byte3                             ${lb_ch}_${lb_ch_name}_rx_vpid_byte3_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}.rx_vpid_byte4                             ${lb_ch}_${lb_ch_name}_rx_vpid_byte4_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}.rx_line_f0                                ${lb_ch}_${lb_ch_name}_rx_line_f0_fanout.sig_input
       add_connection   ${lb_ch}_${lb_ch_name}.rx_line_f1                                ${lb_ch}_${lb_ch_name}_rx_line_f1_fanout.sig_input

       add_connection   ${lb_ch}_${lb_ch_name}_rx_ln_fanout.sig_fanout1                  ${lb_ch}_loopback.rx_ln
       add_connection   ${lb_ch}_${lb_ch_name}_rx_vpid_byte1_fanout.sig_fanout1          ${lb_ch}_loopback.rx_vpid_byte1
       add_connection   ${lb_ch}_${lb_ch_name}_rx_vpid_byte2_fanout.sig_fanout1          ${lb_ch}_loopback.rx_vpid_byte2
       add_connection   ${lb_ch}_${lb_ch_name}_rx_vpid_byte3_fanout.sig_fanout1          ${lb_ch}_loopback.rx_vpid_byte3
       add_connection   ${lb_ch}_${lb_ch_name}_rx_vpid_byte4_fanout.sig_fanout1          ${lb_ch}_loopback.rx_vpid_byte4
       add_connection   ${lb_ch}_${lb_ch_name}_rx_line_f0_fanout.sig_fanout1             ${lb_ch}_loopback.rx_line_f0
       add_connection   ${lb_ch}_${lb_ch_name}_rx_line_f1_fanout.sig_fanout1             ${lb_ch}_loopback.rx_line_f1

       if { $video_std == "tr" | $video_std == "dl" | $video_std == "threeg" | $video_std == "mr" } {
          add_connection   ${lb_ch}_${lb_ch_name}.rx_ln_b                                ${lb_ch}_${lb_ch_name}_rx_ln_b_fanout.sig_input
          add_connection   ${lb_ch}_${lb_ch_name}.rx_vpid_byte1_b                        ${lb_ch}_${lb_ch_name}_rx_vpid_byte1_b_fanout.sig_input
          add_connection   ${lb_ch}_${lb_ch_name}.rx_vpid_byte2_b                        ${lb_ch}_${lb_ch_name}_rx_vpid_byte2_b_fanout.sig_input
          add_connection   ${lb_ch}_${lb_ch_name}.rx_vpid_byte3_b                        ${lb_ch}_${lb_ch_name}_rx_vpid_byte3_b_fanout.sig_input
          add_connection   ${lb_ch}_${lb_ch_name}.rx_vpid_byte4_b                        ${lb_ch}_${lb_ch_name}_rx_vpid_byte4_b_fanout.sig_input

          add_connection   ${lb_ch}_${lb_ch_name}_rx_ln_b_fanout.sig_fanout1             ${lb_ch}_loopback.rx_ln_b
          add_connection   ${lb_ch}_${lb_ch_name}_rx_vpid_byte1_b_fanout.sig_fanout1     ${lb_ch}_loopback.rx_vpid_byte1_b
          add_connection   ${lb_ch}_${lb_ch_name}_rx_vpid_byte2_b_fanout.sig_fanout1     ${lb_ch}_loopback.rx_vpid_byte2_b
          add_connection   ${lb_ch}_${lb_ch_name}_rx_vpid_byte3_b_fanout.sig_fanout1     ${lb_ch}_loopback.rx_vpid_byte3_b
          add_connection   ${lb_ch}_${lb_ch_name}_rx_vpid_byte4_b_fanout.sig_fanout1     ${lb_ch}_loopback.rx_vpid_byte4_b
       }
    }

    # Output from ED Loopback
    add_connection   ${lb_ch}_loopback.tx_trs                                     ${lb_ch}_${lb_ch_name}.tx_trs
    add_connection   ${lb_ch}_loopback.tx_data                                    ${lb_ch}_${lb_ch_name}.tx_datain
    add_connection   ${lb_ch}_loopback.tx_data_valid_out                          ${lb_ch}_${lb_ch_name}.tx_datain_valid

    if { $video_std == "dl" } {
       add_connection   ${lb_ch}_loopback.tx_trs_b                                ${lb_ch}_${lb_ch_name}.tx_trs_b
       add_connection   ${lb_ch}_loopback.tx_data_b                               ${lb_ch}_${lb_ch_name}.tx_datain_b
       add_connection   ${lb_ch}_loopback.tx_data_valid_out_b                     ${lb_ch}_${lb_ch_name}.tx_datain_valid_b
    }

    if { $video_std != "sd" } {
       add_connection   ${lb_ch}_loopback.tx_enable_crc                           ${lb_ch}_${lb_ch_name}.tx_enable_crc
       add_connection   ${lb_ch}_loopback.tx_enable_ln                            ${lb_ch}_${lb_ch_name}.tx_enable_ln
       add_connection   ${lb_ch}_loopback.tx_ln                                   ${lb_ch}_${lb_ch_name}.tx_ln
    }

    if { $video_std == "tr" | $video_std == "ds" | $video_std == "threeg" | $video_std == "mr" } {
       add_connection   ${lb_ch}_loopback.tx_std                                  ${lb_ch}_${lb_ch_name}.tx_std
    }

    if { $video_std == "tr" | $video_std == "dl" | $video_std == "threeg" | $video_std == "mr" } {      
       add_connection   ${lb_ch}_loopback.tx_ln_b                                 ${lb_ch}_${lb_ch_name}.tx_ln_b 
    }

    if { $ch0_vpid_insert} {
       add_connection   ${lb_ch}_loopback.tx_vpid_overwrite                       ${lb_ch}_${lb_ch_name}.tx_vpid_overwrite
       add_connection   ${lb_ch}_loopback.tx_vpid_byte1                           ${lb_ch}_${lb_ch_name}.tx_vpid_byte1
       add_connection   ${lb_ch}_loopback.tx_vpid_byte2                           ${lb_ch}_${lb_ch_name}.tx_vpid_byte2
       add_connection   ${lb_ch}_loopback.tx_vpid_byte3                           ${lb_ch}_${lb_ch_name}.tx_vpid_byte3
       add_connection   ${lb_ch}_loopback.tx_vpid_byte4                           ${lb_ch}_${lb_ch_name}.tx_vpid_byte4
       add_connection   ${lb_ch}_loopback.tx_line_f0                              ${lb_ch}_${lb_ch_name}.tx_line_f0
       add_connection   ${lb_ch}_loopback.tx_line_f1                              ${lb_ch}_${lb_ch_name}.tx_line_f1    
       if { $video_std == "tr" | $video_std == "dl" | $video_std == "threeg" | $video_std == "mr" } {
         add_connection   ${lb_ch}_loopback.tx_vpid_byte1_b                       ${lb_ch}_${lb_ch_name}.tx_vpid_byte1_b
         add_connection   ${lb_ch}_loopback.tx_vpid_byte2_b                       ${lb_ch}_${lb_ch_name}.tx_vpid_byte2_b
         add_connection   ${lb_ch}_loopback.tx_vpid_byte3_b                       ${lb_ch}_${lb_ch_name}.tx_vpid_byte3_b
         add_connection   ${lb_ch}_loopback.tx_vpid_byte4_b                       ${lb_ch}_${lb_ch_name}.tx_vpid_byte4_b
       }
    }
}

proc add_ch1_connection { ch tx_inst_name rx_inst_name std vpid_insert} {
    # Output from Core
    add_connection   ${tx_inst_name}.tx_dataout                            ${ch}_phy_adapter.xcvr_tx_datain
    add_connection   ${tx_inst_name}.tx_dataout_valid                      ${tx_inst_name}_tx_dataout_valid_fanout.sig_input
    add_connection   ${tx_inst_name}_tx_dataout_valid_fanout.sig_fanout1   pattgen.enable
    add_connection   ${rx_inst_name}.gxb_ltd                               ${ch}_rx_native_phy.rx_set_locktodata
    add_connection   ${rx_inst_name}.gxb_ltr                               ${rx_inst_name}_rx_set_locktoref_fanout.sig_input
    add_connection   ${rx_inst_name}_rx_set_locktoref_fanout.sig_fanout0     ${ch}_rx_native_phy.rx_set_locktoref
    add_connection   ${rx_inst_name}_rx_set_locktoref_fanout.sig_fanout1     ${ch}_phy_adapter.rx_set_locktoref
    add_connection   ${rx_inst_name}.trig_rst_ctrl                         ${ch}_rx_xcvr_rst_ctrl_reset_sync.reset_in0
    if { $std == "dl" } {
       add_connection   ${tx_inst_name}.tx_dataout_b                            ${ch}_phy_adapter.xcvr_tx_datain_b
       add_connection   ${rx_inst_name}.gxb_ltd_b                               ${ch}_rx_native_phy_b.rx_set_locktodata           
       add_connection   ${rx_inst_name}.gxb_ltr_b                               ${rx_inst_name}_rx_set_locktoref_b_fanout.sig_input
       add_connection   ${rx_inst_name}_rx_set_locktoref_b_fanout.sig_fanout0                               ${ch}_rx_native_phy_b.rx_set_locktoref    
       add_connection   ${rx_inst_name}_rx_set_locktoref_b_fanout.sig_fanout1                               ${ch}_phy_adapter.rx_set_locktoref_b
    }

    if { $std == "tr" | $std == "ds" | $std == "mr" } {
       add_connection   ${rx_inst_name}.rx_sdi_start_reconfig                     ${ch}_reconfig.cdr_reconfig_req
       add_connection   ${rx_inst_name}.rx_std                                    ${rx_inst_name}_rx_std_fanout.sig_input
       add_connection   ${rx_inst_name}_rx_std_fanout.sig_fanout1                 ${ch}_reconfig.cdr_reconfig_sel
       if {$std == "mr"} {
          add_connection   ${rx_inst_name}_rx_std_fanout.sig_fanout2              ${ch}_phy_adapter.rx_std
       }
    }
}

proc add_pattgen_connection { tx_inst_name std vpid_insert cmp_data} {
    # Output from Pattgen
    add_connection   pattgen.trs                        ${tx_inst_name}.tx_trs
    if { $std == "dl" } {
       add_connection   pattgen.trs_b                        ${tx_inst_name}.tx_trs_b
    }

    if { $cmp_data } {
       add_connection   pattgen.dout                            pattgen_dout_fanout.sig_input
       add_connection   pattgen_dout_fanout.sig_fanout1         ${tx_inst_name}.tx_datain
       add_connection   pattgen.dout_valid                      pattgen_dout_valid_fanout.sig_input
       add_connection   pattgen_dout_valid_fanout.sig_fanout1   ${tx_inst_name}.tx_datain_valid

       if { $std == "dl" } {
          add_connection   pattgen.dout_b                      pattgen_dout_b_fanout.sig_input
          add_connection   pattgen.dout_valid_b                pattgen_dout_valid_b_fanout.sig_input
          add_connection   pattgen_dout_b_fanout.sig_fanout1                ${tx_inst_name}.tx_datain_b
          add_connection   pattgen_dout_valid_b_fanout.sig_fanout1                ${tx_inst_name}.tx_datain_valid_b
       }
    } else {
       add_connection   pattgen.dout                            ${tx_inst_name}.tx_datain
       add_connection   pattgen.dout_valid                      ${tx_inst_name}.tx_datain_valid
       if { $std == "dl" } {
          add_connection   pattgen.dout_b                       ${tx_inst_name}.tx_datain_b
          add_connection   pattgen.dout_valid_b                      ${tx_inst_name}.tx_datain_valid_b
       }
    }

    if {$vpid_insert} {
        add_connection    pattgen.ln                     ${tx_inst_name}.tx_ln 
        # add_connection    pattgen.line_f0                      pattgen_line_f0_fanout.sig_input
        # add_connection    pattgen_line_f0_fanout.sig_fanout1   ${tx_inst_name}.tx_line_f0
        # add_connection    pattgen.line_f1                      pattgen_line_f1_fanout.sig_input
        # add_connection    pattgen_line_f1_fanout.sig_fanout1   ${tx_inst_name}.tx_line_f1
        add_connection    pattgen.line_f0       ${tx_inst_name}.tx_line_f0
        add_connection    pattgen.line_f1       ${tx_inst_name}.tx_line_f1
        add_connection    pattgen.vpid_byte1    ${tx_inst_name}.tx_vpid_byte1
        add_connection    pattgen.vpid_byte2    ${tx_inst_name}.tx_vpid_byte2
        add_connection    pattgen.vpid_byte3    ${tx_inst_name}.tx_vpid_byte3
        add_connection    pattgen.vpid_byte4    ${tx_inst_name}.tx_vpid_byte4
        if { $std == "dl" | $std == "threeg" | $std == "tr" | $std == "mr" } {
            add_connection  pattgen.ln_b          ${tx_inst_name}.tx_ln_b
            add_connection  pattgen.vpid_byte1_b  ${tx_inst_name}.tx_vpid_byte1_b
            add_connection  pattgen.vpid_byte2_b  ${tx_inst_name}.tx_vpid_byte2_b
            add_connection  pattgen.vpid_byte3_b  ${tx_inst_name}.tx_vpid_byte3_b
            add_connection  pattgen.vpid_byte4_b  ${tx_inst_name}.tx_vpid_byte4_b
        }
    } elseif { $std != "sd" } {
       add_connection    pattgen.ln                     ${tx_inst_name}.tx_ln 
       if { $std == "threeg" | $std == "dl" | $std == "tr" | $std == "mr" } {
          add_connection   pattgen.ln_b                 ${tx_inst_name}.tx_ln_b
       }
    }
}

proc add_common_connection { ch tx_inst_name rx_inst_name tx_phy_name rx_phy_name std txpll_switch } {
    # Output from Tx PLL
    add_connection   ${ch}_tx_pll.pll_locked                                   ${ch}_tx_pll_pll_locked_fanout.sig_input
    add_connection   ${ch}_tx_pll.tx_serial_clk                                ${ch}_phy_adapter.tx_serial_clk_in

    add_connection   ${ch}_tx_pll.pll_cal_busy                              ${ch}_phy_adapter.pll_cal_busy_in
    if { $txpll_switch == "1" } {
       add_connection   ${ch}_tx_pll_alt.pll_cal_busy                       ${ch}_phy_adapter.pll_cal_busy_in_alt
    }

    if { $txpll_switch == "1" } {
       add_connection   ${ch}_tx_pll_alt.tx_serial_clk                              ${ch}_phy_adapter.tx_serial_clk_alt_in
       add_connection   ${ch}_tx_pll_alt.pll_locked                                 ${ch}_tx_pll_alt_pll_locked_fanout.sig_input
       add_connection   ${ch}_tx_pll_pll_locked_fanout.sig_fanout1                ${ch}_phy_adapter.pll_locked_in
       add_connection   ${ch}_tx_pll_alt_pll_locked_fanout.sig_fanout1            ${ch}_phy_adapter.pll_locked_in_b
    } else {
       add_connection   ${ch}_tx_pll_pll_locked_fanout.sig_fanout1                ${ch}_tx_xcvr_rst_ctrl.pll_locked
    }
    # Output from Tx Xcvr Reset Controller
    if { $std == "dl" } {
       add_connection   ${ch}_tx_xcvr_rst_ctrl.tx_analogreset                     ${ch}_phy_adapter.tx_analogreset_in
       add_connection   ${ch}_tx_xcvr_rst_ctrl.tx_digitalreset                    ${ch}_phy_adapter.tx_digitalreset_in
    } else {
       add_connection   ${ch}_tx_xcvr_rst_ctrl.tx_analogreset                     ${tx_phy_name}.tx_analogreset
       add_connection   ${ch}_tx_xcvr_rst_ctrl.tx_digitalreset                    ${tx_phy_name}.tx_digitalreset
    }

    if { $txpll_switch == "1" } {
       add_connection   ${ch}_tx_xcvr_rst_ctrl.pll_powerdown                      ${ch}_phy_adapter.pll_powerdown_in
    } elseif { $txpll_switch == "2" } {
       add_connection   ${ch}_tx_xcvr_rst_ctrl.pll_powerdown                      ${ch}_tx_xcvr_rst_ctrl_pll_powerdown_fanout.sig_input
       add_connection   ${ch}_tx_xcvr_rst_ctrl_pll_powerdown_fanout.sig_fanout0   ${ch}_tx_pll.pll_powerdown
       add_connection   ${ch}_tx_xcvr_rst_ctrl_pll_powerdown_fanout.sig_fanout1   ${ch}_tx_reconfig.pll_powerdown
    } else {
       add_connection   ${ch}_tx_xcvr_rst_ctrl.pll_powerdown                      ${ch}_tx_pll.pll_powerdown
    }

    # Output from Rx Xcvr Reset Controller
    add_connection   ${ch}_rx_xcvr_rst_ctrl.rx_ready                           ${ch}_rx_xcvr_rst_ctrl_rx_ready_fanout.sig_input
    add_connection   ${ch}_rx_xcvr_rst_ctrl_rx_ready_fanout.sig_fanout1        ${ch}_phy_adapter.rx_ready_from_xcvr
    if { $std == "dl" } {
       add_connection   ${ch}_rx_xcvr_rst_ctrl.rx_analogreset                     ${ch}_phy_adapter.rx_analogreset_in
       add_connection   ${ch}_rx_xcvr_rst_ctrl.rx_digitalreset                    ${ch}_phy_adapter.rx_digitalreset_in
    } else {
       add_connection   ${ch}_rx_xcvr_rst_ctrl.rx_analogreset                     ${rx_phy_name}.rx_analogreset
       add_connection   ${ch}_rx_xcvr_rst_ctrl.rx_digitalreset                    ${rx_phy_name}.rx_digitalreset
       add_connection   ${ch}_rx_xcvr_rst_ctrl_rx_ready_fanout.sig_fanout2        ${rx_inst_name}.rx_ready
    }

    # Output from Native PHY
    if { $std == "mr" } {
       add_connection   ${tx_phy_name}.tx_clkout                                ${ch}_phy_adapter.unused_tx_clkout
       add_connection   ${rx_phy_name}.rx_clkout                                ${ch}_phy_adapter.unused_rx_clkout
       add_connection   ${tx_phy_name}.tx_pma_div_clkout                        ${tx_phy_name}_tx_clkout_fanout.sig_input
       add_connection   ${rx_phy_name}.rx_pma_div_clkout                        ${rx_phy_name}_rx_clkout_fanout.sig_input
       add_connection   ${rx_phy_name}.rx_control                               ${ch}_phy_adapter.rx_control
    } else {
       add_connection   ${tx_phy_name}.tx_clkout                                ${tx_phy_name}_tx_clkout_fanout.sig_input
       add_connection   ${rx_phy_name}.rx_clkout                                ${rx_phy_name}_rx_clkout_fanout.sig_input
    }
    add_connection   ${tx_phy_name}_tx_clkout_fanout.sig_fanout0             ${ch}_phy_adapter.tx_clkout_from_xcvr
    add_connection   ${tx_phy_name}_tx_clkout_fanout.sig_fanout1             ${tx_phy_name}.tx_coreclkin
    add_connection   ${rx_phy_name}_rx_clkout_fanout.sig_fanout0             ${rx_phy_name}.rx_coreclkin
    add_connection   ${rx_phy_name}_rx_clkout_fanout.sig_fanout1             ${ch}_phy_adapter.rxclk_from_xcvr
    add_connection   ${rx_phy_name}.rx_is_lockedtoref                        ${rx_phy_name}_rx_is_lockedtoref_fanout.sig_input
    add_connection   ${rx_phy_name}.rx_is_lockedtodata                       ${rx_phy_name}_rx_is_lockedtodata_fanout.sig_input
    add_connection   ${rx_phy_name}_rx_is_lockedtoref_fanout.sig_fanout1     ${ch}_phy_adapter.xcvr_rx_is_lockedtoref
    add_connection   ${rx_phy_name}_rx_is_lockedtodata_fanout.sig_fanout1    ${ch}_phy_adapter.xcvr_rx_is_lockedtodata
    add_connection   ${rx_phy_name}.rx_parallel_data                         ${ch}_phy_adapter.rx_dataout_from_xcvr

    if { $std == "dl" } {
       add_connection   ${tx_phy_name}_b.tx_clkout                                   ${ch}_phy_adapter.tx_clkout_from_xcvr_b
       add_connection   ${rx_phy_name}_b.rx_clkout                                   ${rx_phy_name}_b_rx_clkout_fanout.sig_input
       add_connection   ${rx_phy_name}_b_rx_clkout_fanout.sig_fanout0                ${ch}_phy_adapter.rxclk_from_xcvr_b
       add_connection   ${rx_phy_name}_b_rx_clkout_fanout.sig_fanout1                ${rx_phy_name}_b.rx_coreclkin
       add_connection   ${tx_phy_name}_tx_clkout_fanout.sig_fanout2                  ${tx_phy_name}_b.tx_coreclkin
       add_connection   ${tx_phy_name}.tx_cal_busy                              ${ch}_phy_adapter.tx_cal_busy_in
       add_connection   ${rx_phy_name}.rx_cal_busy                              ${ch}_phy_adapter.rx_cal_busy_in
       add_connection   ${tx_phy_name}_b.tx_cal_busy                              ${ch}_phy_adapter.tx_cal_busy_in_b
       add_connection   ${rx_phy_name}_b.rx_cal_busy                              ${ch}_phy_adapter.rx_cal_busy_in_b
       add_connection   ${rx_phy_name}_b.rx_parallel_data                         ${ch}_phy_adapter.rx_dataout_from_xcvr_b
       add_connection   ${rx_phy_name}_b.rx_is_lockedtoref                        ${rx_phy_name}_b_rx_is_lockedtoref_fanout.sig_input
       add_connection   ${rx_phy_name}_b.rx_is_lockedtodata                       ${rx_phy_name}_b_rx_is_lockedtodata_fanout.sig_input
       add_connection   ${rx_phy_name}_b_rx_is_lockedtoref_fanout.sig_fanout1     ${ch}_phy_adapter.xcvr_rx_is_lockedtoref_b
       add_connection   ${rx_phy_name}_b_rx_is_lockedtodata_fanout.sig_fanout1    ${ch}_phy_adapter.xcvr_rx_is_lockedtodata_b
    } elseif { $std == "tr" | $std == "mr"  } {
       add_connection   ${tx_phy_name}.tx_cal_busy                              ${ch}_phy_adapter.tx_cal_busy_in
       add_connection   ${rx_phy_name}.rx_cal_busy                              ${rx_phy_name}_rx_cal_busy_fanout.sig_input
       add_connection   ${rx_phy_name}_rx_cal_busy_fanout.sig_fanout0           ${ch}_rx_xcvr_rst_ctrl.rx_cal_busy
       add_connection   ${rx_phy_name}_rx_cal_busy_fanout.sig_fanout1           ${ch}_reconfig.rx_cal_busy
       add_connection   ${rx_phy_name}.rx_analogreset_ack                       ${ch}_reconfig.rx_analogreset_ack
    } else {
       add_connection   ${tx_phy_name}.tx_cal_busy                              ${ch}_phy_adapter.tx_cal_busy_in
       add_connection   ${rx_phy_name}.rx_cal_busy                              ${ch}_rx_xcvr_rst_ctrl.rx_cal_busy
    }
    
    if { $txpll_switch == "1" } {
        add_connection   ${tx_phy_name}.tx_analogreset_ack                       ${ch}_tx_reconfig.tx_analogreset_ack
       
        if { $std == "dl" } {
            add_connection   ${tx_phy_name}_b.tx_analogreset_ack                       ${ch}_tx_reconfig_b.tx_analogreset_ack
        }
    }

    # Output from PHY Adapter
    add_connection   ${ch}_phy_adapter.tx_pll_select_to_xcvr_rst               ${ch}_tx_xcvr_rst_ctrl.pll_select
    add_connection   ${ch}_phy_adapter.rx_locked_to_xcvr_ctrl                  ${ch}_rx_xcvr_rst_ctrl.rx_is_lockedtodata
    add_connection   ${ch}_phy_adapter.rx_manual                               ${ch}_rx_xcvr_rst_ctrl.rx_reset_mode
    add_connection   ${ch}_phy_adapter.xcvr_rx_dataout                         ${rx_inst_name}.rx_datain
    add_connection   ${ch}_phy_adapter.tx_datain_to_xcvr                       ${tx_phy_name}.tx_parallel_data
    add_connection   ${ch}_phy_adapter.tx_clkout                               ${ch}_phy_adapter_tx_clkout_fanout.sig_input
    add_connection   ${ch}_phy_adapter.xcvr_rxclk                              ${ch}_phy_adapter_rx_clkout_fanout.sig_input
    add_connection   ${ch}_phy_adapter_rx_clkout_fanout.sig_fanout1            ${rx_inst_name}.xcvr_rxclk
    add_connection   ${ch}_phy_adapter_tx_clkout_fanout.sig_fanout1            ${tx_inst_name}.tx_pclk
    add_connection   ${ch}_phy_adapter.rx_cdr_refclk                           ${rx_phy_name}.rx_cdr_refclk0

    if { $ch == "ch0" } {
       add_connection   ${ch}_phy_adapter_tx_clkout_fanout.sig_fanout1         ${ch}_loopback.tx_clk
       add_connection   ${ch}_phy_adapter_rx_clkout_fanout.sig_fanout1         ${ch}_loopback.rx_clk
    } elseif { $ch == "ch1" } {
       add_connection   ${ch}_phy_adapter_tx_clkout_fanout.sig_fanout1         pattgen.clk
    }

    if { $txpll_switch == "1" } {
        add_connection   ${ch}_phy_adapter.tx_cal_busy_out                        ${ch}_phy_adapter_tx_cal_busy_out_fanout.sig_input
        add_connection   ${ch}_phy_adapter_tx_cal_busy_out_fanout.sig_fanout0     ${ch}_tx_xcvr_rst_ctrl.tx_cal_busy
        add_connection   ${ch}_phy_adapter_tx_cal_busy_out_fanout.sig_fanout1     ${ch}_tx_reconfig.tx_cal_busy

        if { $std == "dl" } {
            add_connection   ${ch}_phy_adapter_tx_cal_busy_out_fanout.sig_fanout2     ${ch}_tx_reconfig_b.tx_cal_busy
        }
    } else {
        add_connection   ${ch}_phy_adapter.tx_cal_busy_out                        ${ch}_tx_xcvr_rst_ctrl.tx_cal_busy
    }
    if { $std == "dl" } {
       add_connection   ${ch}_phy_adapter.rx_cdr_refclk_b                      ${rx_phy_name}_b.rx_cdr_refclk0
       add_connection   ${ch}_phy_adapter.xcvr_rxclk_b                         ${rx_inst_name}.xcvr_rxclk_b
       add_connection   ${ch}_phy_adapter.xcvr_rx_dataout_b                      ${rx_inst_name}.rx_datain_b
       add_connection   ${ch}_phy_adapter.xcvr_rx_ready                    ${rx_inst_name}.rx_ready
       add_connection   ${ch}_phy_adapter.xcvr_rx_ready_b                    ${rx_inst_name}.rx_ready_b
       add_connection   ${ch}_phy_adapter.tx_datain_to_xcvr_b                    ${tx_phy_name}_b.tx_parallel_data
       add_connection   ${ch}_phy_adapter.tx_analogreset_out                     ${tx_phy_name}.tx_analogreset
       add_connection   ${ch}_phy_adapter.tx_digitalreset_out                    ${tx_phy_name}.tx_digitalreset
       add_connection   ${ch}_phy_adapter.rx_cal_busy_out                        ${ch}_rx_xcvr_rst_ctrl.rx_cal_busy
       add_connection   ${ch}_phy_adapter.tx_analogreset_out_b                     ${tx_phy_name}_b.tx_analogreset
       add_connection   ${ch}_phy_adapter.tx_digitalreset_out_b                    ${tx_phy_name}_b.tx_digitalreset
       add_connection   ${ch}_phy_adapter.rx_analogreset_out                     ${rx_phy_name}.rx_analogreset
       add_connection   ${ch}_phy_adapter.rx_digitalreset_out                    ${rx_phy_name}.rx_digitalreset
       add_connection   ${ch}_phy_adapter.rx_analogreset_out_b                     ${rx_phy_name}_b.rx_analogreset
       add_connection   ${ch}_phy_adapter.rx_digitalreset_out_b                    ${rx_phy_name}_b.rx_digitalreset
    }
    
    if { $std == "mr" } {
       add_connection   ${ch}_phy_adapter.tx_control                            ${tx_phy_name}.tx_control                               
       add_connection   ${ch}_phy_adapter.tx_enh_data_valid                     ${tx_phy_name}.tx_enh_data_valid  
    }

    if { $std == "dl" } {
       add_connection   ${ch}_phy_adapter.tx_serial_clk_out                   ${ch}_phy_adapter_tx_serial_clk_fanout.sig_input
       add_connection   ${ch}_phy_adapter_tx_serial_clk_fanout.sig_fanout0    ${tx_phy_name}.tx_serial_clk0
       add_connection   ${ch}_phy_adapter_tx_serial_clk_fanout.sig_fanout1    ${tx_phy_name}_b.tx_serial_clk0
    } else {
       add_connection   ${ch}_phy_adapter.tx_serial_clk_out                   ${tx_phy_name}.tx_serial_clk0
    }

    if { $txpll_switch == "1" } {
       add_connection   ${ch}_phy_adapter.pll_locked_out                         ${ch}_tx_xcvr_rst_ctrl.pll_locked
       add_connection   ${ch}_phy_adapter.pll_powerdown_out                      ${ch}_tx_pll.pll_powerdown
       add_connection   ${ch}_phy_adapter.pll_powerdown_out_b                    ${ch}_tx_pll_alt.pll_powerdown

       if { $std == "dl" } {
          add_connection   ${ch}_phy_adapter.reconfig_clk_out                        ${ch}_phy_adapter_reconfig_clk_fanout.sig_input
          add_connection   ${ch}_phy_adapter_reconfig_clk_fanout.sig_fanout0         ${tx_phy_name}.reconfig_clk
          add_connection   ${ch}_phy_adapter_reconfig_clk_fanout.sig_fanout1         ${tx_phy_name}_b.reconfig_clk
          add_connection   ${ch}_phy_adapter.reconfig_rst_out                        ${ch}_phy_adapter_reconfig_rst_fanout.sig_input
          add_connection   ${ch}_phy_adapter_reconfig_rst_fanout.sig_fanout0         ${tx_phy_name}.reconfig_reset
          add_connection   ${ch}_phy_adapter_reconfig_rst_fanout.sig_fanout1         ${tx_phy_name}_b.reconfig_reset
          add_connection   ${ch}_phy_adapter.tx_serial_clk_alt_out                   ${ch}_phy_adapter_tx_serial_clk_alt_fanout.sig_input
          add_connection   ${ch}_phy_adapter_tx_serial_clk_alt_fanout.sig_fanout0    ${tx_phy_name}.tx_serial_clk1
          add_connection   ${ch}_phy_adapter_tx_serial_clk_alt_fanout.sig_fanout1    ${tx_phy_name}_b.tx_serial_clk1
       } else {
          add_connection   ${ch}_phy_adapter.tx_serial_clk_alt_out                   ${tx_phy_name}.tx_serial_clk1
       }

       if { $std == "tr" | $std == "ds" | $std == "mr" } {
          add_connection   ${ch}_phy_adapter.reconfig_clk_out                        ${ch}_phy_adapter_reconfig_clk_fanout.sig_input
          add_connection   ${ch}_phy_adapter_reconfig_clk_fanout.sig_fanout0         ${tx_phy_name}.reconfig_clk
          add_connection   ${ch}_phy_adapter_reconfig_clk_fanout.sig_fanout1         ${rx_phy_name}.reconfig_clk
          add_connection   ${ch}_phy_adapter.reconfig_rst_out                        ${ch}_phy_adapter_reconfig_rst_fanout.sig_input
          add_connection   ${ch}_phy_adapter_reconfig_rst_fanout.sig_fanout0         ${tx_phy_name}.reconfig_reset
          add_connection   ${ch}_phy_adapter_reconfig_rst_fanout.sig_fanout1         ${rx_phy_name}.reconfig_reset
       } elseif { $std != "dl" } {
          add_connection   ${ch}_phy_adapter.reconfig_clk_out                        ${tx_phy_name}.reconfig_clk
          add_connection   ${ch}_phy_adapter.reconfig_rst_out                        ${tx_phy_name}.reconfig_reset
       }
    } elseif { $std == "tr" | $std == "ds" | $std == "mr" } {
       add_connection   ${ch}_phy_adapter.reconfig_clk_out                        ${rx_phy_name}.reconfig_clk
       add_connection   ${ch}_phy_adapter.reconfig_rst_out                        ${rx_phy_name}.reconfig_reset
    }

    # From Top Level Signal
    add_connection   ${ch}_rx_xcvr_rst_ctrl_reset_sync.reset_out               ${ch}_rx_xcvr_rst_ctrl.reset
    add_connection   ${ch}_tx_pll_refclk_bridge.out_clk                        ${ch}_tx_pll.pll_refclk0
    add_connection   ${ch}_rx_cdr_refclk_bridge.out_clk                        ${ch}_phy_adapter.xcvr_refclk
    add_connection   ${ch}_rx_coreclk_bridge.out_clk                           ${ch}_rx_xcvr_rst_ctrl.clock
    add_connection   ${ch}_rx_coreclk_bridge.out_clk                           ${ch}_rx_xcvr_rst_ctrl_reset_sync.clk
    add_connection   ${ch}_rx_coreclk_bridge.out_clk                           ${rx_inst_name}.rx_coreclk
    add_connection   ${ch}_tx_xcvr_rst_ctrl_clk_bridge.out_clk                 ${ch}_tx_xcvr_rst_ctrl.clock
    add_connection   ${ch}_rx_cdr_refclk_bridge.out_clk                        ${ch}_rx_rst_bridge.clk
    add_connection   ${ch}_tx_pll_refclk_bridge.out_clk                        ${ch}_tx_rst_bridge.clk
    add_connection   ${ch}_rx_rst_bridge.out_reset                             ${rx_inst_name}.rx_rst
    add_connection   ${ch}_tx_rst_bridge.out_reset                             ${tx_inst_name}.tx_rst
    if { $ch == "ch1" } {
       add_connection   ${ch}_tx_rst_bridge.out_reset                             pattgen.rst
    } 
    # elseif { $ch == "ch0" } {
       # add_connection   ${ch}_tx_rst_bridge.out_reset                             ${ch}_loopback.tx_rst
    # }
    add_connection   ${ch}_tx_rst_bridge.out_reset                             ${ch}_tx_xcvr_rst_ctrl_reset_sync.reset_in0
    add_connection   ${ch}_tx_xcvr_rst_ctrl_reset_sync.reset_out               ${ch}_tx_xcvr_rst_ctrl.reset
    add_connection   ${ch}_tx_xcvr_rst_ctrl_clk_bridge.out_clk                 ${ch}_tx_xcvr_rst_ctrl_reset_sync.clk

    if { $std == "tr" | $std == "ds" | $std == "mr" | $txpll_switch == "1" } {
       add_connection   ${ch}_reconfig_clk_bridge.out_clk                      ${ch}_phy_adapter.reconfig_clk_in
       add_connection   ${ch}_reconfig_rst_bridge.out_reset                    ${ch}_phy_adapter.reconfig_rst_in
    }
    
    if { $txpll_switch == "2" } {
       add_connection   ${ch}_reconfig_clk_bridge.out_clk                      ${ch}_tx_pll.reconfig_clk0
       add_connection   ${ch}_reconfig_rst_bridge.out_reset                    ${ch}_tx_pll.reconfig_reset0
    }
    
    if { $std == "tr" | $std == "ds" | $std == "mr" | $txpll_switch != "0" } {
       add_connection   ${ch}_reconfig_clk_bridge.out_clk                      ${ch}_reconfig_rst_bridge.clk
    }

    if { $std == "tr" | $std == "ds" | $std == "mr" } {
       add_connection   ${ch}_reconfig_clk_bridge.out_clk                      ${ch}_reconfig.xcvr_reconfig_clk
       add_connection   ${ch}_reconfig_rst_bridge.out_reset                    ${ch}_reconfig.xcvr_reconfig_reset
    }

    if { $txpll_switch != "0" } {
       add_connection   ${ch}_reconfig_clk_bridge.out_clk                      ${ch}_tx_reconfig.xcvr_reconfig_clk
       add_connection   ${ch}_reconfig_rst_bridge.out_reset                    ${ch}_tx_reconfig.xcvr_reconfig_reset

       if { $txpll_switch == "1" } {
         add_connection   ${ch}_tx_reconfig_pll_sel_fanout.sig_fanout0         ${ch}_phy_adapter.xcvr_refclk_sel
         add_connection   ${ch}_tx_reconfig_pll_sel_fanout.sig_fanout1         ${ch}_tx_reconfig.pll_sel
       }

       if { $txpll_switch == "1" && $std == "dl" } {
          add_connection   ${ch}_reconfig_clk_bridge.out_clk                      ${ch}_tx_reconfig_b.xcvr_reconfig_clk
          add_connection   ${ch}_reconfig_rst_bridge.out_reset                    ${ch}_tx_reconfig_b.xcvr_reconfig_reset
       }
    }

    if { $txpll_switch == "1" } {
       add_connection   ${ch}_tx_pll_refclk_alt_bridge.out_clk                 ${ch}_tx_pll_alt.pll_refclk0
    } elseif { $txpll_switch == "2" } {
       add_connection   ${ch}_tx_pll_refclk_alt_bridge.out_clk                 ${ch}_tx_pll.pll_refclk1
    }

    # From Reconfig Module
    if { $std == "tr" | $std == "ds" | $std == "mr" } {
       add_connection   ${ch}_reconfig.rx_reconfig_avmm                          ${rx_phy_name}.reconfig_avmm
    }
    if { $txpll_switch == "1" } {
       add_connection   ${ch}_tx_reconfig.rst_tx_phy                                ${ch}_tx_xcvr_rst_ctrl_reset_sync.reset_in1
       add_connection   ${ch}_tx_reconfig.tx_reconfig_avmm                          ${tx_phy_name}.reconfig_avmm
       if { $std == "dl" } {
          add_connection   ${ch}_tx_reconfig_b.rst_tx_phy                                ${ch}_tx_xcvr_rst_ctrl_reset_sync.reset_in2
          add_connection   ${ch}_tx_reconfig_b.tx_reconfig_avmm                          ${tx_phy_name}_b.reconfig_avmm
       }
    } elseif { $txpll_switch == "2" } {
       add_connection   ${ch}_tx_reconfig.tx_reconfig_avmm0                          ${ch}_tx_pll.reconfig_avmm0
       add_connection   ${ch}_tx_reconfig.rst_tx_phy                                 ${ch}_tx_xcvr_rst_ctrl_reset_sync.reset_in1
    }

    if { $std == "tr" | $std == "ds" | $std == "mr" } {
       add_connection   ${ch}_reconfig.cdr_reconfig_busy                      ${ch}_reconfig_cdr_reconfig_busy_fanout.sig_input
       add_connection   ${ch}_reconfig_cdr_reconfig_busy_fanout.sig_fanout1   ${rx_inst_name}.rx_sdi_reconfig_done
    }
}

proc add_ch2_connection { ch1_rx_name loopback_name ch2_tx_name ch2_rx_name b2a} {
    # Output from Ch 1 Core
    add_connection   ${ch1_rx_name}.rx_dataout                            ${loopback_name}.rx_data
    add_connection   ${ch1_rx_name}.rx_dataout_valid                      ${loopback_name}.rx_data_valid
    add_connection   ${ch1_rx_name}.rx_trs                                ${loopback_name}.rx_trs
    add_connection   ${ch1_rx_name}.rx_ln                                 ${loopback_name}.rx_ln
    add_connection   ${ch1_rx_name}.rx_vpid_byte1                         ${loopback_name}.rx_vpid_byte1
    add_connection   ${ch1_rx_name}.rx_vpid_byte2                         ${loopback_name}.rx_vpid_byte2
    add_connection   ${ch1_rx_name}.rx_vpid_byte3                         ${loopback_name}.rx_vpid_byte3
    add_connection   ${ch1_rx_name}.rx_vpid_byte4                         ${loopback_name}.rx_vpid_byte4
    add_connection   ${ch1_rx_name}.rx_line_f0                            ${loopback_name}.rx_line_f0
    add_connection   ${ch1_rx_name}.rx_line_f1                            ${loopback_name}.rx_line_f1
    add_connection   ${ch1_rx_name}.rx_ln_b                               ${loopback_name}.rx_ln_b
    add_connection   ${ch1_rx_name}.rx_vpid_byte1_b                       ${loopback_name}.rx_vpid_byte1_b
    add_connection   ${ch1_rx_name}.rx_vpid_byte2_b                       ${loopback_name}.rx_vpid_byte2_b
    add_connection   ${ch1_rx_name}.rx_vpid_byte3_b                       ${loopback_name}.rx_vpid_byte3_b
    add_connection   ${ch1_rx_name}.rx_vpid_byte4_b                       ${loopback_name}.rx_vpid_byte4_b

    if { $b2a } {
       add_connection   ${ch1_rx_name}.rx_dataout_b                            ${loopback_name}.rx_data_b
       add_connection   ${ch1_rx_name}.rx_dataout_valid_b                      ${loopback_name}.rx_data_valid_b
    }

    # Output from Ch2 PHY Adapter
    add_connection   ch2_phy_adapter_tx_clkout_fanout.sig_fanout1         ${ch1_rx_name}.rx_clkin_smpte372

    # Output from Loopback
    add_connection   ${loopback_name}.tx_data                             ${ch2_tx_name}.tx_datain
    add_connection   ${loopback_name}.tx_data_valid_out                   ${ch2_tx_name}.tx_datain_valid
    add_connection   ${loopback_name}.tx_trs                              ${ch2_tx_name}.tx_trs
    add_connection   ${loopback_name}.tx_enable_crc                       ${ch2_tx_name}.tx_enable_crc
    add_connection   ${loopback_name}.tx_enable_ln                        ${ch2_tx_name}.tx_enable_ln
    add_connection   ${loopback_name}.tx_ln                               ${ch2_tx_name}.tx_ln
    add_connection   ${loopback_name}.tx_ln_b                             ${ch2_tx_name}.tx_ln_b
    add_connection   ${loopback_name}.tx_vpid_overwrite                   ${ch2_tx_name}.tx_vpid_overwrite
    add_connection   ${loopback_name}.tx_vpid_byte1                       ${ch2_tx_name}.tx_vpid_byte1
    add_connection   ${loopback_name}.tx_vpid_byte2                       ${ch2_tx_name}.tx_vpid_byte2
    add_connection   ${loopback_name}.tx_vpid_byte3                       ${ch2_tx_name}.tx_vpid_byte3
    add_connection   ${loopback_name}.tx_vpid_byte4                       ${ch2_tx_name}.tx_vpid_byte4
    add_connection   ${loopback_name}.tx_line_f0                          ${ch2_tx_name}.tx_line_f0
    add_connection   ${loopback_name}.tx_line_f1                          ${ch2_tx_name}.tx_line_f1
    add_connection   ${loopback_name}.tx_vpid_byte1_b                     ${ch2_tx_name}.tx_vpid_byte1_b
    add_connection   ${loopback_name}.tx_vpid_byte2_b                     ${ch2_tx_name}.tx_vpid_byte2_b
    add_connection   ${loopback_name}.tx_vpid_byte3_b                     ${ch2_tx_name}.tx_vpid_byte3_b
    add_connection   ${loopback_name}.tx_vpid_byte4_b                     ${ch2_tx_name}.tx_vpid_byte4_b

    if { $b2a } {
       add_connection   ${loopback_name}.tx_trs_b                              ${ch2_tx_name}.tx_trs_b
       add_connection   ${loopback_name}.tx_data_b                             ${ch2_tx_name}.tx_datain_b
       add_connection   ${loopback_name}.tx_data_valid_out_b                   ${ch2_tx_name}.tx_datain_valid_b
    } else {
       add_connection   ${loopback_name}.tx_std                              ${ch2_tx_name}.tx_std
    }

    # Output from Ch2 Core
    add_connection   ${ch2_tx_name}.tx_dataout_valid                      ${loopback_name}.tx_data_valid
    add_connection   ${ch2_tx_name}.tx_dataout                            ch2_phy_adapter.xcvr_tx_datain
    add_connection   ${ch2_rx_name}.gxb_ltd                               ch2_rx_native_phy.rx_set_locktodata
    add_connection   ${ch2_rx_name}.gxb_ltr                               ${ch2_rx_name}_rx_set_locktoref_fanout.sig_input
    add_connection   ${ch2_rx_name}_rx_set_locktoref_fanout.sig_fanout0     ch2_rx_native_phy.rx_set_locktoref
    add_connection   ${ch2_rx_name}_rx_set_locktoref_fanout.sig_fanout1     ch2_phy_adapter.rx_set_locktoref
    add_connection   ${ch2_rx_name}.trig_rst_ctrl                         ch2_rx_xcvr_rst_ctrl_reset_sync.reset_in0

    if { $b2a } {
       add_connection   ${ch2_tx_name}.tx_dataout_valid_b                      ${loopback_name}.tx_data_valid_b
       add_connection   ${ch2_tx_name}.tx_dataout_b                            ch2_phy_adapter.xcvr_tx_datain_b
       add_connection   ${ch2_rx_name}.gxb_ltd_b                               ch2_rx_native_phy_b.rx_set_locktodata
       add_connection   ${ch2_rx_name}.gxb_ltr_b                               ${ch2_rx_name}_rx_set_locktoref_b_fanout.sig_input
       add_connection   ${ch2_rx_name}_rx_set_locktoref_b_fanout.sig_fanout0                               ch2_rx_native_phy_b.rx_set_locktoref
       add_connection   ${ch2_rx_name}_rx_set_locktoref_b_fanout.sig_fanout1                               ch2_phy_adapter.rx_set_locktoref_b
    }
}