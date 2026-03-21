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
// DisplayPort IP Example
// 
// Description
//
// This is a simple example which instantiates the altera_dp core and
// IP for reconfiguring the transceivers. This includes the following:
//   * XCVR reconfiguration IP
//   * XCVR PHY IP (TX/RX)
// 
// *********************************************************************


// synthesis translate_off
`timescale 1ns / 1ns
// synthesis translate_on
`default_nettype none

module sv_dp_example # (
    parameter LANES = 4,
    parameter TX_SYMBOLS_PER_CLOCK = 2,
    parameter RX_SYMBOLS_PER_CLOCK = 2,
    parameter TX_POLINV = 0,
    parameter RX_POLINV = 0			
)(
    // top-level clocks & reset
    input  wire         clk,                    // 100 MHz clock for the Avalon-MM domain
    input  wire         reset,
    input  wire [8:0]   tx_mgmt_address, 
    input  wire         tx_mgmt_chipselect,
    input  wire         tx_mgmt_read,
    input  wire         tx_mgmt_write,
    input  wire [31:0]  tx_mgmt_writedata,
    output wire [31:0]  tx_mgmt_readdata,
    output wire         tx_mgmt_waitrequest,
    output wire         tx_mgmt_irq,
    input  wire         xcvr_mgmt_clk,          // 100 MHz required for the XCVR mgmt clock
    input  wire [1:0]   xcvr_refclk,            // 162 MHz and 270 MHz required reference clocks
    output wire [3:0]   tx_serial_data,
    input  wire [3:0]   rx_serial_data,
    input  wire         tx_vid_clk,             // 120 MHz used in this example
    input  wire         tx_vid_v_sync,        
    input  wire         tx_vid_h_sync,        
//    input  wire         tx_vid_f,             
    input  wire         tx_vid_de,            
    input  wire [23:0]  tx_vid_data,          

    // RX Video Output adapted to talk to CVI Video Input
    input  wire         rx_vid_clk,             // 110 MHz uased in this example
    output wire         rx_cvi_datavalid,         
    output wire         rx_cvi_f,         
    output reg          rx_cvi_h_sync,           
    output reg          rx_cvi_v_sync,           
    output wire         rx_cvi_locked,        
    output wire         rx_cvi_de,        
    output wire [23:0]  rx_cvi_data,          
    input  wire         aux_clk,                // 16 MHz required
    input  wire         aux_reset,            
    input  wire         tx_aux_in,            
    output wire         tx_aux_out,          
    output wire         tx_aux_oe,           
    input  wire         tx_hpd,              
    input  wire         rx_aux_in,           
    output wire         rx_aux_out,          
    output wire         rx_aux_oe,           
    output wire         rx_hpd             
);

    // Wires to connect the DisplayPort core to the reconfiguration FSM
    wire         tx_reconfig_req;
    wire         tx_reconfig_ack;
    wire         tx_reconfig_busy;
    wire [1:0]   tx_link_rate;
    wire         tx_analog_reconfig_req;
    wire         tx_analog_reconfig_ack;
    wire         tx_analog_reconfig_busy;
    wire [7:0]   tx_vod;
    wire [7:0]   tx_emp;
    wire         rx_reconfig_req;
    wire         rx_reconfig_ack;
    wire         rx_reconfig_busy;
    wire [1:0]   rx_link_rate;

    // Wires to connect the XCVR reconfig MF to the DisplayPort core
    wire [839:0] reconfig_to_xcvr;
    wire [551:0] reconfig_from_xcvr;

    // Wires to connect the DisplayPort core to the EDID memory
    // Current simulation example does not exercise EDID memory
    // so leaving unconnected.
    wire [7:0]   rx_edid_address;
    wire [7:0]   rx_edid_readdata;
    wire [7:0]   rx_edid_writedata;
    wire         rx_edid_read;
    wire         rx_edid_write;
    wire         rx_edid_waitrequest;

    // Connections from the reconfig management FSM to the XCVR reconfig IP
    wire	 mgmt_waitrequest;
    wire [6:0]	 mgmt_address;
    wire [31:0]	 mgmt_writedata;
    wire	 mgmt_write;
    wire	 reconfig_busy;

    // Connections from the DP RX to the CVI
    wire rx_vid_valid;
    wire rx_vid_sol;
    wire rx_vid_eol;
    wire rx_vid_sof;
    wire rx_vid_eof;
    wire rx_vid_locked;
    wire [23:0] rx_vid_data;

    // Connections between DP and PHY
    wire [LANES*10*TX_SYMBOLS_PER_CLOCK-1:0] tx_parallel_data;
    wire             tx_pll_powerdown;
    wire [LANES-1:0] tx_analogreset;
    wire [LANES-1:0] tx_digitalreset;
    wire [LANES-1:0] tx_cal_busy;
    wire [LANES-1:0] tx_std_clkout;
    wire             tx_pll_locked;
    wire [LANES*10*RX_SYMBOLS_PER_CLOCK-1:0] rx_parallel_data;
    wire [LANES-1:0] rx_std_clkout;
    wire [LANES-1:0] rx_is_lockedtoref;
    wire [LANES-1:0] rx_is_lockedtodata;
    wire [LANES-1:0] rx_bitslip;
    wire [LANES-1:0] rx_cal_busy;
    wire [LANES-1:0] rx_analogreset;
    wire [LANES-1:0] rx_digitalreset;
    wire [LANES-1:0] rx_set_locktoref;
    wire [LANES-1:0] rx_set_locktodata;
   
    // datavalid and f inputs are constant
    assign rx_cvi_datavalid = 1'b1;	// Data is not oversampled
    assign rx_cvi_f         = 1'b0;	// Video is progressive

    // CVI v sync, h sync and datavalid are derived from 
    // delayed versions of eol and eof signals
    always @ (posedge rx_vid_clk)
    begin
        rx_cvi_h_sync <= rx_vid_eol;
        rx_cvi_v_sync <= rx_vid_eof;
    end

    reg clk_cal;
    always @ (posedge xcvr_mgmt_clk or posedge reset)
    begin
        if (reset) begin
           clk_cal <= 1'b0;
        end else begin
           clk_cal <= ~clk_cal;
        end
    end

    // Just connect the locked, de (data-enable) and data signals
    assign rx_cvi_locked = rx_vid_locked;
    assign rx_cvi_de	 = rx_vid_valid;
    assign rx_cvi_data	 = rx_vid_data;

    // Instantiate the DisplayPort core
    sv_dp u0 (
        .reset(reset),
        .clk(clk),
        .tx_mgmt_address(tx_mgmt_address),
        .tx_mgmt_chipselect(tx_mgmt_chipselect),
        .tx_mgmt_read(tx_mgmt_read),       
        .tx_mgmt_write(tx_mgmt_write),     
        .tx_mgmt_writedata(tx_mgmt_writedata),
        .tx_mgmt_readdata(tx_mgmt_readdata),   
        .tx_mgmt_waitrequest(tx_mgmt_waitrequest),
        .tx_mgmt_irq(tx_mgmt_irq),   
        .xcvr_mgmt_clk(xcvr_mgmt_clk),  
        .clk_cal(clk_cal),  
        //.xcvr_refclk(xcvr_refclk),      
        //.tx_serial_data(tx_serial_data),
        //.rx_serial_data(rx_serial_data),
        .tx_parallel_data(tx_parallel_data),
        .tx_pll_powerdown(tx_pll_powerdown),
        .tx_analogreset(tx_analogreset),
        .tx_digitalreset(tx_digitalreset),
        .tx_cal_busy(tx_cal_busy),
        .tx_std_clkout(tx_std_clkout),
        .tx_pll_locked(tx_pll_locked),
        .rx_parallel_data(rx_parallel_data),
        .rx_std_clkout(rx_std_clkout),
        .rx_is_lockedtoref(rx_is_lockedtoref),
        .rx_is_lockedtodata(rx_is_lockedtodata),
        .rx_bitslip(rx_bitslip),
        .rx_cal_busy(rx_cal_busy),
        .rx_analogreset(rx_analogreset),
        .rx_digitalreset(rx_digitalreset),
        .rx_set_locktoref(rx_set_locktoref),
        .rx_set_locktodata(rx_set_locktodata),	      
        .tx_reconfig_req(tx_reconfig_req),
        .tx_reconfig_ack(tx_reconfig_ack), 
        .tx_reconfig_busy(tx_reconfig_busy),
        .tx_link_rate(tx_link_rate),        
        .tx_analog_reconfig_req(tx_analog_reconfig_req),
        .tx_analog_reconfig_ack(tx_analog_reconfig_ack), 
        .tx_analog_reconfig_busy(tx_analog_reconfig_busy),
        .tx_vod(tx_vod),                 
        .tx_emp(tx_emp),                 
        .rx_reconfig_req(rx_reconfig_req),
        .rx_reconfig_ack(rx_reconfig_ack),
        .rx_reconfig_busy(rx_reconfig_busy),
        .rx_link_rate(rx_link_rate),        
        //.reconfig_to_xcvr(reconfig_to_xcvr),
        //.reconfig_from_xcvr(reconfig_from_xcvr),
        .tx_vid_clk(tx_vid_clk),             
        .tx_vid_v_sync(tx_vid_v_sync),       
        .tx_vid_h_sync(tx_vid_h_sync),       
//        .tx_vid_f(tx_vid_f),               
        .tx_vid_de(tx_vid_de),             
        .tx_vid_data(tx_vid_data),         
        .rx_vid_clk(rx_vid_clk),           
        .rx_vid_valid(rx_vid_valid),       
        .rx_vid_sol(rx_vid_sol),           
        .rx_vid_eol(rx_vid_eol),           
        .rx_vid_sof(rx_vid_sof),           
        .rx_vid_eof(rx_vid_eof),           
        .rx_vid_locked(rx_vid_locked),            
        .rx_vid_data(rx_vid_data),         
        .aux_clk(aux_clk),                 
        .aux_reset(aux_reset),             
        .tx_aux_in(tx_aux_in),             
        .tx_aux_out(tx_aux_out),           
        .tx_aux_oe(tx_aux_oe),             
        .tx_hpd(tx_hpd),                 
        .rx_aux_in(rx_aux_in),           
        .rx_aux_out(rx_aux_out),         
        .rx_aux_oe(rx_aux_oe),           
        .rx_hpd(rx_hpd),                 
        .rx_cable_detect(1'b1),
        .rx_pwr_detect(1'b1),
        .rx_edid_address(rx_edid_address),
        .rx_edid_readdata(rx_edid_readdata),
        .rx_edid_writedata(rx_edid_writedata),
        .rx_edid_read(rx_edid_read),          
        .rx_edid_write(rx_edid_write),        
        .rx_edid_waitrequest(rx_edid_waitrequest),
        .rx_lane_count(),          
        .rx_stream_data(),                
        .rx_stream_ctrl(),                
        .rx_stream_valid(),                
        .rx_stream_clk()        
    );

    localparam RECONFIG_TO_XCVR_RX_OFFSET   = LANES*70;
    localparam RECONFIG_FROM_XCVR_RX_OFFSET = LANES*46;
    
    // Instantiate the TX PHY IP   
    genvar i;
    generate begin
        for (i = 0; i < LANES; i = i + 1) begin : TX_PHY_GEN
            sv_native_phy_tx u_tx_phy (
                .pll_powerdown(tx_pll_powerdown),
                .tx_analogreset(tx_analogreset[i]),
                .tx_digitalreset(tx_digitalreset[i]),
                .tx_pll_refclk(xcvr_refclk),  
                .tx_serial_data(tx_serial_data[i]), 
                .pll_locked(tx_pll_locked),
                .tx_std_coreclkin(tx_std_clkout[0]),	
                .tx_std_clkout(tx_std_clkout[i]),
                .tx_std_polinv((TX_POLINV==1)),
                .tx_cal_busy(tx_cal_busy[i]),
                .reconfig_to_xcvr({reconfig_to_xcvr[(RECONFIG_TO_XCVR_RX_OFFSET + (LANES*70) + (70*i)) +: 70], reconfig_to_xcvr[(RECONFIG_TO_XCVR_RX_OFFSET + (70*i)) +: 70]}),
                .reconfig_from_xcvr({reconfig_from_xcvr[(RECONFIG_FROM_XCVR_RX_OFFSET + (LANES*46) + (46*i)) +: 46], reconfig_from_xcvr[(RECONFIG_FROM_XCVR_RX_OFFSET + (46*i)) +: 46]}),
                .tx_parallel_data(tx_parallel_data[10*TX_SYMBOLS_PER_CLOCK*i +: 10*TX_SYMBOLS_PER_CLOCK]),
                .unused_tx_parallel_data()		
            );
        end
    end
    endgenerate
   
    // Instantiate the RX PHY IP
    generate begin
        for (i = 0; i < LANES; i = i + 1) begin : RX_PHY_GEN
            sv_native_phy_rx u_rx_phy (
                .rx_analogreset(rx_analogreset[i]),
                .rx_digitalreset(rx_digitalreset[i]),
                .rx_cdr_refclk(xcvr_refclk),  
                .rx_serial_data(rx_serial_data[i]), 
                .rx_set_locktoref(rx_set_locktoref[i]),
                .rx_set_locktodata(rx_set_locktodata[i]),
                .rx_is_lockedtoref(rx_is_lockedtoref[i]),
                .rx_is_lockedtodata(rx_is_lockedtodata[i]),
                .rx_std_coreclkin(rx_std_clkout[i]),
                .rx_std_clkout(rx_std_clkout[i]),
                .rx_std_bitslip(rx_bitslip[i]),
                .rx_std_polinv((RX_POLINV==1)),
                .rx_cal_busy(rx_cal_busy[i]),
                .reconfig_to_xcvr(reconfig_to_xcvr[70*i +: 70]),
                .reconfig_from_xcvr(reconfig_from_xcvr[46*i +: 46]),
                .rx_parallel_data(rx_parallel_data[10*RX_SYMBOLS_PER_CLOCK*i +: 10*RX_SYMBOLS_PER_CLOCK]),
                .unused_rx_parallel_data()		
            );
        end
    end
    endgenerate
   
    // Instantiate the reconfig management FSM
    reconfig_mgmt_hw_ctrl #(
        .DEVICE_FAMILY("Stratix V"),
        .RX_LANES(LANES),
        .TX_LANES(LANES),
        .TX_PLLS(LANES)
    ) mgmt (
        .clk(clk),
        .reset(reset),
        .rx_reconfig_req(rx_reconfig_req),
        .rx_link_rate(rx_link_rate), 
        .rx_reconfig_ack(rx_reconfig_ack),
        .rx_reconfig_busy(rx_reconfig_busy),
        .tx_reconfig_req(tx_reconfig_req),
        .tx_link_rate(tx_link_rate), 
        .tx_reconfig_ack(tx_reconfig_ack),
        .tx_reconfig_busy(tx_reconfig_busy),
        .tx_analog_reconfig_req(tx_analog_reconfig_req),
        .vod(tx_vod),
        .emp(tx_emp),	
        .tx_analog_reconfig_ack(tx_analog_reconfig_ack),
        .tx_analog_reconfig_busy(tx_analog_reconfig_busy),
        .mgmt_address(mgmt_address),		
        .mgmt_writedata(mgmt_writedata),	
        .mgmt_write(mgmt_write),				
        .mgmt_waitrequest(mgmt_waitrequest),		
        .reconfig_busy(reconfig_busy)			
    );

    // Instantiate the XCVR reconfig IP
    sv_xcvr_reconfig reconfig (
        .reconfig_busy(reconfig_busy),            
        .mgmt_clk_clk(clk),              
        .mgmt_rst_reset(reset),           
        .reconfig_mgmt_address(mgmt_address),
        .reconfig_mgmt_read(1'b0),                      // Unused
        .reconfig_mgmt_readdata(),                      // Unused
        .reconfig_mgmt_waitrequest(mgmt_waitrequest),
        .reconfig_mgmt_write(mgmt_write),     
        .reconfig_mgmt_writedata(mgmt_writedata),  
        .reconfig_mif_address(),                        // Unused -- using MIF mode 1 direct write
        .reconfig_mif_read(),                           // Unused
        .reconfig_mif_readdata(16'h00),                 // Unused
        .reconfig_mif_waitrequest(1'b0),                // Unused
        .reconfig_to_xcvr(reconfig_to_xcvr),         
        .reconfig_from_xcvr(reconfig_from_xcvr)        
    );

endmodule

`default_nettype wire
