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


package provide altera_emif::ip_top::mem 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::ip_top::protocol_expert

namespace eval ::altera_emif::ip_top::mem:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

   
}


proc ::altera_emif::ip_top::mem::create_parameters {is_top_level_component} {

   add_derived_param  "MEM_FORMAT_ENUM"               string     ""       false
   add_derived_param  "MEM_READ_LATENCY"              float      -1       false   
   add_derived_param  "MEM_WRITE_LATENCY"             integer    -1       false   
   add_derived_param  "MEM_BURST_LENGTH"              integer    -1       false
   add_derived_param  "MEM_DATA_MASK_EN"              boolean    true     false
   add_derived_param  "MEM_HAS_SIM_SUPPORT"           boolean    true     false
   add_derived_param  "MEM_NUM_OF_LOGICAL_RANKS"      integer    1        false
   
   add_derived_param  "MEM_TTL_DATA_WIDTH"            integer    -1       false
   add_derived_param  "MEM_TTL_NUM_OF_READ_GROUPS"    integer    -1       false
   add_derived_param  "MEM_TTL_NUM_OF_WRITE_GROUPS"   integer    -1       false
      
   ::altera_emif::ip_top::protocol_expert::create_parameters FUNC_MEM $is_top_level_component
   
   return 1
}

proc ::altera_emif::ip_top::mem::set_family_specific_defaults {family_enum base_family_enum is_hps} {

   
   
   ::altera_emif::ip_top::protocol_expert::set_family_specific_defaults FUNC_MEM $family_enum $base_family_enum $is_hps
   
   return 1
}

proc ::altera_emif::ip_top::mem::add_display_items {tabs} {

   set mem_params_tab [lindex $tabs 0]
   set mem_io_tab [lindex $tabs 1]
   set mem_timing_tab [lindex $tabs 2]

   set topology_grp    [get_string GRP_MEM_TOPOLOGY_NAME]
   set lat_grp         [get_string GRP_MEM_LATENCY_NAME]
   set mrs_grp         [get_string GRP_MEM_MRS_NAME]
   set crs_grp         [get_string GRP_MEM_CRS_NAME]
   set io_grp          [get_string GRP_MEM_IO_NAME]
   set rlrdimm_spd_grp [get_string GRP_MEM_RLRDIMM_SPD_NAME]

   add_display_item $mem_params_tab $topology_grp GROUP
   add_display_item $mem_params_tab $lat_grp GROUP
   add_display_item $mem_params_tab $mrs_grp GROUP
   add_display_item $mem_params_tab $crs_grp GROUP
   add_display_item $mem_io_tab $io_grp GROUP
   add_display_item $mem_io_tab $rlrdimm_spd_grp GROUP
   
   ::altera_emif::ip_top::protocol_expert::add_display_items FUNC_MEM $tabs
   
   return 1
}

proc ::altera_emif::ip_top::mem::validate {} {
   set protocol_enum [get_parameter_value "PROTOCOL_ENUM"]

   if {$protocol_enum == "PROTOCOL_DDR3" || $protocol_enum == "PROTOCOL_DDR4" || $protocol_enum == "PROTOCOL_LPDDR3"} {
      set show_mem_io_tab 1
   } else {
      set show_mem_io_tab 0
   }
   set_display_item_property [get_string TAB_MEM_IO_NAME] VISIBLE $show_mem_io_tab

   set support_sim [get_feature_support_level FEATURE_RTL_SIM $protocol_enum RATE_INVALID]
   set_parameter_value MEM_HAS_SIM_SUPPORT $support_sim
   
   ::altera_emif::ip_top::protocol_expert::validate FUNC_MEM

   return 1
}


proc ::altera_emif::ip_top::mem::_init {} {
}

::altera_emif::ip_top::mem::_init
