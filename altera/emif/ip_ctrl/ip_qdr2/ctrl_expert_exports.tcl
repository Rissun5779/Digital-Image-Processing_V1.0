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


package provide altera_emif::ip_ctrl::ip_qdr2::ctrl_expert_exports 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::enums
package require altera_emif::util::math
package require altera_emif::util::hwtcl_utils

namespace eval ::altera_emif::ip_ctrl::ip_qdr2::ctrl_expert_exports:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*

   
}


proc ::altera_emif::ip_ctrl::ip_qdr2::ctrl_expert_exports::get_num_of_interfaces_used {if_enum} {
   switch $if_enum {
      IF_AFI -
      IF_AFI_RESET -
      IF_AFI_CLK -
      IF_AFI_HALF_CLK -
      IF_EMIF_USR_RESET -
      IF_EMIF_USR_CLK {
         return 1
      }
      IF_CTRL_AMM {
         return 2
      }
      default {
         return 0
      }
   }
}

proc ::altera_emif::ip_ctrl::ip_qdr2::ctrl_expert_exports::get_interface_ports {if_enum} {
   set ports [list]
   
   switch $if_enum {
      IF_AFI {
         set ports [altera_emif::util::arch_expert::get_interface_ports IF_AFI]
         ::altera_emif::util::hwtcl_utils::add_unused_interface_ports IF_AFI ports
      }
      IF_AFI_RESET -
      IF_AFI_CLK -
      IF_AFI_HALF_CLK -
      IF_EMIF_USR_RESET -
      IF_EMIF_USR_CLK {
         set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
      }
      IF_CTRL_AMM {
         set props [get_interface_properties $if_enum]
         
         set data_width    [dict get $props WORD_WIDTH]
         set bws_en        [dict get $props USE_BYTE_ENABLE]
         set bws_n_width   [dict get $props BYTE_ENABLE_WIDTH]
         set bcount_width  [dict get $props BURST_COUNT_WIDTH]
         
         set address_width [dict get $props WORD_ADDRESS_WIDTH]
            
         lappend ports {*}[create_port  true        PORT_CTRL_AMM_READY         1                ]
         lappend ports {*}[create_port  true        PORT_CTRL_AMM_READ          1                ]
         lappend ports {*}[create_port  true        PORT_CTRL_AMM_WRITE         1                ]
         lappend ports {*}[create_port  true        PORT_CTRL_AMM_ADDRESS       $address_width   ]
         lappend ports {*}[create_port  true        PORT_CTRL_AMM_RDATA         $data_width      ]
         lappend ports {*}[create_port  true        PORT_CTRL_AMM_WDATA         $data_width      ]
         lappend ports {*}[create_port  true        PORT_CTRL_AMM_BCOUNT        $bcount_width    ]
         lappend ports {*}[create_port  $bws_en     PORT_CTRL_AMM_BYTEEN        $bws_n_width     ]
         lappend ports {*}[create_port  false       PORT_CTRL_AMM_BEGINXFER     1                ]
         lappend ports {*}[create_port  true        PORT_CTRL_AMM_RDATA_VALID   1                ]
      }
      default {
         emif_ie "Code path does not support if_enum $if_enum"
      }          
   }
   return $ports
}

proc ::altera_emif::ip_ctrl::ip_qdr2::ctrl_expert_exports::get_interface_properties {if_enum} {
   set props [dict create]
   
   switch $if_enum {
      IF_CTRL_AMM {
         set rate_enum           [get_parameter_value PHY_RATE_ENUM]
         set clk_ratio           [enum_data $rate_enum RATIO]
         set burst_length        [get_parameter_value MEM_BURST_LENGTH]
         set data_per_device     [get_parameter_value MEM_QDR2_DATA_PER_DEVICE]
         set data_width          [get_parameter_value MEM_QDR2_DATA_WIDTH]
         set bws_en              [get_parameter_value MEM_QDR2_BWS_EN]   
         set bws_n_width         [get_parameter_value MEM_QDR2_BWS_N_WIDTH]   
         set addr_width          [get_parameter_value MEM_QDR2_ADDR_WIDTH]
         set symbol_width        [get_parameter_value CTRL_QDR2_AVL_SYMBOL_WIDTH]
         set enable_power_of_two [get_parameter_value CTRL_QDR2_AVL_ENABLE_POWER_OF_TWO_BUS]
         set max_burst_count     [get_parameter_value CTRL_QDR2_AVL_MAX_BURST_COUNT]
         
         set ttl_data_bits_per_burst [expr {$data_width * $burst_length}]
         set ttl_mask_bits_per_burst [expr {$bws_n_width * $burst_length}]
         
         set ttl_data_bits_per_cyc   [expr {$data_width * 2 * $clk_ratio}]
         set ttl_mask_bits_per_cyc   [expr {$bws_n_width * 2 * $clk_ratio}]
         
         set data_width              [expr {$ttl_data_bits_per_burst < $ttl_data_bits_per_cyc ? $ttl_data_bits_per_burst : $ttl_data_bits_per_cyc}]
         set bws_n_width             [expr {$ttl_mask_bits_per_burst < $ttl_mask_bits_per_cyc ? $ttl_mask_bits_per_burst : $ttl_mask_bits_per_cyc}]
         
         if {$clk_ratio == 1 && $burst_length == 4} {
            set data_width          [expr {$data_width * 2}]
            set bws_n_width         [expr {$bws_n_width * 2}]
         }
 
         if {$enable_power_of_two} {
            set data_width          [expr {int(pow(2,(int(floor([log2 $data_width])))))}]
         }
 
         set symbols_per_word        [expr {$data_width / $symbol_width}]
         set symbol_address_width    [expr {$addr_width + int(ceil([log2 $symbols_per_word]))}]
         set word_address_width      [expr {$addr_width}]
        
         set burst_count_width       [expr {int(floor([log2 $max_burst_count])) + 1}]

         set word_address_divisible_by 1
         set burst_count_divisible_by 1
         if {$clk_ratio != 1 && $clk_ratio != 2} {
            emif_ie "Code path does not support clk_ratio == $clk_ratio"
         }
         
         dict set props WORD_WIDTH                    $data_width
         dict set props SYMBOL_WIDTH                  $symbol_width
         dict set props SYMBOLS_PER_WORD              $symbols_per_word
         dict set props USE_BYTE_ENABLE               $bws_en
         dict set props BYTE_ENABLE_WIDTH             $bws_n_width
         dict set props WORD_ADDRESS_WIDTH            $word_address_width
         dict set props SYMBOL_ADDRESS_WIDTH          $symbol_address_width
         dict set props BURST_COUNT_WIDTH             $burst_count_width
         dict set props WORD_ADDRESS_DIVISIBLE_BY     $word_address_divisible_by
         dict set props BURST_COUNT_DIVISIBLE_BY      $burst_count_divisible_by
      } 
      default {
         emif_ie "Code path does not support if_enum $if_enum"
      }          
   }
   return $props
}


proc ::altera_emif::ip_ctrl::ip_qdr2::ctrl_expert_exports::_init {} {
}

::altera_emif::ip_ctrl::ip_qdr2::ctrl_expert_exports::_init

