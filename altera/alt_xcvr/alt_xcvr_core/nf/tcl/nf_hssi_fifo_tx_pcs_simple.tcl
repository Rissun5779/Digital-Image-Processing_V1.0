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


proc ::nf_xcvr_native::parameters::getValue_hssi_fifo_tx_pcs_double_write_mode { device_revision hssi_fifo_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx hssi_tx_pld_pcs_interface_hd_fifo_shared_fifo_width_tx } {

   set legal_values [list "double_write_dis" "double_write_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx=="teng_mode_tx") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_fifo_shared_fifo_width_tx=="single_tx") }] {
         set legal_values [intersect $legal_values [list "double_write_dis"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_fifo_shared_fifo_width_tx=="double_tx") }] {
         set legal_values [intersect $legal_values [list "double_write_en"]]
      }
   }
   if [expr { ($hssi_fifo_tx_pcs_prot_mode=="teng_mode") }] {
      set legal_values [intersect $legal_values [list "double_write_en" "double_write_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "double_write_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_fifo_tx_pcs_prot_mode { device_revision hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx } {

   set legal_values [list "non_teng_mode" "teng_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx=="teng_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx=="non_teng_mode_tx") }] {
      set legal_values [intersect $legal_values [list "non_teng_mode"]]
   }

   return $legal_values
}

