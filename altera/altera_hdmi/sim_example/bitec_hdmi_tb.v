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



// *********************************************************************
//
//
// Bitec HDMI IP Core
// 
//
// All rights reserved. Property of Bitec.
// Restricted rights to use, duplicate or disclose this code are
// granted through contract.
// 
// (C) Copyright Bitec 2010,2011,2012
//       All rights reserved
//
// *********************************************************************
// Author         : $Author: Andy $ @ bitec-dsp.com
// Department     : 
// Date           : $Date: 2012-09-25 19:03:22 +0200 (Tue, 25 Sep 2012) $
// Revision       : $Revision: 16 $
// URL            : $URL: file://nas-bitec/svn/hdmi/bitec_hdmi/bitec_hdmi_tb.v $
// *********************************************************************
// Description
// 
//
// *********************************************************************

//
// Video formats
// VIC=0 : Test only
//
// 480P60 (VIC=2)
//  parameter CLK_PIXEL = 27;
//  parameter V_FRONT = 9;
//  parameter V_SYNC  = 6;
//  parameter V_BACK  = 45-V_SYNC-V_FRONT;
//  parameter V_ACT   = 480;
//  parameter V_POL   = 0;
//  parameter H_FRONT = 16;
//  parameter H_SYNC  = 62;
//  parameter H_BACK  = 138-H_SYNC-H_FRONT;
//  parameter H_ACT   = 720; // Must be greater than 54
//  parameter H_POL   = 0;
//
// 720P60 (VIC=4)
//  parameter CLK_PIXEL = 74.25;
//  parameter V_FRONT = 5;
//  parameter V_SYNC  = 5;
//  parameter V_BACK  = 30-V_SYNC-V_FRONT;
//  parameter V_ACT   = 720;
//  parameter V_POL   = 1;
//  parameter H_FRONT = 110;
//  parameter H_SYNC  = 40;
//  parameter H_BACK  = 370-H_SYNC-H_FRONT;
//  parameter H_ACT   = 1280; // Must be greater than 54
//  parameter H_POL   = 1;
//
// 1080P60 (VIC=16)
//  parameter CLK_PIXEL = 148.5;
//  parameter V_FRONT = 4;
//  parameter V_SYNC  = 5;
//  parameter V_BACK  = 45-V_SYNC-V_FRONT;
//  parameter V_ACT   = 1080;
//  parameter V_POL   = 1;
//  parameter H_FRONT = 88;
//  parameter H_SYNC  = 44;
//  parameter H_BACK  = 280-H_SYNC-H_FRONT;
//  parameter H_ACT   = 1920; // Must be greater than 54
//  parameter H_POL   = 1;
//
// 2KP30 (VIC=95)
//  parameter CLK_PIXEL = 297.0;
//  parameter V_FRONT = 8;
//  parameter V_SYNC  = 10;
//  parameter V_BACK  = 90-V_SYNC-V_FRONT;
//  parameter V_ACT   = 2160;
//  parameter V_POL   = 1;
//  parameter H_FRONT = 176;
//  parameter H_SYNC  = 88;
//  parameter H_BACK  = 560-H_SYNC-H_FRONT;
//  parameter H_ACT   = 3840; // Must be greater than 54
//  parameter H_POL   = 1;
//
// 2KP30 (VIC=97)
//  parameter CLK_PIXEL = 594.0;
//  parameter V_FRONT = 8;
//  parameter V_SYNC  = 10;
//  parameter V_BACK  = 90-V_SYNC-V_FRONT;
//  parameter V_ACT   = 2160;
//  parameter V_POL   = 1;
//  parameter H_FRONT = 176;
//  parameter H_SYNC  = 88;
//  parameter H_BACK  = 560-H_SYNC-H_FRONT;
//  parameter H_ACT   = 3840; // Must be greater than 54
//  parameter H_POL   = 1;

// synthesis translate_off
`timescale 1ns / 1ns
// synthesis translate_on

module bitec_hdmi_tb();

parameter BATCH = 0; // Determines how testbench terminates

parameter SYMBOLS_PER_CLOCK = 4; // 4Kp60 (VIC=97) must be in 2 or 4 symbol per clock, so that $floor(1000/CLK_LS/2) is not 0
parameter TEST_HDMI_6G = 1;

parameter CLK_MM_FREQ = 100; // Mhz

parameter CLK_I2C_FREQ = 8;

localparam test_vic2_aud2ch_48khz = 0;


parameter VIC=0; // 2, 4, 16, 95, 97
parameter AUD_FREQ=48; // 48, 96, 192, 384, 1536

parameter CLK_PIXEL =  VIC==2 ? 27.0: VIC==4 ? 74.25: VIC==16 ? 148.5: VIC == 95 ? 297.0: VIC == 97 ? 594.0 : 27.0;
parameter V_FRONT   =  VIC==2 ? 9   : VIC==4 ? 5    : VIC==16 ? 4    : VIC == 95 ? 8    : VIC == 97 ? 8     : 9;
parameter V_SYNC    =  VIC==2 ? 6   : VIC==4 ? 5    : VIC==16 ? 5    : VIC == 95 ? 10   : VIC == 97 ? 10    : 6;
parameter V_BACK    = (VIC==2 ? 45  : VIC==4 ? 30   : VIC==16 ? 45   : VIC == 95 ? 90   : VIC == 97 ? 90    : 45)-V_SYNC-V_FRONT;
parameter V_ACT     =  VIC==2 ? 130 : VIC==4 ? 220  : VIC==16 ? 330 : VIC == 95 ? 360 : VIC == 97 ? 360  : 48;
parameter V_POL     =  VIC==2 ? 0   : VIC==4 ? 1    : VIC==16 ? 1    : VIC == 95 ? 1    : VIC == 97 ? 1     : 0;
parameter H_FRONT   =  VIC==2 ? 16  : VIC==4 ? 110  : VIC==16 ? 88   : VIC == 95 ? 176 : VIC == 97 ? 176   : 16;
parameter H_SYNC    =  VIC==2 ? 62  : VIC==4 ? 40   : VIC==16 ? 44   : VIC == 95 ? 88   : VIC == 97 ? 88    : 62;
parameter H_BACK    = (VIC==2 ? 138 : VIC==4 ? 370  : VIC==16 ? 280  : VIC == 95 ? 560  : VIC == 97 ? 560   : 138)-H_SYNC-H_FRONT;
parameter H_ACT     = (VIC==2 ? 291 : VIC==4 ? 455 : VIC==16 ? 270 : VIC == 95 ? 540 : VIC == 97 ? 540  : 72);
parameter H_POL     =  VIC==2 ? 0   : VIC==4 ? 1    : VIC==16 ? 1    : VIC == 95 ? 1    : VIC == 97 ? 1     : 0;

parameter MODE      = 1; // 1=HDMI, 0=DVI
parameter [1:0] BPP = 0; // Bits per pixel

parameter AUX_TEST = 1;
parameter CLK_LS = CLK_PIXEL;


// 48KHz = 153.6Mhz/3200, 96KHz=153.6Mhz/1600, 192KHz=153.6Mhz/800, 384KHz=153.6Mhz/400, 768KHz=153.6Mhz/200 1536KHz=153.6Mhz/100 3072KHz=153.6Mhz/50 6144KHz=153.6Mhz/25
parameter [11:0] AUDIO_CLK_DIVIDER = AUD_FREQ==48 ? 3200  : AUD_FREQ==96 ? 1600  : AUD_FREQ==192 ? 800  : AUD_FREQ==384 ? 400  : AUD_FREQ==1536 ? 100  :3200;
parameter AUDIO_CHAN_COUNT        =  2; // 2, 8, 12, 24, 32
parameter AUDIO_FORMAT            =  (AUDIO_CHAN_COUNT>8)? 4  : 0;


// AUDIO_FORMAT == 0 -> L-PCM        .. packet type 2
// AUDIO_FORMAT == 1 -> One-Bit      .. packet type 7 (not supported)
// AUDIO_FORMAT == 2 -> DST          .. packet types 8 (not supported)
// AUDIO_FORMAT == 3 -> HBR          .. packet type 9
// AUDIO_FORMAT == 4 -> 3D (LPCM)    .. packet type 11
// AUDIO_FORMAT == 5 -> 3D (One-Bit) .. packet type 12 (not supported)
// AUDIO_FORMAT == 6 -> MST (LPCM)   .. packet type 14
// AUDIO_FORMAT == 7 -> MST (One-Bit).. packet type 15 (not supported)

/*function string get_time();
    int    file_pointer;
     
    //Stores time and date to file sys_time
    void'($system("date +%X--%x > sys_time"));
    //Open the file sys_time with read access
    file_pointer = $fopen("sys_time","r");
    //assin the value from file to variable
    void'($fscanf(file_pointer,"%s",get_time));
    //close the file
    $fclose(file_pointer);
    void'($system("rm sys_time"));
  endfunction*/
   
 
reg reset;    
  initial 
    begin
      reset      <= 1;
      #100 reset <= 0;
    end

parameter CLK_VIDEO_FREQ_CLOCK_PERIOD = 1000.000000/CLK_PIXEL; 
reg clk_vid;
initial
  clk_vid <= 0;
always
  #($floor(CLK_VIDEO_FREQ_CLOCK_PERIOD*SYMBOLS_PER_CLOCK/2)) clk_vid <= ~clk_vid;   

parameter CLK_LS_FREQ_CLOCK_PERIOD    = 1000.000000/CLK_LS;  
reg clk_ls;
initial
  clk_ls <= 0;
always
  #($floor(CLK_LS_FREQ_CLOCK_PERIOD*SYMBOLS_PER_CLOCK/2)) clk_ls <= ~clk_ls;   
 
localparam CLK_I2C_FREQ_HALF_CLOCK_PERIOD = 1000.000000/CLK_I2C_FREQ/2;
reg clk_i2c;
initial
  clk_i2c <= 0;
always
  #CLK_I2C_FREQ_HALF_CLOCK_PERIOD clk_i2c <= ~clk_i2c;  

localparam CLK_MM_FREQ_HALF_CLOCK_PERIOD = 1000.000000/CLK_MM_FREQ/2;
reg clk_mm;
initial
  clk_mm <= 0;
always
  #CLK_MM_FREQ_HALF_CLOCK_PERIOD clk_mm <= ~clk_mm;  

localparam  CLK_100MHZ_FREQ_HALF_CLOCK_PERIOD = 1000.000000/150/2;
reg clk_100;
initial
  clk_100 <= 0;
always
 #CLK_100MHZ_FREQ_HALF_CLOCK_PERIOD clk_100 <= ~clk_100;  
  
   
// *********************************************************************
// Description
// Audio & Infoframe Packets
//
// ********************************************************************* 


// Audio sample clock is derived from 38.4Mhz clock
// AUDIO_CLK_DIVIDER = 800, 400, 200, 100 or 25
// 48KHz = 38.4Mhz/800, 96KHz=38.4Mhz/400, 192KHz=38.4Mhz/200, 348Mhz=38.4Mhz/100, 1536KHz=38.4Mhz/25
//

// Audio basis clock 
//localparam CLK_AUDIO_FREQ_HALF_CLOCK_PERIOD = 1000.000000/38.4/2;
localparam CLK_AUDIO_FREQ_CLOCK_PERIOD = 1000.000000/153.6;
reg clk_76p8;
initial
  clk_76p8 = 0;
always
  #($floor(CLK_AUDIO_FREQ_CLOCK_PERIOD/2)) clk_76p8 <= ~clk_76p8;   
  
wire [255:0] tx_audio_samples;  
wire         tx_audio_de; 
wire [111:0] tx_info_avi;
wire [ 47:0] tx_info_ai;
wire [ 55:0] tx_info_vsi;

wire [164:0] tx_audio_metadata;
wire [  4:0] tx_vsi_length; 

wire [19:0] tx_N_audio;
// Recalculate CTS to compensate for simulation step rounding errors
wire [19:0] tx_CTS_audio  = ($floor(CLK_AUDIO_FREQ_CLOCK_PERIOD)*tx_N_audio*AUDIO_CLK_DIVIDER/128)/$floor(CLK_LS_FREQ_CLOCK_PERIOD);

wire tx_audio_samp0;
wire [  4:0] tx_audio_format = {tx_audio_samp0, AUDIO_FORMAT[3:0]}; 

bitec_hdmi_audio_gen #(
  .MAX_AUDIO_CHAN_COUNT (8),
  .VIDEO_CLOCK(CLK_PIXEL)
)audio_gen
(
    .clk_in         (clk_76p8),
    .reset_in       (reset),
    .clk_en         (tx_audio_de),
    .samp_0         (tx_audio_samp0),
    .CTS_audio      ( ),
    .N_audio        (tx_N_audio),
    .chan_data      (tx_audio_samples),
    .ai_infoframe   (tx_info_ai),
    .avi_infoframe  (tx_info_avi),
    .vsi_infoframe  ({tx_info_vsi, tx_vsi_length}),
    .audio_metadata (tx_audio_metadata),
    .chan_count     (AUDIO_CHAN_COUNT),
    .f_samp_N       (AUDIO_CLK_DIVIDER),
    .audio_format   (AUDIO_FORMAT) 

);

// *********************************************************************
// Description
// Video Test Pattern Generation
//
// *********************************************************************

wire [ 1*SYMBOLS_PER_CLOCK-1:0] tx_h, tx_v, tx_de;
wire [ 1*SYMBOLS_PER_CLOCK-1:0] tx_h_i, tx_v_i;
assign  tx_h = H_POL == 1 ? tx_h_i : ~tx_h_i;
assign  tx_v = V_POL == 1 ? tx_v_i : ~tx_v_i;
wire [16*SYMBOLS_PER_CLOCK-1:0] current_x;
wire [16*SYMBOLS_PER_CLOCK-1:0] current_y;
wire [16*SYMBOLS_PER_CLOCK-1:0] tx_r,tx_g,tx_b;
wire [48*SYMBOLS_PER_CLOCK-1:0] tx_vdata;

genvar p;
generate
  for(p=0;p<SYMBOLS_PER_CLOCK;p=p+1)
    begin : gen_vid_tx
      assign tx_vdata[48*p+:48] ={3{current_x[16*p+:8], 8'd0}};//{SYMBOLS_PER_CLOCK{48'd0}}; //  {SYMBOLS_PER_CLOCK{48'd0}}; // {3{current_x[16*p+:8], 8'd0}};//  //hdcp2_vid_data[48*p+:48];//
      assign {tx_r[16*p+:16],tx_g[16*p+:16],tx_b[16*p+:16]} =  tx_vdata[48*p+:48]; //{SYMBOLS_PER_CLOCK{48'd0}}; // {SYMBOLS_PER_CLOCK{48'd0}};//
    end
endgenerate

tpg #(.PIXELS_PER_CLOCK(SYMBOLS_PER_CLOCK)) tpg_u (
    .clk (clk_vid),
    .reset (reset),

    .current_x (current_x),
    .current_y (current_y),
    .de (tx_de),

    .h (tx_h_i),
    .v (tx_v_i),

    .v_front (V_FRONT), .v_sync (V_SYNC), .v_back (V_BACK), .v_act (V_ACT),
    .h_front (H_FRONT), .h_sync (H_SYNC), .h_back (H_BACK), .h_act (H_ACT)
);

wire [10*SYMBOLS_PER_CLOCK-1:0] out_b, out_r, out_g, out_c; 



// *********************************************************************
// Description
// AUX Data data generation
//
// *********************************************************************

wire [71:0] tx_aux_data [3:0] ;  
reg [8:0] tx_aux_cntr;
// Arbitrary packet
assign tx_aux_data[0] = {8'h0, 32'hdeadbeef,32'hdeadbeef};
assign tx_aux_data[1] = {8'h1, 32'hdeadbeef,32'hdeadbeef}; 
assign tx_aux_data[2] = {8'h2, 32'hdeadbeef,32'hdeadbeef};
assign tx_aux_data[3] = {8'h3, 32'hdeadbeef,32'hdeadbeef};


wire tx_aux_valid = ((tx_aux_cntr == 0) 
                    |  (tx_aux_cntr == 1) 
                    |  (tx_aux_cntr == 2) 
                    |  (tx_aux_cntr == 3)) & (AUX_TEST == 1);
                    
wire tx_aux_sop = (tx_aux_cntr == 0) & (AUX_TEST == 1);                 
                  
wire tx_aux_eop = (tx_aux_cntr == 3) & (AUX_TEST == 1); 
 
wire tx_aux_ready;
always @(posedge clk_ls or posedge reset) 
if(reset)
  tx_aux_cntr <= 0;
else
  tx_aux_cntr <= (tx_aux_valid) ? tx_aux_cntr  + tx_aux_ready : tx_aux_cntr;

// *********************************************************************
// Description
// SOURCE CRC Checking
//
// *********************************************************************

reg crc_sclr = 0; // Used to clear CRC count
wire [15:0] tx_crc_r;  
autotest_crc #(.PIXELS_PER_CLOCK(SYMBOLS_PER_CLOCK)) crc_tx_r(
  // Outputs
  .crc_out (tx_crc_r),
  // Inputs
  .reset (reset), .clk (clk_vid), .d (tx_r), 
  .crc_en (tx_de), .sclr (crc_sclr)
);
wire [15:0] tx_crc_g;  
autotest_crc #(.PIXELS_PER_CLOCK(SYMBOLS_PER_CLOCK)) crc_tx_g(
  // Outputs
  .crc_out (tx_crc_g),
  // Inputs
  .reset (reset), .clk (clk_vid), .d (tx_g), 
  .crc_en (tx_de), .sclr (crc_sclr)
);
wire [15:0] tx_crc_b;  
autotest_crc #(.PIXELS_PER_CLOCK(SYMBOLS_PER_CLOCK)) crc_tx_b(
  // Outputs
  .crc_out (tx_crc_b),
  // Inputs
  .reset (reset), .clk (clk_vid), .d (tx_b), 
  .crc_en (tx_de), .sclr (crc_sclr)
);

// *********************************************************************
// Description
// SOURCE DUT
//
// *********************************************************************
hdmi_tx_4sym dut_tx (

    .reset         (reset),
    .vid_clk       (clk_vid),
    .ls_clk        (clk_ls),
    .vid_data      (tx_vdata),
    .vid_vsync     (tx_v),
    .vid_hsync     (tx_h),
    .vid_de        (tx_de),
    .ctrl          ({SYMBOLS_PER_CLOCK{6'h0}}),
    .out_b         (out_b), 
    .out_r         (out_r), 
    .out_g         (out_g), 
    .out_c         (out_c),
    .aux_data      (tx_aux_data[tx_aux_cntr]),
    .aux_valid     (tx_aux_valid),
    .aux_ready     (tx_aux_ready),
    .aux_sop       (tx_aux_sop),
    .aux_eop       (tx_aux_eop),
    .gcp           ({4'b1000, BPP}), // cd[2:0] = 101 (10 bpc)
    .info_vsi      (62'h1eadbeefdeadbeef),
    .info_avi      ({1'b0,112'hffff}),
    .mode          (MODE==1),
    .audio_CTS     (tx_CTS_audio),
    .audio_N       (tx_N_audio),
    .audio_clk     (clk_76p8),
    .audio_data    (tx_audio_samples),
    .audio_de      (tx_audio_de),
    .audio_mute    (1'b0),
    .audio_info_ai ({1'b0, 48'h0}),
    .audio_metadata({1'b0, tx_audio_metadata}),
    .audio_format  (tx_audio_format),
    .Scrambler_Enable      (TEST_HDMI_6G == 1),
    .TMDS_Bit_clock_Ratio (TEST_HDMI_6G == 1)
);


// *********************************************************************
// Description
// SKEW TMDS DATA
//
// *********************************************************************
reg [2:0] rx_in_lock;
initial
begin
  #134 rx_in_lock[0]  <= 1;
  #162 rx_in_lock[0]  <= 1;
  #197 rx_in_lock[0]  <= 1;
end

reg [10*2*SYMBOLS_PER_CLOCK-1:0] out_b_sr;
reg [10*2*SYMBOLS_PER_CLOCK-1:0] out_r_sr;
reg [10*2*SYMBOLS_PER_CLOCK-1:0] out_g_sr;

always @(posedge reset or posedge clk_ls)
if(reset)
  begin
    out_b_sr <= {SYMBOLS_PER_CLOCK*2{10'd0}}; 
    out_r_sr <= {SYMBOLS_PER_CLOCK*2{10'd0}};
    out_g_sr <= {SYMBOLS_PER_CLOCK*2{10'd0}};
  end
else
  begin
    out_b_sr <= {out_b, out_b_sr[10*2*SYMBOLS_PER_CLOCK-1:10*SYMBOLS_PER_CLOCK]}; 
    out_r_sr <= {out_r, out_r_sr[10*2*SYMBOLS_PER_CLOCK-1:10*SYMBOLS_PER_CLOCK]};
    out_g_sr <= {out_g, out_g_sr[10*2*SYMBOLS_PER_CLOCK-1:10*SYMBOLS_PER_CLOCK]};
  end

wire [ 1*SYMBOLS_PER_CLOCK-1:0] rx_de, rx_h, rx_v;
wire [16*SYMBOLS_PER_CLOCK-1:0] rx_r,  rx_g, rx_b;
wire [48*SYMBOLS_PER_CLOCK-1:0] rx_vdata;   // testbench @ 1 symbol per clock
generate
  for(p=0;p<SYMBOLS_PER_CLOCK;p=p+1)
    begin : gen_vid_rx
      assign {rx_r[16*p+:16],rx_g[16*p+:16],rx_b[16*p+:16]} = rx_vdata[48*p+:48];
    end
endgenerate


// *********************************************************************
// Description
// SINK SCDC CONTROL
//
// *********************************************************************

// scdc interface for controlling the sink
reg  [7:0] rx_scdc_address;
reg rx_scdc_read;
reg rx_scdc_write;
reg  [7:0] rx_scdc_writedata;
wire [7:0] rx_scdc_readdata;

initial
  begin
    rx_scdc_write = 1'b0;
    rx_scdc_address = 8'h0;
    rx_scdc_writedata = 8'h0;
    rx_scdc_read = 1'b0;
    @ (negedge reset);
    #1000 ;
    if(TEST_HDMI_6G==1)
      rx_scdc_slave_write(8'h20,8'h3);
    else
      ; // Do nothing
  end

task rx_scdc_slave_write(input [7:0] addr, input [7:0] wdata);
begin
  @ (negedge clk_i2c);
  rx_scdc_write = 1'b1;
  rx_scdc_address = addr;
  rx_scdc_writedata = wdata;
  @ (negedge clk_i2c);
  rx_scdc_write = 1'b0;
  rx_scdc_writedata = 0;
end
endtask

task rx_scdc_slave_read (input [7:0] addr, output [7:0] rdata);
begin
  @ (negedge clk_i2c);
  rx_scdc_read = 1'b1;
  rx_scdc_address = addr;
  @ (posedge clk_i2c);
  rx_scdc_read = 1'b0;
  @ (posedge clk_i2c);
  rdata = rx_scdc_readdata;
  rx_scdc_read = 1'b0;
  rx_scdc_address = 0;
end
endtask

wire rx_aux_valid;
wire rx_aux_sop;
wire rx_aux_eop;
wire [71:0] rx_aux_data;

wire aux_pkt_wr;
wire [6:0] aux_pkt_addr;
wire [71:0] aux_pkt_data;

wire [ 19:0] rx_N_audio;
wire [ 19:0] rx_CTS_audio;
wire [255:0] rx_audio_samples;  
wire         rx_audio_de; 
wire [  4:0] rx_audio_format;

// *********************************************************************
// Description
// SINK DUT
//
// *********************************************************************

wire [7:0] rx_keys_addr;
   
hdmi_rx_4sym dut_rx(

    .reset         (reset),
    .vid_clk       (clk_vid), 
    .ls_clk        ({clk_ls,clk_ls,clk_ls}),
    .in_b          (out_b_sr[0+:SYMBOLS_PER_CLOCK*10]),
    .in_r          (out_r_sr[1+:SYMBOLS_PER_CLOCK*10]),
    .in_g          (out_g_sr[2+:SYMBOLS_PER_CLOCK*10]),
    .in_lock       (3'b111),
    .vid_data      (rx_vdata),
    .vid_vsync     (rx_v),
    .vid_hsync     (rx_h),
    .vid_de        (rx_de),
    .aux_data      (rx_aux_data),
    .aux_valid     (rx_aux_valid),
    .aux_sop       (rx_aux_sop),
    .aux_eop       (rx_aux_eop), 
    .gcp           (),
    .aux_pkt_addr  (aux_pkt_addr),
    .aux_pkt_data  (aux_pkt_data),
    .aux_pkt_wr    (aux_pkt_wr),
    .audio_CTS     (rx_CTS_audio), 
    .audio_N       (rx_N_audio), 
    .audio_data    (rx_audio_samples), 
    .audio_de      (rx_audio_de), 
    .audio_metadata(),
    .audio_format  (rx_audio_format),
    .locked        (), 
    .scdc_i2c_clk   (clk_i2c),
    .scdc_i2c_addr  (rx_scdc_address),
    .scdc_i2c_rdata (rx_scdc_readdata),
    .scdc_i2c_wdata (rx_scdc_writedata),
    .scdc_i2c_r     (rx_scdc_read),
    .scdc_i2c_w     (rx_scdc_write),
    .TMDS_Bit_clock_Ratio (),
    .mode                 (),
    .ctrl                 (),
    .in_5v_power          (1'b1),
    .in_hpd               (1'b1)
);

// *********************************************************************
// Description
// SINK CRC Checking
// *********************************************************************

wire [15:0] rx_crc_r;
autotest_crc #(.PIXELS_PER_CLOCK(SYMBOLS_PER_CLOCK)) crc_rx_r(
  // Outputs
  .crc_out (rx_crc_r),
  // Inputs
  .reset (reset), .clk (clk_vid), .d (rx_r), 
  .crc_en (rx_de), .sclr (crc_sclr)
);

wire [15:0] rx_crc_g;
autotest_crc #(.PIXELS_PER_CLOCK(SYMBOLS_PER_CLOCK)) crc_rx_g(
  // Outputs
  .crc_out (rx_crc_g),
  // Inputs
  .reset (reset), .clk (clk_vid), .d (rx_g), 
  .crc_en (rx_de), .sclr (crc_sclr)
);

wire [15:0] rx_crc_b;
autotest_crc #(.PIXELS_PER_CLOCK(SYMBOLS_PER_CLOCK)) crc_rx_b(
  // Outputs
  .crc_out (rx_crc_b),
  // Inputs
  .reset (reset), .clk (clk_vid), .d (rx_b), 
  .crc_en (rx_de), .sclr (crc_sclr)
);


// *********************************************************************
// Description
// Simulation control 
//
// *********************************************************************

// Events to start the tests
 
event start_test_video;
event start_test_aux;  
event start_test_audio;
event start_reporting;
event start_test_hdcp1_repeater;
integer field_cntr = 0;

wire rx_v_active = V_POL ? rx_v : ~rx_v; // Detect active edge of recieved vsync
wire tx_v_active = V_POL ? tx_v : ~tx_v; // Detect active edge of recieved vsync
/*
initial
begin
  $display("tx_CTS_audio = %d", tx_CTS_audio);
  $display("($floor(CLK_AUDIO_FREQ_CLOCK_PERIOD)*tx_N_audio*AUDIO_CLK_DIVIDER/128) = %d", ($floor(CLK_AUDIO_FREQ_CLOCK_PERIOD)*tx_N_audio*AUDIO_CLK_DIVIDER/128));
  $display("$floor(CLK_LS_FREQ_CLOCK_PERIOD) = %d", $floor(CLK_LS_FREQ_CLOCK_PERIOD));
end*/


initial
begin
  //$display("System Time (Start) : %s",get_time());
  $display("SYMBOLS_PER_CLOCK = %d", SYMBOLS_PER_CLOCK);
  $display("VIC               = %d", VIC);
  $display("AUDIO Frequency  =  %d kHz", AUD_FREQ );
  $display("AUDIO_CLK_DIVIDE  = %d", AUDIO_CLK_DIVIDER);
  $display("TEST_HDMI_6G      = %d", TEST_HDMI_6G);
  wait(reset == 0);
    #40000
  // Wait for 4 files to be received
//  -> start_reporting;
   
  @(posedge rx_v_active);
  @(posedge rx_v_active);
  
  if(BPP > 0 | TEST_HDMI_6G == 1)
    begin
      // If deepcolor or scrambling we need to wait for the sink to establish color mode
      @(posedge tx_v_active);
      @(posedge tx_v_active);
      // Wait for color phase sync
      @(posedge rx_v_active);
      @(posedge rx_v_active);
      @(posedge rx_v_active);
      @(posedge rx_v_active);
    end
    
  -> start_test_video; 
  -> start_test_aux;
  -> start_test_audio;
    // Check 8 fields
    @(posedge rx_v_active);
    @(posedge rx_v_active);
    @(posedge rx_v_active);
    @(posedge rx_v_active);
    @(posedge rx_v_active);
    @(posedge rx_v_active);
    @(posedge rx_v_active);
    @(posedge rx_v_active);   
    $display("Simulation pass");  
    //$display("System Time (End) : %s",get_time());    
    $finish();  
          
end

// *********************************************************************
// Description
//                         RUN TIME REPORTING
//
// *********************************************************************

integer input_field_cntr = 0;
integer output_field_cntr = 0;
integer output_audio_cntr = 0;
initial
begin
  @ start_reporting
  while(1 == 1)
  @(posedge tx_v_active)
    begin
      $display("--------------");
      $display("-Fields in        = %d", input_field_cntr);
      $display("-Fields out       = %d", output_field_cntr);
      $display("-Audio frames out = %d", output_audio_cntr);
      $display("--------------");
    end
   
end
initial while(1 == 1) @(posedge tx_v_active   ) input_field_cntr  = input_field_cntr + 1;
initial while(1 == 1) @(posedge rx_v_active   ) output_field_cntr = output_field_cntr +1;
initial while(1 == 1) @(posedge rx_audio_samples[28]) output_audio_cntr = output_audio_cntr +1;

// *********************************************************************
// Description
//                         CHECK VIDEO
//
// *********************************************************************
 
initial
begin
  @ start_test_video
  #100
  
    // Clear CRCs
    @(posedge clk_vid) crc_sclr  = 1; // Clear CRC
    @(posedge clk_vid) crc_sclr  = 0;
    
    // Check received video CRCsim:/bitec_hdmi_tb/dut_rx/gen_hdcp2/hdcp2/rsa_clk

    while(1 == 1)
      begin
        @(posedge rx_v_active)
          begin
            //$display("Resolution = %d Single RX CRC = %X TX CRC =%X", H_ACT, rx_crc_r, tx_crc_r);
            if( (rx_crc_r != tx_crc_r) | (rx_crc_g != tx_crc_g) | (rx_crc_b != tx_crc_b))
              begin
                //$display("System Time (End) : %s",get_time());    
                $display("Simulation fail");
                $finish();
              end
            @(posedge clk_vid) crc_sclr  = 1; // Clear CRC
            @(posedge clk_vid) crc_sclr  = 0;
          end
      end    

end

// *********************************************************************
// Description
//                         CHECK AUX DATA
//
// *********************************************************************

reg rx_aux_packet_type = 0; 
reg rx_aux_error = 0; 
reg [7:0] aux_test_step = 0;
initial
begin
  @ start_test_aux
  #100
  

  while(1==1)
  begin
    @(posedge clk_ls) 
        if(rx_aux_valid)
          begin
            case (aux_test_step )
              0 : // waiting for sop
                begin
                  aux_test_step <= rx_aux_sop ? 1 : 0;
                  
                  // Decode header
                  rx_aux_packet_type <=  rx_aux_data == {8'h0, 32'hdeadbeef,32'hdeadbeef};
                  
                  // Check protocol
                  if(rx_aux_eop & rx_aux_sop) 
                    begin
                      $display("AUX protocol error");
                      //$display("System Time (End) : %s",get_time());    
                      $stop();
                    end
                end
              1 : // First payload
                begin
                  aux_test_step <=  2;
                  
                  // Check payload data
                  if(rx_aux_packet_type &  (rx_aux_data != {8'h1, 32'hdeadbeef,32'hdeadbeef}))
                    begin
                      $display("AUX payload error");
                      $stop();
                    end

                  // Check protocol
                  if(rx_aux_sop | rx_aux_eop) 
                    begin
                      $display("AUX protocol error");
                      $stop();
                    end
                end
              2 : // Second payload
                begin
                  aux_test_step <=  3;
                  
                  // Check payload data
                  if(rx_aux_packet_type &  rx_aux_data != ({8'h2, 32'hdeadbeef,32'hdeadbeef}))
                    begin
                      $display("AUX payload error");
                      //$display("System Time (End) : %s",get_time());    
                      $stop();
                    end

                  // Check protocol
                  if(rx_aux_sop | rx_aux_eop) 
                    begin
                      $display("AUX protocol error");
                      //$display("System Time (End) : %s",get_time());    
                      $stop();
                    end
                end
              3 : // eop
                begin
                  aux_test_step <=  0;
                  
                  // Check payload data
                  if(rx_aux_packet_type &  (rx_aux_data != 72'hc3de16be34de16be0b)) // CS
                    begin
                      $display("AUX payload error");
                      $stop();
                    end

                  // Check protocol
                  if(rx_aux_sop) 
                    begin
                      $display("AUX protocol error");
                      $stop();
                    end
                end
              endcase
        end
    end
end 

// *********************************************************************
// Description
//                         CHECK AUDIO
//
// *********************************************************************
wire [31:0] audio_lpcm_err ; 
wire [31:0] rx_audio_samples_chan [3:0][7:0];
wire [ 7:0] rx_audio_de_chan   [3:0];
wire [ 7:0] rx_audio_lpcm_chan   [3:0][7:0];

reg audio_lpcm_err_reg;

reg [1:0] rx_audio_samples_phase;
always @(posedge clk_ls or posedge reset)
if(reset)
  rx_audio_samples_phase <= 2'd0;
else
  rx_audio_samples_phase <= ~rx_audio_format[4] & (rx_audio_format[3:0] ==4) ? // IS format 3D?
      rx_audio_samples_phase + rx_audio_de : 2'd0;
      
reg [7:0] audio_lpcm_cntr   [3:0][7:0]; // Reference test pattern

genvar b; // 32-channel beat
generate 
  for(b=0;b<4;b=b+1)
    begin : gen_audio_check_phase
    
      genvar c; // Inter 32-channel
      for(c=0;c<8;c=c+1)
        begin : gen_audio_check
              
              // Map audio data into channels
              assign rx_audio_de_chan     [b][c] = (b == rx_audio_samples_phase) ? rx_audio_de & rx_audio_samples_chan[b][c][24] : 0;
              assign rx_audio_samples_chan[b][c] = (b == rx_audio_samples_phase) ? rx_audio_samples[c*32+:32] : 0;
              assign rx_audio_lpcm_chan   [b][c] = (b == rx_audio_samples_phase & rx_audio_de_chan[b][c]) ? (rx_audio_samples_chan[b][c][23:16]): 0;
              
              assign audio_lpcm_err[b*8+c] =  rx_audio_de_chan  [b][c] ? rx_audio_lpcm_chan[b][c] != audio_lpcm_cntr[b][c] : 0;

              always @(posedge clk_ls or posedge reset)
              if(reset)
                audio_lpcm_err_reg <= 1'b0;
              else
                audio_lpcm_err_reg <= |audio_lpcm_err;

              
              always @(posedge clk_ls or posedge reset)
              if(reset)
                audio_lpcm_cntr[b][c] <= 8'd0;
              else
                if(rx_audio_de_chan[b][c])
                  begin
                    if(audio_lpcm_err[b*8+c] == 1)
                      audio_lpcm_cntr[b][c] <= rx_audio_lpcm_chan[b][c] + 1;
                    else if(audio_lpcm_cntr[b][c] == 191)
                      audio_lpcm_cntr[b][c] <= 0;
                    else
                      audio_lpcm_cntr[b][c] <= audio_lpcm_cntr[b][c] + 1;
                  end

              /*always @(posedge clk_ls)
              begin
                  if(rx_audio_de_chan  [b][c]) begin
                        if(rx_audio_lpcm_chan[b][c] == audio_lpcm_cntr[b][c]) $display("Match: audio data = 32'h%h", rx_audio_lpcm_chan[b][c]);
                        else $display("Error: Received audio data = 32'h%h, Expected audio data = 32'h%h", rx_audio_lpcm_chan[b][c], audio_lpcm_cntr[b][c]);
                  end
              end*/
              
         
        end
    end    
endgenerate

initial
begin
  @ start_test_audio
  #100
    
  @(posedge audio_lpcm_err_reg)
    begin
     $display("Audio error");
     //$display("System Time (End) : %s",get_time());   
     $stop();
   end

end

endmodule





