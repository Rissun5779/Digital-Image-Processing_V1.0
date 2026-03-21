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


// $Id: //acds/rel/18.1std/ip/sld/mm/altera_avalon_transacto/altera_avalon_transacto.sv#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $

`default_nettype none
`timescale 1ns / 1ns
module altera_avalon_transacto_h2t_fsm #(
    parameter DATA_W = 32,
              BYTEENABLE_W = DATA_W / 8,
              TRANSACTION_CODE_W = 2,
              SEQ_W = 8,
              CMD_W = 8
  )
  (
  input  wire       h2t_valid,
  input  wire       h2t_sop,
  input  wire       h2t_eop,
  input  wire [DATA_W - 1 : 0] h2t_data,
  output reg        h2t_ready,

  output reg [CMD_W - 1 : 0] cmd,
  output reg request_t2h_status,
  input wire ack_t2h_status,

  output reg clear_reset_flags,
  output reg capture_byteenable,
  output reg capture_size,
  output reg capture_addr,
  output reg capture_writedata,
  output reg start_mm_transaction,
  output reg [TRANSACTION_CODE_W - 1 : 0] mm_transaction_code,

  output reg request_mm_write_status,
  input wire inactive,
  input wire t2h_read_complete,
  input wire mm_write_complete,
  input wire mm_next_write,
  input wire user_reset_flag,
  input wire t2h_packet_sent,
  input wire rising_user_reset,

  input wire ack_terminate_packet,
  output reg terminate_packet,

  input wire clk,
  input wire reset
);

  localparam
              // Bit indices within the command byte
              CMD_READ_BIT = 4,
              CMD_INC_BIT = 2,
              // start indices for fields within h2t_data
              CMD_INDEX = 24;
  
  typedef enum int unsigned {
    ST_IDLE,
    ST_DISCARD,
    ST_REQUEST_STATUS,
    ST_GET_ADDR,
    ST_WAIT_READ_COMPLETE,
    ST_AWAIT_WRITEDATA,
    ST_WAIT_WRITE_COMPLETE,
    ST_WAIT_ACK_TERMINATE_PACKET,
    ST_FAIL
  } t_h2t_state;
  t_h2t_state h2t_state, p1_h2t_state;

  typedef enum logic [7:0] {
    CMD_WRITE_FIXED = 8'h00,
    CMD_WRITE_INC = 8'h04,
    CMD_READ_FIXED = 8'h10,
    CMD_READ_INC = 8'h14,
    CMD_RESTART = 8'h20,
    CMD_CAPTURE_BYTEENABLE = 8'h21,
    CMD_NOP = 8'h7F
  } t_cmd;

  logic p1_h2t_ready;
  logic [CMD_W - 1 : 0] p1_cmd;
  logic p1_request_t2h_status;
  logic p1_clear_reset_flags;
  logic p1_capture_byteenable;
  logic p1_capture_size;
  logic p1_capture_addr;
  logic p1_capture_writedata;
  logic p1_start_mm_transaction;
  logic p1_request_mm_write_status;
  logic [TRANSACTION_CODE_W - 1 : 0] p1_mm_transaction_code;
  logic p1_terminate_packet;
  logic t2h_packet_owed;

  // Keep track of if we're in the middle of an h2t packet. 
  // This is needed while handling h2t packets which are interrupted by a
  // user-side reset.
  logic in_h2t_packet;
  logic need_ack_terminate;
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      in_h2t_packet <= '0;
      need_ack_terminate <= '0;
    end
    else begin
      if (h2t_valid & h2t_ready & (h2t_sop | h2t_eop))
        in_h2t_packet <= ~h2t_eop;
      if (p1_terminate_packet | ack_terminate_packet)
        need_ack_terminate <= ~ack_terminate_packet;
    end
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      h2t_state <= ST_IDLE;
      h2t_ready <= 1'b0;
      cmd <= 'x;
      request_t2h_status <= '0;
      clear_reset_flags <= '0;
      capture_byteenable <= '0;
      capture_size <= '0;
      capture_addr <= '0;
      capture_writedata <= '0;
      start_mm_transaction <= '0;
      mm_transaction_code <= '0;
      request_mm_write_status <= '0;
      t2h_packet_owed <= '0;
      terminate_packet <= '0;
    end
    else begin
      h2t_state <= p1_h2t_state;
      h2t_ready <= p1_h2t_ready;
      cmd <= p1_cmd;
      request_t2h_status <= p1_request_t2h_status;
      clear_reset_flags <= p1_clear_reset_flags;
      capture_byteenable = p1_capture_byteenable;
      capture_size <= p1_capture_size;
      capture_addr <= p1_capture_addr;
      capture_writedata <= p1_capture_writedata;
      start_mm_transaction <= p1_start_mm_transaction;
      mm_transaction_code <= p1_mm_transaction_code;
      request_mm_write_status <= p1_request_mm_write_status;
      terminate_packet <= p1_terminate_packet;

      // If we received h2t_sop, we owe a t2h packet.  Clear on sending
      // that packet.  Priority to receiving sop.
      // In this case be careful not to capture unless the sop beat is
      // actually accepted; otherwise, h2t could start an sop beat, but 
      // be backpressured, and deassert bfore h2t_ready; then if a user-side
      // reset occured, a spurious t2h response would be sent.
      if ((h2t_valid & h2t_sop & h2t_ready) | t2h_packet_sent) begin
        t2h_packet_owed <= h2t_valid & h2t_sop & h2t_ready;
      end
    end
  end

  always @* begin : h2t_fsm_state_transition
    // default assignments
    p1_h2t_state = h2t_state;
    p1_cmd = cmd;

    p1_request_t2h_status = 1'b0;
    p1_h2t_ready = '0;
    p1_clear_reset_flags = '0;
    p1_capture_byteenable = '0;
    p1_capture_size = '0;
    p1_capture_addr = '0;
    p1_capture_writedata = '0;
    p1_start_mm_transaction = '0;
    p1_request_mm_write_status = '0;
    p1_mm_transaction_code = mm_transaction_code;
    p1_terminate_packet = '0;

    if (h2t_valid & h2t_sop) begin
      // capture command.
      p1_cmd = h2t_data[CMD_INDEX +: CMD_W];
    end

    if (rising_user_reset & t2h_packet_owed) begin
      // An h2t packet was received, thus a t2h response is due - but a
      // user-side reset has occured, preventing any mm_fsm transactions from
      // completing normally. Go terminate the t2h packet.
      p1_h2t_state = ST_WAIT_ACK_TERMINATE_PACKET;
      p1_h2t_ready = '1;
      // On a subsequent rising_user_reset while we're awaiting
      // acknowledgement, don't repeat the termination.
      p1_terminate_packet = h2t_state != ST_WAIT_ACK_TERMINATE_PACKET;
    end
    else begin
      case (h2t_state)
        ST_IDLE: begin
          if (h2t_valid & h2t_sop) begin
            // 1st cycle: ready is 0, set to 1
            // 2nd cycle: ready is 1, set to 0.
            p1_h2t_ready = ~h2t_ready;
            p1_capture_size = ~h2t_ready;
            if (h2t_eop) begin
              // Deal with single-beat commands (Restart, Set Byteenable).
              if (~h2t_ready) begin
                if (p1_cmd == CMD_RESTART) begin
                  p1_clear_reset_flags = '1;
                end
                if (~inactive) begin
                  if (p1_cmd == CMD_CAPTURE_BYTEENABLE) begin
                    p1_capture_byteenable = '1;
                  end
                  // ... in the future, other Set Flags commands will assert other triggers from
                  // this module.
                end
              end
              else begin // h2t_ready
                p1_request_t2h_status = 1'b1;
                p1_h2t_state = ST_REQUEST_STATUS;
              end
            end
            else begin
              // Multi-beat commands (everything except Set Flags).
              if (!inactive && 
                (p1_cmd == CMD_WRITE_FIXED) || 
                (p1_cmd == CMD_WRITE_INC) || 
                (p1_cmd == CMD_READ_FIXED) || 
                (p1_cmd == CMD_READ_INC)) 
              begin
                // If in active state, capture transaction size and wait for the
                // address on the next beat.
                if (~h2t_ready) begin
                  // p1_capture_size = '1;
                end
                else begin
                  p1_h2t_state = ST_GET_ADDR;
                end
              end
              else begin
                // If inactive or unrecognized command, go discard data until eop, then respond with
                // status.
                p1_h2t_ready = '1;
                p1_h2t_state = ST_DISCARD;
              end
            end
          end
        end

        ST_DISCARD: begin
          p1_h2t_ready = '1;
          if (h2t_valid & h2t_ready & h2t_eop) begin
            p1_h2t_ready = '0;
            p1_request_t2h_status = 1'b1;
            p1_h2t_state = ST_REQUEST_STATUS;
          end
        end

        ST_REQUEST_STATUS: begin
          // wait until the t2h fsm says the status packet has been sent.
          if (ack_t2h_status) begin
            p1_h2t_state = ST_IDLE;
          end
        end

        ST_GET_ADDR: begin
          if (h2t_valid) begin
            p1_h2t_ready = ~h2t_ready;
            if (~h2t_ready) begin
              p1_capture_addr = '1;
            end
            else begin
              p1_mm_transaction_code = {cmd[CMD_INC_BIT], cmd[CMD_READ_BIT]};
              if (cmd[CMD_READ_BIT]) begin
                p1_start_mm_transaction = '1;
                // Hand control off to the mm fsm (which executes reads,
                // calculates the read address, and determines when the
                // transaction is complete) and the
                // t2h fsm (which passes returning readdata to the host).
                p1_h2t_state = ST_WAIT_READ_COMPLETE;
              end 
              else begin
                // It's a write. The interaction is between the h2t fsm (which
                // receives writedata) and the mm fsm (which executes the writes,
                //  calculates the write address and determines when the
                //  transaction is complete.
                p1_h2t_state = ST_AWAIT_WRITEDATA;
              end
            end
          end
        end
      
        ST_WAIT_READ_COMPLETE: begin
          if (t2h_read_complete) begin
            p1_h2t_state = ST_IDLE;
          end
        end

        ST_AWAIT_WRITEDATA: begin
          if (h2t_valid) begin
            p1_h2t_ready = ~h2t_ready;
            if (~h2t_ready) begin
              p1_capture_writedata = '1;
              p1_start_mm_transaction = '1;
            end
            else begin
              p1_h2t_state = ST_WAIT_WRITE_COMPLETE;
            end
          end
        end

        ST_WAIT_WRITE_COMPLETE: begin
          if (mm_write_complete) begin
            p1_request_mm_write_status = '1;
            p1_h2t_state = ST_REQUEST_STATUS;
          end
          else if (mm_next_write) begin
            p1_h2t_state = ST_AWAIT_WRITEDATA;
          end
        end

        ST_WAIT_ACK_TERMINATE_PACKET: begin
          // Wait here, absorbing (discarding) h2t beats until we see h2t_eop,
          // and the terminate has been acked.
          p1_h2t_ready = in_h2t_packet;
          if (~need_ack_terminate & ~in_h2t_packet) begin
            p1_h2t_state = ST_IDLE;
          end
        end

        ST_FAIL: begin
          p1_h2t_state = ST_FAIL;
        end
      endcase
    end
  end
endmodule

module altera_avalon_transacto_t2h_fsm #(
    parameter DATA_W = 32
  )
  (
  output reg       t2h_valid,
  output reg       t2h_sop,
  output reg       t2h_eop,
  output reg [DATA_W - 1 : 0] t2h_data,
  input  wire      t2h_ready,

  input wire user_reset_flag,
  input wire debug_reset_flag,
  input wire request_t2h_status, // valid
  output reg ack_t2h_status, // ready

  output reg t2h_read_complete,

  // readdata "FIFO" interface signals
  // Only the write interface is exposed, because reads occur internal to this
  // module.
  input wire fifo_write,
  input wire [DATA_W - 1 : 0] fifo_writedata,
  output reg fifo_full,
  input wire request_mm_read_status,
  input wire request_mm_write_status,
  input wire capture_size,
  input wire [DATA_W - 1 : 0] h2t_data,

  input wire terminate_packet,
  output reg ack_terminate_packet,

  input wire clk,
  input wire reset
);

  localparam VERSION = 16'h00_01,
             SIZE_INDEX = 0,
             SIZE_W = 16,
             SEQ_W  = 8,
             SEQ_INDEX = 16;

  typedef enum int unsigned {
    ST_IDLE,
    ST_SEND_STATUS,
    ST_SEND_READ_STATUS,
    ST_SEND_WRITE_STATUS,
    ST_AWAIT_READDATA,
    ST_TERMINATE_PACKET,
    ST_FAIL
  } t_t2h_state;
  t_t2h_state t2h_state, p1_t2h_state;

  logic p1_t2h_valid;
  logic p1_t2h_sop, p1_t2h_eop;
  logic [DATA_W - 1 : 0] p1_t2h_data;
  logic p1_ack_t2h_status;
  logic p1_t2h_read_complete;
  logic p1_ack_terminate_packet;
  reg [SEQ_W - 1 : 0] seq;
  reg fifo_empty;
  reg [SIZE_W - 1 : 0] size;
  reg [SIZE_W - 1 : 0] readdata_remaining;
  wire [31:0] status_response = {6'b0, debug_reset_flag, user_reset_flag, seq, VERSION};
  wire [31:0] mm_transaction_response = {6'b0, debug_reset_flag, user_reset_flag, seq, size};

  reg [DATA_W - 1 : 0] readdata_reg;
  reg fifo_read_if_ready;
  logic p1_fifo_read_if_ready;
  wire fifo_read = t2h_ready & fifo_read_if_ready;
  wire p1_fifo_empty = (fifo_read & ~fifo_write) ? 1'b1 :
                       (fifo_write & ~fifo_read) ? 1'b0 :
                       fifo_empty;
  reg sop_already_sent;
  wire p1_sop_already_sent = 
    (t2h_valid & t2h_ready & t2h_eop) ? '0 :
    (t2h_valid & t2h_ready & t2h_sop) ? '1 :
      sop_already_sent;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      fifo_full <= '0;
      fifo_empty <= '1;
      readdata_reg <= '0;
      fifo_read_if_ready <= '0;
      sop_already_sent <= '0;
    end
    else begin
      fifo_empty <= p1_fifo_empty;
      fifo_read_if_ready <= p1_fifo_read_if_ready;
      if (fifo_write & ~fifo_read) begin
        readdata_reg <= fifo_writedata;
        fifo_full <= '1;
      end
      else if (fifo_read & ~fifo_write) begin
        fifo_full <= '0;
      end

      sop_already_sent = p1_sop_already_sent;
    end
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      seq <= '0;
      size <= '0;
      readdata_remaining <= '0;
    end
    else begin
      if (capture_size) begin
        seq <= h2t_data[SEQ_INDEX +: SEQ_W];
        size <= h2t_data[SIZE_INDEX +: SIZE_W];
        readdata_remaining <= h2t_data[SIZE_INDEX +: SIZE_W];
      end
      else if (fifo_read) begin
        readdata_remaining <= readdata_remaining - 1'b1;
      end
    end
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      t2h_state <= ST_IDLE;

      t2h_valid <= '0;
      t2h_data <= 'x;
      t2h_sop <= 'x;
      t2h_eop <= 'x;

      ack_t2h_status <= '0;
      t2h_read_complete <= '0;
      ack_terminate_packet <= '0;
    end
    else begin
      t2h_state <= p1_t2h_state;

      t2h_valid <= p1_t2h_valid;
      t2h_data <= p1_t2h_data;
      t2h_sop <= p1_t2h_sop;
      t2h_eop <= p1_t2h_eop;

      ack_t2h_status <= p1_ack_t2h_status;
      t2h_read_complete <= p1_t2h_read_complete;
      ack_terminate_packet <= p1_ack_terminate_packet;
    end
  end

  reg seen_terminate_packet;
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      seen_terminate_packet <= '0;
    end
    else begin
      if (terminate_packet | p1_ack_terminate_packet) begin
        seen_terminate_packet <= terminate_packet;
      end
    end
  end

  always @* begin : t2h_fsm_state_transition
    // default assignments
    p1_t2h_state = t2h_state;
    p1_t2h_valid = '0;
    p1_t2h_data = 'x;
    p1_fifo_read_if_ready = '0;
    p1_t2h_sop = 'x;
    p1_t2h_eop = 'x;
    p1_ack_t2h_status = '0;
    p1_t2h_read_complete = '0;
    p1_ack_terminate_packet = '0;

    case (t2h_state)
      ST_IDLE: begin
        if (terminate_packet | seen_terminate_packet) begin
          p1_t2h_state = ST_TERMINATE_PACKET;
        end
        else begin
          if (request_t2h_status) begin
            p1_t2h_state = ST_SEND_STATUS;
            p1_t2h_valid = '1;
            p1_t2h_sop = '1;
            p1_t2h_eop = '1;
            p1_t2h_data = status_response;
          end
          else if (request_mm_read_status) begin
            p1_t2h_state = ST_SEND_READ_STATUS;
            p1_t2h_valid = '1;
            p1_t2h_sop = '1;
            p1_t2h_eop = '0;
            p1_t2h_data = mm_transaction_response;
          end
          else if (request_mm_write_status) begin
            p1_t2h_state = ST_SEND_WRITE_STATUS;
            p1_t2h_valid = '1;
            p1_t2h_sop = '1;
            p1_t2h_eop = '1;
            p1_t2h_data = mm_transaction_response;
          end
        end
      end

      // Possible to merge ST_SEND_STATUS, ST_SEND_WRITE_STATUS?
      ST_SEND_STATUS: begin
        p1_t2h_valid = '1;
        p1_t2h_sop = '1;
        p1_t2h_eop = '1;
        p1_t2h_data = status_response;

        if (t2h_ready) begin
          p1_ack_t2h_status = '1;
          p1_t2h_state = ST_IDLE;

          p1_t2h_valid = '0;
          p1_t2h_sop = 'x;
          p1_t2h_eop = 'x;
        end
      end

      ST_SEND_WRITE_STATUS: begin
        p1_t2h_valid = '1;
        p1_t2h_sop = '1;
        p1_t2h_eop = '1;
        p1_t2h_data = mm_transaction_response;

        if (t2h_ready) begin
          p1_ack_t2h_status = '1;
          p1_t2h_state = ST_IDLE;

          p1_t2h_valid = '0;
          p1_t2h_sop = 'x;
          p1_t2h_eop = 'x;
        end
      end

      ST_SEND_READ_STATUS: begin

        if (t2h_ready) begin
          if (terminate_packet | seen_terminate_packet) begin
            p1_t2h_state = ST_TERMINATE_PACKET;
          end
          else begin
            p1_t2h_state = ST_AWAIT_READDATA;

            p1_t2h_valid = '0;
            p1_t2h_sop = 'x;
            p1_t2h_eop = 'x;
          end
        end
        else begin
          p1_t2h_valid = '1;
          p1_t2h_sop = '1;
          p1_t2h_eop = '0;
          p1_t2h_data = mm_transaction_response;
        end
      end

      ST_AWAIT_READDATA: begin
        if (terminate_packet) begin
          p1_t2h_state = ST_TERMINATE_PACKET;
        end
        else begin
          if (~fifo_empty & ~p1_fifo_empty) begin
            p1_fifo_read_if_ready = '1;
            p1_t2h_valid = '1;
            p1_t2h_data = readdata_reg;
            p1_t2h_sop = '0;
            p1_t2h_eop = (readdata_remaining > {{(SIZE_W - 1) {1'b0}}, 1'b1}) ? '0 : '1;
          end
          if (readdata_remaining > {SIZE_W {1'b0}}) begin
            p1_t2h_state = ST_AWAIT_READDATA;
          end
          else begin
            p1_t2h_read_complete = '1;
            p1_t2h_state = ST_IDLE;
          end
        end
      end

      // Possibly it's not necessary to have a new state just for terminating
      // the packet upon user reset, but it will be handy for debugging.
      ST_TERMINATE_PACKET: begin
        p1_t2h_data = status_response;
        p1_t2h_valid = '1;
        p1_t2h_sop = ~sop_already_sent;
        p1_t2h_eop = '1;

        if (t2h_valid & t2h_ready) begin
          p1_t2h_read_complete = '1;
          p1_ack_terminate_packet = '1;
          p1_t2h_state = ST_IDLE;

          p1_t2h_valid = '0;
          p1_t2h_sop = 'x;
          p1_t2h_eop = 'x;
        end
      end

      ST_FAIL: begin
        p1_t2h_valid = '0;
        p1_t2h_state = ST_FAIL;
      end
    endcase
  end
endmodule

module altera_avalon_transacto_mm_fsm #(
    parameter DATA_W = 32,
              BYTEENABLE_W = DATA_W / 8,
              TRANSACTION_CODE_W = 2,
              MM_ADDR_WIDTH = 32
  )
  (
  output reg read,
  output reg write,
  output reg [DATA_W - 1: 0] writedata,
  input  wire [DATA_W - 1: 0] readdata,
  output reg [MM_ADDR_WIDTH - 1 : 0] address,
  output reg [DATA_W/8 - 1 : 0] byteenable,
  input wire waitrequest,
  input wire readdatavalid,

  input wire capture_byteenable,
  input wire capture_size,
  input wire capture_addr,
  input wire capture_writedata,
  input wire [DATA_W - 1 : 0] h2t_data,
  input wire start_mm_transaction,
  input wire [TRANSACTION_CODE_W - 1 : 0] mm_transaction_code,
  input wire fifo_full,
  output reg request_mm_read_status,
  output reg mm_write_complete,
  output reg mm_next_write,

  input wire clk,
  input wire reset
);

  localparam
              // start indices for fields within h2t_data
              SIZE_INDEX = 0,
              SIZE_W = 16,
              ADDR_INDEX = 0,
              BYTEENABLE_INDEX = 0,
              WRITEDATA_INDEX = 0,

              // indices in mm_transaction_code
              CMD_INC_BIT = 1,
              CMD_READ_BIT = 0;


  typedef enum int unsigned {
    ST_IDLE,
    ST_READ,
    ST_WRITE,
    ST_CMD_WAIT,
    ST_RDV_WAIT,
    ST_FIFO_WAIT
  } t_mm_state;
  t_mm_state mm_state, p1_mm_state;

  // Capture various fields from h2t_data, on command from h2t_fsm.
  reg [SIZE_W - 1 : 0] size;
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      size <= '0;
    end
    else begin
      if (capture_size) begin
        size <= h2t_data[SIZE_INDEX +: SIZE_W];
      end
      else if ((read | write) & ~waitrequest) begin
        size <= size - 1'b1;
      end
    end
  end

  reg [SIZE_W - 1 : 0] readdata_remaining;
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      readdata_remaining <= '0;
    end
    else begin
      if (capture_size) begin
        readdata_remaining <= h2t_data[SIZE_INDEX +: SIZE_W];
      end
      else if (readdatavalid) begin
        readdata_remaining <= readdata_remaining - 1'b1;
      end
    end
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      byteenable <= '1;
    end
    else begin
      if (capture_byteenable) begin
        byteenable <= h2t_data[BYTEENABLE_INDEX +: BYTEENABLE_W];
      end
    end
  end

  logic increment_address; // should be reg?
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      address <= '0;
    end
    else begin
      if (capture_addr) begin
        address <= h2t_data[ADDR_INDEX +: MM_ADDR_WIDTH];
      end
      else if (increment_address) begin
        address <= address + 3'h4;
      end
    end
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      writedata <= '0;
    end
    else if (capture_writedata) begin
      writedata <= h2t_data[WRITEDATA_INDEX +: DATA_W];
    end
  end

  // Avalon-MM transactor fsm.
  logic p1_read;
  logic p1_write;
  logic p1_request_mm_read_status;
  logic p1_mm_write_complete;
  logic p1_mm_next_write;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      mm_state <= ST_IDLE;
      read <= '0;
      write <= '0;
      request_mm_read_status = '0;
      mm_write_complete = '0;
    end
    else begin
      mm_state <= p1_mm_state;
      read <= p1_read;
      write <= p1_write;
      request_mm_read_status = p1_request_mm_read_status;
      mm_write_complete = p1_mm_write_complete;
      mm_next_write = p1_mm_next_write;
    end
  end

  always @* begin : mm_fsm_state_transition
    // default assignments
    p1_mm_state = mm_state;
    p1_read = '0;
    p1_write = '0;
    increment_address = '0;
    p1_request_mm_read_status = '0;
    p1_mm_write_complete = '0;
    p1_mm_next_write = '0;

    case (mm_state)
      ST_IDLE: begin
        if (start_mm_transaction) begin
          p1_read = mm_transaction_code[CMD_READ_BIT];
          p1_request_mm_read_status = mm_transaction_code[CMD_READ_BIT];
          p1_write = ~mm_transaction_code[CMD_READ_BIT];
          p1_mm_state = ST_CMD_WAIT;
        end
      end

      ST_CMD_WAIT: begin
        if (waitrequest) begin
          // Obey the protocol.
          p1_read = read;
          p1_write = write;
        end
        else begin
          // ~waitrequest, so a read (write) just completed.
          increment_address = mm_transaction_code[CMD_INC_BIT];
          if (read) begin
            p1_read = '0;
            p1_mm_state = ST_RDV_WAIT;
          end
          else begin
            // write
            p1_mm_state = ST_IDLE;
            if (size > ({SIZE_W {1'b0}} + 1'b1)) begin
              p1_mm_next_write = '1;
            end
            else begin
              p1_mm_write_complete = '1;
            end
          end
        end
      end

      ST_RDV_WAIT: begin
        if (readdatavalid) begin
          if (size > {SIZE_W {1'b0}}) begin
            // More reads remain - go do them.
            p1_mm_state = ST_FIFO_WAIT;
          end
          else begin
            // Done with this read.
            p1_mm_state = ST_IDLE;
          end
        end
      end

    ST_FIFO_WAIT: begin
      if (~fifo_full) begin
        p1_read = '1;
        p1_mm_state = ST_CMD_WAIT;
      end
    end
    endcase
  end

endmodule

module altera_avalon_transacto_reset_flag(
  input wire clk,
  input wire reset,
  input wire sclear,
  output reg rising_edge,
  output reg flag
);

  reg d1_flag;
  always_comb begin
    rising_edge = flag & ~d1_flag;
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      flag <= '1;
    end
    else begin
      if (sclear) begin
        flag <= '0;
      end
    end
  end

  always_ff @(posedge clk) begin
    d1_flag <= flag;
  end

endmodule

module altera_avalon_transacto #(
    parameter DATA_W = 32,
              MM_ADDR_WIDTH = 32
  )
  (
  // Avalon-ST sink (h2t)
  input  wire       h2t_valid,
  input  wire       h2t_sop,
  input  wire       h2t_eop,
  input  wire [DATA_W - 1 : 0] h2t_data,
  output reg        h2t_ready,

  // Avalon-ST source (t2h)
  output reg       t2h_valid,
  output reg       t2h_sop,
  output reg       t2h_eop,
  output reg [DATA_W - 1 : 0] t2h_data,
  input  wire      t2h_ready,

  output reg read,
  output reg write,
  output reg [DATA_W - 1: 0] writedata,
  input  wire [DATA_W - 1: 0] readdata,
  output reg [MM_ADDR_WIDTH - 1 : 0] address,
  output reg [DATA_W/8 - 1 : 0] byteenable,
  input wire waitrequest,
  input wire readdatavalid,

  // Clock sink
  input wire clk,
  // Reset sink - associated with MM master
  input wire user_reset,
  // Reset sink - associated with h2t, t2h
  input wire debug_reset
);

  localparam
              TRANSACTION_CODE_W = 2,
              SEQ_W = 8,
              CMD_W = 8;

  wire request_t2h_status;
  wire ack_t2h_status;
  wire clear_reset_flags;
  wire capture_byteenable;
  wire capture_size;
  wire capture_addr;
  wire capture_writedata;
  wire start_mm_transaction;
  wire request_mm_write_status;
  wire [TRANSACTION_CODE_W - 1 : 0 ] mm_transaction_code;
  wire [SEQ_W - 1 : 0] seq;
  wire [CMD_W - 1 : 0] cmd;
  wire user_reset_flag, debug_reset_flag;
  wire rising_user_reset;

  altera_avalon_transacto_reset_flag debug_reset_flag_generator(
    .clk (clk),
    .reset (debug_reset),
    .sclear (clear_reset_flags),
    .rising_edge (),
    .flag (debug_reset_flag)
  );

  altera_avalon_transacto_reset_flag user_reset_flag_generator(
    .clk (clk),
    .reset (user_reset),
    .sclear (clear_reset_flags),
    .rising_edge (rising_user_reset),
    .flag (user_reset_flag)
  );

  wire inactive = user_reset_flag | debug_reset_flag;
  wire t2h_read_complete;
  wire mm_write_complete;
  wire mm_next_write;
  wire ack_terminate_packet, terminate_packet;
  altera_avalon_transacto_h2t_fsm h2t_fsm(
    .h2t_valid (h2t_valid),
    .h2t_sop (h2t_sop),
    .h2t_eop (h2t_eop),
    .h2t_data (h2t_data),
    .h2t_ready (h2t_ready),
    .cmd (cmd),
    .request_t2h_status (request_t2h_status),
    .ack_t2h_status (ack_t2h_status),
    .clear_reset_flags (clear_reset_flags),
    .capture_byteenable (capture_byteenable),
    .capture_size (capture_size),
    .capture_addr (capture_addr),
    .capture_writedata (capture_writedata),
    .start_mm_transaction (start_mm_transaction),
    .mm_transaction_code (mm_transaction_code),
    .request_mm_write_status (request_mm_write_status),
    .inactive (inactive),
    .t2h_read_complete (t2h_read_complete),
    .mm_write_complete (mm_write_complete),
    .mm_next_write (mm_next_write),
    .user_reset_flag (user_reset_flag),
    .t2h_packet_sent (t2h_eop & t2h_valid & t2h_ready),
    .rising_user_reset (rising_user_reset),
    .ack_terminate_packet (ack_terminate_packet),
    .terminate_packet (terminate_packet),
    .clk (clk),
    .reset (debug_reset)
  );

  wire fifo_full;
  wire request_mm_read_status;
  altera_avalon_transacto_t2h_fsm t2h_fsm(
    .t2h_valid (t2h_valid),
    .t2h_sop (t2h_sop),
    .t2h_eop (t2h_eop),
    .t2h_data (t2h_data),
    .t2h_ready (t2h_ready),
    .user_reset_flag (user_reset_flag),
    .debug_reset_flag (debug_reset_flag),
    .request_t2h_status (request_t2h_status),
    .ack_t2h_status (ack_t2h_status),
    .t2h_read_complete (t2h_read_complete),

    .request_mm_read_status (request_mm_read_status),
    .request_mm_write_status (request_mm_write_status),
    .fifo_write (readdatavalid & ~inactive),
    .fifo_writedata (readdata),
    .fifo_full (fifo_full),
    .capture_size (capture_size),
    .h2t_data (h2t_data),

    .ack_terminate_packet (ack_terminate_packet),
    .terminate_packet (terminate_packet),

    .clk (clk),
    .reset (debug_reset)
  );

  altera_avalon_transacto_mm_fsm mm_fsm(
    .read (read),
    .write (write),
    .writedata (writedata),
    .readdata (readdata),
    .address (address),
    .byteenable (byteenable),
    .waitrequest (waitrequest),
    .readdatavalid (readdatavalid),

    .h2t_data (h2t_data),
    .capture_byteenable (capture_byteenable),
    .capture_size (capture_size),
    .capture_addr (capture_addr),
    .capture_writedata (capture_writedata),
    .start_mm_transaction (start_mm_transaction),
    .mm_transaction_code (mm_transaction_code),
    .fifo_full (fifo_full),
    .request_mm_read_status (request_mm_read_status),
    .mm_write_complete (mm_write_complete),
    .mm_next_write (mm_next_write),
    .clk (clk),
    .reset (user_reset)
  );

endmodule

`default_nettype wire

