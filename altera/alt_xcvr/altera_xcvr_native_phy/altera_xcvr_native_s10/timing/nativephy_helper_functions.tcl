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


set script_dir [file dirname [info script]]

load_package sdc_ext


#__ACDS_USER_COMMENT__ ###########################################   
#__ACDS_USER_COMMENT__  procedure to initialize database of all pins and registers  

proc nativephy_initialize_db { ddr_db_par var_array_name} {
  #TODO: what are the arguments 

  #TODO: learn about upvar; is this needed 
  upvar $ddr_db_par local_nativephy_db
  upvar 1 $var_array_name var
  #TODO: make the corename global 
  global ::GLOBAL_corename
   
  post_sdc_message info "Initializing NATIVEPHY database for CORE $::GLOBAL_corename"
  set instance_list [nativephy_get_core_instance_list $::GLOBAL_corename]
  
  foreach instname $instance_list {
    post_sdc_message info "Finding port-to-pin mapping for CORE: $::GLOBAL_corename INSTANCE: $instname"
    nativephy_get_pins $instname allpins var

    set local_nativephy_db($instname) [ array get allpins ]
   }
}

#__ACDS_USER_COMMENT__ ###########################################   
#__ACDS_USER_COMMENT__  procedure to get NATIVEPHY instances in TQ   
proc nativephy_get_core_instance_list { corename } {
  #TODO: DO you need full_instance_list and instance list?  
  set full_instance_list [nativephy_get_core_full_instance_list $corename]
  set instance_list [list]
 
  foreach inst $full_instance_list {
    set sta_name [nativephy_get_timequest_name $inst]
    if {[lsearch $instance_list [escape_brackets $sta_name]] == -1} {
      lappend instance_list $sta_name
    }
  }
}

#__ACDS_USER_COMMENT__ ###########################################   
#__ACDS_USER_COMMENT__  procedure to get core instances in TQ  
proc nativephy_get_core_full_instance_list { corename } { 
set allkeepers [get_keepers * ]

   # set show entity name after the collection manager is initialized in get_keepers
   set_project_mode -always_show_entity_name on

   set instance_list [list]

   set inst_regexp {(^.*}
   append inst_regexp {:[A-Za-z0-9\.\\_\[\]\-\$():]+)\|}
   append inst_regexp "${corename}"
   append inst_regexp {:arch|}
   append inst_regexp core_*
   append inst_regexp {:arch_inst}   

   foreach_in_collection keeper $allkeepers {
      set name [ get_node_info -name $keeper ]

      if {[regexp -- $inst_regexp $name -> hier_name] == 1} {
         if {[lsearch $instance_list [escape_brackets $hier_name]] == -1} {
            lappend instance_list $hier_name
         }
      }
   }

   set_project_mode -always_show_entity_name qsf

   if {[ llength $instance_list ] == 0} {
      post_message -type error "The auto-constraining script was not able to detect any instance for core < $corename >"
      post_message -type error "Make sure the core < $corename > is instantiated within another component (wrapper)"
      post_message -type error "and it's not the top-level for your project"
   }

   return $instance_list

} 
# ----------------------------------------------------------------
#
# Description:  Convert the full hierarchy name into a TimeQuest name
#
# ----------------------------------------------------------------
proc nativephy_get_timequest_name { instance } { 
   set sta_name ""
   for {set inst_start [string first ":" $hier_name]} {$inst_start != -1} {} {
      incr inst_start
      set inst_end [string first "|" $hier_name $inst_start]
      if {$inst_end == -1} {
         append sta_name [string range $hier_name $inst_start end]
         set inst_start -1
      } else {
         append sta_name [string range $hier_name $inst_start $inst_end]
         set inst_start [string first ":" $hier_name $inst_end]
      }
   }
   return $sta_name

}

#__ACDS_USER_COMMENT__ ###########################################   
#__ACDS_USER_COMMENT__  procedure to find all pins for a instance

proc nativephy_get_pins { instname allpins} {
  #__ACDS_USER_COMMENT__ ########################################   
  #__ACDS_USER_COMMENT__  1.0 find all of the output clocks
  
  # tx_clkout 
  # rx_clkout
  # tx_divclkout
  # rx_divclkout 

  #__ACDS_USER_COMMENT__  C0 output in the periphery
   set pins(pll_c0_periph_clock) [list]
   set pins(pll_c0_periph_clock_id) [get_nets -nowarn [list ${instname}|arch|arch_inst|pll_inst|pll_lvds_clk\[0\]  ${instname}|arch|arch_inst|pll_inst|pll_inst*LVDS_CLK0]]
   foreach_in_collection c $pins(pll_c0_periph_clock_id) {
      lappend pins(pll_c0_periph_clock) [get_node_info -name $c]
   }
   set pins(pll_c0_periph_clock) [join [lsort -decreasing $pins(pll_c0_periph_clock)]]
}
