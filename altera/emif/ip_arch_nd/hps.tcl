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


package provide altera_emif::ip_arch_nd::hps 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::device_family

package require altera_emif::ip_arch_nd::enum_defs
package require altera_emif::ip_arch_nd::util
package require altera_emif::ip_arch_nd::protocol_expert

namespace eval ::altera_emif::ip_arch_nd::hps:: {

   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::ip_arch_nd::util::*


}



proc ::altera_emif::ip_arch_nd::hps::check_hps_compatibility {} {
   
   emif_assert {[get_is_hps]}
   
   set device     [get_device]
   set die_string [get_die_string]
   
   if {$device == ""} {
      set retval 0
      post_ipgen_e_msg MSG_HPS_NO_DEVICE_SELECTED
      
   } else {
      set retval 1
      
      set package_supports_3_tile_hps 1
      
      set ac_pm_scheme       [altera_emif::ip_arch_nd::protocol_expert::get_ac_pin_map_scheme]
      set ac_pm_enum         [dict get $ac_pm_scheme ENUM]
      set num_of_ac_lanes    [enum_data $ac_pm_enum LANES_USED]
      set data_width         [get_parameter_value MEM_TTL_DATA_WIDTH]
      set num_of_read_groups [get_parameter_value MEM_TTL_NUM_OF_READ_GROUPS]
      set ecc_en             [get_parameter_value CTRL_ECC_EN]
      set dm_en              [get_parameter_value MEM_DATA_MASK_EN]
      set group_size         [expr {$data_width / $num_of_read_groups}]

      if {$data_width > 40 && !$package_supports_3_tile_hps} {
         set retval 0
         post_ipgen_e_msg MSG_HPS_EMIF_TOO_WIDE
      }
      
      if {$ecc_en} {
         if {$data_width != 24 && $data_width != 40 && $data_width != 72} {
            set retval 0
            post_ipgen_e_msg MSG_HPS_ECC_WIDTH_NOT_SUPPORTED
         }
      } else {
         if {$data_width != 16 && $data_width != 32 && $data_width != 64} {
            set retval 0
            post_ipgen_e_msg MSG_HPS_NON_ECC_WIDTH_NOT_SUPPORTED
         }
      }

      if {$group_size != 8} {
         set retval 0
         post_ipgen_e_msg MSG_HPS_X4_GROUP_NOT_SUPPORTED
      }
      
      if {!$dm_en} {
         set retval 0
         post_ipgen_e_msg MSG_HPS_NO_DM_NOT_SUPPORTED
      }
      
      if {$num_of_ac_lanes > 3} {
         set retval 0
         post_ipgen_e_msg MSG_HPS_4_AC_LANES_NOT_SUPPORTED
      }
   }
   return $retval
}


proc ::altera_emif::ip_arch_nd::hps::_init {} {
}

::altera_emif::ip_arch_nd::hps::_init
