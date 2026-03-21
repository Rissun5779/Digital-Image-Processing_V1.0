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


// +-----------------------------------------------------------
// | Nadder SDM mailbox command controller 
// | 
// +-----------------------------------------------------------
`timescale 1 ns/ 1 ns

module altera_mailbox_cmd_controller
#(
  parameter COMMAND_WIDTH     = 32,
  parameter REQ_WIDTH         = 6,
  parameter WAITING_TIME      = 10,
  parameter OUT_COMMAND_WIDTH = 64
  )    
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input                                clk,
    input                                reset,
    
    // +--------------------------------------------------
    // | Avl ST command packet signals
    // +--------------------------------------------------
    input [COMMAND_WIDTH-1: 0]           in_data,
    input                                in_valid,
    input                                in_startofpacket,
    input                                in_endofpacket,
    output                               in_ready,

    // +--------------------------------------------------
    // | Avl ST output packet signals
    // +--------------------------------------------------
    output reg [OUT_COMMAND_WIDTH-1 : 0] out_data,
    output reg                           out_valid,
    output reg                           out_startofpacket,
    output reg                           out_endofpacket,
    input                                out_ready,

    // +--------------------------------------------------
    // | Request packet signals
    // +--------------------------------------------------
    output reg [REQ_WIDTH-1 : 0]         req_data,
    output reg                           req_valid,
    input                                req_ready,
    
    // +--------------------------------------------------
    // | ROUT update signals: from Read logic when it 
    // | send an update in ROUT to SDM
    // +--------------------------------------------------    
    input                                rout_update,
    // +--------------------------------------------------
    // | GPIO signals
    // +--------------------------------------------------
    input                                gpo_write,
    input [7:0]                          gpo_data
    );


    // +--------------------------------------------------
    // | Internal signals
    // +--------------------------------------------------
    wire [COMMAND_WIDTH-1:0]             fifo_in_data;
    wire                                 fifo_in_valid;
    wire                                 fifo_in_startofpacket;
    wire                                 fifo_in_endofpacket;
    wire                                 fifo_in_empty;
    wire                                 fifo_in_ready;
    wire                                 out_valid_fifo;
    reg                                  out_ready_fifo;
    wire [COMMAND_WIDTH-1:0]             out_data_fifo;
    wire                                 rout_update_detected;
    wire [4:0]                           fifo_fill_level;
    wire [1:0]                           gpo_addr;
    reg [4:0]                            gpo_cout;
    wire                                 gpo_cout_write;
    reg [5:0]                            counter;
    wire                                 counter_done;
    reg [4:0]                            length_to_sent;
    wire [4:0]                           final_length_to_sent;
    wire                                 enable_min;
    reg [4:0]                            sdm_fifo_wr_ptr;
    wire [4:0]                           sdm_fifo_next_wr_ptr;
    wire [4:0]                           sdm_fifo_incremented_wr_ptr;
    reg [4:0]                            sdm_fifo_cin;
    reg                                  sdm_fifo_full;
    reg                                  sdm_fifo_empty;
    reg                                  sdm_fifo_next_full; 
    reg                                  sdm_fifo_next_empty;
    wire                                 sdm_fifo_write;
    reg [4:0]                            sdm_fifo_empty_level;
    wire                                 fill_level_equal_eight;
    wire                                 req_accepted;
    wire                                 cmd_counter_done;
    reg [4:0]                            cmd_words_counter;
    wire [3:0]                           sdm_fifo_cin_int;
    wire [5 : 0]                         sdm_fifo_cin_in_bytes;
    wire [31 : 0]                        sdm_fifo_cin_address; // offset 0x40
    wire                                 cin_position_first_half;
    reg [4 : 0]                          max_length_can_send_for_this_half;
    reg [4 : 0]                          max_length_can_send;
    // State machine
    typedef enum bit [2:0]
    {
     ST_IDLE           = 3'b000,
     ST_WAITING_INPUT  = 3'b001,
     ST_ROUT_CHECKING  = 3'b010,
     ST_SEND_REQ       = 3'b011,
     ST_SEND_CIN       = 3'b100
     } t_state;
    t_state state, next_state;

    // +--------------------------------------------------
    // | Read GPO information (COUT)
    // +--------------------------------------------------
    assign gpo_addr         = gpo_data[7:6];
    assign gpo_cout_write   =  gpo_write && (gpo_addr == 2'b01);
    always_ff @(posedge clk) begin
        if (reset)
            gpo_cout <= '0;
        else begin
            if (gpo_cout_write) 
                gpo_cout <= gpo_data[4:0];
        end
    end // always_ff @
    
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
    // halfway: 8 words
    assign fill_level_equal_eight  = fifo_fill_level == 5'h8 ? 1'b1 : 1'b0;
    assign req_accepted            = req_valid && req_ready;
    always_comb begin
        next_state  = ST_IDLE;
        case (state)
            ST_IDLE: begin
                next_state  = ST_IDLE;
                if (out_valid_fifo) // If there is something in fifo, start working
                    next_state = ST_WAITING_INPUT;
            end

            ST_WAITING_INPUT: begin
                next_state  = ST_WAITING_INPUT;
                if (counter_done || fill_level_equal_eight)
                    next_state  = ST_ROUT_CHECKING;
            end
            
            ST_ROUT_CHECKING: begin
                // wait here if the cmd fifo in SDM is full
                // not send out anything 
                next_state  = ST_ROUT_CHECKING;
                if (sdm_fifo_empty_level != '0)
                    next_state  = ST_SEND_REQ;
            end
            
            ST_SEND_REQ: begin
                next_state  = ST_SEND_REQ;
                if (req_accepted)
                    next_state  = ST_SEND_CIN;
            end

            ST_SEND_CIN: begin
                next_state  = ST_SEND_CIN;
                if (req_accepted)
                    next_state  = ST_IDLE;
            end
        endcase // case (state)
    end // always_comb
    
    // +--------------------------------------------------
    // | State Machine: state outputs
    // +--------------------------------------------------
    always_comb begin
        req_data        = '0;
        length_to_sent  = '0;
        case (state)
            ST_IDLE: begin
                req_data        = '0;
                length_to_sent  = '0;
            end

            ST_WAITING_INPUT: begin
                req_data        = '0;
                length_to_sent  = fifo_fill_level;
            end

            ST_ROUT_CHECKING: begin
                req_data        = '0;
                // the number of data to sent out is review at this stage
                if (rout_update_detected) begin
                    if (max_length_can_send_for_this_half <= fifo_fill_level)
                        length_to_sent  = max_length_can_send_for_this_half;
                    else
                        length_to_sent  = fifo_fill_level;
                end
                else begin  // no rout update, send all it has, best case if it has more than halfway but not cross 16
                    if (max_length_can_send <= fifo_fill_level)
                        length_to_sent  = max_length_can_send;
                    else
                        length_to_sent  = fifo_fill_level;
                end
                
            end
            
            ST_SEND_REQ: begin
                // Final length to send to SDM after check with empty level if SDM cmd FIFO
                length_to_sent  =  final_length_to_sent;
                req_data            = {1'b1, final_length_to_sent};
            end
            
           ST_SEND_CIN: begin
               // CIN points to the next write possition 
               length_to_sent  = 5'h1;
               // re-edit the location of cin to send out
               req_data        = {1'b0, sdm_fifo_cin};
           end
        endcase // case (state)
    end
    // | 
    // +--------------------------------------------------
    
    // +--------------------------------------------------
    // |calculate real address of SDM FIFO
    assign sdm_fifo_cin_int       = sdm_fifo_cin[3:0];
    assign sdm_fifo_cin_in_bytes  = sdm_fifo_cin[3:0] << 2'b10;
    // CIN address with offset in SDM: 0x40 - 0x7C
    // 0x40: 1000000
    assign sdm_fifo_cin_address   = {24'b0, 1'b1, sdm_fifo_cin_in_bytes};

    // Do some calculations to find the best length to send out
    // which never cross halfway
    assign cin_position_first_half  = (sdm_fifo_cin[3:0] <= 4'h7);
    always_comb begin
        if (rout_update_detected) begin
            max_length_can_send = fifo_fill_level;
            if (cin_position_first_half)
                max_length_can_send_for_this_half  = 5'h8 - sdm_fifo_cin_int;
            else
                max_length_can_send_for_this_half  = 5'h10 - sdm_fifo_cin_int;
        end
        else begin // this case, cmd controller can send as much as it can but never cross 16
            max_length_can_send = 5'h10 - sdm_fifo_cin_int;
            max_length_can_send_for_this_half  = fifo_fill_level; 
        end
    end // always_comb

    // Count word sent out to calculate sop and eop (they do not follow sop and eop from cmd packet)
    assign cmd_counter_done  = ((cmd_words_counter == final_length_to_sent - 1'b1) && (out_valid && out_ready));
    always_ff @(posedge clk) begin
        if (reset)
            cmd_words_counter <= 5'b0;
        else begin
            if (state == ST_SEND_REQ) begin
                if (out_valid && out_ready)
                    cmd_words_counter <= cmd_words_counter + 5'b1;
                if (cmd_counter_done)
                    cmd_words_counter <= 5'b0;
            end 
            else begin
                cmd_words_counter <= 5'b0;
            end
        end
    end // always_ff @

    // +--------------------------------------------------
    // | Waiting counter: wait for a while if any more
    // | command comming
    // +--------------------------------------------------
    assign counter_done  = (counter == WAITING_TIME[5:0]);
    always_ff @(posedge clk) begin
        if (reset)
            counter <= '0;
        else begin
            if (state == ST_WAITING_INPUT) begin
                counter <= counter + 5'b1;
                if (counter_done)
                    counter <= '0;
            end 
            else begin
                counter <= '0;
            end
        end
    end // always_ff @
    
    // +--------------------------------------------------
    // | CIN calculation: calculates CIN (next_write point)
    // | and send to SDM. 
    // +--------------------------------------------------
    assign sdm_fifo_write               = out_valid && out_ready;
    assign sdm_fifo_incremented_wr_ptr  = sdm_fifo_wr_ptr + 5'b1;

    // The next component might backpressure, once a word pop out we increase the wr ptr
    // that how we consider the write pointer to the SDM FIFO
    assign sdm_fifo_next_wr_ptr  = sdm_fifo_write ? sdm_fifo_incremented_wr_ptr : sdm_fifo_wr_ptr;
    assign sdm_fifo_cin          = sdm_fifo_wr_ptr;
    always_ff @(posedge clk) begin
        if (reset)
            sdm_fifo_wr_ptr <= '0;
        else
            sdm_fifo_wr_ptr <= sdm_fifo_next_wr_ptr;
    end
    
    // check the fill level inside SDM command FIFO
    wire [31:0] sdm_fifo_cmd_depth;
    assign sdm_fifo_cmd_depth = 16;

    always_ff @(posedge clk) begin
        if (reset)
            sdm_fifo_empty_level <= sdm_fifo_cmd_depth[4:0];
        else if (sdm_fifo_next_empty)
            sdm_fifo_empty_level <= sdm_fifo_cmd_depth[4:0];
             else begin
                 sdm_fifo_empty_level[4] <= '0;
                 sdm_fifo_empty_level[3:0] <= gpo_cout[3:0] - sdm_fifo_next_wr_ptr[3:0];
             end
    end // always_ff @
    
    always_comb begin
        sdm_fifo_next_empty  = sdm_fifo_empty;
        if (sdm_fifo_write || gpo_cout_write) begin
            sdm_fifo_next_empty  = '0;
        end
        else begin
            if (gpo_cout == sdm_fifo_wr_ptr)
                sdm_fifo_next_empty  = 1'b1;
        end // else: !if(sdm_fifo_write)
    end // always_comb
    
    always @(posedge clk) begin
        if (reset)
            sdm_fifo_empty <= 1'b1;
        else
            sdm_fifo_empty <= sdm_fifo_next_empty;
    end

    // +--------------------------------------------------
    // | Find which one is smaller: the length that the
    // | cmd_controller wants and the empty level inside
    // | SDM cmd fifo.
    // +--------------------------------------------------
    assign enable_min = (state == ST_ROUT_CHECKING);
    calculate_min  
   #( 
    .WIDTH  (5)
    ) min_comp
   (
    .clk      (clk),
    .reset    (reset),
    .a        (sdm_fifo_empty_level),  
    .b        (length_to_sent),
    .en       (enable_min),
    .min_ab   (final_length_to_sent)
    );
    
    
    // +--------------------------------------------------
    // | ROUT update detector: detect within 100 cyclet
    // | is there any ROUT update
    // +--------------------------------------------------
    rout_update_detector rout_detector
    (
     .clk                              (clk),
     .reset                            (reset),
     .rout_upt_req                     (rout_update),
     .rout_chng_within_last_100_cycles (rout_update_detected)
     );

    // +--------------------------------------------------
    // | Output Avalon ST signals
    // +--------------------------------------------------
    always_comb begin
        req_valid          = ((state == ST_SEND_REQ) || (state == ST_SEND_CIN)) ? 1'b1 : 1'b0;
        out_valid          = (state == ST_SEND_REQ) && out_valid_fifo;
        out_ready_fifo     = (state == ST_SEND_REQ) && out_ready;
        out_data           = {sdm_fifo_cin_address, out_data_fifo};
        out_startofpacket  = (cmd_words_counter == '0);
        out_endofpacket    = cmd_counter_done;
        // for CIN update, we do not read from fifo,
        // it goes with request packet
    end
    
    // +--------------------------------------------------
    // | Internal FIFO for imcomming packet
    // +--------------------------------------------------
    altera_avalon_sc_fifo_export_fill_level 
  #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (COMMAND_WIDTH),
    .FIFO_DEPTH          (16),
    .CHANNEL_WIDTH       (0),
    .ERROR_WIDTH         (0),
    .USE_PACKETS         (1),
    .USE_FILL_LEVEL      (1),
    .EMPTY_LATENCY       (3),
    .USE_MEMORY_BLOCKS   (1),
    .USE_STORE_FORWARD   (0),
    .USE_ALMOST_FULL_IF  (0),
    .USE_ALMOST_EMPTY_IF (0)
    ) cmd_fifo 
   (
    .clk               (clk),                  
    .reset             (reset),                
    .in_data           (in_data), 
    .in_valid          (in_valid),              
    .in_ready          (in_ready),
    .in_startofpacket  (in_startofpacket),                                
    .in_endofpacket    (in_endofpacket),                                
    .out_data          (out_data_fifo),              
    .out_valid         (out_valid_fifo),             
    //.out_ready         (1'b0),
    .out_ready         (out_ready_fifo),
    .out_startofpacket (),                           
    .out_endofpacket   (),                                  
    //.out_startofpacket (out_startofpacket),                           
    //.out_endofpacket   (out_endofpacket),                                  
    .out_fifo_fill_level (fifo_fill_level),
    .csr_address       (2'b00),                               
    .csr_read          (1'b0),                                
    .csr_write         (1'b0),                                
    .csr_readdata      (),                                    
    .csr_writedata     (32'b00000000000000000000000000000000),
    .almost_full_data  (),                                    
    .almost_empty_data (),                                    
    .in_empty          (1'b0),                                
    .out_empty         (),                                    
    .in_error          (1'b0),                                
    .out_error         (),                                    
    .in_channel        (1'b0),                                
    .out_channel       ()                                     
    );


    //--------------------------------------
    // Assertions
    //--------------------------------------
    // synthesis translate_off

    // Check that in case there is rout updated, the command controller never
    // send any command the cross halfway point
    // ex: if in first half, it should not send anything cross 8
    //     if in second half, it should not send anything cross 15 (mean that CIN rolls over 0)

    reg  req_valid_dly;
    wire send_req_start;
    always @(posedge clk) begin
        if (reset)
            req_valid_dly <= '0;
        else
            req_valid_dly <= req_valid;
    end
    assign send_req_start  = req_valid & !req_valid_dly;

    // This assertion is used when the command controller needs to send halfway max only
    ERROR_CIN_crosses_halfway_point:
    assert property (@(posedge clk)
                     disable iff (reset) ((rout_update_detected && send_req_start) |-> (final_length_to_sent <= max_length_can_send_for_this_half)));
    // If there is no ROUT update, it can send as much as it can but due to
    // AXI only use INCR burst, so CIN cannot cross from 15 -> 0 (CIN from 15 -> 16; and from 31 -> 0)
    ERROR_CIN_cross_max_point:
    assert property (@(posedge clk)
                     disable iff (reset) ((!rout_update_detected && send_req_start) |-> (final_length_to_sent <= (5'h10 - sdm_fifo_cin_int))));
                
// synthesis translate_on
endmodule // altera_mailbox_cmd_controller

// +--------------------------------------------------
// | Find the minimum between two vectors
// | output is registed, shall we use subtractor for optimized?
// | for first implementation, use as simple as this
// +--------------------------------------------------
module calculate_min (clk,reset,a,b,en,min_ab);

parameter WIDTH = 8;

    input clk;
    input reset;
    input [WIDTH-1:0] a;
    input [WIDTH-1:0] b;
    input             en;
    output [WIDTH-1:0] min_ab;
    
    
    reg [WIDTH-1:0]    min_ab;

    always @(posedge clk) begin
        if (reset)
            min_ab <= 0;
        else begin
            if (en) begin
                if (a<b)
                    min_ab <= a;
                else
                    min_ab <= b;
            end
        end // else: !if(reset)
    end // always @ (posedge clk)
endmodule
