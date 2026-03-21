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


proc compose_tb_arria_10 {dir video_std crc_err a2b b2a disturb_serial dl_sync cmp_data insert_vpid extract_vpid trs_test frame_test rxsample_test pll_switch} {

    set  inst1  [get_parameter_value INST1]
    set  inst3  [get_parameter_value INST3]

    # Output from test cotnrol
    add_connection  tb_test_control.tx_rst_ch0      example_design.ch0_tx_rst
    add_connection  tb_test_control.rx_rst_ch0      example_design.ch0_rx_rst
    add_connection  tb_test_control.tx_xcvr_refclk  example_design.ch0_tx_pll_refclk
    add_connection  tb_test_control.rx_xcvr_refclk  example_design.ch0_rx_cdr_refclk
    add_connection  tb_test_control.rx_coreclk      example_design.ch0_rx_coreclk
    add_connection  tb_test_control.tx_coreclk      example_design.ch0_tx_xcvr_rst_ctrl_clk

    add_connection  tb_test_control.rx_rst               example_design.ch1_rx_rst
    add_connection  tb_test_control.tx_rst               example_design.ch1_tx_rst
    add_connection  tb_test_control.tx_xcvr_refclk  example_design.ch1_tx_pll_refclk
    add_connection  tb_test_control.rx_xcvr_refclk  example_design.ch1_rx_cdr_refclk
    add_connection  tb_test_control.rx_coreclk      example_design.ch1_rx_coreclk
    add_connection  tb_test_control.tx_coreclk      example_design.ch1_tx_xcvr_rst_ctrl_clk

    add_connection  tb_test_control.pattgen_bar_100_75n  example_design.pattgen_bar_100_75n
    add_connection  tb_test_control.pattgen_patho        example_design.pattgen_patho
    add_connection  tb_test_control.pattgen_blank        example_design.pattgen_blank
    add_connection  tb_test_control.pattgen_no_color     example_design.pattgen_no_color
    add_connection  tb_test_control.pattgen_sgmt_frame   example_design.pattgen_sgmt_frame
    add_connection  tb_test_control.pattgen_dl_mapping   example_design.pattgen_dl_mapping
    add_connection  tb_test_control.pattgen_tx_format    example_design.pattgen_tx_format
    add_connection  tb_test_control.pattgen_ntsc_paln    example_design.pattgen_ntsc_paln

    add_connection  tb_test_control.rx_chk_dl_mapping   tb_rx_checker.dl_mapping
    add_connection  tb_test_control.rx_chk_rst          tb_rx_checker.ref_rst
    add_connection  tb_test_control.rx_chk_refclk       tb_rx_checker.rx_refclk
    add_connection  tb_test_control.rx_chk_start_chk    tb_rx_checker.chk_rx
    add_connection  tb_test_control.rx_chk_tx_format    tb_rx_checker.tx_format
    add_connection  tb_test_control.pattgen_tx_std      example_design.pattgen_tx_std

    add_connection  tb_test_control.tx_chk_tx_std       tb_tx_checker.tx_std
    add_connection  tb_test_control.tx_status           tb_tx_checker.tx_status
    add_connection  tb_test_control.tx_chk_start_chk    tb_tx_checker.chk_tx
    add_connection  tb_test_control.tx_chk_refclk       tb_tx_checker.ref_clk

    if { $video_std != "sd" } {
       add_connection  tb_test_control.tx_enable_crc  example_design.${inst1}_tx_enable_crc       
       add_connection  tb_test_control.tx_enable_ln   example_design.${inst1}_tx_enable_ln

       if { ($video_std == "threeg" | $video_std == "mr" | $video_std == "tr") & !$b2a } {
          add_instance            tx_std_fanout                 altera_fanout
          set_instance_parameter  tx_std_fanout                 WIDTH                        3

          add_connection  tb_test_control.tx_std          tx_std_fanout.sig_input
          add_connection  tx_std_fanout.sig_fanout0       example_design.${inst1}_tx_std
          add_connection  tx_std_fanout.sig_fanout1       tb_rx_checker.tx_std
       } elseif { $b2a } {
          add_connection  tb_test_control.tx_std          example_design.${inst1}_tx_std
       }

       if { $video_std == "tr" | $video_std == "mr" } {
          add_connection  tb_test_control.reconfig_clk             example_design.ch0_reconfig_clk
          add_connection  tb_test_control.reconfig_clk             example_design.ch1_reconfig_clk
          add_connection  tb_test_control.reconfig_rst             example_design.ch0_reconfig_rst
          add_connection  tb_test_control.reconfig_rst             example_design.ch1_reconfig_rst
       }
    }

    if { $insert_vpid } {
       add_connection  tb_test_control.tx_vpid_overwrite  example_design.${inst1}_tx_vpid_overwrite
    }

    if { $a2b | $b2a } {
       add_connection  tb_test_control.rx_coreclk_smpte372      example_design.ch2_rx_coreclk
       add_connection  tb_test_control.tx_coreclk_smpte372      example_design.ch2_tx_xcvr_rst_ctrl_clk
       add_connection  tb_test_control.rx_xcvr_refclk_smpte372  example_design.ch2_rx_cdr_refclk
       add_connection  tb_test_control.tx_xcvr_refclk_smpte372  example_design.ch2_tx_pll_refclk
       add_connection  tb_test_control.tx_rst_smpte372          example_design.ch2_tx_rst
       add_connection  tb_test_control.rx_rst_smpte372          example_design.ch2_rx_rst
    }

    if { $pll_switch != "0" } {
       add_connection  tb_test_control.tx_xcvr_refclk_alt       example_design.ch1_tx_pll_refclk_alt
       if { $pll_switch == "1" & $video_std == "dl" } {
          add_instance              tx_sdi_pll_sel_fanout       altera_fanout
       }
       add_connection  tb_test_control.tx_sdi_start_reconfig    tb_rx_checker.tx_sdi_start_reconfig
       if { $pll_switch == "1" & $video_std == "dl" } {
          add_connection  tb_test_control.tx_sdi_pll_sel           tx_sdi_pll_sel_fanout.sig_input
          add_connection  tx_sdi_pll_sel_fanout.sig_fanout0        example_design.ch1_tx_reconfig_pll_sel
          add_connection  tx_sdi_pll_sel_fanout.sig_fanout1        example_design.ch1_tx_reconfig_b_pll_sel
          add_connection  tb_test_control.reconfig_clk             example_design.ch1_reconfig_clk
          add_connection  tb_test_control.reconfig_rst             example_design.ch1_reconfig_rst
       } else {
          add_connection  tb_test_control.tx_sdi_pll_sel        example_design.ch1_tx_reconfig_pll_sel
          if { $video_std != "tr" & $video_std != "mr" } {
             add_connection  tb_test_control.reconfig_clk             example_design.ch1_reconfig_clk
             add_connection  tb_test_control.reconfig_rst             example_design.ch1_reconfig_rst
          }
       }
    }

    # Output from Tx Checker
    if { $pll_switch != "0" } {
       add_connection  tb_tx_checker.tx_clkout_match              tb_test_control.tx_clkout_match
    }

    # Output from Rx Checker
    add_connection  tb_rx_checker.rxcheck_done                     tb_test_control.rx_chk_done
    add_connection  tb_rx_checker.chk_completed                    tb_test_control.rx_chk_completed
    if { $pll_switch != "0" } {
       add_connection  tb_rx_checker.rx_check_posedge              tb_test_control.rx_check_posedge
    }

    # Output from Example Design
    if { $a2b | $b2a } {
       add_connection  example_design.${inst3}_rx_rst_proto_out tb_test_control.rx_rst_proto
       add_connection  example_design.ch2_tx_pll_pll_locked     tb_test_control.tx_pll_locked
    } else {
       add_connection  example_design.ch1_tx_pll_pll_locked     tb_test_control.tx_pll_locked
    }

    if { $pll_switch != "0" } {
       add_connection  example_design.ch1_tx_reconfig_pll_sw_busy     tb_rx_checker.tx_sdi_reconfig_done
       add_connection  example_design.ch1_tx_native_phy_tx_clkout     tb_tx_checker.tx_clkout

       if { $pll_switch == "1" } {
            add_connection  example_design.ch1_tx_pll_alt_pll_locked       tb_test_control.tx_pll_locked_alt
       }
    }

    # Determine the TX and RX cores that need to be checked against
    if { $a2b } {
      set  ch_to_check    ch2
      set  tx_to_check    ch2_smpte372_tx_3g
      set  rx_to_check    ch2_smpte372_rx_3g
    } elseif { $b2a } {
      set  ch_to_check    ch2
      set  tx_to_check    ch2_smpte372_tx_dl
      set  rx_to_check    ch2_smpte372_rx_dl
    } else {
      set  ch_to_check    ch1
      set  tx_to_check    $inst1
      set  rx_to_check    $inst3
    }

    # Data signal connections (Serial loopback)
    add_instance            tb_fanout_serial_a          altera_fanout
    set_instance_parameter  tb_fanout_serial_a          SPECIFY_SIGNAL_TYPE    1
    set_instance_parameter  tb_fanout_serial_a          SIGNAL_TYPE            tx_serial_data
    add_connection          example_design.${ch_to_check}_tx_native_phy_tx_serial_data  tb_fanout_serial_a.sig_input
    add_connection          tb_fanout_serial_a.sig_fanout0  tb_test_control.tx_sdi_serial
    add_connection          tb_fanout_serial_a.sig_fanout1  tb_tx_checker.sdi_serial

    if { ($video_std == "dl" & !$a2b) | $b2a } {
        add_instance            tb_fanout_serial_b                      altera_fanout
        set_instance_parameter  tb_fanout_serial_b                SPECIFY_SIGNAL_TYPE    1
        set_instance_parameter  tb_fanout_serial_b                SIGNAL_TYPE            tx_serial_data
        add_connection          example_design.${ch_to_check}_tx_native_phy_b_tx_serial_data  tb_fanout_serial_b.sig_input
        add_connection          tb_fanout_serial_b.sig_fanout0   tb_test_control.tx_sdi_serial_b
        add_connection          tb_fanout_serial_b.sig_fanout1   tb_tx_checker.sdi_serial_b
    }


    add_connection  example_design.ch1_tx_xcvr_rst_ctrl_tx_ready     tb_test_control.tx_ready  
    add_connection  tb_test_control.rx_sdi_serial   example_design.${ch_to_check}_rx_native_phy_rx_serial_data

      if { $a2b } {
        add_connection  example_design.ch1_tx_native_phy_tx_serial_data    tb_test_control.tx_sdi_serial_ch1_smpte372
        add_connection  example_design.ch1_tx_native_phy_b_tx_serial_data  tb_test_control.tx_sdi_serial_ch1_smpte372_b
        add_connection  tb_test_control.rx_sdi_serial_ch1_smpte372    example_design.ch1_rx_native_phy_rx_serial_data
        add_connection  tb_test_control.rx_sdi_serial_ch1_smpte372_b  example_design.ch1_rx_native_phy_b_rx_serial_data
      } elseif { $b2a } {
        add_connection  example_design.ch1_tx_native_phy_tx_serial_data   tb_test_control.tx_sdi_serial_ch1_smpte372
        add_connection  tb_test_control.rx_sdi_serial_ch1_smpte372        example_design.ch1_rx_native_phy_rx_serial_data
        add_connection  tb_test_control.rx_sdi_serial_b  example_design.${ch_to_check}_rx_native_phy_b_rx_serial_data
      } elseif { $video_std == "dl" } {
          add_connection  tb_test_control.rx_sdi_serial_b  example_design.${ch_to_check}_rx_native_phy_b_rx_serial_data
      }


    add_connection  example_design.${rx_to_check}_rx_align_locked  tb_rx_checker.align_locked
    add_connection  example_design.${rx_to_check}_rx_trs_locked    tb_rx_checker.trs_locked
    add_connection  example_design.${rx_to_check}_rx_frame_locked  tb_rx_checker.frame_locked
    add_connection  example_design.${rx_to_check}_rx_f             tb_rx_checker.rx_f
    add_connection  example_design.${rx_to_check}_rx_v             tb_rx_checker.rx_v
    add_connection  example_design.${rx_to_check}_rx_h             tb_rx_checker.rx_h
    add_connection  example_design.${rx_to_check}_rx_ap            tb_rx_checker.rx_ap
    add_connection  example_design.${rx_to_check}_rx_dataout        tb_rx_checker.rxdata
    add_connection  example_design.${rx_to_check}_rx_dataout_valid  tb_rx_checker.rxdata_valid
    add_connection  example_design.${ch_to_check}_rx_native_phy_rx_clkout   tb_rx_checker.rx_clk

    if { $video_std != "sd" } {
       add_connection  example_design.${rx_to_check}_rx_ln            tb_rx_checker.rx_ln

       if { $video_std == "threeg" | $video_std == "dl" | $video_std == "tr" | $video_std == "mr" } {
          add_connection  example_design.${rx_to_check}_rx_ln_b          tb_rx_checker.rx_ln_b
       }

       if { $video_std == "tr" | $video_std == "mr" } {
          add_connection  example_design.${ch_to_check}_reconfig_cdr_reconfig_busy    tb_rx_checker.rx_sdi_start_reconfig
       }
    }

    if { $video_std != "sd" & $video_std != "hd" & $video_std != "dl" & !$b2a } {
        add_connection  example_design.${rx_to_check}_rx_std             tb_rx_checker.rx_std
    }

    if { ($video_std == "dl" & !$a2b) | $b2a } {
       add_connection  example_design.${rx_to_check}_rx_align_locked_b   tb_rx_checker.align_locked_b
       add_connection  example_design.${rx_to_check}_rx_trs_locked_b     tb_rx_checker.trs_locked_b
       add_connection  example_design.${rx_to_check}_rx_dl_locked        tb_rx_checker.dl_locked
       add_connection  example_design.${rx_to_check}_rx_frame_locked_b   tb_rx_checker.frame_locked_b
       add_connection  example_design.${rx_to_check}_rx_dataout_b        tb_rx_checker.rxdata_b
       add_connection  example_design.${rx_to_check}_rx_dataout_valid_b  tb_rx_checker.rxdata_valid_b
    }

    if { $crc_err } {
       add_connection  example_design.${rx_to_check}_rx_crc_error_c  tb_rx_checker.rx_crc_error_c
       add_connection  example_design.${rx_to_check}_rx_crc_error_y  tb_rx_checker.rx_crc_error_y

       if { $video_std == "threeg" | $video_std == "dl" | $video_std == "tr" | $video_std == "mr" } {
          add_connection  example_design.${rx_to_check}_rx_crc_error_c_b  tb_rx_checker.rx_crc_error_c_b
          add_connection  example_design.${rx_to_check}_rx_crc_error_y_b  tb_rx_checker.rx_crc_error_y_b
       }
    }

    if { $extract_vpid } {
      add_connection  example_design.${rx_to_check}_rx_vpid_byte1           tb_rx_checker.rx_vpid_byte1
      add_connection  example_design.${rx_to_check}_rx_vpid_byte2           tb_rx_checker.rx_vpid_byte2
      add_connection  example_design.${rx_to_check}_rx_vpid_byte3           tb_rx_checker.rx_vpid_byte3
      add_connection  example_design.${rx_to_check}_rx_vpid_byte4           tb_rx_checker.rx_vpid_byte4
      add_connection  example_design.${rx_to_check}_rx_vpid_valid           tb_rx_checker.rx_vpid_valid
      add_connection  example_design.${rx_to_check}_rx_vpid_checksum_error  tb_rx_checker.rx_vpid_checksum_error
      add_connection  example_design.${rx_to_check}_rx_line_f0              tb_rx_checker.rx_line_f0
      add_connection  example_design.${rx_to_check}_rx_line_f1              tb_rx_checker.rx_line_f1
      if { $video_std == "threeg" | $video_std == "dl" | $video_std == "tr" | $video_std == "mr" } {
        add_connection  example_design.${rx_to_check}_rx_vpid_byte1_b           tb_rx_checker.rx_vpid_byte1_b
        add_connection  example_design.${rx_to_check}_rx_vpid_byte2_b           tb_rx_checker.rx_vpid_byte2_b
        add_connection  example_design.${rx_to_check}_rx_vpid_byte3_b           tb_rx_checker.rx_vpid_byte3_b
        add_connection  example_design.${rx_to_check}_rx_vpid_byte4_b           tb_rx_checker.rx_vpid_byte4_b
        add_connection  example_design.${rx_to_check}_rx_vpid_valid_b           tb_rx_checker.rx_vpid_valid_b
        add_connection  example_design.${rx_to_check}_rx_vpid_checksum_error_b  tb_rx_checker.rx_vpid_checksum_error_b
      }
    }

    if { $frame_test } {
      add_connection  example_design.${rx_to_check}_rx_format  tb_rx_checker.rx_format
    }

    if { $trs_test | $frame_test | $rxsample_test | $dl_sync } {
      add_connection  example_design.${rx_to_check}_rx_eav  tb_rx_checker.rx_eav
      add_connection  example_design.${rx_to_check}_rx_trs  tb_rx_checker.rx_trs
     }

    if { $cmp_data } {
      add_connection  example_design.${ch_to_check}_tx_native_phy_tx_clkout     tb_rx_checker.tx_clk
      add_connection  example_design.pattgen_dout_valid                         tb_rx_checker.txdata_valid
      add_connection  example_design.pattgen_dout                               tb_rx_checker.txdata
      if { $video_std == "dl" & !$a2b } {
        add_connection  example_design.pattgen_dout_b        tb_rx_checker.txdata_b
        add_connection  example_design.pattgen_dout_valid_b  tb_rx_checker.txdata_valid_b
      }
    }
}