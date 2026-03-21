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


package provide altera_emif::arch_common::util 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::math

namespace eval ::altera_emif::arch_common::util:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::device_family::*

}


proc ::altera_emif::arch_common::util::alloc_pin {port tiles_varname tile_i lane_i pin_i} {
   upvar 1 $tiles_varname tiles

   set max_tiles_per_if [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_MAX_TILES_PER_IF]
   set lanes_per_tile   [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_LANES_PER_TILE]
   set pins_per_lane    [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_PINS_PER_LANE]

   emif_assert {$tile_i < $max_tiles_per_if}
   emif_assert {$lane_i < $lanes_per_tile}
   emif_assert {$pin_i  < $pins_per_lane}
   emif_assert {[dict get $port ENABLED]}

   if {![dict exists $tiles $tile_i]} {
      dict set tiles $tile_i [dict create]
   }
   if {![dict exists $tiles $tile_i $lane_i]} {
      dict set tiles $tile_i $lane_i [dict create]
   }

   emif_assert {![dict exists $tiles $tile_i $lane_i $pin_i]}
   dict set tiles $tile_i $lane_i $pin_i $port

   return 1
}

proc ::altera_emif::arch_common::util::_init {} {
}

::altera_emif::arch_common::util::_init
