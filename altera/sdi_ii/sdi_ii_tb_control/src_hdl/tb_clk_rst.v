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


`timescale 100 fs / 100 fs

module tb_clk_rst
# (
    // module parameter port list
   parameter VIDEO_STANDARD = "tr",
   parameter DIRECTION      = "rx",
   parameter RX_EN_A2B_CONV = 0,
   parameter RX_EN_B2A_CONV = 0,
   parameter TX_HD_2X_OVERSAMPLING = 0,
   parameter HD_FREQ = "148.5",
   parameter TEST_RXSAMPLE_CHK = 0,
   parameter DEVKIT_A10_CDR_270M = 0
)
(
    // port list
    tx_ref_clk     ,
    rx_coreclk     ,
    rx_cdr_refclk  ,
    ref_clk_smpte372 ,
    tx_chk_refclk   ,
    reconfig_clk,
    clk_fpga    ,

    tx_std
);

    //--------------------------------------------------------------------------
    // local parameter declarations
    //--------------------------------------------------------------------------
    localparam CLK297_PERIOD         = 33670;
    localparam CLK296_99_PERIOD      = 33671;
    localparam CLK270_PERIOD         = 37037;
    localparam CLK148_PERIOD         = 67340;
    localparam CLK148_35_PERIOD      = 67400;    //to create 148.35MHz clock for txpll sel
    localparam CLK148_49_PERIOD      = 67344;    //to create 148.49 MHz clock for rx_sample test
    localparam CLK75_PERIOD          = 134680;
    localparam CLK67_PERIOD          = 148148;      
    localparam CLK27_PERIOD          = 370370;
    localparam CLK100_PERIOD         = 100000;

    //--------------------------------------------------------------------------
    // port declaration
    //--------------------------------------------------------------------------
    output                                          tx_ref_clk              ;
    output                                          rx_coreclk                 ;
    output                                          rx_cdr_refclk           ;
    output                                          ref_clk_smpte372        ;
    output                                          tx_chk_refclk           ;
    output                                          reconfig_clk            ;
    output                                          clk_fpga                ;
    input   [2:0]                                   tx_std                  ;
    
    //--------------------------------------------------------------------------
    // signal declaration
    //--------------------------------------------------------------------------
    reg         clk_297     ;
    reg         clk_296_99  ;
    reg         clk_270     ;
    reg         clk_148     ;
    reg         clk_148_35  ;
    reg         clk_75      ;
    reg         clk_67      ;
    reg         clk_27      ;
    reg         clk_100     ;
    reg         clk_mux_out ;
    reg         clk_148_49  ;

    //--------------------------------------------------------------------------
    // [START] comment
    //--------------------------------------------------------------------------
    initial begin
        clk_297 = 0;
        forever #(CLK297_PERIOD/2) clk_297 = ~clk_297;
    end
    initial begin
        clk_296_99 = 0;
        forever #(CLK296_99_PERIOD/2) clk_296_99 = ~clk_296_99;
    end
    initial begin
        clk_270 = 0;
        forever #(CLK270_PERIOD/2) clk_270 = ~clk_270;
    end
    initial begin
        clk_148 = 0;
        forever #(CLK148_PERIOD/2) clk_148 = ~clk_148;
    end
    initial begin
        clk_148_49 = 0;
        forever #(CLK148_49_PERIOD/2) clk_148_49 = ~clk_148_49;
    end
    initial begin
        clk_75 = 0;
        forever #(CLK75_PERIOD/2) clk_75 = ~clk_75;
    end
    initial begin
        clk_67 = 0;
        forever #(CLK67_PERIOD/2) clk_67 = ~clk_67;
    end
    initial begin
        clk_27 = 0;
        forever #(CLK27_PERIOD/2) clk_27 = ~clk_27;
    end
    initial begin
        clk_100 = 0;
        forever #(CLK100_PERIOD/2) clk_100 = ~clk_100;
    end
    initial begin
        clk_148_35 = 0;
        forever #(CLK148_35_PERIOD/2) clk_148_35 = ~clk_148_35;   //148.35
    end
    //--------------------------------------------------------------------------
    // [END] comment
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    // [START] comment
    //--------------------------------------------------------------------------

    always @ (*) 
    begin
        case (tx_std)
           3'b001 : clk_mux_out = clk_75; 
           3'b000 : clk_mux_out = clk_27;
           default : clk_mux_out = clk_148;
        endcase
    end

    assign tx_ref_clk       = (HD_FREQ == "74.25") ? clk_75 :
                              (TEST_RXSAMPLE_CHK == 1'b1 & VIDEO_STANDARD == "mr") ? clk_296_99 :
                              (VIDEO_STANDARD == "mr") ? clk_297 :
                              (TEST_RXSAMPLE_CHK == 1'b1) ? clk_148_49 : clk_148;
    assign rx_cdr_refclk    = (DEVKIT_A10_CDR_270M) ? clk_270 :
                              (HD_FREQ == "74.25") ? clk_75 : clk_148;
    assign rx_coreclk          = (HD_FREQ == "74.25") ? clk_75 : clk_148;
    //assign ref_clk_smpte372 = (DIRECTION == "rx" & VIDEO_STANDARD == "dl" & RX_EN_A2B_CONV == 1'b1) ? clk_148 : 
    //                          ((DIRECTION == "rx" & (VIDEO_STANDARD == "tr" | VIDEO_STANDARD == "threeg") & RX_EN_B2A_CONV == 1'b1) ? clk_75 : clk_148);
    assign ref_clk_smpte372 = clk_148 ;
    assign tx_chk_refclk    = clk_mux_out;
    assign reconfig_clk     = clk_100;
    assign clk_fpga         = clk_mux_out;

    //--------------------------------------------------------------------------
    // [END] comment
    //--------------------------------------------------------------------------


endmodule
