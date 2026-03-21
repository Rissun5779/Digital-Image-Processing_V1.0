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


// $Id: //acds/rel/18.1std/ip/pgm/altera_s10_mailbox_client/altera_s10_mailbox_client_core.sv#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $
// $Author: psgswbuild $


`timescale 1 ns / 1 ns
module altera_s10_mailbox_client_core #(
        parameter CMD_FIFO_DEPTH            = 0,
        parameter URG_FIFO_DEPTH            = 0,
        parameter RSP_FIFO_DEPTH            = 0,
        parameter CMD_USE_MEMORY_BLOCKS     = 0,
        parameter URG_USE_MEMORY_BLOCKS     = 0,
        parameter RSP_USE_MEMORY_BLOCKS     = 0,
        parameter HAS_URGENT            = 0,
        parameter HAS_STREAM            = 0,
        parameter STREAM_WIDTH            = 0,
        parameter HAS_OFFLOAD           = 0
    ) (
        input               clk,
        input               reset,
        
        input               command_ready,
        output logic        command_valid,
        output logic [31:0] command_data,
        output logic        command_startofpacket,
        output logic        command_endofpacket,
        
        output logic        response_ready,
        input               response_valid,
        input [31:0]        response_data,
        input               response_startofpacket,
        input               response_endofpacket,

        input               urgent_ready,
        output logic        urgent_valid,
        output logic [31:0] urgent_data,
        
        input [3:0]         avmm_address,
        input               avmm_write,
        input [31:0]        avmm_writedata,
        input               avmm_read,
        output logic [31:0] avmm_readdata,
        output logic        avmm_readdatavalid,
        
        output logic        irq
    );

    logic                   sop_enable;
    logic [31:0]            cmd_in_data_fifo;
    logic                   cmd_in_valid_fifo;
    logic                   cmd_in_ready_fifo;
    logic                   cmd_in_sop_fifo;
    logic                   cmd_in_eop_fifo;

    logic [31:0]            urg_in_data_fifo;
    logic                   urg_in_valid_fifo;
    logic                   urg_in_ready_fifo;

    logic [31:0]            out_data_fifo;
    logic                   out_valid_fifo;
    logic                   out_ready_fifo;
    logic                   out_sop_fifo;
    logic                   out_eop_fifo;

    logic [31:0]            urg_data_fifo;
    logic                   urg_valid_fifo;
    logic                   urg_ready_fifo;

    logic [31:0]            rsp_fifo_out_data;
    logic [31:0]            rsp_fifo_out_data_dly;
    logic                   rsp_fifo_out_valid;
    logic                   rsp_fifo_out_ready;
    logic                   rsp_fifo_out_sop;
    logic                   rsp_fifo_out_eop;
    logic [31:0]            cmd_fifo_fill_level;
    logic [31:0]            urg_fifo_fill_level;
    logic [31:0]            rsp_fifo_fill_level;
    
    logic                   cmd_data_addr;
    logic                   cmd_eop_addr;
    logic                   urg_cmd_addr;
    logic                   cmd_fifo_info_addr;
    logic                   urg_fifo_info_addr;
    logic                   rsp_data_addr;
    logic                   rsp_fifo_info_addr;
    logic                   ier_addr;
    logic                   isr_addr;
    logic                   cmd_data_wr;
    logic                   cmd_eop_wr;
    logic                   urg_cmd_wr;
    logic                   ier_wr;
    logic                   cmd_fifo_info_rd;
    logic                   urg_fifo_info_rd;
    logic                   rsp_data_rd;
    logic                   rsp_fifo_info_rd;
    logic                   ier_rd;
    logic                   isr_rd;

    // +--------------------------------------------------
    // | Address decoder:
    // | cmd_fifo: the empty space inside the cmd fifo
    // | rsp_info: the fill level inside rsp fifo and
    // |           two bits: sop and eop of the packet
    // +--------------------------------------------------
    assign cmd_data_addr       = (avmm_address == 4'h0);
    assign cmd_eop_addr        = (avmm_address == 4'h1);
    assign cmd_fifo_info_addr  = (avmm_address == 4'h2);
    assign urg_cmd_addr        = (avmm_address == 4'h3);
    assign urg_fifo_info_addr  = (avmm_address == 4'h4);
    assign rsp_data_addr       = (avmm_address == 4'h5);
    assign rsp_fifo_info_addr  = (avmm_address == 4'h6);
    assign ier_addr            = (avmm_address == 4'h7);
    assign isr_addr            = (avmm_address == 4'h8);
    
    // +--------------------------------------------------
    // | Write enable
    // +--------------------------------------------------
    assign cmd_data_wr = cmd_data_addr & avmm_write;
    assign cmd_eop_wr  = cmd_eop_addr  & avmm_write;
    assign urg_cmd_wr  = urg_cmd_addr  & avmm_write;
    assign ier_wr      = ier_addr      & avmm_write;

    // +--------------------------------------------------
    // | Read enable
    // +--------------------------------------------------
    assign cmd_fifo_info_rd = cmd_fifo_info_addr & avmm_read;
    assign urg_fifo_info_rd = urg_fifo_info_addr & avmm_read;
    assign rsp_data_rd      = rsp_data_addr      & avmm_read;
    assign rsp_fifo_info_rd = rsp_fifo_info_addr & avmm_read;
    assign ier_rd           = ier_addr           & avmm_read;
    assign isr_rd           = isr_addr           & avmm_read;

    // +--------------------------------------------------
    // | SOP generator
    // +--------------------------------------------------
      always @(posedge clk) begin
         if (reset) begin
            sop_enable <= 1'b1;
         end
         else begin
            if (cmd_data_wr) 
               sop_enable <= 1'b0;
            if (cmd_eop_wr)
                sop_enable <= 1'b1;
         end
      end

    // +--------------------------------------------------
    // | Internal command FIFO control signals
    // +--------------------------------------------------
    assign cmd_in_data_fifo     = avmm_writedata;
    // only write when read is high, when fifo empty discard the value
    assign cmd_in_valid_fifo    = (cmd_data_wr | cmd_eop_wr) & cmd_in_ready_fifo;
    assign cmd_in_sop_fifo      = sop_enable;
    assign cmd_in_eop_fifo      = cmd_eop_wr;
    logic [31:0]        cmd_fifo_depth;
    logic [31:0]        cmd_fifo_empty_space;
    logic [31:0]        urg_fifo_depth;
    logic [31:0]        urg_fifo_empty_space;
    assign cmd_fifo_depth       = CMD_FIFO_DEPTH[31:0];
    assign cmd_fifo_empty_space = cmd_fifo_depth - cmd_fifo_fill_level;
    assign urg_in_valid_fifo = urg_cmd_wr & urg_in_ready_fifo;
    assign urg_fifo_depth       = URG_FIFO_DEPTH[31:0];
    assign urg_fifo_empty_space = urg_fifo_depth - urg_fifo_fill_level;

    // +--------------------------------------------------
    // | Internal FIFO for imcomming command packet
    // +--------------------------------------------------
    cmd_sc_fifo 
    #(
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (32),
        .FIFO_DEPTH          (CMD_FIFO_DEPTH),
        .CHANNEL_WIDTH       (0),
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (1),
        .USE_FILL_LEVEL      (1),
        .EMPTY_LATENCY       (1),
        .USE_MEMORY_BLOCKS   (CMD_USE_MEMORY_BLOCKS),
        .USE_STORE_FORWARD   (0),
        .USE_ALMOST_FULL_IF  (0),
        .USE_ALMOST_EMPTY_IF (0)
    ) cmd_fifo 
    (
    .clk               (clk),
    .reset             (reset),
    .in_data           (cmd_in_data_fifo),
    .in_valid          (cmd_in_valid_fifo),
    .in_ready          (cmd_in_ready_fifo),
    .in_startofpacket  (cmd_in_sop_fifo),
    .in_endofpacket    (cmd_in_eop_fifo),
    .out_data          (out_data_fifo),
    .out_valid         (out_valid_fifo),
    .out_ready         (out_ready_fifo),
    .out_startofpacket (out_sop_fifo),
    .out_endofpacket   (out_eop_fifo),
    .csr_address       (2'b00),
    .csr_read          (cmd_fifo_info_rd),
    .csr_write         (1'b0),
    .csr_readdata      (cmd_fifo_fill_level),
    .csr_writedata     (32'b00000000000000000000000000000000)
    );
    
    // +--------------------------------------------------
    // | Output mapping for command
    // +--------------------------------------------------
    assign out_ready_fifo           = command_ready; 
    assign command_valid            = out_valid_fifo;
    assign command_data             = out_data_fifo;
    assign command_startofpacket    = out_sop_fifo;
    assign command_endofpacket      = out_eop_fifo;

    // +--------------------------------------------------
    // | Internal FIFO for imcomming urgent packet
    // +--------------------------------------------------
    urg_sc_fifo 
    #(
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (32),
        .FIFO_DEPTH          (URG_FIFO_DEPTH),
        .CHANNEL_WIDTH       (0),
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (1),
        .USE_FILL_LEVEL      (1),
        .EMPTY_LATENCY       (1),
        .USE_MEMORY_BLOCKS   (URG_USE_MEMORY_BLOCKS),
        .USE_STORE_FORWARD   (0),
        .USE_ALMOST_FULL_IF  (0),
        .USE_ALMOST_EMPTY_IF (0)
    ) urg_fifo 
    (
    .clk               (clk),
    .reset             (reset),
    .in_data           (cmd_in_data_fifo),
    .in_valid          (urg_in_valid_fifo),
    .in_ready          (urg_in_ready_fifo),
    .out_data          (urg_data_fifo),
    .out_valid         (urg_valid_fifo),
    .out_ready         (urg_ready_fifo),
    .csr_address       (2'b00),
    .csr_read          (urg_fifo_info_rd),
    .csr_write         (1'b0),
    .csr_readdata      (urg_fifo_fill_level),
    .csr_writedata     (32'b00000000000000000000000000000000)
    );
    
    // +--------------------------------------------------
    // | Output mapping for command
    // +--------------------------------------------------
    assign urg_ready_fifo           = urgent_ready; 
    assign urgent_valid             = urg_valid_fifo;
    assign urgent_data              = urg_data_fifo;


    // +--------------------------------------------------
    // | Internal response FIFO control signals
    // +--------------------------------------------------
    // Since the avmm readdata has latency of 2
    // flow the read signal and use this as ready 
    logic rsp_data_rd_dly1;
    logic rsp_data_rd_dly2;
    always_ff @(posedge clk) begin
        if (reset) begin 
            rsp_data_rd_dly1   <= '0;
            rsp_data_rd_dly2   <= '0;
        end
        else begin 
            rsp_data_rd_dly1   <= rsp_data_rd;
            rsp_data_rd_dly2   <= rsp_data_rd_dly1;
        end


    end

    // +--------------------------------------------------
    // | Internal FIFO for imcomming response packet
    // +--------------------------------------------------
    rsp_sc_fifo 
    #(
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (32),
        .FIFO_DEPTH          (RSP_FIFO_DEPTH),
        .CHANNEL_WIDTH       (0),
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (1),
        .USE_FILL_LEVEL      (1),
        .EMPTY_LATENCY       (1),
        .USE_MEMORY_BLOCKS   (RSP_USE_MEMORY_BLOCKS),
        .USE_STORE_FORWARD   (0),
        .USE_ALMOST_FULL_IF  (0),
        .USE_ALMOST_EMPTY_IF (0)
    ) rsp_fifo 
    (
    .clk               (clk),
    .reset             (reset),
    .in_data           (response_data),
    .in_valid          (response_valid),
    .in_ready          (response_ready),
    .in_startofpacket  (response_startofpacket),
    .in_endofpacket    (response_endofpacket),
    .out_data          (rsp_fifo_out_data),
    .out_valid         (rsp_fifo_out_valid),
    .out_ready         (rsp_data_rd),
    //.out_ready         (0),
    .out_startofpacket (rsp_fifo_out_sop),
    .out_endofpacket   (rsp_fifo_out_eop),
    .csr_address       (2'b00),
    //.csr_read          (1'b0),
    .csr_read          (rsp_fifo_info_rd),
    .csr_write         (),
    .csr_readdata      (rsp_fifo_fill_level),
    .csr_writedata     (32'b00000000000000000000000000000000)
    );

    //+--------------------------------------------------
    //| Interrupt enable register
    //+--------------------------------------------------
    logic en_data_valid;
    logic en_cmd_fifo_not_full;    

    logic   irq_en;
    logic   irq_status;

    always_ff @(posedge clk) begin
        if (reset) begin 
            en_data_valid        <= '0;
            en_cmd_fifo_not_full <= '0;
        end
        else if (ier_wr) begin 
            en_data_valid        <= avmm_writedata[0];
            en_cmd_fifo_not_full <= avmm_writedata[1];
        end
    end
    

    //+--------------------------------------------------
    //| Interrupt status register
    //+--------------------------------------------------
    logic status_data_valid;
    logic status_cmd_fifo_not_full;
    logic set_data_valid;
    logic set_cmd_fifo_not_full;

    assign set_data_valid          = rsp_fifo_out_valid;
    assign set_cmd_fifo_not_full   = cmd_in_ready_fifo;
    
    always_ff @(posedge clk) begin
        if (reset)
            status_data_valid           <= '0;
        else begin 
            if (set_data_valid)
                status_data_valid <= 1'b1;
            else
                status_data_valid <= 1'b0;
        end
    end

    always_ff @(posedge clk) begin
        if (reset)
            status_cmd_fifo_not_full <= '0;
        else begin 
            if (set_cmd_fifo_not_full)
                status_cmd_fifo_not_full <= 1'b1;
            else
                status_cmd_fifo_not_full <= '0;
        end
    end

    //+--------------------------------------------------
    //| IRQ
    //+--------------------------------------------------    
    assign irq_nxt = (en_data_valid & status_data_valid) | (en_cmd_fifo_not_full & status_cmd_fifo_not_full);
    always_ff @(posedge clk) begin
        if (reset)
            irq <= 1'b0;
        else
            irq <= irq_nxt;
    end

    //+--------------------------------------------------
    //| Avalon ReadData
    //+--------------------------------------------------
    logic [31:0] ier_readdata_internal;
    logic [31:0] isr_readdata_internal;
    logic [31:0] csr_readdata_next;
    logic [31:0] fifo_info_readdata_next;
    logic [31:0] rsp_fifo_fill_lv_eop_sop;
    logic [31:0] csr_readdata;
    logic [31:0] avmm_readdata_next;

    assign ier_readdata_internal = {30'h0, en_cmd_fifo_not_full, en_data_valid};
    assign isr_readdata_internal = {31'h0, status_cmd_fifo_not_full, status_data_valid};
    assign csr_readdata_next = (ier_readdata_internal & {32{ier_rd}}) | (isr_readdata_internal & {32{isr_rd}});
    // Combine the rsp fifo fill level together with eop and sop information
    assign rsp_fifo_fill_lv_eop_sop = {rsp_fifo_fill_level[29:0], rsp_fifo_out_eop, rsp_fifo_out_sop};
    
    logic cmd_fifo_info_rd_dly;
    logic rsp_fifo_info_rd_dly;
    logic urg_fifo_info_rd_dly;
    logic fifo_info_rd_dly;
    logic csr_rd_dly;
    logic rd;
    // the csr from fifo take one cycles to have output
    // cmd_fifo_empty_space
    always_ff @(posedge clk) begin
        if (reset) begin 
            cmd_fifo_info_rd_dly <= '0;
            rsp_fifo_info_rd_dly <= '0;
            urg_fifo_info_rd_dly <= '0;
            fifo_info_rd_dly     <= '0;
            csr_rd_dly           <= '0;
        end
        else begin 
            cmd_fifo_info_rd_dly <= cmd_fifo_info_rd;
            rsp_fifo_info_rd_dly <= rsp_fifo_info_rd;
            urg_fifo_info_rd_dly <= urg_fifo_info_rd;
            fifo_info_rd_dly     <= cmd_fifo_info_rd | rsp_fifo_info_rd | urg_fifo_info_rd;
            csr_rd_dly           <= ier_rd | isr_rd;
        end
    end
    assign rd = cmd_fifo_info_rd_dly | rsp_fifo_info_rd_dly | fifo_info_rd_dly | csr_rd_dly | rsp_data_rd_dly1;
    assign fifo_info_readdata_next = (cmd_fifo_empty_space & {32{cmd_fifo_info_rd_dly}}) | (rsp_fifo_fill_lv_eop_sop & {32{rsp_fifo_info_rd_dly}}) | (urg_fifo_empty_space & {32{urg_fifo_info_rd_dly}});
    // fifo data out put 
    always_ff @(posedge clk) begin
        if (reset) 
            rsp_fifo_out_data_dly <= '0;
        else begin 
            if (rsp_data_rd)
                rsp_fifo_out_data_dly <= rsp_fifo_out_data;

        end
    end
    // Select output readdata
    always_comb begin
        if (fifo_info_rd_dly)
            avmm_readdata_next = fifo_info_readdata_next;
        else if (csr_rd_dly)
            avmm_readdata_next = csr_readdata;
        else if (rsp_data_rd_dly1)
            avmm_readdata_next = rsp_fifo_out_data_dly;
        else
            avmm_readdata_next = '0;
    
    end

    always_ff @(posedge clk) begin
        if (reset)
            csr_readdata <= 32'h0;
        else
            csr_readdata <= csr_readdata_next;
    end
    

    always_ff @(posedge clk) begin
        if (reset) begin 
            avmm_readdata <= 32'h0;
            avmm_readdatavalid <= '0;
        end
        else begin 
            avmm_readdata <= avmm_readdata_next;
            avmm_readdatavalid <= rd;
        end
    end
endmodule
