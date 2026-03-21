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



module altera_emif_ctrl_qdr2_afi # (
   parameter USER_CLK_RATIO                           = 1,
   parameter CTRL_BL                                  = 2,
   parameter CTRL_BWS_EN                              = 1,
   parameter MAX_AFI_WLAT                             = 1,

   // Avalon interface parameters
   parameter PORT_CTRL_AMM_RDATA_WIDTH                = 1,
   parameter PORT_CTRL_AMM_ADDRESS_WIDTH              = 1,
   parameter PORT_CTRL_AMM_WDATA_WIDTH                = 1,
   parameter PORT_CTRL_AMM_BYTEEN_WIDTH               = 1,

   // AFI 4.0 interface parameters
   parameter PORT_AFI_ADDR_WIDTH                      = 1,
   parameter PORT_AFI_BWS_N_WIDTH                     = 1,
   parameter PORT_AFI_RDATA_WIDTH                     = 1,
   parameter PORT_AFI_WDATA_WIDTH                     = 1,
   parameter PORT_AFI_WPS_N_WIDTH                     = 1,
   parameter PORT_AFI_RPS_N_WIDTH                     = 1,
   parameter PORT_AFI_RDATA_EN_FULL_WIDTH             = 1,
   parameter PORT_AFI_RDATA_VALID_WIDTH               = 1,
   parameter PORT_AFI_WDATA_VALID_WIDTH               = 1,
   parameter PORT_AFI_WLAT_WIDTH                      = 1
) (
   // Clock and reset interface
   input    logic                                     clk,
   input    logic                                     reset_n,

   // Commands from main state machine
   input    logic                                     do_write,
   input    logic                                     do_read,
  
   // Avalon data slave interface
   input    logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]   write_addr,
   input    logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]   read_addr,
   input    logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]    be,
   input    logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]     wdata,
   output   logic                                     rdata_valid,
   output   logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]     rdata,

   // AFI 4.0 PHY-Controller Interface
   // Address and command
   output   logic [PORT_AFI_ADDR_WIDTH-1:0]           afi_addr,
   output   logic [PORT_AFI_WPS_N_WIDTH-1:0]          afi_wps_n,
   output   logic [PORT_AFI_RPS_N_WIDTH-1:0]          afi_rps_n,
   // Write data
   output   logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]    afi_wdata_valid,
   output   logic [PORT_AFI_WDATA_WIDTH-1:0]          afi_wdata,
   output   logic [PORT_AFI_BWS_N_WIDTH-1:0]          afi_bws_n,
   // Read data
   output   logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]  afi_rdata_en_full,
   input    logic [PORT_AFI_RDATA_WIDTH-1:0]          afi_rdata,
   input    logic [PORT_AFI_RDATA_VALID_WIDTH-1:0]    afi_rdata_valid,
   // Calibration write latency
   input    logic [PORT_AFI_WLAT_WIDTH-1:0]           afi_wlat
);
   timeunit 1ps;
   timeprecision 1ps;
   
   // Calculate the log_2 of the input value
   function automatic integer log2;
      input integer value;
      begin
         value = value >> 1;
         for (log2 = 0; value > 0; log2 = log2 + 1)
            value = value >> 1;
      end
   endfunction      
   
   //////////////////////////////////////////////////////////////////////////////
   // BEGIN LOCALPARAM SECTION

   localparam PORT_AFI_BE_WIDTH = (USER_CLK_RATIO == 1 && CTRL_BL == 4) ? PORT_CTRL_AMM_BYTEEN_WIDTH / 2 : PORT_CTRL_AMM_BYTEEN_WIDTH;
   
   localparam ACTUAL_AFI_WLAT_WIDTH = log2(MAX_AFI_WLAT) + 1;

   // END LOCALPARAM SECTION
   //////////////////////////////////////////////////////////////////////////////

   wire                                         wdata_valid_wire;
   wire     [PORT_AFI_WDATA_WIDTH-1:0]          wdata_wire;
   wire     [PORT_AFI_BE_WIDTH-1:0]             be_wire;

   wire     [MAX_AFI_WLAT:0]                    wdata_valid_shifter;
   wire     [MAX_AFI_WLAT:0]                    wdata_shifter        [PORT_AFI_WDATA_WIDTH-1:0];
   wire     [MAX_AFI_WLAT:0]                    be_shifter           [PORT_AFI_BE_WIDTH-1:0];
   wire     [ACTUAL_AFI_WLAT_WIDTH-1:0]         actual_afi_wlat;

   reg                                          wdata_valid_reg;
   reg      [PORT_AFI_WDATA_WIDTH-1:0]          wdata_delay_reg;
   reg      [PORT_AFI_BE_WIDTH-1:0]             be_delay_reg;
   reg                                          afi_rdata_en_full_delay_reg;
   reg      [PORT_CTRL_AMM_RDATA_WIDTH-1:0]     rdata_unpadded_delay_reg;
   reg      [PORT_CTRL_AMM_RDATA_WIDTH/2-1:0]   rdata_delay_reg;
   reg                                          rdata_valid_state;

   logic    [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]   afi_addr_h;
   logic    [PORT_AFI_WPS_N_WIDTH/2-1:0]        afi_wps_n_h;
   logic    [PORT_AFI_RPS_N_WIDTH/2-1:0]        afi_rps_n_h;
   logic    [PORT_AFI_RPS_N_WIDTH/2-1:0]        afi_rdata_en_full_h;

   logic    [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]   afi_addr_l;
   logic    [PORT_AFI_WPS_N_WIDTH/2-1:0]        afi_wps_n_l;
   logic    [PORT_AFI_RPS_N_WIDTH/2-1:0]        afi_rps_n_l;
   logic    [PORT_AFI_RPS_N_WIDTH/2-1:0]        afi_rdata_en_full_l;
   
   // When the "generate power-of-two bus" feature is enabled, we must properly
   // pad the avalon write data bus before feeding it to the afi write data bus, 
   // and reverse the process for the read data.

   logic [PORT_AFI_WDATA_WIDTH-1:0]             wdata_padded;
   logic [PORT_AFI_WDATA_WIDTH-1:0]             wdata_l_padded;
   logic [PORT_AFI_WDATA_WIDTH-1:0]             wdata_h_padded;
   logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]        rdata_unpadded;
   logic [(PORT_CTRL_AMM_RDATA_WIDTH/2)-1:0]    rdata_unpadded_half_avl;
   
   // Only the LSBs of the afi_wlat matter due to our ability to support up to MAX_AFI_WLAT only.
   // Here we are being explicit about the truncation to avoid any possibility of synth != sim issue.
   assign actual_afi_wlat = afi_wlat[ACTUAL_AFI_WLAT_WIDTH-1:0];
      
   genvar afi_i;
   generate
      
   // Read command multiplexing needed for burst length 4 designs
   if (CTRL_BL == 4)
   begin
      always @(posedge clk or negedge reset_n)
      begin
         if (!reset_n)
            afi_rdata_en_full_delay_reg <= 1'b0;
         else
            afi_rdata_en_full_delay_reg <= do_read;
      end
   end
   
   if (USER_CLK_RATIO == 1 && CTRL_BL == 4)
   begin
      if (PORT_AFI_WDATA_WIDTH == (PORT_CTRL_AMM_RDATA_WIDTH / 2))
      begin
         assign wdata_l_padded = wdata[PORT_AFI_WDATA_WIDTH-1:0];
         assign wdata_h_padded = wdata[PORT_CTRL_AMM_RDATA_WIDTH-1:PORT_AFI_WDATA_WIDTH];
         assign rdata_unpadded_half_avl = afi_rdata;
      end 
      else if (PORT_AFI_WDATA_WIDTH > (PORT_CTRL_AMM_RDATA_WIDTH / 2)) 
      begin
         
         localparam AFI_SYMBOL_WIDTH = 9;
         localparam CTL_SYMBOL_WIDTH = 8;
         
         for (afi_i = 0; afi_i < PORT_AFI_WDATA_WIDTH; ++afi_i) 
         begin : pad
            if (afi_i % AFI_SYMBOL_WIDTH >= CTL_SYMBOL_WIDTH) 
            begin
               assign wdata_l_padded[afi_i] = 1'b0;
               assign wdata_h_padded[afi_i] = 1'b0;
            end 
            else 
            begin
               assign wdata_l_padded[afi_i] = wdata[(afi_i / AFI_SYMBOL_WIDTH) * CTL_SYMBOL_WIDTH + (afi_i % AFI_SYMBOL_WIDTH)];
               assign wdata_h_padded[afi_i] = wdata[(afi_i / AFI_SYMBOL_WIDTH) * CTL_SYMBOL_WIDTH + (afi_i % AFI_SYMBOL_WIDTH) + (PORT_CTRL_AMM_RDATA_WIDTH / 2)];
               assign rdata_unpadded_half_avl[(afi_i / AFI_SYMBOL_WIDTH) * CTL_SYMBOL_WIDTH + (afi_i % AFI_SYMBOL_WIDTH)] = afi_rdata[afi_i];
            end
         end
      end 
      else 
      begin
      end
      
      assign wdata_valid_wire = do_write | wdata_valid_reg;
      assign wdata_wire = (do_write) ? wdata_l_padded : wdata_delay_reg;

      if (CTRL_BWS_EN != 0)
      begin
         assign be_wire = ~((do_write) ? be[PORT_AFI_BE_WIDTH-1:0] : be_delay_reg);
         
         always @(posedge clk or negedge reset_n)
         begin
            if (!reset_n)
            begin
               be_delay_reg <= '0;
            end
            else
            begin
               be_delay_reg <= be[PORT_CTRL_AMM_BYTEEN_WIDTH-1:PORT_AFI_BE_WIDTH];
            end
         end
      end

      assign afi_rdata_en_full = {USER_CLK_RATIO{do_read | afi_rdata_en_full_delay_reg}};
      assign rdata = {rdata_unpadded_half_avl,rdata_delay_reg};
      assign rdata_valid = rdata_valid_state & afi_rdata_valid[0];

      // Write data multiplexing and read data demultiplexing
      always @(posedge clk or negedge reset_n)
      begin
         if (!reset_n)
         begin
            wdata_valid_reg <= 1'b0;
            wdata_delay_reg <= '0;
            rdata_delay_reg <= '0;
            rdata_valid_state <= 1'b0;
         end
         else
         begin
            wdata_valid_reg <= do_write;
            wdata_delay_reg <= wdata_h_padded;
            if (rdata_valid_state == 1'b0)
               rdata_delay_reg <= rdata_unpadded_half_avl;
            if (afi_rdata_valid)
               rdata_valid_state <= ~rdata_valid_state;
         end
      end
   end
   else
   begin
      if (PORT_AFI_WDATA_WIDTH == PORT_CTRL_AMM_RDATA_WIDTH) 
      begin
         assign wdata_padded = wdata;
         assign rdata_unpadded = afi_rdata;
      end 
      else if (PORT_AFI_WDATA_WIDTH > PORT_CTRL_AMM_RDATA_WIDTH) 
      begin
         
         localparam AFI_SYMBOL_WIDTH = 9;
         localparam CTL_SYMBOL_WIDTH = 8;
         
         for (afi_i = 0; afi_i < PORT_AFI_WDATA_WIDTH; ++afi_i) 
         begin : pad
            if (afi_i % AFI_SYMBOL_WIDTH >= CTL_SYMBOL_WIDTH) 
            begin
               assign wdata_padded[afi_i] = 1'b0;
            end 
            else 
            begin
               assign wdata_padded[afi_i] = wdata[(afi_i / AFI_SYMBOL_WIDTH) * CTL_SYMBOL_WIDTH + (afi_i % AFI_SYMBOL_WIDTH)];
               assign rdata_unpadded[(afi_i / AFI_SYMBOL_WIDTH) * CTL_SYMBOL_WIDTH + (afi_i % AFI_SYMBOL_WIDTH)] = afi_rdata[afi_i];
            end
         end
      end 
      else 
      begin
      end

      assign afi_addr = {afi_addr_h,afi_addr_l};
      assign afi_wps_n = {afi_wps_n_h,afi_wps_n_l};
      assign afi_rps_n = {afi_rps_n_h,afi_rps_n_l};
      
      assign wdata_valid_wire = do_write;
      assign wdata_wire = wdata_padded;
      
      if (CTRL_BWS_EN != 0)
      begin
         assign be_wire = ~be;
      end

      assign rdata_valid = afi_rdata_valid[0];
      
      if (USER_CLK_RATIO == 1 && CTRL_BL == 2)
      begin
         // Full rate burst length 2 designs receive read data in 1 phy clock cycle 
         assign rdata = rdata_unpadded[PORT_CTRL_AMM_RDATA_WIDTH-1:0];
         
         assign afi_rdata_en_full = afi_rdata_en_full_l;
      end
      else if (USER_CLK_RATIO == 2 && CTRL_BL == 4)
      begin
         // Half rate burst length 4 designs receive read data over 2 phy clock cycles 
         assign rdata = {rdata_unpadded[PORT_CTRL_AMM_RDATA_WIDTH/2-1:0], rdata_unpadded_delay_reg[PORT_CTRL_AMM_RDATA_WIDTH-1:PORT_CTRL_AMM_RDATA_WIDTH/2]};
         
         assign afi_rdata_en_full = {afi_rdata_en_full_h, afi_rdata_en_full_l};
         
         // Read data demultiplexing
         always @(posedge clk or negedge reset_n)
         begin
            if (!reset_n)
               rdata_unpadded_delay_reg <= '0;
            else
               rdata_unpadded_delay_reg <= rdata_unpadded;
         end
      end
   end
   endgenerate

   // Delay 'afi_wdata_valid', 'afi_wdata', and 'afi_bws_n' by afi_wlat cycles
   altera_emif_ctrl_burst_latency_shifter # (
      .MAX_LATENCY   (MAX_AFI_WLAT),
      .BURST_LENGTH  (1)
   ) write_latency_shifter_for_wdata_valid (
      .clk      (clk),
      .reset_n   (reset_n),
      .d         (wdata_valid_wire),
      .q         (wdata_valid_shifter));

   // Don't differentiate between DQS groups and enable all data
   assign afi_wdata_valid = {PORT_AFI_WDATA_VALID_WIDTH{wdata_valid_shifter[actual_afi_wlat]}};

   genvar i;
   generate
   for (i = 0; i < PORT_AFI_WDATA_WIDTH; i++)
   begin : wdata_shifter_gen
      altera_emif_ctrl_burst_latency_shifter # (
         .MAX_LATENCY   (MAX_AFI_WLAT),
         .BURST_LENGTH  (1)
      ) write_latency_shifter_for_wdata (
         .clk      (clk),
         .reset_n   (reset_n),
         .d         (wdata_wire[i]),
         .q         (wdata_shifter[i]));

      assign afi_wdata[i] = wdata_shifter[i][actual_afi_wlat];
   end
   
   if (CTRL_BWS_EN != 0)
   begin
      for (i = 0; i < PORT_AFI_BE_WIDTH; i++)
      begin : be_shifter_gen
         altera_emif_ctrl_burst_latency_shifter # (
            .MAX_LATENCY   (MAX_AFI_WLAT),
            .BURST_LENGTH  (1)
         ) write_latency_shifter_for_be (
            .clk      (clk),
            .reset_n   (reset_n),
            .d         (be_wire[i]),
            .q         (be_shifter[i]));

         assign afi_bws_n[i] = be_shifter[i][actual_afi_wlat];
      end
   end
   else
      assign afi_bws_n = '0;

   // AFI 4.0 command translation
   // Burst length 2 devices use a DDR address bus and a SDR command bus and supports reads and writes occurring on the same memory clock cycle. 
   // Since such devices are only supported in full rate, read and write addresses needs to be multiplexed over the first and second half of 
   // the PHY clock cycle whereas the commands are only issued during the first half of the PHY clock cycle. Burst length 4 devices use a SDR
   // address and command bus, hence reads and writes cannot occur on the same memory clock cycle. In full rate, this means that the reads 
   // and writes will each occur in their own PHY clock cycles. In half rate, writes occur in the first phase of the PHY clock cycle and reads 
   // occur in the second phase. As such, read address and command signals need to be staggered over the second phase of the initial PHY clock    
   // cycle and the first phase of the subsequent PHY clock cycle.
   if (USER_CLK_RATIO == 1 && CTRL_BL == 2)
   begin
      always_comb
      begin
         afi_wps_n_h <= 1'b1;
         afi_rps_n_h <= 1'b1;

         afi_addr_h <= write_addr;

         if (do_write)
         begin
            afi_wps_n_l <= 1'b0;
         end
         else
         begin
            afi_wps_n_l <= 1'b1;
         end
         
         afi_addr_l <= read_addr;

         if (do_read)
         begin
            afi_rps_n_l <= 1'b0;
            afi_rdata_en_full_l <= 1'b1;
         end
         else
         begin
            afi_rps_n_l <= 1'b1;
            afi_rdata_en_full_l <= 1'b0;
         end
      end
   end
   else if (USER_CLK_RATIO == 1 && CTRL_BL == 4)
   begin
      always_comb
      begin
         if (do_read)
            afi_addr <= read_addr;
         else 
            afi_addr <= write_addr;

         afi_wps_n <= ~do_write;
         afi_rps_n <= ~do_read;
      end
   end
   else if (USER_CLK_RATIO == 2 && CTRL_BL == 4)
   begin
      always_comb
      begin
         afi_addr_h <= read_addr;
         afi_rdata_en_full_l <= afi_rdata_en_full_delay_reg;

         if (do_read)
         begin
            afi_wps_n_h <= 1'b1;
            afi_rps_n_h <= 1'b0;
            afi_rdata_en_full_h <= 1'b1;
         end
         else
         begin
            afi_wps_n_h <= 1'b1;
            afi_rps_n_h <= 1'b1;
            afi_rdata_en_full_h <= 1'b0;
         end
         
         afi_addr_l <= write_addr;

         if (do_write)
         begin
            afi_wps_n_l <= 1'b0;
            afi_rps_n_l <= 1'b1;
         end
         else
         begin
            afi_wps_n_l <= 1'b1;
            afi_rps_n_l <= 1'b1;
         end
      end
   end
   endgenerate

endmodule
