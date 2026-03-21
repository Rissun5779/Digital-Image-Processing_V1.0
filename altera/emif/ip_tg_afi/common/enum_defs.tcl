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


package provide altera_emif::ip_tg_afi::enum_defs 0.1

package require altera_emif::util::enums

load_strings common_gui.properties

namespace eval ::altera_emif::ip_tg_afi::enum_defs:: {
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::ip_tg_afi::enum_defs::def_enums {} {

   def_enum_type TG_AFI_IF                                  {        IF_ENUM                NUM_IN_RTL   DIR           }
   def_enum      TG_AFI_IF      TG_AFI_IF_AFI               [list    IF_AFI                 1            "REVERSE_DIR" ]
   def_enum      TG_AFI_IF      TG_AFI_IF_AFI_RESET         [list    IF_AFI_RESET           1            "REVERSE_DIR" ]
   def_enum      TG_AFI_IF      TG_AFI_IF_AFI_CLK           [list    IF_AFI_CLK             1            "REVERSE_DIR" ]
   def_enum      TG_AFI_IF      TG_AFI_IF_AFI_HALF_CLK      [list    IF_AFI_HALF_CLK        1            "REVERSE_DIR" ]
   def_enum      TG_AFI_IF      TG_AFI_IF_TG_STATUS         [list    IF_TG_STATUS           1            ""            ]
}


proc ::altera_emif::ip_tg_afi::enum_defs::_init {} {
   def_enums
}

::altera_emif::ip_tg_afi::enum_defs::_init



