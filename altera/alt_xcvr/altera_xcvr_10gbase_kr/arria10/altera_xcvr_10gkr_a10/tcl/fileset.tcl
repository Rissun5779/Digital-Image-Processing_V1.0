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



package provide altera_xcvr_10gkr_a10::fileset 18.1

package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::device
package require alt_xcvr::ip_tcl::ip_module
package require altera_xcvr_native_sv::fileset

namespace eval ::altera_xcvr_10gkr_a10::fileset:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::utils::fileset::*

  namespace export \
    declare_filesets \
    declare_files


  variable filesets

  set filesets {\
    { NAME            TYPE            CALLBACK                                                 TOP_LEVEL             }\
    { quartus_synth   QUARTUS_SYNTH   ::altera_xcvr_10gkr_a10::fileset::callback_quartus_synth altera_xcvr_10gkr_a10 }\
    { sim_verilog     SIM_VERILOG     ::altera_xcvr_10gkr_a10::fileset::callback_sim_verilog   altera_xcvr_10gkr_a10 }\
    { sim_vhdl        SIM_VHDL        ::altera_xcvr_10gkr_a10::fileset::callback_sim_vhdl      altera_xcvr_10gkr_a10 }\
  }

}

proc ::altera_xcvr_10gkr_a10::fileset::declare_filesets { } {
  variable filesets
  
#  generate_native_phy 
  declare_files
  ip_declare_filesets $filesets
}


proc ::altera_xcvr_10gkr_a10::fileset::generate_native_phy  {} {
   
  set ref_clk_10g [get_parameter_value REF_CLK_FREQ_10G]
  set ini_dpath   [get_parameter_value INI_DATAPATH]
  set synth_1588  [expr [get_parameter_value SYNTH_1588_ALL] == 1] 
  set synth_fec   [expr [get_parameter_value SYNTH_FEC] == 1]
  set synth_lt    [expr [get_parameter_value SYNTH_LT ] == 1]
  set synth_an    [expr [get_parameter_value SYNTH_AN ] == 1]
  set debug_cpu   [expr [get_parameter_value USE_DEBUG_CPU] == 1]
  set ecc_cpu     [expr [get_parameter_value USE_ECC_CPU] == 1]
  set hard_prbs   [get_parameter_value HARD_PRBS_ENABLE]
  set es_device   [get_parameter_value ES_DEVICE]
  # Instead of having indidual add_hdl_instace call for every Native PHY variation, use single add_hdl_instance call
  # To do this, correct parameters need to be passed depending upon variation
  # Various Native PHY param,value lists are set according to various GUI params i.e. ref_clk, fec, 1588 etc
  # These param, value lists are appended to common param,value list
  # Also set unique name to native_phy call for each variation
  if {$hard_prbs} {
    set prbs      "hp"
    set list_prbs "set_embedded_debug_enable 1 set_prbs_soft_logic_enable 1 set_capability_reg_enable 1"
  } else {
    set list_prbs ""
    set prbs      ""
  }

  if {$ref_clk_10g == "322.265625"} {
   set freq "_322"
  } elseif {$ref_clk_10g == "644.53125"} {
   set freq "_644"   
  } else {
   set freq "_312"   
  }

  if {$synth_fec} {
  set fec "_fec"	 
  } else {
  set fec ""	  
  }	  

  if {$synth_1588} {
  set ptp "_1588"	  
  } else {
  set ptp ""	  
  }

  if { $synth_lt | $synth_an } {
  #Kr mode	  
  set ls "" 
  } else {
  #lineside mode
  set ls "_ls"
  }	  
  # Do add_hdl_instance on qsys file instead of passing parameters to add_hdl_instance command
  # These QSYS files are pre-generated and are in the build
  # Need to pass auto_device so that we override the device of pre-generated qsys system
 if {$ini_dpath == "10G"} {  
  set native_name native_10g$fec$ptp$prbs$freq$ls
 } else {
     if {$synth_1588} {
       set native_name native_gige_1588
     } else { 
       set native_name native_gige
     }
 }

  add_hdl_instance $native_name  $native_name
  set_instance_parameter_value $native_name auto_device [get_parameter_value "device"]

 
    set prod_cpu_ip kra10_cpu_gen2
    set debg_cpu_ip kra10_debug_cpu_gen2
  
  set QROOT "$::env(QUARTUS_ROOTDIR)"
  if {$es_device} {
    set ES_HEX "_es"
  } else {
    set ES_HEX ""
  }	 
# this is the qsys NIOS
 if {$synth_lt} {
   if       { [expr  $debug_cpu & !$ecc_cpu] } {
    add_hdl_instance  kra10_debug_cpu  $debg_cpu_ip
    set_instance_parameter_value kra10_debug_cpu imem_hex_path "$QROOT/../ip/altera/alt_xcvr/altera_xcvr_10gbase_kr/arria10/cpu/kra10_debug_cpu_imem$ES_HEX.hex"
    set_instance_parameter_value kra10_debug_cpu dmem_hex_path "$QROOT/../ip/altera/alt_xcvr/altera_xcvr_10gbase_kr/arria10/cpu/kra10_debug_cpu_dmem$ES_HEX.hex"
    } elseif { [expr  $debug_cpu &  $ecc_cpu] } {   
    add_hdl_instance  kr_dbg_ecc_cpu  kr_dbg_ecc_cpu
    set_instance_parameter_value kr_dbg_ecc_cpu imem_hex_path "$QROOT/../ip/altera/alt_xcvr/altera_xcvr_10gbase_kr/arria10/cpu/kr_dbg_ecc_cpu_imem$ES_HEX.hex"
    set_instance_parameter_value kr_dbg_ecc_cpu dmem_hex_path "$QROOT/../ip/altera/alt_xcvr/altera_xcvr_10gbase_kr/arria10/cpu/kr_dbg_ecc_cpu_dmem$ES_HEX.hex"
   } elseif { [expr !$debug_cpu &  $ecc_cpu] } {
    add_hdl_instance  kr_ecc_cpu  kr_ecc_cpu
    set_instance_parameter_value kr_ecc_cpu imem_hex_path "$QROOT/../ip/altera/alt_xcvr/altera_xcvr_10gbase_kr/arria10/cpu/kr_ecc_cpu_imem$ES_HEX.hex"
    set_instance_parameter_value kr_ecc_cpu dmem_hex_path "$QROOT/../ip/altera/alt_xcvr/altera_xcvr_10gbase_kr/arria10/cpu/kr_ecc_cpu_dmem$ES_HEX.hex"    
   } else {    
    add_hdl_instance  kra10_cpu  $prod_cpu_ip
    set_instance_parameter_value kra10_cpu imem_hex_path "$QROOT/../ip/altera/alt_xcvr/altera_xcvr_10gbase_kr/arria10/cpu/kra10_cpu_imem$ES_HEX.hex"
    set_instance_parameter_value kra10_cpu dmem_hex_path "$QROOT/../ip/altera/alt_xcvr/altera_xcvr_10gbase_kr/arria10/cpu/kra10_cpu_dmem$ES_HEX.hex"
   }	   
 }



}


proc ::altera_xcvr_10gkr_a10::fileset::declare_files {} {
  # Native PHY files
 # ::altera_xcvr_native_sv::fileset::declare_files

  # Common PHY IP files
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path [::alt_xcvr::utils::fileset::get_altera_xcvr_generic_path]]


  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ ${path} {
    altera_xcvr_functions.sv
  } {ALTERA_XCVR_10GBASE_KR}

  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "${path}/ctrl/" {
    alt_xcvr_csr_common_h.sv
    alt_xcvr_csr_common.sv
    alt_xcvr_csr_selector.sv
    alt_xcvr_resync.sv
    altera_wait_generate.v
  } {ALTERA_XCVR_10GBASE_KR}

  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "${path}/sv/" {
    sv_xcvr_data_adapter.sv
  } {ALTERA_XCVR_10GBASE_KR}

  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "${path}/../altera_10gbaser_phy/siv/" {
    csr_pcs10gbaser_h.sv
    csr_pcs10gbaser.sv
  } {ALTERA_XCVR_10GBASE_KR}


   
    
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "${path}/../primitives/altera_std_synchronizer/" {
    altera_std_synchronizer_nocut.v
  } {ALTERA_XCVR_10GBASE_KR}
  
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "${path}/../avalon_st/altera_avalon_st_handshake_clock_crosser/" {
    altera_avalon_st_handshake_clock_crosser.v
    altera_avalon_st_clock_crosser.v
  } {ALTERA_XCVR_10GBASE_KR}
  
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "${path}/../avalon_st/altera_avalon_st_pipeline_stage/" {
    altera_avalon_st_pipeline_stage.sv
    altera_avalon_st_pipeline_base.v
  } {ALTERA_XCVR_10GBASE_KR}

  # altera_xcvr_10gbase_kr files
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_10gbase_kr/common_src/"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]

  # Declare unencrypted common KR files
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ $path {
    csr_krtop_h.sv
    csr_kran.sv
    csr_krgige.sv
    csr_krfec.sv
  } {ALTERA_XCVR_10GBASE_KR}

  # Declare KR TOP file
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "$path/../arria10/altera_xcvr_10gkr_a10/" {
    altera_xcvr_10gkr_a10.sv
  } {ALTERA_XCVR_10GBASE_KR}
  
  # Declare KR TOP SDC file
  ::alt_xcvr::utils::fileset::common_fileset_group ./ "$path/../arria10/altera_xcvr_10gkr_a10/" SDC {
    altera_xcvr_10gkr_a10.sdc
  } {ALTERA_XCVR_10GBASE_KR} {QIP}
	
  # Declare Reconfiguration files
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "$path/../arria10/reconfig/" {
    rcfg_avmm_mstr.sv
    rcfg_data_1588_644.sv
    rcfg_data_1588_322.sv
    rcfg_data_1588_312.sv
    rcfg_data_644.sv
    rcfg_data_322.sv
    rcfg_data_fec_644.sv
    rcfg_data_fec_322.sv
    rcfg_data_fec1588_644.sv
    rcfg_data_fec1588_322.sv
    rcfg_revd_data_1588_644.sv
    rcfg_revd_data_1588_322.sv
    rcfg_revd_data_1588_312.sv
    rcfg_revd_data_644.sv
    rcfg_revd_data_322.sv
    rcfg_revd_data_fec_644.sv
    rcfg_revd_data_fec_322.sv
    rcfg_pcs_ctrl.sv
    rcfg_top.sv
    rcfg_txeq_ctrl.sv
  } {ALTERA_XCVR_10GBASE_KR}

  # Declare Arria 10 sequencer and other clear-text files
  ::alt_xcvr::utils::fileset::common_fileset_group_plain ./ "$path/../arria10/common_src/" {
    csr_kra10top.sv
    csr_kra10lt.sv
    seqa10_sm.sv
    ultra_chnl.sv
  } {ALTERA_XCVR_10GBASE_KR}

}

  ## Add STP support
proc ::altera_xcvr_10gkr_a10::fileset::callback_add_stp_files {} {
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_10gbase_kr/arria10/altera_xcvr_10gkr_a10"
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path $path]
  add_fileset_file debug/stp/base_stp_A101G10GKR.xml OTHER PATH $path/base_stp_A101G10GKR.txt
  add_fileset_file debug/stp/build_stp.tcl OTHER PATH $path/build_stp.tcl
  set synth_lt    [expr [get_parameter_value SYNTH_LT ] == 1]
}

  ## Add optional encrypted files 
  ## OCP isnt supported properly if all generated files aren't synthesized
proc ::altera_xcvr_10gkr_a10::fileset::callback_optional_files { } {
  set synth_lt    [expr [get_parameter_value SYNTH_LT ]   == 1]
  set synth_an    [expr [get_parameter_value SYNTH_AN ]   == 1]
  set synth_gige  [expr [get_parameter_value SYNTH_GIGE ] == 1]
  set synth_1588  [expr [get_parameter_value SYNTH_1588_ALL ] == 1]

 
 
  set path [::alt_xcvr::utils::fileset::abs_to_rel_path [::alt_xcvr::utils::fileset::get_altera_xcvr_generic_path]]
# Add 1588 files   
  if {$synth_1588} {
      ::alt_xcvr::utils::fileset::common_fileset_group_encrypted ./ "${path}/../altera_10gbaser_phy/soft_pcs/" {
        altera_10gbaser_phy_params.sv
        altera_10gbaser_phy_clockcomp.sv
        altera_10gbaser_phy_1588_latency.sv
        altera_10gbaser_phy_rx_fifo_wrap.v
        altera_10gbaser_phy_clock_crosser.v 
        altera_10gbaser_phy_pipeline_stage.sv
        altera_10gbaser_phy_pipeline_base.v
      } {ALTERA_XCVR_10GBASE_KR}

      # 10G 1588 files without embedded SDCs
      ::alt_xcvr::utils::fileset::common_fileset_group_encrypted ./ "${path}/../altera_10gbaser_phy/sv_soft_pcs/" {
        altera_10gbaser_phy_async_fifo.sv
        altera_10gbaser_phy_async_fifo_fpga.sv
        altera_10gbaser_phy_rx_fifo.v
      } {ALTERA_XCVR_10GBASE_KR}
      # 10G 1588 SDC
      ::alt_xcvr::utils::fileset::common_fileset_group ./ "${path}/../altera_10gbaser_phy/sv_soft_pcs/" SDC {
        alt_10gbaser_phy.sdc
      } {ALTERA_XCVR_10GBASE_KR} {QIP}
      # Add 1588 OCP files
      ::alt_xcvr::utils::fileset::common_fileset_group ./ "${path}/../altera_10gbaser_phy/sv_soft_pcs/"  OTHER {
        altera_10gbaser_phy_clockcomp.ocp
        altera_10gbaser_phy_rx_fifo_wrap.ocp
      } {ALTERA_XCVR_10GBASE_KR} {PLAIN}
	
   
 
  }	  
  set path [::alt_xcvr::utils::fileset::get_alt_xcvr_path]
  set path "${path}/altera_xcvr_10gbase_kr/"
# Add GIGE files   
  if {$synth_gige} {
      ::alt_xcvr::utils::fileset::common_fileset_group_encrypted ./ $path/gige_pcs {
        kr_gige_pcs_a_fifo_24.v
        kr_gige_pcs_carrier_sense.v
        kr_gige_pcs_colision_detect.v
        kr_gige_pcs_gray_cnt.v
        kr_gige_pcs_gxb_aligned_rxsync.v
        kr_gige_pcs_mdio_reg.v
        kr_gige_pcs_mii_rx_if_pcs.v
        kr_gige_pcs_mii_tx_if_pcs.v
        kr_gige_pcs_pcs_control.v
        kr_gige_pcs_pcs_host_control.v
        kr_gige_pcs_reset_synchronizer.v
        kr_gige_pcs_rx_converter.v
        kr_gige_pcs_rx_encapsulation_strx_gx.v
        kr_gige_pcs_rx_fifo_rd.v
        kr_gige_pcs_sdpm_altsyncram.v
        kr_gige_pcs_sgmii_clk_enable.v
        kr_gige_pcs_top.sv
        kr_gige_pcs_clock_crosser.v
        kr_gige_pcs_ph_calculator.sv
        kr_gige_pcs_top_1000_base_x_strx_gx.v
        kr_gige_pcs_top_autoneg.v
        kr_gige_pcs_top_pcs_strx_gx.v
        kr_gige_pcs_top_rx_converter.v
        kr_gige_pcs_top_sgmii_strx_gx.v
        kr_gige_pcs_top_tx_converter.v
        kr_gige_pcs_tx_converter.v
        kr_gige_pcs_tx_encapsulation.v
        kr_gige_pcs_std_synchronizer.v
        kr_gige_pcs_std_synchronizer_bundle.v
    } {ALTERA_XCVR_10GBASE_KR}
    # Add OCP files
    ::alt_xcvr::utils::fileset::common_fileset_group ./ $path/gige_pcs OTHER {
      kr_gige_pcs_top.ocp
    } {ALTERA_XCVR_10GBASE_KR} {PLAIN}
    # Add SDC files
    ::alt_xcvr::utils::fileset::common_fileset_group ./ $path/gige_pcs SDC {
      kr_gige_pcs.sdc
    } {ALTERA_XCVR_10GBASE_KR} {QIP}
  }	  
# Add LT files   
  if {$synth_lt} {
      ::alt_xcvr::utils::fileset::common_fileset_group_encrypted ./ $path/common_src {
        lt32_cf_update.sv
        lt32_frame_lock.sv
        lt32_rx_data.sv
        lt32_tx_data.sv
        lt32_tx_train.sv
      } {ALTERA_XCVR_10GBASE_KR}

      ::alt_xcvr::utils::fileset::common_fileset_group_encrypted ./ $path/arria10/common_src {
       lta10_ultra_top.sv
       lta10_lcl_coef.sv
      } {ALTERA_XCVR_10GBASE_KR}

      ::alt_xcvr::utils::fileset::common_fileset_group ./ "$path/arria10/common_src/" OTHER {
        lta10_ultra_top.ocp
      } {ALTERA_XCVR_10GBASE_KR} {PLAIN}
	
  }	  
# Add AN/LT files   
  if { $synth_lt | $synth_an } {
      ::alt_xcvr::utils::fileset::common_fileset_group_encrypted ./ $path/common_src {
        six_two_comp.sv
      } {ALTERA_XCVR_10GBASE_KR}
  }	  
# Add AN files
  if {$synth_an } {
      ::alt_xcvr::utils::fileset::common_fileset_group_encrypted ./ $path/common_src {
        an_arb_sm.sv
        an_decode.sv
        an_rx_sm.sv
        an_top.sv
        an_tx_sm.sv
      } {ALTERA_XCVR_10GBASE_KR}

      ::alt_xcvr::utils::fileset::common_fileset_group ./ $path/common_src OTHER {
        an_top.ocp
      } {ALTERA_XCVR_10GBASE_KR} {PLAIN}
  }	  
}

proc ::altera_xcvr_10gkr_a10::fileset::callback_quartus_synth {name} {
  callback_optional_files
  common_add_fileset_files {ALTERA_XCVR_10GBASE_KR} {PLAIN QIP QENCRYPT}
  callback_add_stp_files
}

proc ::altera_xcvr_10gkr_a10::fileset::callback_sim_verilog {name} {
  callback_optional_files
  common_add_fileset_files {ALTERA_XCVR_10GBASE_KR} [concat PLAIN [common_fileset_tags_all_simulators]]
}

proc ::altera_xcvr_10gkr_a10::fileset::callback_sim_vhdl {name} {
  callback_optional_files
  common_add_fileset_files {ALTERA_XCVR_10GBASE_KR} [concat PLAIN [common_fileset_tags_all_simulators]]
}

