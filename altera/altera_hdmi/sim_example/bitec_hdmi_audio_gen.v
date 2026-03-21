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
// Bitec Displayport IP Core
// 
//
// All rights reserved. Property of Bitec.
// Restricted rights to use, duplicate or disclose this code are
// granted through contract.
// 
// (C) Copyright Bitec 2010,2011,2012
//     All rights reserved
//
// *********************************************************************
// Author         : $Author: Marco $ @ bitec-dsp.com
// Department     : 
// Date           : $Date: 2012-07-16 19:19:06 +0300 (Mon, 16 Jul 2012) $
// Revision       : $Revision: 112 $
// URL            : $URL: svn://10.8.0.1/share/svn/dp/branches/gxb_40bits/rx/bitec_dp_rx_deskew.v $
// *********************************************************************
// Description
// 
//
// *********************************************************************

// synthesis translate_off
`timescale 1ns / 1ns
// synthesis translate_on
`default_nettype none

module bitec_hdmi_audio_gen #(
  parameter MAX_AUDIO_CHAN_COUNT = 2,
  parameter VIDEO_CLOCK = 25.2
)
(
  input wire clk_in,    	// 38.4 MHz clock
  input wire reset_in,
  
	output reg  [  7:0] clk_en,  
	output reg samp_0,
	output reg clk_1m,
	output wire [ 19:0] N_audio, CTS_audio,
	output wire [255:0] chan_data,
	
	output wire [ 47:0]  ai_infoframe,
	output wire [111:0]  avi_infoframe,
	output wire [ 60:0]  vsi_infoframe,
	output wire [164:0]  audio_metadata,
	input  wire [ 31:0]  chan_count,
	input  wire [ 11:0]  f_samp_N,
	input	 wire [  3:0]  audio_format
);



// audio_format[3:0] == 0 -> L-PCM        .. packet type 2
// audio_format[3:0] == 1 -> One-Bit      .. packet type 7
// audio_format[3:0] == 2 -> DST          .. packet types 8
// audio_format[3:0] == 3 -> HBR          .. packet type 9
// audio_format[3:0] == 4 -> 3D (LPCM)    .. packet type 11
// audio_format[3:0] == 5 -> 3D (One-Bit) .. packet type 12
// audio_format[3:0] == 6 -> MST (LPCM)   .. packet type 14
// audio_format[3:0] == 7 -> MST (One-Bit).. packet type 15
 

localparam [7:0] SAW_LIMIT = 191;
wire [11:0] freq_limit;
generate
  if(VIDEO_CLOCK == 27)
    begin  : gen_27 // 480P60 (VIC=2)
      assign {freq_limit, N_audio, CTS_audio} = 54'd0 
                                        | {54{f_samp_N == 3200}} & {(f_samp_N-12'd1), 20'd6144,   20'd27000} // 38.4/800 =   48KHz
                                        | {54{f_samp_N == 1600}} & {(f_samp_N-12'd1), 20'd12288,  20'd27000} // 38.4/400 =   96KHz
                                        | {54{f_samp_N == 800}} & {(f_samp_N-12'd1), 20'd24576,  20'd27000}; // 38.4/200 =  192KHz
    end
                            
  else if(VIDEO_CLOCK == 74.25)
    begin : gen_74 // 720P60 (VIC=4)
      assign {freq_limit, N_audio, CTS_audio} = 54'd0 
                                        | {54{f_samp_N == 3200}} & {(f_samp_N-12'd1), 20'd6144,   20'd74250}  // 38.4/800 =   48KHz
                                        | {54{f_samp_N == 1600}} & {(f_samp_N-12'd1), 20'd12288,  20'd74250}  // 38.4/400 =   96KHz
                                        | {54{f_samp_N ==  800}} & {(f_samp_N-12'd1), 20'd24576,  20'd74250}  // 38.4/200 =  192KHz
                                        | {54{f_samp_N ==  400}} & {(f_samp_N-12'd1),  20'd49152,  20'd74250} // 38.4/100 =  384KHz
                                        | {54{f_samp_N ==  200}} & {(f_samp_N-12'd1) , 20'd98304,  20'd74250} // 38.4/50  =  768KHz
                                        | {54{f_samp_N ==  100}} & {(f_samp_N-12'd1) , 20'd196608, 20'd74250};// 38.4/25  = 1536KHz
    end                               
  else if(VIDEO_CLOCK == 148.5)
    begin : gen_148 // 1080P60 (VIC=16)
      assign {freq_limit, N_audio, CTS_audio} = 54'd0 
                                        | {54{f_samp_N == 3200}} & {(f_samp_N-12'd1), 20'd6144,   20'd148500}  // 38.4/800 =   48KHz
                                        | {54{f_samp_N == 1600}} & {(f_samp_N-12'd1), 20'd12288,  20'd148500}  // 38.4/400 =   96KHz
                                        | {54{f_samp_N ==  800}} & {(f_samp_N-12'd1), 20'd24576,  20'd148500}  // 38.4/200 =  192KHz
                                        | {54{f_samp_N ==  400}} & {(f_samp_N-12'd1),  20'd49152,  20'd148500} // 38.4/100 =  384KHz
                                        | {54{f_samp_N ==  200}} & {(f_samp_N-12'd1) , 20'd98304,  20'd148500} // 38.4/50  =  768KHz
                                        | {54{f_samp_N ==  100}} & {(f_samp_N-12'd1) , 20'd196608, 20'd148500};// 38.4/25  = 1536KHz
    end                               
  else if(VIDEO_CLOCK == 297)
    begin : gen_297 // 4K30 (VIC=95)
      assign {freq_limit, N_audio, CTS_audio} = 54'd0 
                                        | {54{f_samp_N == 3200}} & {(f_samp_N-12'd1), 20'd5120,   20'd247500} // 38.4/800 =   48KHz
                                        | {54{f_samp_N == 1600}} & {(f_samp_N-12'd1), 20'd10240,  20'd247500} // 38.4/400 =   96KHz
                                        | {54{f_samp_N ==  800}} & {(f_samp_N-12'd1), 20'd24750,  20'd247500} // 38.4/200 =  192KHz
                                        | {54{f_samp_N ==  400}} & {(f_samp_N-12'd1),  20'd49500,  20'd247500} // 38.4/100 =  384KHz
                                        | {54{f_samp_N ==  200}} & {(f_samp_N-12'd1) , 20'd81920,  20'd247500} // 38.4/50  =  768KHz
                                        | {54{f_samp_N ==  100}} & {(f_samp_N-12'd1) , 20'd163840, 20'd247500};// 38.4/25  = 1536KHz
    end        
  else if(VIDEO_CLOCK == 594)
    begin : gen_297 // 4K60 (VIC=97)
      assign {freq_limit, N_audio, CTS_audio} = 54'd0 
                                        | {54{f_samp_N == 3200}} & {(f_samp_N-12'd1), 20'd6144,   20'd594000} // 38.4/800 =   48KHz
                                        | {54{f_samp_N == 1600}} & {(f_samp_N-12'd1), 20'd12288,  20'd594000} // 38.4/400 =   96KHz
                                        | {54{f_samp_N ==  800}} & {(f_samp_N-12'd1), 20'd24576,  20'd594000} // 38.4/200 =  192KHz
                                        | {54{f_samp_N ==  400}} & {(f_samp_N-12'd1),  20'd49152,  20'd594000} // 38.4/100 =  384KHz
                                        | {54{f_samp_N ==  200}} & {(f_samp_N-12'd1), 20'd98304,  20'd594000} // 38.4/50  =  768KHz
                                        | {54{f_samp_N ==  100}} & {(f_samp_N-12'd1), 20'd196608, 20'd594000};// 38.4/25  = 1536KHz
    end     
endgenerate

reg  [ 31:0] chan;
reg  [  7:0] lpcm;
reg  [  7:0] frame_num;
reg  [191:0] user_dta;
reg  [191:0] acs;	// Channel Status Block

// Returns 1 if the number of bits at 1 in sample[23:0] is even
function PARITY_FUNCT (input [23:0] sample);
  reg parity;
  integer i;
  begin
    parity = 1;
    for(i = 0; i < 23; i = i + 1)
      if(sample[i])
        parity = ~parity;
    PARITY_FUNCT = parity;
  end
endfunction

task ENCODE_SAMPLE 
(
  input sample_present,   // 
  input valid,            // validity bit
  input  [7:0]   frame_cnt,  // frame counter
  input  [191:0] user_data,
  input  [191:0] ch_status,
  input  [23:0]  audio,
  output [31:0]  sample
);
  begin
    sample[23:0] = audio;
    sample[24] = valid;
    sample[25] = user_data[frame_cnt];
    sample[26] = ch_status[frame_cnt];
    sample[27] = 1'b0; // parity
    if(frame_cnt == 0)
      sample[28] = 1'b1; // block start
    else
      sample[28] = 1'b0;
    sample[29] = 1'b0; // reserved
    sample[30] = 1'b0; // reserved
    sample[31] = sample_present; 
  end
endtask
  
// Generate audio sample clock and synchronized reset
reg reset, enable, enable_r;
reg [11:0] cnt;
reg [11:0] cnt_r, cnt_rr;
always @ (posedge clk_in or posedge reset_in)
  if(reset_in)
	  begin
		 reset <= 1'b1;
		 enable <= 1'd0;
		 enable_r <= 1'b0;
		 cnt <= 8'd0;
		 cnt_r <= 11'd0;
		 cnt_rr <= 11'd0;
	  end
  else
	  begin
	   enable_r <= enable;
	   cnt_r <=  cnt;
	   cnt_rr <= cnt_r;
	  	cnt   <= (cnt == freq_limit) ? 0 : cnt + 1; 
		 if((cnt_r == 0) 
		 | ((cnt_r == 1) & (chan_count >  8))
		 | ((cnt_r == 2) & (chan_count > 16))
		 | ((cnt_r == 3) & (chan_count > 24)))
			enable <= 1;
		 else
			enable <= 0;	 
	  end

always @ (posedge clk_in or posedge reset_in)
  if(reset_in)
	  begin
		 samp_0    <= 1'b0;
	  end
  else
	  begin
		  /*if(cnt_r[1:0] == 0)
		   	  samp_0 <= enable;
	 	  else
		   	  samp_0 <= 1'b0;*/
      samp_0 <= enable & ~enable_r;

	  end

wire [7:0] enable_i = {8{enable}} & (
                      {8{(chan_count - cnt_rr[1:0]*8) == 0}} & 8'b00000000
                    | {8{(chan_count - cnt_rr[1:0]*8) == 1}} & 8'b00000001
                    | {8{(chan_count - cnt_rr[1:0]*8) == 2}} & 8'b00000011
                    | {8{(chan_count - cnt_rr[1:0]*8) == 3}} & 8'b00000111
                    | {8{(chan_count - cnt_rr[1:0]*8) == 4}} & 8'b00001111
                    | {8{(chan_count - cnt_rr[1:0]*8) == 5}} & 8'b00011111
                    | {8{(chan_count - cnt_rr[1:0]*8) == 6}} & 8'b00111111
                    | {8{(chan_count - cnt_rr[1:0]*8) == 7}} & 8'b01111111
                    | {8{(chan_count - cnt_rr[1:0]*8) >= 8}} & 8'b11111111
                    );
                    
always @ (posedge clk_in or posedge reset_in)
if(reset_in)
  clk_en <= 0;
else
  clk_en <= enable_i;

// Generate 1kHz clock 
reg [9:0] cnt_1m;
always @ (posedge clk_in or posedge reset_in)
  if(reset_in)
	  begin
		 clk_1m <= 0;
		 cnt_1m <= 0;
	  end
  else
	  begin
	  	 cnt_1m <= (cnt_1m == 480) ? 0 : cnt_1m + 1; 	//   9600 / 960 = 1 kHz
		 if(cnt_1m == 0) 
			clk_1m <= 1;
		 else
			clk_1m <= 0;	 
	  end


// Table 9-12 HDMI 2.0 Specification
wire [5:0] acs_audio_rate = 6'd0
                          | {6{f_samp_N == 800}} & 6'b000010 // 48KHz
                          | {6{f_samp_N == 400}} & 6'b001010 // 96KHz
                          | {6{f_samp_N == 200}} & 6'b001110 // 192KHz
                          | {6{f_samp_N == 100}} & 6'b000101 // 384KHz
                          | {6{f_samp_N ==  25}} & 6'b010101;// 1536KHz
		
// generate sample sawtooth
always @ (posedge clk_in or posedge reset_in)
begin
    if(reset_in)
		begin
		  chan <= 32'h0;
		  lpcm <= 8'd0;
		  frame_num <= 8'd0;
		  user_dta <= 192'd0;
		  acs <= 192'd0;
		end
    else 
      begin
	      if (enable_r & ~enable) 
	        begin
             lpcm <= (lpcm == 191) ? 0 : lpcm + 1;

		        // - Linear PCM audio
		        // - Sample Freq. 48.000000 kHz
	          // - Original Sample Freq. 48.000000 kHz
		        // - Channel Count not indicated

            frame_num <= (frame_num == 8'd191) ? 8'd0 : frame_num + 8'd1;    
		        acs <= // {32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0};
				    {	8'h0, 8'h0, 8'h0, 8'h0, 8'h0, 8'h0,			// byte 23:18
					    8'h0, 8'h0, 8'h0, 8'h0, 8'h0, 8'h0,			// byte 17:12
					    8'h0, 8'h0, 8'h0, 8'h0, 8'h0, 8'h0,			// byte 11:6
					    8'h00, 	// 5 - UPC/EAN code
					    8'h01, 	// 4 - word length
					    {acs_audio_rate[5:4], 2'b0, acs_audio_rate[3:0]}, 	// 3 - clock accuracy and 48 kHz
					    8'h00, 	// 2 - source/channel number
					    8'h00, 	// 1 - category code, L bit
					    8'h00};	// 0 - consumer, pcm, copywrite, no pre-emphasis, ch.mode
			
            ENCODE_SAMPLE
            (
              1'b1,1'b1,frame_num,					// 	sample_present, valid, frame_cnt,
              user_dta,acs,{lpcm,16'd0},				//  user_data, ch_status, audio,
		          chan );
      end

    end
end

 
wire [31:0] chan_i = {chan[31:28],PARITY_FUNCT(chan[23:0]),chan[26:24],chan[23:0]};
genvar c;
generate
  for(c=0;c<8;c=c+1)
    begin : gen_chans
      
      reg  [31:0]	audio_data; // 32-channels
      
      always @(posedge clk_in)
      if(c<chan_count)
        begin : active_echan
          audio_data <= chan_i;
        end
      else
        begin
          audio_data <= 32'd0;
        end
        
      assign chan_data[32*c+:32] = audio_data;
    end
endgenerate



	


	 
/******************************************************************************************************/
/*		QD980 AI InfoFrame
/******************************************************************************************************/
/*										
coding type:           refer to Stream Header
channel count:         refer to Stream Header
sampling frequency:    refer to stream header
sample size:           refer to stream header
channel speaker alloc: [ -  -   -   -  -  -   FR FL]
level shift value:     0dB
LFE playback level:    no information
down mixed stereo out: permitted
*/	

wire [3:0] ai_CT_default = 4'd0;     // Audio format type			4'b001 - IEC 60958-3
wire [2:0] ai_CC_default = 3'd0;     // Channel count             	3'b001 - 2-chans 
wire [2:0] ai_SF_default = 3'd0;     // Sampling Frequency        	3'b011 - 48KHz
wire [1:0] ai_SS_default = 2'd0;     // Bits-per-audio sample     	2'b11  - 24-bit
wire [7:0] ai_CXT_default= 8'd0;     // Audio format type of the audio stream	- Refer to Audio Coding Type (CT) field in Data Byte 1
wire [7:0] ai_CA_default = 8'd0;     // Speaker location allocation FL, FR      - FL, FR
wire [0:0] ai_DM_INH_default=1'd0; 	 // Down-mix inhibit flag                   - Permitted or no information about any assertion of this
wire [3:0] ai_LSV_default = 4'd0;    // Level Shift Information, dB				- 0 dB
wire [1:0] ai_LFEPBL_default = 2'd0; // LFE playback level information, dB		- 0 dB playbacks

wire [7:0] ai_default_sum ={
  {ai_DM_INH_default, ai_LSV_default, 1'b0, ai_LFEPBL_default}+// PB5
  {ai_CA_default}+                             // PB4
  {ai_CXT_default}+                            // PB3
  {3'd0, ai_SF_default, ai_SS_default}+        // PB2
  {ai_CT_default, 1'b0, ai_CC_default}+         // PB1
   8'h84 + 8'h01 + 8'h0a
};		
wire [7:0] ai_default_checksum = 8'd0 - ai_default_sum[7:0];

wire [47:0] ai_default = {
  {ai_DM_INH_default, ai_LSV_default, 1'b0, ai_LFEPBL_default},// PB5
  {ai_CA_default},                             	// PB4
  {ai_CXT_default},                            	// PB3
  {3'd0, ai_SF_default, ai_SS_default},	     	// PB2
  {ai_CT_default, 1'b0, ai_CC_default},        	// PB1
  {ai_default_checksum}                        	// PB0
};			

assign ai_infoframe = ai_default; 									

/******************************************************************************************************/
/*		QD980 AVI InfoFrame
/******************************************************************************************************/
/*								
scan info:                          no data
Bar Info:                           no data
active info:                        no data

RGB/YCC indicator:                  RGB
active format:                      not defined
picture aspect ratio:               no data
colorimetry:                        no data
non-uniform picture scale:          not known
quantization range:                 default (depends on video format)
extended colorimetry:               xvYCC601 Not used if Colorimetry (C) bits are not set to 3
video format:                       VIC=0
IT content:                         no data
IT content Type:                    graphics Not used if IT content bit (IT) bit is set to 0
YCC quantization range:             limited Range  not used if Y bit (Y) bit is set to 0
pixel repetition:                   none

line number of end of top bar:      0
line number of start of bottom bar: 0
pixel number of end of left bar:    0
*/

wire [1:0]  avi_Y_default  = 2'd0; 	// RGB (Default)
wire [1:0]  avi_B_default  = 2'd0; 	// Bar not present
wire [1:0]  avi_S_default  = 2'd0; 	// No Scan Information
wire [0:0]  avi_A0_default = 1'd0; 	// No active Format Information
wire [1:0]  avi_C_default  = 2'd0; 	// Colorimetry (No Data)
wire [1:0]  avi_M_default  = 2'd0; 	// Coded Frme Aspect Ration (No Data)
wire [3:0]  avi_R_default  = 4'd8; 	// Active portion Aspect Ration (Same as coded data aspect ration)
wire [0:0]  avi_ITC_default= 1'd0; 	// IT Content (No data)
wire [2:0]  avi_EC_default = 3'd0; 	// Extended Colorimetry (xvYCC_601)
wire [1:0]  avi_Q_default  = 2'd0; 	// RGB Quantization (Default - depends on video format)
wire [1:0]  avi_SC_default = 2'd0; 	// Non-Uniform Picture Scaling (No Known non-uniform Scaling)
wire [6:0]  avi_VIC_default= 7'd0; 	// Video Identification Code from EDID			 
wire [3:0]  avi_PR_default = 4'd0; 	// Pixel repitition factor (pixel data sent once)
wire [1:0]  avi_CN_default = 2'd0; 	// Content Type
wire [1:0]  avi_YQ_default = 16'd0; // YCC Quantization Range
wire [15:0] avi_ETB_default= 16'd0; // Line Number - End of Top Bar
wire [15:0] avi_SBB_default= 16'd0; // Line Number - Start of Bottom Bar
wire [15:0] avi_ELB_default= 16'd0; // Line Number - End of Left Bar
wire [15:0] avi_SRB_default= 16'd0; // Line Number - Start of Right Bar
wire [7:0]  avi_checksum;		

   wire [7:0] avi_default_sum = {
      {avi_SRB_default[15:8]}+                  // PB13
      {avi_SRB_default[7:0]}+                   // PB12
      {avi_ELB_default[15:8]}+                  // PB11
      {avi_ELB_default[7:0]}+                   // PB10
      {avi_SBB_default[15:8]}+                  // PB9
      {avi_SBB_default[7:0]}+                   // PB8
      {avi_ETB_default[15:8]}+                  // PB7 
      {avi_ETB_default[7:0]}+                   // PB6
      {avi_YQ_default, avi_CN_default, avi_PR_default}+         // PB5
      {1'b0, avi_VIC_default}+                        // PB4
      {avi_ITC_default, avi_EC_default, avi_Q_default, avi_SC_default}+ // PB3
      {avi_C_default,avi_M_default,avi_R_default}+              // PB2
      {1'b0, avi_Y_default,avi_A0_default,avi_B_default,avi_S_default}+
      8'h82 + 8'h02 + 8'h0d // Header
    };
    

wire [7:0] avi_default_checksum = 8'd0-avi_default_sum[7:0];

wire [111:0] avi_default = {
	{avi_SRB_default[15:8]},                  // PB13
	{avi_SRB_default[7:0]},                   // PB12
	{avi_ELB_default[15:8]},                  // PB11
	{avi_ELB_default[7:0]},                   // PB10
	{avi_SBB_default[15:8]},                  // PB9
	{avi_SBB_default[7:0]},                   // PB8
	{avi_ETB_default[15:8]},                  // PB7 
	{avi_ETB_default[7:0]},                   // PB6
	{avi_YQ_default, avi_CN_default, avi_PR_default},        			// PB5
	{1'b0, avi_VIC_default},                        					// PB4
	{avi_ITC_default, avi_EC_default, avi_Q_default, avi_SC_default},	// PB3
	{avi_C_default,avi_M_default,avi_R_default},              			// PB2
	{1'b0, avi_Y_default,avi_A0_default,avi_B_default,avi_S_default}, 	// PB1
	{avi_default_checksum}             									// PB0
};

assign avi_infoframe = avi_default;

/******************************************************************************************************/
/*		QD980 Vendor Specific InfoFrame
/******************************************************************************************************/
/*
24bit IEEE Registration ID:    				HDMI Licensing LLC [0x000c03]
HDMI Video Format:             				extended resolution format
Y420:                          				Not indicated
HDMI VIC:                      				0x03 
HDMI Video Format:             				4K x 2K 23.98/24Hz
*/	

wire [7 :0] vsi_3d_default = 8'd0;
wire [4 :0] vsi_rsvd_default = 5'd0;
wire [23:0] vsi_IEEE_ident_default = 24'h00_0C_03;
wire [2 :0] vsi_VF_default = 3'd0; 				//  vsi_VF   - HDMI Video Format
wire [7 :0] vsi_VIC_default = 8'd0; 			//  vsi_VIC  - HDMI VIC		

    // VSI InfoFrame Fields (default)
wire [7:0] vsi_default_sum = {
          {vsi_3d_default[7:5], 5'd0}+     // PB6
          {vsi_VIC_default}+         // PB5 
          {vsi_VF_default, 5'd0}+      // PB4
          {vsi_IEEE_ident_default[23:16]}+ // PB3  
          {vsi_IEEE_ident_default[15: 8]}+ // PB2  
          {vsi_IEEE_ident_default[ 7: 0]}+
         8'h81 + 8'h01 + 8'h06
};  

wire [7:0] vsi_default_checksum = 8'd0 - vsi_default_sum[7:0];

wire [55:0] vsi_default = {
	 {vsi_3d_default[7:4], 4'd0},        // PB6
	 {1'b0, vsi_VIC_default},            // PB5 
	 {vsi_VF_default, vsi_rsvd_default}, // PB4
	 {vsi_IEEE_ident_default[23:16]},    // PB3  
	 {vsi_IEEE_ident_default[15: 8]},    // PB2  
	 {vsi_IEEE_ident_default[ 7: 0]},	 // PB1
	 {vsi_default_checksum}				 // PB0
};	
	
assign vsi_infoframe = {vsi_default, 5'd6};							

/******************************************************************************************************/
/*		Basic Audio Metadata
/******************************************************************************************************/
wire [0:0] am_3d_audio = (audio_format[3:0] == 4);
wire [1:0] am_num_views = 0;
wire [1:0] am_num_audio_str = chan_count[4:0];

wire [4:0] am_3d_cc = am_3d_audio ? chan_count[4:0] : 5'd0;
assign audio_metadata[4:0] = {am_num_audio_str, am_num_views, am_3d_audio};
assign audio_metadata[9:5] = am_3d_cc;
assign audio_metadata[164:10] = 154'd0;

endmodule







`default_nettype wire

// synthesis translate_off

module bitec_hdmi_audio_gen_tb();

reg clk;
  initial
    clk = 1'b0;
  always
    #10 clk <= ~clk;
    
reg reset;    
  initial 
    begin
      reset <= 1;
      #89 reset <= 0;
    end      

wire [31:0] audio_sample_A; 
wire [31:0] audio_sample_B; 
wire [ 7:0] audio_de; 

wire [19:0] N_audio = 0;

bitec_hdmi_audio_gen #(
  .MAX_AUDIO_CHAN_COUNT (32),
  .VIDEO_CLOCK (148.5)
)
dut
(
	.clk_in    (clk),
	.reset_in  (reset),
  
	.clk_en (),  
	.samp_0 (),
  .clk_1m (),
  .N_audio (), .CTS_audio (),
  .chan_data (),
	
  .ai_infoframe   (),
  .avi_infoframe  (),
  .vsi_infoframe  (),
  .audio_metadata (),
  
	.chan_count   (14),
	.f_samp_N     (400),
	.audio_format (4)
);

endmodule

// synthesis translate_on


