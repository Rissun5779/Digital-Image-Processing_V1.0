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


#####################################################################
#
# THIS IS AN AUTO-GENERATED FILE!
# -------------------------------
# If you modify this files, all your changes will be lost if you
# regenerate the core!
#
# FILE DESCRIPTION
# ----------------
# This file specifies the timing constraints for the PHYLITE interface

# ------------------------------------------- #
# -                                         - #
# --- Some useful functions and variables --- #
# -                                         - #
# ------------------------------------------- #

set script_dir [file dirname [info script]]

# ------------------------------------------------- #
# -                                               - #
# --- Please make all your changes to the file  --- #
# --- only in the section below                 --- #
# -                                               - #
# ------------------------------------------------- #


# Dynamic Reconfiguration Algorithm Verification
# Set to 1 if dynamic reconfiguration is on and user has
# extensively verified the calibration algorithm.
# Setting this to 1 will cut all timing paths at the I/O to/from memory device
# for all groups in this PHYLIte IP.
set var(dynamic_reconfiguration_algorithm_verified) 0

# ------------------------------------------- #
# -                                         - #
# --- Some useful functions and variables --- #
# -                                         - #
# ------------------------------------------- #

source "$script_dir/memphy_ip_parameters.tcl"
source "$script_dir/memphy_parameters.tcl"
source "$script_dir/memphy_pin_map.tcl"

set var(C2P_SETUP_OC_NS) 0.100
set var(C2P_HOLD_OC_NS)  0.200
set var(P2C_SETUP_OC_NS) 0.050
set var(P2C_HOLD_OC_NS)  0.100
set var(C2C_SAME_CLK_SETUP_OC_NS) 0.0
set var(C2C_SAME_CLK_HOLD_OC_NS)  0.0
set var(C2C_DIFF_CLK_SETUP_OC_NS) 0.0 
set var(C2C_DIFF_CLK_HOLD_OC_NS)  0.0

#--------------------------------------------#
# -                                        - #
# --- Determine when SDC is being loaded --- #
# -                                        - #
#--------------------------------------------#

set syn_flow 0
set sta_flow 0
set fit_flow 0
if { $::TimeQuestInfo(nameofexecutable) == "quartus_map" || $::TimeQuestInfo(nameofexecutable) == "quartus_syn"} {
   set syn_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_sta" } {
   set sta_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_fit" } {
   set fit_flow 1
}


# ------------------------ #
# -                      - #
# --- GENERAL SETTINGS --- #
# -                      - #
# ------------------------ #

# This is a global setting and will apply to the whole design.
# This setting is not specifically required for PhyLite
# unless the A10 IOPLL workaround is enabled.  However,
# this setting will not affect PhyLite behavior.
if {[memphy_get_a10_iopll_workaround_present]} {
   derive_pll_clocks
}

# This is a global setting and will apply to the whole design.
# This setting is required for the memory interface to be
# properly constrained.
derive_clock_uncertainty

# Debug switch. Change to 1 to get more run-time debug information
set debug 0

# All timing requirements will be represented in nanoseconds with up to 3 decimal places of precision
set_time_format -unit ns -decimal_places 3

# Determine if entity names are on
set entity_names_on [ memphy_are_entity_names_on ]

# ---------------------- #
# -                    - #
# --- DERIVED TIMING --- #
# -                    - #
# ---------------------- #

# PLL multiplier to mem clk
regexp {([0-9\.]+) ps} $var(PLL_REF_CLK_FREQ_PS_STR) match var(PHY_REF_CLK_FREQ_PS)
regexp {([0-9\.]+) ps} $var(PLL_VCO_FREQ_PS_STR) match var(PHY_VCO_FREQ_PS)
set pll_multiplier [ memphy_round_3dp [expr $var(PHY_MEM_CLK_FREQ_MHZ)/$var(PHY_REF_CLK_FREQ_MHZ)] ]
set vco_multiplier [expr int($var(PHY_REF_CLK_FREQ_PS)/$var(PHY_VCO_FREQ_PS))]

# Half of memory clock cycle
set half_period [ memphy_round_3dp [ expr $var(UI) / 2.0 ] ]

# Half of reference clock
set ref_period      [ memphy_round_3dp [ expr $var(PHY_REF_CLK_FREQ_PS)/1000.0] ]
set ref_half_period [ memphy_round_3dp [ expr $ref_period / 2.0 ] ]

# Other clock periods
set tCK_AFI     [ memphy_round_3dp [ expr 1000.0/$var(PHY_MEM_CLK_FREQ_MHZ)*$var(USER_CLK_RATIO) ] ]
set tCK_C2P_P2C [ memphy_round_3dp [ expr 1000.0/$var(PHY_MEM_CLK_FREQ_MHZ)*$var(C2P_P2C_CLK_RATIO) ] ]
set tCK_PHY     [ memphy_round_3dp [ expr 1000.0/$var(PHY_MEM_CLK_FREQ_MHZ)*$var(PHY_PHY_CLK_RATIO) ] ]

# ---------------------- #
# -                    - #
# --- INTERFACE RATE --- #
# -                    - #
# ---------------------- #

if {$var(USER_CLK_RATIO) != $var(C2P_P2C_CLK_RATIO)} {
   # Eighth rate
   set rate 8.0
} else {
   # Quarter / Half / Full rate
   set rate $var(C2P_P2C_CLK_RATIO)
}

# -------------------------------------------------------------------- #
# -                                                                  - #
# --- This is the main call to the netlist traversal routines      --- #
# --- that will automatically find all pins and registers required --- #
# --- to apply timing constraints.                                 --- #
# --- During the fitter, the routines will be called only once     --- #
# --- and cached data will be used in all subsequent calls.        --- #
# -                                                                  - #
# -------------------------------------------------------------------- #

if { ! [ info exists memphy_sdc_cache ] } {
   memphy_initialize_ddr_db memphy_ddr_db $rate var
   set memphy_sdc_cache 1
} else {
   if { $debug } {
      post_message -type info "SDC: reusing cached DDR DB"
   }
}

# ------------------------------------------------------------- #
# -                                                           - #
# --- If multiple instances of this core are present in the --- #
# --- design they will all be constrained through the       --- #
# --- following loop                                        --- #
# -                                                           - #
# ------------------------------------------------------------- #

set instances [ array names memphy_ddr_db ]
foreach { inst } $instances {
   set io_clocks ""

   if { [ info exists pins ] } {
      unset pins
   }
   array set pins $memphy_ddr_db($inst)

   set prefix $inst
   if { $entity_names_on } {
      set prefix [ string map "| |*:" $inst ]
      set prefix "*:$prefix"
   }

   # ----------------------- #
   # -                     - #
   # --- REFERENCE CLOCK --- #
   # -                     - #
   # ----------------------- #

   set additional_jitter 0.000
   # First determine if a reference clock has already been created (i.e. Reference clock sharing)
   if {$var(PLL_USE_CORE_REF_CLK) == "false"} {
      set ref_clock_exists [ memphy_does_ref_clk_exist $pins(pll_ref_clock) ]
      if { $ref_clock_exists == 0 }  {
         # This is the reference clock used by the PLL to derive any other clock in the core
         create_clock -period $ref_period -waveform [ list 0 $ref_half_period ] $pins(pll_ref_clock) -add -name ${inst}_ref_clock
      }   
   } else {
      set additional_jitter 0.100
   }

   # ------------------ #
   # -                - #
   # --- PLL CLOCKS --- #
   # -                - #
   # ------------------ #
   
   set core_clocks [list]
   set core_clocks_local [list]   
   
   # VCO clock
   set i_vco_clock 0
   foreach { vco_clock } $pins(pll_vco_clock) {
   
      set suffix "_${i_vco_clock}"
      if {$vco_clock == $pins(master_vco_clock)} {
         set suffix ""
      }

      set local_pll_vco_clk_${i_vco_clock} [ memphy_get_or_add_generated_clock \
         -target $vco_clock \
         -name "${inst}_vco_clk${suffix}" \
         -source $pins(pll_ref_clock) \
         -multiply_by [expr $vco_multiplier ]  \
         -divide_by 1 \
         -phase 0 ]
      incr i_vco_clock
   }
         
   
   # First USR clock
   set i_usr_clock 0
   set found_master_clock 0
   set divide_by [expr $var(PLL_VCO_TO_MEM_CLK_FREQ_RATIO)*$var(USER_CLK_RATIO)] 
   set phase [expr {$var(PLL_PHY_CLK_VCO_PHASE) * 45.0 / $divide_by}]
   foreach { usr_clock } $pins(pll_usr_clock)  {   

      set suffix "_${i_usr_clock}"
      if {$usr_clock == $pins(pll_master_usr_clk)} {
         set found_master_clock 1
         set suffix ""
      }

      set local_usr_clk${suffix} [ memphy_get_or_add_generated_clock \
         -target $usr_clock \
         -name "${inst}_usr_clk${suffix}" \
         -source [lindex $pins(pll_vco_clock) $i_usr_clock] \
         -multiply_by 1 \
         -divide_by $divide_by \
         -phase $phase ]
      incr i_usr_clock

      lappend core_clocks $usr_clock
      lappend core_clocks_local [set local_usr_clk${suffix}]	  

   }
   
   # Second USR clock
   set i_usr_clock_a 0
   foreach { usr_clock_a } $pins(pll_usr_clock_a)  {   
   
      set suffix "_${i_usr_clock_a}"
      if {$usr_clock_a == $pins(pll_master_usr_clk)} {
         set found_master_clock 1
         set suffix ""
      }   
   
      set local_usr_clk_a${suffix} [ memphy_get_or_add_generated_clock \
         -target $usr_clock_a \
         -name "${inst}_usr_clk_a${i_usr_clock_a}" \
         -source [lindex $pins(pll_vco_clock) $i_usr_clock_a] \
         -multiply_by 1 \
         -divide_by $divide_by \
         -phase $phase ]
      incr i_usr_clock_a

      lappend core_clocks $usr_clock_a
      lappend core_clocks_local [set local_usr_clk_a${suffix}]	  
   }     
   
   if {$found_master_clock == 0} {
   
      set local_pll_master_vco_clk [ memphy_get_or_add_generated_clock \
         -target $pins(master_vco_clock) \
         -name "${pins(master_instname)}_vco_clk" \
         -source $pins(pll_ref_clock) \
         -multiply_by [expr $vco_multiplier ]  \
         -divide_by 1 \
         -phase 0 ]
   
   
      set local_usr_clk [ memphy_get_or_add_generated_clock \
         -target $pins(pll_master_usr_clk) \
         -name "${pins(master_instname)}_usr_clk" \
         -source $pins(master_vco_clock) \
         -multiply_by 1 \
         -divide_by [expr $var(PLL_VCO_TO_MEM_CLK_FREQ_RATIO)*$var(USER_CLK_RATIO)] \
         -phase 0 ]
		 
      lappend core_clocks $pins(pll_master_usr_clk)
      lappend core_clocks_local $local_usr_clk 		 
   }

   # Optional C2P/P2C clock
   if {$var(USER_CLK_RATIO) != $var(C2P_P2C_CLK_RATIO)} {
      set local_pll_c2p_p2c_clock [ memphy_get_or_add_generated_clock \
         -target $pins(pll_c2p_p2c_clock) \
         -name "${inst}_c2p_p2c_clk" \
         -source [lindex $pins(pll_vco_clock) 0] \
         -multiply_by 1  \
         -divide_by [expr $var(PLL_VCO_TO_MEM_CLK_FREQ_RATIO)*$var(C2P_P2C_CLK_RATIO)]  \
         -phase 0 ]
		 
      lappend core_clocks  $pins(pll_c2p_p2c_clock)
      lappend core_clocks_local $local_pll_c2p_p2c_clock	 		 
   }
   
   # Optional PLL Extra clocks
   if {$var(gui_enable_advanced_mode)} {
      for {set i_extra_clk 0} {$i_extra_clk < $var(gui_number_of_pll_output_clocks)} {incr i_extra_clk} {
         set i_clk_cnt_num [expr $i_extra_clk + $var(max_number_of_reserved_clocks)]
         set local_pll_extra_clock [ memphy_get_or_add_generated_clock \
            -target $pins(pll_extra_clock${i_extra_clk}) \
            -name "${inst}_extra_clk${i_extra_clk}" \
            -source [lindex $pins(pll_vco_clock) 0] \
            -multiply_by 1  \
            -divide_by $var(c${i_clk_cnt_num}_cnt)  \
            -phase [expr [lindex $var(pll_output_phase_shift_${i_clk_cnt_num}) 0] * 360.0 / $var(PHY_VCO_FREQ_PS) / $var(c${i_clk_cnt_num}_cnt) ] \
            -duty_cycle $var(pll_output_duty_cycle_${i_clk_cnt_num}) ]
          
         lappend core_clocks  $pins(pll_extra_clock${i_extra_clk})
         lappend core_clocks_local $local_pll_extra_clock	 		 
      }
   }
   
   # Periphery clocks
   set divide_by [expr $var(PLL_VCO_TO_MEM_CLK_FREQ_RATIO)*$var(PHY_PHY_CLK_RATIO)]
   set phase [expr {$var(PLL_PHY_CLK_VCO_PHASE) * 45.0 / $divide_by}]
   set i_phy_clock 0
   foreach { phy_clock } $pins(pll_phy_clock) {
      set local_phy_clk_${i_phy_clock} [ memphy_get_or_add_generated_clock \
         -target $phy_clock \
         -name "${inst}_phy_clk_${i_phy_clock}" \
         -source [lindex $pins(pll_vco_clock) $i_phy_clock] \
         -multiply_by 1 \
         -divide_by $divide_by \
         -phase $phase ]
      incr i_phy_clock
   }
   set i_phy_clock_l 0
   foreach { phy_clock_l } $pins(pll_phy_clock_l) {
      set local_phy_clk_l_${i_phy_clock_l} [ memphy_get_or_add_generated_clock \
         -target $phy_clock_l \
         -name "${inst}_phy_clk_l_${i_phy_clock_l}" \
         -source [lindex $pins(pll_vco_clock) $i_phy_clock_l] \
         -multiply_by 1 \
         -divide_by $divide_by \
         -phase $phase ]
      incr i_phy_clock_l
   }

   if {$fit_flow} {
      set_multicycle_path -from "${inst}*|core|arch_inst|counter_lock_gen_master.counter_lock" -to "${inst}*|core|arch_inst|groups_locked_synch_reg\[0\]*" -setup 2
      set_multicycle_path -from "${inst}*|core|arch_inst|counter_lock_gen_master.counter_lock" -to "${inst}*|core|arch_inst|groups_locked_synch_reg\[0\]*" -hold 1
   } else {
      set_false_path -from "${inst}*|core|arch_inst|counter_lock_gen_master.counter_lock" -to "${inst}*|core|arch_inst|groups_locked_synch_reg\[0\]"
   }


   set var(RD_JITTER_SCALED)      $var(RD_JITTER)
   set var(RD_JITTER_sens) [expr ([expr (($var(UI))*1000.0-$var(EXTRACTED_PERIOD))*$var(RD_JITTER_SENS_TO_PERIOD)])/1000.0]
   if {$var(RD_JITTER_sens) > 0} {
      set var(RD_JITTER_SCALED) [expr $var(RD_JITTER) + $var(RD_JITTER_sens)]
   }
   set var(WR_JITTER_SCALED)      $var(WR_JITTER)
   set var(WR_JITTER_sens) [expr ([expr (($var(UI))*1000.0-$var(EXTRACTED_PERIOD))*$var(WR_JITTER_SENS_TO_PERIOD)])/1000.0]
   if {$var(WR_JITTER_sens) > 0} {
      set var(WR_JITTER_SCALED) [expr $var(WR_JITTER) + $var(WR_JITTER_sens)]
   }

   # Create constraints for each PHYLite group
   for {set i_grp_idx 0} {$i_grp_idx < $var(PHYLITE_NUM_GROUPS)} { incr i_grp_idx} {

      # Input/Output delay constraints
      set var(RD_ISI)         $var(GROUP_${i_grp_idx}_READ_ISI)
      set additional_input_delay [expr 0.5*($var(RD_ISI))]

      set var(WR_ISI)         $var(GROUP_${i_grp_idx}_WRITE_ISI)
      set additional_output_delay [expr 0.5*($var(WR_ISI))]
   
      set out_min_delay [ memphy_round_3dp [ expr - $var(GROUP_${i_grp_idx}_T_OUT_DH) - $additional_output_delay ]]
      set out_max_delay [ memphy_round_3dp [ expr   $var(GROUP_${i_grp_idx}_T_OUT_DS) + $additional_output_delay ]]
      set in_min_delay  [ memphy_round_3dp [ expr - $var(GROUP_${i_grp_idx}_T_IN_DH)  - $additional_input_delay ]]
      set in_max_delay  [ memphy_round_3dp [ expr   $var(GROUP_${i_grp_idx}_T_IN_DS)  + $additional_input_delay ]]

      set ddr_sdc_mode_enum "GROUP_${i_grp_idx}_DDR_SDR_MODE"
      if {$var($ddr_sdc_mode_enum) == "DDR"} {
         set is_ddr 1
      } else {
         set is_ddr 0
      }

      # ------------------------ #
      # -                      - #
      # --- WRITE FIFO CLOCK --- #
      # -                      - #
      # ------------------------ #
      
      set write_fifo_clk [get_keepers -nowarn ${inst}*|core|arch_inst|group_gen[$i_grp_idx].u_phylite_group_tile_20|lane_gen[*].u_lane*~out_phy_reg]
      set write_fifo_clk_neg [get_keepers -nowarn ${inst}*|core|arch_inst|group_gen[$i_grp_idx].u_phylite_group_tile_20|lane_gen[*].u_lane*~out_phy_reg__nff]
      
      set i_wf_clock 0
      foreach_in_collection wf_clock $write_fifo_clk {
         set vco_clock_id [memphy_get_vco_clk_id $wf_clock var]
        if {$vco_clock_id == -1} {
             post_message -type critical_warning "Failed to find VCO clock"
         } else {
            set local_wf_clk_grp_${i_grp_idx}_${i_wf_clock} [ memphy_get_or_add_generated_clock \
              -target [get_node_info -name $wf_clock] \
              -name "${inst}_wf_clk_grp_${i_grp_idx}_${i_wf_clock}" \
              -source [get_node_info -name $vco_clock_id] \
              -multiply_by 1 \
              -divide_by [expr $var(PLL_VCO_TO_MEM_CLK_FREQ_RATIO)] \
              -phase 0 ]
         }	
         incr i_wf_clock	  
      }  
      set i_wf_clock 0
      foreach_in_collection wf_clock $write_fifo_clk_neg {
         set vco_clock_id [memphy_get_vco_clk_id $wf_clock var]
        if {$vco_clock_id == -1} {
             post_message -type critical_warning "Failed to find VCO clock"
         } else {
            set local_wf_clk_grp_${i_grp_idx}_${i_wf_clock} [ memphy_get_or_add_generated_clock \
              -target [get_node_info -name $wf_clock] \
              -name "${inst}_wf_clk_grp_${i_grp_idx}_${i_wf_clock}_neg" \
              -source [get_node_info -name $vco_clock_id] \
              -multiply_by 1 \
              -divide_by [expr $var(PLL_VCO_TO_MEM_CLK_FREQ_RATIO)] \
              -phase 180 ] 
         }	
         incr i_wf_clock	  
      }    

      if {$additional_jitter != 0} {
          set_clock_uncertainty -to [get_clocks ${inst}_wf_clk_grp_*] -add $additional_jitter
      } 

      # ------------------- #
      # -                 - #
      # --- WRITE CLOCK --- #
      # -                 - #
      # ------------------- #

      set master_ck_clock ""
      set write_clocks ""
      foreach { wclk_pin } $pins(wclk,${i_grp_idx}) {
         set master_ck_clock [get_fanins $wclk_pin]
         foreach_in_collection check_pin $master_ck_clock {
            set check_pin_name [get_node_info -name $check_pin]
            if {[regexp {out_phy_reg$} $check_pin_name]} {
               set master_ck_clock $check_pin_name
               break
            }
         }
         create_generated_clock -multiply_by 1 -source $master_ck_clock $wclk_pin -name $wclk_pin	  
         lappend write_clocks $wclk_pin	
      }

      foreach { wclk_pin_n } $pins(wclk_n,${i_grp_idx}) {
         set master_ck_clock [get_fanins $wclk_pin_n]
         foreach_in_collection check_pin $master_ck_clock {
            set check_pin_name [get_node_info -name $check_pin]
            if {[regexp {out_phy_reg__nff$} $check_pin_name]} {
               set master_ck_clock $check_pin_name
               break
            }
         }
         create_generated_clock -multiply_by 1 -source $master_ck_clock $wclk_pin_n -name ${wclk_pin_n}_neg
         lappend write_clocks ${wclk_pin_n}_neg
      }
      
      if {[llength $write_clocks] > 0} {
         lappend io_clocks $write_clocks
      }

      # ------------------ #
      # -                - #
      # --- WRITE PATH --- #
      # -                - #
      # ------------------ #

      
      if {$var(GROUP_${i_grp_idx}_GENERATE_OUTPUT_CONSTRAINT) == "true"} {
         foreach { wclk_pin } $pins(wclk,${i_grp_idx}) {
            foreach { write_pin } $pins(wdata,${i_grp_idx}) {
               set write_port [ get_ports $write_pin ]
               if {[get_collection_size $write_port] > 0} {
                  if [ get_port_info -is_output_port $write_port ] {
                     set_output_delay -min $out_min_delay -clock [get_clocks $wclk_pin] $write_port -add_delay
                     set_output_delay -max $out_max_delay -clock [get_clocks $wclk_pin] $write_port -add_delay

                     if {$is_ddr && [llength $pins(wclk_n,${i_grp_idx})]==0} {
                        set_output_delay -min $out_min_delay -clock [get_clocks "${wclk_pin}"] $write_port -add_delay -clock_fall
                        set_output_delay -max $out_max_delay -clock [get_clocks "${wclk_pin}"] $write_port -add_delay -clock_fall
                     }
                  }
               }
            }
         }
         if {$is_ddr} {
            foreach { wclkn_pin } $pins(wclk_n,${i_grp_idx}) {
               foreach { write_pin } $pins(wdata,${i_grp_idx}) {
                  set write_port [ get_ports $write_pin ]
                  if {[get_collection_size $write_port] > 0} {
                     if [ get_port_info -is_output_port $write_port ] {
                        set_output_delay -min $out_min_delay -clock [get_clocks ${wclkn_pin}_neg] $write_port -add_delay
                        set_output_delay -max $out_max_delay -clock [get_clocks ${wclkn_pin}_neg] $write_port -add_delay
                     }
                  }
               }
            }
         }
         if {[llength $write_clocks]>0} {
            # We don't need derive_clock_uncertainty numbers because we have include FLS JITTER in set_output_delay
            set_clock_uncertainty -to [get_clocks $write_clocks] [memphy_round_3dp [expr 0.5*($var(WR_SSO) + $var(WR_JITTER_SCALED)) + $additional_jitter]]
         }
      }


      # ----------------- #
      # -               - #
      # --- READ PATH --- #
      # -               - #
      # ----------------- #

      set read_clocks ""
      set read_clocks_pos ""
      set read_clocks_neg ""
      foreach { rclk_pin } $pins(rclk,${i_grp_idx}) {
         create_clock -period $var(UI) -waveform [ list 0 $half_period ] $rclk_pin -name ${rclk_pin}_IN -add
         lappend read_clocks_pos ${rclk_pin}_IN
         lappend read_clocks ${rclk_pin}_IN
      }
      foreach { rclkn_pin } $pins(rclk_n,${i_grp_idx}) {
         create_clock -period $var(UI) -waveform [ list $half_period $var(UI) ] $rclkn_pin -name ${rclkn_pin}_IN -add
         lappend read_clocks_neg ${rclkn_pin}_IN
         lappend read_clocks ${rclkn_pin}_IN
      }
      if {[llength $read_clocks_pos]>0 && [llength $read_clocks_neg]>0} {
         set_clock_groups -exclusive -group $read_clocks_pos -group $read_clocks_neg
      }
      if {[llength $read_clocks] > 0} {
         lappend io_clocks $read_clocks
      }
      if {$var(GROUP_${i_grp_idx}_GENERATE_INPUT_CONSTRAINT) == "true"} {
         foreach { read_pin } $pins(rdata,${i_grp_idx}) {
            set_max_delay -from [get_ports $read_pin] 0
            if {$is_ddr} {
               set_min_delay -from [get_ports $read_pin] [expr 0-$half_period]
            } else {
               set_min_delay -from [get_ports $read_pin] [expr 0-$var(UI)]
            }

            foreach { rclk_pin } $pins(rclk,${i_grp_idx}) { 
               set_input_delay -max $in_max_delay -clock [get_clocks ${rclk_pin}_IN ] [get_ports $read_pin] -add_delay
               set_input_delay -min $in_min_delay -clock [get_clocks ${rclk_pin}_IN ] [get_ports $read_pin] -add_delay
               if {[llength $pins(rclk_n,${i_grp_idx})]>0} { 
                  set_false_path -fall_to [get_clocks ${rclk_pin}_IN]
               }
            }

            foreach { rclkn_pin } $pins(rclk_n,${i_grp_idx}) { 
               set_input_delay -max $in_max_delay -clock [get_clocks ${rclkn_pin}_IN ] [get_ports $read_pin] -add_delay
               set_input_delay -min $in_min_delay -clock [get_clocks ${rclkn_pin}_IN ] [get_ports $read_pin] -add_delay
               set_false_path -fall_to [get_clocks ${rclkn_pin}_IN]
            }
         }
         if {[llength $read_clocks]>0} {
            # We don't need derive_clock_uncertainty numbers because we have include FLS JITTER in set_input_delay
            set_clock_uncertainty -to [get_clocks $read_clocks] [memphy_round_3dp [expr 0.5*($var(RD_SSI) + $var(RD_JITTER_SCALED))]]
         }
      }


      if {[llength $pins(wdata,${i_grp_idx})] > 0} {
         # ------------------------------ #
         # -                            - #
         # --- MULTICYCLE CONSTRAINTS --- #
         # -                            - #
         # ------------------------------ #
           
         set wf_clocks [get_clocks ${inst}_wf_clk_grp_${i_grp_idx}_*]
         set wf_clocks_neg [get_clocks ${inst}_wf_clk_grp_${i_grp_idx}_*_neg]
         set wf_clocks_pos [remove_from_collection $wf_clocks $wf_clocks_neg]
         set wclks [concat $pins(wclk,${i_grp_idx}) $pins(wclk_n,${i_grp_idx})]
         if {[llength $wclks] > 0} {
            set wclks_with_neg ""
            foreach iwclk $wclks {
               lappend wclks_with_neg ${iwclk}_neg
            }
            set out_clocks_pos [get_clocks -nowarn $wclks]
            set out_clocks_neg [get_clocks -nowarn $wclks_with_neg]
            set_multicycle_path -from $wf_clocks_pos -to $out_clocks_pos -setup 0
            set_multicycle_path -from $wf_clocks_neg -to $out_clocks_pos -setup 0
            if {$is_ddr} {
               set_multicycle_path -from $wf_clocks_pos -to $out_clocks_pos -hold -1
               set_multicycle_path -from $wf_clocks_neg -to $out_clocks_pos -hold -1
            }
            if {$out_clocks_neg != "" && [get_collection_size $out_clocks_neg] > 0} {
               set_multicycle_path -from $wf_clocks_pos -to $out_clocks_neg -setup 0
               set_multicycle_path -from $wf_clocks_neg -to $out_clocks_neg -setup 0
               if {$is_ddr} {
                  set_multicycle_path -from $wf_clocks_pos -to $out_clocks_neg -hold -1
                  set_multicycle_path -from $wf_clocks_neg -to $out_clocks_neg -hold -1
               }
            }
         } else {
            set out_clocks_pos ""
            set out_clocks_neg ""
         }
   
         set lane_reg [get_keepers -nowarn ${inst}*|core|arch_inst|group_gen[*].u_phylite_group_tile_20|lane_gen[*].u_lane~lane_reg]
         if {[get_collection_size $lane_reg] > 0} {
            if {$fit_flow == 1} {
               set_multicycle_path -to $lane_reg -through ${inst}*|core|arch_inst|group_gen[$i_grp_idx].u_phylite_group_tile_20|lane_gen[*].u_lane|core_dll[2] -setup 8 -end
               set_multicycle_path -to $lane_reg -through ${inst}*|core|arch_inst|group_gen[$i_grp_idx].u_phylite_group_tile_20|lane_gen[*].u_lane|core_dll[2] -hold  7 -end
            } else {
               set_false_path -to $lane_reg -through ${inst}*|core|arch_inst|group_gen[$i_grp_idx].u_phylite_group_tile_20|lane_gen[*].u_lane|core_dll[2]
            }
         }

         # ------------------------------ #
         # -                            - #
         # --- FALSE PATH CONSTRAINTS --- #
         # -                            - #
         # ------------------------------ #

         foreach write_clock $write_clocks {  
            foreach read_clock $read_clocks {  
               set_false_path -to [get_clocks $write_clock] -from [get_clocks $read_clock]
            }
         }         

         if {[get_collection_size $wf_clocks_pos] > 0} {
            set_false_path -fall_from $wf_clocks_pos
         }
         if {[get_collection_size $wf_clocks_neg] > 0} { 
            set_false_path -fall_from $wf_clocks_neg
         }
         if {$is_ddr && $out_clocks_neg != "" && [get_collection_size $out_clocks_neg] > 0} {
            set_false_path -fall_to $out_clocks_neg
            set_false_path -fall_to $out_clocks_pos

            set_false_path -setup -from $wf_clocks_neg -rise_to $out_clocks_pos
            set_false_path -setup -from $wf_clocks_pos -rise_to $out_clocks_neg
            set_false_path -hold -from $wf_clocks_neg -rise_to $out_clocks_neg
            set_false_path -hold -from $wf_clocks_pos -rise_to $out_clocks_pos
         }
         if {$out_clocks_pos != "" && [get_collection_size $out_clocks_pos] > 0} {
            set_false_path -setup -from $wf_clocks_neg -rise_to $out_clocks_pos
            set_false_path -setup -from $wf_clocks_pos -fall_to $out_clocks_pos
            set_false_path -hold -from $wf_clocks_neg -fall_to $out_clocks_pos
            if {$is_ddr} {
               set_false_path -hold -from $wf_clocks_pos -rise_to $out_clocks_pos
            }
         }
      }
   } 
   # end foreach group
   
   # ------------------------- #
   # -                       - #
   # --- CLOCK UNCERTAINTY --- #
   # -                       - #
   # ------------------------- #

   if {($fit_flow == 1 || $sta_flow == 1)} {

      #################################
      # C2P/P2C transfers
      #################################

      # Get P2C / C2P Multi-tile clock uncertainty
      set p2c_c2p_multi_tile_clock_uncertainty [memphy_get_p2c_c2p_clock_uncertainty $inst var]

      # Get extra periphery clock uncertainty
      set periphery_clock_uncertainty [list]
      memphy_get_periphery_clock_uncertainty periphery_clock_uncertainty var

      # Get Fitter overconstraints
      if {$fit_flow == 1} {
         set periphery_overconstraints [list $var(C2P_SETUP_OC_NS) $var(C2P_HOLD_OC_NS) $var(P2C_SETUP_OC_NS) $var(P2C_HOLD_OC_NS)] 
      } else {
         set periphery_overconstraints [list 0.0 0.0 0.0 0.0]
      }

      # Get the master tile name
      set same_tile_index -1
      if {[string compare $inst $pins(master_instname)] == 0} {
         set same_tile_index 0
      }

      # Now loop over core/periphery clocks and set clock uncertainty
      set i_core_clock 0
      foreach core_clock $core_clocks {
         if {$core_clock != ""} {

            set local_core_clock [lindex $core_clocks_local $i_core_clock]

            set i_phy_clock 0
            foreach { phy_clock } $pins(pll_phy_clock_l) {

               if {$i_phy_clock > $same_tile_index} {
                  # C2P/P2C where the periphery tile != CPA tile.
                  # For these transfers the SDC explicitly overrides the clock uncertainty values.
                  # Therefore, when overconstraining we must not use the "-add" option.
                  set add_to_derived ""
                  set c2p_su         [expr {$p2c_c2p_multi_tile_clock_uncertainty + [lindex $periphery_overconstraints 0] + [lindex $periphery_clock_uncertainty 0] + $additional_jitter}]
                  set c2p_h          [expr {$p2c_c2p_multi_tile_clock_uncertainty + [lindex $periphery_overconstraints 1] + [lindex $periphery_clock_uncertainty 1] + $additional_jitter}]
                  set p2c_su         [expr {$p2c_c2p_multi_tile_clock_uncertainty + [lindex $periphery_overconstraints 2] + [lindex $periphery_clock_uncertainty 2] + $additional_jitter}]
                  set p2c_h          [expr {$p2c_c2p_multi_tile_clock_uncertainty + [lindex $periphery_overconstraints 3] + [lindex $periphery_clock_uncertainty 3] + $additional_jitter}]
               } else {
                  # C2P/P2C where the periphery tile == CPA tile
                  # For these transfers it is safe to use the -add option since we rely on 
                  # derive_clock_uncertainty for the base value.
                  set add_to_derived "-add"
                  set c2p_su         [expr [lindex $periphery_overconstraints 0] + [lindex $periphery_clock_uncertainty 0] + $additional_jitter/2]
                  set c2p_h          [expr [lindex $periphery_overconstraints 1] + [lindex $periphery_clock_uncertainty 1] + $additional_jitter/2]
                  set p2c_su         [expr [lindex $periphery_overconstraints 2] + [lindex $periphery_clock_uncertainty 2] + $additional_jitter/2]
                  set p2c_h          [expr [lindex $periphery_overconstraints 3] + [lindex $periphery_clock_uncertainty 3] + $additional_jitter/2]
               }

               set catch_exception [catch {set local_phy_clk_l_${i_phy_clock}} result]
               if {$catch_exception == 0} {
                  set_clock_uncertainty -from [get_clocks $local_core_clock] -to   [get_clocks [set local_phy_clk_l_${i_phy_clock}]] -setup $add_to_derived $c2p_su
                  set_clock_uncertainty -from [get_clocks $local_core_clock] -to   [get_clocks [set local_phy_clk_l_${i_phy_clock}]] -hold  $add_to_derived $c2p_h
                  set_clock_uncertainty -to   [get_clocks $local_core_clock] -from [get_clocks [set local_phy_clk_l_${i_phy_clock}]] -setup $add_to_derived $p2c_su
                  set_clock_uncertainty -to   [get_clocks $local_core_clock] -from [get_clocks [set local_phy_clk_l_${i_phy_clock}]] -hold  $add_to_derived $p2c_h
               }

               set catch_exception [catch {set local_phy_clk_${i_phy_clock}} result]
               if {$catch_exception == 0} {
                  set_clock_uncertainty -from [get_clocks $local_core_clock] -to   [get_clocks [set local_phy_clk_${i_phy_clock}]] -setup $add_to_derived $c2p_su
                  set_clock_uncertainty -from [get_clocks $local_core_clock] -to   [get_clocks [set local_phy_clk_${i_phy_clock}]] -hold  $add_to_derived $c2p_h
                  set_clock_uncertainty -to   [get_clocks $local_core_clock] -from [get_clocks [set local_phy_clk_${i_phy_clock}]] -setup $add_to_derived $p2c_su
                  set_clock_uncertainty -to   [get_clocks $local_core_clock] -from [get_clocks [set local_phy_clk_${i_phy_clock}]] -hold  $add_to_derived $p2c_h
               }

               incr i_phy_clock
            }
         }
         incr i_core_clock
      }

      #################################
      # Within-core transfers
      #################################
	  
      # Get extra core clock uncertainty
      set core_clock_uncertainty [list]
      memphy_get_core_clock_uncertainty core_clock_uncertainty var	  
	  
      # Get Fitter overconstraints
      if {$fit_flow == 1} {
         set core_overconstraints [list $var(C2C_SAME_CLK_SETUP_OC_NS) $var(C2C_SAME_CLK_HOLD_OC_NS) $var(C2C_DIFF_CLK_SETUP_OC_NS) $var(C2C_DIFF_CLK_HOLD_OC_NS)]
      } else {
         set core_overconstraints [list 0.0 0.0 0.0 0.0]
      }

      set c2c_same_su         [expr [lindex $core_overconstraints 0] + [lindex $core_clock_uncertainty 0] + $additional_jitter]
      set c2c_same_h          [expr [lindex $core_overconstraints 1] + [lindex $core_clock_uncertainty 1]]
      set c2c_diff_su         [expr [lindex $core_overconstraints 2] + [lindex $core_clock_uncertainty 2] + $additional_jitter]
      set c2c_diff_h          [expr [lindex $core_overconstraints 3] + [lindex $core_clock_uncertainty 3] + $additional_jitter]      
      
      # For these transfers it is safe to use the -add option of set_clock_uncertainty since
      # we rely on derive_clock_uncertainty for the base value.
      foreach src_core_clock_local $core_clocks_local {
         if {$src_core_clock_local != ""} {
            foreach dst_core_clock_local $core_clocks_local {
               if {$dst_core_clock_local != ""} {
                  if {$src_core_clock_local == $dst_core_clock_local} {
                     # Same clock network transfers
                     set_clock_uncertainty -from $src_core_clock_local -to $dst_core_clock_local -setup -add $c2c_same_su
                     set_clock_uncertainty -from $src_core_clock_local -to $dst_core_clock_local -hold -enable_same_physical_edge -add $c2c_same_h
                  } else {
                     # Transfers between different core clock networks
                     set_clock_uncertainty -from $src_core_clock_local -to $dst_core_clock_local -setup -add $c2c_diff_su
                     set_clock_uncertainty -from $src_core_clock_local -to $dst_core_clock_local -hold -add $c2c_diff_h
                  }
               }
            }
         }
      }

      
   }
   
   # --------------------- #
   # -                   - #
   # --- ACTIVE CLOCKS --- #
   # -                   - #
   # --------------------- #

   if {$var(PHYLITE_USE_DYNAMIC_RECONFIGURATION) == "true" && (($::quartus(nameofexecutable) ne "quartus_fit") && ($::quartus(nameofexecutable) ne "quartus_map"))} {

      set io_clocks [join $io_clocks]
      if {[llength $io_clocks] > 0 && !$debug} {
         post_sdc_message info "Setting I/O clocks of $inst as inactive; use Report DDR to timing analyze I/O clocks"
         set_active_clocks [remove_from_collection [get_active_clocks] [get_clocks $io_clocks]]
      }
   }

   
}


if {$var(PHYLITE_USE_DYNAMIC_RECONFIGURATION) == "true"} {
   add_ddr_report_command "source [list [file join [file dirname [info script]] ${::GLOBAL_corename}_report_timing.tcl]]"
}


