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

module altera_mailbox_urg_controller
#(
  parameter URG_PCK_WIDTH      = 32,
  parameter USE_MEMORY_BLOCKS  = 1
  )    
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input                            clk,
    input                            reset,
    
    // +--------------------------------------------------
    // | Avl ST command packet signals
    // +--------------------------------------------------
    input [URG_PCK_WIDTH-1: 0]       in_data,
    input                            in_valid,
    input                            in_startofpacket,
    input                            in_endofpacket,
    output                           in_ready,

    // +--------------------------------------------------
    // | Avl ST output packet signals
    // +--------------------------------------------------
    output reg [URG_PCK_WIDTH-1 : 0] out_data,
    output reg                       out_valid,
    output reg                       out_startofpacket,
    output reg                       out_endofpacket,
    input                            out_ready,
    
    // +--------------------------------------------------
    // | GPIO signals
    // +--------------------------------------------------
    input                            gpo_write,
    input [7:0]                      gpo_data
    );

    // +--------------------------------------------------
    // | Internal signals
    // +--------------------------------------------------
    wire [URG_PCK_WIDTH-1 : 0]       out_data_fifo;
    wire                             out_valid_fifo;
    wire                             out_startofpacket_fifo;
    wire                             out_endofpacket_fifo;
    wire                             out_ready_fifo;
    reg                              ua_reg;                                    
    wire [1:0]                       gpo_addr;
    // +--------------------------------------------------
    // | Read GPO information (UA)
    // +--------------------------------------------------
    assign gpo_addr = gpo_data[7:6];
    always_ff @(posedge clk) begin
        if (reset)
            ua_reg <= '0;
        else begin
            if (gpo_write && (gpo_addr == 2'b11) && (gpo_data[0] == 1'b1)) 
                ua_reg <= 1'b1;
            else
                ua_reg <= '0;
        end
    end // always_ff @
    //    
    // State machine
    typedef enum bit [2:0]
    {
     ST_IDLE           = 3'b001,
     ST_SEND_URG       = 3'b010,
     ST_WAITING_ACK    = 3'b100
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
                if (out_valid_fifo) // If there is something in fifo, start working
                    next_state = ST_SEND_URG;
            end

            ST_SEND_URG: begin
                next_state  = ST_SEND_URG;
                if (out_ready)
                    next_state = ST_WAITING_ACK;
            end

            ST_WAITING_ACK: begin
                next_state  = ST_WAITING_ACK;
                if (ua_reg) begin
                    if (out_valid_fifo)
                        next_state  = ST_SEND_URG;
                    else
                        next_state  = ST_IDLE;
                end
            end
            
        endcase // case (state)
    end // always_comb

   
    // +--------------------------------------------------
    // | Outputs
    // +--------------------------------------------------
    always_comb begin
        out_valid          = (state == ST_SEND_URG);
        out_data           = out_data_fifo;
        out_startofpacket  = out_startofpacket_fifo;
        out_endofpacket    = out_endofpacket_fifo;
    end
    // ready signal of the fifo
    assign out_ready_fifo  = (state == ST_SEND_URG) && out_ready;
    
    // | 
    // +--------------------------------------------------
    

    // +--------------------------------------------------
    // | Internal FIFO for imcomming packet
    // +--------------------------------------------------
    altera_avalon_sc_fifo 
  #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (URG_PCK_WIDTH),
    .FIFO_DEPTH          (16),
    .CHANNEL_WIDTH       (0),
    .ERROR_WIDTH         (0),
    .USE_PACKETS         (1),
    .USE_FILL_LEVEL      (0),
    .EMPTY_LATENCY       (3),
    .USE_MEMORY_BLOCKS   (USE_MEMORY_BLOCKS),
    .USE_STORE_FORWARD   (0),
    .USE_ALMOST_FULL_IF  (0),
    .USE_ALMOST_EMPTY_IF (0)
    ) urg_fifo 
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
    .out_ready         (out_ready_fifo),
    .out_startofpacket (out_startofpacket_fifo),                           
    .out_endofpacket   (out_endofpacket_fifo),                                  
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

endmodule
