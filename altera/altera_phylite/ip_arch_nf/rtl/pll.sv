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



////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  EMIF IOPLL instantiation for 20nm families
//
//  The following table describes the usage of IOPLL by EMIF. 
//
//  PLL Counter    Fanouts                          Usage
//  =====================================================================================
//  VCO Outputs    vcoph[7:0] -> phy_clk_phs[7:0]   FR clocks, 8 phases (45-deg apart)
//                 vcoph[0] -> DLL                  FR clock to DLL
//  C-counter 0    lvds_clk[0] -> phy_clk[1]        Secondary PHY clock tree (C2P/P2C rate)
//  C-counter 1    loaden[0] -> phy_clk[0]          Primary PHY clock tree (PHY/HMC rate)
//  C-counter 2    phy_clk[2]                       Feedback PHY clock tree (slowest phy clock in system)
//
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////
module pll #(
   parameter PLL_REF_CLK_FREQ_PS_STR                 = "0 ps",
   parameter PLL_VCO_FREQ_PS_STR                     = "0 ps",
   parameter PLL_USE_CORE_REF_CLK                = 0,
   
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
   parameter pll_bw_sel                              = ""
) (
   input  logic       global_reset_n_int,     
   input  logic       pll_ref_clk_int,        
   output logic       pll_lock,               
   output logic       pll_dll_clk,            
   output logic [7:0] phy_clk_phs,            
   output logic [1:0] phy_clk,                
   output logic       phy_fb_clk_to_tile,     
   input  logic       phy_fb_clk_to_pll,      
   output logic [8:0] pll_c_counters,         
   output logic [1:0] core_clks_from_pll      
);
   timeunit 1ns;
   timeprecision 1ps;

   localparam pll_clkin_0_src = (PLL_USE_CORE_REF_CLK == 1) ? "pll_clkin_0_src_coreclkin" : "pll_clkin_0_src_refclkin";
   localparam pll_clkin_1_src = (PLL_USE_CORE_REF_CLK == 1) ? "pll_clkin_1_src_coreclkin" : "pll_clkin_1_src_refclkin";

   logic [7:0]        pll_vcoph;              
   logic [1:0]        pll_loaden;             
   logic [1:0]        pll_lvds_clk;           

   logic              pll_dprio_clk;
   logic              pll_dprio_rst_n;
   logic [8:0]        pll_dprio_address;
   logic              pll_dprio_read;
   logic [7:0]        pll_dprio_readdata;
   logic              pll_dprio_write;
   logic [7:0]        pll_dprio_writedata;
   logic              pll_reset_n;
   wire		      pll_lock_w;

   assign phy_clk_phs  = pll_vcoph;
   
   assign phy_clk[0]   = pll_loaden[0];       // C-cnt 1 drives phy_clk 0 through a delay chain (swapping is intentional)
   assign phy_clk[1]   = pll_lvds_clk[0];     // C-cnt 0 drives phy_clk 1 through a delay chain (swapping is intentional)
      
   assign core_clks_from_pll[0] = pll_c_counters[1];
   assign core_clks_from_pll[1] = pll_c_counters[1];

   wire pll_cascade;
   wire pll_core;
   generate
   if (PLL_USE_CORE_REF_CLK) begin
       assign pll_cascade = 1'b0;
       assign pll_core = pll_ref_clk_int;
   end else begin
       assign pll_cascade = pll_ref_clk_int;
       assign pll_core = 1'b0;
   end
   endgenerate
   
   twentynm_iopll # (
   
      ////////////////////////////////////
      //  VCO and Ref clock
      //  fVCO = fRefClk * M * CCnt2 / N
      ////////////////////////////////////
      .reference_clock_frequency                  (pll_input_clock_frequency),
      .vco_frequency                              (pll_vco_clock_frequency),
      
      .pll_vco_ph0_en                             ("true"),                        // vcoph[0] is required to drive phy_clk_phs[0]
      .pll_vco_ph1_en                             ("true"),                        // vcoph[1] is required to drive phy_clk_phs[1]
      .pll_vco_ph2_en                             ("true"),                        // vcoph[2] is required to drive phy_clk_phs[2]
      .pll_vco_ph3_en                             ("true"),                        // vcoph[3] is required to drive phy_clk_phs[3]
      .pll_vco_ph4_en                             ("true"),                        // vcoph[4] is required to drive phy_clk_phs[4]
      .pll_vco_ph5_en                             ("true"),                        // vcoph[5] is required to drive phy_clk_phs[5]
      .pll_vco_ph6_en                             ("true"),                        // vcoph[6] is required to drive phy_clk_phs[6]
      .pll_vco_ph7_en                             ("true"),                        // vcoph[7] is required to drive phy_clk_phs[7]
      
      ////////////////////////////////////
      //  Special clock selects
      ////////////////////////////////////
      .pll_dll_src                                ("pll_dll_src_ph0"),             // Use vcoph[0] as DLL input
      .pll_phyfb_mux                              ("lvds_tx_fclk"),                // PHY clock feedback path selector
      
      ////////////////////////////////////
      //  M Counter
      ////////////////////////////////////
      .pll_m_counter_bypass_en                    (m_cnt_bypass_en),
      .pll_m_counter_even_duty_en                 (m_cnt_odd_div_duty_en),
      .pll_m_counter_high                         (m_cnt_hi_div),
      .pll_m_counter_low                          (m_cnt_lo_div),
      .pll_m_counter_ph_mux_prst                  (0),
      .pll_m_counter_prst                         (1),
      .pll_m_counter_coarse_dly                   ("0 ps"),
      .pll_m_counter_fine_dly                     ("0 ps"),
      .pll_m_counter_in_src                       (pll_m_cnt_in_src),    // Take VCO clock as input to M Counter
        
      ////////////////////////////////////
      //  N Counter (bypassed)
      ////////////////////////////////////
      .pll_n_counter_bypass_en                    (n_cnt_bypass_en),
      .pll_n_counter_odd_div_duty_en              (n_cnt_odd_div_duty_en),
      .pll_n_counter_high                         (n_cnt_hi_div),
      .pll_n_counter_low                          (n_cnt_lo_div),
      .pll_n_counter_coarse_dly                   ("0 ps"),
      .pll_n_counter_fine_dly                     ("0 ps"),
      
      ////////////////////////////////////
      //  C Counter 0 (phy_clk[1])
      ////////////////////////////////////
      .pll_c0_out_en                              (pll_clk_out_en_0),                        // C-counter driving phy_clk[1]
      .output_clock_frequency_0                   (pll_output_clock_frequency_0),
      .phase_shift_0                              (pll_output_phase_shift_0),
      .duty_cycle_0                               (pll_output_duty_cycle_0),
      .pll_c0_extclk_dllout_en                    ("true"),
      .pll_c_counter_0_bypass_en                  (c_cnt_bypass_en0),
      .pll_c_counter_0_even_duty_en               (c_cnt_odd_div_duty_en0),
      .pll_c_counter_0_high                       (c_cnt_hi_div0),
      .pll_c_counter_0_low                        (c_cnt_lo_div0),
      .pll_c_counter_0_ph_mux_prst                (c_cnt_ph_mux_prst0),
      .pll_c_counter_0_prst                       (c_cnt_prst0),      
      .pll_c_counter_0_coarse_dly                 ("0 ps"),
      .pll_c_counter_0_fine_dly                   ("0 ps"),
      .pll_c_counter_0_in_src                     ("c_m_cnt_in_src_ph_mux_clk"),
  
      ////////////////////////////////////
      //  C Counter 1 (phy_clk[0])
      ////////////////////////////////////
      .pll_c1_out_en                              (pll_clk_out_en_1),                        // C-counter driving phy_clk[0]
      .output_clock_frequency_1                   (pll_output_clock_frequency_1),
      .phase_shift_1                              (pll_output_phase_shift_1),
      .duty_cycle_1                               (pll_output_duty_cycle_1),
      .pll_c1_extclk_dllout_en                    ("true"),
      .pll_c_counter_1_bypass_en                  (c_cnt_bypass_en1),
      .pll_c_counter_1_even_duty_en               (c_cnt_odd_div_duty_en1),
      .pll_c_counter_1_high                       (c_cnt_hi_div1),
      .pll_c_counter_1_low                        (c_cnt_lo_div1),
      .pll_c_counter_1_ph_mux_prst                (c_cnt_ph_mux_prst1),
      .pll_c_counter_1_prst                       (c_cnt_prst1),      
      .pll_c_counter_1_coarse_dly                 ("0 ps"),
      .pll_c_counter_1_fine_dly                   ("0 ps"),
      .pll_c_counter_1_in_src                     ("c_m_cnt_in_src_ph_mux_clk"),

      ////////////////////////////////////
      //  C Counter 2 (phy_clk[2])
      ////////////////////////////////////
      .pll_c2_out_en                              (pll_clk_out_en_2),                        // C-counter driving phy_clk[2]
      .output_clock_frequency_2                   (pll_output_clock_frequency_2),
      .phase_shift_2                              (pll_output_phase_shift_2),
      .duty_cycle_2                               (pll_output_duty_cycle_2),
      .pll_c2_extclk_dllout_en                    ("true"),
      .pll_c_counter_2_bypass_en                  (c_cnt_bypass_en2),
      .pll_c_counter_2_even_duty_en               (c_cnt_odd_div_duty_en2),
      .pll_c_counter_2_high                       (c_cnt_hi_div2),
      .pll_c_counter_2_low                        (c_cnt_lo_div2),
      .pll_c_counter_2_ph_mux_prst                (c_cnt_ph_mux_prst2),
      .pll_c_counter_2_prst                       (c_cnt_prst2),
      .pll_c_counter_2_coarse_dly                 ("0 ps"),
      .pll_c_counter_2_fine_dly                   ("0 ps"),
      .pll_c_counter_2_in_src                     ("c_m_cnt_in_src_ph_mux_clk"),
      
      ////////////////////////////////////
      //  C Counter 3 (unused)
      ////////////////////////////////////
      .pll_c3_out_en                              (pll_clk_out_en_3),                           // Not used by EMIF
      .output_clock_frequency_3                   (pll_output_clock_frequency_3),               // Don't care (unused c-counter)
      .phase_shift_3                              (pll_output_phase_shift_3),                   // Don't care (unused c-counter)
      .duty_cycle_3                               (pll_output_duty_cycle_3),                    // Don't care (unused c-counter)
      .pll_c_counter_3_bypass_en                  (c_cnt_bypass_en3),                           // Don't care (unused c-counter)
      .pll_c_counter_3_even_duty_en               (c_cnt_odd_div_duty_en3),                     // Don't care (unused c-counter)
      .pll_c_counter_3_high                       (c_cnt_hi_div3),                              // Don't care (unused c-counter)
      .pll_c_counter_3_low                        (c_cnt_lo_div3),                              // Don't care (unused c-counter)
      .pll_c_counter_3_ph_mux_prst                (c_cnt_ph_mux_prst3),                         // Don't care (unused c-counter)
      .pll_c_counter_3_prst                       (c_cnt_prst3),                                // Don't care (unused c-counter)
      .pll_c_counter_3_coarse_dly                 ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_3_fine_dly                   ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_3_in_src                     ("c_m_cnt_in_src_ph_mux_clk"),                // Don't care (unused c-counter)
      
      ////////////////////////////////////
      //  C Counter 4 (unused)
      ////////////////////////////////////
      .pll_c4_out_en                              (pll_clk_out_en_4),                           // Not used by EMIF
      .output_clock_frequency_4                   (pll_output_clock_frequency_4),               // Don't care (unused c-counter)
      .phase_shift_4                              (pll_output_phase_shift_4),                   // Don't care (unused c-counter)
      .duty_cycle_4                               (pll_output_duty_cycle_4),                    // Don't care (unused c-counter)
      .pll_c_counter_4_bypass_en                  (c_cnt_bypass_en4),                           // Don't care (unused c-counter)
      .pll_c_counter_4_even_duty_en               (c_cnt_odd_div_duty_en4),                     // Don't care (unused c-counter)
      .pll_c_counter_4_high                       (c_cnt_hi_div4),                              // Don't care (unused c-counter)
      .pll_c_counter_4_low                        (c_cnt_lo_div4),                              // Don't care (unused c-counter)
      .pll_c_counter_4_ph_mux_prst                (c_cnt_ph_mux_prst4),                         // Don't care (unused c-counter)
      .pll_c_counter_4_prst                       (c_cnt_prst4),                                // Don't care (unused c-counter)
      .pll_c_counter_4_coarse_dly                 ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_4_fine_dly                   ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_4_in_src                     ("c_m_cnt_in_src_ph_mux_clk"),                // Don't care (unused c-counter)
      
      ////////////////////////////////////
      //  C Counter 5 (unused)
      ////////////////////////////////////
      .pll_c5_out_en                              (pll_clk_out_en_5),                           // Not used by EMIF
      .output_clock_frequency_5                   (pll_output_clock_frequency_5),               // Don't care (unused c-counter)
      .phase_shift_5                              (pll_output_phase_shift_5),                   // Don't care (unused c-counter)
      .duty_cycle_5                               (pll_output_duty_cycle_5),                    // Don't care (unused c-counter)
      .pll_c_counter_5_bypass_en                  (c_cnt_bypass_en5),                           // Don't care (unused c-counter)
      .pll_c_counter_5_even_duty_en               (c_cnt_odd_div_duty_en5),                     // Don't care (unused c-counter)
      .pll_c_counter_5_high                       (c_cnt_hi_div5),                              // Don't care (unused c-counter)
      .pll_c_counter_5_low                        (c_cnt_lo_div5),                              // Don't care (unused c-counter)
      .pll_c_counter_5_ph_mux_prst                (c_cnt_ph_mux_prst5),                         // Don't care (unused c-counter)
      .pll_c_counter_5_prst                       (c_cnt_prst5),                                // Don't care (unused c-counter)
      .pll_c_counter_5_coarse_dly                 ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_5_fine_dly                   ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_5_in_src                     ("c_m_cnt_in_src_ph_mux_clk"),                // Don't care (unused c-counter)
      
      ////////////////////////////////////
      //  C Counter 6 (unused)
      ////////////////////////////////////
      .pll_c6_out_en                              (pll_clk_out_en_6),                           // Not used by EMIF
      .output_clock_frequency_6                   (pll_output_clock_frequency_6),               // Don't care (unused c-counter)
      .phase_shift_6                              (pll_output_phase_shift_6),                   // Don't care (unused c-counter)
      .duty_cycle_6                               (pll_output_duty_cycle_6),                    // Don't care (unused c-counter)
      .pll_c_counter_6_bypass_en                  (c_cnt_bypass_en6),                           // Don't care (unused c-counter)
      .pll_c_counter_6_even_duty_en               (c_cnt_odd_div_duty_en6),                     // Don't care (unused c-counter)
      .pll_c_counter_6_high                       (c_cnt_hi_div6),                              // Don't care (unused c-counter)
      .pll_c_counter_6_low                        (c_cnt_lo_div6),                              // Don't care (unused c-counter)
      .pll_c_counter_6_ph_mux_prst                (c_cnt_ph_mux_prst6),			                // Don't care (unused c-counter)
      .pll_c_counter_6_prst                       (c_cnt_prst6),                                // Don't care (unused c-counter)
      .pll_c_counter_6_coarse_dly                 ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_6_fine_dly                   ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_6_in_src                     ("c_m_cnt_in_src_ph_mux_clk"),                // Don't care (unused c-counter)
      
      ////////////////////////////////////
      //  C Counter 7 (unused)
      ////////////////////////////////////
      .pll_c7_out_en                              (pll_clk_out_en_7),                           // Not used by EMIF
      .output_clock_frequency_7                   (pll_output_clock_frequency_7),               // Don't care (unused c-counter)
      .phase_shift_7                              (pll_output_phase_shift_7),                   // Don't care (unused c-counter)
      .duty_cycle_7                               (pll_output_duty_cycle_7),                    // Don't care (unused c-counter)
      .pll_c_counter_7_bypass_en                  (c_cnt_bypass_en7),                           // Don't care (unused c-counter)
      .pll_c_counter_7_even_duty_en               (c_cnt_odd_div_duty_en7),                     // Don't care (unused c-counter)
      .pll_c_counter_7_high                       (c_cnt_hi_div7),                              // Don't care (unused c-counter)
      .pll_c_counter_7_low                        (c_cnt_lo_div7),                              // Don't care (unused c-counter)
      .pll_c_counter_7_ph_mux_prst                (c_cnt_ph_mux_prst7),                         // Don't care (unused c-counter)
      .pll_c_counter_7_prst                       (c_cnt_prst7),                                // Don't care (unused c-counter)
      .pll_c_counter_7_coarse_dly                 ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_7_fine_dly                   ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_7_in_src                     ("c_m_cnt_in_src_ph_mux_clk"),                // Don't care (unused c-counter)
      
      ////////////////////////////////////
      //  C Counter 8 (unused)
      ////////////////////////////////////
      .pll_c8_out_en                              (pll_clk_out_en_8),                           // Not used by EMIF
      .output_clock_frequency_8                   (pll_output_clock_frequency_8),               // Don't care (unused c-counter)
      .phase_shift_8                              (pll_output_phase_shift_8),                   // Don't care (unused c-counter)
      .duty_cycle_8                               (pll_output_duty_cycle_8),                    // Don't care (unused c-counter)
      .pll_c_counter_8_bypass_en                  (c_cnt_bypass_en8),                           // Don't care (unused c-counter)
      .pll_c_counter_8_even_duty_en               (c_cnt_odd_div_duty_en8),                     // Don't care (unused c-counter)
      .pll_c_counter_8_high                       (c_cnt_hi_div8),                              // Don't care (unused c-counter)
      .pll_c_counter_8_low                        (c_cnt_lo_div8),                              // Don't care (unused c-counter)
      .pll_c_counter_8_ph_mux_prst                (c_cnt_ph_mux_prst8),    		                // Don't care (unused c-counter)
      .pll_c_counter_8_prst                       (c_cnt_prst8),                                // Don't care (unused c-counter)
      .pll_c_counter_8_coarse_dly                 ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_8_fine_dly                   ("0 ps"),                                     // Don't care (unused c-counter)
      .pll_c_counter_8_in_src                     ("c_m_cnt_in_src_ph_mux_clk"),                // Don't care (unused c-counter)
      
      ////////////////////////////////////
      //  Misc Delay Chains
      ////////////////////////////////////
      .pll_ref_buf_dly                            ("0 ps"),
      .pll_cmp_buf_dly                            ("0 ps"),
      
      .pll_dly_0_enable                           ("true"),                        // Controls whether delay chain on phyclk[0] is enabled, must be true for phyclk to toggle
      .pll_dly_1_enable                           ("true"),                        // Controls whether delay chain on phyclk[1] is enabled, must be true for phyclk to toggle
      .pll_dly_2_enable                           ("true"),                        // Controls whether delay chain on phyclk[2] is enabled
      .pll_dly_3_enable                           ("true"),                        // Controls whether delay chain on phyclk[3] is enabled
      
      .pll_coarse_dly_0                           ("0 ps"),                        // Fine delay chain to skew phyclk[0]
      .pll_coarse_dly_1                           ("0 ps"),                        // Fine delay chain to skew phyclk[1]
      .pll_coarse_dly_2                           ("0 ps"),                        // Fine delay chain to skew phyclk[2]
      .pll_coarse_dly_3                           ("0 ps"),                        // Fine delay chain to skew phyclk[3]
      
      .pll_fine_dly_0                             ("0 ps"),                        // Fine delay chain to skew phyclk[0]
      .pll_fine_dly_1                             ("0 ps"),                        // Fine delay chain to skew phyclk[1]
      .pll_fine_dly_2                             ("0 ps"),                        // Fine delay chain to skew phyclk[2]
      .pll_fine_dly_3                             ("0 ps"),                        // Fine delay chain to skew phyclk[3]
      
      ////////////////////////////////////
      //  Misc PLL Modes and Features
      ////////////////////////////////////
      .pll_enable                                 ("true"),                        // Enable PLL
      .pll_powerdown_mode                         ("false"),                       // PLL power down mode
      .is_cascaded_pll                            ("false"),                       // EMIF assumes non-cascaded PLL for optimal jitter
      
      .compensation_mode                          ("emif"),                        // EMIF doesn't need PLL compensation. Alignment of core clocks and PHY clocks is handled by CPA
      .pll_fbclk_mux_1                            (pll_fbclk_mux_1),               // Setting required by DIRECT compensation
      .pll_fbclk_mux_2                            (pll_fbclk_mux_2),               // Setting required by DIRECT compensation
      
      .pll_extclk_0_enable                        ("false"),                       // EMIF PLL does not need to drive output clock pin
      .pll_extclk_1_enable                        ("false"),                       // EMIF PLL does not need to drive output clock pin
      
      .pll_clkin_0_src                            (pll_clkin_0_src),               // 
      .pll_clkin_1_src                            (pll_clkin_1_src),               // 
      .pll_sw_refclk_src                          ("pll_sw_refclk_src_clk_0"),     // 
      .pll_auto_clk_sw_en                         ("false"),                       // EMIF PLL does not use the automatic clock switch-over feature
      .pll_clk_loss_sw_en                         ("false"),                       // EMIF PLL does not use the automatic clock switch-over feature
      .pll_manu_clk_sw_en                         ("false"),                       // EMIF PLL does not use the automatic clock switch-over feature
      .pll_ctrl_override_setting                  ("true"),
      .pll_cp_compensation                        ("false"),
      
      .bw_sel                                     (pll_bw_sel),                    // Bandwidth select
      .pll_bwctrl                                 (pll_bw_ctrl),                   // Bandwidth control
      .pll_cp_current_setting                     (pll_cp_setting),                // Charge pump setting
      .pll_unlock_fltr_cfg                        (2),
      
      .pll_dprio_broadcast_en                     ("false"),
      .pll_dprio_cvp_inter_sel                    ("false"),
      .pll_dprio_force_inter_sel                  ("false"),
      .pll_dprio_power_iso_en                     ("false")
   ) pll_inst (

      .refclk                                     (4'b0000),
      .rst_n                                      (pll_reset_n),
      .loaden                                     (pll_loaden),
      .lvds_clk                                   (pll_lvds_clk),
      .vcoph                                      (pll_vcoph),
      .fblvds_in                                  (phy_fb_clk_to_pll),
      .fblvds_out                                 (phy_fb_clk_to_tile),
      .dll_output                                 (pll_dll_clk),
      .lock                                       (pll_lock_w),
      .outclk                                     (pll_c_counters),
      .fbclk_in                                   (1'b0),
      .fbclk_out                                  (),
      .zdb_in                                     (1'b0),
      .phase_done                                 (),
      .pll_cascade_in                             (pll_cascade),
      .pll_cascade_out                            (),
      .extclk_output                              (),
      .core_refclk                                (pll_core),
      .dps_rst_n                                  (pll_reset_n),
      .mdio_dis                                   (1'b0),
      .pfden                                      (1'b1),
      .phase_en                                   (1'b0),
      .pma_csr_test_dis                           (1'b1),
      .up_dn                                      (1'b0),
      .extswitch                                  (1'b0),
      .clken                                      (2'b0),                            // Don't care (extclk)
      .cnt_sel                                    (4'b0),
      .num_phase_shifts                           (3'b0),
      .clk0_bad                                   (),
      .clk1_bad                                   (),
      .clksel                                     (),
      .csr_clk                                    (1'b1),
      .csr_en                                     (1'b1),
      .csr_in                                     (1'b1),
      .csr_out                                    (),
      .dprio_clk                                  (pll_dprio_clk),
      .dprio_rst_n                                (pll_dprio_rst_n),
      .dprio_address                              (pll_dprio_address),
      .scan_mode_n                                (1'b1),
      .scan_shift_n                               (1'b1),
      .write                                      (pll_dprio_write),
      .read                                       (pll_dprio_read),
      .readdata                                   (pll_dprio_readdata),
      .writedata                                  (pll_dprio_writedata),
      .extclk_dft                                 (),
      .block_select                               (),
      .lf_reset                                   (),
      .pipeline_global_en_n                       (),
      .pll_pd                                     (),
      .vcop_en                                    (),
      .user_mode                                  (1'b1)
   );
   
   iopll_bootstrap
   #(
      `ifdef ALTERA_A10_IOPLL_BOOTSTRAP
         .PLL_CTR_RESYNC(1)
      `else
         .PLL_CTR_RESYNC(0)
      `endif
   )
   inst_iopll_bootstrap
   (
      .u_dprio_clk(1'b0),
      .u_dprio_rst_n(global_reset_n_int),
      .u_dprio_address({9{1'b0}}),
      .u_dprio_read(1'b0),
      .u_dprio_write(1'b0),
      .u_dprio_writedata({8{1'b0}}),
      .u_rst_n(global_reset_n_int),
      .pll_locked(pll_lock_w),
      .pll_dprio_readdata(pll_dprio_readdata),

      .pll_dprio_clk(pll_dprio_clk),
      .pll_dprio_rst_n(pll_dprio_rst_n),
      .pll_dprio_address(pll_dprio_address),
      .pll_dprio_read(pll_dprio_read),
      .pll_dprio_write(pll_dprio_write),
      .pll_dprio_writedata(pll_dprio_writedata),
      .pll_rst_n(pll_reset_n),
      .u_dprio_readdata(),
      .u_locked(pll_lock)
   );

endmodule
