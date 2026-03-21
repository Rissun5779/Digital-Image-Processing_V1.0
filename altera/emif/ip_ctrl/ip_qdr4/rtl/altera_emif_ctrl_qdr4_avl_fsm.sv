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


module altera_emif_ctrl_qdr4_avl_fsm # (
   parameter PORT_CTRL_AMM_RDATA_WIDTH = 1,
   parameter PORT_CTRL_AMM_ADDRESS_WIDTH = 1,
   parameter PORT_CTRL_AMM_WDATA_WIDTH = 1,
   parameter PORT_CTRL_AMM_BCOUNT_WIDTH = 1,
   parameter PORT_AFI_WLAT_WIDTH = 1,
   parameter PORT_AFI_ADDR_WIDTH = 1,
   parameter PORT_AFI_LD_N_WIDTH = 1, 
   parameter PORT_AFI_RW_N_WIDTH = 1,
   parameter PORT_AFI_WDATA_VALID_WIDTH = 1,
   parameter PORT_AFI_WDATA_WIDTH = 1,
   parameter PORT_AFI_RDATA_EN_FULL_WIDTH = 1,
   parameter PORT_AFI_RDATA_WIDTH = 1,
   parameter PORT_AFI_RDATA_VALID_WIDTH = 1,
   parameter NUM_OF_AVL_CHANNELS = 8,
   
   parameter AVL_CHANNEL_NUM = 0
) (
   
   input  logic                                                          afi_reset_n,
   input  logic                                                          afi_clk,

   input  logic                                                          amm_write,
   input  logic                                                          amm_read,
   output logic                                                          amm_ready,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]                          amm_readdata,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]                        amm_address,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]                          amm_writedata,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]                         amm_burstcount,
   output logic                                                          amm_readdatavalid,
   
   input  logic                                                          afi_cal_success,
   input  logic                                                          afi_cal_fail,
   
   input  logic [PORT_AFI_WLAT_WIDTH-1:0]                                afi_wlat,
   
   output logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_addr,
   output logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_ld_n,
   output logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rw_n,
   output logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]     afi_wdata_valid,
   output logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]           afi_wdata,
   output logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]   afi_rdata_en_full,
   input  logic [PORT_AFI_RDATA_WIDTH-1:0]                               afi_rdata,
   input  logic [PORT_AFI_RDATA_VALID_WIDTH-1:0]                         afi_rdata_valid,
   
   input  logic                                                          wdata_request,
   input  logic                                                          pause
);
   timeunit 1ps;
   timeprecision 1ps;
   
   localparam WL_SHIFTER_WIDTH = 2**PORT_AFI_WLAT_WIDTH;
   
   typedef enum int unsigned {
      INIT,
      IDLE,
      WRITE_BURST,
      READ_BURST,
      FAIL
   } avl_state_t;
   
   avl_state_t avl_state;
   
   reg [WL_SHIFTER_WIDTH-1:0]                                  wl_shifter;
   
   reg [PORT_CTRL_AMM_WDATA_WIDTH-1:0]                         amm_writedata_reg;
   reg [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]                       amm_address_reg;
   
   reg                                                         amm_writedata_fifo_wreq;
   reg                                                         amm_writedata_fifo_rreq;
   
   reg [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]                        beat_counter;
   reg [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]                        prev_amm_burstcount;
   
   wire [PORT_CTRL_AMM_RDATA_WIDTH-1:0]                        afi_rdata_local;
   wire [PORT_AFI_RDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]   afi_rdata_valid_local;
   
   wire [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]         afi_wdata_before_padding;
   wire [PORT_AFI_RDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]         afi_rdata_local_padded;
   
   altera_emif_ctrl_qdr4_afi_in_adjust_timeslot #(
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      
      .NUM_OF_AVL_CHANNELS (NUM_OF_AVL_CHANNELS),
      .AVL_CHANNEL_NUM (AVL_CHANNEL_NUM)
   ) afi_in_adjust_timeslot_inst (
      .afi_rdata_in(afi_rdata),
      .afi_rdata_valid_in(afi_rdata_valid),
      
      .afi_rdata_out(afi_rdata_local_padded),
      .afi_rdata_valid_out(afi_rdata_valid_local)
   );
   
   altera_emif_ctrl_qdr4_fifo_lookahead #(
      .WIDTH (PORT_CTRL_AMM_WDATA_WIDTH),
      .DEPTH (WL_SHIFTER_WIDTH)
   ) amm_writedata_fifo (
      .clk (afi_clk),
      .reset_n (afi_reset_n),
      .d (amm_writedata_reg),
      .q (afi_wdata_before_padding),
      .rdreq (amm_writedata_fifo_rreq),
      .wrreq (amm_writedata_fifo_wreq)
   );
   
   generate
      if (PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS > PORT_CTRL_AMM_WDATA_WIDTH) begin
         if (PORT_CTRL_AMM_WDATA_WIDTH == 32)
            assign afi_wdata = {2'b00, afi_wdata_before_padding[31:16], 2'b00, afi_wdata_before_padding[15:0]};
         else if (PORT_CTRL_AMM_WDATA_WIDTH == 64)
            assign afi_wdata = {4'b0000, afi_wdata_before_padding[63:32], 4'b0000, afi_wdata_before_padding[31:0]};
         else begin
         end
      end else begin
         assign afi_wdata = afi_wdata_before_padding;
      end
      
      if (PORT_AFI_RDATA_WIDTH/NUM_OF_AVL_CHANNELS > PORT_CTRL_AMM_RDATA_WIDTH) begin
         if (PORT_CTRL_AMM_WDATA_WIDTH == 32)
            assign afi_rdata_local = {afi_rdata_local_padded[33:18], afi_rdata_local_padded[15:0]};
         else if (PORT_CTRL_AMM_WDATA_WIDTH == 64)
            assign afi_rdata_local = {afi_rdata_local_padded[67:36], afi_rdata_local_padded[31:0]};
         else begin
         end
      end else begin
         assign afi_rdata_local = afi_rdata_local_padded;
      end
   endgenerate
   
   always_ff @(posedge afi_clk or negedge afi_reset_n)
   begin
      if (!afi_reset_n)
         wl_shifter <= '0;
      else begin
         wl_shifter <= {1'b0, wl_shifter[WL_SHIFTER_WIDTH-1:1]};
         
         if (afi_wlat > 1 && wdata_request)
            wl_shifter[afi_wlat-2] <= 1'b1;
      end
   end
   
   always_ff @(posedge afi_clk or negedge afi_reset_n)
   begin
      if (!afi_reset_n) begin
         afi_wdata_valid <= 1'b0;
         amm_writedata_fifo_rreq <= 1'b0;
      end else begin
         if ( (afi_wlat == 1 && wdata_request) || wl_shifter[0] == 1'b1 ) begin
            afi_wdata_valid <= 1'b1;
            amm_writedata_fifo_rreq <= 1'b1;
         end else begin
            afi_wdata_valid <= 1'b0;
            amm_writedata_fifo_rreq <= 1'b0;
         end
      end
   end
   
   always_ff @(posedge afi_clk or negedge afi_reset_n)
   begin
      if (!afi_reset_n) begin
         amm_readdata <= '0;
         amm_readdatavalid <= 1'b0;
      end else begin
         if ( (avl_state != INIT && avl_state != FAIL) && afi_rdata_valid_local ) begin
            amm_readdata <= afi_rdata_local;
            amm_readdatavalid <= 1'b1;
         end else begin
            amm_readdata <= '0;
            amm_readdatavalid <= 1'b0;
         end
      end
   end
   
   always_ff @(posedge afi_clk or negedge afi_reset_n)
   begin
      if (!afi_reset_n) begin
         amm_address_reg <= '0;
         amm_writedata_reg <= '0;
      end else begin
         if (avl_state == IDLE && (amm_read ^ amm_write))
            amm_address_reg <= amm_address;
         else
            amm_address_reg <= amm_address_reg;
         
         if ( (avl_state == IDLE || avl_state == WRITE_BURST) && amm_write)
            amm_writedata_reg <= amm_writedata;
         else
            amm_writedata_reg <= amm_writedata_reg;
      end
   end
   
   always_ff @(posedge afi_clk or negedge afi_reset_n)
   begin
      if (!afi_reset_n) begin
         beat_counter <= '0;
         prev_amm_burstcount <= '0;
      end else begin
         if (avl_state == IDLE && (amm_write ^ amm_read))
            prev_amm_burstcount <= amm_burstcount;
         else
            prev_amm_burstcount <= prev_amm_burstcount;
      
         if (pause)
            beat_counter <= beat_counter;
         else if (avl_state == IDLE && (amm_write ^ amm_read)) begin
            beat_counter <= amm_burstcount - 1'b1;
         end else if ( (avl_state == WRITE_BURST && amm_write) || avl_state == READ_BURST )
            beat_counter <= beat_counter - 1'b1;
         else
            beat_counter <= beat_counter;
      end
   end
   
   always_ff @(posedge afi_clk or negedge afi_reset_n)
   begin
      if (!afi_reset_n) begin
         afi_addr <= '0;
         afi_rw_n <= 2'b11;
         afi_ld_n <= 2'b11;
         afi_rdata_en_full <= 1'b0;
         
         amm_writedata_fifo_wreq <= 1'b0;
         
         avl_state <= INIT;
      end
      else
      begin
         case (avl_state)
            INIT:
            begin
               if (afi_cal_success)
                  avl_state <= IDLE;
               else if (afi_cal_fail)
                  avl_state <= FAIL;
               else
                  avl_state <= INIT;
            end
            
            IDLE:
            begin
               if (amm_write && !pause) begin
                  afi_addr <= amm_address;
                  afi_ld_n <= 2'b00;
                  afi_rw_n <= 2'b00;
                  afi_rdata_en_full <= 1'b0;
                  
                  amm_writedata_fifo_wreq <= 1'b1;
               end
               else if (amm_read && !pause) begin
                  afi_addr <= amm_address;
                  afi_ld_n <= 2'b00;
                  afi_rw_n <= 2'b11;
                  afi_rdata_en_full <= 1'b1;
                  
                  amm_writedata_fifo_wreq <= 1'b0;
               end
               else begin
                  afi_addr <= '0;
                  afi_ld_n <= 2'b11;
                  afi_rw_n <= 2'b11;
                  afi_rdata_en_full <= 1'b0;
                  
                  amm_writedata_fifo_wreq <= 1'b0;
               end
               
               if (pause)
                  avl_state <= IDLE;
               else if (amm_write && amm_burstcount > 1)
                  avl_state <= WRITE_BURST;
               else if (amm_read && amm_burstcount > 1)
                  avl_state <= READ_BURST;
               else
                  avl_state <= IDLE;
            end
            
            WRITE_BURST:
            begin
               if (beat_counter < 1 || !amm_write || pause) begin
                  afi_addr <= '0;
                  afi_ld_n <= 2'b11;
                  afi_rw_n <= 2'b11;
                  afi_rdata_en_full <= 1'b0;
                  
                  amm_writedata_fifo_wreq <= 1'b0;
               end else begin
                  afi_addr <= amm_address_reg + (prev_amm_burstcount - beat_counter);
                  afi_ld_n <= 2'b00;
                  afi_rw_n <= 2'b00;
                  afi_rdata_en_full <= 1'b0;
                  
                  amm_writedata_fifo_wreq <= 1'b1;
               end
               
               avl_state <= (beat_counter > 0) ? WRITE_BURST : IDLE;
            end
            
            READ_BURST:
            begin
               if (beat_counter < 1 || pause) begin
                  afi_addr <= '0;
                  afi_ld_n <= 2'b11;
                  afi_rw_n <= 2'b11;
                  afi_rdata_en_full <= 1'b0;
               end else begin
                  afi_addr <= amm_address_reg + (prev_amm_burstcount - beat_counter);
                  afi_ld_n <= 2'b00;
                  afi_rw_n <= 2'b11;
                  afi_rdata_en_full <= 1'b1;
               end
               
               amm_writedata_fifo_wreq <= 1'b0;
               
               avl_state <= (beat_counter > 0) ? READ_BURST : IDLE;
            end
            
            FAIL:
            begin
               avl_state <= FAIL;
            end
         endcase
      end
   end
   
   assign amm_ready = !pause & ( avl_state == IDLE || (avl_state == WRITE_BURST && beat_counter > 0) );
endmodule
