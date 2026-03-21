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


package provide altera_xcvr_native_s10::interfaces 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages
package require altera_xcvr_native_s10::interfaces::data

namespace eval ::altera_xcvr_native_s10::interfaces:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    declare_interfaces \
    elaborate \
    map_tx_parallel_data \
    map_rx_parallel_data

  variable interfaces
  variable TX_DATA_WIDTH
  variable RX_DATA_WIDTH

  set interfaces [altera_xcvr_native_s10::interfaces::data::get_variable "interfaces"]
  set TX_DATA_WIDTH 80
  set RX_DATA_WIDTH 80
}


proc ::altera_xcvr_native_s10::interfaces::declare_interfaces {} {
  variable interfaces
  # We want our interfaces declared as conduits in native mode
  ip_set_auto_conduit_in_native_mode 1
  ip_set_iface_split_suffix "_ch"
  ip_declare_interfaces $interfaces
}


proc ::altera_xcvr_native_s10::interfaces::elaborate {} {
  ip_elaborate_interfaces
}


###############################################################################
########################## TX parallel data elaboration #######################
proc ::altera_xcvr_native_s10::interfaces::generate_bit_indexes { field_list width offset } {
	set bit_indexes {}
	foreach field $field_list {
		set lsb [expr $field + $offset]
		if {$width > 1} {
			set msb [expr $lsb + $width - 1]
			lappend bit_indexes "${msb}:${lsb}"
		} else {
			lappend bit_indexes $lsb
		}
	}	
	return $bit_indexes
}

proc ::altera_xcvr_native_s10::interfaces::lcl_create_fragmented_interface { condition pname src_port direction channels total_width group_width words width offset { used "used" } { add_offset 0 } { role default } } {
	set unused_list {}
	if {$used == "used"} {
		create_fragmented_interface $condition $pname $src_port $direction $channels $total_width $group_width $words $width $offset "used" $add_offset $role 1	
	} else {
		set unused_list [create_expanded_index_list $channels $total_width $group_width $words $width $offset "unused"]				
	}
	return $unused_list
}

proc ::altera_xcvr_native_s10::interfaces::lcl_create_fragmented_interface_from_list { condition pname src_port direction channels total_width bit_indexes words width { used "used" } { add_offset 0 } { role default } } {	
	set unused_list {}
	if {$used == "used"} {
		create_fragmented_interface_from_list $condition $pname $src_port $direction $channels $total_width $bit_indexes $words $width "used" $add_offset $role		
	} else {
		set unused_list [create_expanded_index_list_from_list $channels $total_width $bit_indexes "unused"]		
	}
	return $unused_list
 }

proc ::altera_xcvr_native_s10::interfaces::map_tx_parallel_data { l_crete_nf rcfg_iface_enable datapath_select l_enable_tx_std l_enable_tx_enh \
    l_enable_tx_pcs_dir l_enable_std_pipe protocol_mode l_std_tx_word_width l_std_tx_word_count l_std_tx_field_width \
    enable_simple_interface l_channels tx_fifo_mode std_tx_8b10b_enable std_tx_8b10b_disp_ctrl_enable \
	enable_qpi_mode enable_qpi_async_transfer enh_pcs_pma_width enh_pld_pcs_width pcs_direct_width used {sfx ""} {add_offset 0} } {

	variable TX_DATA_WIDTH
	set unused_list_col {}

	# modify values of "l_enable_tx_std" "l_enable_tx_enh" "l_enable_tx_pcs_dir" based on rcfg_iface_enable --> datapath and interface reconfiguration
	set l_enable_tx_std       [expr {$rcfg_iface_enable ? ( $datapath_select == "Standard"   && $l_enable_tx_std     ) : $l_enable_tx_std}]
	set l_enable_tx_enh       [expr {$rcfg_iface_enable ? ( $datapath_select == "Enhanced"   && $l_enable_tx_enh     ) : $l_enable_tx_enh}]
	set l_enable_tx_pcs_dir   [expr {$rcfg_iface_enable ? ( $datapath_select == "PCS Direct" && $l_enable_tx_pcs_dir ) : $l_enable_tx_pcs_dir}]

	if {$l_enable_tx_std} {
		set std_tx_fields [expr { ($protocol_mode == "pipe_g3") ? {49 40 11 0} : {51 40 11 0} }]
		# Standard PCS datapath		
		if {$l_std_tx_word_count == 4} {		
			set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_tx_fields $l_std_tx_word_width 0]		
			lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "tx_parallel_data${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $bit_indexes $l_std_tx_word_count $l_std_tx_word_width $used $add_offset "tx_parallel_data"]
		} else {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_parallel_data${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $l_std_tx_field_width $l_std_tx_word_count $l_std_tx_word_width 0 $used $add_offset "tx_parallel_data" ]
		}
    
		# tx_datak
		if {$std_tx_8b10b_enable} {
			if {$l_std_tx_word_count == 4} {
				set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_tx_fields 1 8]			
				lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "tx_datak${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $bit_indexes $l_std_tx_word_count 1 $used $add_offset "tx_datak"]
			} else {
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_datak${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $l_std_tx_field_width $l_std_tx_word_count 1 8 $used $add_offset "tx_datak" ]
			}
		}
	    
		if {!$l_enable_std_pipe && $std_tx_8b10b_enable && $std_tx_8b10b_disp_ctrl_enable} {
		  # tx_forcedisp
		  if {$l_std_tx_word_count == 4} {
				set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_tx_fields 1 9]			
				lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "tx_forcedisp${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $bit_indexes $l_std_tx_word_count 1 $used $add_offset "tx_forcedisp"]
		  } 
		  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_forcedisp${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $l_std_tx_field_width $l_std_tx_word_count 1 9 $used $add_offset "tx_forcedisp" ]

		  # tx_dispval
		  if {$l_std_tx_word_count == 4} {
				set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_tx_fields 1 10]			
				lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "tx_dispval${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $bit_indexes $l_std_tx_word_count 1 $used $add_offset "tx_dispval"]
		  } 
		  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_dispval${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $l_std_tx_field_width $l_std_tx_word_count 1 10 $used $add_offset "tx_dispval" ]
		}

		if {$l_enable_std_pipe} {
		  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_tx_compliance${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 9 $used $add_offset "pipe_tx_compliance" ]
		  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_tx_elecidle${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 10 $used $add_offset "pipe_tx_elecidle" ]
		  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_tx_detectrx_loopback${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 20 $used $add_offset "pipe_tx_detectrx_loopback" ]
		  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_powerdown${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 2 21 $used $add_offset "pipe_powerdown" ]
		  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_tx_margin${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 3 23 $used $add_offset "pipe_tx_margin" ]
		  if {$protocol_mode == "pipe_g2"} {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_tx_deemph${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 26 $used $add_offset "pipe_tx_deemph" ]
		  }
		  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_tx_swing${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 27 $used $add_offset "pipe_tx_swing" ]
		  if {$protocol_mode == "pipe_g3"} {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_tx_sync_hdr${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 2 28 $used $add_offset "pipe_tx_sync_hdr" ]
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_tx_blk_start${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 30 $used $add_offset "pipe_tx_blk_start" ]
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_tx_data_valid${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 31 $used $add_offset "pipe_tx_data_valid" ]
		  }
		  if {$protocol_mode == "pipe_g2" || $protocol_mode == "pipe_g3"} {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_rate${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 2 32 $used $add_offset "pipe_rate" ]
		  }
		  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_rx_polarity${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 34 $used $add_offset "pipe_rx_polarity" ]
	  
		  if {$protocol_mode == "pipe_g3"} {	
			if {!$l_crete_nf} {	
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_eq_eval${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 35 $used $add_offset "pipe_eq_eval" ]
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_eq_inprogress${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 36 $used $add_offset "pipe_eq_inprogress" ]
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_eq_invalidreq${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 37 $used $add_offset "pipe_eq_invalidreq" ]
			}
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_g3_rxpresethint${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 3 58 $used $add_offset "pipe_g3_rxpresethint" ]
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_g3_txdeemph${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 18 61 $used $add_offset "pipe_g3_txdeemph" ]
		  }
		}
	} elseif {$l_enable_tx_enh} {
		# Enhanced PCS datapath    
		if { $enh_pld_pcs_width >= 64 } {
		  set bit_indexes {71:40 31:0}
		  lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "tx_parallel_data${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $bit_indexes 1 64 $used $add_offset "tx_parallel_data"]
		} else {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_parallel_data${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 $enh_pld_pcs_width 0 $used $add_offset "tx_parallel_data" ]
		}

		# TX Control
		if {$enh_pld_pcs_width > 64} {
			if {$protocol_mode == "teng_baser_mode" || $protocol_mode == "teng_1588_mode" || $protocol_mode == "teng_baser_krfec_mode" || $protocol_mode == "teng_1588_krfec_mode"} {
			  set bit_indexes {75:72 35:32}
			  lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "tx_control${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $bit_indexes 1 8 $used $add_offset "tx_control"]
			} else {
			  set width [expr {$enh_pld_pcs_width - 64}]
			  lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_control${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 $width 32 $used $add_offset "tx_control" ]
			}
		
			#tx_err_ins
			if {($protocol_mode == "teng_baser_mode"  || $protocol_mode == "teng_1588_mode" || $protocol_mode == "teng_baser_krfec_mode" || $protocol_mode == "teng_1588_krfec_mode" || $protocol_mode == "interlaken_mode")} {
			   lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_err_ins${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 76 $used $add_offset "tx_err_ins" ]
			}
		} 
		
		# TX GB data valid
		if {$enh_pld_pcs_width >= 64 && ($enh_pcs_pma_width != $enh_pld_pcs_width) } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_enh_data_valid${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 36 $used $add_offset "tx_enh_data_valid" ]
		} 
	} elseif {$l_enable_tx_pcs_dir} {
		# PCS Direct datapath
		if { $pcs_direct_width < 64 } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_parallel_data${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 $pcs_direct_width 0 $used $add_offset "tx_parallel_data"]
		} else {
			set bit_indexes {71:40 31:0}
			lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "tx_parallel_data${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $bit_indexes 1 64 $used $add_offset "tx_parallel_data"]
		}
	}
  
	# TX FIFO write enable
	if {$tx_fifo_mode == "Interlaken" || $tx_fifo_mode == "Basic"} {
		lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_fifo_wr_en${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 79 $used $add_offset "tx_fifo_wr_en" ]
	}
  
	# QPI signals
	if {$enable_qpi_mode && !$enable_qpi_async_transfer} {	
		set rx_pma_qpipulldn_idx -1
		set tx_pma_qpipulldn_idx -1
		set tx_pma_qpipullup_idx -1
	
		if {$l_enable_tx_std} {
			set rx_pma_qpipulldn_idx 36
			set tx_pma_qpipulldn_idx 37
			set tx_pma_qpipullup_idx 38
		} elseif {$l_enable_tx_enh} {
			if {$enh_pld_pcs_width == 40} {
				ip_message error "Synchronous transfer of QPI signals is not supported when FPGA fabric / Enhanced PCS Interface width is $enh_pld_pcs_width."
			} else { 
				set rx_pma_qpipulldn_idx [expr { $enh_pld_pcs_width == 32 ? 36 : 78 } ]
				set tx_pma_qpipulldn_idx 37
				set tx_pma_qpipullup_idx 38
			}
		} elseif {$l_enable_tx_pcs_dir} {
			if {$pcs_direct_width == 40} {
				ip_message error "Synchronous transfer of QPI signals is not supported when PCS Direct interface width is $pcs_direct_width."
			} else {
				set rx_pma_qpipulldn_idx [expr { $pcs_direct_width < 20 ? 16 
					: $pcs_direct_width < 40 ? 36 
					: 78 } ]
				set tx_pma_qpipulldn_idx [expr { $pcs_direct_width < 20 ? 17 : 37 } ]
				set tx_pma_qpipullup_idx [expr { $pcs_direct_width < 20 ? 18 : 38 } ]
			}
		}

		if { $rx_pma_qpipulldn_idx != -1 } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_pma_qpipulldn_sync${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 $rx_pma_qpipulldn_idx $used $add_offset "rx_pma_qpipulldn_sync" ]
		}
		if { $tx_pma_qpipulldn_idx != -1 } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_pma_qpipulldn_sync${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 $tx_pma_qpipulldn_idx $used $add_offset "tx_pma_qpipulldn_sync" ]
		}
		if { $tx_pma_qpipullup_idx != -1 } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_pma_qpipullup_sync${sfx}" "tx_parallel_data" input $l_channels $TX_DATA_WIDTH $TX_DATA_WIDTH 1 1 $tx_pma_qpipullup_idx $used $add_offset "tx_pma_qpipullup_sync" ]
		}	
  }
  
  return $unused_list_col  
}

proc ::altera_xcvr_native_s10::interfaces::elaborate_tx_parallel_data { PROP_IFACE_SPLIT_INDEX l_crete_nf rcfg_iface_enable enable_hip enable_double_rate_transfer datapath_select l_split_iface l_enable_tx_std l_enable_tx_enh \
    l_enable_tx_pcs_dir l_enable_std_pipe protocol_mode l_std_tx_word_width l_std_tx_word_count l_std_tx_field_width \
    enable_simple_interface l_channels tx_fifo_mode std_tx_8b10b_enable std_tx_8b10b_disp_ctrl_enable \
	enable_qpi_mode enable_qpi_async_transfer enh_pcs_pma_width enh_pld_pcs_width pcs_direct_width } {

  variable TX_DATA_WIDTH

  if {$enable_hip || $enable_double_rate_transfer} {
	return
  }
  
  # Lie about the number of l_channels if splitting (1 per interface)
  set l_channels [expr {$l_split_iface ? 1 : $l_channels}]
  set sfx [expr {$l_split_iface ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
  set add_offset [expr $TX_DATA_WIDTH * $PROP_IFACE_SPLIT_INDEX]
    
  map_tx_parallel_data $l_crete_nf $rcfg_iface_enable $datapath_select $l_enable_tx_std $l_enable_tx_enh $l_enable_tx_pcs_dir $l_enable_std_pipe \
	$protocol_mode $l_std_tx_word_width $l_std_tx_word_count $l_std_tx_field_width \
    $enable_simple_interface $l_channels $tx_fifo_mode $std_tx_8b10b_enable $std_tx_8b10b_disp_ctrl_enable \
	$enable_qpi_mode $enable_qpi_async_transfer $enh_pcs_pma_width $enh_pld_pcs_width $pcs_direct_width "used" $sfx $add_offset 
}
        
proc ::altera_xcvr_native_s10::interfaces::elaborate_unused_tx_parallel_data { l_crete_nf rcfg_iface_enable datapath_select l_enable_tx_std l_enable_tx_enh l_enable_tx_pcs_dir l_enable_std_pipe protocol_mode \
	l_std_tx_word_width l_std_tx_word_count l_std_tx_field_width enable_simple_interface l_channels tx_fifo_mode \
	std_tx_8b10b_enable std_tx_8b10b_disp_ctrl_enable enable_qpi_mode enable_qpi_async_transfer	enh_pcs_pma_width enh_pld_pcs_width pcs_direct_width } {
	
	variable TX_DATA_WIDTH

	if {!$enable_simple_interface} {
		return
	}
	set unused_list_col [map_tx_parallel_data $l_crete_nf $rcfg_iface_enable $datapath_select $l_enable_tx_std $l_enable_tx_enh $l_enable_tx_pcs_dir $l_enable_std_pipe \
		$protocol_mode $l_std_tx_word_width $l_std_tx_word_count $l_std_tx_field_width \
		$enable_simple_interface $l_channels $tx_fifo_mode $std_tx_8b10b_enable $std_tx_8b10b_disp_ctrl_enable \
		$enable_qpi_mode $enable_qpi_async_transfer $enh_pcs_pma_width $enh_pld_pcs_width $pcs_direct_width "unused"]
		
	set unused_list [lindex $unused_list_col 0]
	set size [llength $unused_list_col]
	for {set i 1} {$i < $size} {incr i} {
		set temp_list [lindex $unused_list_col $i]
		set unused_list [::alt_xcvr::utils::common::intersect $unused_list $temp_list]
	}

	if {[llength $unused_list] > 0} {		
		set unused_list [convert_list_to_map $unused_list]		
		create_fragmented_range_conduit "unused_tx_parallel_data" "tx_parallel_data" $unused_list input input		
	}
}

######################## End TX parallel data elaboration #####################
###############################################################################


###############################################################################
########################## RX parallel data elaboration #######################

proc ::altera_xcvr_native_s10::interfaces::map_rx_parallel_data { l_crete_nf rcfg_iface_enable datapath_select rx_fifo_mode l_enable_rx_std l_enable_rx_enh l_enable_rx_pcs_dir l_enable_std_pipe protocol_mode \
	l_std_rx_word_width l_std_rx_word_count l_std_rx_field_width enable_simple_interface l_channels std_rx_8b10b_enable std_rx_word_aligner_mode std_rx_rmfifo_mode \
	enable_qpi_mode enable_qpi_async_transfer enh_pcs_pma_width enh_pld_pcs_width pcs_direct_width enable_port_rx_data_valid enable_ports_rx_prbs used {sfx ""} {add_offset 0} } {

	variable RX_DATA_WIDTH
	set unused_list_col {}

	# modify values of "l_enable_rx_std" "l_enable_rx_enh" "l_enable_rx_pcs_dir" based on rcfg_iface_enable --> datapath and interface reconfiguration
	set l_enable_rx_std       [expr {$rcfg_iface_enable ? ( $datapath_select == "Standard"   && $l_enable_rx_std     ) : $l_enable_rx_std}]
	set l_enable_rx_enh       [expr {$rcfg_iface_enable ? ( $datapath_select == "Enhanced"   && $l_enable_rx_enh     ) : $l_enable_rx_enh}]
	set l_enable_rx_pcs_dir   [expr {$rcfg_iface_enable ? ( $datapath_select == "PCS Direct" && $l_enable_rx_pcs_dir ) : $l_enable_rx_pcs_dir}]

	if {$l_enable_rx_std} {
		set std_rx_fields [expr { ($protocol_mode == "pipe_g3") ? {55 40 15 0} : {56 40 16 0} }]

		if {$l_std_rx_word_count == 4} {		
			set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_rx_fields $l_std_rx_word_width 0]			
			lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_parallel_data${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes $l_std_rx_word_count $l_std_rx_word_width $used $add_offset "rx_parallel_data"]
		} else {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_parallel_data${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $l_std_rx_field_width $l_std_rx_word_count $l_std_rx_word_width 0 $used $add_offset "rx_parallel_data"]
		}   
    
		if {$std_rx_8b10b_enable} {
			if {$l_std_rx_word_count == 4} {
				set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_rx_fields 1 8]			
				lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_datak${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes $l_std_rx_word_count 1 $used $add_offset "rx_datak"]
			} else {
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_datak${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $l_std_rx_field_width $l_std_rx_word_count 1 8 $used $add_offset "rx_datak"]
			}
		}

		if {$std_rx_word_aligner_mode != "bitslip" } {
			if {$l_std_rx_word_count == 4} {
				set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_rx_fields 1 10]			
				lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_syncstatus${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes $l_std_rx_word_count 1 $used $add_offset "rx_syncstatus"]
			} else {
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_syncstatus${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $l_std_rx_field_width $l_std_rx_word_count 1 10 $used $add_offset "rx_syncstatus"]
			}        
		}

		if {!$l_enable_std_pipe} {
			if {$std_rx_8b10b_enable} {
				if {$l_std_rx_word_count == 4} {
					set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_rx_fields 1 9]			
					lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_errdetect${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes $l_std_rx_word_count 1 $used $add_offset "rx_errdetect"]
					set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_rx_fields 1 11]			
					lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_disperr${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes $l_std_rx_word_count 1 $used $add_offset "rx_disperr"]
					set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_rx_fields 1 15]			
					lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_runningdisp${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes $l_std_rx_word_count 1 $used $add_offset "rx_runningdisp"]
				} else {
					lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_errdetect${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $l_std_rx_field_width $l_std_rx_word_count 1 9 $used $add_offset "rx_errdetect"]
					lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_disperr${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $l_std_rx_field_width $l_std_rx_word_count 1 11 $used $add_offset "rx_disperr"]
					lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_runningdisp${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $l_std_rx_field_width $l_std_rx_word_count 1 15 $used $add_offset "rx_runningdisp"]
				}        
			}

			if {$std_rx_word_aligner_mode != "bitslip" } {
				if {$l_std_rx_word_count == 4} {
					set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_rx_fields 1 12]			
					lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_patterndetect${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes $l_std_rx_word_count 1 $used $add_offset "rx_patterndetect"]
				} else {
					lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_patterndetect${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $l_std_rx_field_width $l_std_rx_word_count 1 12 $used $add_offset "rx_patterndetect"]
				}        
			}

			if {$std_rx_rmfifo_mode != "disabled" } {
				if {$l_std_rx_word_count == 4} {
					set bit_indexes [::altera_xcvr_native_s10::interfaces::generate_bit_indexes $std_rx_fields 2 13]			
					lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_rmfifostatus${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes $l_std_rx_word_count 2 $used $add_offset "rx_rmfifostatus"]
				} else {
					lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_rmfifostatus${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $l_std_rx_field_width $l_std_rx_word_count 2 13 $used $add_offset "rx_rmfifostatus"]
				}        
			}
		}

		if {$l_enable_std_pipe} {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_phy_status${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 32 $used $add_offset "pipe_phy_status"]
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_rx_valid${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 33 $used $add_offset "pipe_rx_valid"]
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_rx_status${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 3 34 $used $add_offset "pipe_rx_status"]
			if {$protocol_mode == "pipe_g3"} {
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_rx_sync_hdr${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 2 30 $used $add_offset "pipe_rx_sync_hdr"]
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_rx_blk_start${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 37 $used $add_offset "pipe_rx_blk_start"]
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_rx_data_valid${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 38 $used $add_offset "pipe_rx_data_valid"]
				if {!$l_crete_nf} {
					lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "pipe_eq_dirfeedback${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 6 71 $used $add_offset "pipe_eq_dirfeedback"]
				}
			}
		}
	} elseif {$l_enable_rx_enh} {\
		if {$enh_pld_pcs_width >= 64} {
			set bit_indexes {71:40 31:0}
			lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_parallel_data${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes 1 64 $used $add_offset "rx_parallel_data"]
		} else {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_parallel_data${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 $enh_pld_pcs_width 0 $used $add_offset "rx_parallel_data"]
		}

		# RX Control
		if {$enh_pld_pcs_width > 64} {
			if {$protocol_mode == "teng_baser_mode" || $protocol_mode == "teng_1588_mode" || $protocol_mode == "teng_baser_krfec_mode" || $protocol_mode == "teng_1588_krfec_mode"} {
				set bit_indexes {75:72 35:32}
				lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_control${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes 1 8 $used $add_offset "rx_control"]
			} elseif {$protocol_mode == "interlaken_mode"} {
				set bit_indexes {77:72 35:32}
				lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_control${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes 1 10 $used $add_offset "rx_control"]
			} else {
				set width [expr {$enh_pld_pcs_width - 64}]
				lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_control${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 $width 32 $used $add_offset "rx_control"]
			}
		}

		# RX GB data valid
		if {$enh_pld_pcs_width >= 64 && ($enh_pcs_pma_width != $enh_pld_pcs_width) } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_enh_data_valid${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 36 $used $add_offset "rx_enh_data_valid"]
		} 
			
		# PRBS
		if { $enable_ports_rx_prbs && $enh_pld_pcs_width == 32 } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_prbs_err_sync${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 35 $used $add_offset "rx_prbs_err_sync"]
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_prbs_done_sync${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 36 $used $add_offset "rx_prbs_done_sync"]
		}
	} elseif {$l_enable_rx_pcs_dir} {
		# PCS Direct datapath
		if { $pcs_direct_width < 64 } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_parallel_data${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $pcs_direct_width 1 $pcs_direct_width 0 $used $add_offset "rx_parallel_data"]
		} else {
			set bit_indexes {71:40 31:0}
			lappend unused_list_col [lcl_create_fragmented_interface_from_list $enable_simple_interface "rx_parallel_data${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $bit_indexes 1 64 $used $add_offset "rx_parallel_data"]
		}

		# PRBS
		if { $enable_ports_rx_prbs && $pcs_direct_width == 32 } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_prbs_err_sync${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 35 $used $add_offset "rx_prbs_err_sync"]
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_prbs_done_sync${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 36 $used $add_offset "rx_prbs_done_sync"]
		}
	} 

	# RX data valid
	if {$enable_port_rx_data_valid} {
		lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "rx_data_valid${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 79 $used $add_offset "rx_data_valid"]
	}

	# QPI signals
	if {$enable_qpi_mode && !$enable_qpi_async_transfer} {	
		set tx_pma_rxfound_idx -1
	
		if {$l_enable_rx_std} {
			set tx_pma_rxfound_idx 37
		} elseif {$l_enable_rx_enh} {
			if {$enh_pld_pcs_width == 40} {
				ip_message error "Synchronous transfer of QPI signals is not supported when FPGA fabric / Enhanced PCS Interface width is $enh_pld_pcs_width."
			} else {
				set tx_pma_rxfound_idx [expr { $enh_pld_pcs_width == 32 ? 37 : 78 } ]
			}
		} elseif {$l_enable_rx_pcs_dir} {
			if {$pcs_direct_width == 40} {
				ip_message error "Synchronous transfer of QPI signals is not supported when PCS Direct interface width is $pcs_direct_width."
			} else {
				set tx_pma_rxfound_idx [expr { $pcs_direct_width < 20 ? 18 
					: $pcs_direct_width < 40 ? 37 
					: 78 } ]
			}
		}

		if { $tx_pma_rxfound_idx != -1 } {
			lappend unused_list_col [lcl_create_fragmented_interface $enable_simple_interface "tx_pma_rxfound_sync${sfx}" "rx_parallel_data" output $l_channels $RX_DATA_WIDTH $RX_DATA_WIDTH 1 1 $tx_pma_rxfound_idx $used $add_offset "tx_pma_rxfound_sync"]
		}	
	}

	return $unused_list_col
}

proc ::altera_xcvr_native_s10::interfaces::elaborate_rx_parallel_data { PROP_IFACE_SPLIT_INDEX l_crete_nf rcfg_iface_enable enable_hip enable_double_rate_transfer datapath_select rx_fifo_mode l_split_iface l_enable_rx_std l_enable_rx_enh l_enable_rx_pcs_dir l_enable_std_pipe protocol_mode \
	l_std_rx_word_width l_std_rx_word_count l_std_rx_field_width enable_simple_interface l_channels std_rx_8b10b_enable std_rx_word_aligner_mode std_rx_rmfifo_mode \
	enable_qpi_mode enable_qpi_async_transfer enh_pcs_pma_width enh_pld_pcs_width pcs_direct_width enable_port_rx_data_valid enable_ports_rx_prbs } {
  
  variable RX_DATA_WIDTH

  if {$enable_hip || $enable_double_rate_transfer} {
	return
  }

  # Lie about the number of l_channels if splitting (1 per interface)
  set l_channels [expr {$l_split_iface ? 1 : $l_channels}]
  set sfx [expr {$l_split_iface ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
  set add_offset [expr $RX_DATA_WIDTH * $PROP_IFACE_SPLIT_INDEX]

  map_rx_parallel_data $l_crete_nf $rcfg_iface_enable $datapath_select $rx_fifo_mode $l_enable_rx_std $l_enable_rx_enh $l_enable_rx_pcs_dir $l_enable_std_pipe $protocol_mode \
	$l_std_rx_word_width $l_std_rx_word_count $l_std_rx_field_width $enable_simple_interface $l_channels $std_rx_8b10b_enable $std_rx_word_aligner_mode $std_rx_rmfifo_mode \
	$enable_qpi_mode $enable_qpi_async_transfer $enh_pcs_pma_width $enh_pld_pcs_width $pcs_direct_width $enable_port_rx_data_valid $enable_ports_rx_prbs "used" $sfx $add_offset
}

proc ::altera_xcvr_native_s10::interfaces::elaborate_unused_rx_parallel_data { l_crete_nf rcfg_iface_enable datapath_select rx_fifo_mode l_enable_rx_std l_enable_rx_enh l_enable_rx_pcs_dir l_enable_std_pipe protocol_mode \
	l_std_rx_word_width l_std_rx_word_count l_std_rx_field_width enable_simple_interface l_channels std_rx_8b10b_enable std_rx_word_aligner_mode std_rx_rmfifo_mode \
	enable_qpi_mode enable_qpi_async_transfer enh_pcs_pma_width enh_pld_pcs_width pcs_direct_width enable_port_rx_data_valid enable_ports_rx_prbs } {

	if {!$enable_simple_interface} {
		return
	}

	set unused_list_col [map_rx_parallel_data $l_crete_nf $rcfg_iface_enable $datapath_select $rx_fifo_mode $l_enable_rx_std $l_enable_rx_enh $l_enable_rx_pcs_dir $l_enable_std_pipe $protocol_mode \
		$l_std_rx_word_width $l_std_rx_word_count $l_std_rx_field_width $enable_simple_interface $l_channels $std_rx_8b10b_enable $std_rx_word_aligner_mode $std_rx_rmfifo_mode \
		$enable_qpi_mode $enable_qpi_async_transfer $enh_pcs_pma_width $enh_pld_pcs_width $pcs_direct_width $enable_port_rx_data_valid $enable_ports_rx_prbs "unused"]

	set unused_list [lindex $unused_list_col 0]
	set size [llength $unused_list_col]
	for {set i 1} {$i < $size} {incr i} {
		set temp_list [lindex $unused_list_col $i]
		set unused_list [::alt_xcvr::utils::common::intersect $unused_list $temp_list]
	}

	if {[llength $unused_list] > 0} {
		set unused_list [convert_list_to_map $unused_list]		
		create_fragmented_range_conduit "unused_rx_parallel_data" "rx_parallel_data" $unused_list output output		
	}
}

######################## End RX parallel data elaboration #####################
###############################################################################
proc ::altera_xcvr_native_s10::interfaces::elaborate_reconfig_reset { PROP_IFACE_NAME design_environment l_split_iface } {
  if { $design_environment != "NATIVE" } {
    set reconfig_clk "reconfig_clk"
    if {$l_split_iface} {
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {reconfig_clk\1} reconfig_clk  
    }
    ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $reconfig_clk
  }
}

proc ::altera_xcvr_native_s10::interfaces::elaborate_reconfig_avmm { PROP_IFACE_NAME design_environment l_split_iface device_revision} {
  if { $design_environment != "NATIVE" } {
    set reconfig_clk "reconfig_clk"
    set reconfig_reset "reconfig_reset"
    if {$l_split_iface} {
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {reconfig_clk\1} reconfig_clk  
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {reconfig_reset\1} reconfig_reset  
    }
    ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $reconfig_clk
    ip_set "interface.${PROP_IFACE_NAME}.associatedreset" $reconfig_reset
    ip_set "interface.${PROP_IFACE_NAME}.assignment" [list "debug.typeName" "altera_xcvr_native_s10.slave"]
	ip_set "interface.${PROP_IFACE_NAME}.assignment" [list "debug.param.device_revision" $device_revision]
  }
}


