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

module altera_mailbox_read_controller
#(
  parameter COMMAND_WIDTH       = 32,
  parameter RSP_ST_W            = 32,
  parameter REQ_WIDTH           = 6,
  parameter ADDR_W              = 32,
  parameter DATA_W              = 32,
  parameter ID_W                = 4,  
  parameter USER_W              = 5, 
  parameter WSTRB_W             = 8,
  parameter OUT_COMMAND_WIDTH   = 64
  )    
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input                        clk,
    input                        reset,
    
    // +--------------------------------------------------
    // | AXI4 master signals
    // +--------------------------------------------------
    // AXI write address channel
    output reg [ID_W-1 : 0]      aw_id,
    output reg [ADDR_W-1 : 0]    aw_addr,
    output reg [7:0]             aw_len, 
    output reg [2:0]             aw_size,
    output reg [1:0]             aw_burst,
    output reg                   aw_lock,
    output reg [3:0]             aw_cache,
    output reg [2:0]             aw_prot,
    output reg [3:0]             aw_qos,
    output reg                   aw_valid,
    output reg [USER_W-1 : 0]    aw_user,
    input                        aw_ready,

    // AXI write data channel
    output reg [DATA_W-1 : 0]    w_data,
    output reg [WSTRB_W-1 : 0]   w_strb,
    output reg                   w_last,
    output reg                   w_valid,
    input                        w_ready,

    // AXI write response channel
    input [ID_W-1:0]             b_id,
    input [1:0]                  b_resp,
    input                        b_valid,
    output reg                   b_ready,

    // AXI read address channel
    output reg [ID_W-1 : 0]      ar_id,
    output reg [ADDR_W-1 : 0]    ar_addr,
    output reg [7 : 0]           ar_len,
    output reg [2:0]             ar_size,
    output reg [1:0]             ar_burst,
    output reg                   ar_lock,
    output reg [3:0]             ar_cache,
    output reg [2:0]             ar_prot,
    output reg [3:0]             ar_qos,
    output reg                   ar_valid,
    output reg [USER_W-1 : 0]    ar_user,
    input                        ar_ready,

    // AXI read response channel
    input [ID_W-1 : 0]           r_id,
    input [DATA_W-1 : 0]         r_data,
    input [1:0]                  r_resp,
    input                        r_last,
    input                        r_valid,
    output                       r_ready,
           
    // +--------------------------------------------------
    // | Avl ST output packet signals
    // +--------------------------------------------------
    // check output of Avalon ST
    output [RSP_ST_W - 1 : 0]    out_data,
    output                       out_valid,
    output                       out_startofpacket,
    output                       out_endofpacket,
    input                        out_ready,
    
    // +--------------------------------------------------
    // | Request packet signals
    // +--------------------------------------------------
    output reg [REQ_WIDTH-1 : 0] req_data,
    output reg                   req_valid,
    input                        req_ready,
    
    // +--------------------------------------------------
    // | GPIO signals
    // +--------------------------------------------------
    input                        gpo_write,
    input [7:0]                  gpo_data
    );


    // +--------------------------------------------------
    // | Internal signals
    // +--------------------------------------------------
    // State machine
    typedef enum bit [2:0]
    {
     ST_IDLE           = 3'b000,
     ST_SEND_READ      = 3'b001,
     ST_PROCESS_RSP    = 3'b010,
     ST_ROUT_UPDATE    = 3'b011
     } t_state;
    t_state state, next_state;

    wire [ 1 : 0] gpo_addr;
    reg [5 : 0]   gpo_rin;
    reg [5 : 0]   gpo_rin_dly;
    reg           gpo_re;
    reg           gpo_re_dly;
    reg           gpo_write_dly;    
    reg [5 : 0]   sdm_fifo_wr_ptr;
    wire [5 : 0]  sdm_fifo_next_wr_ptr;
    wire [5 : 0]  sdm_fifo_incremented_wr_ptr;
    reg [5: 0]    sdm_fifo_rd_ptr;
    wire [5 : 0]  sdm_fifo_next_rd_ptr;
    wire [5 : 0]  sdm_fifo_incremented_rd_ptr;
    
    
    reg [5 : 0]   sdm_fifo_cin;
    reg           sdm_fifo_full;
    reg           sdm_fifo_empty;
    reg           sdm_fifo_next_full;
    reg           sdm_fifo_next_empty;
    wire          sdm_fifo_write;
    wire          sdm_fifo_read;
    
    reg           response_cnt_en;
    reg [5 : 0]   response_cnt;
    
    wire [5 : 0]  gpo_rout;
    
    
    wire [7 : 0]  total_word_requested;
    wire [7 : 0]  total_word_requested_minuesone;
    reg [7 : 0]   total_word_requested_minuesone_reg;
    reg [7 : 0]   total_word_requested_minuesone_reg_t;
    
    reg [31 : 0]  word_select;
    reg           word_cnt_en;
    wire          word_cnt_done;
    reg [5 : 0]   word_cnt;
    wire [5 : 0]  next_word_cnt;
    reg [5 : 0]   rsp_cnt;
    wire [5 : 0]  next_rsp_cnt;
    reg           r_valid_internal;
    
    // The RIN and ROUT uses 6 bits (0..63) to indicate write and read pointer
    // Internally, only use 5 bits (0..31)
    reg [4 : 0]   rin_int;
    wire [4 : 0]  rout_int;
    reg [4 : 0]   rin_int_aligned_8bytes;
    reg [4 : 0]   rout_int_aligned_8bytes;
    reg [4 : 0]   len_to_sent_8bytes;
    reg [5 : 0]   length_to_sent;
    wire [5 : 0]  max_len_from_rout_to_boundary;
    wire          rin_rolls_over;
    reg           rsp_fifo_empty;
    // +--------------------------------------------------
    // | Multiple read transctions logic
    // +--------------------------------------------------
    // If RIN crosses over, the read controller needs to send
    // 2 reads. One up to boundary, one from 0 up to current RIN.
    reg [1 : 0]   numb_pending_rd;
    reg           pending_rd_active;
    // check when rin != 0 only, if rin 0 then dont care, read until boundary then rout will be same as rin (0)
    // and it is empty state
    wire          rin_rolls_over_temp;
    reg [1 : 0]   next_numb_pending_rd;
    assign rin_rolls_over_temp  = ((gpo_rout[5] == '0) && (gpo_rin_dly[5] == 1'b1)) || ((gpo_rout[5] == 1'b1) && (gpo_rin_dly[5] == 1'b0));
    assign rin_rolls_over  = rin_rolls_over_temp;    
    assign max_len_from_rout_to_boundary  = 6'd32 - rout_int;
    assign rout_int = gpo_rout[4 : 0];
    always_comb begin
        rin_int  = gpo_rin_dly[4 : 0];
    end

    always_comb begin
        next_numb_pending_rd = numb_pending_rd;
        if ((state == ST_IDLE) && rin_rolls_over &&  (rin_int != '0))
            next_numb_pending_rd  = 2'b10;
        if (ar_ready && ar_valid && pending_rd_active)
            next_numb_pending_rd  = numb_pending_rd - 1'b1;
    end
    
    always_ff @(posedge clk)
        begin
            if (reset)
                numb_pending_rd <= '0;
            else 
                numb_pending_rd <= next_numb_pending_rd;
        end
    assign pending_rd_active = (numb_pending_rd != 0);
    
    // +--------------------------------------------------
    // | Read burst length for AXI
    // +--------------------------------------------------
    always_comb begin
        length_to_sent = rin_int - rout_int;
        if (sdm_fifo_full)
            length_to_sent  = 6'd32;
        if (rin_rolls_over) 
            length_to_sent  = max_len_from_rout_to_boundary;
    end
    // AXI use length minus 1
    assign ar_len  = {2'b0, length_to_sent - 1'b1};

    // +--------------------------------------------------
    // | Read Address for AXI, convert to byte address
    // | (rout uses in term of word)
    // +--------------------------------------------------
    assign gpo_rout  = sdm_fifo_rd_ptr;
    always_comb begin
        ar_addr         = 32'h80;
        ar_addr[6 : 0]  = gpo_rout << 2'b10;
    end

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
                //if (gpo_write_dly)
                // no matter, RIN get updated many times, only work if there is something to read
                if (!rsp_fifo_empty)
                    next_state  = ST_SEND_READ;
            end
           
            ST_SEND_READ: begin
                next_state  = ST_SEND_READ;
                if (ar_ready)
                    next_state  = ST_PROCESS_RSP;
            end
            
            ST_PROCESS_RSP: begin
                next_state  = ST_PROCESS_RSP;
                if (r_last && r_valid && r_ready) begin
                    // If RE (response interrupt enable) then send ROUT update
                    // else not
                    // TEST CASE IS NOT YET BUILT FOR THIS, NOTE IN SYSTEM TEST, hard to send this
                    // now it always send rout update, comment out this code then build that test case
                    /*
                    if (gpo_re_dly)
                        next_state  = ST_ROUT_UPDATE;
                    else
                        next_state  = ST_IDLE;
                     */
                    next_state  = ST_ROUT_UPDATE;
                end
            end

            ST_ROUT_UPDATE: begin
                // note that the ROUT update carry the RA bit
                // to tell the scheduler if it needs to send IRQ or not
                next_state  = ST_ROUT_UPDATE;
                if (req_valid && req_ready) begin
                    if (!pending_rd_active)
                        next_state  = ST_IDLE;
                    else
                        next_state  = ST_SEND_READ;
                end
            end
                        
        endcase // case (state)
    end

    // +--------------------------------------------------
    // | State Machine: state outputs
    // +--------------------------------------------------

    
    always_comb begin
        ar_valid     = '0;
        req_valid    = '0;
        word_cnt_en  = '0;
        req_valid    = '0;
        req_data     = '0;
        case (state)
            ST_IDLE: begin
                ar_valid     = '0;
                req_valid    = '0;
                word_cnt_en  = '0;
                req_valid    = '0;
                req_data     = '0;
            end 
            
            ST_SEND_READ: begin
                ar_valid     = 1'b1;
                req_valid    = '0;
                word_cnt_en  = '0;
                req_data     = '0;
            end
            
            ST_PROCESS_RSP: begin
                ar_valid          = '0;
                req_valid         = '0;
                word_cnt_en       = '0;
                req_data          = '0;
            end

            ST_ROUT_UPDATE: begin
                ar_valid     = '0;
                req_valid    = 1'b1;
                word_cnt_en  = '0;
                //!!! NOW only 6 bits, current test use 38, change the test then change this
                req_data     = sdm_fifo_rd_ptr;
            end
                        
        endcase
    end // always_comb
    // | 
    // +--------------------------------------------------

    // +--------------------------------------------------
    // | Count the number of response recevie
    // +--------------------------------------------------

        // State machine
    typedef enum bit 
    {
     ST_EOP_HEADER             = 1'b0,
     ST_EOP_COUNTING_BEAT      = 1'b1
     } t_state_eop_sm;
    t_state_eop_sm state_eop, next_state_eop;

    reg [10 : 0] beat_counter;
    reg [10 : 0] next_beat_counter;
    reg [10 : 0] packet_length;
    reg [10 : 0] packet_length_wire;
    reg [10 : 0] packet_length_reg;
    wire         end_of_packet;
        
    // +--------------------------------------------------
    // | State Machine: update state
    // +--------------------------------------------------
    // |
    always_ff @(posedge clk) begin
        if (reset)
            state_eop <= ST_EOP_HEADER;
        else
            state_eop <= next_state_eop;
    end
    // +--------------------------------------------------
    // | State Machine: next state condition
    // +--------------------------------------------------
    always_comb begin
        next_state_eop  = ST_EOP_HEADER;
        case (state_eop)
            ST_EOP_HEADER: begin
                next_state_eop  = ST_EOP_HEADER;
                if (r_valid_internal && out_ready) begin
                    if (packet_length == '0)
                        next_state_eop  = ST_EOP_HEADER;
                    else                    
                        next_state_eop  = ST_EOP_COUNTING_BEAT;
                end
            end

            ST_EOP_COUNTING_BEAT : begin
                next_state_eop  = ST_EOP_COUNTING_BEAT;
                if (end_of_packet && out_ready && out_valid)
                    next_state_eop  = ST_EOP_HEADER;
            end
                                   
        endcase // case (state_eop)
    end // always_comb
    
    // +--------------------------------------------------
    // | State Machine: state outputs
    // +--------------------------------------------------
    reg end_of_packet_single_word;
    reg end_of_packet_multi_words;
    
    always_comb begin
        case (state_eop)
            
            ST_EOP_HEADER: begin
                packet_length              = packet_length_wire;
                end_of_packet_single_word  = (packet_length == '0) && r_valid_internal;;
                end_of_packet_multi_words  = '0;
            end

            ST_EOP_COUNTING_BEAT: begin
                packet_length              = packet_length_reg;
                end_of_packet_single_word  = 1'b0;
                if (beat_counter == (packet_length - 1)) 
                    end_of_packet_multi_words  = 1'b1;
                else
                    end_of_packet_multi_words  = '0;
            end
                        
        endcase // case (state_eop)
    end // always_comb

    assign packet_length_wire  = out_data[22 : 12];
    
    always_ff @(posedge clk) begin
        if (reset)
            packet_length_reg <= '0;
        else begin
            if (state_eop == ST_EOP_HEADER)
                packet_length_reg <= packet_length_wire;
        end
    end // always_ff @

    always_comb begin
        if (state_eop == ST_EOP_COUNTING_BEAT) begin
            if (r_valid_internal && out_ready)
                next_beat_counter  = beat_counter + 1'b1;
            else
                next_beat_counter = beat_counter;
        end
        else
            next_beat_counter = '0;
            
    end
    
    always_ff @(posedge clk) begin
        if (reset)
            beat_counter <= 11'h0;                
        else begin
            beat_counter  <= next_beat_counter;
        end
    end
    
    // set (state_eop == ) to only assert eop within this state. there is case when next word is first word of
    // second packet, eop migh trigger, not big problem but put a note here
    assign end_of_packet = end_of_packet_single_word || end_of_packet_multi_words;
        
    // +--------------------------------------------------------------------
    // | Read GPO information: RIN and RA (response active)
    // | RA: if this bit is set, then SDM want to be interrupted if ROUT changes
    // |     if not set, driver still write ROUT but should not set interrupt
    // +--------------------------------------------------------------------

    assign gpo_addr  = gpo_data[7:6];
    assign gpo_rin   = gpo_data[5:0];
    assign gpo_re    = gpo_data[5];
    
    // flop input gpo
    always_ff @(posedge clk) begin
        if (reset) begin
            gpo_rin_dly <= '0;
            gpo_re_dly  <= '0;
        end
        else begin
            if (gpo_write && (gpo_addr == 2'b00)) 
                gpo_rin_dly <= gpo_rin;
            if (gpo_write && (gpo_addr == 2'b01)) 
                gpo_re_dly <= gpo_re;
        end
    end // always_ff @
    
    always_ff @(posedge clk) begin
        if (reset)
            gpo_write_dly <= '0;
        else begin
            if (gpo_addr == 2'b00)
                gpo_write_dly <= gpo_write;
        end
    end
    
    // There may be case when SDM update RIN at the time, the read controller is busy reading response
    // the read controller, will alwasy run anytime it detects that the fifo is not empty, mean got something
    // inside mailbox response fifo, its reponsibility is just get those data out
    // This also help in case accidently update RIN but the fifo empty so it will not do anything
    always_comb begin
        rsp_fifo_empty = (gpo_rin_dly == gpo_rout);
    end

    assign sdm_fifo_read                = out_valid && out_ready;
    assign sdm_fifo_incremented_rd_ptr  = sdm_fifo_rd_ptr + 5'b1;
    assign sdm_fifo_next_rd_ptr         = sdm_fifo_read ? sdm_fifo_incremented_rd_ptr : sdm_fifo_rd_ptr;
    
    
    always_ff @(posedge clk) begin
        if (reset)
            sdm_fifo_rd_ptr  <= '0;
        else
            sdm_fifo_rd_ptr <= sdm_fifo_next_rd_ptr;
    end

    always_comb begin
        sdm_fifo_next_full   = sdm_fifo_full;
        if (sdm_fifo_read) begin
            sdm_fifo_next_full  = '0;
        end
        //if (gpo_write) begin
        if (gpo_write && (gpo_addr == 2'b00)) begin
            if ((gpo_rin[4:0] == gpo_rout[4:0]) && (gpo_rin[5] != gpo_rout[5]))
                sdm_fifo_next_full  = 1'b1;
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            sdm_fifo_full  <= '0;
            end
        else begin
            sdm_fifo_full  <= sdm_fifo_next_full;
        end
    end    

    // +--------------------------------------------------
    // | AXI Output assignment for some only use default value
    // +--------------------------------------------------
    
    always_comb begin
        r_valid_internal  = r_valid;
    end
    assign r_ready  = out_ready;
    
    always_comb begin
        // Read channel: setting default value
        ar_id      = '0;
        ar_size    = 3'b010;
        // Only do INCR
        ar_burst   = 2'b01;
        // Normal access
        ar_lock    = '0;
        ar_cache   = '0;
        ar_prot    = '0;
        ar_qos     = '0;
        ar_user    = '0;
        // Write channel: no use        
        aw_id      = '0;
        aw_addr    = '0;
        aw_len     = '0;
        aw_size    = '0;
        aw_burst   = '0;
        aw_lock    = '0;
        aw_cache   = '0;
        aw_prot    = '0;
        aw_qos     = '0;
        aw_valid   = '0;
        aw_user    = '0;
        // Write data channel: no use
        w_data     = '0;
        w_strb     = '0;
        w_last     = '0;
        w_valid    = '0;
        b_ready    = '0;
    end
    
    
    // +--------------------------------------------------
    // | Avalon ST Output assignment for some only use default value
    // +--------------------------------------------------
    assign out_data          = r_data;
    assign out_valid         = r_valid_internal;
    assign out_startofpacket = (state_eop == ST_EOP_HEADER);
    assign out_endofpacket   = end_of_packet;

    function integer clogb2;
        input [63:0] value;
        begin
            clogb2 = 0;
            while (value>0) begin
                value = value >> 1;
                clogb2 = clogb2 + 1;
            end
            clogb2 = clogb2 - 1;
        end
    endfunction // clogb2
    
endmodule
