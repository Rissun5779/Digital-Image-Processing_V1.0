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


package provide altera_emif::ip_arch_nf::hps 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::device_family

package require altera_emif::ip_arch_nf::enum_defs
package require altera_emif::ip_arch_nf::enum_defs_hps
package require altera_emif::ip_arch_nf::hps_csr
package require altera_emif::ip_arch_nf::util
package require altera_emif::ip_arch_nf::protocol_expert

namespace eval ::altera_emif::ip_arch_nf::hps:: {

   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::ip_arch_nf::util::*


}



proc ::altera_emif::ip_arch_nf::hps::check_hps_compatibility {} {
   
   emif_assert {[get_is_hps]}
   
   set device     [get_device]
   set die_string [get_die_string]
   
   if {$device == ""} {
      set retval 0
      post_ipgen_e_msg MSG_HPS_NO_DEVICE_SELECTED
      
   } elseif {![regexp -nocase "^10AS" $device]} {
      set retval 0
      post_ipgen_e_msg MSG_HPS_NOT_SOC_DEVICE
      
   } else {
      set retval 1
      
      set package_supports_3_tile_hps 0
      if {$die_string == "20nm4" && [regexp -nocase "K.F40" $device]} {
         set package_supports_3_tile_hps 1
      }
      
      set ac_pm_scheme       [altera_emif::ip_arch_nf::protocol_expert::get_ac_pin_map_scheme]
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

proc ::altera_emif::ip_arch_nf::hps::generate_handoff_xml_file {top_level} {
   set filename [::altera_emif::ip_arch_nf::util::get_hps_handoff_xml_filename $top_level]
   
   set hps_cfgs  [dict create]
   
   set timestamp [clock format [clock seconds] -format "%A %B,%d,%Y-%I:%M:%S %p %Z"]
   
   set hmc_inst  "PRI"
   set hmc_cfgs  [::altera_emif::ip_arch_nf::protocol_expert::get_hmc_cfgs $hmc_inst]
   
   foreach cfg_enum [enums_of_type HPS_CFG] {
   
      set xml_name     [enum_data $cfg_enum XML_NAME]
      set hmc_cfg_enum [enum_data $cfg_enum HMC_CFG_ENUM]
      
      if {$hmc_cfg_enum != ""} {
         set val [dict get $hmc_cfgs $hmc_cfg_enum]
      } else {
         switch $xml_name {
            CONFIG_HPS_SDR_SERRCNT {
               set val 8
            }
            CONFIG_HPS_SDR_IO_SIZE {
               set data_width [get_parameter_value MEM_TTL_DATA_WIDTH]
               if {$data_width == 16 || $data_width == 24} {
                  set val 0
               } elseif {$data_width == 32 || $data_width == 40} {
                  set val 1
               } elseif {$data_width == 64 || $data_width == 72} {
                  set val 2
               } else {
                  emif_ie "Unsupported HPS data width: $data_width"
               }
            }
            CONFIG_HPS_SDR_ECC_EN {
               set val [expr {[get_parameter_value CTRL_ECC_EN] ? 1 : 0}]
            }
            CONFIG_HPS_SDR_DDRCONF {
               set hmc_addr_order [dict get $hmc_cfgs HMC_CFG_ADDR_ORDER] 
               if {$hmc_addr_order == "chip_row_bank_col"} {
                  set val 0
               } elseif {$hmc_addr_order == "chip_bank_row_col"} {
                  set val 1
               } elseif {$hmc_addr_order == "row_chip_bank_col"} {
                  set val 2
               } else {
                  emif_ie "Unsupported HMC address ordering: $hmc_addr_order"
               }
            }
            CONFIG_HPS_SDR_DDRTIMING_RDTOMISS {
               set val 0
            }
            CONFIG_HPS_SDR_DDRTIMING_WRTOMISS {
               set val 0
            }
            CONFIG_HPS_SDR_DDRTIMING_BURSTLEN {
               set val 2
            }
            CONFIG_HPS_SDR_DDRTIMING_BWRATIO {
               set val 0
            }
            CONFIG_HPS_SDR_DDRMODE_AUTOPRECHARGE {
               set val 0
            }
            CONFIG_HPS_SDR_DDRMODE_BWRATIOEXTENDED {
               set val 0
            }
            CONFIG_HPS_SDR_READLATENCY {
               set val 0
            }
            CONFIG_HPS_SDR_ACTIVATE_FAWBANK {
               set val 4
            }
            default {
               emif_ie "Unsupported HPS configuration field: $xml_name"
            }
         }
      }
      dict set hps_cfgs $xml_name $val
   }
   
   
   set hps_csr_data [source [file join $::env(QUARTUS_ROOTDIR) .. ip altera emif ip_arch_nf hps_csr_data.tcl]]

   ::altera_emif::ip_arch_nf::hps_csr::init $hps_csr_data


   set file [create_temp_file $filename]
   set fh   [open $file "w"] 

   puts $fh "<?xml version=\"1.0\"?>"
   puts $fh "<emif>"
   puts $fh "   <system>"
   puts $fh "      <config value=\"18.1\" name=\"VERSION\"/>"
   puts $fh "      <config value=\"${timestamp}\" name=\"TIME_AND_DATE\"/>"
   puts $fh "   </system>"
   puts $fh "   <SDRAM>"
   foreach cfg [dict keys $hps_cfgs] {
      set val [dict get $hps_cfgs $cfg]
      puts $fh "      <config name=\"$cfg\" value=\"$val\"/>"
   }
   puts $fh "   </SDRAM>"

   puts $fh "   <csr>"
   foreach csr [::altera_emif::ip_arch_nf::hps_csr::to_list] {
      set csrNamespace [lindex $csr 0]
      set csrValue [lindex $csr 1]
      puts $fh "      <config name=\"$csrNamespace\" value=\"$csrValue\"/>"
   }
   puts $fh "   </csr>"

   puts $fh "</emif>"
   
   close $fh
   return $file
}



proc ::altera_emif::ip_arch_nf::hps::_init {} {
}

::altera_emif::ip_arch_nf::hps::_init
