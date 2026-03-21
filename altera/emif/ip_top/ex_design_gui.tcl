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


package provide altera_emif::ip_top::ex_design_gui 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::ex_design_gui:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::util::hwtcl_utils::*


}


proc ::altera_emif::ip_top::ex_design_gui::create_parameters {is_top_level_component} {




   add_derived_param  "EX_DESIGN_GUI_GEN_SIM"                     boolean    true                    false     ""
   add_derived_param  "EX_DESIGN_GUI_GEN_SYNTH"                   boolean    true                    false     ""
   add_derived_param  "EX_DESIGN_GUI_TARGET_DEV_KIT"              string     TARGET_DEV_KIT_NONE     false     ""

   add_derived_param  "EX_DESIGN_GUI_PREV_PRESET"                 string     TARGET_DEV_KIT_NONE     false     ""

   ::altera_emif::ip_top::protocol_expert::create_parameters FUNC_EX_DESIGN_GUI $is_top_level_component

   return 1
}

proc ::altera_emif::ip_top::ex_design_gui::set_family_specific_defaults {family_enum base_family_enum is_hps} {



   ::altera_emif::ip_top::protocol_expert::set_family_specific_defaults FUNC_EX_DESIGN_GUI $family_enum $base_family_enum $is_hps

   return 1
}

proc ::altera_emif::ip_top::ex_design_gui::create_protocol_specifc_common_parameters {param_prefix} {

   add_user_param     "${param_prefix}_SEL_DESIGN"                    string    AVAIL_EX_DESIGNS_GEN_DESIGN   [enum_dropdown_entries AVAIL_EX_DESIGNS]               ""          ""             ""             EX_DESIGN_SEL_DESIGN
   add_user_param     "${param_prefix}_GEN_SIM"                       boolean   true                          ""                                                     ""          ""             ""             EX_DESIGN_GEN_SIM
   add_user_param     "${param_prefix}_GEN_SYNTH"                     boolean   true                          ""                                                     ""          ""             ""             EX_DESIGN_GEN_SYNTH
   add_user_param     "${param_prefix}_HDL_FORMAT"                    string    HDL_FORMAT_VERILOG            [enum_dropdown_entries HDL_FORMAT]                     ""          ""             ""             EX_DESIGN_HDL_FORMAT
   add_user_param     "${param_prefix}_TARGET_DEV_KIT"                string    TARGET_DEV_KIT_NONE           [enum_dropdown_entries TARGET_DEV_KIT]                 ""          ""             ""             EX_DESIGN_TARGET_DEV_KIT

   add_user_param     "${param_prefix}_PREV_PRESET"                   string    TARGET_DEV_KIT_NONE           [enum_dropdown_entries TARGET_DEV_KIT]                 ""          ""             ""             EX_DESIGN_PREV_PRESET




   return 1
}

proc ::altera_emif::ip_top::ex_design_gui::add_display_items {tabs} {

   set ex_design_tab [lindex $tabs 0]

   set avail_designs_grp [get_string GRP_EX_DESIGN_AVAIL_DESIGNS_NAME]
   set files_grp [get_string GRP_EX_DESIGN_FILES_NAME]
   set hdl_format_grp [get_string GRP_EX_DESIGN_HDL_FORMAT_NAME]
   set target_dev_kit_grp [get_string GRP_EX_DESIGN_TARGET_DEV_KIT_NAME]
   set ex_design_settings_grp [get_string GRP_EX_DESIGN_SETTINGS_NAME]

   add_display_item $ex_design_tab $avail_designs_grp GROUP
   add_display_item $ex_design_tab $files_grp GROUP
   add_display_item $ex_design_tab $hdl_format_grp GROUP
   add_display_item $ex_design_tab $target_dev_kit_grp GROUP
   add_display_item $ex_design_tab $ex_design_settings_grp GROUP

   ::altera_emif::ip_top::protocol_expert::add_display_items FUNC_EX_DESIGN_GUI $tabs

   return 1
}

proc ::altera_emif::ip_top::ex_design_gui::add_display_items_for_protocol_specific_common_parameters {tabs param_prefix} {

   set ex_design_tab [lindex $tabs 0]

   set avail_designs_grp [get_string GRP_EX_DESIGN_AVAIL_DESIGNS_NAME]
   set files_grp [get_string GRP_EX_DESIGN_FILES_NAME]
   set hdl_format_grp [get_string GRP_EX_DESIGN_HDL_FORMAT_NAME]
   set target_dev_kit_grp [get_string GRP_EX_DESIGN_TARGET_DEV_KIT_NAME]
   set ex_design_settings_grp [get_string GRP_EX_DESIGN_SETTINGS_NAME]

   add_param_to_gui $avail_designs_grp "${param_prefix}_SEL_DESIGN"

   add_param_to_gui $files_grp "${param_prefix}_GEN_SIM"
   add_param_to_gui $files_grp "${param_prefix}_GEN_SYNTH"
   add_display_item $files_grp "DESIGN_FILES_GUIDE_TEXT" TEXT [get_string TXT_DESIGN_FILES_GUIDE]

   add_param_to_gui $hdl_format_grp "${param_prefix}_HDL_FORMAT"

   add_param_to_gui $target_dev_kit_grp "${param_prefix}_TARGET_DEV_KIT"
   add_display_item $target_dev_kit_grp "EX_DESIGN_SEL_FAMILY_DEVICE_TEXT" TEXT "None"
   add_display_item $target_dev_kit_grp "EX_DESIGN_GUIDING_TEXT" TEXT [get_string TXT_EX_DESIGN_GUIDE]

   add_param_to_gui $target_dev_kit_grp "${param_prefix}_PREV_PRESET"
   set_parameter_property "${param_prefix}_PREV_PRESET" VISIBLE false

   return 1
}

proc ::altera_emif::ip_top::ex_design_gui::validate {} {

   ::altera_emif::ip_top::protocol_expert::validate FUNC_EX_DESIGN_GUI

   set ex_design_param_prefix [_get_protocol_specific_param_prefix "EX_DESIGN_GUI"]

   set sim_supported [get_parameter_value MEM_HAS_SIM_SUPPORT]

   set generate_simulation [get_parameter_value "${ex_design_param_prefix}_GEN_SIM"]
   set generate_synthesis [get_parameter_value "${ex_design_param_prefix}_GEN_SYNTH"]

   set_parameter_property "${ex_design_param_prefix}_GEN_SIM" ENABLED $sim_supported
   if {!$sim_supported} {
      set generate_simulation $sim_supported
      set_parameter_value EX_DESIGN_GUI_GEN_SIM $generate_simulation
   }

   set target_dev_kit [get_parameter_value "${ex_design_param_prefix}_TARGET_DEV_KIT"]

   set default_devkit [get_parameter_property EX_DESIGN_GUI_TARGET_DEV_KIT DEFAULT_VALUE]

   if {[get_is_hps]} {
      set generate_synthesis false
      set_parameter_value EX_DESIGN_GUI_GEN_SYNTH $generate_synthesis
      set_parameter_property "${ex_design_param_prefix}_GEN_SYNTH" ENABLED $generate_synthesis
   }

   set_parameter_property "${ex_design_param_prefix}_TARGET_DEV_KIT" ENABLED $generate_synthesis
   if {!$generate_synthesis} {
      set target_dev_kit $default_devkit
      set_parameter_value EX_DESIGN_GUI_TARGET_DEV_KIT $default_devkit
   }


   set target_dev_kit_family [enum_data $target_dev_kit FAMILY]
   set target_dev_kit_device [enum_data $target_dev_kit DEVICE]
   set target_dev_kit_name [enum_data $target_dev_kit DEVKIT_NAME]

   set selected_device [get_device]
   if {$selected_device == ""} {
      set selected_device "Unknown"
   }

   set prev_applied_preset [get_parameter_value "${ex_design_param_prefix}_PREV_PRESET"]
   set family_device_text ""
   if {$target_dev_kit != $default_devkit} {
      set family_device_text "Family: $target_dev_kit_family Device: $target_dev_kit_device"

      set target_devkit_ui_name [enum_data $target_dev_kit UI_NAME]
      post_ipgen_w_msg MSG_DEVKIT_BOARD_SELECTED [list $target_devkit_ui_name]

      if {$target_dev_kit_device != $selected_device} {
         post_ipgen_w_msg MSG_DEVKIT_DEVICE_MISMATCH [list $selected_device $target_dev_kit_name $target_dev_kit_device]
      }

      if {$prev_applied_preset != $target_dev_kit} {
         set preset_devkit_ui_name [enum_data $prev_applied_preset UI_NAME]
         if {$prev_applied_preset != $default_devkit} {
            post_ipgen_e_msg MSG_DEVKIT_PRESET_MISMATCH [list $target_devkit_ui_name $preset_devkit_ui_name]
         }  else {
            post_ipgen_e_msg MSG_DEVKIT_PRESET_MISSING [list $target_devkit_ui_name $preset_devkit_ui_name]
         }
      }
   } else {
      set family_device_text [get_string TXT_EX_DESIGN_DEVKIT_NONE]
   }
   set_display_item_property "EX_DESIGN_SEL_FAMILY_DEVICE_TEXT" TEXT $family_device_text

   return 1
}


proc ::altera_emif::ip_top::ex_design_gui::_get_protocol_specific_param_prefix {package_prefix} {
   set protocol_enum  [get_parameter_value "PROTOCOL_ENUM"]
   set module_name    [string toupper [enum_data $protocol_enum MODULE_NAME]]
   return "${package_prefix}_${module_name}"
}

proc ::altera_emif::ip_top::ex_design_gui::_init {} {
}

::altera_emif::ip_top::ex_design_gui::_init
