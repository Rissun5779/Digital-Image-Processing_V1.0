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


package provide altera_phylite::ip_top::group 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_phylite::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_phylite::util::enum_defs
package require altera_emif::util::device_family

namespace eval ::altera_phylite::ip_top::group:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_phylite::util::enum_defs
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_phylite::util::hwtcl_utils::*
   namespace import ::altera_emif::util::hwtcl_utils::*


   variable m_param_prefix "GROUP"
   variable max_num_groups 18
}


proc ::altera_phylite::ip_top::group::create_parameters {grp_idx} {
   variable m_param_prefix

   set param_prefix "${m_param_prefix}_${grp_idx}"
   add_group_derived_param        "${param_prefix}_OCT_MODE"                       string     ""            false                                   $grp_idx      ""               ""             ""             ""

   add_group_gui_param_useable    "${param_prefix}_PARAM_COPY"                     boolean    false         ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_PARAM_COPY"
   add_group_gui_param_useable    "${param_prefix}_PARAM_COPY_GROUP"               integer    0             {0}                                     $grp_idx      ""               ""             ""             "${m_param_prefix}_PARAM_COPY_GROUP"
   add_group_gui_param_useable    "${param_prefix}_PIN_TYPE"                       string     BIDIR         [enum_dropdown_entries PIN_TYPE]        $grp_idx      ""               ""             ""             "${m_param_prefix}_PIN_TYPE"
   add_group_gui_param_useable    "${param_prefix}_PIN_WIDTH"                      integer    9             {1:48}                                  $grp_idx      ""               ""             ""             "${m_param_prefix}_PIN_WIDTH"
   add_group_gui_param_useable    "${param_prefix}_DDR_SDR_MODE"                   string     DDR           [enum_dropdown_entries DDR_SDR_MODE]    $grp_idx      ""               ""             ""             "${m_param_prefix}_DDR_SDR_MODE"
   add_group_gui_param_useable    "${param_prefix}_DATA_CONFIG"                    string     SGL_ENDED     [enum_dropdown_entries DATA_CONFIG]     $grp_idx      ""               ""             ""             "${m_param_prefix}_DATA_CONFIG"
   add_group_gui_param_useable    "${param_prefix}_STROBE_CONFIG"                  string     SINGLE_ENDED  [enum_dropdown_entries STROBE_CONFIG]   $grp_idx      ""               ""             ""             "${m_param_prefix}_STROBE_CONFIG"
   add_group_gui_param_useable    "${param_prefix}_READ_LATENCY"                   integer    7             {1:63}                                  $grp_idx      ""               ""             ""             "${m_param_prefix}_READ_LATENCY"
   add_group_gui_param_useable    "${param_prefix}_USE_INTERNAL_CAPTURE_STROBE"    boolean    false         ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_USE_INTERNAL_CAPTURE_STROBE"
   add_group_gui_param_useable    "${param_prefix}_CAPTURE_PHASE_SHIFT"            integer    90            {0 45 90 135 180}                       $grp_idx      ""               ""             ""             "${m_param_prefix}_CAPTURE_PHASE_SHIFT"
   add_group_gui_param_useable    "${param_prefix}_WRITE_LATENCY"                  integer    0             {0:3}                                   $grp_idx      ""               ""             ""             "${m_param_prefix}_WRITE_LATENCY"
   add_group_gui_param_useable    "${param_prefix}_USE_OUTPUT_STROBE"              boolean    true          ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_USE_OUTPUT_STROBE"
   add_group_gui_param_useable    "${param_prefix}_OUTPUT_STROBE_PHASE"            integer    90            {0 45 90 135 180}                       $grp_idx      ""               ""             ""             "${m_param_prefix}_OUTPUT_STROBE_PHASE"
   add_group_gui_param_useable    "${param_prefix}_USE_SEPARATE_STROBES"           boolean    false         ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_USE_SEPARATE_STROBES"
   add_group_gui_param_useable    "${param_prefix}_SWAP_CAPTURE_STROBE_POLARITY"   boolean    false         ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_SWAP_CAPTURE_STROBE_POLARITY"
   add_group_gui_param_useable    "${param_prefix}_OCT_SIZE"               	   integer    1      	    {0:15}          			    $grp_idx      ""               ""             ""             "${m_param_prefix}_OCT_SIZE"
   add_group_gui_param_useable    "${param_prefix}_DEFAULT_OCT"                    boolean    true          ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_DEFAULT_OCT"
   add_group_gui_param_useable    "${param_prefix}_USER_IN_OCT_ENUM"               string     IN_OCT_0      [enum_dropdown_entries IN_OCT]          $grp_idx      ""               ""             ""             "${m_param_prefix}_IN_OCT"
   add_group_gui_param_useable    "${param_prefix}_USER_OUT_OCT_ENUM"              string     OUT_OCT_0     [enum_dropdown_entries OUT_OCT]         $grp_idx      ""               ""             ""             "${m_param_prefix}_OUT_OCT"
   add_group_gui_param_useable    "${param_prefix}_T_IN_DS"                        float      0.030         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_T_IN_DS"
   add_group_gui_param_useable    "${param_prefix}_T_IN_DH"                        float      0.030         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_T_IN_DH"
   add_group_gui_param_useable    "${param_prefix}_T_OUT_DS"                       float      0.030         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_T_OUT_DS"
   add_group_gui_param_useable    "${param_prefix}_T_OUT_DH"                       float      0.030         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_T_OUT_DH"
   add_group_gui_param_useable    "${param_prefix}_GENERATE_OUTPUT_CONSTRAINT"     boolean    true          ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_GENERATE_OUTPUT_CONSTRAINT"
   add_group_gui_param_useable    "${param_prefix}_GENERATE_INPUT_CONSTRAINT"      boolean    true          ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_GENERATE_INPUT_CONSTRAINT"

   add_group_gui_param_useable    "${param_prefix}_READ_DESKEW_MODE"               string     PER_BIT_DESKEW [enum_dropdown_entries DESKEW_TYPE]    $grp_idx      ""               ""             ""             "${m_param_prefix}_READ_DESKEW_MODE"
   add_group_gui_param_useable    "${param_prefix}_WRITE_DESKEW_MODE"              string     PER_BIT_DESKEW [enum_dropdown_entries DESKEW_TYPE]    $grp_idx      ""               ""             ""             "${m_param_prefix}_WRITE_DESKEW_MODE"
   add_group_gui_param_useable    "${param_prefix}_READ_ISI"                       float      0.090         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_READ_ISI"
   add_group_gui_param_useable    "${param_prefix}_WRITE_ISI"                      float      0.090         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_WRITE_ISI"
   add_group_gui_param_useable    "${param_prefix}_READ_SU_DESKEW_CUSTOM"          float      0.000         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_READ_SU_DESKEW_CUSTOM"
   add_group_gui_param_useable    "${param_prefix}_READ_HD_DESKEW_CUSTOM"          float      0.000         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_READ_HD_DESKEW_CUSTOM"
   add_group_gui_param_useable    "${param_prefix}_WRITE_SU_DESKEW_CUSTOM"         float      0.000         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_WRITE_SU_DESKEW_CUSTOM"
   add_group_gui_param_useable    "${param_prefix}_WRITE_HD_DESKEW_CUSTOM"         float      0.000         {-100.0:100.0}                          $grp_idx      "Nanoseconds"    "ns"           ""             "${m_param_prefix}_WRITE_HD_DESKEW_CUSTOM"

   add_group_gui_param_unuseable  "${param_prefix}_IN_OCT_ENUM"                    string     ""            ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_IN_OCT_ENUM"
   add_group_gui_param_unuseable  "${param_prefix}_OUT_OCT_ENUM"                   string     ""            ""                                      $grp_idx      ""               ""             ""             "${m_param_prefix}_OUT_OCT_ENUM"

   set_parameter_property "GUI_${param_prefix}_READ_LATENCY"         DISPLAY_UNITS "external interface clock cycles"
   set_parameter_property "GUI_${param_prefix}_CAPTURE_PHASE_SHIFT"  DISPLAY_UNITS "degrees"
   set_parameter_property "GUI_${param_prefix}_WRITE_LATENCY"        DISPLAY_UNITS "external interface clock cycles"
   set_parameter_property "GUI_${param_prefix}_OUTPUT_STROBE_PHASE"  DISPLAY_UNITS "degrees"
   set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP"     ALLOWED_RANGES {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17}

   set_parameter_update_callback "GUI_${param_prefix}_DEFAULT_OCT"       ::altera_phylite::ip_top::group::_set_user_oct_to_default ${grp_idx}
   set_parameter_update_callback "GUI_${param_prefix}_PARAM_COPY"        ::altera_phylite::ip_top::group::_update_copy_groups ${grp_idx}
   return 1
}

proc ::altera_phylite::ip_top::group::add_display_items {tabs grp_idx} {
   variable m_param_prefix

   set param_prefix "${m_param_prefix}_${grp_idx}"
   set grp_tab [lindex $tabs 0]

   set param_grp  [get_string "GRP_GROUP_${grp_idx}_PARAM_NAME" ]
   set pin_grp    [get_string "GRP_GROUP_${grp_idx}_PIN_NAME"   ]
   set input_grp  [get_string "GRP_GROUP_${grp_idx}_INPUT_NAME" ]
   set output_grp [get_string "GRP_GROUP_${grp_idx}_OUTPUT_NAME"]
   set data_grp   [get_string "GRP_GROUP_${grp_idx}_DATA_NAME"  ]
   set strb_grp   [get_string "GRP_GROUP_${grp_idx}_STRB_NAME"  ]
   set oct_grp    [get_string "GRP_GROUP_${grp_idx}_OCT_NAME"   ]
   set timing_grp [get_string "GRP_GROUP_${grp_idx}_TIMING_NAME"]
   set dyn_tmg_grp [get_string "GRP_GROUP_${grp_idx}_DYN_RECONFIG_TIMING_NAME"]

   add_display_item $grp_tab $param_grp  GROUP
   add_display_item $grp_tab $pin_grp    GROUP
   add_display_item $grp_tab $input_grp  GROUP
   add_display_item $grp_tab $output_grp GROUP
   add_display_item $grp_tab $data_grp   GROUP
   add_display_item $grp_tab $strb_grp   GROUP
   add_display_item $grp_tab $oct_grp    GROUP
   add_display_item $grp_tab $timing_grp GROUP
   add_display_item $grp_tab $dyn_tmg_grp GROUP

   add_param_to_gui_with_shadow $param_grp   "GUI_${param_prefix}_PARAM_COPY"
   add_param_to_gui_with_shadow $param_grp   "GUI_${param_prefix}_PARAM_COPY_GROUP"
   add_param_to_gui_with_shadow $pin_grp     "GUI_${param_prefix}_PIN_TYPE"
   add_param_to_gui_with_shadow $pin_grp     "GUI_${param_prefix}_PIN_WIDTH"
   add_param_to_gui_with_shadow $pin_grp     "GUI_${param_prefix}_DDR_SDR_MODE"
   add_param_to_gui_with_shadow $input_grp   "GUI_${param_prefix}_READ_LATENCY"
   add_param_to_gui_with_shadow $input_grp   "GUI_${param_prefix}_USE_INTERNAL_CAPTURE_STROBE"
   add_param_to_gui_with_shadow $input_grp   "GUI_${param_prefix}_SWAP_CAPTURE_STROBE_POLARITY"
   add_param_to_gui_with_shadow $input_grp   "GUI_${param_prefix}_CAPTURE_PHASE_SHIFT"
   add_param_to_gui_with_shadow $output_grp  "GUI_${param_prefix}_WRITE_LATENCY"
   add_param_to_gui_with_shadow $output_grp  "GUI_${param_prefix}_USE_OUTPUT_STROBE"
   add_param_to_gui_with_shadow $output_grp  "GUI_${param_prefix}_OUTPUT_STROBE_PHASE"
   add_param_to_gui_with_shadow $data_grp    "GUI_${param_prefix}_DATA_CONFIG"
   add_param_to_gui_with_shadow $strb_grp    "GUI_${param_prefix}_STROBE_CONFIG"
   add_param_to_gui_with_shadow $strb_grp    "GUI_${param_prefix}_USE_SEPARATE_STROBES"
   add_param_to_gui_with_shadow $oct_grp     "GUI_${param_prefix}_OCT_SIZE"
   add_param_to_gui_with_shadow $oct_grp     "GUI_${param_prefix}_DEFAULT_OCT"
   add_param_to_gui_with_shadow $oct_grp     "GUI_${param_prefix}_IN_OCT_ENUM"
   add_param_to_gui_with_shadow $oct_grp     "GUI_${param_prefix}_USER_IN_OCT_ENUM"
   add_param_to_gui_with_shadow $oct_grp     "GUI_${param_prefix}_OUT_OCT_ENUM"
   add_param_to_gui_with_shadow $oct_grp     "GUI_${param_prefix}_USER_OUT_OCT_ENUM"
   add_param_to_gui_with_shadow $timing_grp  "GUI_${param_prefix}_GENERATE_INPUT_CONSTRAINT"
   add_param_to_gui_with_shadow $timing_grp  "GUI_${param_prefix}_T_IN_DS"
   add_param_to_gui_with_shadow $timing_grp  "GUI_${param_prefix}_T_IN_DH"
   add_param_to_gui_with_shadow $timing_grp  "GUI_${param_prefix}_READ_ISI"
   add_param_to_gui_with_shadow $timing_grp  "GUI_${param_prefix}_GENERATE_OUTPUT_CONSTRAINT"
   add_param_to_gui_with_shadow $timing_grp  "GUI_${param_prefix}_T_OUT_DS"
   add_param_to_gui_with_shadow $timing_grp  "GUI_${param_prefix}_T_OUT_DH"
   add_param_to_gui_with_shadow $timing_grp  "GUI_${param_prefix}_WRITE_ISI"

   add_param_to_gui_with_shadow $dyn_tmg_grp  "GUI_${param_prefix}_READ_DESKEW_MODE" 
   add_param_to_gui_with_shadow $dyn_tmg_grp  "GUI_${param_prefix}_READ_SU_DESKEW_CUSTOM"
   add_param_to_gui_with_shadow $dyn_tmg_grp  "GUI_${param_prefix}_READ_HD_DESKEW_CUSTOM"

   add_param_to_gui_with_shadow $dyn_tmg_grp  "GUI_${param_prefix}_WRITE_DESKEW_MODE"
   add_param_to_gui_with_shadow $dyn_tmg_grp  "GUI_${param_prefix}_WRITE_SU_DESKEW_CUSTOM"
   add_param_to_gui_with_shadow $dyn_tmg_grp  "GUI_${param_prefix}_WRITE_HD_DESKEW_CUSTOM"


   return 1
}

proc ::altera_phylite::ip_top::group::validate {grp_idx grp_used} {
   variable m_param_prefix
   set param_prefix "${m_param_prefix}_${grp_idx}"
   set param_copy     [get_parameter_value "GUI_${param_prefix}_PARAM_COPY"]

   if {[_safe_string_compare $param_copy "false"]} {
      set family [get_parameter_value SYS_INFO_DEVICE_FAMILY]
      if { $family == "Arria 10" } {
          set_parameter_property "GUI_${param_prefix}_OCT_SIZE" ALLOWED_RANGES "0:4"
      }
      set pin_type         [get_parameter_value "GUI_${param_prefix}_PIN_TYPE"                   ]
      set pin_width        [get_parameter_value "GUI_${param_prefix}_PIN_WIDTH"                  ]
      set ddr_sdr_mode     [get_parameter_value "GUI_${param_prefix}_DDR_SDR_MODE"               ]
      set use_separate_strobes        [get_parameter_value "GUI_${param_prefix}_USE_SEPARATE_STROBES"]
      set data_config                 [get_parameter_value "GUI_${param_prefix}_DATA_CONFIG"         ]
      set oct_size		      [get_parameter_value "GUI_${param_prefix}_OCT_SIZE"         ]

      set_parameter_value  "${param_prefix}_PIN_TYPE"            $pin_type
      set_parameter_value  "${param_prefix}_PIN_WIDTH"           $pin_width
      set_parameter_value  "${param_prefix}_DDR_SDR_MODE"        $ddr_sdr_mode
      set_parameter_value  "${param_prefix}_OCT_SIZE"        	 $oct_size

      set num_strobes [altera_phylite::ip_top::group::get_num_strobes_in_grp $grp_idx]
      set max_data_pins 48
      if {[expr [string compare -nocase $data_config "DIFF"] == 0 ]} {
         set max_data_pins 24
      }
      set max_num_pins [expr ${max_data_pins} - ${num_strobes}]
      set_parameter_property "GUI_${param_prefix}_PIN_WIDTH" ALLOWED_RANGES "1:${max_num_pins}"

      _validate_input_path  $param_prefix $pin_type $use_separate_strobes
      _validate_output_path $param_prefix $pin_type $use_separate_strobes
      _validate_data_config_param $param_prefix

      _validate_strobes $param_prefix $pin_type $num_strobes $use_separate_strobes

      if { ${grp_used} == 1 } {
         _validate_oct $param_prefix $grp_idx $pin_type
      }
   }

   _validate_param_copy_group $grp_idx

   _update_copied_params $grp_idx

   return 1
}

proc ::altera_phylite::ip_top::group::restore_group_defaults {grp_idx param_type} {
   set group_params     [get_group_param_list $grp_idx $param_type]
   set group_params     [lsearch -all -inline -not -regexp -nocase $group_params PARAM_COPY]

   foreach param $group_params {
      _set_param_to_default $param
   }

   return 1
}


proc ::altera_phylite::ip_top::group::get_num_strobes_in_grp {grp_idx} {

   set pin_type             [get_parameter_value "GROUP_${grp_idx}_PIN_TYPE"                   ]
   set strobe_config        [get_parameter_value "GROUP_${grp_idx}_STROBE_CONFIG"              ]
   set use_out_strobe       [get_parameter_value "GROUP_${grp_idx}_USE_OUTPUT_STROBE"          ]
   set use_int_cap_strobe   [get_parameter_value "GROUP_${grp_idx}_USE_INTERNAL_CAPTURE_STROBE"]
   set use_separate_strobes [get_parameter_value "GROUP_${grp_idx}_USE_SEPARATE_STROBES"       ]

   set num_strobes 1

   if {[string compare -nocase $pin_type "OUTPUT"] == 0 && [string compare -nocase $use_out_strobe "false"] == 0} {
      set num_strobes 0
   } elseif {[string compare -nocase $pin_type "INPUT"] == 0 && [string compare -nocase $use_int_cap_strobe "true"] == 0} {
      set num_strobes 0
   } elseif {[string compare -nocase $pin_type "BIDIR"] == 0 && [string compare -nocase $use_out_strobe "false"] == 0 && [string compare -nocase $use_int_cap_strobe "true"] == 0} {
      set num_strobes 0
   } elseif {[expr [string compare -nocase $strobe_config "DIFFERENTIAL"] == 0 || [string compare -nocase $strobe_config "COMPLEMENTARY"] == 0]} {
      set num_strobes 2
   }

   if { [string compare -nocase $use_separate_strobes "true"] == 0 } {
      set num_strobes [expr ${num_strobes}*2]
   }

   return $num_strobes
}

proc ::altera_phylite::ip_top::group::get_data_width_in_grp {grp_idx} {

   set data_config          [get_parameter_value "GROUP_${grp_idx}_DATA_CONFIG"]
   set num_pins    	    [get_parameter_value "GROUP_${grp_idx}_PIN_WIDTH"        ]

   set data_width 1
   if {[expr [string compare -nocase $data_config "DIFF"] == 0 ]} {
	   set data_width [expr ${num_pins}*2]
   } else {
	   set data_width [expr ${num_pins}]
   }
	
   return $data_width
}


proc ::altera_phylite::ip_top::group::_validate_input_path {param_prefix pin_type use_separate_strobes} {

   set read_latency                [get_parameter_value "GUI_${param_prefix}_READ_LATENCY"                ]
   set use_internal_capture_strobe [get_parameter_value "GUI_${param_prefix}_USE_INTERNAL_CAPTURE_STROBE" ]
   set swap_cap_strobes            [get_parameter_value "GUI_${param_prefix}_SWAP_CAPTURE_STROBE_POLARITY"]
   set capture_phase_shift         [get_parameter_value "GUI_${param_prefix}_CAPTURE_PHASE_SHIFT"         ]
   set strobe_config               [get_parameter_value "GUI_${param_prefix}_STROBE_CONFIG"               ]
   set data_config      	        [get_parameter_value "GUI_${param_prefix}_DATA_CONFIG"                 ]
   set use_dyn_cfg                 [get_parameter_value "PHYLITE_USE_DYNAMIC_RECONFIGURATION"             ]

   set enable_internal_cap_strobe_opt [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_enable_internal_capture_strobe"]

   if {[string compare -nocase $pin_type "OUTPUT"] == 0} {
      set_parameter_property "GUI_${param_prefix}_READ_LATENCY"                 ENABLED false
      set_parameter_property "GUI_${param_prefix}_USE_INTERNAL_CAPTURE_STROBE"  ENABLED false
      set_parameter_property "GUI_${param_prefix}_SWAP_CAPTURE_STROBE_POLARITY" ENABLED false
      set_parameter_property "GUI_${param_prefix}_CAPTURE_PHASE_SHIFT"          ENABLED false
      set_parameter_property "GUI_${param_prefix}_T_IN_DH"                      ENABLED false
      set_parameter_property "GUI_${param_prefix}_T_IN_DS"                      ENABLED false
      set_parameter_property "GUI_${param_prefix}_GENERATE_INPUT_CONSTRAINT"    ENABLED false

      set_parameter_property "GUI_${param_prefix}_READ_DESKEW_MODE"             ENABLED false
      set_parameter_property "GUI_${param_prefix}_READ_SU_DESKEW_CUSTOM"        ENABLED false
      set_parameter_property "GUI_${param_prefix}_READ_HD_DESKEW_CUSTOM"        ENABLED false
      set_parameter_property "GUI_${param_prefix}_READ_ISI"                     ENABLED false

      set_parameter_value  "${param_prefix}_READ_LATENCY"                 7
      set_parameter_value  "${param_prefix}_USE_INTERNAL_CAPTURE_STROBE"  false
      set_parameter_value  "${param_prefix}_SWAP_CAPTURE_STROBE_POLARITY" false
      set_parameter_value  "${param_prefix}_CAPTURE_PHASE_SHIFT"          0
      set_parameter_value  "${param_prefix}_GENERATE_INPUT_CONSTRAINT"    false
   } else {
      set_parameter_property  "GUI_${param_prefix}_READ_LATENCY"                 ENABLED true
      set_parameter_property  "GUI_${param_prefix}_CAPTURE_PHASE_SHIFT"          ENABLED true
      set_parameter_property  "GUI_${param_prefix}_GENERATE_INPUT_CONSTRAINT"    ENABLED true
      if {$use_dyn_cfg} {
         set_parameter_property  "GUI_${param_prefix}_READ_DESKEW_MODE"             ENABLED true

         if { [string compare -nocase [get_parameter_value "GUI_${param_prefix}_READ_DESKEW_MODE"] "custom"] == 0 } {
            set_parameter_property "GUI_${param_prefix}_READ_SU_DESKEW_CUSTOM"        ENABLED true
            set_parameter_property "GUI_${param_prefix}_READ_HD_DESKEW_CUSTOM"        ENABLED true
         } else {
            set_parameter_property "GUI_${param_prefix}_READ_SU_DESKEW_CUSTOM"        ENABLED false
            set_parameter_property "GUI_${param_prefix}_READ_HD_DESKEW_CUSTOM"        ENABLED false
         }
      } else {
         set_parameter_property "GUI_${param_prefix}_READ_DESKEW_MODE"             ENABLED false
         set_parameter_property "GUI_${param_prefix}_READ_SU_DESKEW_CUSTOM"        ENABLED false
         set_parameter_property "GUI_${param_prefix}_READ_HD_DESKEW_CUSTOM"        ENABLED false
      }
         

      if { [string compare -nocase [get_parameter_value "GUI_${param_prefix}_GENERATE_INPUT_CONSTRAINT"] "true"] == 0 } {
         set_parameter_property "GUI_${param_prefix}_T_IN_DH"                      ENABLED true
         set_parameter_property "GUI_${param_prefix}_T_IN_DS"                      ENABLED true
         set_parameter_property "GUI_${param_prefix}_READ_ISI"                     ENABLED true
      } else {
         set_parameter_property "GUI_${param_prefix}_T_IN_DH"                      ENABLED false
         set_parameter_property "GUI_${param_prefix}_T_IN_DS"                      ENABLED false
         set_parameter_property "GUI_${param_prefix}_READ_ISI"                     ENABLED false
      }

      if { [string compare -nocase $use_separate_strobes "true"] == 0 } {
         set_parameter_property  "GUI_${param_prefix}_USE_INTERNAL_CAPTURE_STROBE"  ENABLED false
        set_parameter_value  "${param_prefix}_USE_INTERNAL_CAPTURE_STROBE" false
      } else {
         set_parameter_property  "GUI_${param_prefix}_USE_INTERNAL_CAPTURE_STROBE"  ENABLED true
        set_parameter_value  "${param_prefix}_USE_INTERNAL_CAPTURE_STROBE" $use_internal_capture_strobe
      }

      if { [string compare -nocase $strobe_config "COMPLEMENTARY"] == 0 } {
         set_parameter_property  "GUI_${param_prefix}_SWAP_CAPTURE_STROBE_POLARITY" ENABLED true
         set_parameter_value  "${param_prefix}_SWAP_CAPTURE_STROBE_POLARITY" $swap_cap_strobes
      } else {
         set_parameter_property  "GUI_${param_prefix}_SWAP_CAPTURE_STROBE_POLARITY" ENABLED false
         set_parameter_value  "${param_prefix}_SWAP_CAPTURE_STROBE_POLARITY" false
      }

      set_parameter_value  "${param_prefix}_READ_LATENCY"                 $read_latency
      set_parameter_value  "${param_prefix}_CAPTURE_PHASE_SHIFT"          $capture_phase_shift
      set_parameter_value  "${param_prefix}_GENERATE_INPUT_CONSTRAINT"    [get_parameter_value "GUI_${param_prefix}_GENERATE_INPUT_CONSTRAINT"]
   }

   if { [expr [string compare -nocase $pin_type "INPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0] } {
      set rd_lat_range [altera_phylite::util::arch_expert::get_legal_read_latencies]
      set_parameter_property "GUI_${param_prefix}_READ_LATENCY" ALLOWED_RANGES ${rd_lat_range}
   }

   if { $enable_internal_cap_strobe_opt == 1 } {
      set_parameter_property "GUI_${param_prefix}_USE_INTERNAL_CAPTURE_STROBE" VISIBLE true
   } else {
      set_parameter_property "GUI_${param_prefix}_USE_INTERNAL_CAPTURE_STROBE" VISIBLE false
   }

   set_parameter_value ${param_prefix}_T_IN_DS                         [get_parameter_value "GUI_${param_prefix}_T_IN_DS"]
   set_parameter_value ${param_prefix}_T_IN_DH                         [get_parameter_value "GUI_${param_prefix}_T_IN_DH"]

   set_parameter_value "${param_prefix}_READ_DESKEW_MODE"              [get_parameter_value "GUI_${param_prefix}_READ_DESKEW_MODE"]
   set_parameter_value "${param_prefix}_READ_SU_DESKEW_CUSTOM"         [get_parameter_value "GUI_${param_prefix}_READ_SU_DESKEW_CUSTOM"]
   set_parameter_value "${param_prefix}_READ_HD_DESKEW_CUSTOM"         [get_parameter_value "GUI_${param_prefix}_READ_HD_DESKEW_CUSTOM"]
   set_parameter_value "${param_prefix}_READ_ISI"                      [get_parameter_value "GUI_${param_prefix}_READ_ISI"]

}

proc ::altera_phylite::ip_top::group::_validate_output_path {param_prefix pin_type use_separate_strobes} {

   set write_latency        [get_parameter_value "GUI_${param_prefix}_WRITE_LATENCY"        ]
   set use_output_strobe    [get_parameter_value "GUI_${param_prefix}_USE_OUTPUT_STROBE"    ]
   set output_strobe_phase  [get_parameter_value "GUI_${param_prefix}_OUTPUT_STROBE_PHASE"  ]
   set use_dyn_cfg          [get_parameter_value "PHYLITE_USE_DYNAMIC_RECONFIGURATION"      ]

   if {[string compare -nocase $pin_type "INPUT"] == 0} {
      set_parameter_property  "GUI_${param_prefix}_WRITE_LATENCY"       ENABLED false
      set_parameter_property  "GUI_${param_prefix}_USE_OUTPUT_STROBE"   ENABLED false
      set_parameter_property  "GUI_${param_prefix}_OUTPUT_STROBE_PHASE" ENABLED false
      set_parameter_property  "GUI_${param_prefix}_T_OUT_DH"            ENABLED false
      set_parameter_property  "GUI_${param_prefix}_T_OUT_DS"            ENABLED false
      set_parameter_property  "GUI_${param_prefix}_GENERATE_OUTPUT_CONSTRAINT"   ENABLED false

      set_parameter_property "GUI_${param_prefix}_WRITE_DESKEW_MODE"             ENABLED false
      set_parameter_property "GUI_${param_prefix}_WRITE_SU_DESKEW_CUSTOM"        ENABLED false
      set_parameter_property "GUI_${param_prefix}_WRITE_HD_DESKEW_CUSTOM"        ENABLED false
      set_parameter_property "GUI_${param_prefix}_WRITE_ISI"                     ENABLED false

      set_parameter_value  "${param_prefix}_WRITE_LATENCY"         0
      set_parameter_value  "${param_prefix}_USE_OUTPUT_STROBE"     false
      set_parameter_value  "${param_prefix}_OUTPUT_STROBE_PHASE"   0
      set_parameter_value  "${param_prefix}_GENERATE_OUTPUT_CONSTRAINT"     false
   } else {
      set_parameter_property  "GUI_${param_prefix}_WRITE_LATENCY"       ENABLED true

      if {$use_dyn_cfg} {
         set_parameter_property  "GUI_${param_prefix}_WRITE_DESKEW_MODE"             ENABLED true

         if { [string compare -nocase [get_parameter_value "GUI_${param_prefix}_WRITE_DESKEW_MODE"] "custom"] == 0 } {
            set_parameter_property "GUI_${param_prefix}_WRITE_SU_DESKEW_CUSTOM"        ENABLED true
            set_parameter_property "GUI_${param_prefix}_WRITE_HD_DESKEW_CUSTOM"        ENABLED true
         } else {
            set_parameter_property "GUI_${param_prefix}_WRITE_SU_DESKEW_CUSTOM"        ENABLED false
            set_parameter_property "GUI_${param_prefix}_WRITE_HD_DESKEW_CUSTOM"        ENABLED false
         }
      } else {
         set_parameter_property "GUI_${param_prefix}_WRITE_DESKEW_MODE"             ENABLED false
         set_parameter_property "GUI_${param_prefix}_WRITE_SU_DESKEW_CUSTOM"        ENABLED false
         set_parameter_property "GUI_${param_prefix}_WRITE_HD_DESKEW_CUSTOM"        ENABLED false
      }

      if { [expr [string compare -nocase $use_separate_strobes "true"] == 0 && [string compare -nocase $pin_type "BIDIR"] == 0 && [string compare -nocase $use_output_strobe "true"] == 0] } {
         set_parameter_property  "GUI_${param_prefix}_USE_OUTPUT_STROBE"   ENABLED false
         set_parameter_value  "${param_prefix}_USE_OUTPUT_STROBE" true
      } else {
         set_parameter_property  "GUI_${param_prefix}_USE_OUTPUT_STROBE"   ENABLED true
         set_parameter_value  "${param_prefix}_USE_OUTPUT_STROBE" $use_output_strobe
      }

      if {[string compare -nocase [get_parameter_value "${param_prefix}_OUTPUT_STROBE_PHASE"] "false"] == 0} {
         set_parameter_property  "GUI_${param_prefix}_OUTPUT_STROBE_PHASE" ENABLED false
      } else {
         set_parameter_property  "GUI_${param_prefix}_OUTPUT_STROBE_PHASE" ENABLED true
      }

      set_parameter_property  "GUI_${param_prefix}_GENERATE_OUTPUT_CONSTRAINT"   ENABLED true
      if { [string compare -nocase [get_parameter_value "GUI_${param_prefix}_GENERATE_OUTPUT_CONSTRAINT"] "true"] == 0 } {
         set_parameter_property "GUI_${param_prefix}_T_OUT_DH"                      ENABLED true
         set_parameter_property "GUI_${param_prefix}_T_OUT_DS"                      ENABLED true
         set_parameter_property "GUI_${param_prefix}_WRITE_ISI"                     ENABLED true
      } else {
         set_parameter_property "GUI_${param_prefix}_T_OUT_DH"                      ENABLED false
         set_parameter_property "GUI_${param_prefix}_T_OUT_DS"                      ENABLED false
         set_parameter_property "GUI_${param_prefix}_WRITE_ISI"                     ENABLED false
      }
      set_parameter_value  "${param_prefix}_WRITE_LATENCY"         $write_latency
      set_parameter_value  "${param_prefix}_OUTPUT_STROBE_PHASE"   $output_strobe_phase
      set_parameter_value  "${param_prefix}_GENERATE_OUTPUT_CONSTRAINT" [get_parameter_value "GUI_${param_prefix}_GENERATE_OUTPUT_CONSTRAINT"]
   }

   if { [expr [string compare -nocase $pin_type "OUTPUT"] == 0 || [string compare -nocase $pin_type "BIDIR"] == 0] } {
      set wr_lat_range [altera_phylite::util::arch_expert::get_legal_write_latencies]
      set_parameter_property "GUI_${param_prefix}_WRITE_LATENCY" ALLOWED_RANGES ${wr_lat_range}
   }
   set_parameter_value ${param_prefix}_T_OUT_DS                        [get_parameter_value "GUI_${param_prefix}_T_OUT_DS"]
   set_parameter_value ${param_prefix}_T_OUT_DH                        [get_parameter_value "GUI_${param_prefix}_T_OUT_DH"]

   set_parameter_value "${param_prefix}_WRITE_DESKEW_MODE"              [get_parameter_value "GUI_${param_prefix}_WRITE_DESKEW_MODE"]
   set_parameter_value "${param_prefix}_WRITE_SU_DESKEW_CUSTOM"         [get_parameter_value "GUI_${param_prefix}_WRITE_SU_DESKEW_CUSTOM"]
   set_parameter_value "${param_prefix}_WRITE_HD_DESKEW_CUSTOM"         [get_parameter_value "GUI_${param_prefix}_WRITE_HD_DESKEW_CUSTOM"]
   set_parameter_value "${param_prefix}_WRITE_ISI"                      [get_parameter_value "GUI_${param_prefix}_WRITE_ISI"]
}

proc ::altera_phylite::ip_top::group::_validate_strobes {param_prefix pin_type num_strobes use_separate_strobes} {
   set strobe_config               [get_parameter_value "GUI_${param_prefix}_STROBE_CONFIG"              ]
   set use_output_strobe           [get_parameter_value "GUI_${param_prefix}_USE_OUTPUT_STROBE"          ]
   set use_internal_capture_strobe [get_parameter_value "GUI_${param_prefix}_USE_INTERNAL_CAPTURE_STROBE"]
   set io_std                      [get_parameter_value "GUI_PHYLITE_IO_STD_ENUM"                        ]
   set diff_io_std                 [enum_data ${io_std} DF_IO_STD]

   if { $num_strobes == 0 } {
      set_parameter_property "GUI_${param_prefix}_STROBE_CONFIG" ENABLED false
      set_parameter_value  "${param_prefix}_STROBE_CONFIG" SINGLE_ENDED
   } else {
      set_parameter_property "GUI_${param_prefix}_STROBE_CONFIG" ENABLED true
      if { [string compare -nocase $diff_io_std "IO_STD_INVALID"] == 0 } {
         set_parameter_property "GUI_${param_prefix}_STROBE_CONFIG" ALLOWED_RANGES [::altera_phylite::ip_top::group::_get_legal_enums_ui [list SINGLE_ENDED]]
      } else {
         set_parameter_property "GUI_${param_prefix}_STROBE_CONFIG" ALLOWED_RANGES [enum_dropdown_entries STROBE_CONFIG]
      }
      set_parameter_value  "${param_prefix}_STROBE_CONFIG" $strobe_config
   }

   if { [expr [string compare -nocase $pin_type "BIDIR"] == 0 && [string compare -nocase $use_internal_capture_strobe "false"] == 0 && [string compare -nocase $use_output_strobe "true"] == 0] } {
      set_parameter_property "GUI_${param_prefix}_USE_SEPARATE_STROBES" ENABLED true
      set_parameter_value "${param_prefix}_USE_SEPARATE_STROBES" $use_separate_strobes
   } else {
      set_parameter_property "GUI_${param_prefix}_USE_SEPARATE_STROBES" ENABLED false
      set_parameter_value "${param_prefix}_USE_SEPARATE_STROBES" false
   }
}

proc ::altera_phylite::ip_top::group::_validate_data_config_param {param_prefix} {
   set data_config                 [get_parameter_value "GUI_${param_prefix}_DATA_CONFIG"                ]

   set_parameter_value  "${param_prefix}_DATA_CONFIG" $data_config
}

proc ::altera_phylite::ip_top::group::_validate_oct {param_prefix grp_idx pin_type} {

   set in_oct      [get_parameter_value "GUI_${param_prefix}_USER_IN_OCT_ENUM" ]
   set out_oct     [get_parameter_value "GUI_${param_prefix}_USER_OUT_OCT_ENUM"]
   set io_std      [get_parameter_value "GUI_PHYLITE_IO_STD_ENUM"         ]
   set default_oct [get_parameter_value "GUI_${param_prefix}_DEFAULT_OCT" ]
   set int_freq    [get_parameter_value "GUI_PHYLITE_MEM_CLK_FREQ_MHZ" ]
   
   if { [string compare -nocase $io_std "PHYLITE_IO_STD_NONE"] == 0 } {
      set in_oct  IN_OCT_0
      set out_oct OUT_OCT_0

      set_parameter_property "GUI_${param_prefix}_USER_IN_OCT_ENUM"  ALLOWED_RANGES [::altera_phylite::ip_top::group::_get_legal_enums_ui [list IN_OCT_0]]
      set_parameter_property "GUI_${param_prefix}_USER_OUT_OCT_ENUM" ALLOWED_RANGES [::altera_phylite::ip_top::group::_get_legal_enums_ui [list OUT_OCT_0]]
   } elseif { [string compare -nocase $default_oct "true"] == 0 } {

      set in_oct  [_get_default_oct $io_std "IN"  0]
      set out_oct [_get_default_oct $io_std "OUT" [expr ![string compare -nocase $in_oct "IN_OCT_0"]]]
   } else {
      set allow_no_cal  [expr [string compare -nocase $pin_type "OUTPUT"] == 0]
      set legal_in_oct_range  [_get_legal_oct_range $io_std "IN"  $allow_no_cal]
      set legal_out_oct_range [_get_legal_oct_range $io_std "OUT" $allow_no_cal]

      set_parameter_property "GUI_${param_prefix}_USER_IN_OCT_ENUM"  ALLOWED_RANGES [::altera_phylite::ip_top::group::_get_legal_enums_ui $legal_in_oct_range]
      set_parameter_property "GUI_${param_prefix}_USER_OUT_OCT_ENUM" ALLOWED_RANGES [::altera_phylite::ip_top::group::_get_legal_enums_ui $legal_out_oct_range]
   }

   set in_oct_cal 0
   if { [string compare -nocase $pin_type "OUTPUT"] == 0 } {
      set_parameter_property "GUI_${param_prefix}_USER_IN_OCT_ENUM"  ENABLED false
      set in_oct IN_OCT_0
   } else {
      set_parameter_property "GUI_${param_prefix}_USER_IN_OCT_ENUM"  ENABLED true

      set in_oct_cal [enum_data $in_oct CALIBRATED]
   }

   set out_oct_cal 0
   if { [string compare -nocase $pin_type "INPUT"] == 0 } {
      set_parameter_property "GUI_${param_prefix}_USER_OUT_OCT_ENUM"  ENABLED false
      set out_oct OUT_OCT_0
   } else {
      set_parameter_property "GUI_${param_prefix}_USER_OUT_OCT_ENUM"  ENABLED true

      set out_oct_cal [enum_data $out_oct CALIBRATED]
   }
   
   set is_c1_c2 [expr ([string first "C1" $io_std] != -1) || ([string first "C2" $io_std] != -1)]
   set oct_cal [expr (${in_oct_cal} || ${out_oct_cal})]
   if { [expr ($is_c1_c2 && (${oct_cal} == 1) && ($int_freq > 533) && ([string compare -nocase $pin_type "OUTPUT"] != 0))]} {
      post_ipgen_e_msg MSG_HIGH_INT_FREQ
   }
   set oct_mode "STATIC_OFF"
   if { [expr (([string compare -nocase $pin_type "BIDIR"] == 0) && (${in_oct_cal} ^ ${out_oct_cal}))] } {
      post_ipgen_e_msg MSG_BIDIR_OCT_CONFLICT [list ${grp_idx}]
   } elseif { ${oct_cal} == 1 } {
      post_ipgen_i_msg MSG_OCT_CAL_INFO [list ${grp_idx}]

      set oct_mode "DYNAMIC"
   }

   set_parameter_value "${param_prefix}_OCT_MODE" $oct_mode

   set_parameter_property "GUI_${param_prefix}_IN_OCT_ENUM"       VISIBLE [expr {$default_oct}]
   set_parameter_property "GUI_${param_prefix}_OUT_OCT_ENUM"      VISIBLE [expr {$default_oct}]
   set_parameter_property "GUI_${param_prefix}_USER_IN_OCT_ENUM"  VISIBLE [expr {!$default_oct}]
   set_parameter_property "GUI_${param_prefix}_USER_OUT_OCT_ENUM" VISIBLE [expr {!$default_oct}]

   set_parameter_value "${param_prefix}_IN_OCT_ENUM"  $in_oct
   set_parameter_value "${param_prefix}_OUT_OCT_ENUM" $out_oct
   set_parameter_value "GUI_${param_prefix}_IN_OCT_ENUM"  [enum_data $in_oct  UI_NAME]
   set_parameter_value "GUI_${param_prefix}_OUT_OCT_ENUM" [enum_data $out_oct UI_NAME]
}

proc ::altera_phylite::ip_top::group::_validate_param_copy_group {grp_idx} {
   variable m_param_prefix
   set param_prefix   "${m_param_prefix}_${grp_idx}"
   set param_copy     [get_parameter_value "GUI_${param_prefix}_PARAM_COPY"]

   set num_groups [get_parameter_value PHYLITE_NUM_GROUPS]
   if {$num_groups == 1} {
      set_parameter_property "GUI_${param_prefix}_PARAM_COPY"       ENABLED        false
      set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" VISIBLE        false
      set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ENABLED        false
      set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ALLOWED_RANGES {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17}
   } else {
      if {$grp_idx < $num_groups} {
         set_parameter_property "GUI_${param_prefix}_PARAM_COPY" VISIBLE true
         set_parameter_property "GUI_${param_prefix}_PARAM_COPY" ENABLED true

         set legal_groups     [_get_legal_copy_groups $grp_idx]
         set num_values       [llength $legal_groups]

         if {[_safe_string_compare $param_copy "false"]} {
            set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" VISIBLE        false
            set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ENABLED        false
            set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ALLOWED_RANGES {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17}
            if {$num_values == 0} {
               set_parameter_property "GUI_${param_prefix}_PARAM_COPY" ENABLED false
            }
         } else {
            set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" VISIBLE true
            if {$num_values == 0} {
               set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ALLOWED_RANGES {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17}
               set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ENABLED        false
               set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" VISIBLE        false
               set_parameter_property "GUI_${param_prefix}_PARAM_COPY"       ENABLED        false
            } else {
               set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ALLOWED_RANGES $legal_groups
               set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ENABLED        true
            }
         }
      } else {
         set_parameter_property "GUI_${param_prefix}_PARAM_COPY"       ENABLED        false
         set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" VISIBLE        false
         set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ENABLED        false
         set_parameter_property "GUI_${param_prefix}_PARAM_COPY_GROUP" ALLOWED_RANGES {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17}
      }
   }
}

proc ::altera_phylite::ip_top::group::_get_legal_oct_range {io_std dir allow_no_cal} {
   set mydevice [get_device_family_enum]
   if { ([string compare -nocase $mydevice "FAMILY_ARRIA10"] == 0) } {
	   set range [enum_data [string map {PHYLITE PHYLITE_OCT} $io_std] "RANGE_${dir}_OCT"]
   } else {
	   set range [enum_data [string map {PHYLITE PHYLITE_OCT_ND} $io_std] "RANGE_${dir}_OCT"]
   }

   set retval [list]
   foreach oct $range {
      if {$oct == 0} {
         lappend retval "${dir}_OCT_0"
      } else {
         lappend retval "${dir}_OCT_${oct}_CAL"
         if { [expr (${allow_no_cal} != 0) && ([string compare -nocase $dir "OUT"] == 0)] } {
            lappend retval "${dir}_OCT_${oct}_NO_CAL"
         }
      }
   }

   return $retval
}

proc ::altera_phylite::ip_top::group::_get_default_oct {io_std dir out_no_cal} {
   set mydevice [get_device_family_enum]
   if { ([string compare -nocase $mydevice "FAMILY_ARRIA10"] == 0) } {
	   set oct [enum_data [string map {PHYLITE PHYLITE_OCT} $io_std] "DEFAULT_${dir}_OCT"]
   } else {
	   set oct [enum_data [string map {PHYLITE PHYLITE_OCT_ND} $io_std] "DEFAULT_${dir}_OCT"]
   }

   set retval ""
   if {$oct == 0} {
      set retval "${dir}_OCT_0"
   } else {
      set retval "${dir}_OCT_${oct}_CAL"
      if { [expr (${out_no_cal} != 0) && ([string compare -nocase $dir "OUT"] == 0)] } {
         set retval "${dir}_OCT_${oct}_NO_CAL"
      }
   }

   return $retval
}

proc ::altera_phylite::ip_top::group::_set_user_oct_to_default {grp_idx} {
   variable m_param_prefix
   set param_prefix "${m_param_prefix}_${grp_idx}"

   set io_std      [get_parameter_value "GUI_PHYLITE_IO_STD_ENUM"        ]
   set default_oct [get_parameter_value "GUI_${param_prefix}_DEFAULT_OCT"]
   set pin_type    [get_parameter_value "${param_prefix}_PIN_TYPE"       ]

   if { [expr ([string compare -nocase $default_oct "false"] == 0)&&([string compare -nocase $io_std "PHYLITE_IO_STD_NONE"] != 0)] } {

      set in_oct  [_get_default_oct $io_std "IN"  0]
      set out_oct [_get_default_oct $io_std "OUT" [expr ![string compare -nocase $in_oct "IN_OCT_0"]]]

      set_parameter_value "GUI_${param_prefix}_USER_IN_OCT_ENUM"  $in_oct
      set_parameter_value "GUI_${param_prefix}_USER_OUT_OCT_ENUM" $out_oct
   } else {
      set_parameter_value "GUI_${param_prefix}_USER_IN_OCT_ENUM"  IN_OCT_0
      set_parameter_value "GUI_${param_prefix}_USER_OUT_OCT_ENUM" OUT_OCT_0
      set_parameter_property "GUI_${param_prefix}_USER_IN_OCT_ENUM"  ALLOWED_RANGES [::altera_phylite::ip_top::group::_get_legal_enums_ui [list IN_OCT_0]]
      set_parameter_property "GUI_${param_prefix}_USER_OUT_OCT_ENUM" ALLOWED_RANGES [::altera_phylite::ip_top::group::_get_legal_enums_ui [list OUT_OCT_0]]
   }
}

proc ::altera_phylite::ip_top::group::_get_legal_enums_ui {enum_names} {
   set retval [list]
   foreach enum_name $enum_names {
      lappend retval [enum_dropdown_entry $enum_name]
   }
   return $retval
}

proc ::altera_phylite::ip_top::group::_set_param_to_default {param} {
    set_parameter_value $param [get_parameter_property $param DEFAULT_VALUE]
}


proc ::altera_phylite::ip_top::group::_safe_string_compare { string_1 string_2 } {
	set ret_val [expr {[string compare -nocase $string_1 $string_2] == 0}]
	return $ret_val
}


proc ::altera_phylite::ip_top::group::_update_copy_groups {grp_idx} {
   variable m_param_prefix
   variable max_num_groups
   global all_original_group_values
   global all_original_group_enabled
   global all_original_group_visible

   set num_groups                       [get_parameter_value PHYLITE_NUM_GROUPS]
   set this_param_copy                  [get_parameter_value "GUI_${m_param_prefix}_${grp_idx}_PARAM_COPY"]
   set this_param_copy_group            [get_parameter_value "GUI_${m_param_prefix}_${grp_idx}_PARAM_COPY_GROUP"]
   set this_legal_groups                [_get_legal_copy_groups $grp_idx]
   set this_param_prefix                "${m_param_prefix}_${grp_idx}"


   if {([_safe_string_compare $this_param_copy "true"]) && ([lsearch $this_legal_groups $this_param_copy_group] == -1)} {
      set default_value [lindex $this_legal_groups 0]
      set_parameter_value "GUI_${this_param_prefix}_PARAM_COPY_GROUP" $default_value
   }

   set group_gui_params       [get_group_param_list $grp_idx "GUI"]
   set group_gui_params       [lsearch -all -inline -not -regexp -nocase $group_gui_params PARAM_COPY]

   if {[_safe_string_compare $this_param_copy "true"]} {

      foreach param $group_gui_params {
         set all_original_group_values($param)   [get_parameter_value    "$param"        ]
         set all_original_group_enabled($param)  [get_parameter_property "$param" ENABLED]
         set all_original_group_visible($param)  [get_parameter_property "$param" VISIBLE]
      }

      restore_group_defaults $grp_idx "GUI"
   } else {

      foreach param $group_gui_params {
         emif_assert {[info exists all_original_group_values($param)] && [info exists all_original_group_enabled($param)] && [info exists all_original_group_visible($param)]}
         set_parameter_value     "$param"          $all_original_group_values($param)
         set_parameter_property  "$param" ENABLED  $all_original_group_enabled($param)
         set_parameter_property  "$param" VISIBLE  $all_original_group_visible($param)
      }
   }

   return 1

}


proc ::altera_phylite::ip_top::group::_update_copied_params {grp_idx} {
   variable m_param_prefix
   variable max_num_groups

   set num_groups                       [get_parameter_value PHYLITE_NUM_GROUPS]
   set this_param_prefix                "${m_param_prefix}_${grp_idx}"
   set this_param_copy                  [get_parameter_value    "GUI_${this_param_prefix}_PARAM_COPY"        ]
   set this_param_copy_enabled          [get_parameter_property "GUI_${this_param_prefix}_PARAM_COPY" ENABLED]
   set this_group_gui_params           [get_group_param_list $grp_idx "GUI"]
   set this_group_gui_params           [lsearch -all -inline -not -regexp -nocase $this_group_gui_params PARAM_COPY]
   set this_group_shadow_params        [get_group_param_list $grp_idx "SHADOW"]
   set this_group_shadow_params        [lsearch -all -inline -not -regexp -nocase $this_group_shadow_params PARAM_COPY]
   set this_group_derived_params       [get_group_param_list $grp_idx "DERIVED"]
   set this_group_derived_params       [lsearch -all -inline -not -regexp -nocase $this_group_derived_params PARAM_COPY]

   set this_group_gui_params       [lsort -dictionary $this_group_gui_params]
   set this_group_shadow_params    [lsort -dictionary $this_group_shadow_params]
   set this_group_derived_params   [lsort -dictionary $this_group_derived_params]

   for { set i 0 } { $i < ${num_groups} } { incr i } {
      set copying_param_prefix           "${m_param_prefix}_${i}"
      set param_copy                       [get_parameter_value "GUI_${copying_param_prefix}_PARAM_COPY"]
      set param_copy_group                 [get_parameter_value "GUI_${copying_param_prefix}_PARAM_COPY_GROUP"]

      if {[_safe_string_compare $param_copy "true"] && $param_copy_group == $grp_idx} {
         set copying_group_gui_params           [get_group_param_list $i "GUI"]
         set copying_group_gui_params           [lsearch -all -inline -not -regexp -nocase $copying_group_gui_params PARAM_COPY]
         set copying_group_shadow_params        [get_group_param_list $i "SHADOW"]
         set copying_group_shadow_params        [lsearch -all -inline -not -regexp -nocase $copying_group_shadow_params PARAM_COPY]
         set copying_group_derived_params       [get_group_param_list $i "DERIVED"]
         set copying_group_derived_params       [lsearch -all -inline -not -regexp -nocase $copying_group_derived_params PARAM_COPY]

         set copying_group_gui_params       [lsort -dictionary $copying_group_gui_params]
         set copying_group_shadow_params    [lsort -dictionary $copying_group_shadow_params]
         set copying_group_derived_params   [lsort -dictionary $copying_group_derived_params]

         foreach copying_gui_param $copying_group_gui_params {
            set_parameter_property   "$copying_gui_param"   ENABLED false
            set_parameter_property   "$copying_gui_param"   VISIBLE false
         }

         set copying_derived_params_length   [llength $copying_group_derived_params]
         set this_derived_params_length      [llength $this_group_derived_params]

         emif_assert {$copying_derived_params_length == $this_derived_params_length}


         foreach copying_derived_param $copying_group_derived_params this_derived_param $this_group_derived_params {
            set_parameter_value   "$copying_derived_param"   [get_parameter_value "$this_derived_param"]
         }

         set copying_shadow_params_length   [llength $copying_group_shadow_params]
         set this_gui_params_length         [llength $this_group_gui_params]

         emif_assert {$copying_shadow_params_length == $this_gui_params_length}

         foreach copying_shadow_param $copying_group_shadow_params this_gui_param $this_group_gui_params {
            set_parameter_value      "$copying_shadow_param"                    [get_parameter_value    "$this_gui_param"               ]
            set_parameter_property   "$copying_shadow_param"   VISIBLE          [get_parameter_property "$this_gui_param" VISIBLE       ]
            set_parameter_property   "$copying_shadow_param"   ENABLED          [get_parameter_property "$this_gui_param" ENABLED       ]
            set_parameter_property   "$copying_shadow_param"   ALLOWED_RANGES   [get_parameter_property "$this_gui_param" ALLOWED_RANGES]
         }

         post_ipgen_i_msg MSG_GROUP_COPY_INFO [list \ ${i} \ ${grp_idx}]
      }
   }

   if {[_safe_string_compare $this_param_copy "false"] || $this_param_copy_enabled == 0} {
      foreach this_shadow_param $this_group_shadow_params {
         set_parameter_property   "$this_shadow_param"   ENABLED false
         set_parameter_property   "$this_shadow_param"   VISIBLE false
         _set_param_to_default    "$this_shadow_param"
      }
  }

   return 1
}


proc ::altera_phylite::ip_top::group::_get_legal_copy_groups {grp_idx} {
   variable m_param_prefix
   set retval [list]

   set num_groups [get_parameter_value PHYLITE_NUM_GROUPS]

   for { set i 0 } { $i < ${num_groups} } {incr i } {
      set param_prefix        "${m_param_prefix}_${i}"
      set grp_legal           [get_parameter_value "GUI_${param_prefix}_PARAM_COPY"]

      if {[_safe_string_compare $grp_legal "false"] && $i != $grp_idx} {
         lappend retval "${i}"
      }
   }

   return $retval
}

proc ::altera_phylite::ip_top::group::_init {} {
}

::altera_phylite::ip_top::group::_init
