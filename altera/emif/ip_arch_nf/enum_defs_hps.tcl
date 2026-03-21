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


package provide altera_emif::ip_arch_nf::enum_defs_hps 0.1

package require altera_emif::util::enums

namespace eval ::altera_emif::ip_arch_nf::enum_defs_hps:: {
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::ip_arch_nf::enum_defs_hps::def_enums {} {
   
   def_enum_type HPS_CFG                              {        XML_NAME                                HMC_CFG_ENUM                      }
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_SERRCNT                  ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_IO_SIZE                  ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_ECC_EN                   ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRCONF                  ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRTIMING_ACTTOACT       HMC_CFG_ACT_TO_ACT                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRTIMING_RDTOMISS       ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRTIMING_WRTOMISS       ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRTIMING_BURSTLEN       ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRTIMING_RDTOWR         HMC_CFG_RD_TO_WR                  ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRTIMING_WRTORD         HMC_CFG_WR_TO_RD                  ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRTIMING_BWRATIO        ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRMODE_AUTOPRECHARGE    ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DDRMODE_BWRATIOEXTENDED  ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_READLATENCY              ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_ACTIVATE_RRD             HMC_CFG_ACT_TO_ACT_DIFF_BANK      ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_ACTIVATE_FAW             HMC_CFG_4_ACT_TO_ACT              ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_ACTIVATE_FAWBANK         ""                                ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DEVTODEV_BUSRDTORD       HMC_CFG_RD_TO_RD_DIFF_CHIP        ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DEVTODEV_BUSRDTOWR       HMC_CFG_RD_TO_WR_DIFF_CHIP        ]  
   def_enum      HPS_CFG         _AUTO_GEN_           [list    CONFIG_HPS_SDR_DEVTODEV_BUSWRTORD       HMC_CFG_WR_TO_RD_DIFF_CHIP        ]  
}


proc ::altera_emif::ip_arch_nf::enum_defs_hps::_init {} {
   ::altera_emif::ip_arch_nf::enum_defs_hps::def_enums
}

::altera_emif::ip_arch_nf::enum_defs_hps::_init

