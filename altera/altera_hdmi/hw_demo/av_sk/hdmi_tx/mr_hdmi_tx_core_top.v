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


module mr_hdmi_tx_core_top #(
    parameter SUPPORT_DEEP_COLOR  = 0,
    parameter SUPPORT_AUXILIARY   = 1,
    parameter SYMBOLS_PER_CLOCK   = 2,
    parameter SUPPORT_AUDIO       = 1
) (
    input  wire                                    reset,
    input  wire                                    vid_clk, 
    input  wire                                    ls_clk,
    input  wire                                    tx_clk,
    input  wire                                    os,   
    input  wire                                    mode,
    input  wire [6*SYMBOLS_PER_CLOCK-1:0]          ctrl,
    input  wire                                    audio_clk,
    input  wire                                    audio_de,
    input  wire                                    audio_mute,
    input  wire [19:0]                             audio_CTS,
    input  wire [255:0]                            audio_data,   
    input  wire [48:0]                             audio_info_ai,
    input  wire [19:0]                             audio_N,
    input  wire [165:0]                            audio_metadata,
    input  wire [4:0]                              audio_format,
    input  wire [5:0]                              gcp,
    input  wire [112:0]                            info_avi,
    input  wire [61:0]                             info_vsi,
    output wire                                    aux_ready,
    input  wire [71:0]                             aux_data,
    input  wire                                    aux_sop,
    input  wire                                    aux_eop,
    input  wire                                    aux_valid,
    input  wire [48*SYMBOLS_PER_CLOCK-1:0]         vid_data,
    input  wire [1*SYMBOLS_PER_CLOCK-1:0]          vid_vsync, 
    input  wire [1*SYMBOLS_PER_CLOCK-1:0]          vid_hsync,
    input  wire [1*SYMBOLS_PER_CLOCK-1:0]          vid_de,
    output wire [4*SYMBOLS_PER_CLOCK*10-1:0]       tx_parallel_data,
    input  wire                                    Scrambler_Enable,
    input  wire                                    TMDS_Bit_clock_Ratio
);

genvar i;
//wire ls_clk_rst_sync;
//altera_reset_controller #(
//    .NUM_RESET_INPUTS (1),
//    .SYNC_DEPTH (3)			  
//) u_ls_clk_rst_sync (
//    .reset_in0 (reset),
//    .clk (ls_clk),
//    .reset_out (ls_clk_rst_sync)
//);

wire os_sync;
altera_std_synchronizer #(
   .depth(3)
) u_os_sync (
   .clk(tx_clk),
   .reset_n(1'b1),
   .din(os),
   .dout(os_sync)
);

wire [SYMBOLS_PER_CLOCK*10-1:0] out_b;
wire [SYMBOLS_PER_CLOCK*10-1:0] out_c;
wire [SYMBOLS_PER_CLOCK*10-1:0] out_g;
wire [SYMBOLS_PER_CLOCK*10-1:0] out_r;
hdmi_tx u_bitec_hdmi_tx (
    .reset (reset),
    .vid_clk (vid_clk), 
    .ls_clk (ls_clk),
    .mode (mode),
    .ctrl (ctrl),	 
    .audio_clk (audio_clk),
    .audio_de (audio_de),
    .audio_mute (audio_mute),
    .audio_CTS (audio_CTS),
    .audio_data (audio_data),
    .audio_info_ai (audio_info_ai),
    .audio_N (audio_N),
    .audio_metadata (audio_metadata),
    .audio_format (audio_format),
    .gcp (gcp),
    .info_avi (info_avi),
    .info_vsi (info_vsi),
    .aux_data (aux_data),
    .aux_sop (aux_sop),
    .aux_eop (aux_eop),
    .aux_valid (aux_valid),
    .aux_ready (aux_ready),
    .vid_data (vid_data), 
    .vid_de (vid_de), 
    .vid_hsync (vid_hsync),
    .vid_vsync (vid_vsync),
    .out_b (out_b),
    .out_c (out_c),
    .out_g (out_g),
    .out_r (out_r),
    .Scrambler_Enable(Scrambler_Enable),
    .TMDS_Bit_clock_Ratio(TMDS_Bit_clock_Ratio)
);

wire [4*SYMBOLS_PER_CLOCK*10-1:0] tx_core_out;       // 4*20
wire [4*SYMBOLS_PER_CLOCK*10-1:0] tx_fifo_out;       // 4*20
wire [4*SYMBOLS_PER_CLOCK*10-1:0] tx_oversample_out; // 4*20
wire                              tx_data_valid;
wire                              tx_data_valid_r;
wire                              tx_fifo_rdreq;
   
assign tx_core_out = {out_r, out_g, out_b, out_c};
assign tx_fifo_rdreq = os_sync ? tx_data_valid : 1'b1;

wire tx_clk0_rst_sync;
altera_reset_controller #(
    .NUM_RESET_INPUTS (1),
    .SYNC_DEPTH (3)			  
) u_tx_clk0_rst_sync (
    .reset_in0 (reset),
    .clk (tx_clk),
    .reset_out (tx_clk0_rst_sync)
);
  
generate
    for (i=0; i<4; i=i+1) begin: TX_DCFIFO   
        mr_clock_sync #(
            .DEVICE_FAMILY ("Arria V")
        ) u_tx_clock_sync (
            .wrclk (ls_clk),
            .rdclk (tx_clk),
            .aclr (tx_clk0_rst_sync), 
            .wrreq (1'b1),
            .data (tx_core_out[(i*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(i*SYMBOLS_PER_CLOCK*10)]),
            .rdreq (tx_fifo_rdreq),
            .q (tx_fifo_out[(i*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(i*SYMBOLS_PER_CLOCK*10)])		      
        );
    end
endgenerate

generate
    for (i=0; i<4; i=i+1) begin: TX_OVERSAMPLE   
        mr_tx_oversample #(
            .OVERSAMPLE_RATE (5),
            .DATA_WIDTH (SYMBOLS_PER_CLOCK*10)		   
        ) u_tx_os (
            .clk (tx_clk),
            .rst (tx_clk0_rst_sync), 
            .din (tx_fifo_out[(i*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(i*SYMBOLS_PER_CLOCK*10)]),
            .din_valid (tx_data_valid_r),
            .dout (tx_oversample_out[(i*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(i*SYMBOLS_PER_CLOCK*10)])		       
        );
    end
endgenerate
   
mr_ce u_ce (
    .clk (tx_clk),
    .rst (tx_clk0_rst_sync), 
    .txdata_valid (tx_data_valid),
    .txdata_valid_r (tx_data_valid_r)	
);

assign tx_parallel_data = os_sync ? tx_oversample_out : tx_fifo_out;
   
endmodule   
