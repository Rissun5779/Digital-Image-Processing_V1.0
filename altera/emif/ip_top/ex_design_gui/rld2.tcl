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


package provide altera_emif::ip_top::ex_design_gui::rld2 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::ex_design_gui::rld2:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

   
   variable m_param_prefix "EX_DESIGN_GUI_RLD2"
}


proc ::altera_emif::ip_top::ex_design_gui::rld2::create_parameters {is_top_level_component} {
   variable m_param_prefix
   
   altera_emif::ip_top::ex_design_gui::create_protocol_specifc_common_parameters $m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::ex_design_gui::rld2::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::ex_design_gui::rld2::add_display_items {tabs} {
   variable m_param_prefix
   
   altera_emif::ip_top::ex_design_gui::add_display_items_for_protocol_specific_common_parameters $tabs $m_param_prefix
      
   return 1
}

proc ::altera_emif::ip_top::ex_design_gui::rld2::validate {} {
   variable m_param_prefix
   
   return 1
}


proc ::altera_emif::ip_top::ex_design_gui::rld2::_init {} {
}

::altera_emif::ip_top::ex_design_gui::rld2::_init
