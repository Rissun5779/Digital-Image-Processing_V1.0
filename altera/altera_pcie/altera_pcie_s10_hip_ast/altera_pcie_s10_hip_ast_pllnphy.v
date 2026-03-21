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


// (C) 2001-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings
// altera message_level Level1
// altera message_off 10034 10035 10036 10037 10230 10240 10030

module altera_pcie_s10_hip_ast_pllnphy # (
   parameter protocol_version = "Gen 1",
   parameter USED_LANES            = 1,
   parameter TOTAL_LANES           = 8,
   parameter export_phy_input_to_top_level_hwtcl = 0,
   parameter reconfig_address_width_integer_hwtcl = 11
   ) (
    //Native PHY Ports


  input  wire [TOTAL_LANES-1:0]       tx_analogreset                   ,
  input  wire [TOTAL_LANES-1:0]       tx_digitalreset                  ,
  input  wire [TOTAL_LANES-1:0]       rx_analogreset                   ,
  input  wire [TOTAL_LANES-1:0]       rx_digitalreset                  ,
  input  wire [TOTAL_LANES-1:0]       tx_aibreset                      ,
  input  wire [TOTAL_LANES-1:0]       rx_aibreset                      ,
  output wire [TOTAL_LANES-1:0]       tx_transfer_ready                ,
  output wire [TOTAL_LANES-1:0]       rx_transfer_ready                ,
  output wire [TOTAL_LANES-1:0]       tx_cal_busy                      ,
  output wire [TOTAL_LANES-1:0]       rx_cal_busy                      ,

  input  wire                         rx_cdr_refclk0                   ,
  output wire [TOTAL_LANES-1:0]       tx_serial_data                   ,
  input  wire [TOTAL_LANES-1:0]       rx_serial_data                   ,

  output wire [TOTAL_LANES-1:0]       rx_is_lockedtoref                ,
  output wire [TOTAL_LANES-1:0]       rx_is_lockedtodata               ,

  input  wire [TOTAL_LANES*80-1:0]    tx_parallel_data                 ,
  output wire [TOTAL_LANES*80-1:0]    rx_parallel_data                 ,

  output wire [TOTAL_LANES-1:0]       tx_clkout                        ,
  output wire [TOTAL_LANES-1:0]       tx_clkout2                       ,
  output wire [TOTAL_LANES-1:0]       rx_clkout                        ,

  input  wire [TOTAL_LANES*3-1:0]     pipe_rx_eidleinfersel            , //??
  output wire [TOTAL_LANES-1:0]       pipe_rx_elecidle                 ,

  input  wire [TOTAL_LANES*101-1:0]   hip_aib_data_in                  ,
  output wire [TOTAL_LANES*132-1:0]   hip_aib_data_out                 ,
  input  wire [TOTAL_LANES*92-1:0]    hip_pcs_data_in                  ,
  output wire [TOTAL_LANES*62-1:0]    hip_pcs_data_out                 ,
  input  wire [TOTAL_LANES*4-1:0]     hip_aib_fsr_in                   ,
  input  wire [TOTAL_LANES*40-1:0]    hip_aib_ssr_in                   ,
  output wire [TOTAL_LANES*4-1:0]     hip_aib_fsr_out                  ,
  output wire [TOTAL_LANES*8-1:0]     hip_aib_ssr_out                  ,
  output wire [TOTAL_LANES-1:0]       chnl_cal_done                    ,   //hip_cal_done


  //Reconfig Interface
   input  wire                        reconfig_clk                     ,
   input  wire                        reconfig_reset                   ,
   input  wire                        reconfig_write                   ,
   input  wire                        reconfig_read                    ,
   input  wire [13:0]                 reconfig_address                 ,
   input  wire [31:0]                 reconfig_writedata               ,
   output wire [31:0]                 reconfig_readdata                ,
   output wire                        reconfig_waitrequest             ,
   //FPLL Reconfig Interface
   input  wire                        reconfig_pll0_clk                ,     //     reconfig_clk.clk
   input  wire                        reconfig_pll0_reset              ,     //     reconfig_reset.reset
   input  wire                        reconfig_pll0_write              ,     //     reconfig_avmm.write
   input  wire                        reconfig_pll0_read               ,     //                 .read
   input  wire [10:0]                 reconfig_pll0_address            ,     //                 .address
   input  wire [31:0]                 reconfig_pll0_writedata          ,     //                 .writedata
   output wire [31:0]                 reconfig_pll0_readdata           ,     //                 .readdata
   output wire                        reconfig_pll0_waitrequest        ,     //                 .waitrequest
   //LC PLL Reconfig Interface
   input  wire                        reconfig_pll1_clk                ,     //     reconfig_clk.clk
   input  wire                        reconfig_pll1_reset              ,     //     reconfig_reset.reset
   input  wire                        reconfig_pll1_write              ,     //     reconfig_avmm.write
   input  wire                        reconfig_pll1_read               ,     //                 .read
   input  wire [10:0]                 reconfig_pll1_address            ,     //                 .address
   input  wire [31:0]                 reconfig_pll1_writedata          ,     //                 .writedata
   output wire [31:0]                 reconfig_pll1_readdata           ,     //                 .readdata
   output wire                        reconfig_pll1_waitrequest        ,     //                 .waitrequest

   //LC PLL ports
   input  wire                        pll_powerdown_lcpll              ,     //    pll_powerdown.pll_powerdown   //TODO for Gen3 with LC n FF PLL
   output wire                        pll_locked_lcpll                 ,     //    pll_locked.pll_locked
   output wire                        pll_locked_lcpll_to_pld          ,     //    pll_locked.pll_locked
   output wire                        pll_cal_done_lcpll               ,     //    pll_cal_done.hip_cal_done
   //FPLL ports
   input  wire                        pll_powerdown_fpll               ,     //    pll_powerdown.pll_powerdown   //TODO for Gen3 with LC n FF PLL
   output wire                        pll_locked_fpll                  ,     //    pll_locked.pll_locked
   output wire                        pll_locked_fpll_to_pld           ,     //    pll_locked.pll_locked
   output wire                        pll_cal_done_fpll                ,     //    pll_cal_done.hip_cal_done
   // Master CGB reset port
   input  wire                        mcgb_rst                         ,     //    reset to the MST CGB
   input  wire                        pll_refclk0                           //    pll_refclk0.clk

//   input  wire                       pipe_hclk_in                     ,
//   output wire                       pll_pcie_clk

   );


localparam [255:0] ONES  = 256'HFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
localparam [255:0] ZEROS = 256'H0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;

// Rate Switching from the master channel
wire [1:0]                  pipe_sw_done                     ;
wire [1:0]                  pipe_sw                          ;

wire                        pll_pcie_clk                         ;
wire                        pipe_hclk_in_int                        ;

wire tx_serial_clk0       ;
wire tx_serial_clk1       ;
wire [5:0] tx_bonding_clocks ;
wire pll_cal_busy_fpll    ;
wire pll_cal_busy_lcpll  ;




assign pipe_hclk_in_int =  pll_pcie_clk ;


///////////////////////////////////////////////////////////
///HIP NATIVE PHY
//////////////////////////////////////////////////////////

generate

   if (protocol_version == "Gen 1" ) begin
      if (USED_LANES ==1 ) begin : g_phy_g1x1

         phy_g1x1 phy_g1x1 (
            .pipe_sw_done                         (  2'h0                          ),   //          input  wire [1:0]              pipe_sw_done.pipe_sw_done
            .pipe_sw                              (                                ),   //          output wire [1:0]                   pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                ),   //              input  wire [7:0]            tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset               ),   //              input  wire [7:0]           tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                ),   //              input  wire [7:0]            rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset               ),   //              input  wire [7:0]           rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                   ),   //              input  wire [7:0]               tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                   ),   //              input  wire [7:0]               rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready             ),   //              output wire [7:0]         tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready             ),   //              output wire [7:0]         rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                   ),   //              output wire [7:0]               tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                   ),   //              output wire [7:0]               rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  48'h0                         ),   //               input  wire [47:0]        tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                ),   //              input  wire                  rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                ),   //              output wire [7:0]            tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                ),   //              input  wire [7:0]            rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref             ),   //              output wire [7:0]         rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata            ),   //              output wire [7:0]        rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data              ),   //              output wire [639:0]        rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data              ),   //              input  wire [639:0]        tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                     ),   //              output wire [7:0]                 tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                    ),   //              output wire [7:0]                tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                     ),   //              output wire [7:0]                 rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int              ),   //              input  wire                    pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                ),   //                input  wire                 tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                          ),   //              input  wire                 tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel         ),   //           input  wire [23:0]    pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle              ),   //              output wire [7:0]          pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in               ),   //              input  wire [807:0]         hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out              ),   //              output wire [1055:0]       hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in               ),   //              input  wire [735:0]         hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out              ),   //              output wire [495:0]        hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                ),   //              input  wire [31:0]           hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                ),   //              input  wire [319:0]          hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out               ),   //              output wire [31:0]          hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out               ),   //              output wire [63:0]          hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                 )    //              output wire [7:0]              hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==2 ) begin : g_phy_g1x2
          phy_g1x2 phy_g1x2 (
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==4 ) begin : g_phy_g1x4
          phy_g1x4 phy_g1x4(
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==8 ) begin : g_phy_g1x8
          phy_g1x8 phy_g1x8 (
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==16 ) begin : g_phy_g1x16
          phy_g1x16 phy_g1x16 (
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
   end
   else if (protocol_version == "Gen 2" ) begin
      if (USED_LANES ==1 ) begin : g_phy_g2x1

         phy_g2x1 phy_g2x1 (
            .pipe_sw_done                         (  2'h0                          ),   //              input  wire [1:0]              pipe_sw_done.pipe_sw_done
            .pipe_sw                              (                                ),   //              output wire [1:0]                   pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                ),   //              input  wire [7:0]            tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset               ),   //              input  wire [7:0]           tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                ),   //              input  wire [7:0]            rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset               ),   //              input  wire [7:0]           rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                   ),   //              input  wire [7:0]               tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                   ),   //              input  wire [7:0]               rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready             ),   //              output wire [7:0]         tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready             ),   //              output wire [7:0]         rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                   ),   //              output wire [7:0]               tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                   ),   //              output wire [7:0]               rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  48'h0                         ),   //              input  wire [47:0]        tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                ),   //              input  wire                  rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                ),   //              output wire [7:0]            tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                ),   //              input  wire [7:0]            rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref             ),   //              output wire [7:0]         rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata            ),   //              output wire [7:0]        rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data              ),   //              output wire [639:0]        rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data              ),   //              input  wire [639:0]        tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                     ),   //              output wire [7:0]                 tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                    ),   //              output wire [7:0]                tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                     ),   //              output wire [7:0]                 rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int              ),   //              input  wire                    pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                ),   //              input  wire                 tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                          ),   //              input  wire                 tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel         ),   //              input  wire [23:0]    pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle              ),   //              output wire [7:0]          pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in               ),   //              input  wire [807:0]         hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out              ),   //              output wire [1055:0]       hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in               ),   //              input  wire [735:0]         hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out              ),   //              output wire [495:0]        hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                ),   //              input  wire [31:0]           hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                ),   //              input  wire [319:0]          hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out               ),   //              output wire [31:0]          hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out               ),   //              output wire [63:0]          hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                 )    //              output wire [7:0]              hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==2 ) begin : g_phy_g2x2
          phy_g2x2 phy_g2x2 (
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==4 ) begin : g_phy_g2x4
          phy_g2x4 phy_g2x4(
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==8 ) begin : g_phy_g2x8
          phy_g2x8 phy_g2x8(
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==16 ) begin : g_phy_g2x16
          phy_g2x16 phy_g2x16(
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
   end
   else if (protocol_version == "Gen 3" ) begin
      if (USED_LANES ==1 ) begin : g_phy_g3x1

         phy_g3x1 phy_g3x1 (
            .pipe_sw_done                         (  2'h0                          ),   //          input  wire [1:0]              pipe_sw_done.pipe_sw_done
            .pipe_sw                              (                                ),   //          output wire [1:0]                   pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                ),   //              input  wire [7:0]            tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset               ),   //              input  wire [7:0]           tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                ),   //              input  wire [7:0]            rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset               ),   //              input  wire [7:0]           rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                   ),   //              input  wire [7:0]               tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                   ),   //              input  wire [7:0]               rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready             ),   //              output wire [7:0]         tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready             ),   //              output wire [7:0]         rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                   ),   //              output wire [7:0]               tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                   ),   //              output wire [7:0]               rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  48'h0                         ),   //               input  wire [47:0]        tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                ),   //              input  wire                  rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                ),   //              output wire [7:0]            tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                ),   //              input  wire [7:0]            rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref             ),   //              output wire [7:0]         rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata            ),   //              output wire [7:0]        rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data              ),   //              output wire [639:0]        rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data              ),   //              input  wire [639:0]        tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                     ),   //              output wire [7:0]                 tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                    ),   //              output wire [7:0]                tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                     ),   //              output wire [7:0]                 rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int              ),   //              input  wire                    pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                ),   //                input  wire                 tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  tx_serial_clk1                ),   //              input  wire                 tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel         ),   //           input  wire [23:0]    pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle              ),   //              output wire [7:0]          pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in               ),   //              input  wire [807:0]         hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out              ),   //              output wire [1055:0]       hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in               ),   //              input  wire [735:0]         hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out              ),   //              output wire [495:0]        hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                ),   //              input  wire [31:0]           hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                ),   //              input  wire [319:0]          hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out               ),   //              output wire [31:0]          hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out               ),   //              output wire [63:0]          hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                 )    //              output wire [7:0]              hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==2 ) begin : g_phy_g3x2
          phy_g3x2 phy_g3x2 (
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==4 ) begin : g_phy_g3x4
          phy_g3x4 phy_g3x4(
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==8 ) begin : g_phy_g3x8
          phy_g3x8 phy_g3x8(
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
      else if (USED_LANES ==16 ) begin : g_phy_g3x16
          phy_g3x16 phy_g3x16(
            .pipe_sw_done                         (  pipe_sw_done                   ), //               input  wire [1:0]            pipe_sw_done.pipe_sw_done
            .pipe_sw                              (  pipe_sw                        ), //               output wire [1:0]                 pipe_sw.pipe_sw
            .tx_analogreset                       (  tx_analogreset                 ), //               input  wire [7:0]          tx_analogreset.tx_analogreset
            .tx_digitalreset                      (  tx_digitalreset                ), //               input  wire [7:0]         tx_digitalreset.tx_digitalreset
            .rx_analogreset                       (  rx_analogreset                 ), //               input  wire [7:0]          rx_analogreset.rx_analogreset
            .rx_digitalreset                      (  rx_digitalreset                ), //               input  wire [7:0]         rx_digitalreset.rx_digitalreset
            .tx_aibreset                          (  tx_aibreset                    ), //               input  wire [7:0]             tx_aibreset.tx_aibreset
            .rx_aibreset                          (  rx_aibreset                    ), //               input  wire [7:0]             rx_aibreset.rx_aibreset
            .tx_transfer_ready                    (  tx_transfer_ready              ), //               output wire [7:0]       tx_transfer_ready.tx_transfer_ready
            .rx_transfer_ready                    (  rx_transfer_ready              ), //               output wire [7:0]       rx_transfer_ready.rx_transfer_ready
            .tx_cal_busy                          (  tx_cal_busy                    ), //               output wire [7:0]             tx_cal_busy.tx_cal_busy
            .rx_cal_busy                          (  rx_cal_busy                    ), //               output wire [7:0]             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks                    (  tx_bonding_clocks              ), //               input  wire [47:0]      tx_bonding_clocks.tx_bonding_clocks
            .rx_cdr_refclk0                       (  rx_cdr_refclk0                 ), //               input  wire                rx_cdr_refclk0.rx_cdr_refclk0
            .tx_serial_data                       (  tx_serial_data                 ), //               output wire [7:0]          tx_serial_data.tx_serial_data
            .rx_serial_data                       (  rx_serial_data                 ), //               input  wire [7:0]          rx_serial_data.rx_serial_data
            .rx_is_lockedtoref                    (  rx_is_lockedtoref              ), //               output wire [7:0]       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata                   (  rx_is_lockedtodata             ), //               output wire [7:0]      rx_is_lockedtodata.rx_is_lockedtodata
            .rx_parallel_data                     (  rx_parallel_data               ), //               output wire [639:0]      rx_parallel_data.rx_parallel_data
            .tx_parallel_data                     (  tx_parallel_data               ), //               input  wire [639:0]      tx_parallel_data.tx_parallel_data
            .tx_clkout                            (  tx_clkout                      ), //               output wire [7:0]               tx_clkout.tx_clkout
            .tx_clkout2                           (  tx_clkout2                     ), //               output wire [7:0]              tx_clkout2.tx_clkout2
            .rx_clkout                            (  rx_clkout                      ), //               output wire [7:0]               rx_clkout.rx_clkout
            .pipe_hclk_in                         (  pipe_hclk_in_int               ), //               input  wire                  pipe_hclk_in.pipe_hclk_in
            .tx_serial_clk0                       (  tx_serial_clk0                 ), //               input  wire                tx_serial_clk0.tx_serial_clk0
            .tx_serial_clk1                       (  1'b0                           ), //               input  wire                tx_serial_clk1.tx_serial_clk1
            .pipe_rx_eidleinfersel                (  pipe_rx_eidleinfersel          ), //               input  wire [23:0]  pipe_rx_eidleinfersel.pipe_rx_eidleinfersel
            .pipe_rx_elecidle                     (  pipe_rx_elecidle               ), //               output wire [7:0]        pipe_rx_elecidle.pipe_rx_elecidle
            .hip_aib_data_in                      (  hip_aib_data_in                ), //               input  wire [807:0]       hip_aib_data_in.hip_aib_data_in
            .hip_aib_data_out                     (  hip_aib_data_out               ), //               output wire [1055:0]     hip_aib_data_out.hip_aib_data_out
            .hip_pcs_data_in                      (  hip_pcs_data_in                ), //               input  wire [735:0]       hip_pcs_data_in.hip_pcs_data_in
            .hip_pcs_data_out                     (  hip_pcs_data_out               ), //               output wire [495:0]      hip_pcs_data_out.hip_pcs_data_out
            .hip_aib_fsr_in                       (  hip_aib_fsr_in                 ), //               input  wire [31:0]         hip_aib_fsr_in.hip_aib_fsr_in
            .hip_aib_ssr_in                       (  hip_aib_ssr_in                 ), //               input  wire [319:0]        hip_aib_ssr_in.hip_aib_ssr_in
            .hip_aib_fsr_out                      (  hip_aib_fsr_out                ), //               output wire [31:0]        hip_aib_fsr_out.hip_aib_fsr_out
            .hip_aib_ssr_out                      (  hip_aib_ssr_out                ), //               output wire [63:0]        hip_aib_ssr_out.hip_aib_ssr_out
            .hip_cal_done                         (  chnl_cal_done                  )  //               output wire [7:0]            hip_cal_done.hip_cal_done
        );
      end
   end

endgenerate


/////////////////////////////////////////////
///////////   ATX PLL and FPLL   ///////////
////////////////////////////////////////////

generate

   if (protocol_version == "Gen 1" || protocol_version == "Gen 2"  ) begin
      if (USED_LANES ==1 ) begin : g_pll_g1g2x1
         fpll_g1g2x1 fpll_g1g2x1 (
            .pll_powerdown                (  pll_powerdown_fpll              )   ,           //    input  wire             pll_powerdown.pll_powerdown
            .pll_refclk0                  (  pll_refclk0                     )   ,           //    input  wire               pll_refclk0.clk
            .tx_serial_clk                (  tx_serial_clk0                  )   ,           //    output wire             tx_serial_clk.clk
            .pll_locked_hip               (  pll_locked_fpll                 )   ,           //    output wire                pll_locked.pll_locked
            .pll_locked                   (  pll_locked_fpll_to_pld          )   ,           //    output wire                pll_locked.pll_locked
            .pll_pcie_clk                 (  pll_pcie_clk                    )   ,           //    output wire              pll_pcie_clk.pll_pcie_clk
            .pll_cal_busy                 (  pll_cal_busy_fpll               )   ,           //    output wire              pll_cal_busy.pll_cal_busy
            .hip_cal_done                 (  pll_cal_done_fpll               )               //    output wire              hip_cal_done.hip_cal_done
         );
      end
      else begin : g_pll_g1g2xn
         fpll_g1g2xn fpll_g1g2xn (
            .pll_powerdown                (  pll_powerdown_fpll              )   ,           //    input  wire             pll_powerdown.pll_powerdown
            .pll_refclk0                  (  pll_refclk0                     )   ,           //    input  wire               pll_refclk0.clk
            .tx_serial_clk                (                                  )   ,           //    output wire             tx_serial_clk.clk
            .pll_locked_hip               (  pll_locked_fpll                 )   ,           //    output wire                pll_locked.pll_locked
            .pll_locked                   (  pll_locked_fpll_to_pld          )   ,           //    output wire                pll_locked.pll_locked
            .pll_pcie_clk                 (  pll_pcie_clk                    )   ,           //    output wire              pll_pcie_clk.pll_pcie_clk
            .mcgb_rst                     (  mcgb_rst                        )   ,           //    input  wire                  mcgb_rst.mcgb_rst
            .tx_bonding_clocks            (  tx_bonding_clocks               )   ,           //    output wire [5:0]   tx_bonding_clocks.clk
            .pcie_sw                      (  pipe_sw                         )   ,           //    input  wire [1:0]             pcie_sw.pcie_sw
            .pcie_sw_done                 (  pipe_sw_done                    )   ,           //    output wire [1:0]        pcie_sw_done.pcie_sw_done
            .mcgb_hip_cal_done            (  pll_cal_done_fpll               )   ,           //    output wire         mcgb_hip_cal_done.hip_cal_done
            .pll_cal_busy                 (  pll_cal_busy_fpll               )   ,           //    output wire              pll_cal_busy.pll_cal_busy
            .hip_cal_done                 (                                  )               //    output wire              hip_cal_done.hip_cal_done
         ) ;
      end
   end
   else begin :g_pll_g3
      //FPLL
      fpll_g3 fpll_g3 (
         .pll_powerdown                   (  pll_powerdown_fpll              )   ,            //    input  wire             pll_powerdown.pll_powerdown
         .pll_refclk0                     (  pll_refclk0                     )   ,            //    input  wire               pll_refclk0.clk
         .tx_serial_clk                   (  tx_serial_clk0                  )   ,            //    output wire             tx_serial_clk.clk
         .pll_locked_hip                  (  pll_locked_fpll                 )   ,            //    output wire                pll_locked.pll_locked
         .pll_locked                      (  pll_locked_fpll_to_pld          )   ,            //    output wire                pll_locked.pll_locked
         .pll_cal_busy                    (  pll_cal_busy_fpll               )   ,            //    output wire              pll_cal_busy.pll_cal_busy
         .hip_cal_done                    (  pll_cal_done_fpll               )                //    output wire              hip_cal_done.hip_cal_done
      );

      //ATX PLL
      if (USED_LANES ==1 ) begin : g_pll_g3x1
          lcpll_g3x1 lcpll_g3x1 (

             .pll_powerdown               (  pll_powerdown_lcpll             )   ,            //    input  wire             pll_powerdown.pll_powerdown
             .pll_refclk0                 (  pll_refclk0                     )   ,            //    input  wire               pll_refclk0.clk
             .tx_serial_clk               (  tx_serial_clk1                  )   ,            //    output wire             tx_serial_clk.clk
             .pll_locked_hip              (  pll_locked_lcpll                )   ,            //    output wire                pll_locked.pll_locked
             .pll_locked                  (  pll_locked_lcpll_to_pld         )   ,            //    output wire                pll_locked.pll_locked
             .pll_pcie_clk                (  pll_pcie_clk                    )   ,              //    output wire              pll_pcie_clk.pll_pcie_clk
             .pll_cal_busy                (  pll_cal_busy_lcpll              )   ,            //    output wire              pll_cal_busy.pll_cal_busy
             .hip_cal_done                (  pll_cal_done_lcpll              )   ,            //    output wire              hip_cal_done.hip_cal_done
             .mcgb_hip_cal_done           (                                  )                //    output wire         mcgb_hip_cal_done.hip_cal_done
           );
      end
      else begin : g_pll_g3xn
         lcpll_g3xn lcpll_g3xn (
            .pll_powerdown                (  pll_powerdown_lcpll             )   ,            //    input  wire            pll_powerdown.pll_powerdown
            .pll_refclk0                  (  pll_refclk0                     )   ,            //    input  wire              pll_refclk0.clk
            .pll_locked_hip               (  pll_locked_lcpll                )   ,            //    output wire               pll_locked.pll_locked
            .pll_locked                   (  pll_locked_lcpll_to_pld         )   ,            //    output wire               pll_locked.pll_locked
            .pll_pcie_clk                 (  pll_pcie_clk                    )   ,            //    output wire              pll_pcie_clk.pll_pcie_clk
            .mcgb_rst                     (  mcgb_rst                        )   ,            //    input  wire                 mcgb_rst.mcgb_rst
            .mcgb_aux_clk0                (  tx_serial_clk0                  )   ,            //    input  wire            mcgb_aux_clk0.tx_serial_clk
            .tx_bonding_clocks            (  tx_bonding_clocks               )   ,            //    output wire [5:0]  tx_bonding_clocks.clk
            .pcie_sw                      (  pipe_sw                         )   ,            //    input  wire [1:0]            pcie_sw.pcie_sw
            .pcie_sw_done                 (  pipe_sw_done                    )   ,            //    output wire [1:0]       pcie_sw_done.pcie_sw_done
            .pll_cal_busy                 (  pll_cal_busy_lcpll              )   ,            //    output wire             pll_cal_busy.pll_cal_busy
            .hip_cal_done                 (  pll_cal_done_lcpll              )   ,            //    output wire             hip_cal_done.hip_cal_done
            .mcgb_hip_cal_done            (                                  )                //    output wire        mcgb_hip_cal_done.hip_cal_done
          );

      end
   end

endgenerate

endmodule

