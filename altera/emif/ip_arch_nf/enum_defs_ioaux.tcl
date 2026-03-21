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


package provide altera_emif::ip_arch_nf::enum_defs_ioaux 0.1

package require altera_emif::util::enums

namespace eval ::altera_emif::ip_arch_nf::enum_defs_ioaux:: {
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::ip_arch_nf::enum_defs_ioaux::def_enums {} {

   def_enum_type IOAUX_NIOS_HW_FREQ_MHZ                                    {     VALUE         }
   def_enum      IOAUX_NIOS_HW_FREQ_MHZ  IOAUX_NIOS_HW_FREQ_MHZ_MAX        [list 250           ]
   def_enum      IOAUX_NIOS_HW_FREQ_MHZ  IOAUX_NIOS_HW_FREQ_MHZ_MIN        [list 100           ]

   def_enum_type IOAUX_INT_OSC_FREQ_MHZ                                    {     VALUE         }
   def_enum      IOAUX_INT_OSC_FREQ_MHZ IOAUX_INT_OSC_FREQ_MHZ_MAX         [list 450           ]
   def_enum      IOAUX_INT_OSC_FREQ_MHZ IOAUX_INT_OSC_FREQ_MHZ_MIN         [list 200           ]
   def_enum_type IOAUX_PHYCLK_RATIO                                        {     VALUE         }
   def_enum      IOAUX_PHYCLK_RATIO     IOAUX_PHYCLK_TO_CALCLK_RATIO_MIN   [list 8             ]


   def_enum_type IOAUX_CFG_DIV                                   {     WYSIWYG_NAME           DATA_TYPE  DEFAULT              COMMENT}
   def_enum      IOAUX_CFG_DIV  IOAUX_CFG_DIV_CPU_CLK            [list "sys_clk_div"          "integer"  2                    "Divider for NIOS CPU Clock"]
   def_enum      IOAUX_CFG_DIV  IOAUX_CFG_DIV_CAL_CLK            [list "cal_clk_div"          "integer"  8                    "Divider for Avalon Calibration Bus Clock"]


   def_enum_type IOAUX_CFG_DIV_CPU_CLK                           {      DIV}
   def_enum      IOAUX_CFG_DIV_CPU_CLK  IOAUX_CFG_DIV_CPU_CLK_1  [list    1]
   def_enum      IOAUX_CFG_DIV_CPU_CLK  IOAUX_CFG_DIV_CPU_CLK_2  [list    2]
   def_enum      IOAUX_CFG_DIV_CPU_CLK  IOAUX_CFG_DIV_CPU_CLK_4  [list    4]
   def_enum      IOAUX_CFG_DIV_CPU_CLK  IOAUX_CFG_DIV_CPU_CLK_6  [list    6]
                                                                       
   def_enum_type IOAUX_CFG_DIV_CAL_CLK                           {      DIV}
   def_enum      IOAUX_CFG_DIV_CAL_CLK  IOAUX_CFG_DIV_CAL_CLK_4  [list    4]
   def_enum      IOAUX_CFG_DIV_CAL_CLK  IOAUX_CFG_DIV_CAL_CLK_6  [list    6]
   def_enum      IOAUX_CFG_DIV_CAL_CLK  IOAUX_CFG_DIV_CAL_CLK_8  [list    8]
   def_enum      IOAUX_CFG_DIV_CAL_CLK  IOAUX_CFG_DIV_CAL_CLK_10 [list   10]
   def_enum      IOAUX_CFG_DIV_CAL_CLK  IOAUX_CFG_DIV_CAL_CLK_14 [list   14]
   def_enum      IOAUX_CFG_DIV_CAL_CLK  IOAUX_CFG_DIV_CAL_CLK_20 [list   20]
   def_enum      IOAUX_CFG_DIV_CAL_CLK  IOAUX_CFG_DIV_CAL_CLK_24 [list   24]
   def_enum      IOAUX_CFG_DIV_CAL_CLK  IOAUX_CFG_DIV_CAL_CLK_32 [list   32]
}


proc ::altera_emif::ip_arch_nf::enum_defs_ioaux::_init {} {
   ::altera_emif::ip_arch_nf::enum_defs_ioaux::def_enums
}

::altera_emif::ip_arch_nf::enum_defs_ioaux::_init

