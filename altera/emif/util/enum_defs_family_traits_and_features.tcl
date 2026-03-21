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


package provide altera_emif::util::enum_defs_family_traits_and_features 0.1

package require altera_emif::util::enums
package require altera_emif::util::qini
package require altera_emif::util::messaging

namespace eval ::altera_emif::util::enum_defs_family_traits_and_features:: {
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::messaging::*


}


proc ::altera_emif::util::enum_defs_family_traits_and_features::def_enums {} {

   def_enum_type FAMILY                                                  {     UI_NAME           IS_HPS   ARCH_COMPONENT         ECC_COMPONENT         CAL_SLAVE_COMPONENT          BASE_FAMILY_ENUM     QSYS_NAMES         MEGAFUNC_NAME  DEFAULT_PART_FOR_ED  }
   def_enum      FAMILY                 FAMILY_INVALID                   [list ""                false    ""                     ""                    ""                           FAMILY_INVALID       [list ]            ""             ""                   ]
   def_enum      FAMILY                 FAMILY_ARRIA10                   [list "Arria 10"        false    "altera_emif_arch_nf"  "altera_emif_ecc_nf"  "altera_emif_cal_slave_nf"   FAMILY_ARRIA10       [list ARRIA10]     "ARRIA 10"     "10AX115N1F40E1SG"   ]
   def_enum      FAMILY                 FAMILY_ARRIA10_HPS               [list "Arria 10 HPS"    true     "altera_emif_arch_nf"  "altera_emif_ecc_nf"  "altera_emif_cal_slave_nf"   FAMILY_ARRIA10       [list ARRIA10]     "ARRIA 10"     "10AS066K1F40E1SG"   ]
   def_enum      FAMILY                 FAMILY_STRATIX10                 [list "Stratix 10"      false    "altera_emif_arch_nd"  "altera_emif_ecc_nd"  "altera_emif_cal_slave_nd"   FAMILY_STRATIX10     [list STRATIX10]   "STRATIX 10"   "1SG280LU3F50E1VG"   ]
   def_enum      FAMILY                 FAMILY_STRATIX10_HPS             [list "Stratix 10 HPS"  true     "altera_emif_arch_nd"  "altera_emif_ecc_nd"  "altera_emif_cal_slave_nd"   FAMILY_STRATIX10     [list STRATIX10]   "STRATIX 10"   "1SG280LU3F50E1VG"   ]
   
   def_enum_type FEATURE                                                 {     UI_NAME  }
   def_enum      FEATURE                FEATURE_EMIF                     [list ""       ]
   def_enum      FEATURE                FEATURE_CONFIG                   [list ""       ]
   def_enum      FEATURE                FEATURE_PING_PONG                [list ""       ]
   def_enum      FEATURE                FEATURE_RATE                     [list ""       ]
   def_enum      FEATURE                FEATURE_FMAX_MHZ                 [list ""       ]
   def_enum      FEATURE                FEATURE_BURST_LENGTH             [list ""       ]
   def_enum      FEATURE                FEATURE_HMC_AVL_PROTOCOL         [list ""       ]   
   def_enum      FEATURE                FEATURE_SMC_AVL_PROTOCOL         [list ""       ]
   def_enum      FEATURE                FEATURE_RTL_SIM                  [list ""       ]
   def_enum      FEATURE                FEATURE_SEQ_SOFT_M20K            [list ""       ]
   def_enum      FEATURE                FEATURE_ABSTRACT_PHY             [list ""       ]
   def_enum      FEATURE                FEATURE_PERIODIC_OCT_RECAL       [list ""       ]
   
   def_enum_type FAMILY_TRAIT                                                 {     VERILOG_NAME             TYPE        IS_HDL_PARAM }
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_PINS_PER_LANE            [list "PINS_PER_LANE"          "integer"   true         ]
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_LANES_PER_TILE           [list "LANES_PER_TILE"         "integer"   true         ]
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_MAX_TILES_PER_IF         [list "MAX_TILES_PER_IF"       "integer"   false        ]
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_OCT_CONTROL_WIDTH        [list "OCT_CONTROL_WIDTH"      "integer"   true         ]
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_PLL_PFD_FMAX_MHZ         [list "PLL_PFD_FMAX_MHZ"       "integer"   false        ] 
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_PLL_PFD_FMIN_MHZ         [list "PLL_PFD_FMIN_MHZ"       "integer"   false        ] 
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_PLL_MIN_VCO_DIV          [list "PLL_MIN_VCO_DIV"        "integer"   false        ] 
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_IF_FMIN_MHZ              [list "IF_FMIN_MHZ"            "integer"   false        ] 
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_IF_FMAX_MHZ              [list "IF_FMAX_MHZ"            "integer"   false        ] 
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_SPEEDGRADES              [list "SPEEDGRADES"            "string"    false        ] 
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_DDR4_LRDIMM_PINOUT_BUG   [list "DDR4_LRDIMM_PINOUT_BUG" "string"    false        ] 
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_POD_VREF_MIN             [list "POD_VREF_MIN"           "float"     false        ] 
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_POD_VREF_MAX             [list "POD_VREF_MAX"           "float"     false        ] 
   def_enum      FAMILY_TRAIT           FAMILY_TRAIT_HMC_DDR4_CHIP_ID_MAX     [list "HMC_DDR4_CHIP_ID_MAX"   "integer"   false        ] 

   def_enum_type FAMILY_TRAIT_SPEC                  {     BASE_FAMILY_ENUM    FAMILY_TRAIT_ENUM                     VALUE                                                                       }
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_SPEEDGRADES              [list E1 I1  E2 I2  E3 I3]                                                  ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_PINS_PER_LANE            12                                                                          ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_LANES_PER_TILE           4                                                                           ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_MAX_TILES_PER_IF         8                                                                           ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_OCT_CONTROL_WIDTH        16                                                                          ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_PLL_PFD_FMAX_MHZ         325                                                                         ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_PLL_PFD_FMIN_MHZ         10                                                                          ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_PLL_MIN_VCO_DIV          4                                                                           ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_HMC_FMAX_MHZ             [dict create  ""  667  E1  667  I1  667  E2  534  I2  534  E3  467  I3  467]]  
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_IF_FMAX_MHZ              [dict create  "" 1334  E1 1334  I1 1334  E2 1334  I2 1334  E3 1200  I3 1200]]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_IF_FMIN_MHZ              [dict create  ""  134  E1  134  I1  134  E2  134  I2  134  E3  134  I3  134]]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_DDR4_LRDIMM_PINOUT_BUG   1                                                                           ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_POD_VREF_MIN             45                                                                          ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_POD_VREF_MAX             92.5                                                                        ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_ARRIA10      FAMILY_TRAIT_HMC_DDR4_CHIP_ID_MAX     0                                                                           ]
   
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_SPEEDGRADES              [list E1 I1 M1 E2 I2 M2 E3 I3 M3]                                           ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_PINS_PER_LANE            12                                                                          ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_LANES_PER_TILE           4                                                                           ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_MAX_TILES_PER_IF         8                                                                           ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_OCT_CONTROL_WIDTH        16                                                                          ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_PLL_PFD_FMAX_MHZ         325                                                                         ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_PLL_PFD_FMIN_MHZ         10                                                                          ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_PLL_MIN_VCO_DIV          4                                                                           ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_HMC_FMAX_MHZ             [dict create  ""  667  E1  667  I1  667  E2  600  I2  600  E3  467  I3  467]]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_IF_FMAX_MHZ              [dict create  "" 1334  E1 1334  I1 1334  E2 1334  I2 1334  E3 1200  I3 1200]]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_IF_FMIN_MHZ              [dict create  ""  134  E1  134  I1  134  E2  134  I2  134  E3  134  I3  134]]  
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_DDR4_LRDIMM_PINOUT_BUG   0                                                                           ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_POD_VREF_MIN             45                                                                          ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_POD_VREF_MAX             92.5                                                                        ]
   def_enum      FAMILY_TRAIT_SPEC      _AUTO_GEN_  [list FAMILY_STRATIX10    FAMILY_TRAIT_HMC_DDR4_CHIP_ID_MAX     2                                                                           ]

   def_enum_type FEATURE_SUPPORT_SPEC               {     FAMILY_ENUM         PROTOCOL_ENUM    RATE_ENUM     FEATURE_ENUM               VALUE                                           }

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_INVALID RATE_INVALID  FEATURE_SEQ_SOFT_M20K      1                                               ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL CONFIG_PHY_ONLY] ]   
if {[ini_is_on "emif_show_internal_settings"]} {
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_RATE               [list RATE_HALF RATE_QUARTER]                   ]
} else {   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_RATE               [list RATE_QUARTER]                             ]
}
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_BURST_LENGTH       [list DDR4_BL_BL8]                              ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_HALF     FEATURE_FMIN_MHZ           625                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_QUARTER  FEATURE_FMAX_MHZ           1334                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_QUARTER  FEATURE_FMIN_MHZ           625                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_PING_PONG          true                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_ABSTRACT_PHY       1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL true                                            ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL CONFIG_PHY_ONLY] ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_RATE               [list RATE_HALF RATE_QUARTER]                   ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_BURST_LENGTH       [list DDR3_BL_BL8]                              ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_HALF     FEATURE_FMIN_MHZ           300                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_QUARTER  FEATURE_FMAX_MHZ           1067                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_QUARTER  FEATURE_FMIN_MHZ           400                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_PING_PONG          true                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_ABSTRACT_PHY       1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL CONFIG_PHY_ONLY] ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_RATE               [list RATE_HALF RATE_QUARTER]                   ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_HALF     FEATURE_FMIN_MHZ           300                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_QUARTER  FEATURE_FMAX_MHZ           800                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_QUARTER  FEATURE_FMIN_MHZ           400                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_ABSTRACT_PHY       1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_ONLY]                          ]
if {[ini_is_on "emif_show_internal_settings"]} {
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_RATE               [list RATE_HALF RATE_QUARTER]                   ]
} else {   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_RATE               [list RATE_QUARTER]                             ]
}   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_HALF     FEATURE_FMIN_MHZ           200                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_QUARTER  FEATURE_FMAX_MHZ           1200                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_QUARTER  FEATURE_FMIN_MHZ           400                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_SMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_ABSTRACT_PHY       1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_SOFT_CTRL ]                ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_RATE               [list RATE_QUARTER]                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_HALF     FEATURE_FMIN_MHZ           300                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_QUARTER  FEATURE_FMAX_MHZ           1067                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_QUARTER  FEATURE_FMIN_MHZ           400                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_SMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_ABSTRACT_PHY       1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_SOFT_CTRL]                 ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_RATE               [list RATE_FULL RATE_HALF]                      ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_FULL     FEATURE_FMAX_MHZ           334                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_FULL     FEATURE_FMIN_MHZ           166                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_HALF     FEATURE_FMAX_MHZ           634                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_HALF     FEATURE_FMIN_MHZ           200                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_SMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_ABSTRACT_PHY       1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_EMIF               0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_SOFT_CTRL]                 ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_RATE               [list RATE_HALF]                                ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_HALF     FEATURE_FMAX_MHZ           534                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_HALF     FEATURE_FMIN_MHZ           200                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_SMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_INVALID RATE_INVALID  FEATURE_SEQ_SOFT_M20K      0                                               ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_RTL_SIM            0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL]                 ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_RATE               [list RATE_HALF]                                ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_BURST_LENGTH       [list DDR4_BL_BL8]                              ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_HALF     FEATURE_FMAX_MHZ           1334                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_HALF     FEATURE_FMIN_MHZ           625                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_ST]                     ]   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_RTL_SIM            0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL]                 ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_RATE               [list RATE_HALF]                                ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_BURST_LENGTH       [list DDR3_BL_BL8]                              ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_HALF     FEATURE_FMAX_MHZ           1067                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_HALF     FEATURE_FMIN_MHZ           300                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_ST]                     ]   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_EMIF               0                                               ]


   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_RLD3    RATE_INVALID  FEATURE_EMIF               0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_QDR4    RATE_INVALID  FEATURE_EMIF               0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_QDR2    RATE_INVALID  FEATURE_EMIF               0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_ARRIA10_HPS  PROTOCOL_RLD2    RATE_INVALID  FEATURE_EMIF               0                                               ]
      
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_INVALID RATE_INVALID  FEATURE_SEQ_SOFT_M20K      0                                               ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL CONFIG_PHY_ONLY] ]   
if {[ini_is_on "emif_show_internal_settings"]} {
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_RATE               [list RATE_HALF RATE_QUARTER]                   ]
} else {   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_RATE               [list RATE_QUARTER]                             ]
}
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_BURST_LENGTH       [list DDR4_BL_BL8]                              ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_HALF     FEATURE_FMIN_MHZ           625                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_QUARTER  FEATURE_FMAX_MHZ           1334                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_QUARTER  FEATURE_FMIN_MHZ           625                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_PING_PONG          true                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR4    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL CONFIG_PHY_ONLY] ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_RATE               [list RATE_HALF RATE_QUARTER]                   ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_BURST_LENGTH       [list DDR3_BL_BL8]                              ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_HALF     FEATURE_FMIN_MHZ           300                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_QUARTER  FEATURE_FMAX_MHZ           1067                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_QUARTER  FEATURE_FMIN_MHZ           400                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_PING_PONG          true                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_DDR3    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL CONFIG_PHY_ONLY] ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_RATE               [list RATE_HALF RATE_QUARTER]                   ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_HALF     FEATURE_FMIN_MHZ           300                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_QUARTER  FEATURE_FMAX_MHZ           800                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_QUARTER  FEATURE_FMIN_MHZ           400                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_ONLY]                          ]
if {[ini_is_on "emif_show_internal_settings"]} {
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_RATE               [list RATE_HALF RATE_QUARTER]                   ]
} else {   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_RATE               [list RATE_QUARTER]                             ]
}   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_HALF     FEATURE_FMIN_MHZ           200                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_QUARTER  FEATURE_FMAX_MHZ           1200                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_QUARTER  FEATURE_FMIN_MHZ           400                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_SMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD3    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_SOFT_CTRL ]                ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_RATE               [list RATE_QUARTER]                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_HALF     FEATURE_FMAX_MHZ           667                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_HALF     FEATURE_FMIN_MHZ           300                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_QUARTER  FEATURE_FMAX_MHZ           1067                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_QUARTER  FEATURE_FMIN_MHZ           400                                             ] 
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_SMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR4    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_SOFT_CTRL]                 ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_RATE               [list RATE_FULL RATE_HALF]                      ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_FULL     FEATURE_FMAX_MHZ           334                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_FULL     FEATURE_FMIN_MHZ           166                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_HALF     FEATURE_FMAX_MHZ           634                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_HALF     FEATURE_FMIN_MHZ           200                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_SMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_QDR2    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_EMIF               0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_RTL_SIM            1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_SOFT_CTRL]                 ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_RATE               [list RATE_HALF]                                ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_HALF     FEATURE_FMAX_MHZ           534                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_HALF     FEATURE_FMIN_MHZ           200                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_SMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_MM]                     ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10      PROTOCOL_RLD2    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_INVALID RATE_INVALID  FEATURE_SEQ_SOFT_M20K      0                                               ]
   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_INVALID RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_RTL_SIM            0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL]                 ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_RATE               [list RATE_HALF]                                ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_BURST_LENGTH       [list DDR4_BL_BL8]                              ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_HALF     FEATURE_FMAX_MHZ           1334                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_HALF     FEATURE_FMIN_MHZ           625                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_ST]                     ]   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR4    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_EMIF               1                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_RTL_SIM            0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_CONFIG             [list CONFIG_PHY_AND_HARD_CTRL]                 ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_RATE               [list RATE_HALF]                                ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_BURST_LENGTH       [list DDR3_BL_BL8]                              ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_HALF     FEATURE_FMAX_MHZ           1067                                            ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_HALF     FEATURE_FMIN_MHZ           300                                             ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_HMC_AVL_PROTOCOL   [list CTRL_AVL_PROTOCOL_ST]                     ]   
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_PING_PONG          false                                           ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_ABSTRACT_PHY       0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_DDR3    RATE_INVALID  FEATURE_PERIODIC_OCT_RECAL false                                           ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_LPDDR3  RATE_INVALID  FEATURE_EMIF               0                                               ]

   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_RLD3    RATE_INVALID  FEATURE_EMIF               0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_QDR4    RATE_INVALID  FEATURE_EMIF               0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_QDR2    RATE_INVALID  FEATURE_EMIF               0                                               ]
   def_enum      FEATURE_SUPPORT_SPEC   _AUTO_GEN_  [list FAMILY_STRATIX10_HPS  PROTOCOL_RLD2    RATE_INVALID  FEATURE_EMIF               0                                               ]
   
   
   def_enum_type OCT_IO_STD                              {     RZQ   RANGE_IN_OCT                                        RANGE_OUT_OCT                       RANGE_OUT_OCT_NO_CAL                     RANGE_CURRENT_ST         }
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_125        [list 240   [list 20    30 40       60    120              0]   [list    34 40                  ]   [list    34 40                       ]   [list                 ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_125_C1     [list 240   [list                                          0]   [list                           ]   [list                                ]   [list   4 6 8 10 12   ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_125_C2     [list 240   [list                                          0]   [list                           ]   [list                                ]   [list               16]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_135        [list 240   [list 20    30 40       60    120              0]   [list    34 40                  ]   [list    34 40                       ]   [list                 ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_135_C1     [list 240   [list                                          0]   [list                           ]   [list                                ]   [list   4 6 8 10 12   ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_135_C2     [list 240   [list                                          0]   [list                           ]   [list                                ]   [list               16]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_12         [list 240   [list                   60    120              0]   [list       40       60    240  ]   [list       40       60         240  ]   [list                 ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_12_C1      [list 240   [list                                          0]   [list                           ]   [list                                ]   [list   4 6 8 10 12   ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_12_C2      [list 240   [list                                          0]   [list                           ]   [list                                ]   [list               16]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_POD_12          [list 240   [list    34    40 48    60 80 120 240          0]   [list    34 40 48    60         ]   [list    34 40 48    60              ]   [list   4 6 8 10 12 16]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_HSUL_12         [list 240   [list                                 INFINITE  ]   [list    34 40 48    60 80      ]   [list    34 40 48    60 80           ]   [list                 ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_15         [list 240   [list 20    30 40       60    120              0]   [list    34 40                  ]   [list    34 40                       ]   [list                 ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_15_C1      [list 100   [list                50                        0]   [list             50            ]   [list                               0]   [list   4 6 8 10 12   ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_15_C2      [list 100   [list                50                        0]   [list 25                        ]   [list                               0]   [list       8       16]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_18_C1      [list 100   [list                50                        0]   [list             50            ]   [list                               0]   [list   4 6 8 10 12   ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_SSTL_18_C2      [list 100   [list                50                        0]   [list 25                        ]   [list                               0]   [list       8       16]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_HSTL_12_C1      [list 100   [list                50                        0]   [list             50            ]   [list                               0]   [list   4 6 8 10 12   ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_HSTL_12_C2      [list 100   [list                50                        0]   [list 25                        ]   [list                               0]   [list               16]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_HSTL_15_C1      [list 100   [list                50                        0]   [list             50            ]   [list                               0]   [list   4 6 8 10 12   ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_HSTL_15_C2      [list 100   [list                50                        0]   [list 25                        ]   [list                               0]   [list               16]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_HSTL_18_C1      [list 100   [list                50                        0]   [list             50            ]   [list                               0]   [list   4 6 8 10 12   ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_HSTL_18_C2      [list 100   [list                50                        0]   [list 25                        ]   [list                               0]   [list               16]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_CMOS_12         [list 100   [list                                          0]   [list                           ]   [list                                ]   [list 2 4 6 8         ]  ]
   def_enum      OCT_IO_STD   OCT_IO_STD_CMOS_15         [list 100   [list                                          0]   [list                           ]   [list                                ]   [list 2 4 6 8 10 12   ]  ]
}


proc ::altera_emif::util::enum_defs_family_traits_and_features::_init {} {
   ::altera_emif::util::enum_defs_family_traits_and_features::def_enums
   
   if {[emif_utest_enabled]} {
   
      emif_utest_start "::altera_emif::util::enum_defs_family_traits_and_features"
      
      set base_family_enums [list]
      foreach family_enum [enums_of_type FAMILY] {
         set base_family_enum [enum_data $family_enum BASE_FAMILY_ENUM]
         emif_assert { [enum_exists $base_family_enum] }
         if {$family_enum != "FAMILY_INVALID"} {
            lappend base_family_enums $base_family_enum
         }
      }
      
      set features_to_families [dict create]
      foreach rule_enum [enums_of_type FEATURE_SUPPORT_SPEC] {
         set feature_enum     [enum_data $rule_enum FEATURE_ENUM]
         set base_family_enum [enum_data $rule_enum BASE_FAMILY_ENUM]
         
         if {! [dict exists $features_to_families $feature_enum]} {
            dict set features_to_families $feature_enum [dict create $base_family_enum 1]
         } else {
            dict set features_to_families $feature_enum $base_family_enum 1
         }
      }
      
      foreach feature_enum [dict keys $features_to_families] {
         foreach base_family_enum $base_family_enums {
            emif_assert {[dict exists $features_to_families $feature_enum $base_family_enum]} \
               "Missing FEATURE_SUPPORT_SPEC rule for $feature_enum targeting $base_family_enum"
         }
      }
      
      emif_utest_pass
   }
}

::altera_emif::util::enum_defs_family_traits_and_features::_init



