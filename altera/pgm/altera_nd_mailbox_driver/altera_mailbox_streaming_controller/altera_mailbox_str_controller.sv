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
// | Nadder SDM mailbox command controller 
// | 
// +-----------------------------------------------------------
`timescale 1 ns/ 1 ns

module altera_mailbox_str_controller
#(
  parameter STR_PCK_WIDTH      = 32,
  parameter NUMB_4K_BLOCK      = 4,
  parameter GPI_WIDTH          = 4
  )    
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input                        clk,
    input                        reset,
    
    // +--------------------------------------------------
    // | Stream signals
    // +--------------------------------------------------
    input [STR_PCK_WIDTH-1: 0]   in_data,
    input                        in_valid,
    input                        in_startofpacket,
    input                        in_endofpacket,
    output reg                   in_ready,
    
    output reg [3:0]             stream_select,
    output reg                   stream_active,

    // +--------------------------------------------------
    // | Avl ST output packet signals
    // +--------------------------------------------------
    output reg [63 : 0]          out_data,
    output reg                   out_valid,
    output reg                   out_startofpacket,
    output reg                   out_endofpacket,
    input                        out_ready,
    
    // +--------------------------------------------------
    // | GPIO signals
    // +--------------------------------------------------
    input                        gpo_write,
    input [7:0]                  gpo_data,
    output reg [GPI_WIDTH-1 : 0] gpi_data,

    // +--------------------------------------------------
    // | GPIO signals
    // +--------------------------------------------------
    output reg                   gpi_interrupt
    );

    localparam FIFO_DEPTH    = NUMB_4K_BLOCK * 512;
    localparam IN_NUMSYMBOLS = 4;
    localparam SYMBOL_W      = 8;
    localparam END_VALUE_4K  = 511; 
    
    // +--------------------------------------------------
    // | Internal signals
    // +--------------------------------------------------
    wire [63 : 0]                out_data_fifo;
    wire                         out_valid_fifo;
    wire                         out_startofpacket_fifo;
    wire                         out_endofpacket_fifo;
    wire                         out_ready_fifo;
    wire                         in_ready_fifo;
    wire                         in_valid_fifo;

    wire [1:0]                   gpo_addr;
    reg [3:0]                    gray_value;
    wire [3:0]                   gray_out;

    reg                          ca_reg;                                    
    reg                          sa_reg;
    reg [3:0]                    stream_id_reg;
    wire                         reset_internal;
    reg                          set_irq;
    wire                         clear_irq;
    // +----------------------------------------------------------------------
    // | Read GPO information (UA)
    // | SA: Stream active -> indicate a stream operation is active
    // | CA: Credit interrupt Acknowledge -> from SDM to driver
    // | STREAM_ID: indicates which client ID is active
    // +----------------------------------------------------------------------
    assign gpo_addr = gpo_data[7:6];
    always_ff @(posedge clk) begin
        if (reset_internal) begin
            ca_reg        <= '0;
            sa_reg        <= '0;
            stream_id_reg <= '0;
        end
        else begin
            // sa and stream_id are only update value when write bit asserts
            // else hold that value for operation
            // ca: act as a pulse to clear interrupt line
            if (gpo_write && (gpo_addr == 2'b10)) begin
                sa_reg        <= gpo_data[4];
                stream_id_reg <= gpo_data[3:0];
                if (gpo_data[5] == 1'b1)
                    ca_reg <= 1'b1;
            end
            else
                ca_reg <= '0;
        end
    end // always_ff @

    // +--------------------------------------------------
    // | Stream deactive
    // +--------------------------------------------------
    // detect when stream active goes from high to low 
    reg sa_reg_dly;
    wire sa_deactiave;
    always_ff @(posedge clk) begin
        begin
            if (reset_internal)
                sa_reg_dly <= 0;
            else
                sa_reg_dly <= sa_reg;
        end
    end
    assign sa_deactiave = !sa_reg & sa_reg_dly;
    // when Stream active is 0: either finish a stream, error happens ...
    // need to reset whole stream controller, reset counter, flsuh out fifo
    // detech a pulse when sa goes from high to low, use it as reset
    // Shall we need synchronize here? the input reset should already have 
    assign reset_internal = reset | sa_deactiave;

    // +--------------------------------------------------
    // | Word counter: count each 4k block to generate IRQ
    // +--------------------------------------------------
    reg [12:0]  byte_cnt;
    reg [63:0]  out_data_field;
    
    reg         out_valid_wa;
    wire        in_4k_accepted;
    wire        out_4k_accepted;
    wire [31:0] total_words_one_block_value;
    wire [8:0]  total_words_one_block;
    
    reg [8:0]   word_cnt_64_in_fifo;  
    reg [8:0]   word_cnt_64_out_fifo;
    
    assign total_words_one_block_value  = END_VALUE_4K[31:0];
    assign total_words_one_block        = total_words_one_block_value[8:0];

    assign in_4k_accepted = (word_cnt_64_in_fifo == total_words_one_block) && in_valid && in_ready;


    always_ff @(posedge clk) begin
        if (reset_internal) begin
            word_cnt_64_in_fifo  <= '0;
        end
        else begin
            //if (out_valid_wa && in_ready)
            if (in_valid && in_ready)
                word_cnt_64_in_fifo <= word_cnt_64_in_fifo + 1'b1;
        end
    end
    
   

    // +--------------------------------------------------
    // | Gray counter
    // +--------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset_internal)
            gray_value <= '0;
        else begin
            if (in_4k_accepted)
                gray_value <= gray_out;
        end
    end

    graycnt gray_counter
    (
    .gray       (gray_out),
    .clk        (clk),
    .reset      (reset_internal),
    .updown     (1'b1),
    //.enable     (gray_counter_en)
     // Maximum 15 blocks, enable counter same time with 4k accepted
     // next clock value change together with interrupt
     //.enable     (in_4k_accepted)
    .enable     (set_irq)
    );
    
    // +--------------------------------------------------
    // | Interrurpt
    // +--------------------------------------------------

    assign clear_irq  = ca_reg;
    always_ff @(posedge clk) begin
        if (reset_internal)
            set_irq <= '0;
        else 
            set_irq <= in_4k_accepted;
    end
    // set, clear URQ logic
    always_ff @(posedge clk) begin
        if (reset_internal)
            gpi_interrupt <= '0;
        else begin
            case ({clear_irq, set_irq})
                2'b00: gpi_interrupt <= gpi_interrupt;
                2'b01: gpi_interrupt <= 1'b1;
                2'b10: gpi_interrupt <= 1'b0;
                2'b11: gpi_interrupt <= 1'b1; // setting wins clearing
            endcase // case ({clear_irq, set_irq})
        end
    end
       
    // +--------------------------------------------------
    // | Outputs
    // +--------------------------------------------------
    // only write to the fifo when stream is active
    assign in_valid_fifo = in_valid & sa_reg;
    always_comb begin
        if (sa_reg) begin
            out_valid      = out_valid_fifo;
            in_ready       = in_ready_fifo;
            stream_select  = stream_id_reg;
            stream_active  = 1'b1;
        end
        else begin
            out_valid      = '0;
            in_ready       = '0;
            stream_select  = '0;
            stream_active  = '0;
        end
        
        out_data           = out_data_fifo;
        out_startofpacket  = out_startofpacket_fifo;
        out_endofpacket    = out_endofpacket_fifo;
        gpi_data           = '0;
        gpi_data[3:0]      = gray_out;
    end
    // ready signal of the fifo
    assign out_ready_fifo  = out_ready;
    
    // | 
    // +--------------------------------------------------
    

    // +--------------------------------------------------
    // | Internal FIFO for imcomming packet
    // +--------------------------------------------------
    altera_avalon_sc_fifo 
  #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (64),
    .FIFO_DEPTH          (FIFO_DEPTH),
    .CHANNEL_WIDTH       (0),
    .ERROR_WIDTH         (0),
    //.USE_PACKETS         (1),
    .USE_PACKETS         (0),
    .USE_FILL_LEVEL      (0),
    .EMPTY_LATENCY       (3),
    .USE_MEMORY_BLOCKS   (1),
    .USE_STORE_FORWARD   (0),
    .USE_ALMOST_FULL_IF  (0),
    .USE_ALMOST_EMPTY_IF (0)
    ) urg_fifo 
   (
    .clk               (clk),                  
    .reset             (reset_internal),                
    .in_data           (in_data), 
    .in_valid          (in_valid_fifo),
    //.in_data           (out_data_field), 
    //.in_valid          (out_valid_wa),
    .in_ready          (in_ready_fifo),
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

module graycnt 
 #(
    parameter SIZE = 4
  )
  (
    output logic [SIZE-1:0] gray,
    input logic clk,
    input logic updown,
    input logic enable,
    input logic  reset
    );
    logic [SIZE-1:0] gnext, bnext, bin;
    
    always_ff @(posedge clk) begin
    if (reset) 
        {bin, gray} <= '0;
    else 
        {bin, gray} <= {bnext, gnext};
    end
    //assign bnext = !full ? bin + inc : bin;
    assign bnext = enable? updown? bin + 1'b1 : bin - 1'b1 : bin;
    assign gnext = (bnext>>1) ^ bnext;
endmodule
