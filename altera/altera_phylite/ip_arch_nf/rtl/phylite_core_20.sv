// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



///////////////////////////////////////////////////////////////////////////////
// Top-level wrapper of 20nm PHYLite component.
//
///////////////////////////////////////////////////////////////////////////////
module phylite_core_20 #(
	// Top Level parameters
	parameter integer PHYLITE_NUM_GROUPS              = 1,
	parameter PHYLITE_RATE_ENUM                       = "RATE_IN_QUARTER",
	parameter PHYLITE_USE_DYNAMIC_RECONFIGURATION     = 0,
	parameter PHYLITE_INTERFACE_ID                    = 0,
	parameter PARAM_TABLE_HEX_FILENAME                = "",
	parameter IO_AUX_CAL_CLK_DIV                      = 6,
	parameter PHYLITE_USE_CPA                         = 1,
	parameter PHYLITE_USE_CPA_LOCK                    = 0,
	parameter SILICON_REV				  = "20NM5",
	parameter DLL_MODE                                = "",
	parameter DLL_CODEWORD                            = 0,

	// PLL parameters
	parameter PLL_REF_CLK_FREQ_PS_STR                 = "0 ps",
	parameter PLL_VCO_FREQ_PS_STR                     = "0 ps",
	parameter PLL_USE_CORE_REF_CLK    		  = 0,
	parameter PLL_VCO_FREQ_MHZ_INT                    = 0,
	parameter PLL_VCO_TO_MEM_CLK_FREQ_RATIO           = 1,
	parameter PLL_MEM_CLK_FREQ_PS_STR                 = "0 ps",
	parameter PLL_M_COUNTER_BYPASS_EN                 = 1,
	parameter PLL_M_COUNTER_EVEN_DUTY_EN              = 0,
	parameter PLL_M_COUNTER_HIGH                      = 256,
	parameter PLL_M_COUNTER_LOW                       = 256,
	parameter PLL_PHYCLK_0_FREQ_PS_STR                = "0 ps",
	parameter PLL_PHYCLK_0_BYPASS_EN                  = 1,
	parameter PLL_PHYCLK_0_HIGH                       = 256,
	parameter PLL_PHYCLK_0_LOW                        = 256,
	parameter PLL_PHYCLK_1_FREQ_PS_STR                = "0 ps",
	parameter PLL_PHYCLK_1_BYPASS_EN                  = 1,
	parameter PLL_PHYCLK_1_HIGH                       = 256,
	parameter PLL_PHYCLK_1_LOW                        = 256,
	parameter PLL_PHYCLK_FB_FREQ_PS_STR               = "0 ps",
	parameter PLL_PHYCLK_FB_BYPASS_EN                 = 1,
	parameter PLL_PHYCLK_FB_HIGH                      = 256,
	parameter PLL_PHYCLK_FB_LOW                       = 256,
	parameter PLL_PHY_CLK_VCO_PHASE                   = 0,
	parameter PLL_PHY_CLK_VCO_PHASE_PS_STR            = "0 ps",
	parameter pll_input_clock_frequency               = "",	
	parameter pll_vco_clock_frequency                 = "",	
	parameter m_cnt_hi_div                            = 0,
	parameter m_cnt_lo_div                            = 0,
	parameter n_cnt_hi_div                            = 0,
	parameter n_cnt_lo_div                            = 0,
	parameter m_cnt_bypass_en                         = "",
	parameter n_cnt_bypass_en                         = "",
	parameter m_cnt_odd_div_duty_en                   = "",
	parameter n_cnt_odd_div_duty_en                   = "",
	parameter pll_cp_setting                          = "",
	parameter pll_bw_ctrl                             = "",
	parameter c_cnt_hi_div0                           = 0,
	parameter c_cnt_lo_div0                           = 0,
	parameter c_cnt_prst0                             = 0,
	parameter c_cnt_ph_mux_prst0                      = 0,
	parameter c_cnt_bypass_en0                        = "",
	parameter c_cnt_odd_div_duty_en0                  = "",
	parameter c_cnt_hi_div1                           = 0,
	parameter c_cnt_lo_div1                           = 0,
	parameter c_cnt_prst1                             = 0,
	parameter c_cnt_ph_mux_prst1                      = 0,
	parameter c_cnt_bypass_en1                        = "",
	parameter c_cnt_odd_div_duty_en1                  = "",
	parameter c_cnt_hi_div2                           = 0,
	parameter c_cnt_lo_div2                           = 0,
	parameter c_cnt_prst2                             = 0,
	parameter c_cnt_ph_mux_prst2                      = 0,
	parameter c_cnt_bypass_en2                        = "",
	parameter c_cnt_odd_div_duty_en2                  = "",
	parameter c_cnt_hi_div3                           = 0,
	parameter c_cnt_lo_div3                           = 0,
	parameter c_cnt_prst3                             = 0,
	parameter c_cnt_ph_mux_prst3                      = 0,
	parameter c_cnt_bypass_en3                        = "",
	parameter c_cnt_odd_div_duty_en3                  = "",
	parameter c_cnt_hi_div4                           = 0,
	parameter c_cnt_lo_div4                           = 0,
	parameter c_cnt_prst4                             = 0,
	parameter c_cnt_ph_mux_prst4                      = 0,
	parameter c_cnt_bypass_en4                        = "",
	parameter c_cnt_odd_div_duty_en4                  = "",
	parameter c_cnt_hi_div5                           = 0,
	parameter c_cnt_lo_div5                           = 0,
	parameter c_cnt_prst5                             = 0,
	parameter c_cnt_ph_mux_prst5                      = 0,
	parameter c_cnt_bypass_en5                        = "",
	parameter c_cnt_odd_div_duty_en5                  = "",
	parameter c_cnt_hi_div6                           = 0,
	parameter c_cnt_lo_div6                           = 0,
	parameter c_cnt_prst6                             = 0,
	parameter c_cnt_ph_mux_prst6                      = 0,
	parameter c_cnt_bypass_en6                        = "",
	parameter c_cnt_odd_div_duty_en6                  = "",
	parameter c_cnt_hi_div7                           = 0,
	parameter c_cnt_lo_div7                           = 0,
	parameter c_cnt_prst7                             = 0,
	parameter c_cnt_ph_mux_prst7                      = 0,
	parameter c_cnt_bypass_en7                        = "",
	parameter c_cnt_odd_div_duty_en7                  = "",
	parameter c_cnt_hi_div8                           = 0,
	parameter c_cnt_lo_div8                           = 0,
	parameter c_cnt_prst8                             = 0,
	parameter c_cnt_ph_mux_prst8                      = 0,
	parameter c_cnt_bypass_en8                        = "",
	parameter c_cnt_odd_div_duty_en8                  = "",
	parameter pll_output_clock_frequency_0            = "",
	parameter pll_output_phase_shift_0                = "",
	parameter pll_output_duty_cycle_0                 = 0,
	parameter pll_output_clock_frequency_1            = "",
	parameter pll_output_phase_shift_1                = "",
	parameter pll_output_duty_cycle_1                 = 0,
	parameter pll_output_clock_frequency_2            = "",
	parameter pll_output_phase_shift_2                = "",
	parameter pll_output_duty_cycle_2                 = 0,
	parameter pll_output_clock_frequency_3            = "",
	parameter pll_output_phase_shift_3                = "",
	parameter pll_output_duty_cycle_3                 = 0,
	parameter pll_output_clock_frequency_4            = "",
	parameter pll_output_phase_shift_4                = "",
	parameter pll_output_duty_cycle_4                 = 0,
	parameter pll_output_clock_frequency_5            = "",
	parameter pll_output_phase_shift_5                = "",
	parameter pll_output_duty_cycle_5                 = 0,
	parameter pll_output_clock_frequency_6            = "",
	parameter pll_output_phase_shift_6                = "",
	parameter pll_output_duty_cycle_6                 = 0,
	parameter pll_output_clock_frequency_7            = "",
	parameter pll_output_phase_shift_7                = "",
	parameter pll_output_duty_cycle_7                 = 0,
	parameter pll_output_clock_frequency_8            = "",
	parameter pll_output_phase_shift_8                = "",
	parameter pll_output_duty_cycle_8                 = 0,
	parameter pll_clk_out_en_0                        = "",
	parameter pll_clk_out_en_1                        = "",
	parameter pll_clk_out_en_2                        = "",
	parameter pll_clk_out_en_3                        = "",
	parameter pll_clk_out_en_4                        = "",
	parameter pll_clk_out_en_5                        = "",
	parameter pll_clk_out_en_6                        = "",
	parameter pll_clk_out_en_7                        = "",
	parameter pll_clk_out_en_8                        = "",
	parameter pll_fbclk_mux_1                         = "",
	parameter pll_fbclk_mux_2                         = "",
	parameter pll_m_cnt_in_src                        = "",
	parameter pll_bw_sel                              = "",
	
	// Group Parameters
	parameter string GROUP_0_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_0_PIN_WIDTH                       = 9,
	parameter string GROUP_0_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_0_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_0_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_0_READ_LATENCY                    = 4,
	parameter        GROUP_0_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_0_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_0_WRITE_LATENCY                   = 0,
	parameter        GROUP_0_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_0_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_0_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_0_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_0_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_0_OCT_SIZE                        = 1,
	parameter string GROUP_1_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_1_PIN_WIDTH                       = 9,
	parameter string GROUP_1_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_1_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_1_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_1_READ_LATENCY                    = 4,
	parameter        GROUP_1_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_1_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_1_WRITE_LATENCY                   = 0,
	parameter        GROUP_1_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_1_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_1_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_1_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_1_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_1_OCT_SIZE                        = 1,
	parameter string GROUP_2_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_2_PIN_WIDTH                       = 9,
	parameter string GROUP_2_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_2_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_2_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_2_READ_LATENCY                    = 4,
	parameter        GROUP_2_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_2_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_2_WRITE_LATENCY                   = 0,
	parameter        GROUP_2_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_2_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_2_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_2_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_2_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_2_OCT_SIZE                        = 1,
	parameter string GROUP_3_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_3_PIN_WIDTH                       = 9,
	parameter string GROUP_3_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_3_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_3_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_3_READ_LATENCY                    = 4,
	parameter        GROUP_3_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_3_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_3_WRITE_LATENCY                   = 0,
	parameter        GROUP_3_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_3_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_3_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_3_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_3_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_3_OCT_SIZE                        = 1,
	parameter string GROUP_4_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_4_PIN_WIDTH                       = 9,
	parameter string GROUP_4_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_4_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_4_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_4_READ_LATENCY                    = 4,
	parameter        GROUP_4_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_4_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_4_WRITE_LATENCY                   = 0,
	parameter        GROUP_4_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_4_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_4_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_4_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_4_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_4_OCT_SIZE                        = 1,
	parameter string GROUP_5_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_5_PIN_WIDTH                       = 9,
	parameter string GROUP_5_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_5_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_5_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_5_READ_LATENCY                    = 4,
	parameter        GROUP_5_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_5_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_5_WRITE_LATENCY                   = 0,
	parameter        GROUP_5_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_5_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_5_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_5_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_5_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_5_OCT_SIZE                        = 1,
	parameter string GROUP_6_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_6_PIN_WIDTH                       = 9,
	parameter string GROUP_6_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_6_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_6_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_6_READ_LATENCY                    = 4,
	parameter        GROUP_6_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_6_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_6_WRITE_LATENCY                   = 0,
	parameter        GROUP_6_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_6_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_6_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_6_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_6_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_6_OCT_SIZE                        = 1,
	parameter string GROUP_7_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_7_PIN_WIDTH                       = 9,
	parameter string GROUP_7_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_7_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_7_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_7_READ_LATENCY                    = 4,
	parameter        GROUP_7_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_7_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_7_WRITE_LATENCY                   = 0,
	parameter        GROUP_7_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_7_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_7_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_7_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_7_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_7_OCT_SIZE                        = 1,
	parameter string GROUP_8_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_8_PIN_WIDTH                       = 9,
	parameter string GROUP_8_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_8_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_8_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_8_READ_LATENCY                    = 4,
	parameter        GROUP_8_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_8_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_8_WRITE_LATENCY                   = 0,
	parameter        GROUP_8_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_8_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_8_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_8_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_8_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_8_OCT_SIZE                        = 1,
	parameter string GROUP_9_PIN_TYPE                        = "BIDIR",
	parameter        GROUP_9_PIN_WIDTH                       = 9,
	parameter string GROUP_9_DDR_SDR_MODE                    = "DDR",
	parameter string GROUP_9_STROBE_CONFIG                   = "SINGLE_ENDED",
	parameter string GROUP_9_DATA_CONFIG                     = "SGL_ENDED",
	parameter        GROUP_9_READ_LATENCY                    = 4,
	parameter        GROUP_9_CAPTURE_PHASE_SHIFT             = 90,
	parameter        GROUP_9_USE_INTERNAL_CAPTURE_STROBE     = 0,
	parameter        GROUP_9_WRITE_LATENCY                   = 0,
	parameter        GROUP_9_USE_OUTPUT_STROBE               = 1,
	parameter        GROUP_9_OUTPUT_STROBE_PHASE             = 90,
	parameter        GROUP_9_USE_SEPARATE_STROBES            = 0,
	parameter        GROUP_9_SWAP_CAPTURE_STROBE_POLARITY    = 0,
	parameter string GROUP_9_OCT_MODE                        = "STATIC_OFF",
	parameter 	 GROUP_9_OCT_SIZE                        = 1,
	parameter string GROUP_10_PIN_TYPE                       = "BIDIR",
	parameter        GROUP_10_PIN_WIDTH                      = 9,
	parameter string GROUP_10_DDR_SDR_MODE                   = "DDR",
	parameter string GROUP_10_STROBE_CONFIG                  = "SINGLE_ENDED",
	parameter string GROUP_10_DATA_CONFIG                    = "SGL_ENDED",
	parameter        GROUP_10_READ_LATENCY                   = 4,
	parameter        GROUP_10_CAPTURE_PHASE_SHIFT            = 90,
	parameter        GROUP_10_USE_INTERNAL_CAPTURE_STROBE    = 0,
	parameter        GROUP_10_WRITE_LATENCY                  = 0,
	parameter        GROUP_10_USE_OUTPUT_STROBE              = 1,
	parameter        GROUP_10_OUTPUT_STROBE_PHASE            = 90,
	parameter        GROUP_10_USE_SEPARATE_STROBES           = 0,
	parameter        GROUP_10_SWAP_CAPTURE_STROBE_POLARITY   = 0,
	parameter string GROUP_10_OCT_MODE                       = "STATIC_OFF",
	parameter 	 GROUP_10_OCT_SIZE                        = 1,
	parameter string GROUP_11_PIN_TYPE                       = "BIDIR",
	parameter        GROUP_11_PIN_WIDTH                      = 9,
	parameter string GROUP_11_DDR_SDR_MODE                   = "DDR",
	parameter string GROUP_11_STROBE_CONFIG                  = "SINGLE_ENDED",
	parameter string GROUP_11_DATA_CONFIG                    = "SGL_ENDED",
	parameter        GROUP_11_READ_LATENCY                   = 4,
	parameter        GROUP_11_CAPTURE_PHASE_SHIFT            = 90,
	parameter        GROUP_11_USE_INTERNAL_CAPTURE_STROBE    = 0,
	parameter        GROUP_11_WRITE_LATENCY                  = 0,
	parameter        GROUP_11_USE_OUTPUT_STROBE              = 1,
	parameter        GROUP_11_OUTPUT_STROBE_PHASE            = 90,
	parameter        GROUP_11_USE_SEPARATE_STROBES           = 0,
	parameter        GROUP_11_SWAP_CAPTURE_STROBE_POLARITY   = 0,
	parameter string GROUP_11_OCT_MODE                       = "STATIC_OFF",
	parameter 	 GROUP_11_OCT_SIZE                        = 1,
	parameter string GROUP_12_PIN_TYPE                       = "BIDIR",
	parameter        GROUP_12_PIN_WIDTH                      = 9,
	parameter string GROUP_12_DDR_SDR_MODE                   = "DDR",
	parameter string GROUP_12_STROBE_CONFIG                  = "SINGLE_ENDED",
	parameter string GROUP_12_DATA_CONFIG                    = "SGL_ENDED",
	parameter        GROUP_12_READ_LATENCY                   = 4,
	parameter        GROUP_12_CAPTURE_PHASE_SHIFT            = 90,
	parameter        GROUP_12_USE_INTERNAL_CAPTURE_STROBE    = 0,
	parameter        GROUP_12_WRITE_LATENCY                  = 0,
	parameter        GROUP_12_USE_OUTPUT_STROBE              = 1,
	parameter        GROUP_12_OUTPUT_STROBE_PHASE            = 90,
	parameter        GROUP_12_USE_SEPARATE_STROBES           = 0,
	parameter        GROUP_12_SWAP_CAPTURE_STROBE_POLARITY   = 0,
	parameter string GROUP_12_OCT_MODE                       = "STATIC_OFF",
	parameter 	 GROUP_12_OCT_SIZE                        = 1,
	parameter string GROUP_13_PIN_TYPE                       = "BIDIR",
	parameter        GROUP_13_PIN_WIDTH                      = 9,
	parameter string GROUP_13_DDR_SDR_MODE                   = "DDR",
	parameter string GROUP_13_STROBE_CONFIG                  = "SINGLE_ENDED",
	parameter string GROUP_13_DATA_CONFIG                    = "SGL_ENDED",
	parameter        GROUP_13_READ_LATENCY                   = 4,
	parameter        GROUP_13_CAPTURE_PHASE_SHIFT            = 90,
	parameter        GROUP_13_USE_INTERNAL_CAPTURE_STROBE    = 0,
	parameter        GROUP_13_WRITE_LATENCY                  = 0,
	parameter        GROUP_13_USE_OUTPUT_STROBE              = 1,
	parameter        GROUP_13_OUTPUT_STROBE_PHASE            = 90,
	parameter        GROUP_13_USE_SEPARATE_STROBES           = 0,
	parameter        GROUP_13_SWAP_CAPTURE_STROBE_POLARITY   = 0,
	parameter string GROUP_13_OCT_MODE                       = "STATIC_OFF",
	parameter 	 GROUP_13_OCT_SIZE                        = 1,
	parameter string GROUP_14_PIN_TYPE                       = "BIDIR",
	parameter        GROUP_14_PIN_WIDTH                      = 9,
	parameter string GROUP_14_DDR_SDR_MODE                   = "DDR",
	parameter string GROUP_14_STROBE_CONFIG                  = "SINGLE_ENDED",
	parameter string GROUP_14_DATA_CONFIG                    = "SGL_ENDED",
	parameter        GROUP_14_READ_LATENCY                   = 4,
	parameter        GROUP_14_CAPTURE_PHASE_SHIFT            = 90,
	parameter        GROUP_14_USE_INTERNAL_CAPTURE_STROBE    = 0,
	parameter        GROUP_14_WRITE_LATENCY                  = 0,
	parameter        GROUP_14_USE_OUTPUT_STROBE              = 1,
	parameter        GROUP_14_OUTPUT_STROBE_PHASE            = 90,
	parameter        GROUP_14_USE_SEPARATE_STROBES           = 0,
	parameter        GROUP_14_SWAP_CAPTURE_STROBE_POLARITY   = 0,
	parameter string GROUP_14_OCT_MODE                       = "STATIC_OFF",
	parameter 	 GROUP_14_OCT_SIZE                        = 1,
	parameter string GROUP_15_PIN_TYPE                       = "BIDIR",
	parameter        GROUP_15_PIN_WIDTH                      = 9,
	parameter string GROUP_15_DDR_SDR_MODE                   = "DDR",
	parameter string GROUP_15_STROBE_CONFIG                  = "SINGLE_ENDED",
	parameter string GROUP_15_DATA_CONFIG                    = "SGL_ENDED",
	parameter        GROUP_15_READ_LATENCY                   = 4,
	parameter        GROUP_15_CAPTURE_PHASE_SHIFT            = 90,
	parameter        GROUP_15_USE_INTERNAL_CAPTURE_STROBE    = 0,
	parameter        GROUP_15_WRITE_LATENCY                  = 0,
	parameter        GROUP_15_USE_OUTPUT_STROBE              = 1,
	parameter        GROUP_15_OUTPUT_STROBE_PHASE            = 90,
	parameter        GROUP_15_USE_SEPARATE_STROBES           = 0,
	parameter        GROUP_15_SWAP_CAPTURE_STROBE_POLARITY   = 0,
	parameter string GROUP_15_OCT_MODE                       = "STATIC_OFF",
	parameter 	 GROUP_15_OCT_SIZE                        = 1,
	parameter string GROUP_16_PIN_TYPE                       = "BIDIR",
	parameter        GROUP_16_PIN_WIDTH                      = 9,
	parameter string GROUP_16_DDR_SDR_MODE                   = "DDR",
	parameter string GROUP_16_STROBE_CONFIG                  = "SINGLE_ENDED",
	parameter string GROUP_16_DATA_CONFIG                    = "SGL_ENDED",
	parameter        GROUP_16_READ_LATENCY                   = 4,
	parameter        GROUP_16_CAPTURE_PHASE_SHIFT            = 90,
	parameter        GROUP_16_USE_INTERNAL_CAPTURE_STROBE    = 0,
	parameter        GROUP_16_WRITE_LATENCY                  = 0,
	parameter        GROUP_16_USE_OUTPUT_STROBE              = 1,
	parameter        GROUP_16_OUTPUT_STROBE_PHASE            = 90,
	parameter        GROUP_16_USE_SEPARATE_STROBES           = 0,
	parameter        GROUP_16_SWAP_CAPTURE_STROBE_POLARITY   = 0,
	parameter string GROUP_16_OCT_MODE                       = "STATIC_OFF",
	parameter 	 GROUP_16_OCT_SIZE                        = 1,
	parameter string GROUP_17_PIN_TYPE                       = "BIDIR",
	parameter        GROUP_17_PIN_WIDTH                      = 9,
	parameter string GROUP_17_DDR_SDR_MODE                   = "DDR",
	parameter string GROUP_17_STROBE_CONFIG                  = "SINGLE_ENDED",
	parameter string GROUP_17_DATA_CONFIG                    = "SGL_ENDED",
	parameter        GROUP_17_READ_LATENCY                   = 4,
	parameter        GROUP_17_CAPTURE_PHASE_SHIFT            = 90,
	parameter        GROUP_17_USE_INTERNAL_CAPTURE_STROBE    = 0,
	parameter        GROUP_17_WRITE_LATENCY                  = 0,
	parameter        GROUP_17_USE_OUTPUT_STROBE              = 1,
	parameter        GROUP_17_OUTPUT_STROBE_PHASE            = 90,
	parameter        GROUP_17_USE_SEPARATE_STROBES           = 0,
	parameter        GROUP_17_SWAP_CAPTURE_STROBE_POLARITY   = 0,
	parameter string GROUP_17_OCT_MODE                       = "STATIC_OFF",
	parameter 	 GROUP_17_OCT_SIZE                        = 1,

	// DFT Params
	parameter ENABLE_DFT         = 0,
	parameter DIAG_SYNTH_FOR_SIM = 0
	) (
	// Clock and Reset Ports
	ref_clk         ,
	reset_n         ,
	interface_locked,
	core_clk_out    ,
	pll_locked      ,
	pll_extra_clock0     ,
	pll_extra_clock1     ,
	pll_extra_clock2     ,
	pll_extra_clock3     ,

	// Avalon Input Ports
	avl_clk            ,
	avl_reset_n        ,
	avl_read           ,
	avl_write          ,
	avl_byteenable     ,
	avl_writedata      ,
	avl_address        ,
	avl_readdata       ,
	avl_readdata_valid ,
	avl_waitrequest    ,

	// Avalon Output Ports
	avl_out_clk            ,
	avl_out_reset_n        ,
	avl_out_read           ,
	avl_out_write          ,
	avl_out_byteenable     ,
	avl_out_writedata      ,
	avl_out_address        ,
	avl_out_readdata       ,
	avl_out_readdata_valid ,
	avl_out_waitrequest    ,

	// Core Interface
	group_0_oe_from_core     ,
	group_0_data_from_core   ,
	group_0_data_to_core     ,
	group_0_rdata_en         ,
	group_0_rdata_valid      ,
	group_0_strobe_out_in    ,
	group_0_strobe_out_en    ,
	
	group_1_oe_from_core     ,
	group_1_data_from_core   ,
	group_1_data_to_core     ,
	group_1_rdata_en         ,
	group_1_rdata_valid      ,
	group_1_strobe_out_in    ,
	group_1_strobe_out_en    ,
	
	group_2_oe_from_core     ,
	group_2_data_from_core   ,
	group_2_data_to_core     ,
	group_2_rdata_en         ,
	group_2_rdata_valid      ,
	group_2_strobe_out_in    ,
	group_2_strobe_out_en    ,
	
	group_3_oe_from_core     ,
	group_3_data_from_core   ,
	group_3_data_to_core     ,
	group_3_rdata_en         ,
	group_3_rdata_valid      ,
	group_3_strobe_out_in    ,
	group_3_strobe_out_en    ,
	
	group_4_oe_from_core     ,
	group_4_data_from_core   ,
	group_4_data_to_core     ,
	group_4_rdata_en         ,
	group_4_rdata_valid      ,
	group_4_strobe_out_in    ,
	group_4_strobe_out_en    ,
	
	group_5_oe_from_core     ,
	group_5_data_from_core   ,
	group_5_data_to_core     ,
	group_5_rdata_en         ,
	group_5_rdata_valid      ,
	group_5_strobe_out_in    ,
	group_5_strobe_out_en    ,
	
	group_6_oe_from_core     ,
	group_6_data_from_core   ,
	group_6_data_to_core     ,
	group_6_rdata_en         ,
	group_6_rdata_valid      ,
	group_6_strobe_out_in    ,
	group_6_strobe_out_en    ,
	
	group_7_oe_from_core     ,
	group_7_data_from_core   ,
	group_7_data_to_core     ,
	group_7_rdata_en         ,
	group_7_rdata_valid      ,
	group_7_strobe_out_in    ,
	group_7_strobe_out_en    ,
	
	group_8_oe_from_core     ,
	group_8_data_from_core   ,
	group_8_data_to_core     ,
	group_8_rdata_en         ,
	group_8_rdata_valid      ,
	group_8_strobe_out_in    ,
	group_8_strobe_out_en    ,
	
	group_9_oe_from_core     ,
	group_9_data_from_core   ,
	group_9_data_to_core     ,
	group_9_rdata_en         ,
	group_9_rdata_valid      ,
	group_9_strobe_out_in    ,
	group_9_strobe_out_en    ,
	
	group_10_oe_from_core    ,
	group_10_data_from_core  ,
	group_10_data_to_core    ,
	group_10_rdata_en        ,
	group_10_rdata_valid     ,
	group_10_strobe_out_in   ,
	group_10_strobe_out_en   ,
	
	group_11_oe_from_core    ,
	group_11_data_from_core  ,
	group_11_data_to_core    ,
	group_11_rdata_en        ,
	group_11_rdata_valid     ,
	group_11_strobe_out_in   ,
	group_11_strobe_out_en   ,
	
	group_12_oe_from_core    ,
	group_12_data_from_core  ,
	group_12_data_to_core    ,
	group_12_rdata_en        ,
	group_12_rdata_valid     ,
	group_12_strobe_out_in   ,
	group_12_strobe_out_en   ,
	
	group_13_oe_from_core    ,
	group_13_data_from_core  ,
	group_13_data_to_core    ,
	group_13_rdata_en        ,
	group_13_rdata_valid     ,
	group_13_strobe_out_in   ,
	group_13_strobe_out_en   ,
	
	group_14_oe_from_core    ,
	group_14_data_from_core  ,
	group_14_data_to_core    ,
	group_14_rdata_en        ,
	group_14_rdata_valid     ,
	group_14_strobe_out_in   ,
	group_14_strobe_out_en   ,
	
	group_15_oe_from_core    ,
	group_15_data_from_core  ,
	group_15_data_to_core    ,
	group_15_rdata_en        ,
	group_15_rdata_valid     ,
	group_15_strobe_out_in   ,
	group_15_strobe_out_en   ,
	
	group_16_oe_from_core    ,
	group_16_data_from_core  ,
	group_16_data_to_core    ,
	group_16_rdata_en        ,
	group_16_rdata_valid     ,
	group_16_strobe_out_in   ,
	group_16_strobe_out_en   ,
	
	group_17_oe_from_core    ,
	group_17_data_from_core  ,
	group_17_data_to_core    ,
	group_17_rdata_en        ,
	group_17_rdata_valid     ,
	group_17_strobe_out_in   ,
	group_17_strobe_out_en   ,
	
	// I/Os
	group_0_data_out     ,
	group_0_data_in      ,
	group_0_data_io      ,
	group_0_strobe_out   ,
	group_0_strobe_out_n ,
	group_0_strobe_in    ,
	group_0_strobe_in_n  ,
	group_0_strobe_io    ,
	group_0_strobe_io_n  ,
	group_0_data_out_n   ,
	group_0_data_in_n    ,
	group_0_data_io_n    ,

	group_1_data_out     ,
	group_1_data_in      ,
	group_1_data_io      ,
	group_1_strobe_out   ,
	group_1_strobe_out_n ,
	group_1_strobe_in    ,
	group_1_strobe_in_n  ,
	group_1_strobe_io    ,
	group_1_strobe_io_n  ,
	group_1_data_out_n   ,
	group_1_data_in_n    ,
	group_1_data_io_n    ,

	group_2_data_out     ,
	group_2_data_in      ,
	group_2_data_io      ,
	group_2_strobe_out   ,
	group_2_strobe_out_n ,
	group_2_strobe_in    ,
	group_2_strobe_in_n  ,
	group_2_strobe_io    ,
	group_2_strobe_io_n  ,
	group_2_data_out_n   ,
	group_2_data_in_n    ,
	group_2_data_io_n    ,

	group_3_data_out     ,
	group_3_data_in      ,
	group_3_data_io      ,
	group_3_strobe_out   ,
	group_3_strobe_out_n ,
	group_3_strobe_in    ,
	group_3_strobe_in_n  ,
	group_3_strobe_io    ,
	group_3_strobe_io_n  ,
	group_3_data_out_n   ,
	group_3_data_in_n    ,
	group_3_data_io_n    ,

	group_4_data_out     ,
	group_4_data_in      ,
	group_4_data_io      ,
	group_4_strobe_out   ,
	group_4_strobe_out_n ,
	group_4_strobe_in    ,
	group_4_strobe_in_n  ,
	group_4_strobe_io    ,
	group_4_strobe_io_n  ,
	group_4_data_out_n   ,
	group_4_data_in_n    ,
	group_4_data_io_n    ,

	group_5_data_out     ,
	group_5_data_in      ,
	group_5_data_io      ,
	group_5_strobe_out   ,
	group_5_strobe_out_n ,
	group_5_strobe_in    ,
	group_5_strobe_in_n  ,
	group_5_strobe_io    ,
	group_5_strobe_io_n  ,
	group_5_data_out_n   ,
	group_5_data_in_n    ,
	group_5_data_io_n    ,

	group_6_data_out     ,
	group_6_data_in      ,
	group_6_data_io      ,
	group_6_strobe_out   ,
	group_6_strobe_out_n ,
	group_6_strobe_in    ,
	group_6_strobe_in_n  ,
	group_6_strobe_io    ,
	group_6_strobe_io_n  ,
	group_6_data_out_n   ,
	group_6_data_in_n    ,
	group_6_data_io_n    ,

	group_7_data_out     ,
	group_7_data_in      ,
	group_7_data_io      ,
	group_7_strobe_out   ,
	group_7_strobe_out_n ,
	group_7_strobe_in    ,
	group_7_strobe_in_n  ,
	group_7_strobe_io    ,
	group_7_strobe_io_n  ,
	group_7_data_out_n   ,
	group_7_data_in_n    ,
	group_7_data_io_n    ,

	group_8_data_out     ,
	group_8_data_in      ,
	group_8_data_io      ,
	group_8_strobe_out   ,
	group_8_strobe_out_n ,
	group_8_strobe_in    ,
	group_8_strobe_in_n  ,
	group_8_strobe_io    ,
	group_8_strobe_io_n  ,
	group_8_data_out_n   ,
	group_8_data_in_n    ,
	group_8_data_io_n    ,

	group_9_data_out     ,
	group_9_data_in      ,
	group_9_data_io      ,
	group_9_strobe_out   ,
	group_9_strobe_out_n ,
	group_9_strobe_in    ,
	group_9_strobe_in_n  ,
	group_9_strobe_io    ,
	group_9_strobe_io_n  ,
	group_9_data_out_n   ,
	group_9_data_in_n    ,
	group_9_data_io_n    ,

	group_10_data_out     ,
	group_10_data_in      ,
	group_10_data_io      ,
	group_10_strobe_out   ,
	group_10_strobe_out_n ,
	group_10_strobe_in    ,
	group_10_strobe_in_n  ,
	group_10_strobe_io    ,
	group_10_strobe_io_n  ,
	group_10_data_out_n   ,
	group_10_data_in_n    ,
	group_10_data_io_n    ,

	group_11_data_out     ,
	group_11_data_in      ,
	group_11_data_io      ,
	group_11_strobe_out   ,
	group_11_strobe_out_n ,
	group_11_strobe_in    ,
	group_11_strobe_in_n  ,
	group_11_strobe_io    ,
	group_11_strobe_io_n  ,
	group_11_data_out_n   ,
	group_11_data_in_n    ,
	group_11_data_io_n    ,

	group_12_data_out     ,
	group_12_data_in      ,
	group_12_data_io      ,
	group_12_strobe_out   ,
	group_12_strobe_out_n ,
	group_12_strobe_in    ,
	group_12_strobe_in_n  ,
	group_12_strobe_io    ,
	group_12_strobe_io_n  ,
	group_12_data_out_n   ,
	group_12_data_in_n    ,
	group_12_data_io_n    ,

	group_13_data_out     ,
	group_13_data_in      ,
	group_13_data_io      ,
	group_13_strobe_out   ,
	group_13_strobe_out_n ,
	group_13_strobe_in    ,
	group_13_strobe_in_n  ,
	group_13_strobe_io    ,
	group_13_strobe_io_n  ,
	group_13_data_out_n   ,
	group_13_data_in_n    ,
	group_13_data_io_n    ,

	group_14_data_out     ,
	group_14_data_in      ,
	group_14_data_io      ,
	group_14_strobe_out   ,
	group_14_strobe_out_n ,
	group_14_strobe_in    ,
	group_14_strobe_in_n  ,
	group_14_strobe_io    ,
	group_14_strobe_io_n  ,
	group_14_data_out_n   ,
	group_14_data_in_n    ,
	group_14_data_io_n    ,

	group_15_data_out     ,
	group_15_data_in      ,
	group_15_data_io      ,
	group_15_strobe_out   ,
	group_15_strobe_out_n ,
	group_15_strobe_in    ,
	group_15_strobe_in_n  ,
	group_15_strobe_io    ,
	group_15_strobe_io_n  ,
	group_15_data_out_n   ,
	group_15_data_in_n    ,
	group_15_data_io_n    ,

	group_16_data_out     ,
	group_16_data_in      ,
	group_16_data_io      ,
	group_16_strobe_out   ,
	group_16_strobe_out_n ,
	group_16_strobe_in    ,
	group_16_strobe_in_n  ,
	group_16_strobe_io    ,
	group_16_strobe_io_n  ,
	group_16_data_out_n   ,
	group_16_data_in_n    ,
	group_16_data_io_n    ,

	group_17_data_out     ,
	group_17_data_in      ,
	group_17_data_io      ,
	group_17_strobe_out   ,
	group_17_strobe_out_n ,
	group_17_strobe_in    ,
	group_17_strobe_in_n  ,
	group_17_strobe_io    ,
	group_17_strobe_io_n  ,
	group_17_data_out_n   ,
	group_17_data_in_n    ,
	group_17_data_io_n    ,

	// DFT Ports
	core_to_dft,
	dft_to_core
	);
	timeunit 1ns;
	timeprecision 1ns;


	////////////////////////////////////////////////////////////////////////////
	// Local Parameters
	////////////////////////////////////////////////////////////////////////////
	localparam string GROUP_PIN_TYPE             [0:17] = '{ GROUP_0_PIN_TYPE            ,
	                                                         GROUP_1_PIN_TYPE            ,
	                                                         GROUP_2_PIN_TYPE            ,
	                                                         GROUP_3_PIN_TYPE            ,
	                                                         GROUP_4_PIN_TYPE            ,
	                                                         GROUP_5_PIN_TYPE            ,
	                                                         GROUP_6_PIN_TYPE            ,
	                                                         GROUP_7_PIN_TYPE            ,
	                                                         GROUP_8_PIN_TYPE            ,
	                                                         GROUP_9_PIN_TYPE            ,
	                                                         GROUP_10_PIN_TYPE           ,
	                                                         GROUP_11_PIN_TYPE           ,
	                                                         GROUP_12_PIN_TYPE           ,
	                                                         GROUP_13_PIN_TYPE           ,
	                                                         GROUP_14_PIN_TYPE           ,
	                                                         GROUP_15_PIN_TYPE           ,
	                                                         GROUP_16_PIN_TYPE           ,
	                                                         GROUP_17_PIN_TYPE           };

	localparam integer GROUP_PIN_WIDTH           [0:17] = '{ GROUP_0_PIN_WIDTH           ,
	                                                         GROUP_1_PIN_WIDTH           ,
	                                                         GROUP_2_PIN_WIDTH           ,
	                                                         GROUP_3_PIN_WIDTH           ,
	                                                         GROUP_4_PIN_WIDTH           ,
	                                                         GROUP_5_PIN_WIDTH           ,
	                                                         GROUP_6_PIN_WIDTH           ,
	                                                         GROUP_7_PIN_WIDTH           ,
	                                                         GROUP_8_PIN_WIDTH           ,
	                                                         GROUP_9_PIN_WIDTH           ,
	                                                         GROUP_10_PIN_WIDTH          ,
	                                                         GROUP_11_PIN_WIDTH          ,
	                                                         GROUP_12_PIN_WIDTH          ,
	                                                         GROUP_13_PIN_WIDTH          ,
	                                                         GROUP_14_PIN_WIDTH          ,
	                                                         GROUP_15_PIN_WIDTH          ,
	                                                         GROUP_16_PIN_WIDTH          ,
	                                                         GROUP_17_PIN_WIDTH          };

	localparam string GROUP_DDR_SDR_MODE         [0:17] = '{ GROUP_0_DDR_SDR_MODE        ,
	                                                         GROUP_1_DDR_SDR_MODE        ,
	                                                         GROUP_2_DDR_SDR_MODE        ,
	                                                         GROUP_3_DDR_SDR_MODE        ,
	                                                         GROUP_4_DDR_SDR_MODE        ,
	                                                         GROUP_5_DDR_SDR_MODE        ,
	                                                         GROUP_6_DDR_SDR_MODE        ,
	                                                         GROUP_7_DDR_SDR_MODE        ,
	                                                         GROUP_8_DDR_SDR_MODE        ,
	                                                         GROUP_9_DDR_SDR_MODE        ,
	                                                         GROUP_10_DDR_SDR_MODE       ,
	                                                         GROUP_11_DDR_SDR_MODE       ,
	                                                         GROUP_12_DDR_SDR_MODE       ,
	                                                         GROUP_13_DDR_SDR_MODE       ,
	                                                         GROUP_14_DDR_SDR_MODE       ,
	                                                         GROUP_15_DDR_SDR_MODE       ,
	                                                         GROUP_16_DDR_SDR_MODE       ,
	                                                         GROUP_17_DDR_SDR_MODE       };

	localparam string GROUP_STROBE_CONFIG        [0:17] = '{ GROUP_0_STROBE_CONFIG     ,
	                                                         GROUP_1_STROBE_CONFIG     ,
	                                                         GROUP_2_STROBE_CONFIG     ,
	                                                         GROUP_3_STROBE_CONFIG     ,
	                                                         GROUP_4_STROBE_CONFIG     ,
	                                                         GROUP_5_STROBE_CONFIG     ,
	                                                         GROUP_6_STROBE_CONFIG     ,
	                                                         GROUP_7_STROBE_CONFIG     ,
	                                                         GROUP_8_STROBE_CONFIG     ,
	                                                         GROUP_9_STROBE_CONFIG     ,
	                                                         GROUP_10_STROBE_CONFIG    ,
	                                                         GROUP_11_STROBE_CONFIG    ,
	                                                         GROUP_12_STROBE_CONFIG    ,
	                                                         GROUP_13_STROBE_CONFIG    ,
	                                                         GROUP_14_STROBE_CONFIG    ,
	                                                         GROUP_15_STROBE_CONFIG    ,
	                                                         GROUP_16_STROBE_CONFIG    ,
	                                                         GROUP_17_STROBE_CONFIG    };

	localparam string GROUP_DATA_CONFIG          [0:17] = '{ GROUP_0_DATA_CONFIG     ,
	                                                         GROUP_1_DATA_CONFIG     ,
	                                                         GROUP_2_DATA_CONFIG     ,
	                                                         GROUP_3_DATA_CONFIG     ,
	                                                         GROUP_4_DATA_CONFIG     ,
	                                                         GROUP_5_DATA_CONFIG     ,
	                                                         GROUP_6_DATA_CONFIG     ,
	                                                         GROUP_7_DATA_CONFIG     ,
	                                                         GROUP_8_DATA_CONFIG     ,
	                                                         GROUP_9_DATA_CONFIG     ,
	                                                         GROUP_10_DATA_CONFIG    ,
	                                                         GROUP_11_DATA_CONFIG    ,
	                                                         GROUP_12_DATA_CONFIG    ,
	                                                         GROUP_13_DATA_CONFIG    ,
	                                                         GROUP_14_DATA_CONFIG    ,
	                                                         GROUP_15_DATA_CONFIG    ,
	                                                         GROUP_16_DATA_CONFIG    ,
	                                                         GROUP_17_DATA_CONFIG    };

	localparam integer GROUP_READ_LATENCY        [0:17] = '{ GROUP_0_READ_LATENCY        ,
	                                                         GROUP_1_READ_LATENCY        ,
	                                                         GROUP_2_READ_LATENCY        ,
	                                                         GROUP_3_READ_LATENCY        ,
	                                                         GROUP_4_READ_LATENCY        ,
	                                                         GROUP_5_READ_LATENCY        ,
	                                                         GROUP_6_READ_LATENCY        ,
	                                                         GROUP_7_READ_LATENCY        ,
	                                                         GROUP_8_READ_LATENCY        ,
	                                                         GROUP_9_READ_LATENCY        ,
	                                                         GROUP_10_READ_LATENCY       ,
	                                                         GROUP_11_READ_LATENCY       ,
	                                                         GROUP_12_READ_LATENCY       ,
	                                                         GROUP_13_READ_LATENCY       ,
	                                                         GROUP_14_READ_LATENCY       ,
	                                                         GROUP_15_READ_LATENCY       ,
	                                                         GROUP_16_READ_LATENCY       ,
	                                                         GROUP_17_READ_LATENCY       };

	localparam integer GROUP_USE_INTERNAL_CAPTURE_STROBE [0:17] = '{ GROUP_0_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_1_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_2_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_3_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_4_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_5_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_6_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_7_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_8_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_9_USE_INTERNAL_CAPTURE_STROBE ,
	                                                                 GROUP_10_USE_INTERNAL_CAPTURE_STROBE,
	                                                                 GROUP_11_USE_INTERNAL_CAPTURE_STROBE,
	                                                                 GROUP_12_USE_INTERNAL_CAPTURE_STROBE,
	                                                                 GROUP_13_USE_INTERNAL_CAPTURE_STROBE,
	                                                                 GROUP_14_USE_INTERNAL_CAPTURE_STROBE,
	                                                                 GROUP_15_USE_INTERNAL_CAPTURE_STROBE,
	                                                                 GROUP_16_USE_INTERNAL_CAPTURE_STROBE,
	                                                                 GROUP_17_USE_INTERNAL_CAPTURE_STROBE};

	localparam integer GROUP_CAPTURE_PHASE_SHIFT [0:17] = '{ GROUP_0_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_1_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_2_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_3_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_4_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_5_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_6_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_7_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_8_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_9_CAPTURE_PHASE_SHIFT ,
	                                                         GROUP_10_CAPTURE_PHASE_SHIFT,
	                                                         GROUP_11_CAPTURE_PHASE_SHIFT,
	                                                         GROUP_12_CAPTURE_PHASE_SHIFT,
	                                                         GROUP_13_CAPTURE_PHASE_SHIFT,
	                                                         GROUP_14_CAPTURE_PHASE_SHIFT,
	                                                         GROUP_15_CAPTURE_PHASE_SHIFT,
	                                                         GROUP_16_CAPTURE_PHASE_SHIFT,
	                                                         GROUP_17_CAPTURE_PHASE_SHIFT};

	localparam integer GROUP_WRITE_LATENCY       [0:17] = '{ GROUP_0_WRITE_LATENCY       ,
	                                                         GROUP_1_WRITE_LATENCY       ,
	                                                         GROUP_2_WRITE_LATENCY       ,
	                                                         GROUP_3_WRITE_LATENCY       ,
	                                                         GROUP_4_WRITE_LATENCY       ,
	                                                         GROUP_5_WRITE_LATENCY       ,
	                                                         GROUP_6_WRITE_LATENCY       ,
	                                                         GROUP_7_WRITE_LATENCY       ,
	                                                         GROUP_8_WRITE_LATENCY       ,
	                                                         GROUP_9_WRITE_LATENCY       ,
	                                                         GROUP_10_WRITE_LATENCY      ,
	                                                         GROUP_11_WRITE_LATENCY      ,
	                                                         GROUP_12_WRITE_LATENCY      ,
	                                                         GROUP_13_WRITE_LATENCY      ,
	                                                         GROUP_14_WRITE_LATENCY      ,
	                                                         GROUP_15_WRITE_LATENCY      ,
	                                                         GROUP_16_WRITE_LATENCY      ,
	                                                         GROUP_17_WRITE_LATENCY      };

	localparam integer GROUP_USE_OUTPUT_STROBE   [0:17] = '{ GROUP_0_USE_OUTPUT_STROBE   ,
	                                                         GROUP_1_USE_OUTPUT_STROBE   ,
	                                                         GROUP_2_USE_OUTPUT_STROBE   ,
	                                                         GROUP_3_USE_OUTPUT_STROBE   ,
	                                                         GROUP_4_USE_OUTPUT_STROBE   ,
	                                                         GROUP_5_USE_OUTPUT_STROBE   ,
	                                                         GROUP_6_USE_OUTPUT_STROBE   ,
	                                                         GROUP_7_USE_OUTPUT_STROBE   ,
	                                                         GROUP_8_USE_OUTPUT_STROBE   ,
	                                                         GROUP_9_USE_OUTPUT_STROBE   ,
	                                                         GROUP_10_USE_OUTPUT_STROBE  ,
	                                                         GROUP_11_USE_OUTPUT_STROBE  ,
	                                                         GROUP_12_USE_OUTPUT_STROBE  ,
	                                                         GROUP_13_USE_OUTPUT_STROBE  ,
	                                                         GROUP_14_USE_OUTPUT_STROBE  ,
	                                                         GROUP_15_USE_OUTPUT_STROBE  ,
	                                                         GROUP_16_USE_OUTPUT_STROBE  ,
	                                                         GROUP_17_USE_OUTPUT_STROBE  };

	localparam integer GROUP_OUTPUT_STROBE_PHASE [0:17] = '{ GROUP_0_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_1_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_2_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_3_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_4_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_5_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_6_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_7_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_8_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_9_OUTPUT_STROBE_PHASE ,
	                                                         GROUP_10_OUTPUT_STROBE_PHASE,
	                                                         GROUP_11_OUTPUT_STROBE_PHASE,
	                                                         GROUP_12_OUTPUT_STROBE_PHASE,
	                                                         GROUP_13_OUTPUT_STROBE_PHASE,
	                                                         GROUP_14_OUTPUT_STROBE_PHASE,
	                                                         GROUP_15_OUTPUT_STROBE_PHASE,
	                                                         GROUP_16_OUTPUT_STROBE_PHASE,
	                                                         GROUP_17_OUTPUT_STROBE_PHASE};

	localparam integer GROUP_USE_SEPARATE_STROBES   [0:17] = '{ GROUP_0_USE_SEPARATE_STROBES   ,
	                                                            GROUP_1_USE_SEPARATE_STROBES   ,
	                                                            GROUP_2_USE_SEPARATE_STROBES   ,
	                                                            GROUP_3_USE_SEPARATE_STROBES   ,
	                                                            GROUP_4_USE_SEPARATE_STROBES   ,
	                                                            GROUP_5_USE_SEPARATE_STROBES   ,
	                                                            GROUP_6_USE_SEPARATE_STROBES   ,
	                                                            GROUP_7_USE_SEPARATE_STROBES   ,
	                                                            GROUP_8_USE_SEPARATE_STROBES   ,
	                                                            GROUP_9_USE_SEPARATE_STROBES   ,
	                                                            GROUP_10_USE_SEPARATE_STROBES  ,
	                                                            GROUP_11_USE_SEPARATE_STROBES  ,
	                                                            GROUP_12_USE_SEPARATE_STROBES  ,
	                                                            GROUP_13_USE_SEPARATE_STROBES  ,
	                                                            GROUP_14_USE_SEPARATE_STROBES  ,
	                                                            GROUP_15_USE_SEPARATE_STROBES  ,
	                                                            GROUP_16_USE_SEPARATE_STROBES  ,
	                                                            GROUP_17_USE_SEPARATE_STROBES  };

	localparam integer GROUP_SWAP_CAPTURE_STROBE_POLARITY   [0:17] = '{ GROUP_0_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_1_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_2_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_3_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_4_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_5_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_6_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_7_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_8_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_9_SWAP_CAPTURE_STROBE_POLARITY   ,
	                                                                    GROUP_10_SWAP_CAPTURE_STROBE_POLARITY  ,
	                                                                    GROUP_11_SWAP_CAPTURE_STROBE_POLARITY  ,
	                                                                    GROUP_12_SWAP_CAPTURE_STROBE_POLARITY  ,
	                                                                    GROUP_13_SWAP_CAPTURE_STROBE_POLARITY  ,
	                                                                    GROUP_14_SWAP_CAPTURE_STROBE_POLARITY  ,
	                                                                    GROUP_15_SWAP_CAPTURE_STROBE_POLARITY  ,
	                                                                    GROUP_16_SWAP_CAPTURE_STROBE_POLARITY  ,
	                                                                    GROUP_17_SWAP_CAPTURE_STROBE_POLARITY  };

	localparam string GROUP_OCT_MODE         [0:17] = '{ GROUP_0_OCT_MODE        ,
	                                                     GROUP_1_OCT_MODE        ,
	                                                     GROUP_2_OCT_MODE        ,
	                                                     GROUP_3_OCT_MODE        ,
	                                                     GROUP_4_OCT_MODE        ,
	                                                     GROUP_5_OCT_MODE        ,
	                                                     GROUP_6_OCT_MODE        ,
	                                                     GROUP_7_OCT_MODE        ,
	                                                     GROUP_8_OCT_MODE        ,
	                                                     GROUP_9_OCT_MODE        ,
	                                                     GROUP_10_OCT_MODE       ,
	                                                     GROUP_11_OCT_MODE       ,
	                                                     GROUP_12_OCT_MODE       ,
	                                                     GROUP_13_OCT_MODE       ,
	                                                     GROUP_14_OCT_MODE       ,
	                                                     GROUP_15_OCT_MODE       ,
	                                                     GROUP_16_OCT_MODE       ,
	                                                     GROUP_17_OCT_MODE       };

	localparam integer GROUP_OCT_SIZE        [0:17] = '{ GROUP_0_OCT_SIZE        ,
	                                                     GROUP_1_OCT_SIZE        ,
	                                                     GROUP_2_OCT_SIZE        ,
	                                                     GROUP_3_OCT_SIZE        ,
	                                                     GROUP_4_OCT_SIZE        ,
	                                                     GROUP_5_OCT_SIZE        ,
	                                                     GROUP_6_OCT_SIZE        ,
	                                                     GROUP_7_OCT_SIZE        ,
	                                                     GROUP_8_OCT_SIZE        ,
	                                                     GROUP_9_OCT_SIZE        ,
	                                                     GROUP_10_OCT_SIZE       ,
	                                                     GROUP_11_OCT_SIZE       ,
	                                                     GROUP_12_OCT_SIZE       ,
	                                                     GROUP_13_OCT_SIZE       ,
	                                                     GROUP_14_OCT_SIZE       ,
	                                                     GROUP_15_OCT_SIZE       ,
	                                                     GROUP_16_OCT_SIZE       ,
	                                                     GROUP_17_OCT_SIZE       };

	// Core Interface Widths
	localparam integer RATE_MULT =  (PHYLITE_RATE_ENUM == "RATE_IN_QUARTER") ? 4 :
	                                (PHYLITE_RATE_ENUM == "RATE_IN_HALF")    ? 2 :
	                                                                           1 ;

	localparam integer GROUP_DDR_MULT [0:17] = '{ (GROUP_0_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_1_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_2_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_3_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_4_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_5_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_6_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_7_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_8_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_9_DDR_SDR_MODE == "DDR")  ? 2 : 1,
	                                              (GROUP_10_DDR_SDR_MODE == "DDR") ? 2 : 1,
	                                              (GROUP_11_DDR_SDR_MODE == "DDR") ? 2 : 1,
	                                              (GROUP_12_DDR_SDR_MODE == "DDR") ? 2 : 1,
	                                              (GROUP_13_DDR_SDR_MODE == "DDR") ? 2 : 1,
	                                              (GROUP_14_DDR_SDR_MODE == "DDR") ? 2 : 1,
	                                              (GROUP_15_DDR_SDR_MODE == "DDR") ? 2 : 1,
	                                              (GROUP_16_DDR_SDR_MODE == "DDR") ? 2 : 1,
	                                              (GROUP_17_DDR_SDR_MODE == "DDR") ? 2 : 1 };

	localparam integer GROUP_PIN_DATA_WIDTH [0:17] = '{ RATE_MULT * GROUP_DDR_MULT[0],
	                                                    RATE_MULT * GROUP_DDR_MULT[1],
	                                                    RATE_MULT * GROUP_DDR_MULT[2],
	                                                    RATE_MULT * GROUP_DDR_MULT[3],
	                                                    RATE_MULT * GROUP_DDR_MULT[4],
	                                                    RATE_MULT * GROUP_DDR_MULT[5],
	                                                    RATE_MULT * GROUP_DDR_MULT[6],
	                                                    RATE_MULT * GROUP_DDR_MULT[7],
	                                                    RATE_MULT * GROUP_DDR_MULT[8],
	                                                    RATE_MULT * GROUP_DDR_MULT[9],
	                                                    RATE_MULT * GROUP_DDR_MULT[10],
	                                                    RATE_MULT * GROUP_DDR_MULT[11],
	                                                    RATE_MULT * GROUP_DDR_MULT[12],
	                                                    RATE_MULT * GROUP_DDR_MULT[13],
	                                                    RATE_MULT * GROUP_DDR_MULT[14],
	                                                    RATE_MULT * GROUP_DDR_MULT[15],
	                                                    RATE_MULT * GROUP_DDR_MULT[16],
	                                                    RATE_MULT * GROUP_DDR_MULT[17] };

	localparam integer GROUP_DATA_WIDTH [0:17] = '{ GROUP_0_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[0],
	                                                GROUP_1_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[1],
	                                                GROUP_2_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[2],
	                                                GROUP_3_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[3],
	                                                GROUP_4_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[4],
	                                                GROUP_5_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[5],
	                                                GROUP_6_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[6],
	                                                GROUP_7_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[7],
	                                                GROUP_8_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[8],
	                                                GROUP_9_PIN_WIDTH  * GROUP_PIN_DATA_WIDTH[9],
	                                                GROUP_10_PIN_WIDTH * GROUP_PIN_DATA_WIDTH[10],
	                                                GROUP_11_PIN_WIDTH * GROUP_PIN_DATA_WIDTH[11] ,
	                                                GROUP_12_PIN_WIDTH * GROUP_PIN_DATA_WIDTH[12] ,
	                                                GROUP_13_PIN_WIDTH * GROUP_PIN_DATA_WIDTH[13] ,
	                                                GROUP_14_PIN_WIDTH * GROUP_PIN_DATA_WIDTH[14] ,
	                                                GROUP_15_PIN_WIDTH * GROUP_PIN_DATA_WIDTH[15] ,
	                                                GROUP_16_PIN_WIDTH * GROUP_PIN_DATA_WIDTH[16] ,
	                                                GROUP_17_PIN_WIDTH * GROUP_PIN_DATA_WIDTH[17] };

	localparam integer GROUP_PIN_OE_WIDTH [0:17] = '{ RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT,
	                                                  RATE_MULT };

	localparam integer GROUP_OE_WIDTH [0:17] =  '{ GROUP_0_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[0],
	                                               GROUP_1_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[1],
	                                               GROUP_2_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[2],
	                                               GROUP_3_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[3],
	                                               GROUP_4_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[4],
	                                               GROUP_5_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[5],
	                                               GROUP_6_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[6],
	                                               GROUP_7_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[7],
	                                               GROUP_8_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[8],
	                                               GROUP_9_PIN_WIDTH  * GROUP_PIN_OE_WIDTH[9],
	                                               GROUP_10_PIN_WIDTH * GROUP_PIN_OE_WIDTH[10],
	                                               GROUP_11_PIN_WIDTH * GROUP_PIN_OE_WIDTH[11] ,
	                                               GROUP_12_PIN_WIDTH * GROUP_PIN_OE_WIDTH[12] ,
	                                               GROUP_13_PIN_WIDTH * GROUP_PIN_OE_WIDTH[13] ,
	                                               GROUP_14_PIN_WIDTH * GROUP_PIN_OE_WIDTH[14] ,
	                                               GROUP_15_PIN_WIDTH * GROUP_PIN_OE_WIDTH[15] ,
	                                               GROUP_16_PIN_WIDTH * GROUP_PIN_OE_WIDTH[16] ,
	                                               GROUP_17_PIN_WIDTH * GROUP_PIN_OE_WIDTH[17] };

	localparam integer GROUP_STROBE_PIN_DATA_WIDTH [0:17] = '{ 2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT,
	                                                           2 * RATE_MULT };

	localparam integer GROUP_OUTPUT_STROBE_DATA_WIDTH [0:17] = '{ GROUP_STROBE_PIN_DATA_WIDTH[0],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[1],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[2],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[3],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[4],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[5],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[6],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[7],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[8],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[9],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[10],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[11],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[12],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[13],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[14],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[15],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[16],
	                                                              GROUP_STROBE_PIN_DATA_WIDTH[17] };

	localparam integer GROUP_STROBE_PIN_OE_WIDTH [0:17] = '{ RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT,
	                                                         RATE_MULT };

	localparam integer GROUP_OUTPUT_STROBE_OE_WIDTH [0:17] = '{ GROUP_STROBE_PIN_OE_WIDTH[0],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[1],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[2],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[3],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[4],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[5],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[6],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[7],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[8],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[9],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[10],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[11],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[12],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[13],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[14],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[15],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[16],
	                                                            GROUP_STROBE_PIN_OE_WIDTH[17] };

	// DFT Bus Width
	localparam integer DFT_DPRIO_IN_WIDTH  = 21;
	localparam integer DFT_DPRIO_OUT_WIDTH = 9;
	localparam integer GRP_CORE_TO_DFT_BUS_WIDTH = 4 * 3;
	localparam integer CORE_TO_DFT_BUS_WIDTH = PHYLITE_NUM_GROUPS * GRP_CORE_TO_DFT_BUS_WIDTH + DFT_DPRIO_IN_WIDTH;
	localparam integer GRP_DFT_TO_CORE_BUS_WIDTH = 4 * 15;
	localparam integer DFT_TO_CORE_BUS_WIDTH = PHYLITE_NUM_GROUPS * GRP_DFT_TO_CORE_BUS_WIDTH + DFT_DPRIO_OUT_WIDTH;

   	// The VCO frequency is used to derive filter code of interpolators
   	localparam PLL_VCO_FREQ_MHZ_INT_CAPPED = PLL_VCO_FREQ_MHZ_INT < 500 ? 500 : PLL_VCO_FREQ_MHZ_INT;
   
	////////////////////////////////////////////////////////////////////////////
	// Port Declarations
	////////////////////////////////////////////////////////////////////////////
	// Clock and Reset Ports
	input  ref_clk          ;
	input  reset_n          ;
	output interface_locked ;
	output core_clk_out     ;
	output pll_locked       ;
	output pll_extra_clock0      ;
	output pll_extra_clock1      ;
	output pll_extra_clock2      ;
	output pll_extra_clock3      ;

	// Avalon Input Ports
	input         avl_clk            ;
	input         avl_reset_n        ;
	input         avl_read           ;
	input         avl_write          ;
	input   [3:0] avl_byteenable     ;
	input  [31:0] avl_writedata      ;
	input  [27:0] avl_address        ;
	output [31:0] avl_readdata       ;
	output        avl_readdata_valid ;
	output        avl_waitrequest    ;

	// Avalon Output Ports
	output        avl_out_clk            ;
	output        avl_out_reset_n        ;
	output        avl_out_read           ;
	output        avl_out_write          ;
	output  [3:0] avl_out_byteenable     ;
	output [31:0] avl_out_writedata      ;
	output [27:0] avl_out_address        ;
	input  [31:0] avl_out_readdata       ;
	input         avl_out_readdata_valid ;
	input         avl_out_waitrequest    ;

	// Core Interface
	input                  [GROUP_OE_WIDTH[0] - 1 : 0] group_0_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[0] - 1 : 0] group_0_data_from_core   ;
	output               [GROUP_DATA_WIDTH[0] - 1 : 0] group_0_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_0_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_0_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[0] - 1 : 0] group_0_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[0] - 1 : 0] group_0_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[1] - 1 : 0] group_1_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[1] - 1 : 0] group_1_data_from_core   ;
	output               [GROUP_DATA_WIDTH[1] - 1 : 0] group_1_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_1_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_1_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[1] - 1 : 0] group_1_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[1] - 1 : 0] group_1_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[2] - 1 : 0] group_2_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[2] - 1 : 0] group_2_data_from_core   ;
	output               [GROUP_DATA_WIDTH[2] - 1 : 0] group_2_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_2_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_2_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[2] - 1 : 0] group_2_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[2] - 1 : 0] group_2_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[3] - 1 : 0] group_3_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[3] - 1 : 0] group_3_data_from_core   ;
	output               [GROUP_DATA_WIDTH[3] - 1 : 0] group_3_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_3_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_3_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[3] - 1 : 0] group_3_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[3] - 1 : 0] group_3_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[4] - 1 : 0] group_4_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[4] - 1 : 0] group_4_data_from_core   ;
	output               [GROUP_DATA_WIDTH[4] - 1 : 0] group_4_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_4_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_4_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[4] - 1 : 0] group_4_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[4] - 1 : 0] group_4_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[5] - 1 : 0] group_5_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[5] - 1 : 0] group_5_data_from_core   ;
	output               [GROUP_DATA_WIDTH[5] - 1 : 0] group_5_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_5_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_5_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[5] - 1 : 0] group_5_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[5] - 1 : 0] group_5_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[6] - 1 : 0] group_6_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[6] - 1 : 0] group_6_data_from_core   ;
	output               [GROUP_DATA_WIDTH[6] - 1 : 0] group_6_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_6_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_6_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[6] - 1 : 0] group_6_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[6] - 1 : 0] group_6_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[7] - 1 : 0] group_7_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[7] - 1 : 0] group_7_data_from_core   ;
	output               [GROUP_DATA_WIDTH[7] - 1 : 0] group_7_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_7_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_7_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[7] - 1 : 0] group_7_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[7] - 1 : 0] group_7_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[8] - 1 : 0] group_8_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[8] - 1 : 0] group_8_data_from_core   ;
	output               [GROUP_DATA_WIDTH[8] - 1 : 0] group_8_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_8_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_8_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[8] - 1 : 0] group_8_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[8] - 1 : 0] group_8_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[9] - 1 : 0] group_9_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[9] - 1 : 0] group_9_data_from_core   ;
	output               [GROUP_DATA_WIDTH[9] - 1 : 0] group_9_data_to_core     ;
	input                          [RATE_MULT - 1 : 0] group_9_rdata_en         ;
	output                         [RATE_MULT - 1 : 0] group_9_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[9] - 1 : 0] group_9_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[9] - 1 : 0] group_9_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[10] - 1 : 0] group_10_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[10] - 1 : 0] group_10_data_from_core   ;
	output               [GROUP_DATA_WIDTH[10] - 1 : 0] group_10_data_to_core     ;
	input                           [RATE_MULT - 1 : 0] group_10_rdata_en         ;
	output                          [RATE_MULT - 1 : 0] group_10_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[10] - 1 : 0] group_10_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[10] - 1 : 0] group_10_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[11] - 1 : 0] group_11_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[11] - 1 : 0] group_11_data_from_core   ;
	output               [GROUP_DATA_WIDTH[11] - 1 : 0] group_11_data_to_core     ;
	input                           [RATE_MULT - 1 : 0] group_11_rdata_en         ;
	output                          [RATE_MULT - 1 : 0] group_11_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[11] - 1 : 0] group_11_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[11] - 1 : 0] group_11_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[12] - 1 : 0] group_12_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[12] - 1 : 0] group_12_data_from_core   ;
	output               [GROUP_DATA_WIDTH[12] - 1 : 0] group_12_data_to_core     ;
	input                           [RATE_MULT - 1 : 0] group_12_rdata_en         ;
	output                          [RATE_MULT - 1 : 0] group_12_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[12] - 1 : 0] group_12_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[12] - 1 : 0] group_12_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[13] - 1 : 0] group_13_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[13] - 1 : 0] group_13_data_from_core   ;
	output               [GROUP_DATA_WIDTH[13] - 1 : 0] group_13_data_to_core     ;
	input                           [RATE_MULT - 1 : 0] group_13_rdata_en         ;
	output                          [RATE_MULT - 1 : 0] group_13_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[13] - 1 : 0] group_13_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[13] - 1 : 0] group_13_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[14] - 1 : 0] group_14_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[14] - 1 : 0] group_14_data_from_core   ;
	output               [GROUP_DATA_WIDTH[14] - 1 : 0] group_14_data_to_core     ;
	input                           [RATE_MULT - 1 : 0] group_14_rdata_en         ;
	output                          [RATE_MULT - 1 : 0] group_14_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[14] - 1 : 0] group_14_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[14] - 1 : 0] group_14_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[15] - 1 : 0] group_15_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[15] - 1 : 0] group_15_data_from_core   ;
	output               [GROUP_DATA_WIDTH[15] - 1 : 0] group_15_data_to_core     ;
	input                           [RATE_MULT - 1 : 0] group_15_rdata_en         ;
	output                          [RATE_MULT - 1 : 0] group_15_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[15] - 1 : 0] group_15_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[15] - 1 : 0] group_15_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[16] - 1 : 0] group_16_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[16] - 1 : 0] group_16_data_from_core   ;
	output               [GROUP_DATA_WIDTH[16] - 1 : 0] group_16_data_to_core     ;
	input                           [RATE_MULT - 1 : 0] group_16_rdata_en         ;
	output                          [RATE_MULT - 1 : 0] group_16_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[16] - 1 : 0] group_16_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[16] - 1 : 0] group_16_strobe_out_en    ;
	
	input                  [GROUP_OE_WIDTH[17] - 1 : 0] group_17_oe_from_core     ;
	input                [GROUP_DATA_WIDTH[17] - 1 : 0] group_17_data_from_core   ;
	output               [GROUP_DATA_WIDTH[17] - 1 : 0] group_17_data_to_core     ;
	input                           [RATE_MULT - 1 : 0] group_17_rdata_en         ;
	output                          [RATE_MULT - 1 : 0] group_17_rdata_valid      ;
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[17] - 1 : 0] group_17_strobe_out_in    ;
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[17] - 1 : 0] group_17_strobe_out_en    ;
	
	// I/Os
	output [GROUP_0_PIN_WIDTH - 1 : 0] group_0_data_out     ;
	input  [GROUP_0_PIN_WIDTH - 1 : 0] group_0_data_in      ;
	inout  [GROUP_0_PIN_WIDTH - 1 : 0] group_0_data_io      ;
	output                             group_0_strobe_out   ;
	output                             group_0_strobe_out_n ;
	input                              group_0_strobe_in    ;
	input                              group_0_strobe_in_n  ;
	inout                              group_0_strobe_io    ;
	inout                              group_0_strobe_io_n  ;
	output [GROUP_0_PIN_WIDTH - 1 : 0] group_0_data_out_n   ;
	input  [GROUP_0_PIN_WIDTH - 1 : 0] group_0_data_in_n    ;
	inout  [GROUP_0_PIN_WIDTH - 1 : 0] group_0_data_io_n    ;

	output [GROUP_1_PIN_WIDTH - 1 : 0] group_1_data_out     ;
	input  [GROUP_1_PIN_WIDTH - 1 : 0] group_1_data_in      ;
	inout  [GROUP_1_PIN_WIDTH - 1 : 0] group_1_data_io      ;
	output                             group_1_strobe_out   ;
	output                             group_1_strobe_out_n ;
	input                              group_1_strobe_in    ;
	input                              group_1_strobe_in_n  ;
	inout                              group_1_strobe_io    ;
	inout                              group_1_strobe_io_n  ;
	output [GROUP_1_PIN_WIDTH - 1 : 0] group_1_data_out_n   ;
	input  [GROUP_1_PIN_WIDTH - 1 : 0] group_1_data_in_n    ;
	inout  [GROUP_1_PIN_WIDTH - 1 : 0] group_1_data_io_n    ;


	output [GROUP_2_PIN_WIDTH - 1 : 0] group_2_data_out     ;
	input  [GROUP_2_PIN_WIDTH - 1 : 0] group_2_data_in      ;
	inout  [GROUP_2_PIN_WIDTH - 1 : 0] group_2_data_io      ;
	output                             group_2_strobe_out   ;
	output                             group_2_strobe_out_n ;
	input                              group_2_strobe_in    ;
	input                              group_2_strobe_in_n  ;
	inout                              group_2_strobe_io    ;
	inout                              group_2_strobe_io_n  ;
	output [GROUP_2_PIN_WIDTH - 1 : 0] group_2_data_out_n   ;
	input  [GROUP_2_PIN_WIDTH - 1 : 0] group_2_data_in_n    ;
	inout  [GROUP_2_PIN_WIDTH - 1 : 0] group_2_data_io_n    ;


	output [GROUP_3_PIN_WIDTH - 1 : 0] group_3_data_out     ;
	input  [GROUP_3_PIN_WIDTH - 1 : 0] group_3_data_in      ;
	inout  [GROUP_3_PIN_WIDTH - 1 : 0] group_3_data_io      ;
	output                             group_3_strobe_out   ;
	output                             group_3_strobe_out_n ;
	input                              group_3_strobe_in    ;
	input                              group_3_strobe_in_n  ;
	inout                              group_3_strobe_io    ;
	inout                              group_3_strobe_io_n  ;
	output [GROUP_3_PIN_WIDTH - 1 : 0] group_3_data_out_n   ;
	input  [GROUP_3_PIN_WIDTH - 1 : 0] group_3_data_in_n    ;
	inout  [GROUP_3_PIN_WIDTH - 1 : 0] group_3_data_io_n    ;


	output [GROUP_4_PIN_WIDTH - 1 : 0] group_4_data_out     ;
	input  [GROUP_4_PIN_WIDTH - 1 : 0] group_4_data_in      ;
	inout  [GROUP_4_PIN_WIDTH - 1 : 0] group_4_data_io      ;
	output                             group_4_strobe_out   ;
	output                             group_4_strobe_out_n ;
	input                              group_4_strobe_in    ;
	input                              group_4_strobe_in_n  ;
	inout                              group_4_strobe_io    ;
	inout                              group_4_strobe_io_n  ;
	output [GROUP_4_PIN_WIDTH - 1 : 0] group_4_data_out_n   ;
	input  [GROUP_4_PIN_WIDTH - 1 : 0] group_4_data_in_n    ;
	inout  [GROUP_4_PIN_WIDTH - 1 : 0] group_4_data_io_n    ;


	output [GROUP_5_PIN_WIDTH - 1 : 0] group_5_data_out     ;
	input  [GROUP_5_PIN_WIDTH - 1 : 0] group_5_data_in      ;
	inout  [GROUP_5_PIN_WIDTH - 1 : 0] group_5_data_io      ;
	output                             group_5_strobe_out   ;
	output                             group_5_strobe_out_n ;
	input                              group_5_strobe_in    ;
	input                              group_5_strobe_in_n  ;
	inout                              group_5_strobe_io    ;
	inout                              group_5_strobe_io_n  ;
	output [GROUP_5_PIN_WIDTH - 1 : 0] group_5_data_out_n   ;
	input  [GROUP_5_PIN_WIDTH - 1 : 0] group_5_data_in_n    ;
	inout  [GROUP_5_PIN_WIDTH - 1 : 0] group_5_data_io_n    ;


	output [GROUP_6_PIN_WIDTH - 1 : 0] group_6_data_out     ;
	input  [GROUP_6_PIN_WIDTH - 1 : 0] group_6_data_in      ;
	inout  [GROUP_6_PIN_WIDTH - 1 : 0] group_6_data_io      ;
	output                             group_6_strobe_out   ;
	output                             group_6_strobe_out_n ;
	input                              group_6_strobe_in    ;
	input                              group_6_strobe_in_n  ;
	inout                              group_6_strobe_io    ;
	inout                              group_6_strobe_io_n  ;
	output [GROUP_6_PIN_WIDTH - 1 : 0] group_6_data_out_n   ;
	input  [GROUP_6_PIN_WIDTH - 1 : 0] group_6_data_in_n    ;
	inout  [GROUP_6_PIN_WIDTH - 1 : 0] group_6_data_io_n    ;


	output [GROUP_7_PIN_WIDTH - 1 : 0] group_7_data_out     ;
	input  [GROUP_7_PIN_WIDTH - 1 : 0] group_7_data_in      ;
	inout  [GROUP_7_PIN_WIDTH - 1 : 0] group_7_data_io      ;
	output                             group_7_strobe_out   ;
	output                             group_7_strobe_out_n ;
	input                              group_7_strobe_in    ;
	input                              group_7_strobe_in_n  ;
	inout                              group_7_strobe_io    ;
	inout                              group_7_strobe_io_n  ;
	output [GROUP_7_PIN_WIDTH - 1 : 0] group_7_data_out_n   ;
	input  [GROUP_7_PIN_WIDTH - 1 : 0] group_7_data_in_n    ;
	inout  [GROUP_7_PIN_WIDTH - 1 : 0] group_7_data_io_n    ;


	output [GROUP_8_PIN_WIDTH - 1 : 0] group_8_data_out     ;
	input  [GROUP_8_PIN_WIDTH - 1 : 0] group_8_data_in      ;
	inout  [GROUP_8_PIN_WIDTH - 1 : 0] group_8_data_io      ;
	output                             group_8_strobe_out   ;
	output                             group_8_strobe_out_n ;
	input                              group_8_strobe_in    ;
	input                              group_8_strobe_in_n  ;
	inout                              group_8_strobe_io    ;
	inout                              group_8_strobe_io_n  ;
	output [GROUP_8_PIN_WIDTH - 1 : 0] group_8_data_out_n   ;
	input  [GROUP_8_PIN_WIDTH - 1 : 0] group_8_data_in_n    ;
	inout  [GROUP_8_PIN_WIDTH - 1 : 0] group_8_data_io_n    ;


	output [GROUP_9_PIN_WIDTH - 1 : 0] group_9_data_out     ;
	input  [GROUP_9_PIN_WIDTH - 1 : 0] group_9_data_in      ;
	inout  [GROUP_9_PIN_WIDTH - 1 : 0] group_9_data_io      ;
	output                             group_9_strobe_out   ;
	output                             group_9_strobe_out_n ;
	input                              group_9_strobe_in    ;
	input                              group_9_strobe_in_n  ;
	inout                              group_9_strobe_io    ;
	inout                              group_9_strobe_io_n  ;
	output [GROUP_9_PIN_WIDTH - 1 : 0] group_9_data_out_n   ;
	input  [GROUP_9_PIN_WIDTH - 1 : 0] group_9_data_in_n    ;
	inout  [GROUP_9_PIN_WIDTH - 1 : 0] group_9_data_io_n    ;


	output [GROUP_10_PIN_WIDTH - 1 : 0] group_10_data_out     ;
	input  [GROUP_10_PIN_WIDTH - 1 : 0] group_10_data_in      ;
	inout  [GROUP_10_PIN_WIDTH - 1 : 0] group_10_data_io      ;
	output                              group_10_strobe_out   ;
	output                              group_10_strobe_out_n ;
	input                               group_10_strobe_in    ;
	input                               group_10_strobe_in_n  ;
	inout                               group_10_strobe_io    ;
	inout                               group_10_strobe_io_n  ;
	output [GROUP_10_PIN_WIDTH - 1 : 0] group_10_data_out_n   ;
	input  [GROUP_10_PIN_WIDTH - 1 : 0] group_10_data_in_n    ;
	inout  [GROUP_10_PIN_WIDTH - 1 : 0] group_10_data_io_n    ;


	output [GROUP_11_PIN_WIDTH - 1 : 0] group_11_data_out     ;
	input  [GROUP_11_PIN_WIDTH - 1 : 0] group_11_data_in      ;
	inout  [GROUP_11_PIN_WIDTH - 1 : 0] group_11_data_io      ;
	output                              group_11_strobe_out   ;
	output                              group_11_strobe_out_n ;
	input                               group_11_strobe_in    ;
	input                               group_11_strobe_in_n  ;
	inout                               group_11_strobe_io    ;
	inout                               group_11_strobe_io_n  ;
	output [GROUP_11_PIN_WIDTH - 1 : 0] group_11_data_out_n   ;
	input  [GROUP_11_PIN_WIDTH - 1 : 0] group_11_data_in_n    ;
	inout  [GROUP_11_PIN_WIDTH - 1 : 0] group_11_data_io_n    ;


	output [GROUP_12_PIN_WIDTH - 1 : 0] group_12_data_out     ;
	input  [GROUP_12_PIN_WIDTH - 1 : 0] group_12_data_in      ;
	inout  [GROUP_12_PIN_WIDTH - 1 : 0] group_12_data_io      ;
	output                              group_12_strobe_out   ;
	output                              group_12_strobe_out_n ;
	input                               group_12_strobe_in    ;
	input                               group_12_strobe_in_n  ;
	inout                               group_12_strobe_io    ;
	inout                               group_12_strobe_io_n  ;
	output [GROUP_12_PIN_WIDTH - 1 : 0] group_12_data_out_n   ;
	input  [GROUP_12_PIN_WIDTH - 1 : 0] group_12_data_in_n    ;
	inout  [GROUP_12_PIN_WIDTH - 1 : 0] group_12_data_io_n    ;


	output [GROUP_13_PIN_WIDTH - 1 : 0] group_13_data_out     ;
	input  [GROUP_13_PIN_WIDTH - 1 : 0] group_13_data_in      ;
	inout  [GROUP_13_PIN_WIDTH - 1 : 0] group_13_data_io      ;
	output                              group_13_strobe_out   ;
	output                              group_13_strobe_out_n ;
	input                               group_13_strobe_in    ;
	input                               group_13_strobe_in_n  ;
	inout                               group_13_strobe_io    ;
	inout                               group_13_strobe_io_n  ;
	output [GROUP_13_PIN_WIDTH - 1 : 0] group_13_data_out_n   ;
	input  [GROUP_13_PIN_WIDTH - 1 : 0] group_13_data_in_n    ;
	inout  [GROUP_13_PIN_WIDTH - 1 : 0] group_13_data_io_n    ;


	output [GROUP_14_PIN_WIDTH - 1 : 0] group_14_data_out     ;
	input  [GROUP_14_PIN_WIDTH - 1 : 0] group_14_data_in      ;
	inout  [GROUP_14_PIN_WIDTH - 1 : 0] group_14_data_io      ;
	output                              group_14_strobe_out   ;
	output                              group_14_strobe_out_n ;
	input                               group_14_strobe_in    ;
	input                               group_14_strobe_in_n  ;
	inout                               group_14_strobe_io    ;
	inout                               group_14_strobe_io_n  ;
	output [GROUP_14_PIN_WIDTH - 1 : 0] group_14_data_out_n   ;
	input  [GROUP_14_PIN_WIDTH - 1 : 0] group_14_data_in_n    ;
	inout  [GROUP_14_PIN_WIDTH - 1 : 0] group_14_data_io_n    ;


	output [GROUP_15_PIN_WIDTH - 1 : 0] group_15_data_out     ;
	input  [GROUP_15_PIN_WIDTH - 1 : 0] group_15_data_in      ;
	inout  [GROUP_15_PIN_WIDTH - 1 : 0] group_15_data_io      ;
	output                              group_15_strobe_out   ;
	output                              group_15_strobe_out_n ;
	input                               group_15_strobe_in    ;
	input                               group_15_strobe_in_n  ;
	inout                               group_15_strobe_io    ;
	inout                               group_15_strobe_io_n  ;
	output [GROUP_15_PIN_WIDTH - 1 : 0] group_15_data_out_n   ;
	input  [GROUP_15_PIN_WIDTH - 1 : 0] group_15_data_in_n    ;
	inout  [GROUP_15_PIN_WIDTH - 1 : 0] group_15_data_io_n    ;


	output [GROUP_16_PIN_WIDTH - 1 : 0] group_16_data_out     ;
	input  [GROUP_16_PIN_WIDTH - 1 : 0] group_16_data_in      ;
	inout  [GROUP_16_PIN_WIDTH - 1 : 0] group_16_data_io      ;
	output                              group_16_strobe_out   ;
	output                              group_16_strobe_out_n ;
	input                               group_16_strobe_in    ;
	input                               group_16_strobe_in_n  ;
	inout                               group_16_strobe_io    ;
	inout                               group_16_strobe_io_n  ;
	output [GROUP_16_PIN_WIDTH - 1 : 0] group_16_data_out_n   ;
	input  [GROUP_16_PIN_WIDTH - 1 : 0] group_16_data_in_n    ;
	inout  [GROUP_16_PIN_WIDTH - 1 : 0] group_16_data_io_n    ;


	output [GROUP_17_PIN_WIDTH - 1 : 0] group_17_data_out     ;
	input  [GROUP_17_PIN_WIDTH - 1 : 0] group_17_data_in      ;
	inout  [GROUP_17_PIN_WIDTH - 1 : 0] group_17_data_io      ;
	output                              group_17_strobe_out   ;
	output                              group_17_strobe_out_n ;
	input                               group_17_strobe_in    ;
	input                               group_17_strobe_in_n  ;
	inout                               group_17_strobe_io    ;
	inout                               group_17_strobe_io_n  ;
	output [GROUP_17_PIN_WIDTH - 1 : 0] group_17_data_out_n   ;
	input  [GROUP_17_PIN_WIDTH - 1 : 0] group_17_data_in_n    ;
	inout  [GROUP_17_PIN_WIDTH - 1 : 0] group_17_data_io_n    ;


	// DFT Ports
	input  [CORE_TO_DFT_BUS_WIDTH - 1 : 0] core_to_dft;
	output [DFT_TO_CORE_BUS_WIDTH - 1 : 0] dft_to_core;

	////////////////////////////////////////////////////////////////////////////
	// Wire Declarations
	////////////////////////////////////////////////////////////////////////////
	// PLL
	wire [1:0] phy_clk     ;
	wire [7:0] phy_clk_phs ;
	wire       dll_ref_clk ;
	wire       locked_from_pll;
   	wire [1:0] core_clks_from_pll;
	wire [8:0] pll_c_counters;

	// Groups
	wire [PHYLITE_NUM_GROUPS-1:0] core_clks_locked;
	wire                          groups_locked;
	wire [0:PHYLITE_NUM_GROUPS-1] pa_core_clks;
	wire [PHYLITE_NUM_GROUPS-1:0] lanes_locked;
	wire                          safe_lock;
	reg                     [4:0] post_lock_cnt/* synthesis dont_merge syn_noprune syn_preserve = 1 */;

	// IO_AUX
	wire [54:0] cal_avl          [0:PHYLITE_NUM_GROUPS];
	wire [31:0] cal_avl_readdata [0:PHYLITE_NUM_GROUPS];
	

	// Inter-Tile Daisy Chains
	wire       broadcast_up   [0:PHYLITE_NUM_GROUPS];
	wire       broadcast_dn   [0:PHYLITE_NUM_GROUPS];
	wire [1:0] sync_up        [0:PHYLITE_NUM_GROUPS];
	wire [1:0] sync_dn        [0:PHYLITE_NUM_GROUPS];

	// Core Interface
	wire [191:0] oe_from_core   [0:PHYLITE_NUM_GROUPS-1];
	wire [383:0] data_from_core [0:PHYLITE_NUM_GROUPS-1];
	wire [383:0] data_to_core   [0:PHYLITE_NUM_GROUPS-1];
	wire   [3:0] rdata_en       [0:PHYLITE_NUM_GROUPS-1];
	wire   [3:0] rdata_valid    [0:PHYLITE_NUM_GROUPS-1];
	
	// I/Os
	wire [47:0] data_oe    [0:PHYLITE_NUM_GROUPS-1];
	wire [47:0] data_out   [0:PHYLITE_NUM_GROUPS-1];
	wire [47:0] data_in    [0:PHYLITE_NUM_GROUPS-1];
	wire [47:0] oct_enable [0:PHYLITE_NUM_GROUPS-1];

	// Periphery Clock Paths
	wire phy_fb_clk_to_tile;
	wire phy_fb_clk_to_pll ;
	wire core_clk_buffered ;
	wire core_clk_locked   ;

	// DFT Wires
	wire [DFT_DPRIO_IN_WIDTH -1:0] dft_dprio_in [0:PHYLITE_NUM_GROUPS-1];
	wire [DFT_DPRIO_OUT_WIDTH-1:0] dft_dprio_out[0:PHYLITE_NUM_GROUPS-1];

	////////////////////////////////////////////////////////////////////////////
	// Assignments
	////////////////////////////////////////////////////////////////////////////
	// Locked signal
	assign interface_locked = safe_lock;
	assign pll_locked       = locked_from_pll;

	// Core clocks
	assign core_clk_out    = (PHYLITE_USE_CPA == 1) ? core_clk_buffered : core_clks_from_pll[0];
	assign pll_extra_clock0     = pll_c_counters[5];
	assign pll_extra_clock1     = pll_c_counters[6];
	assign pll_extra_clock2     = pll_c_counters[7];
	assign pll_extra_clock3     = pll_c_counters[8];
	

	// PLL FB
	assign phy_fb_clk_to_pll = phy_fb_clk_to_tile;

	// DFT
	assign dft_dprio_in[0] = core_to_dft[DFT_DPRIO_IN_WIDTH-1:0];
	assign dft_to_core[DFT_DPRIO_OUT_WIDTH-1:0] = dft_dprio_out[0];

	assign cal_avl_readdata[PHYLITE_NUM_GROUPS] = 32'h00000000;
	assign broadcast_dn    [PHYLITE_NUM_GROUPS] = 1'b1;
	assign sync_dn         [PHYLITE_NUM_GROUPS] = 2'b11;

	// Tie-off Bottom of Daisy Chains
	assign broadcast_up[0] = 1'b1;
	assign sync_up     [0] = 2'b11;

	////////////////////////////////////////////////////////////////////////////
	// Core Logic
	////////////////////////////////////////////////////////////////////////////
	// Locked signal
	wire groups_locked_wire;
	assign groups_locked_wire = locked_from_pll & core_clk_locked & lanes_locked[0]; 
	assign safe_lock          = (post_lock_cnt == 5'h00);

   // Synchronize groups_locked before using it in post_lock_cnt
   generate
		if (PHYLITE_USE_CPA_LOCK == 0 && PHYLITE_USE_CPA == 1) begin
         localparam SYNC_STAGES = 3;
			(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name GLOBAL_SIGNAL OFF; -name AUTO_SHIFT_REGISTER_RECOGNITION OFF"}*) reg [SYNC_STAGES-1:0] groups_locked_synch_reg;
			always @(posedge core_clk_out or negedge reset_n) begin
				if (!reset_n) begin
					groups_locked_synch_reg <= {SYNC_STAGES{1'b0}};
				end else begin
					groups_locked_synch_reg <= {groups_locked_synch_reg[SYNC_STAGES-2:0], groups_locked_wire};
				end
			end
			assign groups_locked = groups_locked_synch_reg[SYNC_STAGES-1];
		end else begin
			assign groups_locked = groups_locked_wire;
		end
	endgenerate

	// Delay locked signal to allow read/write data paths to properly initialize
	always @(posedge core_clk_out or negedge reset_n) begin
		if (!reset_n) begin
			post_lock_cnt <= 5'h1F;
		end else begin
			if ((groups_locked == 1'b1) && (post_lock_cnt != 5'h00)) begin
				post_lock_cnt <= post_lock_cnt - 5'h01;
			end
		end
	end

	// Generate core clock lock signal if CPA lock isn't used
	generate
		if (PHYLITE_USE_CPA_LOCK == 1) begin
			assign core_clk_locked = (PHYLITE_USE_CPA == 1) ? core_clks_locked[0] : 1'b1;
		end else if (PHYLITE_USE_CPA == 0) begin
			assign core_clk_locked = 1'b1;
		end else begin
			begin : counter_lock_gen_master
			
				// Synchronize PLL lock signal to PLL ref clock domain.
				// This may not be necessary but we do it for extra safety.
				wire pll_ref_clk_reset_n;
				reg  pll_ref_clk_reset_n_sync_r;
				reg  pll_ref_clk_reset_n_sync_rr;
				reg  pll_ref_clk_reset_n_sync_rrr;
				
				assign pll_ref_clk_reset_n = pll_ref_clk_reset_n_sync_rrr;
				
				always @(posedge ref_clk or negedge locked_from_pll) begin
					if (~locked_from_pll) begin
						pll_ref_clk_reset_n_sync_r   <= 1'b0;
						pll_ref_clk_reset_n_sync_rr  <= 1'b0;
						pll_ref_clk_reset_n_sync_rrr <= 1'b0;
					end else begin
						pll_ref_clk_reset_n_sync_r   <= 1'b1;
						pll_ref_clk_reset_n_sync_rr  <= pll_ref_clk_reset_n_sync_r;
						pll_ref_clk_reset_n_sync_rrr <= pll_ref_clk_reset_n_sync_rr;
					end
				end
				
				// CPA takes ~50k core clock cycles to lock. Obviously we can't use a potentially
				// unstable core clock to clock the counter. We need to use the ref clock instead.
				// The fastest legal ref clock can run at the same rate as core clock, so we simply
				// count 64k PLL ref clock cycles.
				reg [16:0] cpa_count_to_lock;
				reg        counter_lock;
				
				// The following is evaluated for simulation. Don't wait too long during simulation.
				// synthesis translate_off
				localparam COUNTER_LOCK_EXP = 9;
				// synthesis translate_on
				
				// The following is evaluated for synthesis. Don't wait too long when DIAG_SYNTH_FOR_SIM enabled.
				// synthesis read_comments_as_HDL on
				// localparam COUNTER_LOCK_EXP  = DIAG_SYNTH_FOR_SIM ? 9 : 16;
				// synthesis read_comments_as_HDL off
				
				always @(posedge ref_clk or negedge pll_ref_clk_reset_n) begin
				   if (~pll_ref_clk_reset_n) begin  
				      cpa_count_to_lock <= {COUNTER_LOCK_EXP{1'b0}};
				      counter_lock <= 1'b0;
				   end else begin
				      if (~cpa_count_to_lock[COUNTER_LOCK_EXP]) begin
				         cpa_count_to_lock <= cpa_count_to_lock + 1'b1;
				      end
				      counter_lock <= cpa_count_to_lock[COUNTER_LOCK_EXP];
				   end
				end

				assign core_clk_locked = counter_lock;
			end
		end
	endgenerate

	////////////////////////////////////////////////////////////////////////////
	// PLL instance
	////////////////////////////////////////////////////////////////////////////
	pll # (
		.PLL_REF_CLK_FREQ_PS_STR             (PLL_REF_CLK_FREQ_PS_STR),
		.PLL_VCO_FREQ_PS_STR                 (PLL_VCO_FREQ_PS_STR),
		.PLL_USE_CORE_REF_CLK                (PLL_USE_CORE_REF_CLK),
		.pll_input_clock_frequency           (pll_input_clock_frequency),
		.pll_vco_clock_frequency             (pll_vco_clock_frequency),
		.m_cnt_hi_div                        (m_cnt_hi_div),
		.m_cnt_lo_div                        (m_cnt_lo_div),
		.n_cnt_hi_div                        (n_cnt_hi_div),
		.n_cnt_lo_div                        (n_cnt_lo_div),
		.m_cnt_bypass_en                     (m_cnt_bypass_en),
		.n_cnt_bypass_en                     (n_cnt_bypass_en),
		.m_cnt_odd_div_duty_en               (m_cnt_odd_div_duty_en),
		.n_cnt_odd_div_duty_en               (n_cnt_odd_div_duty_en),
		.pll_cp_setting                      (pll_cp_setting),
		.pll_bw_ctrl                         (pll_bw_ctrl),
		.c_cnt_hi_div0                       (c_cnt_hi_div0),
		.c_cnt_lo_div0                       (c_cnt_lo_div0),
		.c_cnt_prst0                         (c_cnt_prst0),
		.c_cnt_ph_mux_prst0                  (c_cnt_ph_mux_prst0),
		.c_cnt_bypass_en0                    (c_cnt_bypass_en0),
		.c_cnt_odd_div_duty_en0              (c_cnt_odd_div_duty_en0),
		.c_cnt_hi_div1                       (c_cnt_hi_div1),
		.c_cnt_lo_div1                       (c_cnt_lo_div1),
		.c_cnt_prst1                         (c_cnt_prst1),
		.c_cnt_ph_mux_prst1                  (c_cnt_ph_mux_prst1),
		.c_cnt_bypass_en1                    (c_cnt_bypass_en1),
		.c_cnt_odd_div_duty_en1              (c_cnt_odd_div_duty_en1),
		.c_cnt_hi_div2                       (c_cnt_hi_div2),
		.c_cnt_lo_div2                       (c_cnt_lo_div2),
		.c_cnt_prst2                         (c_cnt_prst2),
		.c_cnt_ph_mux_prst2                  (c_cnt_ph_mux_prst2),
		.c_cnt_bypass_en2                    (c_cnt_bypass_en2),
		.c_cnt_odd_div_duty_en2              (c_cnt_odd_div_duty_en2),
		.c_cnt_hi_div3                       (c_cnt_hi_div3),
		.c_cnt_lo_div3                       (c_cnt_lo_div3),
		.c_cnt_prst3                         (c_cnt_prst3),
		.c_cnt_ph_mux_prst3                  (c_cnt_ph_mux_prst3),
		.c_cnt_bypass_en3                    (c_cnt_bypass_en3),
		.c_cnt_odd_div_duty_en3              (c_cnt_odd_div_duty_en3),
		.c_cnt_hi_div4                       (c_cnt_hi_div4),
		.c_cnt_lo_div4                       (c_cnt_lo_div4),
		.c_cnt_prst4                         (c_cnt_prst4),
		.c_cnt_ph_mux_prst4                  (c_cnt_ph_mux_prst4),
		.c_cnt_bypass_en4                    (c_cnt_bypass_en4),
		.c_cnt_odd_div_duty_en4              (c_cnt_odd_div_duty_en4),
		.c_cnt_hi_div5                       (c_cnt_hi_div5),
		.c_cnt_lo_div5                       (c_cnt_lo_div5),
		.c_cnt_prst5                         (c_cnt_prst5),
		.c_cnt_ph_mux_prst5                  (c_cnt_ph_mux_prst5),
		.c_cnt_bypass_en5                    (c_cnt_bypass_en5),
		.c_cnt_odd_div_duty_en5              (c_cnt_odd_div_duty_en5),
		.c_cnt_hi_div6                       (c_cnt_hi_div6),
		.c_cnt_lo_div6                       (c_cnt_lo_div6),
		.c_cnt_prst6                         (c_cnt_prst6),
		.c_cnt_ph_mux_prst6                  (c_cnt_ph_mux_prst6),
		.c_cnt_bypass_en6                    (c_cnt_bypass_en6),
		.c_cnt_odd_div_duty_en6              (c_cnt_odd_div_duty_en6),
		.c_cnt_hi_div7                       (c_cnt_hi_div7),
		.c_cnt_lo_div7                       (c_cnt_lo_div7),
		.c_cnt_prst7                         (c_cnt_prst7),
		.c_cnt_ph_mux_prst7                  (c_cnt_ph_mux_prst7),
		.c_cnt_bypass_en7                    (c_cnt_bypass_en7),
		.c_cnt_odd_div_duty_en7              (c_cnt_odd_div_duty_en7),
		.c_cnt_hi_div8                       (c_cnt_hi_div8),
		.c_cnt_lo_div8                       (c_cnt_lo_div8),
		.c_cnt_prst8                         (c_cnt_prst8),
		.c_cnt_ph_mux_prst8                  (c_cnt_ph_mux_prst8),
		.c_cnt_bypass_en8                    (c_cnt_bypass_en8),
		.c_cnt_odd_div_duty_en8              (c_cnt_odd_div_duty_en8),
		.pll_output_clock_frequency_0        (pll_output_clock_frequency_0),
		.pll_output_phase_shift_0            (pll_output_phase_shift_0),
		.pll_output_duty_cycle_0             (pll_output_duty_cycle_0),
		.pll_output_clock_frequency_1        (pll_output_clock_frequency_1),
		.pll_output_phase_shift_1            (pll_output_phase_shift_1),
		.pll_output_duty_cycle_1             (pll_output_duty_cycle_1),
		.pll_output_clock_frequency_2        (pll_output_clock_frequency_2),
		.pll_output_phase_shift_2            (pll_output_phase_shift_2),
		.pll_output_duty_cycle_2             (pll_output_duty_cycle_2),
		.pll_output_clock_frequency_3        (pll_output_clock_frequency_3),
		.pll_output_phase_shift_3            (pll_output_phase_shift_3),
		.pll_output_duty_cycle_3             (pll_output_duty_cycle_3),
		.pll_output_clock_frequency_4        (pll_output_clock_frequency_4),
		.pll_output_phase_shift_4            (pll_output_phase_shift_4),
		.pll_output_duty_cycle_4             (pll_output_duty_cycle_4),
		.pll_output_clock_frequency_5        (pll_output_clock_frequency_5),
		.pll_output_phase_shift_5            (pll_output_phase_shift_5),
		.pll_output_duty_cycle_5             (pll_output_duty_cycle_5),
		.pll_output_clock_frequency_6        (pll_output_clock_frequency_6),
		.pll_output_phase_shift_6            (pll_output_phase_shift_6),
		.pll_output_duty_cycle_6             (pll_output_duty_cycle_6),
		.pll_output_clock_frequency_7        (pll_output_clock_frequency_7),
		.pll_output_phase_shift_7            (pll_output_phase_shift_7),
		.pll_output_duty_cycle_7             (pll_output_duty_cycle_7),
		.pll_output_clock_frequency_8        (pll_output_clock_frequency_8),
		.pll_output_phase_shift_8            (pll_output_phase_shift_8),
		.pll_output_duty_cycle_8             (pll_output_duty_cycle_8),
		.pll_clk_out_en_0                    (pll_clk_out_en_0),
		.pll_clk_out_en_1                    (pll_clk_out_en_1),
		.pll_clk_out_en_2                    (pll_clk_out_en_2),
		.pll_clk_out_en_3                    (pll_clk_out_en_3),
		.pll_clk_out_en_4                    (pll_clk_out_en_4),
		.pll_clk_out_en_5                    (pll_clk_out_en_5),
		.pll_clk_out_en_6                    (pll_clk_out_en_6),
		.pll_clk_out_en_7                    (pll_clk_out_en_7),
		.pll_clk_out_en_8                    (pll_clk_out_en_8),
		.pll_fbclk_mux_1                     (pll_fbclk_mux_1),
		.pll_fbclk_mux_2                     (pll_fbclk_mux_2),
		.pll_m_cnt_in_src                    (pll_m_cnt_in_src),
		.pll_bw_sel                          (pll_bw_sel)
	) pll_inst (
		.global_reset_n_int (reset_n            ),     
		.pll_ref_clk_int    (ref_clk            ),     
		.pll_lock           (locked_from_pll    ),     
		.pll_dll_clk        (dll_ref_clk        ),     
		.phy_clk_phs        (phy_clk_phs        ),     
		.phy_clk            (phy_clk            ),     
		.phy_fb_clk_to_tile (phy_fb_clk_to_tile ),     
		.phy_fb_clk_to_pll  (phy_fb_clk_to_pll  ),     
		.pll_c_counters     (pll_c_counters     ),
		.core_clks_from_pll (core_clks_from_pll )
	);

	////////////////////////////////////////////////////////////////////////////
	// IO_AUX instance
	////////////////////////////////////////////////////////////////////////////
	generate
		if (PHYLITE_USE_DYNAMIC_RECONFIGURATION == 1) begin : io_aux_ctrl
			wire [27:0] soft_nios_addr;
			// IO_AUX
			assign soft_nios_addr[23:0] = avl_address[23:0];
			// synthesis translate_off
			assign soft_nios_addr[27:24] = avl_address[27:24]; // top 4 bits of address are only used in simulation
			// synthesis translate_on                                                                                              
			twentynm_io_aux #(
				.interface_id                    (PHYLITE_INTERFACE_ID    ),
				.parameter_table_hex_file        (PARAM_TABLE_HEX_FILENAME),
				.cal_clk_div                     (IO_AUX_CAL_CLK_DIV      ),
				.sys_clk_source                  ("int_osc_clk"           ),
				.config_hps                      ("false"                 ),
				.config_io_aux_bypass            ("false"                 ),
				.config_power_down               ("false"                 ),
				.config_ram                      (38'h306420c0            ),
				.config_spare                    (8'h00                   ),
				.nios_break_vector_word_addr     (16'h8200                ),
				.nios_exception_vector_word_addr (16'h0008                ),
				.nios_reset_vector_word_addr     (16'h0000                ),
				.silicon_rev			 (SILICON_REV)
			) u_io_aux (
				// Reset
				.core_usr_reset_n              (reset_n                ),

				// Avalon Input
				.soft_nios_clk                 (avl_clk                ),
				.soft_nios_reset_n             (avl_reset_n            ),
				.soft_nios_read                (avl_read               ),
				.soft_nios_write               (avl_write              ),
				.soft_nios_burstcount          (1'b0                   ),
				.soft_nios_byteenable          (avl_byteenable         ),
				.soft_nios_write_data          (avl_writedata          ),
				.soft_nios_addr                (soft_nios_addr         ),
				.soft_nios_read_data           (avl_readdata           ),
				.soft_nios_read_data_valid     (avl_readdata_valid     ),
				.soft_nios_waitrequest         (avl_waitrequest        ),

				// Avalon Daisy Chain Output
				.soft_nios_out_clk             (avl_out_clk            ),
				.soft_nios_out_reset_n         (avl_out_reset_n        ),
				.soft_nios_out_read            (avl_out_read           ),
				.soft_nios_out_write           (avl_out_write          ),
				.soft_nios_out_burstcount      (                       ),
				.soft_nios_out_byteenable      (avl_out_byteenable     ),
				.soft_nios_out_write_data      (avl_out_writedata      ),
				.soft_nios_out_addr            (avl_out_address        ),
				.soft_nios_out_read_data       (avl_out_readdata       ),
				.soft_nios_out_read_data_valid (avl_out_readdata_valid ),
				.soft_nios_out_waitrequest     (avl_out_waitrequest    ),

				// Unused Soft RAM
				.soft_ram_clk                  (1'b0 ),
				.soft_ram_reset_n              (1'b0 ),
				.soft_ram_read_data            (1'b0 ),
				.soft_ram_rdata_valid          (32'd0),
				.soft_ram_waitrequest          (1'b0 ),

				
				.uc_av_bus_clk                 (cal_avl[0][54]         ),
				.uc_read                       (cal_avl[0][53]         ),
				.uc_write                      (cal_avl[0][52]         ),
				.uc_write_data                 (cal_avl[0][51:20]      ),
				.uc_address                    (cal_avl[0][19:0]       ),
				.uc_read_data                  (cal_avl_readdata[0]    )
			);
		end
		else begin
			assign cal_avl[0]   = 55'd0;
			assign avl_readdata = 32'd0;
		end
	endgenerate


	////////////////////////////////////////////////////////////////////////////
	// Generate Loop for data/strobe group instances
	////////////////////////////////////////////////////////////////////////////
	generate
		genvar grp_num;
		for(grp_num = 0; grp_num < PHYLITE_NUM_GROUPS; grp_num = grp_num + 1) begin : group_gen

			// Group Wires
			wire pa_core_clk_in;

			// Group Assignments
			assign pa_core_clk_in = ((grp_num == 0) && (PHYLITE_USE_CPA == 1)) ? core_clk_buffered : 1'b0;

			phylite_group_tile_20 #(
				.TILE_ID                      (grp_num                                    ),
				.USE_DYNAMIC_RECONFIGURATION  (PHYLITE_USE_DYNAMIC_RECONFIGURATION        ),
				.CORE_RATE                    (PHYLITE_RATE_ENUM                          ),
				.PLL_VCO_TO_MEM_CLK_FREQ_RATIO(PLL_VCO_TO_MEM_CLK_FREQ_RATIO              ),
				.PLL_VCO_FREQ_MHZ_INT         (PLL_VCO_FREQ_MHZ_INT_CAPPED                ),
				.PIN_TYPE                     (GROUP_PIN_TYPE                    [grp_num]),
				.PIN_WIDTH                    (GROUP_PIN_WIDTH                   [grp_num]),
				.DDR_SDR_MODE                 (GROUP_DDR_SDR_MODE                [grp_num]),
				.STROBE_CONFIG                (GROUP_STROBE_CONFIG               [grp_num]),
				.DATA_CONFIG                  (GROUP_DATA_CONFIG                 [grp_num]),
				.READ_LATENCY                 (GROUP_READ_LATENCY                [grp_num]),
				.USE_INTERNAL_CAPTURE_STROBE  (GROUP_USE_INTERNAL_CAPTURE_STROBE [grp_num]),
				.CAPTURE_PHASE_SHIFT          (GROUP_CAPTURE_PHASE_SHIFT         [grp_num]),
				.WRITE_LATENCY                (GROUP_WRITE_LATENCY               [grp_num]),
				.USE_OUTPUT_STROBE            (GROUP_USE_OUTPUT_STROBE           [grp_num]),
				.OUTPUT_STROBE_PHASE          (GROUP_OUTPUT_STROBE_PHASE         [grp_num]),
				.USE_SEPARATE_STROBES         (GROUP_USE_SEPARATE_STROBES        [grp_num]),
				.SWAP_CAPTURE_STROBE_POLARITY (GROUP_SWAP_CAPTURE_STROBE_POLARITY[grp_num]),
				.OCT_MODE                     (GROUP_OCT_MODE                    [grp_num]),
				.OCT_SIZE                     (GROUP_OCT_SIZE                    [grp_num]),
				.ENABLE_DFT                   (ENABLE_DFT                                 ),
				.DLL_MODE                     (DLL_MODE					  ),
				.DLL_CODEWORD                 (DLL_CODEWORD				  ),
				.DIAG_SYNTH_FOR_SIM	      (DIAG_SYNTH_FOR_SIM			  ),
				.SILICON_REV 		      (SILICON_REV)
			) u_phylite_group_tile_20 (
				// Clocks and Reset
				.phy_clk              (phy_clk                  ),
				.phy_clk_phs          (phy_clk_phs              ),
				.dll_ref_clk          (dll_ref_clk              ),
				.pll_locked           (locked_from_pll          ),
				.reset_n              (reset_n                  ),
				.lanes_locked         (lanes_locked    [grp_num]),
				.pa_locked            (core_clks_locked[grp_num]),
				.pa_core_clk_out      (pa_core_clks    [grp_num]),
				.pa_core_clk_in       (pa_core_clk_in           ),
				.phy_fb_clk_to_tile   (phy_fb_clk_to_tile       ),

				// Avalon Interface
				.cal_avl_out          (cal_avl         [grp_num + 1]),
				.cal_avl_readdata_in  (cal_avl_readdata[grp_num + 1]),
				.cal_avl_in           (cal_avl         [grp_num]    ),
				.cal_avl_readdata_out (cal_avl_readdata[grp_num]    ),

				// Core Interface
				.oe_from_core         (oe_from_core  [grp_num]),
				.data_from_core       (data_from_core[grp_num]),
				.data_to_core         (data_to_core  [grp_num]),
				.rdata_en             (rdata_en      [grp_num]),
				.rdata_valid          (rdata_valid   [grp_num]),
				
				// I/Os
				.data_oe              (data_oe   [grp_num]),
				.data_out             (data_out  [grp_num]),
				.data_in              (data_in   [grp_num]),
				.oct_enable           (oct_enable[grp_num]),

				// Inter-Tile Daisy Chains
				.broadcast_in_top     (broadcast_dn[grp_num + 1]),
				.broadcast_out_top    (broadcast_up[grp_num + 1]),
				.broadcast_in_bot     (broadcast_up[grp_num]    ),
				.broadcast_out_bot    (broadcast_dn[grp_num]    ),

				.sync_top_in          (sync_dn[grp_num + 1]     ),
				.sync_top_out         (sync_up[grp_num + 1]     ),
				.sync_bot_in          (sync_up[grp_num]         ),
				.sync_bot_out         (sync_dn[grp_num]         ),

				// DFT Ports
				.dft_dprio_in         (dft_dprio_in [grp_num]),
				.dft_dprio_out        (dft_dprio_out[grp_num]),
				.core_to_dft          (core_to_dft[((GRP_CORE_TO_DFT_BUS_WIDTH*(grp_num+1)+DFT_DPRIO_IN_WIDTH)) -1 : ((GRP_CORE_TO_DFT_BUS_WIDTH*grp_num)+DFT_DPRIO_IN_WIDTH )]),
				.dft_to_core          (dft_to_core[((GRP_DFT_TO_CORE_BUS_WIDTH*(grp_num+1)+DFT_DPRIO_OUT_WIDTH))-1 : ((GRP_DFT_TO_CORE_BUS_WIDTH*grp_num)+DFT_DPRIO_OUT_WIDTH)])
			);
		end 
	endgenerate

	////////////////////////////////////////////////////////////////////////////
	// Group Core/Periphery Connections instances
	////////////////////////////////////////////////////////////////////////////
	phylite_c2p_conns #(
		.NUM_GROUPS                        (PHYLITE_NUM_GROUPS               ),
		.RATE_MULT                         (RATE_MULT                        ),
		.GROUP_PIN_TYPE                    (GROUP_PIN_TYPE                   ),
		.GROUP_DDR_SDR_MODE                (GROUP_DDR_SDR_MODE               ),
		.GROUP_PIN_WIDTH                   (GROUP_PIN_WIDTH                  ),
		.GROUP_USE_OUTPUT_STROBE           (GROUP_USE_OUTPUT_STROBE          ),
		.GROUP_USE_INTERNAL_CAPTURE_STROBE (GROUP_USE_INTERNAL_CAPTURE_STROBE),
		.GROUP_USE_SEPARATE_STROBES        (GROUP_USE_SEPARATE_STROBES       ),
		.GROUP_STROBE_CONFIG               (GROUP_STROBE_CONFIG              ),
		.GROUP_DATA_CONFIG                 (GROUP_DATA_CONFIG                ),
		.GROUP_PIN_OE_WIDTH                (GROUP_PIN_OE_WIDTH               ),
		.GROUP_PIN_DATA_WIDTH              (GROUP_PIN_DATA_WIDTH             ),
		.GROUP_STROBE_PIN_OE_WIDTH         (GROUP_STROBE_PIN_OE_WIDTH        ),
		.GROUP_STROBE_PIN_DATA_WIDTH       (GROUP_STROBE_PIN_DATA_WIDTH      ),
		.GROUP_OE_WIDTH                    (GROUP_OE_WIDTH                   ),
		.GROUP_DATA_WIDTH                  (GROUP_DATA_WIDTH                 ),
		.GROUP_OUTPUT_STROBE_OE_WIDTH      (GROUP_OUTPUT_STROBE_OE_WIDTH     ),
		.GROUP_OUTPUT_STROBE_DATA_WIDTH    (GROUP_OUTPUT_STROBE_DATA_WIDTH   )
	) u_phylite_c2p_conns (
		.group_0_oe_from_core   (group_0_oe_from_core  ),
		.group_0_data_from_core (group_0_data_from_core),
		.group_0_data_to_core   (group_0_data_to_core  ),
		.group_0_rdata_en       (group_0_rdata_en      ),
		.group_0_rdata_valid    (group_0_rdata_valid   ),
		.group_0_strobe_out_in  (group_0_strobe_out_in ),
		.group_0_strobe_out_en  (group_0_strobe_out_en ),
                                                                     
		.group_1_oe_from_core   (group_1_oe_from_core  ),
		.group_1_data_from_core (group_1_data_from_core),
		.group_1_data_to_core   (group_1_data_to_core  ),
		.group_1_rdata_en       (group_1_rdata_en      ),
		.group_1_rdata_valid    (group_1_rdata_valid   ),
		.group_1_strobe_out_in  (group_1_strobe_out_in ),
		.group_1_strobe_out_en  (group_1_strobe_out_en ),
                                                                     
		.group_2_oe_from_core   (group_2_oe_from_core  ),
		.group_2_data_from_core (group_2_data_from_core),
		.group_2_data_to_core   (group_2_data_to_core  ),
		.group_2_rdata_en       (group_2_rdata_en      ),
		.group_2_rdata_valid    (group_2_rdata_valid   ),
		.group_2_strobe_out_in  (group_2_strobe_out_in ),
		.group_2_strobe_out_en  (group_2_strobe_out_en ),
                                                                     
		.group_3_oe_from_core   (group_3_oe_from_core  ),
		.group_3_data_from_core (group_3_data_from_core),
		.group_3_data_to_core   (group_3_data_to_core  ),
		.group_3_rdata_en       (group_3_rdata_en      ),
		.group_3_rdata_valid    (group_3_rdata_valid   ),
		.group_3_strobe_out_in  (group_3_strobe_out_in ),
		.group_3_strobe_out_en  (group_3_strobe_out_en ),
                                                                     
		.group_4_oe_from_core   (group_4_oe_from_core  ),
		.group_4_data_from_core (group_4_data_from_core),
		.group_4_data_to_core   (group_4_data_to_core  ),
		.group_4_rdata_en       (group_4_rdata_en      ),
		.group_4_rdata_valid    (group_4_rdata_valid   ),
		.group_4_strobe_out_in  (group_4_strobe_out_in ),
		.group_4_strobe_out_en  (group_4_strobe_out_en ),
                                                                     
		.group_5_oe_from_core   (group_5_oe_from_core  ),
		.group_5_data_from_core (group_5_data_from_core),
		.group_5_data_to_core   (group_5_data_to_core  ),
		.group_5_rdata_en       (group_5_rdata_en      ),
		.group_5_rdata_valid    (group_5_rdata_valid   ),
		.group_5_strobe_out_in  (group_5_strobe_out_in ),
		.group_5_strobe_out_en  (group_5_strobe_out_en ),
                                                                     
		.group_6_oe_from_core   (group_6_oe_from_core  ),
		.group_6_data_from_core (group_6_data_from_core),
		.group_6_data_to_core   (group_6_data_to_core  ),
		.group_6_rdata_en       (group_6_rdata_en      ),
		.group_6_rdata_valid    (group_6_rdata_valid   ),
		.group_6_strobe_out_in  (group_6_strobe_out_in ),
		.group_6_strobe_out_en  (group_6_strobe_out_en ),
                                                                     
		.group_7_oe_from_core   (group_7_oe_from_core  ),
		.group_7_data_from_core (group_7_data_from_core),
		.group_7_data_to_core   (group_7_data_to_core  ),
		.group_7_rdata_en       (group_7_rdata_en      ),
		.group_7_rdata_valid    (group_7_rdata_valid   ),
		.group_7_strobe_out_in  (group_7_strobe_out_in ),
		.group_7_strobe_out_en  (group_7_strobe_out_en ),
                                                                     
		.group_8_oe_from_core   (group_8_oe_from_core  ),
		.group_8_data_from_core (group_8_data_from_core),
		.group_8_data_to_core   (group_8_data_to_core  ),
		.group_8_rdata_en       (group_8_rdata_en      ),
		.group_8_rdata_valid    (group_8_rdata_valid   ),
		.group_8_strobe_out_in  (group_8_strobe_out_in ),
		.group_8_strobe_out_en  (group_8_strobe_out_en ),
                                                                     
		.group_9_oe_from_core   (group_9_oe_from_core  ),
		.group_9_data_from_core (group_9_data_from_core),
		.group_9_data_to_core   (group_9_data_to_core  ),
		.group_9_rdata_en       (group_9_rdata_en      ),
		.group_9_rdata_valid    (group_9_rdata_valid   ),
		.group_9_strobe_out_in  (group_9_strobe_out_in ),
		.group_9_strobe_out_en  (group_9_strobe_out_en ),
                                                                     
		.group_10_oe_from_core  (group_10_oe_from_core  ),
		.group_10_data_from_core(group_10_data_from_core),
		.group_10_data_to_core  (group_10_data_to_core  ),
		.group_10_rdata_en      (group_10_rdata_en      ),
		.group_10_rdata_valid   (group_10_rdata_valid   ),
		.group_10_strobe_out_in (group_10_strobe_out_in ),
		.group_10_strobe_out_en (group_10_strobe_out_en ),
                                                                     
		.group_11_oe_from_core  (group_11_oe_from_core  ),
		.group_11_data_from_core(group_11_data_from_core),
		.group_11_data_to_core  (group_11_data_to_core  ),
		.group_11_rdata_en      (group_11_rdata_en      ),
		.group_11_rdata_valid   (group_11_rdata_valid   ),
		.group_11_strobe_out_in (group_11_strobe_out_in ),
		.group_11_strobe_out_en (group_11_strobe_out_en ),

		.group_12_oe_from_core  (group_12_oe_from_core  ),
		.group_12_data_from_core(group_12_data_from_core),
		.group_12_data_to_core  (group_12_data_to_core  ),
		.group_12_rdata_en      (group_12_rdata_en      ),
		.group_12_rdata_valid   (group_12_rdata_valid   ),
		.group_12_strobe_out_in (group_12_strobe_out_in ),
		.group_12_strobe_out_en (group_12_strobe_out_en ),

		.group_13_oe_from_core  (group_13_oe_from_core  ),
		.group_13_data_from_core(group_13_data_from_core),
		.group_13_data_to_core  (group_13_data_to_core  ),
		.group_13_rdata_en      (group_13_rdata_en      ),
		.group_13_rdata_valid   (group_13_rdata_valid   ),
		.group_13_strobe_out_in (group_13_strobe_out_in ),
		.group_13_strobe_out_en (group_13_strobe_out_en ),

		.group_14_oe_from_core  (group_14_oe_from_core  ),
		.group_14_data_from_core(group_14_data_from_core),
		.group_14_data_to_core  (group_14_data_to_core  ),
		.group_14_rdata_en      (group_14_rdata_en      ),
		.group_14_rdata_valid   (group_14_rdata_valid   ),
		.group_14_strobe_out_in (group_14_strobe_out_in ),
		.group_14_strobe_out_en (group_14_strobe_out_en ),

		.group_15_oe_from_core  (group_15_oe_from_core  ),
		.group_15_data_from_core(group_15_data_from_core),
		.group_15_data_to_core  (group_15_data_to_core  ),
		.group_15_rdata_en      (group_15_rdata_en      ),
		.group_15_rdata_valid   (group_15_rdata_valid   ),
		.group_15_strobe_out_in (group_15_strobe_out_in ),
		.group_15_strobe_out_en (group_15_strobe_out_en ),

		.group_16_oe_from_core  (group_16_oe_from_core  ),
		.group_16_data_from_core(group_16_data_from_core),
		.group_16_data_to_core  (group_16_data_to_core  ),
		.group_16_rdata_en      (group_16_rdata_en      ),
		.group_16_rdata_valid   (group_16_rdata_valid   ),
		.group_16_strobe_out_in (group_16_strobe_out_in ),
		.group_16_strobe_out_en (group_16_strobe_out_en ),

		.group_17_oe_from_core  (group_17_oe_from_core  ),
		.group_17_data_from_core(group_17_data_from_core),
		.group_17_data_to_core  (group_17_data_to_core  ),
		.group_17_rdata_en      (group_17_rdata_en      ),
		.group_17_rdata_valid   (group_17_rdata_valid   ),
		.group_17_strobe_out_in (group_17_strobe_out_in ),
		.group_17_strobe_out_en (group_17_strobe_out_en ),

		.oe_from_core   (oe_from_core   ),
		.data_from_core (data_from_core ),
		.data_to_core   (data_to_core   ),
		.rdata_en       (rdata_en       ),
		.rdata_valid    (rdata_valid    )
	);

	////////////////////////////////////////////////////////////////////////////
	// Group I/O Buffer instances
	////////////////////////////////////////////////////////////////////////////
	phylite_io_bufs #(
		.NUM_GROUPS                        (PHYLITE_NUM_GROUPS               ),
		.GROUP_PIN_TYPE                    (GROUP_PIN_TYPE                   ),
		.GROUP_PIN_WIDTH                   (GROUP_PIN_WIDTH                  ),
		.GROUP_USE_OUTPUT_STROBE           (GROUP_USE_OUTPUT_STROBE          ),
		.GROUP_USE_INTERNAL_CAPTURE_STROBE (GROUP_USE_INTERNAL_CAPTURE_STROBE),
		.GROUP_USE_SEPARATE_STROBES        (GROUP_USE_SEPARATE_STROBES       ),
		.GROUP_STROBE_CONFIG               (GROUP_STROBE_CONFIG              ),
		.GROUP_DATA_CONFIG                 (GROUP_DATA_CONFIG                )
	) u_phylite_io_bufs (
		.data_oe       (data_oe       ),
		.data_out      (data_out      ),
		.data_in       (data_in       ),
		.oct_enable    (oct_enable    ),

		.group_0_data_out      (group_0_data_out      ),
		.group_0_data_in       (group_0_data_in       ),
		.group_0_data_io       (group_0_data_io       ),
		.group_0_strobe_out    (group_0_strobe_out    ),
		.group_0_strobe_out_n  (group_0_strobe_out_n  ),
		.group_0_strobe_in     (group_0_strobe_in     ),
		.group_0_strobe_in_n   (group_0_strobe_in_n   ),
		.group_0_strobe_io     (group_0_strobe_io     ),
		.group_0_strobe_io_n   (group_0_strobe_io_n   ),
         	.group_0_data_out_n    (group_0_data_out_n    ),
		.group_0_data_in_n     (group_0_data_in_n     ),
		.group_0_data_io_n     (group_0_data_io_n     ),
                                                           
		.group_1_data_out      (group_1_data_out      ),
		.group_1_data_in       (group_1_data_in       ),
		.group_1_data_io       (group_1_data_io       ),
		.group_1_strobe_out    (group_1_strobe_out    ),
		.group_1_strobe_out_n  (group_1_strobe_out_n  ),
		.group_1_strobe_in     (group_1_strobe_in     ),
		.group_1_strobe_in_n   (group_1_strobe_in_n   ),
		.group_1_strobe_io     (group_1_strobe_io     ),
		.group_1_strobe_io_n   (group_1_strobe_io_n   ),
            	.group_1_data_out_n    (group_1_data_out_n    ),
		.group_1_data_in_n     (group_1_data_in_n     ),
		.group_1_data_io_n     (group_1_data_io_n     ),
                                                                  
		.group_2_data_out      (group_2_data_out      ),
		.group_2_data_in       (group_2_data_in       ),
		.group_2_data_io       (group_2_data_io       ),
		.group_2_strobe_out    (group_2_strobe_out    ),
		.group_2_strobe_out_n  (group_2_strobe_out_n  ),
		.group_2_strobe_in     (group_2_strobe_in     ),
		.group_2_strobe_in_n   (group_2_strobe_in_n   ),
		.group_2_strobe_io     (group_2_strobe_io     ),
		.group_2_strobe_io_n   (group_2_strobe_io_n   ),
         	.group_2_data_out_n    (group_2_data_out_n    ),
		.group_2_data_in_n     (group_2_data_in_n     ),
		.group_2_data_io_n     (group_2_data_io_n     ),
                                                                     
		.group_3_data_out      (group_3_data_out      ),
		.group_3_data_in       (group_3_data_in       ),
		.group_3_data_io       (group_3_data_io       ),
		.group_3_strobe_out    (group_3_strobe_out    ),
		.group_3_strobe_out_n  (group_3_strobe_out_n  ),
		.group_3_strobe_in     (group_3_strobe_in     ),
		.group_3_strobe_in_n   (group_3_strobe_in_n   ),
		.group_3_strobe_io     (group_3_strobe_io     ),
		.group_3_strobe_io_n   (group_3_strobe_io_n   ),
         	.group_3_data_out_n    (group_3_data_out_n    ),
		.group_3_data_in_n     (group_3_data_in_n     ),
		.group_3_data_io_n     (group_3_data_io_n     ),
                                                                     
		.group_4_data_out      (group_4_data_out      ),
		.group_4_data_in       (group_4_data_in       ),
		.group_4_data_io       (group_4_data_io       ),
		.group_4_strobe_out    (group_4_strobe_out    ),
		.group_4_strobe_out_n  (group_4_strobe_out_n  ),
		.group_4_strobe_in     (group_4_strobe_in     ),
		.group_4_strobe_in_n   (group_4_strobe_in_n   ),
		.group_4_strobe_io     (group_4_strobe_io     ),
		.group_4_strobe_io_n   (group_4_strobe_io_n   ),
         	.group_4_data_out_n    (group_4_data_out_n    ),
		.group_4_data_in_n     (group_4_data_in_n     ),
		.group_4_data_io_n     (group_4_data_io_n     ),
                                                                     
		.group_5_data_out      (group_5_data_out      ),
		.group_5_data_in       (group_5_data_in       ),
		.group_5_data_io       (group_5_data_io       ),
		.group_5_strobe_out    (group_5_strobe_out    ),
		.group_5_strobe_out_n  (group_5_strobe_out_n  ),
		.group_5_strobe_in     (group_5_strobe_in     ),
		.group_5_strobe_in_n   (group_5_strobe_in_n   ),
		.group_5_strobe_io     (group_5_strobe_io     ),
		.group_5_strobe_io_n   (group_5_strobe_io_n   ),
         	.group_5_data_out_n    (group_5_data_out_n    ),
		.group_5_data_in_n     (group_5_data_in_n     ),
		.group_5_data_io_n     (group_5_data_io_n     ),
                                                                     
		.group_6_data_out      (group_6_data_out      ),
		.group_6_data_in       (group_6_data_in       ),
		.group_6_data_io       (group_6_data_io       ),
		.group_6_strobe_out    (group_6_strobe_out    ),
		.group_6_strobe_out_n  (group_6_strobe_out_n  ),
		.group_6_strobe_in     (group_6_strobe_in     ),
		.group_6_strobe_in_n   (group_6_strobe_in_n   ),
		.group_6_strobe_io     (group_6_strobe_io     ),
		.group_6_strobe_io_n   (group_6_strobe_io_n   ),
         	.group_6_data_out_n    (group_6_data_out_n    ),
		.group_6_data_in_n     (group_6_data_in_n     ),
		.group_6_data_io_n     (group_6_data_io_n     ),
                                                                     
		.group_7_data_out      (group_7_data_out      ),
		.group_7_data_in       (group_7_data_in       ),
		.group_7_data_io       (group_7_data_io       ),
		.group_7_strobe_out    (group_7_strobe_out    ),
		.group_7_strobe_out_n  (group_7_strobe_out_n  ),
		.group_7_strobe_in     (group_7_strobe_in     ),
		.group_7_strobe_in_n   (group_7_strobe_in_n   ),
		.group_7_strobe_io     (group_7_strobe_io     ),
		.group_7_strobe_io_n   (group_7_strobe_io_n   ),
         	.group_7_data_out_n    (group_7_data_out_n    ),
		.group_7_data_in_n     (group_7_data_in_n     ),
		.group_7_data_io_n     (group_7_data_io_n     ),
                                                                     
		.group_8_data_out      (group_8_data_out      ),
		.group_8_data_in       (group_8_data_in       ),
		.group_8_data_io       (group_8_data_io       ),
		.group_8_strobe_out    (group_8_strobe_out    ),
		.group_8_strobe_out_n  (group_8_strobe_out_n  ),
		.group_8_strobe_in     (group_8_strobe_in     ),
		.group_8_strobe_in_n   (group_8_strobe_in_n   ),
		.group_8_strobe_io     (group_8_strobe_io     ),
		.group_8_strobe_io_n   (group_8_strobe_io_n   ),
         	.group_8_data_out_n    (group_8_data_out_n    ),
		.group_8_data_in_n     (group_8_data_in_n     ),
		.group_8_data_io_n     (group_8_data_io_n     ),
                                                                     
		.group_9_data_out      (group_9_data_out      ),
		.group_9_data_in       (group_9_data_in       ),
		.group_9_data_io       (group_9_data_io       ),
		.group_9_strobe_out    (group_9_strobe_out    ),
		.group_9_strobe_out_n  (group_9_strobe_out_n  ),
		.group_9_strobe_in     (group_9_strobe_in     ),
		.group_9_strobe_in_n   (group_9_strobe_in_n   ),
		.group_9_strobe_io     (group_9_strobe_io     ),
		.group_9_strobe_io_n   (group_9_strobe_io_n   ),
         	.group_9_data_out_n    (group_9_data_out_n    ),
		.group_9_data_in_n     (group_9_data_in_n     ),
		.group_9_data_io_n     (group_9_data_io_n     ),
                                                                     
		.group_10_data_out     (group_10_data_out     ),
		.group_10_data_in      (group_10_data_in      ),
		.group_10_data_io      (group_10_data_io      ),
		.group_10_strobe_out   (group_10_strobe_out   ),
		.group_10_strobe_out_n (group_10_strobe_out_n ),
		.group_10_strobe_in    (group_10_strobe_in    ),
		.group_10_strobe_in_n  (group_10_strobe_in_n  ),
		.group_10_strobe_io    (group_10_strobe_io    ),
		.group_10_strobe_io_n  (group_10_strobe_io_n  ),
         	.group_10_data_out_n   (group_10_data_out_n   ),
		.group_10_data_in_n    (group_10_data_in_n    ),
		.group_10_data_io_n    (group_10_data_io_n    ),
                                                                     
		.group_11_data_out     (group_11_data_out     ),
		.group_11_data_in      (group_11_data_in      ),
		.group_11_data_io      (group_11_data_io      ),
		.group_11_strobe_out   (group_11_strobe_out   ),
		.group_11_strobe_out_n (group_11_strobe_out_n ),
		.group_11_strobe_in    (group_11_strobe_in    ),
		.group_11_strobe_in_n  (group_11_strobe_in_n  ),
		.group_11_strobe_io    (group_11_strobe_io    ),
		.group_11_strobe_io_n  (group_11_strobe_io_n  ),
         	.group_11_data_out_n   (group_11_data_out_n   ),
		.group_11_data_in_n    (group_11_data_in_n    ),
		.group_11_data_io_n    (group_11_data_io_n    ),
 
		.group_12_data_out     (group_12_data_out     ),
		.group_12_data_in      (group_12_data_in      ),
		.group_12_data_io      (group_12_data_io      ),
		.group_12_strobe_out   (group_12_strobe_out   ),
		.group_12_strobe_out_n (group_12_strobe_out_n ),
		.group_12_strobe_in    (group_12_strobe_in    ),
		.group_12_strobe_in_n  (group_12_strobe_in_n  ),
		.group_12_strobe_io    (group_12_strobe_io    ),
		.group_12_strobe_io_n  (group_12_strobe_io_n  ),
         	.group_12_data_out_n   (group_12_data_out_n   ),
		.group_12_data_in_n    (group_12_data_in_n    ),
		.group_12_data_io_n    (group_12_data_io_n    ),
                                                                     
		.group_13_data_out     (group_13_data_out     ),
		.group_13_data_in      (group_13_data_in      ),
		.group_13_data_io      (group_13_data_io      ),
		.group_13_strobe_out   (group_13_strobe_out   ),
		.group_13_strobe_out_n (group_13_strobe_out_n ),
		.group_13_strobe_in    (group_13_strobe_in    ),
		.group_13_strobe_in_n  (group_13_strobe_in_n  ),
		.group_13_strobe_io    (group_13_strobe_io    ),
		.group_13_strobe_io_n  (group_13_strobe_io_n  ),
         	.group_13_data_out_n   (group_13_data_out_n   ),
		.group_13_data_in_n    (group_13_data_in_n    ),
		.group_13_data_io_n    (group_13_data_io_n    ),
                                                                     
		.group_14_data_out     (group_14_data_out     ),
		.group_14_data_in      (group_14_data_in      ),
		.group_14_data_io      (group_14_data_io      ),
		.group_14_strobe_out   (group_14_strobe_out   ),
		.group_14_strobe_out_n (group_14_strobe_out_n ),
		.group_14_strobe_in    (group_14_strobe_in    ),
		.group_14_strobe_in_n  (group_14_strobe_in_n  ),
		.group_14_strobe_io    (group_14_strobe_io    ),
		.group_14_strobe_io_n  (group_14_strobe_io_n  ),
         	.group_14_data_out_n   (group_14_data_out_n   ),
		.group_14_data_in_n    (group_14_data_in_n    ),
		.group_14_data_io_n    (group_14_data_io_n    ),
                                                                     
		.group_15_data_out     (group_15_data_out     ),
		.group_15_data_in      (group_15_data_in      ),
		.group_15_data_io      (group_15_data_io      ),
		.group_15_strobe_out   (group_15_strobe_out   ),
		.group_15_strobe_out_n (group_15_strobe_out_n ),
		.group_15_strobe_in    (group_15_strobe_in    ),
		.group_15_strobe_in_n  (group_15_strobe_in_n  ),
		.group_15_strobe_io    (group_15_strobe_io    ),
		.group_15_strobe_io_n  (group_15_strobe_io_n  ),
         	.group_15_data_out_n   (group_15_data_out_n   ),
		.group_15_data_in_n    (group_15_data_in_n    ),
		.group_15_data_io_n    (group_15_data_io_n    ),
                                                                     
		.group_16_data_out     (group_16_data_out     ),
		.group_16_data_in      (group_16_data_in      ),
		.group_16_data_io      (group_16_data_io      ),
		.group_16_strobe_out   (group_16_strobe_out   ),
		.group_16_strobe_out_n (group_16_strobe_out_n ),
		.group_16_strobe_in    (group_16_strobe_in    ),
		.group_16_strobe_in_n  (group_16_strobe_in_n  ),
		.group_16_strobe_io    (group_16_strobe_io    ),
		.group_16_strobe_io_n  (group_16_strobe_io_n  ),
         	.group_16_data_out_n   (group_16_data_out_n   ),
		.group_16_data_in_n    (group_16_data_in_n    ),
		.group_16_data_io_n    (group_16_data_io_n    ),
                                                                     
		.group_17_data_out     (group_17_data_out     ),
		.group_17_data_in      (group_17_data_in      ),
		.group_17_data_io      (group_17_data_io      ),
		.group_17_strobe_out   (group_17_strobe_out   ),
		.group_17_strobe_out_n (group_17_strobe_out_n ),
		.group_17_strobe_in    (group_17_strobe_in    ),
		.group_17_strobe_in_n  (group_17_strobe_in_n  ),
		.group_17_strobe_io    (group_17_strobe_io    ),
		.group_17_strobe_io_n  (group_17_strobe_io_n  ),
         	.group_17_data_out_n   (group_17_data_out_n   ),
		.group_17_data_in_n    (group_17_data_in_n    ),
		.group_17_data_io_n    (group_17_data_io_n    )
 	);

	////////////////////////////////////////////////////////////////////////////
	// Core Clock Buffer instance
	////////////////////////////////////////////////////////////////////////////
	generate
		if (PHYLITE_USE_CPA == 1) begin : core_clk_buf_gen
			twentynm_clkena # (
				.clock_type ("GLOBAL CLOCK")
			) core_clk_buf (
				.inclk  (pa_core_clks[0]),
				.outclk (core_clk_buffered),
				.ena    (1'b1),
				.enaout ()
			);
		end
	endgenerate

endmodule
