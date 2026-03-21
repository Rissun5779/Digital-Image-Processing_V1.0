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


# +--------------------------------------------------------
# | 2011-09-19
#
# Add, export and rename interface in example design level
#
proc tx_protocol__add_export_rename_interface {instance std dl_sync insert_vpid trs_test frame_test} {

  if { $std != "sd" } {
    add_export_rename_interface $instance tx_enable_crc       conduit input
    add_export_rename_interface $instance tx_enable_ln       conduit input
  }
  if { $insert_vpid } {
    # add_export_rename_interface $instance tx_enable_vpid_c  conduit input
    add_export_rename_interface $instance tx_vpid_overwrite  conduit input
  }
  if { $dl_sync | $trs_test | $frame_test } {
    add_export_rename_interface     $instance   tx_datain           conduit input
    add_export_rename_interface     $instance   tx_datain_valid     conduit input
    add_export_rename_interface     $instance   tx_trs              conduit input
    if { $std == "dl" } {
      add_export_rename_interface   $instance   tx_datain_b         conduit input
      add_export_rename_interface   $instance   tx_datain_valid_b   conduit input
      add_export_rename_interface   $instance   tx_trs_b            conduit input
    }
  }
  if { $std == "threeg" | $std == "ds" | $std == "tr" } {
    add_export_rename_interface     $instance   tx_std              conduit input
  }

  #if { $std == "dl" } {
  #  add_export_rename_interface $instance tx_enable_crc_b conduit input
  #  add_export_rename_interface $instance tx_enable_ln_b  conduit input
  #}
}

proc tx_phy_mgmt__add_export_rename_interface {instance config std} {
  # if {$config == "xcvr"} {
    #add_export_rename_interface $instance tx_std     conduit input
  # }
  add_export_fanout_rename_interface  $instance   tx_dataout_valid     conduit output

  if { $std == "dl" } {
    add_export_rename_interface       $instance   tx_dataout_valid_b   conduit output
  }
}

proc tx_phy__add_export_rename_interface {instance std xcvr_tx_pll_sel} {
  add_export_rename_interface     $instance   sdi_tx              conduit output
  add_export_rename_interface     $instance   tx_pll_locked       conduit output
  
  if { $xcvr_tx_pll_sel == "1" } {
    add_export_rename_interface   $instance   tx_pll_locked_alt   conduit output
  }

  if { $std == "dl" } {
    add_export_rename_interface   $instance   sdi_tx_b            conduit output
    #add_export_rename_interface $instance tx_pll_locked_b     conduit output
  }
}

proc rx_phy__add_export_rename_interface {instance std} {
  add_export_rename_interface     $instance   sdi_rx            conduit input
  # add_export_rename_interface     $instance   rx_pll_locked     conduit output

  if { $std == "dl" } {
    add_export_rename_interface   $instance   sdi_rx_b          conduit input
    # add_export_rename_interface   $instance   rx_pll_locked_b   conduit output
  }
}

proc rx_phy_mgmt__add_export_rename_interface {instance std config} {
  # add_export_rename_interface $instance rx_enable_sd_search conduit input
  # add_export_rename_interface $instance rx_enable_hd_search conduit input
  # add_export_rename_interface $instance rx_enable_3g_search conduit input
  if { ($config != "xcvr_proto" & ( $instance != "ch2_smpte372_rx_3g" & $instance != "ch2_smpte372_rx_dl" ) ) | $instance == "ch0_loopback_du_${std}" } {
     add_export_fanout_rename_interface   $instance   rx_rst_proto_out          conduit output
  } else {
     add_export_rename_interface          $instance   rx_rst_proto_out          conduit output
  }

  if { $std != "sd" } {
    add_export_rename_interface           $instance   rx_coreclk_is_ntsc_paln   conduit input
    add_export_rename_interface           $instance   rx_clkout_is_ntsc_paln    conduit output
  }

  if { $std == "ds" | $std == "tr" } {
    add_export_fanout_rename_interface    $instance   rx_sdi_start_reconfig     conduit output
  }

  # if { $std == "threeg" | $std == "ds" | $std == "tr" } {
    # add_interface          ${instance}_rx_std   conduit        output
    # set_interface_property ${instance}_rx_std   export_of      rx_std_fanout.sig_fanout0
    # set_interface_property ${instance}_rx_std   PORT_NAME_MAP "${instance}_rx_std sig_fanout0"
    # # add_export_rename_interface $instance rx_std              conduit output
  # }
}

proc rx_protocol__add_export_rename_interface {instance std crc_err vpid_bytes_out a2b b2a } {
  if { $std == "ds" | $std == "tr" | ($std == "threeg" & $instance == "ch0_loopback_du_${std}") } {
     add_export_fanout_rename_interface  $instance   rx_std   conduit output
  } elseif { $std == "threeg" } {
     add_export_rename_interface         $instance   rx_std   conduit output
  }
  
  add_export_rename_interface $instance rx_align_locked  conduit output
  add_export_rename_interface $instance rx_f             conduit output
  add_export_rename_interface $instance rx_v             conduit output
  add_export_rename_interface $instance rx_h             conduit output
  add_export_rename_interface $instance rx_ap            conduit output
  add_export_rename_interface $instance rx_format        conduit output
  add_export_rename_interface $instance rx_eav           conduit output

  if { $instance == "ch0_loopback_du_${std}" } {
    add_instance                        ${instance}_rx_trs_locked_fanout       altera_fanout
    add_instance                        ${instance}_rx_frame_locked_fanout     altera_fanout
    add_export_fanout_rename_interface  $instance   rx_trs_locked    conduit   output
    add_export_fanout_rename_interface  $instance   rx_frame_locked  conduit   output
  } else {
    add_export_rename_interface         $instance   rx_trs_locked    conduit   output
    add_export_rename_interface         $instance   rx_frame_locked  conduit   output
  }

  if { $crc_err } {
    add_export_rename_interface         $instance   rx_crc_error_c   conduit   output
    add_export_rename_interface         $instance   rx_crc_error_y   conduit   output
    if { $std == "threeg" | $std == "dl" | $std == "tr" } {
      add_export_rename_interface       $instance   rx_crc_error_c_b conduit   output
      add_export_rename_interface       $instance   rx_crc_error_y_b conduit   output
    }
  }

  if { $std != "sd" } {
    if { $instance == "ch0_loopback_du_${std}" && $vpid_bytes_out } {
      add_instance                         ${instance}_rx_ln_fanout  altera_fanout
      set_instance_parameter               ${instance}_rx_ln_fanout  WIDTH   11
      add_export_fanout_rename_interface   $instance   rx_ln         conduit   output
    } elseif { ($a2b | $b2a) & $instance != "ch0_loopback_du_${std}" & $instance != "ch2_smpte372_rx_3g" & $instance != "ch2_smpte372_rx_dl" } {
      add_instance                         ${instance}_rx_ln_fanout  altera_fanout
      set_instance_parameter               ${instance}_rx_ln_fanout  WIDTH   11
      add_export_fanout_rename_interface   $instance   rx_ln         conduit   output
    } else {
      add_export_rename_interface          $instance   rx_ln         conduit output
    }
  }

  if { $std == "threeg" | $std == "dl" | $std == "tr" } {
    if { $instance == "ch0_loopback_du_${std}" && $vpid_bytes_out } {
      add_instance                         ${instance}_rx_ln_b_fanout   altera_fanout
      set_instance_parameter               ${instance}_rx_ln_b_fanout   WIDTH   11
      add_export_fanout_rename_interface   $instance   rx_ln_b          conduit   output
    } elseif { ($a2b | $b2a) & $instance != "ch0_loopback_du_${std}" & $instance != "ch2_smpte372_rx_3g" & $instance != "ch2_smpte372_rx_dl" } {
      add_instance                         ${instance}_rx_ln_b_fanout   altera_fanout
      set_instance_parameter               ${instance}_rx_ln_b_fanout   WIDTH   11
      add_export_fanout_rename_interface   $instance   rx_ln_b          conduit   output
    } else {
       add_export_rename_interface         $instance   rx_ln_b          conduit output
    }
  }

  # if { $trs_misc } {
    # add_export_rename_interface $instance rx_xyz           conduit output
    # add_export_rename_interface $instance rx_xyz_valid     conduit output
  # }

  #add_export_rename_interface $instance rx_anc_dataout   conduit output
  #add_export_rename_interface $instance rx_anc_valid     conduit output
  #add_export_rename_interface $instance rx_anc_error     conduit output
  if { $instance == "ch0_loopback_du_${std}" } {
     add_instance                         ${instance}_rx_dataout_fanout         altera_fanout
     set_instance_parameter               ${instance}_rx_dataout_fanout         WIDTH   20
     add_instance                         ${instance}_rx_dataout_valid_fanout   altera_fanout

     add_export_fanout_rename_interface   $instance   rx_dataout                conduit   output
     add_export_fanout_rename_interface   $instance   rx_dataout_valid          conduit   output

  } elseif { ($a2b | $b2a) & $instance != "ch0_loopback_du_${std}" & $instance != "ch2_smpte372_rx_3g" & $instance != "ch2_smpte372_rx_dl" } {
     add_instance                         ${instance}_rx_dataout_fanout         altera_fanout
     set_instance_parameter               ${instance}_rx_dataout_fanout         WIDTH   20
     add_instance                         ${instance}_rx_dataout_valid_fanout   altera_fanout

     add_export_fanout_rename_interface   $instance   rx_dataout                conduit   output
     add_export_fanout_rename_interface   $instance   rx_dataout_valid          conduit   output
  } else {
     add_export_rename_interface          $instance   rx_dataout                conduit output
     add_export_rename_interface          $instance   rx_dataout_valid          conduit output
  }
  #add_export_rename_interface $instance rx_clkout        clock   output

  if { $b2a & $instance != "ch0_loopback_du_${std}" & $instance != "ch2_smpte372_rx_dl" } {
     add_instance                         ${instance}_rx_dataout_b_fanout             altera_fanout
     set_instance_parameter               ${instance}_rx_dataout_b_fanout             WIDTH   20
     add_instance                         ${instance}_rx_dataout_valid_b_fanout       altera_fanout

     add_export_fanout_rename_interface   $instance   rx_dataout_b                    conduit   output
     add_export_fanout_rename_interface   $instance   rx_dataout_valid_b              conduit   output
  }

  if { $std == "dl" } {
    add_export_rename_interface           $instance   rx_align_locked_b               conduit output
    add_export_rename_interface           $instance   rx_trs_locked_b                 conduit output
    add_export_rename_interface           $instance   rx_frame_locked_b               conduit output
    add_export_rename_interface           $instance   rx_dl_locked                    conduit output

    if { $instance == "ch0_loopback_du_${std}" } {
      add_instance                        ${instance}_rx_dataout_b_fanout             altera_fanout
      set_instance_parameter              ${instance}_rx_dataout_b_fanout             WIDTH   20
      add_instance                        ${instance}_rx_dataout_valid_b_fanout       altera_fanout

      add_export_fanout_rename_interface  $instance   rx_dataout_b                    conduit   output
      add_export_fanout_rename_interface  $instance   rx_dataout_valid_b              conduit   output
    } else {
      if { !$a2b } {
         add_export_rename_interface         $instance   rx_dataout_b                    conduit output
         add_export_rename_interface         $instance   rx_dataout_valid_b              conduit output
      }
    }
  }

  if { $vpid_bytes_out } {
    add_export_rename_interface           $instance   rx_vpid_valid                   conduit output
    add_export_rename_interface           $instance   rx_vpid_checksum_error          conduit output
    if { $std == "dl" | $std == "threeg" | $std == "tr"} {
      add_export_rename_interface         $instance   rx_vpid_valid_b                 conduit output
      add_export_rename_interface         $instance   rx_vpid_checksum_error_b        conduit output
    }

    if { $instance == "ch0_loopback_du_${std}" } {
      add_instance            ${instance}_rx_vpid_byte1_fanout         altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte1_fanout         WIDTH   8
      add_instance            ${instance}_rx_vpid_byte2_fanout         altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte2_fanout         WIDTH   8
      add_instance            ${instance}_rx_vpid_byte3_fanout         altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte3_fanout         WIDTH   8
      add_instance            ${instance}_rx_vpid_byte4_fanout         altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte4_fanout         WIDTH   8
      add_instance            ${instance}_rx_line_f0_fanout            altera_fanout
      set_instance_parameter  ${instance}_rx_line_f0_fanout            WIDTH   11
      add_instance            ${instance}_rx_line_f1_fanout            altera_fanout
      set_instance_parameter  ${instance}_rx_line_f1_fanout            WIDTH   11

      add_export_fanout_rename_interface  $instance   rx_vpid_byte1   conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte2   conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte3   conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte4   conduit   output
      add_export_fanout_rename_interface  $instance   rx_line_f0      conduit   output
      add_export_fanout_rename_interface  $instance   rx_line_f1      conduit   output

      if { $std == "dl" | $std == "threeg" | $std == "tr"} {
        add_instance            ${instance}_rx_vpid_byte1_b_fanout       altera_fanout
        set_instance_parameter  ${instance}_rx_vpid_byte1_b_fanout       WIDTH   8
        add_instance            ${instance}_rx_vpid_byte2_b_fanout       altera_fanout
        set_instance_parameter  ${instance}_rx_vpid_byte2_b_fanout       WIDTH   8
        add_instance            ${instance}_rx_vpid_byte3_b_fanout       altera_fanout
        set_instance_parameter  ${instance}_rx_vpid_byte3_b_fanout       WIDTH   8
        add_instance            ${instance}_rx_vpid_byte4_b_fanout       altera_fanout
        set_instance_parameter  ${instance}_rx_vpid_byte4_b_fanout       WIDTH   8

        add_export_fanout_rename_interface  $instance   rx_vpid_byte1_b   conduit   output
        add_export_fanout_rename_interface  $instance   rx_vpid_byte2_b   conduit   output
        add_export_fanout_rename_interface  $instance   rx_vpid_byte3_b   conduit   output
        add_export_fanout_rename_interface  $instance   rx_vpid_byte4_b   conduit   output
      }
   } elseif { ($a2b | $b2a) & $instance != "ch0_loopback_du_${std}" & $instance != "ch2_smpte372_rx_3g" & $instance != "ch2_smpte372_rx_dl" } {
      add_instance            ${instance}_rx_vpid_byte1_fanout         altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte1_fanout         WIDTH   8
      add_instance            ${instance}_rx_vpid_byte2_fanout         altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte2_fanout         WIDTH   8
      add_instance            ${instance}_rx_vpid_byte3_fanout         altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte3_fanout         WIDTH   8
      add_instance            ${instance}_rx_vpid_byte4_fanout         altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte4_fanout         WIDTH   8
      add_instance            ${instance}_rx_line_f0_fanout            altera_fanout
      set_instance_parameter  ${instance}_rx_line_f0_fanout            WIDTH   11
      add_instance            ${instance}_rx_line_f1_fanout            altera_fanout
      set_instance_parameter  ${instance}_rx_line_f1_fanout            WIDTH   11
      add_instance            ${instance}_rx_vpid_byte1_b_fanout       altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte1_b_fanout       WIDTH   8
      add_instance            ${instance}_rx_vpid_byte2_b_fanout       altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte2_b_fanout       WIDTH   8
      add_instance            ${instance}_rx_vpid_byte3_b_fanout       altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte3_b_fanout       WIDTH   8
      add_instance            ${instance}_rx_vpid_byte4_b_fanout       altera_fanout
      set_instance_parameter  ${instance}_rx_vpid_byte4_b_fanout       WIDTH   8

      add_export_fanout_rename_interface  $instance   rx_vpid_byte1   conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte2   conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte3   conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte4   conduit   output
      add_export_fanout_rename_interface  $instance   rx_line_f0      conduit   output
      add_export_fanout_rename_interface  $instance   rx_line_f1      conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte1_b   conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte2_b   conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte3_b   conduit   output
      add_export_fanout_rename_interface  $instance   rx_vpid_byte4_b   conduit   output
    } else {
      add_export_rename_interface $instance rx_vpid_byte1             conduit output
      add_export_rename_interface $instance rx_vpid_byte2             conduit output
      add_export_rename_interface $instance rx_vpid_byte3             conduit output
      add_export_rename_interface $instance rx_vpid_byte4             conduit output
      add_export_rename_interface $instance rx_line_f0                conduit output
      add_export_rename_interface $instance rx_line_f1                conduit output
      if { $std == "dl" | $std == "threeg" | $std == "tr"} {
        add_export_rename_interface $instance rx_vpid_byte1_b           conduit output
        add_export_rename_interface $instance rx_vpid_byte2_b           conduit output
        add_export_rename_interface $instance rx_vpid_byte3_b           conduit output
        add_export_rename_interface $instance rx_vpid_byte4_b           conduit output
      }
    }
  }
}

# +---------------------------------------------------------------------------------
# | Export interface ports to the example design top level
# | 

# Export common signals
#
proc common_add_export_rename_interface {instance} {
  add_export_rename_interface  $instance gxb_powerdown  conduit input
}

# +-------------------------
# | Connect the instances
# |

# Connect the common transceiver clock signals
#
proc add_common_xcvr_reconfig_clk_connection {instance} {
  add_connection  clk_fpga_bridge.out_clk      $instance.gxb_cal_clk
  add_connection  reconfig_clk_bridge.out_clk  $instance.gxb_reconfig_clk   
}

# Connect the pattern generator with Tx protocol
#

proc add_pattgen_dut_connection {instance1 instance2 insert_vpid std a2b b2a dl_sync trs_test frame_test cmp_data} {

  if { $cmp_data } {
    add_instance            pattgen_dout_fanout               altera_fanout
    set_instance_parameter  pattgen_dout_fanout               WIDTH   20
    add_connection          pattgen.dout                      pattgen_dout_fanout.sig_input
    add_connection          pattgen_dout_fanout.sig_fanout1   $instance1.tx_datain

    add_instance            pattgen_dout_valid_fanout               altera_fanout
    add_connection          pattgen.dout_valid                      pattgen_dout_valid_fanout.sig_input
    add_connection          pattgen_dout_valid_fanout.sig_fanout1   $instance1.tx_datain_valid

    add_connection          pattgen.trs         $instance1.tx_trs

    if { $std == "dl" } {
      add_instance            pattgen_dout_b_fanout               altera_fanout
      set_instance_parameter  pattgen_dout_b_fanout               WIDTH   20
      add_connection          pattgen.dout_b                      pattgen_dout_b_fanout.sig_input
      add_connection          pattgen_dout_b_fanout.sig_fanout1   $instance1.tx_datain_b

      add_instance            pattgen_dout_valid_b_fanout               altera_fanout
      add_connection          pattgen.dout_valid_b                      pattgen_dout_valid_b_fanout.sig_input
      add_connection          pattgen_dout_valid_b_fanout.sig_fanout1   $instance1.tx_datain_valid_b

      add_connection          pattgen.trs_b         $instance1.tx_trs_b
    }

  } elseif { !($dl_sync | $trs_test | $frame_test) } {

    add_connection  pattgen.dout        $instance1.tx_datain
    add_connection  pattgen.dout_valid  $instance1.tx_datain_valid  
    add_connection  pattgen.trs         $instance1.tx_trs   

    if { $std == "dl" } {
      add_connection  pattgen.dout_b        $instance1.tx_datain_b
      add_connection  pattgen.dout_valid_b  $instance1.tx_datain_valid_b
      add_connection  pattgen.trs_b         $instance1.tx_trs_b
    }
  }
  
  if {$insert_vpid} {
    add_instance            pattgen_line_f0_fanout               altera_fanout
    set_instance_parameter  pattgen_line_f0_fanout               WIDTH 11
    add_connection          pattgen.line_f0                      pattgen_line_f0_fanout.sig_input
    add_connection          pattgen_line_f0_fanout.sig_fanout1   $instance1.tx_line_f0

    add_instance            pattgen_line_f1_fanout               altera_fanout
    set_instance_parameter  pattgen_line_f1_fanout               WIDTH 11
    add_connection          pattgen.line_f1                      pattgen_line_f1_fanout.sig_input
    add_connection          pattgen_line_f1_fanout.sig_fanout1   $instance1.tx_line_f1

    # add_connection  pattgen.line_f0       $instance1.tx_line_f0
    # add_connection  pattgen.line_f1       $instance1.tx_line_f1
    add_connection    pattgen.vpid_byte1    $instance1.tx_vpid_byte1
    add_connection    pattgen.vpid_byte2    $instance1.tx_vpid_byte2
    add_connection    pattgen.vpid_byte3    $instance1.tx_vpid_byte3
    add_connection    pattgen.vpid_byte4    $instance1.tx_vpid_byte4
    if { $std == "dl" | $std == "threeg" | $std == "tr"} {
      add_connection  pattgen.vpid_byte1_b  $instance1.tx_vpid_byte1_b
      add_connection  pattgen.vpid_byte2_b  $instance1.tx_vpid_byte2_b
      add_connection  pattgen.vpid_byte3_b  $instance1.tx_vpid_byte3_b
      add_connection  pattgen.vpid_byte4_b  $instance1.tx_vpid_byte4_b
    }
  } 
  
  if { $std != "sd" || $insert_vpid } {
    add_connection  pattgen.ln  $instance1.tx_ln 

    if { $std == "threeg" | $std == "dl" | $std == "tr" } {
      add_connection  pattgen.ln_b  $instance1.tx_ln_b
    }
  }
  
  add_instance    ${instance2}_tx_dataout_valid_fanout                altera_fanout
  add_connection  $instance2.tx_dataout_valid                         ${instance2}_tx_dataout_valid_fanout.sig_input 
  add_connection  ${instance2}_tx_dataout_valid_fanout.sig_fanout1    pattgen.enable

}

# Connect the reconfig with Tx transceiver
#
proc add_tx_reconfig_dut_connection {instance separate device dir std} {

  #if { $device == "Stratix V" | $device == "Arria V" } {

    if { $dir != "du"} {
      add_connection  u_reconfig_router.reconfig_to_xcvr_tx_ch1  $instance.reconfig_to_xcvr
      add_connection  $instance.reconfig_from_xcvr               u_reconfig_router.reconfig_from_xcvr_tx_ch1

      if { $std == "dl"} {

        add_connection  u_reconfig_router.reconfig_to_xcvr_tx_ch1_b  $instance.reconfig_to_xcvr_b
        add_connection  $instance.reconfig_from_xcvr_b               u_reconfig_router.reconfig_from_xcvr_tx_ch1_b

      }
    }
  #}
}

# Connect the reconfig with Rx transceiver
#
proc add_reconfig_dut_connection {instance1 instance2 device dir std} {

  #if { $device == "Stratix V" | $device == "Arria V" } {

    if { $dir == "du"} {

      if { $std == "tr" | $std == "ds" } {
        add_connection  ${instance1}_rx_sdi_start_reconfig_fanout.sig_fanout1   u_reconfig_router.sdi_rx_start_reconfig_du_ch1
        add_connection  u_reconfig_router.sdi_rx_reconfig_done_du_ch1           $instance1.rx_sdi_reconfig_done
        add_connection  ${instance2}_rx_std_fanout.sig_fanout1                  u_reconfig_router.sdi_rx_std_du_ch1
      }

      add_connection    u_reconfig_router.reconfig_to_xcvr_du_ch1               $instance1.reconfig_to_xcvr
      add_connection    $instance1.reconfig_from_xcvr                           u_reconfig_router.reconfig_from_xcvr_du_ch1

      if { $std == "dl"} {
        add_connection  u_reconfig_router.reconfig_to_xcvr_du_ch1_b             $instance1.reconfig_to_xcvr_b
        add_connection  $instance1.reconfig_from_xcvr_b                         u_reconfig_router.reconfig_from_xcvr_du_ch1_b     
      }    
    } else {

      if { $std == "tr" | $std == "ds" } {
        add_connection  ${instance1}_rx_sdi_start_reconfig_fanout.sig_fanout1   u_reconfig_router.sdi_rx_start_reconfig_rx_ch1
        add_connection  u_reconfig_router.sdi_rx_reconfig_done_rx_ch1           $instance1.rx_sdi_reconfig_done  
        add_connection  ${instance2}_rx_std_fanout.sig_fanout1                  u_reconfig_router.sdi_rx_std_rx_ch1
      }

      add_connection    u_reconfig_router.reconfig_to_xcvr_rx_ch1               $instance1.reconfig_to_xcvr
      add_connection    $instance1.reconfig_from_xcvr                           u_reconfig_router.reconfig_from_xcvr_rx_ch1

      if { $std == "dl"} {
        add_connection  u_reconfig_router.reconfig_to_xcvr_rx_ch1_b             $instance1.reconfig_to_xcvr_b
        add_connection  $instance1.reconfig_from_xcvr_b                         u_reconfig_router.reconfig_from_xcvr_rx_ch1_b  
  
      }
    }
  #} else {
  #
  #  if { $std == "tr" | $std == "ds" } {
  #
  #    add_connection  reconfig.write_ctrl_ch0         rx_rcfg_fanout.sig_fanout1
  #    add_connection  reconfig.rx_std_ch0             rx_std_fanout.sig_fanout0
  #    add_connection  reconfig.sdi_reconfig_done_ch0  $instance.rx_sdi_reconfig_done
  #  
  #    add_connection  reconfig.reconfig_fromgxb_ch0  $instance.gxb_reconfig_fromgxb
  #    add_connection  reconfig.reconfig_togxb_ch0    $instance.gxb_reconfig_togxb
  #
  #  }
  #} 
}

proc add_reconfig_dut_connection_a2b { instance1 instance2 } {

  add_connection  u_reconfig_router.reconfig_to_xcvr_rx_smpte372  $instance1.reconfig_to_xcvr
  add_connection  $instance1.reconfig_from_xcvr                   u_reconfig_router.reconfig_from_xcvr_rx_smpte372
  add_connection  u_reconfig_router.reconfig_to_xcvr_tx_smpte372  $instance2.reconfig_to_xcvr
  add_connection  $instance2.reconfig_from_xcvr                   u_reconfig_router.reconfig_from_xcvr_tx_smpte372

}

proc add_reconfig_dut_connection_b2a { instance1 instance2 } {

  add_connection  u_reconfig_router.reconfig_to_xcvr_rx_smpte372  $instance1.reconfig_to_xcvr
  add_connection  $instance1.reconfig_from_xcvr                   u_reconfig_router.reconfig_from_xcvr_rx_smpte372
  add_connection  u_reconfig_router.reconfig_to_xcvr_tx_smpte372  $instance2.reconfig_to_xcvr
  add_connection  $instance2.reconfig_from_xcvr                   u_reconfig_router.reconfig_from_xcvr_tx_smpte372  
  
  add_connection  u_reconfig_router.reconfig_to_xcvr_rx_smpte372_b  $instance1.reconfig_to_xcvr_b
  add_connection  $instance1.reconfig_from_xcvr_b                   u_reconfig_router.reconfig_from_xcvr_rx_smpte372_b
  add_connection  u_reconfig_router.reconfig_to_xcvr_tx_smpte372_b  $instance2.reconfig_to_xcvr_b
  add_connection  $instance2.reconfig_from_xcvr_b                   u_reconfig_router.reconfig_from_xcvr_tx_smpte372_b  
}

# Connect the reconfig with Duplex Ch0 transceiver
#
proc add_reconfig_du_ch0_connection {instance separate device std} {

  if { $std == "tr" | $std == "ds" } {
    add_instance            ${instance}_rx_std_fanout  altera_fanout
    set_instance_parameter  ${instance}_rx_std_fanout  WIDTH 3
    set_instance_parameter  ${instance}_rx_std_fanout  NUM_FANOUT 3
    add_connection          ${instance}.rx_std  ${instance}_rx_std_fanout.sig_input
    
    #if { $device == "Stratix V" | $device == "Arria V" } {
    
    add_connection  ${instance}_rx_sdi_start_reconfig_fanout.sig_fanout1   u_reconfig_router.sdi_rx_start_reconfig_du_ch0
    add_connection  ${instance}_rx_std_fanout.sig_fanout2                  u_reconfig_router.sdi_rx_std_du_ch0
    add_connection  u_reconfig_router.sdi_rx_reconfig_done_du_ch0          $instance.rx_sdi_reconfig_done
    
    #} else {
    #  add_connection rx_rcfg_fanout_0.sig_fanout1   reconfig.write_ctrl_ch1
    #  add_connection rx_std_fanout_0.sig_fanout0    reconfig.rx_std_ch1
    #  add_connection reconfig.sdi_reconfig_done_ch1 $instance.rx_sdi_reconfig_done  
    #
    #  add_connection reconfig.reconfig_fromgxb_ch1 $instance.gxb_reconfig_fromgxb
    #  add_connection reconfig.reconfig_togxb_ch1   $instance.gxb_reconfig_togxb 
    #}

  } elseif { $std == "threeg" } {
    add_instance            ${instance}_rx_std_fanout  altera_fanout
    set_instance_parameter  ${instance}_rx_std_fanout  WIDTH 3
    add_connection          ${instance}.rx_std         ${instance}_rx_std_fanout.sig_input
  }
  
  #if { $device == "Stratix V" | $device == "Arria V" } {
  add_connection  u_reconfig_router.reconfig_to_xcvr_du_ch0  $instance.reconfig_to_xcvr
  add_connection  $instance.reconfig_from_xcvr               u_reconfig_router.reconfig_from_xcvr_du_ch0
  #} 

  if { $std == "dl"} {
    add_connection  u_reconfig_router.reconfig_to_xcvr_du_ch0_b  $instance.reconfig_to_xcvr_b
    add_connection  $instance.reconfig_from_xcvr_b               u_reconfig_router.reconfig_from_xcvr_du_ch0_b
  }
}

# Connect the reconfig with reconfig_router and reconfig_mgmt blocks
#
proc add_reconfig_router_mgmt_connection {device std xcvr_tx_pll_sel reset_reconfig} {
  #if { $device == "Stratix V" | $device == "Arria V" } {

    if { $std == "tr" | $std == "ds" } {

      add_connection  u_reconfig_mgmt.sdi_rx_reconfig_done              u_reconfig_router.sdi_rx_reconfig_done_from_mgmt 
      add_connection  u_reconfig_router.sdi_rx_start_reconfig_to_mgmt   u_reconfig_mgmt.sdi_rx_start_reconfig
      add_connection  u_reconfig_router.sdi_rx_std_to_mgmt              u_reconfig_mgmt.sdi_rx_std
      
    }
    
    if { $std == "tr" | $std == "ds" | $xcvr_tx_pll_sel != "0" } {
      add_connection  u_reconfig.reconfig_mif                           u_reconfig_mgmt.reconfig_mif
    }
    
    if { $xcvr_tx_pll_sel != "0" } {
      add_connection  u_reconfig_mgmt.sdi_tx_reconfig_done              u_reconfig_router.sdi_tx_reconfig_done_from_mgmt 
      add_connection  u_reconfig_router.sdi_tx_start_reconfig_to_mgmt   u_reconfig_mgmt.sdi_tx_start_reconfig
      #add_connection  u_reconfig_router.sdi_tx_pll_sel_to_mgmt          u_reconfig_mgmt.sdi_tx_pll_sel
      
      #add_connection          sdi_tx_pll_sel_fanout.sig_fanout1         u_reconfig_mgmt.sdi_tx_pll_sel
    }

    if { $reset_reconfig } {
      add_connection  u_reconfig.reconfig_busy                      u_reconfig_reconfig_busy_fanout.sig_input
      add_connection  u_reconfig_reconfig_busy_fanout.sig_fanout1   u_reconfig_mgmt.reconfig_busy
    } else {
      add_connection  u_reconfig.reconfig_busy                      u_reconfig_mgmt.reconfig_busy
    }
    add_connection    u_reconfig_mgmt.reconfig_mgmt                 u_reconfig.reconfig_mgmt
    add_connection    u_reconfig.reconfig_to_xcvr                   u_reconfig_router.reconfig_to_xcvr
    add_connection    u_reconfig_router.reconfig_from_xcvr          u_reconfig.reconfig_from_xcvr

  #}
}

# Connect the Tx protocol with Tx transceiver
# (for split transceiver and protocol option)
#
proc add_tx_proto_xcvr_connection {instance1 instance2 std}  {

  add_connection  ${instance1}.tx_dataout        ${instance2}.tx_datain
  add_connection  ${instance1}.tx_dataout_valid  ${instance2}.tx_datain_valid

  if { $std == "threeg" | $std == "ds" | $std == "tr" } {
    add_connection  ${instance1}.tx_std_out  ${instance2}.tx_std
  }

  if { $std == "dl" } {
    add_connection  ${instance1}.tx_dataout_b        ${instance2}.tx_datain_b
    add_connection  ${instance1}.tx_dataout_valid_b  ${instance2}.tx_datain_valid_b
  }
}


# Connect the Rx protocol with Rx transceiver
# (for split transceiver and protocol option)
#
proc add_rx_xcvr_proto_connection {instance1 instance2 std }  {

  add_connection    ${instance1}.rx_clkout                             ${instance2}.rx_clkin

  if { $std == "ds" | $std == "tr" | $std == "threeg" } {
    add_connection  ${instance1}.rx_std                                ${instance2}.rx_std_in
  }

  add_connection    ${instance1}_rx_rst_proto_out_fanout.sig_fanout1   ${instance2}.rx_rst_proto_in
  add_connection    ${instance1}.rx_dataout                            ${instance2}.rx_datain
  add_connection    ${instance1}.rx_dataout_valid                      ${instance2}.rx_datain_valid
  add_connection    ${instance1}.rx_trs_in                             ${instance2}_rx_trs_fanout.sig_fanout1
  add_connection    ${instance1}.rx_trs_loose_lock_in                  ${instance2}.rx_trs_loose_lock_out

  if { $std == "dl" } {
    add_connection  ${instance1}.rx_clkout_b                           ${instance2}.rx_clkin_b
    add_connection  ${instance1}.rx_rst_proto_out_b                    ${instance2}.rx_rst_proto_in_b
    add_connection  ${instance1}.rx_dataout_b                          ${instance2}.rx_datain_b
    add_connection  ${instance1}.rx_dataout_valid_b                    ${instance2}.rx_datain_valid_b
    add_connection  ${instance1}.rx_trs_loose_lock_in_b                ${instance2}.rx_trs_loose_lock_out_b
  }
}

# +--------------------
# | Compose Callback
# |
proc compose_ed_v_series {dir config device video_std xcvr_tx_pll_sel insert_vpid extract_vpid crc_err a2b b2a hd_frequency dl_sync cmp_data trs_test frame_test reset_reconfig} {
    if { $insert_vpid } {
       set extract_vpid      1
    }

    if { ($video_std == "tr" | $video_std == "dl" | $video_std == "threeg") } {
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

    # Instantiate pattern generator
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
      set_instance_parameter pattgen TX_EN_VPID_INSERT   1
    }
    if { !$ch1_vpid_insert & $ch1_vpid_extract } {
      set_instance_parameter pattgen TEST_GEN_ANC    1
      set_instance_parameter pattgen TEST_GEN_VPID   1
    }

    # Add clock and reset bridges for reconfig
    #add_clk_bridge rx_coreclk_ch0
    add_clk_bridge  reconfig_clk
    add_rst_bridge  reconfig
    ##add_rst_bridge tx
    ##add_rst_bridge rx

    #if { $device == "Stratix V" | $device == "Arria V" } {
    #  add_clk_bridge phy_mgmt_clk_ch0
    #  if { $dir == "du" } {
    #    add_clk_bridge du_xcvr_refclk_ch0        
    #    #add_clk_bridge du_rx_coreclk_ch0
    #    #add_clk_bridge du_phy_mgmt_clk_ch0
    #    add_rst_bridge du_tx_ch0
    #    add_rst_bridge du_rx_ch0
    #    add_rst_bridge du_phy_mgmt_clk_ch0
    #  } else {
    #    add_clk_bridge tx_xcvr_refclk_ch0
    #    add_clk_bridge rx_xcvr_refclk_ch0
    #    #add_clk_bridge rx_coreclk_ch0
    #    add_rst_bridge tx_ch0
    #    add_rst_bridge rx_ch0
    #    add_rst_bridge tx_phy_mgmt_clk_ch0
    #    add_rst_bridge rx_phy_mgmt_clk_ch0
    #  }
    #}
    
    #if { $device == "Stratix V" | $device == "Arria V" } {
    #  add_clk_bridge du_xcvr_refclk_ch1        
    #  add_clk_bridge du_rx_coreclk_ch1
    #  add_clk_bridge du_phy_mgmt_clk_ch1
    #  add_rst_bridge du_tx_ch1
    #  add_rst_bridge du_rx_ch1
    #  add_rst_bridge du_phy_mgmt_clk_ch1
    #} else {
    #  add_clk_bridge tx_coreclk
    #  add_clk_bridge clk_fpga
    #}
    
    #########################################################################################
    #
    # Expotr interface for reconfig_router blocks
    #
    #########################################################################################
   

    #########################################################################################
    #
    # Configure the connection to alt_xcvr_reconfig, reconfig_mgmt and reconfig_router blocks
    #
    #########################################################################################
    ## Add alt_xcvr_reconfig module
    add_instance  u_reconfig  alt_xcvr_reconfig

    ## Add reconfig_mgmt module for triple rate and dual standard only
    ##if { $video_std == "tr" | $video_std == "ds" } 

    add_instance                  u_reconfig_mgmt  sdi_ii_ed_reconfig_mgmt
    propagate_params              u_reconfig_mgmt
    set_instance_parameter_value  u_reconfig_mgmt  NUM_CHS  2
    set_instance_parameter_value  u_reconfig_mgmt  VIDEO_STANDARD   $video_std
    set_instance_parameter_value  u_reconfig_mgmt  DIRECTION        $dir
    set_instance_parameter_value  u_reconfig_mgmt  XCVR_TX_PLL_SEL  $xcvr_tx_pll_sel
    #set_instance_parameter_value  u_reconfig_mgmt  FAMILY  $device

    ## Add reconfig_router block to split up the reconfig bus to various SDI Instances
    add_instance                  u_reconfig_router  sdi_ii_ed_reconfig_router
    propagate_params              u_reconfig_router
    set_instance_parameter_value  u_reconfig_router  VIDEO_STANDARD  $video_std
    set_instance_parameter_value  u_reconfig_router  XCVR_TX_PLL_SEL  $xcvr_tx_pll_sel
      
    ## if direction = duplex
    if { $dir == "du" } {

      if { $video_std == "dl"} {

        if { $xcvr_tx_pll_sel == "1" } {
          set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  10
          set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 10
        } else {
          set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  8
          set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 8
        }
        set_instance_parameter_value    u_reconfig_router  NUM_CHS                        2

      } else {

        if { $xcvr_tx_pll_sel == "1" } {
          set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  5
          set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 5
        } else {
          set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  4
          set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 4
        }
        set_instance_parameter_value    u_reconfig_router  NUM_CHS                        2

      }

    } else {  ## if direction = separated rx/tx

      if { $video_std == "dl" } {

        if { $a2b } {

          if { $xcvr_tx_pll_sel == "1" } {
            set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  15
            set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 15
          } else {
            set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  13
            set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 13
          }

          set_instance_parameter_value    u_reconfig_router  NUM_CHS                        2
          set_instance_parameter_value    u_reconfig_router  RX_EN_A2B_CONV                 1

        } else { 

          if { $xcvr_tx_pll_sel == "1" } {
            set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  12
            set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 12
          } else {
            set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  10
            set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 10
          }             

          set_instance_parameter_value    u_reconfig_router  NUM_CHS                        2

        }

      } else { ## if SD/HD/3G/DS/TR

        if { $b2a } { ## apllicable for 3GB and TR only

          if { $xcvr_tx_pll_sel == "1" } {
            set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  12
            set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 12
          } else {
            set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  11
            set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 11
          }

          set_instance_parameter_value    u_reconfig_router  NUM_CHS                        2
          set_instance_parameter_value    u_reconfig_router  RX_EN_B2A_CONV                 1

        } else {

          if { $xcvr_tx_pll_sel == "1" } {
            set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  6
            set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 6
          } else {
            set_instance_parameter_value  u_reconfig         number_of_reconfig_interfaces  5
            set_instance_parameter_value  u_reconfig_router  NUM_INTERFACES                 5
          }

          set_instance_parameter_value    u_reconfig_router  NUM_CHS                        2
        }
      }
    }

    ## Only enable and expose mif_reconfig ports in DS and TR mode
    if { $video_std == "tr" | $video_std == "ds" | $xcvr_tx_pll_sel != "0" } {
      set_instance_parameter_value  u_reconfig         enable_mif      1
      set_instance_parameter_value  u_reconfig         gui_enable_pll  1
    } else {
      set_instance_parameter_value  u_reconfig         enable_mif      0
      set_instance_parameter_value  u_reconfig         gui_enable_pll  0
    }
    set_instance_parameter_value    u_reconfig_router  DIRECTION       $dir  

    if { $reset_reconfig } {
      add_instance                        u_reconfig_reconfig_busy_fanout       altera_fanout
      set_instance_parameter              u_reconfig_reconfig_busy_fanout       SPECIFY_SIGNAL_TYPE  1
      set_instance_parameter              u_reconfig_reconfig_busy_fanout       SIGNAL_TYPE  reconfig_busy

      add_export_fanout_rename_interface  u_reconfig   reconfig_busy            conduit   output
      # add_connection          ${instance}.rx_std    reconfig_busy_fanout.sig_input     
      # add_export_rename_interface  u_reconfig reconfig_busy        conduit  output
    }

    ########################################################################################
    
    # if { $extract_vpid | $video_std == "tr" | $video_std == "dl" | $video_std == "threeg"} {
    #   set vpid_bytes_out 1
    # }

    # This is not needed
    derive_instance_name   $dir $config  $video_std

    # Derive the desired direction and configuration of 
    # each sub instance in a core
    derive_instance_param  $dir $config

    set  num_inst             [get_parameter_value NUM_INST]
    set  inst1                [get_parameter_value INST1]
    set  inst2                [get_parameter_value INST2]
    set  inst3                [get_parameter_value INST3]
    set  inst4                [get_parameter_value INST4]
    set  inst1_dir_param      [get_parameter_value INST1_DIR]
    set  inst2_dir_param      [get_parameter_value INST2_DIR]
    set  inst3_dir_param      [get_parameter_value INST3_DIR]
    set  inst4_dir_param      [get_parameter_value INST4_DIR]
    set  inst1_config_param   [get_parameter_value INST1_CONFIG]
    set  inst2_config_param   [get_parameter_value INST2_CONFIG]
    set  inst3_config_param   [get_parameter_value INST3_CONFIG]
    set  inst4_config_param   [get_parameter_value INST4_CONFIG]
    set  ch                   ch1

    ########################################################################################
    ##
    ## SDI Instances Instantiation at Channel 1 (User selection)
    ##
    ########################################################################################

    if { $config == "xcvr_proto" } {

        # Instantiate first instance of IP core (DUT) with combined xcvr_proto
        # this could be du OR rx OR tx
        add_instance            $inst1  sdi_ii
        propagate_params        $inst1
        set_instance_parameter  $inst1  DIRECTION             $inst1_dir_param
        set_instance_parameter  $inst1  TRANSCEIVER_PROTOCOL  $inst1_config_param
        set_instance_parameter  $inst1  RX_EN_A2B_CONV        0
        set_instance_parameter  $inst1  RX_EN_B2A_CONV        0
        set_instance_parameter  $inst1  TX_EN_VPID_INSERT     $ch1_vpid_insert
        #if { $device == "Stratix V" | $device == "Arria V" } {
        #  ##
        #} else {
        #  common_add_export_rename_interface      $inst1
        #  add_common_xcvr_reconfig_clk_connection $inst1
        #}

        if { $num_inst == 2 } {

          # Instantiate second instance of IP core (TEST) with combined xcvr_proto
          # this could be tx OR rx
          add_instance            $inst3  sdi_ii
          propagate_params        $inst3
          set_instance_parameter  $inst3  DIRECTION             $inst3_dir_param
          set_instance_parameter  $inst3  TRANSCEIVER_PROTOCOL  $inst3_config_param

          if { $dir == "tx" } {
             set_instance_parameter  $inst3  RX_EN_VPID_EXTRACT  $ch1_vpid_extract
             set_instance_parameter  $inst3  XCVR_TX_PLL_SEL     0
          }

          #if { $device == "Stratix V" | $device == "Arria V" } {
          #  ##
          #} else {
          #  common_add_export_rename_interface      $inst3
          #  add_common_xcvr_reconfig_clk_connection $inst3
          #}
        }

        # Connect example design clocks and resets
        #if { $device == "Stratix V" | $device == "Arria V" } {
        #  ##
        #} else {        
        #  add_connection tx_coreclk_bridge.out_clk $inst1.tx_coreclk
        #}

        # Add connection for rx_coreclk, xcvr_refclk, phy_mgmt_clk, rx_rst, tx_rst and phy_mgmt_clk_rst
        if { $dir == "du" } {

          if { $hd_frequency == "74.25" } {
            add_clk_bridge  ${ch}_du_rx_coreclk_hd
            add_connection  ${ch}_du_rx_coreclk_hd_bridge.out_clk  $inst1.rx_coreclk_hd
            add_clk_bridge  ${ch}_du_tx_coreclk_hd
            add_connection  ${ch}_du_tx_coreclk_hd_bridge.out_clk  $inst1.tx_coreclk_hd
          } else {
            add_clk_bridge  ${ch}_du_rx_coreclk
            add_connection  ${ch}_du_rx_coreclk_bridge.out_clk    $inst1.rx_coreclk
            add_clk_bridge  ${ch}_du_tx_coreclk
            add_connection  ${ch}_du_tx_coreclk_bridge.out_clk    $inst1.tx_coreclk
          }
          add_clk_bridge  ${ch}_du_xcvr_refclk
          add_connection  ${ch}_du_xcvr_refclk_bridge.out_clk   $inst1.xcvr_refclk

          if { $xcvr_tx_pll_sel == "1" } {
            add_export_free_rename_interface u_reconfig_router sdi_tx_pll_sel_${dir}_${ch}          ${ch}_${dir}_tx_sdi_pll_sel         conduit input
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_mgmt         u_reconfig_mgmt.sdi_tx_pll_sel
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_xcvr_${ch}   $inst1.xcvr_refclk_sel
          } elseif { $xcvr_tx_pll_sel == "2" } {
            add_export_free_rename_interface u_reconfig_router sdi_tx_pll_sel_${dir}_${ch}          ${ch}_${dir}_tx_sdi_pll_sel         conduit input
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_mgmt         u_reconfig_mgmt.sdi_tx_pll_sel
          }

          if { $xcvr_tx_pll_sel != "0" } {
            add_clk_bridge  ${ch}_du_xcvr_refclk_alt
            add_connection  ${ch}_du_xcvr_refclk_alt_bridge.out_clk   $inst1.xcvr_refclk_alt
            add_export_free_rename_interface u_reconfig_router sdi_tx_start_reconfig_${dir}_${ch}   ${ch}_${dir}_tx_sdi_start_reconfig  conduit input
            add_export_free_rename_interface u_reconfig_router sdi_tx_reconfig_done_${dir}_${ch}    ${ch}_${dir}_tx_sdi_reconfig_done   conduit output
          }

#          if { $device == "Stratix V" | $device == "Arria V" | $device == "Arria V GZ"} {
#             add_clk_bridge  ${ch}_du_phy_mgmt_clk
#             add_connection  ${ch}_du_phy_mgmt_clk_bridge.out_clk  $inst1.phy_mgmt_clk
#             add_rst_bridge  ${ch}_du_phy_mgmt_clk
             #add_connection  ${ch}_du_phy_mgmt_clk_bridge.out_clk        ${ch}_du_phy_mgmt_rst_bridge.clk
#             add_connection  ${ch}_du_xcvr_refclk_bridge.out_clk         ${ch}_du_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#             add_connection  ${ch}_du_phy_mgmt_clk_rst_bridge.out_reset  $inst1.phy_mgmt_clk_rst
#          }

          add_rst_bridge  ${ch}_du_rx
          add_rst_bridge  ${ch}_du_tx
          add_connection  ${ch}_du_rx_rst_bridge.out_reset     $inst1.rx_rst
          add_connection  ${ch}_du_tx_rst_bridge.out_reset     $inst1.tx_rst 
          add_connection  ${ch}_du_xcvr_refclk_bridge.out_clk  ${ch}_du_rx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
          add_connection  ${ch}_du_xcvr_refclk_bridge.out_clk  ${ch}_du_tx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added

        } else {

          if { $hd_frequency == "74.25" } {
            add_clk_bridge  ${ch}_rx_coreclk_hd
            add_connection  ${ch}_rx_coreclk_hd_bridge.out_clk  $inst3.rx_coreclk_hd
            add_clk_bridge  ${ch}_tx_coreclk_hd
            add_connection  ${ch}_tx_coreclk_hd_bridge.out_clk  $inst1.tx_coreclk_hd
          } else {
            add_clk_bridge  ${ch}_rx_coreclk
            add_connection  ${ch}_rx_coreclk_bridge.out_clk    $inst3.rx_coreclk
            add_clk_bridge  ${ch}_tx_coreclk
            add_connection  ${ch}_tx_coreclk_bridge.out_clk    $inst1.tx_coreclk
          }
          add_clk_bridge  ${ch}_rx_xcvr_refclk
          add_connection  ${ch}_rx_xcvr_refclk_bridge.out_clk   $inst3.xcvr_refclk
          add_clk_bridge  ${ch}_tx_xcvr_refclk
          add_connection  ${ch}_tx_xcvr_refclk_bridge.out_clk   $inst1.xcvr_refclk
          
          if { $xcvr_tx_pll_sel == "1" } {
            add_export_free_rename_interface u_reconfig_router sdi_tx_pll_sel_${dir}_${ch}          ${ch}_${dir}_tx_sdi_pll_sel         conduit input
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_mgmt         u_reconfig_mgmt.sdi_tx_pll_sel
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_xcvr_${ch}   $inst1.xcvr_refclk_sel
          } elseif { $xcvr_tx_pll_sel == "2" } {
            add_export_free_rename_interface u_reconfig_router sdi_tx_pll_sel_${dir}_${ch}          ${ch}_${dir}_tx_sdi_pll_sel         conduit input
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_mgmt         u_reconfig_mgmt.sdi_tx_pll_sel
          }

          if { $xcvr_tx_pll_sel != "0" } {
            add_clk_bridge  ${ch}_tx_xcvr_refclk_alt
            add_connection  ${ch}_tx_xcvr_refclk_alt_bridge.out_clk   $inst1.xcvr_refclk_alt
            add_export_free_rename_interface u_reconfig_router sdi_tx_start_reconfig_${dir}_${ch}   ${ch}_${dir}_tx_sdi_start_reconfig  conduit input
            add_export_free_rename_interface u_reconfig_router sdi_tx_reconfig_done_${dir}_${ch}    ${ch}_${dir}_tx_sdi_reconfig_done   conduit output
          }

#          if { $device == "Stratix V" | $device == "Arria V" | $device == "Arria V GZ"} {
#             add_clk_bridge  ${ch}_rx_phy_mgmt_clk
#             add_connection  ${ch}_rx_phy_mgmt_clk_bridge.out_clk  $inst3.phy_mgmt_clk
#             add_clk_bridge  ${ch}_tx_phy_mgmt_clk
#             add_connection  ${ch}_tx_phy_mgmt_clk_bridge.out_clk  $inst1.phy_mgmt_clk
#             add_rst_bridge  ${ch}_rx_phy_mgmt_clk
             #add_connection  ${ch}_rx_phy_mgmt_clk_bridge.out_clk        ${ch}_rx_phy_mgmt_rst_bridge.clk
#             add_connection  ${ch}_rx_xcvr_refclk_bridge.out_clk         ${ch}_rx_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#             add_connection  ${ch}_rx_phy_mgmt_clk_rst_bridge.out_reset  $inst3.phy_mgmt_clk_rst
#             add_rst_bridge  ${ch}_tx_phy_mgmt_clk
             #add_connection  ${ch}_tx_phy_mgmt_clk_bridge.out_clk        ${ch}_tx_phy_mgmt_rst_bridge.clk
#             add_connection  ${ch}_tx_xcvr_refclk_bridge.out_clk         ${ch}_tx_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#             add_connection  ${ch}_tx_phy_mgmt_clk_rst_bridge.out_reset  $inst1.phy_mgmt_clk_rst
#          }
 
          add_rst_bridge  ${ch}_rx
          add_rst_bridge  ${ch}_tx
          add_connection  ${ch}_rx_rst_bridge.out_reset        $inst3.rx_rst
          add_connection  ${ch}_tx_rst_bridge.out_reset        $inst1.tx_rst
          add_connection  ${ch}_rx_xcvr_refclk_bridge.out_clk  ${ch}_rx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
          add_connection  ${ch}_tx_xcvr_refclk_bridge.out_clk  ${ch}_tx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added

        } 

        #add_connection rx_coreclk_bridge.out_clk $inst3.rx_coreclk

        #if { $device == "Stratix V" || $device == "Arria V" } {
        #  if { $dir == "du" } {
        #    #add_connection du_xcvr_refclk_bridge.out_clk  $inst1.xcvr_refclk
        #    add_connection du_xcvr_refclk_ch0_bridge.out_clk  $inst1.xcvr_refclk
        #  } else {
        #    #add_connection tx_xcvr_refclk_bridge.out_clk  $inst1.xcvr_refclk
        #    add_connection tx_xcvr_refclk_ch0_bridge.out_clk  $inst1.xcvr_refclk
        #  }

        #  #add_connection phy_mgmt_clk_bridge.out_clk $inst1.phy_mgmt_clk  
        #  add_connection phy_mgmt_clk_bridge.out_clk $inst1.phy_mgmt_clk

        #  if { $num_inst == 2 } {
        #    add_connection rx_xcvr_refclk_bridge.out_clk  $inst3.xcvr_refclk
        #    add_connection phy_mgmt_clk_bridge.out_clk    $inst3.phy_mgmt_clk
        #  }
        #}

        #if { $device == "Stratix V" || $device == "Arria V" } {
        #  add_connection phy_mgmt_clk_bridge.out_clk   tx_rst_bridge.clk
        #  if { $dir == "du" } {
        #    add_connection phy_mgmt_clk_bridge.out_clk                du_phy_mgmt_clk_rst_bridge.clk
        #    add_connection du_phy_mgmt_clk_rst_bridge.out_reset       $inst1.phy_mgmt_clk_rst
        #  } else {
        #    add_connection phy_mgmt_clk_bridge.out_clk                tx_phy_mgmt_clk_rst_bridge.clk
        #    add_connection tx_phy_mgmt_clk_rst_bridge.out_reset       $inst1.phy_mgmt_clk_rst            
        #    if { $num_inst == 2 } {
        #      add_connection phy_mgmt_clk_bridge.out_clk                rx_phy_mgmt_clk_rst_bridge.clk
        #      add_connection rx_phy_mgmt_clk_rst_bridge.out_reset       $inst3.phy_mgmt_clk_rst
        #    }
        #  }
        #} else {
        #  add_connection tx_coreclk_bridge.out_clk     tx_rst_bridge.clk
        #}

        #add_connection rx_coreclk_bridge.out_clk rx_rst_bridge.clk
        
        #add_connection tx_rst_bridge.out_reset  $inst1.tx_rst
        #add_connection rx_rst_bridge.out_reset  $inst3.rx_rst
         
        #Fanout rx_clkout to rx_clkin
        #add_instance           rx_clkout_bridge           altera_clock_bridge
        #set_instance_parameter rx_clkout_bridge           NUM_CLOCK_OUTPUTS       2
        #add_connection         $inst4.rx_clkout           rx_clkout_bridge.in_clk
        #add_interface          ${inst4}_rx_clkout         clock                   start
        #set_interface_property ${inst4}_rx_clkout         export_of               rx_clkout_bridge.out_clk 
        #add_connection         rx_clkout_bridge.out_clk_1 $inst3.rx_clkin
        
        add_instance            rx_clkout_bridge    altera_clock_bridge
        set_instance_parameter  rx_clkout_bridge    NUM_CLOCK_OUTPUTS        3
        add_connection          $inst3.rx_clkout    rx_clkout_bridge.in_clk
        add_interface           ${inst3}_rx_clkout  clock                    start
        set_interface_property  ${inst3}_rx_clkout  export_of                rx_clkout_bridge.out_clk

        # Fanout tx_clkout to various components
        add_instance            tx_clkout_bridge            altera_clock_bridge
        set_instance_parameter  tx_clkout_bridge            NUM_CLOCK_OUTPUTS            3
        add_connection          $inst2.tx_clkout            tx_clkout_bridge.in_clk
        add_interface           ${inst2}_tx_clkout          clock                        start
        set_interface_property  ${inst2}_tx_clkout          export_of                    tx_clkout_bridge.out_clk 
        add_connection          tx_clkout_bridge.out_clk_1  $inst1.tx_pclk
        add_connection          tx_clkout_bridge.out_clk_2  pattgen.clk

        if { $video_std == "tr" | $video_std == "ds" } {
          add_instance            ${inst4}_rx_sdi_start_reconfig_fanout   altera_fanout
          add_connection          ${inst4}.rx_sdi_start_reconfig          ${inst4}_rx_sdi_start_reconfig_fanout.sig_input
        }

        if { $video_std == "tr" | $video_std == "ds" } {
          add_instance            ${inst3}_rx_std_fanout       altera_fanout
          set_instance_parameter  ${inst3}_rx_std_fanout       WIDTH 3
          add_connection          $inst3.rx_std                ${inst3}_rx_std_fanout.sig_input
        }
        # Export example design interfaces
        tx_protocol__add_export_rename_interface  $inst1  $video_std  $dl_sync   $ch1_vpid_insert  $trs_test  $frame_test
        tx_phy_mgmt__add_export_rename_interface  $inst2  $config     $video_std
        tx_phy__add_export_rename_interface       $inst2  $video_std  $xcvr_tx_pll_sel
        rx_phy__add_export_rename_interface       $inst4  $video_std
        rx_phy_mgmt__add_export_rename_interface  $inst4  $video_std  $config
        rx_protocol__add_export_rename_interface  $inst3  $video_std  $crc_err  $ch1_vpid_extract $a2b $b2a
        if { ($a2b | $b2a) } {
            add_instance      ${inst3}_rx_trs_fanout   altera_fanout
            add_connection    ${inst3}.rx_trs       ${inst3}_rx_trs_fanout.sig_input
            add_export_fanout_rename_interface  $inst3   rx_trs          conduit output
        } else {
            add_export_rename_interface         $inst3   rx_trs          conduit output
         }

        # Pattgen - TX Proto connection
        add_pattgen_dut_connection  $inst1  $inst2  $ch1_vpid_insert  $video_std  $a2b  $b2a  $dl_sync  $trs_test  $frame_test $cmp_data

        #if { $video_std == "ds" | $video_std == "tr" } 
        # Reconfig - RX xcvr connection
        add_reconfig_dut_connection          $inst4   $inst3        $device  $dir  $video_std
        add_tx_reconfig_dut_connection       $inst2   true         $device  $dir  $video_std  
        add_reconfig_router_mgmt_connection  $device  $video_std  $xcvr_tx_pll_sel $reset_reconfig
        
        # Case:294867 - Providing flexibility to user to control pll_powerdown signal
        add_connection                       $inst1.pll_powerdown_out              $inst1.pll_powerdown_in
        #if { $video_std == "threeg"} {

        #add_instance            rx_std_fanout  altera_fanout
        #set_instance_parameter  rx_std_fanout  WIDTH 2
        #add_connection          $inst4.rx_std  rx_std_fanout.sig_input
        #}
        # if { $video_std == "threeg" | $video_std == "ds" | $video_std == "tr" } {
        # add_connection  rx_std_fanout.sig_fanout1        ${inst3}.rx_std_in
        # }

    } else { # Split Xcvr Proto
  
        # Instantiate first instance of IP core (DUT) with split xcvr proto
        # this could be du OR rx OR tx with xcvr OR proto
        add_instance            $inst1  sdi_ii
        propagate_params        $inst1
        set_instance_parameter  $inst1  DIRECTION             $inst1_dir_param
        set_instance_parameter  $inst1  TRANSCEIVER_PROTOCOL  $inst1_config_param
        set_instance_parameter  $inst1  RX_EN_A2B_CONV        0
        set_instance_parameter  $inst1  RX_EN_B2A_CONV        0
        set_instance_parameter  $inst1  TX_EN_VPID_INSERT     $ch1_vpid_insert
        if { $config == "xcvr" } {
          set_instance_parameter  $inst1  RX_EN_VPID_EXTRACT    $ch1_vpid_extract
        }
        set_instance_parameter  $inst1  XCVR_TX_PLL_SEL       0

        # Instantiate second instance of IP core (TEST) with split xcvr proto
        # this could be du OR tx OR rx with proto OR xcvr
        add_instance            $inst2  sdi_ii
        propagate_params        $inst2
        set_instance_parameter  $inst2  DIRECTION             $inst2_dir_param
        set_instance_parameter  $inst2  TRANSCEIVER_PROTOCOL  $inst2_config_param
        set_instance_parameter  $inst2  RX_EN_A2B_CONV        0
        set_instance_parameter  $inst2  RX_EN_B2A_CONV        0

        #if { $device == "Stratix V" | $device == "Arria V" } {
        #  ##
        #} else {
        #  common_add_export_rename_interface      $inst2
        #  add_common_xcvr_reconfig_clk_connection $inst2
        #}

        if { $num_inst == 4 } { 

            # Instantiate third instance of IP core (TEST) with split xcvr proto
            # this could be rx OR tx with xcvr OR proto
            add_instance            $inst3  sdi_ii
            propagate_params        $inst3
            set_instance_parameter  $inst3  DIRECTION             $inst3_dir_param
            set_instance_parameter  $inst3  TRANSCEIVER_PROTOCOL  $inst3_config_param

            if { $dir == "tx" } {
               set_instance_parameter  $inst3  RX_EN_VPID_EXTRACT  $ch1_vpid_extract
               set_instance_parameter  $inst3  XCVR_TX_PLL_SEL     0
            }

            # Instantiate fourth instance of IP core (TEST) with split xcvr proto
            # this could be tx OR rx with proto OR xcvr
            add_instance            $inst4  sdi_ii
            propagate_params        $inst4
            set_instance_parameter  $inst4  DIRECTION             $inst4_dir_param
            set_instance_parameter  $inst4  TRANSCEIVER_PROTOCOL  $inst4_config_param
            set_instance_parameter  $inst4  RX_EN_A2B_CONV        0
            set_instance_parameter  $inst4  RX_EN_B2A_CONV        0

            if { $dir == "tx" } {
               set_instance_parameter  $inst4  RX_EN_VPID_EXTRACT  $ch1_vpid_extract
               set_instance_parameter  $inst4  XCVR_TX_PLL_SEL     0
            }
            #if { $device == "Stratix V" | $device == "Arria V" } {
            ###
            #} else {
            #  common_add_export_rename_interface  $inst4
            #  add_common_xcvr_reconfig_clk_connection $inst4
            #}

        }

        # Connect example design clocks and resets
        # Add connection for rx_coreclk, xcvr_refclk, phy_mgmt_clk, rx_rst, tx_rst and phy_mgmt_clk_rst
        if { $dir == "du" } {

          if { $hd_frequency == "74.25" } {
            add_clk_bridge  ${ch}_du_rx_coreclk_hd
            add_connection  ${ch}_du_rx_coreclk_hd_bridge.out_clk  $inst2.rx_coreclk_hd
            add_clk_bridge  ${ch}_du_tx_coreclk_hd
            add_connection  ${ch}_du_tx_coreclk_hd_bridge.out_clk  $inst2.tx_coreclk_hd
          } else {
            add_clk_bridge  ${ch}_du_rx_coreclk
            add_connection  ${ch}_du_rx_coreclk_bridge.out_clk    $inst2.rx_coreclk
            add_clk_bridge  ${ch}_du_tx_coreclk
            add_connection  ${ch}_du_tx_coreclk_bridge.out_clk    $inst2.tx_coreclk
          }
          add_clk_bridge  ${ch}_du_xcvr_refclk
          add_connection  ${ch}_du_xcvr_refclk_bridge.out_clk   $inst2.xcvr_refclk
          
          if { $xcvr_tx_pll_sel == "1" } {
            add_export_free_rename_interface u_reconfig_router sdi_tx_pll_sel_${dir}_${ch}          ${ch}_${dir}_tx_sdi_pll_sel         conduit input
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_mgmt         u_reconfig_mgmt.sdi_tx_pll_sel
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_xcvr_${ch}   $inst2.xcvr_refclk_sel
          } elseif { $xcvr_tx_pll_sel == "2" } {
            add_export_free_rename_interface u_reconfig_router sdi_tx_pll_sel_${dir}_${ch}          ${ch}_${dir}_tx_sdi_pll_sel         conduit input
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_mgmt         u_reconfig_mgmt.sdi_tx_pll_sel
          }

          if { $xcvr_tx_pll_sel != "0" } {
            add_clk_bridge  ${ch}_du_xcvr_refclk_alt
            add_connection  ${ch}_du_xcvr_refclk_alt_bridge.out_clk   $inst2.xcvr_refclk_alt
            add_export_free_rename_interface u_reconfig_router sdi_tx_start_reconfig_${dir}_${ch}   ${ch}_${dir}_tx_sdi_start_reconfig  conduit input
            add_export_free_rename_interface u_reconfig_router sdi_tx_reconfig_done_${dir}_${ch}    ${ch}_${dir}_tx_sdi_reconfig_done   conduit output
          }

          #if { $device == "Stratix V" | $device == "Arria V" | $device == "Arria V GZ"} {
          #   add_clk_bridge  ${ch}_du_phy_mgmt_clk
          #   add_connection  ${ch}_du_phy_mgmt_clk_bridge.out_clk  $inst2.phy_mgmt_clk
          #   add_rst_bridge  ${ch}_du_phy_mgmt_clk
             #add_connection  ${ch}_du_phy_mgmt_clk_bridge.out_clk        ${ch}_du_phy_mgmt_rst_bridge.clk
          #   add_connection  ${ch}_du_xcvr_refclk_bridge.out_clk         ${ch}_du_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
          #   add_connection  ${ch}_du_phy_mgmt_clk_rst_bridge.out_reset  $inst2.phy_mgmt_clk_rst
          #}

          add_rst_bridge  ${ch}_du_rx
          #add_connection  ${ch}_du_rx_coreclk_bridge.out_clk   ${ch}_du_rx_rst_bridge.clk
          add_connection  ${ch}_du_xcvr_refclk_bridge.out_clk  ${ch}_du_rx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
          add_connection  ${ch}_du_rx_rst_bridge.out_reset     $inst2.rx_rst
          add_rst_bridge  ${ch}_du_tx
          #add_connection  ${ch}_du_tx_coreclk_bridge.out_clk   ${ch}_du_tx_rst_bridge.clk
          add_connection  ${ch}_du_xcvr_refclk_bridge.out_clk  ${ch}_du_tx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
          add_connection  ${ch}_du_tx_rst_bridge.out_reset     $inst1.tx_rst
          add_connection  ${ch}_du_tx_rst_bridge.out_reset     $inst2.tx_rst

    } else {

          if { $hd_frequency == "74.25" } {
            add_clk_bridge  ${ch}_rx_coreclk_hd
            add_connection  ${ch}_rx_coreclk_hd_bridge.out_clk  $inst4.rx_coreclk_hd
            add_clk_bridge  ${ch}_tx_coreclk_hd
            add_connection  ${ch}_tx_coreclk_hd_bridge.out_clk  $inst2.tx_coreclk_hd
          } else {
            add_clk_bridge  ${ch}_rx_coreclk
            add_connection  ${ch}_rx_coreclk_bridge.out_clk     $inst4.rx_coreclk
            add_clk_bridge  ${ch}_tx_coreclk
            add_connection  ${ch}_tx_coreclk_bridge.out_clk     $inst2.tx_coreclk
          }
          add_clk_bridge  ${ch}_rx_xcvr_refclk
          add_connection  ${ch}_rx_xcvr_refclk_bridge.out_clk   $inst4.xcvr_refclk
          add_clk_bridge  ${ch}_tx_xcvr_refclk
          add_connection  ${ch}_tx_xcvr_refclk_bridge.out_clk   $inst2.xcvr_refclk
          
          if { $xcvr_tx_pll_sel == "1" } {
            add_export_free_rename_interface u_reconfig_router sdi_tx_pll_sel_${dir}_${ch}          ${ch}_${dir}_tx_sdi_pll_sel         conduit input
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_mgmt         u_reconfig_mgmt.sdi_tx_pll_sel
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_xcvr_${ch}   $inst2.xcvr_refclk_sel
          } elseif { $xcvr_tx_pll_sel == "2" } {
            add_export_free_rename_interface u_reconfig_router sdi_tx_pll_sel_${dir}_${ch}          ${ch}_${dir}_tx_sdi_pll_sel         conduit input
            add_connection          u_reconfig_router.sdi_tx_pll_sel_to_mgmt         u_reconfig_mgmt.sdi_tx_pll_sel
          }

          if { $xcvr_tx_pll_sel != "0" } {
            add_clk_bridge  ${ch}_tx_xcvr_refclk_alt
            add_connection  ${ch}_tx_xcvr_refclk_alt_bridge.out_clk   $inst2.xcvr_refclk_alt
            add_export_free_rename_interface u_reconfig_router sdi_tx_start_reconfig_${dir}_${ch}   ${ch}_${dir}_tx_sdi_start_reconfig  conduit input
            add_export_free_rename_interface u_reconfig_router sdi_tx_reconfig_done_${dir}_${ch}    ${ch}_${dir}_tx_sdi_reconfig_done   conduit output
          }

#          if { $device == "Stratix V" | $device == "Arria V" | $device == "Arria V GZ"} {
#             add_clk_bridge  ${ch}_rx_phy_mgmt_clk
#             add_connection  ${ch}_rx_phy_mgmt_clk_bridge.out_clk  $inst4.phy_mgmt_clk
#             add_clk_bridge  ${ch}_tx_phy_mgmt_clk
#             add_connection  ${ch}_tx_phy_mgmt_clk_bridge.out_clk  $inst2.phy_mgmt_clk
#             add_rst_bridge  ${ch}_rx_phy_mgmt_clk
             #add_connection  ${ch}_rx_phy_mgmt_clk_bridge.out_clk        ${ch}_rx_phy_mgmt_rst_bridge.clk
#             add_connection  ${ch}_rx_xcvr_refclk_bridge.out_clk         ${ch}_rx_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#             add_connection  ${ch}_rx_phy_mgmt_clk_rst_bridge.out_reset  $inst4.phy_mgmt_clk_rst
#             add_rst_bridge  ${ch}_tx_phy_mgmt_clk
             #add_connection  ${ch}_tx_phy_mgmt_clk_bridge.out_clk        ${ch}_tx_phy_mgmt_rst_bridge.clk
#             add_connection  ${ch}_tx_xcvr_refclk_bridge.out_clk         ${ch}_tx_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#             add_connection  ${ch}_tx_phy_mgmt_clk_rst_bridge.out_reset  $inst2.phy_mgmt_clk_rst
#          }

          add_rst_bridge  ${ch}_rx
          #add_connection  ${ch}_rx_coreclk_bridge.out_clk      ${ch}_rx_rst_bridge.clk
          add_connection  ${ch}_rx_xcvr_refclk_bridge.out_clk  ${ch}_rx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
          add_connection  ${ch}_rx_rst_bridge.out_reset        $inst4.rx_rst
          add_rst_bridge  ${ch}_tx
          #add_connection  ${ch}_tx_coreclk_bridge.out_clk     ${ch}_tx_rst_bridge.clk
          add_connection  ${ch}_tx_xcvr_refclk_bridge.out_clk  ${ch}_tx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
          add_connection  ${ch}_tx_rst_bridge.out_reset        $inst1.tx_rst
          add_connection  ${ch}_tx_rst_bridge.out_reset        $inst2.tx_rst

        } 

        #if { $device == "Stratix V" | $device == "Arria V" } {
        #  ##
        #} else {
        #  add_connection tx_coreclk_bridge.out_clk $inst2.tx_coreclk
        #}
        #add_connection rx_coreclk_bridge.out_clk $inst4.rx_coreclk
        #if { $device == "Stratix V" || $device == "Arria V" } {
        #  if { $dir == "du" } {
        #    add_connection du_xcvr_refclk_bridge.out_clk  $inst2.xcvr_refclk
        #  } else {
        #    add_connection tx_xcvr_refclk_bridge.out_clk  $inst2.xcvr_refclk
        #  }
        #  add_connection phy_mgmt_clk_bridge.out_clk   $inst2.phy_mgmt_clk
        #  if { $num_inst == 4 } {
        #    add_connection rx_xcvr_refclk_bridge.out_clk  $inst4.xcvr_refclk
        #    add_connection phy_mgmt_clk_bridge.out_clk    $inst4.phy_mgmt_clk
        #  }
        #}
        
        #if { $device == "Stratix V" | $device == "Arria V" } {
        #  add_connection phy_mgmt_clk_bridge.out_clk             tx_rst_bridge.clk
        #  if { $dir == "du" } {
        #    add_connection phy_mgmt_clk_bridge.out_clk             du_phy_mgmt_clk_rst_bridge.clk
        #    add_connection du_phy_mgmt_clk_rst_bridge.out_reset    $inst2.phy_mgmt_clk_rst
        #  } else {
        #    add_connection phy_mgmt_clk_bridge.out_clk             tx_phy_mgmt_clk_rst_bridge.clk
        #    add_connection tx_phy_mgmt_clk_rst_bridge.out_reset    $inst2.phy_mgmt_clk_rst            
        #    if { $num_inst == 4 } {
        #      add_connection phy_mgmt_clk_bridge.out_clk             rx_phy_mgmt_clk_rst_bridge.clk
        #      add_connection rx_phy_mgmt_clk_rst_bridge.out_reset    $inst4.phy_mgmt_clk_rst
        #    }
        #  }
        #} else {
        #  add_connection tx_coreclk_bridge.out_clk     tx_rst_bridge.clk
        #}
        #add_connection rx_coreclk_bridge.out_clk rx_rst_bridge.clk
  
        #add_connection tx_rst_bridge.out_reset  $inst1.tx_rst
        #add_connection tx_rst_bridge.out_reset  $inst2.tx_rst
        #add_connection rx_rst_bridge.out_reset  $inst4.rx_rst

        ##add_export_rename_interface  $inst3     rx_clkout     clock   output
       
        add_instance            rx_clkout_bridge    altera_clock_bridge
        set_instance_parameter  rx_clkout_bridge    NUM_CLOCK_OUTPUTS        3
        add_connection          $inst3.rx_clkout    rx_clkout_bridge.in_clk
        add_interface           ${inst3}_rx_clkout  clock                    start
        set_interface_property  ${inst3}_rx_clkout  export_of                rx_clkout_bridge.out_clk
        
        # Fanout tx_clkout to various components
        add_instance            tx_clkout_bridge            altera_clock_bridge
        set_instance_parameter  tx_clkout_bridge            NUM_CLOCK_OUTPUTS            4
        add_connection          ${inst2}.tx_clkout          tx_clkout_bridge.in_clk
        add_interface           ${inst2}_tx_clkout          clock                        start
        set_interface_property  ${inst2}_tx_clkout          export_of                    tx_clkout_bridge.out_clk 
        add_connection          tx_clkout_bridge.out_clk_1  ${inst1}.tx_pclk
        add_connection          tx_clkout_bridge.out_clk_2  ${inst2}.tx_pclk
        add_connection          tx_clkout_bridge.out_clk_3  pattgen.clk

        if { $video_std == "tr" | $video_std == "ds" } {
          add_instance            ${inst3}_rx_std_fanout       altera_fanout
          set_instance_parameter  ${inst3}_rx_std_fanout       WIDTH 3
          add_connection          $inst3.rx_std       ${inst3}_rx_std_fanout.sig_input
        }

        add_instance            ${inst4}_rx_rst_proto_out_fanout       altera_fanout
        add_connection          $inst4.rx_rst_proto_out       ${inst4}_rx_rst_proto_out_fanout.sig_input
        if { $video_std == "tr" | $video_std == "ds" } {
          add_instance            ${inst4}_rx_sdi_start_reconfig_fanout         altera_fanout
          add_connection          ${inst4}.rx_sdi_start_reconfig       ${inst4}_rx_sdi_start_reconfig_fanout.sig_input
        }

        # Export example design interfaces
        tx_protocol__add_export_rename_interface  $inst1  $video_std  $dl_sync    $ch1_vpid_insert  $trs_test  $frame_test
        tx_phy_mgmt__add_export_rename_interface  $inst2  $config     $video_std ;# seems like nothing to export
        tx_phy__add_export_rename_interface       $inst2  $video_std  $xcvr_tx_pll_sel
        rx_phy__add_export_rename_interface       $inst4  $video_std
        rx_phy_mgmt__add_export_rename_interface  $inst4  $video_std  $config
        rx_protocol__add_export_rename_interface  $inst3  $video_std  $crc_err  $ch1_vpid_extract $a2b $b2a
        add_instance      ${inst3}_rx_trs_fanout   altera_fanout
        if { ($a2b | $b2a) } {
           set_instance_parameter  ${inst3}_rx_trs_fanout  NUM_FANOUT  3
        }
        add_connection    ${inst3}.rx_trs       ${inst3}_rx_trs_fanout.sig_input
        add_export_fanout_rename_interface  $inst3   rx_trs          conduit output


        # Pattgen - TX proto connection
        add_pattgen_dut_connection  $inst1  $inst2  $ch1_vpid_insert  $video_std  $a2b  $b2a  $dl_sync  $trs_test  $frame_test $cmp_data

        # Reconfig - RX xcvr connection    
        add_reconfig_dut_connection          $inst4   $inst3        $device  $dir  $video_std
        add_tx_reconfig_dut_connection       $inst2   true        $device  $dir  $video_std
        add_reconfig_router_mgmt_connection  $device  $video_std  $xcvr_tx_pll_sel $reset_reconfig

        # TX proto - TX xcvr connection
        add_tx_proto_xcvr_connection  $inst1  $inst2  $video_std

        # RX xcvr - RX proto connection
        add_rx_xcvr_proto_connection  $inst4  $inst3  $video_std

        # Case:294867 - Providing flexibility to user to control pll_powerdown signal
        add_connection  $inst2.pll_powerdown_out              $inst2.pll_powerdown_in

    }
    ########################################################################################
    
    ######################################################################################## 
    #
    # Level A to Level B conversion, channel 2
    #
    ########################################################################################

    if { $video_std == "dl" & $dir == "rx" & $a2b } {
  
      set  smpte372_ch  ch2
      set  tx_smpte372  ${smpte372_ch}_smpte372_tx_3g
      add_instance            $tx_smpte372  sdi_ii
      propagate_params        $tx_smpte372
      set_instance_parameter  $tx_smpte372  VIDEO_STANDARD        threeg
      set_instance_parameter  $tx_smpte372  DIRECTION             tx
      set_instance_parameter  $tx_smpte372  TX_EN_VPID_INSERT     $ch2_vpid_insert
      set_instance_parameter  $tx_smpte372  TRANSCEIVER_PROTOCOL  xcvr_proto
      set_instance_parameter  $tx_smpte372  RX_EN_A2B_CONV        0
      set_instance_parameter  $tx_smpte372  XCVR_TX_PLL_SEL       0
      set_instance_parameter  $tx_smpte372  HD_FREQ               "148.5"

      #if { $device == "Stratix V" | $device == "Arria V" } {
      #  ##
      #} else {
      #  common_add_export_rename_interface      $tx_smpte372
      #  add_common_xcvr_reconfig_clk_connection $tx_smpte372
      #}

      set  rx_smpte372  ${smpte372_ch}_smpte372_rx_3g
      add_instance            $rx_smpte372  sdi_ii
      propagate_params        $rx_smpte372
      set_instance_parameter  $rx_smpte372  VIDEO_STANDARD        threeg
      set_instance_parameter  $rx_smpte372  DIRECTION             rx
      set_instance_parameter  $rx_smpte372  RX_EN_VPID_EXTRACT    $ch2_vpid_extract
      set_instance_parameter  $rx_smpte372  RX_EN_A2B_CONV        0
      set_instance_parameter  $rx_smpte372  TRANSCEIVER_PROTOCOL  xcvr_proto
      set_instance_parameter  $rx_smpte372  XCVR_TX_PLL_SEL       0
      set_instance_parameter  $rx_smpte372  HD_FREQ               "148.5"

      #if { $device == "Stratix V" | $device == "Arria V" } {
      #  ##
      #} else {
      #  common_add_export_rename_interface      $rx_smpte372
      #  add_common_xcvr_reconfig_clk_connection $rx_smpte372
      #}

      #add_connection tx_refclk_bridge.out_clk test_tx_xcvr_proto_a2b.tx_refclk
      #add_connection rx_refclk_bridge.out_clk test_rx_xcvr_proto_a2b.rx_refclk
      #add_connection tx_rst_bridge.out_reset  test_tx_xcvr_proto_a2b.tx_rst
      #add_connection rx_rst_bridge.out_reset  test_rx_xcvr_proto_a2b.rx_rst
      
      # Connect example design clocks and resets
      #add_clk_bridge tx_refclk_smpte372
      #add_clk_bridge rx_refclk_smpte372
      #add_rst_bridge tx_smpte372
      #add_rst_bridge rx_smpte372
      #add_connection tx_refclk_smpte372_bridge.out_clk $tx_smpte372.tx_refclk
      #add_connection rx_refclk_smpte372_bridge.out_clk $rx_smpte372.rx_refclk
      #add_connection tx_refclk_smpte372_bridge.out_clk tx_smpte372_rst_bridge.clk
      #add_connection rx_refclk_smpte372_bridge.out_clk rx_smpte372_rst_bridge.clk

      # Connect example design clocks and resets
      # Add connection for rx_coreclk, xcvr_refclk, phy_mgmt_clk, rx_rst, tx_rst and phy_mgmt_clk_rst
      add_clk_bridge  ${smpte372_ch}_smpte372_rx_coreclk
      add_connection  ${smpte372_ch}_smpte372_rx_coreclk_bridge.out_clk       $rx_smpte372.rx_coreclk
      add_clk_bridge  ${smpte372_ch}_smpte372_rx_xcvr_refclk
      add_connection  ${smpte372_ch}_smpte372_rx_xcvr_refclk_bridge.out_clk   $rx_smpte372.xcvr_refclk
      add_clk_bridge  ${smpte372_ch}_smpte372_tx_coreclk
      add_connection  ${smpte372_ch}_smpte372_tx_coreclk_bridge.out_clk       $tx_smpte372.tx_coreclk
      add_clk_bridge  ${smpte372_ch}_smpte372_tx_xcvr_refclk
      add_connection  ${smpte372_ch}_smpte372_tx_xcvr_refclk_bridge.out_clk   $tx_smpte372.xcvr_refclk

#      if { $device == "Stratix V" | $device == "Arria V" | $device == "Arria V GZ"} {
#         add_clk_bridge  ${smpte372_ch}_smpte372_rx_phy_mgmt_clk
#         add_connection  ${smpte372_ch}_smpte372_rx_phy_mgmt_clk_bridge.out_clk  $rx_smpte372.phy_mgmt_clk
#         add_clk_bridge  ${smpte372_ch}_smpte372_tx_phy_mgmt_clk
#         add_connection  ${smpte372_ch}_smpte372_tx_phy_mgmt_clk_bridge.out_clk  $tx_smpte372.phy_mgmt_clk
#         add_rst_bridge  ${smpte372_ch}_smpte372_rx_phy_mgmt_clk
         #add_connection ${smpte372_ch}_smpte372_rx_phy_mgmt_clk_bridge.out_clk         ${smpte372_ch}_smpte372_rx_phy_mgmt_rst_bridge.clk
#         add_connection  ${smpte372_ch}_smpte372_rx_xcvr_refclk_bridge.out_clk         ${smpte372_ch}_smpte372_rx_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#         add_connection  ${smpte372_ch}_smpte372_rx_phy_mgmt_clk_rst_bridge.out_reset  $rx_smpte372.phy_mgmt_clk_rst
#         add_rst_bridge  ${smpte372_ch}_smpte372_tx_phy_mgmt_clk
         #add_connection ${smpte372_ch}_smpte372_tx_phy_mgmt_clk_bridge.out_clk         ${smpte372_ch}_smpte372_tx_phy_mgmt_rst_bridge.clk
#         add_connection  ${smpte372_ch}_smpte372_tx_xcvr_refclk_bridge.out_clk         ${smpte372_ch}_smpte372_tx_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#         add_connection  ${smpte372_ch}_smpte372_tx_phy_mgmt_clk_rst_bridge.out_reset  $tx_smpte372.phy_mgmt_clk_rst
#      }
 
      add_rst_bridge  ${smpte372_ch}_smpte372_rx
      #add_connection  ${smpte372_ch}_smpte372_rx_coreclk_bridge.out_clk      ${smpte372_ch}_smpte372_rx_rst_bridge.clk
      add_connection  ${smpte372_ch}_smpte372_rx_xcvr_refclk_bridge.out_clk  ${smpte372_ch}_smpte372_rx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
      add_connection  ${smpte372_ch}_smpte372_rx_rst_bridge.out_reset        $rx_smpte372.rx_rst
      add_rst_bridge  ${smpte372_ch}_smpte372_tx
      #add_connection  ${smpte372_ch}_smpte372_tx_coreclk_bridge.out_clk      ${smpte372_ch}_smpte372_tx_rst_bridge.clk
      add_connection  ${smpte372_ch}_smpte372_tx_xcvr_refclk_bridge.out_clk  ${smpte372_ch}_smpte372_tx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
      add_connection  ${smpte372_ch}_smpte372_tx_rst_bridge.out_reset        $tx_smpte372.tx_rst

      #add_clk_bridge rx_coreclk_smpte372
      #add_rst_bridge tx_smpte372
      #add_rst_bridge rx_smpte372
      #if { $device == "Stratix V" | $device == "Arria V" } { 
      #  add_clk_bridge rx_xcvr_refclk_smpte372
      #  add_clk_bridge tx_xcvr_refclk_smpte372
      #  add_clk_bridge phy_mgmt_clk_smpte372
      #  add_rst_bridge tx_phy_mgmt_clk_smpte372
      #  add_rst_bridge rx_phy_mgmt_clk_smpte372        
      #} else {
      #  add_clk_bridge tx_coreclk_smpte372      
      #}

      #if { $device == "Stratix V" | $device == "Arria V" } { 
      #  ##
      #} else {
      #  add_connection tx_coreclk_smpte372_bridge.out_clk $tx_smpte372.tx_coreclk
      #}

      #add_connection rx_coreclk_smpte372_bridge.out_clk $rx_smpte372.rx_coreclk
      #if { $device == "Stratix V" | $device == "Arria V" } { 
      #  add_connection tx_xcvr_refclk_smpte372_bridge.out_clk $tx_smpte372.xcvr_refclk
      #  add_connection rx_xcvr_refclk_smpte372_bridge.out_clk $rx_smpte372.xcvr_refclk
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk   $tx_smpte372.phy_mgmt_clk
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk   $rx_smpte372.phy_mgmt_clk       
      #}

      #if { $device == "Stratix V" | $device == "Arria V" } { 
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk             tx_smpte372_rst_bridge.clk
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk             tx_phy_mgmt_clk_smpte372_rst_bridge.clk
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk             rx_phy_mgmt_clk_smpte372_rst_bridge.clk
      #  add_connection tx_phy_mgmt_clk_smpte372_rst_bridge.out_reset    $tx_smpte372.phy_mgmt_clk_rst 
      #  add_connection rx_phy_mgmt_clk_smpte372_rst_bridge.out_reset    $rx_smpte372.phy_mgmt_clk_rst
      #} else {
      #  add_connection tx_coreclk_smpte372_bridge.out_clk               tx_smpte372_rst_bridge.clk
      #}
      #add_connection rx_coreclk_smpte372_bridge.out_clk rx_smpte372_rst_bridge.clk

      #add_connection tx_smpte372_rst_bridge.out_reset  $tx_smpte372.tx_rst
      #add_connection rx_smpte372_rst_bridge.out_reset  $rx_smpte372.rx_rst

      add_instance            ${smpte372_ch}_smpte372_rx_clkout_bridge  altera_clock_bridge
      add_connection          ${rx_smpte372}.rx_clkout                  ${smpte372_ch}_smpte372_rx_clkout_bridge.in_clk
      add_interface           ${rx_smpte372}_rx_clkout                  clock                                            start
      set_interface_property  ${rx_smpte372}_rx_clkout                  export_of                                        ${smpte372_ch}_smpte372_rx_clkout_bridge.out_clk
         
      add_instance            ${smpte372_ch}_smpte372_tx_clkout_bridge            altera_clock_bridge
      set_instance_parameter  ${smpte372_ch}_smpte372_tx_clkout_bridge            NUM_CLOCK_OUTPUTS                                    5
      add_connection          ${tx_smpte372}.tx_clkout                            ${smpte372_ch}_smpte372_tx_clkout_bridge.in_clk   
      add_interface           ${tx_smpte372}_tx_clkout clock                      start
      set_interface_property  ${tx_smpte372}_tx_clkout export_of                  ${smpte372_ch}_smpte372_tx_clkout_bridge.out_clk
      add_connection          ${smpte372_ch}_smpte372_tx_clkout_bridge.out_clk_1  ${tx_smpte372}.tx_pclk
      add_connection          ${smpte372_ch}_smpte372_tx_clkout_bridge.out_clk_2  $inst3.rx_clkin_smpte372

      #add_connection  $tx_smpte372.tx_dataout_valid  $tx_smpte372.tx_datain_valid

      #tx_protocol__add_export_rename_interface test_tx_xcvr_proto_a2b tr
      #tx_phy_mgmt__add_export_rename_interface test_tx_xcvr_proto_a2b xcvr_proto tr
      tx_phy__add_export_rename_interface       ${tx_smpte372}  threeg  0
      rx_phy__add_export_rename_interface       ${rx_smpte372}  threeg
      rx_phy_mgmt__add_export_rename_interface  ${rx_smpte372}  threeg  $config
      rx_protocol__add_export_rename_interface  ${rx_smpte372}  threeg  $crc_err  $ch2_vpid_extract $a2b $b2a
      add_export_rename_interface               ${rx_smpte372}  rx_trs  conduit output

      # Case:294867 - Providing flexibility to user to control pll_powerdown signal
      add_connection  $tx_smpte372.pll_powerdown_out        $tx_smpte372.pll_powerdown_in

      #add_reconfig_dut_connection     $rx_smpte372  true  $device  $dir  $video_std
      #add_tx_reconfig_dut_connection  $tx_smpte372  true  $device  $dir  $video_std

      add_reconfig_dut_connection_a2b  ${rx_smpte372}  ${tx_smpte372}


      add_instance      a2b_loopback  sdi_ii_ed_loopback
      propagate_params  a2b_loopback
      set_instance_parameter  a2b_loopback  TX_EN_VPID_INSERT      $ch2_vpid_insert

      #add_connection  tx_smpte372_rst_bridge.out_reset  a2b_loopback.reset
      #add_connection  ${smpte372_ch}_smpte372_tx_clkout_bridge.out_clk_4  a2b_loopback.rx_clk
      #add_connection  ${smpte372_ch}_smpte372_tx_clkout_bridge.out_clk_3  a2b_loopback.tx_clk
      
      add_connection  $inst3.rx_dataout                              ${inst3}_rx_dataout_fanout.sig_input
      add_connection  ${inst3}_rx_dataout_fanout.sig_fanout1         a2b_loopback.rx_data
      add_connection  $inst3.rx_dataout_valid                        ${inst3}_rx_dataout_valid_fanout.sig_input
      add_connection  ${inst3}_rx_dataout_valid_fanout.sig_fanout1   a2b_loopback.rx_data_valid

      add_connection  $inst3.rx_ln                                   ${inst3}_rx_ln_fanout.sig_input
      add_connection  ${inst3}_rx_ln_fanout.sig_fanout1              a2b_loopback.rx_ln
      add_connection  $inst3.rx_ln_b                                 ${inst3}_rx_ln_b_fanout.sig_input
      add_connection  ${inst3}_rx_ln_b_fanout.sig_fanout1            a2b_loopback.rx_ln_b
      #add_connection  $inst3.rx_std            a2b_loopback.rx_std

      if { $ch1_vpid_extract } {
        add_connection  $inst3.rx_vpid_byte1                         ${inst3}_rx_vpid_byte1_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte1_fanout.sig_fanout1    a2b_loopback.rx_vpid_byte1
        add_connection  $inst3.rx_vpid_byte2                         ${inst3}_rx_vpid_byte2_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte2_fanout.sig_fanout1    a2b_loopback.rx_vpid_byte2
        add_connection  $inst3.rx_vpid_byte3                         ${inst3}_rx_vpid_byte3_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte3_fanout.sig_fanout1    a2b_loopback.rx_vpid_byte3
        add_connection  $inst3.rx_vpid_byte4                         ${inst3}_rx_vpid_byte4_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte4_fanout.sig_fanout1    a2b_loopback.rx_vpid_byte4
        add_connection  $inst3.rx_vpid_byte1_b                       ${inst3}_rx_vpid_byte1_b_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte1_b_fanout.sig_fanout1  a2b_loopback.rx_vpid_byte1_b
        add_connection  $inst3.rx_vpid_byte2_b                       ${inst3}_rx_vpid_byte2_b_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte2_b_fanout.sig_fanout1  a2b_loopback.rx_vpid_byte2_b
        add_connection  $inst3.rx_vpid_byte3_b                       ${inst3}_rx_vpid_byte3_b_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte3_b_fanout.sig_fanout1  a2b_loopback.rx_vpid_byte3_b
        add_connection  $inst3.rx_vpid_byte4_b                       ${inst3}_rx_vpid_byte4_b_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte4_b_fanout.sig_fanout1  a2b_loopback.rx_vpid_byte4_b
        add_connection  $inst3.rx_line_f0                            ${inst3}_rx_line_f0_fanout.sig_input
        add_connection  ${inst3}_rx_line_f0_fanout.sig_fanout1       a2b_loopback.rx_line_f0
        add_connection  $inst3.rx_line_f1                            ${inst3}_rx_line_f1_fanout.sig_input
        add_connection  ${inst3}_rx_line_f1_fanout.sig_fanout1       a2b_loopback.rx_line_f1
      }

      # if { $trs_misc } {
      #  add_connection  $inst3.rx_trs                        ${inst3}_rx_trs_fanout.sig_input
      if { $config == "xcvr_proto" } {
        add_connection  ${inst3}_rx_trs_fanout.sig_fanout1   a2b_loopback.rx_trs
      } else {
        add_connection  ${inst3}_rx_trs_fanout.sig_fanout2   a2b_loopback.rx_trs
      }
        add_connection  a2b_loopback.tx_trs                  ${tx_smpte372}.tx_trs

      # }
 
      add_connection  ${tx_smpte372}.tx_dataout_valid   a2b_loopback.tx_data_valid
      add_connection  a2b_loopback.tx_data              ${tx_smpte372}.tx_datain
      add_connection  a2b_loopback.tx_data_valid_out    ${tx_smpte372}.tx_datain_valid
      # add_connection  a2b_loopback.tx_enable_vpid_c    ${tx_smpte372}.tx_enable_vpid_c
      add_connection  a2b_loopback.tx_vpid_overwrite   ${tx_smpte372}.tx_vpid_overwrite
      add_connection  a2b_loopback.tx_vpid_byte1       ${tx_smpte372}.tx_vpid_byte1
      add_connection  a2b_loopback.tx_vpid_byte2       ${tx_smpte372}.tx_vpid_byte2
      add_connection  a2b_loopback.tx_vpid_byte3       ${tx_smpte372}.tx_vpid_byte3
      add_connection  a2b_loopback.tx_vpid_byte4       ${tx_smpte372}.tx_vpid_byte4
      add_connection  a2b_loopback.tx_vpid_byte1_b     ${tx_smpte372}.tx_vpid_byte1_b
      add_connection  a2b_loopback.tx_vpid_byte2_b     ${tx_smpte372}.tx_vpid_byte2_b
      add_connection  a2b_loopback.tx_vpid_byte3_b     ${tx_smpte372}.tx_vpid_byte3_b
      add_connection  a2b_loopback.tx_vpid_byte4_b     ${tx_smpte372}.tx_vpid_byte4_b
      add_connection  a2b_loopback.tx_std              ${tx_smpte372}.tx_std
      add_connection  a2b_loopback.tx_ln               ${tx_smpte372}.tx_ln
      add_connection  a2b_loopback.tx_ln_b             ${tx_smpte372}.tx_ln_b

      #Drive unnecessary enable_crc and enable_ln ports to GND
      add_connection  a2b_loopback.tx_enable_crc        ${tx_smpte372}.tx_enable_crc
      add_connection  a2b_loopback.tx_enable_ln         ${tx_smpte372}.tx_enable_ln
      add_connection  a2b_loopback.tx_line_f0           ${tx_smpte372}.tx_line_f0
      add_connection  a2b_loopback.tx_line_f1           ${tx_smpte372}.tx_line_f1

    }
    ########################################################################################

    ########################################################################################   
    # 
    # Level B to Level A conversion channel 2
    #
    ########################################################################################
    
    if { ($video_std == "threeg" | $video_std == "tr") & $dir == "rx" & $b2a } {
    
      set  smpte372_ch  ch2
      set  tx_smpte372  ${smpte372_ch}_smpte372_tx_dl
      
      add_instance            $tx_smpte372  sdi_ii
      propagate_params        $tx_smpte372
      set_instance_parameter  $tx_smpte372  VIDEO_STANDARD        dl
      set_instance_parameter  $tx_smpte372  DIRECTION             tx
      set_instance_parameter  $tx_smpte372  TX_EN_VPID_INSERT     $ch2_vpid_insert
      set_instance_parameter  $tx_smpte372  TRANSCEIVER_PROTOCOL  xcvr_proto
      set_instance_parameter  $tx_smpte372  RX_EN_B2A_CONV        0
      set_instance_parameter  $tx_smpte372  XCVR_TX_PLL_SEL       0

      #if { $device == "Stratix V" | $device == "Arria V" } {
      #  ##
      #} else {
      #  common_add_export_rename_interface      $tx_smpte372
      #  add_common_xcvr_reconfig_clk_connection $tx_smpte372
      #}

      set  rx_smpte372  ${smpte372_ch}_smpte372_rx_dl

      add_instance            $rx_smpte372  sdi_ii
      propagate_params        $rx_smpte372
      set_instance_parameter  $rx_smpte372  VIDEO_STANDARD        dl
      set_instance_parameter  $rx_smpte372  DIRECTION             rx
      set_instance_parameter  $rx_smpte372  RX_EN_VPID_EXTRACT    $ch2_vpid_extract
      set_instance_parameter  $rx_smpte372  RX_EN_B2A_CONV        0
      set_instance_parameter  $rx_smpte372  TRANSCEIVER_PROTOCOL  xcvr_proto
      set_instance_parameter  $rx_smpte372  XCVR_TX_PLL_SEL       0

      #if { $device == "Stratix V" | $device == "Arria V" } {
      #  ##
      #} else {
      #  common_add_export_rename_interface      $rx_smpte372
      #  add_common_xcvr_reconfig_clk_connection $rx_smpte372
      #}

      #add_connection tx_refclk_bridge.out_clk test_tx_xcvr_proto_a2b.tx_refclk
      #add_connection rx_refclk_bridge.out_clk test_rx_xcvr_proto_a2b.rx_refclk
      #add_connection tx_rst_bridge.out_reset  test_tx_xcvr_proto_a2b.tx_rst
      #add_connection rx_rst_bridge.out_reset  test_rx_xcvr_proto_a2b.rx_rst
      
      # Connect example design clocks and resets
      #add_clk_bridge tx_refclk_smpte372
      #add_clk_bridge rx_refclk_smpte372
      #add_rst_bridge tx_smpte372
      #add_rst_bridge rx_smpte372
      #add_connection tx_refclk_smpte372_bridge.out_clk $tx_smpte372.tx_refclk
      #add_connection rx_refclk_smpte372_bridge.out_clk $rx_smpte372.rx_refclk
      #add_connection tx_refclk_smpte372_bridge.out_clk tx_smpte372_rst_bridge.clk
      #add_connection rx_refclk_smpte372_bridge.out_clk rx_smpte372_rst_bridge.clk

      # Connect example design clocks and resets
      # Add connection for rx_coreclk, xcvr_refclk, phy_mgmt_clk, rx_rst, tx_rst and phy_mgmt_clk_rst
      
      add_clk_bridge  ${smpte372_ch}_smpte372_rx_coreclk
      add_connection  ${smpte372_ch}_smpte372_rx_coreclk_bridge.out_clk    ${rx_smpte372}.rx_coreclk    
      add_clk_bridge  ${smpte372_ch}_smpte372_rx_xcvr_refclk
      add_connection  ${smpte372_ch}_smpte372_rx_xcvr_refclk_bridge.out_clk   ${rx_smpte372}.xcvr_refclk
      add_clk_bridge  ${smpte372_ch}_smpte372_tx_coreclk
      add_connection  ${smpte372_ch}_smpte372_tx_coreclk_bridge.out_clk    ${tx_smpte372}.tx_coreclk
      add_clk_bridge  ${smpte372_ch}_smpte372_tx_xcvr_refclk
      add_connection  ${smpte372_ch}_smpte372_tx_xcvr_refclk_bridge.out_clk   ${tx_smpte372}.xcvr_refclk

#      if { $device == "Stratix V" | $device == "Arria V" | $device == "Arria V GZ"} {
#         add_clk_bridge  ${smpte372_ch}_smpte372_rx_phy_mgmt_clk
#         add_connection  ${smpte372_ch}_smpte372_rx_phy_mgmt_clk_bridge.out_clk  ${rx_smpte372}.phy_mgmt_clk
#         add_clk_bridge  ${smpte372_ch}_smpte372_tx_phy_mgmt_clk
#         add_connection  ${smpte372_ch}_smpte372_tx_phy_mgmt_clk_bridge.out_clk  ${tx_smpte372}.phy_mgmt_clk
#         add_rst_bridge  ${smpte372_ch}_smpte372_rx_phy_mgmt_clk
         #add_connection ${smpte372_ch}_smpte372_rx_phy_mgmt_clk_bridge.out_clk         ${smpte372_ch}_smpte372_rx_phy_mgmt_rst_bridge.clk
#         add_connection  ${smpte372_ch}_smpte372_rx_xcvr_refclk_bridge.out_clk         ${smpte372_ch}_smpte372_rx_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#         add_connection  ${smpte372_ch}_smpte372_rx_phy_mgmt_clk_rst_bridge.out_reset  ${rx_smpte372}.phy_mgmt_clk_rst
#         add_rst_bridge  ${smpte372_ch}_smpte372_tx_phy_mgmt_clk
         #add_connection ${smpte372_ch}_smpte372_tx_phy_mgmt_clk_bridge.out_clk         ${smpte372_ch}_smpte372_tx_phy_mgmt_rst_bridge.clk
#         add_connection  ${smpte372_ch}_smpte372_tx_xcvr_refclk_bridge.out_clk         ${smpte372_ch}_smpte372_tx_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#         add_connection  ${smpte372_ch}_smpte372_tx_phy_mgmt_clk_rst_bridge.out_reset  ${tx_smpte372}.phy_mgmt_clk_rst 
#      }
 
      add_rst_bridge  ${smpte372_ch}_smpte372_rx
      #add_connection  ${smpte372_ch}_smpte372_rx_coreclk_bridge.out_clk      ${smpte372_ch}_smpte372_rx_rst_bridge.clk
      add_connection  ${smpte372_ch}_smpte372_rx_xcvr_refclk_bridge.out_clk   ${smpte372_ch}_smpte372_rx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
      add_connection  ${smpte372_ch}_smpte372_rx_rst_bridge.out_reset        ${rx_smpte372}.rx_rst
      add_rst_bridge  ${smpte372_ch}_smpte372_tx
      #add_connection  ${smpte372_ch}_smpte372_tx_coreclk_bridge.out_clk      ${smpte372_ch}_smpte372_tx_rst_bridge.clk
      add_connection  ${smpte372_ch}_smpte372_tx_xcvr_refclk_bridge.out_clk   ${smpte372_ch}_smpte372_tx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
      add_connection  ${smpte372_ch}_smpte372_tx_rst_bridge.out_reset        ${tx_smpte372}.tx_rst

      #add_clk_bridge rx_coreclk_smpte372
      #add_rst_bridge tx_smpte372
      #add_rst_bridge rx_smpte372
      #if { $device == "Stratix V" || $device == "Arria V" } {
      #  add_clk_bridge rx_xcvr_refclk_smpte372
      #  add_clk_bridge tx_xcvr_refclk_smpte372
      #  add_clk_bridge phy_mgmt_clk_smpte372
      #  add_rst_bridge rx_phy_mgmt_clk_smpte372
      #  add_rst_bridge tx_phy_mgmt_clk_smpte372
      #} else {
      #  add_clk_bridge tx_coreclk_smpte372
      #}

      #if { $device == "Stratix V" | $device == "Arria V" } {
      #  ##
      #} else {
      #  add_connection tx_coreclk_smpte372_bridge.out_clk $tx_smpte372.tx_coreclk
      #}
      #add_connection rx_coreclk_smpte372_bridge.out_clk $rx_smpte372.rx_coreclk
      #if { $device == "Stratix V" || $device == "Arria V" } { 
      #  add_connection rx_xcvr_refclk_smpte372_bridge.out_clk $rx_smpte372.xcvr_refclk
      #  add_connection tx_xcvr_refclk_smpte372_bridge.out_clk $tx_smpte372.xcvr_refclk
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk   $rx_smpte372.phy_mgmt_clk
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk   $tx_smpte372.phy_mgmt_clk
      #}
      #if { $device == "Stratix V" | $device == "Arria V" } {
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk           tx_smpte372_rst_bridge.clk
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk           rx_phy_mgmt_clk_smpte372_rst_bridge.clk
      #  add_connection phy_mgmt_clk_smpte372_bridge.out_clk           tx_phy_mgmt_clk_smpte372_rst_bridge.clk
      #  add_connection rx_phy_mgmt_clk_smpte372_rst_bridge.out_reset  $rx_smpte372.phy_mgmt_clk_rst
      #  add_connection tx_phy_mgmt_clk_smpte372_rst_bridge.out_reset  $tx_smpte372.phy_mgmt_clk_rst
      #} else {
      #  add_connection tx_coreclk_smpte372_bridge.out_clk tx_smpte372_rst_bridge.clk
      #}
      #add_connection rx_coreclk_smpte372_bridge.out_clk rx_smpte372_rst_bridge.clk

      #add_connection tx_smpte372_rst_bridge.out_reset  $tx_smpte372.tx_rst
      #add_connection rx_smpte372_rst_bridge.out_reset  $rx_smpte372.rx_rst

      add_instance            ${smpte372_ch}_smpte372_rx_clkout_bridge  altera_clock_bridge
      add_connection          ${rx_smpte372}.rx_clkout                  ${smpte372_ch}_smpte372_rx_clkout_bridge.in_clk
      add_interface           ${rx_smpte372}_rx_clkout                  clock                                            start
      set_interface_property  ${rx_smpte372}_rx_clkout                  export_of                                        ${smpte372_ch}_smpte372_rx_clkout_bridge.out_clk
         
      add_instance            ${smpte372_ch}_smpte372_tx_clkout_bridge  altera_clock_bridge
      set_instance_parameter  ${smpte372_ch}_smpte372_tx_clkout_bridge  NUM_CLOCK_OUTPUTS                                    5
      add_connection          ${tx_smpte372}.tx_clkout                  ${smpte372_ch}_smpte372_tx_clkout_bridge.in_clk   
      add_interface           ${tx_smpte372}_tx_clkout                  clock                                                start
      set_interface_property  ${tx_smpte372}_tx_clkout                  export_of                                            ${smpte372_ch}_smpte372_tx_clkout_bridge.out_clk
      add_connection          ${smpte372_ch}_smpte372_tx_clkout_bridge.out_clk_1  ${tx_smpte372}.tx_pclk
      add_connection          ${smpte372_ch}_smpte372_tx_clkout_bridge.out_clk_2  $inst3.rx_clkin_smpte372
      #add_connection         ${tx_smpte372}.tx_dataout_valid                         ${tx_smpte372}.tx_datain_valid
      #add_connection         ${tx_smpte372}.tx_dataout_valid_b                       ${tx_smpte372}.tx_datain_valid_b

      #tx_protocol__add_export_rename_interface test_tx_xcvr_proto_a2b tr
      #tx_phy_mgmt__add_export_rename_interface test_tx_xcvr_proto_a2b xcvr_proto tr
      tx_phy__add_export_rename_interface       $tx_smpte372  dl  0
      rx_phy__add_export_rename_interface       $rx_smpte372  dl
      rx_phy_mgmt__add_export_rename_interface  $rx_smpte372  dl $config
      rx_protocol__add_export_rename_interface  $rx_smpte372  dl $crc_err  $ch2_vpid_extract $a2b $b2a
      add_export_rename_interface               $rx_smpte372  rx_trs  conduit output

      # Case:294867 - Providing flexibility to user to control pll_powerdown signal
      add_connection            $tx_smpte372.pll_powerdown_out        $tx_smpte372.pll_powerdown_in
      #add_instance                 rx_std_fanout                       altera_fanout
      #set_instance_parameter       rx_std_fanout                       WIDTH                                   2
      #add_connection               $rx_smpte372.rx_std                 rx_std_fanout.sig_input
      #add_instance                 rx_sdi_start_reconfig_fanout        altera_fanout
      #set_instance_parameter       rx_sdi_start_reconfig_fanout        WIDTH                                   1
      #add_connection               $rx_smpte372.rx_sdi_start_reconfig  rx_sdi_start_reconfig_fanout.sig_input
      #add_reconfig_dut_connection  $rx_smpte372                        rx_std_fanout                           rx_sdi_start_reconfig_fanout true  $device

      add_reconfig_dut_connection_b2a  $rx_smpte372  $tx_smpte372

      add_instance            b2a_loopback  sdi_ii_ed_loopback
      propagate_params        b2a_loopback
      set_instance_parameter  b2a_loopback  TX_EN_VPID_INSERT      $ch2_vpid_insert

      #add_connection  tx_smpte372_rst_bridge.out_reset  b2a_loopback.reset
      
      #add_connection  rx_clkout_bridge.out_clk_1                               b2a_loopback.rx_clk
      #add_connection  ${smpte372_ch}_smpte372_tx_clkout_bridge.out_clk_3   b2a_loopback.tx_clk

      add_connection  $inst3.rx_dataout                                ${inst3}_rx_dataout_fanout.sig_input
      add_connection  ${inst3}_rx_dataout_fanout.sig_fanout1           b2a_loopback.rx_data
      add_connection  $inst3.rx_dataout_valid                          ${inst3}_rx_dataout_valid_fanout.sig_input
      add_connection  ${inst3}_rx_dataout_valid_fanout.sig_fanout1     b2a_loopback.rx_data_valid
      add_connection  $inst3.rx_dataout_b                              ${inst3}_rx_dataout_b_fanout.sig_input
      add_connection  ${inst3}_rx_dataout_b_fanout.sig_fanout1         b2a_loopback.rx_data_b
      add_connection  $inst3.rx_dataout_valid_b                        ${inst3}_rx_dataout_valid_b_fanout.sig_input
      add_connection  ${inst3}_rx_dataout_valid_b_fanout.sig_fanout1   b2a_loopback.rx_data_valid_b

      add_connection  $inst3.rx_ln                                     ${inst3}_rx_ln_fanout.sig_input
      add_connection  ${inst3}_rx_ln_fanout.sig_fanout1                b2a_loopback.rx_ln
      add_connection  $inst3.rx_ln_b                                   ${inst3}_rx_ln_b_fanout.sig_input
      add_connection  ${inst3}_rx_ln_b_fanout.sig_fanout1              b2a_loopback.rx_ln_b

      if { $ch1_vpid_extract } {
        add_connection  $inst3.rx_vpid_byte1                          ${inst3}_rx_vpid_byte1_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte1_fanout.sig_fanout1     b2a_loopback.rx_vpid_byte1
        add_connection  $inst3.rx_vpid_byte2                          ${inst3}_rx_vpid_byte2_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte2_fanout.sig_fanout1     b2a_loopback.rx_vpid_byte2
        add_connection  $inst3.rx_vpid_byte3                          ${inst3}_rx_vpid_byte3_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte3_fanout.sig_fanout1     b2a_loopback.rx_vpid_byte3
        add_connection  $inst3.rx_vpid_byte4                          ${inst3}_rx_vpid_byte4_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte4_fanout.sig_fanout1     b2a_loopback.rx_vpid_byte4
        add_connection  $inst3.rx_vpid_byte1_b                        ${inst3}_rx_vpid_byte1_b_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte1_b_fanout.sig_fanout1   b2a_loopback.rx_vpid_byte1_b
        add_connection  $inst3.rx_vpid_byte2_b                        ${inst3}_rx_vpid_byte2_b_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte2_b_fanout.sig_fanout1   b2a_loopback.rx_vpid_byte2_b
        add_connection  $inst3.rx_vpid_byte3_b                        ${inst3}_rx_vpid_byte3_b_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte3_b_fanout.sig_fanout1   b2a_loopback.rx_vpid_byte3_b
        add_connection  $inst3.rx_vpid_byte4_b                        ${inst3}_rx_vpid_byte4_b_fanout.sig_input
        add_connection  ${inst3}_rx_vpid_byte4_b_fanout.sig_fanout1   b2a_loopback.rx_vpid_byte4_b
        add_connection  $inst3.rx_line_f0                             ${inst3}_rx_line_f0_fanout.sig_input
        add_connection  ${inst3}_rx_line_f0_fanout.sig_fanout1        b2a_loopback.rx_line_f0
        add_connection  $inst3.rx_line_f1                             ${inst3}_rx_line_f1_fanout.sig_input
        add_connection  ${inst3}_rx_line_f1_fanout.sig_fanout1        b2a_loopback.rx_line_f1
      }

      # if { $trs_misc } {
      # add_connection  $inst3.rx_trs                        ${inst3}_rx_trs_fanout.sig_input
      if { $config == "xcvr_proto" } {
        add_connection  ${inst3}_rx_trs_fanout.sig_fanout1   b2a_loopback.rx_trs
      } else {
        add_connection  ${inst3}_rx_trs_fanout.sig_fanout2   b2a_loopback.rx_trs
      }
        add_connection  b2a_loopback.tx_trs                  ${tx_smpte372}.tx_trs
        add_connection  b2a_loopback.tx_trs_b                ${tx_smpte372}.tx_trs_b
      # }

      add_connection  ${tx_smpte372}.tx_dataout_valid   b2a_loopback.tx_data_valid
      add_connection  ${tx_smpte372}.tx_dataout_valid_b b2a_loopback.tx_data_valid_b
      add_connection  b2a_loopback.tx_data              ${tx_smpte372}.tx_datain
      add_connection  b2a_loopback.tx_data_b            ${tx_smpte372}.tx_datain_b
      add_connection  b2a_loopback.tx_data_valid_out    ${tx_smpte372}.tx_datain_valid
      add_connection  b2a_loopback.tx_data_valid_out_b  ${tx_smpte372}.tx_datain_valid_b
      # add_connection  b2a_loopback.tx_enable_vpid_c     ${tx_smpte372}.tx_enable_vpid_c
      add_connection  b2a_loopback.tx_vpid_overwrite    ${tx_smpte372}.tx_vpid_overwrite
      add_connection  b2a_loopback.tx_vpid_byte1        ${tx_smpte372}.tx_vpid_byte1
      add_connection  b2a_loopback.tx_vpid_byte2        ${tx_smpte372}.tx_vpid_byte2
      add_connection  b2a_loopback.tx_vpid_byte3        ${tx_smpte372}.tx_vpid_byte3
      add_connection  b2a_loopback.tx_vpid_byte4        ${tx_smpte372}.tx_vpid_byte4
      add_connection  b2a_loopback.tx_vpid_byte1_b      ${tx_smpte372}.tx_vpid_byte1_b
      add_connection  b2a_loopback.tx_vpid_byte2_b      ${tx_smpte372}.tx_vpid_byte2_b
      add_connection  b2a_loopback.tx_vpid_byte3_b      ${tx_smpte372}.tx_vpid_byte3_b
      add_connection  b2a_loopback.tx_vpid_byte4_b      ${tx_smpte372}.tx_vpid_byte4_b
      add_connection  b2a_loopback.tx_ln                ${tx_smpte372}.tx_ln
      add_connection  b2a_loopback.tx_ln_b              ${tx_smpte372}.tx_ln_b
      #add_connection  b2a_loopback.tx_std               ${tx_smpte372}.tx_std

      #Drive unnecessary enable_crc and enable_ln ports to GND
      add_connection  b2a_loopback.tx_enable_crc        ${tx_smpte372}.tx_enable_crc
      add_connection  b2a_loopback.tx_enable_ln         ${tx_smpte372}.tx_enable_ln
      add_connection  b2a_loopback.tx_line_f0           ${tx_smpte372}.tx_line_f0
      add_connection  b2a_loopback.tx_line_f1           ${tx_smpte372}.tx_line_f1

      # enable_ln, enable_crc, tx_ln, tx_trs could be tied to 1'b0
    }
    ########################################################################################

    ################################################################## 
    # 
    # Instantiate SDI Duplex instance at Channel 0  
    # to demonstrate multi-channel reconfiguration
    # Configuration fixed at duplex, xcvr_proto
    #
    ##################################################################
    ##if { $device == "Stratix V" || $device == "Arria V" } 

      set  lb_ch       ch0
      set  lb_ch_name  loopback_du_$video_std
      add_instance            ${lb_ch}_${lb_ch_name}  sdi_ii
      propagate_params        ${lb_ch}_${lb_ch_name}
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  DIRECTION             du
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  TRANSCEIVER_PROTOCOL  xcvr_proto
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  VIDEO_STANDARD        $video_std
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  RX_EN_A2B_CONV        0
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  RX_EN_B2A_CONV        0
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  TX_HD_2X_OVERSAMPLING 0
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  TX_EN_VPID_INSERT     $ch0_vpid_insert
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  RX_EN_VPID_EXTRACT    $ch0_vpid_extract
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  XCVR_TX_PLL_SEL       0
      set_instance_parameter  ${lb_ch}_${lb_ch_name}  HD_FREQ               $hd_frequency

      # set_instance_parameter  ${lb_ch}_${lb_ch_name}  RX_EN_TRS_MISC        $trs_misc
      #set_instance_parameter  ${lb_ch}_${lb_ch_name}  DIRECTION             du

      #if { $device == "Stratix V" | $device == "Arria V" } {
      #  ##
      #} else {
      #  common_add_export_rename_interface      ${lb_ch}_${lb_ch_name}
      #  add_common_xcvr_reconfig_clk_connection ${lb_ch}_${lb_ch_name}
      #}      

      # Add clock and reset bridges 
      if { $hd_frequency == "74.25" } {
        add_clk_bridge  ${lb_ch}_du_rx_coreclk_hd
        add_connection  ${lb_ch}_du_rx_coreclk_hd_bridge.out_clk   ${lb_ch}_${lb_ch_name}.rx_coreclk_hd
        add_clk_bridge  ${lb_ch}_du_tx_coreclk_hd
        add_connection  ${lb_ch}_du_tx_coreclk_hd_bridge.out_clk   ${lb_ch}_${lb_ch_name}.tx_coreclk_hd
      } else {
        add_clk_bridge  ${lb_ch}_du_rx_coreclk
        add_connection  ${lb_ch}_du_rx_coreclk_bridge.out_clk      ${lb_ch}_${lb_ch_name}.rx_coreclk
        add_clk_bridge  ${lb_ch}_du_tx_coreclk
        add_connection  ${lb_ch}_du_tx_coreclk_bridge.out_clk      ${lb_ch}_${lb_ch_name}.tx_coreclk
      }
      add_clk_bridge  ${lb_ch}_du_xcvr_refclk
      add_connection  ${lb_ch}_du_xcvr_refclk_bridge.out_clk       ${lb_ch}_${lb_ch_name}.xcvr_refclk
      

#      if { $device == "Stratix V" | $device == "Arria V" | $device == "Arria V GZ"} {
#         add_clk_bridge  ${lb_ch}_du_phy_mgmt_clk
#         add_connection  ${lb_ch}_du_phy_mgmt_clk_bridge.out_clk  ${lb_ch}_${lb_ch_name}.phy_mgmt_clk
#         add_rst_bridge  ${lb_ch}_du_phy_mgmt_clk
#         add_connection  ${lb_ch}_du_phy_mgmt_clk_rst_bridge.out_reset  ${lb_ch}_${lb_ch_name}.phy_mgmt_clk_rst
         #add_connection  ${lb_ch}_du_phy_mgmt_clk_bridge.out_clk        ${lb_ch}_du_phy_mgmt_rst_bridge.clk
#         add_connection  ${lb_ch}_du_xcvr_refclk_bridge.out_clk         ${lb_ch}_du_phy_mgmt_clk_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
#      }

      add_rst_bridge  ${lb_ch}_du_rx
      add_rst_bridge  ${lb_ch}_du_tx
      add_connection  ${lb_ch}_du_xcvr_refclk_bridge.out_clk   ${lb_ch}_du_rx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added
      add_connection  ${lb_ch}_du_xcvr_refclk_bridge.out_clk   ${lb_ch}_du_tx_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added

      add_connection  ${lb_ch}_du_rx_rst_bridge.out_reset      ${lb_ch}_${lb_ch_name}.rx_rst
      #add_connection  ${lb_ch}_du_tx_coreclk_bridge.out_clk   ${lb_ch}_du_tx_rst_bridge.clk
      add_connection  ${lb_ch}_du_tx_rst_bridge.out_reset      ${lb_ch}_${lb_ch_name}.tx_rst

      #add_rst_bridge tx_ch0
      #add_rst_bridge rx_ch0
    
      #if { $device == "Stratix V" | $device == "Arria V" } {
      #  add_clk_bridge du_xcvr_refclk_ch0
      #  add_rst_bridge du_phy_mgmt_clk_ch0
      #}

      #if { $device == "Stratix V" | $device == "Arria V" } { 
      #  ##
      #} else {
      #  add_connection tx_coreclk_bridge.out_clk $inst_ch0.tx_coreclk
      #}

      #add_connection rx_coreclk_bridge.out_clk $inst_ch0.rx_coreclk
      #if { $device == "Stratix V" || $device == "Arria V" } { 
      #  add_connection du_xcvr_refclk_ch0_bridge.out_clk  $inst_ch0.xcvr_refclk
      #  add_connection phy_mgmt_clk_bridge.out_clk     $inst_ch0.phy_mgmt_clk
      #}

      #if { $device == "Stratix V" || $device == "Arria V" } { 
      #  add_connection phy_mgmt_clk_bridge.out_clk                 tx_ch0_rst_bridge.clk
      #  add_connection phy_mgmt_clk_bridge.out_clk                 du_phy_mgmt_clk_ch0_rst_bridge.clk
      #  add_connection du_phy_mgmt_clk_ch0_rst_bridge.out_reset    $inst_ch0.phy_mgmt_clk_rst 
      #} else {
      #  add_connection tx_coreclk_bridge.out_clk               tx_ch0_rst_bridge.clk
      #}
      #add_connection rx_coreclk_bridge.out_clk    rx_ch0_rst_bridge.clk

      #add_connection tx_ch0_rst_bridge.out_reset  $inst_ch0.tx_rst
      #add_connection rx_ch0_rst_bridge.out_reset  $inst_ch0.rx_rst

      add_instance            rx_clkout_${lb_ch}_bridge         altera_clock_bridge
      set_instance_parameter  rx_clkout_${lb_ch}_bridge         NUM_CLOCK_OUTPUTS  3
      add_connection          ${lb_ch}_${lb_ch_name}.rx_clkout  rx_clkout_${lb_ch}_bridge.in_clk
      add_interface           ${lb_ch}_${lb_ch_name}_rx_clkout  clock      start
      set_interface_property  ${lb_ch}_${lb_ch_name}_rx_clkout  export_of  rx_clkout_${lb_ch}_bridge.out_clk
         
      add_instance            tx_clkout_${lb_ch}_bridge         altera_clock_bridge
      set_instance_parameter  tx_clkout_${lb_ch}_bridge         NUM_CLOCK_OUTPUTS  3
      add_connection          ${lb_ch}_${lb_ch_name}.tx_clkout  tx_clkout_${lb_ch}_bridge.in_clk   
      add_interface           ${lb_ch}_${lb_ch_name}_tx_clkout  clock      start
      set_interface_property  ${lb_ch}_${lb_ch_name}_tx_clkout  export_of  tx_clkout_${lb_ch}_bridge.out_clk
      add_connection          tx_clkout_${lb_ch}_bridge.out_clk_1          ${lb_ch}_${lb_ch_name}.tx_pclk
      ##add_connection        tx_clkout_${lb_ch}_bridge.out_clk_2          ${lb_ch}_${lb_ch_name}.rx_clkin_smpte372

      if { $video_std == "tr" | $video_std == "ds" } {
         add_instance     ${lb_ch}_${lb_ch_name}_rx_sdi_start_reconfig_fanout   altera_fanout
         add_connection   ${lb_ch}_${lb_ch_name}.rx_sdi_start_reconfig          ${lb_ch}_${lb_ch_name}_rx_sdi_start_reconfig_fanout.sig_input
      }

      add_reconfig_du_ch0_connection            ${lb_ch}_${lb_ch_name}  true  $device  $video_std
      tx_phy__add_export_rename_interface       ${lb_ch}_${lb_ch_name}  $video_std  0
      rx_phy__add_export_rename_interface       ${lb_ch}_${lb_ch_name}  $video_std
      rx_phy_mgmt__add_export_rename_interface  ${lb_ch}_${lb_ch_name}  $video_std  $config
      rx_protocol__add_export_rename_interface  ${lb_ch}_${lb_ch_name}  $video_std  $crc_err  $ch0_vpid_extract $a2b $b2a
      add_export_rename_interface               ${lb_ch}_${lb_ch_name}   rx_trs          conduit output

      add_instance            ${lb_ch}_loopback  sdi_ii_ed_loopback
      propagate_params        ${lb_ch}_loopback
      set_instance_parameter  ${lb_ch}_loopback  RX_EN_A2B_CONV       0
      set_instance_parameter  ${lb_ch}_loopback  RX_EN_B2A_CONV       0
      set_instance_parameter  ${lb_ch}_loopback  TX_EN_VPID_INSERT    $ch0_vpid_insert
      set_instance_parameter  ${lb_ch}_loopback  RX_EN_VPID_EXTRACT   $ch0_vpid_extract

      add_instance     ${lb_ch}_${lb_ch_name}_rx_rst_proto_out_fanout   altera_fanout
      add_connection   ${lb_ch}_${lb_ch_name}.rx_rst_proto_out          ${lb_ch}_${lb_ch_name}_rx_rst_proto_out_fanout.sig_input


      #add_connection  rx_${lb_ch}_rst_bridge.out_reset         ${lb_ch}_loopback.reset
      add_connection  ${lb_ch}_${lb_ch_name}_rx_rst_proto_out_fanout.sig_fanout1   ${lb_ch}_loopback.rx_rst      
      add_connection  rx_clkout_${lb_ch}_bridge.out_clk_1                          ${lb_ch}_loopback.rx_clk
      # add_connection  ${lb_ch}_du_tx_rst_bridge.out_reset                          ${lb_ch}_loopback.tx_rst
      add_connection  tx_clkout_${lb_ch}_bridge.out_clk_2                          ${lb_ch}_loopback.tx_clk
      
      add_connection  ${lb_ch}_${lb_ch_name}.rx_dataout                            ${lb_ch}_${lb_ch_name}_rx_dataout_fanout.sig_input
      add_connection  ${lb_ch}_${lb_ch_name}_rx_dataout_fanout.sig_fanout1         ${lb_ch}_loopback.rx_data
      add_connection  ${lb_ch}_${lb_ch_name}.rx_dataout_valid                      ${lb_ch}_${lb_ch_name}_rx_dataout_valid_fanout.sig_input
      add_connection  ${lb_ch}_${lb_ch_name}_rx_dataout_valid_fanout.sig_fanout1   ${lb_ch}_loopback.rx_data_valid
      add_connection  ${lb_ch}_${lb_ch_name}.rx_trs_locked                         ${lb_ch}_${lb_ch_name}_rx_trs_locked_fanout.sig_input
      add_connection  ${lb_ch}_${lb_ch_name}_rx_trs_locked_fanout.sig_fanout1      ${lb_ch}_loopback.rx_trs_locked
      add_connection  ${lb_ch}_${lb_ch_name}.rx_frame_locked                       ${lb_ch}_${lb_ch_name}_rx_frame_locked_fanout.sig_input
      add_connection  ${lb_ch}_${lb_ch_name}_rx_frame_locked_fanout.sig_fanout1    ${lb_ch}_loopback.rx_frame_locked

      if { $video_std == "tr" | $video_std == "ds" | $video_std == "threeg"} { 
        add_connection  ${lb_ch}_${lb_ch_name}_rx_std_fanout.sig_fanout1           ${lb_ch}_loopback.rx_std
      }

      if { $ch0_vpid_extract } {
        add_connection  ${lb_ch}_${lb_ch_name}.rx_ln                               ${lb_ch}_${lb_ch_name}_rx_ln_fanout.sig_input
        add_connection  ${lb_ch}_${lb_ch_name}_rx_ln_fanout.sig_fanout1            ${lb_ch}_loopback.rx_ln
        add_connection  ${lb_ch}_${lb_ch_name}.rx_vpid_byte1                       ${lb_ch}_${lb_ch_name}_rx_vpid_byte1_fanout.sig_input
        add_connection  ${lb_ch}_${lb_ch_name}_rx_vpid_byte1_fanout.sig_fanout1    ${lb_ch}_loopback.rx_vpid_byte1
        add_connection  ${lb_ch}_${lb_ch_name}.rx_vpid_byte2                       ${lb_ch}_${lb_ch_name}_rx_vpid_byte2_fanout.sig_input
        add_connection  ${lb_ch}_${lb_ch_name}_rx_vpid_byte2_fanout.sig_fanout1    ${lb_ch}_loopback.rx_vpid_byte2
        add_connection  ${lb_ch}_${lb_ch_name}.rx_vpid_byte3                       ${lb_ch}_${lb_ch_name}_rx_vpid_byte3_fanout.sig_input
        add_connection  ${lb_ch}_${lb_ch_name}_rx_vpid_byte3_fanout.sig_fanout1    ${lb_ch}_loopback.rx_vpid_byte3
        add_connection  ${lb_ch}_${lb_ch_name}.rx_vpid_byte4                       ${lb_ch}_${lb_ch_name}_rx_vpid_byte4_fanout.sig_input
        add_connection  ${lb_ch}_${lb_ch_name}_rx_vpid_byte4_fanout.sig_fanout1    ${lb_ch}_loopback.rx_vpid_byte4
        add_connection  ${lb_ch}_${lb_ch_name}.rx_line_f0                          ${lb_ch}_${lb_ch_name}_rx_line_f0_fanout.sig_input
        add_connection  ${lb_ch}_${lb_ch_name}_rx_line_f0_fanout.sig_fanout1       ${lb_ch}_loopback.rx_line_f0
        add_connection  ${lb_ch}_${lb_ch_name}.rx_line_f1                          ${lb_ch}_${lb_ch_name}_rx_line_f1_fanout.sig_input
        add_connection  ${lb_ch}_${lb_ch_name}_rx_line_f1_fanout.sig_fanout1       ${lb_ch}_loopback.rx_line_f1

        if { $video_std == "tr" | $video_std == "dl" | $video_std == "threeg" } {
          add_connection  ${lb_ch}_${lb_ch_name}.rx_ln_b                              ${lb_ch}_${lb_ch_name}_rx_ln_b_fanout.sig_input
          add_connection  ${lb_ch}_${lb_ch_name}_rx_ln_b_fanout.sig_fanout1           ${lb_ch}_loopback.rx_ln_b
          add_connection  ${lb_ch}_${lb_ch_name}.rx_vpid_byte1_b                      ${lb_ch}_${lb_ch_name}_rx_vpid_byte1_b_fanout.sig_input
          add_connection  ${lb_ch}_${lb_ch_name}_rx_vpid_byte1_b_fanout.sig_fanout1   ${lb_ch}_loopback.rx_vpid_byte1_b
          add_connection  ${lb_ch}_${lb_ch_name}.rx_vpid_byte2_b                      ${lb_ch}_${lb_ch_name}_rx_vpid_byte2_b_fanout.sig_input
          add_connection  ${lb_ch}_${lb_ch_name}_rx_vpid_byte2_b_fanout.sig_fanout1   ${lb_ch}_loopback.rx_vpid_byte2_b
          add_connection  ${lb_ch}_${lb_ch_name}.rx_vpid_byte3_b                      ${lb_ch}_${lb_ch_name}_rx_vpid_byte3_b_fanout.sig_input
          add_connection  ${lb_ch}_${lb_ch_name}_rx_vpid_byte3_b_fanout.sig_fanout1   ${lb_ch}_loopback.rx_vpid_byte3_b
          add_connection  ${lb_ch}_${lb_ch_name}.rx_vpid_byte4_b                      ${lb_ch}_${lb_ch_name}_rx_vpid_byte4_b_fanout.sig_input
          add_connection  ${lb_ch}_${lb_ch_name}_rx_vpid_byte4_b_fanout.sig_fanout1   ${lb_ch}_loopback.rx_vpid_byte4_b
        }
      }

      #if { $trs_misc } {
      #  add_connection  ${lb_ch}_${lb_ch_name}.rx_trs  ${lb_ch}_loopback.rx_trs
      #  add_connection  ${lb_ch}_loopback.tx_trs       ${lb_ch}_${lb_ch_name}.tx_trs
      #}

      ## Drive unnecessary tx_trs port to tx_data[20]
      add_connection    ${lb_ch}_loopback.tx_trs         ${lb_ch}_${lb_ch_name}.tx_trs
      if { $video_std == "dl" } {
        add_connection  ${lb_ch}_loopback.tx_trs_b       ${lb_ch}_${lb_ch_name}.tx_trs_b
      }

      add_connection  ${lb_ch}_${lb_ch_name}.tx_dataout_valid  ${lb_ch}_loopback.tx_data_valid
      add_connection  ${lb_ch}_loopback.tx_data                ${lb_ch}_${lb_ch_name}.tx_datain
      add_connection  ${lb_ch}_loopback.tx_data_valid_out      ${lb_ch}_${lb_ch_name}.tx_datain_valid
      add_connection  ${lb_ch}_${lb_ch_name}.pll_powerdown_out ${lb_ch}_${lb_ch_name}.pll_powerdown_in

      if { $video_std != "sd" } {
        #Drive unnecessary enable_crc and enable_ln ports to GND
        add_connection  ${lb_ch}_loopback.tx_enable_crc        ${lb_ch}_${lb_ch_name}.tx_enable_crc
        add_connection  ${lb_ch}_loopback.tx_enable_ln         ${lb_ch}_${lb_ch_name}.tx_enable_ln

        #Drive unnecessary tx_ln port to GND
        add_connection  ${lb_ch}_loopback.tx_ln                ${lb_ch}_${lb_ch_name}.tx_ln
      }

      if { $video_std == "tr" | $video_std == "ds" | $video_std == "threeg" } {
        add_connection  ${lb_ch}_loopback.tx_std   ${lb_ch}_${lb_ch_name}.tx_std
      }

      if { $video_std == "tr" | $video_std == "dl" | $video_std == "threeg" } {      
        #Drive unnecessary tx_ln_b port to GND
        add_connection  ${lb_ch}_loopback.tx_ln_b   ${lb_ch}_${lb_ch_name}.tx_ln_b 
      }        

      if { $video_std == "dl" } {
        add_connection  ${lb_ch}_${lb_ch_name}.rx_dataout_b                            ${lb_ch}_${lb_ch_name}_rx_dataout_b_fanout.sig_input
        add_connection  ${lb_ch}_${lb_ch_name}_rx_dataout_b_fanout.sig_fanout1         ${lb_ch}_loopback.rx_data_b
        add_connection  ${lb_ch}_${lb_ch_name}.rx_dataout_valid_b                      ${lb_ch}_${lb_ch_name}_rx_dataout_valid_b_fanout.sig_input
        add_connection  ${lb_ch}_${lb_ch_name}_rx_dataout_valid_b_fanout.sig_fanout1   ${lb_ch}_loopback.rx_data_valid_b
        add_connection  ${lb_ch}_${lb_ch_name}.tx_dataout_valid_b                      ${lb_ch}_loopback.tx_data_valid_b
        add_connection  ${lb_ch}_loopback.tx_data_b                                    ${lb_ch}_${lb_ch_name}.tx_datain_b
        add_connection  ${lb_ch}_loopback.tx_data_valid_out_b                          ${lb_ch}_${lb_ch_name}.tx_datain_valid_b
      } 

     if { $ch0_vpid_insert} {
       #add_connection  ${lb_ch}_loopback.tx_enable_vpid_c  ${lb_ch}_${lb_ch_name}.tx_enable_vpid_c
       add_connection  ${lb_ch}_loopback.tx_vpid_overwrite     ${lb_ch}_${lb_ch_name}.tx_vpid_overwrite
       add_connection  ${lb_ch}_loopback.tx_vpid_byte1         ${lb_ch}_${lb_ch_name}.tx_vpid_byte1
       add_connection  ${lb_ch}_loopback.tx_vpid_byte2         ${lb_ch}_${lb_ch_name}.tx_vpid_byte2
       add_connection  ${lb_ch}_loopback.tx_vpid_byte3         ${lb_ch}_${lb_ch_name}.tx_vpid_byte3
       add_connection  ${lb_ch}_loopback.tx_vpid_byte4         ${lb_ch}_${lb_ch_name}.tx_vpid_byte4
       add_connection  ${lb_ch}_loopback.tx_line_f0            ${lb_ch}_${lb_ch_name}.tx_line_f0
       add_connection  ${lb_ch}_loopback.tx_line_f1            ${lb_ch}_${lb_ch_name}.tx_line_f1    
       if { $video_std == "tr" | $video_std == "dl" | $video_std == "threeg" } {
         add_connection  ${lb_ch}_loopback.tx_vpid_byte1_b     ${lb_ch}_${lb_ch_name}.tx_vpid_byte1_b
         add_connection  ${lb_ch}_loopback.tx_vpid_byte2_b     ${lb_ch}_${lb_ch_name}.tx_vpid_byte2_b
         add_connection  ${lb_ch}_loopback.tx_vpid_byte3_b     ${lb_ch}_${lb_ch_name}.tx_vpid_byte3_b
         add_connection  ${lb_ch}_loopback.tx_vpid_byte4_b     ${lb_ch}_${lb_ch_name}.tx_vpid_byte4_b
       }
     }
    
    ########################################################################################  

    ########################################################################################
    #
    # Pattgen Connections
    #
    ########################################################################################

    # Pattgen reset connection
    if { $dir == "du" } {
      add_connection  ${ch}_du_tx_rst_bridge.out_reset  pattgen.rst
    } else {
      add_connection  ${ch}_tx_rst_bridge.out_reset     pattgen.rst
    }

    # Pattgen - export
    add_export_rename_interface  pattgen bar_100_75n  conduit  input 
    #add_export_rename_interface  pattgen enable       conduit  input
    add_export_rename_interface  pattgen patho        conduit  input
    add_export_rename_interface  pattgen blank        conduit  input
    add_export_rename_interface  pattgen no_color     conduit  input
    add_export_rename_interface  pattgen sgmt_frame   conduit  input
    add_export_rename_interface  pattgen tx_std       conduit  input
    add_export_rename_interface  pattgen tx_format    conduit  input
    add_export_rename_interface  pattgen dl_mapping   conduit  input
    add_export_rename_interface  pattgen ntsc_paln    conduit  input

    if { $insert_vpid } {
      add_export_fanout_rename_interface     pattgen   line_f0        conduit   input
      add_export_fanout_rename_interface     pattgen   line_f1        conduit   input
    }

    if { $dl_sync | $trs_test | $frame_test } {
      add_export_rename_interface            pattgen   dout           conduit   output
      add_export_rename_interface            pattgen   dout_valid     conduit   output

      if { $video_std == "dl"} {
        add_export_rename_interface          pattgen   dout_b         conduit   output
        add_export_rename_interface          pattgen   dout_valid_b   conduit   output
      }
    } elseif { $cmp_data } {
      add_export_fanout_rename_interface     pattgen   dout           conduit   output
      add_export_fanout_rename_interface     pattgen   dout_valid     conduit   output

      if { $video_std == "dl"} {
        add_export_fanout_rename_interface   pattgen   dout_b         conduit   output
        add_export_fanout_rename_interface   pattgen   dout_valid_b   conduit   output
      }
    }

    if { $dl_sync | $trs_test | $frame_test} {
      add_export_rename_interface            pattgen   trs            conduit  output
      
      if { $video_std == "dl"} {
        add_export_rename_interface          pattgen   trs_b          conduit  output
      }
    }
    ########################################################################################
    
    ########################################################################################
    #
    # Reconfig clock/reset connection
    #
    ########################################################################################
    add_connection  reconfig_clk_bridge.out_clk        u_reconfig.mgmt_clk_clk
    add_connection  reconfig_rst_bridge.out_reset      u_reconfig.mgmt_rst_reset        
    #add_connection  reconfig_clk_bridge.out_clk       reconfig_rst_bridge.clk
    add_connection  ${lb_ch}_du_xcvr_refclk_bridge.out_clk  reconfig_rst_bridge.clk ;# assign to different clock so that reset synchronizer will be added

    add_connection  reconfig_clk_bridge.out_clk     u_reconfig_mgmt.reconfig_clk
    add_connection  reconfig_rst_bridge.out_reset   u_reconfig_mgmt.rst
    ########################################################################################
}
