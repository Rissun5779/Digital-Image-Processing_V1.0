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


package provide altera_emif::ip_ecc::ip_core_nf::enum_defs 0.1

package require altera_emif::util::enums

load_strings common_gui.properties

namespace eval ::altera_emif::ip_ecc::ip_core_nf::enum_defs:: {
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::ip_ecc::ip_core_nf::enum_defs::def_enums {} {

   def_enum_type ECC_IF                                                       {      IF_ENUM                         NUM_IN_RTL  }
   def_enum      ECC_IF                     ECC_IF_EMIF_USR_RESET             [list  IF_EMIF_USR_RESET               1           ]
   def_enum      ECC_IF                     ECC_IF_EMIF_USR_CLK               [list  IF_EMIF_USR_CLK                 1           ]
   def_enum      ECC_IF                     ECC_IF_EMIF_USR_RESET_IN          [list  IF_EMIF_USR_RESET_IN            1           ]
   def_enum      ECC_IF                     ECC_IF_EMIF_USR_CLK_IN            [list  IF_EMIF_USR_CLK_IN              1           ]
   def_enum      ECC_IF                     ECC_IF_EMIF_USR_RESET_SEC         [list  IF_EMIF_USR_RESET_SEC           1           ]
   def_enum      ECC_IF                     ECC_IF_EMIF_USR_CLK_SEC           [list  IF_EMIF_USR_CLK_SEC             1           ]
   def_enum      ECC_IF                     ECC_IF_EMIF_USR_RESET_SEC_IN      [list  IF_EMIF_USR_RESET_SEC_IN        1           ]
   def_enum      ECC_IF                     ECC_IF_EMIF_USR_CLK_SEC_IN        [list  IF_EMIF_USR_CLK_SEC_IN          1           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_ECC                   [list  IF_CTRL_ECC                     2           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_ECC_USER_INTERRUPT    [list  IF_CTRL_ECC_USER_INTERRUPT      2           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_AST_CMD               [list  IF_CTRL_AST_CMD                 2           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_AST_WR                [list  IF_CTRL_AST_WR                  2           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_AST_RD                [list  IF_CTRL_AST_RD                  2           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_AMM                   [list  IF_CTRL_AMM                     2           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_MMR_SLAVE             [list  IF_CTRL_MMR_SLAVE               2           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_MMR_MASTER            [list  IF_CTRL_MMR_MASTER              2           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_USER_PRIORITY         [list  IF_CTRL_USER_PRIORITY           2           ]
   def_enum      ECC_IF                     ECC_IF_CTRL_AUTO_PRECHARGE        [list  IF_CTRL_AUTO_PRECHARGE          2           ]
}


proc ::altera_emif::ip_ecc::ip_core_nf::enum_defs::_init {} {
   def_enums
}

::altera_emif::ip_ecc::ip_core_nf::enum_defs::_init



