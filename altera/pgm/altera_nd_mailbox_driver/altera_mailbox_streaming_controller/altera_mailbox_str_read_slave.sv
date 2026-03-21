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


// $Id: //acds/main/ip/altera_voltage_sensor/control/altera_voltage_sensor_control.sv#3 $
// $Revision: #3 $
// $Date: 2015/01/18 $
// $Author: tgngo $

// +-----------------------------------------------------------
// | Nadder SDM mailbox read controller:
// |  - Read response packet from response FIFO in SDM mailbox
// |     via AXI interface
// +-----------------------------------------------------------
`timescale 1 ns/ 1 ns

module altera_mailbox_str_read_slave
#(
  parameter COMMAND_WIDTH       = 32,
  parameter ST_IN_W             = 64,
  parameter REQ_WIDTH           = 38,
  parameter WAITING_TIME        = 10,
  parameter ADDR_W              = 32,
  parameter DATA_W              = 64,
  parameter ID_W                = 4,  
  parameter USER_W              = 4, 
  parameter WSTRB_W             = DATA_W / 8,
  parameter OUT_COMMAND_WIDTH   = COMMAND_WIDTH + 32,
  parameter READ_ACCEPTANCE_CAPABILITY = 8
  )    
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input                     clk,
    input                     reset,
    
    // +--------------------------------------------------
    // | AXI4 master signals
    // +--------------------------------------------------
    // AXI write address channel
    input [ID_W-1 : 0]        aw_id,
    input [ADDR_W-1 : 0]      aw_addr,
    input [7:0]               aw_len, 
    input [2:0]               aw_size,
    input [1:0]               aw_burst,
    input                     aw_lock,
    input [3:0]               aw_cache,
    input [2:0]               aw_prot,
    input [3:0]               aw_qos,
    input                     aw_valid,
    input [USER_W-1 : 0]      aw_user,
    output reg                aw_ready,
    // AXI write data channel
    input [DATA_W-1 : 0]      w_data,
    input [WSTRB_W-1 : 0]     w_strb,
    input                     w_last,
    input                     w_valid,
    output reg                w_ready,
    // AXI write response channel
    output reg [ID_W-1:0]     b_id,
    output reg [1:0]          b_resp,
    output reg                b_valid,
    input                     b_ready,

    // AXI read address channel
    input [ID_W-1 : 0]        ar_id,
    input [ADDR_W-1 : 0]      ar_addr,
    input [7 : 0]             ar_len,
    input [2:0]               ar_size,
    input [1:0]               ar_burst,
    input                     ar_lock,
    input [3:0]               ar_cache,
    input [2:0]               ar_prot,
    input [3:0]               ar_qos,
    input                     ar_valid,
    input [USER_W-1 : 0]      ar_user,
    output reg                ar_ready,

    // AXI read response channel
    output reg [ID_W-1 : 0]   r_id,
    output reg [DATA_W-1 : 0] r_data,
    output reg [1:0]          r_resp,
    output reg                r_last,
    output reg                r_valid,
    input                     r_ready,
           
    // +--------------------------------------------------
    // | Avl ST input packet signals
    // +--------------------------------------------------
    // check input of Avalon ST
    input [ST_IN_W - 1 : 0]   in_st_data,
    input                     in_st_valid,
    input                     in_st_startofpacket,
    input                     in_st_endofpacket,
    output reg                in_st_ready

    );

    localparam READ_CMD_DATA_W = ID_W+ADDR_W+8+3+2+1+4+3+USER_W;
    // +--------------------------------------------------
    // | Internal signals
    // +--------------------------------------------------
    reg                         busy;
    reg [3:0]                   ar_size_reg;
    reg [7:0]                   ar_len_reg;
    wire [7:0]                  ar_len_plus_one;
    reg [7:0]                   word_cnt;
    wire [READ_CMD_DATA_W - 1 : 0]  read_cmd_fifo_indata;
    wire [READ_CMD_DATA_W - 1 : 0]  read_cmd_fifo_outdata;
    reg [READ_CMD_DATA_W - 1 : 0]  read_cmd_fifo_outdata_reg;
    reg                         read_cmd_fifo_invalid;
    wire                        read_cmd_fifo_inready;
    wire                        read_cmd_fifo_outready;
    wire                        read_cmd_fifo_outvalid;
    // Internal AXI read address channel
    wire [ID_W-1 : 0]        ar_id_sig;
    wire [ADDR_W-1 : 0]      ar_addr_sig;
    wire [7 : 0]             ar_len_sig;
    wire [2:0]               ar_size_sig;
    wire [1:0]               ar_burst_sig;
    wire                     ar_lock_sig;
    wire [3:0]               ar_cache_sig;
    wire [2:0]               ar_prot_sig;
    wire [USER_W-1 : 0]      ar_user_sig;
    wire                     last_transfer;
    reg [7:0]                beat_cnt;
    reg [7:0]                next_beat_cnt;
    // +---------------------------------------------------
    // | Store command information and store in fifo
    // | The DMA can send up to 8 outstanding transactions
    // | Store all commands and process them 
    // +---------------------------------------------------
    assign read_cmd_fifo_indata = {ar_id, ar_addr, ar_len, ar_size, ar_burst, ar_lock, ar_cache, ar_prot, ar_user};
    altera_avalon_sc_fifo #(
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (READ_CMD_DATA_W), 
        .FIFO_DEPTH          (READ_ACCEPTANCE_CAPABILITY),
        .CHANNEL_WIDTH       (0),
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (0),
        .USE_FILL_LEVEL      (0),
        .EMPTY_LATENCY       (1),
        .USE_MEMORY_BLOCKS   (0),
        .USE_STORE_FORWARD   (0),
        .USE_ALMOST_FULL_IF  (0),
        .USE_ALMOST_EMPTY_IF (0)
    ) read_rsp_fifo (
        .clk               (clk),                                
        .reset             (reset),                              
        .in_data           (read_cmd_fifo_indata),                
        .in_valid          (read_cmd_fifo_invalid),               
        .in_ready          (read_cmd_fifo_inready),               
        .out_data          (read_cmd_fifo_outdata),               
        .out_valid         (read_cmd_fifo_outvalid),              
        .out_ready         (read_cmd_fifo_outready),
        .csr_address       (2'b00),                               
        .csr_read          (1'b0),                                
        .csr_write         (1'b0),                                
        .csr_readdata      (),                                    
        .csr_writedata     (32'b00000000000000000000000000000000),
        .almost_full_data  (),                                    
        .almost_empty_data (),                                    
        .in_startofpacket  (1'b0),                                
        .in_endofpacket    (1'b0),                                
        .out_startofpacket (),                                    
        .out_endofpacket   (),                                    
        .in_empty          (1'b0),                                
        .out_empty         (),                                    
        .in_error          (1'b0),                                
        .out_error         (),                                    
        .in_channel        (1'b0),                                
        .out_channel       ()                                     
    );      
   
   //assign read_cmd_fifo_outready = (next_beat_cnt == ar_len_sig) && r_valid && r_ready;
   
    // +--------------------------------------------------
    // | State Machine
    // +--------------------------------------------------
    typedef enum bit [2:0]
    {
        ST_IDLE           = 3'b001,
        ST_LOAD_CMD       = 3'b010,
        ST_SEND_RSP       = 3'b100
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
                if (read_cmd_fifo_outvalid && in_st_valid) // If there is command in fifo, and the response streaming data is ready, start working
                    next_state = ST_LOAD_CMD;
            end

            ST_LOAD_CMD: begin
                next_state = ST_SEND_RSP;
            end

            ST_SEND_RSP: begin
                next_state  = ST_SEND_RSP;
                if (last_transfer) begin
                    if (read_cmd_fifo_outvalid)
                        next_state = ST_LOAD_CMD;
                    else    
                        next_state = ST_IDLE;
                end
            end

        endcase // case (state)
    end // always_comb



    assign last_transfer = r_last;

    // +--------------------------------------------------
    // | Load the command informnation out and store them
    // +--------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset)
            read_cmd_fifo_outdata_reg <= '0;
        else begin
            if (state == ST_LOAD_CMD)
                read_cmd_fifo_outdata_reg <= read_cmd_fifo_outdata;
        end
    end
    // pop the processing command out of the fifo
   assign read_cmd_fifo_outready = (state == ST_LOAD_CMD);
   assign {ar_id_sig, ar_addr_sig, ar_len_sig, ar_size_sig, ar_burst_sig, ar_lock_sig, ar_cache_sig, ar_prot_sig, ar_user_sig} = read_cmd_fifo_outdata_reg;

    // +--------------------------------------------------
    // | R_last control
    // +--------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset)
            beat_cnt <= '0;
        else 
            beat_cnt <= next_beat_cnt;
    end

    always_comb begin
        next_beat_cnt = beat_cnt;
        if (state == ST_SEND_RSP) begin
            if (r_valid && r_ready)
                next_beat_cnt = next_beat_cnt + 7'h1;
            if (next_beat_cnt == (ar_len_sig + 7'h1))
                next_beat_cnt = '0;
        end
        else 
            next_beat_cnt = '0;
        end
    
    assign r_last = (beat_cnt == ar_len_sig) && r_valid && r_ready;


    // +--------------------------------------------------
    // | Read data
    // +--------------------------------------------------
    always_comb begin
        r_data  = in_st_data;
        if (state == ST_SEND_RSP) begin
            r_valid      = in_st_valid;
            in_st_ready  = r_ready;
            //r_last = (beat_cnt == ar_len_sig) && r_valid && r_ready;
        end
        else begin
            r_valid      = '0;
            in_st_ready  = '0;
        end
        
    end
        
    // +--------------------------------------------------
    // | Output signals
    // +--------------------------------------------------
    always_comb begin
        //ar_ready  = !busy;
        ar_ready  = read_cmd_fifo_inready;
        read_cmd_fifo_invalid = ar_valid;
        r_id      = ar_id_sig;
        r_resp    = '0; // OKAY
    end

    // default signals, we only use read channel here
    always_comb begin
        aw_ready  = '0;
        w_ready   = '0;
        b_id      = '0;
        b_resp    = '0;
        b_valid   = '0;
    end         
    
    
endmodule
