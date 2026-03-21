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


package provide altera_phylite::ip_arch_nd::sdc 0.1

package require altera_phylite::ip_arch_nd::main

namespace eval ::altera_phylite::ip_arch_nd::sdc:: {
   variable ref_clk_name "ref_clk"
   

}


proc ::altera_phylite::ip_arch_nd::sdc::generate_sdc_file {phylite_inst_name} {
   set sdc_content ""

   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]

   append sdc_content [::altera_phylite::ip_arch_nd::sdc::_generate_header]
   append sdc_content [::altera_phylite::ip_arch_nd::sdc::_generate_user_variables $phylite_inst_name]
   append sdc_content [::altera_phylite::ip_arch_nd::sdc::_generate_sdc_flow_check]
   append sdc_content [::altera_phylite::ip_arch_nd::sdc::_generate_common_clocks]

   append sdc_content [::altera_phylite::ip_arch_nd::sdc::_generate_phy_clocks 0]

   append sdc_content [::altera_phylite::ip_arch_nd::sdc::_cut_paths]

   return $sdc_content
}


proc ::altera_phylite::ip_arch_nd::sdc::_generate_header {} {
   set sdc_content ""

   append sdc_content "##########################################################################################\n"
   append sdc_content "# Automatically Generated Altera PHYLite SDC File\n"
   append sdc_content "# This file is a reference for creating your own SDC constraints\n"
   append sdc_content "# and cannot just be used out-of-the-box\n"
   append sdc_content "# Most of the constraints are applicable to any PHY IP, but will likely need\n"
   append sdc_content "# to be modified to suit the requirements specific to the system the IP is instantiated in\n"
   append sdc_content "##########################################################################################\n"
   append sdc_content "\n"

   return $sdc_content
}

proc ::altera_phylite::ip_arch_nd::sdc::_generate_user_variables {phylite_inst_name} {
   set sdc_content ""

   append sdc_content "##########################################################################################\n"
   append sdc_content "# Modifiable user variables\n"
   append sdc_content "# If using this SDC file as a template, change these values to match your design.\n"
   append sdc_content "##########################################################################################\n"
   append sdc_content "set phylite_instance_path \"${phylite_inst_name}\"\n"
   append sdc_content "set ref_ck_pin \"ref_clk_clock_sink_clk\" \n"
   append sdc_content "\n"

   return $sdc_content
}

proc ::altera_phylite::ip_arch_nd::sdc::_generate_sdc_flow_check {} {
   set sdc_content ""

   append sdc_content "##########################################################################################\n"
   append sdc_content "# Determine when SDC is being loaded\n"
   append sdc_content "##########################################################################################\n"
   append sdc_content "set syn_flow 0\n"
   append sdc_content "set sta_flow 0\n"
   append sdc_content "set fit_flow 0\n"
   append sdc_content "if { \$::TimeQuestInfo(nameofexecutable) == \"quartus_map\" } {\n"
   append sdc_content "        set syn_flow 1\n"
   append sdc_content "} elseif { \$::TimeQuestInfo(nameofexecutable) == \"quartus_sta\" } {\n"
   append sdc_content "        set sta_flow 1\n"
   append sdc_content "} elseif { \$::TimeQuestInfo(nameofexecutable) == \"quartus_fit\" } {\n"
   append sdc_content "        set fit_flow 1\n"
   append sdc_content "}\n"
   append sdc_content "\n"

   return $sdc_content
}

proc ::altera_phylite::ip_arch_nd::sdc::_generate_common_clocks {} {
   variable ref_clk_name

   set sdc_content ""

   append sdc_content "##########################################################################################\n"
   append sdc_content "# Create Common Clocks\n"
   append sdc_content "##########################################################################################\n"

   append sdc_content "set core_ck_name \"\${phylite_instance_path}|core|arch_inst|pll_inst|pll_inst|outclk\\\[1\\\]\"\n"
   append sdc_content "\n"

   set ref_clock_mhz [get_parameter_value PHYLITE_REF_CLK_FREQ_MHZ]
   set ref_clock_ns [expr 1000.0 / $ref_clock_mhz]
   append sdc_content "set ref_clock_period_ns [format "%.3f" $ref_clock_ns] \n"
   append sdc_content "create_clock -name ${ref_clk_name} -period \$ref_clock_period_ns \$ref_ck_pin \n"
   append sdc_content "\n"

   append sdc_content "derive_pll_clocks \n"
   append sdc_content "\n"

   return $sdc_content
}

proc ::altera_phylite::ip_arch_nd::sdc::_generate_ref_clock {} {
   set sdc_content ""


   return $sdc_content
}

proc ::altera_phylite::ip_arch_nd::sdc::_generate_phy_clocks {grp_idx} {
   set sdc_content ""

   set m_bypass      [get_parameter_value PLL_M_COUNTER_BYPASS_EN]
   set fb_high       [get_parameter_value PLL_PHYCLK_FB_HIGH     ]
   set fb_low        [get_parameter_value PLL_PHYCLK_FB_LOW      ]
   set m_high        [get_parameter_value PLL_M_COUNTER_HIGH     ]
   set m_low         [get_parameter_value PLL_M_COUNTER_LOW      ]
   set phyclk_0_high [get_parameter_value PLL_PHYCLK_0_HIGH      ]
   set phyclk_0_low  [get_parameter_value PLL_PHYCLK_0_LOW       ]
   set phyclk_1_high [get_parameter_value PLL_PHYCLK_1_HIGH      ]
   set phyclk_1_low  [get_parameter_value PLL_PHYCLK_1_LOW       ]

   set m_mult [expr { ${m_high}        + ${m_low}        } ]
   if {[string compare -nocase $m_bypass "true"] == 0} {
      set m_mult 1
   }

   set mult  [expr { (${fb_high}       + ${fb_low}) * ${m_mult} } ]
   set div_0 [expr {  ${phyclk_0_high} + ${phyclk_0_low}        } ]
   set div_1 [expr {  ${phyclk_1_high} + ${phyclk_1_low}        } ]


   append sdc_content "##########################################################################################\n"
   append sdc_content "# Name PHY Clocks\n"
   append sdc_content "##########################################################################################\n"
   append sdc_content "set phy_clk_0 \"\${phylite_instance_path}|core|arch_inst|pll_inst|pll_inst*|loaden\\\[0\\\]\"\n"
   append sdc_content "set phy_clk_1 \"\${phylite_instance_path}|core|arch_inst|pll_inst|pll_inst*|lvds_clk\\\[0\\\]\"\n"

   append sdc_content "\n"

   return $sdc_content
}

proc ::altera_phylite::ip_arch_nd::sdc::_cut_paths {} {
   set sdc_content ""


   append sdc_content "##########################################################################################\n"
   append sdc_content "# Core to Periphery timing is preliminary. Cutting C2P and P2C paths from reports\n"
   append sdc_content "##########################################################################################\n"
   append sdc_content "if { \${sta_flow} == 1 } {\n"
   append sdc_content "\tset_false_path -setup -hold -from \$phy_clk_0\n"
   append sdc_content "\tset_false_path -setup -hold -to \$phy_clk_0\n"
   append sdc_content "\tset_false_path -setup -hold -from \$phy_clk_1\n"
   append sdc_content "\tset_false_path -setup -hold -to \$phy_clk_1\n"
   append sdc_content "}\n"

   append sdc_content "\n"

   return $sdc_content
}

proc ::altera_phylite::ip_arch_nd::sdc::_cut_c2p_paths {grp_idx} {
   set sdc_content ""

   set num_lanes [::altera_phylite::ip_arch_nd::sdc::_get_num_lanes_in_grp $grp_idx]

   for {set i 0 } { $i < ${num_lanes} } {incr i } {
      append sdc_content "\tset_false_path -setup -hold -from grp_${grp_idx}_lane_${i}_phy_clk_0\n"
      append sdc_content "\tset_false_path -setup -hold -to grp_${grp_idx}_lane_${i}_phy_clk_0\n"
      append sdc_content "\tset_false_path -setup -hold -from grp_${grp_idx}_lane_${i}_phy_clk_1\n"
      append sdc_content "\tset_false_path -setup -hold -to grp_${grp_idx}_lane_${i}_phy_clk_1\n"
   }

   append sdc_content "\n"

   return $sdc_content
}

proc ::altera_phylite::ip_arch_nd::sdc::_get_num_lanes_in_grp {grp_idx} {
   set num_data_pins [get_parameter_value "GROUP_${grp_idx}_PIN_WIDTH"]
   set num_strobes   [::altera_phylite::ip_arch_nd::main::get_num_strobes_in_grp $grp_idx]
   set total_num_pins [expr { ${num_data_pins} + ${num_strobes} } ]
   set num_lanes [expr { floor(${total_num_pins} / 12) + 1 } ]

   return $num_lanes
}
