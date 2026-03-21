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


// $Id: //acds/rel/18.1std/ip/pgm/altera_nd_mailbox_multiplexer/altera_nd_mailbox_id_remapper/altera_nd_mailbox_id_remapper.sv#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $
// $Author: psgswbuild $


//+-----------------------------------------------------
//| Id Remapper
//+-----------------------------------------------------
`timescale 1 ns / 1 ns
module altera_nd_mailbox_id_remapper
#(
    parameter USE_MEMORY_BLOCKS = 0,
    parameter IN_ST_DATA_W = 64,
    parameter ST_DATA_W = 64,
    parameter ADDR_W    = 4,
    parameter DEPTH     = 16,
    //+-----------------------
    //| ID mapping widths
    //+-----------------------
    parameter ID_W   = 4,
    parameter NUM_ENDPOINTS   = 3,
    parameter NUM_STR_ENDPOINTS   = 2
)
(
    //+ -------------------
    //| Clock & Reset
    //+ -------------------
    input                          clk,
    input                          reset,

    //+ ---------------------------------------
    //| Command Input Packet
    //+ ---------------------------------------
    input [IN_ST_DATA_W-1:0]          cmd_in_data, 
    input                          cmd_in_sop, 
    input                          cmd_in_eop, 
    output reg                     cmd_in_ready, 
    input                          cmd_in_valid, 
    input [NUM_ENDPOINTS-1:0]      cmd_in_channel, 
    //+---------------------------------------
    //| Command Output Packet
    //+---------------------------------------
    input                          cmd_out_ready, 
    output reg                     cmd_out_valid,
    output reg [ST_DATA_W-1:0]     cmd_out_data,
    output reg                     cmd_out_sop,
    output reg                     cmd_out_eop, 
    //+---------------------------------------
    //| Respond Input Packet
    //+---------------------------------------
    output reg                     rsp_in_ready, 
    input                          rsp_in_valid, 
    input [ST_DATA_W-1:0]          rsp_in_data,
    input                          rsp_in_sop,
    input                          rsp_in_eop, 
    //+---------------------------------------
    //| Response Output Packet
    //+---------------------------------------
    input                          rsp_out_ready,
    output reg                     rsp_out_valid, 
    output reg [ST_DATA_W-1:0]     rsp_out_data,
    output reg                     rsp_out_sop,
    output reg                     rsp_out_eop, 
    output reg [NUM_ENDPOINTS-1:0] rsp_out_channel
);

    // ID field in packet
    localparam ID_H  = 27;
    localparam ID_L  = 24;
    localparam EMPTY_BITS  = 16 - NUM_ENDPOINTS;
    
    // --------------------------
    // Reg/Wire Declarations
    // --------------------------


    wire [ADDR_W-1:0]              waddr_wire;
    reg [ADDR_W-1:0]               waddr_reg;
    wire [ADDR_W-1:0]              waddr;
    wire [ADDR_W-1:0]              raddr;
    wire                           wren;
    wire [31:0]                    wdata;
    wire [31:0]                    rdata;
    reg                            rden;
    wire                           mem_rden;
    reg                            rden_t;
    reg                            rden1;
    reg                            rden2;
    reg [DEPTH-1:0]                used_location;
    wire                           no_empty_id;
    reg [DEPTH-1:0]                lowest_unset_valid_position;
    reg [ID_W-1:0]                 lowest_unset_valid_position_binary;
    
    reg                            rsp_in_ready_pipe1;
    wire                           rsp_in_valid_pipe1;
    wire                           rsp_in_sop_pipe1;
    wire                           rsp_in_eop_pipe1;
    wire [ST_DATA_W-1:0]           rsp_in_data_pipe1;
    
    
    wire [ID_W-1:0]                id_in;
    wire [ID_W-1:0]                id_in_lookup;
    wire [ID_W-1:0]                id_restored;
    reg [ID_W-1:0]                 id_remapped;
    wire [NUM_STR_ENDPOINTS-1:0]   stream_channel;
    wire                           has_stream;
    wire                           cmd_in_first_word;
    wire                           cmd_in_last_word;
    wire                           rsp_in_first_word;
      
    reg [31:0]                    rdata_pipe1;
    always_ff @(posedge clk) begin
        if (reset)
            rdata_pipe1 <= '0;
        else begin
            if (rsp_in_ready_pipe1 && rsp_in_sop_pipe1 && rsp_in_valid_pipe1)
                rdata_pipe1 <= rdata;
        end
    end

    // +----------------------------------------------------------------------------
    // | 
    // +----------------------------------------------------------------------------
    // State machine
    typedef enum bit [3:0]
    {
     ST_IDLE            = 4'b0001,
     ST_RESTORE_ID      = 4'b0010,
     ST_WAIT_ID         = 4'b0100,
     ST_PASS_RSP        = 4'b1000
     } t_state;
    t_state state, next_state;
    
    // +--------------------------------------------------
    // | State Machine: update state
    // +--------------------------------------------------
    // |
    always_ff @(posedge clk) begin
        if (reset)
            state <= ST_IDLE;
        else
            state <= next_state;
    end
    // +--------------------------------------------------
    // | State Machine: next state condition
    // +--------------------------------------------------
    always_comb begin
        next_state  = ST_IDLE;
        case (state)
            ST_IDLE: begin
                next_state  = ST_IDLE;
                if (rsp_in_valid & rsp_in_sop)
                    next_state = ST_RESTORE_ID;
            end

            ST_RESTORE_ID: begin
                next_state  = ST_WAIT_ID;
            end
            
            ST_WAIT_ID: begin
                next_state  = ST_PASS_RSP;
            end
            ST_PASS_RSP: begin 
                next_state = ST_PASS_RSP;
                if (rsp_out_valid && rsp_out_ready && rsp_out_eop)
                    next_state = ST_IDLE;
            end
        endcase
    end
    // +--------------------------------------------------
    // | State Machine: state outputs
    // +--------------------------------------------------

    always_comb begin
        rden            = '0;
        rsp_out_valid   = '0;
        rsp_out_sop     = '0;
        rsp_out_eop     = '0;
        rsp_out_channel = '0;
        rsp_out_data    = '0;
        rsp_in_ready    = '0;
        case (state)
            ST_IDLE: begin
                rden            = '0;
                rsp_out_valid   = '0;
                rsp_out_sop     = '0;
                rsp_out_eop     = '0;
                rsp_out_channel = '0;
                rsp_out_data    = '0;
                rsp_in_ready    = '0;
            end
            
            ST_RESTORE_ID: begin 
                rden            = 1'b1;
                rsp_out_valid   = '0;
                rsp_out_sop     = '0;
                rsp_out_eop     = '0;
                rsp_out_channel = '0;
                rsp_out_data    = '0;
                rsp_in_ready    = '0;
            end
            ST_WAIT_ID: begin 
                rden            = '0;
                rsp_out_valid   = '0;
                rsp_out_sop     = '0;
                rsp_out_eop     = '0;
                rsp_out_channel = '0;
                rsp_out_data    = '0;
                rsp_in_ready    = '0;
            end
            
            ST_PASS_RSP: begin
                rden            = '0;
                rsp_out_valid   = rsp_in_valid;
                rsp_out_sop     = rsp_in_sop;
                rsp_out_eop     = rsp_in_eop;
                rsp_out_channel = rdata[NUM_ENDPOINTS-1:0];
                rsp_out_data    = rsp_in_data;
                if (rsp_out_sop)
                    rsp_out_data[ID_H:ID_L]  = id_restored;
                rsp_in_ready    = rsp_out_ready;
            end
        endcase
    end
/*
    // +----------------------------------------------------------------------------
    // | Pipeline response, the RAM has read latency of 2, dont want to backpressure
    // | the response, pipeline them to be same as read latency, and sop is used to read
    // | and decode the ID to route them back.
    // +----------------------------------------------------------------------------
    wire  back_pressure;
    always_ff @(posedge clk) begin
        if (reset) begin
            rden1 <= '0;
            rden2 <= '0;
        end
        else begin
            rden1 <= rden;
            rden2 <= rden1;
        end
    end
    assign back_pressure = rden | rden1 | rden2;

        alt_nd_skid_buffer #(
            .SYMBOLS_PER_BEAT (1),
            .BITS_PER_SYMBOL  (ST_DATA_W),
            .USE_PACKETS      (1),
            .PACKET_WIDTH     (2),
            .USE_EMPTY        (0),
            .EMPTY_WIDTH      (0),
            .CHANNEL_WIDTH    (0),
            .ERROR_WIDTH      (0),
            .PIPELINE_READY   (1)
        ) rsp_skid_buffer1 (
            .clk               (clk),
            .reset             (reset),

            .in_ready          (rsp_in_ready),
            .in_valid          (rsp_in_valid),
            .in_startofpacket  (rsp_in_sop),
            .in_endofpacket    (rsp_in_eop),
            .in_data           (rsp_in_data),
            .in_channel        (1'b0),

            .out_ready         (rsp_in_ready_pipe1 && !back_pressure),
            //.out_ready         (0),
            .out_valid         (rsp_in_valid_pipe1),
            .out_startofpacket (rsp_in_sop_pipe1),
            .out_endofpacket   (rsp_in_eop_pipe1),
            .out_data          (rsp_in_data_pipe1),
            .out_channel       (),

            .in_empty          (1'b0),
            .in_error          (1'b0),
            .out_empty         (),
            .out_error         ()
        );
    */
    //+---------------------------------------
    //| Input
    //+---------------------------------------
    assign id_in         = cmd_in_data[ID_H:ID_L];
    assign id_in_lookup  = rsp_in_data[ID_H:ID_L];
    assign id_restored   = rdata[19:16];

    assign cmd_in_first_word = cmd_in_valid && cmd_in_ready && cmd_in_sop;
    assign cmd_in_last_word  = cmd_in_valid && cmd_in_ready && cmd_in_eop;
    assign rsp_in_first_word = rsp_in_valid && rsp_in_ready && rsp_in_sop;
    
    // --------------------------
    // Outputs mapping 
    // --------------------------
    always_comb begin
        // Command packet
        cmd_out_data  = cmd_in_data;
        id_remapped   = waddr;
        if (cmd_in_sop)
            cmd_out_data[ID_H:ID_L]  = id_remapped;
        cmd_in_ready                 = cmd_out_ready && !no_empty_id;
        cmd_out_sop                  = cmd_in_sop;
        cmd_out_eop                  = cmd_in_eop;
        cmd_out_valid                = cmd_in_valid  && !no_empty_id;
        


        // response packet
        //rsp_in_ready_pipe1            = rsp_out_ready;
        //rsp_out_valid                = rsp_in_valid_pipe1 && !back_pressure;
        //rsp_out_data                 = rsp_in_data_pipe1;
        //if (rsp_in_sop_pipe1)
        //    rsp_out_data[ID_H:ID_L]  = id_restored;
        //rsp_out_channel              = rdata[NUM_ENDPOINTS-1:0];
        //rsp_out_sop                  = rsp_in_sop_pipe1;
        //rsp_out_eop                  = rsp_in_eop_pipe1;
    end

    // -----------------------------------------
    // Control signal ID decoder from stream mux
    // -----------------------------------------
    always_ff @(posedge clk) begin
        if (reset) begin
            rden1 <= '0;
            rden2 <= '0;
        end
        else begin
            rden1 <= rden;
            rden2 <= rden1;
        end
    end
    
    // +-------------------------------------------------------
    // | Next lowest unused ID value to assign
    // | Use a vector and track which ID is free to auto assign
    // | if command in, based on first zero, set that bit
    // | response in, pop out ID and clear that bit
    // +-------------------------------------------------------
    assign no_empty_id  = &used_location;
    always_ff @(posedge clk) begin
        if (reset)
            used_location <= '0;
        else begin
            if (cmd_in_last_word)
                used_location[waddr] <= 1'b1;
            if (rsp_in_first_word)
                used_location[raddr] <= 1'b0;
        end
    end

    //+--------------------------------------------------------------------------
    //| Find lowest zero in a vector, to decide the auto assign ID for output packet
    //+--------------------------------------------------------------------------
    always_comb begin
        lowest_unset_valid_position = ~used_location & ~(~used_location - 1'b1); 
    end
    
    onehot_to_bin #(
        .ONEHOT_WIDTH (DEPTH),
        .BIN_WIDTH    (ID_W)
    ) conv_lowest_to_bin (
        .onehot  (lowest_unset_valid_position),
        .bin     (lowest_unset_valid_position_binary)
    );

    //+--------------------------------------------------------------------------
    //| Ram control logic: stores orginal ID and channel to route response packet
    //| Use fixed 32 bits for RAM data (On chip memory can be 16 or 32 ...) 16 is for channel, (max) 
    //+--------------------------------------------------------------------------
    // At sop of input packet, read the current address (ID out)
    // then lock it until the packet finish (eop appear) then only 
    // write this to the memory, need to do this in case, the input packet
    // is halfway transfer, the response comes back, the lowest zero may change
    wire waddr_lock;
    //assign waddr_lock  = cmd_in_sop;
    assign waddr_lock  = cmd_in_first_word;
    assign waddr_wire  = lowest_unset_valid_position_binary;
    
    always_ff @(posedge clk) begin
        if (reset)
            waddr_reg <= '0;
        else begin
            if (waddr_lock)
                waddr_reg <= waddr_wire;
        end
    end
    
    // when sop use first address wire from calculation 
    //assign waddr = cmd_in_sop? waddr_wire : waddr_reg;
    assign waddr = waddr_lock? waddr_wire : waddr_reg;
    assign raddr = id_in_lookup;
    assign wren  = cmd_in_first_word;
    assign mem_rden = rden;
    //assign mem_rden = rden || stream_active_in;
    //assign rden  = rsp_in_first_word;
    // Ram write data two parts: first is ID (fixed), second is Channel (dynamic)
    assign wdata  = {12'h0, id_in, {EMPTY_BITS{1'b0}}, cmd_in_channel};

    //+--------------------------------------------------------------------------
    //| Different kind of memory, all have read latency of 2
    //+--------------------------------------------------------------------------
    generate if (USE_MEMORY_BLOCKS == 0)
        begin : register_based
            store_register
                #(
                  .DEPTH         (16),
                  .DATA_W        (32),
                  .ADDR_W        (ADDR_W)
                  ) u_ss_register
                    (
                     .clk          (clk),
                     .reset        (reset),
                     .in_data      (wdata),
                     .rdaddress    (raddr),
                     //.rden         (rden),
                     .rden         (mem_rden),
                     .wraddress    (waddr),
                     .wren         (wren),
                     .out_data     (rdata)
                     );
		end // block: register_based
        else begin : ram_based
            store_ram u_ss_ram 
                (
                 .clock      (clk),
                 .data       (wdata),
                 .rdaddress  (raddr),
                 //.rden       (rden),
                 .rden         (mem_rden),
                 .wraddress  (waddr),
                 .wren       (wren),
                 .q          (rdata)
                 );
        end // block: ram_based
    endgenerate
    
endmodule

//+---------------------------------------
//| Register based memory
//+---------------------------------------

module store_register 
#(
  parameter DEPTH  = 8,
  parameter DATA_W = 16,
  parameter ADDR_W = 3
)
   (
    input                   clk,
    input                   reset,
    input [DATA_W-1:0]      in_data,
    input [ADDR_W-1:0]      rdaddress,
    input                   rden,
    input [ADDR_W-1:0]      wraddress,
    input                   wren,
    output reg [DATA_W-1:0] out_data
    );

    reg [DATA_W - 1 : 0] mem [DEPTH - 1 :0];
    reg [DATA_W-1:0] out_data_pipe;

    // Write data to register bank
    genvar               i;
    generate
        for (i = 0; i < DEPTH; i = i + 1) begin : regsiter_banks
            always_ff @(posedge clk) begin
                if (reset)
                    mem[i] <= '0;
                else begin 
                    if (wren & (wraddress == i))
                        mem[i] <= in_data;
                end
            end // always_ff @
        end // block: regsiter_banks
    endgenerate
    
    // Read data from register
    always_ff @(posedge clk) begin
        if (reset)
          out_data_pipe <= '0;
        else begin
           if (rden)
              out_data_pipe <= mem[rdaddress];
	   end
    end
    always_ff @(posedge clk) begin
        if (reset)
          out_data <= '0;
        else
            out_data <= out_data_pipe;
    end
    
endmodule

//+---------------------------------------
//| Onchip RAM based memory
//+---------------------------------------

module  store_ram (
    clock,
    data,
    rdaddress,
    rden,
    wraddress,
    wren,
    q);

    input    clock;
    input  [31:0]  data;
    input  [3:0]  rdaddress;
    input    rden;
    input  [3:0]  wraddress;
    input    wren;
    output [31:0]  q;
    /*
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
    tri1     clock;
    tri1     rden;
    tri0     wren;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif
*/
    wire [31:0] sub_wire0;
    wire [31:0] q = sub_wire0[31:0];

    altera_syncram  altera_syncram_component (
                .address_a (wraddress),
                .address_b (rdaddress),
                .clock0 (clock),
                .data_a (data),
                .rden_b (rden),
                .wren_a (wren),
                .q_b (sub_wire0),
                .aclr0 (1'b0),
                .aclr1 (1'b0),
                .address2_a (1'b1),
                .address2_b (1'b1),
                .addressstall_a (1'b0),
                .addressstall_b (1'b0),
                .byteena_a (1'b1),
                .byteena_b (1'b1),
                .clock1 (1'b1),
                .clocken0 (1'b1),
                .clocken1 (1'b1),
                .clocken2 (1'b1),
                .clocken3 (1'b1),
                .data_b ({32{1'b1}}),
                .eccencbypass (1'b0),
                .eccencparity (8'b0),
                .eccstatus (),
                .q_a (),
                .rden_a (1'b1),
                .sclr (1'b0),
                .wren_b (1'b0));
    defparam
        altera_syncram_component.address_aclr_b  = "NONE",
        altera_syncram_component.address_reg_b  = "CLOCK0",
        altera_syncram_component.clock_enable_input_a  = "BYPASS",
        altera_syncram_component.clock_enable_input_b  = "BYPASS",
        altera_syncram_component.clock_enable_output_b  = "BYPASS",
        altera_syncram_component.intended_device_family  = "Stratix 10",
        altera_syncram_component.lpm_type  = "altera_syncram",
        altera_syncram_component.numwords_a  = 16,
        altera_syncram_component.numwords_b  = 16,
        altera_syncram_component.operation_mode  = "DUAL_PORT",
        altera_syncram_component.outdata_aclr_b  = "NONE",
        altera_syncram_component.outdata_sclr_b  = "NONE",
        altera_syncram_component.outdata_reg_b  = "CLOCK0",
        altera_syncram_component.power_up_uninitialized  = "FALSE",
        altera_syncram_component.rdcontrol_reg_b  = "CLOCK0",
        altera_syncram_component.read_during_write_mode_mixed_ports  = "OLD_DATA",
        altera_syncram_component.widthad_a  = 4,
        altera_syncram_component.widthad_b  = 4,
        altera_syncram_component.width_a  = 32,
        altera_syncram_component.width_b  = 32,
        altera_syncram_component.width_byteena_a  = 1;


endmodule


