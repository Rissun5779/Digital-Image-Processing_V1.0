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


// $Id: //acds/main/ip/altera_remote_update/altera_remote_update.sv#3 $
// $Revision: #3 $
// $Date: 2014/09/26 $
// $Author: tgngo $

// +----------------------------------------------------------------------
// | Altera Voltage Sensor Sample Store: 
// | stores the sample that the voltage sensor reads
// +----------------------------------------------------------------------
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module altera_voltage_sensor_sample_store 
#(
  parameter MEM_TYPE = 0
)
   (
    input             clk,
    input             rst,
    input [3:0]       addr,
    input             read,
    input             write,
    input [31:0]      writedata,
    input             rsp_valid,
    input [2:0]       rsp_channel,
    input [5:0]       rsp_data,
    input             rsp_sop,
    input             rsp_eop,
    output reg [31:0] readdata,
    output reg        irq
);

    reg               e_eop;
    reg               s_eop;
    reg [31:0]        csr_readdata;
    reg               ram_rd_en_flp;

    wire              ier_addr;
    wire              isr_addr;
    wire              ram_addr;
    wire              ier_wr_en;
    wire              isr_wr_en;
    wire              ier_rd_en;
    wire              isr_rd_en;
    wire              ram_rd_en;
    wire              set_eop;
    wire [31:0]       csr_readdata_nxt;
    wire [31:0]       ier_internal;
    wire [31:0]       isr_internal;
    wire [31:0]       readdata_nxt;
    wire [15:0]       q_out;
    wire              irq_nxt;
    reg [2:0]         slot_num;
    
    //+--------------------------------------------------------------------------------------------
    //| Address decode
    //+--------------------------------------------------------------------------------------------
    assign ier_addr = (addr == 4'h8);
    assign isr_addr = (addr == 4'h9);
    assign ram_addr = (addr < 4'h8);

    //+--------------------------------------------------------------------------------------------
    //| Write enable
    //+--------------------------------------------------------------------------------------------
    assign ier_wr_en = ier_addr & write;
    assign isr_wr_en = isr_addr & write;

    //+--------------------------------------------------------------------------------------------
    //| Read enable
    //+--------------------------------------------------------------------------------------------
    assign ier_rd_en = ier_addr & read;
    assign isr_rd_en = isr_addr & read;
    assign ram_rd_en = ram_addr & read;

    //+--------------------------------------------------------------------------------------------
    //| Interrupt enable register
    //+--------------------------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            e_eop <= 1'b1;
        else if (ier_wr_en)
            e_eop <= writedata[0];
    end

    //+--------------------------------------------------------------------------------------------
    //| Interrupt status register
    //+--------------------------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            s_eop <= 1'b0;
        else if (set_eop)
            s_eop <= 1'b1;
             else if (isr_wr_en & writedata[0])
                 s_eop <= 1'b0;
    end

    //+--------------------------------------------------------------------------------------------
    //| Avalon slave readdata path - read latency of 2 due to RAM's address and dataout register
    //+--------------------------------------------------------------------------------------------
    assign ier_internal     = {31'h0, e_eop};
    assign isr_internal     = {31'h0, s_eop};
    assign csr_readdata_nxt = (ier_internal & {32{ier_rd_en}}) |
                              (isr_internal & {32{isr_rd_en}});

    always @(posedge clk or posedge rst) begin
        if (rst)
            csr_readdata <= 32'h0;
        else
            csr_readdata <= csr_readdata_nxt;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            ram_rd_en_flp <= 1'b0;
        else
            ram_rd_en_flp <= ram_rd_en;
    end

    assign readdata_nxt = ram_rd_en_flp ? {16'h0, q_out[15:0]} : csr_readdata;

    always @(posedge clk or posedge rst) begin
        if (rst)
            readdata <= 32'h0;
        else
            readdata <= readdata_nxt;
    end

    //+--------------------------------------------------------------------------------------------
    //| RAM to store ADC sample
    //+--------------------------------------------------------------------------------------------
    generate if (MEM_TYPE == 0) 
        begin : ram_based
            altera_voltage_sensor_sample_store_ram u_ss_ram 
                (
                 .clock      (clk),
                 .data       ({10'h0, rsp_data}),
                 .rdaddress  (addr[2:0]),
                 .rden       (ram_rd_en),
                 .wraddress  (slot_num),
                 .wren       (rsp_valid),
                 .q          (q_out)
                 );
        end // block: ram_based
        else begin : register_based
            altera_voltage_sensor_sample_store_register
               #(
                 .DEPTH(8)
                ) u_ss_register
                (
                 .clk          (clk),
                 .reset        (rst),
                 .in_data      ({10'h0, rsp_data}),
                 .rdaddress    (addr[2:0]),
                 .rden         (ram_rd_en),
                 .wraddress    (slot_num),
                 .wren         (rsp_valid),
                 .out_data     (q_out)
                 );
        end // block: register_based
    endgenerate

    //--------------------------------------------------------------------------------------------
    // Sequential counter to indicate which RAM location to store ADC sample
    //--------------------------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            slot_num <= 3'h0;
        else if (set_eop)
            slot_num <= 3'h0;
             else if (rsp_valid)
                 slot_num <= slot_num + 3'h1; 
    end
    
    //+--------------------------------------------------------------------------------------------
    //| Set EOP status
    //+--------------------------------------------------------------------------------------------
    assign set_eop = rsp_valid & rsp_eop;

    //+--------------------------------------------------------------------------------------------
    //| IRQ
    //+--------------------------------------------------------------------------------------------
    assign irq_nxt = e_eop & s_eop;

    always @(posedge clk or posedge rst) begin
        if (rst)
            irq <= 1'b0;
        else
            irq <= irq_nxt;
    end
endmodule
