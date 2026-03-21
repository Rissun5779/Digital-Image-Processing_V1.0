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


proc ::nf_xcvr_native::parameters::getValue_hssi_gen3_tx_pcs_mode { device_revision hssi_tx_pld_pcs_interface_hd_g3_prot_mode } {

   set legal_values [list "disable_pcs" "gen3_func"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g1") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g2") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g3") }] {
      set legal_values [intersect $legal_values [list "gen3_func"]]
   }
   set legal_values [intersect $legal_values [list "gen3_func" "disable_pcs"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_gen3_tx_pcs_reverse_lpbk { device_revision hssi_gen3_tx_pcs_mode hssi_gen3_tx_pcs_sup_mode } {

   set legal_values [list "rev_lpbk_dis" "rev_lpbk_en"]

   if [expr { ($hssi_gen3_tx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_tx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "rev_lpbk_en"]]
      } else {
         if [expr { ($hssi_gen3_tx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "rev_lpbk_dis"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "rev_lpbk_dis" "rev_lpbk_en"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_gen3_tx_pcs_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_g3_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_gen3_tx_pcs_tx_bitslip { device_revision hssi_gen3_tx_pcs_mode hssi_gen3_tx_pcs_sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($hssi_gen3_tx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_tx_pcs_mode=="gen3_func") }] {
         set legal_values [compare_eq $legal_values 0]
      } else {
         if [expr { ($hssi_gen3_tx_pcs_mode=="disable_pcs") }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_gen3_tx_pcs_tx_gbox_byp { device_revision hssi_gen3_tx_pcs_mode hssi_gen3_tx_pcs_sup_mode } {

   set legal_values [list "bypass_gbox" "enable_gbox"]

   if [expr { ($hssi_gen3_tx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_tx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "enable_gbox"]]
      } else {
         if [expr { ($hssi_gen3_tx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "bypass_gbox"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bypass_gbox" "enable_gbox"]]
      }
   }

   return $legal_values
}

