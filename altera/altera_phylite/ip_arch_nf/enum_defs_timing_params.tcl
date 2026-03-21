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


package provide altera_phylite::ip_arch_nf::enum_defs_timing_params 0.1

package require altera_emif::util::enums

namespace eval ::altera_phylite::ip_arch_nf::enum_defs_timing_params:: {
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_phylite::ip_arch_nf::enum_defs_timing_params::def_enums {} {

   def_enum_type TPARAM                                       {     TCL_NAME                      }
   
   def_enum_type TPARAM_HWTCL                                   {     HWTCL_PARAM                   }
   def_enum      TPARAM_HWTCL    PHYLITE_NUM_GROUPS             [list PHYLITE_NUM_GROUPS            ]
   def_enum      TPARAM_HWTCL    PHY_MEM_CLK_FREQ_MHZ           [list PHYLITE_MEM_CLK_FREQ_MHZ      ]
   def_enum      TPARAM_HWTCL    PHY_REF_CLK_FREQ_MHZ           [list PHYLITE_REF_CLK_FREQ_MHZ      ]
   def_enum      TPARAM_HWTCL    PLL_REF_CLK_FREQ_PS_STR        [list PLL_REF_CLK_FREQ_PS_STR       ]
   def_enum      TPARAM_HWTCL    PLL_VCO_FREQ_PS_STR            [list PLL_VCO_FREQ_PS_STR           ]
   def_enum      TPARAM_HWTCL    PLL_MEM_CLK_FREQ_PS_STR        [list PLL_MEM_CLK_FREQ_PS_STR       ]
   def_enum      TPARAM_HWTCL    PLL_VCO_TO_MEM_CLK_FREQ_RATIO  [list PLL_VCO_TO_MEM_CLK_FREQ_RATIO ]
   def_enum      TPARAM_HWTCL    PLL_PHY_CLK_VCO_PHASE          [list PLL_PHY_CLK_VCO_PHASE         ]
   def_enum	 TPARAM_HWTCL    PLL_USE_CORE_REF_CLK  		[list PLL_USE_CORE_REF_CLK 		    ]
   def_enum      TPARAM_HWTCL    PHYLITE_USE_DYNAMIC_RECONFIGURATION  [list PHYLITE_USE_DYNAMIC_RECONFIGURATION ]
   def_enum      TPARAM_HWTCL    PHY_TARGET_IS_ES                     [list PHYLITE_TARGET_IS_ES                ]
   def_enum      TPARAM_HWTCL    m_cnt_hi_div                         [list m_cnt_hi_div                        ]
   def_enum      TPARAM_HWTCL    m_cnt_lo_div                         [list m_cnt_lo_div                        ]
   def_enum      TPARAM_HWTCL    m_cnt_bypass_en                      [list m_cnt_bypass_en                     ]
   def_enum      TPARAM_HWTCL    n_cnt_hi_div                         [list n_cnt_hi_div                        ]
   def_enum      TPARAM_HWTCL    n_cnt_lo_div                         [list n_cnt_lo_div                        ]
   def_enum      TPARAM_HWTCL    n_cnt_bypass_en                      [list n_cnt_bypass_en                     ]
   def_enum      TPARAM_HWTCL    c_cnt_hi_div5                        [list c_cnt_hi_div5                       ]
   def_enum      TPARAM_HWTCL    c_cnt_lo_div5                        [list c_cnt_lo_div5                       ]
   def_enum      TPARAM_HWTCL    c_cnt_bypass_en5                     [list c_cnt_bypass_en5                    ]
   def_enum      TPARAM_HWTCL    pll_output_phase_shift_5             [list pll_output_phase_shift_5            ]
   def_enum      TPARAM_HWTCL    pll_output_duty_cycle_5              [list pll_output_duty_cycle_5             ]
   def_enum      TPARAM_HWTCL    c_cnt_hi_div6                        [list c_cnt_hi_div6                       ]
   def_enum      TPARAM_HWTCL    c_cnt_lo_div6                        [list c_cnt_lo_div6                       ]
   def_enum      TPARAM_HWTCL    c_cnt_bypass_en6                     [list c_cnt_bypass_en6                    ]
   def_enum      TPARAM_HWTCL    pll_output_phase_shift_6             [list pll_output_phase_shift_6            ]
   def_enum      TPARAM_HWTCL    pll_output_duty_cycle_6              [list pll_output_duty_cycle_6             ]
   def_enum      TPARAM_HWTCL    c_cnt_hi_div7                        [list c_cnt_hi_div7                       ]
   def_enum      TPARAM_HWTCL    c_cnt_lo_div7                        [list c_cnt_lo_div7                       ]
   def_enum      TPARAM_HWTCL    c_cnt_bypass_en7                     [list c_cnt_bypass_en7                    ]
   def_enum      TPARAM_HWTCL    pll_output_phase_shift_7             [list pll_output_phase_shift_7            ]
   def_enum      TPARAM_HWTCL    pll_output_duty_cycle_7              [list pll_output_duty_cycle_7             ]
   def_enum      TPARAM_HWTCL    c_cnt_hi_div8                        [list c_cnt_hi_div8                       ]
   def_enum      TPARAM_HWTCL    c_cnt_lo_div8                        [list c_cnt_lo_div8                       ]
   def_enum      TPARAM_HWTCL    c_cnt_bypass_en8                     [list c_cnt_bypass_en8                    ]
   def_enum      TPARAM_HWTCL    pll_output_phase_shift_8             [list pll_output_phase_shift_8            ]
   def_enum      TPARAM_HWTCL    pll_output_duty_cycle_8              [list pll_output_duty_cycle_8             ]
   def_enum      TPARAM_HWTCL    gui_enable_advanced_mode             [list gui_enable_advanced_mode            ]
   def_enum      TPARAM_HWTCL    gui_number_of_pll_output_clocks      [list gui_number_of_pll_output_clocks     ]


   def_enum_type TPARAM_HWTCL_ENUM                                   {     HWTCL_PARAM          ENUM      }
   def_enum      TPARAM_HWTCL_ENUM    USER_CLK_RATIO                 [list PHYLITE_RATE_ENUM    AFI_RATIO   ]
   def_enum      TPARAM_HWTCL_ENUM    C2P_P2C_CLK_RATIO              [list PHYLITE_RATE_ENUM    AFI_RATIO   ]
   def_enum      TPARAM_HWTCL_ENUM    PHY_PHY_CLK_RATIO              [list PHYLITE_RATE_ENUM    AFI_RATIO   ]

   def_enum_type TPARAM_HWTCL_GROUP                                {     HWTCL_PARAM                   }
   def_enum      TPARAM_HWTCL_GROUP    DDR_SDR_MODE                [list DDR_SDR_MODE                  ]
   def_enum      TPARAM_HWTCL_GROUP    T_IN_DH                     [list T_IN_DH                       ]
   def_enum      TPARAM_HWTCL_GROUP    T_IN_DS                     [list T_IN_DS                       ]
   def_enum      TPARAM_HWTCL_GROUP    T_OUT_DH                    [list T_OUT_DH                      ]
   def_enum      TPARAM_HWTCL_GROUP    T_OUT_DS                    [list T_OUT_DS                      ]
   def_enum      TPARAM_HWTCL_GROUP    GENERATE_INPUT_CONSTRAINT   [list GENERATE_INPUT_CONSTRAINT     ]
   def_enum      TPARAM_HWTCL_GROUP    GENERATE_OUTPUT_CONSTRAINT  [list GENERATE_OUTPUT_CONSTRAINT    ]
   def_enum      TPARAM_HWTCL_GROUP    READ_DESKEW_MODE            [list READ_DESKEW_MODE              ]
   def_enum      TPARAM_HWTCL_GROUP    WRITE_DESKEW_MODE           [list WRITE_DESKEW_MODE             ]
   def_enum      TPARAM_HWTCL_GROUP    READ_ISI                    [list READ_ISI                      ]
   def_enum      TPARAM_HWTCL_GROUP    WRITE_ISI                   [list WRITE_ISI                     ]
   def_enum      TPARAM_HWTCL_GROUP    READ_SU_DESKEW_CUSTOM       [list READ_SU_DESKEW_CUSTOM         ]
   def_enum      TPARAM_HWTCL_GROUP    READ_HD_DESKEW_CUSTOM       [list READ_HD_DESKEW_CUSTOM         ]
   def_enum      TPARAM_HWTCL_GROUP    WRITE_SU_DESKEW_CUSTOM      [list WRITE_SU_DESKEW_CUSTOM        ]
   def_enum      TPARAM_HWTCL_GROUP    WRITE_HD_DESKEW_CUSTOM      [list WRITE_HD_DESKEW_CUSTOM        ]
   def_enum      TPARAM_HWTCL_GROUP    CAPTURE_PHASE_SHIFT         [list CAPTURE_PHASE_SHIFT           ]
   def_enum      TPARAM_HWTCL_GROUP    OUTPUT_STROBE_PHASE         [list OUTPUT_STROBE_PHASE           ]

}


proc ::altera_phylite::ip_arch_nf::enum_defs_timing_params::_init {} {
   ::altera_phylite::ip_arch_nf::enum_defs_timing_params::def_enums
}

::altera_phylite::ip_arch_nf::enum_defs_timing_params::_init

