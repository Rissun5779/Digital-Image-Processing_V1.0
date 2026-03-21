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


package provide altera_emif::util::enum_defs 0.1

package require altera_emif::util::enums

load_strings common_gui.properties

namespace eval ::altera_emif::util::enum_defs:: {
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::util::enum_defs::def_enums {} {

   def_enum_type FUNC                                                    {     MODULE_NAME   }
   def_enum      FUNC                   FUNC_PHY                         [list phy           ]
   def_enum      FUNC                   FUNC_MEM                         [list mem           ]
   def_enum      FUNC                   FUNC_BOARD                       [list board         ]
   def_enum      FUNC                   FUNC_CTRL                        [list ctrl          ]
   def_enum      FUNC                   FUNC_DIAG                        [list diag          ]
   def_enum      FUNC                   FUNC_EX_DESIGN                   [list ex_design     ]
   def_enum      FUNC                   FUNC_EX_DESIGN_GUI               [list ex_design_gui ]
   
   def_enum_type PROTOCOL                                                {     UI_NAME                        MODULE_NAME}
   def_enum      PROTOCOL               PROTOCOL_INVALID                 [list ""                             ""         ]
   def_enum      PROTOCOL               PROTOCOL_DDR3                    [list [get_string PROTOCOL_DDR3]     ddr3       ]
   def_enum      PROTOCOL               PROTOCOL_DDR4                    [list [get_string PROTOCOL_DDR4]     ddr4       ]
   def_enum      PROTOCOL               PROTOCOL_QDR2                    [list [get_string PROTOCOL_QDR2]     qdr2       ]
   def_enum      PROTOCOL               PROTOCOL_QDR4                    [list [get_string PROTOCOL_QDR4]     qdr4       ]
   def_enum      PROTOCOL               PROTOCOL_RLD2                    [list [get_string PROTOCOL_RLD2]     rld2       ]
   def_enum      PROTOCOL               PROTOCOL_RLD3                    [list [get_string PROTOCOL_RLD3]     rld3       ]
   def_enum      PROTOCOL               PROTOCOL_LPDDR3                  [list [get_string PROTOCOL_LPDDR3]   lpddr3     ]
   
   def_enum_type RATE                                                    {     UI_NAME    RATIO    }
   def_enum      RATE                   RATE_INVALID                     [list ""         0        ]   
   def_enum      RATE                   RATE_FULL                        [list "Full"     1        ]
   def_enum      RATE                   RATE_HALF                        [list "Half"     2        ]
   def_enum      RATE                   RATE_QUARTER                     [list "Quarter"  4        ] 

   def_enum_type CONFIG                                                  {     UI_NAME                       }
   def_enum      CONFIG                 CONFIG_PHY_AND_HARD_CTRL         [list "Hard PHY and Hard Controller"]
   def_enum      CONFIG                 CONFIG_PHY_AND_SOFT_CTRL         [list "Hard PHY and Soft Controller"]
   def_enum      CONFIG                 CONFIG_PHY_ONLY                  [list "Hard PHY Only"               ]
   
   def_enum_type CORE_CLKS_SHARING                                       {     UI_NAME      }
   def_enum      CORE_CLKS_SHARING      CORE_CLKS_SHARING_DISABLED       [list "No Sharing" ]   
   def_enum      CORE_CLKS_SHARING      CORE_CLKS_SHARING_MASTER         [list "Master"     ]
   def_enum      CORE_CLKS_SHARING      CORE_CLKS_SHARING_SLAVE          [list "Slave"      ]
      
   def_enum_type SIM_CAL_MODE                                            {     UI_NAME           }
   def_enum      SIM_CAL_MODE           SIM_CAL_MODE_SKIP                [list "Skip Calibration"]
   def_enum      SIM_CAL_MODE           SIM_CAL_MODE_FULL                [list "Full Calibration"]
    
   def_enum_type FAST_SIM_OVERRIDE                                       {     UI_NAME           }
   def_enum      FAST_SIM_OVERRIDE      FAST_SIM_OVERRIDE_DEFAULT        [list "Default"]
   def_enum      FAST_SIM_OVERRIDE      FAST_SIM_OVERRIDE_ENABLED        [list "Enabled"]
   def_enum      FAST_SIM_OVERRIDE      FAST_SIM_OVERRIDE_DISABLED       [list "Disabled"]
    
   def_enum_type CAL_DEBUG_EXPORT_MODE                                            {     UI_NAME           }
   def_enum      CAL_DEBUG_EXPORT_MODE           CAL_DEBUG_EXPORT_MODE_DISABLED                [list "Disabled"]
   def_enum      CAL_DEBUG_EXPORT_MODE           CAL_DEBUG_EXPORT_MODE_EXPORT                  [list "Export"]
   def_enum      CAL_DEBUG_EXPORT_MODE           CAL_DEBUG_EXPORT_MODE_JTAG                    [list "Add EMIF Debug Interface"]

   def_enum_type SOFT_NIOS_MODE                                            {     UI_NAME           }
   def_enum      SOFT_NIOS_MODE           SOFT_NIOS_MODE_DISABLED                [list "Disabled"]
   def_enum      SOFT_NIOS_MODE           SOFT_NIOS_MODE_ON_CHIP_DEBUG           [list "On-Chip Debug"]

   def_enum_type EFFMON_MODE                                            {     UI_NAME           }
   def_enum      EFFMON_MODE           EFFMON_MODE_DISABLED                [list "Disabled"]
   def_enum      EFFMON_MODE           EFFMON_MODE_EXPORT                  [list "Export"]
   def_enum      EFFMON_MODE           EFFMON_MODE_JTAG                    [list "Interface to EMIF Debug Toolkit"]
      
   def_enum_type MEM_FORMAT                                              {     UI_NAME             }
   def_enum      MEM_FORMAT             MEM_FORMAT_DISCRETE              [list "Component"         ]
   def_enum      MEM_FORMAT             MEM_FORMAT_UDIMM                 [list "UDIMM"             ]
   def_enum      MEM_FORMAT             MEM_FORMAT_RDIMM                 [list "RDIMM"             ]
   def_enum      MEM_FORMAT             MEM_FORMAT_LRDIMM                [list "LRDIMM"            ]
   def_enum      MEM_FORMAT             MEM_FORMAT_SODIMM                [list "SODIMM"            ]
   
   def_enum_type CTRL_AVL_PROTOCOL                                        {     UI_NAME               }
   def_enum      CTRL_AVL_PROTOCOL      CTRL_AVL_PROTOCOL_INVALID         [list ""                    ]
   def_enum      CTRL_AVL_PROTOCOL      CTRL_AVL_PROTOCOL_MM              [list "Avalon Memory-Mapped"]
   def_enum      CTRL_AVL_PROTOCOL      CTRL_AVL_PROTOCOL_ST              [list "Avalon Streaming"    ]
   
   def_enum_type IO_STD                                                   {     UI_NAME                              QSF_NAME                             DF_IO_STD            }
   def_enum      IO_STD                 IO_STD_INVALID                    [list ""                                   ""                                   IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_SSTL_12                    [list "SSTL-12"                            "SSTL-12"                            IO_STD_DF_SSTL_12    ]
   def_enum      IO_STD                 IO_STD_SSTL_12_C1                 [list "SSTL-12 Class I"                    "SSTL-12 Class I"                    IO_STD_DF_SSTL_12_C1 ]
   def_enum      IO_STD                 IO_STD_SSTL_12_C2                 [list "SSTL-12 Class II"                   "SSTL-12 Class II"                   IO_STD_DF_SSTL_12_C2 ]
   def_enum      IO_STD                 IO_STD_SSTL_125                   [list "SSTL-125"                           "SSTL-125"                           IO_STD_DF_SSTL_125   ]
   def_enum      IO_STD                 IO_STD_SSTL_125_C1                [list "SSTL-125 Class I"                   "SSTL-125 Class I"                   IO_STD_DF_SSTL_125_C1]
   def_enum      IO_STD                 IO_STD_SSTL_125_C2                [list "SSTL-125 Class II"                  "SSTL-125 Class II"                  IO_STD_DF_SSTL_125_C2]
   def_enum      IO_STD                 IO_STD_SSTL_135                   [list "SSTL-135"                           "SSTL-135"                           IO_STD_DF_SSTL_135   ]
   def_enum      IO_STD                 IO_STD_SSTL_135_C1                [list "SSTL-135 Class I"                   "SSTL-135 Class I"                   IO_STD_DF_SSTL_135_C1]
   def_enum      IO_STD                 IO_STD_SSTL_135_C2                [list "SSTL-135 Class II"                  "SSTL-135 Class II"                  IO_STD_DF_SSTL_135_C2]
   def_enum      IO_STD                 IO_STD_SSTL_15                    [list "SSTL-15"                            "SSTL-15"                            IO_STD_DF_SSTL_15    ]
   def_enum      IO_STD                 IO_STD_SSTL_15_C1                 [list "SSTL-15 Class I"                    "SSTL-15 Class I"                    IO_STD_DF_SSTL_15_C1 ]
   def_enum      IO_STD                 IO_STD_SSTL_15_C2                 [list "SSTL-15 Class II"                   "SSTL-15 Class II"                   IO_STD_DF_SSTL_15_C2 ]
   def_enum      IO_STD                 IO_STD_SSTL_18_C1                 [list "SSTL-18 Class I"                    "SSTL-18 Class I"                    IO_STD_DF_SSTL_18_C1 ]
   def_enum      IO_STD                 IO_STD_SSTL_18_C2                 [list "SSTL-18 Class II"                   "SSTL-18 Class II"                   IO_STD_DF_SSTL_18_C2 ]
   def_enum      IO_STD                 IO_STD_HSTL_12_C1                 [list "1.2-V HSTL Class I"                 "1.2-V HSTL Class I"                 IO_STD_DF_HSTL_12_C1 ]
   def_enum      IO_STD                 IO_STD_HSTL_12_C2                 [list "1.2-V HSTL Class II"                "1.2-V HSTL Class II"                IO_STD_DF_HSTL_12_C2 ]
   def_enum      IO_STD                 IO_STD_HSTL_15_C1                 [list "1.5-V HSTL Class I"                 "1.5-V HSTL Class I"                 IO_STD_DF_HSTL_15_C1 ]
   def_enum      IO_STD                 IO_STD_HSTL_15_C2                 [list "1.5-V HSTL Class II"                "1.5-V HSTL Class II"                IO_STD_DF_HSTL_15_C2 ]
   def_enum      IO_STD                 IO_STD_HSTL_18_C1                 [list "1.8-V HSTL Class I"                 "1.8-V HSTL Class I"                 IO_STD_DF_HSTL_18_C1 ]
   def_enum      IO_STD                 IO_STD_HSTL_18_C2                 [list "1.8-V HSTL Class II"                "1.8-V HSTL Class II"                IO_STD_DF_HSTL_18_C2 ]
   def_enum      IO_STD                 IO_STD_POD_12                     [list "1.2-V POD"                          "1.2-V POD"                          IO_STD_DF_POD_12     ]
   def_enum      IO_STD                 IO_STD_HSUL_12                    [list "1.2-V HSUL"                         "1.2-V HSUL"                         IO_STD_DF_HSUL_12    ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_12                 [list "Differential 1.2-V SSTL"            "Differential 1.2-V SSTL"            IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_12_C1              [list "Differential 1.2-V SSTL Class I"    "Differential 1.2-V SSTL Class I"    IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_12_C2              [list "Differential 1.2-V SSTL Class II"   "Differential 1.2-V SSTL Class II"   IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_125                [list "Differential 1.25-V SSTL"           "Differential 1.25-V SSTL"           IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_125_C1             [list "Differential 1.25-V SSTL Class I"   "Differential 1.25-V SSTL Class I"   IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_125_C2             [list "Differential 1.25-V SSTL Class II"  "Differential 1.25-V SSTL Class II"  IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_135                [list "Differential 1.35-V SSTL"           "Differential 1.35-V SSTL"           IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_135_C1             [list "Differential 1.35-V SSTL Class I"   "Differential 1.35-V SSTL Class I"   IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_135_C2             [list "Differential 1.35-V SSTL Class II"  "Differential 1.35-V SSTL Class II"  IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_15                 [list "Differential 1.5-V SSTL"            "Differential 1.5-V SSTL"            IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_15_C1              [list "Differential 1.5-V SSTL Class I"    "Differential 1.5-V SSTL Class I"    IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_15_C2              [list "Differential 1.5-V SSTL Class II"   "Differential 1.5-V SSTL Class II"   IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_18_C1              [list "Differential 1.8-V SSTL Class I"    "Differential 1.8-V SSTL Class I"    IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_SSTL_18_C2              [list "Differential 1.8-V SSTL Class II"   "Differential 1.8-V SSTL Class II"   IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_HSTL_12_C1              [list "Differential 1.2-V HSTL Class I"    "Differential 1.2-V HSTL Class I"    IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_HSTL_12_C2              [list "Differential 1.2-V HSTL Class II"   "Differential 1.2-V HSTL Class II"   IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_HSTL_15_C1              [list "Differential 1.5-V HSTL Class I"    "Differential 1.5-V HSTL Class I"    IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_HSTL_15_C2              [list "Differential 1.5-V HSTL Class II"   "Differential 1.5-V HSTL Class II"   IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_HSTL_18_C1              [list "Differential 1.8-V HSTL Class I"    "Differential 1.8-V HSTL Class I"    IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_HSTL_18_C2              [list "Differential 1.8-V HSTL Class II"   "Differential 1.8-V HSTL Class II"   IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_POD_12                  [list "Differential 1.2-V POD"             "Differential 1.2-V POD"             IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_DF_HSUL_12                 [list "Differential 1.2-V HSUL"            "Differential 1.2-V HSUL"            IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_LVDS                       [list "LVDS with On-Chip Termination"      "LVDS"                               IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_LVDS_NO_OCT                [list "LVDS without On-Chip Termination"   "LVDS"                               IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_CMOS_12                    [list "1.2-V"                              "1.2-V"                              IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_CMOS_15                    [list "1.5-V"                              "1.5-V"                              IO_STD_INVALID       ]
   def_enum      IO_STD                 IO_STD_CMOS_18                    [list "1.8-V"                              "1.8-V"                              IO_STD_INVALID       ]
   
   def_enum_type OUT_OCT                                                 {     UI_NAME                              QSF_NAME                             OHM   CALIBRATED  IS_OCT}
   def_enum      OUT_OCT                OUT_OCT_INVALID                  [list ""                                   ""                                   -1    0           1     ]
   def_enum      OUT_OCT                OUT_OCT_25_CAL                   [list "25 ohm with calibration"            "SERIES 25 OHM WITH CALIBRATION"     25    1           1     ]
   def_enum      OUT_OCT                OUT_OCT_25_NO_CAL                [list "25 ohm without calibration"         "SERIES 25 OHM WITHOUT CALIBRATION"  25    0           1     ]
   def_enum      OUT_OCT                OUT_OCT_34_CAL                   [list "34 ohm with calibration"            "SERIES 34 OHM WITH CALIBRATION"     34    1           1     ]
   def_enum      OUT_OCT                OUT_OCT_34_NO_CAL                [list "34 ohm without calibration"         "SERIES 34 OHM WITHOUT CALIBRATION"  34    0           1     ]
   def_enum      OUT_OCT                OUT_OCT_40_CAL                   [list "40 ohm with calibration"            "SERIES 40 OHM WITH CALIBRATION"     40    1           1     ]
   def_enum      OUT_OCT                OUT_OCT_40_NO_CAL                [list "40 ohm without calibration"         "SERIES 40 OHM WITHOUT CALIBRATION"  40    0           1     ]
   def_enum      OUT_OCT                OUT_OCT_48_CAL                   [list "48 ohm with calibration"            "SERIES 48 OHM WITH CALIBRATION"     48    1           1     ]
   def_enum      OUT_OCT                OUT_OCT_48_NO_CAL                [list "48 ohm without calibration"         "SERIES 48 OHM WITHOUT CALIBRATION"  48    0           1     ]
   def_enum      OUT_OCT                OUT_OCT_50_CAL                   [list "50 ohm with calibration"            "SERIES 50 OHM WITH CALIBRATION"     50    1           1     ]
   def_enum      OUT_OCT                OUT_OCT_50_NO_CAL                [list "50 ohm without calibration"         "SERIES 50 OHM WITHOUT CALIBRATION"  50    0           1     ]
   def_enum      OUT_OCT                OUT_OCT_60_CAL                   [list "60 ohm with calibration"            "SERIES 60 OHM WITH CALIBRATION"     60    1           1     ]
   def_enum      OUT_OCT                OUT_OCT_60_NO_CAL                [list "60 ohm without calibration"         "SERIES 60 OHM WITHOUT CALIBRATION"  60    0           1     ]
   def_enum      OUT_OCT                OUT_OCT_80_CAL                   [list "80 ohm with calibration"            "SERIES 80 OHM WITH CALIBRATION"     80    1           1     ]
   def_enum      OUT_OCT                OUT_OCT_80_NO_CAL                [list "80 ohm without calibration"         "SERIES 80 OHM WITHOUT CALIBRATION"  80    0           1     ]
   def_enum      OUT_OCT                OUT_OCT_240_CAL                  [list "240 ohm with calibration"           "SERIES 240 OHM WITH CALIBRATION"    240   1           1     ]
   def_enum      OUT_OCT                OUT_OCT_240_NO_CAL               [list "240 ohm without calibration"        "SERIES 240 OHM WITHOUT CALIBRATION" 240   0           1     ]
   def_enum      OUT_OCT                OUT_OCT_0                        [list "No termination"                     "OFF"                                -1    0           1     ]
   
   def_enum_type IN_OCT                                                  {     UI_NAME                              QSF_NAME                             OHM   CALIBRATED  IS_OCT}
   def_enum      IN_OCT                 IN_OCT_INVALID                   [list ""                                   ""                                   -1    0           1     ]
   def_enum      IN_OCT                 IN_OCT_20_CAL                    [list "20 ohm with calibration"            "PARALLEL 20 OHM WITH CALIBRATION"   20    1           1     ]
   def_enum      IN_OCT                 IN_OCT_25_CAL                    [list "25 ohm with calibration"            "PARALLEL 25 OHM WITH CALIBRATION"   25    1           1     ]
   def_enum      IN_OCT                 IN_OCT_30_CAL                    [list "30 ohm with calibration"            "PARALLEL 30 OHM WITH CALIBRATION"   30    1           1     ]
   def_enum      IN_OCT                 IN_OCT_34_CAL                    [list "34 ohm with calibration"            "PARALLEL 34 OHM WITH CALIBRATION"   34    1           1     ]
   def_enum      IN_OCT                 IN_OCT_40_CAL                    [list "40 ohm with calibration"            "PARALLEL 40 OHM WITH CALIBRATION"   40    1           1     ]
   def_enum      IN_OCT                 IN_OCT_48_CAL                    [list "48 ohm with calibration"            "PARALLEL 48 OHM WITH CALIBRATION"   48    1           1     ]
   def_enum      IN_OCT                 IN_OCT_50_CAL                    [list "50 ohm with calibration"            "PARALLEL 50 OHM WITH CALIBRATION"   50    1           1     ]
   def_enum      IN_OCT                 IN_OCT_60_CAL                    [list "60 ohm with calibration"            "PARALLEL 60 OHM WITH CALIBRATION"   60    1           1     ]
   def_enum      IN_OCT                 IN_OCT_80_CAL                    [list "80 ohm with calibration"            "PARALLEL 80 OHM WITH CALIBRATION"   80    1           1     ]
   def_enum      IN_OCT                 IN_OCT_120_CAL                   [list "120 ohm with calibration"           "PARALLEL 120 OHM WITH CALIBRATION"  120   1           1     ]
   def_enum      IN_OCT                 IN_OCT_240_CAL                   [list "240 ohm with calibration"           "PARALLEL 240 OHM WITH CALIBRATION"  240   1           1     ]
   def_enum      IN_OCT                 IN_OCT_INFINITE_CAL              [list "Unterminated Logic"                 "OFF"                                -1    1           1     ]
   def_enum      IN_OCT                 IN_OCT_0                         [list "No termination"                     "OFF"                                -1    0           1     ]
   def_enum      IN_OCT                 IN_OCT_DIFFERENTIAL              [list "Differential Input Rd"              "DIFFERENTIAL"                       100   0           1     ]
   
   def_enum_type CURRENT_ST                                              {     UI_NAME                   QSF_NAME  CALIBRATED IS_OCT}
   def_enum      CURRENT_ST             CURRENT_ST_INVALID               [list ""                        ""        0          0     ]
   def_enum      CURRENT_ST             CURRENT_ST_2                     [list "2 mA current strength"   "2mA"     0          0     ]
   def_enum      CURRENT_ST             CURRENT_ST_4                     [list "4 mA current strength"   "4mA"     0          0     ]
   def_enum      CURRENT_ST             CURRENT_ST_6                     [list "6 mA current strength"   "6mA"     0          0     ]
   def_enum      CURRENT_ST             CURRENT_ST_8                     [list "8 mA current strength"   "8mA"     0          0     ]
   def_enum      CURRENT_ST             CURRENT_ST_10                    [list "10 mA current strength"  "10mA"    0          0     ]
   def_enum      CURRENT_ST             CURRENT_ST_12                    [list "12 mA current strength"  "12mA"    0          0     ]
   def_enum      CURRENT_ST             CURRENT_ST_16                    [list "16 mA current strength"  "16mA"    0          0     ]

   def_enum_type VREF_MODE                                               {     QSF_NAME                            }
   def_enum      VREF_MODE              VREF_MODE_INVALID                [list ""                                  ]
   def_enum      VREF_MODE              VREF_MODE_EXTERNAL               [list "EXTERNAL"                          ]
   def_enum      VREF_MODE              VREF_MODE_CALIBRATED             [list "CALIBRATED"                        ]
   def_enum      VREF_MODE              VREF_MODE_CALIBRATED_RANGE_2     [list "CALIBRATED_SSTL"                   ]
   def_enum      VREF_MODE              VREF_MODE_VCCIO_45               [list "VCCIO_45"                          ]
   def_enum      VREF_MODE              VREF_MODE_VCCIO_50               [list "VCCIO_50"                          ]
   def_enum      VREF_MODE              VREF_MODE_VCCIO_55               [list "VCCIO_55"                          ]
   def_enum      VREF_MODE              VREF_MODE_VCCIO_65               [list "VCCIO_65"                          ]
   def_enum      VREF_MODE              VREF_MODE_VCCIO_70               [list "VCCIO_70"                          ]
   def_enum      VREF_MODE              VREF_MODE_VCCIO_75               [list "VCCIO_75"                          ]
      
   def_enum_type SLEW_RATE                                               {     UI_NAME   QSF_NAME                 }
   def_enum      SLEW_RATE              SLEW_RATE_INVALID                [list ""        ""                       ]
   def_enum      SLEW_RATE              SLEW_RATE_FAST                   [list "Fast"    1                        ]
   def_enum      SLEW_RATE              SLEW_RATE_SLOW                   [list "Slow"    0                        ]

   def_enum_type SEQ_ODT_MODE                                            {     VALUE }
   def_enum      SEQ_ODT_MODE           SEQ_ODT_MODE_ALWAYS_HIGH         [list "0111"                               ]
   def_enum      SEQ_ODT_MODE           SEQ_ODT_MODE_HIGH_ON_READ_WRITE  [list "0110"                               ]
   def_enum      SEQ_ODT_MODE           SEQ_ODT_MODE_HIGH_ON_WRITE       [list "0100"                               ]
   def_enum      SEQ_ODT_MODE           SEQ_ODT_MODE_HIGH_ON_READ        [list "0010"                               ]
   def_enum      SEQ_ODT_MODE           SEQ_ODT_MODE_ALWAYS_LOW          [list "0000"                               ]
   
   def_enum_type AVAIL_EX_DESIGNS                                        {     UI_NAME }
   def_enum      AVAIL_EX_DESIGNS       AVAIL_EX_DESIGNS_GEN_DESIGN      [list "EMIF Example Design"                ]
   
   def_enum_type HDL_FORMAT                                              {     UI_NAME }
   def_enum      HDL_FORMAT             HDL_FORMAT_VERILOG               [list "Verilog"                            ]
   def_enum      HDL_FORMAT             HDL_FORMAT_VHDL                  [list "VHDL"                               ]
   
   def_enum_type PERIODIC_OCT_RECAL                                        {     UI_NAME               }
   def_enum      PERIODIC_OCT_RECAL     PERIODIC_OCT_RECAL_AUTO            [list "Enable if supported" ]
   def_enum      PERIODIC_OCT_RECAL     PERIODIC_OCT_RECAL_DISABLE         [list "Disable"             ]   
   
   def_enum_type TARGET_DEV_KIT                                             {     UI_NAME                                                       FAMILY         DEVICE               DEVKIT_NAME}
   def_enum      TARGET_DEV_KIT         TARGET_DEV_KIT_NONE                 [list "none"                                                        ""             ""                   ""]
   def_enum      TARGET_DEV_KIT         TARGET_DEV_KIT_A10_GX_FPGA_DDR3     [list "Arria 10 GX FPGA Development Kit with DDR3 HILO"             "Arria 10"     "10AX115S2F45I1SG"   "Arria 10 GX FPGA Development Kit"]
   def_enum      TARGET_DEV_KIT         TARGET_DEV_KIT_A10_GX_FPGA_DDR4     [list "Arria 10 GX FPGA Development Kit with DDR4 HILO"             "Arria 10"     "10AX115S2F45I1SG"   "Arria 10 GX FPGA Development Kit"]
   def_enum      TARGET_DEV_KIT         TARGET_DEV_KIT_A10_GX_FPGA_RLDRAM3  [list "Arria 10 GX FPGA Development Kit with RLDRAM3 HILO"          "Arria 10"     "10AX115S2F45I1SG"   "Arria 10 GX FPGA Development Kit"]
   def_enum      TARGET_DEV_KIT         TARGET_DEV_KIT_A10_SOC_DDR4         [list "Arria 10 SoC Development Kit with DDR4 HILO for FPGA (x72)"  "Arria 10"     "10AS066N3F40I2SG"   "Arria 10 SoC Development Kit"]
   def_enum      TARGET_DEV_KIT         TARGET_DEV_KIT_HPS_A10_SOC_DDR4     [list "Arria 10 SoC Development Kit with DDR4 HILO for HPS (x40)"   "Arria 10"     "10AS066N3F40I2SG"   "Arria 10 SoC Development Kit"]
   
   def_enum_type DDR3_BL                                                 {     UI_NAME                                MRS    }
   def_enum      DDR3_BL                DDR3_BL_BL8                      [list "Fixed BL8"                            0      ]

   def_enum_type DDR3_BT                                                 {     UI_NAME          MRS   }
   def_enum      DDR3_BT                DDR3_BT_SEQUENTIAL               [list "Sequential"     0     ]
   def_enum      DDR3_BT                DDR3_BT_INTERLEAVED              [list "Interleaved"    1     ]

   def_enum_type DDR3_ASR                                                {     UI_NAME          MRS   }
   def_enum      DDR3_ASR               DDR3_ASR_MANUAL                  [list "Manual"         0     ]
   def_enum      DDR3_ASR               DDR3_ASR_AUTOMATIC               [list "Automatic"      1     ]

   def_enum_type DDR3_SRT                                                {     UI_NAME          MRS   }
   def_enum      DDR3_SRT               DDR3_SRT_NORMAL                  [list "Normal"         0     ]
   def_enum      DDR3_SRT               DDR3_SRT_EXTENDED                [list "Extended"       1     ]

   def_enum_type DDR3_PD                                                 {     UI_NAME          MRS   }
   def_enum      DDR3_PD                DDR3_PD_OFF                      [list "DLL off"         0    ]
   def_enum      DDR3_PD                DDR3_PD_ON                       [list "DLL on"          1    ]

   def_enum_type DDR3_DRV_STR                                            {     UI_NAME          MRS   }
   def_enum      DDR3_DRV_STR           DDR3_DRV_STR_RZQ_6               [list "RZQ/6"          0     ]
   def_enum      DDR3_DRV_STR           DDR3_DRV_STR_RZQ_7               [list "RZQ/7"          1     ] 
                                                                                                                      
   def_enum_type DDR3_RTT_NOM                                            {     UI_NAME                                 MRS   }
   def_enum      DDR3_RTT_NOM           DDR3_RTT_NOM_ODT_DISABLED        [list "ODT Disabled"                          0     ]
   def_enum      DDR3_RTT_NOM           DDR3_RTT_NOM_RZQ_4               [list "RZQ/4"                                 1     ] 
   def_enum      DDR3_RTT_NOM           DDR3_RTT_NOM_RZQ_2               [list "RZQ/2"                                 2     ] 
   def_enum      DDR3_RTT_NOM           DDR3_RTT_NOM_RZQ_6               [list "RZQ/6"                                 3     ] 
   def_enum      DDR3_RTT_NOM           DDR3_RTT_NOM_RZQ_12              [list "Non-Writes = RZQ/12, Write = N/A"      4     ] 
   def_enum      DDR3_RTT_NOM           DDR3_RTT_NOM_RZQ_8               [list "Non-Writes = RZQ/8, Write = N/A"       5     ] 

   def_enum_type DDR3_RTT_WR                                             {     UI_NAME                 MRS   }
   def_enum      DDR3_RTT_WR            DDR3_RTT_WR_ODT_DISABLED         [list "Dynamic ODT off"       0     ]
   def_enum      DDR3_RTT_WR            DDR3_RTT_WR_RZQ_4                [list "RZQ/4"                 1     ] 
   def_enum      DDR3_RTT_WR            DDR3_RTT_WR_RZQ_2                [list "RZQ/2"                 2     ] 

   def_enum_type DDR3_ATCL                                               {     UI_NAME                 MRS   VALUE }
   def_enum      DDR3_ATCL              DDR3_ATCL_DISABLED               [list "Disabled"              0     0     ]
   def_enum      DDR3_ATCL              DDR3_ATCL_CL1                    [list "CL-1"                  1     1     ] 
   def_enum      DDR3_ATCL              DDR3_ATCL_CL2                    [list "CL-2"                  2     2     ] 

   def_enum_type DDR3_TWR_CYC_RANGE                                      {     VALUE }
   def_enum      DDR3_TWR_CYC_RANGE     DDR3_TWR_CYC_RANGE_MIN           [list 5     ]
   def_enum      DDR3_TWR_CYC_RANGE     DDR3_TWR_CYC_RANGE_MAX           [list 16    ]

   def_enum_type DDR3_DEFAULT_RODT_1X1                                   { VALUE }
   def_enum      DDR3_DEFAULT_RODT_1X1  DDR3_DEFAULT_RODT_1X1_ODT0       [list "off"]

   def_enum_type DDR3_DEFAULT_WODT_1X1                                   { VALUE }
   def_enum      DDR3_DEFAULT_WODT_1X1  DDR3_DEFAULT_WODT_1X1_ODT0       [list  "on"]

   def_enum_type DDR3_DEFAULT_RODT_2X2                                   { VALUE }
   def_enum      DDR3_DEFAULT_RODT_2X2  DDR3_DEFAULT_RODT_2X2_ODT0       [list [list "off" "off"]]
   def_enum      DDR3_DEFAULT_RODT_2X2  DDR3_DEFAULT_RODT_2X2_ODT1       [list [list "off" "off"]]

   def_enum_type DDR3_DEFAULT_WODT_2X2                                   { VALUE }
   def_enum      DDR3_DEFAULT_WODT_2X2  DDR3_DEFAULT_WODT_2X2_ODT0       [list [list  "on"  "off"]]
   def_enum      DDR3_DEFAULT_WODT_2X2  DDR3_DEFAULT_WODT_2X2_ODT1       [list [list  "off" "on"]]

   def_enum_type DDR3_DEFAULT_RODT_4X2                                   { VALUE }
   def_enum      DDR3_DEFAULT_RODT_4X2  DDR3_DEFAULT_RODT_4X2_ODT0       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR3_DEFAULT_RODT_4X2  DDR3_DEFAULT_RODT_4X2_ODT1       [list [list  "on"  "on" "off" "off"]]

   def_enum_type DDR3_DEFAULT_WODT_4X2                                   { VALUE }
   def_enum      DDR3_DEFAULT_WODT_4X2  DDR3_DEFAULT_WODT_4X2_ODT0       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR3_DEFAULT_WODT_4X2  DDR3_DEFAULT_WODT_4X2_ODT1       [list [list  "on"  "on" "off" "off"]]

   def_enum_type DDR3_DEFAULT_RODT_4X4                                   { VALUE }
   def_enum      DDR3_DEFAULT_RODT_4X4  DDR3_DEFAULT_RODT_4X4_ODT0       [list [list "off" "off" "off" "off"]]
   def_enum      DDR3_DEFAULT_RODT_4X4  DDR3_DEFAULT_RODT_4X4_ODT1       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR3_DEFAULT_RODT_4X4  DDR3_DEFAULT_RODT_4X4_ODT2       [list [list "off" "off" "off" "off"]]
   def_enum      DDR3_DEFAULT_RODT_4X4  DDR3_DEFAULT_RODT_4X4_ODT3       [list [list  "on"  "on" "off" "off"]]

   def_enum_type DDR3_DEFAULT_WODT_4X4                                   { VALUE }
   def_enum      DDR3_DEFAULT_WODT_4X4  DDR3_DEFAULT_WODT_4X4_ODT0       [list [list  "on"  "on" "off" "off"]]
   def_enum      DDR3_DEFAULT_WODT_4X4  DDR3_DEFAULT_WODT_4X4_ODT1       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR3_DEFAULT_WODT_4X4  DDR3_DEFAULT_WODT_4X4_ODT2       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR3_DEFAULT_WODT_4X4  DDR3_DEFAULT_WODT_4X4_ODT3       [list [list  "on"  "on" "off" "off"]]
   
   def_enum_type DDR3_ALERT_N_PLACEMENT                                      {     UI_NAME }
   def_enum      DDR3_ALERT_N_PLACEMENT DDR3_ALERT_N_PLACEMENT_DATA_LANES    [list "I/O Lane with DQS Group" ]
   def_enum      DDR3_ALERT_N_PLACEMENT DDR3_ALERT_N_PLACEMENT_AC_LANES      [list "I/O Lane with Address/Command Pins" ]

   def_enum_type DDR3_CTRL_ADDR_ORDER                                    {     UI_NAME            }
   def_enum      DDR3_CTRL_ADDR_ORDER   DDR3_CTRL_ADDR_ORDER_CS_B_R_C    [list "Chip-Bank-Row-Col"]
   def_enum      DDR3_CTRL_ADDR_ORDER   DDR3_CTRL_ADDR_ORDER_CS_R_B_C    [list "Chip-Row-Bank-Col"] 
   def_enum      DDR3_CTRL_ADDR_ORDER   DDR3_CTRL_ADDR_ORDER_R_CS_B_C    [list "Row-Chip-Bank-Col"] 

   def_enum_type DDR3_VOLTAGE                                {     UI_NAME}
   def_enum      DDR3_VOLTAGE      DDR3_VOLTAGE_DDR3         [list  "DDR3"]
   def_enum      DDR3_VOLTAGE      DDR3_VOLTAGE_DDR3L        [list "DDR3L"]
   def_enum      DDR3_VOLTAGE      DDR3_VOLTAGE_DDR3U        [list "DDR3U"]
   
   def_enum_type DDR3_SPEEDBIN                               {     UI_NAME  VALUE   FMAX_MHZ   FMIN_MHZ    ALLOWED_VOLTAGES}         
   def_enum      DDR3_SPEEDBIN     DDR3_SPEEDBIN_800         [list  "-800"    800        400        300    {1.5 1.35 1.25} ]
   def_enum      DDR3_SPEEDBIN     DDR3_SPEEDBIN_1066        [list "-1066"   1066        534        300    {1.5 1.35 1.25} ]
   def_enum      DDR3_SPEEDBIN     DDR3_SPEEDBIN_1333        [list "-1333"   1333        667        300    {1.5 1.35 1.25} ]
   def_enum      DDR3_SPEEDBIN     DDR3_SPEEDBIN_1600        [list "-1600"   1600        800        300    {1.5 1.35 1.25} ]
   def_enum      DDR3_SPEEDBIN     DDR3_SPEEDBIN_1866        [list "-1866"   1866        934        300    {1.5 1.35}      ]
   def_enum      DDR3_SPEEDBIN     DDR3_SPEEDBIN_2133        [list "-2133"   2133       1067        300    {1.5 1.35}      ]
   
   def_enum_type DDR3_ACDC                                   {      ALLOWED_TIS_AC   ALLOWED_TIH_DC   ALLOWED_TDS_AC   ALLOWED_TDH_DC}
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3_800        [list  {175 150}        {100}            {175 150 135}    {100}         ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3_1066       [list  {175 150}        {100}            {175 150 135}    {100}         ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3_1333       [list  {175 150}        {100}            {150 135}        {100}         ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3_1600       [list  {175 150}        {100}            {150 135}        {100}         ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3_1866       [list  {135 125}        {100}            {135}            {100}         ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3_2133       [list  {135 125}        {100}            {135}            {100}         ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3L_800       [list  {160 135}        {90}             {160 135}        {90}          ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3L_1066      [list  {160 135}        {90}             {160 135}        {90}          ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3L_1333      [list  {160 135}        {90}             {135}            {90}          ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3L_1600      [list  {160 135}        {90}             {135}            {90}          ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3L_1866      [list  {135 125}        {90}             {130}            {90}          ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3L_2133      [list  {135 125}        {90}             {130}            {90}          ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3U_800       [list  {150 130}        {90}             {150 130}        {90}          ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3U_1066      [list  {150 130}        {90}             {150 130}        {90}          ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3U_1333      [list  {150 130}        {90}             {130}            {90}          ]
   def_enum      DDR3_ACDC         DDR3_ACDC_DDR3U_1600      [list  {150 130}        {90}             {130}            {90}          ]
      
   def_enum_type DDR4_BL                                                 {     UI_NAME                                MRS    }
   def_enum      DDR4_BL                DDR4_BL_BL8                      [list "Fixed BL8"                            0      ]

   def_enum_type DDR4_BT                                                 {     UI_NAME          MRS   }
   def_enum      DDR4_BT                DDR4_BT_SEQUENTIAL               [list "Sequential"     0     ]
   def_enum      DDR4_BT                DDR4_BT_INTERLEAVED              [list "Interleaved"    1     ]

   def_enum_type DDR4_ASR                                                {     UI_NAME          MRS   }
   def_enum      DDR4_ASR               DDR4_ASR_MANUAL_NORMAL           [list "Manual - Normal Temp. Range"         0     ]
   def_enum      DDR4_ASR               DDR4_ASR_MANUAL_REDUCED          [list "Manual - Reduced Temp. Range"        1     ]
   def_enum      DDR4_ASR               DDR4_ASR_MANUAL_EXTENDED         [list "Manual - Extended Temp. Range"       2     ]
   def_enum      DDR4_ASR               DDR4_ASR_AUTOMATIC               [list "Automatic"                           3     ]

   def_enum_type DDR4_SRT                                                {     UI_NAME          MRS   }
   def_enum      DDR4_SRT               DDR4_SRT_NORMAL                  [list "Normal"         0     ]
   def_enum      DDR4_SRT               DDR4_SRT_EXTENDED                [list "Extended"       1     ]

   def_enum_type DDR4_DRV_STR                                            {     UI_NAME                   MRS   OHM }
   def_enum      DDR4_DRV_STR           DDR4_DRV_STR_RZQ_7               [list "RZQ/7 (34 Ohm)"          0     34  ]
   def_enum      DDR4_DRV_STR           DDR4_DRV_STR_RZQ_5               [list "RZQ/5 (48 Ohm)"          1     48  ]
   def_enum      DDR4_DRV_STR           DDR4_DRV_STR_10                  [list "RZQ/6 (40 Ohm)"          2     40  ]
   def_enum      DDR4_DRV_STR           DDR4_DRV_STR_11                  [list "Reserved (2'b11)"        3     -1  ]

   def_enum_type DDR4_RTT_NOM                                            {     UI_NAME                   MRS   OHM }
   def_enum      DDR4_RTT_NOM           DDR4_RTT_NOM_ODT_DISABLED        [list "ODT Disabled"            0     -1  ]
   def_enum      DDR4_RTT_NOM           DDR4_RTT_NOM_RZQ_4               [list "RZQ/4 (60 Ohm)"          1     60  ] 
   def_enum      DDR4_RTT_NOM           DDR4_RTT_NOM_RZQ_2               [list "RZQ/2 (120 Ohm)"         2     120 ] 
   def_enum      DDR4_RTT_NOM           DDR4_RTT_NOM_RZQ_6               [list "RZQ/6 (40 Ohm)"          3     40  ] 
   def_enum      DDR4_RTT_NOM           DDR4_RTT_NOM_RZQ_1               [list "RZQ/1 (240 Ohm)"         4     240 ] 
   def_enum      DDR4_RTT_NOM           DDR4_RTT_NOM_RZQ_5               [list "RZQ/5 (48 Ohm)"          5     48  ] 
   def_enum      DDR4_RTT_NOM           DDR4_RTT_NOM_RZQ_3               [list "RZQ/3 (80 Ohm)"          6     80  ] 
   def_enum      DDR4_RTT_NOM           DDR4_RTT_NOM_RZQ_7               [list "RZQ/7 (34 Ohm)"          7     34  ] 

   def_enum_type DDR4_RTT_WR                                             {     UI_NAME                   MRS   OHM }
   def_enum      DDR4_RTT_WR            DDR4_RTT_WR_ODT_DISABLED         [list "Dynamic ODT off"         0     -1  ]
   def_enum      DDR4_RTT_WR            DDR4_RTT_WR_RZQ_2                [list "RZQ/2 (120 Ohm)"         1     120 ] 
   def_enum      DDR4_RTT_WR            DDR4_RTT_WR_RZQ_1                [list "RZQ/1 (240 Ohm)"         2     240 ] 
   def_enum      DDR4_RTT_WR            DDR4_RTT_WR_RZQ_HI_Z             [list "Hi-Z"                    3     -1  ] 
   def_enum      DDR4_RTT_WR            DDR4_RTT_WR_RZQ_3                [list "RZQ/3 (80 Ohm)"          4     80  ] 

   def_enum_type DDR4_RTT_PARK                                           {     UI_NAME                   MRS   OHM }
   def_enum      DDR4_RTT_PARK          DDR4_RTT_PARK_ODT_DISABLED       [list "Park ODT off"            0     -1  ]
   def_enum      DDR4_RTT_PARK          DDR4_RTT_PARK_RZQ_4              [list "RZQ/4 (60 Ohm)"          1     60  ]
   def_enum      DDR4_RTT_PARK          DDR4_RTT_PARK_RZQ_2              [list "RZQ/2 (120 Ohm)"         2     120 ]
   def_enum      DDR4_RTT_PARK          DDR4_RTT_PARK_RZQ_6              [list "RZQ/6 (40 Ohm)"          3     40  ]
   def_enum      DDR4_RTT_PARK          DDR4_RTT_PARK_RZQ_1              [list "RZQ/1 (240 Ohm)"         4     240 ]
   def_enum      DDR4_RTT_PARK          DDR4_RTT_PARK_RZQ_5              [list "RZQ/5 (48 Ohm)"          5     48  ]
   def_enum      DDR4_RTT_PARK          DDR4_RTT_PARK_RZQ_3              [list "RZQ/3 (80 Ohm)"          6     80  ]
   def_enum      DDR4_RTT_PARK          DDR4_RTT_PARK_RZQ_7              [list "RZQ/7 (34 Ohm)"          7     34  ]

   def_enum_type DDR4_ATCL                                               {     UI_NAME                 MRS   VALUE}
   def_enum      DDR4_ATCL              DDR4_ATCL_DISABLED               [list "Disabled"              0     0]
   def_enum      DDR4_ATCL              DDR4_ATCL_CL1                    [list "CL-1"                  1     1] 
   def_enum      DDR4_ATCL              DDR4_ATCL_CL2                    [list "CL-2"                  2     2] 

   def_enum_type DDR4_TWR_CYC_RANGE                                      {     VALUE }
   def_enum      DDR4_TWR_CYC_RANGE     DDR4_TWR_CYC_RANGE_MIN           [list 10     ]
   def_enum      DDR4_TWR_CYC_RANGE     DDR4_TWR_CYC_RANGE_MAX           [list 24     ]
  
   def_enum_type DDR4_GEARDOWN                                           {     UI_NAME          MRS   }
   def_enum      DDR4_GEARDOWN          DDR4_GEARDOWN_HR                 [list "Half Rate"         0     ]
   def_enum      DDR4_GEARDOWN          DDR4_GEARDOWN_QR                 [list "Quarter Rate"      1     ]

   def_enum_type DDR4_FINE_REFRESH                                           {     UI_NAME          MRS   }
   def_enum      DDR4_FINE_REFRESH      DDR4_FINE_REFRESH_FIXED_1X           [list "Fixed 1x"         0     ]
   def_enum      DDR4_FINE_REFRESH      DDR4_FINE_REFRESH_FIXED_2X           [list "Fixed 2x"         1     ]
   def_enum      DDR4_FINE_REFRESH      DDR4_FINE_REFRESH_FIXED_4X           [list "Fixed 4x"         2     ]
   def_enum      DDR4_FINE_REFRESH      DDR4_FINE_REFRESH_OTF_2X             [list "On-the-fly 2x"    5     ]
   def_enum      DDR4_FINE_REFRESH      DDR4_FINE_REFRESH_OTF_4X             [list "On-the-fly 4x"    6     ]

   def_enum_type DDR4_ALERT_N_PLACEMENT                                      {     UI_NAME }
   def_enum      DDR4_ALERT_N_PLACEMENT DDR4_ALERT_N_PLACEMENT_AUTO          [list "Automatically select a location" ]
   def_enum      DDR4_ALERT_N_PLACEMENT DDR4_ALERT_N_PLACEMENT_DATA_LANES    [list "I/O Lane with DQS Group" ]
   def_enum      DDR4_ALERT_N_PLACEMENT DDR4_ALERT_N_PLACEMENT_AC_LANES      [list "I/O Lane with Address/Command Pins" ]

   def_enum_type DDR4_DEFAULT_RODT_1X1                                   { VALUE }
   def_enum      DDR4_DEFAULT_RODT_1X1  DDR4_DEFAULT_RODT_1X1_ODT0       [list "off"]

   def_enum_type DDR4_DEFAULT_WODT_1X1                                   { VALUE }
   def_enum      DDR4_DEFAULT_WODT_1X1  DDR4_DEFAULT_WODT_1X1_ODT0       [list  "on"]

   def_enum_type DDR4_DEFAULT_RODT_2X2                                   { VALUE }
   def_enum      DDR4_DEFAULT_RODT_2X2  DDR4_DEFAULT_RODT_2X2_ODT0       [list [list "off" "off"]]
   def_enum      DDR4_DEFAULT_RODT_2X2  DDR4_DEFAULT_RODT_2X2_ODT1       [list [list "off" "off"]]

   def_enum_type DDR4_DEFAULT_WODT_2X2                                   { VALUE }
   def_enum      DDR4_DEFAULT_WODT_2X2  DDR4_DEFAULT_WODT_2X2_ODT0       [list [list  "on"  "off"]]
   def_enum      DDR4_DEFAULT_WODT_2X2  DDR4_DEFAULT_WODT_2X2_ODT1       [list [list  "off" "on"]]

   def_enum_type DDR4_DEFAULT_RODT_4X2                                   { VALUE }
   def_enum      DDR4_DEFAULT_RODT_4X2  DDR4_DEFAULT_RODT_4X2_ODT0       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR4_DEFAULT_RODT_4X2  DDR4_DEFAULT_RODT_4X2_ODT1       [list [list  "on"  "on" "off" "off"]]

   def_enum_type DDR4_DEFAULT_WODT_4X2                                   { VALUE }
   def_enum      DDR4_DEFAULT_WODT_4X2  DDR4_DEFAULT_WODT_4X2_ODT0       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR4_DEFAULT_WODT_4X2  DDR4_DEFAULT_WODT_4X2_ODT1       [list [list  "on"  "on" "off" "off"]]

   def_enum_type DDR4_DEFAULT_RODT_4X4                                   { VALUE }
   def_enum      DDR4_DEFAULT_RODT_4X4  DDR4_DEFAULT_RODT_4X4_ODT0       [list [list "off" "off" "off" "off"]]
   def_enum      DDR4_DEFAULT_RODT_4X4  DDR4_DEFAULT_RODT_4X4_ODT1       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR4_DEFAULT_RODT_4X4  DDR4_DEFAULT_RODT_4X4_ODT2       [list [list "off" "off" "off" "off"]]
   def_enum      DDR4_DEFAULT_RODT_4X4  DDR4_DEFAULT_RODT_4X4_ODT3       [list [list  "on"  "on" "off" "off"]]

   def_enum_type DDR4_DEFAULT_WODT_4X4                                   { VALUE }
   def_enum      DDR4_DEFAULT_WODT_4X4  DDR4_DEFAULT_WODT_4X4_ODT0       [list [list  "on"  "on" "off" "off"]]
   def_enum      DDR4_DEFAULT_WODT_4X4  DDR4_DEFAULT_WODT_4X4_ODT1       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR4_DEFAULT_WODT_4X4  DDR4_DEFAULT_WODT_4X4_ODT2       [list [list "off" "off"  "on"  "on"]]
   def_enum      DDR4_DEFAULT_WODT_4X4  DDR4_DEFAULT_WODT_4X4_ODT3       [list [list  "on"  "on" "off" "off"]]

   def_enum_type DDR4_LRDIMM_DEFAULT_ODT                                 { VALUE }
   def_enum      DDR4_LRDIMM_DEFAULT_ODT  DDR4_LRDIMM_DEFAULT_ODT_RODT   [list [list "off" "off" "off" "off"]]
   def_enum      DDR4_LRDIMM_DEFAULT_ODT  DDR4_LRDIMM_DEFAULT_ODT_WODT   [list [list "off" "off" "off" "off"]]

   
   def_enum_type DDR4_CTRL_ADDR_ORDER                                    {     UI_NAME                             VALID  MIGRATION_VALUE}
   def_enum      DDR4_CTRL_ADDR_ORDER   DDR4_CTRL_ADDR_ORDER_CS_BG_B_R_C [list "Chip-BG-Bank-Row-Col"              1      ""]
   def_enum      DDR4_CTRL_ADDR_ORDER   DDR4_CTRL_ADDR_ORDER_CS_R_B_C_BG [list "Chip-Row-Bank-Col-BG"              1      ""] 
   def_enum      DDR4_CTRL_ADDR_ORDER   DDR4_CTRL_ADDR_ORDER_R_CS_B_C_BG [list "Row-Chip-Bank-Col-BG"              1      ""]
   def_enum      DDR4_CTRL_ADDR_ORDER   DDR4_CTRL_ADDR_ORDER_CS_R_BG_B_C [list "Chip-Row-BG-Bank-Col"              0      "DDR4_CTRL_ADDR_ORDER_CS_R_B_C_BG"] 
   def_enum      DDR4_CTRL_ADDR_ORDER   DDR4_CTRL_ADDR_ORDER_R_CS_BG_B_C [list "Row-Chip-BG-Bank-Col"              0      "DDR4_CTRL_ADDR_ORDER_R_CS_B_C_BG"]
   
   def_enum_type DDR4_MPR_READ_FORMAT                                           {     UI_NAME          MRS   }
   def_enum      DDR4_MPR_READ_FORMAT      DDR4_MPR_READ_FORMAT_SERIAL           [list "Serial"         0     ]
   def_enum      DDR4_MPR_READ_FORMAT      DDR4_MPR_READ_FORMAT_PARALLEL         [list "Parallel"       1     ]
   def_enum      DDR4_MPR_READ_FORMAT      DDR4_MPR_READ_FORMAT_STAGGERED        [list "Staggered"      2     ]
   
   def_enum_type DDR4_TEMP_CONTROLLED_RFSH_RANGE                                      {     UI_NAME          MRS   }
   def_enum      DDR4_TEMP_CONTROLLED_RFSH_RANGE   DDR4_TEMP_CONTROLLED_RFSH_NORMAL   [list "Normal"         0     ]
   def_enum      DDR4_TEMP_CONTROLLED_RFSH_RANGE   DDR4_TEMP_CONTROLLED_RFSH_EXTENDED [list "Extended"       1     ]

   def_enum_type DDR4_AC_PARITY_LATENCY                                      {     UI_NAME          MRS    VALUE }
   def_enum      DDR4_AC_PARITY_LATENCY   DDR4_AC_PARITY_LATENCY_DISABLE     [list "Disabled"         0        0 ]
   def_enum      DDR4_AC_PARITY_LATENCY   DDR4_AC_PARITY_LATENCY_4           [list "4 CK"             1        4 ]
   def_enum      DDR4_AC_PARITY_LATENCY   DDR4_AC_PARITY_LATENCY_5           [list "5 CK"             2        5 ]
   def_enum      DDR4_AC_PARITY_LATENCY   DDR4_AC_PARITY_LATENCY_6           [list "6 CK"             3        6 ]
   def_enum      DDR4_AC_PARITY_LATENCY   DDR4_AC_PARITY_LATENCY_8           [list "8 CK"             4        8 ]
  
   def_enum_type DDR4_VREFDQ_TRAINING_RANGE                                  {     UI_NAME                    MRS   }
   def_enum      DDR4_VREFDQ_TRAINING_RANGE DDR4_VREFDQ_TRAINING_RANGE_0     [list "Range 1 - 60% to 92.5%"   0     ]
   def_enum      DDR4_VREFDQ_TRAINING_RANGE DDR4_VREFDQ_TRAINING_RANGE_1     [list "Range 2 - 45% to 77.5%"   1     ]
   

   def_enum_type DDR4_RCD_CA_IBT                                               {     UI_NAME                 SETTING   }
   def_enum      DDR4_RCD_CA_IBT           DDR4_RCD_CA_IBT_100                 [list "100 Ohm"               0         ]
   def_enum      DDR4_RCD_CA_IBT           DDR4_RCD_CA_IBT_150                 [list "150 Ohm"               1         ] 
   def_enum      DDR4_RCD_CA_IBT           DDR4_RCD_CA_IBT_300                 [list "300 Ohm"               2         ] 
   def_enum      DDR4_RCD_CA_IBT           DDR4_RCD_CA_IBT_OFF                 [list "Off"                   3         ] 

   def_enum_type DDR4_RCD_CS_IBT                                               {     UI_NAME                 SETTING   }
   def_enum      DDR4_RCD_CS_IBT           DDR4_RCD_CS_IBT_100                 [list "100 Ohm"               0         ]
   def_enum      DDR4_RCD_CS_IBT           DDR4_RCD_CS_IBT_150                 [list "150 Ohm"               1         ] 
   def_enum      DDR4_RCD_CS_IBT           DDR4_RCD_CS_IBT_300                 [list "300 Ohm"               2         ] 
   def_enum      DDR4_RCD_CS_IBT           DDR4_RCD_CS_IBT_OFF                 [list "Off"                   3         ] 

   def_enum_type DDR4_RCD_CKE_IBT                                              {     UI_NAME                 SETTING   }
   def_enum      DDR4_RCD_CKE_IBT          DDR4_RCD_CKE_IBT_100                [list "100 Ohm"               0         ]
   def_enum      DDR4_RCD_CKE_IBT          DDR4_RCD_CKE_IBT_150                [list "150 Ohm"               1         ] 
   def_enum      DDR4_RCD_CKE_IBT          DDR4_RCD_CKE_IBT_300                [list "300 Ohm"               2         ] 
   def_enum      DDR4_RCD_CKE_IBT          DDR4_RCD_CKE_IBT_OFF                [list "Off"                   3         ] 
   
   def_enum_type DDR4_RCD_ODT_IBT                                              {     UI_NAME                 SETTING   }
   def_enum      DDR4_RCD_ODT_IBT          DDR4_RCD_ODT_IBT_100                [list "100 Ohm"               0         ]
   def_enum      DDR4_RCD_ODT_IBT          DDR4_RCD_ODT_IBT_150                [list "150 Ohm"               1         ] 
   def_enum      DDR4_RCD_ODT_IBT          DDR4_RCD_ODT_IBT_300                [list "300 Ohm"               2         ] 
   def_enum      DDR4_RCD_ODT_IBT          DDR4_RCD_ODT_IBT_OFF                [list "Off"                   3         ] 
   
   def_enum_type DDR4_DB_RTT_NOM                                               {     UI_NAME                 SETTING    OHM   }
   def_enum      DDR4_DB_RTT_NOM           DDR4_DB_RTT_NOM_ODT_DISABLED        [list "RTT_NOM disabled"      0          -1    ]

   def_enum_type DDR4_DB_RTT_WR                                                {     UI_NAME                 SETTING    OHM   }
   def_enum      DDR4_DB_RTT_WR            DDR4_DB_RTT_WR_RZQ_4                [list "RZQ/4 (60 Ohm)"        1          60    ] 
   def_enum      DDR4_DB_RTT_WR            DDR4_DB_RTT_WR_RZQ_2                [list "RZQ/2 (120 Ohm)"       2          120   ] 
   def_enum      DDR4_DB_RTT_WR            DDR4_DB_RTT_WR_RZQ_1                [list "RZQ/1 (240 Ohm)"       4          240   ] 
   def_enum      DDR4_DB_RTT_WR            DDR4_DB_RTT_WR_RZQ_3                [list "RZQ/3 (80 Ohm)"        6          80    ] 
   def_enum      DDR4_DB_RTT_WR            DDR4_DB_RTT_WR_RZQ_HI_Z             [list "Hi-Z"                  7          -1    ] 

   def_enum_type DDR4_DB_RTT_PARK                                              {     UI_NAME                 SETTING    OHM   }
   def_enum      DDR4_DB_RTT_PARK          DDR4_DB_RTT_PARK_ODT_DISABLED       [list "RTT_PARK disabled"     0          -1    ]
   def_enum      DDR4_DB_RTT_PARK          DDR4_DB_RTT_PARK_RZQ_4              [list "RZQ/4 (60 Ohm)"        1          60    ] 
   def_enum      DDR4_DB_RTT_PARK          DDR4_DB_RTT_PARK_RZQ_2              [list "RZQ/2 (120 Ohm)"       2          120   ] 
   def_enum      DDR4_DB_RTT_PARK          DDR4_DB_RTT_PARK_RZQ_6              [list "RZQ/6 (40 Ohm)"        3          40    ] 
   def_enum      DDR4_DB_RTT_PARK          DDR4_DB_RTT_PARK_RZQ_1              [list "RZQ/1 (240 Ohm)"       4          240   ] 
   def_enum      DDR4_DB_RTT_PARK          DDR4_DB_RTT_PARK_RZQ_5              [list "RZQ/5 (48 Ohm)"        5          48    ] 
   def_enum      DDR4_DB_RTT_PARK          DDR4_DB_RTT_PARK_RZQ_3              [list "RZQ/3 (80 Ohm)"        6          80    ] 
   def_enum      DDR4_DB_RTT_PARK          DDR4_DB_RTT_PARK_RZQ_7              [list "RZQ/7 (34 Ohm)"        7          34    ]    
   
   def_enum_type DDR4_DB_DRV_STR                                               {     UI_NAME                 SETTING    OHM   }
   def_enum      DDR4_DB_DRV_STR           DDR4_DB_DRV_STR_RZQ_6               [list "RZQ/6 (40 Ohm)"        0          40    ]
   def_enum      DDR4_DB_DRV_STR           DDR4_DB_DRV_STR_RZQ_7               [list "RZQ/7 (34 Ohm)"        1          34    ]
   def_enum      DDR4_DB_DRV_STR           DDR4_DB_DRV_STR_RZQ_5               [list "RZQ/5 (48 Ohm)"        2          48    ]
   
   def_enum_type DDR4_SPD_145_DRV_STR                                          {     UI_NAME                 SETTING    OHM   }
   def_enum      DDR4_SPD_145_DRV_STR      DDR4_SPD_145_DRV_STR_RZQ_6          [list "RZQ/6 (40 Ohm)"        0          40    ]
   def_enum      DDR4_SPD_145_DRV_STR      DDR4_SPD_145_DRV_STR_RZQ_7          [list "RZQ/7 (34 Ohm)"        1          34    ]
   def_enum      DDR4_SPD_145_DRV_STR      DDR4_SPD_145_DRV_STR_RZQ_5          [list "RZQ/5 (48 Ohm)"        2          48    ]
   def_enum      DDR4_SPD_145_DRV_STR      DDR4_SPD_145_DRV_STR_RZQ_4          [list "RZQ/4 (60 Ohm)"        5          60    ]
   
   def_enum_type DDR4_SPD_145_RTT                                               {     UI_NAME                 SETTING    OHM   }
   def_enum      DDR4_SPD_145_RTT          DDR4_SPD_145_RTT_DISABLED            [list "Disabled"              0          -1    ]
   def_enum      DDR4_SPD_145_RTT          DDR4_SPD_145_RTT_RZQ_4               [list "RZQ/4 (60 Ohm)"        1          60    ]
   def_enum      DDR4_SPD_145_RTT          DDR4_SPD_145_RTT_RZQ_2               [list "RZQ/2 (120 Ohm)"       2          120   ]
   def_enum      DDR4_SPD_145_RTT          DDR4_SPD_145_RTT_RZQ_6               [list "RZQ/6 (40 Ohm)"        3          40    ]
   def_enum      DDR4_SPD_145_RTT          DDR4_SPD_145_RTT_RZQ_1               [list "RZQ/1 (240 Ohm)"       4          240   ]
   def_enum      DDR4_SPD_145_RTT          DDR4_SPD_145_RTT_RZQ_5               [list "RZQ/5 (48 Ohm)"        5          48    ]
   def_enum      DDR4_SPD_145_RTT          DDR4_SPD_145_RTT_RZQ_3               [list "RZQ/3 (80 Ohm)"        6          80    ]
   def_enum      DDR4_SPD_145_RTT          DDR4_SPD_145_RTT_RZQ_7               [list "RZQ/7 (34 Ohm)"        7          34    ]
   
   def_enum_type DDR4_VOLTAGE                                {     UI_NAME}
   def_enum      DDR4_VOLTAGE      DDR4_VOLTAGE_DDR4         [list  "DDR4"]
   
   def_enum_type DDR4_SPEEDBIN                               {     UI_NAME  VALUE   FMAX_MHZ   FMIN_MHZ    ALLOWED_VOLTAGES}         
   def_enum      DDR4_SPEEDBIN     DDR4_SPEEDBIN_1600        [list "-1600"   1600        800        625    {1.2}           ]
   def_enum      DDR4_SPEEDBIN     DDR4_SPEEDBIN_1866        [list "-1866"   1866        934        625    {1.2}           ]
   def_enum      DDR4_SPEEDBIN     DDR4_SPEEDBIN_2133        [list "-2133"   2133       1067        625    {1.2}           ]
   def_enum      DDR4_SPEEDBIN     DDR4_SPEEDBIN_2400        [list "-2400"   2400       1200        625    {1.2}           ]
   def_enum      DDR4_SPEEDBIN     DDR4_SPEEDBIN_2666        [list "-2666"   2666       1334        625    {1.2}           ]
   
   def_enum_type DDR4_ACDC                                   {      ALLOWED_TIS_AC   ALLOWED_TIH_DC   ALLOWED_TDS_AC   ALLOWED_TDH_DC}
   def_enum      DDR4_ACDC         DDR4_ACDC_DDR4_1600       [list  {100}            {75}            {100}            {75}         ]
   def_enum      DDR4_ACDC         DDR4_ACDC_DDR4_1866       [list  {100}            {75}            {100}            {75}         ]
   def_enum      DDR4_ACDC         DDR4_ACDC_DDR4_2133       [list  {100}            {75}            {100}            {75}         ]
   def_enum      DDR4_ACDC         DDR4_ACDC_DDR4_2400       [list  {100}            {75}            {100}            {75}         ]
   def_enum      DDR4_ACDC         DDR4_ACDC_DDR4_2666       [list  {100}            {75}            {100}            {75}         ]
   
   def_enum_type LPDDR3_SPEEDBIN                             {     UI_NAME  VALUE   FMAX_MHZ   FMIN_MHZ    ALLOWED_VOLTAGES}
   def_enum      LPDDR3_SPEEDBIN   LPDDR3_SPEEDBIN_1333      [list "-1333"   1333        667        400    {1.2}           ]
   def_enum      LPDDR3_SPEEDBIN   LPDDR3_SPEEDBIN_1600      [list "-1600"   1600        800        400    {1.2}           ]

   def_enum_type LPDDR3_ACDC                                 {      ALLOWED_TIS_AC   ALLOWED_TIH_DC   ALLOWED_TDS_AC   ALLOWED_TDH_DC}
   def_enum      LPDDR3_ACDC       LPDDR3_ACDC_LPDDR3_1333   [list  {150}            {100}            {150}            {100}         ]
   def_enum      LPDDR3_ACDC       LPDDR3_ACDC_LPDDR3_1600   [list  {150}            {100}            {150}            {100}         ]
   
   def_enum_type LPDDR3_BL                                   {     UI_NAME     MRS}
   def_enum      LPDDR3_BL         LPDDR3_BL_BL8             [list "Fixed BL8"   3]

   def_enum_type LPDDR3_NWR                                  {         UI_NAME  MRS  NWRE}
   def_enum      LPDDR3_NWR        LPDDR3_NWR_NWR3           [list     "nWR=3"    1     0]
   def_enum      LPDDR3_NWR        LPDDR3_NWR_NWR6           [list     "nWR=6"    4     0]
   def_enum      LPDDR3_NWR        LPDDR3_NWR_NWR8           [list     "nWR=8"    6     0]
   def_enum      LPDDR3_NWR        LPDDR3_NWR_NWR9           [list     "nWR=9"    7     0]
   def_enum      LPDDR3_NWR        LPDDR3_NWR_NWR10          [list    "nWR=10"    0     1]
   def_enum      LPDDR3_NWR        LPDDR3_NWR_NWR11          [list    "nWR=11"    1     1]
   def_enum      LPDDR3_NWR        LPDDR3_NWR_NWR12          [list    "nWR=12"    4     1]
   def_enum      LPDDR3_NWR        LPDDR3_NWR_NWR14          [list    "nWR=14"    6     1]
   def_enum      LPDDR3_NWR        LPDDR3_NWR_NWR16          [list    "nWR=16"    7     1]

   def_enum_type LPDDR3_DL                                   {     UI_NAME                    MRS  RL  WL  SET_B  FMAX_MHZ}
   def_enum      LPDDR3_DL         LPDDR3_DL_RL6_WL3         [list "RL=6, WL=3"                 4   6   3      0       400]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL8_WL4         [list "RL=8, WL=4"                 6   8   4      0       533]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL9_WL5         [list "RL=9, WL=5"                 7   9   5      0       600]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL10_WL6        [list "RL=10, WL=6"                8  10   6      0       667]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL10_WL8        [list "RL=10, WL=8"                8  10   8      1       667]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL11_WL6        [list "RL=11, WL=6"                9  11   6      0       733]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL11_WL9        [list "RL=11, WL=9"                9  11   9      1       733]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL12_WL6        [list "RL=12, WL=6"               10  12   6      0       800]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL12_WL9        [list "RL=12, WL=9"               10  12   9      1       800]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL14_WL8        [list "RL=14, WL=8"               12  14   8      0       933]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL14_WL11       [list "RL=14, WL=11"              12  14  11      1       933]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL16_WL8        [list "RL=16, WL=8"               14  16   8      0      1067]
   def_enum      LPDDR3_DL         LPDDR3_DL_RL16_WL13       [list "RL=16, WL=13"              14  16  13      1      1067]



   def_enum_type LPDDR3_WRLEVEL                              {     UI_NAME                        MRS}
   def_enum      LPDDR3_WRLEVEL    LPDDR3_WRLEVEL_DISABLED   [list "Disabled"                       0]
   def_enum      LPDDR3_WRLEVEL    LPDDR3_WRLEVEL_ENABLED    [list "Enabled"                        1]

   def_enum_type LPDDR3_DRV_STR                              {     UI_NAME                           MRS}
   def_enum      LPDDR3_DRV_STR    LPDDR3_DRV_STR_34D_34U    [list "34 ohm pull-down/pull-up"          1]
   def_enum      LPDDR3_DRV_STR    LPDDR3_DRV_STR_40D_40U    [list "40 ohm pull-down/pull-up"          2]
   def_enum      LPDDR3_DRV_STR    LPDDR3_DRV_STR_48D_48U    [list "48 ohm pull-down/pull-up"          3]
   def_enum      LPDDR3_DRV_STR    LPDDR3_DRV_STR_60D_60U    [list "60 ohm pull-down/pull-up"          4]
   def_enum      LPDDR3_DRV_STR    LPDDR3_DRV_STR_80D_80U    [list "80 ohm pull-down/pull-up"          6]
   def_enum      LPDDR3_DRV_STR    LPDDR3_DRV_STR_34D_40U    [list "34 ohm pull-down, 40 ohm pull-up"  9]
   def_enum      LPDDR3_DRV_STR    LPDDR3_DRV_STR_40D_48U    [list "40 ohm pull-down, 48 ohm pull-up" 10]
   def_enum      LPDDR3_DRV_STR    LPDDR3_DRV_STR_34D_48U    [list "34 ohm pull-down, 48 ohm pull-up" 11]

   def_enum_type LPDDR3_CALCODE                              {     UI_NAME                                     MRS}
   def_enum      LPDDR3_CALCODE    LPDDR3_CALCODE_POSTINIT   [list "Calibration command after initialization"  255]
   def_enum      LPDDR3_CALCODE    LPDDR3_CALCODE_LONG_CAL   [list "Long Calibration"                          171]
   def_enum      LPDDR3_CALCODE    LPDDR3_CALCODE_SHORT_CAL  [list "Short Calibration"                          86]
   def_enum      LPDDR3_CALCODE    LPDDR3_CALCODE_ZQ_RESET   [list "ZQ Reset"                                  195]

   def_enum_type LPDDR3_DQODT                                {     UI_NAME                                     MRS}
   def_enum      LPDDR3_DQODT      LPDDR3_DQODT_DISABLE      [list "Disabled"                                    0]
   def_enum      LPDDR3_DQODT      LPDDR3_DQODT_RZQ_4        [list "RZQ/4"                                       1]
   def_enum      LPDDR3_DQODT      LPDDR3_DQODT_RZQ_2        [list "RZQ/2"                                       2]
   def_enum      LPDDR3_DQODT      LPDDR3_DQODT_RZQ_1        [list "RZQ/1"                                       3]

   def_enum_type LPDDR3_PDODT                                {     UI_NAME                                     MRS}
   def_enum      LPDDR3_PDODT      LPDDR3_PDODT_DISABLED     [list "Disabled"                                    0]
   def_enum      LPDDR3_PDODT      LPDDR3_PDODT_ENABLED      [list "Enabled"                                     1]

   def_enum_type LPDDR3_DEFAULT_RODT_1X1                                   { VALUE }
   def_enum      LPDDR3_DEFAULT_RODT_1X1  LPDDR3_DEFAULT_RODT_1X1_ODT0     [list "off"]

   def_enum_type LPDDR3_DEFAULT_WODT_1X1                                   { VALUE }
   def_enum      LPDDR3_DEFAULT_WODT_1X1  LPDDR3_DEFAULT_WODT_1X1_ODT0     [list  "on"]

   def_enum_type LPDDR3_DEFAULT_RODT_2X2                                   { VALUE }
   def_enum      LPDDR3_DEFAULT_RODT_2X2  LPDDR3_DEFAULT_RODT_2X2_ODT0     [list [list "off" "off"]]
   def_enum      LPDDR3_DEFAULT_RODT_2X2  LPDDR3_DEFAULT_RODT_2X2_ODT1     [list [list "off" "off"]]

   def_enum_type LPDDR3_DEFAULT_WODT_2X2                                   { VALUE }
   def_enum      LPDDR3_DEFAULT_WODT_2X2  LPDDR3_DEFAULT_WODT_2X2_ODT0     [list [list  "on"  "on"]]
   def_enum      LPDDR3_DEFAULT_WODT_2X2  LPDDR3_DEFAULT_WODT_2X2_ODT1     [list [list "off" "off"]]

   def_enum_type LPDDR3_DEFAULT_RODT_4X4                                   { VALUE }
   def_enum      LPDDR3_DEFAULT_RODT_4X4  LPDDR3_DEFAULT_RODT_4X4_ODT0     [list [list "off" "off" "off" "off"]]
   def_enum      LPDDR3_DEFAULT_RODT_4X4  LPDDR3_DEFAULT_RODT_4X4_ODT1     [list [list "off" "off" "off" "off"]]
   def_enum      LPDDR3_DEFAULT_RODT_4X4  LPDDR3_DEFAULT_RODT_4X4_ODT2     [list [list "off" "off" "off" "off"]]
   def_enum      LPDDR3_DEFAULT_RODT_4X4  LPDDR3_DEFAULT_RODT_4X4_ODT3     [list [list "off" "off" "off" "off"]]

   def_enum_type LPDDR3_DEFAULT_WODT_4X4                                   { VALUE }
   def_enum      LPDDR3_DEFAULT_WODT_4X4  LPDDR3_DEFAULT_WODT_4X4_ODT0     [list [list  "on"  "on"  "on"  "on"]]
   def_enum      LPDDR3_DEFAULT_WODT_4X4  LPDDR3_DEFAULT_WODT_4X4_ODT1     [list [list "off" "off" "off" "off"]]
   def_enum      LPDDR3_DEFAULT_WODT_4X4  LPDDR3_DEFAULT_WODT_4X4_ODT2     [list [list "off" "off" "off" "off"]]
   def_enum      LPDDR3_DEFAULT_WODT_4X4  LPDDR3_DEFAULT_WODT_4X4_ODT3     [list [list "off" "off" "off" "off"]]

   def_enum_type LPDDR3_CTRL_ADDR_ORDER                                      {     UI_NAME            }
   def_enum      LPDDR3_CTRL_ADDR_ORDER   LPDDR3_CTRL_ADDR_ORDER_CS_B_R_C    [list "Chip-Bank-Row-Col"]
   def_enum      LPDDR3_CTRL_ADDR_ORDER   LPDDR3_CTRL_ADDR_ORDER_CS_R_B_C    [list "Chip-Row-Bank-Col"] 
   def_enum      LPDDR3_CTRL_ADDR_ORDER   LPDDR3_CTRL_ADDR_ORDER_R_CS_B_C    [list "Row-Chip-Bank-Col"] 

   def_enum_type RLD3_SPEEDBIN                               {     UI_NAME  VALUE   FMAX_MHZ   FMIN_MHZ    ALLOWED_VOLTAGES}         
   def_enum      RLD3_SPEEDBIN     RLD3_SPEEDBIN_125         [list "-125"    1600        800        200    {1.2}           ]
   def_enum      RLD3_SPEEDBIN     RLD3_SPEEDBIN_125E        [list "-125E"   1600        800        200    {1.2}           ]
   def_enum      RLD3_SPEEDBIN     RLD3_SPEEDBIN_107         [list "-107"    1866        934        200    {1.2}           ]
   def_enum      RLD3_SPEEDBIN     RLD3_SPEEDBIN_107E        [list "-107E"   1866        934        200    {1.2}           ]
   def_enum      RLD3_SPEEDBIN     RLD3_SPEEDBIN_093         [list "-093"    2133       1067        200    {1.2}           ]
   def_enum      RLD3_SPEEDBIN     RLD3_SPEEDBIN_093E        [list "-093E"   2133       1067        200    {1.2}           ]
   def_enum      RLD3_SPEEDBIN     RLD3_SPEEDBIN_083         [list "-083"    2400       1200        200    {1.2}           ]
   
   def_enum_type RLD3_ACDC                                   {      ALLOWED_TIS_AC   ALLOWED_TIH_DC   ALLOWED_TDS_AC   ALLOWED_TDH_DC}
   def_enum      RLD3_ACDC         RLD3_ACDC_ALL		         [list  {150 120}        {100}            {150 120}    {100}         ]
   
   def_enum_type RLD3_DL                                                 {     UI_NAME         MRS   RL   WL}
   def_enum      RLD3_DL                RLD3_DL_RL3_WL4                  [list "RL=3, WL=4"    0     3    4 ]
   def_enum      RLD3_DL                RLD3_DL_RL4_WL5                  [list "RL=4, WL=5"    1     4    5 ]
   def_enum      RLD3_DL                RLD3_DL_RL5_WL6                  [list "RL=5, WL=6"    2     5    6 ]
   def_enum      RLD3_DL                RLD3_DL_RL6_WL7                  [list "RL=6, WL=7"    3     6    7 ]
   def_enum      RLD3_DL                RLD3_DL_RL7_WL8                  [list "RL=7, WL=8"    4     7    8 ]
   def_enum      RLD3_DL                RLD3_DL_RL8_WL9                  [list "RL=8, WL=9"    5     8    9 ] 
   def_enum      RLD3_DL                RLD3_DL_RL9_WL10                 [list "RL=9, WL=10"   6     9    10]
   def_enum      RLD3_DL                RLD3_DL_RL10_WL11                [list "RL=10, WL=11"  7     10   11]
   def_enum      RLD3_DL                RLD3_DL_RL11_WL12                [list "RL=11, WL=12"  8     11   12]
   def_enum      RLD3_DL                RLD3_DL_RL12_WL13                [list "RL=12, WL=13"  9     12   13]
   def_enum      RLD3_DL                RLD3_DL_RL13_WL14                [list "RL=13, WL=14"  10    13   14]
   def_enum      RLD3_DL                RLD3_DL_RL14_WL15                [list "RL=14, WL=15"  11    14   15]
   def_enum      RLD3_DL                RLD3_DL_RL15_WL16                [list "RL=15, WL=16"  12    15   16]
   def_enum      RLD3_DL                RLD3_DL_RL16_WL17                [list "RL=16, WL=17"  13    16   17]
   def_enum      RLD3_DL                RLD3_DL_RL17_WL18                [list "RL=17, WL=18"  14    17   18]
   def_enum      RLD3_DL                RLD3_DL_RL18_WL19                [list "RL=18, WL=19"  15    18   19]
   
   def_enum_type RLD3_TRC                                                {     UI_NAME      MRS   TRC}
   def_enum      RLD3_TRC               RLD3_TRC_2                       [list "tRC=2"      0     2  ]
   def_enum      RLD3_TRC               RLD3_TRC_3                       [list "tRC=3"      1     3  ]
   def_enum      RLD3_TRC               RLD3_TRC_4                       [list "tRC=4"      2     4  ]
   def_enum      RLD3_TRC               RLD3_TRC_5                       [list "tRC=5"      3     5  ]
   def_enum      RLD3_TRC               RLD3_TRC_6                       [list "tRC=6"      4     6  ]
   def_enum      RLD3_TRC               RLD3_TRC_7                       [list "tRC=7"      5     7  ]
   def_enum      RLD3_TRC               RLD3_TRC_8                       [list "tRC=8"      6     8  ]
   def_enum      RLD3_TRC               RLD3_TRC_9                       [list "tRC=9"      7     9  ]
   def_enum      RLD3_TRC               RLD3_TRC_10                      [list "tRC=10"     8     10 ]
   def_enum      RLD3_TRC               RLD3_TRC_11                      [list "tRC=11"     9     11 ]
   def_enum      RLD3_TRC               RLD3_TRC_12                      [list "tRC=12"     10    12 ]

   def_enum_type RLD3_OUTPUT_DRIVE                                       {     UI_NAME              MRS}
   def_enum      RLD3_OUTPUT_DRIVE      RLD3_OUTPUT_DRIVE_40             [list "RZQ/6 (40 Ohm)"     0  ]
   def_enum      RLD3_OUTPUT_DRIVE      RLD3_OUTPUT_DRIVE_60             [list "RZQ/4 (60 Ohm)"     1  ]

   def_enum_type RLD3_ODT                                                {     UI_NAME              MRS}
   def_enum      RLD3_ODT               RLD3_ODT_OFF                     [list "Off"                0  ]
   def_enum      RLD3_ODT               RLD3_ODT_40                      [list "RZQ/6 (40 Ohm)"     1  ]
   def_enum      RLD3_ODT               RLD3_ODT_60                      [list "RZQ/4 (60 Ohm)"     2  ]
   def_enum      RLD3_ODT               RLD3_ODT_120                     [list "RZQ/2 (120 Ohm)"    3  ]

   def_enum_type RLD3_AREF                                               {     UI_NAME                   MRS}
   def_enum      RLD3_AREF              RLD3_AREF_BAC                    [list "Bank Address Control"    0  ]
   def_enum      RLD3_AREF              RLD3_AREF_MB                     [list "Multibank"               1  ] 

   def_enum_type RLD3_WRITE                                              {     UI_NAME                   MRS}
   def_enum      RLD3_WRITE             RLD3_WRITE_1BANK                 [list "Single Bank"             0  ]
   def_enum      RLD3_WRITE             RLD3_WRITE_2BANK                 [list "Dual Bank"               1  ]
   def_enum      RLD3_WRITE             RLD3_WRITE_4BANK                 [list "Quad Bank"               2  ]
   
   def_enum_type RLD3_CTRL_ADDR_ORDER                                    {     UI_NAME            }
   def_enum      RLD3_CTRL_ADDR_ORDER   RLD3_CTRL_ADDR_ORDER_CS_B_R_C    [list "Chip-Bank-Row-Col"]
   def_enum      RLD3_CTRL_ADDR_ORDER   RLD3_CTRL_ADDR_ORDER_CS_R_B_C    [list "Chip-Row-Bank-Col"]
   def_enum      RLD3_CTRL_ADDR_ORDER   RLD3_CTRL_ADDR_ORDER_R_CS_B_C    [list "Row-Chip-Bank-Col"]

   def_enum_type RLD2_SPEEDBIN                               {   UI_NAME    FMAX_MHZ   FMIN_MHZ    ALLOWED_VOLTAGES}
   def_enum      RLD2_SPEEDBIN     RLD2_SPEEDBIN_18          [list "-18"    533.333    175.0       {1.8 1.5}       ]
   def_enum      RLD2_SPEEDBIN     RLD2_SPEEDBIN_25          [list "-25"    400.0      175.0       {1.8 1.5}       ]
   def_enum      RLD2_SPEEDBIN     RLD2_SPEEDBIN_25E         [list "-25E"   400.0      175.0       {1.8 1.5}       ]
   def_enum      RLD2_SPEEDBIN     RLD2_SPEEDBIN_33          [list "-33"    300.0      175.0       {1.8 1.5}       ]

   def_enum_type RLD2_CONFIG                                     {     UI_NAME                                 MRS      TRC    TRL   TWL}
   def_enum      RLD2_CONFIG RLD2_CONFIG_TRC_4_TRL_4_TWL_5       [list "tRC=4, tRL=4, tWL=5, f=266-175MHz"     1        4      4     5  ]
   def_enum      RLD2_CONFIG RLD2_CONFIG_TRC_6_TRL_6_TWL_7       [list "tRC=6, tRL=6, tWL=7, f=400-175MHz"     2        6      6     7  ]
   def_enum      RLD2_CONFIG RLD2_CONFIG_TRC_8_TRL_8_TWL_9       [list "tRC=8, tRL=8, tWL=9, f=533-175MHz"     3        8      8     9  ]
   def_enum      RLD2_CONFIG RLD2_CONFIG_TRC_3_TRL_3_TWL_4       [list "tRC=3, tRL=3, tWL=4, f=200-175MHz"     4        4      3     4  ]
   def_enum      RLD2_CONFIG RLD2_CONFIG_TRC_5_TRL_5_TWL_6       [list "tRC=5, tRL=5, tWL=6, f=333-175MHz"     5        5      5     6  ]
   
   def_enum_type RLD2_DRIVE_IMPEDENCE                                           {      UI_NAME           MRS}
   def_enum      RLD2_DRIVE_IMPEDENCE RLD2_DRIVE_IMPEDENCE_INTERNAL_50          [list "Internal 50 Ohm"  0  ] 
   def_enum      RLD2_DRIVE_IMPEDENCE RLD2_DRIVE_IMPEDENCE_EXTERNAL_ZQ          [list "External (ZQ)"    1  ]

   def_enum_type RLD2_ODT                                           {  UI_NAME           MRS}
   def_enum      RLD2_ODT RLD2_ODT_OFF                              [list "Off"          0  ]
   def_enum      RLD2_ODT RLD2_ODT_ON                               [list "On"           1  ]

   def_enum_type TILE_SKEW                                               {     PKG_SKEW           }
   def_enum      TILE_SKEW              PINS_4                           [list 0.1                ]
   def_enum      TILE_SKEW              PINS_8                           [list 0.1                ]
   def_enum      TILE_SKEW              PINS_9                           [list 0.1                ]
   def_enum      TILE_SKEW              PINS_16                          [list 0.1                ]
   def_enum      TILE_SKEW              PINS_18                          [list 0.1                ]
   def_enum      TILE_SKEW              PINS_32                          [list 0.16               ]
   def_enum      TILE_SKEW              PINS_36                          [list 0.16               ]
 
   def_enum_type QDR2_SPEEDBIN                               {     UI_NAME    VALUE       FMAX_MHZ    FMIN_MHZ    ALLOWED_VOLTAGES}         
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_250         [list  "250"     250.0       250.0       166         [list 1.8 1.5] ]
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_300         [list  "300"     300.0       300.0       166         [list 1.8 1.5] ]
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_333         [list  "333"     333.333     333.333     166         [list 1.8 1.5] ]
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_350         [list  "350"     350.0       350.0       200         [list 1.8 1.5] ]
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_400         [list  "400"     400.0       400.0       200         [list 1.8 1.5] ]
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_450         [list  "450"     450.0       450.0       200         [list 1.8 1.5] ]
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_500         [list  "500"     500.0       500.0       200         [list 1.8 1.5] ]
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_550         [list  "550"     550.0       550.0       200         [list 1.8 1.5] ]
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_600         [list  "600"     600.0       600.0       200         [list 1.5] ]
   def_enum      QDR2_SPEEDBIN     QDR2_SPEEDBIN_633         [list  "633"     633.333     633.333     200         [list 1.5] ]
   
   def_enum_type QDR4_OUTPUT_DRIVE                                       {     UI_NAME              MRS}
   def_enum      QDR4_OUTPUT_DRIVE      QDR4_OUTPUT_DRIVE_17_PCT         [list "16.67% of ZT"       1  ]
   def_enum      QDR4_OUTPUT_DRIVE      QDR4_OUTPUT_DRIVE_25_PCT         [list "25% of ZT"          2  ]

   def_enum_type QDR4_ODT                                                {     UI_NAME              MRS}
   def_enum      QDR4_ODT               QDR4_ODT_OFF                     [list "Off"                0  ]
   def_enum      QDR4_ODT               QDR4_ODT_25_PCT                  [list "25% of ZT"          4  ]
   def_enum      QDR4_ODT               QDR4_ODT_50_PCT                  [list "50% of ZT"          5  ]
   
   def_enum_type QDR4_SPEEDBIN                               {    UI_NAME    VALUE      FMAX_MHZ   FMIN_MHZ    ALLOWED_VOLTAGES}
   def_enum      QDR4_SPEEDBIN     QDR4_SPEEDBIN_1866        [list "1866"    933.333    933.333    466.667     {1.2}           ]
   def_enum      QDR4_SPEEDBIN     QDR4_SPEEDBIN_2133        [list "2133"    1066.667   1066.667   533.333     {1.2}           ]
}


proc ::altera_emif::util::enum_defs::_init {} {
   ::altera_emif::util::enum_defs::def_enums
}

::altera_emif::util::enum_defs::_init



