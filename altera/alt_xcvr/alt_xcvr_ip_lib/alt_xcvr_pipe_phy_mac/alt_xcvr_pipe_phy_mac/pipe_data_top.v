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


//Optional:
//  flow control
//  header flags and packet framing
//  error managment and fast retransmit
module pipe_data_top #(
  parameter max_rate        = "gen2",
  parameter lanes           = 1,
  parameter fast_sim        = "true",
  parameter pld_if_dw       = 16,
  parameter pattern         = "prbs",
  parameter words_pld_if    = 2
) (
  input                                 pclk,
  input                                 reset,

  //inputs from the MAC to begin transmitting data
  input                                 ltssm_recovery,
  input                                 send_data,
  input [1:0]                           send_ts,

  //inputs from the PHY for data integrity checking
  input [1:0]                           rate,
  input [lanes*pld_if_dw-1:0]           rx_data_in,
  input [lanes*words_pld_if-1:0]        rx_datak,
  input [lanes*2-1:0]                   rx_sync_hdr,
  input [lanes-1:0]                     rx_blk_start,
  input [lanes-1:0]                     rx_data_valid,
  input [lanes-1:0]                     rx_valid,
  input [lanes-1:0]                     rx_syncstatus,

  //Outputs from the data generator and control signal logic
  output [pld_if_dw*lanes-1:0]          tx_data_out,
  output [words_pld_if*lanes-1:0]       tx_datak,
  output [2*lanes-1:0]                  tx_sync_hdr,
  output [lanes-1:0]                    tx_blk_start,
  output [lanes-1:0]                    tx_data_valid,
  output [lanes-1:0]                    polarity, 

  //outputs to the MAC to signify that data checking and transmission is complete
  output [1:0]                          end_ts, 
  output reg                            end_packet,
  output                                rx_infer_elecidle,
  output [lanes-1:0]                    errors
);

//specifies the number of 8-bit words make up a 32-bit interface
localparam pld_if_per_32      = (32/pld_if_dw); 

//State Assignments.  More states can be added for sending FTS or EIOS
localparam [2:0] SM_IDLE           = 3'd0,
                 SM_XMT_TS1        = 3'd1,
                 SM_XMT_TS2        = 3'd2,
                 SM_XMT_COMP       = 3'd3,
                 SM_XMT_DATA       = 3'd4,
                 SM_XMT_EIEOS      = 3'd5,
                 SM_XMT_SKIP       = 3'd6,
                 SM_XMT_EIOS       = 3'd7;

//k-characters
localparam [7:0] k_com             = 8'hBC; //k28.5
localparam [7:0] k_stp             = 8'hFB; //k27.7
localparam [7:0] k_sdp             = 8'h5C; //k28.2
localparam [7:0] k_end             = 8'hFD; //k29.7
localparam [7:0] k_edb             = 8'hFE; //k30.7
localparam [7:0] k_pad             = 8'hF7; //k23.7
localparam [7:0] k_skp             = 8'h1C; //k28.0
localparam [7:0] k_fts             = 8'h3C; //k28.1
localparam [7:0] k_idle            = 8'h7C; //k28.3
localparam [7:0] k_eie             = 8'hFC; //k28.7

//D-characters
localparam [7:0] d5_2              = 8'h45;
localparam [7:0] d10_2             = 8'h4A;
localparam [7:0] d21_5             = 8'hB5;

//Ordered Sets
localparam [31:0] g12_skip_os      = {k_skp, k_skp, k_skp, k_com}; //32'h1C1C1CBC;
localparam [31:0] g3_skip_os       = 32'hAAAAAAAA;
localparam [31:0] g3_skip_os_end   = 32'hFF00FFE1;
localparam [31:0] g3_eieos         = 32'hFF00FF00;
localparam [31:0] g3_eios          = 32'h66666666;
wire       [15:0] ts_max_rate      = (max_rate == "gen3") ? 16'h000E :
                                     (max_rate == "gen2") ? 16'h0006 : 16'h0002;
wire       [31:0] g12_eios         = {k_idle, k_idle, k_idle, k_com};
wire       [31:0] g2_eieos_start   = {k_eie, k_eie, k_eie, k_com};
wire       [31:0] g2_eieos_mid     = {k_eie, k_eie, k_eie, k_eie};
wire       [31:0] g2_eieos_end     = {d10_2, k_eie, k_eie, k_eie};

//Gen 3 Data stream packets
localparam [31:0] sds_identity     = 32'h555555E1;
localparam [31:0] sds_body         = 32'h55555555;
localparam [31:0] eds_token        = 32'h1F809000;

//TS1
wire [31:0] ts1_symbol_0_3         = (rate == 2'b10) ?      {8'h03, k_pad, k_pad, 8'h1E} :  //in gen 3, the first symbol is different than in gen1/2 {n_fts, k_pad, k_pad, k_com} 
                                                            {8'h03, k_pad, k_pad, k_com};
wire [31:0] ts1_symbol_4_7         = (rate == 2'b10) ?      {16'h1600, ts_max_rate} :       //in each of the different generations, the data rate identifier is different.  
                                    ((rate == 2'b01) ?      {d10_2, d10_2, ts_max_rate} :   //Also in gen 3, tap values are encoded {sym7, sym6, sym5, max_rate} 
                                                            {d10_2, d10_2, ts_max_rate});
wire [31:0] ts1_symbol_8_11        = (rate == 2'b10) ?      {d10_2, d10_2, 16'h020d} : 
                                                            {d10_2, d10_2, d10_2, d10_2};   //in gen 3, encodes various tap values {d10.2, d10.2, sym9, sym8}
wire [31:0] ts1_symbol_12_15       = {d10_2, d10_2, d10_2, d10_2};                          //in gen 3, symbols 14 and 15 are for dc balance {d10.2, d10.2, d10.2, d10.2}

//TS2
wire [31:0] ts2_symbol_0_3         = (rate == 2'b10) ?      {8'h03, k_pad, k_pad, 8'h2D} :  //in gen 3, the first symbol is different than in gen1/2 {n_fts, k_pad, k_pad, k_com}
                                                            {8'h03, k_pad, k_pad, k_com}; 

wire [31:0] ts2_symbol_4_7         = (rate == 2'b10) ?     {d5_2, 8'h00, ts_max_rate} :      //in each of the different generations, the data rate identifier is different.  
                                    ((rate == 2'b01) ?     {d5_2, d5_2, ts_max_rate} :       //Also in gen 3, tap values are encoded {d5.2, sym6, sym5, max_rate} 
                                                           {d5_2, d5_2, ts_max_rate}); 
wire [31:0] ts2_symbol_8_11        = {d5_2, d5_2, d5_2, d5_2};                              //Identical encoding between gen1/2 and gen 3 {d5.2, d5.2, d5.2, d5.2}
wire [31:0] ts2_symbol_12_15       = {d5_2, d5_2, d5_2, d5_2};                              //in gen 3, symbols 14 and 15 are for dc balance {d5.2, d5.2, d5.2, d5.2}

//Gen1/2 Compliance pattern and os
wire [31:0] g12_compliance         = {d10_2, k_com, d21_5, k_com};                          //{D10.2, k_com, D21.5, k_com}

//Wire for maths
wire  [2:0] words_pld_if_wire      = (words_pld_if == 4) ? 3'd4 :
                                     (words_pld_if == 2) ? 3'd2 : 3'd1;

//Local Wires and Registers
reg                                 tx_data_skip_int;
reg                                 tx_data_valid_int;
reg                                 tx_blk_start_int;
reg  [1:0]                          ts_edge_det;
reg  [1:0]                          blk_count;
reg  [1:0]                          tx_sync_hdr_int;
reg  [2:0]                          state;
reg  [2:0]                          prev_state;
reg  [3:0]                          ts_count;
reg  [3:0]                          count_valid;
reg  [3:0]                          tx_datak_int;
reg  [4:0]                          count_eieos;
reg  [9:0]                          complete_1024_ts;
reg  [13:0]                         clk_tolerance;
reg  [19:0]                         data_count;
reg  [19:0]                         data_count_next;
reg  [31:0]                         tx_data_int;
wire                                end_block;
wire                                data_enable;
wire                                eieos_timeout;
wire                                skip_timeout;
wire                                reset_eieos;
wire                                reset_ts_1024;
wire                                ts_1024;
wire                                complete_data_packet;
wire                                packet_complete;
wire                                tx_blk_start_next;
wire                                tx_data_valid_next;
wire [1:0]                          ts_status;
wire [1:0]                          tx_sync_hdr_next;
wire [3:0]                          tx_datak_next;
wire [4:0]                          transfer_count;
wire [9:0]                          transmit_ts_count;
wire [13:0]                         skip_insert_count;
wire [pld_if_dw-1:0]                tx_data_scrambled;
wire [31:0]                         data_pattern;
wire [31:0]                         tx_data_next;

//Wires for the scrambler
reg                                 comp_reset_scram;
wire                                reset_scrambler;
wire                                advance_scrambler;
wire [3:0]                          enable_scrambler;

//registers for the TS
reg  [31:0]                         ts_next;
reg  [3:0]                          ts_datak_next;
reg  [3:0]                          ts_en_scrambler;

//registers for compliance
reg  [31:0]                         comp_next;
reg  [3:0]                          comp_datak_next;
reg  [5:0]                          g3_count;
reg  [5:0]                          g3_count_next;
reg  [3:0]                          comp_en_scrambler;

//registers for EIEOS
reg  [31:0]                         eieos_next;
reg  [3:0]                          eieos_datak_next;

//register and wires for EIOS
wire [3:0]                          eios_transfer;
wire                                eios_complete;
reg  [31:0]                         eios_next;
reg  [3:0]                          eios_datak_next;
reg  [5:0]                          eios_count;
reg  [5:0]                          eios_xmt_count;

//Registers for the Skip OS
reg                                 skip_done;
reg                                 skip_done_next;
reg  [31:0]                         skip_next;
reg  [3:0]                          skip_datak_next;
reg  [2:0]                          skip_count;
reg  [2:0]                          skip_count_next;

//registers for data
reg                                 send_sds;
reg                                 send_sds_next;
reg  [1:0]                          data_sync_hdr;
reg  [3:0]                          data_en_scrambler;
reg  [31:0]                         data_next;
reg  [31:0]                         datak_next;

//First stage flops for received data to improve timing closure from periphery to core.
reg [lanes*pld_if_dw-1:0]           rx_data_in_int;
reg [lanes*words_pld_if-1:0]        rx_datak_int;
reg [lanes*2-1:0]                   rx_sync_hdr_int;
reg [lanes-1:0]                     rx_blk_start_int;
reg [lanes-1:0]                     rx_data_valid_int;
reg [lanes-1:0]                     rx_valid_int;
reg [lanes-1:0]                     rx_syncstatus_int;

//Assign statements for simple combinational logic
//Sets a counting threshold to indicate the end of a training sequence
assign transfer_count     = (words_pld_if == 1) ? 4'd15 : ((words_pld_if == 2) ? 4'd14 : 4'd12);

//count for sending 1024 training sequences
assign transmit_ts_count  = (fast_sim == "true") ? 10'h01F : 10'h3FF;

//Depending on rate, and whether or not we want fast simulation, set the timeout for inserting skip ordered sets
assign skip_insert_count  = (rate == 2'b10) ? ((fast_sim == "true") ? 14'd37 : 14'd370) : 
                                              ((fast_sim == "true") ? 14'd118 : 14'd1180);

assign tx_data_next       = (state == SM_XMT_TS1 || state == SM_XMT_TS2)  ? ts_next :
                           ((state == SM_XMT_COMP)                        ? comp_next :
                           ((state == SM_XMT_EIEOS)                       ? eieos_next :
                           ((state == SM_XMT_SKIP)                        ? skip_next :
                           ((state == SM_XMT_DATA)                        ? data_next : 
                           ((state == SM_XMT_EIOS)                        ? eios_next :32'b0)))));
assign tx_datak_next      = (state == SM_XMT_TS1 || state == SM_XMT_TS2)  ? ts_datak_next :
                           ((state == SM_XMT_COMP)                        ? comp_datak_next :
                           ((state == SM_XMT_EIEOS)                       ? eieos_datak_next :
                           ((state == SM_XMT_SKIP)                        ? skip_datak_next :
                           ((state == SM_XMT_EIOS)                        ? eios_datak_next : 4'b0000))));
assign tx_sync_hdr_next   = (state == SM_XMT_DATA || state == SM_IDLE)  ? data_sync_hdr : 2'b01;
assign tx_blk_start_next  = (state != SM_IDLE && rate == 2'b10 && tx_data_skip_int == 1'b0 && (blk_count  == 2'b00)) ? 1'd1 : 1'b0;
assign tx_data_valid_next = (state != SM_IDLE && rate == 2'b10) ? ~(tx_data_skip_int) : 1'd0;

//assign outputs
assign tx_data_out    = {lanes{tx_data_int[pld_if_dw-1:0]}};
assign tx_datak       = {lanes{tx_datak_int[words_pld_if-1:0]}};
assign tx_sync_hdr    = {lanes{tx_sync_hdr_int}};
assign tx_blk_start   = {lanes{tx_blk_start_int}};
assign tx_data_valid  = {lanes{tx_data_valid_int}};

always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    state             <= SM_IDLE;
    tx_data_int       <= 32'b0;
    tx_datak_int      <= 4'b0;
    tx_sync_hdr_int   <= 2'b0;
    tx_blk_start_int  <= 1'b0;
    tx_data_valid_int <= 1'b0;
    skip_count        <= 3'b0;
    send_sds          <= 1'b0;
    g3_count          <= 6'b0;
    data_count        <= 20'b0;
    eios_xmt_count    <= 6'b0;
    end_packet        <= 1'b0;
  end else begin
    tx_data_int       <= (rate == 2'b10) ? tx_data_scrambled : tx_data_next;
    tx_datak_int      <= tx_datak_next;
    tx_sync_hdr_int   <= tx_sync_hdr_next;
    tx_blk_start_int  <= tx_blk_start_next;
    tx_data_valid_int <= tx_data_valid_next;
    skip_count        <= skip_count_next;
    send_sds          <= send_sds_next;
    g3_count          <= g3_count_next;
    data_count        <= data_count_next;
    eios_xmt_count    <= eios_count;
    end_packet        <= eios_complete;
    case(state)
      SM_IDLE: begin
        //If we are not in a polling state and not gen 1, and we want to send data or a training sequence
        //then we must first send an EIEOS.
        if(rate != 2'b00 && ltssm_recovery == 1'b1 && send_ts != 2'b00) begin
          state       <= SM_XMT_EIEOS;
          prev_state  <= SM_XMT_TS1;
        //if we are not in recovery, and we are in polling, then if we wish to send training sequences
        //then we must go to the correct state to send the correct sequence. 
        end else if(send_ts == 2'b01) begin
          state       <= SM_XMT_TS1;
        end else if(send_ts == 2'b10) begin
          state       <= SM_XMT_TS2;
        end else if(send_ts == 2'b11) begin
          state       <= SM_XMT_COMP;
        end else begin
          state       <= SM_IDLE;
        end
      end

      SM_XMT_TS1: begin
        //If we are no longer sending data or Training sequences, then return to idle
        if(send_ts == 2'b00 && send_data == 1'b0) begin
          state       <= SM_IDLE;
        //If the Training sequences has changed, then switch training sequences
        end else if((send_ts == 2'b10 || send_data == 1'b1) && packet_complete == 1'b1) begin
          state       <= SM_XMT_TS2;
        //If the Training sequence has switched to compliance, send the compliance pattern
        end else if(send_ts == 2'b11 && packet_complete == 1'b1) begin
          state       <= SM_XMT_COMP;
        //Every 32 Training Sequences, send an EIEOS
        end else if(eieos_timeout == 1'b1 && packet_complete == 1'b1) begin
          state       <= SM_XMT_EIEOS;
          prev_state  <= SM_XMT_TS1;
        //Send a Skip ordered set
        end else if(skip_timeout == 1'b1 && packet_complete == 1'b1) begin
          state       <= SM_XMT_SKIP;
          prev_state  <= SM_XMT_TS1;
        end else begin
          state       <= SM_XMT_TS1;
          prev_state  <= SM_XMT_TS1;
        end
      end
      
      SM_XMT_TS2: begin
        //If we are no longer sending data or Training sequences, then return to idle
        if(send_ts == 2'b00 && send_data == 1'b0) begin
          state       <= SM_IDLE;
        //If the training Sequence changes, switch training sequences
        end else if(send_ts == 2'b01 && packet_complete == 1'b1) begin
          state       <= SM_XMT_TS1;
        //If we have received enough training sequences, transmit data
        end else if(send_data == 1'b1 && packet_complete == 1'b1) begin
          state       <= SM_XMT_DATA;
        //Every 32 Training Sequences, transmit an EIEOS
        end else if(eieos_timeout == 1'b1 && packet_complete == 1'b1) begin
          state       <= SM_XMT_EIEOS;
          prev_state  <= SM_XMT_TS1;
        //Send a Skip ordered set
        end else if(skip_timeout == 1'b1 && packet_complete == 1'b1) begin
          state       <= SM_XMT_SKIP;
          prev_state  <= SM_XMT_TS2;
        end else begin
          state       <= SM_XMT_TS2;
          prev_state  <= SM_XMT_TS2;
        end
      end
      
      SM_XMT_COMP: begin
        //If we are no longer sending data or Training sequences, then return to idle
        if(send_ts == 2'b00 && send_data == 1'b0) begin
          state       <= SM_XMT_EIOS;
          prev_state  <= SM_IDLE;
        //Send a skip ordered set
        end else if(skip_timeout == 1'b1 && packet_complete == 1'b1) begin
          state       <= SM_XMT_SKIP;
          prev_state  <= SM_XMT_COMP;
        //If we are no long in compliance, then return to transmitting skip ordered sets
        end else if(send_ts == 2'b01 && packet_complete == 1'b1) begin
          state       <= SM_XMT_TS1;
        end else begin
          state       <= SM_XMT_COMP;
          prev_state  <= SM_XMT_COMP;
        end
      end

      SM_XMT_DATA: begin
        //If we are no longer sending data or Training sequences, then return to idle
        if(send_ts == 2'b00 && send_data == 1'b0 && end_block == 1'b1) begin
          state       <= SM_XMT_EIOS;
          prev_state  <= SM_IDLE;
        //Return to sending Training Sequences
        end else if(send_ts == 2'b01 && end_block == 1'b1) begin
          state       <= SM_XMT_EIEOS;
          prev_state  <= SM_XMT_TS1;
        //Return to sending Training Sequences
        end else if(send_ts == 2'b10 && end_block == 1'b1) begin
          state       <= SM_XMT_EIEOS;
          prev_state  <= SM_XMT_TS2;
        //After sending the EDS, send an EIEOS
        end else if(end_block == 1'b1 && rate == 2'b10) begin
          state       <= SM_XMT_EIEOS;
          prev_state  <= SM_XMT_DATA;
        //Send a Skip Ordered Set
        end else if(skip_timeout == 1'b1 && (rate == 2'b10 && packet_complete || rate != 2'b10)) begin
          state       <= SM_XMT_SKIP;
          prev_state  <= SM_XMT_DATA;
        end else begin
          state       <= SM_XMT_DATA;
          prev_state  <= SM_XMT_DATA;
        end
      end

      SM_XMT_EIEOS: begin
        //If we are no longer sending data or Training sequences, then return to idle
        if(send_ts == 2'b00 && send_data == 1'b0 && packet_complete == 1'b1) begin
          state   <= SM_IDLE;
        //Return to the previous state
        end else if(packet_complete == 1'b1) begin
          if(skip_timeout == 1'b1) begin
            state <= SM_XMT_SKIP;
          end else begin
            state <= prev_state;
          end
        end else begin
          state   <= SM_XMT_EIEOS;
        end
      end
           
      SM_XMT_SKIP: begin
        //If we are no longer sending data or Training sequences, then return to idle
        if(send_ts == 2'b00 && send_data == 1'b0 && skip_done == 1'b1) begin
          state       <= SM_XMT_EIOS;
          prev_state  <= SM_IDLE;
        //Return to the previous state
        end else if (skip_done == 1'b1) begin
          state <= prev_state;
        end else begin
          state <= SM_XMT_SKIP;
        end
      end

      SM_XMT_EIOS: begin
        if(eios_complete == 1'b1) begin
          state       <= SM_IDLE;
        end
      end

    endcase
  end
end


//combinational logic for TS1 or TS2
//tracks where in the training sequence we are.  blk_count counts for tx_blk_start, and ts_count counts the number of symbols send
//ts_count can be incremented anywhere between 1 and 4 symbols at a time, and block count is incremented once per 4 symbols, thus
//making blk_count a shifted version of ts_count
always@(*) begin
  //If we are in gen 3
  if(state != SM_XMT_TS1 && state != SM_XMT_TS2) begin
    ts_next         = tx_data_int;
    ts_datak_next   = tx_datak_int;
    ts_en_scrambler = 4'b0;
  end else if(rate == 2'b10) begin
    ts_datak_next   = tx_datak_int;
    case(blk_count)
      2'b00: begin
        ts_en_scrambler = 4'b1110;
        ts_next = (state == SM_XMT_TS1) ? ts1_symbol_0_3 : ts2_symbol_0_3;
      end

      2'b01: begin
        ts_en_scrambler = 4'b1111;
        ts_next = (state == SM_XMT_TS1) ? ts1_symbol_4_7 : ts2_symbol_4_7;
      end

      2'b10: begin
        ts_en_scrambler = 4'b1111;
        ts_next = (state == SM_XMT_TS1) ? ts1_symbol_8_11 : ts2_symbol_8_11;
      end

      2'b11: begin
        ts_en_scrambler = 4'b1111;
        ts_next = (state == SM_XMT_TS1) ? ts1_symbol_12_15 : ts2_symbol_12_15;
      end

      default: begin
        ts_en_scrambler = 4'b0;
        ts_next = tx_data_int;
      end
    endcase
  end else begin
    ts_en_scrambler = 4'b0;
    case(ts_count)
      4'b0000: begin
        ts_datak_next = 4'b0111;
        ts_next       = (state == SM_XMT_TS1) ? ts1_symbol_0_3 : ts2_symbol_0_3;
      end

      4'b0100: begin
        ts_datak_next = 4'b0;
        ts_next       = (state == SM_XMT_TS1) ? ts1_symbol_4_7 : ts2_symbol_4_7;
      end

      4'b1000: begin
        ts_datak_next = 4'b0;
        ts_next       = (state == SM_XMT_TS1) ? ts1_symbol_8_11 : ts2_symbol_8_11;
      end

      4'b1100: begin
        ts_datak_next = 4'b0;
        ts_next       = (state == SM_XMT_TS1) ? ts1_symbol_12_15 : ts2_symbol_12_15;
      end

      default: begin
        ts_datak_next = tx_datak_int >> words_pld_if;
        ts_next       = tx_data_int >> pld_if_dw;
      end
    endcase
  end
end


//combinational logic for Compliance
always@(*) begin
  if(state != SM_XMT_COMP) begin
    comp_next           = tx_data_int;
    comp_datak_next     = tx_datak_int;
    g3_count_next       = 6'd0;
    comp_en_scrambler   = 4'b0;
    comp_reset_scram    = 1'b0;
  end else if(rate != 2'b10) begin
    comp_en_scrambler   = 4'b0;
    comp_reset_scram    = 1'b0;
    g3_count_next       = 6'd0;
    case(ts_count)
      4'b0000: begin
        comp_datak_next = 4'b0101;
        comp_next       = g12_compliance;
      end

      4'b0100: begin
        comp_datak_next = 4'b0101;
        comp_next       = g12_compliance;
      end

      4'b1000: begin
        comp_datak_next = 4'b0101;
        comp_next       = g12_compliance;
      end

      4'b1100: begin
        comp_datak_next = 4'b0101;
        comp_next       = g12_compliance;
      end

      default: begin
        comp_datak_next = tx_datak_int >> words_pld_if;
        comp_next       = tx_data_int >> pld_if_dw;
      end
    endcase
  end else begin
    comp_datak_next     = tx_datak_int;
    if(g3_count == 6'd35 && blk_count == 2'b11) begin
      g3_count_next       = 6'd0;
    end else if(tx_data_skip_int == 1'b1) begin
      g3_count_next       = g3_count;
    end else begin
      g3_count_next       = g3_count + (blk_count == 2'b11);
    end
    case(g3_count)
      6'd0: begin
        comp_en_scrambler = 4'b0;
        comp_reset_scram  = 1'b0;
        if(blk_count == 2'b01 || blk_count == 2'b00) begin
          comp_next       = 32'hFFFFFFFF;
        end else begin
          comp_next       = 32'h00000000;
        end
      end

      6'd1: begin
        comp_en_scrambler = 4'b0;
        comp_reset_scram  = 1'b0;
        if(blk_count == 2'b00) begin
          comp_next       = 32'h55555555;
        end else if(blk_count == 2'b01) begin
          comp_next       = 32'h55555555;  //for now the ending byte is 55, but its supposed to be an analog value.  see spec page 320
        end else begin
          comp_next       = 32'b0;
        end
      end

      6'd2: begin
        comp_en_scrambler = 4'b0;
        comp_reset_scram  = 1'b0;
        if(blk_count == 2'b00) begin
          comp_next       = 32'hF0FFFFFF;
        end else if(blk_count == 2'b01) begin
          comp_next       = 32'h0;//for now the ending byte is 55, but its supposed to be an analog value.  see spec page 320
        end else if(blk_count == 2'b10) begin
          comp_next       = 32'b0;
        end else begin
          comp_next       = 32'hFFFFFFFF;
        end
      end

      6'd3: begin
        comp_en_scrambler = 4'b0;
        comp_reset_scram  = 1'b1;
        comp_next         = g3_eieos;
      end

      default: begin
        comp_en_scrambler = 4'b1111;
        comp_reset_scram  = 1'b0;
        comp_next         = 32'd0;
      end
    endcase
  end
end 

//combinational logic for EIEOS
assign data_enable          = (rate == 2'b10) ? (send_sds == 1'b1 && tx_data_skip_int == 1'b0 && state == SM_XMT_DATA) : (state == SM_XMT_DATA);
//assign complete_data_packet = (data_count >= 20'd100);
assign complete_data_packet = (state == SM_XMT_DATA && send_data == 1'b0);
assign end_block            = (rate == 2'b10) ? (complete_data_packet == 1'b1 && send_sds_next == 1'b0) : (complete_data_packet);
always@(*) begin
  if(state != SM_XMT_DATA && state != SM_XMT_SKIP) begin
    data_next               = 32'b0;
    data_sync_hdr           = 2'b10;
    send_sds_next           = 1'b0;
    data_count_next         = 20'b0;
    data_en_scrambler       = 4'b0;
  end else begin
    if(rate == 2'b10 && tx_data_skip_int == 1'b1) begin
      data_next             = data_pattern;
      data_sync_hdr         = tx_sync_hdr_int;
      send_sds_next         = send_sds;
      data_count_next       = data_count;
      data_en_scrambler     = 4'b1111;
    end else if(send_sds == 1'b0 && complete_data_packet == 1'b0 && rate == 2'b10) begin
      data_en_scrambler     = 4'b0;
      data_count_next       = data_count;
      data_sync_hdr         = 2'b01;
      data_next             = (blk_count == 2'b00) ? sds_identity : sds_body;
      send_sds_next         = (blk_count == 2'b11);
    end else begin
      data_en_scrambler     = 4'b1111;
      data_count_next       = (rate == 2'b10) ? data_count + (blk_count == 2'b11) : data_count + 1'b1;
      data_sync_hdr         = 2'b10;
      if(complete_data_packet == 1'b1) begin
        send_sds_next       = (blk_count == 2'b11) ? 1'b0 : send_sds;
        data_next           = /*(blk_count == 2'b11) ? eds_token :*/ data_pattern;
      end else begin
        send_sds_next       = send_sds;
        data_next           = data_pattern;
      end
    end
  end
end


//combinational logic for EIEOS
always@(*) begin
  if(state == !SM_XMT_EIEOS) begin
    eieos_next              = tx_data_int;
    eieos_datak_next        = tx_datak_int;
  end else begin
    if(rate == 2'b10) begin
      eieos_next = g3_eieos;
      eieos_datak_next      = tx_datak_int;
    end else begin
      case(ts_count)
        4'b0000: begin
          eieos_datak_next  = 4'b1111;
          eieos_next        = g2_eieos_start;
        end
        
        4'b0100: begin
          eieos_datak_next  = 4'b1111;
          eieos_next        = g2_eieos_mid;
        end
        
        4'b1000: begin
          eieos_datak_next  = 4'b1111;
          eieos_next        = g2_eieos_mid;
        end

        4'b1100: begin
          eieos_datak_next  = 4'b0111;
          eieos_next        = g2_eieos_end;
        end

        default: begin
          eieos_datak_next  = tx_datak_int >> words_pld_if;
          eieos_next        = tx_data_int  >> pld_if_dw;
        end
      endcase
    end
  end
end 


//combinational logic for SKIP OS
always@(*) begin
  if(state != SM_XMT_SKIP) begin
    skip_done       = 1'b0;
    skip_next       = tx_data_int;
    skip_datak_next = tx_datak_int;
    skip_count_next = 3'b0;
  end else if(rate == 2'b10) begin
    skip_done       = packet_complete;//(blk_count == 2'b11);
    skip_datak_next = tx_datak_int;
    skip_count_next = 3'b0;
    if(blk_count == 2'b11) begin
      skip_next     = g3_skip_os_end;
    end else begin
      skip_next     = g3_skip_os;
    end
  end else begin
    skip_count_next = skip_count + words_pld_if_wire;
    skip_done       = (skip_count_next >= 3'b100);
    skip_datak_next = 4'b1111;
    skip_next       = (skip_count[1:0] == 2'b00) ? g12_skip_os[pld_if_dw-1:0] : {words_pld_if{k_skp}};
  end
end 

//combinational logic for eios
assign eios_transfer  = (ltssm_recovery == 1'b0) ? 4'h8 :
                        (rate == 2'b01) ? 4'h2 : 4'h1;
assign eios_complete  = (rate == 2'b10) ? packet_complete : (eios_count[5:2] >= eios_transfer);
//assign eios_pkt_done  = (rate == 2'b10) ? packet_complete : (eios_sym >= 3'b100);
always@(*) begin
  if(state != SM_XMT_EIOS) begin
    eios_next       = tx_data_int;
    eios_datak_next = tx_datak_int;
    eios_count      = 4'b0;
  end else if(rate == 2'b10) begin
    eios_count      = eios_xmt_count;
    eios_next       = g3_eios;
    eios_datak_next = tx_datak_int;
  end else begin
    eios_count      = eios_xmt_count + words_pld_if_wire;
    eios_next       = (eios_count[1:0] == 2'b00) ? g12_eios[pld_if_dw-1:0] : {words_pld_if{k_idle}};
    eios_datak_next = 4'b1111;
  end
end

//Counters for inserting eieos
assign eieos_timeout  = (count_eieos == 5'h1F && rate != 2'b00);
assign reset_eieos    = (ltssm_recovery && (ts_status[1] && ~ts_edge_det[1]));
always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    count_eieos       <= 5'b0;
    ts_edge_det       <= 2'b00;
  end else if(state == SM_XMT_EIEOS || reset_eieos == 1'b1) begin
    count_eieos       <= 5'b0;
    ts_edge_det       <= ts_status;
  end else begin
    count_eieos       <= count_eieos + packet_complete;
    ts_edge_det       <= ts_status;
  end
end

//counters for determining the number of training sets sent
assign end_ts  = (ltssm_recovery) ? ts_status : (ts_status & {2{ts_1024}}); 
assign ts_1024 = (complete_1024_ts == transmit_ts_count);
assign reset_ts_1024 = (ts_1024 && (prev_state == SM_XMT_TS1 && state == SM_XMT_TS2));
always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    complete_1024_ts  <= 10'b0;
  end else if((state != SM_XMT_TS1 && state != SM_XMT_TS2 && state != SM_XMT_SKIP && state != SM_XMT_EIEOS) || reset_ts_1024 == 1'b1) begin
    complete_1024_ts  <= 10'b0;
  end else begin
    complete_1024_ts  <= (ts_1024 == 1'b1) ? complete_1024_ts : complete_1024_ts + packet_complete;
  end
end

//Insert Skip ordered sets
assign skip_timeout   = (clk_tolerance > skip_insert_count);
always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    clk_tolerance     <= 5'b0;
  end else if (state == SM_IDLE || state == SM_XMT_SKIP) begin
    clk_tolerance     <= 14'd0;
  end else if(skip_timeout) begin
    clk_tolerance     <= clk_tolerance;
  end else begin
    clk_tolerance     <= (rate == 2'b10) ? (clk_tolerance + tx_blk_start_int) : (clk_tolerance + words_pld_if_wire);
  end
end

//Determine when a packet is complete, either a training sequence in gen 1/2 or in gen 3, the end of a block
assign packet_complete = (rate == 2'b10) ? (blk_count == 2'b11) : (ts_count == transfer_count);
always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    tx_data_skip_int  <= 1'b0;
    count_valid       <= 4'b0;
    blk_count         <= 2'b00;
  end else if (rate != 2'b10 || state == SM_IDLE) begin
    tx_data_skip_int  <= 1'b0;
    count_valid       <= 4'b0;
    blk_count         <= 2'b00;
  end else if (tx_data_skip_int == 1'b1) begin
    tx_data_skip_int  <= 1'b0;
    count_valid       <= 4'b0;
    blk_count         <= blk_count;
  end else begin
    {tx_data_skip_int, count_valid} <= count_valid + (blk_count == 2'b11);
    blk_count         <= blk_count + 1'b1;
  end
end

//Counter for determining the end of a training sequence
always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    ts_count          <= 4'd0;
  end else if (rate == 2'b10 || (state != SM_XMT_TS1 && state != SM_XMT_TS2 && state != SM_XMT_EIEOS)) begin
    ts_count          <= 4'b0;
  end else begin
    ts_count          <= ts_count + words_pld_if_wire;
  end
end

//Generates various PRBS patterns, Walking Ones, Counter, Static Pattern as well
//as various training sequences from the mac, and valid data signal management.
pattern_gen data_generator (
  .clk                  (pclk),
  .reset                (reset),
  .enable               (data_enable),
  .start                (data_enable),
  .pause                (1'b0),
  .dout                 (data_pattern)
);

//Scramble the Data out of the data_handler
assign enable_scrambler   = (state == SM_XMT_TS1 || state == SM_XMT_TS2) ? ts_en_scrambler:
                            (state == SM_XMT_DATA) ? data_en_scrambler :
                            (state == SM_XMT_COMP) ? comp_en_scrambler : 4'b0;
assign advance_scrambler  = (state == SM_XMT_SKIP || tx_data_skip_int == 1'b1) ? 1'b0 : 1'b1;
assign reset_scrambler    = (state == SM_XMT_COMP) ? comp_reset_scram : (state == SM_XMT_EIEOS); //after transmitting an EIEOS, seed the scrambler.
pipe_scrambler #(
  .words_pld_if              (words_pld_if),
  .pld_if_dw                 (pld_if_dw)
) gen3_data_scrambler (
  .pclk                      (pclk),
  .reset                     (reset),
  .reset_scrambler           (reset_scrambler),
  .advance_scrambler         (advance_scrambler),
  .lane_number               (3'b0),
  .scramble_data_en          (enable_scrambler),
  .data_in                   (tx_data_next),
  .data_out                  (tx_data_scrambled)
);

// first level flops
always@(posedge pclk) begin
  rx_data_in_int    <=  rx_data_in;
  rx_valid_int      <=  rx_valid;
  rx_data_valid_int <=  rx_data_valid;
  rx_blk_start_int  <=  rx_blk_start;
  rx_datak_int      <=  rx_datak;
  rx_sync_hdr_int   <=  rx_sync_hdr;
  rx_syncstatus_int <=  rx_syncstatus;
end

//Checks The validity of the PRBS patterns, Walking Ones, Counter and static pattern.
//It also will also decompose and align the data for the mac to signify the beginning
//signal integrity
pipe_data_checker #(
  .lanes                (lanes),
  .pld_if_dw            (pld_if_dw),
  .pattern              (pattern),
  .fast_sim             (fast_sim),
  .max_rate             (max_rate),
  .words_pld_if         (words_pld_if)
) data_verifier (
  .pclk                 (pclk),
  .reset                (reset),
  .rx_syncstatus        (rx_syncstatus_int),
  .rate                 (rate),
  .state                (state),
  .rx_valid             (rx_valid_int),
  .rx_data_valid        (rx_data_valid_int[lanes-1:0]),
  .rx_blk_start         (rx_blk_start_int[lanes-1:0]),
  .rx_data              (rx_data_in_int),
  .rx_datak             (rx_datak_int),
  .rx_sync_hdr          (rx_sync_hdr_int),
  .rx_iei               (rx_infer_elecidle),
  .ts_done              (ts_status),
  .polarity             (polarity),
  .errors               (errors)
);

endmodule
