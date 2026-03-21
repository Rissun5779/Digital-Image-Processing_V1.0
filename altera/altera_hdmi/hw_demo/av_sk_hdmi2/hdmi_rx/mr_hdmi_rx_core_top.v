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


module mr_hdmi_rx_core_top #(
    parameter SUPPORT_DEEP_COLOR  = 0,
    parameter SUPPORT_AUXILIARY   = 1,
    parameter SYMBOLS_PER_CLOCK   = 4,
    parameter SUPPORT_AUDIO       = 1
) (
    input  wire                                    reset,
    input  wire [2:0]                              rx_clk,
    input  wire                                    ls_clk,
    input  wire                                    vid_clk,
    input  wire                                    os,
    input  wire [3*SYMBOLS_PER_CLOCK*10-1:0]       rx_parallel_data,
    input  wire [2:0]                              rx_datalock,
    output wire                                    audio_de,
    output wire [255:0]                            audio_data,
    output wire [47:0]                             audio_info_ai,   
    output wire [19:0]                             audio_N,
    output wire [19:0]                             audio_CTS,
    output wire [164:0]                            audio_metadata,
    output wire [4:0]                              audio_format,
    output wire [5:0]                              gcp,
    output wire [111:0]                            info_avi,
    output wire [60 :0]                            info_vsi,
    output wire [2:0]                              locked,
    output wire [71:0]                             aux_data,
    output wire                                    aux_sop,
    output wire                                    aux_eop,
    output wire                                    aux_valid,
    output wire [71:0]                             aux_pkt_data,
    output wire [6:0]                              aux_pkt_addr,
    output wire                                    aux_pkt_wr,
    output wire                                    aux_error,
    output wire [SYMBOLS_PER_CLOCK*48-1:0]         vid_data,
    output wire [SYMBOLS_PER_CLOCK-1:0]            vid_vsync,
    output wire [SYMBOLS_PER_CLOCK-1:0]            vid_hsync,
    output wire [SYMBOLS_PER_CLOCK-1:0]            vid_de,
    output wire                                    vid_lock,
    input  wire                                    in_5v_power,
    input  wire                                    in_hpd,
    output wire                                    mode,
    output wire [SYMBOLS_PER_CLOCK*6-1:0]          ctrl,
    input  wire                                    scdc_i2c_clk,
    input  wire [7:0]                              scdc_i2c_addr,
    output wire [7:0]                              scdc_i2c_rdata,
    input  wire [7:0]                              scdc_i2c_wdata,
    input  wire                                    scdc_i2c_r,
    input  wire                                    scdc_i2c_w,
    output wire                                    TMDS_Bit_clock_Ratio
);

genvar i;
wire [2:0] rx_clk_rst_sync;
generate
    for (i=0; i<3; i=i+1) begin: RX_CLK_RST_SYNCHRONIZER
        altera_reset_controller #(
            .NUM_RESET_INPUTS (1),
            .SYNC_DEPTH (3)				
        ) u_rx_clk_rst_sync (
            .reset_in0 (reset),
            .clk (rx_clk[i]),
            .reset_out (rx_clk_rst_sync[i])
        );
    end 
endgenerate
   
wire [3*SYMBOLS_PER_CLOCK*10-1:0] rx_oversample_out;       // 3*20
wire [2:0]                        rx_oversample_out_valid; // 3*1
wire [2:0]                        rx_fifo_wrreq;           // 3*1
wire [3*SYMBOLS_PER_CLOCK*10-1:0] rx_fifo_in;              // 3*20
wire [3*SYMBOLS_PER_CLOCK*10-1:0] rx_fifo_out;             // 3*20   
wire [SYMBOLS_PER_CLOCK*10-1:0]   in_r;
wire [SYMBOLS_PER_CLOCK*10-1:0]   in_g;
wire [SYMBOLS_PER_CLOCK*10-1:0]   in_b;       
generate
    for (i=0; i<3; i=i+1) begin: RX_OVERSAMPLE   
        mr_rx_oversample #(
            .DIN_WIDTH (SYMBOLS_PER_CLOCK*10),
            .DOUT_WIDTH (SYMBOLS_PER_CLOCK*10),
            .SAMPLE_INTERVAL (5),
            .SAMPLE_MASK (5'b00100)		   
        ) u_rx_os (
            .clk (rx_clk[i]),
            .rst (rx_clk_rst_sync[i]),
            .din (rx_parallel_data[(i*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(i*SYMBOLS_PER_CLOCK*10)]),
            .dout (rx_oversample_out[(i*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(i*SYMBOLS_PER_CLOCK*10)]),
            .dout_valid (rx_oversample_out_valid[i])       
        );
    end
endgenerate

wire ls_clk_rst_sync;
altera_reset_controller #(
    .NUM_RESET_INPUTS (2),
    .SYNC_DEPTH (3)			  
) u_ls_clk_rst_sync (
    .reset_in0 (reset),
    .reset_in1 ({~(&rx_datalock)}),
    .clk (ls_clk),
    .reset_out (ls_clk_rst_sync)
);
   
assign rx_fifo_in = os ? rx_oversample_out : rx_parallel_data;
assign rx_fifo_wrreq = os ? rx_oversample_out_valid : 3'b111;
   
generate
    for (i=0; i<3; i=i+1) begin: RX_DCFIFO   
        mr_clock_sync #(
            .DEVICE_FAMILY ("Arria V")
        ) u_rx_clock_sync (
            .wrclk (rx_clk[i]),
            .rdclk (ls_clk),
            .aclr (ls_clk_rst_sync), 
            .wrreq (rx_fifo_wrreq[i]),
            .data (rx_fifo_in[(i*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(i*SYMBOLS_PER_CLOCK*10)]),
            .rdreq (1'b1),
            .q (rx_fifo_out[(i*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(i*SYMBOLS_PER_CLOCK*10)])		      
        );
    end
endgenerate

assign in_b = rx_fifo_out[(0*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(0*SYMBOLS_PER_CLOCK*10)];
assign in_g = rx_fifo_out[(1*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(1*SYMBOLS_PER_CLOCK*10)];
assign in_r = rx_fifo_out[(2*SYMBOLS_PER_CLOCK*10+SYMBOLS_PER_CLOCK*10-1):(2*SYMBOLS_PER_CLOCK*10)];

hdmi_rx u_bitec_hdmi_rx (
    .reset (reset),
    .vid_clk (vid_clk),
    .in_b (in_b), 
    .in_g (in_g), 
    .in_r (in_r), 
    .in_lock (rx_datalock[2:0]),
    .ls_clk ({ls_clk, ls_clk, ls_clk}),
    .audio_de (audio_de),
    .audio_data (audio_data),
    .audio_info_ai (audio_info_ai),
    .audio_N (audio_N),
    .audio_CTS (audio_CTS),
    .audio_metadata (audio_metadata),
    .audio_format (audio_format), 
    .gcp (gcp),
    .info_avi (info_avi),
    .info_vsi (info_vsi),
    .locked (locked),
    .aux_data (aux_data),
    .aux_sop (aux_sop),
    .aux_eop (aux_eop),
    .aux_valid (aux_valid),
    .aux_pkt_data (aux_pkt_data),
    .aux_pkt_addr (aux_pkt_addr),
    .aux_pkt_wr (aux_pkt_wr),
     .aux_error (aux_error),
    .vid_data (vid_data),
    .vid_de (vid_de),
    .vid_hsync (vid_hsync),
    .vid_vsync (vid_vsync),
    .vid_lock (vid_lock),
    .scdc_i2c_clk (scdc_i2c_clk),
    .scdc_i2c_addr (scdc_i2c_addr),
    .scdc_i2c_rdata (scdc_i2c_rdata),
    .scdc_i2c_wdata (scdc_i2c_wdata),
    .scdc_i2c_r (scdc_i2c_r),
    .scdc_i2c_w (scdc_i2c_w),
    .TMDS_Bit_clock_Ratio (TMDS_Bit_clock_Ratio),
    .mode (mode),
    .ctrl (ctrl),
    .in_5v_power (in_5v_power),
    .in_hpd (in_hpd)
);
   
endmodule			
